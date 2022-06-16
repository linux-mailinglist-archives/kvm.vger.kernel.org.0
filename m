Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA2754DD69
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376557AbiFPItr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376414AbiFPIs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178575F250;
        Thu, 16 Jun 2022 01:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369278; x=1686905278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=72vrd16dybfGhayhrx0NsJFobw9Ileac81SFXF0QanY=;
  b=mfJxO5qV2p6QrcqBExhIGUxBOFPVtYB/KhiZf0nuA3V8Efeljt+n1NF5
   lEXpq9f4xDQN8f6tLaxUtJEk1ciGBbeEuYiaegdHzbF1Q0k/TjZ8hSakb
   bqF4KrI71HnrGWso38+FYKQmv5GEK4pW1M8dS0OkV0ItSMLvMi6r9CpJJ
   HEoj/RfPlSw35S2vzEh9yXkvab9ufmAQxncatV1N48t30Mi+ypugIEEqS
   7cVrOCDhtb89DfMNIPtBBhGQLNYQAo+JwURzoEDTr23c5/AFqUNdhbY81
   bsvjmRRI1MURxLub5FWZ7epuCg8R4irqqwsgRM6V4o+vAKCasRUPUmUue
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259664562"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259664562"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:42 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083175"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 16/19] KVM: x86: Enable CET virtualization for VMX and advertise CET to userspace
Date:   Thu, 16 Jun 2022 04:46:40 -0400
Message-Id: <20220616084643.19564-17-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the feature bits so that CET capabilities can be seen in guest via
CPUID enumeration. Add CR4.CET bit support in order to allow guest set CET
master control bit(CR4.CET).

Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
KVM does not support emulating CET.

Don't expose CET feature if dependent CET bits are cleared in host XSS,
or if XSAVES isn't supported.  Updating the CET features in common x86 is
a little ugly, but there is no clean solution without risking breakage of
SVM if SVM hardware ever gains support for CET, e.g. moving everything to
common x86 would prematurely expose CET on SVM.  The alternative is to
put all the logic in VMX, but that means rereading host_xss in VMX and
duplicating the XSAVES check across VMX and SVM.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/cpuid.c            |  5 +++--
 arch/x86/kvm/vmx/capabilities.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c          | 37 ++++++++++++++++++++++++++++-----
 arch/x86/kvm/x86.c              | 21 ++++++++++++++++++-
 5 files changed, 61 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e98b2876380..a7e5463d0107 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -120,7 +120,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 46ca0f1abbcb..12d527e612e5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -581,7 +581,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
-		F(SGX_LC) | F(BUS_LOCK_DETECT)
+		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
@@ -599,7 +599,8 @@ void kvm_set_cpu_caps(void)
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
-		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) |
+		F(IBT)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 069d8d298e1d..6849888f7b46 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -106,6 +106,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 }
 
+static inline bool cpu_has_load_cet_ctrl(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
+}
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fc1229f23987..4bdede87669a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2516,6 +2516,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
@@ -2636,7 +2637,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2660,7 +2662,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -2705,7 +2708,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		}
 	}
 
-
 	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
@@ -6159,6 +6161,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
 		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
+	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE) {
+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
+		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
+		pr_err("SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(GUEST_INTR_SSP_TABLE));
+	}
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
@@ -6236,6 +6244,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
 		pr_err("Virtual processor ID = 0x%04x\n",
 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
+	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE) {
+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
+		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
+		pr_err("SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(HOST_INTR_SSP_TABLE));
+	}
 }
 
 /*
@@ -7679,9 +7693,10 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
-	if (!cpu_has_vmx_xsaves())
+	if (!cpu_has_vmx_xsaves()) {
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
+		kvm_caps.supported_xss = 0;
+	}
 
 	/* CPUID 0x80000001 and 0x7 (RDPID) */
 	if (!cpu_has_vmx_rdtscp()) {
@@ -7691,6 +7706,18 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_USER;
+	}
+
+#ifndef CONFIG_X86_SHADOW_STACK
+	if (boot_cpu_has(X86_FEATURE_SHSTK))
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+#endif
+
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86bccb12f036..fe049d0e5ecc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -217,6 +217,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
+#define KVM_SUPPORTED_XSS     (XFEATURE_MASK_CET_USER)
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -11807,8 +11809,10 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
+	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
 		rdmsrl(MSR_IA32_XSS, host_xss);
+		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
+	}
 
 	kvm_init_pmu_capability();
 
@@ -11823,6 +11827,21 @@ int kvm_arch_hardware_setup(void *opaque)
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		kvm_caps.supported_xss = 0;
 
+	/* Update CET features now as kvm_caps.supported_xss is finalized. */
+	if (!kvm_cet_user_supported()) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	}
+
+	/*
+	 * If SHSTK and IBT are disabled either by user space or unselection in
+	 * Kconfig,then the feature bits should have been removed from KVM caps
+	 * by this point, clear CET user bit in kvm_caps.supported_xss too.
+	 */
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~XFEATURE_CET_USER;
+
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
 #undef __kvm_cpu_cap_has
-- 
2.27.0

