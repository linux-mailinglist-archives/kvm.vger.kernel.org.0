Return-Path: <kvm+bounces-32609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6307B9DAF23
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27E58282444
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198532036F6;
	Wed, 27 Nov 2024 21:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l/b+TWay"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E84191F75
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 21:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732744679; cv=none; b=PqeQvUjKcAyKCeraq+kI+mfn2Ha+DtKp8qlOOShLkU+BCh+HkcTR3rS0zRV6ia4U1J1uOObUeFNPOvp5/+4HgWYC8iW13qUADxUMywGm1EeEVjzl3qjNylPy11LodbS55n+8oV+dRQFtvAQXGfTBLEtOqJuwE2htH0CfUXOPYMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732744679; c=relaxed/simple;
	bh=yNN1Xk3TccDPadgu5HHWNoACbQdnU49JouU4u5pt+o0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kJg6jVAZ/tqfY+I39pgq1idyn8ASFqxwcjjuTB6+U4kdOkRcQBBTGgamiLi2zzHcpk0UbDgwKQj8MNGACxt3VTw/RvH6HGDlHbRHXrHX6uKXWRtHNGfsxE1t5RQeC97eHutmfH6JNmG1MryczBWxhyRC2pCat+57OPrASyBjjtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l/b+TWay; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea5bf5354fso189848a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 13:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732744676; x=1733349476; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fZw6tsf549gTKLZRA8JHzJn1DPDNehK6P6+Blgyomcc=;
        b=l/b+TWay0SCf1AEjpx2kprwr5xk0m5fDYvmerrkiP2Fdi0277vbNXaCpCbG4jugN1i
         C0gsmJwTGM9XF7bFhQYFXcLphR4uwiohJWhVAIZ356R0N4FbLILRpdQWjac+ow2sUKNF
         SymjhUf537ve2TcOEWmjVy5dVFSO+IwoGHen++rkW2R2cixvu8yeIx1KkEJ6XSZGK4jB
         YQW6B5JwN9ZyW0K/OJBj6doj+l5EU8yDCcXkEKyhReb1UjUy0yl04zHe86I7YbYxUzvV
         eISSu48zUkzH6Fub0hQU/htsNjVaEwXxI2FLUDvkE5UJUgdiasguFniT25W2qwA4pFVr
         KLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732744676; x=1733349476;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZw6tsf549gTKLZRA8JHzJn1DPDNehK6P6+Blgyomcc=;
        b=RnuUvgTxcTvzponNuhOXGlPCdnGJs3oasGnD+vQTDfWeLUxHF2GRqXAB7IS24hg9Fd
         LllFN795gstXVlCWLSUcNE0pi6XwD+NL34hWbW1HMc4o9YSM4OUv2CgvwoikEFYAg/Jf
         3N3VMjtsfRX2X30zuD4gO/4S11IxkOU49mC9DV1MRy15sjjRMm3asH7LyWpB5zGxlJjT
         6ysD72+Y+TRuiDr8Y+C7Jdv6YLT6sSEovzzJpqVnFRekXcMmH2C2B0q7ZQ/7pkG6F+/Z
         4CL2Is6P+GeezNZzoH18tZag/hh/XrqmbDH8mN8S2enuwBT1kjT04v0n0d30KgNhPtS7
         euLw==
X-Gm-Message-State: AOJu0Yze6NL26dp7Uib/9N8wsOSfDUfDOuBEg+sT9ySwwGFwRRHB2set
	zpnGYkG8KE1M2W+NBkJPjvtEwg3CXwBFnfCZoFaPU8bT5afIuxHeaiGsSZhSu+GuN9zB0ytXF/r
	FlQ==
