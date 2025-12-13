Return-Path: <kvm+bounces-65924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C68CCBA6FE
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 09:01:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1CD03052B1A
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 08:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E70285CAA;
	Sat, 13 Dec 2025 08:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="PD7k7SrW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="db5hIDJi"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A930E1C84CB;
	Sat, 13 Dec 2025 08:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765612816; cv=none; b=FlHltOoKypejv6brv5jrf1YRhKd1z2dp2+k1xKgUomtQC9nQKfgaH7/D3DZZCrj5LHhglQ8n+wEgg+59c7GFwd1shhFCIwlchuafI0vdo5OJVjyLcUrVuS5Pn9w2IQuWv5d5Io7aTGI91NbhjPcfpcGq+lTSU+DHLVzl0LgcJi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765612816; c=relaxed/simple;
	bh=QfWovsD//pnp/uqN66/qw77t5D2F2+FkFk/S+xG/uf8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iA31bYEcK6aq2xQk4RfheIHekYS19C8NJ+pT5GPcgFG79kggetyQBbKlMWycebZJAnoE5cPNzTkRgqWZXT8y2SV0YosN8FlsylhJcmJj5znswOncGuX8OCQvEuEnwUdu2GcmFd1aTDGwPrla2D+6SmIMsWI+zbcPiXnAnZ0Zca8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=PD7k7SrW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=db5hIDJi; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 9E74EEC0571;
	Sat, 13 Dec 2025 03:00:10 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Sat, 13 Dec 2025 03:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1765612810;
	 x=1765699210; bh=4cKpV/fyfVbQhCD31q9uz0Vr0824m5w2xINKUH++CfU=; b=
	PD7k7SrW+VLJLCwifJ5cLDKSHOPAtI3Nq6ft0mZE/r7pGm0YRIjjxRMUA//oqvUR
	N2XYY8qETgbHaPH46U1og3bwYSjQt+tr7PmDmFhWtZYkR09XHl1s0vNyGhxNFUU9
	fHWj6w7v9XvOJKYC9k5UHhUkFAPUwdrKN5KWHwPMBJmqskNuAMlord9myRNCV2bB
	hcp/Kc4JF6Jj6JAr2w0xtmcMgAFeAddfk7DtGSI2weHhNekGkxxVZHp6lEdUoDeo
	Fdd4RTw84fYPjeuidCq8QHKERicP5/B2+kVdRmTIfF8QyPRtlTcVM5KSJq+7HxbG
	OduxX7EQqP97kOhI5tPaQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1765612810; x=
	1765699210; bh=4cKpV/fyfVbQhCD31q9uz0Vr0824m5w2xINKUH++CfU=; b=d
	b5hIDJicNFH3b9OB0jJB2phHJ3qewHZuZCoujThWEntl1lDuDeAgS73te5jhO4EF
	9Q/yOTYFtUIXtfJNNnZ1CP64XhMGEqWo6pCMRY+E1aPGOLcARoPBNxwkXBPV/zC6
	ITN8RksTZFprefNBs+MxJp3vh74/q4k3Qbu/KzwqaIfXPFBDolTgqNGFKwwznyfS
	uy/Ph95RTFkgBqKoh+k5KizLhDQKwB6XIn7KvAJXX7CHryeFE5F2MsUx2LnS4jkm
	4iCZJOCN7Gd4n89Lt0UzuMTtNM6vPE+xDSf9wlO349ObeyP6C87a/iWIzX4hGv3R
	SIyS1jdQqEZGGUMgMANqA==
X-ME-Sender: <xms:CR09aZ0se5d3fy_spLds3LVWykP23hi5QJ_eccTKLMMaT2yakXNTEw>
    <xme:CR09aZdYqUErkr3zt0uuDzHNmoy5bH0Q8A7iugKAOQG7ZGxHf98FfWT343M3rveIW
    360q_eOPk2tYN3JGbXQ1UWkTEFSIKg2ezIkc3hg62vQbrJxBdnbUQ>
