Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5920522390F
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 12:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgGQKOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 06:14:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725864AbgGQKOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 06:14:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594980845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NWRZh8GIm6J9mvw0vutm7qlz6pJaBy9pU2O6hSL6rVI=;
        b=ghhe8MJb1/kN09zlX3vgqOZ3g5LJXCglClMkrK9ibL58OdW9P3UAF1JotQ6zq5XLAHRcLx
        9qaZFoWqAoEmUG2OozlegT5rAAziNuA39deWjvzV4q42RNBU3aPjMJd+U4FU4tDInrpt2Z
        ESGU0nWzME6sK5VJK0oaSWE2cGEmHvg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-hz8CbKH4OXKENr6Wd9FH2w-1; Fri, 17 Jul 2020 06:14:04 -0400
X-MC-Unique: hz8CbKH4OXKENr6Wd9FH2w-1
Received: by mail-ej1-f70.google.com with SMTP id q9so5384225ejr.21
        for <kvm@vger.kernel.org>; Fri, 17 Jul 2020 03:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=NWRZh8GIm6J9mvw0vutm7qlz6pJaBy9pU2O6hSL6rVI=;
        b=hrCozav8znYLyNiKeI8+XItpxl0sNUQ2Qk2AaciCgmYtDXEddsA6+aTI9uTp2Pn2G5
         2E0hmXNiIriLW6ZP7zeHdO+8hsVCrjmEGKM1FrWQxA63Cm4ukRRAz7ZRcPLOwBEWo3Ja
         PLZ0G0pvvVHHBvksVXEIRPkxyMeI9fhpo+zgxd15ThJgZSDRPKWhFR653T96XGEyjqgX
         LeutIuj+N6cKz+bhz3rMY9rVhhpQTg02NbO2YlP2qfyi+xfXDbdcQMD5UGZHdq8LboQk
         XskaUnsTpl3ct1ixQRK6SSCcoyg4WWM0epNBQc5gnKyFh1cJkqgeOr9RyhTAq5zo90Um
         5mSw==
X-Gm-Message-State: AOAM531V9Q6AY+6AXql7u3Z8G8gfe82xY/yvKdYjgXXod6KsDVIs7g60
        WBv+GdCoYnP6G7ODabbDxo9Ub+70O3ue7o/wxkNYAlp52BCJXaadkU2o+vKTbffyGzQ6MBIREGF
        3FRFxB8R+nii5
X-Received: by 2002:a17:906:5006:: with SMTP id s6mr7733469ejj.294.1594980842598;
        Fri, 17 Jul 2020 03:14:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCGSI48lFSHs7e1tObgRN/jXbDB6AQgdxDvMq4y3mipolAy3uTCh1f/jXGlM9Q1kmgSe9JHQ==
X-Received: by 2002:a17:906:5006:: with SMTP id s6mr7733454ejj.294.1594980842285;
        Fri, 17 Jul 2020 03:14:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j19sm7927967edt.44.2020.07.17.03.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:14:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kvm,x86: Exit to user space in case of page fault error
