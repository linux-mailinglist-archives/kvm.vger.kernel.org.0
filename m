Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D266CF3D6
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 21:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjC2T6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 15:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjC2T6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 15:58:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707D983
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 12:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680119848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mlzNdSqBUq7hFdpaURYUAN0/X+/m9jx/CyLubt4sDCs=;
        b=bIgy7nIp5LwV1S5RKFReri9rr7P/D80WZtj/sI152mmL++ebainVMUlteK1SpZyA4IBfAB
        XF2Uq6oiPcB788PC9DOTiwECaP2afj2HIjfEvku42ee/tnuvO9S67HZJpQBXi7cFJZ2aj5
        nrIhszN/yG8sEqwyNsjyabtZ15MXFTc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-_JIOW46iPuWH5n0n3qKapA-1; Wed, 29 Mar 2023 15:57:23 -0400
X-MC-Unique: _JIOW46iPuWH5n0n3qKapA-1
Received: by mail-il1-f197.google.com with SMTP id o15-20020a056e02102f00b003261821bf26so5266952ilj.1
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 12:57:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680119842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mlzNdSqBUq7hFdpaURYUAN0/X+/m9jx/CyLubt4sDCs=;
        b=Gx31gQrz8qz+/QGMdDd3srJpSKZBBbVgM4k01st67HgdxXVE0oQQyVLhdDYQNiqa53
         jL3sLpdufbRmpZMtlDnhUsca1EtizJADvxUO4Klqjp1mCWMX8yRY/u841dqJtecA7NO4
         eHhPfilGCBhg3fgHkx5+PJYdBEgK1dKAGQc8BoASDlO4oTA9/1wkKM2JN0aL4iljsOHA
         CbQrrcf88DfLk7d3a1sJrsmx+TKaUss1TsVvmNTKQAlCuJ4rFtdcLDNnpHoKRwySiK0w
         ZDVV1sVyO5qHhBYoAIMXQi9LE4zme/+Omko6MOhE0FLu/kPmJ6F1eimivKh4sjhQBM4V
         FZTw==
X-Gm-Message-State: AAQBX9dCb+oQouGIA0Bl5BpSP+xXsjABbMqeXK/Hf8ynBGGXstnFfwzX
        a706PXPLV4AnQ8r7YQlb7yF294qMsIkUs5rAprVWJNSxmnNOntgfxfmtPomn7futen6+vKWkTtf
        M77RA9KM9PrjQ
X-Received: by 2002:a92:6f04:0:b0:326:2025:84e4 with SMTP id k4-20020a926f04000000b00326202584e4mr4998904ilc.3.1680119842334;
        Wed, 29 Mar 2023 12:57:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350aYXa0G8+E8laT0e6XCb4RulheIoXfK+T0gQxRLx9CaDoZVRLKJon6W/GPMEeYbFb3gGnwj0w==
X-Received: by 2002:a92:6f04:0:b0:326:2025:84e4 with SMTP id k4-20020a926f04000000b00326202584e4mr4998898ilc.3.1680119841975;
        Wed, 29 Mar 2023 12:57:21 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q10-20020a056e020c2a00b00316e54a8287sm9583344ilg.14.2023.03.29.12.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 12:57:21 -0700 (PDT)
Date:   Wed, 29 Mar 2023 13:57:19 -0600
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
Subject: Re: [PATCH v8 20/24] vfio: Add cdev for vfio_device
Message-ID: <20230329135719.22ac6c12.alex.williamson@redhat.com>
In-Reply-To: <20230327094047.47215-21-yi.l.liu@intel.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
        <20230327094047.47215-21-yi.l.liu@intel.com>
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

