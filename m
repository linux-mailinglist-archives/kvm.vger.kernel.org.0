Return-Path: <kvm+bounces-64179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE70C7AF92
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:03:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D148C35A5F0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 16:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997222F12C4;
	Fri, 21 Nov 2025 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="f0S/mjwn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="v29zozUq"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDCB275861;
	Fri, 21 Nov 2025 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763744377; cv=none; b=SCDbVotav/HhrvCzM3ip8jtvHnjzVp1/GpnALt8TzuW8Xb1hJI0LkwqzAJjkLYa6S7yXOG6f31F13bWgx/Z9O7hyMr59f0hnruqKMSWTtDire92YYtSLXm/4pPhxisSDSBKx+A6lhZSwCai0X5orKqOuB4O9tD08IVNjQ8qAXxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763744377; c=relaxed/simple;
	bh=aQKU6V1JRH668sbcJH4gp1GCpog2CNat/iF2OOt8G2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S6QKSl6x+M3n3kbwnM9VdjhWURN54ubrHgn8o3x7fInEICzeQSlA4UQyUqf8ECH67K0HfM8qo2wUtsMOCm6FpJ2j2n3OGOw0oSyL6bSAw8tZQeE50Q4DplNL+VlsmXe2nYEA1J6rhchzp7OeASVFF9dMe8DIGtld1n4F/3UX95o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=f0S/mjwn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=v29zozUq; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 688B47A0112;
	Fri, 21 Nov 2025 11:59:33 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 21 Nov 2025 11:59:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763744373;
	 x=1763830773; bh=NQDfHKLWmqlj9klBa55Uq5LxkyIhHUTxyXA+WdMEM60=; b=
	f0S/mjwnOAH0n55Ke8Dt4V7RmyZiQDFqlbDtQ9u7e4f8c4vAoflk+QaZFfIxkfpD
	9+XL+m5Yy/MEFyg1dC7wXwSvrPlEe1W9j/PEWb2+RqMvrJV6ycJ1R/jTh8QaU/i6
	yQRw7sgLn2Vq/ZMzckQXq9/07Y/zeLGbJ4LmX+5/YF0CgRvw57TkIPFTHTwkJMQf
	jXOjF9d2m8uE5M4eH1t98bH0bsROxvKOx3OWjJ0dvDsVtEnCQhqXqNbRDINtkKPh
	8XxOBu39G/hoO9K288UB7HEvWWcGLIOYP+ZlfhAOPkx+ofXv4ALUd6SkRl4BcTHA
	Wm9R/w9Vbns6ymAPgT1AeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763744373; x=
	1763830773; bh=NQDfHKLWmqlj9klBa55Uq5LxkyIhHUTxyXA+WdMEM60=; b=v
	29zozUq2TH9pHSTqv2XgF+s197ujp1DRzATQK6T5Ub+NKx0taIorchlJcvqcmMd9
	0S5xD178G/rC0L5tAp2u/aCcz2YT8Ov1+uZ4mX2h5LcmBMYtaSBVkZpNF8wrixKb
	M3RONoh0y3QIExR50ysG5EYdjbaCGkZGPvUVZOsBxRicRcK5aZ1EU71eO7hbUBk+
	vxKu7L2H2zAxt4amjcqZiJOwf1h/vkR0DJTTWCceaOx5Q/9XppcicJVFpmI3U5o5
	5JbM4kkDyla7rheySLRSqXbEGj9YGdjodoNJMTuuoKZdArXS5MdNtibv2Q36zbpu
	y9KcUpw7b9VXRwNJxXavA==
X-ME-Sender: <xms:dJogaZ-ejhfierwMrNbQbqpWx-n-uc8-GwtvInx9HjGR68bykIFqpQ>
    <xme:dJogaV62mBX_eM3PKltQvdcRTnoVfKrSTJKjlG-RGYU4P8l1AjM5g0h2aT4_nj7JC
    xOkGyzQqmZNBN1uoXHeBOU715ytAfbuY1euFEK--v8ofnIljbsO>
