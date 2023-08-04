Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D69A770653
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 18:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjHDQvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 12:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjHDQve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 12:51:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71041994;
        Fri,  4 Aug 2023 09:51:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVrhZuBL0raP08m77cWqVmuvLKzvRrrQK6Rf4LJrwR6s44+oHS1JfnlyRDyNEfNMObBkPFzSkNjUsORpA8fvsVj0WW/lxGdtK8bmpi/GLCbpb8GPi6PLA7UKZ+SVtrRvi9FZiDhIzxrOQ7InTOzxI/vzMqpFL1HGmz8HkLwTahpTOfCv6rxo4dN2rBaoQLlRZCfm9vEqLHdvoQChmy14JsOHO93x8MAsR9gVCHWN3Ez1Rn1NAshoBQtA73TLtuVvORT8ZdZF8v3WXOSqZEsoOPR5Co2UEIRoboxSb8pHarkJzoWa7kPfiERJo/nRw9e+zp7k6bhJW9LXMbW6kVSHlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lAN2gxDToXnbmOndznQSaQmy6ZhAGSA95vBqW5CTp/U=;
 b=blEQsUOq8cAAVZemwmkdQNPfF8HtJafMz+u/MF+qhob9ucitZG/azHLBFoaSijCPxlvPoOQhrEnp3S8582NQ7pFu8jXD/3RGYktFVE9y0hNqE+quEO4wgbXO1+xZgUR/eJLomTEtnir/xHNeHjUmlHxtsQU5J2U0Sz395zyE96ovAftdwqR8ym9yilSwVqM8gmTstnKJS/TUGi9qB5qD4PchivdorcBxdK+B8SLNtPKsSXFr7aN5oNc22PTj5gbb2iceE0jkjIeaSFfJ1vil4aRyejBsaMJDk1tCtIQqnMKtPkDaUZ9LOu6v6ZDvg2ieVlQjezx2odorKw2Zb5v0GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lAN2gxDToXnbmOndznQSaQmy6ZhAGSA95vBqW5CTp/U=;
 b=juH5LOUWDgYeYqeQzS9fX1dO/URp2diIeHEjuMmiwDtJ6qo6h7+fQE922kJSQQjeKKqF8QRY+NrwZkxr+CVN+mKotILj1SkDCUp9/9XtzeBdmxtclcu4hHfuHD98vzDbyNfAXx1otyumoEWOr+JuswkO99gt/a1h9UsaWniGdHGHkHwUM90Q0+QewZczqanTCqMFJdeNOf72ekBf7ptk7KuOCAa8NbJzpbvNV3VvLyJppuz+Yq2/tDi/vEkstmb+XrTRd8MzPNuRlqoVscBwHI0NppGbArtVDSeW23coPh2X/PVMZYXF/KCO3Ly0js/E1yUMiB2T2lXkEN0BlQLqwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV8PR12MB9406.namprd12.prod.outlook.com (2603:10b6:408:20b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Fri, 4 Aug
 2023 16:51:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 16:51:31 +0000
Date:   Fri, 4 Aug 2023 13:51:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
Subject: Re: [PATCH v13 vfio 1/7] vfio: Commonize combine_ranges for use in
 other VFIO drivers
Message-ID: <ZM0skSmMTNbfRrQ0@nvidia.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-2-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725214025.9288-2-brett.creeley@amd.com>
X-ClientProxiedBy: MN2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV8PR12MB9406:EE_
X-MS-Office365-Filtering-Correlation-Id: c7cd5d90-9f31-41e7-20e5-08db950b0d80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uh/lgwSRhbJrIqtE9q+p4l1ajrBXWVz8b3Kiaa6xysC9ltFxnSyfns1aRtXJp2cAkgEW3mibJJQ9bk95KDJSMoL9r2opm2xy3pxWlx1FxcVwOHE0jYfkNWxtkMJXg5HGunrMH4rG2/FPYHyNnyxrk0Phl1Ltl/HHOQbAgSBpGnodBhbxqdatKtVCyNLVgdddJPq6ey4XMKNGmK4il8ryGG0EIQ4NtQxVqSgCmX22iK/EclWRQWGxKIiHbZ/gAtIfff/9675nmC2bxwbmrx8g/b2s704Bq4/Fhn7+YRc0sSczzu9b3mpcCe79CEkncyjJY5ACP60CZ13ptTa6sSNMmgEJruNfd6E5AVSnxzqsCJOwrgKywXVCucgeahexBhyEMlqrAmvRU5LJasU5SIEmCGk9hStBZFLskm1tHf9hc5XZAodhSoCAvUx6VG8hgbY/zvPEp5Ir97kjbue/pbE2sEQGJ1IpkTYrjnZ5uEXxNlNCZxWJmewI2S3Fvsy/7uzfAZp5D2g9pVVVpUELyK5UM3vsFXGKEmyZlh7unlclGJ6CPYtTIf5T3m1CgmEcoCnA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39860400002)(346002)(136003)(1800799003)(451199021)(186006)(2616005)(26005)(6506007)(8676002)(4326008)(2906002)(66476007)(316002)(66946007)(5660300002)(6916009)(66556008)(8936002)(41300700001)(6486002)(6512007)(478600001)(38100700002)(83380400001)(36756003)(86362001)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KZalLPoWRLoa4vvis8CkDy504bRU+KAk1tOLOphv3hggmCwOX6D6rCHy/xdd?=
 =?us-ascii?Q?Zb80R2Q6JkA10wr6aouaMJ8XjhDUxJ5l+3cgArKRpD7ibHGR5fgws7oUqVVr?=
 =?us-ascii?Q?PmozR+CtQdkwdrA4H5OM76FPPlMeC1peRLrFP9Wmz7Lit0qv9BsdQoO1h65K?=
 =?us-ascii?Q?d2Lj7K9S7Rb/4IUCxrfimaxovWZWrZaLnMS8Q587OH20U7CNvVtWG7S7O6O7?=
 =?us-ascii?Q?UqAW5WrMwC6ShCt3U1tqfSCPEZY8wUv4OGTejCjsQJhhmHdRYj7MKH9fwymW?=
 =?us-ascii?Q?J8XYWzsdHglRnKNDsaRAz2aMMocTIT96VFm3Ym3LRNwyNqHIgH3o0+QExh1o?=
 =?us-ascii?Q?uq7mrIN99TWO799kc9+qHB3Il9Vs/JpSeXCG9hbrEPVkoF/AFAW5MXeoOhzg?=
 =?us-ascii?Q?BEvsrHY21S6fdqzWu4zidDDbkyY6cTBgGZQ/nEqpT1cpEgwyfLVRTcJGHtZs?=
 =?us-ascii?Q?n6KuH3UFitvwEA11oIO7TKMpbqM+pRJM8g+9VEbhA/YVy15X+IOmZ0nZWvKD?=
 =?us-ascii?Q?e1SJT6rqvpKozUYbomX3twodM0s2SqBkMSPUG4Ulvqj8F/0M1YL/HNQpGfb5?=
 =?us-ascii?Q?Jv4OQ2bhQ8a6Nhq9u1TmcsZ/OVzkfcrHNpn3NNja2XpheoTbAjOag7Gkh5+3?=
 =?us-ascii?Q?hLzgjSogAzDsjZw+8FoCztXOIuR4FL+/hHHZkCvDvxe5V9htsl2iEXEqnGMr?=
 =?us-ascii?Q?5Pqls/SjurQMWMSPr5n0BMEVxvm6FJYSQszEFo5TrzX2ocIWEsM1HpAFLdaF?=
 =?us-ascii?Q?oXDY4CSCXb7UGN8RrFc185feeAdIwWWT+BRgxhXN3QG93lpsl5ayxFt8uiOR?=
 =?us-ascii?Q?ziTdB+l9rQs3q8U/Hpksi+me0kQvuvNTSv+rrdJisCyy8AQshvL4Fe5X0MMh?=
 =?us-ascii?Q?wnIH6mfrqpm1t6WVyIC73BCImvYuQc69WP7PQLW/l/oI5uiMKEpYUYpCHTjc?=
 =?us-ascii?Q?/v/jFG6fEBeqvQZ96ZVOIfPkL9Ttg49Vkic2rkqKkHhK4E4r2fUMfY48q7P3?=
 =?us-ascii?Q?CFjLttZRloN0byTordMsb+I71IPc5fK1d8PxNvLzkiqZnRNuz/LXR2gYkY1d?=
 =?us-ascii?Q?d/uoAwpsVYu37MS6j+036E2/9P+73WmzUbvdmIMSrXzpg5ye8bY1BuYhQY5V?=
 =?us-ascii?Q?xrddOJTHJgabklpwRVIOq4hQsFjQ5t/0yAoZM52Mmmo7zwutICQf4X9ayREo?=
 =?us-ascii?Q?n4uAFPEx2wm4wvr9gzrbra8wajWEumMM3g9xNb0NyLz1O5q6CizzfmlvZ0GS?=
 =?us-ascii?Q?4aKsU9Gfq9iEWLbQIEWnmRJCsviMLdNnEdXOevAcTlZU7OeMa69NhfDs/6Xr?=
 =?us-ascii?Q?500UCS3NDfPYZT8Ry6ebm4nbji6gtBtGql4mW7R2Aowo1fh7VqY6zzexIcY1?=
 =?us-ascii?Q?raWyH8lCBIKBJp376zOqRaDJPjGfZyde9sylLIHk94qkAL45zOzlEWZVIGVS?=
 =?us-ascii?Q?9Uab2pKWnyYGCxACZnQW3svmOKngoUubIKB/RMvOfzypK4b2HDAAchm0Pd+r?=
 =?us-ascii?Q?6k15UEyR/4kucIOwKyNQ7t2TehptC3esse+oxCCWkFAraQLwTQbDZzrxXC5J?=
 =?us-ascii?Q?7wpziMhE8UGn5iezR7iljUPW3+Pgmen+UZ9SglJs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7cd5d90-9f31-41e7-20e5-08db950b0d80
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 16:51:30.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJ6EfgJOLcfmHBXTllnzAxVXXKbUHm/LFpqywp99EN4b7JEB2xlysdODfrZJHquU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9406
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 02:40:19PM -0700, Brett Creeley wrote:
> Currently only Mellanox uses the combine_ranges function. The
> new pds_vfio driver also needs this function. So, move it to
> a common location for other vendor drivers to use.
> 
> Also, fix RCT ordering while moving/renaming the function.
> 
> Cc: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/vfio/pci/mlx5/cmd.c | 48 +------------------------------------
>  drivers/vfio/vfio_main.c    | 47 ++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h        |  3 +++
>  3 files changed, 51 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index deed156e6165..7f6c51992a15 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -732,52 +732,6 @@ void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
>  	mlx5vf_cmd_dealloc_pd(migf);
>  }
>  
> -static void combine_ranges(struct rb_root_cached *root, u32 cur_nodes,
> -			   u32 req_nodes)
> -{
> -	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
> -	unsigned long min_gap;
> -	unsigned long curr_gap;
> -
> -	/* Special shortcut when a single range is required */
> -	if (req_nodes == 1) {
> -		unsigned long last;
> -
> -		curr = comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
> -		while (curr) {
> -			last = curr->last;
> -			prev = curr;
> -			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
> -			if (prev != comb_start)
> -				interval_tree_remove(prev, root);
> -		}
> -		comb_start->last = last;
> -		return;
> -	}
> -
> -	/* Combine ranges which have the smallest gap */
> -	while (cur_nodes > req_nodes) {
> -		prev = NULL;
> -		min_gap = ULONG_MAX;
> -		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
> -		while (curr) {
> -			if (prev) {
> -				curr_gap = curr->start - prev->last;
> -				if (curr_gap < min_gap) {
> -					min_gap = curr_gap;
> -					comb_start = prev;
> -					comb_end = curr;
> -				}
> -			}
> -			prev = curr;
> -			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
> -		}
> -		comb_start->last = comb_end->last;
> -		interval_tree_remove(comb_end, root);
> -		cur_nodes--;
> -	}
> -}
> -
>  static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
>  				 struct mlx5vf_pci_core_device *mvdev,
>  				 struct rb_root_cached *ranges, u32 nnodes)
> @@ -800,7 +754,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
>  	int i;
>  
>  	if (num_ranges > max_num_range) {
> -		combine_ranges(ranges, nnodes, max_num_range);
> +		vfio_combine_iova_ranges(ranges, nnodes, max_num_range);
>  		num_ranges = max_num_range;
>  	}
>  
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f0ca33b2e1df..3bde62f7e08b 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -865,6 +865,53 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
>  	return 0;
>  }
>  
> +void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
> +			      u32 req_nodes)
> +{

It should really gain a kdoc now.

But the code is fine

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
