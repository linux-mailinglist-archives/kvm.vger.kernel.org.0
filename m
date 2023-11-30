Return-Path: <kvm+bounces-2824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C06F47FE4A7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 01:12:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 635B6B20B14
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 00:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69341636;
	Thu, 30 Nov 2023 00:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gmVKMJvz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6425ED7D;
	Wed, 29 Nov 2023 16:12:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbMPn82YSG4tTtIHLr/VAnwqRvIy5gBS5sGKqmiHcI9iQAfBReE1FjWyGB8nwZcU8p9fUdpKxM8rnxCBtyuLbChRc78VpRjvZPQMGBoQFsGoF0lH2KMobKanu4WR1TSIWLzwbwar0ZaMk6R5DMO5ZRfK6RpLYYvKWQFHl9WBbsFLcuZUq1rNsKuwSh2+jxq126sFPRaXh+K9du+/x8bUByMEDhUEYffC/cGScOwc/LS8/HYwMWsfcNXsTVDb5YtJPdNrRBM/SiLaln7uNEuUEt3DT1JNctxiqr32DZuUnHvovpVfXka8rQlk7IEp1T/62HMGJLFllSf4eiBZHd00cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZA6F60v8VeYeSSoT++ymvdUaAyddru+AIELbMmQzr0=;
 b=nz0p6hANQnDVy4c5876CAakjEpz0hxzMJtnPchsPu3ZMZxnp416CozTF6Dduv51FHdbPmYnuGfo+9koucHPzdMZgiaATZOCZkM18rMNAm4dfbG5rmBYvRVFyRzf+WaVlbAo6kZYPLKjqPYaANpJ7IeDdnueQ/r11DwrHcbOPt2N2HGEG1Eeav4m3A2aIR4Up11QLrj5I4ONbC58hRnFFLzbGiwZMDBf6wIjndqoxu05VG8f41f5FncBk4zDE7Fgw8CawgjTaUf/Vzsvju7gV4SPnbqZ6kD3S56NQ/fNEl/MEC32tWtBMOBAlT0mY++Y7m6lrUooYmGDStWsmGV/jZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZA6F60v8VeYeSSoT++ymvdUaAyddru+AIELbMmQzr0=;
 b=gmVKMJvz+9CtxebhAbwK2theMkrPDrZ7DJamXKcfgb7/zr8sii2KeFfn6u6SMQDqsiUt9teuL62j0EQqb4yY3EvQRAtbtRVdGUKjLbFcQOPAFRmDLXMxJhTtrWwo/x/9PsWfpdel6F8Yt2d5tTKvYozmkseeoVBOL07CZQKicJYnRE74nb0SfLrol+WsNxtAG4jAtp9iUeZf+goXsbevknpEr8+E3szj8jTqAvPqRy5W+MlQIvZvU0EWFljOTt7fO6S/NoD1d0uxtxKH0QCNk+rK8IcfL48XWeycJuUV3Ny16/R4w+ApxFMe8v/sor0ENgKVdQFKn6zxUt5n8cD/eQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4247.namprd12.prod.outlook.com (2603:10b6:610:7c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Thu, 30 Nov
 2023 00:12:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.015; Thu, 30 Nov 2023
 00:12:18 +0000
Date: Wed, 29 Nov 2023 20:12:16 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] vfio: Drop vfio_file_iommu_group() stub to fudge around
 a KVM wart
