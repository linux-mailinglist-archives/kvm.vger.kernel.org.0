Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FECA72462C
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbjFFOdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237643AbjFFOdd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:33:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEA0E70
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 07:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686061963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qA1CzM35tnud+/gdYrYM3G/6AVdiGiYIAFudUJbrM8U=;
        b=gVwbQw0GWNdfq0o+5gQHCdBkCCqD0DnG4OmOapiNVv14EYepxSnMnjGYgmXobxwA4/XsFe
        Wd1TqacqseGh+MCMXDk7gYhyyaP+wmMSrQwq6iFVpeYBfG57aqvwR0dIvQzGIEo02VqrE4
        mOEJoR9CrHypLjMYuNbOgzSJsEAoB5k=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-XD2vbdbiPiej1HTNEZxVnw-1; Tue, 06 Jun 2023 10:32:42 -0400
X-MC-Unique: XD2vbdbiPiej1HTNEZxVnw-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-33b09aff418so40416945ab.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 07:32:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686061961; x=1688653961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qA1CzM35tnud+/gdYrYM3G/6AVdiGiYIAFudUJbrM8U=;
        b=Cd/VeM2pRtQR3ml5PZzQNmyByJaUGKIgB9cT6TWtMTV+zkpVRbDEb0JWtQY3FlAbOm
         3RKhb8vMv1ZXTeLLlLXDmjhNfTDzbJFS78J47KA4fwVPuXOz2UF7QIZQmiR8yt/w7V4+
         HgFhEleQUfDvx34WhKvz4NyA1zP+iYB7ajh28uNwTBPkGBz4862B67RQXhXZWrKW2fRV
         JD/aYa+eU4dGOBzCU+inu7wHG/Ysu5lmj2WCKQ5UxoMK1pyelrq+MuZa+iL2RR3kpWod
         SFJSmc4RbIrczK09vZ6vrAA2QmBYEQg1Mm/P3IQ2yT1kH3THFILfCil6ZZwYGfJ6ohBl
         H2hg==
X-Gm-Message-State: AC+VfDwGW4Oqe7Zs9qB/gZxf8AS5CXJB6ItPO8L1ubn3S/KeJgBuGtpK
        NGOo5848J0Q93WdrIfjTsOgNhE6WsjxQMZTdW9j3jWjkjTEW0DLzRVIM9wdHB38zvxek3eCXx7Z
        bq3AQ0ED0tyvo
X-Received: by 2002:a92:c98f:0:b0:331:1f0e:79b8 with SMTP id y15-20020a92c98f000000b003311f0e79b8mr1774389iln.0.1686061960902;
        Tue, 06 Jun 2023 07:32:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7DW2XyI7S3SpIGF5d46/6dO+N+uiEx024Q/yWj2IQYb2eFvpQjqnzzs5o0A08ki67jOkorzQ==
X-Received: by 2002:a92:c98f:0:b0:331:1f0e:79b8 with SMTP id y15-20020a92c98f000000b003311f0e79b8mr1774366iln.0.1686061960460;
        Tue, 06 Jun 2023 07:32:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n12-20020a92d9cc000000b0032f240a0802sm3048947ilq.48.2023.06.06.07.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 07:32:40 -0700 (PDT)
Date:   Tue, 6 Jun 2023 08:32:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     <ankita@nvidia.com>
Cc:     <jgg@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
        <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
        <danw@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230606083238.48ea50e9.alex.williamson@redhat.com>
In-Reply-To: <20230606025320.22647-1-ankita@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Jun 2023 19:53:20 -0700
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal proprietary cache coherent interconnect.
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
> and exported to userspace as a separate VFIO_REGION. Since the device
> implements only one 64-bit BAR (BAR0), the GPU memory aperture is mapped
> to the next available PCI BAR (BAR2). Qemu will then naturally generate a
> PCI device in the VM with two 64-bit BARs (where the cacheable aperture
> reported in BAR2).
> 
> Since this memory region is actually cache coherent with the CPU, the
> VFIO variant driver will mmap it into VMA using a cacheable mapping. The
> mapping is done using remap_pfn_range().
> 
> PCI BAR are aligned to the power-of-2, but the actual memory on the
> device may not. The physical address from the last device PFN up to the
> next power-of-2 aligned PA thus is mapped to a dummy PFN through
> vm_operations fault.

As noted in the QEMU series, this all suggests to me that we should
simply expose a device specific region for this coherent memory which
QEMU can then choose to expose to the VM as a BAR, or not.  It's
clearly not a BAR on bare metal, so if we need to go to all the trouble
to create ACPI tables to further define the coherent memory space,
what's the benefit of pretending that it's a PCI BAR?  ie. Why should a
VM view this as a BAR rather than follow the same semantics as bare
metal?

We can then have a discussion whether this even needs to be a variant
driver versus a vfio-pci quirk if this device specific region is the
only feature provided (ie. is migration in the future for this
driver?).  I think we're trying to push in the direction of variant
drivers, but I'm not sure how much that makes sense for the purpose of
only tacking on a device specific region.

Also, isn't "nvgpu" already overused?  Thanks,

