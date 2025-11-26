Return-Path: <kvm+bounces-64671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A6703C8A9D2
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 57878346A1C
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 15:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9852F3328F1;
	Wed, 26 Nov 2025 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="HgjYwMVK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Uw49BKVG"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759173314D7;
	Wed, 26 Nov 2025 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170652; cv=none; b=X3Hx1hGvUSj8Mk7hIMkEBs9DaNtWRP0Fsk2cyPByO25k5dZ02qqbRR6FrzN+x0yRHMD83RvxuoZGWKuzKNNVisagsEJQt7pOR0loKy7s2/m+cqklflP70r45m5pJV5gLf4anE7VmydAHOTDQVQq+dYRyUBhUu8uWdazjGJIQ6Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170652; c=relaxed/simple;
	bh=bH+mN2jF+c1CE2DaJxHCFtuJHGZT7Zn58BcxjyYzKyI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NaH++J+Fy/UuuY6Zx+5328zBxyTMFDKhC3MU56HdS37p3mCRZAFbkFTZMO+VR3oycq0OeG7THSygyVQayGviRknvhVIloU9/EjdCFgC50AOjDgeoMmUFI3bFqLraJmovPv8Q11Cvd+vmeRxWOScoDCwxARbNx3fte2rqzJzqkSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=HgjYwMVK; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Uw49BKVG; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id CCE9CEC01E5;
	Wed, 26 Nov 2025 10:24:07 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 26 Nov 2025 10:24:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764170647;
	 x=1764257047; bh=WjzwmMl0HnlConkqj57nsAiRBwJ6K1Ae57RryCMSpCI=; b=
	HgjYwMVKCG1K+SlZ9vM5U2oMCsQz7r16W3yaBgV2TFemnhFaY84hX7aq3BITaiwy
	/DcK00+e4Txg0kO9PXK7znF4E/PFv0XoHediTQsNTv3kGexcB/6cz/3qqXafbMw3
	mr9IYbLSM+B4Sf5JgbO+0ioFQsRKeOPTVphXnQaGmr9N8iqE2RaXhMk8OcniGlsJ
	Jncdg86AeR3bR3CIj5NRTGFSNlr/FeXn2u4KGzKYBM8GQnJf+Kn6zhX0cahk5keX
	MWRT1GY6UZTlwbUvCgA1u6TnURaU9iMZ+z/i8qDGkiKL6Zj7I0omAYeopfB8VIIW
	RRJ23ILm0G1jYzuWYqWnAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764170647; x=
	1764257047; bh=WjzwmMl0HnlConkqj57nsAiRBwJ6K1Ae57RryCMSpCI=; b=U
	w49BKVGgl6zBBLSjCbay+BB9n5+PCosgj3FCJK5ozW1lmS0ckOjxnzm7XnMDZN4k
	VdIO6oJIY+Rtw0OvReIobbrlaz33KMq/kNHrIC0Y5eDLOEiw2ePXOD4Lxjdlyjto
	Suc2aTXfJrLlyum1KYdZEc3LStxXTjAQeuCfmGkhYWXQHPFOsxL3aPghZEMB8wWY
	6vC1eRsjrSQYW+ctW7P3TbZEcoj8N9TFyq/MW+82UbkjcTqLzQBlB4Kbdp+F6kbg
	ckCjORCbzYR/MMA5HCQPKy0iN8FpDGRqCV1qOaG592M4qO09Y/jMRrphI3bmCiwk
	N2/Y0BVGq99/sJELeRcpw==
X-ME-Sender: <xms:lxsnaSLSlPCn5Q1BCNDJ__pB6JI0gh9zYBJyAuaXwTpnVVSsI4wOhg>
    <xme:lxsnaVIVXMkA_YQJDWrp8LZqOjc52NaeXvg1zMX-rY4HyQVMbeGbVPNM881m3-COW
    U6oKonH_3WYy0YydLICkTONhEcp5eUxPoo7ORRRVrmhHadx9D9o8w>
X-ME-Received: <xmr:lxsnaZUSvQmohfykBWXQCteyiqhildqJu0Ubvu3AavfDfnTRo1tqzTzo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeegieelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:lxsnaVDZ11oFZgflaEscXF8ldyQKU6KfR0EaYXlpu9Lh_zbqQMvm2w>
    <xmx:lxsnaUGN1qDt83ToCrrXyi2dQC2ADonGMQMx2V0yJW_cy4fXqhLXkQ>
    <xmx:lxsnaZe50CxvhwPH6fqmTD4LSjfc69mhTa9KrQaRp59Cqxp1-Z9c0Q>
    <xmx:lxsnaZ_7Gs306XzaE_je_RXYtB_xG6lt3UbylZ3ScmjD61SPPg6nzA>
    <xmx:lxsnad0UteBI063aOMsdS7BadwQFQ3kYpDPV3uOnLjDsQGu8iXa49cQC>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 10:24:05 -0500 (EST)
Date: Wed, 26 Nov 2025 08:23:15 -0700
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
Subject: Re: [PATCH v7 6/6] vfio/nvgrace-gpu: wait for the GPU mem to be
 ready
