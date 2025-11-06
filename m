Return-Path: <kvm+bounces-62243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 375EFC3D886
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 22:56:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B83934E392A
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 21:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969F33081DD;
	Thu,  6 Nov 2025 21:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="REjd7ea4";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TEBqBx0v"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E56F2ED175;
	Thu,  6 Nov 2025 21:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762466194; cv=none; b=pq3FlPvHubjhz4bL1PPhBVukNfRjMytt+nNdF1N8Jbw8TKpZ6W9ujX+bAynRDa0yywcAVb6XJvqQ0RlNa3odq5vT8prFu12a1G+YZ3nWN1156cg6HV+jwbzskPVzHM+E3T16so4mwpCxfSk9D3/A7lXuWUhi7BdAqaHEEaojSw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762466194; c=relaxed/simple;
	bh=Wnn2TE7l8/HF6KTmsLA1p6vAtjQPjrc9cNKpin17/Pw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cm/r6Q+RpivgLXsG5NjiyXR4GczgmlSfUlSZww2sI4r4VwxVUUgncSDlNmSewMv5ItcdS0EzSMg4pbKeg/gg/5sC/dhfkkjRuIbMDV9s3MLxG8aC6SKDnqmJYC3DppT6+CP31CqhGZFNBxqjCyrQat+U4iRRpmcIy0Aa1n54Lm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=REjd7ea4; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TEBqBx0v; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 33E637A009A;
	Thu,  6 Nov 2025 16:56:29 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 06 Nov 2025 16:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762466189;
	 x=1762552589; bh=qPfsiLN1n3oCXH0bYb9sc+hEU45g8Wrq4al92DnOXSw=; b=
	REjd7ea48BU9x1rmydQeYrwoKcgxNX8+mUmzTKMSvlEpUs8m9K9hlcK0GbU1LEeA
	NVYPwD98/nmhIhUIkLFGqEMkZ0zcb0UQhKmGw+p9ULpJ6tfK3soxbmxm7mpK1sID
	0KVYWCJWDNk6s3a4BLoCx0SUO8J1WUcG40XOMjtQAlKGZEmb3YXWXyZUcr1PFtHv
	9lrTfMGzUTYcWiQFC9b1lvoBBt+S0AC9DYVLwU3vGQBdD5rpksjiEq8ERDMLzQh2
	TCKP8oE1oMim/s7wzlN+v5BhFYNDZ88Y+Q85D3JXd4I889RtES83LnojVTX7vIhz
	gcPNtHt1r9nbutpmtX3g/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762466189; x=
	1762552589; bh=qPfsiLN1n3oCXH0bYb9sc+hEU45g8Wrq4al92DnOXSw=; b=T
	EBqBx0vGyrD+M7zHDdEiypWw2aHj44F4s+KKGiS6E7bbBqutRUYGGdUXJDCJOPAP
	cH8T4NgtQFCrRZMfvh5JdrYimP+Atx9vaYclPTYIVED5Zl30HjeD0vqfv//7lsem
	/80j4lM4I85ZsZf0Cexk0ZY5LuzcuBze1x76Fgl5QNEJd3cNydWw5o4PC+u4vOPl
	DSgosf/FvJe/Rjs8EJdluO5i2unn6u8QIJUwn8NCw1dqdWDjpaXDTLxAdmRlbRc4
	s33o+DwUb34GVfaw0ww0pKuJ0GAxUvtYopgP56lHjoNF1Y29qJLrQ39QmyWuzt9e
	Cm0zXNNMk0OliQDNcZyzg==
X-ME-Sender: <xms:ihkNaZyuoNPb30d6i4X9m4a5JDlaVzyKERQvPEE3jNzHt2CQQ3PhSA>
    <xme:ihkNaRjbfos2rb-YOcRfsfkOJQcqWFRmF26uvJe4fv47K1yA6hxkEVdV0jWjhsjfB
    RHMgljin4t4oRzgzZD1sERWcnEn2PiyrV8uRKsfUZE0tqtIN9JI>
X-ME-Received: <xmr:ihkNaRI8Za-W-t78sM2q5XqiH2yb-clOLLraA92U79VBmkvuUWTNPmp8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeejledvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeehvddtueevjeduffejfeduhfeufe
    ejvdetgffftdeiieduhfejjefhhfefueevudenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeefledpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtph
    htthhopegrnhhikhgvthgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehvshgvthhh
    ihesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpd
    hrtghpthhtohepmhhotghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhl
    ohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehlihhnmhhirghohh
    gvsehhuhgrfigvihdrtghomhdprhgtphhtthhopehnrghordhhohhrihhguhgthhhisehg
    mhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtih
    honhdrohhrgh
