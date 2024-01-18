Return-Path: <kvm+bounces-6412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9E1831066
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 01:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8743B214DE
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 00:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4C3C184C;
	Thu, 18 Jan 2024 00:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IFa4nba1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A0315A4
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 00:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705536894; cv=none; b=b10q96T2SSGhV/btBmdQoQq9v/S+Wsng4yFI4/Tp1KsjkmhQQSXa/ymBlN1YOh5ZYmUt9qb+P/JVKpIYD1t7H+Ry6BHYaFa0PAcBifg01jBF09MyIJBXhhbLv63oBz+eG0mTIJijdzKCUcWUN8+ULSGdmf1cfIAlY3GF7ZnFJqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705536894; c=relaxed/simple;
	bh=CkRsI3ol3ofIs2iS7UW1KKPrGraUDIFbaEJJxRsdrfM=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Received:
	 X-Google-Smtp-Source:X-Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding; b=DfRFd+67LrRl2zrJiA7KTzH6aDxrAzOyWWudJdqV93ztwAzDuz5wVX9Oyk5H20wR1kIWuae1ps3BCKTYlmqtVbOi4novb7eXyqoNZ6Mi+4yGhqWqbauJcDWMUasVDvwIOrxMpTVS4OFN/rQrE8HzxdeWk36gb2oOUBl7JB2J0Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IFa4nba1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705536891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5PL0ov+2KqKgntTJc/SKObISYhAZZoZJAQD9yE/vPc=;
	b=IFa4nba1RojxDYXDAhkWudw/+OoXnsepsWF4WwKi+hXKi4iFHylwKnWRqW43uWTrHtsAlq
	5WbReeCpQpUdSqxHHvRmCK/LfHrpBLGMZHXN6H+Hnw4NVnvw6eykwYSye18WwBjgoQ91q3
	1q07RDxB4OfXC+kGwTi0kMjByRZOkAs=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-l-_ucOQXPX2CeHdYnHXaEQ-1; Wed, 17 Jan 2024 19:13:15 -0500
X-MC-Unique: l-_ucOQXPX2CeHdYnHXaEQ-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6dc200ea990so174408a34.1
        for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 16:13:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705536795; x=1706141595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j5PL0ov+2KqKgntTJc/SKObISYhAZZoZJAQD9yE/vPc=;
        b=mbOIGP1DP2CMi++xbEkH1zWnYxbhKPZXVzk8Tpe00PEwgMq4DPI6WSJbcWrfOO0QH6
         lQ1fLZXCf6OSjx5o+a5J+G9EGCXkMj8bcL3vofO5I6lKmzudVLSt7wu2/ct/hNaN+In6
         6OAQQotLE82azJF2DFkeHr9bB4PU0m1ijzxhpi2pIjs3Wuma6a6RTmq8HCOfkXTFJaRA
         GWF+TPh2yybTnJ6RSEyxUmGBcXOGTXTuI7XfczJRvqGqNdpXQysQZHPcgZSIigQcYy0b
         pjQd5lasrzhs4CUACnnQTVfNIcFb/1ywJ4DNYvfftPcyrm6gHIgms/Z8c1ECkhVyWff5
         DDmQ==
X-Gm-Message-State: AOJu0YwBJwM8cu4jRwotHnWoFc/iqsp7HhLrsl8i2wtACh3ZHC0TQNo+
	Ird+gQKZzGQoJgDJ4YRJjec0kwVzaooRi+ctOusnfX5pVYS+6kou/WExbL3BW7vkwf9HknAJgr5
	xOrMsW0eiiStpxyr+UQTRlBR0pM5qw4BGjT+eJcnhMQJV8s3qQw==
X-Received: by 2002:a9d:6b10:0:b0:6dc:811c:1c5a with SMTP id g16-20020a9d6b10000000b006dc811c1c5amr611175otp.38.1705536794744;
        Wed, 17 Jan 2024 16:13:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbkYvo0U6I9hqOA9BVJIkurWI5P6C0PE/LX1/PxxcrmdNuc0IgIsEg+pDIjBvpSh6r6mMJog==
X-Received: by 2002:a9d:6b10:0:b0:6dc:811c:1c5a with SMTP id g16-20020a9d6b10000000b006dc811c1c5amr611161otp.38.1705536794157;
        Wed, 17 Jan 2024 16:13:14 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id c22-20020a4ad8d6000000b005992de5a683sm326016oov.12.2024.01.17.16.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 16:13:13 -0800 (PST)
