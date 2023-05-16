Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD9B705949
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 23:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjEPVKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 17:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjEPVKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 17:10:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C11E7682
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 14:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684271360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=643fYsQZ1fDNY6BVUTHGfYuSL8yeWpaf18fS6acrZro=;
        b=b0mFglPCLSh4hcG2EEjDbZtOh20byQDpQNB/JPWGP4z6ffO1oeuAov6R6vDU4cGHd7VBFb
        t1vvJlQm3EdRCPbBYTfvmcDS6MJhoak25XW8fCl5EpBTWmLU55i7sBqgNlJ4FQpIdbHtId
        to+EV5y9fTUOGFJTDvwuApCkgjTzFks=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-Ym2qz1wrMI2zd1HhsuqYHg-1; Tue, 16 May 2023 17:09:18 -0400
X-MC-Unique: Ym2qz1wrMI2zd1HhsuqYHg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33389ee5c78so454905ab.3
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 14:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684271357; x=1686863357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=643fYsQZ1fDNY6BVUTHGfYuSL8yeWpaf18fS6acrZro=;
        b=N6XLa84GW+SW2XgFt6h5rmfg/JUCfEDz0KkQ+6MGphi/TMREAjYTcBppRLvX6aGgPn
         hGrk/vQN0Z4YS/I813k6FacT3jVMoiZj373mZck2dGgAyg9CMxUvKEbEHv76RYc4K2Mo
         I61YYXYZtbwiBxXg2Jp13x1PEjYDhelQmF2eQb1I47Hs4QuAlSg6tyykkhB2nCQvGw2D
         YeMmCM0VEbpcDzUDR3s5moMQlC4vgraBqkeI2VgXOUPo05oWlEyoVEos4lbGFLvGCWoU
         yFgsM9KpC9biK15Uk5ln1k6zbKrRUeZjJqj831JPHWekCT67z/GHvj1NnEqiI0RiW9e0
         WQyw==
X-Gm-Message-State: AC+VfDy4ZE8IwPNdwqBwTe4IwPzU/o+w24dkrT58s2w8FNJ22eeKwg+F
        I9C9r4Yua1jiWtelxQ24tw2xVnPRD5/eQf8PvSQvgskAJ/OAW5NsPLWXd8v8utzkZpOtprg1bc/
        zyqNn5d3wjFhg
X-Received: by 2002:a92:b0e:0:b0:32a:f852:318a with SMTP id b14-20020a920b0e000000b0032af852318amr365526ilf.24.1684271357582;
        Tue, 16 May 2023 14:09:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4KbImBC7NwUAl9CkIRFvUIfuuUaKWuqrlVRUgAc/QE3QoCsvFOiDWSJ7m1M/W/qt2VrM78ig==
X-Received: by 2002:a92:b0e:0:b0:32a:f852:318a with SMTP id b14-20020a920b0e000000b0032af852318amr365508ilf.24.1684271357220;
        Tue, 16 May 2023 14:09:17 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b6-20020a92dcc6000000b003350c8ae201sm7019640ilr.29.2023.05.16.14.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 14:09:16 -0700 (PDT)
Date:   Tue, 16 May 2023 15:09:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     <ankita@nvidia.com>
Cc:     <jgg@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
        <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
        <danw@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com
