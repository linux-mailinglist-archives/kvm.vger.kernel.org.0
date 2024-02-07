Return-Path: <kvm+bounces-8290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B149884D69B
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 00:34:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD7291F230FE
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 23:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C9E535BC;
	Wed,  7 Feb 2024 23:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lie+MwaG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA807535AB
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 23:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707348854; cv=none; b=ImrEGRV1St1tdntAkI7E6AqRs0Kgx3wH5EM2RcRTVKiB88V3HUI+QTc+b85jkYUeWfdJMTdC368MeWxoTedT95xKgxBwQ4qDKU5tHucHn8avZFMW7MPl3ockl02MsWqfEERx02Sd3D83UK9yMGJYJ7CKwAoQb7iHGe9Pf1vt8Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707348854; c=relaxed/simple;
	bh=BTfnx35m+e76ekk+8FmjCwmzA/xYnjdwClodKR+deoU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGRwhxnIFc7DBuOx8K8TTTcOCvuBS92V6Pc09tWJ8EbdctKVvirt+y+pR44mRhlm9DckfxRrfaBG6Vu8EU2mr1zjU1XnyBGsTNE1NeU+lOHquOZ+3K5qZK1hzi4vXVemMlBJ7vd7S/oWY4dFV0SqPYORIup8KyOAjy+INKQ1dU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lie+MwaG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707348850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m6WHqRBlpxiEwBotPFdQWPo/IKjRul0ClLZSAKQLOYQ=;
	b=Lie+MwaGPIi2CT0despeDK7Xmbh+2pBrtNsmoSLX4Uvlu15Z6tWBFvurof40Gjoap5H94I
	dcstnsveajmxt5q+5nf7JiWNoaCGbmNT2Vj8x+NSWMY4zAtjKOujtoMeH3pbQeB43wVqsG
	BvVO5pEBb0Wrc8y1vk9JZpbkP5lLycg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-zK2_bF40OjaY9M-EWuuggg-1; Wed, 07 Feb 2024 18:34:08 -0500
X-MC-Unique: zK2_bF40OjaY9M-EWuuggg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c3e3ac59b3so89546839f.1
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 15:34:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707348848; x=1707953648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m6WHqRBlpxiEwBotPFdQWPo/IKjRul0ClLZSAKQLOYQ=;
        b=UkpzUVWF5/Rxc80Ek+JB6Ogb29Xn+6uhz/6xb0Xzt3wMM+hEa4VwJUaGiNOaSyjxBu
         H52NAHlW8aFEnRc1WzqTHc3TW4yqR44eGk8JjfD7dAk0SWH+ffMwl7jqklcNVJujPHsp
         WZ5n3rCjZK+Mp8Gxi8lph1UaU35ZXkMgtk+JaKse2/Be4f+yUDVvYyuzQbZgmswSGjD0
         DyXXlzHZEL3EiPeu3mjwP+ULQsN19nbAhkdh9tRahw4BMtLsGdoPaaMlaQCWh+h1tbfR
         gsth3mz6ei1R2u37NyCWa9SUMmVRQPQ7/rE9XitH6Q2Hh4Dy9I6+/bYlak9p35kK5BEx
         D4sQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyvQj7TnIr5RLYNOHOibiqnyvOR6DsvANAAQjO1/UDBnaSo6qIULDl18DtM6tEbcoYUjFZ5R3ue9XeFhaecuQb9MnC
X-Gm-Message-State: AOJu0YwhGkmZOTWLKW38Kyy6R/9mzXGOLFYO6KNMH2VofpERDH0Zw3kQ
	nlfW5uqQW3s/gHAzHbGQSwjXJzkQekD2tLFwHGvNwoz0fwT4gQBXm40EtRyLEYPz8uZ0k2DErHd
	GfbD0q42FtrcfequjMmeBaKhKXkmwdGU8AxE0OBNObPr7yCISVw==
X-Received: by 2002:a5e:df47:0:b0:7c4:726:d8f6 with SMTP id g7-20020a5edf47000000b007c40726d8f6mr1280146ioq.18.1707348847577;
        Wed, 07 Feb 2024 15:34:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHKc5VwI3PgiielkrCzGAb0wtnvn1bF5icBZAkgvUshblGkZf2lxEdCKO4Pyd285ygGsfWGHQ==