Message-ID: <20231130001216.GC1389974@nvidia.com>
References: <20231130001000.543240-1-seanjc@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130001000.543240-1-seanjc@google.com>
X-ClientProxiedBy: SA0PR11CA0082.namprd11.prod.outlook.com
 (2603:10b6:806:d2::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4247:EE_
X-MS-Office365-Filtering-Correlation-Id: e0cd5e67-31bf-458a-0bad-08dbf13903ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M14JWNBNpKozj4WH8GIJH/MNJSVHlZ5mXS+OA3euUwzSYKRJRQ1rvndJih4V/0i+463PRo3a9eE3mMLYdx+jRUxeuW+ivpD8BEAw/FWjnEwiOSOiZvxXKrBmxuQdZmKSokITZAJvX0NxHRTkZrRgn6bFJLmhjUnTU0eQyPTTga3hCrtjPbh97HZWeHygsJJu5NQPFDDS6RPMX+OTixJE+vKhhclGM/QQfBHoGCGOChuTJHCWa6vjeWXghPc07niu58sjMTUaviWqebmfsPk1iykhKU1363qsbKVpzYJO3V+a6CwvyAtSK8uA6GlGxtXb/utpXG4bLDA/WZH+ufVOQN3nCk2+HZHYDQRkqicnYBx9sah3cP7valraiLnWuqOPUuyh7j348jFQDhniM9f28J45yTZuCi8JxyCnrq/bPmB4Mu61A+sJbRlRdArjqRArsh21kqgs79gcTBmqYq5LuvxGUeYWrZibxrxJ6Xco7UdPckpL6/lr+7S3xaUW8jc5+4kaqNzZ0nbdPz1bffEWtqG1nF7h50nmtC3NWQSNw6hU6RRU1zgvunzaSd1AT7xLXqyhZej7n3QnBZ4VH+Vl6zUX0T9Pp+uu3IJxV70SJm+t1mkkxAs066B6u3RllJSYMqfGudEcwiRJPupeGsfVLfTzr3xx1TzFwv/fJJW8P1+9QK8Ex0M4xyH5gsN7xG8rM3UGk2QxtFTA2eth/gGCjsJH5W4+uINWuGsP1PFdKX1R8KbcEA84Oie4KQLciP8R
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230273577357003)(230173577357003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(36756003)(83380400001)(26005)(2616005)(1076003)(54906003)(66476007)(66556008)(66946007)(6916009)(2906002)(86362001)(4326008)(8676002)(8936002)(5660300002)(6506007)(6512007)(316002)(33656002)(478600001)(41300700001)(966005)(6486002)(202311291699003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WsUETZS6XszaGzQ5939qo2MLAoZA3EPsUnKD5OOFrIQVsiCPP5jCvTiJA0d/?=
 =?us-ascii?Q?AEAsDYLnTYa//Zppb4X8xOw8NROptwQ7Ly1+IPbyr4TkdfbLifrsOVWXPx/Z?=
 =?us-ascii?Q?auU3Pq5lveAwATfLTtZPGwWi3TVJJZo3K/BQd7ORrc6jXm2TTkeUfvt/9M62?=
 =?us-ascii?Q?XA+AZY2t6fNMIj6wQLWclCuCcw55IYDp21XwDDtNpsBR2T8F1Mw3Ibpcaeiq?=
 =?us-ascii?Q?FJ7dOZgGqa6nSsAc/v9O4Itm9Mclqk7jZM2/hiWwkqsS4U1ELvVS02tvVDo/?=
 =?us-ascii?Q?AKnSrfjH/yDjanu+qed/irpXOafb/2Zg8jr4t8x0jQoZrGGQSapq97Y69PuK?=
 =?us-ascii?Q?HX9Ht+0QQpazSN5P/GXldmF2wdr/EL6xRyikySW1mnBdpNj+SL2IJQRSTXmA?=
 =?us-ascii?Q?Xpp9Rj+m3o7/+tAabNtj6RrwHh0YZl4d/yzKkwtX0zsLtQT2YGAOj64StFwx?=
 =?us-ascii?Q?gu2OPSwf/veCvTL1dLxCNL8DogU8PPbxDM9jRRVRPjQdr4CnaT5y+pgO/9Pg?=
 =?us-ascii?Q?jsfP4vYnOSvisB0DY1zNntoroVs4XcgJ2Ke0p/3zZbUF7jzhDSm4g9aHONq9?=
 =?us-ascii?Q?ODm1Q5RdYx6Sn6Hy4aZFwQOgzLMKJhQGD1qRl+BYENzlggQ7qI0bWLzONVWe?=
 =?us-ascii?Q?trDQm2ok/HlnCuuOeByCik7SU1p+Xa452XIi6OZPyzzDi3dO99pKc4jcTe38?=
 =?us-ascii?Q?yhR5oWPAxRN2GNh4cmMxOVEIM3TWR3qwcOrToIzDH94y49sYIG/CRMRaSJv7?=
 =?us-ascii?Q?57JLNhvQ19mGVxfU8vQR/uqrFiA68/4AilwVrCW3a4WI2Ycx1Nx6ng/h4w76?=
 =?us-ascii?Q?f5n8uf+dsfe92uXOQrCy+FDV5hCPymhXICYdkqDZcSrCDRK+P6edBkbFQn3j?=
 =?us-ascii?Q?AGSWpCPK/T3q/QivVB57di7uphcWq1FakLFzGA0UuoxbQ+DItiTrR0IZc94I?=
 =?us-ascii?Q?x2CdPUYVG476SHQHq52XKjNEWWfQXbjZP+9+Y3Pw3I5aubg5HyQwp3uV1+d4?=
 =?us-ascii?Q?KQXF5tS+7GeX3dOExwX6zZ3PmfB6EHIIkZ9yNz+wL2AVAg+lYhexJjZKDjNq?=
 =?us-ascii?Q?6yq/oudBOe+RaP8Frfwnc0N4LRF9o/bxFL4xG/AE0wpVLXSQi2ubx28csi0I?=
 =?us-ascii?Q?EA6yUzgMGRIYJZ2UCAoLCWHm3BqAKiVFCWqFfXucNSJpfQWjg0Q0/iMNt3VR?=
 =?us-ascii?Q?opIJp0TsyA9v1UsCZB0gDDStTVgpQJ0SC4Z08fZHUnHJpQJZn8dl+nNjW6gV?=
 =?us-ascii?Q?bA98IHi3PcDqcyfI7YpySE0KZlbspLQHugGwNitj/5M+9Sf1ePD6ZGnLNUQX?=
 =?us-ascii?Q?yHagRFETIlv1LBFooDHmIeihW6V2upWKE/+XeIksZaK3z8nSMcSRA0zD3FDJ?=
 =?us-ascii?Q?LxzLIJDwmRXZDuzlFdShsgXuNgt6fvvrlOann2tuj0pByIYeDS+FIn1uzgfg?=
 =?us-ascii?Q?K2x4GKyZUvUukDYD75SdawM43zd9I0y2Pnh/DrVr2yvulEmIOJgr+WINDwUi?=
 =?us-ascii?Q?teZWU52n/BhPXn9nACcksqur1mPgCUL/B+jZO4ofrbvsRSIbZnvqYc3LdEJ8?=
 =?us-ascii?Q?hVx4Wgnukdq8OSdYc+hNRLlM3ENBHRw8V6yifpq4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0cd5e67-31bf-458a-0bad-08dbf13903ae
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2023 00:12:18.1125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZxcfQ5vj8HU75EMklLS4agG2jCfP/IBxkVQEkFcZAIyNbEKW29gSBSWTDLX+Q6F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4247

On Wed, Nov 29, 2023 at 04:10:00PM -0800, Sean Christopherson wrote:
> Drop the vfio_file_iommu_group() stub and instead unconditionally declare
> the function to fudge around a KVM wart where KVM tries to do symbol_get()
> on vfio_file_iommu_group() (and other VFIO symbols) even if CONFIG_VFIO=n.
> 
> Ensuring the symbol is always declared fixes a PPC build error when
> modules are also disabled, in which case symbol_get() simply points at the
> address of the symbol (with some attributes shenanigans).  Because KVM
> does symbol_get() instead of directly depending on VFIO, the lack of a
> fully defined symbol is not problematic (ugly, but "fine").
> 
>    arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7:
>    error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
>            fn = symbol_get(vfio_file_iommu_group);
>                 ^
>    include/linux/module.h:805:60: note: expanded from macro 'symbol_get'
>    #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
>                                                               ^
>    include/linux/vfio.h:294:35: note: previous definition is here
>    static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
>                                      ^
>    arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7:
>    error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
>            fn = symbol_get(vfio_file_iommu_group);
>                 ^
>    include/linux/module.h:805:65: note: expanded from macro 'symbol_get'
>    #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
>                                                                    ^
>    include/linux/vfio.h:294:35: note: previous definition is here
>    static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
>                                      ^
>    2 errors generated.
> 
> Although KVM is firmly in the wrong (there is zero reason for KVM to build
> virt/kvm/vfio.c when VFIO is disabled), fudge around the error in VFIO as
> the stub is unnecessary and doesn't serve its intended purpose (KVM is the
> only external user of vfio_file_iommu_group()), and there is an in-flight
> series to clean up the entire KVM<->VFIO interaction, i.e. fixing this in
> KVM would result in more churn in the long run, and the stub needs to go
> away regardless.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308251949.5IiaV0sz-lkp@intel.com
> Closes: https://lore.kernel.org/oe-kbuild-all/202309030741.82aLACDG-lkp@intel.com
> Closes: https://lore.kernel.org/oe-kbuild-all/202309110914.QLH0LU6L-lkp@intel.com
> Link: https://lore.kernel.org/all/0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com
> Link: https://lore.kernel.org/all/20230916003118.2540661-1-seanjc@google.com
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Michael Ellerman <mpe@ellerman.id.au>
> Fixes: c1cce6d079b8 ("vfio: Compile vfio_group infrastructure optionally")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/vfio.h | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

