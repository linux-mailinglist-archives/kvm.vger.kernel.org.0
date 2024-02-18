Return-Path: <kvm+bounces-8988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 511D38596CA
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 12:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7687FB20B4F
	for <lists+kvm@lfdr.de>; Sun, 18 Feb 2024 11:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91836634E5;
	Sun, 18 Feb 2024 11:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QdqDK//K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06791B811;
	Sun, 18 Feb 2024 11:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708257480; cv=fail; b=YJR4xirkttjz4IO3q3my4OuDVvzjE05vU0j6GjEestrvOawCHpGq/YaZobTtqUORpXw8HiarS2LTASulBQvqjQPrE6VMICAVHDvnsZwq42EVSGEPR9e5eHJgrvR5HrD6is0rRB8ff9GDR8NL4qa+ICRaxSIrDf16ZUvP0Z6SVcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708257480; c=relaxed/simple;
	bh=59CAn5wXmap+szpOqOXeFHeEbKuafsT2IE2jSwR4QiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bkw9UMZD45vuSNSUI2XBgSfxIwOgtHSelBZcMuB6uIetoWMr5KOHfWoRd+eaFtPy1JIQbxfsY7IKMj3wpvsgFKHayxXLdeOPff+9drZkw4qL+G7sSz4HPACPtN9W4iPmkYTMEI0a8aIZPdckIb6tDfWrNlDg9e6ydmRCMLUsFco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QdqDK//K; arc=fail smtp.client-ip=40.107.237.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luoRPBY+KdYkVvz1P4s0kCOyAGZKKTsz1axcVHqiBurI7dfP5fbxQuHkztWM5gp+82vb8mkMI0M8cT7jS+Ii2M263jTVz4h0ZxvM4eGMyuFw56LCGkqRIexECWFf7QLnAEV8oDQnfZC9nE0Gvfxh2ZLoIavgoXDj913L6NuTx4URSYgLUUBiZIXdFzAHcmBwXGQR7NabsiXAg9aSwosZH4MskA8FVUUtt7QkyTh1Lgwi5DMsC3Cg8MRt+d8CTnNgqbKjvlZG0sU7bQRsUUehhCqge7tJRH05WjbAj9FaWEIz8z89NTx6wV1UOK5TZsyiibbfO6I+wUPZi/nseikuCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhdozrAwlDh4/q0rWb8RZFMxx2ywrrLJev0rhxbmng4=;
 b=A7FNvkVm/Fjrwn8BivQweyg/JDFt3Cb/3BPaozPkQIuGLpXAhosPdniBWhsPxkCHM2GjK5ipFSTCYJRVtRcaEWsUr4OsbdyQbLwuLCGHNc5LU8A7HfuobP+DQ6qxwuDR5KmcNODV5dMI8E88Pwo6a4ynJwt97o9BHrI+DF7gpLTCjwA834jMMLW1bVYWpbxhswLnrTpgUD/eJGh28Iqe5mVutqJ/v6Zg1/3DYP5yIeee1fsEoMPWzYNhbKt3aOdMTBhl/F+AjMoar6Pu9I/JrLrbVqo5c8bjrZhNE4V16oYFuQL/Ax9OaObkwtKzquRUf39dMTpPJ7ios8gxrNVVvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhdozrAwlDh4/q0rWb8RZFMxx2ywrrLJev0rhxbmng4=;
 b=QdqDK//KUOt6y07G93Mzxgzvdc6L9YKarv4p6T1NU5H5ZM14F4KmLzITnYWILdNdLmHz6BHU3YlocOv1zM21MjsKzqV1WroDgTfNAFlDHmDrddfPiaK8glSL38ShH5hkQGj4MHfD1lMi+zwVTVczkwhceSI3fuaxS/ucvrq4yXjn3mJ38+sFojZYB8pqzFgOvzfHKqFxxd4BDouolyeQcFQ3kymNiUMUIKkez1uw40zbwXspAoj6hb3BFt5HItBfSB+c72djuBgeQ7QmHoRJgT++kdDNuYABjv06EvCfELL/xZJhLRxb2o1i5yVjCxMiRue8FoFyEyhYZn3Gf50aVw==
Received: from SN1PR12CA0087.namprd12.prod.outlook.com (2603:10b6:802:21::22)
 by SN7PR12MB8027.namprd12.prod.outlook.com (2603:10b6:806:32a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.17; Sun, 18 Feb
 2024 11:57:54 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:802:21:cafe::bc) by SN1PR12CA0087.outlook.office365.com
 (2603:10b6:802:21::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.34 via Frontend
 Transport; Sun, 18 Feb 2024 11:57:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Sun, 18 Feb 2024 11:57:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 18 Feb
 2024 03:57:41 -0800
Received: from [172.27.34.193] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Sun, 18 Feb
 2024 03:57:34 -0800
Message-ID: <c7690b8a-78db-46ba-91fe-a2186eaae8aa@nvidia.com>
Date: Sun, 18 Feb 2024 13:57:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 1/3] vfio/pci: rename and export do_io_rw()
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<mst@redhat.com>, <eric.auger@redhat.com>, <jgg@ziepe.ca>,
	<oleksandr@natalenko.name>, <clg@redhat.com>,
	<satyanarayana.k.v.p@intel.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
	<shannon.nelson@amd.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
