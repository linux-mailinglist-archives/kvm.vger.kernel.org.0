Return-Path: <kvm+bounces-2532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 625C37FABB3
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 21:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 110D8B213DB
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 20:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B39D46453;
	Mon, 27 Nov 2023 20:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OdVqDNC8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A79691
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 12:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701117508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w0bYeuzp+FoNerOocxS60F7yFXla3JQF4CGdAUVorRQ=;
	b=OdVqDNC8T8/G01mNGjlnIcW0At0YtZUFY+sPywaXWHqW7BGDmSY4g23z3JZNFg4hR4JlXc
	ZRS4tAkprskyL5aEMzFt4M2F/ouqCKjT54pW1D5eFFlV5gTHD5barjF4JKJngzml4YwNoM
	9QrKuAsNSDn+S07bDuRnk4hi2vdS/98=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-5IGBPmZNPKKFR73YBOeONQ-1; Mon, 27 Nov 2023 15:38:26 -0500
X-MC-Unique: 5IGBPmZNPKKFR73YBOeONQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-35c5a5c4b03so37436965ab.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 12:38:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701117505; x=1701722305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w0bYeuzp+FoNerOocxS60F7yFXla3JQF4CGdAUVorRQ=;
        b=QRN1rBnwnXkHaD6YTFCwI/z9nk6P0Av/9gTCAJ4U82VFc7+Gcb4MJ17cNOn72kq0SO
         5ouoZrkM6msq14Xv3L5LARbU7wRuDGj1X0jTwugttpp3Pcs6oCpVq3keT+UYn2L9SY/U
         H8wk2dUB/jrKjVMHXKeEMmYikhUhpA/GZnUqQdTq395BVSKs3jddg2IdXtP2aRrKe1tX
         M0K+8KBTAKmxUP7DEnzDD7I1M0JvhOrW5z0ukP0iyW3TBpd+1dYm5lVDL9bVqX5MJoQT
         RC2Sn7JaYtaL7BlKn+tSsFdURsfj042ItVIsCDwRFqnlv0b7y5BDAnhSDGtwDjuHVNOL
         HUuA==
X-Gm-Message-State: AOJu0YxJus10d0tiJPpCmcTZLKo+eabi+ZoYXbgQK6NCr1l3H/VHwPsg
	XRjfHvttPcTkBHdWh/PdYGNimOB1CXpeMIIAHJZweP+nMjHW5LdgaYc38022hMZi5KRYYJ9Kgci
	aqGchK2eBG53P
X-Received: by 2002:a92:3f04:0:b0:35c:d2ed:d807 with SMTP id m4-20020a923f04000000b0035cd2edd807mr4895405ila.20.1701117504933;
        Mon, 27 Nov 2023 12:38:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHdZnMINVk/gOi+ZhJC0I9LV7SaccSI92AOdUEkB6B8tOFBjwaXZgYRe1v2c9MbTAFM5Jg72A==
X-Received: by 2002:a92:3f04:0:b0:35c:d2ed:d807 with SMTP id m4-20020a923f04000000b0035cd2edd807mr4895383ila.20.1701117504477;
        Mon, 27 Nov 2023 12:38:24 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id p12-20020a92d48c000000b0035c9a135aa9sm1587610ilg.61.2023.11.27.12.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 12:38:24 -0800 (PST)
Date: Mon, 27 Nov 2023 13:38:22 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
 <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
 <anuaggarwal@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20231127133822.3454fdad.alex.williamson@redhat.com>
