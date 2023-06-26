Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3E073E40D
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjFZQCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjFZQCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:02:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F02091
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687795277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lwY6Nb6UBI8R87L8/t+4M4Aigmo4zbnBjUGr21IPFnE=;
        b=g0/xdmBSDDj1ad6xb+MyJT30N6POxMmg0z1bB17jliqA8pwzmuLXoOf8bEk7e5tJUbsrWu
        VK5ezzMj8HBSj0E5EJR9yzN7sGYxbL/BU5rwJP3TrXxsjt1qNbJd+29DF82AgH6SVFH+PX
        dZ01sW7pXyLNcrdZU3bBy7i4SYLXqWM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-3ULObjt-Pv6H5QIi5vGF7g-1; Mon, 26 Jun 2023 12:01:13 -0400
X-MC-Unique: 3ULObjt-Pv6H5QIi5vGF7g-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3458f079102so10792615ab.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687795272; x=1690387272;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwY6Nb6UBI8R87L8/t+4M4Aigmo4zbnBjUGr21IPFnE=;
        b=KzmSb+gG4xut1d+gIfGchSA8AeAL6ZeKpznuhQj6unIp7H1LJiSCgSdELwaLgAZssk
         utngKKyG7InR8oFOioN3mrHZZkjGS9JVngS4upEOxVl+1zdDSlYMBRdtbliZc1D+JFQC
         XJRVQth5EJE5q6R+1zMp0S1mUKhysAir9ZpKX1uPZ2Uy7IjZhKkkoHX3C1bH0FQeyhvZ
         c/RyPSgbCXT8gwTy+rlN5CNfRc23akMNmA4dvFOa+UE+PeSLxKKjQE9qUC8IhtHXSwTd
         YMCXuxmqCHL83gVoUTb7G5XxmXw9eAddBkJoRtMpqDEih56blVNrJeWE3FQMdcyZhqhm
         o2Uw==
X-Gm-Message-State: AC+VfDxTHlB7jAn0smQHHj5zM6UX40qnFwfFaOptSeYEk+0Qodjz7iix
        iBMEP+HyLKLPATWMSgSqoLVtu/6NDp5n8OLGNZqtZ4A91P7yzeLmiLIMI1ee81DODdaDeFL9jwN
        DMWS5R8BQXL0F
X-Received: by 2002:a92:d445:0:b0:345:aba5:3782 with SMTP id r5-20020a92d445000000b00345aba53782mr2465611ilm.24.1687795271753;
        Mon, 26 Jun 2023 09:01:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5UWZXd6NBkcLIQxXDOtjLhDEhb6jsRLlC3EU+Sb413+tKJqEBx/lkUb+fEaNRaFkKmwk/Gxg==
X-Received: by 2002:a92:d445:0:b0:345:aba5:3782 with SMTP id r5-20020a92d445000000b00345aba53782mr2465546ilm.24.1687795271093;
        Mon, 26 Jun 2023 09:01:11 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f25-20020a056638023900b0042887e69e99sm1824448jaq.95.2023.06.26.09.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 09:01:09 -0700 (PDT)
Date:   Mon, 26 Jun 2023 10:01:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     <ankita@nvidia.com>
Cc:     <jgg@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
        <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
        <danw@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230626100106.2e3ddb14.alex.williamson@redhat.com>
In-Reply-To: <20230622030720.19652-1-ankita@nvidia.com>
References: <20230622030720.19652-1-ankita@nvidia.com>
Organization: Red Hat
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

On Wed, 21 Jun 2023 20:07:20 -0700
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
> next power-of-2 aligned PA thus is handled by the vfio-pci read/write
> device ops which returns an error.
> 
> This goes along with a qemu series to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device.
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg967557.html
> 
> This patch is split from a patch series being pursued separately:
> https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/
> 
> Applied and tested over v6.4-rc6.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
> v3 -> v4
> - Mapping the available device memory using sparse mmap. The region outside
>   the device memory is handled by read/write ops.
> - Removed the fault handler added in v3.
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
>  drivers/vfio/pci/nvgpu/Kconfig     |  10 +
>  drivers/vfio/pci/nvgpu/Makefile    |   3 +
>  drivers/vfio/pci/nvgpu/main.c      | 311 +++++++++++++++++++++++++++++
>  8 files changed, 336 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/pci/nvgpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f794002a192e..f3b3115fdfed 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22169,6 +22169,12 @@ L:	kvm@vger.kernel.org
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

