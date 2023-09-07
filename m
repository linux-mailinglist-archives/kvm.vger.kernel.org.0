Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002FD797D12
	for <lists+kvm@lfdr.de>; Thu,  7 Sep 2023 21:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239625AbjIGT4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Sep 2023 15:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240204AbjIGT4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Sep 2023 15:56:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93ADE47
        for <kvm@vger.kernel.org>; Thu,  7 Sep 2023 12:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694116552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uY9msHAjcgERr2tpUfd3bWc+7jc+Nv3J4lM2dSNS2Mo=;
        b=c14Zt1fVf5goNpFlZFZVMWe0RC3/vgkLvUIVVBKpMaPLtVpDC51bsHaOmnRKNJJEhyLiK1
        z4uQjenx8w8/IPusalKCVSaXehjkR3kf87GFxXwvq+/yjxLHzIkl+5e+SaZoeEm709DM2t
        a3qax68SufRgNu1GK95+1mMb3EEkDQc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-Ux5qbfSyOC6NeoBC57muvA-1; Thu, 07 Sep 2023 15:55:50 -0400
X-MC-Unique: Ux5qbfSyOC6NeoBC57muvA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34670b3089dso12832555ab.1
        for <kvm@vger.kernel.org>; Thu, 07 Sep 2023 12:55:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694116550; x=1694721350;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uY9msHAjcgERr2tpUfd3bWc+7jc+Nv3J4lM2dSNS2Mo=;
        b=O1Y0L/9Mb0t4XjTcdtItKlc3njpdtvxaN3oq8q4/CnS0TB6kUwRO5KkByColXP0sHL
         nUhlP3Ckx4hGSXd8pMI/HrnY8CR1X0oNI7TmPPvcuEQo7AFgg/ZGKgK6gvipeue5s4gF
         ygSsqWPoStVxBKPakJoNLPrfWDDtNT9YQ7Q8BXgUG+HK8ZzDCbENqRu8d6VgA/sXjpDn
         2mqSXj8Jl7zYGbeSsmtibTRwJDwUH6j3+MQb7GTrazwiQhSKC/uKaY3zqeyJMCRUFUin
         SfHcYhuatNFD9ZgSsvCzBIDPSMK17F97VbaETQpLxiT/dr/9kQ5IDa9WQrPP1JFEx958
         KZFw==
X-Gm-Message-State: AOJu0YyIIgpdBtGGW8DiYHEyoJCmteEtP4wwANYxMMO7ZnjgGygMNwQE
        m0PhQnV6hoYL5L4ALrV68fGKAgOhjo3S31il2HE2LjJyXpenqUjcyZjv4uIwE07h8+oEZVAK7Dx
        RMG6YlFKSyF1H
X-Received: by 2002:a05:6e02:1d11:b0:34f:14e5:5c89 with SMTP id i17-20020a056e021d1100b0034f14e55c89mr3023814ila.13.1694116549398;
        Thu, 07 Sep 2023 12:55:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPxHp7Ij9sJ8Nqa9JM3iBL2l5VCQWSiw/1uY4/0c0OVlwIgHOtWmX+UyNCGLkj3F4LkOji4Q==
X-Received: by 2002:a05:6e02:1d11:b0:34f:14e5:5c89 with SMTP id i17-20020a056e021d1100b0034f14e55c89mr3023787ila.13.1694116548967;
        Thu, 07 Sep 2023 12:55:48 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id gj7-20020a0566386a0700b0042b8566a982sm25121jab.41.2023.09.07.12.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 12:55:47 -0700 (PDT)
Date:   Thu, 7 Sep 2023 13:55:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     <ankita@nvidia.com>
Cc:     <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <anuaggarwal@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v8 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230907135546.70239f1b.alex.williamson@redhat.com>
In-Reply-To: <20230825124138.9088-1-ankita@nvidia.com>
References: <20230825124138.9088-1-ankita@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Aug 2023 05:41:38 -0700
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
> results in reading ~0 and dropped writes.
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
> Applied and tested over next-20230824.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
> 
> Link for v7:
> https://lore.kernel.org/all/20230822202303.19661-1-ankita@nvidia.com/
> 
> v7 -> v8
> - Various field names updated.
> - Added a new function to handle VFIO_DEVICE_GET_REGION_INFO ioctl.
> - Locking protection for memremap to bar region and other changes
>   including overflow recommended in v7.
> - Added code to fail if the devmem size advertized is 0 in system DSDT.

A few trivial comments below, but I think more importantly we need
resolution to Christoph's concern whether this driver should be
considered for mainline.  As Ankit identified earlier, there is a
non-mainline, open source driver for this device, though we've never
previously made any requirements regarding how the device is used by
userspace.  In fact we have a cdx bus now with vfio-cdx support, where
I don't see any mainline drivers other than vfio-cdx.  There does
however appear to be DPDK support for cdx devices exposed through vfio.

In this case we've created an infrastructure within vfio-pci to support
device specific variant drivers.  To date those drivers have only
supported migration, but the door is certainly open for other device
specific features.  Even in the case of migration, the drivers are
device specific and retrieve, store, and transmit device specific data
as a blob.  We've left IGD support in the base code for compatibility
reasons, but I think we've agreed that similar device specific features
would be done in variant drivers such as this.

