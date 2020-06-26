Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D7820AEE5
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 11:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgFZJZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 05:25:28 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24723 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725971AbgFZJZ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 05:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593163525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OQ+iqFTdF52CzCAmRMYkGBuT2f7oz2wK2HsAlevEW0E=;
        b=VSGpLa8JMQascB4pHOm+qGBgbGKgmf8MhBkcHR1y/dfuDYXZX0ynTUky5zRuVq6smWLwqh
        9ZEzR2gUh4siiAyq/Z63EUBNU7gwI4ib/pFsbLLTZShEBKk9Zw154GqBasef8UvPwFS4zn
        97zB1/BbZ5g4XHzkqzi0XO+PX7meuGs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-3M3Iy72FNM2E5qWdXIrC5g-1; Fri, 26 Jun 2020 05:25:23 -0400
X-MC-Unique: 3M3Iy72FNM2E5qWdXIrC5g-1
Received: by mail-wm1-f69.google.com with SMTP id h6so10182399wmb.7
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 02:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OQ+iqFTdF52CzCAmRMYkGBuT2f7oz2wK2HsAlevEW0E=;
        b=ul0yO7YnrWZtvCDl64CumS0hZ73EFchtOJG27w0wREX1Iok3w5Iu9ta4oIy2ODvMdM
         DrebpnzqKJn+m6zT03iFJssqBoypfHQCZwIEjbDr9kX+R9Z2HL5+HwC//SFn7BzBzKrN
         XPM4EhWNIYRJVSSX+V1UQyH88QNz08UAt9U4GZkeMxxUFeujTaL3j2orMcX9ke3iIcu/
         IsprTxKxDtU+TZJE6ySxzqhFTesgXnjsMdkTdZcs0qNH1gnCwZW1MwCRZQPiqxneK1xA
         Wrc/B53uy0w9g5Tfw18HwKXsj5c/g6og/ONIDUgXPm6rSYD7POHyXfBGk3lpqdwbXPPY
         L4cw==
X-Gm-Message-State: AOAM530RWoJ2fzi6s+meXAEJEz3uB50IhS+42MEQoCne4AmsaEnkYLL5
        Kls2/ibRhptwNMFyIWvYKi8KUMvdwvPf/4d203hZGrs8btbAwwMYcl1G9UDvXUk1JHDrxWG6Drm
        7OzEw/dPBYcDe
X-Received: by 2002:adf:f608:: with SMTP id t8mr2766199wrp.308.1593163522221;
        Fri, 26 Jun 2020 02:25:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywXuR87Ty186wl5i8tfnbY4muleFHtP6UPdfNFbaa4hdPWjIc402Wef+Df5J3GTzWaJX81CQ==
X-Received: by 2002:adf:f608:: with SMTP id t8mr2766168wrp.308.1593163521866;
        Fri, 26 Jun 2020 02:25:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a10sm36589931wrm.21.2020.06.26.02.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 02:25:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>, kvm@vger.kernel.org
Cc:     virtio-fs@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault error
In-Reply-To: <20200625214701.GA180786@redhat.com>
References: <20200625214701.GA180786@redhat.com>
Date:   Fri, 26 Jun 2020 11:25:19 +0200
Message-ID: <87lfkach6o.fsf@vitty.brq.redhat.com>
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
> As of now only one error pfn is stored and that means it could be
> overwritten before next a retry from guest happens. But this is
> just a hint and if we miss it, some other time we will catch it.
> If this becomes an issue, we could maintain an array of error
> gfn later to help ease the issue.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/x86.c              | 14 +++++++++++---
>  4 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b21540..3c0677b9d3d5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -778,6 +778,7 @@ struct kvm_vcpu_arch {
>  		unsigned long nested_apf_token;
>  		bool delivery_as_pf_vmexit;
>  		bool pageready_pending;
> +		gfn_t error_gfn;
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
> index 76817d13c86e..a882a6a9f7a7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  	if (!async)
>  		return false; /* *pfn has correct page already */
>  
> -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
> +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {

gpa_to_gfn(cr2_or_gpa) ?

>  		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
>  		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
>  			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3b92db412335..a6af7e9831b9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10380,7 +10380,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
>  		return;
>  
> -	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
> +	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
> +	if (r < 0)
> +		vcpu->arch.apf.error_gfn = work->cr2_or_gpa >> PAGE_SHIFT;
>  }
>  
>  static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
> @@ -10490,7 +10492,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
>  	if (unlikely(!lapic_in_kernel(vcpu) ||
>  		     kvm_event_needs_reinjection(vcpu) ||
> @@ -10504,7 +10506,13 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  	 * If interrupts are off we cannot even use an artificial
>  	 * halt state.
>  	 */
> -	return kvm_arch_interrupt_allowed(vcpu);
> +	if (!kvm_arch_interrupt_allowed(vcpu))
> +		return false;
> +
> +	if (vcpu->arch.apf.error_gfn == gfn)
> +		return false;
> +
> +	return true;
>  }
>  
>  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,

I'm a little bit afraid that a single error_gfn may not give us
deterministric behavior. E.g. when we have a lot of faulting processes
it may take many iterations to hit 'error_gfn == gfn' because we'll
always be overwriting 'error_gfn' with new values and waking up some
(random) process.

What if we just temporary disable the whole APF mechanism? That would
ensure we're making forward progress. Something like (completely
untested):

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8998e97457f..945b3d5a2796 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -778,6 +778,7 @@ struct kvm_vcpu_arch {
 		unsigned long nested_apf_token;
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
+		bool error_pending;
 	} apf;
 
 	/* OSVW MSRs (AMD only) */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdd05c233308..e5f04ae97e91 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4124,8 +4124,18 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r)) {
+		/*
+		 * In case APF mechanism was previously disabled due to an error
+		 * we are ready to re-enable it here as we're about to inject an
+		 * error to userspace. There is no guarantee we are handling the
+		 * same GFN which failed in APF here but at least we are making
+		 * forward progress.
+		 */
+
+		vcpu->arch.apf.error_pending = false;
 		return r;
+	}
 
 	r = RET_PF_RETRY;
 	spin_lock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..4607cf4d5117 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10379,7 +10379,9 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
 		return;
 
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
+	r = kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
+	if (r < 0)
+		vcpu->arch.apf.error_pending = true;
 }
 
 static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
@@ -10499,6 +10501,9 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
 		return false;
 
+	if (unlikely(vcpu->arch.apf.error_pending))
+		return false;
+
 	/*
 	 * If interrupts are off we cannot even use an artificial
 	 * halt state.

-- 
Vitaly

