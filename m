Return-Path: <kvm+bounces-61497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FB8C21174
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 17:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 20F2935013A
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E8283655C3;
	Thu, 30 Oct 2025 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uKHB83wO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2239C262FF3
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761840405; cv=none; b=vAnQajA+gyv7FB7zLlt2WlAhhAKgF3mmJ3kyI9uygd3atxLAl5AP7BioL5ZHWtofqsShY8h4EpF+5BQph0/LghQvi0z2WoxndE2kDJykwRkdyqoUyVd00+58y+ZgFZYtjj72wZuBmmZW3U6m+al9dMLSMxThRq35Pa5Vbn8b4K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761840405; c=relaxed/simple;
	bh=emHXDFH3cm5JcOr/ZLISPK3FauTyJLfHMVixVBcEdtg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DMIRbC2j05QYb6U/ekKxxY4RjHBh2UC+0+0YBxuvtACP2N44IGkTP+bkMEwjqessiiyHBobw4XMqZ5zj/ILAQdxx/ZchMbQkL7HjXUvrp6xsdLfaOWoCHcRXTcZY2s5C8nlO1I4nxqOdwzI7n3MzHTrNtMvs8G3ZDy3pisN0n60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uKHB83wO; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2930e2e8e7fso10278095ad.2
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 09:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761840403; x=1762445203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ut8vW6bsxjlrZ6/WRQNVG4rroxn8B21Wq3a7SMf8Qso=;
        b=uKHB83wOjEJc7mMLlF2cmLWzyPB904t4c0pTLtTAWLtR5nyK7Xp3Le8R8KLxPiHBgc
         3iZ0Q35H5uHfPUm520XjwdEKTOm0/x4s5djyILRNM/Spg1p/j2+IsU/Gr237/WBpv/8N
         tv9KWYksy3E1wSAhpkYZCIt63Yxu8t0ADK7MuVNr4for8bYYYG0YhjrztAEjcKwp1C/P
         X2SP8tA+2h9cVSFD7TS+xqAJmcRfwb6hGJ4fLo6pEPgsUXhnsemBz3/7SbZdRsI3QMRt
         5A8yDSLLDCfguZM3XAVVqm3dprMoIjdqHRKTkDvEiI1/n82MDbsy1Nd+t6kJCtBDK5gX
         uO0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761840403; x=1762445203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ut8vW6bsxjlrZ6/WRQNVG4rroxn8B21Wq3a7SMf8Qso=;
        b=nS9MO6wO75xTWyW7kPPx0zTFGhfUY22RxqkzOnh2/s6ObS626S75U3U99LMWfJph3p
         bFQ/n9p8YcpRNYqBz1V2xO/rmfA7a9xxAbUDoM6NXWMy2HmZepXwzJzANQsx4wuujaG2
         81ycGoGTCcbAxl0Jpli+bHFqstfvU3x9cQmCaFqaXip8Hawwp2Rd+EkGMagIjfFlFsYx
         6DvdRREhiyr0YfU7QlI0cJYfz/PZTOPq8DPrA2mOWs1Awn2vzr6xtZwWvaBrDuOFq5wC
         ZUmFRG47P1x+A5Pp0WzQN5MBR7KP0gnixgD1P3RzbKDr5fBejkl27gZu6kUjl/ApYEdP
         b1Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXDD5X9nBDHd1cEuOzRS6p5RqTaIJYEaMAtPKSz/Ia3z/is7m3vQsWOA4b9gF0L0UooouY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl9v9eDEqMJXb5M6XITHA+UuwNhawGAcu5P2h7NoatcfH81I6w
	02tJ/0wzmHyWtvDoN1Kjd6Q9ryOITNZ+hZL84T5xStGzP/XqI/ABpiRpYjsxEiIezD0jePNVfOT
	H9wzFSQ==
