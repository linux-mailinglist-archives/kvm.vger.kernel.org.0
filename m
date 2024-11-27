Return-Path: <kvm+bounces-32598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB6C9DAE79
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91105167093
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E6C204084;
	Wed, 27 Nov 2024 20:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AVcQH1o8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03233203718
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738810; cv=none; b=nl58b4z3YIH/Zk/P6gzoU9ilxa/mBPaJj+Fc2ll6W4IR/c9N+ifFcHzaghuzVmtv4/zrSN97IqLNdAR3YlyTjurMP4P/eTFZYTKOGfOJlCiCkzt9e7q8uYhwTXK5Pk6617uRF+U8anjLYl19SgQRnnsYkNr/hYej36v2DSSkbEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738810; c=relaxed/simple;
	bh=5yCIHfL6l2qkR7DUG3ULusr8QF1ROkRn5VWELBESHeY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M0bcPtiPI3iN94G1m0PvW7i9mD5rLNq8KkVO7PqjfpWcOg82tqeAI4Ovs/TtBhESwI3Nl/H0M0mLmzJC6aftuCv2TPkEwfBF1zBmvaAbXxS+c9P7paruUcDqBmUHy0Gq2uFEBzDF+ZFEy6oxhVb4m/YqOMkp7E4b1ybL6X0nyM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AVcQH1o8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2edeef8a994so142676a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738808; x=1733343608; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hN4rCKuG9RjUkutHBlEkAp/6p8hoxoVrTp3+V8iwhZU=;
        b=AVcQH1o8nWoPVrYdDs8+JB10kT3AJbNVm+5FJxNuspTLWgSCHweSchrFn3NFH44zm8
         TQxerl1WVJB3dfIElj+pEcSkjCCKFrleH8GK3mBpD5zWTGwRLu7fUI3iSMibtb9laD/E
         r0AybRJBjMWIanhSO1W/aqYVh2vZHUwACnQ/b/IKCPzk3YmSenYRRtU8opiRm/mR2Hjf
         qcvdB6KHo4NESVGOb2ijSPoHCnX8uAcB2Y1F9vBafq/pptxK4fo0RkuH0ByTRzI6of+a
         xZWYatwL0ZLTYAn5vNkA0Y+lksB2Wye2iTnk5geZTuGChaR2ezDxMrYouc4nNVn0+HHC
         bthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738808; x=1733343608;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hN4rCKuG9RjUkutHBlEkAp/6p8hoxoVrTp3+V8iwhZU=;
        b=CJDDHGN17e5gIk6GUlTBeZJ2bL7H718VKJckCud9DgkjD55sqbOmdk2orrAc/Xx8Wg
         acC0WA+gT9ceCMfQD4SLya8wfJIpSR6JivtjF0yU6afo4/gil3BGP97yxPB5FFN6I1E0
         lF6EuuZFOvH/axLEarpY6382jOGj5W2JWswd1bOk4OjOesr0nD9MC01/Apx6TTEczINe
         y85qCRzsKi3hIVidI+gBwjyIjb7VU+SE/3osNVfp0pfjFkk8w3rjwo+xp1atmti6/FxF
         Rcs4+zRnSdt1RIpHQj9GvazOgDhil/tRvDjoB1Slm5C7ZoHytIQEuS2zMLHoJD/sP44m
         uYcg==
X-Gm-Message-State: AOJu0YxXn7+AEDT+cKKxVffsmQvjg4/CsWvbtOazxqmxPEuRNl1QO2xN
	iYZrxa8bt5i//paHUArayX5JvlwilXxPhnHZi4CB+j0rT83TB0i88zYMwqcq7pTy13VNdHUx99q
	5QXmf6sVYHuFGybG+urbmTl4zouF+VA+EKjk9keCXb5aGrtXI89uqVHZ6VwCiDtV4YkLwT4V4od
	YFz+zr+TNT6wQULM74QvN1nWmFpOCqMiHDY3k4uBv8cArfreH78Q==
