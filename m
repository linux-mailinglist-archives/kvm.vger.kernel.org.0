Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76076728B1C
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 00:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbjFHWbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 18:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbjFHWbL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 18:31:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695EC26BA
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 15:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686263423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GA+nLwF8g1cMDJ0xjQRqpeY7nYKWYHpzlhO904qn/Ho=;
        b=fJR89S3Zh0jk6TjMUPgEaFS3ezBYZ9yQ6kxVNMf+BpCANrSKabf0zwWOpWuyJ2jnh8Sy69
        zngNaLGx+lVxEDVPbtltVj4ZG88J06PNxZ7PIYK6U2EjNjnK8JQWIFMyl67/OLT5iHqU5Q
        HFjnwJXHwS4OSJisIlC4zJ6YBk+HFNc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-tzSelVX1M-WeNNvmxwBsDA-1; Thu, 08 Jun 2023 18:30:21 -0400
X-MC-Unique: tzSelVX1M-WeNNvmxwBsDA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-77ac4ec0bb7so86658039f.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 15:30:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686263421; x=1688855421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GA+nLwF8g1cMDJ0xjQRqpeY7nYKWYHpzlhO904qn/Ho=;
        b=CJ3XdCZkAeT7rzLYl4tleBRm/wB0e7m58XJO8UKPU2QWf7Uj8vqBa12gti+jZNiGez
         pZjFfxeUBPRE3qfq5od1hd9eYRkVBcKioH8tWlcOLOsVHtb+rSCsKwTHDKff5KmSY32D
         Nymh7ZYkaqT0zOQn3IcY1MlhgMyqZHTnQC2EvHXXdr2PMtoXOTZQS1N4O0Ee+1bV0tW3
         NcBXey3strwCBL3VKYN6TJhp+vsl6hoJs1dafJlv19ste0wBoh1lwWs2AJ9dQEcY+L9m
         C1hiZFJtDgb57zq411aG4n08ES9H0W0OUlfeiehDe5tv19lxxfZgbVLu10eZZbyb4Zzb
         YZjA==
X-Gm-Message-State: AC+VfDwz+1yX2tRU6A7DPY6zBKRVeHxUs6FPJWSXtWZc2LrIHiB6ysM8
        Z92J+uK+3C1Btyg8IBYsKimnBQmZIZWy2DLlvahETdOo9MR9bDQt8xXr1fNqGJxjO8boAROCdOT
        j0SLiPD2aJ+ut
X-Received: by 2002:a05:6602:3985:b0:774:9415:bed8 with SMTP id bw5-20020a056602398500b007749415bed8mr2213193iob.10.1686263421017;
        Thu, 08 Jun 2023 15:30:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7e6lVUtG05Mk1/IrWtaMS20izWBIVTCZumKYSr4usrIHtSm+EzlnNVv8IKTUTE2/88NnXd6A==
X-Received: by 2002:a05:6602:3985:b0:774:9415:bed8 with SMTP id bw5-20020a056602398500b007749415bed8mr2213161iob.10.1686263420700;
        Thu, 08 Jun 2023 15:30:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v4-20020a02b904000000b0040fa075e5e6sm544412jan.102.2023.06.08.15.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 15:30:20 -0700 (PDT)
Date:   Thu, 8 Jun 2023 16:30:18 -0600
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
Subject: Re: [PATCH v7 9/9] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <20230608163018.70bf3345.alex.williamson@redhat.com>
In-Reply-To: <20230602121515.79374-10-yi.l.liu@intel.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
        <20230602121515.79374-10-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Jun 2023 05:15:15 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This is the way user to invoke hot-reset for the devices opened by cdev