Message-ID: <20251126082315.222b1e94.alex@shazbot.org>
In-Reply-To: <20251126052627.43335-7-ankita@nvidia.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
	<20251126052627.43335-7-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Nov 2025 05:26:27 +0000
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
> request or read/write access which amortizes the GPU readiness
> time.
> 
> The first fault and read/write checks the GPU state when the
> reset_done flag - which denotes whether the GPU has just been
> reset. The memory_lock is taken across map/access to avoid
> races with GPU reset.
> 
> Cc: Shameer Kolothum <skolothumtho@nvidia.com>
> Cc: Alex Williamson <alex@shazbot.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Vikram Sethi <vsethi@nvidia.com>
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 81 +++++++++++++++++++++++++----
>  1 file changed, 72 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index b46984e76be7..3064f8aca858 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -104,6 +104,17 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  		mutex_init(&nvdev->remap_lock);
>  	}
>  
> +	/*
> +	 * GPU readiness is checked by reading the BAR0 registers.
> +	 *
> +	 * ioremap BAR0 to ensure that the BAR0 mapping is present before
> +	 * register reads on first fault before establishing any GPU
> +	 * memory mapping.
> +	 */
> +	ret = vfio_pci_core_setup_barmap(vdev, 0);
> +	if (ret)
> +		return ret;
> +
>  	vfio_pci_core_finish_enable(vdev);
>  
>  	return 0;
> @@ -146,6 +157,31 @@ static int nvgrace_gpu_wait_device_ready(void __iomem *io)
>  	return -ETIME;
>  }
>  
> +/*
> + * If the GPU memory is accessed by the CPU while the GPU is not ready
> + * after reset, it can cause harmless corrected RAS events to be logged.
> + * Make sure the GPU is ready before establishing the mappings.
> + */
> +static int
> +nvgrace_gpu_check_device_ready(struct nvgrace_gpu_pci_core_device *nvdev)
> +{
> +	struct vfio_pci_core_device *vdev = &nvdev->core_device;
> +	int ret;
> +
> +	lockdep_assert_held_read(&vdev->memory_lock);
> +
> +	if (!nvdev->reset_done)
> +		return 0;
> +
> +	ret = nvgrace_gpu_wait_device_ready(vdev->barmap[0]);
> +	if (ret)
> +		return ret;
> +
> +	nvdev->reset_done = false;
> +
> +	return 0;
> +}
> +
>  static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
>  				   unsigned long addr)
>  {
> @@ -163,13 +199,13 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
>  	struct vfio_pci_core_device *vdev = &nvdev->core_device;
>  	unsigned int index =
>  		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> -	vm_fault_t ret = VM_FAULT_SIGBUS;
> +	vm_fault_t ret;
>  	struct mem_region *memregion;
>  	unsigned long pfn, addr;
>  
>  	memregion = nvgrace_gpu_memregion(index, nvdev);
>  	if (!memregion)
> -		return ret;
> +		return VM_FAULT_SIGBUS;
>  
>  	addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
>  	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma, addr);
> @@ -179,8 +215,14 @@ static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
>  		goto out;
>  	}
>  
> -	scoped_guard(rwsem_read, &vdev->memory_lock)
> +	scoped_guard(rwsem_read, &vdev->memory_lock) {
> +		if (nvgrace_gpu_check_device_ready(nvdev)) {
> +			ret = VM_FAULT_SIGBUS;
> +			goto out;
> +		}
> +
>  		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
> +	}
>  
>  out:
>  	dev_dbg_ratelimited(&vdev->pdev->dev,
> @@ -593,9 +635,15 @@ nvgrace_gpu_read_mem(struct nvgrace_gpu_pci_core_device *nvdev,
>  	else
>  		mem_count = min(count, memregion->memlength - (size_t)offset);
>  
> -	ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
> -	if (ret)
> -		return ret;
> +	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
> +		ret = nvgrace_gpu_check_device_ready(nvdev);
> +		if (ret)
> +			return ret;
> +
> +		ret = nvgrace_gpu_map_and_read(nvdev, buf, mem_count, ppos);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	/*
>  	 * Only the device memory present on the hardware is mapped, which may
> @@ -713,9 +761,15 @@ nvgrace_gpu_write_mem(struct nvgrace_gpu_pci_core_device *nvdev,
>  	 */
>  	mem_count = min(count, memregion->memlength - (size_t)offset);
>  
> -	ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
> -	if (ret)
> -		return ret;
> +	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock) {
> +		ret = nvgrace_gpu_check_device_ready(nvdev);
> +		if (ret)
> +			return ret;
> +
> +		ret = nvgrace_gpu_map_and_write(nvdev, buf, mem_count, ppos);
> +		if (ret)
> +			return ret;
> +	}
>  
>  exitfn:
>  	*ppos += count;
> @@ -1056,6 +1110,15 @@ MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
>   *
>   * The reset_done implementation is triggered on every reset and is used
>   * set the reset_done variable that assists in achieving the serialization.
> + *
> + * The writer memory_lock is held during reset through ioctl and FLR, while
> + * the reader is held in the fault and access code.
> + *
> + * The lock is however not taken during reset called through
> + * vfio_pci_core_enable during open. Whilst a serialization is not
> + * required at that early stage, it still prevents from putting
> + * lockdep_assert_held_write in this function.
> + *

I think the key point is that the readiness test is done holding the
memory_lock read lock and we expect all vfio-pci initiated resets to
hold the memory_lock write lock to avoid races.  However, .reset_done
extends beyond the scope of vfio-pci initiated resets therefore we
cannot assert this behavior.  Thanks,

Alex