Date: Wed, 17 Jan 2024 17:13:11 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <eric.auger@redhat.com>, <brett.creeley@amd.com>, <horms@kernel.org>,
 <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
 <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
 <anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Message-ID: <20240117171311.40583fa7.alex.williamson@redhat.com>
In-Reply-To: <20240115211516.635852-4-ankita@nvidia.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
	<20240115211516.635852-4-ankita@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jan 2024 21:15:16 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> for the on-chip GPU that is the logical OS representation of the
> internal proprietary chip-to-chip cache coherent interconnect.
> 
> The device is peculiar compared to a real PCI device in that whilst
> there is a real 64b PCI BAR1 (comprising region 2 & region 3) on the
> device, it is not used to access device memory once the faster
> chip-to-chip interconnect is initialized (occurs at the time of host
> system boot). The device memory is accessed instead using the chip-to-chip
> interconnect that is exposed as a contiguous physically addressable
> region on the host. This device memory aperture can be obtained from host
> ACPI table using device_property_read_u64(), according to the FW
> specification. Since the device memory is cache coherent with the CPU,
> it can be mmap into the user VMA with a cacheable mapping using
> remap_pfn_range() and used like a regular RAM. The device memory
> is not added to the host kernel, but mapped directly as this reduces
> memory wastage due to struct pages.
> 
> There is also a requirement of a reserved 1G uncached region (termed as
> resmem) to support the Multi-Instance GPU (MIG) feature [1]. This is
> to work around a HW defect. Based on [2], the requisite properties
> (uncached, unaligned access) can be achieved through a VM mapping (S1)
> of NORMAL_NC and host (S2) mapping with MemAttr[2:0]=0b101. To provide
> a different non-cached property to the reserved 1G region, it needs to
> be carved out from the device memory and mapped as a separate region
> in Qemu VMA with pgprot_writecombine(). pgprot_writecombine() sets the
> Qemu VMA page properties (pgprot) as NORMAL_NC.
> 
> Provide a VFIO PCI variant driver that adapts the unique device memory
> representation into a more standard PCI representation facing userspace.
> 
> The variant driver exposes these two regions - the non-cached reserved
> (resmem) and the cached rest of the device memory (termed as usemem) as
> separate VFIO 64b BAR regions. This is divergent from the baremetal
> approach, where the device memory is exposed as a device memory region.
> The decision for a different approach was taken in view of the fact that
> it would necessiate additional code in Qemu to discover and insert those
> regions in the VM IPA, along with the additional VM ACPI DSDT changes to
> communiate the device memory region IPA to the VM workloads. Moreover,
> this behavior would have to be added to a variety of emulators (beyond
> top of tree Qemu) out there desiring grace hopper support.
> 
> Since the device implements 64-bit BAR0, the VFIO PCI variant driver
> maps the uncached carved out region to the next available PCI BAR (i.e.
> comprising of region 2 and 3). The cached device memory aperture is
> assigned BAR region 4 and 5. Qemu will then naturally generate a PCI
> device in the VM with the uncached aperture reported as BAR2 region,
> the cacheable as BAR4. The variant driver provides emulation for these
> fake BARs' PCI config space offset registers.
> 
> The hardware ensures that the system does not crash when the memory
> is accessed with the memory enable turned off. It synthesis ~0 reads
> and dropped writes on such access. So there is no need to support the
> disablement/enablement of BAR through PCI_COMMAND config space register.
> 
> The memory layout on the host looks like the following:
>                devmem (memlength)
> |--------------------------------------------------|
> |-------------cached------------------------|--NC--|
> |                                           |
> usemem.phys/memphys                         resmem.phys
> 
> PCI BARs need to be aligned to the power-of-2, but the actual memory on the
> device may not. A read or write access to the physical address from the
> last device PFN up to the next power-of-2 aligned physical address
> results in reading ~0 and dropped writes. Note that the GPU device
> driver [6] is capable of knowing the exact device memory size through
> separate means. The device memory size is primarily kept in the system
> ACPI tables for use by the VFIO PCI variant module.
> 
> Note that the usemem memory is added by the VM Nvidia device driver [5]
> to the VM kernel as memblocks. Hence make the usable memory size memblock
> aligned.
> 
> Currently there is no provision in KVM for a S2 mapping with
> MemAttr[2:0]=0b101, but there is an ongoing effort to provide the same [3].
> As previously mentioned, resmem is mapped pgprot_writecombine(), that
> sets the Qemu VMA page properties (pgprot) as NORMAL_NC. Using the
> proposed changes in [4] and [3], KVM marks the region with
> MemAttr[2:0]=0b101 in S2.
> 
> This goes along with a qemu series [6] to provides the necessary
> implementation of the Grace Hopper Superchip firmware specification so
> that the guest operating system can see the correct ACPI modeling for
> the coherent GPU device. Verified with the CUDA workload in the VM.
> 
> [1] https://www.nvidia.com/en-in/technologies/multi-instance-gpu/
> [2] section D8.5.5 of https://developer.arm.com/documentation/ddi0487/latest/
> [3] https://lore.kernel.org/all/20231205033015.10044-1-ankita@nvidia.com/
> [4] https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
> [5] https://github.com/NVIDIA/open-gpu-kernel-modules
> [6] https://lore.kernel.org/all/20231203060245.31593-1-ankita@nvidia.com/
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
> Tested-by: Ankit Agrawal <ankita@nvidia.com>