X-Received: by 2002:a5e:df47:0:b0:7c4:726:d8f6 with SMTP id g7-20020a5edf47000000b007c40726d8f6mr1280123ioq.18.1707348846999;
        Wed, 07 Feb 2024 15:34:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVz8ZsQHQTzDQZVdA9oqnEkQrA/6S2fdwh/vppYteMiARExb6VKS9pj47uUw/xfnnxhV3/Pfs8egADWPr5rIPvNb3+pSsKmK3hnpKtvGXGCQ8WMhE4tF4QaLvhiy0ODouayNDdEZPT5o6PO/e/AsK2pDQRRi6rrFGpwazMKaR7NaUBRgGo3NUus7jR/caTYA2bA9cmB/vMtTeBSiEK7UC2/QlB5fvWlr/4AoMoO6XGRJfYToI8wW8ot99/8CFE5eJNXj/A/kOV2MPq16cX2QUu5SE55/iBnX7ePddGDxJtpZ81gCRsYFQ2I20YcLsSMW9W+nIy8HBLF3PUWeO8rpw7e53/rliP9ldleTaZd102l3KUGUA906sGuSE/fZasIqxF72mMzmPn0qridZUa6/AGm4LJu7r5bs5rROFtwJw6f1PkRNgp3K26yOvfam6VBPAU8DOKN+rBnV7g40jY79vtr2+sFbCAjnPq7BBjdpU91CTQPQ+RflcwL3C7AFPpdVAJoEJazfE/a1L4NiHlWWYXpz6kaYsp26cNaQ+wvaZk/oocPR3ytwT4rQvxvnCQzpZAHgLsQi8sZinf6X4alNbKdc3mubHLr1FKiVsSy1GkQEJBKk7SvysKVdlD+Qz0k33Ih0+VxK/kXWSWkjHqG+Kio/oDeuWzs0E2r6jQodOTGgjjk0aSsSLu3gBn4ofc6tfG4c8Z/KhH2ubhhyIoTyR5wsScJSVeuMdmLWol6wWJ+C2QuXZloIJ5ePL+k5wdpj87uqtWSverZU1VIYdZ/gJoIcJa2XBuOdaXW6XRaNViepQdFV/pLz5wo
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id a17-20020a056638019100b00471312c41eesm558671jaq.131.2024.02.07.15.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Feb 2024 15:34:06 -0800 (PST)
Date: Wed, 7 Feb 2024 16:34:05 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>, <mst@redhat.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <clg@redhat.com>, <oleksandr@natalenko.name>,
 <satyanarayana.k.v.p@intel.com>, <eric.auger@redhat.com>,
 <brett.creeley@amd.com>, <horms@kernel.org>, <rrameshbabu@nvidia.com>,
 <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
 <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
 <anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v17 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Message-ID: <20240207163405.38cdcc4f.alex.williamson@redhat.com>
In-Reply-To: <20240205230123.18981-4-ankita@nvidia.com>
References: <20240205230123.18981-1-ankita@nvidia.com>
	<20240205230123.18981-4-ankita@nvidia.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Feb 2024 04:31:23 +0530
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
> communicate the device memory region IPA to the VM workloads. Moreover,
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
> If the bare metal properties are not present, the driver registers the
> vfio-pci-core function pointers.
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
> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  MAINTAINERS                           |   6 +
>  drivers/vfio/pci/Kconfig              |   2 +
>  drivers/vfio/pci/Makefile             |   2 +
>  drivers/vfio/pci/nvgrace-gpu/Kconfig  |  10 +
>  drivers/vfio/pci/nvgrace-gpu/Makefile |   3 +
>  drivers/vfio/pci/nvgrace-gpu/main.c   | 856 ++++++++++++++++++++++++++
>  6 files changed, 879 insertions(+)
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile
>  create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8999497011a2..529ec8966f58 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23103,6 +23103,12 @@ L:	kvm@vger.kernel.org
>  S:	Maintained
>  F:	drivers/vfio/platform/
>  
> +VFIO NVIDIA GRACE GPU DRIVER
> +M:	Ankit Agrawal <ankita@nvidia.com>
> +L:	kvm@vger.kernel.org
> +S:	Supported
> +F:	drivers/vfio/pci/nvgrace-gpu/
> +