In-Reply-To: <20200709125442.GA150543@redhat.com>
References: <20200709125442.GA150543@redhat.com>
Date:   Fri, 17 Jul 2020 12:14:00 +0200
Message-ID: <87365qsb2v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Page fault error handling behavior in kvm seems little inconsistent when
> page fault reports error. If we are doing fault synchronously
> then we capture error (-EFAULT) returned by __gfn_to_pfn_memslot() and
> exit to user space and qemu reports error, "error: kvm run failed Bad address".
>
> But if we are doing async page fault, then async_pf_execute() will simply
> ignore the error reported by get_user_pages_remote() or
> by kvm_mmu_do_page_fault(). It is assumed that page fault was successful
> and either a page ready event is injected in guest or guest is brought
> out of artificial halt state and run again. In both the cases when guest
> retries the instruction, it takes exit again as page fault was not
> successful in previous attempt. And then this infinite loop continues
> forever.
>
> Trying fault in a loop will make sense if error is temporary and will
> be resolved on retry. But I don't see any intention in the code to
> determine if error is temporary or not.  Whether to do fault synchronously
> or asynchronously, depends on so many variables but none of the varibales
> is whether error is temporary or not. (kvm_can_do_async_pf()).
>
> And that makes it very inconsistent or unpredictable to figure out whether
> kvm will exit to qemu with error or it will just retry and go into an
> infinite loop.
>
> This patch tries to make this behavior consistent. That is instead of
> getting into infinite loop of retrying page fault, exit to user space
> and stop VM if page fault error happens.
>
> In future this can be improved by injecting errors into guest. As of
> now we don't have any race free method to inject errors in guest.
>
> When page fault error happens in async path save that pfn and when next
> time guest retries, do a sync fault instead of async fault. So that if error
> is encountered, we exit to qemu and avoid infinite loop.
>
> We maintain a cache of error gfns and force sync fault if a gfn is
> found in cache of error gfn. There is a small possibility that we
> miss an error gfn (as it got overwritten by a new error gfn). But
> its just a hint and sooner or later some error pfn will match
> and we will force sync fault and exit to user space.
>
> Change from v2:
> - Fixed a warning by converting kvm_find_error_gfn() static.
>
> Change from v1:
> - Maintain a cache of error gfns, instead of single gfn. (Vitaly)
>

Sorry for the delayed reply, please find some nitpicks below.

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/x86.c              | 61 +++++++++++++++++++++++++++++++--
>  4 files changed, 62 insertions(+), 5 deletions(-)
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
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6d6a0ae7800c..a0e6283e872d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  	if (!async)
>  		return false; /* *pfn has correct page already */
>  
> -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
> +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {

gpa_to_gfn() ?

>  		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
>  		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
>  			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..c4d4dab3ccde 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -263,6 +263,13 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
>  		vcpu->arch.apf.gfns[i] = ~0;
>  }
>  
> +static inline void kvm_error_gfn_hash_reset(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	for (i = 0; i < ERROR_GFN_PER_VCPU; i++)
> +		vcpu->arch.apf.error_gfns[i] = ~0;

Nit: I see this is already present in kvm_async_pf_hash_reset() but what
about defining 

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index a7580f69dda0..9144fde2550e 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -38,6 +38,7 @@ typedef u64            gpa_t;
 typedef u64            gfn_t;
 
 #define GPA_INVALID    (~(gpa_t)0)
+#define GFN_INVALID    (~(gfn_t)0)
 
 typedef unsigned long  hva_t;
 typedef u64            hpa_t;

and using it instead?

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
> @@ -10369,6 +10378,41 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
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
> +static void kvm_del_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_error_gfn_hash_fn(gfn);
> +
> +	if (WARN_ON_ONCE(vcpu->arch.apf.error_gfns[key] != gfn))
> +		return;
> +
> +	vcpu->arch.apf.error_gfns[key] = ~0;
> +}
> +
> +static bool kvm_find_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> +{
> +	u32 key = kvm_error_gfn_hash_fn(gfn);
> +
> +	return vcpu->arch.apf.error_gfns[key] == gfn;
> +}

These two functions kvm_del_error_gfn()/kvm_find_error_gfn() come in
pair and the only usage seems to be

 if (kvm_find_error_gfn())
    kvm_del_error_gfn();

what if we replace it with a single kvm_find_and_remove_error_gfn() and
drop the WARN_ON_ONCE()?

> +
>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  {
>  	int r;
> @@ -10385,7 +10429,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
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
> @@ -10495,7 +10541,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
>  	if (unlikely(!lapic_in_kernel(vcpu) ||
>  		     kvm_event_needs_reinjection(vcpu) ||
> @@ -10509,7 +10555,16 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  	 * If interrupts are off we cannot even use an artificial
>  	 * halt state.
>  	 */
> -	return kvm_arch_interrupt_allowed(vcpu);
> +	if (!kvm_arch_interrupt_allowed(vcpu))
> +		return false;
> +
> +	/* Found gfn in error gfn cache. Force sync fault */
> +	if (kvm_find_error_gfn(vcpu, gfn)) {
> +		kvm_del_error_gfn(vcpu, gfn);
> +		return false;
> +	}
> +
> +	return true;
>  }
>  
>  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,

-- 
Vitaly