Dunno about others, but I sure hope and assume the author tests ;)
Sometimes I'm proven wrong.

> ---
>  MAINTAINERS                                   |   6 +
>  drivers/vfio/pci/Kconfig                      |   2 +
>  drivers/vfio/pci/Makefile                     |   2 +
>  drivers/vfio/pci/nvgrace-gpu/Kconfig          |  10 +
>  drivers/vfio/pci/nvgrace-gpu/Makefile         |   3 +
>  drivers/vfio/pci/nvgrace-gpu/main.c           | 760 ++++++++++++++++++
>  .../pci/nvgrace-gpu/nvgrace_gpu_vfio_pci.h    |  50 ++
>  7 files changed, 833 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/nvgrace_gpu_vfio_pci.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f5c2450fa4ec..2c4749b7bb94 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22813,6 +22813,12 @@ L:	kvm@vger.kernel.org
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
> index 000000000000..6d1d50008bc4
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -0,0 +1,760 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include "nvgrace_gpu_vfio_pci.h"

Could probably just shorten this to nvgrace_gpu.h, but with just a
single source file, we don't need a separate header.  Put it inline here.

> +
> +static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	nvdev->resmem.u64_reg = 0;
> +	nvdev->usemem.u64_reg = 0;
> +}
> +
> +/* Choose the structure corresponding to the fake BAR with a given index. */
> +struct mem_region *

static

