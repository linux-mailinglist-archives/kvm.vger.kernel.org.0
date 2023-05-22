Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954DA70CD6E
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 00:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbjEVWC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 18:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbjEVWCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 18:02:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C2CDB
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684792889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5EDSc5v1Qc3zvN3S4SFC5VgFZScH8vmGrx6LaWbAnc=;
        b=ilMJkjac4elKDxT7DitOdJACKFXwMCEhtH8g7uttycT/WX3KFoTbtnrdLxR4XeR+/L/IB6
        XR5WU96IqFXhlVfVKb8oitBvc3ZSWE3F5tAYjNojhj3FhlxLozOd/9WHdgPv5qGl+1MFvt
        TW4VU+qq0Si9qQIvpc1GWZIi5GX3N54=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-hefKVCLOPniGKhIbkpDK-g-1; Mon, 22 May 2023 18:01:27 -0400
X-MC-Unique: hefKVCLOPniGKhIbkpDK-g-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3384bfb39b4so2234615ab.0
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 15:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684792887; x=1687384887;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O5EDSc5v1Qc3zvN3S4SFC5VgFZScH8vmGrx6LaWbAnc=;
        b=GpXmQUmX6sOrJuGcUrLzK9BvHKFRfcqB96DS1sEwrN0kqiuW0wC1YTO/DV/KCBY1Dl
         ESHKW1xWA+Jm+CAT6GvbN0xTkJFNpNYdy5Wf5W8aZsVlMIVGDJ1CN/XCroshu7I6dPmb
         PZQhGCEZp9idUMi3JABMIgCydst0h7aaT7GP8c6883tjrA6ieSsVP4PKoNYunSBR+7Yy
         Zqks2ynhhFBLaqd29+AKwwdgGSiRlkpGWrgzvWnmMmAjIwY6I0SeKsitHMjP0LodR4bf
         0zhqRMHSeRafvjemOt3gjeygeN7mGkBpti71WoyP1mp3k2e+tfUzC0sNmhc+/0yg3Quu
         8VoA==
X-Gm-Message-State: AC+VfDwcL4dlUNzxs3tAMx2M4s6qZRVaUREhv/o19D/UlQdBkQ2FT+Gv
        WlIVae12JaTBdCjKZhei1xRHNL2JX38IATZ7NL9yNJRle6TqL061jWc1ENH7pv3e0W0no88GWSD
        jLsJjJoZRTLny
X-Received: by 2002:a05:6e02:6d2:b0:33a:329f:24e1 with SMTP id p18-20020a056e0206d200b0033a329f24e1mr1819176ils.1.1684792886868;
        Mon, 22 May 2023 15:01:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5xemqPygQC5U9UB2AxSjRbSzUXv44JQFlOogWY8Qv5rSQxGXRmhHbfNr4FARPnEVGhwDgK5g==
X-Received: by 2002:a05:6e02:6d2:b0:33a:329f:24e1 with SMTP id p18-20020a056e0206d200b0033a329f24e1mr1819154ils.1.1684792886570;
        Mon, 22 May 2023 15:01:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t9-20020a056638348900b0041889152a61sm1988125jal.97.2023.05.22.15.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 15:01:26 -0700 (PDT)
Date:   Mon, 22 May 2023 16:01:24 -0600
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
Subject: Re: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20230522160124.768430b4.alex.williamson@redhat.com>
In-Reply-To: <20230513132827.39066-20-yi.l.liu@intel.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-20-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 13 May 2023 06:28:23 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This adds ioctl for userspace to bind device cdev fd to iommufd.
> 
>     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
> 			      control provided by the iommufd. open_device
> 			      op is called after bind_iommufd op.
> 
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 130 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        |  13 ++++
>  drivers/vfio/vfio_main.c   |   5 ++
>  include/linux/vfio.h       |   3 +-
>  include/uapi/linux/vfio.h  |  28 ++++++++
>  5 files changed, 178 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 1c640016a824..291cc678a18b 100644
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
> @@ -44,6 +45,135 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
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
> +void vfio_device_cdev_close(struct vfio_device_file *df)
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
> +	vfio_device_close(df);
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
> +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				    struct vfio_device_bind_iommufd __user *arg)
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
> +	if (vfio_device_is_noiommu(device) && !capable(CAP_SYS_RAWIO))
> +		return -EPERM;
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
> +	ret = vfio_device_open(df);
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
> +
> +	if (vfio_device_is_noiommu(device))
> +		dev_warn(device->dev, "noiommu device is bound to iommufd by user "
> +			 "(%s:%d)\n", current->comm, task_pid_nr(current));

