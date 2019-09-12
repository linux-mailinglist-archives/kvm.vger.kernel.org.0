Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9E0B0BF4
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 11:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbfILJvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 05:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730706AbfILJvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 05:51:52 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22BBBC050E12
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 09:51:51 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id a6so26246846qkl.10
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2019 02:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bz0vgQ+BkVyu6heHi03tITHLE5ryNGKRf56ZJJ9wdRo=;
        b=AwS3Fue++BN3SzvCAWCzp1zxh1LS75g0oLuDnzKIDi6a8mrTUobbGHhLRIl7BnuBiC
         8+5Yet5Eg4ki7nBAWJSIDR5R37SXmpy/MtnUr3f3oWABZul0s6/bcxrauo7Gxqq27qZq
         0QbetXEn7dfKMMn4YJmHxbPmbJnF3ZYB81Uhpiai3+MRR5GoxL6EbFG5kDgZEsj2UREx
         gIICxo3ys1jiOKW41cNlFdLwyt4Tb5YtCfdQNaiv7HElnMt2LkR/yZgudqWd/CzyjaFv
         oluElprGdITehEc59nV/y5Hi/GBD/jTmRalx+tpZCgyD/87ydnPgFqWXWqMAvTcmuJv8
         ygMQ==
X-Gm-Message-State: APjAAAUW+z2N7QgmsioXYdR8d/5gCdCl5S2bnkRDYFII0aIBi0318Y6N
        ngibV5MWEvXZh2Y+5VzZU+q5+qXPnF+rt+Ev85sgcLwsVgvlsBKi370Ie6lcoAFPpiltyvkprs0
        nFJlzQsp1Dj6B
X-Received: by 2002:ac8:3647:: with SMTP id n7mr41093096qtb.159.1568281909439;
        Thu, 12 Sep 2019 02:51:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyDlD0ePR3jiHiLRFOr8sxOGetAxQ16lUQKr9+iVwYghI0rOFUzoUIK5pKVt3qjaGD6ZBmPzA==
X-Received: by 2002:ac8:3647:: with SMTP id n7mr41093075qtb.159.1568281909192;
        Thu, 12 Sep 2019 02:51:49 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id a22sm4923888qkl.117.2019.09.12.02.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 02:51:48 -0700 (PDT)
Date:   Thu, 12 Sep 2019 05:51:36 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, cohuck@redhat.com,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        pmorel@linux.ibm.com, freude@linux.ibm.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com, idos@mellanox.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com
Subject: Re: [RFC PATCH 2/2] mdev: introduce device specific ops
Message-ID: <20190912055037-mutt-send-email-mst@kernel.org>
References: <20190912094012.29653-1-jasowang@redhat.com>
 <20190912094012.29653-3-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912094012.29653-3-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 05:40:12PM +0800, Jason Wang wrote:
> Currently, except for the crate and remove. The rest fields of


better:

Currently, except for create and remove, the rest of the field in ...


