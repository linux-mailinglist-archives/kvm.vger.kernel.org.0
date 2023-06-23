Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311C373BC76
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjFWQWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 12:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbjFWQWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 12:22:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A53F271B;
        Fri, 23 Jun 2023 09:22:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtkfSw4BLQ44fBq0H6WEYOQ0Q/YCgR+CpgGtfVZ7mnZk4pdW64da8t59WkrazgAeRJTMG/DGYLvhyHj15H48mNyLicxx41QNlXWgjKEvpkO6EIY4OqsxhcJFJlJ+Mqgb5wBzIaluF677E5naba1by2OpqynKMQ6hGnLfEIpaDagkpFflhdRHdOJdoh45A234307nmh25b2xuaepXAhZxxc6J/YmDifjeBeBX7Fi6TTTJYB1LE/JAmKcbTQFxVYd9GcbATJ0TGbgI4t4AMPepKJrj7PIWX3H6HxD+3ucaxp3/gjGaRTCEVJRkG24bdGFm4Rfnz5IlxLbZvRjUA6fG1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zF2hO4y+553CjxSehCv/cY3joZ9NHP19QXSdi5m2Ccs=;
 b=T0z0MS7HAEwlTnHGSf+RETob3gXXL2kWtQCPK9zpSoDRUCtVwhjmS36wdCJrnteYyoSzmFciSOAq6I5pdp/J2RW/k4AVLFG3L1K4ztQ0GNcuR9pgg1a+kvsHg3Yi1otxBAiSpcGKgNWsoXHespQsU1O1/PPLncN1VOI6O4pL9FQWUmdl2bx6jzP5smHhk632Zw/HyJR/4QQSl3njh23RXZxJzmHCr+ncbFaeS76dVTeqgXuWWL/Iu+s831xAA4Ie9n8COw+nMxT5hxe00/ZEnE0ybY4ymLNk/SxJKbLpJN9G6dhddruRXubrOVWWJ3PyquU7itfpHx+pWi6vQGAxcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zF2hO4y+553CjxSehCv/cY3joZ9NHP19QXSdi5m2Ccs=;
 b=oKNxIe4/veBN9WDFk0ISLKzNtUjUjzcJNOJPDUoX0fYTs80z5HPApw6WHRgjL4WZyEVgraUOxbW0mF8Tc99l8gApoAW1GlA43U47XUNzMbtyh5Rj9v+djn38j7PsqKRedtJhDfIfcfRPwJVcyUrLlb0ZHEAO7SliIshnkcjweqMiWGl3TeRRJTsPYRkYeeUhbJz6yngE/J/v1dAYOIfhQ9e2sbNE91l289QrsJ5iLlxShtoMv5e4VWHl8vsbaqvRyziRwaucLrEwdD+NBrQ94E7l4NU/CSlZ5abenrs/XZN+M0j3n2/qEWKvvnMfgFVlTqCni8x4iA8UJlj0sIufig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5897.namprd12.prod.outlook.com (2603:10b6:208:395::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Fri, 23 Jun
 2023 16:22:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 16:22:01 +0000
Date:   Fri, 23 Jun 2023 13:21:59 -0300
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
Subject: Re: [PATCH v12 19/24] vfio: Add VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT
Message-ID: <ZJXGp6tlSe+oA01s@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-20-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-20-yi.l.liu@intel.com>
X-ClientProxiedBy: CH2PR12CA0021.namprd12.prod.outlook.com
 (2603:10b6:610:57::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5897:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e044a34-a573-4ed9-8240-08db7405f954
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1m2qhCtSewVXPDz/V8v86rJCD8yW7vrC0JiflZJIUS0GFi2irq/SX9bzgEFzgFti42iR+7L4St9D+Qu++Pdwzxjx4EnUd8mfMoTWK8sDoipFv4hHZPV8H8PYmQ8Si4E7d7TUA7VaGj91IVtMcXrF/ZpT6y3evp0lIXtZ/Y3L4B1aY1BBUj4UVRfJzyejaGjKnEstY6OO1EvoKU22sZ17HGQtTsWqWj2gsQik3kDf0OpBVBBb+mYkkjXWrvMNh8xtzfBq5MrSI1tXPtvbka04dm9ZrV/3uIsQeLoD9S0udeA8qFsNpwdbQz1IM5EJl8mMKY2SY27RR5PDBgERPo370DBw1ZG+imc/aVL6WiraGVEVw5upn79zrSWm0W2mM/I54anKE/t6lRQaGkPA1srCjB+3Ev2a5Fxlvh/wNeEJKoqUxwxhytjQRFT0rRryIlAc56uHkVpTJEvLoFD8rEo3K5VT2IoOGQPgmvc/rekupJ5+aK8qmFxoWY3O+3SPJAPv8zAYUlBfRkNwpFsDPK3gcK3AvAqNRZls01T8ypbxnH9mL8xBpvKx8Z00cTzgM63BV7xb1Cii1zIxUnn/fEzKuNxcOYMLmOXYYuaAMS1iW85C6OAx8apSbaLlHF9YdGjA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199021)(6486002)(478600001)(83380400001)(2616005)(186003)(26005)(6512007)(36756003)(38100700002)(86362001)(6506007)(8676002)(5660300002)(2906002)(316002)(41300700001)(4326008)(6916009)(8936002)(66476007)(66556008)(66946007)(7416002)(83133001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bMJzotKm/zpUWFH7pEnTSD/cyO9Ta1dMsMNinsiR+eY2Ee5ly94BD7ApE8cf?=
 =?us-ascii?Q?/55qJyshvWYg/N0KARo4+ru7AsmCgYZTOd+t55pRU9ZioePBKB6CZXuIiPob?=
 =?us-ascii?Q?k+ynocIMtw3lOWxYz4F4ErhQzgdaM29u/0BJeKs79k0dhpCjXajZjFIoCzU8?=
 =?us-ascii?Q?9cPbrjAAN/VRa7LN9OVJj45YkdEU5K7lA8fbbFs0TSBHBMDBtZHzBM2BMlxk?=
 =?us-ascii?Q?qucEVPDr0ZY+mPaWj9EMjwNPET6PtPt+IMG+TGzkEAoGSh26mFL0nr99Rd4c?=
 =?us-ascii?Q?1xqCvkmVAHU5icl0vn/qLwtDej8q7A8QEmJRlmGQ5wOZxLewVqjrRLamiN9+?=
 =?us-ascii?Q?Obr5h0QhSNjOT8evx3OOGIxMEY0U7zoaXGHKOCmlYl9qst/Kyt9iWJ1g/VMW?=
 =?us-ascii?Q?fvbDY0ibJNeac91qXCPa4sqcrUy+yHTyZ/8fALmrxitEHc6fIVQaleiUoICu?=
 =?us-ascii?Q?3RjtPF5z13lUrOWJgGBooAx3LaC/W01LAj9xaLY4af+eJ75+alOXCmKKt810?=
 =?us-ascii?Q?9rWAorv0zUQfmWYa39dfJvGgYf9jzkaGRnr3lw36YmEn/LDrNfJ5OcfOURGQ?=
 =?us-ascii?Q?Rn0enc/8twrZVrJk0vZFoOfVkTVdfLcuEmNPQCsOdRi27y7Xpk+CpdT/hjLm?=
 =?us-ascii?Q?xiET/vgXgMrE0yONqhlg3BZ6ccNJAIHLF9bdiBd2cOx9fhmLsRZJHf4t/PkR?=
 =?us-ascii?Q?oVs50v2gOxeghfjM3jt1JTauRhd77qNEjADZfZfCh36O0Ppc0IvNNyJgMRXA?=
 =?us-ascii?Q?0aso0qcaCoiG3GuriFhD2xG/1ZXqjNh+qcTDN7dnUZaB7gtBgKST7D1jJQjQ?=
 =?us-ascii?Q?0XmKyyOoRExSl6OGsnLxfTQYMpwZG4Zh4V0yd7xr2bzcoOZPnoAyJ+hbS6rc?=
 =?us-ascii?Q?Pe2lqJm51oV2K143qjTZ/b3aGLTOf3yG9RaFRYb/BzWl/3V1wvT+tfwlobe0?=
 =?us-ascii?Q?VXFu/X/dy1GeSTLnGc3cb2KT7KfWjhQjzxTYru5pB/U5YKi1e0A1olUXYhty?=
 =?us-ascii?Q?TvaE4CW75PQ2wc9g1Xmzplfbhm0GclJM0OG+QXJ+sx5HsbSwWCoQLBKtJEMW?=
 =?us-ascii?Q?7sA0ivKcyF9jhST88SSgogGDetDP18OyhxEq0UHpPj5Ewt9L8wvFUT90X4fs?=
 =?us-ascii?Q?ZMGD/vkuqI4x1/JhtEVbTn+zqOzHn/pbo8yBKbDmaKpo9Jyl01bUUmbvWzIO?=
 =?us-ascii?Q?3y6Y62D5A9N9p/iKQHJIpNov988mrzx98bwcA+fMgF/g+Xq6QAiuA7ShcNID?=
 =?us-ascii?Q?eZUevQTpHO6xM+zFKnpUuyo6mv3Px0hD1KNu+vjvzBhRWaly7FhNx77oa/Sw?=
 =?us-ascii?Q?i+PKEi0VXfX860FZuFDfei/O3az8Ao4FGDtzURCnHk6KISyb9slire/djJqC?=
 =?us-ascii?Q?9IZLYd42LKhPc9yOyP7vVc+KzRoc35ddnTKv/NxJ/1gBtC+Awi3GNj5GzKiw?=
 =?us-ascii?Q?QZ+J3LZsxBaUr8Q0p2o4FscDQJkz7yXdwJXp/dv4i1mgXv4+ZXkk8m7gKlzO?=
 =?us-ascii?Q?HI6mKE5385Z6K9zxLgy451lpf+3M1nCcx1gueDePxpxRpcDCCNgnTyBTD4f0?=
 =?us-ascii?Q?R7XozpZJtPDZ/mnDXBCN/XvXFlAJJsehKaYOco/t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e044a34-a573-4ed9-8240-08db7405f954
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:22:01.1340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5elJlC5IN7FY33bBJZrk2i3+6AEhOBEArCk/F7WHxkBWXfGKSFAiwUs6SIpSDzCJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5897
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

On Fri, Jun 02, 2023 at 05:16:48AM -0700, Yi Liu wrote:
> This adds ioctl for userspace to attach device cdev fd to and detach
> from IOAS/hw_pagetable managed by iommufd.
> 
>     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach vfio device to IOAS, hw_pagetable
> 				   managed by iommufd. Attach can be
> 				   undo by VFIO_DEVICE_DETACH_IOMMUFD_PT
> 				   or device fd close.
>     VFIO_DEVICE_DETACH_IOMMUFD_PT: detach vfio device from the current attached
> 				   IOAS or hw_pagetable managed by iommufd.
> 
> noiommu devices do not support [AT|DE]TACH, if user invokes the two ioctls
> on such devices, shall fail.

Stale comment

> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 66 ++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        | 16 +++++++++
>  drivers/vfio/vfio_main.c   |  8 +++++
>  include/uapi/linux/vfio.h  | 42 ++++++++++++++++++++++++
>  4 files changed, 132 insertions(+)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index a4498ddbe774..6e1d499ee160 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -167,6 +167,72 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>  	return ret;
>  }
>  
> +int vfio_df_ioctl_attach_pt(struct vfio_device_file *df,
> +			    struct vfio_device_attach_iommufd_pt __user *arg)
> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_attach_iommufd_pt attach;
> +	unsigned long minsz;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> +
> +	if (copy_from_user(&attach, arg, minsz))
> +		return -EFAULT;
> +
> +	if (attach.argsz < minsz || attach.flags)
> +		return -EINVAL;
> +
> +	/* ATTACH only allowed for cdev fds */
> +	if (df->group)
> +		return -EINVAL;

I feel like vfio_device_fops_unl_ioctl() should do these group tests
for the whole lot

@@ -1187,19 +1187,24 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
        if (ret)
                return ret;
 
+       /* cdev only ioctls */
+       if (IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) && !df->group) {
+               switch (cmd) {
+               case VFIO_DEVICE_ATTACH_IOMMUFD_PT:
+                       ret = vfio_df_ioctl_attach_pt(df, (void __user *)arg);
+                       goto out;
+
+               case VFIO_DEVICE_DETACH_IOMMUFD_PT:
+                       ret = vfio_df_ioctl_detach_pt(df, (void __user *)arg);
+                       goto out;
+               }
+       }
+
        switch (cmd) {
        case VFIO_DEVICE_FEATURE:
                ret = vfio_ioctl_device_feature(device, (void __user *)arg);
                break;
 
-       case VFIO_DEVICE_ATTACH_IOMMUFD_PT:
-               ret = vfio_df_ioctl_attach_pt(df, (void __user *)arg);
-               break;
-
-       case VFIO_DEVICE_DETACH_IOMMUFD_PT:
-               ret = vfio_df_ioctl_detach_pt(df, (void __user *)arg);
-               break;
-
        default:
                if (unlikely(!device->ops->ioctl))
                        ret = -EINVAL;

And also make a local var for void __user * to avoid the repeated
casts.

Also this construction avoids the stub static inlines since the
IS_ENABLED will compile out the call. Just use a normal function
prototype outside any ifdef.

> +
> +	mutex_lock(&device->dev_set->lock);
> +	ret = device->ops->attach_ioas(device, &attach.pt_id);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret = copy_to_user(&arg->pt_id, &attach.pt_id,
> +			   sizeof(attach.pt_id)) ? -EFAULT : 0;
> +	if (ret)
> +		goto out_detach;

Don't use the ?:

if (copy_to_user()..) {
    ret = -EFAULT;
    goto out_detach;
}

Jason