X-Google-Smtp-Source: AGHT+IFOmrhGs9qwzgqNWom3vtayLxGcvnNzwDkh449M4y7i/ZpK9e+ty3EmpdbliiXkDlefL48EH9rCeCs=
X-Received: from pjm14.prod.google.com ([2002:a17:90b:2fce:b0:340:6b70:821e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2348:b0:272:c95c:866
 with SMTP id d9443c01a7336-2951a3b6b8amr3692235ad.20.1761840403282; Thu, 30
 Oct 2025 09:06:43 -0700 (PDT)
Date: Thu, 30 Oct 2025 09:06:41 -0700
In-Reply-To: <DDVO5U7JZF4F.1WXXE8IYML140@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com> <DDVO5U7JZF4F.1WXXE8IYML140@google.com>
Message-ID: <aQONEWlBwFCXx3o6@google.com>
Subject: Re: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 30, 2025, Brendan Jackman wrote:
> > @@ -160,6 +163,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >  	/* Load guest RAX.  This kills the @regs pointer! */
> >  	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
> >  
> > +	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
> > +	jz .Lskip_clear_cpu_buffers
> 
> Hm, it's a bit weird that we have the "alternative" inside
> VM_CLEAR_CPU_BUFFERS, but then we still keep the test+jz
> unconditionally. 

Yeah, I had the same reaction, but couldn't come up with a clean-ish solution
and so ignored it :-)

> If we really want to super-optimise the no-mitigations-needed case,
> shouldn't we want to avoid the conditional in the asm if it never
> actually leads to a flush?
> 
> On the other hand, if we don't mind a couple of extra instructions,
> shouldn't we be fine with just having the whole asm code based solely
> on VMX_RUN_CLEAR_CPU_BUFFERS and leaving the
> X86_FEATURE_CLEAR_CPU_BUF_VM to the C code?
> 
> I guess the issue is that in the latter case we'd be back to having
> unnecessary inconsistency with AMD code while in the former case... well
> that would just be really annoying asm code - am I on the right
> wavelength there? So I'm not necessarily asking for changes here, just
> probing in case it prompts any interesting insights on your side.
> 
> (Also, maybe this test+jz has a similar cost to the nops that the
> "alternative" would inject anyway...?)

It's not at all expensive.  My bigger objection is that it's hard to follow what's
happening.

Aha!  Idea.  IIUC, only the MMIO Stale Data is conditional based on the properties
of the vCPU, so we should track _that_ in a KVM_RUN flag.  And then if we add yet
another X86_FEATURE for MMIO Stale Data flushing (instead of a static branch),
this path can use ALTERNATIVE_2.  The use of ALTERNATIVE_2 isn't exactly pretty,
but IMO this is much more intuitive.

diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
index 004fe1ca89f0..b9651960e069 100644
--- a/arch/x86/kvm/vmx/run_flags.h
+++ b/arch/x86/kvm/vmx/run_flags.h
@@ -4,10 +4,10 @@
 
 #define VMX_RUN_VMRESUME_SHIFT                 0
 #define VMX_RUN_SAVE_SPEC_CTRL_SHIFT           1
-#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT                2
+#define VMX_RUN_CAN_ACCESS_HOST_MMIO_SHIT      2
 
 #define VMX_RUN_VMRESUME               BIT(VMX_RUN_VMRESUME_SHIFT)
 #define VMX_RUN_SAVE_SPEC_CTRL         BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
-#define VMX_RUN_CLEAR_CPU_BUFFERS      BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
+#define VMX_RUN_CAN_ACCESS_HOST_MMIO   BIT(VMX_RUN_CAN_ACCESS_HOST_MMIO_SHIT)
 
 #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index ec91f4267eca..50a748b489b4 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -137,8 +137,10 @@ SYM_FUNC_START(__vmx_vcpu_run)
        /* Load @regs to RAX. */
        mov (%_ASM_SP), %_ASM_AX
 
-       /* jz .Lskip_clear_cpu_buffers below relies on this */
-       test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
+       /* Check if jz .Lskip_clear_cpu_buffers below relies on this */
+       ALTERNATIVE_2 "",
+                     "", X86_FEATURE_CLEAR_CPU_BUF
+                     "test $VMX_RUN_CAN_ACCESS_HOST_MMIO, %ebx", X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO
 
        /* Check if vmlaunch or vmresume is needed */
        bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
@@ -163,8 +165,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
        /* Load guest RAX.  This kills the @regs pointer! */
        mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
-       /* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
-       jz .Lskip_clear_cpu_buffers
+       ALTERNATIVE_2 "jmp .Lskip_clear_cpu_buffers",
+                     "", X86_FEATURE_CLEAR_CPU_BUF
+                     "jz .Lskip_clear_cpu_buffers", X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO
        /* Clobbers EFLAGS.ZF */
        VM_CLEAR_CPU_BUFFERS
 .Lskip_clear_cpu_buffers:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 303935882a9f..b9e7247e6b9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -903,16 +903,9 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
        if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
                flags |= VMX_RUN_SAVE_SPEC_CTRL;
 
-       /*
-        * When affected by MMIO Stale Data only (and not other data sampling
-        * attacks) only clear for MMIO-capable guests.
-        */
-       if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only)) {
-               if (kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
-                       flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
-       } else {
-               flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
-       }
+       if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUFFERS_MMIO) &&
+           kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
+               flags |= VMX_RUN_CAN_ACCESS_HOST_MMIO;
 
        return flags;
 }

