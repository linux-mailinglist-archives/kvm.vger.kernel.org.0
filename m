Return-Path: <kvm+bounces-65908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9BACBA10B
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7CF3930076B2
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 23:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3106728DF2D;
	Fri, 12 Dec 2025 23:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="1DZrOSHE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="CLT5ut7G"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD86218C2C;
	Fri, 12 Dec 2025 23:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765583289; cv=none; b=WoxqSJDciM0coe0s6lNdItVf/uQDOz1HeKx5L+xThFm3GRsCbyeTRJya1UrSEapchp83ICZPreAUsNdqXJ1YFA9MlbCP0uin5WXYslVrx0BAaFMgeWeHZ0XFg+ucTRslKZ2CgH/Z/Yasd3CJF/iXOIJK5tGbhAXIY++qodJ1CEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765583289; c=relaxed/simple;
	bh=aCXpavTmt2EPOOShrKG7Vrb02gMgs5cUbNxJkVJ3mjw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LzJXGOcTUHXxY8KoVVlvpZINU6M9c9WpxaGNfOkHaTNZoUCDMVPB7dXceycNpI3VNh60Pbskg0QAWNeeigs2pHEl9gZb0WyHL1pcq07ZIi66iU6XBtCgDWpIpEuO1AHGcsZIyFRqyknJG06A41VFZ/+vHwcHL1RsS7fCcEst8/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=1DZrOSHE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=CLT5ut7G; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E6FF114001FC;
	Fri, 12 Dec 2025 18:48:04 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 12 Dec 2025 18:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1765583284;
	 x=1765669684; bh=W9TXVWpHLXJtDlvpLHB65RP0R7uQG8nC3Fdf5xQm6B8=; b=
	1DZrOSHEWSaX3XkP88w8X+/lMkOOHcZEZB940z2Ofk5NpYAbkuxFSy00o79V3ZV4
	Xc3IEI1Gx6mRdESMYo4VqZ20Mrd+U4NCGzWncUdFaBP3Fi5FElaxj6snPDFE0MU2
	lj1fs4U9k4SggxzuQDtUVSpn6G80fCIETEgtUwk0rM1bvS9ul0tN3DsghMEruLQV
	M4CVZnPZ7AJvnJSTAH/W9swOU3EBSkz5cRGij0IBGMi365cZ4n2lk561X19PNzDW
	uFdBOY9a+8Uns3oPGjHE3Ys/VdnacyImiS3wt86ITVWb9jDpcAMFzrCOdpWVSJ0Z
	fx7LnZSBtmQ3hQicAWpr/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1765583284; x=
	1765669684; bh=W9TXVWpHLXJtDlvpLHB65RP0R7uQG8nC3Fdf5xQm6B8=; b=C
	LT5ut7GZaCtq8BU02crDWkE24z2UscNkCREB+vs/1u12Tce92HTAdBwJ8f2LvG0f
	F0ku0rBYVjHRlnZS4JsyEuJI0TgmWCMABdDB4gOs2jltU4g31uwzkBTrOy+B9yo8
	zKiqxZYtPhVl+uOf2tdVy26bemNvP9HB4+reKEtdaDDS3+1BmNfLiZs3MGe+pTRF
	K5g/71scGJ1sWWWZkZORhp+0E8VTp+JntUMJYEH9u9sq4pU+A3mjbRaOD1gPY73A
	ih6fsPTlXy+6/er/cd9OqBHHsvBQ+XmzxDndhAGu6ZfARYEfX63TytyLeITmnFsJ
	ZeBofGbv117E95fGD34hA==
X-ME-Sender: <xms:tKk8aQX6cp5HO_gokUSEOFam63oerwI3eO-Wn-i6ePHOYbzWf_lYAA>
    <xme:tKk8afwvMGZyTVrHjT-nvVORRSlvWd3pmvCxzDMRHwHrOeoe0qv_UuziakTDKA0Zf
    zW_8PcdNdY6wWECX5nEp_KlTejivc3U7E_0IavCgqgkEYMfqQCr4A>
