Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9914573BC6A
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 18:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjFWQPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 12:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjFWQPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 12:15:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A40A19AF;
        Fri, 23 Jun 2023 09:15:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4Of5uGwmzvoXTs7Uc6puLcduOqtrUV7hW+zpxQTizELPiq8Waz/MPoVk80dyISZIsW8Yb/HGcz+EKOwUMLQF+NCXLSZfDs27kP3CvMRmDO0SFopKHnooRO/NwjT81mJOhejlFtzOvHcX+d1mhkKjJnU/bX7D7xsgTAMD2DQ4YSMH+Kx0jP0LwIAoTGsQ1FTlj7oCXytayvhQclw/rZ+XZOvBQrFbvVzeFv6IW0HCjlMOB+5jXhL7V6dA8e0OVROT5YPOAmehjLcdTHb9KLUN2bu6jbIHAHziBHoi1/fF8+AviFn4lGBPxudJGf01Bh/82xPmuwGhFqmxrWdBwxH0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KE0gQ+4Pru1RyntzAfMQetauYpaEGpod2YBMsrp1UKo=;
 b=RepW+KP8wYY+EcgF2f3s60SkI20DpSF7MGbLhSWcGs7AMH2cL4bzZBzt+tBa+/NmGsAZMCZuNReLvrK3zdbk6Jysvscz9My8ZyToWzLvzR4KbL9MkrtV/K7WceoLGfmBpaSClYOtPboibyrj05Nf1JC12U3l3q02QI+43eCJnmQTs/zAieqS5Ne9qtVq7n6yXMCOYfRW6yVvhsGUforKj1DnH6Q6F6Btih2QuT3hV9+82zincSBpHO2FHf2xTOuBC9aLLyqHBkFyv06xlxxU5z4HwdzK4Xzw0VlphiWdh5EsKzch7zecX1DZ0v9Mw1K6U4Igxcy7u1FmZTzGNot5IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KE0gQ+4Pru1RyntzAfMQetauYpaEGpod2YBMsrp1UKo=;
 b=f7nEClKjH1EjEvGfDx1dwBO9D3JEQp01wYkLA7OzHH4aaE9MRm/htWcafyewRRguOX/ut/a5kP5BZYIk1xBB1DqEoPsuaM2RMBwgTZjGpztgNprjqAVZgm4azStWO6y+nFDU6uRT9hgX3awPrC4CB40639zeeMb4h9UVzBz2FGKY9vLLSXbc+us4GFTMa2D8fzg/PmE/ObWfZJ+BF9hBrJ8IO/5hpkLZFLQQSRI/v/fM3CrppwCobItKhSgmfZSfBWHddKPeEwt7ogsz+eBsj/iPMa13qMB4kJcBP13HyMspOAVXGbhH+p/01VFRWDwqnsgS2Dn12tai1czeOaJjBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5263.namprd12.prod.outlook.com (2603:10b6:5:39b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 16:15:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 16:15:15 +0000
Date:   Fri, 23 Jun 2023 13:15:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZJXFEbmY7BOW6QIe@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-19-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-19-yi.l.liu@intel.com>
X-ClientProxiedBy: CH2PR18CA0026.namprd18.prod.outlook.com
 (2603:10b6:610:4f::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5263:EE_
X-MS-Office365-Filtering-Correlation-Id: 74b87056-eaae-4aad-104c-08db74050758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yyLIpZMVhID0X/x+6jivs2TcpYsR+LFF6GlS2QmvB+fYilZqlVSg7kMnb7r7mF6s0olXTgz2iM0jJgVq3Z+61CSN03QHKnRhrjGNbHJzswrVUt4hRSRYDApq5wEmicucuxAcwAZj8HB3+f2F0GsnRTWoosKUfN+OKET4h1T7DX66TP9cyvwUmWYqSbIbyRVyNaIhSVCh/vh6NE255jO2aDN0eiajv+bKB016glKqk2o5Ef++RaGwmR0vI7l/hjLtJUeltApVTf8IpRiCyu+7AcUo/Rn2cOCFaUgxTT0ahG3LLOfirK6KMNHv6rwQkJaNNxs594JJQJdZUYOhmQOliEtIb2DNsO9Mt7QxIKNDAZRDcCF6Zno/z0V7W2kISJYoh6/DyWUCMBSPL6pUZmYs5cNgH0EaQJVFqqdnfkySObPdgJyFpx3/i0OAyYIKX05LdpJslDAOpeBz4d0E+/2HFnB6lStRZ1udETucX/c3k9rExlpSKP7APpZO+T1tTdL2r6fQPphOaKF0jDsAgYiSFe0dYmPvi0UyY+Wo+19fJy5R4VQVjBFEqQx6N2DMv/RF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(316002)(83380400001)(41300700001)(7416002)(5660300002)(2906002)(8936002)(8676002)(36756003)(38100700002)(6506007)(6512007)(186003)(6486002)(26005)(66476007)(6916009)(66556008)(4326008)(66946007)(478600001)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D7i9q7GnDxnwcsHk/I/MPSJJ5cAv8h9CL94aKKtFDidJMUuDCLS2vRsSC22O?=
 =?us-ascii?Q?oOy6kzwLekfH9ftNsL1bPxY9ixr9tt7fh7N0+vaHiR031lhP33/b9wcsoy9N?=
 =?us-ascii?Q?bKjgL5ENs5HztQp/l4+RwZ19eWc4x1ZCEr+VSoce3hxLwAnxoWbW9OPkT43w?=
 =?us-ascii?Q?XxMUkckfblE37xZqmUuofN6x3M1fAlyJ/ACkjYi/PXiO0EWG4w29mu7ejHXH?=
 =?us-ascii?Q?NL7D+U1ke+k0On6waNtxiYuPUqBbP3oQtFMAxVADlQW+SJJ/sAxYW7iYEZZo?=
 =?us-ascii?Q?7g5+vOWUD6XZDpEOKP3QwnlUBLsdRlTPxFoUhNUi5djYDLwIvnHUCuWmevMe?=
 =?us-ascii?Q?bXvfgYsB0VoZarUqcDCushC12EtSF1ETILPmGwgKc6aThi6H+jxCIhmLWDVF?=
 =?us-ascii?Q?QVWYSbJ5GJcNUriokPOmYxEHbQZEx25+cXjbNlyFMZuuJH4tDd76WFswu/aF?=
 =?us-ascii?Q?E8yKmQRp+S+9cUHJpBFsw7Ov4VtXVZvAJfhb8G4IzG3hNztdeE18ZNIP+7ki?=
 =?us-ascii?Q?FajAy5+6NT7igeEwjyNFncGY/WhIOyeMIYznfD3A4NIF1WCKmv7IjatJXJEX?=
 =?us-ascii?Q?Bv/hbhNvmp8LZbPFtWb9wXdjWSOuohzNTqWzd+eEFIKfy/DnjWb/MDEgt5JO?=
 =?us-ascii?Q?CXLoc/ZYqm2oZbQDvbzVIr3fc5sIfBqgXXexp7286y0vFcEkGrkHJ3gg5BRh?=
 =?us-ascii?Q?VfmRfFiAG8ru7z3LeYsBtaX4oMEfZUoppPN4Rz6xbBEVNG1uuMSXo+NUaTjC?=
 =?us-ascii?Q?NGjwKJjMQoRuF99sM/mF6TLeS4J6Yw04O7hKKoJeRPCQvlPHln5KokHIlwUG?=
 =?us-ascii?Q?uSRnO6F1FkGkwRvdwmgP9OXwaTWaOTDRf5nBgs1DF+hoR7Vn6wW4RZ4Cxubp?=
 =?us-ascii?Q?Mq+Cua5I5IXaoxTJQCMA37oM4eES4mNlBtjc8/h3gMjT7IdyUe0VC6Duuc5L?=
 =?us-ascii?Q?qSUWRRIaMqfrqzZAxMtrOukuV+dAlJ4Bo5+56da6eTwDhrc254DdzxZSLeGl?=
 =?us-ascii?Q?ljStafeYjmahlF9VmahLhexJT/d5Lpp+1v7uVbpGLuXD/wEuVAvJkCxBVpx3?=
 =?us-ascii?Q?L7e5ZQ0QuQJEvIl6tVLhF6Iqt+vdyTDwt3E/OJMLKPNBLEfMlJq7oT0bZ5Uz?=
 =?us-ascii?Q?t6au8HHXbUIibN0Etmg9Y5upSCVKplICLW6ceXBE7L7997n9zsW4KYH3rgc0?=
 =?us-ascii?Q?UDL/J9xhvlP50VbTjBg9js835SO/N+n7MsuKP/hU6QacZL9T3ZcmBznqnKq5?=
 =?us-ascii?Q?D1rkUEEW9GO6Bvfrbkvc1p/NWdzh1eYyvEitJPdhLannMSK0yi6DSEInSQP5?=
 =?us-ascii?Q?h0vxoxsyvdC08cZkg1Y4POGN9F7Q5xW1zfa0Na+2Ex/Ux5g5xa2pSJnnfJny?=
 =?us-ascii?Q?Rj5SROYOkNYuFCsdVWaZi0TxxO7ErotzohjnxU7c94/fMVVH87CpjbU3/HvS?=
 =?us-ascii?Q?z+DzHj7vkhw3dHiapmHKvq716YmSdym81u93bAEQl/mpSPkDarw4Hhf642LK?=
 =?us-ascii?Q?TOqzsCb7GiqrW8tD66RyXpLEfPGJmOWo6hXYxTmO+V8PjEYCTQ2JlcrFLrqD?=
 =?us-ascii?Q?iPxi9U6uFtWGksDgvLpZD4Syx/L7b+D2lCBSAcFI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b87056-eaae-4aad-104c-08db74050758
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:15:15.1299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5etcg6e6dK9zBPJg4LwANdRNShG4/iQSTNji5RkzHMndZaeNG6VQDDHKrdZQ3acS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5263
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:16:47AM -0700, Yi Liu wrote:
> This adds ioctl for userspace to bind device cdev fd to iommufd.
> 
>     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
> 			      control provided by the iommufd. open_device
> 			      op is called after bind_iommufd op.
> 
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 123 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        |  13 ++++
>  drivers/vfio/vfio_main.c   |   5 ++
>  include/linux/vfio.h       |   3 +-
>  include/uapi/linux/vfio.h  |  27 ++++++++
>  5 files changed, 170 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 1c640016a824..a4498ddbe774 100644
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
> @@ -44,6 +45,128 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>  	return ret;
>  }
>  
> +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> +{
> +	spin_lock(&df->kvm_ref_lock);
> +	if (df->kvm)
> +		_vfio_device_get_kvm_safe(df->device, df->kvm);
> +	spin_unlock(&df->kvm_ref_lock);
> +}

I'm surprised symbol_get() can be called from a spinlock, but it sure
looks like it can..

Also moving the if kvm is null test into _vfio_device_get_kvm_safe()
will save a few lines.

Also shouldn't be called _vfio_device...

> +void vfio_df_cdev_close(struct vfio_device_file *df)
> +{
> +	struct vfio_device *device = df->device;
> +
> +	/*
> +	 * In the time of close, there is no contention with another one
> +	 * changing this flag.  So read df->access_granted without lock
> +	 * and no smp_load_acquire() is ok.
> +	 */
> +	if (!df->access_granted)
> +		return;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	vfio_df_close(df);
> +	vfio_device_put_kvm(device);
> +	iommufd_ctx_put(df->iommufd);
> +	device->cdev_opened = false;
> +	mutex_unlock(&device->dev_set->lock);
> +	vfio_device_unblock_group(device);
> +}

Lets call this vfio_df_unbind_iommufd() and put it near
vfio_df_ioctl_bind_iommufd()

> static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)

This can probably be an iommufd function:
  iommufd_ctx_from_fd(int fd)

> +long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				struct vfio_device_bind_iommufd __user *arg)
> +{
> +	ret = copy_to_user(&arg->out_devid, &df->devid,
> +			   sizeof(df->devid)) ? -EFAULT : 0;
> +	if (ret)
> +		goto out_close_device;
> +
> +	/*
> +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> +	 * read/write/mmap
> +	 */
> +	smp_store_release(&df->access_granted, true);
> +	device->cdev_opened = true;

Move the cdev_opened up above the release just for consistency.

Jason