X-Google-Smtp-Source: AGHT+IGlM4KHV5i6GyQaHnw455i3dIIs4L2mY+DuGZSGcezWUH0uIbDIggZAKHWNKNN9QatnkDWSHm4RkHE=
X-Received: from pjbpw2.prod.google.com ([2002:a17:90b:2782:b0:2ea:8aa9:cac7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c01:b0:2ea:98f1:c159
 with SMTP id 98e67ed59e1d1-2ee08e9982bmr5889893a91.1.1732744676154; Wed, 27
 Nov 2024 13:57:56 -0800 (PST)
Date: Wed, 27 Nov 2024 13:57:54 -0800
In-Reply-To: <20241127201929.4005605-13-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com> <20241127201929.4005605-13-aaronlewis@google.com>
Message-ID: <Z0eV4puJ39N8wOf9@google.com>
Subject: Re: [PATCH 12/15] KVM: x86: Track possible passthrough MSRs in kvm_x86_ops
From: Sean Christopherson <seanjc@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com, 
	Xin Li <xin@zytor.com>, Borislav Petkov <bp@alien8.de>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="NN6Sh9wlc+Qhm6Zo"


--NN6Sh9wlc+Qhm6Zo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+Xin, Boris, and Dapeng

On Wed, Nov 27, 2024, Aaron Lewis wrote:
> Move the possible passthrough MSRs to kvm_x86_ops.  Doing this allows
> them to be accessed from common x86 code.

...

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3e8afc82ae2fb..7e9fee4d36cc2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1817,6 +1817,9 @@ struct kvm_x86_ops {
>  	int (*enable_l2_tlb_flush)(struct kvm_vcpu *vcpu);
>  
>  	void (*migrate_timers)(struct kvm_vcpu *vcpu);
> +
> +	const u32 * const possible_passthrough_msrs;
> +	const u32 nr_possible_passthrough_msrs;
>  	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
>  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);

...

> +/*
> + * List of MSRs that can be directly passed to the guest.
> + * In addition to these x2apic, PT and LBR MSRs are handled specially.
> + */
> +static const u32 vmx_possible_passthrough_msrs[] = {
> +	MSR_IA32_SPEC_CTRL,
> +	MSR_IA32_PRED_CMD,
> +	MSR_IA32_FLUSH_CMD,
> +	MSR_IA32_TSC,
> +#ifdef CONFIG_X86_64
> +	MSR_FS_BASE,
> +	MSR_GS_BASE,
> +	MSR_KERNEL_GS_BASE,
> +	MSR_IA32_XFD,
> +	MSR_IA32_XFD_ERR,
> +#endif
> +	MSR_IA32_SYSENTER_CS,
> +	MSR_IA32_SYSENTER_ESP,
> +	MSR_IA32_SYSENTER_EIP,
> +	MSR_CORE_C1_RES,
> +	MSR_CORE_C3_RESIDENCY,
> +	MSR_CORE_C6_RESIDENCY,
> +	MSR_CORE_C7_RESIDENCY,
> +};

Looking at this with fresh eyes, the "possible" passthrough MSR list, and SVM's
direct_access_msrs, are confusing and flat out stupid.  VMX's list isn't the set
of "possible" passthrough MSRs, it's the set of MSRs for which KVM may disable
interceptions without dedicated handling in .msr_filter_changed().  Ditto for
SVM's list, but at least SVM's array uses a slightly less awful name.

Xin Li and Boris have been bikeshedding over the VMX array, and it's all a giant
waste of time.

In all cases, KVM *already knows* which MSRs it wants to pass-through to the
guest.  In a few cases the logic isn't super intuitive, e.g. for SPEC_CTRL, but
it's always fairly easy to understand what KVM wants to do.

Rather than expose the lists to common code, I think we should pivot after
"KVM: SVM: Drop "always" flag from list of possible passthrough MSRs" and rip
them out entirely.

The attached patch is compile-tested only (the nested interactions in particular
need a bit of scrutiny) and needs to be chunked into multiple patches, but I don't
see any obvious blockers, and the diffstats speak volumes:

 arch/x86/include/asm/kvm-x86-ops.h |   2 +-
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/lapic.h               |   2 +
 arch/x86/kvm/svm/svm.c             | 310 ++++++++++++++++++++++++++++++++++++++--------------------------------------------------------------------------------------------
 arch/x86/kvm/svm/svm.h             |   6 ---
 arch/x86/kvm/vmx/main.c            |   2 +-
 arch/x86/kvm/vmx/vmx.c             | 179 ++++++++++++++++++---------------------------------------------------------
 arch/x86/kvm/vmx/vmx.h             |   9 ----
 arch/x86/kvm/vmx/x86_ops.h         |   2 +-
 arch/x86/kvm/x86.c                 |  10 ++++-
 10 files changed, 147 insertions(+), 377 deletions(-)

[*] https://lore.kernel.org/all/20241001050110.3643764-10-xin@zytor.com

--NN6Sh9wlc+Qhm6Zo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-tmp.patch"

From 83928fe0ccd81ac46d48b62ec31580e725998436 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 13:54:37 -0800
Subject: [PATCH] tmp

---
 arch/x86/include/asm/kvm-x86-ops.h |   2 +-
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/lapic.h               |   2 +
 arch/x86/kvm/svm/svm.c             | 310 +++++++++--------------------
 arch/x86/kvm/svm/svm.h             |   6 -
 arch/x86/kvm/vmx/main.c            |   2 +-
 arch/x86/kvm/vmx/vmx.c             | 179 ++++-------------
 arch/x86/kvm/vmx/vmx.h             |   9 -
 arch/x86/kvm/vmx/x86_ops.h         |   2 +-
 arch/x86/kvm/x86.c                 |  10 +-
 10 files changed, 147 insertions(+), 377 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5aff7222e40f..8750fc49434b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -131,7 +131,7 @@ KVM_X86_OP(check_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
 KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
 KVM_X86_OP_OPTIONAL(migrate_timers)
-KVM_X86_OP(msr_filter_changed)
+KVM_X86_OP(refresh_msr_intercepts)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..a0854c1dbb3e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1819,7 +1819,7 @@ struct kvm_x86_ops {
 	int (*enable_l2_tlb_flush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
-	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+	void (*refresh_msr_intercepts)(struct kvm_vcpu *vcpu);
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 24add38beaf0..150fcaa8430f 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -21,6 +21,8 @@
 #define APIC_BROADCAST			0xFF
 #define X2APIC_BROADCAST		0xFFFFFFFFul
 
+#define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
+
 enum lapic_mode {
 	LAPIC_MODE_DISABLED = 0,
 	LAPIC_MODE_INVALID = X2APIC_ENABLE,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3813258497e4..0b2a88251f10 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -79,69 +79,6 @@ static uint64_t osvw_len = 4, osvw_status;
 
 static DEFINE_PER_CPU(u64, current_tsc_ratio);
 
-#define X2APIC_MSR(x)	(APIC_BASE_MSR + (x >> 4))
-
-static const u32 direct_access_msrs[MAX_DIRECT_ACCESS_MSRS] = {
-	MSR_STAR,
-	MSR_IA32_SYSENTER_CS,
-	MSR_IA32_SYSENTER_EIP,
-	MSR_IA32_SYSENTER_ESP,
-#ifdef CONFIG_X86_64
-	MSR_GS_BASE,
-	MSR_FS_BASE,
-	MSR_KERNEL_GS_BASE,
-	MSR_LSTAR,
-	MSR_CSTAR,
-	MSR_SYSCALL_MASK,
-#endif
-	MSR_IA32_SPEC_CTRL,
-	MSR_IA32_PRED_CMD,
-	MSR_IA32_FLUSH_CMD,
-	MSR_IA32_DEBUGCTLMSR,
-	MSR_IA32_LASTBRANCHFROMIP,
-	MSR_IA32_LASTBRANCHTOIP,
-	MSR_IA32_LASTINTFROMIP,
-	MSR_IA32_LASTINTTOIP,
-	MSR_IA32_XSS,
-	MSR_EFER,
-	MSR_IA32_CR_PAT,
-	MSR_AMD64_SEV_ES_GHCB,
-	MSR_TSC_AUX,
-	X2APIC_MSR(APIC_ID),
-	X2APIC_MSR(APIC_LVR),
-	X2APIC_MSR(APIC_TASKPRI),
-	X2APIC_MSR(APIC_ARBPRI),
-	X2APIC_MSR(APIC_PROCPRI),
-	X2APIC_MSR(APIC_EOI),
-	X2APIC_MSR(APIC_RRR),
-	X2APIC_MSR(APIC_LDR),
-	X2APIC_MSR(APIC_DFR),
-	X2APIC_MSR(APIC_SPIV),
-	X2APIC_MSR(APIC_ISR),
-	X2APIC_MSR(APIC_TMR),
-	X2APIC_MSR(APIC_IRR),
-	X2APIC_MSR(APIC_ESR),
-	X2APIC_MSR(APIC_ICR),
-	X2APIC_MSR(APIC_ICR2),
-
-	/*
-	 * Note:
-	 * AMD does not virtualize APIC TSC-deadline timer mode, but it is
-	 * emulated by KVM. When setting APIC LVTT (0x832) register bit 18,
-	 * the AVIC hardware would generate GP fault. Therefore, always
-	 * intercept the MSR 0x832, and do not setup direct_access_msr.
-	 */
-	X2APIC_MSR(APIC_LVTTHMR),
-	X2APIC_MSR(APIC_LVTPC),
-	X2APIC_MSR(APIC_LVT0),
-	X2APIC_MSR(APIC_LVT1),
-	X2APIC_MSR(APIC_LVTERR),
-	X2APIC_MSR(APIC_TMICT),
-	X2APIC_MSR(APIC_TMCCT),
-	X2APIC_MSR(APIC_TDCR),
-	MSR_INVALID,
-};
-
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * pause_filter_count: On processors that support Pause filtering(indicated
@@ -756,18 +693,6 @@ static void clr_dr_intercepts(struct vcpu_svm *svm)
 	recalc_intercepts(svm);
 }
 
-static int direct_access_msr_slot(u32 msr)
-{
-	u32 i;
-
-	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
-		if (direct_access_msrs[i] == msr)
-			return i;
-	}
-
-	return -ENOENT;
-}
-
 static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
 	u8 bit_write;
@@ -831,17 +756,6 @@ BUILD_SVM_MSR_BITMAP_HELPER(svm_clear_msr_bitmap_write, __clear_bit, write)
 void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	int slot;
-
-	slot = direct_access_msr_slot(msr);
-	WARN_ON(slot == -ENOENT);
-	if (slot >= 0) {
-		/* Set the shadow bitmaps to the desired intercept states */
-		if (type & MSR_TYPE_R)
-			__clear_bit(slot, svm->shadow_msr_intercept.read);
-		if (type & MSR_TYPE_W)
-			__clear_bit(slot, svm->shadow_msr_intercept.write);
-	}
 
 	/*
 	 * Don't disabled interception for the MSR if userspace wants to
@@ -870,17 +784,6 @@ void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	int slot;
-
-	slot = direct_access_msr_slot(msr);
-	WARN_ON(slot == -ENOENT);
-	if (slot >= 0) {
-		/* Set the shadow bitmaps to the desired intercept states */
-		if (type & MSR_TYPE_R)
-			__set_bit(slot, svm->shadow_msr_intercept.read);
-		if (type & MSR_TYPE_W)
-			__set_bit(slot, svm->shadow_msr_intercept.write);
-	}
 
 	if (type & MSR_TYPE_R)
 		svm_set_msr_bitmap_read(vcpu, msr);
@@ -907,6 +810,20 @@ unsigned long *svm_vcpu_alloc_msrpm(void)
 	return msrpm;
 }
 
+static void svm_refresh_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
+{
+	bool intercept = !(to_svm(vcpu)->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
+
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTINTFROMIP, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTINTTOIP, MSR_TYPE_RW, intercept);
+
+	if (sev_es_guest(vcpu->kvm))
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW, intercept);
+
+}
+
 void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, unsigned long *msrpm)
 {
 	svm_disable_intercept_for_msr(vcpu, MSR_STAR, MSR_TYPE_RW);
@@ -924,8 +841,76 @@ void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, unsigned long *msrpm)
 		svm_disable_intercept_for_msr(vcpu, MSR_AMD64_SEV_ES_GHCB, MSR_TYPE_RW);
 }
 
