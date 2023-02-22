Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7839869EFFA
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 09:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjBVIRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 03:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBVIRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 03:17:01 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B3A36FE5;
        Wed, 22 Feb 2023 00:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677053817; x=1708589817;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=EP1Hl21xMxh1psOWpQJTih63QMR8M5mx+sJIiwqONT8=;
  b=JMnrbnXnZjmaGIVjLJSxooI26KNbeGI6/u4CjFdVvBfHfR4zrdOET98X
   HjdvtrfQTjDoCIIqy2w40HJZtjz+h3z/xq5V88R7pskbYhrVNyS7cp6q0
   LFIksh+59Cs1O4ROcVGnbSZc0KeZHKmgF8hPExdAVYUzSqYBj0CGZnlLK
   gyuTu6ZRitCtnuF/ATJzZeV6SvseYMRly6tIapgKs/aaHCY2VO1Ms5npG
   ira2qo+c7NDV1Xdgdlmy9+OirINg0A7tToEEsFTifm1/fyaRcGjEluiAX
   dR3zNqRPdK/cz+AF6rXTgkHWEgcdwUhs/HuZwPGHvCnv1mLUXFySIC5l+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="419094378"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="419094378"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 00:16:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="665268328"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="665268328"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 22 Feb 2023 00:16:56 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 00:16:55 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 00:16:55 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 00:16:55 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 00:16:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YZ62IovNTQySa5W79t3mq6upIOTtASuOLh0fnpBLvFgPcin9T4QO2UZDNFSQFyu6eSXKgbgBf0c1y4bi7whVVKcopUvH3lD7vaCjVnfQQR7FCSMXACW8rlWwhVuz0jwAXaDz6klWT/Jn5pja7LYD0ApejOrs9yTiuH0hD+sG0sZ3Vzc5Ip9ZVUuDujCnFEmUMBq3VIL0Kms9wvrFJypott0eWaXibS6KTFAUfOb1fbMWo/JqPbnXhnpgNFuPy610k+GDuFNW3qCGOdegdYOmtiPOG/bm4JXeoA73RtSqLhljv33GkHSCfxiBeSBhpCSUrkwJgVynP3I4cDMdpInyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zFQwy71kkv/QvF/7/81ItRMImd7RDoC/wjR/OFqTbnY=;
 b=cmF9llpPVN05yCrPGR3pOujJcXpDwhBcjxfflxTIZoydV+fho+JRILe75FvLpvx3LsFdVMsbBP1Ii2bHf8bErtbt5XCNngulEKMM9KqrpCBdpoH12NNRkYi0bE1BssrRyzEQ3AqKj+duSTnKAVdYf6xuyfkha20ctGukJPkJtcPtooNSLUdSRtfofEk0Ub9rslhINzesplvDUQsPQcKXNblQMzW5M9deWvettKJxZXXzjc06QCeUhFLMEBG15oCqasvKgRaFmI5VTrXMwHXhqPXDm17H+HRmBi/pSVhpvIVr0JeAA7UHBwzTfS1DMhY1pqB9ajDTfCmKmAAbaMq/9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Wed, 22 Feb 2023 08:16:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%6]) with mapi id 15.20.6111.019; Wed, 22 Feb 2023
 08:16:54 +0000
Date:   Wed, 22 Feb 2023 15:53:09 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yi Liu <yi.l.liu@intel.com>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <joro@8bytes.org>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <peterx@redhat.com>, <jasowang@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>, <lulu@redhat.com>,
        <suravee.suthikulpanit@amd.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-s390@vger.kernel.org>,
        <xudong.hao@intel.com>, <terrence.xu@intel.com>