> +nvgrace_gpu_vfio_pci_fake_bar_mem_region(int index,
> +			struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	if (index == USEMEM_REGION_INDEX)
> +		return &nvdev->usemem;
> +
> +	if (index == RESMEM_REGION_INDEX)
> +		return &nvdev->resmem;
> +
> +	return NULL;
> +}
> +
> +static int nvgrace_gpu_vfio_pci_open_device(struct vfio_device *core_vdev)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +	int ret;
> +
> +	ret = vfio_pci_core_enable(vdev);
> +	if (ret)
> +		return ret;
> +
> +	vfio_pci_core_finish_enable(vdev);
> +
> +	nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
> +
> +	mutex_init(&nvdev->remap_lock);
> +
> +	return 0;
> +}
> +
> +static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	/* Unmap the mapping to the device memory cached region */
> +	if (nvdev->usemem.bar_remap.memaddr) {

There's really no reason to name the union, it only makes the reference
longer and we can be a little more clever without it.  See below.

> +		memunmap(nvdev->usemem.bar_remap.memaddr);
> +		nvdev->usemem.bar_remap.memaddr = NULL;
> +	}
> +
> +	/* Unmap the mapping to the device memory non-cached region */
> +	if (nvdev->resmem.bar_remap.ioaddr) {
> +		iounmap(nvdev->resmem.bar_remap.ioaddr);
> +		nvdev->resmem.bar_remap.ioaddr = NULL;
> +	}
> +
> +	mutex_destroy(&nvdev->remap_lock);
> +
> +	vfio_pci_core_close_device(core_vdev);
> +}
> +
> +static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
> +				     struct vm_area_struct *vma)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	unsigned long start_pfn;
> +	unsigned int index;
> +	u64 req_len, pgoff, end;
> +	int ret = 0;
> +	struct mem_region *memregion;
> +
> +	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +
> +	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(index, nvdev);
> +	if (!memregion)
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
> +	    check_add_overflow(PHYS_PFN(memregion->memphys), pgoff, &start_pfn) ||
> +	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
> +		return -EOVERFLOW;
> +
> +	/*
> +	 * Check that the mapping request does not go beyond available device
> +	 * memory size
> +	 */
> +	if (end > memregion->memlength)
> +		return -EINVAL;
> +
> +	/*
> +	 * The carved out region of the device memory needs the NORMAL_NC
> +	 * property. Communicate as such to the hypervisor.
> +	 */
> +	if (index == RESMEM_REGION_INDEX)
> +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +
> +	/*
> +	 * Perform a PFN map to the memory and back the device BAR by the
> +	 * GPU memory.
> +	 *
> +	 * The available GPU memory size may not be power-of-2 aligned. Map up
> +	 * to the size of the device memory. If the memory access is beyond the
> +	 * actual GPU memory size, it will be handled by the vfio_device_ops
> +	 * read/write.

The phrasing "[m]ap up to the size" suggests the behavior of previous
versions where we'd truncate mappings.  Maybe something like:

	* The available GPU memory size may not be power-of-2 aligned.
	* The remainder is only backed by read/write handlers.

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
> +					   unsigned long arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +	struct vfio_region_info_cap_sparse_mmap *sparse;
> +	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +	struct vfio_region_info info;
> +	struct mem_region *memregion;
> +	u32 size;
> +	int ret;
> +
> +	if (copy_from_user(&info, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(info.index, nvdev);
> +	if (!memregion)
> +		return vfio_pci_core_ioctl(core_vdev,
> +					   VFIO_DEVICE_GET_REGION_INFO, arg);
> +
> +	/*
> +	 * Request to determine the BAR region information. Send the
> +	 * GPU memory information.
> +	 */
> +	size = struct_size(sparse, areas, 1);
> +
> +	/*
> +	 * Setup for sparse mapping for the device memory. Only the
> +	 * available device memory on the hardware is shown as a
> +	 * mappable region.
> +	 */
> +	sparse = kzalloc(size, GFP_KERNEL);
> +	if (!sparse)
> +		return -ENOMEM;
> +
> +	sparse->nr_areas = 1;
> +	sparse->areas[0].offset = 0;
> +	sparse->areas[0].size = memregion->memlength;
> +	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
> +	sparse->header.version = 1;
> +
> +	ret = vfio_info_add_capability(&caps, &sparse->header, size);
> +	kfree(sparse);
> +	if (ret)
> +		return ret;
> +
> +	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +	/*
> +	 * The region memory size may not be power-of-2 aligned.
> +	 * Given that the memory  as a BAR and may not be
> +	 * aligned, roundup to the next power-of-2.
> +	 */
> +	info.size = roundup_pow_of_two(memregion->memlength);
> +	info.flags = VFIO_REGION_INFO_FLAG_READ |
> +		     VFIO_REGION_INFO_FLAG_WRITE |
> +		     VFIO_REGION_INFO_FLAG_MMAP;
> +
> +	if (caps.size) {
> +		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +		if (info.argsz < sizeof(info) + caps.size) {
> +			info.argsz = sizeof(info) + caps.size;
> +			info.cap_offset = 0;
> +		} else {
> +			vfio_info_cap_shift(&caps, sizeof(info));
> +			if (copy_to_user((void __user *)arg +
> +					 sizeof(info), caps.buf,
> +					 caps.size)) {
> +				kfree(caps.buf);
> +				return -EFAULT;
> +			}
> +			info.cap_offset = sizeof(info);
> +		}
> +		kfree(caps.buf);
> +	}
> +	return copy_to_user((void __user *)arg, &info, minsz) ?
> +			    -EFAULT : 0;
> +}
> +
> +static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
> +				       unsigned int cmd, unsigned long arg)
> +{
> +	switch (cmd) {
> +	case VFIO_DEVICE_GET_REGION_INFO:
> +		return nvgrace_gpu_vfio_pci_ioctl_get_region_info(core_vdev, arg);
> +	case VFIO_DEVICE_IOEVENTFD:
> +		return -ENOTTY;
> +	case VFIO_DEVICE_RESET:
> +		nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
> +		fallthrough;
> +	default:
> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +	}
> +}
> +
> +static __le64
> +nvgrace_gpu_get_read_value(size_t bar_size, u64 flags, __le64 val64)
> +{
> +	u64 tmp_val;
> +
> +	tmp_val = le64_to_cpu(val64);
> +	tmp_val &= ~(bar_size - 1);
> +	tmp_val |= flags;
> +
> +	return cpu_to_le64(tmp_val);
> +}
> +
> +/*
> + * Both the usable (usemem) and the reserved (resmem) device memory region
> + * are exposed as a 64b fake BARs in the VM. These fake BARs must respond
> + * to the accesses on their respective PCI config space offsets.
> + *
> + * resmem BAR owns PCI_BASE_ADDRESS_2 & PCI_BASE_ADDRESS_3.
> + * usemem BAR owns PCI_BASE_ADDRESS_4 & PCI_BASE_ADDRESS_5.
> + */
> +static ssize_t
> +nvgrace_gpu_read_config_emu(struct vfio_device *core_vdev,
> +			    char __user *buf, size_t count, loff_t *ppos)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	__le64 val64;
> +	size_t register_offset;
> +	loff_t copy_offset;
> +	size_t copy_count;
> +	int ret;
> +
> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_2, sizeof(val64),
> +				  &copy_offset, &copy_count,
> +				  &register_offset)) {
> +		val64 = nvgrace_gpu_get_read_value(roundup_pow_of_two(nvdev->resmem.memlength),
> +						   PCI_BASE_ADDRESS_MEM_TYPE_64 |
> +						   PCI_BASE_ADDRESS_MEM_PREFETCH,
> +						   nvdev->resmem.u64_reg);
> +		if (copy_to_user(buf + copy_offset,
> +				 (void *)&val64 + register_offset, copy_count))
> +			return -EFAULT;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_4, sizeof(val64),
> +				  &copy_offset, &copy_count,
> +				  &register_offset)) {
> +		val64 = nvgrace_gpu_get_read_value(roundup_pow_of_two(nvdev->usemem.memlength),
> +						   PCI_BASE_ADDRESS_MEM_TYPE_64 |
> +						   PCI_BASE_ADDRESS_MEM_PREFETCH,
> +						   nvdev->usemem.u64_reg);
> +		if (copy_to_user(buf + copy_offset,
> +				 (void *)&val64 + register_offset, copy_count))
> +			return -EFAULT;
> +	}

