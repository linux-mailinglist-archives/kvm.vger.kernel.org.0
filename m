Return-Path: <kvm+bounces-2535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1CE7FAC8C
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 22:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB49D1C20F91
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 21:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41DD446456;
	Mon, 27 Nov 2023 21:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W3q9Q7h7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA58D131
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 13:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701120507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/5OYuYCt67wzJ+/8qqlhau3Gp1gL5G3obHLUv10gK1M=;
	b=W3q9Q7h79qRQz4Y+MqVysAbl+AzMavKWuPIqIx7QdYXBE18MvVmQU9q33Yv73HMUJK9o0j
	JlyrWJ7fBXO4yR2Pxkzr8Yd5wkiSTDcc7LvXF8v3TsB3ZUsaEFIrjOBzL4aXeNwF16r7XS
	0/fdgz5pm5rvs3T688EiDgteDl4XQ78=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-hXlEsK40NGSYxyunfhaaRw-1; Mon, 27 Nov 2023 16:28:25 -0500
X-MC-Unique: hXlEsK40NGSYxyunfhaaRw-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1f9fdbb8521so4312444fac.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 13:28:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701120504; x=1701725304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/5OYuYCt67wzJ+/8qqlhau3Gp1gL5G3obHLUv10gK1M=;
        b=Ftk7K84yaecXOP33viYggMBf0C9loyEWVG/KELEvjqXTlvVRhGksR3OKeFxzp7VdLr
         sG6hvpDNJUdFNtRHQ/8KALn6PTxQ579HhRuv1N8g+y/AxvXYwe7aQ8ybyHPPvZH+AZUp
         nBAnXcaE5xWb9E/H5cEO8WjU/GOTgHmUaNXdg6m6fsyr5Xb02RmxXpO8J8SUCNjbqRmU
         Sjo9/wA0MsxPmQ8EVD6B8z61Eyb3tEmu8wKbQNpWfz0dDm4ibBB4YMPJRK4PETiSn+U6
         GSFKe2Q5Tw08XjX7VBCNESHTwQfJNNZVH/Exe4y3hSVUAp+/2xQ7BoGFovvEtnDx1uvN
         ETxg==
X-Gm-Message-State: AOJu0YwXfAoNwMAGB0DyjxvP9dTqvJIRP24zktpbiEZcy7aOnwwcEjGE
	wmEUUjQTcGpvpc/TnPfThNoNYQPo2GLf+DH+ziaNC/Y1aRj2nM7+i5O5TUFG/yqUL9+k38f8tTP
	lQ8DN4fNttdXx
X-Received: by 2002:a05:6870:9f87:b0:1f5:994:9853 with SMTP id xm7-20020a0568709f8700b001f509949853mr18861546oab.22.1701120504507;
        Mon, 27 Nov 2023 13:28:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPG4DiKquHjo8rjyosbxukSwyh/uk1y7gO5uXk0jcvQoC13Mot6fHceSEth56OkegsFzQWAA==
X-Received: by 2002:a05:6870:9f87:b0:1f5:994:9853 with SMTP id xm7-20020a0568709f8700b001f509949853mr18861528oab.22.1701120504117;
        Mon, 27 Nov 2023 13:28:24 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id wx20-20020a0568707e1400b001fa38903b92sm1104172oab.15.2023.11.27.13.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 13:28:23 -0800 (PST)
Date: Mon, 27 Nov 2023 14:28:22 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: <ankita@nvidia.com>
Cc: <jgg@nvidia.com>, <yishaih@nvidia.com>,
 <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
 <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
 <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
 <anuaggarwal@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org
Subject: Re: [PATCH v1 1/1] vfio/nvgrace-gpu: carve out non cached reserved
 region from device memory
Message-ID: <20231127142822.41d70196.alex.williamson@redhat.com>
In-Reply-To: <20231115080751.4558-1-ankita@nvidia.com>
References: <20231115080751.4558-1-ankita@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

[Cc +benh]