Entries should be alphabetical.  This will end up colliding with [1] so
I'll plan to fix it either way.

Otherwise just a couple optional comments from me below.  I see Zhi also
has a few good comments.  I'd suggest soliciting a review from the other
variant driver reviewers for this version and maybe we can make v18 the
final version.  Thanks,

Alex

[1]https://lore.kernel.org/all/20240205235427.2103714-1-alex.williamson@redhat.com/


>  VGA_SWITCHEROO
>  R:	Lukas Wunner <lukas@wunner.de>
>  S:	Maintained
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index 18c397df566d..15821a2d77d2 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -67,4 +67,6 @@ source "drivers/vfio/pci/pds/Kconfig"
>  
>  source "drivers/vfio/pci/virtio/Kconfig"
>  
> +source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
> +
>  endmenu
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 046139a4eca5..ce7a61f1d912 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -15,3 +15,5 @@ obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
>  obj-$(CONFIG_PDS_VFIO_PCI) += pds/
>  
>  obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
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
> index 000000000000..6279af2bc6b8
> --- /dev/null
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -0,0 +1,856 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
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
> +	size_t bar_size;        /* Reported region BAR size */
> +	__le64 bar_val;         /* Emulated BAR offset registers */
> +	union {
> +		void *memaddr;
> +		void __iomem *ioaddr;
> +	};                      /* Base virtual address of the region */
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
> +static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	nvdev->resmem.bar_val = 0;
> +	nvdev->usemem.bar_val = 0;
> +}
> +
> +/* Choose the structure corresponding to the fake BAR with a given index. */
> +static struct mem_region *
> +nvgrace_gpu_memregion(int index,
> +		      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
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
> +static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
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
> +	if (nvdev->usemem.memlength) {
> +		nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
> +		mutex_init(&nvdev->remap_lock);
> +	}
> +
> +	return 0;
> +}
> +
> +static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	/* Unmap the mapping to the device memory cached region */
> +	if (nvdev->usemem.memaddr) {
> +		memunmap(nvdev->usemem.memaddr);
> +		nvdev->usemem.memaddr = NULL;
> +	}
> +
> +	/* Unmap the mapping to the device memory non-cached region */
> +	if (nvdev->resmem.ioaddr) {
> +		iounmap(nvdev->resmem.ioaddr);
> +		nvdev->resmem.ioaddr = NULL;
> +	}
> +
> +	mutex_destroy(&nvdev->remap_lock);
> +
> +	vfio_pci_core_close_device(core_vdev);
> +}
> +
> +static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
> +			    struct vm_area_struct *vma)
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
> +	memregion = nvgrace_gpu_memregion(index, nvdev);
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
> +	 * The available GPU memory size may not be power-of-2 aligned. The
> +	 * remainder is only backed by vfio_device_ops read/write handlers.
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
> +nvgrace_gpu_ioctl_get_region_info(struct vfio_device *core_vdev,
> +				  unsigned long arg)
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
> +	memregion = nvgrace_gpu_memregion(info.index, nvdev);
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
> +	info.size = memregion->bar_size;
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
> +static long nvgrace_gpu_ioctl(struct vfio_device *core_vdev,
> +			      unsigned int cmd, unsigned long arg)
> +{
> +	switch (cmd) {
> +	case VFIO_DEVICE_GET_REGION_INFO:
> +		return nvgrace_gpu_ioctl_get_region_info(core_vdev, arg);
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
> +	struct mem_region *memregion = NULL;
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
> +	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_2,
> +						sizeof(val64),
> +						&copy_offset, &copy_count,
> +						&register_offset))
> +		memregion = nvgrace_gpu_memregion(RESMEM_REGION_INDEX, nvdev);
> +	else if (vfio_pci_core_range_intersect_range(pos, count,
> +						     PCI_BASE_ADDRESS_4,
> +						     sizeof(val64),
> +						     &copy_offset, &copy_count,
> +						     &register_offset))
> +		memregion = nvgrace_gpu_memregion(USEMEM_REGION_INDEX, nvdev);
> +
> +	if (memregion) {
> +		val64 = nvgrace_gpu_get_read_value(memregion->bar_size,
> +						   PCI_BASE_ADDRESS_MEM_TYPE_64 |
> +						   PCI_BASE_ADDRESS_MEM_PREFETCH,
> +						   memregion->bar_val);
> +		if (copy_to_user(buf + copy_offset,
> +				 (void *)&val64 + register_offset, copy_count))
> +			return -EFAULT;
> +	}
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
> +	struct mem_region *memregion = NULL;


