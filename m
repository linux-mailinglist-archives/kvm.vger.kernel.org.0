Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B51072D45E
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 00:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbjFLW20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 18:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjFLW2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 18:28:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE00A170A
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 15:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686608857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u7yFiATbLIA5V3pSv1HQvfxsdGnzO7UHaWzDCSMoHuI=;
        b=RigrOZW61+KLCli1rkx76vp+ER5zrDF+SCnx4K/nj+ZFDXRmw7yPi1Qk0FEOMZQ8SXAl9Z
        +AyvyBFTDpETxRFui0+czafrzZtsW9NGPmEjq8RgeV5501kczz1sLdlrSPMOH2GdhQdj39
        U3y6zD4jnqTX23eEq8yivdNOGxmUVRQ=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-EjQXciMqNXml7cIQz9K3yA-1; Mon, 12 Jun 2023 18:27:29 -0400
X-MC-Unique: EjQXciMqNXml7cIQz9K3yA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33b372d1deeso44192575ab.3
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 15:27:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686608848; x=1689200848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u7yFiATbLIA5V3pSv1HQvfxsdGnzO7UHaWzDCSMoHuI=;
        b=Wa0HHtJP+O/qZ4jQpdFpeLDxnKB+xgu22Rrz76JmzHa9F/2o/DT1cK0QXAzbD7EH3C
         314U/sM+g7zOMkGhxp+j7tJGdMoM1J7NyDIC40IjNYF+rMRGn9wCOpc0LTg6O5ZHrcq+
         dYFnKir1fdDn+V9Sj/cuT7FatVp3H9/jJcCd36pv/TPkEssARKUcG+Qc+aVST6wPuE4B
         cVTmZN99n53Ghl3HzyV264cVib3c+jmUwSsbA9IyB0PQsFC2NLPaD/fThAM28aOkzFTO
         H7C9AXiY9MLdUDtL7+nI0Bj69xNIYuS0FFhIdsqQHb25v6aOJkysirW0IuITXJPnCZHN
         wSeA==
X-Gm-Message-State: AC+VfDyQZ+vFlGPvdXcXzF6w+6hU9iejojFjGkT6UXVmrOTlYZCp2Yy+
        Xcz1kZWM321ucc0hWvBEz1TD80ngV0j/F3DoYRi6yS9o4yO++FYytcdbHAX/W1Mv6CIIteS2Mil
        YQahg5B0qTbuO
X-Received: by 2002:a92:ceca:0:b0:33d:73fe:3971 with SMTP id z10-20020a92ceca000000b0033d73fe3971mr7870213ilq.9.1686608848567;
        Mon, 12 Jun 2023 15:27:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7w5e5PisRLS7jAQzwuZKoWDibRbgbo3q542VRJEJXviOc0ggWMLi4p4yFG27CG0GdHn8jwIw==
X-Received: by 2002:a92:ceca:0:b0:33d:73fe:3971 with SMTP id z10-20020a92ceca000000b0033d73fe3971mr7870190ilq.9.1686608848252;
        Mon, 12 Jun 2023 15:27:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p10-20020a0566380e8a00b00420e045a3ddsm3018327jas.148.2023.06.12.15.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 15:27:27 -0700 (PDT)
Date:   Mon, 12 Jun 2023 16:27:26 -0600
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
Subject: Re: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20230612162726.16f58ea4.alex.williamson@redhat.com>
In-Reply-To: <20230602121653.80017-19-yi.l.liu@intel.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-19-yi.l.liu@intel.com>
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