X-Google-Smtp-Source: AGHT+IGM7z35sOQKGVXiJB6QQ9+rdwGe3YwWc1Izop4nOcwe0FiWVoZpxUJF+x5wfqvNJ2pZ7QKNMUmdySxU3nA4
X-Received: from pjbrr15.prod.google.com ([2002:a17:90b:2b4f:b0:2ea:adc3:8daa])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:fe06:b0:2ea:8aac:6ac4 with SMTP id 98e67ed59e1d1-2ee08eb070fmr6218888a91.16.1732738808396;
 Wed, 27 Nov 2024 12:20:08 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:26 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-13-aaronlewis@google.com>
Subject: [PATCH 12/15] KVM: x86: Track possible passthrough MSRs in kvm_x86_ops
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the possible passthrough MSRs to kvm_x86_ops.  Doing this allows
them to be accessed from common x86 code.

In order to set the passthrough MSRs in kvm_x86_ops for VMX,
"vmx_possible_passthrough_msrs" had to be relocated to main.c, and with
that vmx_msr_filter_changed() had to be moved too because it uses
"vmx_possible_passthrough_msrs".

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/svm/svm.c          | 18 ++-------
 arch/x86/kvm/vmx/main.c         | 58 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 67 ++-------------------------------
 arch/x86/kvm/x86.c              | 13 +++++++
 arch/x86/kvm/x86.h              |  1 +
 6 files changed, 83 insertions(+), 77 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e8afc82ae2fb..7e9fee4d36cc2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1817,6 +1817,9 @@ struct kvm_x86_ops {
 	int (*enable_l2_tlb_flush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
+
+	const u32 * const possible_passthrough_msrs;
+	const u32 nr_possible_passthrough_msrs;
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4e30efe90c541..23e6515bb7904 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -755,18 +755,6 @@ static void clr_dr_intercepts(struct vcpu_svm *svm)
 	recalc_intercepts(svm);
 }
 
-static int direct_access_msr_slot(u32 msr)
-{
-	u32 i;
-
-	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
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
@@ -832,7 +820,7 @@ void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int slot;
 
-	slot = direct_access_msr_slot(msr);
+	slot = kvm_passthrough_msr_slot(msr);
 	WARN_ON(slot == -ENOENT);
 	if (slot >= 0) {
 		/* Set the shadow bitmaps to the desired intercept states */
@@ -871,7 +859,7 @@ void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int slot;
 
-	slot = direct_access_msr_slot(msr);
+	slot = kvm_passthrough_msr_slot(msr);
 	WARN_ON(slot == -ENOENT);
 	if (slot >= 0) {
 		/* Set the shadow bitmaps to the desired intercept states */
@@ -5165,6 +5153,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
+	.possible_passthrough_msrs = direct_access_msrs,
+	.nr_possible_passthrough_msrs = ARRAY_SIZE(direct_access_msrs),
 	.msr_filter_changed = svm_msr_filter_changed,
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 92d35cc6cd15d..6d52693b0fd6c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -7,6 +7,62 @@
 #include "pmu.h"
 #include "posted_intr.h"
 
+/*
+ * List of MSRs that can be directly passed to the guest.
+ * In addition to these x2apic, PT and LBR MSRs are handled specially.
+ */
+static const u32 vmx_possible_passthrough_msrs[] = {
+	MSR_IA32_SPEC_CTRL,
+	MSR_IA32_PRED_CMD,
+	MSR_IA32_FLUSH_CMD,
+	MSR_IA32_TSC,
+#ifdef CONFIG_X86_64
+	MSR_FS_BASE,
+	MSR_GS_BASE,
+	MSR_KERNEL_GS_BASE,
+	MSR_IA32_XFD,
+	MSR_IA32_XFD_ERR,
+#endif
+	MSR_IA32_SYSENTER_CS,
+	MSR_IA32_SYSENTER_ESP,
+	MSR_IA32_SYSENTER_EIP,
+	MSR_CORE_C1_RES,
+	MSR_CORE_C3_RESIDENCY,
+	MSR_CORE_C6_RESIDENCY,
+	MSR_CORE_C7_RESIDENCY,
+};
+
+void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 i;
+
+	if (!cpu_has_vmx_msr_bitmap())
+		return;
+
+	/*
+	 * Redo intercept permissions for MSRs that KVM is passing through to
+	 * the guest.  Disabling interception will check the new MSR filter and
+	 * ensure that KVM enables interception if usersepace wants to filter
+	 * the MSR.  MSRs that KVM is already intercepting don't need to be
+	 * refreshed since KVM is going to intercept them regardless of what
+	 * userspace wants.
+	 */
+	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
+		u32 msr = vmx_possible_passthrough_msrs[i];
+
+		if (!test_bit(i, vmx->shadow_msr_intercept.read))
+			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_R);
+
+		if (!test_bit(i, vmx->shadow_msr_intercept.write))
+			vmx_disable_intercept_for_msr(vcpu, msr, MSR_TYPE_W);
+	}
+
+	/* PT MSRs can be passed through iff PT is exposed to the guest. */
+	if (vmx_pt_mode_is_host_guest())
+		pt_update_intercept_for_msr(vcpu);
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -152,6 +208,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
+	.possible_passthrough_msrs = vmx_possible_passthrough_msrs,
+	.nr_possible_passthrough_msrs = ARRAY_SIZE(vmx_possible_passthrough_msrs),
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bc64e7cc02704..1c2c0c06f3d35 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -163,31 +163,6 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 	RTIT_STATUS_ERROR | RTIT_STATUS_STOPPED | \
 	RTIT_STATUS_BYTECNT))
 
