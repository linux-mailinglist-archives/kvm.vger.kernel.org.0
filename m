Return-Path: <kvm+bounces-32599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A73CD9DAE7A
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A1CF167083
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5612036F4;
	Wed, 27 Nov 2024 20:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I8UOEY2A"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC23204085
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732738813; cv=none; b=DCLJ0uVJMN7PRq9lcCAQT2uJjLRsNap3kFLMPvnzHeOwy5hK6D1T7jHOyO20iGJhOmEhkqtvjeG6r7gX+3/k96Vqwigy9jwzIInvkaHWFtU8SMKX7Gqow+mPj6P5edwf0tH9aV2aMs7ffsffZNEGrrZPCycWawHZrsuCW63Jvng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732738813; c=relaxed/simple;
	bh=g/dl6v5JSn82RfydqRxv1FB6+0KdRK4244vXkZ+8ZT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lmbAdG+BZEin8jqpn3Hz+Cdr4Had+Msf/Hq1jezwY85RfMfZ35MlJj3hExlFMn5Ylq/zBsodCdzPo0Y/ny5Ejst11oncKpKXOVypvT9rgip7qpqkFhbJkQp7HWrkLZ1waEc/ZuJcDKVVyQtEspD0gyPnn2BzDFNbHOUQJJ450Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I8UOEY2A; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-2970b792b98so113679fac.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732738810; x=1733343610; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwBijepV3qdSa5PW7c6B2ta0sO0Sgux9WgSa1RA6CHQ=;
        b=I8UOEY2AQ2G4gayDpjBRbNSUbJyzAxNrMz4MP0m5x67AU5zOnoSdaHNIlvJu0oPBKq
         MXVrvTaz68OLcemwCYQuVnIlYew6LkS3k0RZsDzGiI7IYCDjLn3cnt4ol2LgFOdh97R3
         7MDvzPws5Y8al/AcicLG6nNFhWvcLvoBXMpaAhOqtRg8ckGNCV/pVzvY/YBTRNFjgiir
         hzcPEy+1YuN8mRz/x0RR13gpZjrfhyM5lqqlnD7MdnzzK8Y3RGG3QmKDuyJddLXawOZZ
         f/r63VKldqJaZ2OYY6XJYgjkKSoBZAxBlrzORy8SFTwUw1K15TUFyQJeu5os8ztHTlAh
         BK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732738810; x=1733343610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwBijepV3qdSa5PW7c6B2ta0sO0Sgux9WgSa1RA6CHQ=;
        b=GPUNwvthJcKPHG4BhuAv1nXW7k46Cw4AvR9r2pO/VBS6tk5f5hxeDcwsoGYlmpmCyL
         Rm38U2dntl65GXx7Btncr5t+mbe77EWDyDAgKM1oJ8W5QBc0r6/NXlGoMjzx+QaYUdui
         h0NhDMGjMLwpGUYEd7lk9rlkI97AB2EAGVjCOOAQ7ROu1WImtgrrhoLG/G1reywLErGJ
         dmrPdZxCXQjWmYwu4w5lfQxlmQ7WBEO/EPxFaX/5D7Fz5+QE0mgb3UD6hDBHwFHdfUoi
         N9yJT6TeLwcbseafffuEvtRVPbsPxPpJrxg8xhNYMQ7J0ERmXIt+WOxA2RRKB/Zq/IR+
         COPQ==
X-Gm-Message-State: AOJu0Yw6iPq5PcZE0mcYogAIl83fZF4I0xfTI1xtnnEN0ndk2YearA1+
	TP45nVi3K87C2dKE2XrlYnElE8i2fXTTAFwBe9Tbe7X3Sc9UuFkmHjOYJQlYVok8ljRQ8e9VAHK
	XiHmulfMkUMrClnb6mPAfPzFCeKJwR6/dRfdBCB7CZC1bnkngK2eRP9TX/8I3MHTh3w0TipzcW5
	ZetWq9QxfMMlKRus2t2G8512bfyzMtc5TNkKOGyPOjxfIw01w1DQ==
X-Google-Smtp-Source: AGHT+IGdZHSbxgZvba3P3DLDX13RaPp0HbZ+744UxU8XwtxfkeY1fO7RtAr0RQtojyrLRaoPLasVy+qv+nPZwYaR
X-Received: from oad18.prod.google.com ([2002:a05:6870:4012:b0:29d:c30e:d034])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6870:3b8a:b0:29d:c8fd:15ba with SMTP id 586e51a60fabf-29de0bed081mr570594fac.10.1732738810560;
 Wed, 27 Nov 2024 12:20:10 -0800 (PST)
Date: Wed, 27 Nov 2024 20:19:27 +0000
In-Reply-To: <20241127201929.4005605-1-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127201929.4005605-14-aaronlewis@google.com>
Subject: [PATCH 13/15] KVM: x86: Move ownership of passthrough MSR "shadow" to
 common x86
