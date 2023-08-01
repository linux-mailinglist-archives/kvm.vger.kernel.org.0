Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1996E76BEFD
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 23:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjHAVK7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 17:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbjHAVKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 17:10:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8659DE70
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 14:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690924205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZIFlH9QePx4UbTnSOmrkqZSXnYFrIKMfODf0mljJEfs=;
        b=XB25Ws6EWWOvUNc53asA9C4//JFm51MCfw8Q1i420hC9HHUN6bnZX1Tivy/W2ThSIY5lmC
        yKPK8bEbVvE2yuwrAeijPXSsBMgsadNPcICYqE3z4kR8VHu3c9MNs9bW30PHmB9hfns0/a
        LONsMT8UUJsD4F2fHbXcHRTNhQN7IMs=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-EUts2o2nMfKC-KVhRHt3lA-1; Tue, 01 Aug 2023 17:09:59 -0400
X-MC-Unique: EUts2o2nMfKC-KVhRHt3lA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3491035e176so45816725ab.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 14:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690924199; x=1691528999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZIFlH9QePx4UbTnSOmrkqZSXnYFrIKMfODf0mljJEfs=;
        b=GRy0+12JD8pGsCWupD85hyNcCxHBNg/cizuTjAHqJvZ6nQHtxfHxgAmXhiRA9uPCme
         Ft2nQxv37owp1vIo7cBFkZEfLke8WOWSqbVf/uyKO7NNoJ4m4iGnDVM/rZ1grxRYv7Zk
         hhQhq+B51JpuHLcTondi6b27VM9DXkcS7hPxWaqXMfxsbdJz8ft+juOjf/iarRJuHMJg
         VD377f+5WBZt6LgeNQsJHc8nwDuF4hCFA3TyXXgvajNe7wtGm4hcV30Gh0e0l5BXTr7m
         6ae1QSe0dS6RDcxHdOs5v2h0Q8sJoGd4LX2/LSmk3qpiD+j02JYTqSsRlfeAnn5Q4G85
         VUtg==
X-Gm-Message-State: ABy/qLaxCHFYXd3KK1CKXdHBOvVia49fUC0IThpWw2KNwsOLw1L9Srn8
        cnmbVTZ8S9HXjjDKEpp57aWNt2ikspFber30fqeHYTZ9OyQpoZppAmMwwkwgz1DLrujWFCQKYZQ
        VfuNE543KmLJp
X-Received: by 2002:a05:6e02:1091:b0:348:7d72:86f4 with SMTP id r17-20020a056e02109100b003487d7286f4mr10924073ilj.31.1690924198712;
        Tue, 01 Aug 2023 14:09:58 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHstcNfonTt1IqmniHYky/GZrWZO5VbQnmoCHR0MIu/YaXVmaD2g7fY3iKv3e+roDbn+ZZ6Cg==
X-Received: by 2002:a05:6e02:1091:b0:348:7d72:86f4 with SMTP id r17-20020a056e02109100b003487d7286f4mr10924057ilj.31.1690924198351;
        Tue, 01 Aug 2023 14:09:58 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id n14-20020a056638120e00b0041d73d0a412sm3989964jas.19.2023.08.01.14.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 14:09:57 -0700 (PDT)
Date:   Tue, 1 Aug 2023 15:09:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     <ankita@nvidia.com>
Cc:     <jgg@nvidia.com>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
        <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
        <danw@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230801150956.72f7aa59.alex.williamson@redhat.com>
