Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2AD04D7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 02:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbfJIAl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 20:41:56 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:32876 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729860AbfJIAl4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 20:41:56 -0400
Received: by mail-pg1-f201.google.com with SMTP id f10so439080pgj.0
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 17:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HFb1XRQYBGQ051C39vXgzSCDUzRwswGfka/G3jhuSKA=;
        b=nAH/BgvskUp7FnY8g96ywrXrldMObHFA1uJUsCAf+Q05sqHZV0SPU/SLYo/CjdH90W
         teJ5Cie0QqOIKViO56QkzfxD1i7vO65o7ARleFWy1cpP30H8wSVDQB4Oxuf16l0m/e7j
         ttcU87xelo6t0W/GmBeCD03yNHZYs4+mqEx95Q3h+Wj68V05vjQkYUg9hJyDAB8GC7Zd
         2Ui95N+aEu8HmBsAa+dFoJU5c5z9cRlDPFug0KD9o9w/VMQMjicCYRUxk++KztiySrVO
         MS3BxnUoRwWT16dV6gVVMKRHLYvYr/YFwDQD1KkHUFxnIlW/bpU70EGbMFaAaXfKyGP2
         eLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HFb1XRQYBGQ051C39vXgzSCDUzRwswGfka/G3jhuSKA=;
        b=tT9pkYK3d2GI5JYYl2dO7OwDPYfPSYelMhIqpwdfTiS+xVPpK0tnj4sE9OM//Ij8vq
         0HBYBuwgAlW110oeNfkGwRqzf9mG6coN3fWYHAx42suO2dG3KhQdQNVGTYoBpJl02xRr
         xFJcW7HMClFg7u91KHEbZaIfj/PC+KH8p99E+MLCVpV8lSQBJDaXECOyih51VLAUXpbe
         MJfb3VY4Lb2TnfGexWpsxT3ReDRK02L9BsfvZ4Xg93yjl0RBychr/D1PJti40MFUGXXp
         M0AKwAHMGss6xipA7RHERudVkw4pQe7Ltjqab77Uacgcrpw03V7zUUTLwdlwm2CzBCr1
         cPWA==
X-Gm-Message-State: APjAAAV8Nx+br/wB/GUGkIsfvbHn3mteYnoLOPoOdF5DIK+ce6Axi0ub
        7LrGXDimR37MSRkZM4vOm4cbTtc0dQN+Gl2b
X-Google-Smtp-Source: APXvYqzzdx/wRd0YDIfermtN1PKlvSKV2aEqDS5FGpbQ4Fvtf79p319hNA9DPlkEl+pWYO0KqGg3yT1ef4vhzfDV
X-Received: by 2002:a63:495b:: with SMTP id y27mr1338777pgk.438.1570581713649;
 Tue, 08 Oct 2019 17:41:53 -0700 (PDT)
Date:   Tue,  8 Oct 2019 17:41:38 -0700
In-Reply-To: <20191009004142.225377-1-aaronlewis@google.com>
Message-Id: <20191009004142.225377-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191009004142.225377-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [Patch 2/6] KVM: VMX: Use wrmsr for switching between guest and host IA32_XSS
From:   Aaron Lewis <aaronlewis@google.com>
To:     Babu Moger <Babu.Moger@amd.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set IA32_XSS for the guest and host during VM Enter and VM Exit
transitions rather than by using the MSR-load areas.

Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/svm.c     |  4 ++--
 arch/x86/kvm/vmx/vmx.c | 14 ++------------
 arch/x86/kvm/x86.c     | 25 +++++++++++++++++++++----
 arch/x86/kvm/x86.h     |  4 ++--
 4 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f8ecb6df5106..e2d7a7738c76 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5628,7 +5628,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
 	clgi();
-	kvm_load_guest_xcr0(vcpu);
+	kvm_load_guest_xsave_controls(vcpu);
 
 	if (lapic_in_kernel(vcpu) &&
 		vcpu->arch.apic->lapic_timer.timer_advance_ns)