On Wed, 15 Nov 2023 13:37:51 +0530
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The NVIDIA's upcoming Grace Hopper Superchip GPU device driver has a
> requirement of a reserved 1G uncached RAM-like region to support the
> Multi-Instance GPU (MIG) feature [1]. Carve out the region from the device
> memory.
> 
> Based on [2], the requisite properties (uncached, unaligned access) can be
> achieved through a VM mapping (S1) of NORMAL_NC and host (S2) mapping
> with MemAttr[2:0]=0b101. Currently there is no provision in KVM for a S2
> mapping with MemAttr[2:0]=0b101, but there is an ongoing effort to provide
> the same [3].
> 
> This patch change goes on top of the VFIO PCI variant driver proposed for
> the Grace Hopper devices in [4], which facilitates the entire device memory
> to be mapped as NORMAL in S2. To provide a different non-cached property to
> the reserved 1G region, it needs to be carved out from the device memory and
> mapped as a separate region in Qemu VMA with pgprot_writecombine().
> pgprot_writecombine() sets the Qemu VMA page properties (pgprot) as
> NORMAL_NC. Using the proposed changes in [5] and [3], KVM marks the region
> with MemAttr[2:0]=0b101 in S2.
> 
> The new region (represented as resmem in the patch) is carved out from
> the tail end of the device memory host physical address range and exposed
> as a 64b BAR (comprising of region 2 and 3) to the VM.
> 
> The remaining device memory (termed as usable memory and represented
> using usemem) continues to be NORMAL cacheable and is exposed as 64b BAR
> with region 4 and 5. This memory is added by the VM Nvidia device driver [6]
> to the VM kernel as memblocks. Hence make the usable memory size memblock
> aligned.

Couldn't we make use of the sparse memory capability to force userspace
to create separate mappings? ie. abutting mmap'able ranges within a
single BAR.

I'd also suggest that this seems like a fundamental feature of the
nvgrace-gpu variant driver, this should be rolled in or minimally sent
as a series together.

> 
> The memory layout on the host looks like the following:
>                devmem (memlength)
> |--------------------------------------------------|
> |-------------cached------------------------|--NC--|
> |                                           |
> usemem.phys/memphys                         resmem.phys
> 
> [1] https://www.nvidia.com/en-in/technologies/multi-instance-gpu/
> [2] section D8.5.5 of DDI0487_I_a_a-profile_architecture_reference_manual.pdf

This is not a link (obviously) and I only come up with a
DDI0487J_a_a-profile_architecture_reference_manual.pdf when searching.

