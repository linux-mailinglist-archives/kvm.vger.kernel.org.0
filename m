Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FF86A49F1
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 19:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjB0Sjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 13:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjB0Sje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 13:39:34 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1F31C325;
        Mon, 27 Feb 2023 10:39:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7gG+2VQxWNdUZEPoZm+wClHo1ICigu0qDlw3a6P6XfeY85d2qJ0H1+IRJiOSSo38RXNNZJpXmqSHWpA72sHaZTwfopnFVho17Ju2APZg85xORpMQXDVP3PAdAM8tVippjnJQB2u+mgDMnbvZh0LVfElM64PKc74wwBOYmoZq06Vy90TBhGp7jZTohWpOsJp2X0lyOHe/LSWA/Ihexce6ndhRMa8RVsrPc7kBg8x1/45iw5Eck7qoumDKg4IaCQwzR3IKMJn9HQJwhoFEb46UPlfF6i56/8wpKhoRD9VGzJ36XgQabvs8syeyDnKhHC5okZsHVqar9b30qcijtkaDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZKXQHTLwRsBQWyKaIbdxOPRv97QirQr+eiqATR1Xs4=;
 b=jhafSn4WBm0rFBfNcg2tulTKMSMZkvt+r1YFefuqgpLXksUhEg9IhpOAgl1lnCbr9IsT5clrYBDxF8OyR0ycexgHl8aoun0nBsYNMr2/ec1bgIIdCAAG74xXaYOo9ZSXMgg1K3+Wopp2RHBJkKvHIEYMF8Zvo70jgIid6ddgzoAvck+cgJ9Ge1Ru2wAtHUnOdfqxzLhzsPECuQmw/QPDrEhgJXlvSygpYGPB0Iq5yXI0LsjULIjE5/+J20w0cjqJt/tt/MwmqT28W65BDUA4Y4utxIJXbtnFbA/wz5G/RIgqeBP4CJeVwM7n2tvIUwiwwhS8icgCAI+XNHGQHfwXRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZKXQHTLwRsBQWyKaIbdxOPRv97QirQr+eiqATR1Xs4=;
 b=ZAJCKP32bSX4tO8YoyRRxbnZbv9YJekzYoJT/emiQyXAb7/92MJbWUsnFSrBeHVwHjnO4YpHdq0aydHy+jtxGJ4sUQmbkxJO/ekhkqIl7vZHKL0u4F+4VBuYmHIJlfAxwjFjneQrgAM0CdKzLpHN0Z0+sptjnd/hIYVSRmJ5jAFKKMVyGnqdLun5cINiEMxFx9aQNaPrw5zVDSvJXoGyeVeBmbRU+GZ78GZEEV77DyDBGGwZniYOmmoZ/COQF6PqV2+FgdSXjHbBagJcFXQu99bi2uDloOXBHgxWW6bP62qen9O+0dnJC6K8bch8n1E7kKfppwhYZMiC8qA+D5+oLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6850.namprd12.prod.outlook.com (2603:10b6:303:20d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Mon, 27 Feb
 2023 18:39:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 18:39:17 +0000
Date:   Mon, 27 Feb 2023 14:39:15 -0400
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Message-ID: <Y/z400uzn7Nk0CXe@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-18-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-18-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR11CA0022.namprd11.prod.outlook.com
 (2603:10b6:208:23b::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6850:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e964309-1578-4ec1-51da-08db18f1ee85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wEUm9QeSmLZpqp6X5k43mBw1gvaKKCwl2jbAXKr4h43GNEYjQsgsDzmrmM602GkbWrhVX6HFBp3gpbjn9HFSs5XDoAVQoQvKz3nU9+2sKp0FZWXiw33tfoT6pPGZFlGZmm687yBbww4KX6qF73S4XFNU1W7iCqZGcVkQTeum/9qArAI7ExRKUdH/UL/VtwWImuVi0wlTMm3BS2bx8qpqwlsLBlaVdIAXvTEcb5kqTBgvl6GbPnPgmEWHHqwunb57jNU3YQWz7nZflGGDv7bHVN2usKQ2WO+SbGXzkASHNhUNQ42oCF3/xjRiPVD9ODiS2gMPjCQNMkITiTQxppA0BuiIcA+5a4cAWHmpsqew5LcmyAN883cJ6qJ07Jm11cBOROoqtc5ozLYXcVLK+RKGlXf2xUMmbwbAHB/ohhpYyUPzYN4C2h6XC3MfB5obuwUQ4YfrnC5b1fV26a+KxJXZsZnrAetUp/QFElkFtRkr9eH4AyjfyUl99+xKDdyIDjpiSxgfiUSNoVBsspRB3wQuHPbwlVzg9dZHyknpQaYHv8Qn3bmZvBvTJunPVcVNC02kXhI4JgF2XJGIEclYK5OKY9lYcMLZT33MUbzAN60/8GqPxiVkHC7V5ci5kiX1NfZZ3uV4p5Nz4ua6bKtX4btMPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199018)(41300700001)(7416002)(6512007)(186003)(66946007)(8936002)(6506007)(2906002)(26005)(5660300002)(8676002)(38100700002)(2616005)(36756003)(478600001)(6916009)(6486002)(86362001)(316002)(66476007)(66556008)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MOyJzNxcltZE5zeljiWnqopzGm3MK2efhPYtwr/mixI7KdO2Q7R1i5h88pr/?=
 =?us-ascii?Q?GwPsTIiwkNELajTjH8Wnc+BeFJXGmtvyWIj2YsTYNSkWdNUHG1N1vP5jUFIO?=
 =?us-ascii?Q?lZkx4K/1nFDMWwh2GZi/IaUsiMk7Z0EKNLXfw3xhrDumThXcu6bNQFBrgqVS?=
 =?us-ascii?Q?fFXjra5AF67SEtI0a6/WZl684Ix2Y8mRrbDntf/3ewUMlC72FKpbX9H1gr78?=
 =?us-ascii?Q?nVeAejVjkvmI7ZB+Wp6fhXOWx8k5f+gs6hA3WYQhN/7zxkjXgBBDCVAk1m5i?=
 =?us-ascii?Q?ro5cwqXgGanUxy/DTS9I3sVkACN6Jli+wVIlDKlCDMQpdfIacWCj6FHs4+6h?=
 =?us-ascii?Q?ScX6cduNzZN9tEbcQ3BCvJMlfazvLQ4iljAztyXhXIWHN9CwKMZAB6Mzu2lR?=
 =?us-ascii?Q?Po6ZLAXiCBfFS0qDtCrDzkxIqxuAuUiIZV0MCuYv2PscG1LCUNv9lPoLbbnQ?=
 =?us-ascii?Q?QVhbtmWz3qRwp7iFsu71sF8WCwIkY2tV9tw4GBgGzWOl2nT2c4ECbOLCAs5Y?=
 =?us-ascii?Q?bWHIlLQK5R0lMDrnXCd2cHx/nepU1mTDHYEpW6Omk8QMbjqGrAzIw3lZ65fu?=
 =?us-ascii?Q?NWOeWiqDXzDIC71MHRgLgNVHY+5IXz4ueWfpzDuSp5DcKyRkotDvryEL4NqQ?=
 =?us-ascii?Q?g2vaS0Cfq+pGvyACrVjUilhtUsl0F2H0G5xRJpyG+uUXOH2Isymwd0Jrjrkt?=
 =?us-ascii?Q?XoL3I5t8ixOT2ZtSQkdT3jZyWmQD7IQ+NrIq9uwhHXeIvY0OaKrUFd0tuYGC?=
 =?us-ascii?Q?b51RZCkTKrmcLwL4xrWbf+qWEgrtxFTA57eYjWdLTNLddxpLGLn3/l5lb2Gu?=
 =?us-ascii?Q?JTeLEfigmSlJHkazbfJ2M4S8p13bTtEYQ+4/ajO7QiLG6oUe5unKaJp7SiEW?=
 =?us-ascii?Q?A8LxkrSk7g9mXJrW2k8teGIT5abeT5iDEt2JBGdVsPcJ1A3I4ilZEmJQImiw?=
 =?us-ascii?Q?oPjf6l4dvAuiTSdkbu6pNE4JGd7CvBmA+5mBtI8BoUxFS1lZHJVfbPfSTCHV?=
 =?us-ascii?Q?0DgY/33qAMQAXyxpxWzlVlmMFegFqffVKqYj3MYziiENIwHzQEvRfl7+LHBk?=
 =?us-ascii?Q?mRAI7lIwi5j5Pp+0IMPY2pRaBtVe7mGcqSjb9NyivkH2N0PTgn7E+jO162qR?=
 =?us-ascii?Q?AX7MEaiWoGlw9AVusui6SqEjkAyVqkPThVARv8/mcVlRYx9OVeGdgu71wsZw?=
 =?us-ascii?Q?9Ihf4PO9he2n46pabhIpaKYaCAmGrKee+WZYpNstFSuhEHJ4s7XXYFo+8gZB?=
 =?us-ascii?Q?AXZUP3ixAJaSBUhaWPGtCnQkm/sIecF7Pcz7fHZ1+4fA3GJK3qGogQkf6TAI?=
 =?us-ascii?Q?Zdi7LHpKVEaBzYxxxWUdPO0q/VRsu8iTtB2t+2p5RoUBPlaPeuy9n/RfN+WQ?=
 =?us-ascii?Q?i9O/BQLYZBmRkGei54RhuMnTu4tYupNK2MxidsfI60NtVwDzsDDjxYQBU+Zm?=
 =?us-ascii?Q?j2FVWqPtcsDP/mlNZ2GJWkJGigzDJhSf6Cp575vNouucQVALUcu14THLv19A?=
 =?us-ascii?Q?Cx1ck9npnt606IrQNneNvci1bfFMRV7N40tk5ZbqkE2ZQjvd2h6tlWb/aLY9?=
 =?us-ascii?Q?3R0bQ+z/Msch3JhjX+cUlKsz81UallV6yTVp/W3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e964309-1578-4ec1-51da-08db18f1ee85
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 18:39:17.2987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sEHRIgGhp5VwqKf1dvZfRQ6qKOOm+5F1iNyS12wG6LdvSL+7QoMpFkiRxtW4RqH0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6850
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:33AM -0800, Yi Liu wrote:
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
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 76 ++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        | 16 ++++++++
>  drivers/vfio/vfio_main.c   |  8 ++++
>  include/uapi/linux/vfio.h  | 52 ++++++++++++++++++++++++++
>  4 files changed, 152 insertions(+)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 37f80e368551..5b5a249a6612 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -191,6 +191,82 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
>  	return ret;
>  }
>  
> +int vfio_ioctl_device_attach(struct vfio_device_file *df,
> +			     void __user *arg)