X-ME-Proxy: <xmx:ihkNaQcEhPMq-qSqBVkoefCb_0FrAK5mvbl7mJTt0zHmSaNo0LROJw>
    <xmx:ixkNaVjv2QmUxlYiv9iqoyIZtqTYLtXDPfE3w3ztagX3NOq5dIUI3g>
    <xmx:ixkNaVmiKwJPbNlzenf75TxYAt9k9HqaWn0xSxG0NfO9US_s1_J6uw>
    <xmx:ixkNacVfSy0qbaJ67wFSS92CC5LBEmjQeDgZ49X0naGjhg6gxdpY9w>
    <xmx:jRkNaWE7ZC2BhJZqjFONk0ddcg7naexkNkaf5fTZrI7LB8RMAz3li4ND>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Nov 2025 16:56:24 -0500 (EST)
Date: Thu, 6 Nov 2025 14:56:22 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <aniketa@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
 <mochs@nvidia.com>, <skolothumtho@nvidia.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
 <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
 <guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
 <kevin.tian@intel.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <zhiw@nvidia.com>, <dnigam@nvidia.com>,
 <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
 <ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
 <u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
 <linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Message-ID: <20251106145622.1610d306.alex@shazbot.org>
In-Reply-To: <20251102184434.2406-4-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
	<20251102184434.2406-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 2 Nov 2025 18:44:34 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The nvgrace-gpu-vfio-pci module [1] maps the device memory to the user VA
> (Qemu) using remap_pfn_range() without adding the memory to the kernel.
> The device memory pages are not backed by struct page. The previous
> patch implements the mechanism to handle ECC/poison on memory page without
> struct page. This new mechanism is being used here.
> 
> The module registers its memory region and the address_space with the
> kernel MM for ECC handling using the register_pfn_address_space()
> registration API exposed by the kernel.
> 
> Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 45 ++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)

LGTM.  I see Andrew has already picked this up in mm-new, if he
refreshes, here's another ack.

Acked-by: Alex Williamson <alex@shazbot.org>

Thanks,
Alex

> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index d95761dcdd58..80b3ed63c682 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -8,6 +8,10 @@
>  #include <linux/delay.h>
>  #include <linux/jiffies.h>
>  
> +#ifdef CONFIG_MEMORY_FAILURE
> +#include <linux/memory-failure.h>
> +#endif
> +
>  /*
>   * The device memory usable to the workloads running in the VM is cached
>   * and showcased as a 64b device BAR (comprising of BAR4 and BAR5 region)
> @@ -47,6 +51,9 @@ struct mem_region {
>  		void *memaddr;
>  		void __iomem *ioaddr;
>  	};                      /* Base virtual address of the region */
> +#ifdef CONFIG_MEMORY_FAILURE
> +	struct pfn_address_space pfn_address_space;
> +#endif
>  };
>  
>  struct nvgrace_gpu_pci_core_device {
> @@ -60,6 +67,28 @@ struct nvgrace_gpu_pci_core_device {
>  	bool has_mig_hw_bug;
>  };
>  
> +#ifdef CONFIG_MEMORY_FAILURE
> +
> +static int
> +nvgrace_gpu_vfio_pci_register_pfn_range(struct mem_region *region,
> +					struct vm_area_struct *vma)
> +{
> +	unsigned long nr_pages;
> +	int ret = 0;
> +
> +	nr_pages = region->memlength >> PAGE_SHIFT;
> +
> +	region->pfn_address_space.node.start = vma->vm_pgoff;
> +	region->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
> +	region->pfn_address_space.mapping = vma->vm_file->f_mapping;
> +
> +	ret = register_pfn_address_space(&region->pfn_address_space);
> +
> +	return ret;
> +}
> +
> +#endif
> +
>  static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
>  {
>  	struct nvgrace_gpu_pci_core_device *nvdev =
> @@ -127,6 +156,13 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  
>  	mutex_destroy(&nvdev->remap_lock);
>  
> +#ifdef CONFIG_MEMORY_FAILURE
> +	if (nvdev->resmem.memlength)
> +		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
> +
> +	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
> +#endif
> +
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> @@ -202,7 +238,14 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  
>  	vma->vm_pgoff = start_pfn;
>  
> -	return 0;
> +#ifdef CONFIG_MEMORY_FAILURE
> +	if (nvdev->resmem.memlength && index == VFIO_PCI_BAR2_REGION_INDEX)
> +		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->resmem, vma);
> +	else if (index == VFIO_PCI_BAR4_REGION_INDEX)
> +		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->usemem, vma);
> +#endif
> +
> +	return ret;
>  }
>  
>  static long