Subject: Re: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <Y/XJ5RsH+uivVUlH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-17-yi.l.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230221034812.138051-17-yi.l.liu@intel.com>
X-ClientProxiedBy: SG2P153CA0013.APCP153.PROD.OUTLOOK.COM (2603:1096::23) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6038:EE_
X-MS-Office365-Filtering-Correlation-Id: 08224c01-5003-4a1f-e593-08db14ad27f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6QMKMZGft8SlgTk622SNPKXFzQWsLNBRp3BeprAx3PHMwCkQ4f5OXS6F8scfDktNjjGWbFCUam0kZpgdrl/BT+UTATpbqQUmQr6EWwahwBHqX6/Tn04Pmu8Tp2VIQtZqhav6rTZR3+NTeN8Eom+KHDMXVAWGAeDb7rEVRQYQi2M2z44ybJCxkWGg/xuYLLF6mDrFbXJscimxF9KY3jhrDmYX2c5xy3/fzoGG7gTXWgjM2KiuYk9Z9wqwhygrRwskteYPvse4YJM4aaza1THYB0wdJLhM0X9+hm4KytytVPmtEmBwz91IrHYGMoheXpoHtbzZUceQxquMOGr+hE0w3VYE46QWhOV/2iv1xwCeJz8ZkdC6awMm+R9snbg2oXtwAnd6Rapl5nNcwRYyFMd+L6LaCtE5dgTWrWkUX4nvOU9T06NY9jgEg8bRwG7SONCtQToRz9BLAbgbsvN9SsYufW8x/PtKDQwykzflIIBoIJLbK86zkOpwISt2JVXYMcbZR3Q8bibhKq1X2BymQMZA7RF0xQ56agszjx5SPnn8/NGznefTkqAqOGdFu8S67m1GrEN2e5d6qQjp8goi0PaLbYQe2JCsP6cPCEMrYc7lPXlZH4gKPr3+LISbx+FrQ+Z8yqyPIshf+S6zG7LSj6YXEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199018)(66476007)(8676002)(66556008)(4326008)(6486002)(66946007)(7416002)(54906003)(316002)(6636002)(8936002)(41300700001)(86362001)(478600001)(6666004)(6506007)(38100700002)(186003)(6512007)(26005)(2906002)(3450700001)(5660300002)(82960400001)(6862004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uzcu1eUj4VdzGDRTKf5FqW08xJIz8ZSpV9EPQEe4tLjDZETKXyufiddb8Tck?=
 =?us-ascii?Q?AMOoidtnDsZIVvg/TEv/hjYHyoPHzN2DrdpJdtHcyOhuzmB8xXFL1iObQvuS?=
 =?us-ascii?Q?+cCdD0SjqJqECpE4tkQy3U0Qly9IKrZ0Pff5Df9s1nwaZ1dgnDh3bw1GEmJ2?=
 =?us-ascii?Q?B+nkXUSRslApOTV4R9b7EQ9UbrnmYDki7IrglP0UTl8eUWI0Xo7j7QtAdfpy?=
 =?us-ascii?Q?/3nixjf6JhfIHdmQb3CdLd5Atux88v/Lnms6gcirA6fv+JbFwpb4hHloEd0L?=
 =?us-ascii?Q?ft2OHSqT+IJAwILU0tCzA4NVDcrhRy6ktnQX7AiCAMMG6uRAz8HFkqdTN4hU?=
 =?us-ascii?Q?MRl+yLUOXcs23lHay9S+HjdY6CeWxhuIVdJ6diOVXyZCUxpelrXSuIrUB6sG?=
 =?us-ascii?Q?h8Bk9lpCvyaWCYc6xmhkE9muruXa2Ekx3lrwaTd/MeVkvJAhrBknTuIid3u1?=
 =?us-ascii?Q?Iy3yr9nsMDCY0LCUiTvUkwLtis8gxJiwLznCrO7/M4z3zDZJhWxI83KWGJ29?=
 =?us-ascii?Q?2fFjvkXW3r85fqUxodsdSKwohs0+7pdOLAAHOixS9Bsd91D6BHoFke5fc49M?=
 =?us-ascii?Q?YuP/BxdPMa06u1LGnR5//xzgCxtNDCppzLJ5mso67ZnQ7+IxchMSWA/2v5Br?=
 =?us-ascii?Q?X9Rrg4Jb47UDoiN2uOIUhKHMF8Q33ZqMSABiLoThBYTLWdEJjMwE2u22dB7q?=
 =?us-ascii?Q?+H+nNwAEM+ErzinBi+TjtmEcJIdQCeS6Q5cjGX5uCpCm4Xy9KxJMjDLp/ods?=
 =?us-ascii?Q?hucNdpqjaWHdMis9GyrW3Vt+4SZb7WLD9bs5HGbiEz5OS9kbaaElr7ctJIJr?=
 =?us-ascii?Q?VjgwQVjBVkTFM87gcBdY70fOO3pHY4GAzTUtXqL6fWnevkk2kAINq38/vHHH?=
 =?us-ascii?Q?ZlUU9ea4IPNQjGh9HYMSiI4g3o52zZnINjRPn3Usa/QdaAf3WLX0MZrTJi8r?=
 =?us-ascii?Q?vTqGNYJnRLuyeyjBEQ0cujEh3b3nk2bRQHOpjSEMdsDsdhK4AgjAT38fN5bp?=
 =?us-ascii?Q?k6d0l5oJp6JVStuVkWCi+lKGlqnUKb1RH3yX3pRD9khFHmzytwg+D/DJyY/L?=
 =?us-ascii?Q?Ro/HNjbenSHAsVxYaaIJ01CdToPu+5cI8AE9STRMFj9dAYz7n+geVaDc3S+I?=
 =?us-ascii?Q?lx2MTCqJwn/CBwqeZbHoW41WibMPtu8yub4mLA8OFEFjQCIxe7NqLgGFm0CJ?=
 =?us-ascii?Q?jWXGqeKIhemr/0ObcsLX99/ZwxpYH2Qgs2sQ04/bCVo6/92tEvC/As8U4/9e?=
 =?us-ascii?Q?6QwgzmYvVbD+rTK8VyHaOgTjCuMp2tZHnHyUXUsyQ/SuR8JNRVQr/n0/3bK9?=
 =?us-ascii?Q?AbxyVPbZXbrzWroj5h/asXg1nuQXT/Mj+yEQtbcsmUYBHtRkA/KoQRtOs8uc?=
 =?us-ascii?Q?aianDHMwJPeB0EOuLoVsv1hws06fxcvCAkuRSh1+SUeDgbhWSBD9LCmLBPuw?=
 =?us-ascii?Q?C3lw4Vfr8z3eE+CRqvI8/7H3Xkj4+AoFQmiKE7XoCfIgyprphosdtrbG3Sew?=
 =?us-ascii?Q?vzvWBSiEavjIQOVDog17XlsORpJ5Sp/xz4k606JCPoriMm+9XvNCq1EtLGgo?=
 =?us-ascii?Q?Ea5NBeDUNbwBmaeZqMP/emOG3bG8IeiCvCQNr+YfQpsC24CyU+0anU1dUllT?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08224c01-5003-4a1f-e593-08db14ad27f6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 08:16:53.7790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCubrQm3IKRe2x09QQ81sETmwPf7g6W0985wCpUWI5GQRy6xlpgyNPLpKLGZM1AlkIuGzL9XnMZcp2hrSj8hAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6038
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 07:48:09PM -0800, Yi Liu wrote:
> This adds ioctl for userspace to bind device cdev fd to iommufd.
> 
>     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
> 			      control provided by the iommufd. open_device
> 			      op is called after bind_iommufd op.
> 			      VFIO no iommu mode is indicated by passing
> 			      a negative iommufd value.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 137 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        |  17 ++++-
>  drivers/vfio/vfio_main.c   |  30 ++++++--
>  include/linux/iommufd.h    |   6 ++
>  include/uapi/linux/vfio.h  |  34 +++++++++
>  5 files changed, 219 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 9e2c1ecaaf4f..be62f0a5687e 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -3,6 +3,7 @@
>   * Copyright (c) 2023 Intel Corporation.
>   */
>  #include <linux/vfio.h>
> +#include <linux/iommufd.h>
>  
>  #include "vfio.h"
>  
> @@ -45,6 +46,142 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>  	return ret;
>  }
>  
> +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> +{
> +	spin_lock(&df->kvm_ref_lock);
> +	if (!df->kvm)
> +		goto unlock;
> +
> +	_vfio_device_get_kvm_safe(df->device, df->kvm);
> +
> +unlock:
> +	spin_unlock(&df->kvm_ref_lock);
> +}
> +
> +void vfio_device_cdev_close(struct vfio_device_file *df)
> +{
> +	struct vfio_device *device = df->device;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	if (!smp_load_acquire(&df->access_granted)) {
> +		mutex_unlock(&device->dev_set->lock);
> +		return;
> +	}
> +	vfio_device_close(df);
> +	vfio_device_put_kvm(device);
> +	if (df->iommufd)
> +		iommufd_ctx_put(df->iommufd);
> +	mutex_unlock(&device->dev_set->lock);
> +	vfio_device_unblock_group(device);
> +}
> +
> +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				    unsigned long arg)
> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_bind_iommufd bind;
> +	struct iommufd_ctx *iommufd = NULL;
> +	struct fd f;
> +	unsigned long minsz;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
> +
> +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (bind.argsz < minsz || bind.flags)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;
> +
> +	ret = vfio_device_block_group(device);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	/*
> +	 * If already been bound to an iommufd, or already set noiommu
> +	 * then fail it.
> +	 */
> +	if (df->iommufd || df->noiommu) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/* iommufd < 0 means noiommu mode */
> +	if (bind.iommufd < 0) {
> +		if (!capable(CAP_SYS_RAWIO)) {
> +			ret = -EPERM;
> +			goto out_unlock;
> +		}
> +		df->noiommu = true;
> +	} else {
> +		f = fdget(bind.iommufd);
> +		if (!f.file) {
> +			ret = -EBADF;
> +			goto out_unlock;
> +		}
> +		iommufd = iommufd_ctx_from_file(f.file);
> +		if (IS_ERR(iommufd)) {
> +			ret = PTR_ERR(iommufd);
> +			goto out_put_file;
> +		}
> +	}
> +
> +	/*
> +	 * Before the device open, get the KVM pointer currently
> +	 * associated with the device file (if there is) and obtain a
> +	 * reference. This reference is held until device closed. Save
> +	 * the pointer in the device for use by drivers.
> +	 */
> +	vfio_device_get_kvm_safe(df);
> +
> +	df->iommufd = iommufd;
> +	ret = vfio_device_open(df, &bind.out_devid, NULL);
> +	if (ret)
> +		goto out_put_kvm;
> +
> +	ret = copy_to_user((void __user *)arg +
> +			   offsetofend(struct vfio_device_bind_iommufd, iommufd),
> +			   &bind.out_devid,
> +			   sizeof(bind.out_devid)) ? -EFAULT : 0;
> +	if (ret)
> +		goto out_close_device;
> +
> +	if (iommufd)
> +		fdput(f);
> +	else if (df->noiommu)
> +		dev_warn(device->dev, "vfio-noiommu device used by user "
> +			 "(%s:%d)\n", current->comm, task_pid_nr(current));
> +
> +	/*
> +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> +	 * read/write/mmap
> +	 */
> +	smp_store_release(&df->access_granted, true);
> +	mutex_unlock(&device->dev_set->lock);
> +
> +	return 0;
> +
> +out_close_device:
> +	vfio_device_close(df);
> +out_put_kvm:
> +	df->iommufd = NULL;
> +	df->noiommu = false;
> +	vfio_device_put_kvm(device);
> +out_put_file:
> +	if (iommufd) {
> +		iommufd_ctx_put(iommufd);
> +		fdput(f);
even if iommufd is NULL, still need to fdput(f) if f.file is true, right?

> +	}
> +out_unlock:
> +	mutex_unlock(&device->dev_set->lock);
> +	vfio_device_unblock_group(device);
> +	return ret;
> +}
> +