X-ME-Received: <xmr:CR09aSag5YeKcHmQCnWMWnKF6g3erPdMltjQi4jA1YVdZW2pcNlqKwcl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkjghfgggtgfesthejredttd
    dtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhhrgii
    sghothdrohhrgheqnecuggftrfgrthhtvghrnhephedvtdeuveejudffjeefudfhueefje
    dvtefgffdtieeiudfhjeejhffhfeeuvedunecuffhomhgrihhnpehkvghrnhgvlhdrohhr
    ghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlh
    gvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepudejpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpth
    htohepvhhsvghthhhisehnvhhiughirgdrtghomhdprhgtphhtthhopehjghhgsehnvhhi
    ughirgdrtghomhdprhgtphhtthhopehmohgthhhssehnvhhiughirgdrtghomhdprhgtph
    htthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehskhholhhothhhuhhmthhh
    ohesnhhvihguihgrrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopehlihhnmhhirghohhgvsehhuhgrfigvihdr
    tghomhdprhgtphhtthhopehnrghordhhohhrihhguhgthhhisehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:CR09aWXS5_16LGB8Zv-_B0guUAGOluib79melqLDniY5OlYEwDI3jg>
    <xmx:CR09adRYhMy-CWM-TT_seE_oFA2Bk7s7FFFGh988PjaW2-8cjwRW5A>
    <xmx:CR09aTEUGmVjFZuiM6tjs9PJv1_a7j10QHjI_kTDcTnLLGmL0LeLNA>
    <xmx:CR09aUdBYE-UU5jPFlusESAWcmhzir2Gv4JT7HUM7dfRQxq4KivpMA>
    <xmx:Ch09aS6qUcggBsvuf3RJTQtwZHXzdMqLHkGhpRpB3Dqw8-TVvl6jGrgq>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 13 Dec 2025 03:00:05 -0500 (EST)
Date: Sat, 13 Dec 2025 17:00:02 +0900
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <akpm@linux-foundation.org>,
 <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Message-ID: <20251213170002.5babbf70.alex@shazbot.org>
In-Reply-To: <20251213044708.3610-4-ankita@nvidia.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
	<20251213044708.3610-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 13 Dec 2025 04:47:08 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The nvgrace-gpu module [1] maps the device memory to the user VA (Qemu)
> without adding the memory to the kernel. The device memory pages are PFNMAP
> and not backed by struct page. The module can thus utilize the MM's PFNMAP
> memory_failure mechanism that handles ECC/poison on regions with no struct
> pages.
> 
> The kernel MM code exposes register/unregister APIs allowing modules to
> register the device memory for memory_failure handling. Make nvgrace-gpu
> register the GPU memory with the MM on open.
> 
> The module registers its memory region, the address_space with the
> kernel MM for ECC handling and implements a callback function to convert
> the PFN to the file page offset. The callback functions checks if the
> PFN belongs to the device memory region and is also contained in the
> VMA range, an error is returned otherwise.
> 
> Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]
> 
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
>  1 file changed, 112 insertions(+), 4 deletions(-)

I'm not sure where Andrew stands with this series going into v6.19-rc
via mm as an alternate fix to Linus' revert, but in case it's on the
table for that to happen:

Reviewed-by: Alex Williamson <alex@shazbot.org>

