Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7461728B11
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 00:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbjFHW1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 18:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjFHW1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 18:27:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111B826BA
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 15:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686263224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+i3hbSxCtGfqeGfoJw1Ae6QO7FGXzU3FKdQTLPV41wM=;
        b=aU+onGZArlQ3pqr1UgpL4XOSfKVCbYjhFzy0OqCSwnvqErKVqju1ZzGPXMrEVs9OAKhVsk
        8WIv2l+1nf4Kqrl1nO0nPHuMw1b8Pt25urxeAiQaldp2GhBFkrsoNjV/eIlRxjQLDUE1VK
        5ETvQZpnZr4SVOr0959S8qDqySOhhtE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-ALxLsLnWM0CSgHCH_aBLyA-1; Thu, 08 Jun 2023 18:27:02 -0400
X-MC-Unique: ALxLsLnWM0CSgHCH_aBLyA-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77751dc936eso102430839f.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 15:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686263222; x=1688855222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+i3hbSxCtGfqeGfoJw1Ae6QO7FGXzU3FKdQTLPV41wM=;
        b=aC66W+0Mt98VDk0apdLYqlWF35FbmqV8Fk8p8erOJQBLTWGc/uAiZCJ0y2NAF48XsY
         pelqQ1UzvJcXWHMcAUHLjz/IQIDM290mvezfTbJoV9ESarz8lX7UnSquVc6u0zQ8piR4
         9+0tHpHVsibArBTDwtek71p0TTjHppR5e3EPCqF8Wt+ot5rBSLTYmIdghcTpC0MtOfqE
         /Mu2gt+jndOdlAVjOkGuq0FWc5+YWckfTTkHYGZatRxCz/ZnCBRfarLP0fQz1wUEFzUH
         nKW7Wr9E7AC43vMzTY8vyV5ERC+8utu9n8TCBfMaZ4DruZiKWDPe8bMNMCGZHXRPekFw
         KjQw==
X-Gm-Message-State: AC+VfDwdjB+a5ulksNEnthr7XPCmltyfKLgV7Jfg2zp+vFCUm7h3bDwd
        ksgmbVEF1EAojq64p/1IP7MTh3a4mcHveCh9AFY2NKxH8Wq0cGrRLUuHJE9n5dX6YgHJyi3udr6
        xKrU7aTdKdlTm
X-Received: by 2002:a5e:834d:0:b0:775:5f74:f4c7 with SMTP id y13-20020a5e834d000000b007755f74f4c7mr15105446iom.17.1686263221764;
        Thu, 08 Jun 2023 15:27:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5fIcaWd14KZySkBjd3YmCC4QO0Lm7VbUcjSZolTnee5AtLfgxh8+xxsSHDnIlQUk0qvjp0mg==
X-Received: by 2002:a5e:834d:0:b0:775:5f74:f4c7 with SMTP id y13-20020a5e834d000000b007755f74f4c7mr15105411iom.17.1686263221294;
        Thu, 08 Jun 2023 15:27:01 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l25-20020a02ccf9000000b004186c617328sm542252jaq.90.2023.06.08.15.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 15:27:00 -0700 (PDT)
Date:   Thu, 8 Jun 2023 16:26:59 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
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
Subject: Re: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <20230608162659.59b0522f.alex.williamson@redhat.com>
In-Reply-To: <20230602121515.79374-9-yi.l.liu@intel.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
        <20230602121515.79374-9-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Jun 2023 05:15:14 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This allows VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl use the iommufd_ctx