This should be

struct vfio_device_attach_iommufd_pt __user *arg

> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_attach_iommufd_pt attach;
> +	unsigned long minsz;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> +
> +	if (copy_from_user(&attach, (void __user *)arg, minsz))

No cast

> +		return -EFAULT;
> +
> +	if (attach.argsz < minsz || attach.flags ||
> +	    attach.pt_id == IOMMUFD_INVALID_ID)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	if (df->noiommu) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	ret = device->ops->attach_ioas(device, &attach.pt_id);
> +	if (ret)
> +		goto out_unlock;
> +
> +	ret = copy_to_user((void __user *)arg +
> +			   offsetofend(struct vfio_device_attach_iommufd_pt, flags),

This should just be &arg->flags

> +			   &attach.pt_id,
> +			   sizeof(attach.pt_id)) ? -EFAULT : 0;

Also:

static_assert(__same_type(arg->flags), attach.pt_id);

> +	if (ret)
> +		goto out_detach;
> +	mutex_unlock(&device->dev_set->lock);
> +
> +	return 0;
> +
> +out_detach:
> +	device->ops->detach_ioas(device);


> +out_unlock:
> +	mutex_unlock(&device->dev_set->lock);
> +	return ret;
> +}
> +
> +int vfio_ioctl_device_detach(struct vfio_device_file *df,
> +			     void __user *arg)
> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_detach_iommufd_pt detach;
> +	unsigned long minsz;
> +
> +	minsz = offsetofend(struct vfio_device_detach_iommufd_pt, flags);
> +
> +	if (copy_from_user(&detach, (void __user *)arg, minsz))
> +		return -EFAULT;

Same comments here

> +
> +	if (detach.argsz < minsz || detach.flags)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	if (df->noiommu) {
> +		mutex_unlock(&device->dev_set->lock);
> +		return -EINVAL;
> +	}

This seems strange. no iommu mode should have a NULL dev->iommufctx.
Why do we have a df->noiommu at all?

Jason