X-ME-Received: <xmr:dJogaeUrzweu2LNo2OhiH1IkYwStEnT-CI6Ae8JQrD8adgVtirEtsH46>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfedthedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeetteduleegkeeigedugeeluedvff
    egheeliedvtdefkedtkeekheffhedutefhhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspg
    hrtghpthhtohepvdehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrnhhkihht
    rgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtg
    hpthhtohephihishhhrghihhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhl
    ohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehkvghvihhnrdhtih
    grnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrnhhikhgvthgrsehnvhhiughirgdr
    tghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrdgtohhmpdhrtghpthhtoh
    epmhhotghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohephihunhigihgrnhhgrdhl
    ihesrghmugdrtghomh
X-ME-Proxy: <xmx:dJogabKUstFIMw1gOdjURL9DoEtrrBGvZl779rdU8NsyiFOGQDzsXw>
    <xmx:dJogabRqW4O8EX0afgiKHxftSW9Ylbg2ewiMWEOYgZn1wdzTdPy4Hw>
    <xmx:dJogafhyBK5nO_Wi7CUSCMX-fcYB6J8MS2NUV6sNtRjd-qO6zcbB5A>
    <xmx:dJogadteLLdyxXy5SdnQlFOqa8-ZZioiYov8XnKpUwci5omjSoHH8w>
    <xmx:dZogaWBxvXC1wUTUdjVP35sRasyu3O1FHd0pgEKVl7rzhrAaL08q8LBc>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Nov 2025 11:59:30 -0500 (EST)
Date: Fri, 21 Nov 2025 09:59:28 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <skolothumtho@nvidia.com>,
 <kevin.tian@intel.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
 <mochs@nvidia.com>, <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
 <zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
 <bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
 <apopple@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <zhiw@nvidia.com>, <danw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: Re: [PATCH v3 7/7] vfio/nvgrace-gpu: wait for the GPU mem to be
 ready
Message-ID: <20251121095928.4c95c704.alex@shazbot.org>
In-Reply-To: <20251121141141.3175-8-ankita@nvidia.com>
References: <20251121141141.3175-1-ankita@nvidia.com>
	<20251121141141.3175-8-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Nov 2025 14:11:41 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Speculative prefetches from CPU to GPU memory until the GPU is
> ready after reset can cause harmless corrected RAS events to
> be logged on Grace systems. It is thus preferred that the
> mapping not be re-established until the GPU is ready post reset.
> 
> The GPU readiness can be checked through BAR0 registers similar
> to the checking at the time of device probe.
> 
> It can take several seconds for the GPU to be ready. So it is
> desirable that the time overlaps as much of the VM startup as
> possible to reduce impact on the VM bootup time. The GPU
> readiness state is thus checked on the first fault/huge_fault
> request which amortizes the GPU readiness time. The first fault
> is checked using a flag. The flag is unset on every GPU reset
> request.
> 
> Intercept the following calls to the GPU reset, unset gpu_mem_mapped.
> Then use it to determine whether to wait before mapping.
> 1. VFIO_DEVICE_RESET ioctl call
> 2. FLR through config space.
> 
> cc: Alex Williamson <alex@shazbot.org>
> cc: Jason Gunthorpe <jgg@ziepe.ca>
> cc: Vikram Sethi <vsethi@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 64 ++++++++++++++++++++++++++++-
>  1 file changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 7618c3f515cc..23e3278aba25 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -58,6 +58,8 @@ struct nvgrace_gpu_pci_core_device {
>  	/* Lock to control device memory kernel mapping */
>  	struct mutex remap_lock;
>  	bool has_mig_hw_bug;
> +	/* Any GPU memory mapped to the VMA */
> +	bool gpu_mem_mapped;
>  };
>  
>  static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
> @@ -102,9 +104,15 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  		mutex_init(&nvdev->remap_lock);
>  	}
>  
> +	nvdev->gpu_mem_mapped = false;
> +
>  	vfio_pci_core_finish_enable(vdev);
>  
> -	return 0;
> +	/*
> +	 * The GPU readiness is determined through BAR0 register reads.
> +	 * Make sure the BAR0 is mapped before any such check occur.
> +	 */
> +	return vfio_pci_core_barmap(vdev, 0);

I think the idea is that all variant specific open code happens between
vfio_pci_core_enable() and vfio_pci_core_finish_enable().