The noiommu kernel taint only happens in vfio_group_find_or_alloc(), so
how does noiommu taint the kernel when !CONFIG_VFIO_GROUP?


> +	return 0;
> +
> +out_close_device:
> +	vfio_device_close(df);
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
> index 6861f8ebb64d..8b359a7794be 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -279,6 +279,9 @@ static inline void vfio_device_del(struct vfio_device *device)
>  
>  void vfio_init_device_cdev(struct vfio_device *device);
>  int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
> +void vfio_device_cdev_close(struct vfio_device_file *df);
> +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				    struct vfio_device_bind_iommufd __user *arg);
>  int vfio_cdev_init(struct class *device_class);
>  void vfio_cdev_cleanup(void);
>  #else
> @@ -302,6 +305,16 @@ static inline int vfio_device_fops_cdev_open(struct inode *inode,
>  	return 0;
>  }
>  
> +static inline void vfio_device_cdev_close(struct vfio_device_file *df)
> +{
> +}
> +
> +static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +						  struct vfio_device_bind_iommufd __user *arg)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static inline int vfio_cdev_init(struct class *device_class)
>  {
>  	return 0;
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index c87cc7afe92c..c9fa39ac4b02 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -574,6 +574,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  
>  	if (df->group)
>  		vfio_device_group_close(df);
> +	else
> +		vfio_device_cdev_close(df);
>  
>  	vfio_device_put_registration(device);
>  
> @@ -1147,6 +1149,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  	struct vfio_device *device = df->device;
>  	int ret;
>  
> +	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
> +		return vfio_device_ioctl_bind_iommufd(df, (void __user *)arg);
> +
>  	/* Paired with smp_store_release() following vfio_device_open() */
>  	if (!smp_load_acquire(&df->access_granted))
>  		return -EINVAL;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 873275419f13..cf9d082a623c 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -67,6 +67,7 @@ struct vfio_device {
>  	struct iommufd_device *iommufd_device;
>  	bool iommufd_attached;
>  #endif
> +	bool cdev_opened:1;
>  };
>  
>  /**
> @@ -169,7 +170,7 @@ vfio_iommufd_physical_devid(struct vfio_device *vdev)
>  
>  static inline bool vfio_device_cdev_opened(struct vfio_device *device)
>  {
> -	return false;
> +	return device->cdev_opened;
>  }
>  
>  /**
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 24858b650562..07c917de31e9 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -194,6 +194,34 @@ struct vfio_group_status {
>  
>  /* --------------- IOCTLs for DEVICE file descriptors --------------- */
>  
> +/*
> + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
> + *				   struct vfio_device_bind_iommufd)
> + *
> + * Bind a vfio_device to the specified iommufd.
> + *
> + * User is restricted from accessing the device before the binding operation
> + * is completed.
> + *
> + * Unbind is automatically conducted when device fd is closed.
> + *
> + * @argsz:	 User filled size of this data.
> + * @flags:	 Must be 0.
> + * @iommufd:	 iommufd to bind.
> + * @out_devid:	 The device id generated by this bind. devid is a handle for
> + *		 this device/iommufd bond and can be used in IOMMUFD commands.
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
> +#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
> +

Why is this preempting the first device ioctl below rather than being
added in sequential order?  I'm also not sure what's at device ioctl 18
that we started at 19.  VFIO_DEVICE_FEATURE is at 17.  Yes, they're
hard to keep track of.  Thanks,

Alex

>  /**
>   * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
>   *						struct vfio_device_info)

