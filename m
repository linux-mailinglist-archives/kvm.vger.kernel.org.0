Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB436D6DE8
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 22:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbjDDUTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 16:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjDDUTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 16:19:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CE93AB9
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 13:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680639523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UQkB+/g6+kZ8Dd7MXF9242hej0yLBl/S8rsqAXLmve4=;
        b=G0NG/FE5H3QatLkZ2dUf56gQcjwjwpEBL5TeARArZqEwwknY23g9dxjgQPWL5Co0QpIYCz
        WkMrLLcrT6FkQoRBDxj+1QC2ruuwEIkUaiKwXdoJGcvAFPsWEjbtvUhO5G/Y688EFe+abh
        Su1UqvR/bQz054fJ5O66jCruyprJdc4=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-1mlfWGeDOBOOpKNHlrEMmw-1; Tue, 04 Apr 2023 16:18:42 -0400
X-MC-Unique: 1mlfWGeDOBOOpKNHlrEMmw-1
Received: by mail-io1-f72.google.com with SMTP id i2-20020a5d9e42000000b0074cfcc4ed07so21485268ioi.22
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 13:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680639521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQkB+/g6+kZ8Dd7MXF9242hej0yLBl/S8rsqAXLmve4=;
        b=OD3g5NZpEa95aWjuM0lNbI4LvcmKyP/eT+5MeEcc1a8PyuB4nhH1W2bkhT8rRgSIWi
         vLqPDMO81MpPkjCuwskYz8i+ujSsInRJgS/UpCyOowDcUhb4kA8cMsEvB2RHCd6VtW7F
         yQn+GsKmNhByQOWDh25SsU75Kfi8qPgFaYGeNmXCyEisdZobI5m0+OB387EV+T80t59E
         HjH7uifkwRlRx8OAu18hIsbvv039gMFtEGJwgb6pxHGibBsbAgispJ9woAqjZxFLSwU1
         vQncoNIypoZDJjdLzMS4xM07BzS84SlQtvNZGF6U5ZdJfrjEmsqHu1+7qY+YagsCR0Tu
         y8iA==
X-Gm-Message-State: AAQBX9feE9CbVWRiHLxGSnyMO1wNcx0QtNQV4iC6gFGCUC8O/6bIPKiQ
        lj8e5JGMF9g968aiwg5a/YaFTCYcirlUZfMJDhssyG+vpUf4Etp0OBj4Hc/11fcK4ij5dH+NxyA
        lQhZLXogn6wkS
X-Received: by 2002:a5d:8459:0:b0:75c:f4d8:95a4 with SMTP id w25-20020a5d8459000000b0075cf4d895a4mr4416617ior.7.1680639521694;
        Tue, 04 Apr 2023 13:18:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350aweeLcxWW2qhgQDsJtGDwAV0eYpiJclHZtxi4zQqsYv7ev1oJCy+EHkuk7CSmTo+6lhPnpgw==
X-Received: by 2002:a5d:8459:0:b0:75c:f4d8:95a4 with SMTP id w25-20020a5d8459000000b0075cf4d895a4mr4416609ior.7.1680639521418;
        Tue, 04 Apr 2023 13:18:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c20-20020a023f54000000b003c2b67fac92sm3591510jaf.81.2023.04.04.13.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 13:18:40 -0700 (PDT)
Date:   Tue, 4 Apr 2023 14:18:38 -0600
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
        yanting.jiang@intel.com
Subject: Re: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array
 in VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <20230404141838.6a4efdd4.alex.williamson@redhat.com>
