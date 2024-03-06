Return-Path: <kvm+bounces-11116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6405873303
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 10:48:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F1C9B211D9
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 09:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE4A5EE6D;
	Wed,  6 Mar 2024 09:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQnF6Z1I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85C95DF3B;
	Wed,  6 Mar 2024 09:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709718457; cv=none; b=XjoorcbkcKlhT0VygS50VChtUfjBtiNeLxE2Fm8wgKhveJv/bcUVbcLPXTx+mxkdZbmmQwX0lvHVlury3aX3QvOCO9NFHa4Xsd1wiWGl67ojeYGryASDJGAsLrPnwJsemsym5mNpY0IuSRYyccH+5EYFZWUvoppKgXRzkD77ev8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709718457; c=relaxed/simple;
	bh=0Z6Bqj7WGyMcJwm4bMhfmiCLbED3HC5PGJMJVusSN8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APsDC/sZBVTd5fep9/U0HV3EafyL3gcReSGCs8VNQyCjqSOuT6QE4tgdE936mwitV4zL9uY7bnkIP2wzHWVQM87cwJUbciy/JJmejEWw8FOUxndbLRPuNHPqGnpFYGUBbspNxBRbh4NSn9NttWrRj8paioNw8r6N885YKBufg7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EQnF6Z1I; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709718456; x=1741254456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0Z6Bqj7WGyMcJwm4bMhfmiCLbED3HC5PGJMJVusSN8c=;
  b=EQnF6Z1IAOWU9vu8XJ88awbq6tRItauOHwk+SzMdN0heujQlicnrmdYN
   jJ4Wm68cYOZMaQyzX22Tt+ZKnv1gh3d+2z1WP3JW/5iHBC7/tw+qv1dHz
   7+sJvb4TYzcui6aMYrA1uSJW67vZ4BH+IcgJBQUikU3k0PXI4McZVK75B
   ZvmT3LtTLCURhTTcS7kJDjEJuHsI+1BPj9WXU7r/lTk1/KZ3+96xMXy3m
   URZmh5nmykzow+h0r49VLxX51u0falDNZx1D59RUQ0l3rBATjuMlYTeQh
   pJb1TsYfQE9sJdGiG4uIkt4TWBSPRx2opaYJ8wAsCS048Yu26OldhW3/O
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="21843505"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="21843505"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 01:47:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="14360830"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa003.jf.intel.com with ESMTP; 06 Mar 2024 01:47:31 -0800
Date: Wed, 6 Mar 2024 17:43:16 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 05/16] KVM: x86/mmu: Use synthetic page fault error code
 to indicate private faults
Message-ID: <Zeg6tKA0zNQ+dUpn@yilunxu-OptiPlex-7050>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240228024147.41573-6-seanjc@google.com>

On Tue, Feb 27, 2024 at 06:41:36PM -0800, Sean Christopherson wrote:
> Add and use a synthetic, KVM-defined page fault error code to indicate
> whether a fault is to private vs. shared memory.  TDX and SNP have
> different mechanisms for reporting private vs. shared, and KVM's
> software-protected VMs have no mechanism at all.  Usurp an error code
> flag to avoid having to plumb another parameter to kvm_mmu_page_fault()
> and friends.
> 
> Alternatively, KVM could borrow AMD's PFERR_GUEST_ENC_MASK, i.e. set it
> for TDX and software-protected VMs as appropriate, but that would require
> *clearing* the flag for SEV and SEV-ES VMs, which support encrypted
> memory at the hardware layer, but don't utilize private memory at the
> KVM layer.

I see this alternative in other patchset.  And I still don't understand why
synthetic way is better after reading patch #5-7.  I assume for SEV(-ES) if
there is spurious PFERR_GUEST_ENC flag set in error code when private memory
is not used in KVM, then it is a HW issue or SW bug that needs to be caught
and warned, and by the way cleared.

Thanks,
Yilun

> 
> Opportunistically add a comment to call out that the logic for software-
> protected VMs is (and was before this commit) broken for nested MMUs, i.e.
> for nested TDP, as the GPA is an L2 GPA.  Punt on trying to play nice with
> nested MMUs as there is a _lot_ of functionality that simply doesn't work
> for software-protected VMs, e.g. all of the paths where KVM accesses guest
> memory need to be updated to be aware of private vs. shared memory.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 11 +++++++++++
>  arch/x86/kvm/mmu/mmu.c          | 26 +++++++++++++++++++-------
>  arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>  3 files changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1e69743ef0fb..4077c46c61ab 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -267,7 +267,18 @@ enum x86_intercept_stage;
>  #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
>  #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
>  #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
> +
> +/*
> + * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP checks
> + * when emulating instructions that triggers implicit access.
> + */
>  #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
> +/*
> + * PRIVATE_ACCESS is a KVM-defined flag us to indicate that a fault occurred
> + * when the guest was accessing private memory.
> + */
> +#define PFERR_PRIVATE_ACCESS	BIT_ULL(49)
> +#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
>  
>  #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
>  				 PFERR_WRITE_MASK |		\
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 408969ac1291..7807bdcd87e8 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5839,19 +5839,31 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  	bool direct = vcpu->arch.mmu->root_role.direct;
>  
>  	/*
> -	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
> -	 * checks when emulating instructions that triggers implicit access.
>  	 * WARN if hardware generates a fault with an error code that collides
> -	 * with the KVM-defined value.  Clear the flag and continue on, i.e.
> -	 * don't terminate the VM, as KVM can't possibly be relying on a flag
> -	 * that KVM doesn't know about.
> +	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
> +	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
> +	 * flag that KVM doesn't know about.
>  	 */
> -	if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
> -		error_code &= ~PFERR_IMPLICIT_ACCESS;
> +	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
> +		error_code &= ~PFERR_SYNTHETIC_MASK;
>  
>  	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>  		return RET_PF_RETRY;
>  
> +	/*
> +	 * Except for reserved faults (emulated MMIO is shared-only), set the
> +	 * private flag for software-protected VMs based on the gfn's current
> +	 * attributes, which are the source of truth for such VMs.  Note, this
> +	 * wrong for nested MMUs as the GPA is an L2 GPA, but KVM doesn't
> +	 * currently supported nested virtualization (among many other things)
> +	 * for software-protected VMs.
> +	 */
> +	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
> +	    !(error_code & PFERR_RSVD_MASK) &&
> +	    vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
> +	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
> +		error_code |= PFERR_PRIVATE_ACCESS;
> +
>  	r = RET_PF_INVALID;
>  	if (unlikely(error_code & PFERR_RSVD_MASK)) {
>  		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1fab1f2359b5..d7c10d338f14 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -306,7 +306,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
>  		.req_level = PG_LEVEL_4K,
>  		.goal_level = PG_LEVEL_4K,
> -		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
> +		.is_private = err & PFERR_PRIVATE_ACCESS,
>  	};
>  	int r;
>  
> -- 
> 2.44.0.278.ge034bb2e1d-goog
> 
> 

