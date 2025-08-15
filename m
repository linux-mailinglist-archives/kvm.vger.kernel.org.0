Return-Path: <kvm+bounces-54722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0BFB27399
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9401B613DD
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D27B24C076;
	Fri, 15 Aug 2025 00:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QwOlrUiV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F25233D9C
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216774; cv=none; b=AAhtO+qBtxSgYDQcf4dghV8VeRF2z71kRmGa/80TwI311EnSpc8gOHUQ2tRNaHR6JjGa3TQWV8s0V+XUyrskWY3IA3LjsEkNO6babcoVVqITDlU3VQ5wAdmB2rAzRhMFFeXo+cLzvF4jSRLRGBxWxnqqP9wOP22BAyw+OiycItc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216774; c=relaxed/simple;
	bh=lOvxPSaxtzgfnLuwRx2Czq523miEVYErN+utCgJz7BI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TZ+q1w8guEUlmKRijbqc1Zojs6rQbeNXCHIeOb3ADJdvDV2sFPm+efILeukfZCVXAfJIPQBRnOSGjO+LS7L4NEbJyYeYY1J0KbL1KhXTOdOfbncEqcmpV93S/f4cgEGlgMl5HZhPPVJBA5mdykk0BYtva8mQlT2bU0eBmZsxhT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QwOlrUiV; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458067fdeso15742435ad.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216771; x=1755821571; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=c13NaN+YXr/BX/bGMCHRTcbQakErEGNzfF6KpN+Ic+4=;
        b=QwOlrUiVLfUaXvMjPoOdPjIu57klsuoccp+JjbjCBykkf9YoZLPb3BvZPNyFQEf6lb
         BF4SktIuxPxZtuZrYGfHuklkc1NDcTwT9PrZdWyvn+LnKI/UOAdnQU9L0Xw3U9elxuaN
         a/xcpgCn4wsjGffNfD/TaTGFoNDatoP2U26kIFOjVgG21K5+fyECezlMrgBWrrAr5zHu
         iRTIlubrNm7GTKw5CClp0wFJg7PCOBRIkVkWBQvlOOMqVYujhVlU0bRIKyxRFkYCKL15
         XhzV7A+8O1IjUYd4EMnfJW/C0qt++iF8JuYQ9/wUaBIC4gBkq+ri+KDcMNInVdPJ6chL
         KnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216771; x=1755821571;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c13NaN+YXr/BX/bGMCHRTcbQakErEGNzfF6KpN+Ic+4=;
        b=nhIuXhAzQmtdLZfOjwplD3CoYRBbOfydM3cXVrwKgqoyMJS7Wh8SX7UHXih/IPzx8w
         V0G285OR9Jy0kGCrWZBHG1epzmdQgki7AH4KpsyBYBxr9X0/ze584w6zI4a5UgENl+3T
         3jQUgsGFGpd4YqhxaH7BQhr0GO98kq+qX3nDliiVBpG2BckYwz6nUDZDPw2pi9BJ1lxe
         AOsIKQ/kPuaoPavrhKDbsJas7gcKwzcTyDAnn6hfJYDmX1YE+VfFIgyz3zz3wvfMEqCU
         Evh2X6vrDEgvsfXfwWqdkFNHLWY5aGPm6xgY237YWanrir/9Gpeapxs7pAUVFHUzOWvN
         6rnw==
X-Gm-Message-State: AOJu0Yx/ttxWwZgBYowsGWck6YLFDGA2t9NvGPRv2kgT97aGqAnXHx7J
	vuNiuESDhyj+mG+deQVLhWmKX43SKltT31tTJ5Io+EjTuc5RJSnKjJnVOlO4Jc5Ahej24TNysxE
	sXdSh2w==