In-Reply-To: <20230401144429.88673-6-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-6-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  1 Apr 2023 07:44:22 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> as an alternative method for ownership check when iommufd is used. In
> this case all opened devices in the affected dev_set are verified to
> be bound to a same valid iommufd value to allow reset. It's simpler
> and faster as user does not need to pass a set of fds and kernel no
> need to search the device within the given fds.
> 
> a device in noiommu mode doesn't have a valid iommufd, so this method
> should not be used in a dev_set which contains multiple devices and one
> of them is in noiommu. The only allowed noiommu scenario is that the
> calling device is noiommu and it's in a singleton dev_set.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 42 +++++++++++++++++++++++++++-----
>  include/uapi/linux/vfio.h        |  9 ++++++-
>  2 files changed, 44 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 3696b8e58445..b68fcba67a4b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -180,7 +180,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  struct vfio_pci_group_info;
>  static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> -				      struct vfio_pci_group_info *groups);
> +				      struct vfio_pci_group_info *groups,
> +				      struct iommufd_ctx *iommufd_ctx);
>  
>  /*
>   * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
> @@ -1277,7 +1278,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  		return ret;
>  
>  	/* Somewhere between 1 and count is OK */
> -	if (!hdr->count || hdr->count > count)
> +	if (hdr->count > count)
>  		return -EINVAL;
>  
>  	group_fds = kcalloc(hdr->count, sizeof(*group_fds), GFP_KERNEL);
> @@ -1326,7 +1327,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  	info.count = hdr->count;
>  	info.files = files;
>  
> -	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
> +	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
>  
>  hot_reset_release:
>  	for (file_idx--; file_idx >= 0; file_idx--)
> @@ -1341,6 +1342,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  {
>  	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
>  	struct vfio_pci_hot_reset hdr;
> +	struct iommufd_ctx *iommufd;
>  	bool slot = false;
>  
>  	if (copy_from_user(&hdr, arg, minsz))
> @@ -1355,7 +1357,12 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  	else if (pci_probe_reset_bus(vdev->pdev->bus))
>  		return -ENODEV;
>  
> -	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
> +	if (hdr.count)
> +		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
> +
> +	iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
> +
> +	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL, iommufd);
>  }
>  
>  static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
> @@ -2327,6 +2334,9 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
>  {
>  	unsigned int i;
>  
> +	if (!groups)
> +		return false;
> +
>  	for (i = 0; i < groups->count; i++)
>  		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
>  			return true;
> @@ -2402,13 +2412,25 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
>  	return ret;
>  }
>  
> +static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
> +				    struct iommufd_ctx *iommufd_ctx)
> +{
> +	struct iommufd_ctx *iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
> +
> +	if (!iommufd)
> +		return false;
> +
> +	return iommufd == iommufd_ctx;
> +}
> +
>  /*
>   * We need to get memory_lock for each device, but devices can share mmap_lock,
>   * therefore we need to zap and hold the vma_lock for each device, and only then
>   * get each memory_lock.
>   */
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> -				      struct vfio_pci_group_info *groups)
> +				      struct vfio_pci_group_info *groups,
> +				      struct iommufd_ctx *iommufd_ctx)
>  {
>  	struct vfio_pci_core_device *cur_mem;
>  	struct vfio_pci_core_device *cur_vma;
> @@ -2448,9 +2470,17 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  		 *
>  		 * Otherwise all opened devices in the dev_set must be
>  		 * contained by the set of groups provided by the user.
> +		 *
> +		 * If user provides a zero-length array, then all the
> +		 * opened devices must be bound to a same iommufd_ctx.
> +		 *
> +		 * If all above checks are failed, reset is allowed only if
> +		 * the calling device is in a singleton dev_set.
>  		 */
>  		if (cur_vma->vdev.open_count &&
> -		    !vfio_dev_in_groups(cur_vma, groups)) {
> +		    !vfio_dev_in_groups(cur_vma, groups) &&
> +		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx) &&
> +		    (dev_set->device_count > 1)) {

This last condition looks buggy to me, we need all conditions to be
true to generate an error here, which means that for a singleton
dev_set, it doesn't matter what group fds are passed, if any, or whether
the iommufd context matches.  I think in fact this means that the empty
array path is equally available for group use cases with a singleton
dev_set, but we don't enable it for multiple device dev_sets like we do
iommufd.

You pointed out a previous issue with hot-reset info and no-iommu where
if other affected devices are not bound to vfio-pci the info ioctl
returns error.  That's handled in the hot-reset ioctl by the fact that
all affected devices must be in the dev_set and therefore bound to
vfio-pci drivers.  So it seems to me that aside from the spurious error
because we can't report an iommu group when none exists, and didn't
spot it to invent an invalid group for debugging, hot-reset otherwise
works with no-iommu just like it does for iommu backed devices.  We
don't currently require singleton no-iommu dev_sets afaict.

I'll also note that if the dev_set is singleton, this suggests that
pci_reset_function() can make use of bus reset, so a hot-reset is
accessible via VFIO_DEVICE_RESET if the appropriate reset method is
selected.

Therefore, I think as written, the singleton dev_set hot-reset is
enabled for iommufd and (unintentionally?) for the group path, while
also negating a requirement for a group fd or that a provided group fd
actually matches the device in this latter case.  The null-array
approach is not however extended to groups for more general use.
Additionally, limiting no-iommu hot-reset to singleton dev_sets
provides only a marginal functional difference vs VFIO_DEVICE_RESET.
Thanks,

Alex

>  			ret = -EINVAL;
>  			goto err_undo;
>  		}
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index f96e5689cffc..17aa5d09db41 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -679,7 +679,14 @@ struct vfio_pci_hot_reset_info {
>   * the calling user must ensure all affected devices, if opened, are
>   * owned by itself.
>   *
> - * The ownership is proved by an array of group fds.
> + * The ownership can be proved by:
> + *   - An array of group fds
> + *   - A zero-length array
> + *
> + * In the last case all affected devices which are opened by this user
> + * must have been bound to a same iommufd. If the calling device is in
> + * noiommu mode (no valid iommufd) then it can be reset only if the reset
> + * doesn't affect other devices.
>   *
>   * Return: 0 on success, -errno on failure.
>   */

