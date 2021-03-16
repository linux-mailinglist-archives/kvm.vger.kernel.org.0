Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF02233D462
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 13:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhCPMyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 08:54:46 -0400
Received: from mail-dm6nam10on2061.outbound.protection.outlook.com ([40.107.93.61]:37473
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234335AbhCPMyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 08:54:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S64fXo8ubIAdu/uTR/RzH3fN/dlz6P1W8/AYnWb4fr15LxprOz89ZbTd1Y7Z67zP/A/xWNkH6GHdrEnIQIzwYfU4z85kjeO0qACWnBl5zFtp5fHzSErH11zHHYKQ5wAT0i6uiMu8f/WXvVWiDlgL8TUBPZI0aWIji3I0Qzemd2raazlUPuKy2weHVmhrGZ2yMaHnMIzJ3lTqj0l+PgSjVugrj0W+wgnloHglNM4tKVZOpWxK/x0RDl7/MzL0Cojaak+ngO6s2QWxvXPY4JjjnV75XTQ8VABQ7e3ZpvULqvSM32xwfDXDWpftwjOoXsEIu20k/EhiRpK90Zid4vVj8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnhsQHVZcupkrLBWyLBOY9lunCf2EmxhvqrYCQYrnKU=;
 b=QcEcWcA5/MclR6PedgIo4Gscx2WsLWvAtMOAee2KXVdOqsSwIt+wRCQR/JA+q/nCFdKRLN8NI00EDyjXYaPPRsZs2yVMJQh/vWrL6rKm5BvXCwdXydqImC0UuTLTOdFELTjPrDaTr0lXNkqelcH9Wi/32Qm8wp+1BwsjmM4jWzTlSrIbKmDwQd0FDj/tBY9JpIol4D31mA2pviYjyBv8j6eYAVGkvIgQ2VyGLzEfA7VJjUwSPIOVA9GV0TSCtFgQ1u1sxfVEnfY+cDQN+JQefoZ1xxQVHsJIVWKzdKY1zRMcZ33Sv10tFKxqODxb3i1l2IuOd5mcNXeHdVJeFRKFUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnhsQHVZcupkrLBWyLBOY9lunCf2EmxhvqrYCQYrnKU=;
 b=cjney7y8lhU31sAwaVbnnT1sUUfKLbLvcmdvTJCJJXa2bT2rW4aKKowyzbnbvPIeZO4PC+XojJQJL6tM+MLBOawUmC4kFuexLBEORKZ+xjKyJhgGH+nRKFrwaXPD4xFGIlKeykpdSGQeu5N61hbwJ/2YZEkOaXXtU62KRrQ9YIO0OSyU2v+RUwMp7IFEm2zIZzAakTq5RU80GvOUGkEYtRiZu2ebn30ajWJBhFwcK016nTxuazLZ9Y79AdJ83CEITQShESD/qFM0mpZv0dOEMXu9PpRgqDf0wYl8Vj7TWaqPkKg1+VKK/JDYpZQeO4g/YOEJBZ5ZrrddC/QhA8J77Q==
Received: from CO2PR04CA0094.namprd04.prod.outlook.com (2603:10b6:104:6::20)
 by CH2PR12MB3991.namprd12.prod.outlook.com (2603:10b6:610:2f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 12:54:07 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:6:cafe::75) by CO2PR04CA0094.outlook.office365.com
 (2603:10b6:104:6::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Tue, 16 Mar 2021 12:54:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 12:54:06 +0000
Received: from [172.27.13.197] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 12:54:02 +0000
Subject: Re: [PATCH v2 03/14] vfio: Split creation of a vfio_device into init
 and register ops
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
References: <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <d2d2012d-ba49-9354-e6f9-6e6ecc19ff37@nvidia.com>
Date:   Tue, 16 Mar 2021 14:54:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5893cdc-1a81-4b21-db03-08d8e87a95da
X-MS-TrafficTypeDiagnostic: CH2PR12MB3991:
X-Microsoft-Antispam-PRVS: <CH2PR12MB39915735D09E284FDE135E3DDE6B9@CH2PR12MB3991.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t6z4gACYHRjoKzIgfh14YNTsVPhOGFqhBIT4mGKYsSdXL9e/IREahLIn1V1+oTLZJyjyJ0RLMvBzti6KGchb/ZEW18GpmDQE1AMmkM7eB0f5RrOBTel+GXwYijcF2mLjvk1pv0voCbH4bbivBCgGx0WT9WjcaxjMSwDfucRhTOk7hA3mCwrvOaaPKZggxurZEzOeZTO1RP79rvymIBCp52CtG/kHbh9i3AEV7+CXw9Ylm51xgwzdI1jxMbo1RIO1Qkc1YYzR0enJy+u0OTjrHH7Rp8eQDSx26+O5hzzFZBX39fnUkhtdsnqalfmJzNOGf9ULCz8fF8BNDEHmhsTL2FOi09RbDnkWe/oHBBSHvU3wSy158PBJF7W0OlqqJZ20RCJ1hj33UUFdp6GqkwjM32LE+q6T20bjpW7re9FFKhwxIPiPzX1tb10pretiXzwoVefVgwYYhr9eZcfrcCq+HcA1P3wA43fOaVPGXs3c4Wr+63XMz+9+5h23yIRjb6dyMB/RM1zu2GVlbXSDD+Db3gLYy8w1YSlVBGi/MqwMEmQB1XHBve2cFOcMjUid9j+TG7x83NMXYDigaPzQWZgpDjs73qo31fevtqqfzO9SEQ718SIqaZ9Zxms4FBosvTxIZfWQMhxMhmjrOoL/6NKnXOO4emFDtlrxmVW69Xz2M3W3KvrqOsGCTFdcCQOaI7zXD3g5Er2ItNtx9cZxuwK07ewysU/n80XRCz6TY1vhpuM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(36840700001)(46966006)(31686004)(4326008)(86362001)(478600001)(47076005)(70586007)(83380400001)(7636003)(356005)(7416002)(82740400003)(82310400003)(34020700004)(5660300002)(36756003)(336012)(36860700001)(26005)(186003)(426003)(8676002)(2616005)(36906005)(110136005)(16576012)(2906002)(53546011)(316002)(31696002)(54906003)(8936002)(16526019)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 12:54:06.9668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5893cdc-1a81-4b21-db03-08d8e87a95da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3991
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/13/2021 2:55 AM, Jason Gunthorpe wrote:
> This makes the struct vfio_pci_device part of the public interface so it
> can be used with container_of and so forth, as is typical for a Linux
> subystem.
>
> This is the first step to bring some type-safety to the vfio interface by
> allowing the replacement of 'void *' and 'struct device *' inputs with a
> simple and clear 'struct vfio_pci_device *'
>
> For now the self-allocating vfio_add_group_dev() interface is kept so each
> user can be updated as a separate patch.
>
> The expected usage pattern is
>
>    driver core probe() function:
>       my_device = kzalloc(sizeof(*mydevice));
>       vfio_init_group_dev(&my_device->vdev, dev, ops, mydevice);
>       /* other driver specific prep */
>       vfio_register_group_dev(&my_device->vdev);
>       dev_set_drvdata(my_device);
>
>    driver core remove() function:
>       my_device = dev_get_drvdata(dev);
>       vfio_unregister_group_dev(&my_device->vdev);
>       /* other driver specific tear down */
>       kfree(my_device);
>
> Allowing the driver to be able to use the drvdata and vifo_device to go
> to/from its own data.
>
> The pattern also makes it clear that vfio_register_group_dev() must be
> last in the sequence, as once it is called the core code can immediately
> start calling ops. The init/register gap is provided to allow for the
> driver to do setup before ops can be called and thus avoid races.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   Documentation/driver-api/vfio.rst |  31 ++++----
>   drivers/vfio/vfio.c               | 123 ++++++++++++++++--------------
>   include/linux/vfio.h              |  16 ++++
>   3 files changed, 98 insertions(+), 72 deletions(-)

With comments from Cornelia and Kevin, looks good.

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>


