Return-Path: <kvm+bounces-24128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A1900951A53
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 135F0B21212
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 11:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534021B14F2;
	Wed, 14 Aug 2024 11:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aaNq0VDJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE76913D881;
	Wed, 14 Aug 2024 11:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723635756; cv=none; b=rlrh2h4+l4GlMsZpyJRjooqpwoUlz5Vy5TS1jmjs2MHJrHejKoG1x8WNAHs2zFiG3qylPDEo1BQGdat28FsksJ2opmU52wV7a5yjfgz4OUssj7Z64hctGK2xJGs/3zAaLcLsF2dNfUheIkhXjoqbsBD5IUjNzPAaXjz96HKz5+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723635756; c=relaxed/simple;
	bh=rEp9vRtfXxftwnUubj/FEhL5hPRwoPWmet0a9f9aE4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QeZUtMgvD6j4+LMo0dHkGplHFoCknthbL0AdA3Apph9ldv+k/2b9YPxzsGIqUI24kzgdtxLrI7H1LkpoIvoT+70g6RfSREUsROMJdCTTSsrgatlP3xtAVQKUH4JfxKHwki8NUWTs8PlKq3nQceirPKXyBSYHFTWzWUXWMPh3dew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aaNq0VDJ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723635755; x=1755171755;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rEp9vRtfXxftwnUubj/FEhL5hPRwoPWmet0a9f9aE4U=;
  b=aaNq0VDJVXMBtivmSBt+uX7qG4mLD76to9PLLRluGODu7OKXC2ZZ5xGL
   +5PdcrKf8GPqn3E0kl5i4ohGJtdKoN1zi5xsRhjTte9z8o9we1BQ+q9Lj
   LeAwSz2S2wKx9bQbPvKT7C5h7C5O+S6w4QJDntJ7lCY5EgGcHTsdLGVGj
   nVjMNalXeI1oG8HOtIvWhyFPKf5C9lOsGqRlnh9oFuznwy00Qutz1S7KG
   qSJ0R7uYVXc4u1wEvMorgFwDHfVJ4iCoVzDWOPURw8EMX0epetuWZ1NQW
   sNZC6/1WilrsOaYQdf+Iadih6G1Qx1c43h8b9M9Vc81+nEvJwgag3Obsh
   Q==;
X-CSE-ConnectionGUID: GTAcgG5ZTWOSOJxe2a2TYg==
X-CSE-MsgGUID: nBrelIC9TdCCr/kwuEiV9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="21996301"
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="21996301"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 04:42:34 -0700
X-CSE-ConnectionGUID: tD2oQpTqTIKhxk3SAa/++w==
X-CSE-MsgGUID: iwn/jYccRFKcwXBpbWZSLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,145,1716274800"; 
   d="scan'208";a="59557176"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orviesa007.jf.intel.com with ESMTP; 14 Aug 2024 04:42:31 -0700
Date: Wed, 14 Aug 2024 19:42:30 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerly Tng <ackerleytng@google.com>
Subject: Re: [PATCH 03/22] KVM: x86/mmu: Trigger unprotect logic only on
 write-protection page faults
Message-ID: <20240814114230.hgzrh3cal6k6x2dn@yy-desk-7060>
References: <20240809190319.1710470-1-seanjc@google.com>
 <20240809190319.1710470-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809190319.1710470-4-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Fri, Aug 09, 2024 at 12:03:00PM -0700, Sean Christopherson wrote:
> Trigger KVM's various "unprotect gfn" paths if and only if the page fault
> was a write to a write-protected gfn.  To do so, add a new page fault
> return code, RET_PF_WRITE_PROTECTED, to explicitly and precisely track
> such page faults.
>
> If a page fault requires emulation for any MMIO (or any reason besides
> write-protection), trying to unprotect the gfn is pointless and risks
> putting the vCPU into an infinite loop.  E.g. KVM will put the vCPU into
> an infinite loop if the vCPU manages to trigger MMIO on a page table walk.
>
> Fixes: 147277540bbc ("kvm: svm: Add support for additional SVM NPF error codes")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 78 +++++++++++++++++++--------------
>  arch/x86/kvm/mmu/mmu_internal.h |  3 ++
>  arch/x86/kvm/mmu/mmutrace.h     |  1 +
>  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  6 +--
>  5 files changed, 53 insertions(+), 37 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 901be9e420a4..e3aa04c498ea 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2914,10 +2914,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>  		trace_kvm_mmu_set_spte(level, gfn, sptep);
>  	}
>
> -	if (wrprot) {
> -		if (write_fault)
> -			ret = RET_PF_EMULATE;
> -	}
> +	if (wrprot && write_fault)
> +		ret = RET_PF_WRITE_PROTECTED;
>
>  	if (flush)
>  		kvm_flush_remote_tlbs_gfn(vcpu->kvm, gfn, level);
> @@ -4549,7 +4547,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  		return RET_PF_RETRY;
>
>  	if (page_fault_handle_page_track(vcpu, fault))
> -		return RET_PF_EMULATE;
> +		return RET_PF_WRITE_PROTECTED;
>
>  	r = fast_page_fault(vcpu, fault);
>  	if (r != RET_PF_INVALID)
> @@ -4642,7 +4640,7 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>  	int r;
>
>  	if (page_fault_handle_page_track(vcpu, fault))
> -		return RET_PF_EMULATE;
> +		return RET_PF_WRITE_PROTECTED;
>
>  	r = fast_page_fault(vcpu, fault);
>  	if (r != RET_PF_INVALID)
> @@ -4726,6 +4724,9 @@ static int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
>  	case RET_PF_EMULATE:
>  		return -ENOENT;
>
> +	case RET_PF_WRITE_PROTECTED:
> +		return -EPERM;
> +
>  	case RET_PF_RETRY:
>  	case RET_PF_CONTINUE:
>  	case RET_PF_INVALID:
> @@ -5960,6 +5961,41 @@ void kvm_mmu_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  }
>
> +static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> +				       u64 error_code, int *emulation_type)
> +{
> +	bool direct = vcpu->arch.mmu->root_role.direct;
> +
> +	/*
> +	 * Before emulating the instruction, check if the error code
> +	 * was due to a RO violation while translating the guest page.
> +	 * This can occur when using nested virtualization with nested
> +	 * paging in both guests. If true, we simply unprotect the page
> +	 * and resume the guest.
> +	 */
> +	if (direct &&
> +	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
> +		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
> +		return RET_PF_FIXED;
> +	}
> +
> +	/*
> +	 * The gfn is write-protected, but if emulation fails we can still
> +	 * optimistically try to just unprotect the page and let the processor
> +	 * re-execute the instruction that caused the page fault.  Do not allow
> +	 * retrying MMIO emulation, as it's not only pointless but could also
> +	 * cause us to enter an infinite loop because the processor will keep
> +	 * faulting on the non-existent MMIO address.  Retrying an instruction
> +	 * from a nested guest is also pointless and dangerous as we are only
> +	 * explicitly shadowing L1's page tables, i.e. unprotecting something
> +	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
> +	 */
> +	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))

Looks the mmio_info_in_cache() checking can be removed,
emulation should not come here with RET_PF_WRITE_PROTECTED
introduced, may WARN_ON_ONCE() it.


