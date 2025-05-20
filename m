Return-Path: <kvm+bounces-47195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CDCEABE7CA
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:59:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05EFE189BC34
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9674225E46E;
	Tue, 20 May 2025 22:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fVqBH8Vv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBF52566F5
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 22:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747781829; cv=none; b=S1nlKTvTO1tSmK8rSH62vEPDyyXPsA05th9HK1dD2O1q+eizdMcqlofKNDcsy2c3Hil51lHU7KwuIPWoPOgksjU3K9HNbnGZsciUZvxBwQWQhFgLILrb0BbKmn6sGzoKwSzJWmcP5xDCyehYiSUAxsSHXqMD33IQJh4XhkUPatU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747781829; c=relaxed/simple;
	bh=rdA6H3VgwQOCh8S8IexGiiGwtEMnVDcfDttQOjM2xbQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BE8nI0oBz/pkvcLupIdAOI2aBH2WDxFXVYXzp5/XAIe0bQXAZyeH1+RR+gDOhh7HKwod+6U6lggtR66TXe82ThF3puHN1rOqC5J+s7dz1ArfYzxXhT5n5mRfq7a6mTx+N9clHnxloO+4ZFaoOYK7wnWvt47NFC9Qw34hKsSbImc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fVqBH8Vv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e2bd11716so6239134a91.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 15:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747781827; x=1748386627; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8yKW/q7vhix09E264PiuMuzRJMsgSqosjtJ6IDxGY5A=;
        b=fVqBH8Vvb707psRBTNWpMcUffsSgv6j1iPvpuFiNF5K3MTpvWNEEbNTgVGak6L+7xX
         bdbp6+oatcZi5PJZOnar0/J7tHmXbcA5nQ5ywkIgxbmIi+3R/ooRvD54uIp5IkSLwaIz
         bWLIG1fOWt7+goJujdqobNwxSGqyuZKEUerxeruLzolKwrL4xaEIpudt+6ZNQqySCrgv
         Y6Mhax7cD4HvRWb49aj1AXUjHqVDcl26Z8jOn7DtMUA6NUoTxBuCoBdg9Kpwt2DTXDXG
         FkNl4HPISKAZOgjBbM2XB8GDfKCi/ZIju/KMSDrr4pa3HPLUN73Alj+vLhGQQB1xX1e7
         MqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747781827; x=1748386627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8yKW/q7vhix09E264PiuMuzRJMsgSqosjtJ6IDxGY5A=;
        b=vXx8qnQ3b8d5uaQKNlbCiyAse0OBlGYh+X0AsXWcVpObZExZ4FOj7+p7W56fCJrXuM
         oRQVuHGKAVgggzmtFCsLwQKW7Wr37+V/ExhouH7F4iUhlkGtwy5yBoVOq9mbq1Y102qN
         cCyHkL1akHtubSolp5lwjGvyOkXDoZP8bndxZ0fFFDX8BC9CU8J+Lz2kKN8P45M3mKte
         mxUeXfPzbXkYTSFU+QjHgC+xoAhnQ8AzkZm/SY2K4ucHNjT8STV+8qq1QIQG8IlroAxq
         nv0Z9Uhy08Bxa5ZLWQaBHbX7riOSiOSrk43AtjdMUVb5hQnIgIj4w7LsUphALpc893qd
         Hkzw==
X-Gm-Message-State: AOJu0YyhFMuBYyzoFh5ThOXau8lMx2PPTNo03hubQFfG9d4UTM7GKSkb
	RPOfgAXzWhupACpD5ewIiAhFcS8ORtsf5Ycu6yX3r3uVpEJp489YFoSuMhGptEyVsjaanC7BLoL
	WrReZqA==
