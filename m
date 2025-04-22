Return-Path: <kvm+bounces-43857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAA4A97B24
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 01:41:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B74A189C065
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 23:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A2A215168;
	Tue, 22 Apr 2025 23:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z62Ch55u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABED2135B9
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 23:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745365267; cv=none; b=nvUOGpAIyn+bGfkzaMdrwnK0eBCgg9AAY8kNnki7AhRwVdQcioIsHIf/DTq8ErfqOOS83FllnNZAW5dmlLBP+tCIGdhDa1cILG1ZI9S4fnNr58zIaBL74LLq0ZrFACXFxTZ+jf3rIsDSrl4dUK2XIKJOJ7zWnrpJfVhjfUrXytM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745365267; c=relaxed/simple;
	bh=ldq+7yZwRN8k4yscTNvrYgSUwYk0Uwef6nhbdoF6kMQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A7fycuTHQLvUNrmDaTu7ocfVKIjqS3fdPixhUjPpoM6H9fSqebdESl/LnvP/qyDfX+1A9Rx3LWaQ/q+0Tbh8U+AliDeh6wPgakvYqW6PIh+snYt8WPxczPMpB9wc6yjTGRakXUBfY+R9+faMxkrY0Slh6LgkGTGOJmUUAjYMHZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z62Ch55u; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b06b29fee16so5833118a12.0
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 16:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745365265; x=1745970065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5i4tTTsOvq/0ja5G4fA3PdG/h+iKArfQaWWNqsvt2qM=;
        b=Z62Ch55uWZMVy8qTtdYbebGXHMIxf6TrARyLzhcin6On67qZ/chwx+Q6SQcxyrt+3B
         1m77gJnlPSPo58LcgWtwAk09iITLRSTJ6uGg3y1CafwgGpIvcP4ly8pzjLuCI84mtNtp
         7UB8JMvBn1ZMmTqCjNQccaReoKI3hbncqguOoewO6v+i35gz5lp8wB7oscoeb0AuOx3W
         b8JoQoSr6MI/cO13VdWthXVI1IzE2aPMG0UhQHlEl4qoNk3XFnoKcLelHjwSOmj8Y2KI
         WANQ3p4Rlaz3K8VoqNj3PFunDEPKcYVeQeCzH3dr9im+oadfQgYzfDJuk5KZEsZIt87P
         D5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745365265; x=1745970065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5i4tTTsOvq/0ja5G4fA3PdG/h+iKArfQaWWNqsvt2qM=;
        b=KUOc1mHjx4CeccJT01RFLSrelNXYDXzDI0wp3wbvr8wlZcFwSvlbomGf7MFXXkS8dF
         HdKu5dmO7IwHQxFgY+P/Qe42NOR3eTQekOdKdbp3KouXen32Q9JqpDQ3wS8J9P1wXxli
         ZuoyZTq+mEQYyJbolLCoJFNtfRiVHtTLAvIkJJBBMkZd5AANSVYPeCizfBhCsceghnqS
         XGoRNbXi58hRFPRIzCBNpLVtDiIwANrkYFeygW0Q/JjRGAxuPFrn3GSh9JgnF1pYlezZ
         EBTRvOXQy5OuOj6D84TjhQlMneHfjthdA/pRQ3ydg+FRM7mdWE0dZR0TDDtHgAJD83LR
         6s7Q==
X-Gm-Message-State: AOJu0YwtBR7nlJsEzNahTUm1/RLwlZIC2WIPtaTrIjhJyHPvs03tRYCt
	RzKQxEWZXAcf3uf171VUJ1y986WjX1qAHVnS+rrX9Sa/50xlKE/np30qrrHKqsDBZ2OK9V//64m
	9gQ==