X-ME-Received: <xmr:tKk8aYNUKc5qUa_SVNgYBvscPpsYApi--brKofNa6841tVK2HIjjkdJb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvleehgecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:tKk8aZqz90rPtd-LBFImpOT3VRDxAAWLD22Le4uK9e71EHEtn_q99A>
    <xmx:tKk8aX-eTUKtMHd33mXZoboaaeShWwxvHNPWhkKiybM7C1E_ca__7w>
    <xmx:tKk8aX04fPDhgBFtbmrP8Ehr7IZmC7J9vi1gJ7d7AswTm01hh7fZnw>
    <xmx:tKk8aSAaJcIcj2JAXOegFPF28IaJpUv7ht6UFI5bdW0sdSR_nmfQFw>
    <xmx:tKk8aWywaqytJhxzbTZBoJ4YftNYW1tgIyETuBZ9xUK2o6AQb3zsU3ZG>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Dec 2025 18:48:00 -0500 (EST)
Date: Sat, 13 Dec 2025 08:47:57 +0900
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <akpm@linux-foundation.org>,
 <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v1 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Message-ID: <20251213084757.0e6089f7.alex@shazbot.org>
In-Reply-To: <20251211070603.338701-4-ankita@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
	<20251211070603.338701-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Dec 2025 07:06:03 +0000
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
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 84d142a47ec6..fdfb961a6972 100644
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
> +static inline int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvdev,

Per Documentation/process/coding-style.rst this doesn't meet the
guidelines for being declared inline.

> +				       unsigned int index,
> +				       unsigned long pfn,
> +				       u64 *pfn_offset_in_region)

Is a pgoff_t more appropriate here?

> +{
> +	struct mem_region *region;
> +	unsigned long start_pfn, num_pages;
> +
> +	region = nvgrace_gpu_memregion(index, nvdev);
> +	if (!region)
> +		return -ENOENT;
> +
> +	start_pfn = PHYS_PFN(region->memphys);
> +	num_pages = region->memlength >> PAGE_SHIFT;
> +
> +	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
> +		return -EINVAL;
> +
> +	*pfn_offset_in_region = pfn - start_pfn;
> +
> +	return 0;
> +}
> +
> +static inline struct nvgrace_gpu_pci_core_device *
> +vma_to_nvdev(struct vm_area_struct *vma);

Ugly line wrapping, try:

static inline
struct nvgrace_gpu_pci_core_device *vma_to_nvdev(...

> +
> +static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
> +					unsigned long pfn,
> +					pgoff_t *pgoff)
> +{
> +	struct nvgrace_gpu_pci_core_device *nvdev;
> +	unsigned int index =
> +		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	u64 vma_offset_in_region = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);

It's still a pgoff_t

> +	u64 pfn_offset_in_region;

As is this.

> +	int ret;
> +
> +	nvdev = vma_to_nvdev(vma);
> +	if (!nvdev)
> +		return -EPERM;

More of a nit, but the errnos seem like they could use a little more
thought.  The above is more of a "not my vma", ie. ENOENT.  Failing to
get a mem_region associated with a vma that is confirmed ours is more
of an invalid arg, EINVAL.  Ultimately the question though is does this
pfn land in this vma and if so provide the pgoff_t relative to the vma.
So maybe a pfn unassociated to the vma is more of a bad address, EFAULT.

> +
> +	ret = pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_region);
> +	if (ret)
> +		return ret;
> +
> +	/* Ensure PFN is not before VMA's start within the region */
> +	if (pfn_offset_in_region < vma_offset_in_region)
> +		return -EINVAL;

This is really just another version of the pfn is not associated to the
vma, the only difference is the pfn lands on the device, but still
probably -EFAULT.

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
> +static inline struct nvgrace_gpu_pci_core_device *
> +vma_to_nvdev(struct vm_area_struct *vma)

Same wrapping suggestion as above.  Thanks,

Alex

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


