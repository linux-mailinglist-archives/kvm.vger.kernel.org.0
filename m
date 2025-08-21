Return-Path: <kvm+bounces-55392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 126C6B30782
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63D1A1D03561
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DE235690E;
	Thu, 21 Aug 2025 20:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J4HMOKiV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5391F3568F4
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755808701; cv=none; b=Bd2ExM4xOr0dhWfVNJbSIcfa7bULbblS2rlub1/3sQIX5ZzTrLaxk1kZpduuWCVpgGPxbHci4sF4pAOG0xZw0IhC5GuNivJqEpiYp0T+SIUq+/qzTHkEzgbzDj/b7KhbLF92fjN5zfTiuXwythnKgaezOmrhGqr9MIbbcr0Vjnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755808701; c=relaxed/simple;
	bh=CCWyrizXqh6azDRIlEbtuLy92d9UOttaWpx8GvlyZH8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pUR65+DXWk1mzMb9WfayzZDATAjAaLcxNzVidb0VaK65s5IYvUHe2O1EJr3whkjb18ewuV5mme2Kctr+dWLrUlah2divaZBoiKRF+X/ldZG4FTchDWqTbRdMEooP7j6MMpN9M7gqTVKhZjgZaCCyDSku6RK1uykdznyH1LZwjv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J4HMOKiV; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471757d82fso1125411a12.3
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 13:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755808698; x=1756413498; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0DT+LN0N/uSj+iDQVx56WV7qQae5b12UpmwE1JIpSnE=;
        b=J4HMOKiVZn3062sSZbrT8a+iPMy+jnFWemauDYir0wUCXKDus6hvt19X/z4B4t+/xK
         x6gLGKLNHKoUS4xBSElC5+pAPe9iNOqPysazjz4Fv9h/oJ2iv/nR+Gak6UtMi7KRhzcL
         5tvPrFYecqMFPHoi3rwg3z7Bics+l4ePNh2eabQu4gskK9+hP3hldauUU/tLrJDrxVkg
         6E/8pneEaptECBjkTAiTdVkKVBi8w9JH0kKAIjukL5TYAEIaMdKo1l/oMCCFEuPoi8nN
         GWWj/kADinM859KHGqsFKsvfGnQKPblprpt90LSJ8t28HXObdM4H/7BVtLlOnLObjxri
         D4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755808698; x=1756413498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0DT+LN0N/uSj+iDQVx56WV7qQae5b12UpmwE1JIpSnE=;
        b=a23iwfkkYADXXUunJujAcp5R+FowKGFANB5Ch2VsQlZvgd/QOAygo2Kt0QUsypomF5
         sYIk1WhsLZzA5Ovgbq/5s1JSvJnyscUo2zWppwSMCgQbLXTsVIF2iSgxdiWoGEC3CUC8
         YahgEr03O3GEw05u1IjCcEeLrmwc+a/WLxviFih1GNOdYliED9rng49I/VaF4S0pIa0d
         sfLt9eMQ6YFC4Hs6nwvvtsNMHBwWdZYIEIcnjtQUj4DnGn3vIbwQV4Xqg0CsG8/RbsUU
         WF4VxMhnI2uL36AomARDKvC4jt7lDr8PuKSCe08qnf/PAsVSUexh8Q9HcqNCJKUl4szC
         XgOg==
X-Forwarded-Encrypted: i=1; AJvYcCW1mjusha4pK+df0b2KQ2h948oZnuuxGP8oRMkz4VIWW5IThumoJCStQFzcAWtfA6CzHIY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0uYPSlKLmvtM3iTqZIPyox6J9HWRKLawBw06Rn7ldOJSa8ea+
	PJTxMGJEtokvTMjqigq82ZZ1mHqVQ2lqoFhBmPlnO152s4fMfgmgDq723WYzPAu0pqpFBnjdHPL
	9iU1NHg==
