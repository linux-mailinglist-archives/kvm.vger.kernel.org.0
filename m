Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92C57074F7
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 00:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjEQWCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 18:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjEQWC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 18:02:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF6E2D53
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 15:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684360897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HG/rceSfXoWbIlm6Cl/pPVb/WvTeG1OA3/AKdOuyr2M=;
        b=Ne8kGk1bPXuxvMa/BogjM/BIcIgTsFGVrt0tAqEg/F4XRgRRRzQ3YbXPuFWZA0K5spaauE
        xCg6UVriBmDEdKY945sFwLxWPJ2EoJzeLOYD/fKHo8mEFnpdaLSTXwg9GjhKrOfdWtENry
        1XMyD+a9JIC4sCkgadwpBrGjfBDbfoU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-u-daC3SzOoCgkZdnunQ1FA-1; Wed, 17 May 2023 18:01:35 -0400
X-MC-Unique: u-daC3SzOoCgkZdnunQ1FA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-76c48b53e16so90520339f.1
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 15:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684360895; x=1686952895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HG/rceSfXoWbIlm6Cl/pPVb/WvTeG1OA3/AKdOuyr2M=;
        b=TzZDsKklEwSPzE9eVT6ngIr9RNdBq+fhWa6Kj/NxLZ2i5MBFZkeMC27RtzRO65ds1e
         SDgP/InNBHCcr6JNGTIC6WjulcznPnSzUfUBSPxfPs2ZBokCeN7cDRkvnkGWtT4svhyr
         ccwWvykIi1JVysGfalam0FR2dSjo3wBENEoKyH6OK0606hes9JXw2rR5qeAeWD0sQwpK
         UCdmitQNDY6m/X7xbrzDCLk8Yiz92p64QW0ilzRGBMt/y3SdRfSZ/++xj90FSRmX9zRw
         ENTHNpAscT9f8y4c+K4oHOFryD5uChLXAC0tq1AKwIhG1424Vwpd3F4nbvY5h+DpHntm
         2JeA==
X-Gm-Message-State: AC+VfDzmKWzFxbl+A+4+fk9DyEBrL2f8jvFSoK+PoMvNteKzp/Xh1DQi
        hil8zHWV8bnOSwMdeKTBEJLWvewGIxbIbxtBmrrDYGmWPpIG6f8ZLllgWaNbYnJ7Gx3XMmQ72SJ
        CsR5hNhpYxE0Y
X-Received: by 2002:a5d:8558:0:b0:763:a8a0:c7c0 with SMTP id b24-20020a5d8558000000b00763a8a0c7c0mr5096038ios.10.1684360894637;
        Wed, 17 May 2023 15:01:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5VIN7oZu7ufkSHUSKK5ieAsNm16qvFybf0QXWwaZsZClXLWw964O5XEMhRfmlbyIumybiHYA==
X-Received: by 2002:a5d:8558:0:b0:763:a8a0:c7c0 with SMTP id b24-20020a5d8558000000b00763a8a0c7c0mr5096013ios.10.1684360894200;
        Wed, 17 May 2023 15:01:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id dl6-20020a056638278600b004166c24e30dsm27560jab.32.2023.05.17.15.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:01:33 -0700 (PDT)