+static void svm_refresh_msr_intercepts(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
+
+	if (lbrv)
+		svm_refresh_lbr_msr_intercepts(vcpu);
+
+	if (boot_cpu_has(X86_FEATURE_IBPB) && guest_has_pred_cmd_msr(vcpu))
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
+
+	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D) && guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
+
+	/*
+	 * If the host supports V_SPEC_CTRL then disable the interception
+	 * of MSR_IA32_SPEC_CTRL.
+	 */
+	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
+	else
+		svm_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW, !svm->spec_ctrl);
+
+	/*
+	 * Intercept SYSENTER_EIP and SYSENTER_ESP when emulating an Intel CPU,
+	 * as AMD hardware only store 32 bits, whereas Intel CPUs track 64 bits.
+	 */
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW,
+				  guest_cpuid_is_intel_compatible(vcpu));
+	svm_set_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW,
+				  guest_cpuid_is_intel_compatible(vcpu));
+}
+
 void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 {
+	static const u32 x2avic_passthrough_msrs[] = {
+		X2APIC_MSR(APIC_ID),
+		X2APIC_MSR(APIC_LVR),
+		X2APIC_MSR(APIC_TASKPRI),
+		X2APIC_MSR(APIC_ARBPRI),
+		X2APIC_MSR(APIC_PROCPRI),
+		X2APIC_MSR(APIC_EOI),
+		X2APIC_MSR(APIC_RRR),
+		X2APIC_MSR(APIC_LDR),
+		X2APIC_MSR(APIC_DFR),
+		X2APIC_MSR(APIC_SPIV),
+		X2APIC_MSR(APIC_ISR),
+		X2APIC_MSR(APIC_TMR),
+		X2APIC_MSR(APIC_IRR),
+		X2APIC_MSR(APIC_ESR),
+		X2APIC_MSR(APIC_ICR),
+		X2APIC_MSR(APIC_ICR2),
+
+		/*
+		* Note:
+		* AMD does not virtualize APIC TSC-deadline timer mode, but it is
+		* emulated by KVM. When setting APIC LVTT (0x832) register bit 18,
+		* the AVIC hardware would generate GP fault. Therefore, always
+		* intercept the MSR 0x832, and do not setup direct_access_msr.
+		*/
+		X2APIC_MSR(APIC_LVTTHMR),
+		X2APIC_MSR(APIC_LVTPC),
+		X2APIC_MSR(APIC_LVT0),
+		X2APIC_MSR(APIC_LVT1),
+		X2APIC_MSR(APIC_LVTERR),
+		X2APIC_MSR(APIC_TMICT),
+		X2APIC_MSR(APIC_TMCCT),
+		X2APIC_MSR(APIC_TDCR),
+	};
 	int i;
 
 	if (intercept == svm->x2avic_msrs_intercepted)
@@ -934,15 +919,9 @@ void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool intercept)
 	if (!x2avic_enabled)
 		return;
 