> [3] https://lore.kernel.org/all/20230907181459.18145-3-ankita@nvidia.com/
> [4] https://lore.kernel.org/all/20231114081611.30550-1-ankita@nvidia.com/
> [5] https://lore.kernel.org/all/20230907181459.18145-2-ankita@nvidia.com/
> [6] https://github.com/NVIDIA/open-gpu-kernel-modules
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 236 +++++++++++++++++++++-------
>  1 file changed, 178 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index a3dbee6b87de..87afbda39939 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -7,24 +7,62 @@
>  #include <linux/vfio_pci_core.h>
>  #include <linux/vfio.h>
>  
> +/* Memory size expected as non cached and reserved by the VM driver */
> +#define RESMEM_SIZE 0x40000000
> +#define MEMBLK_SIZE 0x20000000
> +
> +struct mem_region {
> +	phys_addr_t memphys; /* Base address of the region */
> +	size_t memlength;    /* Region size */
> +	u32 bar_regs[2];     /* Emulated BAR offset registers */
> +	void *memmap;        /* Memremap pointer to the region */

Don't we need an __iomem pointer to the non-cached region as well as
calls to ioremap() and iounmap() here somewhere?

> +};
> +
>  struct nvgrace_gpu_vfio_pci_core_device {
>  	struct vfio_pci_core_device core_device;
> -	phys_addr_t memphys;
> -	size_t memlength;
> -	u32 bar_regs[2];
> -	void *memmap;
> +	/* Cached and usable memory for the VM. */
> +	struct mem_region usemem;
> +	/* Non cached memory carved out from the end of device memory */
> +	struct mem_region resmem;
>  	struct mutex memmap_lock;
>  };
>  
> +/* Choose the structure corresponding to the BAR under question. */
> +static int nvgrace_gpu_vfio_pci_get_mem_region(int index,
> +		struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +		struct mem_region *region)
> +{
> +	if (index == VFIO_PCI_BAR4_REGION_INDEX)
> +		*region = nvdev->usemem;
> +	else if (index == VFIO_PCI_BAR2_REGION_INDEX)
> +		*region = nvdev->resmem;
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static bool nvgrace_gpu_vfio_pci_is_fake_bar(int index)
> +{
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX ||
> +	    index == VFIO_PCI_BAR4_REGION_INDEX)
> +		return true;
> +
> +	return false;
> +}
> +
>  static void init_fake_bar_emu_regs(struct vfio_device *core_vdev)
>  {
>  	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
>  		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
>  		core_device.vdev);
>  
> -	nvdev->bar_regs[0] = PCI_BASE_ADDRESS_MEM_TYPE_64 |
> -			     PCI_BASE_ADDRESS_MEM_PREFETCH;
> -	nvdev->bar_regs[1] = 0;
> +	nvdev->resmem.bar_regs[0] = PCI_BASE_ADDRESS_MEM_TYPE_64 |
> +				    PCI_BASE_ADDRESS_MEM_PREFETCH;
> +	nvdev->resmem.bar_regs[1] = 0;
> +	nvdev->usemem.bar_regs[0] = PCI_BASE_ADDRESS_MEM_TYPE_64 |
> +				    PCI_BASE_ADDRESS_MEM_PREFETCH;
> +	nvdev->usemem.bar_regs[1] = 0;
>  }
>  
>  static bool is_fake_bar_pcicfg_emu_reg_access(loff_t pos)
> @@ -33,7 +71,7 @@ static bool is_fake_bar_pcicfg_emu_reg_access(loff_t pos)
>  	u64 offset = pos & VFIO_PCI_OFFSET_MASK;
>  
>  	if ((index == VFIO_PCI_CONFIG_REGION_INDEX) &&
> -	    (offset == PCI_BASE_ADDRESS_2 || offset == PCI_BASE_ADDRESS_3))
> +	    (offset >= PCI_BASE_ADDRESS_2 && offset <= PCI_BASE_ADDRESS_5))
>  		return true;
>  
>  	return false;
> @@ -67,9 +105,9 @@ static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
>  		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
>  		core_device.vdev);
>  
> -	if (nvdev->memmap) {
> -		memunmap(nvdev->memmap);
> -		nvdev->memmap = NULL;
> +	if (nvdev->usemem.memmap) {
> +		memunmap(nvdev->usemem.memmap);
> +		nvdev->usemem.memmap = NULL;
>  	}
>  
>  	mutex_destroy(&nvdev->memmap_lock);
> @@ -78,7 +116,7 @@ static void nvgrace_gpu_vfio_pci_close_device(struct vfio_device *core_vdev)
>  }
>  
>  static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
> -				      struct vm_area_struct *vma)
> +				     struct vm_area_struct *vma)

spurious

