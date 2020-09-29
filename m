Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F2A27BC21
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 06:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgI2EhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 00:37:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:15848 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI2EhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 00:37:02 -0400
IronPort-SDR: dA1+yhwbHXuXIeqdOaFgphb4EkYTg0EYj5wiyYRsS1Tx7PKgrZ+CEK7nFC+9Pu87JL+VnUE6OF
 5LPVdPBzQEyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="162992925"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="162992925"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:37:01 -0700
IronPort-SDR: bFOU+w1skkKw693c7UpsfEAuqWoNmI2EqJEX5IgGMJwdGCvfTt/P8oRHaiOzdpHKkLI4PLQmEL
 WpkuJFKlkj5Q==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="457110458"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 21:37:01 -0700
Date:   Mon, 28 Sep 2020 21:37:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20200929043700.GL31514@linux.intel.com>
References: <20200720211359.GF502563@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720211359.GF502563@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 20, 2020 at 05:13:59PM -0400, Vivek Goyal wrote:
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/x86.c              | 54 +++++++++++++++++++++++++++++++--
>  include/linux/kvm_types.h       |  1 +
>  5 files changed, 56 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b21540..e6f8d3f1a377 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -137,6 +137,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
>  #define KVM_NR_VAR_MTRR 8
>  
>  #define ASYNC_PF_PER_VCPU 64
> +#define ERROR_GFN_PER_VCPU 64

Aren't these two related?  I.e. wouldn't it make sense to do:

  #define ERROR_GFN_PER_VCPU ASYNC_PF_PER_VCPU

Or maybe even size error_gfns[] to ASYNC_PF_PER_VCPU?

>  
>  enum kvm_reg {
>  	VCPU_REGS_RAX = __VCPU_REGS_RAX,
> @@ -778,6 +779,7 @@ struct kvm_vcpu_arch {
>  		unsigned long nested_apf_token;
>  		bool delivery_as_pf_vmexit;
>  		bool pageready_pending;
> +		gfn_t error_gfns[ERROR_GFN_PER_VCPU];
>  	} apf;
>  
>  	/* OSVW MSRs (AMD only) */
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 444bb9c54548..d0a2a12c7bb6 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -60,7 +60,7 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
>  void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer);
>  void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>  			     bool accessed_dirty, gpa_t new_eptp);
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn);
>  int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>  				u64 fault_address, char *insn, int insn_len);
>  

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..c1f5094d6e53 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -263,6 +263,13 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
>  		vcpu->arch.apf.gfns[i] = ~0;
>  }
>  
> +static inline void kvm_error_gfn_hash_reset(struct kvm_vcpu *vcpu)
> +{
> +	int i;

Need a newline.   

> +	for (i = 0; i < ERROR_GFN_PER_VCPU; i++)
> +		vcpu->arch.apf.error_gfns[i] = GFN_INVALID;
> +}
> +
>  static void kvm_on_user_return(struct user_return_notifier *urn)
>  {
>  	unsigned slot;
> @@ -9484,6 +9491,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.pat = MSR_IA32_CR_PAT_DEFAULT;
>  
>  	kvm_async_pf_hash_reset(vcpu);
> +	kvm_error_gfn_hash_reset(vcpu);
>  	kvm_pmu_init(vcpu);
>  
>  	vcpu->arch.pending_external_vector = -1;
> @@ -9608,6 +9616,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	kvm_clear_async_pf_completion_queue(vcpu);
>  	kvm_async_pf_hash_reset(vcpu);
> +	kvm_error_gfn_hash_reset(vcpu);
>  	vcpu->arch.apf.halted = false;
>  
>  	if (kvm_mpx_supported()) {
> @@ -10369,6 +10378,36 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_rflags);
>  
> +static inline u32 kvm_error_gfn_hash_fn(gfn_t gfn)
> +{
> +	BUILD_BUG_ON(!is_power_of_2(ERROR_GFN_PER_VCPU));
> +
> +	return hash_32(gfn & 0xffffffff, order_base_2(ERROR_GFN_PER_VCPU));
> +}
> +
> +static void kvm_add_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_error_gfn_hash_fn(gfn);
> +
> +	/*
> +	 * Overwrite the previous gfn. This is just a hint to do
> +	 * sync page fault.
> +	 */
> +	vcpu->arch.apf.error_gfns[key] = gfn;
> +}
> +
> +/* Returns true if gfn was found in hash table, false otherwise */
> +static bool kvm_find_and_remove_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_error_gfn_hash_fn(gfn);

Mostly out of curiosity, do we really need a hash?  E.g. could we get away
with an array of 4 values?  2 values?  Just wondering if we can avoid 64*8
bytes per CPU.

One thought would be to use the index to handle the case of no error gfns so
that the size of the array doesn't affect lookup for the common case, e.g.

	...

		u8 error_gfn_head;
		gfn_t error_gfns[ERROR_GFN_PER_VCPU];
	} apf;	


	if (vcpu->arch.apf.error_gfn_head == 0xff)
		return false;

	for (i = 0; i < vcpu->arch.apf.error_gfn_head; i++) {
		if (vcpu->arch.apf.error_gfns[i] == gfn) {
			vcpu->arch.apf.error_gfns[i] = INVALID_GFN;
			return true;
		}
	}
	return true;

Or you could even avoid INVALID_GFN altogether by compacting the array on
removal.  The VM is probably dead anyways, burning a few cycles to clean
things up is a non-issue.  Ditto for slow insertion.

> +
> +	if (vcpu->arch.apf.error_gfns[key] != gfn)
> +		return 0;

Should be "return false".

> +
> +	vcpu->arch.apf.error_gfns[key] = GFN_INVALID;
> +	return true;
> +}
> +
>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
>  	int r;
> @@ -10385,7 +10424,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
>  		return;
>  
> -	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
> +	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
> +	if (r < 0)
> +		kvm_add_error_gfn(vcpu, gpa_to_gfn(work->cr2_or_gpa));
>  }
>  
>  static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
> @@ -10495,7 +10536,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
>  	if (unlikely(!lapic_in_kernel(vcpu) ||
>  		     kvm_event_needs_reinjection(vcpu) ||
> @@ -10509,7 +10550,14 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  	 * If interrupts are off we cannot even use an artificial
>  	 * halt state.
>  	 */
> -	return kvm_arch_interrupt_allowed(vcpu);
> +	if (!kvm_arch_interrupt_allowed(vcpu))
> +		return false;
> +
> +	/* Found gfn in error gfn cache. Force sync fault */
> +	if (kvm_find_and_remove_error_gfn(vcpu, gfn))
> +		return false;
> +
> +	return true;
>  }
>  
>  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 68e84cf42a3f..677bb8269cd3 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -36,6 +36,7 @@ typedef u64            gpa_t;
>  typedef u64            gfn_t;
>  
>  #define GPA_INVALID	(~(gpa_t)0)
> +#define GFN_INVALID	(~(gfn_t)0)
>  
>  typedef unsigned long  hva_t;
>  typedef u64            hpa_t;
> -- 
> 2.25.4
> 
