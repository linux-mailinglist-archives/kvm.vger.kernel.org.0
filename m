Return-Path: <kvm+bounces-15727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 293658AFB97
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 959CC1F23787
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 22:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31C6F13E8AC;
	Tue, 23 Apr 2024 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IKCeIlIZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C145D143C4F
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 22:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713910529; cv=none; b=hVBWr1FZXmlYuNqA4auV/O5jn4+tjbAtXh6K1r0BCMkJgHTGVM7YzIRI/YOOxJnO4sSUmyrVCB41ttFnAGI7qskXReyrnGPoFhvR5xywcBsFIrp2Zro0jKU/YJTwpFt7jhBmvVv0HkrE2OSfb+hOG69WfFA4FxZXuEYUFVT48V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713910529; c=relaxed/simple;
	bh=KgCs/kJZY7xdJCGpcAAqULB3WqvUrefj9IG3vqzS0KY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sbnNtVlSyrnrkneJx6IEb3QxGCXeRR94Px8inJ9CmpTJpa+ErZ0L8DNYn4LtctzHe8vgqGmHPhakDyaXvZhMnt8YaDrU7BsPAQWkZEMGHo6pUnA6Gsfu7LYwBosEXy/x4v5WyOOa1swtEbCks7ZSLgXDV7EXCCX1MrBqBgea3Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IKCeIlIZ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b269686aso10905541276.1
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 15:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713910527; x=1714515327; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ltCZUKA09BKJhKOF4qi4OedR1io6EGlo9sc+ZLkmkFA=;
        b=IKCeIlIZGgooIezmoosUP4Rd7Z8YN+jcD/l2UkhZ6j3eT4oh3ARRJNyGjE4/hhaSY+
         ojijlyBaWTsEnM9MTAlH4yfG+hLDyrT7pu4P2QRr0gn6k2VA6JFHH44PlqSIgbSko0T5
         j2D6VTWuT6Mapo9OkLxsr/mvXtFTHT4VsbqR7lPIvmknaARhQ+JzD0cPy8cz8Bj+Le3F
         TyhOtLIFsbGQZR9gCKoFzJjzK3VRDYXK0cnfBvM/fQwhgBpxpcvd+dkk/Wk0kSOxYwpA
         gMtGa6P/T5kbcWiKkSSzzQJNp+slqS4rO+DuEoGvMwKMV9c+d2PkKY8WP288VcT2jTFl
         cC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713910527; x=1714515327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ltCZUKA09BKJhKOF4qi4OedR1io6EGlo9sc+ZLkmkFA=;
        b=FM7llhrdtz2GYwv0nuOcO5Cja6apNpqwy3XqB6Pr0X1TMtmuyzXMfHorRa7iqiE0PI
         yA8LYtChi3sF2/khPZtO16M3RdIuvuvpapGNbosvnXihcTKIvcwXnjEeog4+O92oC+93
         NwKwATg7KXhl/JHusNbgy1sLVrH29PvZ6a8UZJ9WzrGtxzPVeNYn6OWhnthjoSYXW9QC
         Fyg6IObu/6tZZQl8uD4STOpFfj0MM8blh/5SCxF/55OUeyqvwEucyoaldmRe0BHXWkCw
         8dYzHBy4E0aFLQnw25HWsFKGswRL8aIds3xudR2rik/jGUgQ95qXaJPblBcmU/0QBaOL
         v0cg==
X-Gm-Message-State: AOJu0YyRud6ba2BrFcuKru9spzQfyWJRUww2T7+ddsOzXsUUKlLaaZpB
	mZHy47isUecEbWdRGkKc17trY2pOrzLehgRr3wzUP7T0PEXDOJ+HMcnb0G1gvcSYYlaCNNHaCZs
	wOA==
X-Google-Smtp-Source: AGHT+IEceCiUtwhramWsyr6t7u/CrRyOb3AC4xyCBZGzgKK+/xYWsdWnGvGIS/SZheBYAhyTWndO07VOvyk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102c:b0:de5:78:34d2 with SMTP id
 x12-20020a056902102c00b00de5007834d2mr121617ybt.6.1713910526777; Tue, 23 Apr
 2024 15:15:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 23 Apr 2024 15:15:18 -0700