> interface. User should check the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED
> in the output of VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before doing
> hot-reset for cdev devices.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 61 ++++++++++++++++++++++++++------
>  include/uapi/linux/vfio.h        | 14 ++++++++
>  2 files changed, 64 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index a615a223cdef..b0eadafcbcf5 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -181,7 +181,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  struct vfio_pci_group_info;
>  static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> -				      struct vfio_pci_group_info *groups);
> +				      struct vfio_pci_group_info *groups,
> +				      struct iommufd_ctx *iommufd_ctx);
>  
>  /*
>   * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
> @@ -1308,8 +1309,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  	if (ret)
>  		return ret;
>  
> -	/* Somewhere between 1 and count is OK */
> -	if (!array_count || array_count > count)
> +	if (array_count > count)
>  		return -EINVAL;
>  
>  	group_fds = kcalloc(array_count, sizeof(*group_fds), GFP_KERNEL);
> @@ -1358,7 +1358,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  	info.count = array_count;
>  	info.files = files;
>  
> -	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
> +	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
>  
>  hot_reset_release:
>  	for (file_idx--; file_idx >= 0; file_idx--)
> @@ -1381,13 +1381,21 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  	if (hdr.argsz < minsz || hdr.flags)
>  		return -EINVAL;
>  
> +	/* zero-length array is only for cdev opened devices */
> +	if (!!hdr.count == vfio_device_cdev_opened(&vdev->vdev))
> +		return -EINVAL;
> +
>  	/* Can we do a slot or bus reset or neither? */
>  	if (!pci_probe_reset_slot(vdev->pdev->slot))
>  		slot = true;
>  	else if (pci_probe_reset_bus(vdev->pdev->bus))
>  		return -ENODEV;
>  
> -	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
> +	if (hdr.count)
> +		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
> +
> +	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL,
> +					  vfio_iommufd_device_ictx(&vdev->vdev));
>  }
>  
>  static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
> @@ -2354,13 +2362,16 @@ const struct pci_error_handlers vfio_pci_core_err_handlers = {
>  };
>  EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
>  
> -static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
> +static bool vfio_dev_in_groups(struct vfio_device *vdev,
>  			       struct vfio_pci_group_info *groups)
>  {
>  	unsigned int i;
>  
> +	if (!groups)
> +		return false;
> +
>  	for (i = 0; i < groups->count; i++)
> -		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> +		if (vfio_file_has_dev(groups->files[i], vdev))
>  			return true;
>  	return false;
>  }
> @@ -2436,7 +2447,8 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
>   * get each memory_lock.
>   */
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> -				      struct vfio_pci_group_info *groups)
> +				      struct vfio_pci_group_info *groups,
> +				      struct iommufd_ctx *iommufd_ctx)
>  {
>  	struct vfio_pci_core_device *cur_mem;
>  	struct vfio_pci_core_device *cur_vma;
> @@ -2466,11 +2478,38 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  		goto err_unlock;
>  
>  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
> +		bool owned;
> +
>  		/*
> -		 * Test whether all the affected devices are contained by the
> -		 * set of groups provided by the user.
> +		 * Test whether all the affected devices can be reset by the
> +		 * user.
> +		 *
> +		 * If called from a group opened device and the user provides
> +		 * a set of groups, all the devices in the dev_set should be
> +		 * contained by the set of groups provided by the user.
> +		 *
> +		 * If called from a cdev opened device and the user provides
> +		 * a zero-length array, all the devices in the dev_set must
> +		 * be bound to the same iommufd_ctx as the input iommufd_ctx.
> +		 * If there is any device that has not been bound to any
> +		 * iommufd_ctx yet, check if its iommu_group has any device
> +		 * bound to the input iommufd_ctx.  Such devices can be
> +		 * considered owned by the input iommufd_ctx as the device
> +		 * cannot be owned by another iommufd_ctx when its iommu_group
> +		 * is owned.
> +		 *
> +		 * Otherwise, reset is not allowed.
>  		 */
> -		if (!vfio_dev_in_groups(cur_vma, groups)) {
> +		if (iommufd_ctx) {
> +			int devid = vfio_iommufd_device_hot_reset_devid(&cur_vma->vdev,
> +									iommufd_ctx);
> +
> +			owned = (devid != VFIO_PCI_DEVID_NOT_OWNED);
> +		} else {
> +			owned = vfio_dev_in_groups(&cur_vma->vdev, groups);
> +		}
> +
> +		if (!owned) {
>  			ret = -EINVAL;
>  			goto err_undo;
>  		}
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 70cc31e6b1ce..f753124e1c82 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -690,6 +690,9 @@ enum {
>   *	  affected devices are represented in the dev_set and also owned by
>   *	  the user.  This flag is available only when
>   *	  flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
> + *	  When set, user could invoke VFIO_DEVICE_PCI_HOT_RESET with a zero
> + *	  length fd array on the calling device as the ownership is validated
> + *	  by iommufd_ctx.
>   *
>   * Return: 0 on success, -errno on failure:
>   *	-enospc = insufficient buffer, -enodev = unsupported for device.
> @@ -721,6 +724,17 @@ struct vfio_pci_hot_reset_info {
>   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
>   *				    struct vfio_pci_hot_reset)
>   *
> + * Userspace requests hot reset for the devices it operates.  Due to the
> + * underlying topology, multiple devices can be affected in the reset
> + * while some might be opened by another user.  To avoid interference
> + * the calling user must ensure all affected devices are owned by itself.

This phrasing suggest to me that we're placing the responsibility on
the user to avoid resetting another user's devices.  Perhaps these
paragraphs could be replaced with:

  A PCI hot reset results in either a bus or slot reset which may affect
  other devices sharing the bus/slot.  The calling user must have
  ownership of the full set of affected devices as determined by the
  VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl.

  When called on a device file descriptor acquired through the vfio
  group interface, the user is required to provide proof of ownership
  of those affected devices via the group_fds array in struct
  vfio_pci_hot_reset.

  When called on a direct cdev opened vfio device, the flags field of
  struct vfio_pci_hot_reset_info reports the ownership status of the
  affected devices and this ioctl must be called with an empty group_fds
  array.  See above INFO ioctl definition for ownership requirements.

  Mixed usage of legacy groups and cdevs across the set of affected
  devices is not supported.

Other than this and the couple other comments, the series looks ok to
me.  We still need acks from Jason for iommufd on 3-5.  Thanks,

Alex

> + *
> + * As the ownership described by VFIO_DEVICE_GET_PCI_HOT_RESET_INFO, the
> + * cdev opened devices must exclusively provide a zero-length fd array and
> + * the group opened devices must exclusively use an array of group fds for
> + * proof of ownership.  Mixed access to devices between cdev and legacy
> + * groups are not supported by this interface.
> + *
>   * Return: 0 on success, -errno on failure.
>   */
>  struct vfio_pci_hot_reset {