-/*
- * List of MSRs that can be directly passed to the guest.
- * In addition to these x2apic, PT and LBR MSRs are handled specially.
- */
-static const u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
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
@@ -669,7 +644,7 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 
 static int vmx_get_passthrough_msr_slot(u32 msr)
 {
-	int i;
+	int r;
 
 	switch (msr) {
 	case 0x800 ... 0x8ff:
@@ -692,13 +667,10 @@ static int vmx_get_passthrough_msr_slot(u32 msr)
 		return -ENOENT;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
-		if (vmx_possible_passthrough_msrs[i] == msr)
-			return i;
-	}
+	r = kvm_passthrough_msr_slot(msr);
 
-	WARN(1, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
-	return -ENOENT;
+	WARN(!r, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
+	return r;
 }
 
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
@@ -4145,37 +4117,6 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
-void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 i;
-
-	if (!cpu_has_vmx_msr_bitmap())
-		return;
-
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
-	}
-
-	/* PT MSRs can be passed through iff PT is exposed to the guest. */
-	if (vmx_pt_mode_is_host_guest())
-		pt_update_intercept_for_msr(vcpu);
-}
-
 static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 						     int pi_vec)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8637bc0010965..20b6cce793af5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1806,6 +1806,19 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 }
 EXPORT_SYMBOL_GPL(kvm_msr_allowed);
 
+int kvm_passthrough_msr_slot(u32 msr)
+{
+	u32 i;
+
+	for (i = 0; i < kvm_x86_ops.nr_possible_passthrough_msrs; i++) {
+		if (kvm_x86_ops.possible_passthrough_msrs[i] == msr)
+			return i;
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(kvm_passthrough_msr_slot);
+
 /*
  * Write @data into the MSR specified by @index.  Select MSR specific fault
  * checks are bypassed if @host_initiated is %true.
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ec623d23d13d2..208f0698c64e2 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -555,6 +555,7 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
 bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
+int kvm_passthrough_msr_slot(u32 msr);
 
 enum kvm_msr_access {
 	MSR_TYPE_R	= BIT(0),
-- 
2.47.0.338.g60cca15819-goog


