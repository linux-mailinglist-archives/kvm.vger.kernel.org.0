Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E976E2BCA
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 23:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDNVhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 17:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDNVhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 17:37:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D57365B3
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 14:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681508179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xO3JWd65erI53kZpfQpE+HrurqCOXGCS2o0sdPSeZa8=;
        b=XGXSQDKA6cj3b611HBSf/b8yNjS7ialFu3Cbqszcccl6DQW0K+4VBJAr1ER0UmKBd+jiQe
        6r+BWwJagk+CHGbSdSM5tQcZkMEI4tJuXvXFAVSu2wD4tAN5V9m4iFmLwVIg1/mrmOaxoi
        cA7SejSdNj0FGufqgKlw9auFqrlSzfc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-WeFy6KZFOASptMsmHkhNLg-1; Fri, 14 Apr 2023 17:36:18 -0400
X-MC-Unique: WeFy6KZFOASptMsmHkhNLg-1
Received: by mail-io1-f70.google.com with SMTP id h7-20020a6bb707000000b00760a8765317so3973971iof.23
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 14:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681508177; x=1684100177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xO3JWd65erI53kZpfQpE+HrurqCOXGCS2o0sdPSeZa8=;
        b=l94OnqmVD2JShX0RifJWI4KZvLlYN0GpJOxCTp5UGqcl5yrXn01kYEh6zTaoOljNJw
         afLZSW2LJotEUYP233pbb6084zg8oj0WefG7dCn2QgnnettmKoT9lqinimifU8NRjvdK
         FlY8/ERtUKWxxHM6OX7FemkYnYfIxzp77xNyiGj+VGSmedwt094MLF4x0/2t8xHU/U/A
         +1fhLuMyd3ps0fcpsbdifbh2Y86HOjk3xluAjud52ctTwNusl40QLD4Zr+0Wv3tCOTwK
         MpvNNo1G3h8HiXDRGu+WwDjoj+2HlQg9iWGxFZCSRzyc2OKqGcZCykfhRU0UGY95i2Zb
         +MvQ==
X-Gm-Message-State: AAQBX9dn5sa/FYsMJzlW8q3PYPz5jHwoa5FSn51+/iIgUNxgBwZctYS1
        zqMeZOXxCc36Tq1A2mSK7p2HB7mb4cqFME+TKgmv41ONfXSUAGm1G8G353ZcPU4dpZuwYzICtIL
        xMenStbJoVB62
X-Received: by 2002:a5d:8751:0:b0:760:a07c:322a with SMTP id k17-20020a5d8751000000b00760a07c322amr3989278iol.19.1681508177186;
        Fri, 14 Apr 2023 14:36:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350afe+UHgm1ft5e8i3TFAWW9bI+/REl1rcVD1bgad6mOAmIo+b9HDevL2yUzYeCN/o8JQam5ig==
X-Received: by 2002:a5d:8751:0:b0:760:a07c:322a with SMTP id k17-20020a5d8751000000b00760a07c322amr3989267iol.19.1681508176799;
        Fri, 14 Apr 2023 14:36:16 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r16-20020a6bfc10000000b0075d23c433efsm1313798ioh.29.2023.04.14.14.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 14:36:16 -0700 (PDT)
Date:   Fri, 14 Apr 2023 15:36:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nipun Gupta <nipun.gupta@amd.com>
Cc:     <jgg@ziepe.ca>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <masahiroy@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <nicolas@fjasle.eu>, <git@amd.com>,
        <harpreet.anand@amd.com>, <pieter.jansen-van-vuuren@amd.com>,
        <nikhil.agarwal@amd.com>, <michal.simek@amd.com>
Subject: Re: [PATCH v2] vfio/cdx: add support for CDX bus
Message-ID: <20230414153614.3b72e659.alex.williamson@redhat.com>
In-Reply-To: <20230414123414.21645-1-nipun.gupta@amd.com>
References: <20230414123414.21645-1-nipun.gupta@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Apr 2023 18:04:14 +0530
Nipun Gupta <nipun.gupta@amd.com> wrote:

> vfio-cdx driver enables IOCTLs for user space to query
> MMIO regions for CDX devices and mmap them. This change
> also adds support for reset of CDX devices.
> 
> This change adds the VFIO CDX driver and enables the following
> ioctls for CDX devices:
>  - VFIO_DEVICE_GET_INFO:
>  - VFIO_DEVICE_GET_REGION_INFO
>  - VFIO_DEVICE_RESET
> 
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Tested-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
> ---
> 
> Changes v1->v2:
> - Updated file2alias to support vfio_cdx
> - removed some un-necessary checks in mmap
> - removed vfio reset wrapper API
> - converted complex macros to static APIs
> - used pgprot_device and io_remap_pfn_range
> 
>  MAINTAINERS                         |   7 +
>  drivers/vfio/Kconfig                |   1 +
>  drivers/vfio/Makefile               |   1 +
>  drivers/vfio/cdx/Kconfig            |  17 ++
>  drivers/vfio/cdx/Makefile           |   8 +
>  drivers/vfio/cdx/vfio_cdx.c         | 290 ++++++++++++++++++++++++++++
>  drivers/vfio/cdx/vfio_cdx_private.h |  31 +++
>  include/linux/cdx/cdx_bus.h         |   1 -
>  include/linux/mod_devicetable.h     |   6 +
>  scripts/mod/devicetable-offsets.c   |   1 +
>  scripts/mod/file2alias.c            |  17 +-
>  11 files changed, 378 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/cdx/Kconfig
>  create mode 100644 drivers/vfio/cdx/Makefile
>  create mode 100644 drivers/vfio/cdx/vfio_cdx.c
>  create mode 100644 drivers/vfio/cdx/vfio_cdx_private.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7f74d8571ac9..c4fd42ba8f46 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22064,6 +22064,13 @@ F:	Documentation/filesystems/vfat.rst
>  F:	fs/fat/
>  F:	tools/testing/selftests/filesystems/fat/
>  
> +VFIO CDX DRIVER
> +M:	Nipun Gupta <nipun.gupta@amd.com>
> +M:	Nikhil Agarwal <nikhil.agarwal@amd.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/cdx/*
> +
>  VFIO DRIVER
>  M:	Alex Williamson <alex.williamson@redhat.com>
>  L:	kvm@vger.kernel.org
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 89e06c981e43..aba36f5be4ec 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -57,6 +57,7 @@ source "drivers/vfio/pci/Kconfig"
>  source "drivers/vfio/platform/Kconfig"
>  source "drivers/vfio/mdev/Kconfig"
>  source "drivers/vfio/fsl-mc/Kconfig"
> +source "drivers/vfio/cdx/Kconfig"
>  endif
>  
>  source "virt/lib/Kconfig"
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 70e7dcb302ef..1a27b2516612 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -14,3 +14,4 @@ obj-$(CONFIG_VFIO_PCI) += pci/
>  obj-$(CONFIG_VFIO_PLATFORM) += platform/
>  obj-$(CONFIG_VFIO_MDEV) += mdev/
>  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
> +obj-$(CONFIG_VFIO_CDX) += cdx/
> diff --git a/drivers/vfio/cdx/Kconfig b/drivers/vfio/cdx/Kconfig
> new file mode 100644
> index 000000000000..e6de0a0caa32
> --- /dev/null
> +++ b/drivers/vfio/cdx/Kconfig
> @@ -0,0 +1,17 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# VFIO CDX configuration
> +#
> +# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> +#
> +
> +config VFIO_CDX
> +	tristate "VFIO support for CDX bus devices"
> +	depends on CDX_BUS
> +	select EVENTFD
> +	help
> +	  Driver to enable VFIO support for the devices on CDX bus.
> +	  This is required to make use of CDX devices present in
> +	  the system using the VFIO framework.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
> new file mode 100644
> index 000000000000..82e4ef412c0f
> --- /dev/null
> +++ b/drivers/vfio/cdx/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> +#
> +
> +obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
> +
> +vfio-cdx-objs := vfio_cdx.o
> diff --git a/drivers/vfio/cdx/vfio_cdx.c b/drivers/vfio/cdx/vfio_cdx.c
> new file mode 100644
> index 000000000000..c19062ce7680
> --- /dev/null
> +++ b/drivers/vfio/cdx/vfio_cdx.c
> @@ -0,0 +1,290 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> + */
> +
> +#include <linux/vfio.h>
> +#include <linux/cdx/cdx_bus.h>
> +
> +#include "vfio_cdx_private.h"
> +
> +static struct cdx_driver vfio_cdx_driver;
> +
> +static int vfio_cdx_init_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_cdx_device *vdev =
> +		container_of(core_vdev, struct vfio_cdx_device, vdev);
> +	struct cdx_device *cdx_dev = to_cdx_device(core_vdev->dev);
> +
> +	vdev->cdx_dev = cdx_dev;
> +	vdev->dev = &cdx_dev->dev;

