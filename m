Return-Path: <kvm+bounces-48052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45991AC8536
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 01:45:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 823ADA4348B
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 23:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1AEE2620C6;
	Thu, 29 May 2025 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B8KWrJKD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BCB264FB3
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 23:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562046; cv=none; b=FwvUdNavV8YmHuWJ2NUPAFCOCL5Sx9tK1MULjFrOlVYJ3CgmzSZL9StHO9sb4iwcNk0cL4kavibBPigBAKCF25FJpCHsiKFyu8sqZUAxSnUvBF1U7TJVmc16LyCTnME4h1LcLf+DYAS2nkSZ6tWMqSqouPXt1Ixw01sFlzHy05w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562046; c=relaxed/simple;
	bh=O33BtJNOo80xVaZDEE/DRx/daeadMKrBBE6HwgKd7Y4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H3exo3QdEhdR33YAn7PQFJJmxSfUv33azOerE9y33F5oU6SrxvEveSpVDSH6b7voIWhgU0N8DzN+4LhRnbtOk6plapLk/VgjcsyAwgHptUjGBADsqDHUCwaPHlQei3hsuXrVDun41AU/O6jZWVbB4OV5F20UtD7eaSKbS9iIwqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B8KWrJKD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-310c5c2c38cso1429207a91.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 16:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748562043; x=1749166843; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UOOPmHMr37cYJ1G3oxjtvw78EW21ZQaVCkdI2FrCdR8=;
        b=B8KWrJKDaiR0wSDGeTyC48VMvzPetIX8/1uf67t/tZKXmSSAt7HiQxLOVgMG2uAPRe
         Ka9Yk3bxWLZnjVyZdjMEAsDw/exQBlvz4ELGC0KDCeyUuDMKquZu9ve7wt1WnXDKtcPS
         ijwNEVOLmCxQe3TnazH2fPeh4mfEhGD5SW1nhg7iZRw1HZqPCtT1SMCg5ZQg34IyWTXq
         rv/GD+3OoOzWt1xbIV6S/+f0RU7lQTznG7xZO/c+gksLBPaMSMrSM0DOn9weFuy3lyaG
         f8B8D8RMwnhOROIS6cZvyPA5vQZ7fwkUNqMUp0lpc/EZ5l+JWNpZaf2feyBTpm+xhNel
         bYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562043; x=1749166843;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UOOPmHMr37cYJ1G3oxjtvw78EW21ZQaVCkdI2FrCdR8=;
        b=py5k9no7slkgNZ0QLKviUdY+Ly8RfNb+eBeJQR9jtsG+vFwWICjX9enYeWaCTkcNeT
         U5d3GLxniEHpX5+XZ92GiYdelluTdv8htQCecCI1n/zOSKJ6KyNirRD/KdyIb2GpGDUi
         fF5bZlYSi+RIkMfN13kXU+kYIyS7MHJbWphN7FG770kp5eCe0kVC6N7It2Z9ETdAn5nF
         +elFlIUValdTgC2hTsDJ2JJy/SjmYQULRsIg2FED3e0Fr2k0TTyUSQCMqp4Q2IhW+axZ
         BTiSB0hRcOQoVUYqIi7Tbcv2IYd/wGthuki3GFLAx2XBet9qj5gGtSbW+w0sQDTW4VRP
         lOpg==
X-Gm-Message-State: AOJu0YwyM4OAjjBpEFvELKMn3JUgyVHs6IUw+d2Z7xRgNODztFM5wVtQ
	AAUvBtB4zE1zR4X7u5YXM/O+7B9YxCpfGbxHZvvaNzvi0WYaF1Fcev6CC4BBHjx+dUys2AC2vj9
	hRblXvw==
X-Google-Smtp-Source: AGHT+IHAoGdZFc0J3ioTPcFg41l5KnD1coCisy9YuSWfjfod9//GKc+7T2F6M9sPTz4jvRjH5Y9sezH6q/w=
X-Received: from pjbsj2.prod.google.com ([2002:a17:90b:2d82:b0:308:6685:55e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e09:b0:312:25dd:1c86
 with SMTP id 98e67ed59e1d1-31241639de9mr2105681a91.18.1748562043106; Thu, 29
 May 2025 16:40:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 16:40:01 -0700
In-Reply-To: <20250529234013.3826933-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529234013.3826933-17-seanjc@google.com>
Subject: [PATCH 16/28] KVM: VMX: Manually recalc all MSR intercepts on
 userspace MSR filter change
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

On a userspace MSR filter change, recalculate all MSR intercepts using the
filter-agnostic logic instead of maintaining a "shadow copy" of KVM's
desired intercepts.  The shadow bitmaps add yet another point of failure,
are confusing (e.g. what does "handled specially" mean!?!?), an eyesore,
and a maintenance burden.

Given that KVM *must* be able to recalculate the correct intercepts at any
given time, and that MSR filter updates are not hot paths, there is zero
benefit to maintaining the shadow bitmaps.

Link: https://lore.kernel.org/all/aCdPbZiYmtni4Bjs@google.com
Link: https://lore.kernel.org/all/20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local
Cc: Borislav Petkov <bp@alien8.de>
Cc: Xin Li <xin@zytor.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 184 +++++++++++------------------------------
 arch/x86/kvm/vmx/vmx.h |   7 --
 2 files changed, 47 insertions(+), 144 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8f7fe04a1998..6ffa2b2b85ce 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -166,31 +166,6 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
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
@@ -672,40 +647,6 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
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
@@ -4015,25 +3956,12 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
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
@@ -4057,25 +3985,12 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
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
 
@@ -4159,35 +4074,59 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 	}
 }
 
-void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
+static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
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
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD));
+
+	if (boot_cpu_has(X86_FEATURE_IBPB))
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
+					  !guest_has_pred_cmd_msr(vcpu));
+
+	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
+
+	/*
+	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
+	 * filtered by userspace.
+	 */
+}
+
+void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	vmx_recalc_msr_intercepts(vcpu);
 }
 
 static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
@@ -7537,26 +7476,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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
@@ -7842,18 +7761,6 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
-		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
-					  !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD));
-
-	if (boot_cpu_has(X86_FEATURE_IBPB))
-		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
-					  !guest_has_pred_cmd_msr(vcpu));
-
-	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
-		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
-					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
-
 	set_cr4_guest_host_mask(vmx);
 
 	vmx_write_encls_bitmap(vcpu, NULL);
@@ -7869,6 +7776,9 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx->msr_ia32_feature_control_valid_bits &=
 			~FEAT_CTL_SGX_LC_ENABLED;
 
+	/* Recalc MSR interception to account for feature changes. */
+	vmx_recalc_msr_intercepts(vcpu);
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0afe97e3478f..a26fe3d9e1d2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -294,13 +294,6 @@ struct vcpu_vmx {
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
-- 
2.49.0.1204.g71687c7c1d-goog