In-Reply-To: <20231114081611.30550-1-ankita@nvidia.com>
References: <20231114081611.30550-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Nov 2023 13:46:11 +0530
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal proprietary chip-to-chip cache coherent interconnect.
> 
> The device is peculiar compared to a real PCI device in that whilst
> there is a real 64b PCI BAR1 (comprising region 2 & region 3) on the device,
> it is not used to access device memory once the faster chip-to-chip
> interconnect is initialized (occurs at the time of host system boot).
> The device memory is accessed instead using the chip-to-chip interconnect
> that is exposed as a contiguous physically addressable region on the host.
> 
> Provide a VFIO PCI variant driver that adapts the unique device memory
> representation into a more standard PCI representation facing userspace.
> 
> The device memory aperture is obtained from ACPI using
> device_property_read_u64(), according to the FW specification, and exported
> to userspace as a separate VFIO BAR region. Since the device implements
> 64-bit BAR0, the VFIO PCI variant driver maps the GPU memory aperture
> to the next available PCI BAR (BAR2). Qemu will then naturally generate a
> PCI device in the VM with the cacheable aperture reported in BAR2 region. The
> variant driver also provides emulation for this fake BAR's PCI config space
> offset registers.
> 
> Since this memory region is actually cache coherent with the CPU, the
> VFIO variant driver will mmap it into VMA using a cacheable mapping. The
> mapping is done using remap_pfn_range().
> 
> PCI BAR are aligned to the power-of-2, but the actual memory on the
> device may not. A read or write access to the physical address from the
> last device PFN up to the next power-of-2 aligned physical address
> results in reading ~0 and dropped writes. Note that the GPU device
> driver [1] is capable of knowing the exact device memory size through
> separate means. The device memory size is primarily kept in the system
> ACPI tables for use by the VFIO PCI variant module.
> 
> This goes along with a qemu series to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device. Verified with the CUDA workload in the VM.
> https://lore.kernel.org/all/20231107190039.19434-1-ankita@nvidia.com/
> 
> This patch is split from a patch series being pursued separately:
> https://lore.kernel.org/lkml/20230405180134.16932-1-ankita@nvidia.com/
> 
> Applied over next-20231113.
> 
> [1] https://github.com/NVIDIA/open-gpu-kernel-modules
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>


There's been a fair bit of churn since Kevin's ack, probably best to
drop this until he provides a more recent review.