Both of these seem trivial to factor out of this patch, cdx_device is
always available via to_cdx_device(core_vdev->dev) and the struct
device is always available via core_vdev->dev.  vdev->dev isn't even
used anywhere yet.  Both the init and release functions here could be
dropped afaict.

> +
> +	return 0;
> +}
> +
> +static void vfio_cdx_release_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_cdx_device *vdev =
> +		container_of(core_vdev, struct vfio_cdx_device, vdev);
> +
> +	vdev->cdx_dev = NULL;
> +	vdev->dev = NULL;
> +}
> +
> +/**
> + * CDX_DRIVER_OVERRIDE_DEVICE_VFIO - macro used to describe a VFIO
> + *                                   "driver_override" CDX device.
> + * @vend: the 16 bit CDX Vendor ID
> + * @dev: the 16 bit CDX Device ID
> + *
> + * This macro is used to create a struct cdx_device_id that matches a
> + * specific device. driver_override will be set to
> + * CDX_ID_F_VFIO_DRIVER_OVERRIDE.
> + */
> +#define CDX_DRIVER_OVERRIDE_DEVICE_VFIO(vend, dev) \
> +	CDX_DEVICE_DRIVER_OVERRIDE(vend, dev, CDX_ID_F_VFIO_DRIVER_OVERRIDE)
> +
> +static int vfio_cdx_open_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_cdx_device *vdev =
> +		container_of(core_vdev, struct vfio_cdx_device, vdev);
> +	struct cdx_device *cdx_dev = vdev->cdx_dev;
> +	int count = cdx_dev->res_count;
> +	int i;
> +
> +	vdev->regions = kcalloc(count, sizeof(struct vfio_cdx_region),
> +				GFP_KERNEL);
> +	if (!vdev->regions)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < count; i++) {
> +		struct resource *res = &cdx_dev->res[i];
> +
> +		vdev->regions[i].addr = res->start;
> +		vdev->regions[i].size = resource_size(res);
> +		vdev->regions[i].type = res->flags;
> +		/*
> +		 * Only regions addressed with PAGE granularity may be
> +		 * MMAP'ed securely.
> +		 */
> +		if (!(vdev->regions[i].addr & ~PAGE_MASK) &&
> +		    !(vdev->regions[i].size & ~PAGE_MASK))
> +			vdev->regions[i].flags |=
> +					VFIO_REGION_INFO_FLAG_MMAP;
> +		vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
> +		if (!(cdx_dev->res[i].flags & IORESOURCE_READONLY))
> +			vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
> +	}
> +
> +	return 0;
> +}
> +
> +static void vfio_cdx_regions_cleanup(struct vfio_cdx_device *vdev)
> +{
> +	kfree(vdev->regions);
> +}
> +
> +static void vfio_cdx_close_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_cdx_device *vdev =
> +		container_of(core_vdev, struct vfio_cdx_device, vdev);
> +	int ret;
> +
> +	vfio_cdx_regions_cleanup(vdev);
> +
> +	/* reset the device before cleaning up the interrupts */
> +	ret = cdx_dev_reset(&vdev->cdx_dev->dev);
> +	if (WARN_ON(ret))
> +		dev_warn(core_vdev->dev,
> +			 "VFIO_CDX: reset device has failed (%d)\n", ret);

WARN_ON() + dev_warn(), do we need both?  Curious we're not even using
vdev->dev here ;)