Date:   Wed, 17 May 2023 16:01:31 -0600
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
Subject: Re: [PATCH v5 09/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <20230517160131.254be76b.alex.williamson@redhat.com>
In-Reply-To: <20230513132136.15021-10-yi.l.liu@intel.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-10-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 13 May 2023 06:21:35 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This makes VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl to use the iommufd_ctx

s/makes/allows/?

s/to//

> of the cdev device to check the ownership of the other affected devices.
> 
> This returns devid for each of the affected devices. If it is bound to the
> iommufd_ctx of the cdev device, _INFO reports a valid devid > 0; If it is
> not opened by the calling user, but it belongs to the same iommu_group of
> a device that is bound to the iommufd_ctx of the cdev device, reports devid
> value of 0; If the device is un-owned device, configured within a different
> iommufd, or opened outside of the vfio device cdev API, the _INFO ioctl shall
> report devid value of -1.
> 
> devid >=0 doesn't block hot-reset as the affected devices are considered to
> be owned, while devid == -1 will block the use of VFIO_DEVICE_PCI_HOT_RESET
> outside of proof-of-ownership calling conventions (ie. via legacy group
> accessed devices).
> 
> This adds flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID to tell the user devid is
> returned in case of calling user get device fd from other software stack

"other software stack"?  I think this is trying to say something like:

  When VFIO_DEVICE_GET_PCI_HOT_RESET_INFO is called on an IOMMUFD
  managed device, the new flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is
  reported to indicate the values returned are IOMMUFD devids rather
  than group IDs as used when accessing vfio devices through the
  conventional vfio group interface.  Additionally the flag
  VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED will be reported in this mode if
  all of the devices affected by the hot-reset are owned by either
  virtue of being directly bound to the same iommufd context as the
  calling device, or implicitly owned via a shared IOMMU group.

> and adds flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED to tell user if all
> the affected devices are owned, so user can know it without looping all
> the returned devids.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 52 ++++++++++++++++++++++++++++++--
>  include/uapi/linux/vfio.h        | 46 +++++++++++++++++++++++++++-
>  2 files changed, 95 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 4df2def35bdd..57586be770af 100644
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
> @@ -36,6 +37,10 @@
>  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
>  #define DRIVER_DESC "core driver for VFIO based PCI devices"
>  
> +#ifdef CONFIG_IOMMUFD
> +MODULE_IMPORT_NS(IOMMUFD);
> +#endif
> +
>  static bool nointxmask;
>  static bool disable_vga;
>  static bool disable_idle_d3;
> @@ -776,6 +781,9 @@ struct vfio_pci_fill_info {
>  	int max;
>  	int cur;
>  	struct vfio_pci_dependent_device *devices;
> +	struct vfio_device *vdev;
> +	bool devid:1;
> +	bool dev_owned:1;
>  };
>  
>  static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
> @@ -790,7 +798,37 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
>  	if (!iommu_group)
>  		return -EPERM; /* Cannot reset non-isolated devices */
>  
> -	fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
> +	if (fill->devid) {
> +		struct iommufd_ctx *iommufd = vfio_iommufd_physical_ictx(fill->vdev);
> +		struct vfio_device_set *dev_set = fill->vdev->dev_set;
> +		struct vfio_device *vdev;
> +
> +		/*
> +		 * Report devid for the affected devices:
> +		 * - valid devid > 0 for the devices that are bound with
> +		 *   the iommufd of the calling device.
> +		 * - devid == 0 for the devices that have not been opened
> +		 *   but have same group with one of the devices bound to
> +		 *   the iommufd of the calling device.
> +		 * - devid == -1 for others, and clear dev_owned flag.
> +		 */
> +		vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
> +		if (vdev && iommufd == vfio_iommufd_physical_ictx(vdev)) {
> +			int ret;
> +
> +			ret = vfio_iommufd_physical_devid(vdev);
> +			if (WARN_ON(ret < 0))
> +				return ret;
> +			fill->devices[fill->cur].devid = ret;

Nit, @devid seems like a better variable name here rather than @ret.

> +		} else if (vdev && iommufd_ctx_has_group(iommufd, iommu_group)) {
> +			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_OWNED;
> +		} else {
> +			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_NOT_OWNED;
> +			fill->dev_owned = false;
> +		}

I think we're not describing the requirements for this middle test
correctly.  We're essentially only stating the iommufd_ctx_has_group()
part of the requirement, but we're also enforcing a
vfio_find_device_in_devset() requirement, which means the device is not
just unopened within a group shared by the iommufd context, but it must
also still be a device registered as a member of the devset, ie. it
must be bound to a vfio driver.

It's not a new requirement, it's imposed in the hot-reset ioctl itself,
but it's new for the info ioctl given that it's now trying to report
that the user can perform the reset for cdev callers.

This also shares too much logic with vfio_device_owned() added in the
next patch.  I think it might be cleaner to move the iommu_group_get() to
the group path below and change vfio_device_owned() to something that
can be used here and in the reset path.  For example, if we had a
function like:

static int vfio_hot_reset_devid(struct vfio_device *vdev,
                                struct iommufd_ctx *iommufd_ctx)
{
        struct iommu_group *group;
        int devid;

        if (!vdev)
                return VFIO_PCI_DEVID_NOT_OWNED;

        if (vfio_iommufd_physical_ictx(vdev) == iommufd_ctx) 
                return vfio_iommufd_physical_devid(vdev);

        group = iommu_group_get(vdev->dev);
        if (!group)
                return VFIO_PCI_DEVID_NOT_OWNED;
                        
        if (iommufd_ctx_has_group(iommufd_ctx, group))
                devid = VFIO_PCI_DEVID_OWNED;

        iommu_group_put(group);
                                
        return devid;
} 

It could be called above as:

	vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
	fill->devices[fill->cur].devid =
			vfio_hot_reset_devid(vdev, iommufd);


And from vfio_pci_dev_set_hot_reset() as:

	bool owned;

	if (iommufd_ctx) {
		int devid = vfio_hot_reset_devid(&cur_vma->vdev,
						 iommufd_ctx);

		owned = (devid != VFIO_PCI_DEVID_NOT_OWNED);
	} else
		owned = vfio_dev_in_groups(&cur_vma->vdev, groups);

Any better?

> +	} else {
> +		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
> +	}
>  	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
>  	fill->devices[fill->cur].bus = pdev->bus->number;
>  	fill->devices[fill->cur].devfn = pdev->devfn;
> @@ -1229,17 +1267,27 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  		return -ENOMEM;
>  
>  	fill.devices = devices;
> +	fill.vdev = &vdev->vdev;
>  
> +	mutex_lock(&vdev->vdev.dev_set->lock);
> +	fill.devid = fill.dev_owned = vfio_device_cdev_opened(&vdev->vdev);
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
> +		if (fill.devid) {
> +			hdr.flags |= VFIO_PCI_HOT_RESET_FLAG_DEV_ID;
> +			if (fill.dev_owned)
> +				hdr.flags |= VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
> +		}
> +	}

