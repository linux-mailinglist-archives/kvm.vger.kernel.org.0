Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C12EDF8B2
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 01:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbfJUXdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 19:33:54 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:51309 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbfJUXdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 19:33:53 -0400
Received: by mail-pg1-f201.google.com with SMTP id w22so3254360pgj.18
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 16:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WXcaMgTqCdGpLJ7ej0amGPxYa/WmdQdeRFxwU867VtM=;
        b=wMXZwaW694USG6bko1a1zH4uE0kyXvYQbAMqZsIoDc2/ey6LSx65BMkVq0Aw29y1ze
         VZs1t0GUAZCHoM8F0oWJA2ToivWZoFIF9xcCXPNnVqIl44kmM03G4XmlffdL3GH3qJaM
         8fu7+E427u14AThTq0dpuxc2/h3VH2MKqSz8L7tAx+9JZgSEqTOdZ1TTjJYqTkwrg2u8
         tC6gjeuwwq17HnacIRCy5+pIbNPMqYdww3yli9LV9C6AFRQEmCU0zw2z2EGlrGnCBv7C
         IaCZtNivnmfvTxFlXYeF7pwruraxH7YjEvzfvtZMWJRj5nJ5WbnvWjd7HI9VGQkIAIUS
         hNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WXcaMgTqCdGpLJ7ej0amGPxYa/WmdQdeRFxwU867VtM=;
        b=TU5jHToZpej3MJtwq9dkCSM1vaddOexEg25Xxa0Nco52xX1eEAW1/GUvfnAnhpsFh1
         SGlkJgYjnUgTjBAG2GSfM8Z+aIBYMrmyqCbfFfndUmtNYFBPke26bMY79cgCsb5Zp2jK
         d3C/p2meQfgAT8yuLXmNnKs3+EAxeQAWwO6647ppi6CT2xJ6dK70nHiF6FMgFeq4maEt
         d7bjh+++82TUmLsKjULQ98l3oSGuHUmg/9vDo8IgtVEzYYckMuV9wR1aU2fxMiSsZiLn
         UbihDq6EwNhHIsE4ONCIEPbej0ePopQvqOo+Jbk/rz28RITPihqfvrp2s+LCpS3ZWhZA
         76aw==
X-Gm-Message-State: APjAAAWqGGZ+y261yBHfcfby33Mf66j16kJ4YzqYFvMvNBSs/wC1Hxmm
        G/W7lv6xjyT3XbOV3ER+UQluEi0swLJtY/xq
X-Google-Smtp-Source: APXvYqy1x7D/07wLNbA0hNoxTGGWyBvqPEmuqATLkPxo0aricEFqYrA+tRTKQel8kPcG6+zav+ju71sZ0XGGEt1P
X-Received: by 2002:a63:710:: with SMTP id 16mr426587pgh.329.1571700832272;
 Mon, 21 Oct 2019 16:33:52 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:30:25 -0700
In-Reply-To: <20191021233027.21566-1-aaronlewis@google.com>
Message-Id: <20191021233027.21566-7-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191021233027.21566-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 6/9] KVM: x86: Move IA32_XSS-swapping on VM-entry/VM-exit
 to common x86 code
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hoist the vendor-specific code related to loading the hardware IA32_XSS
MSR with guest/host values on VM-entry/VM-exit to common x86 code.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Change-Id: Ic6e3430833955b98eb9b79ae6715cf2a3fdd6d82
---
 arch/x86/kvm/svm.c     | 27 ++-------------------------
 arch/x86/kvm/vmx/vmx.c | 27 ++-------------------------
 arch/x86/kvm/x86.c     | 38 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/x86.h     |  4 ++--
 4 files changed, 34 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2702ebba24ba..36d1cfd45c60 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -115,8 +115,6 @@ MODULE_DEVICE_TABLE(x86cpu, svm_cpu_id);
 
 static bool erratum_383_found __read_mostly;
 
-static u64 __read_mostly host_xss;
-
 static const u32 host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
 	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
@@ -1402,9 +1400,6 @@ static __init int svm_hardware_setup(void)
 			pr_info("Virtual GIF supported\n");
 	}
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrl(MSR_IA32_XSS, host_xss);
-
 	return 0;
 
 err:
@@ -5595,22 +5590,6 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
-static void svm_load_guest_xss(struct kvm_vcpu *vcpu)
-{
-	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
-	    vcpu->arch.xsaves_enabled &&
-	    vcpu->arch.ia32_xss != host_xss)
-		wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
-}
-
-static void svm_load_host_xss(struct kvm_vcpu *vcpu)
-{
-	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
-	    vcpu->arch.xsaves_enabled &&
-	    vcpu->arch.ia32_xss != host_xss)
-		wrmsrl(MSR_IA32_XSS, host_xss);
-}
-
 static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5649,8 +5628,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
 	clgi();
