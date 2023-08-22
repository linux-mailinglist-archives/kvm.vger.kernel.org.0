Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39447784CD6
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 00:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjHVWaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 18:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjHVWaN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 18:30:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0B2CDA
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 15:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692743364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BrzKZOJDxSWL3iuVhtpSty+NlnQMDe/EquCkH+uudK4=;
        b=dyV5lqNd9UNBmQc7R2MnXuexrvzkHChsOulIMNlYABtWHJ1C0owOc2KJMpWNuRf2ceB/A7
        LVguypCASS5J/q5igmpsgR79sV51hazqY6Li5RISp5kUaciImvYHxKJGpMY3JFgba76zuh
        6tKbhLxXYDJQC1CX0DhO9QqMJS5pmPU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-ITuw8o25NqqJUja2Oi3Upw-1; Tue, 22 Aug 2023 18:29:22 -0400
X-MC-Unique: ITuw8o25NqqJUja2Oi3Upw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-791984d0dcbso483092439f.3
        for <kvm@vger.kernel.org>; Tue, 22 Aug 2023 15:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692743362; x=1693348162;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BrzKZOJDxSWL3iuVhtpSty+NlnQMDe/EquCkH+uudK4=;
        b=UqipJZgjO17BxBvUlAzxScBQd8M0NzUR3/j945vRkTGW1dICvUX17veWKAoOI5Tf9x
         rOzxmwVlYktaciosqdpQJPgs3BmiiRrWAP5DJHZr0VY3PhV6IlF9TWdTmozcmXIf3XTF
         ZQkKFTrnzDDXjgOtfYr22oqW8ymZsCx2wCeik2/o7j3YZapeKopRkfSIQVBaQsu2pXT9
         h99e9hXDkDxOL9n0IUicQWMSDpIRNv1O4xyLrjU+U4qsNhj7Epb2W+FkIaS12KYpIEY/
         JFxIagUoPCwokbxZHlTvp/egernjsJpV1dHr3rbzNtt83AI8djI1SBbIxoa0J7IoZgS2
         cqeA==
X-Gm-Message-State: AOJu0YyTC1CVNswrov2zpHIssBgzutFKN26q1wLK6ZqCeWvbA9XfhJDX
        FKwxONaWTL2WglqlwFaOIx3TmuQh2LjnW1iifnqdEUJC4oFmYMTexFCE4OzQA45KYhTmr8NuGnY
        iRDNl4mcpvNff
X-Received: by 2002:a05:6e02:12ac:b0:348:987a:fd8c with SMTP id f12-20020a056e0212ac00b00348987afd8cmr804547ilr.31.1692743361871;
        Tue, 22 Aug 2023 15:29:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFAXtCy2Elwr9DblD8Ot9gVssYuzffRpHfXxkV1NQkiuwPBFMP7RofOzQHTa3aq91bYPF4YQ==
X-Received: by 2002:a05:6e02:12ac:b0:348:987a:fd8c with SMTP id f12-20020a056e0212ac00b00348987afd8cmr804537ilr.31.1692743361449;
        Tue, 22 Aug 2023 15:29:21 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id e8-20020a92de48000000b003460b8505easm1934264ilr.19.2023.08.22.15.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 15:29:20 -0700 (PDT)