X-Google-Smtp-Source: AGHT+IE+AhhLQo5xzH7TXUWFpbYxhlr78tkce48JIm7UcelnR3fJBK8dTo72Zhy0xpqPqtexbQRTF7ISI+c=
X-Received: from pjbpv14.prod.google.com ([2002:a17:90b:3c8e:b0:2ea:aa56:49c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2743:b0:2ee:d024:e4fc
 with SMTP id 98e67ed59e1d1-3087bdde85amr27692855a91.33.1745365265393; Tue, 22
 Apr 2025 16:41:05 -0700 (PDT)
Date: Tue, 22 Apr 2025 16:41:03 -0700
In-Reply-To: <20250416002546.3300893-4-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250416002546.3300893-1-mlevitsk@redhat.com> <20250416002546.3300893-4-mlevitsk@redhat.com>
Message-ID: <aAgpD_5BI6ZcCN29@google.com>
Subject: Re: [PATCH 3/3] x86: KVM: VMX: preserve host's DEBUGCTLMSR_FREEZE_IN_SMM
 while in the guest mode
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 15, 2025, Maxim Levitsky wrote:
> Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the guest
> GUEST_IA32_DEBUGCTL without the guest seeing this value.
> 
> Note that in the future we might allow the guest to set this bit as well,
> when we implement PMU freezing on VM own, virtual SMM entry.
> 
> Since the value of the host DEBUGCTL can in theory change between VM runs,
> check if has changed, and if yes, then reload the GUEST_IA32_DEBUGCTL with
> the new value of the host portion of it (currently only the
> DEBUGCTLMSR_FREEZE_IN_SMM bit)

No, it can't.  DEBUGCTLMSR_FREEZE_IN_SMM can be toggled via IPI callback, but
IRQs are disabled for the entirety of the inner run loop.  And if I'm somehow
wrong, this change movement absolutely belongs in a separate patch.

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++++++++++++++++-
>  arch/x86/kvm/x86.c     |  2 --
>  3 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cc1c721ba067..fda0660236d8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4271,6 +4271,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
>  	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
>  
> +	vcpu->arch.host_debugctl = get_debugctlmsr();
> +
>  	/*
>  	 * Disable singlestep if we're injecting an interrupt/exception.
>  	 * We don't want our modified rflags to be pushed on the stack where
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c9208a4acda4..e0bc31598d60 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2194,6 +2194,17 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
>  	return debugctl;
>  }
>  
> +static u64 vmx_get_host_preserved_debugctl(struct kvm_vcpu *vcpu)

No, just open code handling DEBUGCTLMSR_FREEZE_IN_SMM, or make it a #define.
I'm not remotely convinced that we'll ever want to emulate DEBUGCTLMSR_FREEZE_IN_SMM,
and trying to plan for that possibility and adds complexity for no immediate value.

> +{
> +	/*
> +	 * Bits of host's DEBUGCTL that we should preserve while the guest is
> +	 * running.
> +	 *
> +	 * Some of those bits might still be emulated for the guest own use.
> +	 */
> +	return DEBUGCTLMSR_FREEZE_IN_SMM;
>
>  u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
>  {
>  	return to_vmx(vcpu)->msr_ia32_debugctl;
> @@ -2202,9 +2213,11 @@ u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
>  static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	u64 host_mask = vmx_get_host_preserved_debugctl(vcpu);
>  
>  	vmx->msr_ia32_debugctl = data;
> -	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> +	vmcs_write64(GUEST_IA32_DEBUGCTL,
> +		     (vcpu->arch.host_debugctl & host_mask) | (data & ~host_mask));
>  }
>  
>  bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
> @@ -2232,6 +2245,7 @@ bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated
>  	return true;
>  }
>  
> +

Spurious newline.

>  /*
>   * Writes msr value into the appropriate "register".
>   * Returns 0 on success, non-0 otherwise.
> @@ -7349,6 +7363,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long cr3, cr4;
> +	u64 old_debugctl;
>  
>  	/* Record the guest's net vcpu time for enforced NMI injections. */
>  	if (unlikely(!enable_vnmi &&
> @@ -7379,6 +7394,17 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  		vmcs_write32(PLE_WINDOW, vmx->ple_window);
>  	}
>  
> +	old_debugctl = vcpu->arch.host_debugctl;
> +	vcpu->arch.host_debugctl = get_debugctlmsr();
> +
> +	/*
> +	 * In case the host DEBUGCTL had changed since the last time we
> +	 * read it, update the guest's GUEST_IA32_DEBUGCTL with
> +	 * the host's bits.
> +	 */
> +	if (old_debugctl != vcpu->arch.host_debugctl)

This can and should be optimized to only do an update if a host-preserved bit
is toggled.

> +		__vmx_set_guest_debugctl(vcpu, vmx->msr_ia32_debugctl);

I would rather have a helper that explicitly writes the VMCS field, not one that
sets the guest value *and* writes the VMCS field.

The usage in init_vmcs() doesn't need to write vmx->msr_ia32_debugctl because the
vCPU is zero allocated, and this usage doesn't change vmx->msr_ia32_debugctl.
So the only path that actually needs to modify vmx->msr_ia32_debugctl is
vmx_set_guest_debugctl().

> +
>  	/*
>  	 * We did this in prepare_switch_to_guest, because it needs to
>  	 * be within srcu_read_lock.
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 844e81ee1d96..05e866ed345d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11020,8 +11020,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		set_debugreg(0, 7);
>  	}
>  
> -	vcpu->arch.host_debugctl = get_debugctlmsr();
> -
>  	guest_timing_enter_irqoff();
>  
>  	for (;;) {
> -- 
> 2.26.3
> 

