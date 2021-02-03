Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D1A30D88C
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhBCLY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:24:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:28338 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234200AbhBCLXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:23:48 -0500
IronPort-SDR: d27PlhUwqqWugcR97DU+1teertJLjmLHMUMoIm+dQcRKRLOiEQbj6nFzM1bo0UdRvstXYIDGVs
 fmFXSKDki9tA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981314"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981314"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:25 -0800
IronPort-SDR: NVw1tSHmUeOBRWJa5BP+vKqNwF6bm1PJB6A4fMeo205+gAbbFlQ4RpJoFb05KBJu6to8K6CI/g
 dj6yz7ACU96Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311193"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:23 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 10/14] KVM: x86: Enable CET virtualization for VMX and advertise CET to userspace
Date:   Wed,  3 Feb 2021 19:34:17 +0800
Message-Id: <20210203113421.5759-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210203113421.5759-1-weijiang.yang@intel.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
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
a little ugly, but there is on clean solution without risking breakage of
SVM if SVM hardware ever gains support for CET, e.g. moving everything to
common x86 would prematurely expose CET on SVM.  The alternative is to
put all the logic in VMX, but that means rereading host_xss in VMX and
duplicating the XSAVES check across VMX and SVM.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/cpuid.c            |  5 +--
 arch/x86/kvm/vmx/capabilities.h |  5 +++
 arch/x86/kvm/vmx/vmx.c          | 55 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |  8 +++++
 5 files changed, 70 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1734f872712d..3955e76dce96 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -100,7 +100,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6d7d9d59fd5b..46087bca9418 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -417,7 +417,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+		F(SHSTK)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
@@ -434,7 +435,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16)
+		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) | F(IBT)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 3a1861403d73..58cb57b08697 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -103,6 +103,11 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
 }
 
+static inline bool cpu_has_load_cet_ctrl(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE) &&
+	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_CET_STATE);
+}
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cd6a9710a51..c2242fc1f71a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2278,7 +2278,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_U_CET:
 		if (!cet_is_control_msr_accessible(vcpu, msr_info))
 			return 1;
-		if (data & GENMASK(9, 6))
+		if ((data & GENMASK(9, 6)) || is_noncanonical_address(data, vcpu))
 			return 1;
 		if (msr_index == MSR_IA32_S_CET)
 			vmcs_writel(GUEST_S_CET, data);
@@ -2593,7 +2593,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2617,7 +2618,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -2645,6 +2647,15 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		}
 	}
 
+	/*
+	 * The CET entry and exit controls need to be synchronized, e.g. to
+	 * avoid loading guest state but not restoring host state.
+	 */
+	if (!(_vmentry_control & VM_ENTRY_LOAD_CET_STATE) ||
+	    !(_vmexit_control & VM_EXIT_LOAD_CET_STATE)) {
+		_vmentry_control &= ~VM_ENTRY_LOAD_CET_STATE;
+		_vmexit_control &= ~VM_EXIT_LOAD_CET_STATE;
+	}
 
 	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
 
@@ -5943,6 +5954,12 @@ void dump_vmcs(void)
 		pr_err("InterruptStatus = %04x\n",
 		       vmcs_read16(GUEST_INTR_STATUS));
 
+	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE) {
+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
+		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
+		pr_err("SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(GUEST_INTR_SSP_TABLE));
+	}
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
@@ -6017,6 +6034,12 @@ void dump_vmcs(void)
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
@@ -7395,6 +7418,15 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	} else if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
+		   kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		supported_xss |= XFEATURE_MASK_CET_USER |
+				 XFEATURE_MASK_CET_KERNEL;
+	}
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
@@ -7833,6 +7865,8 @@ static __init int hardware_setup(void)
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
 	int r, i, ept_lpage_level;
+	u64 cet_msr;
+	bool accessible;
 
 	store_idt(&dt);
 	host_idt_base = dt.address;
@@ -7846,6 +7880,21 @@ static __init int hardware_setup(void)
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
+	accessible = (supported_xss & XFEATURE_MASK_CET_KERNEL) &&
+		     (boot_cpu_has(X86_FEATURE_IBT) ||
+		      boot_cpu_has(X86_FEATURE_SHSTK));
+	if (accessible) {
+		rdmsrl(MSR_IA32_S_CET, cet_msr);
+		WARN_ONCE(cet_msr, "KVM: CET S_CET in host will be lost!\n");
+	}
+
+	accessible = (supported_xss & XFEATURE_MASK_CET_KERNEL) &&
+		     boot_cpu_has(X86_FEATURE_SHSTK);
+	if (accessible) {
+		rdmsrl(MSR_IA32_PL0_SSP, cet_msr);
+		WARN_ONCE(cet_msr, "KVM: CET PL0_SSP in host will be lost!\n");
+	}
+
 	if (boot_cpu_has(X86_FEATURE_MPX)) {
 		rdmsrl(MSR_IA32_BNDCFGS, host_bndcfgs);
 		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 059e101daf94..22eb6b8626a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10329,6 +10329,14 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
+	else
+		supported_xss &= host_xss;
+
+	/* Update CET features now that supported_xss is finalized. */
+	if (!kvm_cet_supported()) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	}
 
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
-- 
2.26.2

