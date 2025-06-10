Return-Path: <kvm+bounces-48902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B538BAD464E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AAFD3A7C65
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D312DFA40;
	Tue, 10 Jun 2025 22:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x+G0AuBX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A679F2DCBEF
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596293; cv=none; b=KCqyV8lX3ckRlemjihI9NcrYmBCZ3QCaTdDJyQOESz++J263c2XQgwJfJBi1Qh8WYwVqr5IQKRqJ0dNCXXc2T5YV9u3HrggclPCpUhYDLAzKxoqPYWEQsDGsIoAgEvFeQq+J7ps6gqZEYqWtvA726r2UEYJp3VG0f+KF9VzvjT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596293; c=relaxed/simple;
	bh=ssD/VvfXryYkxfcwJ77I5aGWq07gsB3l/k7qm/ZKWsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oFEgt50tbanT6zbJH8P8pOgK+KqLPy2sQSiPfGftw5evIKlx7U2cbnZEZkVB8kAJVURFgJlsF2C2xExiyAjVgxIY4iOXEFJ59HngGnuJIAx5CYm5r/rFxD47VP2JscXzAUIJnlqDQ8XzsLiaQwKNA49ycpv0CnmC1duAQf/PchI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x+G0AuBX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235196dfc50so2217195ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596291; x=1750201091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3phPzAY9xoCLeO4kRFPS879rtp9iLcDc4NMcy31JRNs=;
        b=x+G0AuBXVSOhTiF39u1Xy/PR/AViXGsSk80OuTjfiY4HbR3nZ0xKNgUONITvKCJKUc
         AOSsVejjtTOXvvRkCBOZYhIVemfd020wN8G3PPRXVd0Q2MQkjTfd1sOHzk0o5osfAq47
         /Khh6Bebw/fT9+EWhFKu3gZg4oHwx+eOLSR5wiD3UgaKnlFUUni+9xZrwHA46Vtw87sN
         tGqXXTFc235TbdErWq6tYYSlHTI8vrBm9tS0x7HacQN6Ea9PSJacdUNfWCQ1YN7cDhMr
         kHyIOGBWGyLi0cfkzS/DwxVyzyh7txnqAEDKVHmxs3cCo98IG++rOclBrY0lF8HU/q2B
         JVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596291; x=1750201091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3phPzAY9xoCLeO4kRFPS879rtp9iLcDc4NMcy31JRNs=;
        b=BEfeOKXRYeIrFVGeSqjlhRF0M1myZwwayq4lZnUswBml+CLVc3PTkanqX89k7Kq9Nj
         8dca0rBewTPy20hAhvYUL8DUYh/gD8zc05aCgHMUJ99W2avAOXkGqhFyr2lA1HPFyKMO
         PPuXB3Tvu2u46rFH9+ItoKAKWJk5dXYaowFi0PDiHuK2UdqK4AJ8Rrs7/Z294p+eOtjz
         xc3Ux7M/WKkR1Ft5tZMamGUq9xogwCsEXRjIIor5fU8rC0j8nqqq0o9FXjB7vL4YtXbt
         BbycG9XfpvQOHjt6vxWCt1Iyw/2r4JBCSaef8Innr7o6GymoD62W8xI0ZvcsFT77RNKg
         m7eg==
X-Gm-Message-State: AOJu0YwgEPQKZ1vY7AH6Ny2NB7MHS5QcA6uBguoYn0LiwXq2ymcJ64eS
	O4655UgWnBs5+ijHKcz9o2ww+uJvwIPfy5LE7ltEhBMM3yXG7A+bH3cT6I3kO3KGb8LGi428MW3
	GMjzdpw==
X-Google-Smtp-Source: AGHT+IHsMWUutCGs/CxdBC/rqI1zjY9VjV++pNfWQTMJsf0LnXWNkeYetcRJ+4VBOeQQ4jnvzM8ik7+1+yo=
X-Received: from plhl11.prod.google.com ([2002:a17:903:120b:b0:231:de34:f9f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:288:b0:215:b1e3:c051
 with SMTP id d9443c01a7336-236416d6006mr13754145ad.11.1749596290920; Tue, 10
 Jun 2025 15:58:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:23 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-19-seanjc@google.com>
Subject: [PATCH v2 18/32] KVM: VMX: Manually recalc all MSR intercepts on
 userspace MSR filter change
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

On a userspace MSR filter change, recalculate all MSR intercepts using the
filter-agnostic logic instead of maintaining a "shadow copy" of KVM's
desired intercepts.  The shadow bitmaps add yet another point of failure,
are confusing (e.g. what does "handled specially" mean!?!?), an eyesore,
and a maintenance burden.

Given that KVM *must* be able to recalculate the correct intercepts at any
given time, and that MSR filter updates are not hot paths, there is zero
benefit to maintaining the shadow bitmaps.

Opportunistically switch from boot_cpu_has() to cpu_feature_enabled() as
appropriate.

Link: https://lore.kernel.org/all/aCdPbZiYmtni4Bjs@google.com
Link: https://lore.kernel.org/all/20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local
Cc: Borislav Petkov <bp@alien8.de>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Xin Li (Intel) <xin@zytor.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 183 +++++++++++------------------------------
 arch/x86/kvm/vmx/vmx.h |   7 --
 2 files changed, 46 insertions(+), 144 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8f7fe04a1998..ce7a1c07e402 100644
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
 
@@ -4159,35 +4074,58 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
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
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW,
+				  !to_vmx(vcpu)->spec_ctrl);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD));
+
+	if (cpu_feature_enabled(X86_FEATURE_IBPB))
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
+					  !guest_has_pred_cmd_msr(vcpu));
+
+	if (cpu_feature_enabled(X86_FEATURE_FLUSH_L1D))
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
@@ -7537,26 +7475,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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
@@ -7842,18 +7760,6 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
@@ -7869,6 +7775,9 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
2.50.0.rc0.642.g800a2b2222-goog