> ---
> 
> Link for v12:
> https://lore.kernel.org/all/20231015163047.20391-1-ankita@nvidia.com/
> 
> v12 -> v13
> - Added emulation for the PCI config space BAR offset register for
> the fake BAR.
> - commit message updated with more details on the BAR offset emulation.
> 
> v11 -> v12
> - More details in commit message on device memory size
> 
> v10 -> v11
> - Removed sysfs attribute to expose the CPU coherent memory feature
> - Addressed review comments
> 
> v9 -> v10
> - Add new sysfs attribute to expose the CPU coherent memory feature.
> 
> v8 -> v9
> - Minor code adjustment suggested in v8.
> 
> v7 -> v8
> - Various field names updated.
> - Added a new function to handle VFIO_DEVICE_GET_REGION_INFO ioctl.
> - Locking protection for memremap to bar region and other changes
>   recommended in v7.
> - Added code to fail if the devmem size advertized is 0 in system DSDT.
> 
> v6 -> v7
> - Handled out-of-bound and overflow conditions at various places to validate
>   input offset and length.
> - Added code to return EINVAL for offset beyond region size.
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
> ---
> ---
>  MAINTAINERS                           |   6 +
>  drivers/vfio/pci/Kconfig              |   2 +
>  drivers/vfio/pci/Makefile             |   2 +
>  drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
>  drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
>  drivers/vfio/pci/nvgrace-gpu/main.c   | 586 ++++++++++++++++++++++++++
>  6 files changed, 609 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1466699fbaaf..c1b43eb35cea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22891,6 +22891,12 @@ L:	kvm@vger.kernel.org
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
> index 8125e5f37832..2456210e85f1 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -65,4 +65,6 @@ source "drivers/vfio/pci/hisilicon/Kconfig"
>  
>  source "drivers/vfio/pci/pds/Kconfig"
>  
> +source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
> +
>  endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 45167be462d8..1352c65e568a 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -13,3 +13,5 @@ obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>  
>  obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> +
> +obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
> diff --git a/drivers/vfio/pci/nvgrace-gpu/Kconfig b/drivers/vfio/pci/nvgrace-gpu/Kconfig
> new file mode 100644
> index 000000000000..936e88d8d41d
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
> +	  required to assign the GPU device using KVM/qemu/etc.
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
> index 000000000000..a3dbee6b87de
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -0,0 +1,586 @@
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
> +	phys_addr_t memphys;
> +	size_t memlength;
> +	u32 bar_regs[2];
> +	void *memmap;
> +	struct mutex memmap_lock;
> +};
> +
> +static void init_fake_bar_emu_regs(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +		core_device.vdev);
> +
> +	nvdev->bar_regs[0] = PCI_BASE_ADDRESS_MEM_TYPE_64 |
> +			     PCI_BASE_ADDRESS_MEM_PREFETCH;
> +	nvdev->bar_regs[1] = 0;
> +}
> +
> +static bool is_fake_bar_pcicfg_emu_reg_access(loff_t pos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(pos);
> +	u64 offset = pos & VFIO_PCI_OFFSET_MASK;
> +
> +	if ((index == VFIO_PCI_CONFIG_REGION_INDEX) &&
> +	    (offset == PCI_BASE_ADDRESS_2 || offset == PCI_BASE_ADDRESS_3))
> +		return true;


What spec reference do you have that suggests that config space can only
be accessed at double word alignment?


> +
> +	return false;
> +}
> +
> +static int nvgrace_gpu_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +		core_device.vdev);
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	init_fake_bar_emu_regs(core_vdev);
> +
> +	mutex_init(&nvdev->memmap_lock);
> +
> +	return 0;
> +}
> +
> +static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +		core_device.vdev);
> +
> +	if (nvdev->memmap) {
> +		memunmap(nvdev->memmap);
> +		nvdev->memmap = NULL;
> +	}
> +
> +	mutex_destroy(&nvdev->memmap_lock);
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
> +		check_add_overflow(PHYS_PFN(nvdev->memphys), pgoff, &start_pfn) ||
> +		check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
> +		return -EOVERFLOW;
> +
> +	/*
> +	 * Check that the mapping request does not go beyond available device
> +	 * memory size
> +	 */
> +	if (end > nvdev->memlength)
> +		return -EINVAL;
> +
> +	/*
> +	 * Perform a PFN map to the memory and back the device BAR by the
> +	 * GPU memory.
> +	 *
> +	 * The available GPU memory size may not be power-of-2 aligned. Map up
> +	 * to the size of the device memory. If the memory access is beyond the
> +	 * actual GPU memory size, it will be handled by the vfio_device_ops
> +	 * read/write.
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
> +static long
> +nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
> +					    unsigned long arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	struct vfio_region_info info;
> +
> +	if (copy_from_user(&info, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		/*
> +		 * Request to determine the BAR region information. Send the
> +		 * GPU memory information.
> +		 */
> +		uint32_t size;
> +		int ret;
> +		struct vfio_region_info_cap_sparse_mmap *sparse;
> +		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +
> +		size = struct_size(sparse, areas, 1);
> +
> +		/*
> +		 * Setup for sparse mapping for the device memory. Only the
> +		 * available device memory on the hardware is shown as a
> +		 * mappable region.
> +		 */
> +		sparse = kzalloc(size, GFP_KERNEL);
> +		if (!sparse)
> +			return -ENOMEM;
> +
> +		sparse->nr_areas = 1;
> +		sparse->areas[0].offset = 0;
> +		sparse->areas[0].size = nvdev->memlength;
> +		sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> +		sparse->header.version = 1;
> +
> +		ret = vfio_info_add_capability(&caps, &sparse->header, size);
> +		kfree(sparse);
> +		if (ret)
> +			return ret;
> +
> +		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +		/*
> +		 * The available GPU memory size may not be power-of-2 aligned.
> +		 * Given that the memory is exposed as a BAR and may not be
> +		 * aligned, roundup to the next power-of-2.
> +		 */
> +		info.size = roundup_pow_of_two(nvdev->memlength);
> +		info.flags = VFIO_REGION_INFO_FLAG_READ |
> +			VFIO_REGION_INFO_FLAG_WRITE |
> +			VFIO_REGION_INFO_FLAG_MMAP;
> +
> +		if (caps.size) {
> +			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +			if (info.argsz < sizeof(info) + caps.size) {
> +				info.argsz = sizeof(info) + caps.size;
> +				info.cap_offset = 0;
> +			} else {
> +				vfio_info_cap_shift(&caps, sizeof(info));
> +				if (copy_to_user((void __user *)arg +
> +								sizeof(info), caps.buf,
> +								caps.size)) {
> +					kfree(caps.buf);
> +					return -EFAULT;
> +				}
> +				info.cap_offset = sizeof(info);
> +			}
> +			kfree(caps.buf);
> +		}
> +		return copy_to_user((void __user *)arg, &info, minsz) ?
> +			       -EFAULT : 0;
> +	}
> +	return vfio_pci_core_ioctl(core_vdev, VFIO_DEVICE_GET_REGION_INFO, arg);
> +}
> +
> +static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
> +					unsigned int cmd, unsigned long arg)
> +{
> +	if (cmd == VFIO_DEVICE_GET_REGION_INFO)
> +		return nvgrace_gpu_vfio_pci_ioctl_get_region_info(core_vdev, arg);
> +
> +	if (cmd == VFIO_DEVICE_RESET)
> +		init_fake_bar_emu_regs(core_vdev);
> +
> +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +}
> +
> +static int nvgrace_gpu_memmap(struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	mutex_lock(&nvdev->memmap_lock);
> +	if (!nvdev->memmap) {
> +		nvdev->memmap = memremap(nvdev->memphys, nvdev->memlength, MEMREMAP_WB);
> +		if (!nvdev->memmap) {
> +			mutex_unlock(&nvdev->memmap_lock);
> +			return -ENOMEM;
> +		}
> +	}
> +	mutex_unlock(&nvdev->memmap_lock);
> +
> +	return 0;
> +}
> +
> +/*
> + * Read count bytes from the device memory at an offset. The actual device
> + * memory size (available) may not be a power-of-2. So the driver fakes
> + * the size to a power-of-2 (reported) when exposing to a user space driver.
> + *
> + * Read request beyond the actual device size is filled with ~0, while
> + * those beyond the actual reported size is skipped.
> + *
> + * A read from a negative or an offset greater than reported size, a negative
> + * count are considered error conditions and returned with an -EINVAL.
> + */
> +static ssize_t
> +nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
> +		     struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	size_t mem_count, i, bar_size = roundup_pow_of_two(nvdev->memlength);
> +	u8 val = 0xFF;
> +
> +	if (offset >= bar_size)
> +		return -EINVAL;
> +
> +	/* Clip short the read request beyond reported BAR size */
> +	count = min(count, bar_size - (size_t)offset);
> +
> +	/*
> +	 * Determine how many bytes to be actually read from the device memory.
> +	 * Read request beyond the actual device memory size is filled with ~0,
> +	 * while those beyond the actual reported size is skipped.
> +	 */
> +	if (offset >= nvdev->memlength)
> +		mem_count = 0;
> +	else
> +		mem_count = min(count, nvdev->memlength - (size_t)offset);
> +
> +	/*
> +	 * Handle read on the BAR2 region. Map to the target device memory
> +	 * physical address and copy to the request read buffer.
> +	 */
> +	if (copy_to_user(buf, (u8 *)nvdev->memmap + offset, mem_count))
> +		return -EFAULT;
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. A read to an offset beyond the device memory
> +	 * size is filled with ~0.
> +	 */
> +	for (i = mem_count; i < count; i++)
> +		put_user(val, (unsigned char __user *)(buf + i));
> +
> +	*ppos += count;
> +	return count;
> +}
> +
> +static ssize_t pcibar_read_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +				char __user *buf, size_t count, loff_t *ppos)
> +{
> +	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	u32 val;
> +
> +	if (!IS_ALIGNED(pos, 4) || !(is_fake_bar_pcicfg_emu_reg_access(*ppos)))
> +		return -EINVAL;


Isn't the latter redundant to the caller?  Unnecessary () in the latter
too.


> +
> +	switch (pos) {
> +	case PCI_BASE_ADDRESS_2:
> +		val = nvdev->bar_regs[0];
> +		break;
> +	case PCI_BASE_ADDRESS_3:
> +		val = nvdev->bar_regs[1];
> +		break;
> +	}
> +
> +	if (copy_to_user(buf, &val, count))
> +		return -EFAULT;
> +
> +	*ppos += count;
> +	return count;
> +}
> +
> +static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
> +					  char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +		core_device.vdev);
> +	int ret;
> +
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		ret = nvgrace_gpu_memmap(nvdev);
> +		if (ret)
> +			return ret;
> +
> +		return nvgrace_gpu_read_mem(buf, count, ppos, nvdev);
> +	}
> +
> +	if (is_fake_bar_pcicfg_emu_reg_access(*ppos))
> +		return pcibar_read_emu(nvdev, buf, count, ppos);
> +