In-Reply-To: <20230801130714.8221-1-ankita@nvidia.com>
References: <20230801130714.8221-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Aug 2023 06:07:14 -0700
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
> results in reading -1 and ignored writes.
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
> Applied over next-20230731.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
> 
> Link for v5: https://lore.kernel.org/lkml/20230716174333.8221-1-ankita@nvidia.com/t/
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
>  drivers/vfio/pci/nvgrace-gpu/main.c   | 362 ++++++++++++++++++++++++++
>  6 files changed, 385 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7b867c57920..6b611bffc921 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22482,6 +22482,12 @@ L:	kvm@vger.kernel.org
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
> index 000000000000..9cb616a7611c
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -0,0 +1,362 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
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
> +static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
> +			struct vm_area_struct *vma)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +
> +	unsigned long start_pfn;
> +	unsigned int index;
> +	u64 req_len, pgoff;
> +	int ret;
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
> +	start_pfn = PHYS_PFN(nvdev->hpa);
> +	req_len = vma->vm_end - vma->vm_start;
> +	pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	if (PFN_PHYS(pgoff) + req_len > nvdev->mem_length)
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
> +			      req_len, vma->vm_page_prot);
> +	if (ret)
> +		return ret;
> +
> +	vma->vm_pgoff = start_pfn + pgoff;
> +
> +	return 0;
> +}
> +
> +static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
> +			unsigned int cmd, unsigned long arg)
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
> +static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
> +		char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	u8 val = 0xFF;
> +	size_t i;
> +
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		void *addr;
> +
> +		/*
> +		 * Only the device memory present on the hardware is mapped, which may
> +		 * not be power-of-2 aligned. A read to the BAR2 region implies an
> +		 * access outside the available device memory on the hardware.
> +		 * Return -1 for such read requests.
> +		 */
> +		if (offset >= nvdev->mem_length) {
> +			for (i = 0; i < count; i++)
> +				if (copy_to_user(buf + i, &val, 1))
> +					return -EFAULT;
> +
> +			return count;
> +		}

count should be adjusted for the end of the region and offset
validated.  As implemented, this essentially allows the user to
successfully read past the end of the region even if they're just
getting back -1.  A read with offset beyond the reported region size
should return -EINVAL.

> +
> +		/*
> +		 * Handle read on the BAR2 region. Map to the target device memory
> +		 * physical address and copy to the request read buffer.
> +		 */
> +		addr = memremap(nvdev->hpa + offset, count, MEMREMAP_WB);

Yikes, we just let the user specify an arbitrary length of physical
address space to read beyond the implemented coherent memory range.

> +		if (!addr)
> +			return -ENOMEM;
> +
> +		if (copy_to_user(buf, addr, count))
> +			return -EFAULT;
> +
> +		memunmap(addr);

If a user is using read(2), they'll probably do it again.  Shouldn't we
memremap() the whole range and cache it on the nvdev object until the
device is closed?

We also need to assume that it's possible for the user to cross the
mem_length boundary in a read(2), so we should probably first satisfy
the implemented memory range, then fill the remainder as -1, adjusting
count to not exceed the reported region size.

> +
> +		return count;
> +	}
> +
> +	return vfio_pci_core_read(core_vdev, buf, count, ppos);
> +}
> +
> +static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
> +		const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		void *addr;
> +
> +		/*
> +		 * Only the device memory present on the hardware is mapped, which may
> +		 * not be power-of-2 aligned. A write to the BAR2 region implies an
> +		 * access outside the available device memory on the hardware. Drop
> +		 * those write requests.
> +		 */
> +		if (offset >= nvdev->mem_length)
> +			return count;

But offset beyond reported region size should return -EINVAL.

> +
> +		/*
> +		 * Handle write to the BAR2 region. Map to the target device memory
> +		 * physical address and copy the buffer data to the device memory.
> +		 */
> +		addr = memremap(nvdev->hpa + offset, count, MEMREMAP_WB);
> +		if (!addr)
> +			return -ENOMEM;
> +
> +		if (copy_from_user(addr, buf, count))
> +			return -EFAULT;
> +
> +		memunmap(addr);

Similar to above, offset+count cannot exceed the implemented coherent
memory size.  The above allows the user to write an arbitrary length
beyond the end.  Thanks,

Alex

> +
> +		return count;
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
> +	.close_device = vfio_pci_core_close_device,
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
> +				     struct nvgrace_gpu_vfio_pci_core_device *nvdev)
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
> +				const struct pci_device_id *id)
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

