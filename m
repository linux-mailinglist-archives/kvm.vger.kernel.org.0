Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90FB196865
	for <lists+kvm@lfdr.de>; Sat, 28 Mar 2020 19:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgC1S0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Mar 2020 14:26:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:59931 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgC1S0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Mar 2020 14:26:32 -0400
IronPort-SDR: w12XMlPxsEG7nrkMfX9FNJniJqsyXsZJOl6bsbS+MfVJ5bNb/ceLHyevMBF+qcmcPZ0AD6u3a6
 tQv3FJZM0Vnw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2020 11:26:31 -0700
IronPort-SDR: Uv+OifZnoawvUHECe/GAv9j+IxCZMJerEK49v69mTC5jEVUus3bAfS2KWg101bG1t2EdX8EPvZ
 VAy3ntVPC/bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,317,1580803200"; 
   d="scan'208";a="251464781"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 28 Mar 2020 11:26:31 -0700
Date:   Sat, 28 Mar 2020 11:26:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/3] KVM: x86: introduce kvm_mmu_invalidate_gva
Message-ID: <20200328182631.GQ8104@linux.intel.com>
References: <20200326093516.24215-1-pbonzini@redhat.com>
 <20200326093516.24215-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326093516.24215-2-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 05:35:14AM -0400, Paolo Bonzini wrote:
> Wrap the combination of mmu->invlpg and kvm_x86_ops->tlb_flush_gva
> into a new function.  This function also lets us specify the host PGD to
> invalidate and also the MMU, both of which will be useful in fixing and
> simplifying kvm_inject_emulated_page_fault.
> 
> A nested guest's MMU however has g_context->invlpg == NULL.  Instead of
> setting it to nonpaging_invlpg, make kvm_mmu_invalidate_gva the only
> entry point to mmu->invlpg and make a NULL invlpg pointer equivalent
> to nonpaging_invlpg, saving a retpoline.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +
>  arch/x86/kvm/mmu/mmu.c          | 71 +++++++++++++++++++++------------
>  2 files changed, 47 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 328b1765ff76..f6a1ece1bb4a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1506,6 +1506,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>  int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  		       void *insn, int insn_len);
>  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
> +void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +		            gva_t gva, unsigned long root_hpa);
>  void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
>  void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 560e85ebdf22..e26c9a583e75 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2153,10 +2153,6 @@ static int nonpaging_sync_page(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -static void nonpaging_invlpg(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root)
> -{
> -}
> -
>  static void nonpaging_update_pte(struct kvm_vcpu *vcpu,
>  				 struct kvm_mmu_page *sp, u64 *spte,
>  				 const void *pte)
> @@ -4237,7 +4233,7 @@ static void nonpaging_init_context(struct kvm_vcpu *vcpu,
>  	context->page_fault = nonpaging_page_fault;
>  	context->gva_to_gpa = nonpaging_gva_to_gpa;
>  	context->sync_page = nonpaging_sync_page;
> -	context->invlpg = nonpaging_invlpg;
> +	context->invlpg = NULL;
>  	context->update_pte = nonpaging_update_pte;
>  	context->root_level = 0;
>  	context->shadow_root_level = PT32E_ROOT_LEVEL;
> @@ -4928,7 +4924,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	context->mmu_role.as_u64 = new_role.as_u64;
>  	context->page_fault = kvm_tdp_page_fault;
>  	context->sync_page = nonpaging_sync_page;
> -	context->invlpg = nonpaging_invlpg;
> +	context->invlpg = NULL;
>  	context->update_pte = nonpaging_update_pte;
>  	context->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
>  	context->direct_map = true;
> @@ -5096,6 +5092,12 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
>  	g_context->get_pdptr         = kvm_pdptr_read;
>  	g_context->inject_page_fault = kvm_inject_page_fault;
>  
> +	/*
> +	 * L2 page tables are never shadowed, so there is no need to sync
> +	 * SPTEs.
> +	 */
> +	g_context->invlpg            = NULL;
> +
>  	/*
>  	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
>  	 * L1's nested page tables (e.g. EPT12). The nested translation
> @@ -5497,37 +5499,54 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
>  
> -void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
> +void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> +		            gva_t gva, unsigned long root_hpa)

As pointed out by the build bot, @root_hpa needs to be hpa_t.

>  {
> -	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  	int i;
>  
> -	/* INVLPG on a * non-canonical address is a NOP according to the SDM.  */
> -	if (is_noncanonical_address(gva, vcpu))
> +	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
> +	if (mmu != &vcpu->arch.guest_mmu) {

Doesn't need to be addressed here, but this is not the first time in this
series (the large TLB flushing series) that I've struggled to parse
"guest_mmu".  Would it make sense to rename it something like nested_tdp_mmu
or l2_tdp_mmu?

A bit ugly, but it'd be nice to avoid the mental challenge of remembering
that guest_mmu is in play if and only if nested TDP is enabled.

> +		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
> +		if (is_noncanonical_address(gva, vcpu))
> +			return;
> +
> +		kvm_x86_ops->tlb_flush_gva(vcpu, gva);
> +	}
> +
> +	if (!mmu->invlpg)
>  		return;
>  
> -	mmu->invlpg(vcpu, gva, mmu->root_hpa);
> +	if (root_hpa == INVALID_PAGE) {
> +		mmu->invlpg(vcpu, gva, mmu->root_hpa);
>  
> -	/*
> -	 * INVLPG is required to invalidate any global mappings for the VA,
> -	 * irrespective of PCID. Since it would take us roughly similar amount
> -	 * of work to determine whether any of the prev_root mappings of the VA
> -	 * is marked global, or to just sync it blindly, so we might as well
> -	 * just always sync it.
> -	 *
> -	 * Mappings not reachable via the current cr3 or the prev_roots will be
> -	 * synced when switching to that cr3, so nothing needs to be done here
> -	 * for them.
> -	 */
> -	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> -		if (VALID_PAGE(mmu->prev_roots[i].hpa))
> -			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
> +		/*
> +		 * INVLPG is required to invalidate any global mappings for the VA,
> +		 * irrespective of PCID. Since it would take us roughly similar amount
> +		 * of work to determine whether any of the prev_root mappings of the VA
> +		 * is marked global, or to just sync it blindly, so we might as well
> +		 * just always sync it.
> +		 *
> +		 * Mappings not reachable via the current cr3 or the prev_roots will be
> +		 * synced when switching to that cr3, so nothing needs to be done here
> +		 * for them.
> +		 */
> +		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> +			if (VALID_PAGE(mmu->prev_roots[i].hpa))
> +				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
> +	} else {
> +		mmu->invlpg(vcpu, gva, root_hpa);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_invalidate_gva);
>  
> -	kvm_x86_ops->tlb_flush_gva(vcpu, gva);
> +void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
> +{
> +	kvm_mmu_invalidate_gva(vcpu, vcpu->arch.mmu, gva, INVALID_PAGE);
>  	++vcpu->stat.invlpg;
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
>  
> +
>  void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> -- 
> 2.18.2
> 
> 