-	for (i = 0; i < MAX_DIRECT_ACCESS_MSRS; i++) {
-		int index = direct_access_msrs[i];
-
-		if ((index < APIC_BASE_MSR) ||
-		    (index > APIC_BASE_MSR + 0xff))
-			continue;
-
-		svm_set_intercept_for_msr(&svm->vcpu, index, MSR_TYPE_RW, intercept);
-	}
+	for (i = 0; i < ARRAY_SIZE(x2avic_passthrough_msrs); i++)
+		svm_set_intercept_for_msr(&svm->vcpu, x2avic_passthrough_msrs[i],
+					  MSR_TYPE_RW, intercept);
 
 	svm->x2avic_msrs_intercepted = intercept;
 }
@@ -952,73 +931,6 @@ void svm_vcpu_free_msrpm(unsigned long *msrpm)
 	__free_pages(virt_to_page(msrpm), get_order(MSRPM_SIZE));
 }
 
-static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 i;
-
-	/*
-	 * Redo intercept permissions for MSRs that KVM is passing through to
-	 * the guest.  Disabling interception will check the new MSR filter and
-	 * ensure that KVM enables interception if usersepace wants to filter
-	 * the MSR.  MSRs that KVM is already intercepting don't need to be
-	 * refreshed since KVM is going to intercept them regardless of what
-	 * userspace wants.
-	 */
-	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
-		u32 msr = direct_access_msrs[i];
-
-		if (!test_bit(i, svm->shadow_msr_intercept.read))
-			svm_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_R);
-
-		if (!test_bit(i, svm->shadow_msr_intercept.write))
-			svm_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_W);
-	}
-}
-
-static void add_msr_offset(u32 offset)
-{
-	int i;
-
-	for (i = 0; i < MSRPM_OFFSETS; ++i) {
-
-		/* Offset already in list? */
-		if (msrpm_offsets[i] == offset)
-			return;
-
-		/* Slot used by another offset? */
-		if (msrpm_offsets[i] != MSR_INVALID)
-			continue;
-
-		/* Add offset to list */
-		msrpm_offsets[i] = offset;
-
-		return;
-	}
-
-	/*
-	 * If this BUG triggers the msrpm_offsets table has an overflow. Just
-	 * increase MSRPM_OFFSETS in this case.
-	 */
-	BUG();
-}
-
-static void init_msrpm_offsets(void)
-{
-	int i;
-
-	memset(msrpm_offsets, 0xff, sizeof(msrpm_offsets));
-
-	for (i = 0; direct_access_msrs[i] != MSR_INVALID; i++) {
-		u32 offset;
-
-		offset = svm_msrpm_offset(direct_access_msrs[i]);
-		BUG_ON(offset == MSR_INVALID);
-
-		add_msr_offset(offset);
-	}
-}
-
 void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
 {
 	to_vmcb->save.dbgctl		= from_vmcb->save.dbgctl;
@@ -1035,13 +947,7 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTINTFROMIP, MSR_TYPE_RW);
-	svm_disable_intercept_for_msr(vcpu, MSR_IA32_LASTINTTOIP, MSR_TYPE_RW);
-
-	if (sev_es_guest(vcpu->kvm))
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_DEBUGCTLMSR, MSR_TYPE_RW);
+	svm_refresh_lbr_msr_intercepts(vcpu);
 
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
 	if (is_guest_mode(vcpu))