Both read and write could be simplified a bit:

        if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_2, sizeof(val64),
                                  &copy_offset, &copy_count,
                                  &register_offset)) 
                memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(RESMEM_REGION_INDEX, nvdev);
        else if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_4, sizeof(val64),
                                  &copy_offset, &copy_count,
                                  &register_offset)) 
                memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(USEMEM_REGION_INDEX, nvdev);

        if (memregion) {
                val64 = nvgrace_gpu_get_read_value(roundup_pow_of_two(memregion->memlength),
                                                   PCI_BASE_ADDRESS_MEM_TYPE_64 |
                                                   PCI_BASE_ADDRESS_MEM_PREFETCH,
                                                   memregion->u64_reg);
                if (copy_to_user(buf + copy_offset,
                                 (void *)&val64 + register_offset, copy_count))
                        return -EFAULT;
        }

> +
> +	return count;
> +}
> +
> +static ssize_t
> +nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,
> +			     const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	size_t register_offset;
> +	loff_t copy_offset;
> +	size_t copy_count;
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_2, sizeof(u64),
> +				  &copy_offset, &copy_count,
> +				  &register_offset)) {
> +		if (copy_from_user((void *)&nvdev->resmem.u64_reg + register_offset,
> +				   buf + copy_offset, copy_count))
> +			return -EFAULT;
> +		*ppos += copy_count;
> +		return copy_count;
> +	}
> +
> +	if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_4, sizeof(u64),
> +				  &copy_offset, &copy_count, &register_offset)) {
> +		if (copy_from_user((void *)&nvdev->usemem.u64_reg + register_offset,
> +				   buf + copy_offset, copy_count))
> +			return -EFAULT;
> +		*ppos += copy_count;
> +		return copy_count;
> +	}