> +}
> +
> +static long vfio_cdx_ioctl(struct vfio_device *core_vdev,
> +			   unsigned int cmd, unsigned long arg)
> +{
> +	struct vfio_cdx_device *vdev =
> +		container_of(core_vdev, struct vfio_cdx_device, vdev);
> +	struct cdx_device *cdx_dev = vdev->cdx_dev;
> +	unsigned long minsz;
> +
> +	switch (cmd) {
> +	case VFIO_DEVICE_GET_INFO:
> +	{
> +		struct vfio_device_info info;
> +
> +		minsz = offsetofend(struct vfio_device_info, num_irqs);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		info.flags = VFIO_DEVICE_FLAGS_RESET;

There ought to be a flag here indicating the vfio device exposed is
vfio-cdx.

> +
> +		info.num_regions = cdx_dev->res_count;
> +		info.num_irqs = 0;
> +
> +		return copy_to_user((void __user *)arg, &info, minsz) ?
> +			-EFAULT : 0;
> +	}
> +	case VFIO_DEVICE_GET_REGION_INFO:
> +	{
> +		struct vfio_region_info info;
> +
> +		minsz = offsetofend(struct vfio_region_info, offset);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (info.index >= cdx_dev->res_count)
> +			return -EINVAL;
> +
> +		/* map offset to the physical address  */
> +		info.offset = vfio_cdx_index_to_offset(info.index);
> +		info.size = vdev->regions[info.index].size;
> +		info.flags = vdev->regions[info.index].flags;
> +
> +		if (copy_to_user((void __user *)arg, &info, minsz))
> +			return -EFAULT;
> +		return 0;
> +	}
> +	case VFIO_DEVICE_RESET:
> +	{
> +		return cdx_dev_reset(&vdev->cdx_dev->dev);
> +	}
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
> +static int vfio_cdx_mmap_mmio(struct vfio_cdx_region region,
> +			      struct vm_area_struct *vma)
> +{
> +	u64 size = vma->vm_end - vma->vm_start;
> +	u64 pgoff, base;
> +
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	base = pgoff << PAGE_SHIFT;
> +
> +	if (region.size < PAGE_SIZE || base + size > region.size)
> +		return -EINVAL;
> +
> +	vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
> +	vma->vm_page_prot = pgprot_device(vma->vm_page_prot);
> +
> +	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> +				  size, vma->vm_page_prot);
> +}
> +
> +static int vfio_cdx_mmap(struct vfio_device *core_vdev,
> +			 struct vm_area_struct *vma)
> +{
> +	struct vfio_cdx_device *vdev =
> +		container_of(core_vdev, struct vfio_cdx_device, vdev);
> +	struct cdx_device *cdx_dev = vdev->cdx_dev;
> +	unsigned int index;
> +
> +	index = vma->vm_pgoff >> (VFIO_CDX_OFFSET_SHIFT - PAGE_SHIFT);
> +
> +	if (index >= cdx_dev->res_count)
> +		return -EINVAL;
> +
> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_MMAP))
> +		return -EINVAL;
> +
> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_READ) &&
> +	    (vma->vm_flags & VM_READ))
> +		return -EINVAL;
> +
> +	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &&
> +	    (vma->vm_flags & VM_WRITE))
> +		return -EINVAL;
> +
> +	return vfio_cdx_mmap_mmio(vdev->regions[index], vma);
> +}
> +
> +static const struct vfio_device_ops vfio_cdx_ops = {
> +	.name		= "vfio-cdx",
> +	.init		= vfio_cdx_init_device,
> +	.release	= vfio_cdx_release_device,
> +	.open_device	= vfio_cdx_open_device,
> +	.close_device	= vfio_cdx_close_device,
> +	.ioctl		= vfio_cdx_ioctl,
> +	.mmap		= vfio_cdx_mmap,

Missing bind_iommufd, unbind_iommufd, and attach_ioas, which will be
necessary for iommufd support.

> +};
> +
> +static int vfio_cdx_probe(struct cdx_device *cdx_dev)
> +{
> +	struct vfio_cdx_device *vdev = NULL;
> +	struct device *dev = &cdx_dev->dev;
> +	int ret;
> +
> +	vdev = vfio_alloc_device(vfio_cdx_device, vdev, dev,
> +				 &vfio_cdx_ops);
> +	if (IS_ERR(vdev))
> +		return PTR_ERR(vdev);
> +
> +	ret = vfio_register_group_dev(&vdev->vdev);
> +	if (ret) {
> +		dev_err(dev, "VFIO_CDX: Failed to add to vfio group\n");
> +		goto out_uninit;
> +	}
> +
> +	dev_set_drvdata(dev, vdev);
> +	return 0;
> +
> +out_uninit:
> +	vfio_put_device(&vdev->vdev);
> +	return ret;
> +}
> +
> +static int vfio_cdx_remove(struct cdx_device *cdx_dev)
> +{
> +	struct device *dev = &cdx_dev->dev;
> +	struct vfio_cdx_device *vdev;
> +
> +	vdev = dev_get_drvdata(dev);
> +	vfio_unregister_group_dev(&vdev->vdev);
> +	vfio_put_device(&vdev->vdev);
> +
> +	return 0;
> +}
> +
> +static const struct cdx_device_id vfio_cdx_table[] = {
> +	{ CDX_DRIVER_OVERRIDE_DEVICE_VFIO(CDX_ANY_ID, CDX_ANY_ID) }, /* match all by default */
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(cdx, vfio_cdx_table);
> +
> +static struct cdx_driver vfio_cdx_driver = {
> +	.probe		= vfio_cdx_probe,
> +	.remove		= vfio_cdx_remove,
> +	.match_id_table	= vfio_cdx_table,
> +	.driver	= {
> +		.name	= "vfio-cdx",
> +		.owner	= THIS_MODULE,
> +	},
> +	.driver_managed_dma = true,
> +};
> +
> +static int __init vfio_cdx_driver_init(void)
> +{
> +	return cdx_driver_register(&vfio_cdx_driver);
> +}
> +
> +static void __exit vfio_cdx_driver_exit(void)
> +{
> +	cdx_driver_unregister(&vfio_cdx_driver);
> +}
> +
> +module_init(vfio_cdx_driver_init);
> +module_exit(vfio_cdx_driver_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("VFIO for CDX devices - User Level meta-driver");
> diff --git a/drivers/vfio/cdx/vfio_cdx_private.h b/drivers/vfio/cdx/vfio_cdx_private.h
> new file mode 100644
> index 000000000000..5f143736eb7a
> --- /dev/null
> +++ b/drivers/vfio/cdx/vfio_cdx_private.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
> + */
> +
> +#ifndef VFIO_CDX_PRIVATE_H
> +#define VFIO_CDX_PRIVATE_H
> +
> +#define VFIO_CDX_OFFSET_SHIFT    40
> +
> +static inline u64 vfio_cdx_index_to_offset(u32 index)
> +{
> +	return ((u64)(index) << VFIO_CDX_OFFSET_SHIFT);
> +}
> +
> +struct vfio_cdx_region {
> +	u32			flags;
> +	u32			type;
> +	u64			addr;
> +	resource_size_t		size;
> +	void __iomem		*ioaddr;

I don't see that ioaddr is used in this patch.  Future r/w support?
Thanks,

Alex

> +};
> +
> +struct vfio_cdx_device {
> +	struct vfio_device	vdev;
> +	struct cdx_device	*cdx_dev;
> +	struct device		*dev;
> +	struct vfio_cdx_region	*regions;
> +};
> +
> +#endif /* VFIO_CDX_PRIVATE_H */
> diff --git a/include/linux/cdx/cdx_bus.h b/include/linux/cdx/cdx_bus.h
> index 35ef41d8a61a..bead71b7bc73 100644
> --- a/include/linux/cdx/cdx_bus.h
> +++ b/include/linux/cdx/cdx_bus.h
> @@ -14,7 +14,6 @@
>  #include <linux/mod_devicetable.h>
>  
>  #define MAX_CDX_DEV_RESOURCES	4
> -#define CDX_ANY_ID (0xFFFF)
>  #define CDX_CONTROLLER_ID_SHIFT 4
>  #define CDX_BUS_NUM_MASK 0xF
>  
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index ccaaeda792c0..ccf017353bb6 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -912,6 +912,12 @@ struct ishtp_device_id {
>  	kernel_ulong_t driver_data;
>  };
>  
> +#define CDX_ANY_ID (0xFFFF)
> +
> +enum {
> +	CDX_ID_F_VFIO_DRIVER_OVERRIDE = 1,
> +};
> +
>  /**
>   * struct cdx_device_id - CDX device identifier
>   * @vendor: Vendor ID
> diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
> index 62dc988df84d..abe65f8968dd 100644
> --- a/scripts/mod/devicetable-offsets.c
> +++ b/scripts/mod/devicetable-offsets.c
> @@ -265,6 +265,7 @@ int main(void)
>  	DEVID(cdx_device_id);
>  	DEVID_FIELD(cdx_device_id, vendor);
>  	DEVID_FIELD(cdx_device_id, device);
> +	DEVID_FIELD(cdx_device_id, override_only);
>  
>  	return 0;
>  }
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 28da34ba4359..38120f932b0d 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -1458,8 +1458,23 @@ static int do_cdx_entry(const char *filename, void *symval,
>  {
>  	DEF_FIELD(symval, cdx_device_id, vendor);
>  	DEF_FIELD(symval, cdx_device_id, device);
> +	DEF_FIELD(symval, cdx_device_id, override_only);
>  
> -	sprintf(alias, "cdx:v%08Xd%08Xd", vendor, device);
> +	switch (override_only) {
> +	case 0:
> +		strcpy(alias, "cdx:");
> +		break;
> +	case CDX_ID_F_VFIO_DRIVER_OVERRIDE:
> +		strcpy(alias, "vfio_cdx:");
> +		break;
> +	default:
> +		warn("Unknown CDX driver_override alias %08X\n",
> +		     override_only);
> +		return 0;
> +	}
> +
> +	ADD(alias, "v", vendor != CDX_ANY_ID, vendor);
> +	ADD(alias, "d", device != CDX_ANY_ID, device);
>  	return 1;
>  }
>  