-	kvm_load_guest_xcr0(vcpu);
-	svm_load_guest_xss(vcpu);
+	kvm_load_guest_xsave_state(vcpu);
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
@@ -5800,8 +5778,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
 
-	svm_load_host_xss(vcpu);
-	kvm_put_guest_xcr0(vcpu);
+	kvm_load_host_xsave_state(vcpu);
 	stgi();
 
 	/* Any pending NMI will happen here */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f3cd2e372c4a..f7d292ac9921 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -106,8 +106,6 @@ module_param(enable_apicv, bool, S_IRUGO);
 static bool __read_mostly nested = 1;
 module_param(nested, bool, S_IRUGO);
 
-static u64 __read_mostly host_xss;
-
 bool __read_mostly enable_pml = 1;
 module_param_named(pml, enable_pml, bool, S_IRUGO);
 
@@ -6485,22 +6483,6 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
-static void vmx_load_guest_xss(struct kvm_vcpu *vcpu)
-{
-	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
-	    vcpu->arch.xsaves_enabled &&
-	    vcpu->arch.ia32_xss != host_xss)
-		wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
-}
-
-static void vmx_load_host_xss(struct kvm_vcpu *vcpu)
-{
-	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
-	    vcpu->arch.xsaves_enabled &&
-	    vcpu->arch.ia32_xss != host_xss)
-		wrmsrl(MSR_IA32_XSS, host_xss);
-}
-
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
@@ -6551,8 +6533,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vmx_set_interrupt_shadow(vcpu, 0);
 
-	kvm_load_guest_xcr0(vcpu);
-	vmx_load_guest_xss(vcpu);
+	kvm_load_guest_xsave_state(vcpu);
 
 	if (static_cpu_has(X86_FEATURE_PKU) &&
 	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
@@ -6659,8 +6640,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 			__write_pkru(vmx->host_pkru);
 	}
 
-	vmx_load_host_xss(vcpu);
-	kvm_put_guest_xcr0(vcpu);
+	kvm_load_host_xsave_state(vcpu);
 
 	vmx->nested.nested_run_pending = 0;
 	vmx->idt_vectoring_info = 0;
@@ -7615,9 +7595,6 @@ static __init int hardware_setup(void)
 		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
 	}
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrl(MSR_IA32_XSS, host_xss);
-
 	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
 	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
 		enable_vpid = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 39eac7b2aa01..259a30e4d3a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -176,6 +176,8 @@ struct kvm_shared_msrs {
 static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
 static struct kvm_shared_msrs __percpu *shared_msrs;
 
+static u64 __read_mostly host_xss;
+
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "pf_fixed", VCPU_STAT(pf_fixed) },
 	{ "pf_guest", VCPU_STAT(pf_guest) },
@@ -812,21 +814,34 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 }
 EXPORT_SYMBOL_GPL(kvm_lmsw);
 
-void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
+void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 {
-	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
-	    vcpu->arch.xcr0 != host_xcr0)
-		xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
+	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
+
+		if (vcpu->arch.xcr0 != host_xcr0)
+			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
+
+		if (vcpu->arch.xsaves_enabled &&
+		    vcpu->arch.ia32_xss != host_xss)
+			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
+	}
 }
-EXPORT_SYMBOL_GPL(kvm_load_guest_xcr0);
+EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
-void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
+void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
-	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
-	    vcpu->arch.xcr0 != host_xcr0)
-		xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
+	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
+
+		if (vcpu->arch.xcr0 != host_xcr0)
+			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
+
+		if (vcpu->arch.xsaves_enabled &&
+		    vcpu->arch.ia32_xss != host_xss)
+			wrmsrl(MSR_IA32_XSS, host_xss);
+	}
+
 }
-EXPORT_SYMBOL_GPL(kvm_put_guest_xcr0);
+EXPORT_SYMBOL_GPL(kvm_load_host_xsave_state);
 
 static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
@@ -9287,6 +9302,9 @@ int kvm_arch_hardware_setup(void)
 		kvm_default_tsc_scaling_ratio = 1ULL << kvm_tsc_scaling_ratio_frac_bits;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_XSAVES))
+		rdmsrl(MSR_IA32_XSS, host_xss);
+
 	kvm_init_msr_list();
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index dbf7442a822b..250c2c932e46 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -366,7 +366,7 @@ static inline bool kvm_pat_valid(u64 data)
 	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
 }
 
-void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
-void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
+void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
+void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.23.0.866.gb869b98d4c-goog

