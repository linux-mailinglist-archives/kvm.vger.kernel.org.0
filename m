Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B69D6CF4EE
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 23:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjC2VBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 17:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC2VBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 17:01:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B0244A2
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 14:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680123665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5qURyqrYVpdH6pizDlOAe+LjF2lt1cGL1qY3yj5NPA=;
        b=IRB8Tk+xlynSvz1oeA2jqQqvv4ChH4uCc5U+Y988y3vi9QGmRhuIKEIqA+Sa8dy/C7bJsr
        w0JHJSePTEq9NWEgX8x94sAu9Djls2nt0Go/XEwVcnxH9YKshm1bq1IQVkkKG1BVyGJmVn
        ZFgiREBgd0yAbTIPGsmTHTSVPrjqdJ0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-ORZWhqp3NJmK9ygHfbTlLA-1; Wed, 29 Mar 2023 17:00:59 -0400
X-MC-Unique: ORZWhqp3NJmK9ygHfbTlLA-1
Received: by mail-il1-f200.google.com with SMTP id i17-20020a056e020d9100b00325a80f683cso11234610ilj.22
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 14:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680123658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U5qURyqrYVpdH6pizDlOAe+LjF2lt1cGL1qY3yj5NPA=;
        b=EL7/rBXy+sd1kktr/L9r5rMfi7OgRROYtvvhBWxlqr0hIyyDVEBvFN47JF2FvJ4PgM
         KbipUxF8Jis6Gs3kQl0N5dqlhKUrMNI3iynBOKPrFbAftJUflfimKgRE895vEASK/K9t
         WwnG5idFVY8+y0taa2yptTuNb5WuI2yCTRpmci+7obCcouvph+toM+LhZSKC5R+xRlfs
         QDTpMu2KtNuxzywa4HUeNuIxYLXDLeBAjtbjIk+Np0AU1nwd/rpw6M5xbenSQalo8D1p
         NfpfqLnn56WiyRLQRvRh/0yJjnjk2ktXQeGutyZDkxZqtyE98cwiljHtaJcKrwKLxQPO
         0ssQ==
X-Gm-Message-State: AAQBX9emKeHmH/mERlsHU5yKbj4eBQER0X5NHyzmJkAgb4BEBARKmlAq
        jJuRUMM2BC0bpgP+cDP59rKTAlp4ZT0qRKgMSC/LKkC6qkYuc2RYravO4A2BFONJjrm7HYGl460
        ElPgcE6ocOb1N
X-Received: by 2002:a92:b511:0:b0:325:f703:6e5e with SMTP id f17-20020a92b511000000b00325f7036e5emr1978710ile.11.1680123658244;
        Wed, 29 Mar 2023 14:00:58 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y6F9PxZc5bVI5dPpZUK9Ox3FEejxJdl5AVM6qZvWz4XSNy7ab9vt4HcS0hkfP79hEUuic/wQ==
X-Received: by 2002:a92:b511:0:b0:325:f703:6e5e with SMTP id f17-20020a92b511000000b00325f7036e5emr1978693ile.11.1680123657898;
        Wed, 29 Mar 2023 14:00:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h5-20020a056638338500b003ea1dbd00d6sm10293125jav.70.2023.03.29.14.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 14:00:56 -0700 (PDT)
Date:   Wed, 29 Mar 2023 15:00:55 -0600
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
Subject: Re: [PATCH v8 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20230329150055.3dee2476.alex.williamson@redhat.com>
In-Reply-To: <20230327094047.47215-22-yi.l.liu@intel.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
        <20230327094047.47215-22-yi.l.liu@intel.com>
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

On Mon, 27 Mar 2023 02:40:44 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This adds ioctl for userspace to bind device cdev fd to iommufd.
> 
>     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
> 			      control provided by the iommufd. open_device
> 			      op is called after bind_iommufd op.
> 			      VFIO no iommu mode is indicated by passing
> 			      a negative iommufd value.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c | 153 +++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        |  13 ++++
>  drivers/vfio/vfio_main.c   |   5 ++
>  include/uapi/linux/vfio.h  |  37 +++++++++
>  4 files changed, 208 insertions(+)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 1c640016a824..2b563bac50b9 100644
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
> @@ -44,6 +45,158 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
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
> +	 * As df->access_granted writer is under dev_set->lock as well,
> +	 * so this read no need to use smp_load_acquire() to pair with

Nit, "no need to use" -> "does not need to use"

> +	 * smp_store_release() in the caller of vfio_device_open().
> +	 */
> +	if (!df->access_granted)
> +		return;
> +

Isn't the lock we're acquiring below the one that we claim to have in
the comment above to make the non-smp_load_acquire() test safe?

> +	mutex_lock(&device->dev_set->lock);
> +	vfio_device_close(df);
> +	vfio_device_put_kvm(device);
> +	if (df->iommufd)
> +		iommufd_ctx_put(df->iommufd);
> +	mutex_unlock(&device->dev_set->lock);
> +	vfio_device_unblock_group(device);
> +}
> +
> +static int vfio_device_cdev_enable_noiommu(struct vfio_device *device)
> +{
> +	if (!capable(CAP_SYS_RAWIO))
> +		return -EPERM;
> +
> +	if (!device->noiommu)
> +		return -EINVAL;
> +
> +	return 0;
> +}

This is testing, not enabling. ie. naming nit.