> mdev_parent_ops is just designed for vfio-mdev driver and may not help
> for kernel mdev driver. So follow the device id support by previous
> patch, this patch introduces device specific ops which points to
> device specific ops (e.g vfio ops). This allows the future drivers
> like virtio-mdev to implement its own device specific ops.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c  | 14 +++---
>  drivers/s390/cio/vfio_ccw_ops.c   | 14 +++---
>  drivers/s390/crypto/vfio_ap_ops.c | 10 +++--
>  drivers/vfio/mdev/vfio_mdev.c     | 30 +++++++------
>  include/linux/mdev.h              | 72 ++++++++++++++++++-------------
>  samples/vfio-mdev/mbochs.c        | 16 ++++---
>  samples/vfio-mdev/mdpy.c          | 16 ++++---
>  samples/vfio-mdev/mtty.c          | 14 +++---
>  8 files changed, 113 insertions(+), 73 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 19d51a35f019..64823998fd58 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1600,20 +1600,22 @@ static const struct attribute_group *intel_vgpu_groups[] = {
>  	NULL,
>  };
>  
> -static struct mdev_parent_ops intel_vgpu_ops = {
> -	.mdev_attr_groups       = intel_vgpu_groups,
> -	.create			= intel_vgpu_create,
> -	.remove			= intel_vgpu_remove,
> -
> +static struct vfio_mdev_parent_ops intel_vfio_vgpu_ops = {
>  	.open			= intel_vgpu_open,
>  	.release		= intel_vgpu_release,
> -
>  	.read			= intel_vgpu_read,
>  	.write			= intel_vgpu_write,
>  	.mmap			= intel_vgpu_mmap,
>  	.ioctl			= intel_vgpu_ioctl,
>  };
>  
> +static struct mdev_parent_ops intel_vgpu_ops = {
> +	.mdev_attr_groups       = intel_vgpu_groups,
> +	.create			= intel_vgpu_create,
> +	.remove			= intel_vgpu_remove,
> +	.device_ops	        = &intel_vfio_vgpu_ops,
> +};
> +
>  static int kvmgt_host_init(struct device *dev, void *gvt, const void *ops)
>  {
>  	struct attribute **kvm_type_attrs;
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index f87d9409e290..96e9f18100ae 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -564,11 +564,7 @@ static ssize_t vfio_ccw_mdev_ioctl(struct mdev_device *mdev,
>  	}
>  }
>  
> -static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
> -	.owner			= THIS_MODULE,
> -	.supported_type_groups  = mdev_type_groups,
> -	.create			= vfio_ccw_mdev_create,
> -	.remove			= vfio_ccw_mdev_remove,
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
>  	.open			= vfio_ccw_mdev_open,
>  	.release		= vfio_ccw_mdev_release,
>  	.read			= vfio_ccw_mdev_read,
> @@ -576,6 +572,14 @@ static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
>  	.ioctl			= vfio_ccw_mdev_ioctl,
>  };
>  
> +static const struct mdev_parent_ops vfio_ccw_mdev_ops = {
> +	.owner			= THIS_MODULE,
> +	.supported_type_groups  = mdev_type_groups,
> +	.create			= vfio_ccw_mdev_create,
> +	.remove			= vfio_ccw_mdev_remove,
> +	.device_ops		= &vfio_mdev_ops,
> +};
> +
>  int vfio_ccw_mdev_reg(struct subchannel *sch)
>  {
>  	return mdev_register_vfio_device(&sch->dev, &vfio_ccw_mdev_ops);
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index eacbde3c7a97..a48282bff066 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1280,15 +1280,19 @@ static ssize_t vfio_ap_mdev_ioctl(struct mdev_device *mdev,
>  	return ret;
>  }
>  
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
> +	.open			= vfio_ap_mdev_open,
> +	.release		= vfio_ap_mdev_release,
> +	.ioctl			= vfio_ap_mdev_ioctl,
> +};
> +
>  static const struct mdev_parent_ops vfio_ap_matrix_ops = {
>  	.owner			= THIS_MODULE,
>  	.supported_type_groups	= vfio_ap_mdev_type_groups,
>  	.mdev_attr_groups	= vfio_ap_mdev_attr_groups,
>  	.create			= vfio_ap_mdev_create,
>  	.remove			= vfio_ap_mdev_remove,
> -	.open			= vfio_ap_mdev_open,
> -	.release		= vfio_ap_mdev_release,
> -	.ioctl			= vfio_ap_mdev_ioctl,
> +	.device_ops		= &vfio_mdev_ops,
>  };
>  
>  int vfio_ap_mdev_register(void)
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> index 887c57f10880..1196fbb6c3d2 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -25,15 +25,16 @@ static int vfio_mdev_open(void *device_data)
>  {
>  	struct mdev_device *mdev = device_data;
>  	struct mdev_parent *parent = mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
>  	int ret;
>  
> -	if (unlikely(!parent->ops->open))
> +	if (unlikely(!ops->open))
>  		return -EINVAL;
>  
>  	if (!try_module_get(THIS_MODULE))
>  		return -ENODEV;
>  
> -	ret = parent->ops->open(mdev);
> +	ret = ops->open(mdev);
>  	if (ret)
>  		module_put(THIS_MODULE);
>  
> @@ -44,9 +45,10 @@ static void vfio_mdev_release(void *device_data)
>  {
>  	struct mdev_device *mdev = device_data;
>  	struct mdev_parent *parent = mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
>  
> -	if (likely(parent->ops->release))
> -		parent->ops->release(mdev);
> +	if (likely(ops->release))
> +		ops->release(mdev);
>  
>  	module_put(THIS_MODULE);
>  }
> @@ -56,11 +58,12 @@ static long vfio_mdev_unlocked_ioctl(void *device_data,
>  {
>  	struct mdev_device *mdev = device_data;
>  	struct mdev_parent *parent = mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
>  
> -	if (unlikely(!parent->ops->ioctl))
> +	if (unlikely(!ops->ioctl))
>  		return -EINVAL;
>  
> -	return parent->ops->ioctl(mdev, cmd, arg);
> +	return ops->ioctl(mdev, cmd, arg);
>  }
>  
>  static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
> @@ -68,11 +71,12 @@ static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
>  {
>  	struct mdev_device *mdev = device_data;
>  	struct mdev_parent *parent = mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
>  
> -	if (unlikely(!parent->ops->read))
> +	if (unlikely(!ops->read))
>  		return -EINVAL;
>  
> -	return parent->ops->read(mdev, buf, count, ppos);
> +	return ops->read(mdev, buf, count, ppos);
>  }
>  
>  static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
> @@ -80,22 +84,24 @@ static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
>  {
>  	struct mdev_device *mdev = device_data;
>  	struct mdev_parent *parent = mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
>  
> -	if (unlikely(!parent->ops->write))
> +	if (unlikely(!ops->write))
>  		return -EINVAL;
>  
> -	return parent->ops->write(mdev, buf, count, ppos);
> +	return ops->write(mdev, buf, count, ppos);
>  }
>  
>  static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
>  {
>  	struct mdev_device *mdev = device_data;
>  	struct mdev_parent *parent = mdev->parent;
> +	const struct vfio_mdev_parent_ops *ops = parent->ops->device_ops;
>  
> -	if (unlikely(!parent->ops->mmap))
> +	if (unlikely(!ops->mmap))
>  		return -EINVAL;
>  
> -	return parent->ops->mmap(mdev, vma);
> +	return ops->mmap(mdev, vma);
>  }
>  
>  static const struct vfio_device_ops vfio_mdev_dev_ops = {
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index f85045392120..3b8a76bc69cf 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -27,27 +27,9 @@ int mdev_set_iommu_device(struct device *dev, struct device *iommu_device);
>  struct device *mdev_get_iommu_device(struct device *dev);
>  
>  /**
> - * struct mdev_parent_ops - Structure to be registered for each parent device to
> - * register the device to mdev module.
> + * struct vfio_mdev_parent_ops - Structure to be registered for each
> + * parent device to register the device to vfio-mdev module.
>   *
> - * @owner:		The module owner.
> - * @dev_attr_groups:	Attributes of the parent device.
> - * @mdev_attr_groups:	Attributes of the mediated device.
> - * @supported_type_groups: Attributes to define supported types. It is mandatory
> - *			to provide supported types.
> - * @create:		Called to allocate basic resources in parent device's
> - *			driver for a particular mediated device. It is
> - *			mandatory to provide create ops.
> - *			@kobj: kobject of type for which 'create' is called.
> - *			@mdev: mdev_device structure on of mediated device
> - *			      that is being created
> - *			Returns integer: success (0) or error (< 0)
> - * @remove:		Called to free resources in parent device's driver for a
> - *			a mediated device. It is mandatory to provide 'remove'
> - *			ops.
> - *			@mdev: mdev_device device structure which is being
> - *			       destroyed
> - *			Returns integer: success (0) or error (< 0)
>   * @open:		Open mediated device.
>   *			@mdev: mediated device.
>   *			Returns integer: success (0) or error (< 0)
> @@ -72,6 +54,43 @@ struct device *mdev_get_iommu_device(struct device *dev);
>   * @mmap:		mmap callback
>   *			@mdev: mediated device structure
>   *			@vma: vma structure
> + */
> +struct vfio_mdev_parent_ops {
> +	int     (*open)(struct mdev_device *mdev);
> +	void    (*release)(struct mdev_device *mdev);
> +	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
> +			size_t count, loff_t *ppos);
> +	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
> +			 size_t count, loff_t *ppos);
> +	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> +			 unsigned long arg);
> +	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
> +};
> +
> +/**
> + * struct mdev_parent_ops - Structure to be registered for each parent device to
> + * register the device to mdev module.
> + *
> + * @owner:		The module owner.
> + * @dev_attr_groups:	Attributes of the parent device.
> + * @mdev_attr_groups:	Attributes of the mediated device.
> + * @supported_type_groups: Attributes to define supported types. It is mandatory
> + *			to provide supported types.
> + * @create:		Called to allocate basic resources in parent device's
> + *			driver for a particular mediated device. It is
> + *			mandatory to provide create ops.
> + *			@kobj: kobject of type for which 'create' is called.
> + *			@mdev: mdev_device structure on of mediated device
> + *			      that is being created
> + *			Returns integer: success (0) or error (< 0)
> + * @remove:		Called to free resources in parent device's driver for a
> + *			a mediated device. It is mandatory to provide 'remove'
> + *			ops.
> + *			@mdev: mdev_device device structure which is being
> + *			       destroyed
> + *			Returns integer: success (0) or error (< 0)
> + * @device_ops:         Device specific emulation callback.
> + *
>   * Parent device that support mediated device should be registered with mdev
>   * module with mdev_parent_ops structure.
>   **/
> @@ -83,15 +102,7 @@ struct mdev_parent_ops {
>  
>  	int     (*create)(struct kobject *kobj, struct mdev_device *mdev);
>  	int     (*remove)(struct mdev_device *mdev);
> -	int     (*open)(struct mdev_device *mdev);
> -	void    (*release)(struct mdev_device *mdev);
> -	ssize_t (*read)(struct mdev_device *mdev, char __user *buf,
> -			size_t count, loff_t *ppos);
> -	ssize_t (*write)(struct mdev_device *mdev, const char __user *buf,
> -			 size_t count, loff_t *ppos);
> -	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
> -			 unsigned long arg);
> -	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
> +	const void *device_ops;
>  };
>  
>  /* interface for exporting mdev supported type attributes */
> @@ -137,7 +148,8 @@ const guid_t *mdev_uuid(struct mdev_device *mdev);
>  
>  extern struct bus_type mdev_bus_type;
>  
> -int mdev_register_vfio_device(struct device *dev, const struct mdev_parent_ops *ops);
> +int mdev_register_vfio_device(struct device *dev,
> +                              const struct mdev_parent_ops *ops);
>  void mdev_unregister_device(struct device *dev);
>  
>  int mdev_register_driver(struct mdev_driver *drv, struct module *owner);
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 71a4469be85d..53ceb357f152 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1418,12 +1418,7 @@ static struct attribute_group *mdev_type_groups[] = {
>  	NULL,
>  };
>  
> -static const struct mdev_parent_ops mdev_fops = {
> -	.owner			= THIS_MODULE,
> -	.mdev_attr_groups	= mdev_dev_groups,
> -	.supported_type_groups	= mdev_type_groups,
> -	.create			= mbochs_create,
> -	.remove			= mbochs_remove,
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
>  	.open			= mbochs_open,
>  	.release		= mbochs_close,
>  	.read			= mbochs_read,
> @@ -1432,6 +1427,15 @@ static const struct mdev_parent_ops mdev_fops = {
>  	.mmap			= mbochs_mmap,
>  };
>  
> +static const struct mdev_parent_ops mdev_fops = {
> +	.owner			= THIS_MODULE,
> +	.mdev_attr_groups	= mdev_dev_groups,
> +	.supported_type_groups	= mdev_type_groups,
> +	.create			= mbochs_create,
> +	.remove			= mbochs_remove,
> +	.device_ops		= &vfio_mdev_ops,
> +};
> +
>  static const struct file_operations vd_fops = {
>  	.owner		= THIS_MODULE,
>  };
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index d3029dd27d91..4ba285a5768f 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -725,12 +725,7 @@ static struct attribute_group *mdev_type_groups[] = {
>  	NULL,
>  };
>  
> -static const struct mdev_parent_ops mdev_fops = {
> -	.owner			= THIS_MODULE,
> -	.mdev_attr_groups	= mdev_dev_groups,
> -	.supported_type_groups	= mdev_type_groups,
> -	.create			= mdpy_create,
> -	.remove			= mdpy_remove,
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
>  	.open			= mdpy_open,
>  	.release		= mdpy_close,
>  	.read			= mdpy_read,
> @@ -739,6 +734,15 @@ static const struct mdev_parent_ops mdev_fops = {
>  	.mmap			= mdpy_mmap,
>  };
>  
> +static const struct mdev_parent_ops mdev_fops = {
> +	.owner			= THIS_MODULE,
> +	.mdev_attr_groups	= mdev_dev_groups,
> +	.supported_type_groups	= mdev_type_groups,
> +	.create			= mdpy_create,
> +	.remove			= mdpy_remove,
> +	.device_ops		= &vfio_mdev_ops,
> +};
> +
>  static const struct file_operations vd_fops = {
>  	.owner		= THIS_MODULE,
>  };
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 744c88a6b22c..a468904ec626 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -1410,6 +1410,14 @@ static struct attribute_group *mdev_type_groups[] = {
>  	NULL,
>  };
>  
> +static const struct vfio_mdev_parent_ops vfio_mdev_ops = {
> +	.open                   = mtty_open,
> +	.release                = mtty_close,
> +	.read                   = mtty_read,
> +	.write                  = mtty_write,
> +	.ioctl		        = mtty_ioctl,
> +};
> +
>  static const struct mdev_parent_ops mdev_fops = {
>  	.owner                  = THIS_MODULE,
>  	.dev_attr_groups        = mtty_dev_groups,
> @@ -1417,11 +1425,7 @@ static const struct mdev_parent_ops mdev_fops = {
>  	.supported_type_groups  = mdev_type_groups,
>  	.create                 = mtty_create,
>  	.remove			= mtty_remove,
> -	.open                   = mtty_open,
> -	.release                = mtty_close,
> -	.read                   = mtty_read,
> -	.write                  = mtty_write,
> -	.ioctl		        = mtty_ioctl,
> +	.device_ops             = &vfio_mdev_ops,
>  };
>  
>  static void mtty_device_release(struct device *dev)
> -- 
> 2.19.1