Date:   Tue, 22 Aug 2023 16:29:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     <ankita@nvidia.com>
Cc:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230822162918.63efda6c.alex.williamson@redhat.com>
In-Reply-To: <20230822202303.19661-1-ankita@nvidia.com>
References: <20230822202303.19661-1-ankita@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Aug 2023 13:23:03 -0700
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
> device may not. A read or write access to the physical address from the
> last device PFN up to the next power-of-2 aligned physical address
> results in reading ~1 and dropped writes.
> 
> This goes along with a qemu series to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device. Verified with the CUDA workload in the VM.
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg967557.html
> 
> This patch is split from a patch series being pursued separately:
> https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/
> 
> Applied and tested over next-20230821.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
> 
> Link for v6: https://lore.kernel.org/all/20230801130714.8221-1-ankita@nvidia.com/
> 
> v6 -> v7
> - Handled out-of-bound and overflow conditions at various places to validate
>   input offset and length.
> - Added code to return EINVAL for offset beyond region size.
> - Memremap the device memory region and cached in the nvdev object until
>   the device is closed
> 
> v5 -> v6
> - Added the code to handle BAR2 read/write using memremap to the device
>   memory.
> 
> v4 -> v5
> - Changed the module name from nvgpu-vfio-pci to nvgrace-gpu-vfio-pci.
> - Fixed memory leak and added suggested boundary checks on device memory
>   mapping.
> - Added code to read all Fs and ignored write on region outside of the
>   physical memory.
> - Other miscellaneous cleanup suggestions.
> 
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
>  MAINTAINERS                           |   6 +
>  drivers/vfio/pci/Kconfig              |   2 +
>  drivers/vfio/pci/Makefile             |   2 +
>  drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
>  drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
>  drivers/vfio/pci/nvgrace-gpu/main.c   | 444 ++++++++++++++++++++++++++
>  6 files changed, 467 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d590ce31aa72..3398dba35b48 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22347,6 +22347,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/platform/
>  
> +VFIO NVIDIA GRACE GPU DRIVER
> +M:	Ankit Agrawal <ankita@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/vfio/pci/nvgrace-gpu/
> +
>  VGA_SWITCHEROO
>  R:	Lukas Wunner <lukas@wunner.de>
>  S:	Maintained
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 86bb7835cf3c..0dbdacb929ad 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -63,4 +63,6 @@ source "drivers/vfio/pci/mlx5/Kconfig"
>  
>  source "drivers/vfio/pci/hisilicon/Kconfig"
>  
> +source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
> +
>  endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 24c524224da5..733f684f320a 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>  obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> +
> +obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/

The pds driver should have been here using the linux-next base reported
above.


> diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> new file mode 100644
> index 000000000000..b46f2d97a1d6
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> @@ -0,0 +1,10 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config NVGRACE_GPU_VFIO_PCI
> +	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper Superchip"
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> +	select VFIO_PCI_CORE
> +	help
> +	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
> +	  required to assign the GPU device to a VM using KVM/qemu/etc.
> +
> +	  If you don't know what to do here, say N.
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Makefile b/drivers/vfio/pci/nvgrace-gpu/Makefile
> new file mode 100644
> index 000000000000..3ca8c187897a
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu-vfio-pci.o
> +nvgrace-gpu-vfio-pci-y := main.o
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> new file mode 100644
> index 000000000000..161a6b19e31c
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -0,0 +1,444 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/vfio.h>
> +
> +struct nvgrace_gpu_vfio_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	u64 hpa;
> +	u64 mem_length;
> +	void *opregion;

Maybe mem_hpa, mem_lenth, mem_map?

> +};
> +
> +static int nvgrace_gpu_vfio_pci_open_device(struct vfio_device *core_vdev)
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
> +static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +
> +	if (nvdev->opregion) {
> +		memunmap(nvdev->opregion);
> +		nvdev->opregion = NULL;
> +	}
> +
> +	vfio_pci_core_close_device(core_vdev);
> +}
> +
> +static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
> +				      struct vm_area_struct *vma)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +
> +	unsigned long start_pfn;
> +	unsigned int index;
> +	u64 req_len, pgoff, end;
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
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +
> +	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
> +		check_add_overflow(PHYS_PFN(nvdev->hpa), pgoff, &start_pfn) ||
> +		check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
> +		return -EOVERFLOW;
> +
> +	if (end > nvdev->mem_length)
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
> +	ret = remap_pfn_range(vma, vma->vm_start, start_pfn,
> +			      req_len, vma->vm_page_prot);
> +	if (ret)
> +		return ret;
> +
> +	vma->vm_pgoff = start_pfn;
> +
> +	return 0;
> +}
> +
> +static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
> +					unsigned int cmd, unsigned long arg)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
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
> +			size = struct_size(sparse, areas, 1);
> +
> +			/*
> +			 * Setup for sparse mapping for the device memory. Only the
> +			 * available device memory on the hardware is shown as a
> +			 * mappable region.
> +			 */
> +			sparse = kzalloc(size, GFP_KERNEL);
> +			if (!sparse)
> +				return -ENOMEM;
> +
> +			sparse->nr_areas = 1;
> +			sparse->areas[0].offset = 0;
> +			sparse->areas[0].size = nvdev->mem_length;
> +			sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> +			sparse->header.version = 1;
> +
> +			if (vfio_info_add_capability(&caps, &sparse->header, size)) {
> +				kfree(sparse);
> +				return -EINVAL;
> +			}