X-Google-Smtp-Source: AGHT+IHZMVljwetvzNG3QUgRgAPbKeHu60JLPsRcUNj6g9cQyY08V1CGpDmRnHFioMM/wBEXLCKeZRJAv+c=
X-Received: from pjbdy5.prod.google.com ([2002:a17:90b:6c5:b0:2ff:6e58:89f7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfc7:b0:30c:5479:c92e
 with SMTP id 98e67ed59e1d1-30e830c7988mr28117531a91.4.1747781827386; Tue, 20
 May 2025 15:57:07 -0700 (PDT)
Date: Tue, 20 May 2025 15:57:05 -0700
In-Reply-To: <20250515005353.952707-5-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250515005353.952707-1-mlevitsk@redhat.com> <20250515005353.952707-5-mlevitsk@redhat.com>
Message-ID: <aC0IwYfNvuo_vUDU@google.com>
Subject: Re: [PATCH v4 4/4] x86: KVM: VMX: preserve DEBUGCTLMSR_FREEZE_IN_SMM
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

KVM: VMX:

On Wed, May 14, 2025, Maxim Levitsky wrote:
> Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the guest
> GUEST_IA32_DEBUGCTL without the guest seeing this value.
> 
> Since the value of the host DEBUGCTL can in theory change between VM runs,
> check if has changed, and if yes, then reload the GUEST_IA32_DEBUGCTL with
> the new value.

Please split this into two patches.  Add vmx_guest_debugctl_{read,write}(), then
land the FREEZE_IN_SMM change on top.  Adding the helpers should be a nop and
thus trivial to review, and similarly the DEBUGCTLMSR_FREEZE_IN_SMM change is
actually pretty small.  But combined, this patch is annoying to review because
there's a lot of uninteresting diff to wade through to get at the FREEZE_IN_SMM
logic.

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/nested.c       |  4 ++--
>  arch/x86/kvm/vmx/vmx.c          | 22 +++++++++++++++++++---
>  arch/x86/kvm/vmx/vmx.h          |  2 ++
>  arch/x86/kvm/x86.c              |  7 +++++--
>  5 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d2ad31a1628e..2e7e4a8b392e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1673,6 +1673,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  enum kvm_x86_run_flags {
>  	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
>  	KVM_RUN_LOAD_GUEST_DR6		= BIT(1),
> +	KVM_RUN_LOAD_DEBUGCTL		= BIT(2),
>  };
>  
>  struct kvm_x86_ops {

...

> @@ -7368,6 +7381,9 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>  	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
>  		set_debugreg(vcpu->arch.dr6, 6);
>  
> +	if (run_flags & KVM_RUN_LOAD_DEBUGCTL)
> +		vmx_guest_debugctl_write(vcpu, vmx_guest_debugctl_read());
> +
>  	/*
>  	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
>  	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 1b80479505d3..5ddedf73392b 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -416,6 +416,8 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
>  
>  void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
>  u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
> +void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val);
> +u64 vmx_guest_debugctl_read(void);

I vote to make these static inlines, I don't see any reason to bury them in vmx.c

>  /*
>   * Note, early Intel manuals have the write-low and read-high bitmap offsets
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 684b8047e0f2..a85078dfa36d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10752,7 +10752,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		dm_request_for_irq_injection(vcpu) &&
>  		kvm_cpu_accept_dm_intr(vcpu);
>  	fastpath_t exit_fastpath;
> -	u64 run_flags;
> +	u64 run_flags, host_debug_ctl;
>  
>  	bool req_immediate_exit = false;
>  
> @@ -11024,7 +11024,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		set_debugreg(0, 7);
>  	}
>  
> -	vcpu->arch.host_debugctl = get_debugctlmsr();
> +	host_debug_ctl = get_debugctlmsr();

This can probably just be debug_ctl to shorten the lines, I don't see a strong
need to clarify it's the host's value since all accesses are clustered together.

> +	if (host_debug_ctl != vcpu->arch.host_debugctl)
> +		run_flags |= KVM_RUN_LOAD_DEBUGCTL;
> +	vcpu->arch.host_debugctl = host_debug_ctl;

Argh, the TDX series didn't get refreshed (or maybe it got poorly rebased), and
now there's a redundant and confusing "host_debugctlmsr" field in vcpu_vt.  Can
you slot in the below?  It's not urgent enough to warrant posting separately,
and handling TDX in this series would get a bit wonky if TDX uses a different
snapshot.

The reason I say that TDX will get wonky is also why I think the "are bits
changing?" check in x86.c needs to be precise.  KVM_RUN_LOAD_DEBUGCTL should
*never* be set for TDX and SVM, and so they should WARN instead of silently
doing nothing.  But to do that without generating false positives, the common
check needs to be precise.

I was going to say we could throw a mask in kvm_x86_ops, but TDX throws a wrench
in that idea.  Aha!  Actually, we can still use kvm_x86_ops.  TDX can be exempted
via guest_state_protected.  E.g. in common x86:

	debug_ctl = get_debugctlmsr();
	if (((debug_ctl ^ vcpu->arch.host_debugctl) & kvm_x86_ops.HOST_DEBUGCTL_MASK) &&
	    !vcpu->arch.guest_state_protected)
		run_flags |= KVM_RUN_LOAD_DEBUGCTL;
	vcpu->arch.host_debugctl = debug_ctl;

--
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 20 May 2025 15:37:41 -0700
Subject: [PATCH] KVM: TDX: Use kvm_arch_vcpu.host_debugctl to restore the
 host's DEBUGCTL

Use the kvm_arch_vcpu.host_debugctl snapshot to restore DEBUGCTL after
running a TD vCPU.  The final TDX series rebase was mishandled, likely due
to commit fb71c7959356 ("KVM: x86: Snapshot the host's DEBUGCTL in common
x86") deleting the same line of code from vmx.h, i.e. creating a semantic
conflict of sorts, but no syntactic conflict.

Using the version in kvm_vcpu_arch picks up the ulong => u64 fix (which
isn't relevant to TDX) as well as the IRQ fix from commit 189ecdb3e112
("KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs").

Link: https://lore.kernel.org/all/20250307212053.2948340-10-pbonzini@redhat.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Fixes: 8af099037527 ("KVM: TDX: Save and restore IA32_DEBUGCTL")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/common.h | 2 --
 arch/x86/kvm/vmx/tdx.c    | 6 ++----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 8f46a06e2c44..66454bead202 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -53,8 +53,6 @@ struct vcpu_vt {
 #ifdef CONFIG_X86_64
 	u64		msr_host_kernel_gs_base;
 #endif
-
-	unsigned long	host_debugctlmsr;
 };
 
 #ifdef CONFIG_KVM_INTEL_TDX
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7dbfad28debc..84b2922b8119 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -778,8 +778,6 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	else
 		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
 
-	vt->host_debugctlmsr = get_debugctlmsr();
-
 	vt->guest_state_loaded = true;
 }
 
@@ -1056,8 +1054,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	tdx_vcpu_enter_exit(vcpu);
 
-	if (vt->host_debugctlmsr & ~TDX_DEBUGCTL_PRESERVED)
-		update_debugctlmsr(vt->host_debugctlmsr);
+	if (vcpu->arch.host_debugctl & ~TDX_DEBUGCTL_PRESERVED)
+		update_debugctlmsr(vcpu->arch.host_debugctl);
 
 	tdx_load_host_xsave_state(vcpu);
 	tdx->guest_entered = true;

base-commit: 475a02020ac2de6b10e85de75e79833139b556e0
--