Likewise:

        if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_2, sizeof(u64),
                                  &copy_offset, &copy_count,
                                  &register_offset)) 
                memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(RESMEM_REGION_INDEX, nvdev);
        else if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_4, sizeof(u64),
                                  &copy_offset, &copy_count, &register_offset)) {
                memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(USEMEM_REGION_INDEX, nvdev);

        if (memregion) {
                if (copy_from_user((void *)&memregion->u64_reg + register_offset,
                                   buf + copy_offset, copy_count))
                        return -EFAULT;

                *ppos += copy_count;
                return copy_count;
        }

> +
> +	return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +}
> +
> +/*
> + * Ad hoc map the device memory in the module kernel VA space. Primarily needed
> + * to support Qemu's device x-no-mmap=on option.

In general we try not to assume QEMU is the userspace driver.  This
certainly supports x-no-mmap=on in QEMU, but this is needed because
vfio does not require the userspace driver to only perform accesses
through mmaps of the vfio-pci BAR regions and existing userspace driver
precedent requires read/write implementations.

> + *
> + * The usemem region is cacheable memory and hence is memremaped.
> + * The resmem region is non-cached and is mapped using ioremap_wc (NORMAL_NC).
> + */
> +static int
> +nvgrace_gpu_map_device_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +			   int index)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&nvdev->remap_lock);
> +	if (index == USEMEM_REGION_INDEX &&
> +	    !nvdev->usemem.bar_remap.memaddr) {
> +		nvdev->usemem.bar_remap.memaddr =
> +			memremap(nvdev->usemem.memphys,
> +				 nvdev->usemem.memlength, MEMREMAP_WB);
> +		if (!nvdev->usemem.bar_remap.memaddr)
> +			ret = -ENOMEM;
> +	} else if (index == RESMEM_REGION_INDEX &&
> +		!nvdev->resmem.bar_remap.ioaddr) {
> +		nvdev->resmem.bar_remap.ioaddr =
> +			ioremap_wc(nvdev->resmem.memphys,
> +				   nvdev->resmem.memlength);
> +		if (!nvdev->resmem.bar_remap.ioaddr)
> +			ret = -ENOMEM;
> +	}


With an anonymous union we could reduce a lot of the redundancy here:

	struct mem_region *memregion;
	int ret = 0;

	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(index, nvdev);
	if (!memregion)
		return -EINVAL;

	mutex_lock(&nvdev->remap_lock);

	if (memregion->memaddr)
		goto unlock;

	if (index == USEMEM_REGION_INDEX)
                memregion->memaddr = memremap(memregion->memphys,
                                              memregion->memlength,
                                              MEMREMAP_WB);
        else
                memregion->ioaddr = ioremap_wc(memregion->memphys,
                                               memregion->memlength);

        if (!memregion->memaddr)
                ret = -ENOMEM;

unlock:
	...


BTW, why does this function have args (nvdev, index) but
nvgrace_gpu_vfio_pci_fake_bar_mem_region has args (index, nvdev)?

nvgrace_gpu_vfio_pci_fake_bar_mem_region could also be shorted to just
nvgrace_gpu_memregion and I think we could use nvgrace_gpu in place of
nvgrace_gpu_vfio_pci for function names throughout.