In-Reply-To: <20240423221521.2923759-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423221521.2923759-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423221521.2923759-2-seanjc@google.com>
Subject: [PATCH 1/4] KVM: x86: Add a struct to consolidate host values, e.g.
 EFER, XCR0, etc...
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add "struct kvm_host_values kvm_host" to hold the various host values
that KVM snapshots during initialization.  Bundling the host values into
a single struct simplifies adding new MSRs and other features with host
state/values that KVM cares about, and provides a one-stop shop.  E.g.
adding a new value requires one line, whereas tracking each value
individual often requires three: declaration, definition, and export.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/vmx/nested.c       |  8 +++----
 arch/x86/kvm/vmx/vmx.c          | 14 ++++++------
 arch/x86/kvm/x86.c              | 38 +++++++++++++--------------------
 arch/x86/kvm/x86.h              | 12 +++++++----
 6 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1d13e3cd1dc5..8d3940a59894 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1846,7 +1846,6 @@ struct kvm_arch_async_pf {
 };
 
 extern u32 __read_mostly kvm_nr_uret_msrs;
-extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 598d78b4107f..71f1518f0ca1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3251,7 +3251,7 @@ void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_are
 	 */
 	hostsa->xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
 	hostsa->pkru = read_pkru();
-	hostsa->xss = host_xss;
+	hostsa->xss = kvm_host.xss;
 
 	/*
 	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d5b832126e34..a896df59eaad 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2422,7 +2422,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	if (cpu_has_load_ia32_efer()) {
 		if (guest_efer & EFER_LMA)
 			exec_control |= VM_ENTRY_IA32E_MODE;
-		if (guest_efer != host_efer)
+		if (guest_efer != kvm_host.efer)
 			exec_control |= VM_ENTRY_LOAD_IA32_EFER;
 	}
 	vm_entry_controls_set(vmx, exec_control);
@@ -2435,7 +2435,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	 * bits may be modified by vmx_set_efer() in prepare_vmcs02().
 	 */
 	exec_control = __vm_exit_controls_get(vmcs01);
-	if (cpu_has_load_ia32_efer() && guest_efer != host_efer)
+	if (cpu_has_load_ia32_efer() && guest_efer != kvm_host.efer)
 		exec_control |= VM_EXIT_LOAD_IA32_EFER;
 	else
 		exec_control &= ~VM_EXIT_LOAD_IA32_EFER;
@@ -4662,7 +4662,7 @@ static inline u64 nested_vmx_get_vmcs01_guest_efer(struct vcpu_vmx *vmx)
 		return vmcs_read64(GUEST_IA32_EFER);
 
 	if (cpu_has_load_ia32_efer())
-		return host_efer;
+		return kvm_host.efer;
 
 	for (i = 0; i < vmx->msr_autoload.guest.nr; ++i) {
 		if (vmx->msr_autoload.guest.val[i].index == MSR_EFER)
@@ -4673,7 +4673,7 @@ static inline u64 nested_vmx_get_vmcs01_guest_efer(struct vcpu_vmx *vmx)
 	if (efer_msr)
 		return efer_msr->data;
 
-	return host_efer;
+	return kvm_host.efer;
 }
 
 static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f10b5f8f364b..cb1bd9aebac4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -258,7 +258,7 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 		return 0;
 	}
 
-	if (host_arch_capabilities & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
+	if (kvm_host.arch_capabilities & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
 		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
 		return 0;
 	}
@@ -403,7 +403,7 @@ static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
 	 * and VM-Exit.
 	 */
 	vmx->disable_fb_clear = !cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) &&
-				(host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
+				(kvm_host.arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
 				!boot_cpu_has_bug(X86_BUG_MDS) &&
 				!boot_cpu_has_bug(X86_BUG_TAA);
 
@@ -1116,12 +1116,12 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
 	 * atomically, since it's faster than switching it manually.
 	 */
 	if (cpu_has_load_ia32_efer() ||
-	    (enable_ept && ((vmx->vcpu.arch.efer ^ host_efer) & EFER_NX))) {
+	    (enable_ept && ((vmx->vcpu.arch.efer ^ kvm_host.efer) & EFER_NX))) {
 		if (!(guest_efer & EFER_LMA))
 			guest_efer &= ~EFER_LME;
-		if (guest_efer != host_efer)
+		if (guest_efer != kvm_host.efer)
 			add_atomic_switch_msr(vmx, MSR_EFER,
-					      guest_efer, host_efer, false);
+					      guest_efer, kvm_host.efer, false);
 		else
 			clear_atomic_switch_msr(vmx, MSR_EFER);
 		return false;
@@ -1134,7 +1134,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
 	clear_atomic_switch_msr(vmx, MSR_EFER);
 
 	guest_efer &= ~ignore_bits;
-	guest_efer |= host_efer & ignore_bits;
+	guest_efer |= kvm_host.efer & ignore_bits;
 
 	vmx->guest_uret_msrs[i].data = guest_efer;
 	vmx->guest_uret_msrs[i].mask = ~ignore_bits;
@@ -4346,7 +4346,7 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	}
 
 	if (cpu_has_load_ia32_efer())
-		vmcs_write64(HOST_IA32_EFER, host_efer);
+		vmcs_write64(HOST_IA32_EFER, kvm_host.efer);
 }
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e9ef1fa4b90b..1b664385461d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -98,6 +98,9 @@ struct kvm_caps kvm_caps __read_mostly = {
 };
 EXPORT_SYMBOL_GPL(kvm_caps);
 