From: Aaron Lewis <aaronlewis@google.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, jmattson@google.com, seanjc@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  3 ++-
 arch/x86/include/asm/kvm_host.h    | 11 +++++++++
 arch/x86/kvm/svm/svm.c             | 38 ++++--------------------------
 arch/x86/kvm/svm/svm.h             |  6 -----
 arch/x86/kvm/vmx/main.c            | 32 +------------------------
 arch/x86/kvm/vmx/vmx.c             | 22 ++++++++++-------
 arch/x86/kvm/vmx/vmx.h             |  7 ------
 arch/x86/kvm/x86.c                 | 37 ++++++++++++++++++++++++++++-
 8 files changed, 69 insertions(+), 87 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5aff7222e40fa..124c2e1e42026 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -131,7 +131,8 @@ KVM_X86_OP(check_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
 KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
 KVM_X86_OP_OPTIONAL(migrate_timers)
-KVM_X86_OP(msr_filter_changed)
+KVM_X86_OP_OPTIONAL(msr_filter_changed)
+KVM_X86_OP(disable_intercept_for_msr)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e9fee4d36cc2..808b5365e4bd2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -777,6 +777,16 @@ struct kvm_vcpu_arch {
 	u64 arch_capabilities;
 	u64 perf_capabilities;
 
+	/*
+	 * KVM's "shadow" of the MSR intercepts, i.e. bitmaps that track KVM's
+	 * desired behavior irrespective of userspace MSR filtering.
+	 */
+#define KVM_MAX_POSSIBLE_PASSTHROUGH_MSRS	64
+	struct {
+		DECLARE_BITMAP(read, KVM_MAX_POSSIBLE_PASSTHROUGH_MSRS);
+		DECLARE_BITMAP(write, KVM_MAX_POSSIBLE_PASSTHROUGH_MSRS);
+	} shadow_msr_intercept;
+
 	/*
 	 * Paging state of the vcpu
 	 *
@@ -1820,6 +1830,7 @@ struct kvm_x86_ops {
 
 	const u32 * const possible_passthrough_msrs;
 	const u32 nr_possible_passthrough_msrs;
+	void (*disable_intercept_for_msr)(struct kvm_vcpu *vcpu, u32 msr, int type);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 23e6515bb7904..31ed6c68e8194 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -825,9 +825,9 @@ void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (slot >= 0) {
 		/* Set the shadow bitmaps to the desired intercept states */
 		if (type & MSR_TYPE_R)
-			__clear_bit(slot, svm->shadow_msr_intercept.read);
+			__clear_bit(slot, vcpu->arch.shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			__clear_bit(slot, svm->shadow_msr_intercept.write);
+			__clear_bit(slot, vcpu->arch.shadow_msr_intercept.write);
 	}
 
 	/*
@@ -864,9 +864,9 @@ void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	if (slot >= 0) {
 		/* Set the shadow bitmaps to the desired intercept states */
 		if (type & MSR_TYPE_R)
-			__set_bit(slot, svm->shadow_msr_intercept.read);
+			__set_bit(slot, vcpu->arch.shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			__set_bit(slot, svm->shadow_msr_intercept.write);
+			__set_bit(slot, vcpu->arch.shadow_msr_intercept.write);
 	}
 
 	if (type & MSR_TYPE_R)
@@ -939,30 +939,6 @@ void svm_vcpu_free_msrpm(unsigned long *msrpm)
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
-	for (i = 0; i < ARRAY_SIZE(direct_access_msrs); i++) {
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
 static void add_msr_offset(u32 offset)
 {
 	int i;
@@ -1475,10 +1451,6 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		goto error_free_vmsa_page;
 
-	/* All MSRs start out in the "intercepted" state. */
-	bitmap_fill(svm->shadow_msr_intercept.read, MAX_DIRECT_ACCESS_MSRS);
-	bitmap_fill(svm->shadow_msr_intercept.write, MAX_DIRECT_ACCESS_MSRS);
-
 	svm->msrpm = svm_vcpu_alloc_msrpm();
 	if (!svm->msrpm) {
 		err = -ENOMEM;
@@ -5155,7 +5127,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.possible_passthrough_msrs = direct_access_msrs,
 	.nr_possible_passthrough_msrs = ARRAY_SIZE(direct_access_msrs),
-	.msr_filter_changed = svm_msr_filter_changed,
+	.disable_intercept_for_msr = svm_disable_intercept_for_msr,
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2513990c5b6e6..a73da8ca73b49 100644
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
index 6d52693b0fd6c..5279c82648fe6 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -32,37 +32,6 @@ static const u32 vmx_possible_passthrough_msrs[] = {
 	MSR_CORE_C7_RESIDENCY,
 };
 
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
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -210,6 +179,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.possible_passthrough_msrs = vmx_possible_passthrough_msrs,
 	.nr_possible_passthrough_msrs = ARRAY_SIZE(vmx_possible_passthrough_msrs),
+	.disable_intercept_for_msr = vmx_disable_intercept_for_msr,
 	.msr_filter_changed = vmx_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c2c0c06f3d35..4cb3e9a8df2c0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3987,9 +3987,9 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	idx = vmx_get_passthrough_msr_slot(msr);
 	if (idx >= 0) {
 		if (type & MSR_TYPE_R)
-			__clear_bit(idx, vmx->shadow_msr_intercept.read);
+			__clear_bit(idx, vcpu->arch.shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			__clear_bit(idx, vmx->shadow_msr_intercept.write);
+			__clear_bit(idx, vcpu->arch.shadow_msr_intercept.write);
 	}
 
 	if ((type & MSR_TYPE_R) &&
@@ -4029,9 +4029,9 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	idx = vmx_get_passthrough_msr_slot(msr);
 	if (idx >= 0) {
 		if (type & MSR_TYPE_R)
-			__set_bit(idx, vmx->shadow_msr_intercept.read);
+			__set_bit(idx, vcpu->arch.shadow_msr_intercept.read);
 		if (type & MSR_TYPE_W)
-			__set_bit(idx, vmx->shadow_msr_intercept.write);
+			__set_bit(idx, vcpu->arch.shadow_msr_intercept.write);
 	}
 
 	if (type & MSR_TYPE_R)
@@ -4117,6 +4117,16 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
+void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	if (!cpu_has_vmx_msr_bitmap())
+		return;
+
+	/* PT MSRs can be passed through iff PT is exposed to the guest. */
+	if (vmx_pt_mode_is_host_guest())
+		pt_update_intercept_for_msr(vcpu);
+}
+
 static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 						     int pi_vec)
 {
@@ -7513,10 +7523,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 		evmcs->hv_enlightenments_control.msr_bitmap = 1;
 	}
 
-	/* The MSR bitmap starts with all ones */
-	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
 #ifdef CONFIG_X86_64
 	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 43f573f6ca46a..c40e7c880764f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -353,13 +353,6 @@ struct vcpu_vmx {
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20b6cce793af5..2082ae8dc5db1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1819,6 +1819,31 @@ int kvm_passthrough_msr_slot(u32 msr)
 }
 EXPORT_SYMBOL_GPL(kvm_passthrough_msr_slot);
 
+static void kvm_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	u32 msr, i;
+
+	/*
+	 * Redo intercept permissions for MSRs that KVM is passing through to
+	 * the guest.  Disabling interception will check the new MSR filter and
+	 * ensure that KVM enables interception if usersepace wants to filter
+	 * the MSR.  MSRs that KVM is already intercepting don't need to be
+	 * refreshed since KVM is going to intercept them regardless of what
+	 * userspace wants.
+	 */
+	for (i = 0; i < kvm_x86_ops.nr_possible_passthrough_msrs; i++) {
+		msr = kvm_x86_ops.possible_passthrough_msrs[i];
+
+		if (!test_bit(i, vcpu->arch.shadow_msr_intercept.read))
+			static_call(kvm_x86_disable_intercept_for_msr)(vcpu, msr, MSR_TYPE_R);
+
+		if (!test_bit(i, vcpu->arch.shadow_msr_intercept.write))
+			static_call(kvm_x86_disable_intercept_for_msr)(vcpu, msr, MSR_TYPE_W);
+	}
+
+	static_call_cond(kvm_x86_msr_filter_changed)(vcpu);
+}
+
 /*
  * Write @data into the MSR specified by @index.  Select MSR specific fault
  * checks are bypassed if @host_initiated is %true.
@@ -9747,6 +9772,10 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, kvm_host.arch_capabilities);
 
+	if (ops->runtime_ops->nr_possible_passthrough_msrs >
+	    KVM_MAX_POSSIBLE_PASSTHROUGH_MSRS)
+		return -E2BIG;
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		goto out_mmu_exit;
@@ -10851,7 +10880,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
 		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
-			kvm_x86_call(msr_filter_changed)(vcpu);
+			kvm_msr_filter_changed(vcpu);
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			kvm_x86_call(update_cpu_dirty_logging)(vcpu);
@@ -12305,6 +12334,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
 #endif
 
+	/* All MSRs start out in the "intercepted" state. */
+	bitmap_fill(vcpu->arch.shadow_msr_intercept.read,
+		    KVM_MAX_POSSIBLE_PASSTHROUGH_MSRS);
+	bitmap_fill(vcpu->arch.shadow_msr_intercept.write,
+		    KVM_MAX_POSSIBLE_PASSTHROUGH_MSRS);
+
 	r = kvm_x86_call(vcpu_create)(vcpu);
 	if (r)
 		goto free_guest_fpu;
-- 
2.47.0.338.g60cca15819-goog