> +		*emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
> +
> +	return RET_PF_EMULATE;
> +}
> +
>  int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  		       void *insn, int insn_len)
>  {
> @@ -6005,6 +6041,10 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  	if (r < 0)
>  		return r;
>
> +	if (r == RET_PF_WRITE_PROTECTED)
> +		r = kvm_mmu_write_protect_fault(vcpu, cr2_or_gpa, error_code,
> +						&emulation_type);
> +
>  	if (r == RET_PF_FIXED)
>  		vcpu->stat.pf_fixed++;
>  	else if (r == RET_PF_EMULATE)
> @@ -6015,32 +6055,6 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  	if (r != RET_PF_EMULATE)
>  		return 1;
>
> -	/*
> -	 * Before emulating the instruction, check if the error code
> -	 * was due to a RO violation while translating the guest page.
> -	 * This can occur when using nested virtualization with nested
> -	 * paging in both guests. If true, we simply unprotect the page
> -	 * and resume the guest.
> -	 */
> -	if (vcpu->arch.mmu->root_role.direct &&
> -	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
> -		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
> -		return 1;
> -	}
> -
> -	/*
> -	 * vcpu->arch.mmu.page_fault returned RET_PF_EMULATE, but we can still
> -	 * optimistically try to just unprotect the page and let the processor
> -	 * re-execute the instruction that caused the page fault.  Do not allow
> -	 * retrying MMIO emulation, as it's not only pointless but could also
> -	 * cause us to enter an infinite loop because the processor will keep
> -	 * faulting on the non-existent MMIO address.  Retrying an instruction
> -	 * from a nested guest is also pointless and dangerous as we are only
> -	 * explicitly shadowing L1's page tables, i.e. unprotecting something
> -	 * for L1 isn't going to magically fix whatever issue cause L2 to fail.
> -	 */
> -	if (!mmio_info_in_cache(vcpu, cr2_or_gpa, direct) && !is_guest_mode(vcpu))
> -		emulation_type |= EMULTYPE_ALLOW_RETRY_PF;
>  emulate:
>  	return x86_emulate_instruction(vcpu, cr2_or_gpa, emulation_type, insn,
>  				       insn_len);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1721d97743e9..50d2624111f8 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -258,6 +258,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>   * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
>   * RET_PF_RETRY: let CPU fault again on the address.
>   * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
> + * RET_PF_WRITE_PROTECTED: the gfn is write-protected, either unprotected the
> + *                         gfn and retry, or emulate the instruction directly.
>   * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
>   * RET_PF_FIXED: The faulting entry has been fixed.
>   * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
> @@ -274,6 +276,7 @@ enum {
>  	RET_PF_CONTINUE = 0,
>  	RET_PF_RETRY,
>  	RET_PF_EMULATE,
> +	RET_PF_WRITE_PROTECTED,
>  	RET_PF_INVALID,
>  	RET_PF_FIXED,
>  	RET_PF_SPURIOUS,
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index 195d98bc8de8..f35a830ce469 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -57,6 +57,7 @@
>  TRACE_DEFINE_ENUM(RET_PF_CONTINUE);
>  TRACE_DEFINE_ENUM(RET_PF_RETRY);
>  TRACE_DEFINE_ENUM(RET_PF_EMULATE);
> +TRACE_DEFINE_ENUM(RET_PF_WRITE_PROTECTED);
>  TRACE_DEFINE_ENUM(RET_PF_INVALID);
>  TRACE_DEFINE_ENUM(RET_PF_FIXED);
>  TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 69941cebb3a8..a722a3c96af9 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -805,7 +805,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>
>  	if (page_fault_handle_page_track(vcpu, fault)) {
>  		shadow_page_table_clear_flood(vcpu, fault->addr);
> -		return RET_PF_EMULATE;
> +		return RET_PF_WRITE_PROTECTED;
>  	}
>
>  	r = mmu_topup_memory_caches(vcpu, true);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c7dc49ee7388..8bf44ac9372f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1046,10 +1046,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  	 * protected, emulation is needed. If the emulation was skipped,
>  	 * the vCPU would have the same fault again.
>  	 */
> -	if (wrprot) {
> -		if (fault->write)
> -			ret = RET_PF_EMULATE;
> -	}
> +	if (wrprot && fault->write)
> +		ret = RET_PF_WRITE_PROTECTED;
>
>  	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
>  	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
> --
> 2.46.0.76.ge559c4bf1a-goog
>
>

