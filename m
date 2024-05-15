Return-Path: <kvm+bounces-17455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B128C6BCE
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 20:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C56D5284831
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 18:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3687A158DB8;
	Wed, 15 May 2024 18:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NvWoVpgH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069DC158858;
	Wed, 15 May 2024 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715796208; cv=none; b=aFkHdbu48e+Z1UImfqdpY/IEdTrLe1ZRrLVrcT9j+CuvL3DHvdDu+nJ4YM8O5hXQPh42WyGMaa92LNyqp0DfmGT0TU1q0omE5piC3DAE1djDD6AZdlI6epOpSwfTMiJpaddzEGdwpd8tBshaKYX2BPaovXKkR4n/hXD+5Izl0hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715796208; c=relaxed/simple;
	bh=Z7Hdp2hnQbitj1OHNbeyDt8mh9FgzxK3ag8pko+XpZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMxd7zeDvN7g6WG+dTdFo6XqlpKAGVHmm8rE+2t2zYtnbtFCrmFM0xcCtkRZyfcKfNDpDbqtBvb4dqCPyx8HmmtpRXnKomAn00A97H726vgZ8BBNp1+MpSYWeCOYX9xBPnvgU9z09hxGhQN6n70zhXAmKRR8Mv1FvvRtmnZ4qN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NvWoVpgH; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715796206; x=1747332206;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z7Hdp2hnQbitj1OHNbeyDt8mh9FgzxK3ag8pko+XpZo=;
  b=NvWoVpgHrdrEQnga9QtGvK3e6CjwXwRr2UlGyQa/Eh038iSzFNe8EGBp
   iv2XFH2LuW5zBIOUjky9tg/7Kh4ZtO7Yuz5gIYBJmDDlf24S8UJhNBd2p
   xnMkcB96IdQBOhUEAUTLhKOiYAaN6IZQEPxODr/FJveyNX88IDfp0ffuQ
   DO9sJx5ZD9BWDNcEBim4CWm2ppfGuz6sksXtFJWqXfiCkPX7MpzBQ30n6
   0VlDVYFBOXcKl/41CXE9HMiLrfYQevIum4ycd9mRgsJWCiFeAs9dbjaUd
   N003kyX+7o8uTmEXRHtfn7Xc2qdZbfFrwTNWyeyowY2Ttnq79PPSB86zw
   w==;
X-CSE-ConnectionGUID: 7xLPnLgoSfq5KuuC9SS3qw==
X-CSE-MsgGUID: WHnJIgTuQluHH0eKG9VaQQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12030556"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="12030556"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 11:03:26 -0700
X-CSE-ConnectionGUID: OHum9dFHReeK1/arUG9wAQ==
X-CSE-MsgGUID: SRyI60eJTjaSQ31F3Lhz1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31566173"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 11:03:25 -0700
Date: Wed, 15 May 2024 11:03:24 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	erdemaktas@google.com, sagis@google.com, yan.y.zhao@intel.com,
	dmatlack@google.com
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Message-ID: <20240515180324.GF168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240515005952.3410568-3-rick.p.edgecombe@intel.com>

On Tue, May 14, 2024 at 05:59:38PM -0700,
Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:

> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Introduce a per-memslot flag KVM_MEM_ZAP_LEAFS_ONLY to permit zap only leaf
> SPTEs when deleting a memslot.
> 
> Today "zapping only memslot leaf SPTEs" on memslot deletion is not done.
> Instead KVM will invalidate all old TDPs (i.e. EPT for Intel or NPT for
> AMD) and generate fresh new TDPs based on the new memslot layout. This is
> because zapping and re-generating TDPs is low overhead for most use cases,
> and  more importantly, it's due to a bug [1] which caused VM instability
> when a VM is with Nvidia Geforce GPU assigned.
> 
> There's a previous attempt [2] to introduce a per-VM flag to workaround bug
> [1] by only allowing "zapping only memslot leaf SPTEs" for specific VMs.
> However, [2] was not merged due to lacking of a clear explanation of
> exactly what is broken [3] and it's not wise to "have a bug that is known
> to happen when you enable the capability".
> 
> However, for some specific scenarios, e.g. TDX, invalidating and
> re-generating a new page table is not viable for reasons:
> - TDX requires root page of private page table remains unaltered throughout
>   the TD life cycle.
> - TDX mandates that leaf entries in private page table must be zapped prior
>   to non-leaf entries.
> 
> So, Sean re-considered about introducing a per-VM flag or per-memslot flag
> again for VMs like TDX. [4]
> 
> This patch is an implementation of per-memslot flag.
> Compared to per-VM flag approach,
> Pros:
> (1) By allowing userspace to control the zapping behavior in fine-grained
>     granularity, optimizations for specific use cases can be developed
>     without future kernel changes.
> (2) Allows developing new zapping behaviors without risking regressions by
>     changing KVM behavior, as seen previously.
> 
> Cons:
> (1) Users need to ensure all necessary memslots are with flag
>     KVM_MEM_ZAP_LEAFS_ONLY set.e.g. QEMU needs to ensure all GUEST_MEMFD
>     memslot is with ZAP_LEAFS_ONLY flag for TDX VM.
> (2) Opens up the possibility that userspace could configure memslots for
>     normal VM in such a way that the bug [1] is seen.
> 
> However, one thing deserves noting for TDX, is that TDX may potentially
> meet bug [1] for either per-memslot flag or per-VM flag approach, since
> there's a usage in radar to assign an untrusted & passthrough GPU device
> in TDX. If that happens, it can be treated as a bug (not regression) and
> fixed accordingly.
> 
> An alternative approach we can also consider is to always invalidate &
> rebuild all shared page tables and zap only memslot leaf SPTEs for mirrored
> and private page tables on memslot deletion. This approach could exempt TDX
> from bug [1] when "untrusted & passthrough" devices are involved. But
> downside is that this approach requires creating new very specific KVM
> zapping ABI that could limit future changes in the same way that the bug
> did for normal VMs.
> 
> Link: https://patchwork.kernel.org/project/kvm/patch/20190205210137.1377-11-sean.j.christopherson@intel.com [1]
> Link: https://lore.kernel.org/kvm/20200713190649.GE29725@linux.intel.com/T/#mabc0119583dacf621025e9d873c85f4fbaa66d5c [2]
> Link: https://lore.kernel.org/kvm/20200713190649.GE29725@linux.intel.com/T/#m1839c85392a7a022df9e507876bb241c022c4f06 [3]
> Link: https://lore.kernel.org/kvm/ZhSYEVCHqSOpVKMh@google.com [4]
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU Part 1:
>  - New patch
> ---
>  arch/x86/kvm/mmu/mmu.c   | 30 +++++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c       | 17 +++++++++++++++++
>  include/uapi/linux/kvm.h |  1 +
>  virt/kvm/kvm_main.c      |  5 ++++-
>  4 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 61982da8c8b2..4a8e819794db 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6962,10 +6962,38 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  	kvm_mmu_zap_all(kvm);
>  }
>  
> +static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *slot)
> +{
> +	if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
> +		return;
> +
> +	write_lock(&kvm->mmu_lock);
> +
> +	/*
> +	 * Zapping non-leaf SPTEs, a.k.a. not-last SPTEs, isn't required, worst
> +	 * case scenario we'll have unused shadow pages lying around until they
> +	 * are recycled due to age or when the VM is destroyed.
> +	 */
> +	struct kvm_gfn_range range = {
> +		.slot = slot,
> +		.start = slot->base_gfn,
> +		.end = slot->base_gfn + slot->npages,
> +		.may_block = true,
> +	};

nit: move this up at the beginning of this function.
Compiler didn't complain?


> +
> +	if (kvm_tdp_mmu_unmap_gfn_range(kvm, &range, false))
> +		kvm_flush_remote_tlbs(kvm);
> +
> +	write_unlock(&kvm->mmu_lock);
> +}
> +
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  				   struct kvm_memory_slot *slot)
>  {
> -	kvm_mmu_zap_all_fast(kvm);
> +	if (slot->flags & KVM_MEM_ZAP_LEAFS_ONLY)
> +		kvm_mmu_zap_memslot_leafs(kvm, slot);
> +	else
> +		kvm_mmu_zap_all_fast(kvm);
>  }
>  
>  void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7c593a081eba..4b3ec2ec79e9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12952,6 +12952,23 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
>  			return -EINVAL;
>  
> +		/*
> +		 * Since TDX private pages requires re-accepting after zap,
> +		 * and TDX private root page should not be zapped, TDX requires
> +		 * memslots for private memory must have flag
> +		 * KVM_MEM_ZAP_LEAFS_ONLY set too, so that only leaf SPTEs of
> +		 * the deleting memslot will be zapped and SPTEs in other
> +		 * memslots would not be affected.
> +		 */
> +		if (kvm->arch.vm_type == KVM_X86_TDX_VM &&
> +		    (new->flags & KVM_MEM_GUEST_MEMFD) &&
> +		    !(new->flags & KVM_MEM_ZAP_LEAFS_ONLY))
> +			return -EINVAL;
> +
> +		/* zap-leafs-only works only when TDP MMU is enabled for now */
> +		if ((new->flags & KVM_MEM_ZAP_LEAFS_ONLY) && !tdp_mmu_enabled)
> +			return -EINVAL;
> +
>  		return kvm_alloc_memslot_metadata(kvm, new);
>  	}
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index aee67912e71c..d53648c19b26 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -51,6 +51,7 @@ struct kvm_userspace_memory_region2 {
>  #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
>  #define KVM_MEM_READONLY	(1UL << 1)
>  #define KVM_MEM_GUEST_MEMFD	(1UL << 2)
> +#define KVM_MEM_ZAP_LEAFS_ONLY	(1UL << 3)

If we make this uAPI, please update Documentation/virt/kvm/api.rst too.


>  
>  /* for KVM_IRQ_LINE */
>  struct kvm_irq_level {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 81b90bf03f2f..1b1ffb6fc786 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1568,6 +1568,8 @@ static int check_memory_region_flags(struct kvm *kvm,
>  	if (kvm_arch_has_private_mem(kvm))
>  		valid_flags |= KVM_MEM_GUEST_MEMFD;
>  
> +	valid_flags |= KVM_MEM_ZAP_LEAFS_ONLY;
> +

This is arch common code. We need a guard for other arch (non-x86).
Also feature enumeration. KVM_CAP_USER_MEMORY2 can be used?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