So in the VM, if I iterate with setpci to read the BAR using byte, word,
or double word, I get different results.  At the BAR2/3 base I get
-EINVAL unless it's a 4-byte access, otherwise I fall through below and
see values from the real BAR that are inconsistent with the VM devices
view.  Please implement for all naturally aligned offsets and widths or
find a spec statement supporting this behavior.


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
> + * A write to a negative or an offset greater than the reported size, a
> + * negative count are considered error conditions and returned with an -EINVAL.
> + */
> +static ssize_t
> +nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
> +		      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	size_t mem_count, bar_size = roundup_pow_of_two(nvdev->memlength);
> +
> +	if (offset >= bar_size)
> +		return -EINVAL;
> +
> +	/* Clip short the write request beyond reported BAR size */
> +	count = min(count, bar_size - (size_t)offset);
> +
> +	/*
> +	 * Determine how many bytes to be actually written to the device memory.
> +	 * Do not write to the offset beyond available size.
> +	 */
> +	if (offset >= nvdev->memlength)
> +		goto exitfn;
> +
> +	mem_count = min(count, nvdev->memlength - (size_t)offset);
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. A write to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware. Drop
> +	 * those write requests.
> +	 */
> +	if (copy_from_user((u8 *)nvdev->memmap + offset, buf, mem_count))
> +		return -EFAULT;
> +
> +exitfn:
> +	*ppos += count;
> +	return count;
> +}
> +
> +static ssize_t pcibar_write_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +				 const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	u64 size;
> +	u32 val;
> +
> +	if (!IS_ALIGNED(pos, 4) || !(is_fake_bar_pcicfg_emu_reg_access(*ppos)))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&val, buf, count))
> +		return -EFAULT;
> +
> +	size = ~(roundup_pow_of_two(nvdev->memlength) - 1);
> +
> +	if (val == 0xffffffff) {
> +		switch (pos) {
> +		case PCI_BASE_ADDRESS_2:
> +			nvdev->bar_regs[0] = (size & GENMASK(31, 4)) |
> +				(nvdev->bar_regs[0] & GENMASK(3, 0));
> +			break;
> +		case PCI_BASE_ADDRESS_3:
> +			nvdev->bar_regs[1] = size >> 32;
> +			break;
> +		}
> +	} else {
> +		switch (pos) {
> +		case PCI_BASE_ADDRESS_2:
> +			nvdev->bar_regs[0] = val;
> +			break;
> +		case PCI_BASE_ADDRESS_3:
> +			nvdev->bar_regs[1] = val;
> +			break;
> +		}
> +	}