>  {
>  	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
>  		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> @@ -87,11 +125,17 @@ static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
>  	unsigned int index;
>  	u64 req_len, pgoff, end;
>  	int ret = 0;
> +	struct mem_region memregion;
>  
>  	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> -	if (index != VFIO_PCI_BAR2_REGION_INDEX)
> +
> +	if (!nvgrace_gpu_vfio_pci_is_fake_bar(index))
>  		return vfio_pci_core_mmap(core_vdev, vma);
>  
> +	ret = nvgrace_gpu_vfio_pci_get_mem_region(index, nvdev, &memregion);
> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * Request to mmap the BAR. Map to the CPU accessible memory on the
>  	 * GPU using the memory information gathered from the system ACPI
> @@ -101,7 +145,7 @@ static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
>  		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>  
>  	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
> -		check_add_overflow(PHYS_PFN(nvdev->memphys), pgoff, &start_pfn) ||
> +		check_add_overflow(PHYS_PFN(memregion.memphys), pgoff, &start_pfn) ||
>  		check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
>  		return -EOVERFLOW;
>  
> @@ -109,9 +153,16 @@ static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
>  	 * Check that the mapping request does not go beyond available device
>  	 * memory size
>  	 */
> -	if (end > nvdev->memlength)
> +	if (end > memregion.memlength)
>  		return -EINVAL;
>  
> +	/*
> +	 * The carved out region of the device memory needs the NORMAL_NC
> +	 * property. Communicate as such to the hypervisor.
> +	 */
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX)
> +		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +
>  	/*
>  	 * Perform a PFN map to the memory and back the device BAR by the
>  	 * GPU memory.
> @@ -142,7 +193,12 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
>  	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
>  	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
>  		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	struct vfio_region_info_cap_sparse_mmap *sparse;
> +	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
>  	struct vfio_region_info info;
> +	struct mem_region memregion;
> +	uint32_t size;
> +	int ret;
>  
>  	if (copy_from_user(&info, (void __user *)arg, minsz))
>  		return -EFAULT;
> @@ -150,16 +206,14 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
>  	if (info.argsz < minsz)
>  		return -EINVAL;
>  
> -	if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> +	if (nvgrace_gpu_vfio_pci_is_fake_bar(info.index)) {
> +		ret = nvgrace_gpu_vfio_pci_get_mem_region(info.index, nvdev, &memregion);
> +		if (ret)
> +			return ret;
>  		/*
>  		 * Request to determine the BAR region information. Send the
>  		 * GPU memory information.
>  		 */
> -		uint32_t size;
> -		int ret;
> -		struct vfio_region_info_cap_sparse_mmap *sparse;
> -		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> -
>  		size = struct_size(sparse, areas, 1);
>  
>  		/*
> @@ -173,7 +227,7 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
>  
>  		sparse->nr_areas = 1;
>  		sparse->areas[0].offset = 0;
> -		sparse->areas[0].size = nvdev->memlength;
> +		sparse->areas[0].size = memregion.memlength;
>  		sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
>  		sparse->header.version = 1;
>  
> @@ -188,7 +242,7 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
>  		 * Given that the memory is exposed as a BAR and may not be
>  		 * aligned, roundup to the next power-of-2.
>  		 */
> -		info.size = roundup_pow_of_two(nvdev->memlength);
> +		info.size = roundup_pow_of_two(memregion.memlength);
>  		info.flags = VFIO_REGION_INFO_FLAG_READ |
>  			VFIO_REGION_INFO_FLAG_WRITE |
>  			VFIO_REGION_INFO_FLAG_MMAP;
> @@ -201,8 +255,8 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
>  			} else {
>  				vfio_info_cap_shift(&caps, sizeof(info));
>  				if (copy_to_user((void __user *)arg +
> -								sizeof(info), caps.buf,
> -								caps.size)) {
> +						 sizeof(info), caps.buf,
> +						 caps.size)) {
>  					kfree(caps.buf);
>  					return -EFAULT;
>  				}
> @@ -211,7 +265,7 @@ nvgrace_gpu_vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
>  			kfree(caps.buf);
>  		}
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
> -			       -EFAULT : 0;
> +				    -EFAULT : 0;
>  	}
>  	return vfio_pci_core_ioctl(core_vdev, VFIO_DEVICE_GET_REGION_INFO, arg);
>  }
> @@ -228,12 +282,13 @@ static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>  }
>  
> -static int nvgrace_gpu_memmap(struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +static int nvgrace_gpu_memmap(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
> +			      struct mem_region *memregion)
>  {
>  	mutex_lock(&nvdev->memmap_lock);
> -	if (!nvdev->memmap) {
> -		nvdev->memmap = memremap(nvdev->memphys, nvdev->memlength, MEMREMAP_WB);
> -		if (!nvdev->memmap) {
> +	if (!memregion->memmap) {
> +		memregion->memmap = memremap(memregion->memphys, memregion->memlength, MEMREMAP_WB);
> +		if (!memregion->memmap) {
>  			mutex_unlock(&nvdev->memmap_lock);
>  			return -ENOMEM;
>  		}
> @@ -256,10 +311,10 @@ static int nvgrace_gpu_memmap(struct nvgrace_gpu_vfio_pci_core_device *nvdev)
>   */
>  static ssize_t
>  nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
> -		     struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +		     struct mem_region memregion)
>  {
>  	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> -	size_t mem_count, i, bar_size = roundup_pow_of_two(nvdev->memlength);
> +	size_t mem_count, i, bar_size = roundup_pow_of_two(memregion.memlength);
>  	u8 val = 0xFF;
>  
>  	if (offset >= bar_size)
> @@ -273,16 +328,16 @@ nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
>  	 * Read request beyond the actual device memory size is filled with ~0,
>  	 * while those beyond the actual reported size is skipped.
>  	 */
> -	if (offset >= nvdev->memlength)
> +	if (offset >= memregion.memlength)
>  		mem_count = 0;
>  	else
> -		mem_count = min(count, nvdev->memlength - (size_t)offset);
> +		mem_count = min(count, memregion.memlength - (size_t)offset);
>  
>  	/*
>  	 * Handle read on the BAR2 region. Map to the target device memory
>  	 * physical address and copy to the request read buffer.
>  	 */
> -	if (copy_to_user(buf, (u8 *)nvdev->memmap + offset, mem_count))
> +	if (copy_to_user(buf, (u8 *)memregion.memmap + offset, mem_count))
>  		return -EFAULT;
>  
>  	/*
> @@ -308,10 +363,16 @@ static ssize_t pcibar_read_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
>  
>  	switch (pos) {
>  	case PCI_BASE_ADDRESS_2:
> -		val = nvdev->bar_regs[0];
> +		val = nvdev->resmem.bar_regs[0];
>  		break;
>  	case PCI_BASE_ADDRESS_3:
> -		val = nvdev->bar_regs[1];
> +		val = nvdev->resmem.bar_regs[1];
> +		break;
> +	case PCI_BASE_ADDRESS_4:
> +		val = nvdev->usemem.bar_regs[0];
> +		break;
> +	case PCI_BASE_ADDRESS_5:
> +		val = nvdev->usemem.bar_regs[1];
>  		break;
>  	}
>  
> @@ -329,14 +390,19 @@ static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
>  	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
>  		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
>  		core_device.vdev);
> +	struct mem_region memregion;
>  	int ret;
>  
> -	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> -		ret = nvgrace_gpu_memmap(nvdev);
> +	if (nvgrace_gpu_vfio_pci_is_fake_bar(index)) {
> +		ret = nvgrace_gpu_vfio_pci_get_mem_region(index, nvdev, &memregion);
> +		if (ret)
> +			return ret;
> +
> +		ret = nvgrace_gpu_memmap(nvdev, &memregion);
>  		if (ret)
>  			return ret;
>  
> -		return nvgrace_gpu_read_mem(buf, count, ppos, nvdev);
> +		return nvgrace_gpu_read_mem(buf, count, ppos, memregion);
>  	}
>  
>  	if (is_fake_bar_pcicfg_emu_reg_access(*ppos))
> @@ -358,10 +424,10 @@ static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
>   */
>  static ssize_t
>  nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
> -		      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +		      struct mem_region memregion)
>  {
>  	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> -	size_t mem_count, bar_size = roundup_pow_of_two(nvdev->memlength);
> +	size_t mem_count, bar_size = roundup_pow_of_two(memregion.memlength);
>  
>  	if (offset >= bar_size)
>  		return -EINVAL;
> @@ -373,10 +439,10 @@ nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
>  	 * Determine how many bytes to be actually written to the device memory.
>  	 * Do not write to the offset beyond available size.
>  	 */
> -	if (offset >= nvdev->memlength)
> +	if (offset >= memregion.memlength)
>  		goto exitfn;
>  
> -	mem_count = min(count, nvdev->memlength - (size_t)offset);
> +	mem_count = min(count, memregion.memlength - (size_t)offset);
>  
>  	/*
>  	 * Only the device memory present on the hardware is mapped, which may
> @@ -384,7 +450,7 @@ nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void __user *buf,
>  	 * access outside the available device memory on the hardware. Drop
>  	 * those write requests.
>  	 */
> -	if (copy_from_user((u8 *)nvdev->memmap + offset, buf, mem_count))
> +	if (copy_from_user((u8 *)memregion.memmap + offset, buf, mem_count))
>  		return -EFAULT;
>  
>  exitfn:
> @@ -405,25 +471,40 @@ static ssize_t pcibar_write_emu(struct nvgrace_gpu_vfio_pci_core_device *nvdev,
>  	if (copy_from_user(&val, buf, count))
>  		return -EFAULT;
>  
> -	size = ~(roundup_pow_of_two(nvdev->memlength) - 1);
> -
>  	if (val == 0xffffffff) {
>  		switch (pos) {
>  		case PCI_BASE_ADDRESS_2:
> -			nvdev->bar_regs[0] = (size & GENMASK(31, 4)) |
> -				(nvdev->bar_regs[0] & GENMASK(3, 0));
> +			size = ~(roundup_pow_of_two(nvdev->resmem.memlength) - 1);
> +			nvdev->resmem.bar_regs[0] = (size & GENMASK(31, 4)) |
> +				(nvdev->resmem.bar_regs[0] & GENMASK(3, 0));
>  			break;
>  		case PCI_BASE_ADDRESS_3:
> -			nvdev->bar_regs[1] = size >> 32;
> +			size = ~(roundup_pow_of_two(nvdev->resmem.memlength) - 1);
> +			nvdev->resmem.bar_regs[1] = size >> 32;
> +			break;
> +		case PCI_BASE_ADDRESS_4:
> +			size = ~(roundup_pow_of_two(nvdev->usemem.memlength) - 1);
> +			nvdev->usemem.bar_regs[0] = (size & GENMASK(31, 4)) |
> +				(nvdev->usemem.bar_regs[0] & GENMASK(3, 0));
> +			break;
> +		case PCI_BASE_ADDRESS_5:
> +			size = ~(roundup_pow_of_two(nvdev->usemem.memlength) - 1);
> +			nvdev->usemem.bar_regs[1] = size >> 32;
>  			break;
>  		}
>  	} else {
>  		switch (pos) {
>  		case PCI_BASE_ADDRESS_2:
> -			nvdev->bar_regs[0] = val;
> +			nvdev->resmem.bar_regs[0] = val;
>  			break;
>  		case PCI_BASE_ADDRESS_3:
> -			nvdev->bar_regs[1] = val;
> +			nvdev->resmem.bar_regs[1] = val;
> +			break;
> +		case PCI_BASE_ADDRESS_4:
> +			nvdev->usemem.bar_regs[0] = val;
> +			break;
> +		case PCI_BASE_ADDRESS_5:
> +			nvdev->usemem.bar_regs[1] = val;
>  			break;
>  		}
>  	}
> @@ -438,14 +519,19 @@ static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
>  	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>  	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
>  		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +	struct mem_region memregion;
>  	int ret;
>  
> -	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> -		ret = nvgrace_gpu_memmap(nvdev);
> +	if (nvgrace_gpu_vfio_pci_is_fake_bar(index)) {
> +		ret = nvgrace_gpu_vfio_pci_get_mem_region(index, nvdev, &memregion);
>  		if (ret)
>  			return ret;
>  
> -		return nvgrace_gpu_write_mem(count, ppos, buf, nvdev);
> +		ret = nvgrace_gpu_memmap(nvdev, &memregion);
> +		if (ret)
> +			return ret;
> +
> +		return nvgrace_gpu_write_mem(count, ppos, buf, memregion);
>  	}
>  
>  	if (is_fake_bar_pcicfg_emu_reg_access(*ppos))
> @@ -499,8 +585,6 @@ nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
>  	if (memphys > type_max(phys_addr_t))
>  		return -EOVERFLOW;
>  
> -	nvdev->memphys = memphys;
> -
>  	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
>  				       &(memlength));
>  	if (ret)
> @@ -516,8 +600,44 @@ nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
>  	if (memlength == 0)
>  		return -ENOMEM;
>  
> -	nvdev->memlength = memlength;
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
> +	     nvdev->usemem.memlength, &nvdev->resmem.memphys)) ||
> +	    (check_sub_overflow(memlength, nvdev->usemem.memlength,
> +	     &nvdev->resmem.memlength))) {
> +		ret = -EOVERFLOW;
> +		goto done;
> +	}
>  
> +done:
>  	return ret;
>  }
>  

The second emulated BAR only exemplifies the issues with the BAR
handling noted in the v13 nvgrace-gpu driver and it doesn't seem like
the semantics of the non-cached read/write accesses have really been
considered since we're still creating a write-back memremap() access
through that path.  Thanks,

Alex


