// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChatDapp {
    address public owner;
    
    struct Message {
        address sender;
        address recipient;
        uint256 timestamp;
        string content;
    }
    
    mapping(address => Message[]) private sentMessages;
    mapping(address => Message[]) private receivedMessages;

    event MessageSent(
        address indexed sender,
        address indexed recipient,
        uint256 timestamp,
        string content
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }

    function sendMessage(address recipient, string memory message) public {
        require(recipient != address(0), "Invalid recipient address");
        require(bytes(message).length > 0, "Message content is empty");

        Message memory newMessage = Message(msg.sender, recipient, block.timestamp, message);
        sentMessages[msg.sender].push(newMessage);
        receivedMessages[recipient].push(newMessage);

        emit MessageSent(msg.sender, recipient, block.timestamp, message);
    }

    function getSentMessages() public view returns (Message[] memory) {
        return sentMessages[msg.sender];
    }

    function getReceivedMessages() public view returns (Message[] memory) {
        return receivedMessages[msg.sender];
    }

    function changeOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        owner = newOwner;
    }
}