I'd suggest your bar_regs should be a union including a u64 and prior
to any read you do something like:

 bar_reg &= ~(size - 1);
 bar_reg |= PCI_BASE_ADDRESS_MEM_TYPE_64 |
	    PCI_BASE_ADDRESS_MEM_PREFETCH;

Then you don't need to do anything on write.  Also note that config
sizing doesn't require writing the lower bits, they're defined as
read-only.  This algorithm would also allow you to just zero the u64
field on init/reset and memcpy any naturally aligned buffer requested
by the user.

But also note that config space is defined as little endian, so the
buffer should be declared as __le64 and each line above should be
wrapped in cpu_to_le64().  Bad precedent otherwise even if this will
never run on a big endian host.  Thanks,

Alex


> +
> +	*ppos += count;
> +	return count;
> +}
> +
> +static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
> +					   const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	int ret;
> +
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		ret = nvgrace_gpu_memmap(nvdev);
> +		if (ret)
> +			return ret;
> +
> +		return nvgrace_gpu_write_mem(count, ppos, buf, nvdev);
> +	}
> +
> +	if (is_fake_bar_pcicfg_emu_reg_access(*ppos))
> +		return pcibar_write_emu(nvdev, buf, count, ppos);
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
> +	u64 memphys, memlength;
> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
> +	 */
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-base-pa",
> +				       &(memphys));
> +	if (ret)
> +		return ret;
> +
> +	if (memphys > type_max(phys_addr_t))
> +		return -EOVERFLOW;
> +
> +	nvdev->memphys = memphys;
> +
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
> +				       &(memlength));
> +	if (ret)
> +		return ret;
> +
> +	if (memlength > type_max(size_t))
> +		return -EOVERFLOW;
> +
> +	/*
> +	 * If the C2C link is not up due to an error, the coherent device
> +	 * memory size is returned as 0. Fail in such case.
> +	 */
> +	if (memlength == 0)
> +		return -ENOMEM;
> +
> +	nvdev->memlength = memlength;
> +
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