@@ -1053,12 +959,8 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
-
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW);
-	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW);
-	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTINTFROMIP, MSR_TYPE_RW);
-	svm_enable_intercept_for_msr(vcpu, MSR_IA32_LASTINTTOIP, MSR_TYPE_RW);
+	svm_refresh_lbr_msr_intercepts(vcpu);
 
 	/*
 	 * Move the LBR msrs back to the vmcb01 to avoid copying them
@@ -1241,17 +1143,9 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (guest_cpuid_is_intel_compatible(vcpu)) {
-		/*
-		 * We must intercept SYSENTER_EIP and SYSENTER_ESP
-		 * accesses because the processor only stores 32 bits.
-		 * For the same reason we cannot use virtual VMLOAD/VMSAVE.
-		 */
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
 		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
-
-		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-		svm_enable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -1262,9 +1156,6 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
-		/* No need to intercept these MSRs */
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	}
 }
 
@@ -1388,13 +1279,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
-	/*
-	 * If the host supports V_SPEC_CTRL then disable the interception
-	 * of MSR_IA32_SPEC_CTRL.
-	 */
-	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
-
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -1422,8 +1306,6 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
-
 	svm_init_osvw(vcpu);
 
 	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_STUFF_FEATURE_MSRS))
@@ -1448,6 +1330,7 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		sev_snp_init_protected_guest_state(vcpu);
 
 	init_vmcb(vcpu);