On Mon, 27 Mar 2023 02:40:43 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This allows user to directly open a vfio device w/o using the legacy
> container/group interface, as a prerequisite for supporting new iommu
> features like nested translation.
> 
> The device fd opened in this manner doesn't have the capability to access
> the device as the fops open() doesn't open the device until the successful
> BIND_IOMMUFD which be added in next patch.
> 
> With this patch, devices registered to vfio core have both group and device
> interface created.
> 
> - group interface : /dev/vfio/$groupID
> - device interface: /dev/vfio/devices/vfioX - normal device
> 		    /dev/vfio/devices/noiommu-vfioX - noiommu device
> 		    ("X" is the minor number and is unique across devices)
> 
> Given a vfio device the user can identify the matching vfioX by checking
> the sysfs path of the device. Take PCI device (0000:6a:01.0) for example,
> /sys/bus/pci/devices/0000\:6a\:01.0/vfio-dev/vfio0/dev contains the
> major:minor of the matching vfioX.
> 
> Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
> that the major:minor matches.
> 
> The vfio_device cdev logic in this patch:
> *) __vfio_register_dev() path ends up doing cdev_device_add() for each
>    vfio_device if VFIO_DEVICE_CDEV configured.
> *) vfio_unregister_group_dev() path does cdev_device_del();
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/Kconfig       | 11 +++++++
>  drivers/vfio/Makefile      |  1 +
>  drivers/vfio/device_cdev.c | 62 ++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h        | 46 ++++++++++++++++++++++++++++
>  drivers/vfio/vfio_main.c   | 26 +++++++++++-----
>  include/linux/vfio.h       |  4 +++
>  6 files changed, 143 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/vfio/device_cdev.c
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 89e06c981e43..e2105b4dac2d 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -12,6 +12,17 @@ menuconfig VFIO
>  	  If you don't know what to do here, say N.
>  
>  if VFIO
> +config VFIO_DEVICE_CDEV
> +	bool "Support for the VFIO cdev /dev/vfio/devices/vfioX"
> +	depends on IOMMUFD
> +	help
> +	  The VFIO device cdev is another way for userspace to get device
> +	  access. Userspace gets device fd by opening device cdev under
> +	  /dev/vfio/devices/vfioX, and then bind the device fd with an iommufd
> +	  to set up secure DMA context for device access.
> +
> +	  If you don't know what to do here, say N.
> +
>  config VFIO_CONTAINER
>  	bool "Support for the VFIO container /dev/vfio/vfio"
>  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 70e7dcb302ef..245394aeb94b 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -4,6 +4,7 @@ obj-$(CONFIG_VFIO) += vfio.o
>  vfio-y += vfio_main.o \
>  	  group.o \
>  	  iova_bitmap.o
> +vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
>  vfio-$(CONFIG_IOMMUFD) += iommufd.o
>  vfio-$(CONFIG_VFIO_CONTAINER) += container.o
>  vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> new file mode 100644
> index 000000000000..1c640016a824
> --- /dev/null
> +++ b/drivers/vfio/device_cdev.c
> @@ -0,0 +1,62 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023 Intel Corporation.
> + */
> +#include <linux/vfio.h>
> +
> +#include "vfio.h"
> +
> +static dev_t device_devt;
> +
> +void vfio_init_device_cdev(struct vfio_device *device)
> +{
> +	device->device.devt = MKDEV(MAJOR(device_devt), device->index);
> +	cdev_init(&device->cdev, &vfio_device_fops);
> +	device->cdev.owner = THIS_MODULE;
> +}
> +
> +/*
> + * device access via the fd opened by this function is blocked until
> + * .open_device() is called successfully during BIND_IOMMUFD.
> + */
> +int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> +{
> +	struct vfio_device *device = container_of(inode->i_cdev,
> +						  struct vfio_device, cdev);
> +	struct vfio_device_file *df;
> +	int ret;
> +
> +	if (!vfio_device_try_get_registration(device))
> +		return -ENODEV;
> +
> +	df = vfio_allocate_device_file(device);
> +	if (IS_ERR(df)) {
> +		ret = PTR_ERR(df);
> +		goto err_put_registration;
> +	}
> +
> +	filep->private_data = df;
> +
> +	return 0;
> +
> +err_put_registration:
> +	vfio_device_put_registration(device);
> +	return ret;
> +}
> +
> +static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
> +{
> +	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> +}
> +
> +int vfio_cdev_init(struct class *device_class)
> +{
> +	device_class->devnode = vfio_device_devnode;
> +	return alloc_chrdev_region(&device_devt, 0,
> +				   MINORMASK + 1, "vfio-dev");
> +}
> +
> +void vfio_cdev_cleanup(void)
> +{
> +	unregister_chrdev_region(device_devt, MINORMASK + 1);
> +}
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 41dfc9d5205a..3a8fd0e32f59 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -268,6 +268,52 @@ static inline void vfio_iommufd_unbind(struct vfio_device_file *df)
>  }
>  #endif
>  
> +#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
> +static inline int vfio_device_add(struct vfio_device *device)
> +{
> +	return cdev_device_add(&device->cdev, &device->device);
> +}
> +
> +static inline void vfio_device_del(struct vfio_device *device)
> +{
> +	cdev_device_del(&device->cdev, &device->device);
> +}
> +
> +void vfio_init_device_cdev(struct vfio_device *device);
> +int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
> +int vfio_cdev_init(struct class *device_class);
> +void vfio_cdev_cleanup(void);
> +#else
> +static inline int vfio_device_add(struct vfio_device *device)
> +{
> +	return device_add(&device->device);
> +}
> +
> +static inline void vfio_device_del(struct vfio_device *device)
> +{
> +	device_del(&device->device);
> +}
> +
> +static inline void vfio_init_device_cdev(struct vfio_device *device)
> +{
> +}
> +
> +static inline int vfio_device_fops_cdev_open(struct inode *inode,
> +					     struct file *filep)
> +{
> +	return 0;
> +}
> +
> +static inline int vfio_cdev_init(struct class *device_class)
> +{
> +	return 0;
> +}
> +
> +static inline void vfio_cdev_cleanup(void)
> +{
> +}
> +#endif /* CONFIG_VFIO_DEVICE_CDEV */
> +
>  #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
>  int __init vfio_virqfd_init(void);
>  void vfio_virqfd_exit(void);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 8e96aab27029..58fc3bb768f2 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -242,6 +242,7 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
>  	device->device.release = vfio_device_release;
>  	device->device.class = vfio.device_class;
>  	device->device.parent = device->dev;
> +	vfio_init_device_cdev(device);
>  	return 0;
>  
>  out_uninit:
> @@ -280,7 +281,7 @@ static int __vfio_register_dev(struct vfio_device *device,
>  	if (ret)
>  		goto err_out;
>  
> -	ret = device_add(&device->device);
> +	ret = vfio_device_add(device);
>  	if (ret)
>  		goto err_out;
>  
> @@ -320,6 +321,12 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  	bool interrupted = false;
>  	long rc;
>  
> +	/* Prevent new device opened in the group path */
> +	vfio_device_group_unregister(device);
> +
> +	/* Prevent new device opened in the cdev path */
> +	vfio_device_del(device);
> +
>  	vfio_device_put_registration(device);
>  	rc = try_wait_for_completion(&device->comp);
>  	while (rc <= 0) {
> @@ -343,11 +350,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  		}
>  	}
>  
> -	vfio_device_group_unregister(device);
> -
> -	/* Balances device_add in register path */
> -	device_del(&device->device);
> -