Otherwise let's get some mm buy-in for the front of the series and
maybe it should go in through vfio since nvgrace is the only user of
these interfaces currently.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 84d142a47ec6..91b4a3a135cf 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -9,6 +9,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/pci-p2pdma.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/memory-failure.h>
>  
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -49,6 +50,7 @@ struct mem_region {
>  		void *memaddr;
>  		void __iomem *ioaddr;
>  	};                      /* Base virtual address of the region */
> +	struct pfn_address_space pfn_address_space;
>  };
>  
>  struct nvgrace_gpu_pci_core_device {
> @@ -88,6 +90,83 @@ nvgrace_gpu_memregion(int index,
>  	return NULL;
>  }
>  
> +static int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvdev,
> +				unsigned int index,
> +				unsigned long pfn,
> +				pgoff_t *pfn_offset_in_region)
> +{
> +	struct mem_region *region;
> +	unsigned long start_pfn, num_pages;
> +
> +	region = nvgrace_gpu_memregion(index, nvdev);
> +	if (!region)
> +		return -EINVAL;
> +
> +	start_pfn = PHYS_PFN(region->memphys);
> +	num_pages = region->memlength >> PAGE_SHIFT;
> +
> +	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
> +		return -EFAULT;
> +
> +	*pfn_offset_in_region = pfn - start_pfn;
> +
> +	return 0;
> +}
> +
> +static inline
> +struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma);
> +
> +static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
> +					unsigned long pfn,
> +					pgoff_t *pgoff)
> +{
> +	struct nvgrace_gpu_pci_core_device *nvdev;
> +	unsigned int index =
> +		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	pgoff_t vma_offset_in_region = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	pgoff_t pfn_offset_in_region;
> +	int ret;
> +
> +	nvdev = vma_to_nvdev(vma);
> +	if (!nvdev)
> +		return -ENOENT;
> +
> +	ret = pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_region);
> +	if (ret)
> +		return ret;
> +
> +	/* Ensure PFN is not before VMA's start within the region */
> +	if (pfn_offset_in_region < vma_offset_in_region)
> +		return -EFAULT;
> +
> +	/* Calculate offset from VMA start */
> +	*pgoff = vma->vm_pgoff +
> +		 (pfn_offset_in_region - vma_offset_in_region);
> +
> +	return 0;
> +}
> +
> +static int
> +nvgrace_gpu_vfio_pci_register_pfn_range(struct vfio_device *core_vdev,
> +					struct mem_region *region)
> +{
> +	int ret;
> +	unsigned long pfn, nr_pages;
> +
> +	pfn = PHYS_PFN(region->memphys);
> +	nr_pages = region->memlength >> PAGE_SHIFT;
> +
> +	region->pfn_address_space.node.start = pfn;
> +	region->pfn_address_space.node.last = pfn + nr_pages - 1;
> +	region->pfn_address_space.mapping = core_vdev->inode->i_mapping;
> +	region->pfn_address_space.pfn_to_vma_pgoff = nvgrace_gpu_pfn_to_vma_pgoff;
> +
> +	ret = register_pfn_address_space(&region->pfn_address_space);
> +
> +	return ret;
> +}
> +
>  static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =
> @@ -114,14 +193,28 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  	 * memory mapping.
>  	 */
>  	ret = vfio_pci_core_setup_barmap(vdev, 0);
> -	if (ret) {
> -		vfio_pci_core_disable(vdev);
> -		return ret;
> +	if (ret)
> +		goto error_exit;
> +
> +	if (nvdev->resmem.memlength) {
> +		ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->resmem);
> +		if (ret && ret != -EOPNOTSUPP)
> +			goto error_exit;
>  	}
>  
> -	vfio_pci_core_finish_enable(vdev);
> +	ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->usemem);
> +	if (ret && ret != -EOPNOTSUPP)
> +		goto register_mem_failed;
>  
> +	vfio_pci_core_finish_enable(vdev);
>  	return 0;
> +
> +register_mem_failed:
> +	if (nvdev->resmem.memlength)
> +		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
> +error_exit:
> +	vfio_pci_core_disable(vdev);
> +	return ret;
>  }
>  
>  static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
> @@ -130,6 +223,11 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
>  			     core_device.vdev);
>  
> +	if (nvdev->resmem.memlength)
> +		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
> +
> +	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
> +
>  	/* Unmap the mapping to the device memory cached region */
>  	if (nvdev->usemem.memaddr) {
>  		memunmap(nvdev->usemem.memaddr);
> @@ -247,6 +345,16 @@ static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
>  #endif
>  };
>  
> +static inline
> +struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma)
> +{
> +	/* Check if this VMA belongs to us */
> +	if (vma->vm_ops != &nvgrace_gpu_vfio_pci_mmap_ops)
> +		return NULL;
> +
> +	return vma->vm_private_data;
> +}
> +
>  static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  			    struct vm_area_struct *vma)
>  {