> of the cdev device to check the ownership of the other affected devices.
> 
> When VFIO_DEVICE_GET_PCI_HOT_RESET_INFO is called on an IOMMUFD managed
> device, the new flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is reported to indicate
> the values returned are IOMMUFD devids rather than group IDs as used when
> accessing vfio devices through the conventional vfio group interface.
> Additionally the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED will be reported
> in this mode if all of the devices affected by the hot-reset are owned by
> either virtue of being directly bound to the same iommufd context as the
> calling device, or implicitly owned via a shared IOMMU group.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/iommufd.c           | 49 +++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_core.c | 47 +++++++++++++++++++++++++-----
>  include/linux/vfio.h             | 16 ++++++++++
>  include/uapi/linux/vfio.h        | 50 +++++++++++++++++++++++++++++++-
>  4 files changed, 154 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 88b00c501015..a04f3a493437 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -66,6 +66,55 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
>  		vdev->ops->unbind_iommufd(vdev);
>  }
>  
> +struct iommufd_ctx *vfio_iommufd_device_ictx(struct vfio_device *vdev)
> +{
> +	if (vdev->iommufd_device)
> +		return iommufd_device_to_ictx(vdev->iommufd_device);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_device_ictx);
> +
> +static int vfio_iommufd_device_id(struct vfio_device *vdev)
> +{
> +	if (vdev->iommufd_device)
> +		return iommufd_device_to_id(vdev->iommufd_device);
> +	return -EINVAL;

If this is actually reachable, it allows us to return -EINVAL as a
devid in the reset-info ioctl, which is not a defined value.  Should
this return VFIO_PCI_DEVID_NOT_OWNED or do you want to catch the errno
value in the caller?  Thanks,

Alex

> +}
> +
> +/*
> + * Return devid for a device which is affected by hot-reset.
> + * - valid devid > 0 for the device that is bound to the input
> + *   iommufd_ctx.
> + * - devid == VFIO_PCI_DEVID_OWNED for the device that has not
> + *   been bound to any iommufd_ctx but other device within its
> + *   group has been bound to the input iommufd_ctx.
> + * - devid == VFIO_PCI_DEVID_NOT_OWNED for others. e.g. device
> + *   is bound to other iommufd_ctx etc.
> + */
> +int vfio_iommufd_device_hot_reset_devid(struct vfio_device *vdev,
> +					struct iommufd_ctx *ictx)
> +{
> +	struct iommu_group *group;
> +	int devid;
> +
> +	if (vfio_iommufd_device_ictx(vdev) == ictx)
> +		return vfio_iommufd_device_id(vdev);
> +
> +	group = iommu_group_get(vdev->dev);
> +	if (!group)
> +		return VFIO_PCI_DEVID_NOT_OWNED;
> +
> +	if (iommufd_ctx_has_group(ictx, group))
> +		devid = VFIO_PCI_DEVID_OWNED;
> +	else
> +		devid = VFIO_PCI_DEVID_NOT_OWNED;
> +
> +	iommu_group_put(group);
> +
> +	return devid;
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_device_hot_reset_devid);
> +
>  /*
>   * The physical standard ops mean that the iommufd_device is bound to the
>   * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 3a2f67675036..a615a223cdef 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -27,6 +27,7 @@
>  #include <linux/vgaarb.h>
>  #include <linux/nospec.h>
>  #include <linux/sched/mm.h>
> +#include <linux/iommufd.h>
>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
> @@ -776,26 +777,49 @@ struct vfio_pci_fill_info {
>  	int max;
>  	int cur;
>  	struct vfio_pci_dependent_device *devices;
> +	struct vfio_device *vdev;
> +	u32 flags;
>  };
>  
>  static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
>  {
>  	struct vfio_pci_fill_info *fill = data;
> -	struct iommu_group *iommu_group;
>  
>  	if (fill->cur == fill->max)
>  		return -EAGAIN; /* Something changed, try again */
>  
> -	iommu_group = iommu_group_get(&pdev->dev);
> -	if (!iommu_group)
> -		return -EPERM; /* Cannot reset non-isolated devices */
> +	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
> +		struct iommufd_ctx *iommufd = vfio_iommufd_device_ictx(fill->vdev);
> +		struct vfio_device_set *dev_set = fill->vdev->dev_set;
> +		struct vfio_device *vdev;
>  
> -	fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
> +		/*
> +		 * hot-reset requires all affected devices be represented in
> +		 * the dev_set.
> +		 */
> +		vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
> +		if (!vdev)
> +			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_NOT_OWNED;
> +		else
> +			fill->devices[fill->cur].devid =
> +				vfio_iommufd_device_hot_reset_devid(vdev, iommufd);
> +		/* If devid is VFIO_PCI_DEVID_NOT_OWNED, clear owned flag. */
> +		if (fill->devices[fill->cur].devid == VFIO_PCI_DEVID_NOT_OWNED)
> +			fill->flags &= ~VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
> +	} else {
> +		struct iommu_group *iommu_group;
> +
> +		iommu_group = iommu_group_get(&pdev->dev);
> +		if (!iommu_group)
> +			return -EPERM; /* Cannot reset non-isolated devices */
> +
> +		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
> +		iommu_group_put(iommu_group);
> +	}
>  	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
>  	fill->devices[fill->cur].bus = pdev->bus->number;
>  	fill->devices[fill->cur].devfn = pdev->devfn;
>  	fill->cur++;
> -	iommu_group_put(iommu_group);
>  	return 0;
>  }
>  
> @@ -1229,17 +1253,26 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  		return -ENOMEM;
>  
>  	fill.devices = devices;
> +	fill.vdev = &vdev->vdev;
> +
> +	if (vfio_device_cdev_opened(&vdev->vdev))
> +		fill.flags |= VFIO_PCI_HOT_RESET_FLAG_DEV_ID |
> +			     VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
>  
> +	mutex_lock(&vdev->vdev.dev_set->lock);
>  	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
>  					    &fill, slot);
> +	mutex_unlock(&vdev->vdev.dev_set->lock);
>  
>  	/*
>  	 * If a device was removed between counting and filling, we may come up
>  	 * short of fill.max.  If a device was added, we'll have a return of
>  	 * -EAGAIN above.
>  	 */
> -	if (!ret)
> +	if (!ret) {
>  		hdr.count = fill.cur;
> +		hdr.flags = fill.flags;
> +	}
>  
>  reset_info_exit:
>  	if (copy_to_user(arg, &hdr, minsz))
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ee120d2d530b..382a7b119c7c 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -114,6 +114,9 @@ struct vfio_device_ops {
>  };
>  
>  #if IS_ENABLED(CONFIG_IOMMUFD)
> +struct iommufd_ctx *vfio_iommufd_device_ictx(struct vfio_device *vdev);
> +int vfio_iommufd_device_hot_reset_devid(struct vfio_device *vdev,
> +					struct iommufd_ctx *ictx);
>  int vfio_iommufd_physical_bind(struct vfio_device *vdev,
>  			       struct iommufd_ctx *ictx, u32 *out_device_id);
>  void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
> @@ -123,6 +126,19 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
>  void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
>  int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
>  #else
> +static inline struct iommufd_ctx *
> +vfio_iommufd_device_ictx(struct vfio_device *vdev)
> +{
> +	return NULL;
> +}
> +
> +static inline int
> +vfio_iommufd_device_hot_reset_devid(struct vfio_device *vdev,
> +				    struct iommufd_ctx *ictx)
> +{
> +	return VFIO_PCI_DEVID_NOT_OWNED;
> +}
> +
>  #define vfio_iommufd_physical_bind                                      \
>  	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
>  		  u32 *out_device_id)) NULL)
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 0552e8dcf0cb..70cc31e6b1ce 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -650,11 +650,57 @@ enum {
>   * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 12,
>   *					      struct vfio_pci_hot_reset_info)
>   *
> + * This command is used to query the affected devices in the hot reset for
> + * a given device.
> + *
> + * This command always reports the segment, bus, and devfn information for
> + * each affected device, and selectively reports the group_id or devid per
> + * the way how the calling device is opened.
> + *
> + *	- If the calling device is opened via the traditional group/container
> + *	  API, group_id is reported.  User should check if it has owned all
> + *	  the affected devices and provides a set of group fds to prove the
> + *	  ownership in VFIO_DEVICE_PCI_HOT_RESET ioctl.
> + *
> + *	- If the calling device is opened as a cdev, devid is reported.
> + *	  Flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set to indicate this
> + *	  data type.  All the affected devices should be represented in
> + *	  the dev_set, ex. bound to a vfio driver, and also be owned by
> + *	  this interface which is determined by the following conditions:
> + *	  1) Has a valid devid within the iommufd_ctx of the calling device.
> + *	     Ownership cannot be determined across separate iommufd_ctx and
> + *	     the cdev calling conventions do not support a proof-of-ownership
> + *	     model as provided in the legacy group interface.  In this case
> + *	     valid devid with value greater than zero is provided in the return
> + *	     structure.
> + *	  2) Does not have a valid devid within the iommufd_ctx of the calling
> + *	     device, but belongs to the same IOMMU group as the calling device
> + *	     or another opened device that has a valid devid within the
> + *	     iommufd_ctx of the calling device.  This provides implicit ownership
> + *	     for devices within the same DMA isolation context.  In this case
> + *	     the devid value of VFIO_PCI_DEVID_OWNED is provided in the return
> + *	     structure.
> + *
> + *	  A devid value of VFIO_PCI_DEVID_NOT_OWNED is provided in the return
> + *	  structure for affected devices where device is NOT represented in the
> + *	  dev_set or ownership is not available.  Such devices prevent the use
> + *	  of VFIO_DEVICE_PCI_HOT_RESET ioctl outside of the proof-of-ownership
> + *	  calling conventions (ie. via legacy group accessed devices).  Flag
> + *	  VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED would be set when all the
> + *	  affected devices are represented in the dev_set and also owned by
> + *	  the user.  This flag is available only when
> + *	  flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
> + *
>   * Return: 0 on success, -errno on failure:
>   *	-enospc = insufficient buffer, -enodev = unsupported for device.
>   */
>  struct vfio_pci_dependent_device {
> -	__u32	group_id;
> +	union {
> +		__u32   group_id;
> +		__u32	devid;
> +#define VFIO_PCI_DEVID_OWNED		0
> +#define VFIO_PCI_DEVID_NOT_OWNED	-1
> +	};
>  	__u16	segment;
>  	__u8	bus;
>  	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
> @@ -663,6 +709,8 @@ struct vfio_pci_dependent_device {
>  struct vfio_pci_hot_reset_info {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID		(1 << 0)
> +#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED	(1 << 1)
>  	__u32	count;
>  	struct vfio_pci_dependent_device	devices[];
>  };

