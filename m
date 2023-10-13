Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE827C8B3E
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjJMQWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjJMQWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:22:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AD52100
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K32O5XWcSebo9KbbgJKq5vq54dHZxIAP+H3IX2viSd5wHxBQv/iHNYp4Nh+txMpjgkmi1tp3e2n5NhLXnIzk+fOE6td0wMTU1G/zohE567hGJ2CLAlUVcRHS3HxmrLb7bUgcex7sfHGF8mC8uAZcvvy28cJ9iAIc8Zii4vse2/IPID64c26xKLpWDc+rsrIRe6FQKZADXB6E2F5USRmWcpAn4IpYVqTPLy6gXCfxRguxPil7SC04OzdQb/R1F4nx2JmERSfwplW6yHiTSv+uY6cgxyuBrE8a9EZdz7EtCMh8ID9YF3SrQySzBI7NPhCdoge3oEsKSSWDcRfCCj0DHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4+sFc5lOM9qrTxtyIMRimTxjyH2BLiwBV6vaJQz4Rk=;
 b=L9bMrHo40IDuEC/go/sSYXDNXdWseyYjukFFgbFvpE3umc2qvKRRDUuFD0851jhVhorUliYk3clvCoX9+ByhI7HMTyaImFM4jiAmGHU46KZ2gDYqGmWSUMGECS4+7DTzaYA11dysaRJ82ru3PfWcYVwEVT6cd1UPbJ62EpMHTbLIl3gyDnyxmtzUlEsOabGojg6Ldz1z8Jhq3l2PWXEUoG/7dP8Y/p25wE8PwCDimZ9XxBfyHY+Eem1KV/H6h1BJ+C9ktsHeZD4/aGE6/eSLv7bq/jv0IXmXTWkgn+d77bKMX5HLwPfjPbMySsePZxwAGwphfLLc4SlM/6MOtBLT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4+sFc5lOM9qrTxtyIMRimTxjyH2BLiwBV6vaJQz4Rk=;
 b=JaiZGgl6SzRdo3TJrWgLvZjAsDu6InWVgtOClaM1ooRiV3qWsJe5RT7DvToxV87jp/1L2o6v2W5EmUpar4pr9mz+buj1ACzbgvSretkcxzGzFZX3xg17Zowf7A90EPBTwdqcEYM9Alg5jZcAkeDz7hoP54/wGXyUM989iIyZ30rxStY03WRpVMuADFXZqIZjxjj5RiV2gSmezfkScqfmRf608s0FoHb/3pFceJdZZdQa3DlgzB/ZnriBs5E07Ugqgtfic9mujHxuzOZM9FNKPmw+w2JvkjcEq8MZfXv5PpCuec4iUTfOWRxgKncea5YGsQpebEP+0md8m9xpnfpfDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB7523.namprd12.prod.outlook.com (2603:10b6:610:148::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.42; Fri, 13 Oct
 2023 16:22:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 16:22:19 +0000
Date:   Fri, 13 Oct 2023 13:22:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 10/19] iommufd: Add IOMMU_HWPT_GET_DIRTY_IOVA
Message-ID: <20231013162217.GF3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-11-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230923012511.10379-11-joao.m.martins@oracle.com>
X-ClientProxiedBy: MN2PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:208:234::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB7523:EE_
X-MS-Office365-Filtering-Correlation-Id: f4770578-89b4-47ac-0012-08dbcc089259
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b3wKkHZjtKYjHgK6j09/4l/gdpFF2PSvETqCujknyc+94FzFC15O7ERnBfSoJkG4LfRKCW+fwVVphQ0ShjKVrfJ2S0IOpQfAmuC5TlyxC3RkY4IIKa19rBVpB4V1hMEnh2SEAiEpmw7C12cJ6UzDwsLTB3Iv6r8xDdIDN+34SMk0h1mEn28cI1NR3Gt6QBPDX53EoMRiHzMOaYWd8rFO/Kq901L7iLvBf64S6UvCsGB7QSEoJ2T6Lgx89d9irMJdg76wHTwak/VAjPCbCFO2s4x92dwBJoo4MepVX2SPG5x7FgmU6F1lObFvPFYwsc4fB7HiJHlIMA2h5QvydLLju52TJ4BdQMH0exCyZiBb2+OHaMc2i1LuaPW5MQsMxqlK7rKEfgW1/EVC7hc1Y3f1f0uhmJ1oMvMiSKh0lQ/DNcv+mAlfXxEmPTFT+qQIzF+l+0BHnXtT55GZBIGo/x0yDWCMLnGClUngU7jSeuwj0lRHz4Rygv+YjRPKkhhE4XtYGG91snGgRtpfvhSjd4t0nV/RROgs6/NRZpb7jhqFnOsb5ae1pXrteKElo6BubLvAvP+a77yjCVBSZmx8Pcvfl0Up3qlpGHgVkVD1/L7+H1A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(39860400002)(396003)(136003)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(36756003)(38100700002)(6512007)(6486002)(478600001)(6506007)(1076003)(26005)(2616005)(41300700001)(66476007)(54906003)(66946007)(66556008)(86362001)(2906002)(6916009)(316002)(4326008)(8676002)(7416002)(5660300002)(8936002)(33656002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o9GKhQYnFqpQ22bQIIF88b4u7wE6TaJJ90CX33eq/jFzRC2rT4cwfjCWGAXz?=
 =?us-ascii?Q?2B+LDxP8U88v1udwPswTTUHv5hGplvTTubGWhcHPeEYBNzKoiEAAVHnNHnRj?=
 =?us-ascii?Q?1KEQ46/6RUEaXExI7Iyii7qjm/4CALelHP2649s+zdLZJrj0+ubliIw8/P1w?=
 =?us-ascii?Q?QB+TL23OLBcZoh9JRX9voBc1zYdnzjHW80wEGlWCiePDHoj6aFCSvZAXTXRl?=
 =?us-ascii?Q?zihdnga/oMXPeYq6rgT81/Mw7PmfEoxemtEkZP1miNY8CQnrCC2n6CfX88wG?=
 =?us-ascii?Q?XELPN6ubR7Hxw6Qwj8zOMk4cHRusbQ2NIY9S6s9tMLowHrD3IMtd11RZqohc?=
 =?us-ascii?Q?Cmu3wOdo6pwmWg/1G8oBlDB9JO/0JiipAz7KOB8sfy3dn3DZ+E6gwTbgEQY4?=
 =?us-ascii?Q?9zeobfL6EcFzjuBP8lJiQxiZgtu7b6Xmv354jLHXxI0OzTCFxh+ckRRA6fJw?=
 =?us-ascii?Q?0UAJSY84Fl0+p8bsBEvmOl8L4lVXhLyLgPU+DnxucPoGZ2hupfxfBh6buxjY?=
 =?us-ascii?Q?PjbhE10dTQIu/rAzjVo4+cc65NNDyxtXU2nMlsHom0dpG1HmJXZtypuuR7KX?=
 =?us-ascii?Q?IAH8R5jstMFL8ArkImGKNC7dbJio8uG+NPvCVDGmW2teT3hm5KyHT77mDC3I?=
 =?us-ascii?Q?El5oaD/uu0MvBglr/+PjDD8BjVna0Kwu7qgfG79v0ysGUlkSghqySQXIJ+6r?=
 =?us-ascii?Q?zVr9kmLH8vSf/AD0BnSIicfDfl2zXMADnwAKnljv4nnGKXEdKKpw9/Iaki9o?=
 =?us-ascii?Q?m+qY8RXDvRbjcysE4Lj1Z5/j0lVH+/+PzdIA2Sddl1XdO4BRFF4BHiTo7OGx?=
 =?us-ascii?Q?kY3qWLH2IsJeHWgh4bW1FgO717L3UIp+5rHiQK7D3tnNtdOcD5sqoTSBXw94?=
 =?us-ascii?Q?9o59tPZLHQt/edxg8obil9pDXUghL6NLpmJ0XoI74LzllLSp2sctuTlDyuOr?=
 =?us-ascii?Q?lZatYZqcym5d9hz1XTA3r1bK2Jzho+qE12nuHRd9Ky0HlPgQn94ZGz7WaBlB?=
 =?us-ascii?Q?T3/CjbE1IGaB4+4clhImjQWRfueWGDrNAuUJtXZQFH0iovyqHi6x9iHaWq+u?=
 =?us-ascii?Q?0KzaQ5IIG+maxKTvsdQ+tXuGV82BGCajpbcUQqk2ptqqVBMMl2FhIX/EbCCP?=
 =?us-ascii?Q?CXWC8A5ooHHHLcwX+r0yv6ikcBUoSRwEU45reufzMEnrtJ2ps5PQfhzCDn0o?=
 =?us-ascii?Q?lZM9HR6w5lLx9Ia21UBwBe76G4DqFANmyCbzGnTAdlFdPbfvZaVQApB6j3w+?=
 =?us-ascii?Q?+0a9oyt7/UHDvbQ0fVkMnszwVS/XM3/szUuoNI4k3AR5CABHDKLh31Q7vZ1j?=
 =?us-ascii?Q?yAKRHPhb+mgofVYUexK48mlOsfmBZsjiYXFQbHIz1OU5Fy4/vbkmOOHjL7Z9?=
 =?us-ascii?Q?JQ0a0EPYWv/iElfFqNw1dszvxGEGcPD4elFoSEHjD1Dq2pD+hAKdggeHUVya?=
 =?us-ascii?Q?AwpM9d1zfEqdG9dHPCcMR5ldVdWTVpRALskEEDhoTRvpDSDt4PvPp/17hs5M?=
 =?us-ascii?Q?ZraDFadVwkqhbe1i0sOVP+xNGT5A76q/NeC1DFvAP9TjA9sUQDnvyN6Wkcr9?=
 =?us-ascii?Q?ko6Kcz1ax+OjdvzfOjdZC+1orV2xuQxR2f/RY3CF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4770578-89b4-47ac-0012-08dbcc089259
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:22:19.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LQBadBFHQ3YYtmHJFx0+NVYWyeYvZS/vs+MV6aKZ/rJfeJ1lPJGBjBylCGQcD9PG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7523
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 23, 2023 at 02:25:02AM +0100, Joao Martins wrote:

> +int iommufd_check_iova_range(struct iommufd_ioas *ioas,
> +			     struct iommufd_dirty_data *bitmap)
> +{
> +	unsigned long pgshift, npages;
> +	size_t iommu_pgsize;
> +	int rc = -EINVAL;
> +
> +	pgshift = __ffs(bitmap->page_size);
> +	npages = bitmap->length >> pgshift;
> +
> +	if (!npages || (npages > ULONG_MAX))
> +		return rc;
> +
> +	iommu_pgsize = 1 << __ffs(ioas->iopt.iova_alignment);

iova_alignment is not a bitmask, it is the alignment itself, so is
redundant.

> +	/* allow only smallest supported pgsize */
> +	if (bitmap->page_size != iommu_pgsize)
> +		return rc;

!= is smallest?

Why are we restricting this anyhow? I thought the iova bitmap stuff
did all the adaptation automatically?

I can sort of see restricting the start/stop iova


> +	if (bitmap->iova & (iommu_pgsize - 1))
> +		return rc;
> +
> +	if (!bitmap->length || bitmap->length & (iommu_pgsize - 1))
> +		return rc;
> +
> +	return 0;
> +}

> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -316,6 +316,7 @@ union ucmd_buffer {
>  	struct iommu_option option;
>  	struct iommu_vfio_ioas vfio_ioas;
>  	struct iommu_hwpt_set_dirty set_dirty;
> +	struct iommu_hwpt_get_dirty_iova get_dirty_iova;
>  #ifdef CONFIG_IOMMUFD_TEST
>  	struct iommu_test_cmd test;
>  #endif
> @@ -361,6 +362,8 @@ static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
>  		 __reserved),
>  	IOCTL_OP(IOMMU_HWPT_SET_DIRTY, iommufd_hwpt_set_dirty,
>  		 struct iommu_hwpt_set_dirty, __reserved),
> +	IOCTL_OP(IOMMU_HWPT_GET_DIRTY_IOVA, iommufd_hwpt_get_dirty_iova,
> +		 struct iommu_hwpt_get_dirty_iova, bitmap.data),

Also keep sorted

>  #ifdef CONFIG_IOMMUFD_TEST
>  	IOCTL_OP(IOMMU_TEST_CMD, iommufd_test, struct iommu_test_cmd, last),
>  #endif
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 37079e72d243..b35b7d0c4be0 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -48,6 +48,7 @@ enum {
>  	IOMMUFD_CMD_HWPT_ALLOC,
>  	IOMMUFD_CMD_GET_HW_INFO,
>  	IOMMUFD_CMD_HWPT_SET_DIRTY,
> +	IOMMUFD_CMD_HWPT_GET_DIRTY_IOVA,
>  };
>  
>  /**
> @@ -481,4 +482,39 @@ struct iommu_hwpt_set_dirty {
>  	__u32 __reserved;
>  };
>  #define IOMMU_HWPT_SET_DIRTY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_SET_DIRTY)
> +
> +/**
> + * struct iommufd_dirty_bitmap - Dirty IOVA tracking bitmap
> + * @iova: base IOVA of the bitmap
> + * @length: IOVA size
> + * @page_size: page size granularity of each bit in the bitmap
> + * @data: bitmap where to set the dirty bits. The bitmap bits each
> + * represent a page_size which you deviate from an arbitrary iova.
> + * Checking a given IOVA is dirty:
> + *
> + *  data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> + */
> +struct iommufd_dirty_data {
> +	__aligned_u64 iova;
> +	__aligned_u64 length;
> +	__aligned_u64 page_size;
> +	__aligned_u64 *data;
> +};

Is there a reason to add this struct? Does something else use it?

> +/**
> + * struct iommu_hwpt_get_dirty_iova - ioctl(IOMMU_HWPT_GET_DIRTY_IOVA)
> + * @size: sizeof(struct iommu_hwpt_get_dirty_iova)
> + * @hwpt_id: HW pagetable ID that represents the IOMMU domain.
> + * @flags: Flags to control dirty tracking status.
> + * @bitmap: Bitmap of the range of IOVA to read out
> + */
> +struct iommu_hwpt_get_dirty_iova {
> +	__u32 size;
> +	__u32 hwpt_id;
> +	__u32 flags;
> +	__u32 __reserved;
> +	struct iommufd_dirty_data bitmap;

vs inlining here?

I see you are passing it around the internal API, but that could
easily pass the whole command too

Jason