+struct kvm_host_values kvm_host __read_mostly;
+EXPORT_SYMBOL_GPL(kvm_host);
+
 #define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
 
 #define emul_to_vcpu(ctxt) \
@@ -227,21 +230,12 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
-u64 __read_mostly host_efer;
-EXPORT_SYMBOL_GPL(host_efer);
-
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
 bool __read_mostly enable_apicv = true;
 EXPORT_SYMBOL_GPL(enable_apicv);
 
-u64 __read_mostly host_xss;
-EXPORT_SYMBOL_GPL(host_xss);
-
-u64 __read_mostly host_arch_capabilities;
-EXPORT_SYMBOL_GPL(host_arch_capabilities);
-
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
@@ -315,8 +309,6 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 		       sizeof(kvm_vcpu_stats_desc),
 };
 
-u64 __read_mostly host_xcr0;
-
 static struct kmem_cache *x86_emulator_cache;
 
 /*
@@ -1023,11 +1015,11 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 
 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
 
-		if (vcpu->arch.xcr0 != host_xcr0)
+		if (vcpu->arch.xcr0 != kvm_host.xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
 
 		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
-		    vcpu->arch.ia32_xss != host_xss)
+		    vcpu->arch.ia32_xss != kvm_host.xss)
 			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
 	}
 
@@ -1054,12 +1046,12 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 
 	if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
 
-		if (vcpu->arch.xcr0 != host_xcr0)
-			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
+		if (vcpu->arch.xcr0 != kvm_host.xcr0)
+			xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
 
 		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
-		    vcpu->arch.ia32_xss != host_xss)
-			wrmsrl(MSR_IA32_XSS, host_xss);
+		    vcpu->arch.ia32_xss != kvm_host.xss)
+			wrmsrl(MSR_IA32_XSS, kvm_host.xss);
 	}
 
 }
@@ -1626,7 +1618,7 @@ static bool kvm_is_immutable_feature_msr(u32 msr)
 
 static u64 kvm_get_arch_capabilities(void)
 {
-	u64 data = host_arch_capabilities & KVM_SUPPORTED_ARCH_CAP;
+	u64 data = kvm_host.arch_capabilities & KVM_SUPPORTED_ARCH_CAP;
 
 	/*
 	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
@@ -9777,19 +9769,19 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		goto out_free_percpu;
 
 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
-		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
-		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
+		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
+		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
 	}
 
-	rdmsrl_safe(MSR_EFER, &host_efer);
+	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
 
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrl(MSR_IA32_XSS, host_xss);
+		rdmsrl(MSR_IA32_XSS, kvm_host.xss);
 
 	kvm_init_pmu_capability(ops->pmu_ops);
 
 	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, host_arch_capabilities);
+		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, kvm_host.arch_capabilities);
 
 	r = ops->hardware_setup();
 	if (r != 0)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d80a4c6b5a38..e69fff7d1f21 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -33,6 +33,13 @@ struct kvm_caps {
 	u64 supported_perf_cap;
 };
 
+struct kvm_host_values {
+	u64 efer;
+	u64 xcr0;
+	u64 xss;
+	u64 arch_capabilities;
+};
+
 void kvm_spurious_fault(void);
 
 #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
@@ -325,11 +332,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 
-extern u64 host_xcr0;
-extern u64 host_xss;
-extern u64 host_arch_capabilities;
-
 extern struct kvm_caps kvm_caps;
+extern struct kvm_host_values kvm_host;
 
 extern bool enable_pmu;
 
-- 
2.44.0.769.g3c40516874-goog