Alex

 
> This goes along with a qemu series to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device.
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg967557.html
> 
> This patch is split from a patch series being pursued separately:
> https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/
> 
> Applied and tested over v6.4-rc4.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
> 
> v2 -> v3
> - Added fault handler to map the region outside the physical GPU memory
>   up to the next power-of-2 to a dummy PFN.
> - Changed to select instead of "depends on" VFIO_PCI_CORE for all the
>   vfio-pci variant driver.
> - Code cleanup based on feedback comments.
> - Code implemented and tested against v6.4-rc4.
> 
> v1 -> v2
> - Updated the wording of reference to BAR offset and replaced with
>   index.
> - The GPU memory is exposed at the fixed BAR2_REGION_INDEX.
> - Code cleanup based on feedback comments.
> 
>  MAINTAINERS                        |   6 +
>  drivers/vfio/pci/Kconfig           |   2 +
>  drivers/vfio/pci/Makefile          |   2 +
>  drivers/vfio/pci/hisilicon/Kconfig |   2 +-
>  drivers/vfio/pci/mlx5/Kconfig      |   2 +-
>  drivers/vfio/pci/nvgpu/Kconfig     |  10 ++
>  drivers/vfio/pci/nvgpu/Makefile    |   3 +
>  drivers/vfio/pci/nvgpu/main.c      | 257 +++++++++++++++++++++++++++++
>  8 files changed, 282 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/pci/nvgpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 250518fc70ff..51e364b8f00b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22150,6 +22150,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/platform/
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
> diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
> index 5daa0f45d2f9..38e90e05d68a 100644
> --- a/drivers/vfio/pci/hisilicon/Kconfig
> +++ b/drivers/vfio/pci/hisilicon/Kconfig
> @@ -2,12 +2,12 @@
>  config HISI_ACC_VFIO_PCI
>  	tristate "VFIO PCI support for HiSilicon ACC devices"
>  	depends on ARM64 || (COMPILE_TEST && 64BIT)
> -	depends on VFIO_PCI_CORE
>  	depends on PCI_MSI
>  	depends on CRYPTO_DEV_HISI_QM
>  	depends on CRYPTO_DEV_HISI_HPRE
>  	depends on CRYPTO_DEV_HISI_SEC2
>  	depends on CRYPTO_DEV_HISI_ZIP
> +	select VFIO_PCI_CORE
>  	help
>  	  This provides generic PCI support for HiSilicon ACC devices
>  	  using the VFIO framework.
> diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
> index 29ba9c504a75..7088edc4fb28 100644
> --- a/drivers/vfio/pci/mlx5/Kconfig
> +++ b/drivers/vfio/pci/mlx5/Kconfig
> @@ -2,7 +2,7 @@
>  config MLX5_VFIO_PCI
>  	tristate "VFIO support for MLX5 PCI devices"
>  	depends on MLX5_CORE
> -	depends on VFIO_PCI_CORE
> +	select VFIO_PCI_CORE
>  	help
>  	  This provides migration support for MLX5 devices using the VFIO
>  	  framework.
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
> index 000000000000..9a838fe52a78
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgpu/main.c
> @@ -0,0 +1,257 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#define DUMMY_PFN \
> +	(((nvdev->mem_prop.hpa + nvdev->mem_prop.mem_length) >> PAGE_SHIFT) - 1)
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
> +static vm_fault_t nvgpu_vfio_pci_fault(struct vm_fault *vmf)
> +{
> +	unsigned long mem_offset = vmf->pgoff - vmf->vma->vm_pgoff;
> +	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
> +		vmf->vma->vm_file->private_data,
> +		struct nvgpu_vfio_pci_core_device, core_device.vdev);
> +	int ret;
> +
> +	/*
> +	 * We come here only if the access is to a memory region that is
> +	 * beyond physical GPU memory. Map such request to a dummy PFN.
> +	 */
> +	ret = remap_pfn_range(vmf->vma,
> +			vmf->vma->vm_start + (mem_offset << PAGE_SHIFT),
> +			DUMMY_PFN, PAGE_SIZE,
> +			vmf->vma->vm_page_prot);
> +	if (ret)
> +		return VM_FAULT_ERROR;
> +
> +	return VM_FAULT_NOPAGE;
> +}
> +
> +static const struct vm_operations_struct nvgpu_vfio_pci_mmap_ops = {
> +	.fault = nvgpu_vfio_pci_fault,
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
> +	return 0;
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
> +	 *
> +	 * The available GPU memory size may not be power-of-2 aligned. Given
> +	 * that the memory is exposed as a BAR, the mapping request is of the
> +	 * power-of-2 aligned size. Map only up to the size of the GPU memory.
> +	 * If the memory access is beyond the actual GPU memory size, it will
> +	 * be handled by the VMA ops fault through mapping to a dummy PFN.
> +	 *
> +	 * During device reset, the GPU is safely disconnected to the CPU
> +	 * and access to the BAR will be immediately returned preventing
> +	 * machine check.
> +	 */
> +	ret = remap_pfn_range(vma, vma->vm_start, start_pfn + pgoff,
> +			      min(req_len, nvdev->mem_prop.mem_length - pgoff),
> +			      vma->vm_page_prot);
> +	if (ret)
> +		return ret;
> +
> +	vma->vm_pgoff = start_pfn + pgoff;
> +	vma->vm_ops = &nvgpu_vfio_pci_mmap_ops;
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