As noted in other reviews, rebase to vfio next branch of linux-next.

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
> index 000000000000..ff68d0c5f865
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgpu/main.c
> @@ -0,0 +1,311 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/vfio.h>
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
> +	 * be handled by the vfio_device_ops read/write.
> +	 *
> +	 * During device reset, the GPU is safely disconnected to the CPU
> +	 * and access to the BAR will be immediately returned preventing
> +	 * machine check.
> +	 */
> +	ret = remap_pfn_range(vma, vma->vm_start, start_pfn + pgoff,
> +			      min(req_len, nvdev->mem_prop.mem_length - pgoff),
> +			      vma->vm_page_prot);

This should error rather than adjusting the mapping length if it
exceeds the map'able range.


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
> +			uint32_t size;
> +			struct vfio_region_info_cap_sparse_mmap *sparse;
> +			struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +
> +			size = sizeof(struct vfio_region_info_cap_sparse_mmap) +
> +				(sizeof(struct vfio_region_sparse_mmap_area));
> +
> +			/*
> +			 * Setup for sparse mapping for the device memory. Only the
> +			 * available device memory on the hardware is shown as a
> +			 * mappable region.
> +			 */
> +			sparse = kmalloc(size, GFP_KERNEL);

kzalloc()

> +			if (sparse == NULL)
> +				return -ENOMEM;
> +
> +			sparse->nr_areas = 1;
> +			sparse->areas[0].offset = 0;
> +			sparse->areas[0].size = nvdev->mem_prop.mem_length;
> +			sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> +			sparse->header.version = 1;
> +
> +			vfio_info_add_capability(&caps, &sparse->header, size);
> +
> +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +			/*
> +			 * The available GPU memory size may not be power-of-2 aligned.
> +			 * Given that the memory is exposed as a BAR and may not be
> +			 * aligned, roundup to the next power-of-2.
> +			 */
> +			info.size = is_power_of_2(nvdev->mem_prop.mem_length) ?
> +				nvdev->mem_prop.mem_length :
> +				roundup_pow_of_two(nvdev->mem_prop.mem_length);

The terinary seems unnecessary, roundup_pow_of_two() should be a nop if
already a power of 2.

> +			info.flags = VFIO_REGION_INFO_FLAG_READ |
> +				VFIO_REGION_INFO_FLAG_WRITE |
> +				VFIO_REGION_INFO_FLAG_MMAP;
> +
> +			if (caps.size) {
> +				info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +				if (info.argsz < sizeof(info) + caps.size) {
> +					info.argsz = sizeof(info) + caps.size;
> +					info.cap_offset = 0;
> +				} else {
> +					vfio_info_cap_shift(&caps, sizeof(info));
> +					if (copy_to_user((void __user *)arg +
> +									sizeof(info), caps.buf,
> +									caps.size)) {
> +						kfree(caps.buf);
> +						return -EFAULT;
> +					}
> +					info.cap_offset = sizeof(info);
> +				}
> +				kfree(caps.buf);
> +			}
> +
> +			return copy_to_user((void __user *)arg, &info, minsz) ?
> +				       -EFAULT : 0;

'sparse' is leaked.

> +		}
> +	}
> +
> +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +}
> +
> +static ssize_t nvgpu_vfio_pci_read(struct vfio_device *core_vdev,
> +		char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. A read to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware.
> +	 */
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX)
> +		return -EINVAL;

Shouldn't this return -1 value for the data and drop writes in the
function below?  Returning -errno is a different thing which could
cause error logging in the VMM if not crash the guest.

Also, mmap'd regions are not required to be mmap'd, read & write to the
coherent area should work through an ioremap.

I had also asked in the previous review whether "nvgpu" is already
overused.  I see a python tool named nvgpu, an OpenXLA tool, various
nvgpu things related to Tegra, an nvgpu dialect for MLIR, etc.  There
are over 5,000 hits on google for "nvgpu", only a few of which
reference development of this module.  Is there a more unique name we
can use?  Thanks,

Alex

> +
> +	return vfio_pci_core_read(core_vdev, buf, count, ppos);
> +
> +}
> +
> +static ssize_t nvgpu_vfio_pci_write(struct vfio_device *core_vdev,
> +		const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. A write to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware.
> +	 */
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX)
> +		return -EINVAL;
> +
> +	return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +}
> +
> +static const struct vfio_device_ops nvgpu_vfio_pci_ops = {
> +	.name = "nvgpu-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = nvgpu_vfio_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = nvgpu_vfio_pci_ioctl,
> +	.read = nvgpu_vfio_pci_read,
> +	.write = nvgpu_vfio_pci_write,
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