+	svm_refresh_msr_intercepts(vcpu);
 
 	if (!init_event)
 		__svm_vcpu_reset(vcpu);
@@ -1488,10 +1371,6 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		goto error_free_vmsa_page;
 
-	/* All MSRs start out in the "intercepted" state. */
-	bitmap_fill(svm->shadow_msr_intercept.read, MAX_DIRECT_ACCESS_MSRS);
-	bitmap_fill(svm->shadow_msr_intercept.write, MAX_DIRECT_ACCESS_MSRS);
-
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
@@ -3193,8 +3072,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		/*
 		 * TSC_AUX is usually changed only during boot and never read
-		 * directly.  Intercept TSC_AUX instead of exposing it to the
-		 * guest via direct_access_msrs, and switch it via user return.
+		 * directly.  Intercept TSC_AUX and switch it via user return.
 		 */
 		preempt_disable();
 		ret = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
@@ -4465,12 +4343,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
-	if (boot_cpu_has(X86_FEATURE_IBPB) && guest_has_pred_cmd_msr(vcpu))
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
-
-	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D) && guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
-		svm_disable_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
-
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
 
@@ -5166,7 +5038,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
-	.msr_filter_changed = svm_msr_filter_changed,
+	.refresh_msr_intercepts = svm_refresh_msr_intercepts,
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
@@ -5324,8 +5196,6 @@ static __init int svm_hardware_setup(void)
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
 	iopm_base = __sme_page_pa(iopm_pages);
 
-	init_msrpm_offsets();
-
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
 				     XFEATURE_MASK_BNDCSR);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2513990c5b6e..a73da8ca73b4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -313,12 +313,6 @@ struct vcpu_svm {
 	struct list_head ir_list;
 	spinlock_t ir_list_lock;
 
-	/* Save desired MSR intercept (read: pass-through) state */
-	struct {
-		DECLARE_BITMAP(read, MAX_DIRECT_ACCESS_MSRS);
-		DECLARE_BITMAP(write, MAX_DIRECT_ACCESS_MSRS);
-	} shadow_msr_intercept;
-
 	struct vcpu_sev_es_state sev_es;
 
 	bool guest_state_loaded;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 92d35cc6cd15..915df0f5f1eb 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -152,7 +152,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-	.msr_filter_changed = vmx_msr_filter_changed,
+	.refresh_msr_intercepts = vmx_refresh_msr_intercepts,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0701bf32e59e..88f71b66e673 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -163,31 +163,6 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 	RTIT_STATUS_ERROR | RTIT_STATUS_STOPPED | \
 	RTIT_STATUS_BYTECNT))
 