Why were these relocated?  And additionally why was the comment
regarding the balance operations dropped?  The move seems unrelated to
the patch here, so if it's actually advisable for some reason, it
should be a separate patch.  Thanks,

Alex

>  	/* Balances vfio_device_set_group in register path */
>  	vfio_device_remove_group(device);
>  }
> @@ -555,7 +557,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> -	vfio_device_group_close(df);
> +	if (df->group)
> +		vfio_device_group_close(df);
>  
>  	vfio_device_put_registration(device);
>  
> @@ -1204,6 +1207,7 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
>  
>  const struct file_operations vfio_device_fops = {
>  	.owner		= THIS_MODULE,
> +	.open		= vfio_device_fops_cdev_open,
>  	.release	= vfio_device_fops_release,
>  	.read		= vfio_device_fops_read,
>  	.write		= vfio_device_fops_write,
> @@ -1590,9 +1594,16 @@ static int __init vfio_init(void)
>  		goto err_dev_class;
>  	}
>  
> +	ret = vfio_cdev_init(vfio.device_class);
> +	if (ret)
> +		goto err_alloc_dev_chrdev;
> +
>  	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>  	return 0;
>  
> +err_alloc_dev_chrdev:
> +	class_destroy(vfio.device_class);
> +	vfio.device_class = NULL;
>  err_dev_class:
>  	vfio_virqfd_exit();
>  err_virqfd:
> @@ -1603,6 +1614,7 @@ static int __init vfio_init(void)
>  static void __exit vfio_cleanup(void)
>  {
>  	ida_destroy(&vfio.device_ida);
> +	vfio_cdev_cleanup();
>  	class_destroy(vfio.device_class);
>  	vfio.device_class = NULL;
>  	vfio_virqfd_exit();
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 5c06af04ed9e..8719ec2adbbb 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -13,6 +13,7 @@
>  #include <linux/mm.h>
>  #include <linux/workqueue.h>
>  #include <linux/poll.h>
> +#include <linux/cdev.h>
>  #include <uapi/linux/vfio.h>
>  #include <linux/iova_bitmap.h>
>  
> @@ -51,6 +52,9 @@ struct vfio_device {
>  	/* Members below here are private, not for driver use */
>  	unsigned int index;
>  	struct device device;	/* device.kref covers object life circle */
> +#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
> +	struct cdev cdev;
> +#endif
>  	refcount_t refcount;	/* user count on registered device*/
>  	unsigned int open_count;
>  	struct completion comp;