> +
> +static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)
> +{
> +	struct fd f;
> +	struct iommufd_ctx *iommufd;
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
> +	struct iommufd_ctx *iommufd = NULL;
> +	unsigned long minsz;
> +	int ret;
> +
> +	static_assert(__same_type(arg->out_devid, bind.out_devid));

They're the same field in the same structure, how could they be
otherwise?

> +
> +	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
> +
> +	if (copy_from_user(&bind, arg, minsz))
> +		return -EFAULT;
> +
> +	if (bind.argsz < minsz || bind.flags)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;

This test seems beyond normal paranoia since we test in
__vfio_register_dev()

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
> +	/* iommufd < 0 means noiommu mode */
> +	if (bind.iommufd < 0) {
> +		ret = vfio_device_cdev_enable_noiommu(device);
> +		if (ret)
> +			goto out_unlock;
> +	} else {
> +		iommufd = vfio_get_iommufd_from_fd(bind.iommufd);
> +		if (IS_ERR(iommufd)) {
> +			ret = PTR_ERR(iommufd);
> +			goto out_unlock;
> +		}
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
> +	df->iommufd = iommufd;
> +	ret = vfio_device_open(df);
> +	if (ret)
> +		goto out_put_kvm;
> +
> +	if (df->iommufd)
> +		bind.out_devid = df->devid;

How about only setting df->iommufd in the non-noiommu case above so
it's not confusing that it was just set 4 lines previous.  That also
allows the iommufd pointer to be scoped within that branch and not
require initialization.  It might make sense to declare:

	bool is_noiommu = (bind.iommufd < 0);

and use it consistently rather than alternating testing between
bind.iommufd and df->iommufd.

> +
> +	ret = copy_to_user(&arg->out_devid, &bind.out_devid,
> +			   sizeof(bind.out_devid)) ? -EFAULT : 0;

In the noiommu case, this copies back the input value, shouldn't it be
some known invalid value?  Seems confusing.

> +	if (ret)
> +		goto out_close_device;
> +
> +	if (bind.iommufd < 0)
> +		dev_warn(device->dev, "device is bound to vfio-noiommu by user "
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
> +	vfio_device_put_kvm(device);
> +	if (iommufd)
> +		iommufd_ctx_put(iommufd);
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
> index 3a8fd0e32f59..ace3d52b0928 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -281,6 +281,9 @@ static inline void vfio_device_del(struct vfio_device *device)
>  
>  void vfio_init_device_cdev(struct vfio_device *device);
>  int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
> +void vfio_device_cdev_close(struct vfio_device_file *df);
> +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				    struct vfio_device_bind_iommufd __user *arg);
>  int vfio_cdev_init(struct class *device_class);
>  void vfio_cdev_cleanup(void);
>  #else
> @@ -304,6 +307,16 @@ static inline int vfio_device_fops_cdev_open(struct inode *inode,
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
> index 58fc3bb768f2..375086c8803f 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -559,6 +559,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  
>  	if (df->group)
>  		vfio_device_group_close(df);
> +	else
> +		vfio_device_cdev_close(df);
>  
>  	vfio_device_put_registration(device);
>  
> @@ -1132,6 +1134,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  	struct vfio_device *device = df->device;
>  	int ret;
>  
> +	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
> +		return vfio_device_ioctl_bind_iommufd(df, (void __user *)arg);
> +
>  	/* Paired with smp_store_release() following vfio_device_open() */
>  	if (!smp_load_acquire(&df->access_granted))
>  		return -EINVAL;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 61b801dfd40b..62b2f2497525 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -194,6 +194,43 @@ struct vfio_group_status {
>  
>  /* --------------- IOCTLs for DEVICE file descriptors --------------- */
>  
> +/*
> + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
> + *				   struct vfio_device_bind_iommufd)
> + *
> + * Bind a vfio_device to the specified iommufd.
> + *
> + * The user should provide a device cookie when calling this ioctl. The
> + * cookie is carried only in event e.g. I/O fault reported to userspace
> + * via iommufd. The user should use devid returned by this ioctl to mark
> + * the target device in other ioctls (e.g. iommu hardware infomration query
> + * via iommufd, and etc.).

AFAICT, the whole concept of this dev_cookie is a fantasy.  It only
exists in this series in these comments and the structure below.  It's
not even defined whether it needs to be unique within an iommufd
context, and clearly nothing here validates that.  There's not enough
implementation for it to exist in this series.  Maybe dev_cookie is
appended to the end of the structure and indicated with a flag when it
has some meaning.

> + *
> + * User is not allowed to access the device before the binding operation
> + * is completed.

s/not allowed to access/restricted from accessing/

> + *
> + * Unbind is automatically conducted when device fd is closed.
> + *
> + * @argsz:	 user filled size of this data.
> + * @flags:	 reserved for future extension.
> + * @dev_cookie:	 a per device cookie provided by userspace.
> + * @iommufd:	 iommufd to bind. a negative value means noiommu.

"Use a negative value for no-iommu, where supported", or better, should
we define this explicitly as -1, or why not use a flag bit to specify
no-iommu?  Maybe minsz is only through flags for the noiommu use case.
Thanks,

Alex

> + * @out_devid:	 the device id generated by this bind. This field is valid
> + *		as long as the input @iommufd is valid. Otherwise, it is
> + *		meaningless.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_bind_iommufd {
> +	__u32		argsz;
> +	__u32		flags;
> +	__aligned_u64	dev_cookie;
> +	__s32		iommufd;
> +	__u32		out_devid;
> +};
> +
> +#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
> +
>  /**
>   * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
>   *						struct vfio_device_info)