-/*
- * List of MSRs that can be directly passed to the guest.
- * In addition to these x2apic, PT and LBR MSRs are handled specially.
- */
-static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
-	MSR_IA32_SPEC_CTRL,
-	MSR_IA32_PRED_CMD,
-	MSR_IA32_FLUSH_CMD,
-	MSR_IA32_TSC,
-#ifdef CONFIG_X86_64
-	MSR_FS_BASE,
-	MSR_GS_BASE,
-	MSR_KERNEL_GS_BASE,
-	MSR_IA32_XFD,
-	MSR_IA32_XFD_ERR,
-#endif
-	MSR_IA32_SYSENTER_CS,
-	MSR_IA32_SYSENTER_ESP,
-	MSR_IA32_SYSENTER_EIP,
-	MSR_CORE_C1_RES,
-	MSR_CORE_C3_RESIDENCY,
-	MSR_CORE_C6_RESIDENCY,
-	MSR_CORE_C7_RESIDENCY,
-};
-
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
  * ple_gap:    upper bound on the amount of time between two successive
@@ -669,40 +644,6 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static int vmx_get_passthrough_msr_slot(u32 msr)
-{
-	int i;
-
-	switch (msr) {
-	case 0x800 ... 0x8ff:
-		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
-		return -ENOENT;
-	case MSR_IA32_RTIT_STATUS:
-	case MSR_IA32_RTIT_OUTPUT_BASE:
-	case MSR_IA32_RTIT_OUTPUT_MASK:
-	case MSR_IA32_RTIT_CR3_MATCH:
-	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
-		/* PT MSRs. These are handled in pt_update_intercept_for_msr() */
-	case MSR_LBR_SELECT:
-	case MSR_LBR_TOS:
-	case MSR_LBR_INFO_0 ... MSR_LBR_INFO_0 + 31:
-	case MSR_LBR_NHM_FROM ... MSR_LBR_NHM_FROM + 31:
-	case MSR_LBR_NHM_TO ... MSR_LBR_NHM_TO + 31:
-	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
-	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
-		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
-		return -ENOENT;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
-		if (vmx_possible_passthrough_msrs[i] == msr)
-			return i;
-	}
-
-	WARN(1, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
-	return -ENOENT;
-}
-
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
@@ -4002,25 +3943,12 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
-	int idx;
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
 	vmx_msr_bitmap_l01_changed(vmx);
 
-	/*
-	 * Mark the desired intercept state in shadow bitmap, this is needed
-	 * for resync when the MSR filters change.
-	 */
-	idx = vmx_get_passthrough_msr_slot(msr);
-	if (idx >= 0) {
-		if (type & MSR_TYPE_R)
-			__clear_bit(idx, vmx->shadow_msr_intercept.read);
-		if (type & MSR_TYPE_W)
-			__clear_bit(idx, vmx->shadow_msr_intercept.write);
-	}
-
 	if ((type & MSR_TYPE_R) &&
 	    !kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_READ)) {
 		vmx_set_msr_bitmap_read(msr_bitmap, msr);
@@ -4044,25 +3972,12 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
-	int idx;
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
 	vmx_msr_bitmap_l01_changed(vmx);
 
-	/*
-	 * Mark the desired intercept state in shadow bitmap, this is needed
-	 * for resync when the MSR filter changes.
-	 */
-	idx = vmx_get_passthrough_msr_slot(msr);
-	if (idx >= 0) {
-		if (type & MSR_TYPE_R)
-			__set_bit(idx, vmx->shadow_msr_intercept.read);
-		if (type & MSR_TYPE_W)
-			__set_bit(idx, vmx->shadow_msr_intercept.write);
-	}
-
 	if (type & MSR_TYPE_R)
 		vmx_set_msr_bitmap_read(msr_bitmap, msr);
 
@@ -4146,35 +4061,54 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
-void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
+void vmx_refresh_msr_intercepts(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 i;
-
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
 
-	/*
-	 * Redo intercept permissions for MSRs that KVM is passing through to
-	 * the guest.  Disabling interception will check the new MSR filter and
-	 * ensure that KVM enables interception if usersepace wants to filter
-	 * the MSR.  MSRs that KVM is already intercepting don't need to be
-	 * refreshed since KVM is going to intercept them regardless of what
-	 * userspace wants.
-	 */
-	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
-		u32 msr = vmx_possible_passthrough_msrs[i];
-
-		if (!test_bit(i, vmx->shadow_msr_intercept.read))
-			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_R);
-
-		if (!test_bit(i, vmx->shadow_msr_intercept.write))
-			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_W);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
+#ifdef CONFIG_X86_64
+	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+#endif
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+	if (kvm_cstate_in_guest(vcpu->kvm)) {
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
 	}
 
 	/* PT MSRs can be passed through iff PT is exposed to the guest. */
 	if (vmx_pt_mode_is_host_guest())
 		pt_update_intercept_for_msr(vcpu);
