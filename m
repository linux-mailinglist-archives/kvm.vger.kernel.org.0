Return-Path: <kvm+bounces-2885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FABF7FECE7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 11:35:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C512B21137
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7963B7B2;
	Thu, 30 Nov 2023 10:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H434yxt+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5381703
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 02:35:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5XNulks3L2Wb+zB3l6j9t5dN+mMZW+Smm2gVJcnjDt7l5FePdRcipsPfAO+YM0t633eHVPb++h+ifMVklAdMfNbk1SqE3xDp7jV6eKkBsqtJhRBM7zwUy8c0bVESC4b3+adQwSFUGI8FhJWGNLBClrf3fnITrlNMohNKF4mbE0blfVnHK/zd7dmUIbVfcB2u/+0XJxNJjtAO0x89QeylPThuzwZprpXix7xuNQJKAbqLeA0Y+61pcDpNjJsET3weki5TUYXqMmrPIjFmjqtkYAj22LQntijCsew7Ix2EfJxE2WLuyjuRq+syr7BxThcOeiUVxTZ05iSwuy1MAqcZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DUPxF2LKB6in+WIqUyrYbxCRlnJZLppUIn05THCmb4=;
 b=GyS4ZZ3iWOF5JLQHKIQxOw4wAhuQfHjVGEsWdwWuFOLMUopnb44J1bs9eAKdI9X1KiEZ2cc2JVRN4BgrnDDFASMaTbnNC4FK9n8IylVCgnFOmtrfwpzBtl6JQXQjRBbK4tBBBilLV1TYLqe81fOSV7Qy/dKfpuWCmsbfnOnLt555pOsefJMQDnB32siXtaXI51Fi53AKKXjVUYsDe9oe3ndWpy6zrqLCnUVsoEpZxctsXXJO8h/nLN9GZdYfawGP5xn5DQo6Ciyh3hMabVcLumUY8kL2YcRiY/L/4TYA4vAtlV/3vZBWeumHE5eH0CIgXj/8F/6g9yxe7k1e+dnS6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DUPxF2LKB6in+WIqUyrYbxCRlnJZLppUIn05THCmb4=;
 b=H434yxt+xoL5MHmDOTNa4ekUIFxFSWLDFMg/R8dcXFVV6dUVLKlWELt/5efVKqiaNIBX4/BhrpY1pIy0fxHNI2/RFbNsAYCxDau+Yr16Yi5429M3Buz4Pq8rKucZ2z/q0/2OyHWHMYmk97jGAfUjKZQ9QjBV7QKM2aBNDydHRig0cq0MQ1kg4HCGVHnmt/UCsqUDk/9Aa1zis5A4SMgx9NBvinTLg0oIRj7gw/Gu8MSiyrNESDBky5wUKWwc5m636J4npI3R4JxBpaWQT6Vgkggczdy4/YveRrO9e4T5IR5jqpT2VD0c1IZa9IOFM3rh2g9AZVygxeOs2VrMauzJrw==
Received: from MW4PR03CA0299.namprd03.prod.outlook.com (2603:10b6:303:b5::34)
 by CY8PR12MB7682.namprd12.prod.outlook.com (2603:10b6:930:85::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Thu, 30 Nov
 2023 10:35:28 +0000
Received: from MWH0EPF000989EA.namprd02.prod.outlook.com
 (2603:10b6:303:b5:cafe::2b) by MW4PR03CA0299.outlook.office365.com
 (2603:10b6:303:b5::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Thu, 30 Nov 2023 10:35:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000989EA.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Thu, 30 Nov 2023 10:35:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 30 Nov
 2023 02:35:14 -0800
Received: from [172.27.21.28] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 30 Nov
 2023 02:35:09 -0800
Message-ID: <aaa83d6a-779d-44cb-a72e-83ba9c8db76b@nvidia.com>
Date: Thu, 30 Nov 2023 12:35:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 vfio 4/9] virtio-pci: Introduce admin commands
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <alex.williamson@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
 <20231129143746.6153-5-yishaih@nvidia.com>
 <20231130044910-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231130044910-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EA:EE_|CY8PR12MB7682:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f9b685b-98e0-43d7-d3e6-08dbf19011c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	60VQ0ShIifOflwFR2A+Bt+d0X4QFANF6xupIyVKNyHtHu0qwHibQ2q6AUVhwjie4Kxa4y2vfaE6CYZwVYdMn2KuL/VMyn0bwazBsMHuJC5huEFjCz7NE9YqdBvED0s7d1fLRilPgomwId6qltiLq0Vnaf1u7p9YTQbjzwCt3lqWhURjlMPUTpmbcOp35H8eIiLzjaLj1Uo6vO2jr/pSSIrOm0yGnYGFE1fwwOUzoODEXlQGGVUiCpUyuKKPqwcJuL/f+gdPMj8eTU8Z88+3zrfskRZ7J6vtXMB5+1hf5zxZAaEjAXX28yVMYv5yB/Obx2ADuGHdylQJ/jCnT46DUtlRQa8zbykyutBn/6CpSOHH9tsbg7Fqc5nJtbk/HDynOpvPmsEDmhkZvTV8/Qqnaer50nZUD2AXAuXx1yyw7F3gFJctC5bqkRvcVGmLX5XP8bCtiLZPiBAi+DhJwzRU27j09rmeqRY6JqGYI0PDBSc2rp0+BhPnxT6Qk6vAE5cQmtY+hE5Rgh1QoNKRbYkr3c5/rWcq7qo6B8KrYNquS9gh2uUxVtfqD89pSaeq6lNOSw2k7pBDjsSKOkr2UYzrHHNdGW7Lc/dYm4RkiELBcRNGIr40bDWMcJWEuwdNRVz00qcj49I3nnmJUaFlSzzDUpnZz01s9HjMvTLKKVv7yBgxI6iiF7zYwJ7XsvXnmg5RWiWrYXBC/Eg2uU13dyBxIEWll5SPdVyprJvCf84ibvmTzLvsAK0wRojCJXr7whMSFy02eo5PtUMXiu1Ynf/WIkJ9Swq47kbLt2KxaJDCsE0akKPZNc7W0E/3RvIW9pkLc
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(136003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(82310400011)(36840700001)(40470700004)(46966006)(40460700003)(16526019)(26005)(336012)(83380400001)(426003)(107886003)(53546011)(2616005)(36860700001)(47076005)(5660300002)(4326008)(8676002)(8936002)(41300700001)(4744005)(2906002)(478600001)(316002)(16576012)(6916009)(54906003)(70206006)(70586007)(202311291699003)(31696002)(86362001)(36756003)(7636003)(82740400003)(356005)(40480700001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2023 10:35:27.7881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9b685b-98e0-43d7-d3e6-08dbf19011c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7682

On 30/11/2023 11:52, Michael S. Tsirkin wrote:
> On Wed, Nov 29, 2023 at 04:37:41PM +0200, Yishai Hadas wrote:
>> +/* Transitional device admin command. */
>> +#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE	0x2
>> +#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ		0x3
>> +#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE		0x4
>> +#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
>> +#define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
>> +
>> +/* Increment MAX_OPCODE to next value when new opcode is added */
>> +#define VIRTIO_ADMIN_MAX_CMD_OPCODE			0x6
> 
> Does anything need VIRTIO_ADMIN_MAX_CMD_OPCODE? Not in this
> patchset...
> 

Right, once you suggested to move to 'u64 supported_cmds' it's not any 
more in use.

It still can be used in the future, however I can drop it if it's worth 
a V5 sending.

Yishai