X-Google-Smtp-Source: AGHT+IHQ8AGbnn6QCZLFRxGDCTZzOhReMkq4QJBU0f701KawomGbTYhx5V2Jp8mxit55/TGINdvLjXyC+B8=
X-Received: from pjbsb5.prod.google.com ([2002:a17:90b:50c5:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:fab:b0:23f:f6ca:6a3
 with SMTP id d9443c01a7336-2446d8f561dmr1329135ad.43.1755216770682; Thu, 14
 Aug 2025 17:12:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:12:05 -0700
In-Reply-To: <20250815001205.2370711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815001205.2370711-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815001205.2370711-22-seanjc@google.com>
Subject: [PATCH 6.1.y 21/21] KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM
 while running the guest
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 6b1dd26544d045f6a79e8c73572c0c0db3ef3c1a ]

Set/clear DEBUGCTLMSR_FREEZE_IN_SMM in GUEST_IA32_DEBUGCTL based on the
host's pre-VM-Enter value, i.e. preserve the host's FREEZE_IN_SMM setting
while running the guest.  When running with the "default treatment of SMIs"
in effect (the only mode KVM supports), SMIs do not generate a VM-Exit that
is visible to host (non-SMM) software, and instead transitions directly
from VMX non-root to SMM.  And critically, DEBUGCTL isn't context switched
by hardware on SMI or RSM, i.e. SMM will run with whatever value was
resident in hardware at the time of the SMI.

Failure to preserve FREEZE_IN_SMM results in the PMU unexpectedly counting
events while the CPU is executing in SMM, which can pollute profiling and
potentially leak information into the guest.

Check for changes in FREEZE_IN_SMM prior to every entry into KVM's inner
run loop, as the bit can be toggled in IRQ context via IPI callback (SMP
function call), by way of /sys/devices/cpu/freeze_on_smi.

Add a field in kvm_x86_ops to communicate which DEBUGCTL bits need to be
preserved, as FREEZE_IN_SMM is only supported and defined for Intel CPUs,
i.e. explicitly checking FREEZE_IN_SMM in common x86 is at best weird, and
at worst could lead to undesirable behavior in the future if AMD CPUs ever
happened to pick up a collision with the bit.

Exempt TDX vCPUs, i.e. protected guests, from the check, as the TDX Module
owns and controls GUEST_IA32_DEBUGCTL.

WARN in SVM if KVM_RUN_LOAD_DEBUGCTL is set, mostly to document that the
lack of handling isn't a KVM bug (TDX already WARNs on any run_flag).

Lastly, explicitly reload GUEST_IA32_DEBUGCTL on a VM-Fail that is missed
by KVM but detected by hardware, i.e. in nested_vmx_restore_host_state().
Doing so avoids the need to track host_debugctl on a per-VMCS basis, as
GUEST_IA32_DEBUGCTL is unconditionally written by prepare_vmcs02() and
load_vmcs12_host_state().  For the VM-Fail case, even though KVM won't
have actually entered the guest, vcpu_enter_guest() will have run with
vmcs02 active and thus could result in vmcs01 being run with a stale value.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250610232010.162191-9-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: move vmx/main.c change to vmx/vmx.c]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/kvm/vmx/nested.c       |  3 +++
 arch/x86/kvm/vmx/vmx.c          |  5 +++++
 arch/x86/kvm/vmx/vmx.h          | 15 ++++++++++++++-
 arch/x86/kvm/x86.c              | 14 ++++++++++++--
 5 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c8fc4f2acf69..d0229323ca63 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1459,6 +1459,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 enum kvm_x86_run_flags {
 	KVM_RUN_FORCE_IMMEDIATE_EXIT	= BIT(0),
 	KVM_RUN_LOAD_GUEST_DR6		= BIT(1),
+	KVM_RUN_LOAD_DEBUGCTL		= BIT(2),
 };
 
 struct kvm_x86_ops {
@@ -1484,6 +1485,12 @@ struct kvm_x86_ops {
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
+	/*
+	 * Mask of DEBUGCTL bits that are owned by the host, i.e. that need to
+	 * match the host's value even while the guest is active.
+	 */
+	const u64 HOST_OWNED_DEBUGCTL;
+
 	void (*update_exception_bitmap)(struct kvm_vcpu *vcpu);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a220770644e1..2c3cf4351c4c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4627,6 +4627,9 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 			WARN_ON(kvm_set_dr(vcpu, 7, vmcs_readl(GUEST_DR7)));
 	}
 
+	/* Reload DEBUGCTL to ensure vmcs01 has a fresh FREEZE_IN_SMM value. */
+	vmx_reload_guest_debugctl(vcpu);
+
 	/*
 	 * Note that calling vmx_set_{efer,cr0,cr4} is important as they
 	 * handle a variety of side effects to KVM's software model.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e470a294b22d..3fef4e14abc6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7258,6 +7258,9 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (run_flags & KVM_RUN_LOAD_GUEST_DR6)
 		set_debugreg(vcpu->arch.dr6, 6);
 
+	if (run_flags & KVM_RUN_LOAD_DEBUGCTL)
+		vmx_reload_guest_debugctl(vcpu);
+
 	/*
 	 * Refresh vmcs.HOST_CR3 if necessary.  This must be done immediately
 	 * prior to VM-Enter, as the kernel may load a new ASID (PCID) any time
@@ -8197,6 +8200,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
+	.HOST_OWNED_DEBUGCTL = DEBUGCTLMSR_FREEZE_IN_SMM,
+
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_msr_feature = vmx_get_msr_feature,
 	.get_msr = vmx_get_msr,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b7ae263cde7b..dc6f06326648 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -447,12 +447,25 @@ bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
 
 static inline void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val)
 {
+	WARN_ON_ONCE(val & DEBUGCTLMSR_FREEZE_IN_SMM);
+
+	val |= vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM;
 	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
 }
 
 static inline u64 vmx_guest_debugctl_read(void)
 {
-	return vmcs_read64(GUEST_IA32_DEBUGCTL);
+	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~DEBUGCTLMSR_FREEZE_IN_SMM;
+}
+
+static inline void vmx_reload_guest_debugctl(struct kvm_vcpu *vcpu)
+{
+	u64 val = vmcs_read64(GUEST_IA32_DEBUGCTL);
+
+	if (!((val ^ vcpu->arch.host_debugctl) & DEBUGCTLMSR_FREEZE_IN_SMM))
+		return;
+
+	vmx_guest_debugctl_write(vcpu, val & ~DEBUGCTLMSR_FREEZE_IN_SMM);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e7253972ea..f542ab5e8698 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10591,7 +10591,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 	fastpath_t exit_fastpath;
-	u64 run_flags;
+	u64 run_flags, debug_ctl;
 
 	bool req_immediate_exit = false;
 
@@ -10838,7 +10838,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
-	vcpu->arch.host_debugctl = get_debugctlmsr();
+	/*
+	 * Refresh the host DEBUGCTL snapshot after disabling IRQs, as DEBUGCTL
+	 * can be modified in IRQ context, e.g. via SMP function calls.  Inform
+	 * vendor code if any host-owned bits were changed, e.g. so that the
+	 * value loaded into hardware while running the guest can be updated.
+	 */
+	debug_ctl = get_debugctlmsr();
+	if ((debug_ctl ^ vcpu->arch.host_debugctl) & kvm_x86_ops.HOST_OWNED_DEBUGCTL &&
+	    !vcpu->arch.guest_state_protected)
+		run_flags |= KVM_RUN_LOAD_DEBUGCTL;
+	vcpu->arch.host_debugctl = debug_ctl;
 
 	guest_timing_enter_irqoff();
 
-- 
2.51.0.rc1.163.g2494970778-goog


