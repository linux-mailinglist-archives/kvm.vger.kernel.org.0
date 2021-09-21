Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B9841390D
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhIURsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:48:43 -0400
Received: from mail-dm6nam12on2058.outbound.protection.outlook.com ([40.107.243.58]:16961
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230425AbhIURsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 13:48:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+NH4Ht+68SUnru7mCM1nQ73Ub45LvBaHDZAXIbQyCmY4FxZKiuYOL5C+u7QsGs2EVMtm+hFTZJP428Vn/H6a6JWzyHwGspZXcq29eQUAzlGmEq7d0jAizv2IeY7chjN+ihuof4Q1oWZcTThLX6LEXO1+4XW5SjOiXCSk8r3+ObJUuJA6ATAMvW7+wxv6cvlwn9DGOgS8wNQVVNb5ZIUN16ILw+KFYKWU/383ZNlCD2qiUSe9dSDIENV2532vtr6j6UqSpJD7UuPV24/Hh19HA9h4jBor0qYsFoPT2O1gbMY4J3bckHf6lrRiua9uWrod7rXuQ7kyOO4A3QyjaAaqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ys1iV4OM/wJrKYFG3vi/hBBPwVqeZz+k6lrAwQJH15A=;
 b=cBqE0P76t6nOCjbXbSbQLDPjkFXmuFfN6Exm7CDEFQSMEQXac3QcA5K71K16OzyjhrJRbYeKO+NQQKLGGJgz/Kw+YQ7zs6Wv+UVB9xqAdgpY87NtMCSMCg409Q0mcFb4VzeYTMWnvMLTyZu1uFygM3ueW1+qQ+8/VWV25pA9iRH7QNie3RVc9/wTnhKGhYNndKgPgd1zokN0sJGMpJuBI5wXv4KMbnqES+8Zog2j+CjRAQGd2LQ+wZpIlXjP+bpvKxg00xUNsQY6nRWd5BXqismPtkWYtLZDoJFWVdKZt8NERNMKJu73h0mN4T42jjZTKq5jSXQPS2kNss4BQreq4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ys1iV4OM/wJrKYFG3vi/hBBPwVqeZz+k6lrAwQJH15A=;
 b=Nqy+MVpFuWdtdzdM/vaY969HH6gfWPOG0PvcP3ZGNdEwN/pXVFx1MtFvcAXwY7KRt9hzpljUEcwfbEXDpq8mWI5UGZrEdDyY1CuntQrWWOP+NeV8SKNO5FrJhj+CG+I7ZFRcGVz8GxpZi9CD9qZL+zXegvE/IwJDvI3NTVmukvMb8wfzO8/3Xxr9pbpo9aCqn8vLvVsd0+U1AovR3UoBo0jARk/9RvOx/cbuNT2kh0czD/YF0CmubqE7a/U3PZlNeed+5hDR+gCXUXPS968cprlnYgqR4wYGXuYip/jIpz56X88qmXbhL8lcx0jXW86hg+zwO8U2/q2pwed/fJ45zQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5095.namprd12.prod.outlook.com (2603:10b6:208:31b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Tue, 21 Sep
 2021 17:47:12 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 17:47:12 +0000
Date:   Tue, 21 Sep 2021 14:47:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 12/20] iommu/iommufd: Add IOMMU_CHECK_EXTENSION
Message-ID: <20210921174711.GX327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-13-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-13-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:c0::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR05CA0019.namprd05.prod.outlook.com (2603:10b6:208:c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Tue, 21 Sep 2021 17:47:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSjrL-003X5d-5Z; Tue, 21 Sep 2021 14:47:11 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0db7b8fe-9bc8-4b10-bec5-08d97d27d77a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50958D1FA9A7BF4903D80499C2A19@BL1PR12MB5095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YpSDNUttmq01rOb4r5FrfzZls6TXUdAQTnXvsntyfZqtmH6DyWiWaIF3rdSXeTCfxjroPRpppy6dxnhwWr91zl+1XkJZgYvuOsdoy0Z+YjtD63hqUpsqhVzwkE4u7u6guyr3gl83gvSG7+tcxnQk+7DPtehQxmMM6okJiO39q8tyaYE0G/mlXLt6RtWxbIILW5EmkUH5vFYoKsttLWIDvWlKtAlmp/bg5fuyIOVrghXuh86KGlVnN1UMYNPAO/O0M2ctpUKc/RSKr5n38UxMOdA0YhuGOyMsvCqEHcXg7/B34Q8OyHmYGYqUUpx25t1+VqvM5rqtpvCGzlW5t+F6Ekrrjsdirkyl91EVeOMeMwXqrrAkXGSpygwHwf+tHKSl8k+L4auh6IT5HkzFITpxPTGCs/LSiFVhh4OUpzi2GtMS/K/TKywtPbBL+tZWNNZnxG+xKNXDUHqeK5FVWByawlPTR2BR1YCfA/0kj9GSa8mOVb8eTAAnEjmZLzVHSevaLb81/bsCze2MjkPiyGCFflxVUOLbvcJ4srFKov7bKtSpfFBpdpTfMgQIm10lr83RRU9kgn6JWlU2UlzB+1wLc+PyKIZKXCIEB5G96Gy9Awb4vp8jiGgBJ65IRuhy8ERwGggQKyiT0uOeIjPpE0SDqnKxSGuWS1J5BaYmlgOS4egfwLMupvY+yrau5ZM43MiT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(8936002)(5660300002)(4326008)(8676002)(86362001)(508600001)(2616005)(66946007)(6916009)(36756003)(7416002)(107886003)(26005)(9746002)(426003)(186003)(316002)(33656002)(9786002)(2906002)(66556008)(38100700002)(66476007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6oPeaQgahbCt1PFL5ntXFfk0g4LJ2arCMOAn06g7whzJuzfXK6tQWyUZdnRP?=
 =?us-ascii?Q?JDFM13xgc71yW2mC+6o+MgKshHa+OM8gE3HdhNpyUuTisTX71WAS856W+ruc?=
 =?us-ascii?Q?mkL56GSpeeRhNOuFP7PWGv+TunTdIQ/9hLRVOqps2pr0vzZ64SQCsuC+ZHAL?=
 =?us-ascii?Q?9n0V6Dv5ZO3g5cKRtTrC59gLFJg4yykb0xfo6Tfx7Ahc6fQ9uNMemuSFGEpc?=
 =?us-ascii?Q?8OCq3UGPsfGGTHEC8KsJ3yH3+mEHEBh1jKdhk/i9wjz0NT7J6uF7KaBezWFx?=
 =?us-ascii?Q?RUxnekQujDDC1W6APwjJew9AdsfSJNtNXEkD3mJAu9lqR3XqzM0SLc15Ql6H?=
 =?us-ascii?Q?UUcRJtDU9dgQ4WEYBdg1RbJfWfKdU14+Na5LXE5AINF8aYvoAzY6qZdP5aoB?=
 =?us-ascii?Q?4EUCHWCDUc6gbecEZnKFG1RK5tya90W2RWYYZFo8TS8pcItPZ2iwbLIvxUFg?=
 =?us-ascii?Q?vLmgQyq7kf7YR///29Uqyexa/j8gKgtoC2cgbYwXOvNefONM/V7IGq2UVR5f?=
 =?us-ascii?Q?B668E8uWy2madE/5RMxmHcu+H5XzSs0oMUyI06xAwSMp/KXI59PzrD2OU+q9?=
 =?us-ascii?Q?dzHcz1snHotVrHcXTvHRyg1kSEpaEWjA+Qg1FDQbSRVaEfMssBvmCuFrDxDw?=
 =?us-ascii?Q?rRRANtYKA3G8yy1TbAOmWyYGlE5rkqbv9LuvbkDmfmHOiTm7JYwzDUG2iX2p?=
 =?us-ascii?Q?AJ0TOxOhBTB0QcdZq7d2LGXnT035N33TgJeG6baCwtWVPJVPfdw3lja0yUd8?=
 =?us-ascii?Q?G8C9JsXprAHcpIMtqGieuA6LOv01I+ZVvbegP4xnGs/zzAtm/bz6cos7nmWt?=
 =?us-ascii?Q?5kgg3d+ZqMHu00PsNk+5KeRHcARCAkpasoZJ2FLwqf9ZMpopF3DOSu83DaPa?=
 =?us-ascii?Q?qDDUpdocOdKBNaI/Whdh+hUHNzOWorp+AhSj5TKRScL3qB31K84TAkXljXX+?=
 =?us-ascii?Q?b6Nwcvlb7INCUbyLBp3+izqLWaEqNK4EnobQlgpV9jDC0pL6B2XCCmpb26TY?=
 =?us-ascii?Q?LhBl9oaYBV2uAfNKqzgK/tmKjCb6FjaZspqq4rBFodb0NGGRcT9++xg+Ztod?=
 =?us-ascii?Q?RVgNgFETQjyKWSCsg9oe1OTBac6R/YIqJzrBKGHqWzchGHpdAH40LX/fVNcP?=
 =?us-ascii?Q?hfrjmQXpuVZ7wcceodaHYtf+YR/TyJ1J44h6Jg9OFq85OOuhscCZLDGyC9wg?=
 =?us-ascii?Q?W9lVaXXc8LhzcGXgYKdz7X2kXxcHw8tb/Iifzj7ULd0Szo0DutDw24tXXSeI?=
 =?us-ascii?Q?D9Tm9Euygzt5ca+pkX512eUTbTkLNSNfhCCKiofdlZQGXTupS2wnVUBL/riD?=
 =?us-ascii?Q?2FPpZOcJQH0VAjoPsgkHVuH5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db7b8fe-9bc8-4b10-bec5-08d97d27d77a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 17:47:12.3849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZ8bAsy/JVZmpoc0bq9ZWu7nFXmTkUJ/rGKbJb+WnFCoJTpVO/PToXeJm3UiF5x6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:40PM +0800, Liu Yi L wrote:
> As aforementioned, userspace should check extension for what formats
> can be specified when allocating an IOASID. This patch adds such
> interface for userspace. In this RFC, iommufd reports EXT_MAP_TYPE1V2
> support and no no-snoop support yet.
> 
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>  drivers/iommu/iommufd/iommufd.c |  7 +++++++
>  include/uapi/linux/iommu.h      | 27 +++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/iommufd.c b/drivers/iommu/iommufd/iommufd.c
> index 4839f128b24a..e45d76359e34 100644
> +++ b/drivers/iommu/iommufd/iommufd.c
> @@ -306,6 +306,13 @@ static long iommufd_fops_unl_ioctl(struct file *filep,
>  		return ret;
>  
>  	switch (cmd) {
> +	case IOMMU_CHECK_EXTENSION:
> +		switch (arg) {
> +		case EXT_MAP_TYPE1V2:
> +			return 1;
> +		default:
> +			return 0;
> +		}
>  	case IOMMU_DEVICE_GET_INFO:
>  		ret = iommufd_get_device_info(ictx, arg);
>  		break;
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index 5cbd300eb0ee..49731be71213 100644
> +++ b/include/uapi/linux/iommu.h
> @@ -14,6 +14,33 @@
>  #define IOMMU_TYPE	(';')
>  #define IOMMU_BASE	100
>  
> +/*
> + * IOMMU_CHECK_EXTENSION - _IO(IOMMU_TYPE, IOMMU_BASE + 0)
> + *
> + * Check whether an uAPI extension is supported.
> + *
> + * It's unlikely that all planned capabilities in IOMMU fd will be ready
> + * in one breath. User should check which uAPI extension is supported
> + * according to its intended usage.
> + *
> + * A rough list of possible extensions may include:
> + *
> + *	- EXT_MAP_TYPE1V2 for vfio type1v2 map semantics;
> + *	- EXT_DMA_NO_SNOOP for no-snoop DMA support;
> + *	- EXT_MAP_NEWTYPE for an enhanced map semantics;
> + *	- EXT_MULTIDEV_GROUP for 1:N iommu group;
> + *	- EXT_IOASID_NESTING for what the name stands;
> + *	- EXT_USER_PAGE_TABLE for user managed page table;
> + *	- EXT_USER_PASID_TABLE for user managed PASID table;
> + *	- EXT_DIRTY_TRACKING for tracking pages dirtied by DMA;
> + *	- ...
> + *
> + * Return: 0 if not supported, 1 if supported.
> + */
> +#define EXT_MAP_TYPE1V2		1
> +#define EXT_DMA_NO_SNOOP	2
> +#define IOMMU_CHECK_EXTENSION	_IO(IOMMU_TYPE, IOMMU_BASE + 0)

I generally advocate for a 'try and fail' approach to discovering
compatibility.

If that doesn't work for the userspace then a query to return a
generic capability flag is the next best idea. Each flag should
clearly define what 'try and fail' it is talking about

Eg dma_no_snoop is about creating an IOS with flag NO SNOOP set

TYPE1V2 seems like nonsense

Not sure about the others.

IOW, this should recast to a generic 'query capabilities' IOCTL

Jason