Ideally this would be:

	ret = vfio_info_add_capability(...
	if (ret) {
		kfree(sparse);
		return ret;
	}

Which avoids inventing return values, but also I think we're done with
@sparse here, so it would simplify later error handling to have:

	ret = vfio_info_add_capability(...
	kfree(sparse);
	if (ret)
		return ret;

> +
> +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +			/*
> +			 * The available GPU memory size may not be power-of-2 aligned.
> +			 * Given that the memory is exposed as a BAR and may not be
> +			 * aligned, roundup to the next power-of-2.
> +			 */
> +			info.size = roundup_pow_of_two(nvdev->mem_length);
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
> +						kfree(sparse);
> +						return -EFAULT;
> +					}
> +					info.cap_offset = sizeof(info);
> +				}
> +				kfree(caps.buf);
> +			}
> +
> +			kfree(sparse);
> +			return copy_to_user((void __user *)arg, &info, minsz) ?
> +				       -EFAULT : 0;
> +		}
> +	}
> +
> +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +}
> +
> +/*
> + * Read count bytes from the device memory at an offset. The actual device
> + * memory size (available) may not be a power-of-2. So the driver fakes
> + * the size to a power-of-2 (reported) when exposing to a user space driver.
> + *
> + * Read request beyond the actual device size is filled with ~1, while
> + * those beyond the actual reported size is skipped.

I'm not sure why the commit log and description here describe this as
"~1", which is the bit-wise NOT of 1, ie. 0x...fe, when we're using -1,
ie. ~0.

> + *
> + * A read from a reported+ offset is considered error conditions and
> + * returned with an -EINVAL. Overflow conditions are also handled.
> + */
> +ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
> +			      const void *addr, size_t available, size_t reported)

The translation to a new set of variable names is distracting here, we
could simply pass nvdev itself or pull out "opregion" and "mem_length"
(or the above suggested names) and let this function calculate
"bar_size" (or "region_size") itself.

> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	u64 end;
> +	size_t read_count, i;
> +	u8 val = 0xFF;
> +
> +	if (offset >= reported)
> +		return -EINVAL;
> +
> +	if (check_add_overflow(offset, count, &end))
> +		return -EOVERFLOW;
> +
> +	/* Clip short the read request beyond reported BAR size */
> +	if (end >= reported)
> +		count = reported - offset;

This would typically be something like:

	count = min(count, reported - offset);

> +
> +	/*
> +	 * Determine how many bytes to be actually read from the device memory.
> +	 * Do not read from the offset beyond available size.
> +	 */
> +	if (offset >= available)
> +		read_count = 0;
> +	else
> +		read_count = min(count, available - (size_t)offset);

phys_count?  mem_count?

> +
> +	/*
> +	 * Handle read on the BAR2 region. Map to the target device memory
> +	 * physical address and copy to the request read buffer.
> +	 */
> +	if (copy_to_user(buf, (u8 *)addr + offset, read_count))
> +		return -EFAULT;

Just to verify, does this memory allow access of arbitrary alignment
and size?

> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. A read to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware. Fill
> +	 * such read request with ~1.
> +	 */
> +	for (i = 0; i < count - read_count; i++)

Why not:

	for (i = read_count; i < count; i++)

> +		if (copy_to_user(buf + read_count + i, &val, 1))
> +			return -EFAULT;
> +
> +	return count;
> +}
> +
> +static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
> +					  char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		if (!nvdev->opregion) {
> +			nvdev->opregion = memremap(nvdev->hpa, nvdev->mem_length, MEMREMAP_WB);
> +			if (!nvdev->opregion)
> +				return -ENOMEM;
> +		}

Seems like this would be susceptible to concurrent accesses causing
duplicate mappings.

The write() path should adopt similar changes to the read() path above.
Thanks,

Alex