> +	mutex_unlock(&nvdev->remap_lock);
> +
> +	return ret;
> +}
> +
> +/*
> + * Read the data from the device memory (mapped either through ioremap
> + * or memremap) into the user buffer.
> + */
> +static int
> +nvgrace_gpu_map_and_read(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +			 char __user *buf, size_t mem_count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret = 0;
> +
> +	/*
> +	 * Handle read on the BAR regions. Map to the target device memory
> +	 * physical address and copy to the request read buffer.
> +	 */
> +	ret = nvgrace_gpu_map_device_mem(nvdev, index);
> +	if (ret)
> +		return ret;
> +


This seems like a good place for a comment regarding COMMAND_MEM being
ignored, especially since we're passing 'false' for test_mem in the
second branch.


> +	if (index == USEMEM_REGION_INDEX) {
> +		if (copy_to_user(buf,
> +				 (u8 *)nvdev->usemem.bar_remap.memaddr + offset,
> +				 mem_count))
> +			ret = -EFAULT;
> +	} else {
> +		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
> +					     nvdev->resmem.bar_remap.ioaddr,
> +					     buf, offset, mem_count,
> +					     0, 0, false);
> +	}
> +
> +	return ret;
> +}
> +
> +/*
> + * Read count bytes from the device memory at an offset. The actual device
> + * memory size (available) may not be a power-of-2. So the driver fakes
> + * the size to a power-of-2 (reported) when exposing to a user space driver.
> + *
> + * Read request beyond the actual device size is filled with ~0, while
> + * those beyond the actual reported size is skipped.

Reads extending beyond the reported size are truncated, reads starting
beyond the reported size generate errors.

> + *
> + * A read from a negative or an offset greater than reported size, a negative
> + * count are considered error conditions and returned with an -EINVAL.

This needs some phrasing help, I can't parse.

> + */
> +static ssize_t
> +nvgrace_gpu_read_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +		     char __user *buf, size_t count, loff_t *ppos)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct mem_region *memregion;
> +	size_t mem_count, i, bar_size;
> +	u8 val = 0xFF;
> +	int ret;
> +
> +	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(index, nvdev);
> +	if (!memregion)
> +		return -EINVAL;
> +
> +	bar_size = roundup_pow_of_two(memregion->memlength);
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
> +	if (offset >= memregion->memlength)
> +		mem_count = 0;
> +	else
> +		mem_count = min(count, memregion->memlength - (size_t)offset);
> +
> +	ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
> +	if (ret)
> +		return ret;
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
> +static ssize_t
> +nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
> +			  char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	if (nvgrace_gpu_vfio_pci_fake_bar_mem_region(index, nvdev))
> +		return nvgrace_gpu_read_mem(nvdev, buf, count, ppos);
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
> +		return nvgrace_gpu_read_config_emu(core_vdev, buf, count, ppos);
> +
> +	return vfio_pci_core_read(core_vdev, buf, count, ppos);
> +}
> +
> +/*
> + * Write the data to the device memory (mapped either through ioremap
> + * or memremap) from the user buffer.
> + */
> +static int
> +nvgrace_gpu_map_and_write(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +			  const char __user *buf, size_t mem_count,
> +			  loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret = 0;
> +
> +	ret = nvgrace_gpu_map_device_mem(nvdev, index);
> +	if (ret)
> +		return ret;
> +
> +	if (index == USEMEM_REGION_INDEX) {
> +		if (copy_from_user((u8 *)nvdev->usemem.bar_remap.memaddr + pos,
> +				   buf, mem_count))
> +			return -EFAULT;
> +	} else {
> +		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
> +					     nvdev->resmem.bar_remap.ioaddr,
> +					     (char __user *)buf, pos, mem_count,
> +					     0, 0, true);
> +	}
> +
> +	return ret;
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
> +nvgrace_gpu_write_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +		      size_t count, loff_t *ppos, const char __user *buf)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct mem_region *memregion;
> +	size_t mem_count, bar_size;
> +	int ret = 0;
> +
> +	memregion = nvgrace_gpu_vfio_pci_fake_bar_mem_region(index, nvdev);
> +	if (!memregion)
> +		return -EINVAL;
> +
> +	bar_size = roundup_pow_of_two(memregion->memlength);
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
> +	if (offset >= memregion->memlength)
> +		goto exitfn;
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. Drop access outside the available device
> +	 * memory on the hardware.
> +	 */
> +	mem_count = min(count, memregion->memlength - (size_t)offset);
> +
> +	ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
> +	if (ret)
> +		return ret;
> +
> +exitfn:
> +	*ppos += count;
> +	return count;
> +}
> +
> +static ssize_t
> +nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
> +			   const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	if (nvgrace_gpu_vfio_pci_fake_bar_mem_region(index, nvdev))
> +		return nvgrace_gpu_write_mem(nvdev, count, ppos, buf);
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
> +		return nvgrace_gpu_write_config_emu(core_vdev, buf, count, ppos);
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
> +	.detach_ioas = vfio_iommufd_physical_detach_ioas,
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
> +					   struct nvgrace_gpu_vfio_pci_core_device *nvdev)
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
> +	/*
> +	 * The VM GPU device driver needs a non-cacheable region to support
> +	 * the MIG feature. Since the device memory is mapped as NORMAL cached,
> +	 * carve out a region from the end with a different NORMAL_NC
> +	 * property (called as reserved memory and represented as resmem). This
> +	 * region then is exposed as a 64b BAR (region 2 and 3) to the VM, while
> +	 * exposing the rest (termed as usable memory and represented using usemem)
> +	 * as cacheable 64b BAR (region 4 and 5).
> +	 *
> +	 *               devmem (memlength)
> +	 * |-------------------------------------------------|
> +	 * |                                           |
> +	 * usemem.phys/memphys                         resmem.phys
> +	 */
> +	nvdev->usemem.memphys = memphys;
> +
> +	/*
> +	 * The device memory exposed to the VM is added to the kernel by the
> +	 * VM driver module in chunks of memory block size. Only the usable
> +	 * memory (usemem) is added to the kernel for usage by the VM
> +	 * workloads. Make the usable memory size memblock aligned.
> +	 */
> +	if (check_sub_overflow(memlength, RESMEM_SIZE,
> +			       &nvdev->usemem.memlength)) {
> +		ret = -EOVERFLOW;
> +		goto done;
> +	}
> +	nvdev->usemem.memlength = round_down(nvdev->usemem.memlength,
> +					     MEMBLK_SIZE);
> +	if ((check_add_overflow(nvdev->usemem.memphys,
> +	    nvdev->usemem.memlength, &nvdev->resmem.memphys)) ||
> +	    (check_sub_overflow(memlength, nvdev->usemem.memlength,
> +	     &nvdev->resmem.memlength))) {
> +		ret = -EOVERFLOW;
> +		goto done;
> +	}
> +
> +done:
> +	return ret;
> +}
> +
> +static int nvgrace_gpu_vfio_pci_probe(struct pci_dev *pdev,
> +				      const struct pci_device_id *id)
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