X-Google-Smtp-Source: AGHT+IHLMb0Ev4JwGytUG/z778wSGXRQCiWY994aVKEonVuNvxifDjuhuy4KGJVbjfnt1w2f94VzQ8w6u2s=
X-Received: from pjbnb7.prod.google.com ([2002:a17:90b:35c7:b0:321:c9cf:de39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3805:b0:31c:c661:e4e
 with SMTP id 98e67ed59e1d1-32518997f87mr991073a91.33.1755808698460; Thu, 21
 Aug 2025 13:38:18 -0700 (PDT)
Date: Thu, 21 Aug 2025 13:38:17 -0700
In-Reply-To: <2b2cfff9a2bd6bcc97b97fee7f3a3e1186c9b03c.1755609446.git.maciej.szmigiero@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1755609446.git.maciej.szmigiero@oracle.com> <2b2cfff9a2bd6bcc97b97fee7f3a3e1186c9b03c.1755609446.git.maciej.szmigiero@oracle.com>
Message-ID: <aKeDuaW5Df7PgA38@google.com>
Subject: Re: [PATCH 1/2] KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR when
 setting LAPIC regs
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 19, 2025, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> When AVIC is enabled the normal pre-VMRUN sync in sync_lapic_to_cr8() is
> inhibited so any changed TPR in the LAPIC state would not get copied into
> the V_TPR field of VMCB.
> 
> AVIC does sync between these two fields, however it does so only on
> explicit guest writes to one of these fields, not on a bare VMRUN.
> 
> This is especially true when it is the userspace setting LAPIC state via
> KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
> VMCB.
> 
> Practice shows that it is the V_TPR that is actually used by the AVIC to
> decide whether to issue pending interrupts to the CPU (not TPR in TASKPRI),
> so any leftover value in V_TPR will cause serious interrupt delivery issues
> in the guest when AVIC is enabled.
> 
> Fix this issue by explicitly copying LAPIC TPR to VMCB::V_TPR in
> avic_apicv_post_state_restore(), which gets called from KVM_SET_LAPIC and
> similar code paths when AVIC is enabled.
> 
> Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  arch/x86/kvm/svm/avic.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index a34c5c3b164e..877bc3db2c6e 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -725,8 +725,31 @@ int avic_init_vcpu(struct vcpu_svm *svm)
>  
>  void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	u64 cr8;
> +
>  	avic_handle_dfr_update(vcpu);
>  	avic_handle_ldr_update(vcpu);
> +
> +	/* Running nested should have inhibited AVIC. */
> +	if (WARN_ON_ONCE(nested_svm_virtualize_tpr(vcpu)))
> +		return;


> +
> +	/*
> +	 * Sync TPR from LAPIC TASKPRI into V_TPR field of the VMCB.
> +	 *
> +	 * When AVIC is enabled the normal pre-VMRUN sync in sync_lapic_to_cr8()
> +	 * is inhibited so any set TPR LAPIC state would not get reflected
> +	 * in V_TPR.

Hmm, I think that code is straight up wrong.  There's no justification, just a
claim:

  commit 3bbf3565f48ce3999b5a12cde946f81bd4475312
  Author:     Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
  AuthorDate: Wed May 4 14:09:51 2016 -0500
  Commit:     Paolo Bonzini <pbonzini@redhat.com>
  CommitDate: Wed May 18 18:04:31 2016 +0200

    svm: Do not intercept CR8 when enable AVIC
    
    When enable AVIC:
        * Do not intercept CR8 since this should be handled by AVIC HW.
        * Also, we don't need to sync cr8/V_TPR and APIC backing page.   <======
    
    Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    [Rename svm_in_nested_interrupt_shadow to svm_nested_virtualize_tpr. - Paolo]
    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

That claim assumes APIC[TPR] will _never_ be modified by anything other than
hardware.  That's obviously false for state restore from userspace, and it's also
technically false at steady state, e.g. if KVM managed to trigger emulation of a
store to the APIC page, then KVM would bypass the automatic harware sync.

There's also the comically ancient KVM_SET_VAPIC_ADDR, which AFAICT appears to
be largely dead code with respect to vTPR (nothing sets KVM_APIC_CHECK_VAPIC
except for the initial ioctl), but could again set APIC[TPR] without updating
V_TPR.

So, rather than manually do the update during state restore, my vote is to restore
the sync logic.  And if we want to optimize that code (seems unnecessary), then
we should hook all TPR writes.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..1bfebe40854f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4046,8 +4046,7 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
        struct vcpu_svm *svm = to_svm(vcpu);
        u64 cr8;
 
-       if (nested_svm_virtualize_tpr(vcpu) ||
-           kvm_vcpu_apicv_active(vcpu))
+       if (nested_svm_virtualize_tpr(vcpu))
                return;
 
        cr8 = kvm_get_cr8(vcpu);


> +	 *
> +	 * Practice shows that it is the V_TPR that is actually used by the
> +	 * AVIC to decide whether to issue pending interrupts to the CPU, not
> +	 * TPR in TASKPRI.

FWIW, the APM kinda sorta alludes to this:

  Enabling AVIC also affects CR8 behavior independent of V_INTR_MASKING enable
  (bit 24): writes to CR8 affect the V_TPR and update the backing page and reads
  from CR8 return V_TPR.


> +	 */
> +	cr8 = kvm_get_cr8(vcpu);
> +	svm->vmcb->control.int_ctl &= ~V_TPR_MASK;
> +	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;
> +	WARN_ON_ONCE(!vmcb_is_dirty(svm->vmcb, VMCB_INTR));


>  }
>  
>  static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)