On Fri,  2 Jun 2023 05:16:47 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

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
> +
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
> +
> +static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)
> +{
> +	struct iommufd_ctx *iommufd;
> +	struct fd f;
> +
> +	f = fdget(fd);
> +	if (!f.file)
> +		return ERR_PTR(-EBADF);
> +
> +	iommufd = iommufd_ctx_from_file(f.file);
> +
> +	fdput(f);
> +	return iommufd;
> +}
> +
> +long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				struct vfio_device_bind_iommufd __user *arg)
> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_bind_iommufd bind;
> +	unsigned long minsz;
> +	int ret;
> +
> +	static_assert(__same_type(arg->out_devid, df->devid));
> +
> +	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
> +
> +	if (copy_from_user(&bind, arg, minsz))
> +		return -EFAULT;
> +
> +	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
> +		return -EINVAL;
> +
> +	/* BIND_IOMMUFD only allowed for cdev fds */
> +	if (df->group)
> +		return -EINVAL;
> +
> +	ret = vfio_device_block_group(device);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	/* one device cannot be bound twice */
> +	if (df->access_granted) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	df->iommufd = vfio_get_iommufd_from_fd(bind.iommufd);
> +	if (IS_ERR(df->iommufd)) {
> +		ret = PTR_ERR(df->iommufd);
> +		df->iommufd = NULL;
> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * Before the device open, get the KVM pointer currently
> +	 * associated with the device file (if there is) and obtain
> +	 * a reference.  This reference is held until device closed.
> +	 * Save the pointer in the device for use by drivers.
> +	 */
> +	vfio_device_get_kvm_safe(df);
> +
> +	ret = vfio_df_open(df);
> +	if (ret)
> +		goto out_put_kvm;
> +
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
> +	mutex_unlock(&device->dev_set->lock);
> +	return 0;
> +
> +out_close_device:
> +	vfio_df_close(df);
> +out_put_kvm:
> +	vfio_device_put_kvm(device);
> +	iommufd_ctx_put(df->iommufd);
> +	df->iommufd = NULL;
> +out_unlock:
> +	mutex_unlock(&device->dev_set->lock);
> +	vfio_device_unblock_group(device);
> +	return ret;
> +}
> +
>  static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
>  {
>  	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index d12b5b524bfc..42de40d2cd4d 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -287,6 +287,9 @@ static inline void vfio_device_del(struct vfio_device *device)
>  }
>  
>  int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
> +void vfio_df_cdev_close(struct vfio_device_file *df);
> +long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				struct vfio_device_bind_iommufd __user *arg);
>  int vfio_cdev_init(struct class *device_class);
>  void vfio_cdev_cleanup(void);
>  #else
> @@ -310,6 +313,16 @@ static inline int vfio_device_fops_cdev_open(struct inode *inode,
>  	return 0;
>  }
>  
> +static inline void vfio_df_cdev_close(struct vfio_device_file *df)
> +{
> +}
> +
> +static inline long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> +					      struct vfio_device_bind_iommufd __user *arg)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static inline int vfio_cdev_init(struct class *device_class)
>  {
>  	return 0;
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index ef55af75f459..9ba4d420eda2 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -572,6 +572,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  
>  	if (df->group)
>  		vfio_df_group_close(df);
> +	else
> +		vfio_df_cdev_close(df);
>  
>  	vfio_device_put_registration(device);
>  
> @@ -1145,6 +1147,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  	struct vfio_device *device = df->device;
>  	int ret;
>  
> +	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
> +		return vfio_df_ioctl_bind_iommufd(df, (void __user *)arg);
> +
>  	/* Paired with smp_store_release() following vfio_df_open() */
>  	if (!smp_load_acquire(&df->access_granted))
>  		return -EINVAL;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 83cc5dc28b7a..e80a8ac86e46 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -66,6 +66,7 @@ struct vfio_device {
>  	struct iommufd_device *iommufd_device;
>  	bool iommufd_attached;
>  #endif
> +	bool cdev_opened:1;

Perhaps a more strongly defined data type here as well and roll
iommufd_attached into the same bit field scheme.

>  };
>  
>  /**
> @@ -170,7 +171,7 @@ vfio_iommufd_device_hot_reset_devid(struct vfio_device *vdev,
>  
>  static inline bool vfio_device_cdev_opened(struct vfio_device *device)
>  {
> -	return false;
> +	return device->cdev_opened;
>  }
>  
>  /**
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index f753124e1c82..7296012b7f36 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -194,6 +194,33 @@ struct vfio_group_status {
>  
>  /* --------------- IOCTLs for DEVICE file descriptors --------------- */
>  
> +/*
> + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
> + *				   struct vfio_device_bind_iommufd)
> + * @argsz:	 User filled size of this data.
> + * @flags:	 Must be 0.
> + * @iommufd:	 iommufd to bind.
> + * @out_devid:	 The device id generated by this bind. devid is a handle for
> + *		 this device/iommufd bond and can be used in IOMMUFD commands.
> + *
> + * Bind a vfio_device to the specified iommufd.
> + *
> + * User is restricted from accessing the device before the binding operation
> + * is completed.
> + *
> + * Unbind is automatically conducted when device fd is closed.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_bind_iommufd {
> +	__u32		argsz;
> +	__u32		flags;
> +	__s32		iommufd;
> +	__u32		out_devid;
> +};
> +
> +#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)
> +

Why are we still defining device ioctls 18-20 before existing device
ioctls?  18 should be defined after 17...  Thanks,

Alex

>  /**
>   * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
>   *						struct vfio_device_info)