@@ -5778,7 +5778,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
 
-	kvm_put_guest_xcr0(vcpu);
+	kvm_load_host_xsave_controls(vcpu);
 	stgi();
 
 	/* Any pending NMI will happen here */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 409e9a7323f1..ff5ba28abecb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -106,8 +106,6 @@ module_param(enable_apicv, bool, S_IRUGO);
 static bool __read_mostly nested = 1;
 module_param(nested, bool, S_IRUGO);
 
-static u64 __read_mostly host_xss;
-
 bool __read_mostly enable_pml = 1;
 module_param_named(pml, enable_pml, bool, S_IRUGO);
 
@@ -2074,11 +2072,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data != 0)
 			return 1;
 		vcpu->arch.ia32_xss = data;
-		if (vcpu->arch.ia32_xss != host_xss)
-			add_atomic_switch_msr(vmx, MSR_IA32_XSS,
-				vcpu->arch.ia32_xss, host_xss, false);
-		else
-			clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
 		break;
 	case MSR_IA32_RTIT_CTL:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
@@ -6540,7 +6533,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vmx_set_interrupt_shadow(vcpu, 0);
 
-	kvm_load_guest_xcr0(vcpu);
+	kvm_load_guest_xsave_controls(vcpu);
 
 	if (static_cpu_has(X86_FEATURE_PKU) &&
 	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
@@ -6647,7 +6640,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 			__write_pkru(vmx->host_pkru);
 	}
 
-	kvm_put_guest_xcr0(vcpu);
+	kvm_load_host_xsave_controls(vcpu);
 
 	vmx->nested.nested_run_pending = 0;
 	vmx->idt_vectoring_info = 0;
@@ -7599,9 +7592,6 @@ static __init int hardware_setup(void)
 		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
 	}
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrl(MSR_IA32_XSS, host_xss);
-
 	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
 	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
 		enable_vpid = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf38526..e90e658fd8a9 100644
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
@@ -812,27 +814,39 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 }
 EXPORT_SYMBOL_GPL(kvm_lmsw);
 
-void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
+void kvm_load_guest_xsave_controls(struct kvm_vcpu *vcpu)
 {
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
 			!vcpu->guest_xcr0_loaded) {
 		/* kvm_set_xcr() also depends on this */
 		if (vcpu->arch.xcr0 != host_xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
+
+		if (kvm_x86_ops->xsaves_supported() &&
+		    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
+		    vcpu->arch.ia32_xss != host_xss)
+			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
+
 		vcpu->guest_xcr0_loaded = 1;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_load_guest_xcr0);
+EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_controls);
 
-void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
+void kvm_load_host_xsave_controls(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->guest_xcr0_loaded) {
 		if (vcpu->arch.xcr0 != host_xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
+
+		if (kvm_x86_ops->xsaves_supported() &&
+		    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
+		    vcpu->arch.ia32_xss != host_xss)
+			wrmsrl(MSR_IA32_XSS, host_xss);
+
 		vcpu->guest_xcr0_loaded = 0;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_put_guest_xcr0);
+EXPORT_SYMBOL_GPL(kvm_load_host_xsave_controls);
 
 static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
@@ -9293,6 +9307,9 @@ int kvm_arch_hardware_setup(void)
 		kvm_default_tsc_scaling_ratio = 1ULL << kvm_tsc_scaling_ratio_frac_bits;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_XSAVES))
+		rdmsrl(MSR_IA32_XSS, host_xss);
+
 	kvm_init_msr_list();
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index dbf7442a822b..0d04e865665b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -366,7 +366,7 @@ static inline bool kvm_pat_valid(u64 data)
 	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
 }
 
-void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
-void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
+void kvm_load_guest_xsave_controls(struct kvm_vcpu *vcpu);
+void kvm_load_host_xsave_controls(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.23.0.581.g78d2f28ef7-goog

