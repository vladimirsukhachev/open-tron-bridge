pragma solidity ^0.8.0;

interface ITRC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TronBridge {
    address public admin;
    ITRC20 public usdtToken;

    event Deposit(address indexed sender, uint256 amount, uint256 indexed chainId, string recipient);
    event Withdraw(address indexed recipient, uint256 amount);

    constructor(address _usdtToken) {
        admin = msg.sender;
        usdtToken = ITRC20(_usdtToken);
    }

    function deposit(uint256 _amount, uint256 _chainId, string calldata _recipient) external {
        require(usdtToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        emit Deposit(msg.sender, _amount, _chainId, _recipient);
    }

    function withdraw(address _recipient, uint256 _amount) external {
        require(msg.sender == admin, "Only admin can withdraw");
        require(usdtToken.transfer(_recipient, _amount), "Transfer failed");
        emit Withdraw(_recipient, _amount);
    }
}