Does this clean up the flag and branching a bit?

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 737115d16a79..6a2a079e452d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -786,8 +786,7 @@ struct vfio_pci_fill_info {
 	int cur;
 	struct vfio_pci_dependent_device *devices;
 	struct vfio_device *vdev;
-	bool devid:1;
-	bool dev_owned:1;
+	u32 flags;
 };
 
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
@@ -802,7 +801,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 	if (!iommu_group)
 		return -EPERM; /* Cannot reset non-isolated devices */
 
-	if (fill->devid) {
+	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
 		struct iommufd_ctx *iommufd = vfio_iommufd_physical_ictx(fill->vdev);
 		struct vfio_device_set *dev_set = fill->vdev->dev_set;
 		struct vfio_device *vdev;
@@ -814,7 +813,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 		 * - devid == 0 for the devices that have not been opened
 		 *   but have same group with one of the devices bound to
 		 *   the iommufd of the calling device.
-		 * - devid == -1 for others, and clear dev_owned flag.
+		 * - devid == -1 for others, and clear owned flag.
 		 */
 		vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
 		if (vdev && iommufd == vfio_iommufd_physical_ictx(vdev)) {
@@ -828,7 +827,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_OWNED;
 		} else {
 			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_NOT_OWNED;
-			fill->dev_owned = false;
+			fill->flags &= ~VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
 		}
 	} else {
 		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
@@ -1273,8 +1272,11 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	fill.devices = devices;
 	fill.vdev = &vdev->vdev;
 
+	if (vfio_device_cdev_opened(&vdev->vdev))
+		fill.flags |= VFIO_PCI_HOT_RESET_FLAG_DEV_ID |
+			     VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
+
 	mutex_lock(&vdev->vdev.dev_set->lock);
-	fill.devid = fill.dev_owned = vfio_device_cdev_opened(&vdev->vdev);
 	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
 					    &fill, slot);
 	mutex_unlock(&vdev->vdev.dev_set->lock);
@@ -1286,11 +1288,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	 */
 	if (!ret) {
 		hdr.count = fill.cur;
-		if (fill.devid) {
-			hdr.flags |= VFIO_PCI_HOT_RESET_FLAG_DEV_ID;
-			if (fill.dev_owned)
-				hdr.flags |= VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
-		}
+		hdr.flags = fill.flags;
 	}
 
 reset_info_exit:

Thanks,
Alex

>  
>  reset_info_exit:
>  	if (copy_to_user(arg, &hdr, minsz))
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 0552e8dcf0cb..01203215251a 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -650,11 +650,53 @@ enum {
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
> + *	  data type.  For a given affected device, it is considered owned by
> + *	  this interface if it meets the following conditions:
> + *	  1) Has a valid devid within the iommufd_ctx of the calling device.
> + *	     Ownership cannot be determined across separate iommufd_ctx and the
> + *	     cdev calling conventions do not support a proof-of-ownership model
> + *	     as provided in the legacy group interface.  In this case a valid
> + *	     devid with value greater than zero is provided in the return
> + *	     structure.
> + *	  2) Does not have a valid devid within the iommufd_ctx of the calling
> + *	     device, but belongs to the same IOMMU group as the calling device
> + *	     or another opened device that has a valid devid within the
> + *	     iommufd_ctx of the calling device.  This provides implicit ownership
> + *	     for devices within the same DMA isolation context.  In this case
> + *	     the invalid devid value of zero is provided in the return structure.
> + *
> + *	  A devid value of -1 is provided in the return structure for devices
> + *	  where ownership is not available.  Such devices prevent the use of
> + *	  VFIO_DEVICE_PCI_HOT_RESET outside of proof-of-ownership calling
> + *	  conventions (ie. via legacy group accessed devices).
> + *	  Flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED would be set when all the
> + *	  affected devices are owned by the user.  This flag is available only
> + *	  when VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
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
> @@ -663,6 +705,8 @@ struct vfio_pci_dependent_device {
>  struct vfio_pci_hot_reset_info {
>  	__u32	argsz;
>  	__u32	flags;
> +#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID		(1 << 0)
> +#define VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED	(1 << 1)
>  	__u32	count;
>  	struct vfio_pci_dependent_device	devices[];
>  };

