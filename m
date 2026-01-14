Return-Path: <kvm+bounces-67998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 35D5BD1BD4F
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 01:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A6BD5302956E
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 00:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FA0225403;
	Wed, 14 Jan 2026 00:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qpKym3Ej"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25C31A08AF
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 00:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768351329; cv=none; b=X5z/lVSj3rp6/nW+ICCcExTZdfGetWRpWfQ4GEeSIXkg+zhWGZxtJYogjBmR4citMW1AsVLT4ubhzbVqjJzNF62EpShcvQH9jBFAtPdKv5dFgQ7cj3ZYDCceeVGayt8qvd3mBA31Twkg+Lf8HPDnR6eXSyW19modVuuOlcUGVRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768351329; c=relaxed/simple;
	bh=Bopgb5ZIVLWPBVYEccSD9skYtC+OxMkBXkfDoARxMtU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YKR+JhcEFGYpWWmYzKGYxgR9GgxJL4xlEb7VtJFut5s2qFIRFJdPJ93EcSbcIMwfZjNCTF8KtulwVasHgZ2jZKIRQeDp/FtX20y1640vdk5wIDsQ9hAlCh+SpLS5lVI4pKGKjNqndoM++JYX6VPhHZ4zRv25d+cBEnm4jk24PDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qpKym3Ej; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c3501d784so7542675a91.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768351327; x=1768956127; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pd5+DJp4tMXnHmf+bQwLqAmsmcSpJgq9CjvpTrkRj6s=;
        b=qpKym3Ejlg89nsjFscQ1kCgyhX3Yf9Z3HXpVTvC3KBQeOtvPxgtDKpCSq7ijpffugP
         3Gk0zKqW/6e7szgNH07uhebNGp3TmgE2CcU+EHvAqTXlNi+5/JmAdcyw8E/2Pcy1c0sM
         e4AhzDGd+k2eUvyVN0At1tenaA4RMem5M2UPZDDsToJ3WrgnlRaQ6lC02RW38JxnZzhc
         CVcroQxZ6sXT2KF7WIGfr8vqKeiI0N0pWZJBIivLVRsAKKOjXudd3QwaMvKHB9p8Trv+
         QsrR8a0jybpeoyZI19X2u+mamCVPW+XqNc4asZ1Ei1oETiSXEoNCmjHM8AHd192dt9LT
         Kl1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768351327; x=1768956127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pd5+DJp4tMXnHmf+bQwLqAmsmcSpJgq9CjvpTrkRj6s=;
        b=KAUawGWbBq55PV4nQCWM6CqOyRlz1dElnR7qMTPWd453/FsKm5+5JkSA9zQgm1kDGl
         B7nOK8ufPsd1CNBa8ojOdiiecx6IBepNq3A/9cIXQ7+WeWzjm6VhtPf9MPH+N0QpFtWH
         xQxMk/dUvoN/QXmYbaPSkGADQlPg5aAIOBvsVu/wm8m7N6hyRQ+xxnPXHLPMYTPAS+Ge
         SWvz7HbtFNaCub8rhYNll4SBzgzZ1nP65V4kA7ZL0qq/zZF4XN07s80IY4cFVYZquQzb
         sukCrqOBfcfWrK/75rhpPzE9h8V4yev6tJ7MOO7U1CioBDsOgYDT0koBJXu2mmLm4xou
         ZKcA==
X-Forwarded-Encrypted: i=1; AJvYcCWkEzgSUPNk2FN0OV1xJ2uWeRvPZPTL6epndTKIJ//Cx0HPdMQ8WENtHbPKVkAAS61zWqw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgF9pkBQRhbv5OAr9/KKyaE6PYu2C8b+lybzPoJ0u+/WFgubmY
	4JqZZpLVS6NDt6nV8x4gw+yQKbBPnso9ieL12Nur/zjoVkc2nAOsDeSYLce0Iu2N8gmnyqDZ8FX
	JmXALwA==
X-Received: from pjbie5.prod.google.com ([2002:a17:90b:4005:b0:34c:fe27:790f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d09:b0:34c:fe7e:84fe
 with SMTP id 98e67ed59e1d1-35109135069mr688153a91.28.1768351327191; Tue, 13
 Jan 2026 16:42:07 -0800 (PST)
Date: Tue, 13 Jan 2026 16:42:05 -0800
In-Reply-To: <20260113225406.273373-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113225406.273373-1-jmattson@google.com>
Message-ID: <aWbmXTJdZDO_tnvE@google.com>
Subject: Re: [PATCH] KVM: VMX: Add quirk to allow L1 to set FREEZE_IN_SMM in vmcs12
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 13, 2026, Jim Mattson wrote:
> Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM to allow L1 to set
> IA32_DEBUGCTL.FREEZE_IN_SMM in vmcs12 when using nested VMX.  Prior to
> commit 6b1dd26544d0 ("KVM: VMX: Preserve host's
> DEBUGCTLMSR_FREEZE_IN_SMM while running the guest"), L1 could set
> FREEZE_IN_SMM in vmcs12 to freeze PMCs during physical SMM coincident
> with L2's execution.  The quirk is enabled by default for backwards
> compatibility; userspace can disable it via KVM_CAP_DISABLE_QUIRKS2 if
> consistency with WRMSR(IA32_DEBUGCTL) is desired.

It's probably worth calling out that KVM will still drop FREEZE_IN_SMM in vmcs02

	if (vmx->nested.nested_run_pending &&
	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
		vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_debugctl &
					       vmx_get_supported_debugctl(vcpu, false)); <====
	} else {
		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
		vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_debugctl);
	}

both from a correctness standpoint and so that users aren't mislead into thinking
the quirk lets L1 control of FREEZE_IN_SMM while running L2.

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0521b55d47a5..bc8f0b3aa70b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3298,10 +3298,24 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
>  	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
>  		return -EINVAL;
>  
> -	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> -	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> -	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
> -		return -EINVAL;
> +	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) {
> +		u64 debugctl = vmcs12->guest_ia32_debugctl;
> +
> +		/*
> +		 * FREEZE_IN_SMM is not virtualized, but allow L1 to set it in
> +		 * L2's DEBUGCTL under a quirk for backwards compatibility.
> +		 * Prior to KVM taking ownership of the bit to ensure PMCs are
> +		 * frozen during physical SMM, L1 could set FREEZE_IN_SMM in
> +		 * vmcs12 to freeze PMCs during physical SMM coincident with
> +		 * L2's execution.
> +		 */
> +		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM))
> +			debugctl &= ~DEBUGCTLMSR_FREEZE_IN_SMM;
> +
> +		if (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
> +		    CC(!vmx_is_valid_debugctl(vcpu, debugctl, false)))

I'm mildly tempted to say we should quirk the entire consistency check instead of
limiting it to FREEZE_IN_SMM, purely so that we don't have to add yet another quirk
if a different setup breaks on a different bit.  I suppose we could limit the quirk
to bits that could have been plausibly set in hardware, because otherwise VM-Entry
using L2 would VM-Fail, but that's still quite a few bits.

I'm definitely not opposed to a targeted quirk though.

> +			return -EINVAL;
> +	}
>  
>  	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
>  	    CC(!kvm_pat_valid(vmcs12->guest_ia32_pat)))
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