+
+	if (vcpu->arch.xfd_no_write_intercept)
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW);
+
+
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
+				  !to_vmx(vcpu)->spec_ctrl);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
+					  !guest_cpuid_has(vcpu, X86_FEATURE_XFD));
+
+	if (boot_cpu_has(X86_FEATURE_IBPB))
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
+					  !guest_has_pred_cmd_msr(vcpu));
+
+	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
+					  !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
+
+	/*
+	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
+	 * filtered by userspace.
+	 */
 }
 
 static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
@@ -7566,26 +7500,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 		evmcs->hv_enlightenments_control.msr_bitmap = 1;
 	}
 
-	/* The MSR bitmap starts with all ones */
-	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-
-	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
-#ifdef CONFIG_X86_64
-	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
-#endif
-	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-	if (kvm_cstate_in_guest(vcpu->kvm)) {
-		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
-	}
-
 	vmx->loaded_vmcs = &vmx->vmcs01;
 
 	if (cpu_need_virtualize_apic_accesses(vcpu)) {
@@ -7866,18 +7780,6 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
-		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
-					  !guest_cpuid_has(vcpu, X86_FEATURE_XFD));
-
-	if (boot_cpu_has(X86_FEATURE_IBPB))
-		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
-					  !guest_has_pred_cmd_msr(vcpu));
-
-	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
-		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
-					  !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
-
 	set_cr4_guest_host_mask(vmx);
 
 	vmx_write_encls_bitmap(vcpu, NULL);
@@ -7893,6 +7795,9 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx->msr_ia32_feature_control_valid_bits &=
 			~FEAT_CTL_SGX_LC_ENABLED;
 
+	/* Refresh MSR interception to account for feature changes. */
+	vmx_refresh_msr_intercepts(vcpu);
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 43f573f6ca46..d38f39935a52 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -17,8 +17,6 @@
 #include "run_flags.h"
 #include "../mmu.h"
 
-#define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
-
 #ifdef CONFIG_X86_64
 #define MAX_NR_USER_RETURN_MSRS	7
 #else
@@ -353,13 +351,6 @@ struct vcpu_vmx {
 	struct pt_desc pt_desc;
 	struct lbr_desc lbr_desc;
 
-	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
-	struct {
-		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-	} shadow_msr_intercept;
-
 	/* ve_info must be page aligned. */
 	struct vmx_ve_information *ve_info;
 };
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index a55981c5216e..ee16bbdd9a3e 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -54,7 +54,7 @@ void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
 void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
 bool vmx_has_emulated_msr(struct kvm *kvm, u32 index);
-void vmx_msr_filter_changed(struct kvm_vcpu *vcpu);
+void vmx_refresh_msr_intercepts(struct kvm_vcpu *vcpu);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 int vmx_get_feature_msr(u32 msr, u64 *data);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e713480933a..5d4e049e5725 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10840,8 +10840,16 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_update_apicv(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
+
+		/*
+		 * Refresh intercept permissions for MSRs that KVM is passing
+		 * through to the guest, as userspace may want to trap accesses.
+		 * Disabling interception will check the new MSR filter and
+		 * ensure that KVM enables interception if usersepace wants to
+		 * filter the MSR.
+		 */
 		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
-			kvm_x86_call(msr_filter_changed)(vcpu);
+			kvm_x86_call(refresh_msr_intercepts)(vcpu);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			kvm_x86_call(update_cpu_dirty_logging)(vcpu);

base-commit: c109f5c273abb98684209280d4b07d596ee6a54a
-- 
2.47.0.338.g60cca15819-goog


--NN6Sh9wlc+Qhm6Zo--

