Return-Path: <kvm+bounces-52555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87A9BB06A0D
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 01:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92A794A3294
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 23:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83C02D661D;
	Tue, 15 Jul 2025 23:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="na5YKnSf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF04425B31B;
	Tue, 15 Jul 2025 23:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752623260; cv=none; b=uPYHg4szx5aotXopaG5iIIcodKWKz+RMNY3MvyE+hP5J1dwBdD6HiKZBb3tnIo8VLPmQaB+spI78BZhL5qeqNi3YzZRtI2Ec0+gxi3qXumHLWptY1lDdLSci4ryK5UoD3LMTJ+8VCv9sX1SJWjsJ1gDjIeoi6qT2eJZDKcPh5QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752623260; c=relaxed/simple;
	bh=D3c6sfdeoqU0+rpixMaPXjWlnYZEYRf6Fje/K+TEVYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckNghBTMxpo9yxwXoNhflovyLMzbL7cMk3i1kBseENdzHW6j4LwlHkrQXdOXYzWG8w8FigCld14deKOkTfKkPvt4G5B2tzytk2DWnPLpDNsE4B6aMC+TL57sRjdjVwveHI4sQ2w+0srHLlxncyD7J0U6IZ23xpR8joN0TP+tkIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=na5YKnSf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB2FC4CEE3;
	Tue, 15 Jul 2025 23:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752623256;
	bh=D3c6sfdeoqU0+rpixMaPXjWlnYZEYRf6Fje/K+TEVYk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=na5YKnSffEt9VavXq/l8lZWfSazjB4rpYX/YnWyZPMJ/jlvIVI8z3wGV1ZbAUhB1i
	 8C7UFx8Qo4WTZrmqcWE7d1ZHUgXgjCCTRwP9OfC8IgTp7nYafVSDDqALiEDKFvvRvP
	 ps223zl6DOta6+Hq/AUYdUyk/+Y/Fz1HcpZYCBNbY8fE+9arK0nIXUF6E3hJmFUT2i
	 goPaXvzctB100fcLRfF6X9MdrQ7POeCCBlrT6U3XUfXSaPRzPSB1zYndpDUL51Znsg
	 17SCUk5jt5AvUKcTOgIhp+RZrT8c3xzKErM7wo0ceXg/WadxHc0pI48MjEo4+Ed8BJ
	 sFfIcz4DA5hXA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id CBA16CE0811; Tue, 15 Jul 2025 16:47:35 -0700 (PDT)
Date: Tue, 15 Jul 2025 16:47:35 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2] vfio/type1: conditional rescheduling while pinning
Message-ID: <d00cc343-b900-47d5-ba30-1ecc5d11393f@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250715184622.3561598-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715184622.3561598-1-kbusch@meta.com>

On Tue, Jul 15, 2025 at 11:46:22AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> A large DMA mapping request can loop through dma address pinning for
> many pages. In cases where THP can not be used, the repeated vmf_insert_pfn can
> be costly, so let the task reschedule as need to prevent CPU stalls. Failure to
> do so has potential harmful side effects, like increased memory pressure
> as unrelated rcu tasks are unable to make their reclaim callbacks and
> result in OOM conditions.
> 
>  rcu: INFO: rcu_sched self-detected stall on CPU
>  rcu:   36-....: (20999 ticks this GP) idle=b01c/1/0x4000000000000000 softirq=35839/35839 fqs=3538
>  rcu:            hardirqs   softirqs   csw/system
>  rcu:    number:        0        107            0
>  rcu:   cputime:       50          0        10446   ==> 10556(ms)
>  rcu:   (t=21075 jiffies g=377761 q=204059 ncpus=384)
> ...
>   <TASK>
>   ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>   ? walk_system_ram_range+0x63/0x120
>   ? walk_system_ram_range+0x46/0x120
>   ? pgprot_writethrough+0x20/0x20
>   lookup_memtype+0x67/0xf0
>   track_pfn_insert+0x20/0x40
>   vmf_insert_pfn_prot+0x88/0x140
>   vfio_pci_mmap_huge_fault+0xf9/0x1b0 [vfio_pci_core]
>   __do_fault+0x28/0x1b0
>   handle_mm_fault+0xef1/0x2560
>   fixup_user_fault+0xf5/0x270
>   vaddr_get_pfns+0x169/0x2f0 [vfio_iommu_type1]
>   vfio_pin_pages_remote+0x162/0x8e0 [vfio_iommu_type1]
>   vfio_iommu_type1_ioctl+0x1121/0x1810 [vfio_iommu_type1]
>   ? futex_wake+0x1c1/0x260
>   x64_sys_call+0x234/0x17a0
>   do_syscall_64+0x63/0x130
>   ? exc_page_fault+0x63/0x130
>   entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>

From an RCU CPU stall-warning viewpoint, given that vaddr_get_pfns()
invokes mmap_read_lock(), thus this code can schedule:

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
> v1->v2:
> 
>   Merged up to vfio/next
> 
>   Moved the cond_resched() to a more appropriate place within the
>   loop, and added a comment about why it's there.
> 
>   Update to change log describing one of the consequences of not doing
>   this.
> 
>  drivers/vfio/vfio_iommu_type1.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 1136d7ac6b597..ad599b1601711 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -647,6 +647,13 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  
>  	while (npage) {
>  		if (!batch->size) {
> +			/*
> +			 * Large mappings may take a while to repeatedly refill
> +			 * the batch, so conditionally relinquish the CPU when
> +			 * needed to avoid stalls.
> +			 */
> +			cond_resched();
> +
>  			/* Empty batch, so refill it. */
>  			ret = vaddr_get_pfns(mm, vaddr, npage, dma->prot,
>  					     &pfn, batch);
> -- 
> 2.47.1
> 