As a consequence of exposing the device differently in the host vs
guest, we need to consider nested assignment here.  The device table
below will force userspace to select this driver for the device, but
binding to it would fail because these bare metal properties are not
present.  We addressed this in the virtio-vfio-pci driver and decided
the driver needs to support the device regardless of the availability
of support for the legacy aspects of that driver.  There's no protocol
defined for userspace to pick a second best driver for a device.

Therefore, like virtio-vfio-pci, this should be able to register a
straight vfio-pci-core ops when these bare metal properties are not
present.

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
> +MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");
> diff --git a/drivers/vfio/pci/nvgrace-gpu/nvgrace_gpu_vfio_pci.h b/drivers/vfio/pci/nvgrace-gpu/nvgrace_gpu_vfio_pci.h
> new file mode 100644
> index 000000000000..1f2027ec6fae
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/nvgrace_gpu_vfio_pci.h
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#ifndef NVGRACE_GPU_VFIO_PCI_H
> +#define NVGRACE_GPU_VFIO_PCI_H
> +
> +#include <linux/vfio_pci_core.h>
> +
> +/*
> + * The device memory usable to the workloads running in the VM is cached
> + * and showcased as a 64b device BAR (comprising of BAR4 and BAR5 region)
> + * to the VM and is represented as usemem.
> + * Moreover, the VM GPU device driver needs a non-cacheable region to
> + * support the MIG feature. This region is also exposed as a 64b BAR
> + * (comprising of BAR2 and BAR3 region) and represented as resmem.
> + */
> +#define RESMEM_REGION_INDEX VFIO_PCI_BAR2_REGION_INDEX
> +#define USEMEM_REGION_INDEX VFIO_PCI_BAR4_REGION_INDEX
> +
> +/* Memory size expected as non cached and reserved by the VM driver */
> +#define RESMEM_SIZE 0x40000000
> +#define MEMBLK_SIZE 0x20000000
> +
> +/*
> + * The state of the two device memory region - resmem and usemem - is
> + * saved as struct mem_region.
> + */
> +struct mem_region {
> +	phys_addr_t memphys;    /* Base physical address of the region */
> +	size_t memlength;       /* Region size */
> +	__le64 u64_reg;         /* Emulated BAR offset registers */

s/u64_reg/bar_val/ ?

We could also include bar_size so we don't recalculate the power-of-2 size.
Thanks,

Alex

> +	union {
> +		void *memaddr;
> +		void __iomem *ioaddr;
> +	} bar_remap;            /* Base virtual address of the region */
> +};
> +
> +struct nvgrace_gpu_vfio_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	/* Cached and usable memory for the VM. */
> +	struct mem_region usemem;
> +	/* Non cached memory carved out from the end of device memory */
> +	struct mem_region resmem;
> +	/* Lock to control device memory kernel mapping */
> +	struct mutex remap_lock;
> +};
> +
> +#endif /* NVGRACE_GPU_VFIO_PCI_H */