>  }
>  
>  static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
> @@ -158,6 +166,21 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
>  	struct mem_region *memregion;
>  	unsigned long pgoff, pfn, addr;
>  
> +	/*
> +	 * If the GPU memory is accessed by the CPU while the GPU is
> +	 * not ready after reset, it can cause harmless corrected RAS
> +	 * events to be logged. Make sure the GPU is ready before
> +	 * establishing the mappings.
> +	 */
> +	if (!nvdev->gpu_mem_mapped) {
> +		struct vfio_pci_core_device *vdev = &nvdev->core_device;
> +
> +		if (nvgrace_gpu_wait_device_ready(vdev->barmap[0]))
> +			return VM_FAULT_SIGBUS;
> +
> +		nvdev->gpu_mem_mapped = true;
> +	}
> +
>  	memregion = nvgrace_gpu_memregion(index, nvdev);
>  	if (!memregion)
>  		return ret;
> @@ -354,7 +377,17 @@ static long nvgrace_gpu_ioctl(struct vfio_device *core_vdev,
>  	case VFIO_DEVICE_IOEVENTFD:
>  		return -ENOTTY;
>  	case VFIO_DEVICE_RESET:
> +		struct nvgrace_gpu_pci_core_device *nvdev =
> +			container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
> +				     core_device.vdev);
>  		nvgrace_gpu_init_fake_bar_emu_regs(core_vdev);
> +
> +		/*
> +		 * GPU memory is exposed as device BAR2 (region 4,5).
> +		 * This would be zapped during GPU reset. Unset
> +		 * nvdev->gpu_mem_mapped to reflect just that.
> +		 */
> +		nvdev->gpu_mem_mapped = false;

Why aren't we using a reset_done callback for this, where we then might
name the flag "reset_done"?  What protects this flag against races,
is it only valid under memory_lock?  memory_lock is held across reset,
including .reset_done.


>  		fallthrough;
>  	default:
>  		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> @@ -439,11 +472,14 @@ nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,
>  	struct nvgrace_gpu_pci_core_device *nvdev =
>  		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
>  			     core_device.vdev);
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
>  	u64 pos = *ppos & VFIO_PCI_OFFSET_MASK;
>  	struct mem_region *memregion = NULL;
>  	size_t register_offset;
>  	loff_t copy_offset;
>  	size_t copy_count;
> +	int cap_start = vfio_find_cap_start(vdev, pos);
>  
>  	if (vfio_pci_core_range_intersect_range(pos, count, PCI_BASE_ADDRESS_2,
>  						sizeof(u64), &copy_offset,
> @@ -462,6 +498,23 @@ nvgrace_gpu_write_config_emu(struct vfio_device *core_vdev,
>  		return copy_count;
>  	}
>  
> +	if (vfio_pci_core_range_intersect_range(pos, count, cap_start + PCI_EXP_DEVCTL,
> +						sizeof(u16), &copy_offset,
> +						&copy_count, &register_offset)) {
> +		__le16 val16;
> +
> +		if (copy_from_user((void *)&val16, buf, copy_count))
> +			return -EFAULT;
> +
> +		/*
> +		 * GPU memory is exposed as device BAR2 (region 4,5).
> +		 * This would be zapped during GPU reset. Unset
> +		 * nvdev->gpu_mem_mapped to reflect just that.
> +		 */
> +		if (val16 & cpu_to_le16(PCI_EXP_DEVCTL_BCR_FLR))
> +			nvdev->gpu_mem_mapped = false;
> +	}

reset_done would significantly simplify this and avoid that we need to
export vfio_find_cap_start().  I think it might be done this way to set
the flag prior to reset, but as above, the flag seems racy as
implemented here.

> +
>  	return vfio_pci_core_write(core_vdev, buf, count, ppos);
>  }
>  
> @@ -478,9 +531,18 @@ static int
>  nvgrace_gpu_map_device_mem(int index,
>  			   struct nvgrace_gpu_pci_core_device *nvdev)
>  {
> +	struct vfio_pci_core_device *vdev = &nvdev->core_device;
>  	struct mem_region *memregion;
>  	int ret = 0;
>  
> +	if (!nvdev->gpu_mem_mapped) {
> +		ret = nvgrace_gpu_wait_device_ready(vdev->barmap[0]);
> +		if (ret)
> +			return ret;
> +
> +		nvdev->gpu_mem_mapped = true;
> +	}

Similar to the code in the fault handler, should have a common wrapper?
Likely need to learn about memory_lock in this path to prevent races as
well.  Thanks,

Alex

> +
>  	memregion = nvgrace_gpu_memregion(index, nvdev);
>  	if (!memregion)
>  		return -EINVAL;