References: <20240216030128.29154-1-ankita@nvidia.com>
 <20240216030128.29154-2-ankita@nvidia.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20240216030128.29154-2-ankita@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|SN7PR12MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: 3495ce6d-4cde-44bc-720b-08dc3078d778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nSuzu0FGcyOAWCVNjFLow/XBGauybMric9WWm6TLh3FVHHhwqzKVoOD8Er91OEGXtmKOEgwxdalVlJaI8fmSq9or4UhGOrkiahFamOaEy0oKVoXkpbA5LKg16LJ8mpMibc1w2XADJAHGjBTYKxVP9nWPu1ldqXxejkK9b9TjYG2M4deVZeyMo90Z0FePtl42+A7696g/8+g5yhJ9Zu6Xa/kD/GFtBQweZ09i0nOoFjekjUSF2zWMSxP+AktPt9ONaf8w7XD76yuJ671mz9EaWDvk2Rir4oBnW4D7uHLDZOhd/032mxUu+ZFTFyhD1tfadvhcktWTchw9RAW3c8SYEpLmm+EIFPvlloJFBSrR/ntpX7SpHQwuh5d5QYb2bS5bN04MGB50bvtZlqVB5U2AcogUO5G1QZRgJe+egb79by8LkbAMySRfn4JcwR5sSHIOWJTxXd6pLQ2cmYa9DxSYOfub6bUF+QX0UFIRlHsrlwSXId3o90ZSHLN0wPSl8KZboCg52RTU0AjXcNjxBFgkPcF1x4n6HAKutFv6BZf/AuvQ6TdAsNIcFouv67zc3kCNBGx17JQq7EQbKcMQ4Epu/CqlSUI+EnS6qWAHPAz4hKXTDSCjlQPZKJvn6HIA7ZLTRX++nYLtB9VbunTqBzE/Z/JtNw5OdxnxA1gEeU8bRo4=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(136003)(376002)(230922051799003)(186009)(64100799003)(36860700004)(82310400011)(451199024)(1800799012)(46966006)(40470700004)(5660300002)(70206006)(70586007)(8936002)(8676002)(31686004)(4326008)(7416002)(2906002)(86362001)(31696002)(7636003)(36756003)(356005)(82740400003)(921011)(110136005)(54906003)(26005)(16526019)(336012)(426003)(83380400001)(2616005)(41300700001)(53546011)(16576012)(478600001)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2024 11:57:54.7565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3495ce6d-4cde-44bc-720b-08dc3078d778
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8027

On 16/02/2024 5:01, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> do_io_rw() is used to read/write to the device MMIO. The grace hopper
> VFIO PCI variant driver require this functionality to read/write to
> its memory.
> 
> Rename this as vfio_pci_core functions and export as GPL.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>   drivers/vfio/pci/vfio_pci_rdwr.c | 16 +++++++++-------
>   include/linux/vfio_pci_core.h    |  5 ++++-
>   2 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 07fea08ea8a2..03b8f7ada1ac 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -96,10 +96,10 @@ VFIO_IOREAD(32)
>    * reads with -1.  This is intended for handling MSI-X vector tables and
>    * leftover space for ROM BARs.
>    */
> -static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
> -			void __iomem *io, char __user *buf,
> -			loff_t off, size_t count, size_t x_start,
> -			size_t x_end, bool iswrite)
> +ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
> +			       void __iomem *io, char __user *buf,
> +			       loff_t off, size_t count, size_t x_start,
> +			       size_t x_end, bool iswrite)
>   {
>   	ssize_t done = 0;
>   	int ret;
> @@ -201,6 +201,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   
>   	return done;
>   }
> +EXPORT_SYMBOL_GPL(vfio_pci_core_do_io_rw);
>   
>   int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
>   {
> @@ -279,8 +280,8 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>   		x_end = vdev->msix_offset + vdev->msix_size;
>   	}
>   
> -	done = do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
> -			count, x_start, x_end, iswrite);
> +	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
> +				      count, x_start, x_end, iswrite);
>   
>   	if (done >= 0)
>   		*ppos += done;
> @@ -348,7 +349,8 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>   	 * probing, so we don't currently worry about access in relation
>   	 * to the memory enable bit in the command register.
>   	 */
> -	done = do_io_rw(vdev, false, iomem, buf, off, count, 0, 0, iswrite);
> +	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
> +				      0, 0, iswrite);
>   
>   	vga_put(vdev->pdev, rsrc);
>   
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 85e84b92751b..cf9480a31f3e 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -130,7 +130,10 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
>   int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
>   pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
>   						pci_channel_state_t state);
> -
> +ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
> +			       void __iomem *io, char __user *buf,
> +			       loff_t off, size_t count, size_t x_start,
> +			       size_t x_end, bool iswrite);
>   #define VFIO_IOWRITE_DECLATION(size) \
>   int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
>   			bool test_mem, u##size val, void __iomem *io);

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>