Nit, consistency and reverse Christmas tree variable declaration would
suggest pushing this up in the list, but it's not strictly required.


> +
> +	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_2,
> +						sizeof(u64), &copy_offset,
> +						&copy_count, &register_offset))
> +		memregion = nvgrace_gpu_memregion(RESMEM_REGION_INDEX, nvdev);
> +	else if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_4,
> +						     sizeof(u64), &copy_offset,
> +						     &copy_count, &register_offset))
> +		memregion = nvgrace_gpu_memregion(USEMEM_REGION_INDEX, nvdev);
> +
> +	if (memregion) {
> +		if (copy_from_user((void *)&memregion->bar_val + register_offset,
> +				   buf + copy_offset, copy_count))
> +			return -EFAULT;
> +		*ppos += copy_count;
> +		return copy_count;
> +	}
> +
> +	return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +}
> +
> +/*
> + * Ad hoc map the device memory in the module kernel VA space. Primarily needed
> + * as vfio does not require the userspace driver to only perform accesses through
> + * mmaps of the vfio-pci BAR regions and such accesses should be supported using
> + * vfio_device_ops read/write implementations.
> + *
> + * The usemem region is cacheable memory and hence is memremaped.
> + * The resmem region is non-cached and is mapped using ioremap_wc (NORMAL_NC).
> + */
> +static int
> +nvgrace_gpu_map_device_mem(int index,
> +			   struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	struct mem_region *memregion;
> +	int ret = 0;
> +
> +	memregion = nvgrace_gpu_memregion(index, nvdev);
> +	if (!memregion)
> +		return -EINVAL;
> +
> +	mutex_lock(&nvdev->remap_lock);
> +	if (index == USEMEM_REGION_INDEX && !memregion->memaddr) {
> +		memregion->memaddr = memremap(memregion->memphys,
> +					      memregion->memlength,
> +					      MEMREMAP_WB);
> +		if (!memregion->memaddr)
> +			ret = -ENOMEM;
> +	} else if (index == RESMEM_REGION_INDEX && !memregion->ioaddr) {
> +		memregion->ioaddr = ioremap_wc(memregion->memphys,
> +					       memregion->memlength);
> +		if (!memregion->ioaddr)
> +			ret = -ENOMEM;
> +	}


As .memaddr and .ioaddr are a union we can consolidate the NULL test.


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
> +	int ret;
> +
> +	/*
> +	 * Handle read on the BAR regions. Map to the target device memory
> +	 * physical address and copy to the request read buffer.
> +	 */
> +	ret = nvgrace_gpu_map_device_mem(index, nvdev);
> +	if (ret)
> +		return ret;
> +
> +	if (index == USEMEM_REGION_INDEX) {
> +		if (copy_to_user(buf,
> +				 (u8 *)nvdev->usemem.memaddr + offset,
> +				 mem_count))
> +			ret = -EFAULT;
> +	} else {
> +		/*
> +		 * The hardware ensures that the system does not crash when
> +		 * the device memory is accessed with the memory enable
> +		 * turned off. It synthesizes ~0 on such read. So there is
> +		 * no need to check or support the disablement/enablement of
> +		 * BAR through PCI_COMMAND config space register. Pass
> +		 * test_mem flag as false.
> +		 */
> +		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
> +					     nvdev->resmem.ioaddr,
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
> + * Reads extending beyond the reported size are truncated; reads starting
> + * beyond the reported size generate -EINVAL; reads extending beyond the
> + * actual device size is filled with ~0.
> + */
> +static ssize_t
> +nvgrace_gpu_read_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +		     char __user *buf, size_t count, loff_t *ppos)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct mem_region *memregion;
> +	size_t mem_count, i;
> +	u8 val = 0xFF;
> +	int ret;
> +
> +	memregion = nvgrace_gpu_memregion(index, nvdev);
> +	if (!memregion)
> +		return -EINVAL;
> +
> +	if (offset >= memregion->bar_size)
> +		return -EINVAL;
> +
> +	/* Clip short the read request beyond reported BAR size */
> +	count = min(count, memregion->bar_size - (size_t)offset);
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
> +nvgrace_gpu_read(struct vfio_device *core_vdev,
> +		 char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	if (nvgrace_gpu_memregion(index, nvdev))
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
> +	int ret;
> +
> +	ret = nvgrace_gpu_map_device_mem(index, nvdev);
> +	if (ret)
> +		return ret;
> +
> +	if (index == USEMEM_REGION_INDEX) {
> +		if (copy_from_user((u8 *)nvdev->usemem.memaddr + pos,
> +				   buf, mem_count))
> +			return -EFAULT;
> +	} else {
> +		/*
> +		 * The hardware ensures that the system does not crash when
> +		 * the device memory is accessed with the memory enable
> +		 * turned off. It drops such writes. So there is no need to
> +		 * check or support the disablement/enablement of BAR
> +		 * through PCI_COMMAND config space register. Pass test_mem
> +		 * flag as false.
> +		 */
> +		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
> +					     nvdev->resmem.ioaddr,
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
> + * Writes extending beyond the reported size are truncated; writes starting
> + * beyond the reported size generate -EINVAL.
> + */
> +static ssize_t
> +nvgrace_gpu_write_mem(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +		      size_t count, loff_t *ppos, const char __user *buf)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct mem_region *memregion;
> +	size_t mem_count;
> +	int ret = 0;
> +
> +	memregion = nvgrace_gpu_memregion(index, nvdev);
> +	if (!memregion)
> +		return -EINVAL;
> +
> +	if (offset >= memregion->bar_size)
> +		return -EINVAL;
> +
> +	/* Clip short the write request beyond reported BAR size */
> +	count = min(count, memregion->bar_size - (size_t)offset);
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
> +nvgrace_gpu_write(struct vfio_device *core_vdev,
> +		  const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =
> +		container_of(core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> +			     core_device.vdev);
> +
> +	if (nvgrace_gpu_memregion(index, nvdev))
> +		return nvgrace_gpu_write_mem(nvdev, count, ppos, buf);
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
> +		return nvgrace_gpu_write_config_emu(core_vdev, buf, count, ppos);
> +
> +	return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +}
> +
> +static const struct vfio_device_ops nvgrace_gpu_vfio_pci_ops = {
> +	.name		= "nvgrace-gpu-vfio-pci",
> +	.init		= vfio_pci_core_init_dev,
> +	.release	= vfio_pci_core_release_dev,
> +	.open_device	= nvgrace_gpu_open_device,
> +	.close_device	= nvgrace_gpu_close_device,
> +	.ioctl		= nvgrace_gpu_ioctl,
> +	.read		= nvgrace_gpu_read,
> +	.write		= nvgrace_gpu_write,
> +	.mmap		= nvgrace_gpu_mmap,
> +	.request	= vfio_pci_core_request,
> +	.match		= vfio_pci_core_match,
> +	.bind_iommufd	= vfio_iommufd_physical_bind,
> +	.unbind_iommufd	= vfio_iommufd_physical_unbind,
> +	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
> +};
> +
> +static const struct vfio_device_ops nvgrace_gpu_vfio_pci_core_ops = {
> +	.name		= "nvgrace-gpu-vfio-pci-core",
> +	.init		= vfio_pci_core_init_dev,
> +	.release	= vfio_pci_core_release_dev,
> +	.open_device	= nvgrace_gpu_open_device,
> +	.close_device	= vfio_pci_core_close_device,
> +	.ioctl		= vfio_pci_core_ioctl,
> +	.device_feature	= vfio_pci_core_ioctl_feature,
> +	.read		= vfio_pci_core_read,
> +	.write		= vfio_pci_core_write,
> +	.mmap		= vfio_pci_core_mmap,
> +	.request	= vfio_pci_core_request,
> +	.match		= vfio_pci_core_match,
> +	.bind_iommufd	= vfio_iommufd_physical_bind,
> +	.unbind_iommufd	= vfio_iommufd_physical_unbind,
> +	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
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
> +nvgrace_gpu_fetch_memory_property(struct pci_dev *pdev,
> +				  u64 *pmemphys, u64 *pmemlength)
> +{
> +	int ret;
> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
> +	 */
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-base-pa",
> +				       pmemphys);
> +	if (ret)
> +		return ret;
> +
> +	if (*pmemphys > type_max(phys_addr_t))
> +		return -EOVERFLOW;
> +
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
> +				       pmemlength);
> +	if (ret)
> +		return ret;
> +
> +	if (*pmemlength > type_max(size_t))
> +		return -EOVERFLOW;
> +
> +	/*
> +	 * If the C2C link is not up due to an error, the coherent device
> +	 * memory size is returned as 0. Fail in such case.
> +	 */
> +	if (*pmemlength == 0)
> +		return -ENOMEM;
> +
> +	return ret;
> +}
> +
> +static int
> +nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
> +			      struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +			      u64 memphys, u64 memlength)
> +{
> +	int ret = 0;
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
> +				nvdev->usemem.memlength,
> +				&nvdev->resmem.memphys)) ||
> +	    (check_sub_overflow(memlength, nvdev->usemem.memlength,
> +				&nvdev->resmem.memlength))) {
> +		ret = -EOVERFLOW;
> +		goto done;
> +	}
> +
> +	/*
> +	 * The memory regions are exposed as BARs. Calculate and save
> +	 * the BAR size for them.
> +	 */
> +	nvdev->usemem.bar_size = roundup_pow_of_two(nvdev->usemem.memlength);
> +	nvdev->resmem.bar_size = roundup_pow_of_two(nvdev->resmem.memlength);
> +done:
> +	return ret;
> +}
> +
> +static int nvgrace_gpu_probe(struct pci_dev *pdev,
> +			     const struct pci_device_id *id)
> +{
> +	const struct vfio_device_ops *ops = &nvgrace_gpu_vfio_pci_core_ops;
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev;
> +	u64 memphys, memlength;
> +	int ret;
> +
> +	ret = nvgrace_gpu_fetch_memory_property(pdev, &memphys, &memlength);
> +	if (!ret)
> +		ops = &nvgrace_gpu_vfio_pci_ops;
> +
> +	nvdev = vfio_alloc_device(nvgrace_gpu_vfio_pci_core_device, core_device.vdev,
> +				  &pdev->dev, ops);
> +	if (IS_ERR(nvdev))
> +		return PTR_ERR(nvdev);
> +
> +	dev_set_drvdata(&pdev->dev, &nvdev->core_device);
> +
> +	if (ops == &nvgrace_gpu_vfio_pci_ops) {
> +		/*
> +		 * Device memory properties are identified in the host ACPI
> +		 * table. Set the nvgrace_gpu_vfio_pci_core_device structure.
> +		 */
> +		ret = nvgrace_gpu_init_nvdev_struct(pdev, nvdev,
> +						    memphys, memlength);
> +		if (ret)
> +			goto out_put_vdev;
> +	}
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
> +static void nvgrace_gpu_remove(struct pci_dev *pdev)
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
> +	.probe = nvgrace_gpu_probe,
> +	.remove = nvgrace_gpu_remove,
> +	.err_handler = &vfio_pci_core_err_handlers,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(nvgrace_gpu_vfio_pci_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Ankit Agrawal <ankita@nvidia.com>");
> +MODULE_AUTHOR("Aniket Agashe <aniketa@nvidia.com>");
> +MODULE_DESCRIPTION("VFIO NVGRACE GPU PF - User Level driver for NVIDIA devices with CPU coherently accessible device memory");