Subject: Re: [PATCH v2 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230516150914.26ae99c3.alex.williamson@redhat.com>
In-Reply-To: <20230509040734.24392-1-ankita@nvidia.com>
References: <20230509040734.24392-1-ankita@nvidia.com>
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

[Copying additional vfio-pci variant driver reviewers]

On Mon, 8 May 2023 21:07:34 -0700
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal propritary cache coherent interconnect.
> 
> This representation has a number of limitations compared to a real PCI
> device, in particular, it does not model the coherent GPU memory
> aperture as a PCI config space BAR, and PCI doesn't know anything
> about cacheable memory types.
> 
> Provide a VFIO PCI variant driver that adapts the unique PCI
> representation into a more standard PCI representation facing
> userspace. The GPU memory aperture is obtained from ACPI using
> device_property_read_u64(), according to the FW specification,
> and exported to userspace as the VFIO_REGION that covers the first
> PCI BAR. qemu will naturally generate a PCI device in the VM where the
> cacheable aperture is reported in BAR1.
> 
> Since this memory region is actually cache coherent with the CPU, the
> VFIO variant driver will mmap it into VMA using a cacheable mapping. The
> mapping is done using remap_pfn_range().
> 
> This goes along with a qemu series to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device.
> https://github.com/qemu/qemu/compare/master...ankita-nv:qemu:dev-ankit/cohmem-0330

This doesn't seem like a very stable link, a lore link to an RFC
posting would be preferred.

> This patch is split from a patch series being pursued separately:
> https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/
> 
> Applied and tested over v6.3-rc7.
> 
> v1 -> v2

Patch version changes can go below the '---' below to keep them out of
the committed change log.

> - Updated the wording of reference to BAR offset and replaced with
>   index.
> - The GPU memory is exposed at the fixed BAR2_REGION_INDEX.

Nit, the commit log above still refers to BAR1.

> - Code cleanup based on feedback comments.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                     |   6 +
>  drivers/vfio/pci/Kconfig        |   2 +
>  drivers/vfio/pci/Makefile       |   2 +
>  drivers/vfio/pci/nvgpu/Kconfig  |  10 ++
>  drivers/vfio/pci/nvgpu/Makefile |   3 +
>  drivers/vfio/pci/nvgpu/main.c   | 217 ++++++++++++++++++++++++++++++++
>  6 files changed, 240 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0e64787aace8..6b55861bbfbe 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21949,6 +21949,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/pci/mlx5/
>  
> +VFIO NVIDIA PCI DRIVER
> +M:	Ankit Agrawal <ankita@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/pci/nvgpu/
> +
>  VGA_SWITCHEROO
>  R:	Lukas Wunner <lukas@wunner.de>
>  S:	Maintained
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738..ade18b0ffb7b 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -59,4 +59,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
>  
>  source "drivers/vfio/pci/hisilicon/Kconfig"
>  
> +source "drivers/vfio/pci/nvgpu/Kconfig"
> +
>  endif
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 24c524224da5..0c93d452d0da 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>  obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> +
> +obj-$(CONFIG_NVGPU_VFIO_PCI) += nvgpu/
> diff --git a/drivers/vfio/pci/nvgpu/Kconfig b/drivers/vfio/pci/nvgpu/Kconfig
> new file mode 100644
> index 000000000000..066f764f7c5f
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgpu/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config NVGPU_VFIO_PCI
> +	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> +	select VFIO_PCI_CORE

I think this should be a 'depends on' as well, that's what we have for
the other vfio-pci variant drivers.

> +	help
> +	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
> +	  required to assign the GPU device to a VM using KVM/qemu/etc.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/nvgpu/Makefile b/drivers/vfio/pci/nvgpu/Makefile
> new file mode 100644
> index 000000000000..00fd3a078218
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgpu/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_NVGPU_VFIO_PCI) += nvgpu-vfio-pci.o
> +nvgpu-vfio-pci-y := main.o
> diff --git a/drivers/vfio/pci/nvgpu/main.c b/drivers/vfio/pci/nvgpu/main.c
> new file mode 100644
> index 000000000000..bb09dada9907
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgpu/main.c
> @@ -0,0 +1,217 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/vfio_pci_core.h>
> +
> +struct dev_mem_properties {
> +	uint64_t hpa;
> +	uint64_t mem_length;
> +};
> +
> +struct nvgpu_vfio_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	struct dev_mem_properties mem_prop;
> +};
> +
> +static int nvgpu_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	return ret;
> +}
> +
> +static int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
> +			struct vm_area_struct *vma)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
> +
> +	unsigned long start_pfn;
> +	unsigned int index;
> +	u64 req_len, pgoff;
> +	int ret = 0;
> +
> +	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	if (index != VFIO_PCI_BAR2_REGION_INDEX)
> +		return vfio_pci_core_mmap(core_vdev, vma);
> +
> +	/*
> +	 * Request to mmap the BAR. Map to the CPU accessible memory on the
> +	 * GPU using the memory information gathered from the system ACPI
> +	 * tables.
> +	 */
> +	start_pfn = nvdev->mem_prop.hpa >> PAGE_SHIFT;
> +	req_len = vma->vm_end - vma->vm_start;
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	if (pgoff >= (nvdev->mem_prop.mem_length >> PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	/*
> +	 * Perform a PFN map to the memory. The device BAR is backed by the
> +	 * GPU memory now. Check that the mapping does not overflow out of
> +	 * the GPU memory size.

vfio-pci-core return -EINVAL if the mapping length exceeds the resource
length whereas this silently resizes the requested length.  IMO it
should fail like vfio-pci-core does.

Is our test for vm_end < vm_start in vfio-pci-core just paranoia?  I
don't see an equivalent here.

Can we also get a comment in the code outlining the various reasons
that this "BAR" doesn't need the disabled access protections that
vfio-pci-core implements?  For example outlining the behavior relative
to BAR access while the memory enable bit is disabled, the bus being in
reset, or the device being in a low-power state.  Thanks,

Alex

> +	 */
> +	ret = remap_pfn_range(vma, vma->vm_start, start_pfn + pgoff,
> +			      min(req_len, nvdev->mem_prop.mem_length - pgoff),
> +			      vma->vm_page_prot);
> +	if (ret)
> +		return ret;
> +
> +	vma->vm_pgoff = start_pfn + pgoff;
> +
> +	return 0;
> +}
> +
> +static long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
> +			unsigned int cmd, unsigned long arg)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
> +
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct vfio_region_info info;
> +
> +	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> +			/*
> +			 * Request to determine the BAR region information. Send the
> +			 * GPU memory information.
> +			 */
> +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +			info.size = nvdev->mem_prop.mem_length;
> +			info.flags = VFIO_REGION_INFO_FLAG_READ |
> +				     VFIO_REGION_INFO_FLAG_WRITE |
> +				     VFIO_REGION_INFO_FLAG_MMAP;
> +			return copy_to_user((void __user *)arg, &info, minsz) ?
> +				       -EFAULT : 0;
> +		}
> +	}
> +
> +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +}
> +
> +static const struct vfio_device_ops nvgpu_vfio_pci_ops = {
> +	.name = "nvgpu-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = nvgpu_vfio_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = nvgpu_vfio_pci_ioctl,
> +	.read = vfio_pci_core_read,
> +	.write = vfio_pci_core_write,
> +	.mmap = nvgpu_vfio_pci_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +static struct nvgpu_vfio_pci_core_device *nvgpu_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct nvgpu_vfio_pci_core_device,
> +			    core_device);
> +}
> +
> +static int
> +nvgpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
> +				     struct nvgpu_vfio_pci_core_device *nvdev)
> +{
> +	int ret;
> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
> +	 */
> +	ret = device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-base-pa",
> +				       &(nvdev->mem_prop.hpa));
> +	if (ret)
> +		return ret;
> +
> +	ret = device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-size",
> +				       &(nvdev->mem_prop.mem_length));
> +	return ret;
> +}
> +
> +static int nvgpu_vfio_pci_probe(struct pci_dev *pdev,
> +				const struct pci_device_id *id)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev;
> +	int ret;
> +
> +	nvdev = vfio_alloc_device(nvgpu_vfio_pci_core_device, core_device.vdev,
> +				  &pdev->dev, &nvgpu_vfio_pci_ops);
> +	if (IS_ERR(nvdev))
> +		return PTR_ERR(nvdev);
> +
> +	dev_set_drvdata(&pdev->dev, nvdev);
> +
> +	ret = nvgpu_vfio_pci_fetch_memory_property(pdev, nvdev);
> +	if (ret)
> +		goto out_put_vdev;
> +
> +	ret = vfio_pci_core_register_device(&nvdev->core_device);
> +	if (ret)
> +		goto out_put_vdev;
> +
> +	return ret;
> +
> +out_put_vdev:
> +	vfio_put_device(&nvdev->core_device.vdev);
> +	return ret;
> +}
> +
> +static void nvgpu_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev = nvgpu_drvdata(pdev);
> +	struct vfio_pci_core_device *vdev = &nvdev->core_device;
> +
> +	vfio_pci_core_unregister_device(vdev);
> +	vfio_put_device(&vdev->vdev);
> +}
> +
> +static const struct pci_device_id nvgpu_vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2343) },
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, nvgpu_vfio_pci_table);
> +
> +static struct pci_driver nvgpu_vfio_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = nvgpu_vfio_pci_table,
> +	.probe = nvgpu_vfio_pci_probe,
> +	.remove = nvgpu_vfio_pci_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(nvgpu_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> +MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
> +MODULE_DESCRIPTION(
> +	"VFIO NVGPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");