> +
> +		return nvgrace_gpu_read_mem(buf, count, ppos, nvdev->opregion,
> +				nvdev->mem_length, roundup_pow_of_two(nvdev->mem_length));
> +	}
> +
> +	return vfio_pci_core_read(core_vdev, buf, count, ppos);
> +}
> +
> +/*
> + * Write count bytes to the device memory at a given offset. The actual device
> + * memory size (available) may not be a power-of-2. So the driver fakes the
> + * size to a power-of-2 (reported) when exposing to a user space driver.
> + *
> + * Write request beyond the actual device size are dropped, while those
> + * beyond the actual reported size are skipped entirely.
> + *
> + * A write to a reported+ offset is considered error conditions and
> + * returned with an -EINVAL. Overflow conditions are also handled.
> + */
> +ssize_t nvgrace_gpu_write_mem(const void *addr, size_t count, loff_t *ppos,
> +			       const void __user *buf, size_t available, size_t reported)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	u64 end;
> +	size_t write_count;
> +
> +	if (offset >= reported)
> +		return -EINVAL;
> +
> +	if (check_add_overflow(offset, count, &end))
> +		return -EOVERFLOW;
> +
> +	/* Clip short the read request beyond reported BAR size */
> +	if (end >= reported)
> +		count = reported - offset;
> +
> +	/*
> +	 * Determine how many bytes to be actually written to the device memory.
> +	 * Do not write to the offset beyond available size.
> +	 */
> +	if (offset >= available)
> +		write_count = 0;
> +	else
> +		write_count = min(count, available - (size_t)offset);
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. A write to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware. Drop
> +	 * those write requests.
> +	 */
> +	if (copy_from_user((u8 *)addr + offset, buf, write_count))
> +		return -EFAULT;
> +
> +	return count;
> +}
> +
> +static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
> +					   const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		if (!nvdev->opregion) {
> +			nvdev->opregion = memremap(nvdev->hpa, nvdev->mem_length, MEMREMAP_WB);
> +			if (!nvdev->opregion)
> +				return -ENOMEM;
> +		}
> +
> +		return nvgrace_gpu_write_mem(nvdev->opregion, count, ppos, buf,
> +				nvdev->mem_length, roundup_pow_of_two(nvdev->mem_length));
> +	}
> +
> +	return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +}
> +
> +static const struct vfio_device_ops nvgrace_gpu_vfio_pci_ops = {
> +	.name = "nvgrace-gpu-vfio-pci",
> +	.init = vfio_pci_core_init_dev,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = nvgrace_gpu_vfio_pci_open_device,
> +	.close_device = nvgrace_gpu_vfio_pci_close_device,
> +	.ioctl = nvgrace_gpu_vfio_pci_ioctl,
> +	.read = nvgrace_gpu_vfio_pci_read,
> +	.write = nvgrace_gpu_vfio_pci_write,
> +	.mmap = nvgrace_gpu_vfio_pci_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +static struct
> +nvgrace_gpu_vfio_pci_core_device *nvgrace_gpu_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct nvgrace_gpu_vfio_pci_core_device,
> +			    core_device);
> +}
> +
> +static int
> +nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
> +					    struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	int ret;
> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
> +	 */
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-base-pa",
> +				       &(nvdev->hpa));
> +	if (ret)
> +		return ret;
> +
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
> +				       &(nvdev->mem_length));
> +	return ret;
> +}
> +
> +static int nvgrace_gpu_vfio_pci_probe(struct pci_dev *pdev,
> +				       const struct pci_device_id *id)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev;
> +	int ret;
> +
> +	nvdev = vfio_alloc_device(nvgrace_gpu_vfio_pci_core_device, core_device.vdev,
> +				  &pdev->dev, &nvgrace_gpu_vfio_pci_ops);
> +	if (IS_ERR(nvdev))
> +		return PTR_ERR(nvdev);
> +
> +	dev_set_drvdata(&pdev->dev, nvdev);
> +
> +	ret = nvgrace_gpu_vfio_pci_fetch_memory_property(pdev, nvdev);
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
> +static void nvgrace_gpu_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = nvgrace_gpu_drvdata(pdev);
> +	struct vfio_pci_core_device *vdev = &nvdev->core_device;
> +
> +	vfio_pci_core_unregister_device(vdev);
> +	vfio_put_device(&vdev->vdev);
> +}
> +
> +static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
> +	/* GH200 120GB */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
> +	/* GH200 480GB */
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
> +
> +static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = nvgrace_gpu_vfio_pci_table,
> +	.probe = nvgrace_gpu_vfio_pci_probe,
> +	.remove = nvgrace_gpu_vfio_pci_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(nvgrace_gpu_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> +MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
> +MODULE_DESCRIPTION(
> +	"VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");