There's perhaps an argument whether userspace should compose this
device itself, for example finding the firmware attributes in sysfs and
directly mmap'ing the coherent memory via /dev/mem to back a virtual
BAR or otherwise pass-through this associated region.  We didn't
require that from userspace for IGD (ie. the OpRegion and bridge config
space) because we felt access to those regions (with appropriate
permissions) was within the scope of providing usable access to the
device, where QEMU would need effectively arbitrary permissions
relative to a management tool to otherwise provide a usable device.

I've previously raised the point whether the coherent region here
might be exposed as a device specific region (such as we do for the
above IGD regions) rather than a virtual BAR, but the NVIDIA folks feel
strongly that the BAR approach is correct.

Please continue the discussion, but I'm not seeing anything here that
feels significantly different than what we created vfio-pci variant
drivers to do.

Also, for the team of reviewers for vfio-pci variant drivers, please
have your say.  If anything, I'm more concerned about the state of the
userspace portion where the proposal referenced above has been shot
down by QEMU because it tries to fundamentally change the VM machine
based on this device being attached.  I'd like to avoid another
scenario like vaddr where the referenced use case fails to materialize
in any generally usable way.

[additional code comments below]

Thanks,
Alex

 
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
> 
>  MAINTAINERS                           |   6 +
>  drivers/vfio/pci/Kconfig              |   2 +
>  drivers/vfio/pci/Makefile             |   2 +
>  drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
>  drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
>  drivers/vfio/pci/nvgrace-gpu/main.c   | 481 ++++++++++++++++++++++++++
>  6 files changed, 504 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 250c43c675cb..6042b09ad920 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22638,6 +22638,12 @@ L:	kvm@vger.kernel.org
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
> index 000000000000..324547bc8ab2
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -0,0 +1,481 @@
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
> +	void *memmap;
> +	struct mutex memmap_lock;
> +};
> +
> +static int nvgrace_gpu_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	mutex_init(&nvdev->memmap_lock);
> +
> +	return 0;
> +}
> +
> +static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
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
> +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
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
> + * A read from a negative or a reported+ offset, a negative count are
> + * considered error conditions and returned with an -EINVAL.
> + */
> +ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
> +			      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
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
> +	 * Do not read from the offset beyond available size.
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
> +	 * not be power-of-2 aligned. A read to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware. Fill
> +	 * such read request with ~0.
> +	 */
> +	for (i = mem_count; i < count; i++)
> +		put_user(val, (unsigned char __user *)(buf + i));
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
> +		mutex_lock(&nvdev->memmap_lock);
> +		if (!nvdev->memmap) {
> +			nvdev->memmap = memremap(nvdev->memphys, nvdev->memlength, MEMREMAP_WB);
> +			if (!nvdev->memmap) {
> +				mutex_unlock(&nvdev->memmap_lock);
> +				return -ENOMEM;
> +			}
> +		}
> +		mutex_unlock(&nvdev->memmap_lock);
> +
> +		return nvgrace_gpu_read_mem(buf, count, ppos, nvdev);
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
> + * A write to a negative or a reported+ offset, a negative count are
> + * considered error conditions and returned with an -EINVAL.
> + */
> +ssize_t nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
> +			       struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	size_t mem_count, bar_size = roundup_pow_of_two(nvdev->memlength);
> +
> +	if (offset >= bar_size)
> +		return -EINVAL;
> +
> +	/* Clip short the read request beyond reported BAR size */
> +	count = min(count, bar_size - (size_t)offset);
> +
> +	/*
> +	 * Determine how many bytes to be actually written to the device memory.
> +	 * Do not write to the offset beyond available size.
> +	 */
> +	if (offset >= nvdev->memlength)
> +		mem_count = 0;

We could simply 'return count;' here, then setting mem_count doesn't
need to be behind the 'else'.

> +	else
> +		mem_count = min(count, nvdev->memlength - (size_t)offset);
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
> +		mutex_lock(&nvdev->memmap_lock);
> +		if (!nvdev->memmap) {
> +			nvdev->memmap = memremap(nvdev->memphys, nvdev->memlength, MEMREMAP_WB);
> +			if (!nvdev->memmap) {
> +				mutex_unlock(&nvdev->memmap_lock);
> +				return -ENOMEM;
> +			}
> +		}
> +		mutex_unlock(&nvdev->memmap_lock);
> +
> +		return nvgrace_gpu_write_mem(count, ppos, buf, nvdev);
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
> +	u64 memphys, memlength;
> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
> +	 */
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-base-pa",
> +				       &(memphys));
> +	if (ret)
> +		goto done;
> +
> +	if (memphys > type_max(phys_addr_t)) {
> +		ret = -EOVERFLOW;
> +		goto done;
> +	}
> +
> +	nvdev->memphys = memphys;
> +
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
> +				       &(memlength));
> +	if (ret)
> +		goto done;
> +
> +	if (memlength > type_max(size_t)) {
> +		ret = -EOVERFLOW;
> +		goto done;
> +	}
> +
> +	/*
> +	 * If the C2C link is not up due to an error, the coherent device
> +	 * memory size is returned as 0. Fail in such case.
> +	 */
> +	if (memlength == 0) {
> +		ret = -ENOMEM;
> +		goto done;
> +	}
> +
> +	nvdev->memlength = memlength;
> +
> +done:
> +	return ret;

Without needing to release a lock or perform any other sort of cleanup,
I'm not sure why we need a common exit path, each of the above could
simply call 'return ret;' or 'return -ERRNO;'.

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

I think we should probably have a Signed-off-by or Acked-by from Aniket
to add them as an author.

> +MODULE_DESCRIPTION(
> +	"VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");

