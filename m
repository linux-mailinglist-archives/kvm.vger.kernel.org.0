Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026142A8BDF
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 02:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733208AbgKFBGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 20:06:36 -0500
Received: from mga18.intel.com ([134.134.136.126]:38191 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733197AbgKFBGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 20:06:35 -0500
IronPort-SDR: W3yLWLwXCozOTqUs9IKy9HPnK4OVwoetx85udnAPUHSzBAwJEkZeD1d5o0NYbAYTEm8wjgYWt1
 ZlCvzSpa9YyA==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="157264711"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="157264711"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 17:06:34 -0800
IronPort-SDR: r0+OHauq2PfQBI4YHMUZkciIcs6e2RJZYKI3nywGVbbIb6aRqX0/u/B9ZMdSDv9jsz2C4GQyxY
 1Kqfw6RQvANA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="471874556"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga004.jf.intel.com with ESMTP; 05 Nov 2020 17:06:33 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v14 10/13] KVM: x86: Enable CET virtualization for VMX and advertise CET to userspace
Date:   Fri,  6 Nov 2020 09:16:34 +0800
Message-Id: <20201106011637.14289-11-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201106011637.14289-1-weijiang.yang@intel.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the feature bits so that CET capabilities can be seen in guest via
CPUID enumeration. Add CR4.CET bit support in order to allow guest set CET
master control bit(CR4.CET).

Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
KVM does not support emulating CET. Reset guest CET states in vmcs so as
to avoid vmentry failure when guest toggles CR4.CET bit, e.g. during guest
reboot.

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
 arch/x86/kvm/vmx/vmx.c          | 64 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.c              |  8 +++++
 5 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1620a2cca781..b3b5cb44e75b 100644
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
index 2c737337f466..6a888ee1c7db 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -405,7 +405,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+		F(SHSTK)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
@@ -422,7 +423,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE) | F(TSXLDTRK)
+		F(SERIALIZE) | F(TSXLDTRK) | F(IBT)
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
index 28ba8414a7a3..c88a6e1721b1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2279,7 +2279,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_U_CET:
 		if (!cet_is_control_msr_accessible(vcpu, msr_info))
 			return 1;
-		if (data & GENMASK(9, 6))
+		if ((data & GENMASK(9, 6)) || is_noncanonical_address(data, vcpu))
 			return 1;
 		if (msr_index == MSR_IA32_S_CET)
 			vmcs_writel(GUEST_S_CET, data);
@@ -2594,7 +2594,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_LOAD_IA32_EFER |
 	      VM_EXIT_CLEAR_BNDCFGS |
 	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
+	      VM_EXIT_CLEAR_IA32_RTIT_CTL |
+	      VM_EXIT_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
 				&_vmexit_control) < 0)
 		return -EIO;
@@ -2618,7 +2619,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_LOAD_IA32_EFER |
 	      VM_ENTRY_LOAD_BNDCFGS |
 	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
+	      VM_ENTRY_LOAD_IA32_RTIT_CTL |
+	      VM_ENTRY_LOAD_CET_STATE;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
 				&_vmentry_control) < 0)
 		return -EIO;
@@ -2646,6 +2648,15 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
 
@@ -3217,7 +3228,9 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	 * this bit, even if host CR4.MCE == 0.
 	 */
 	unsigned long hw_cr4;
+	unsigned long old_cr4;
 
+	old_cr4 = vmcs_readl(CR4_READ_SHADOW);
 	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
 	if (is_unrestricted_guest(vcpu))
 		hw_cr4 |= KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST;
@@ -3281,6 +3294,13 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	vmcs_writel(CR4_READ_SHADOW, cr4);
 	vmcs_writel(GUEST_CR4, hw_cr4);
+
+	if (((cr4 ^ old_cr4) & X86_CR4_CET) && kvm_cet_supported()) {
+		vmcs_writel(GUEST_SSP, 0);
+		vmcs_writel(GUEST_S_CET, 0);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
+	}
+
 	return 0;
 }
 
@@ -5961,6 +5981,12 @@ void dump_vmcs(void)
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
@@ -6035,6 +6061,12 @@ void dump_vmcs(void)
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
@@ -7409,6 +7441,15 @@ static __init void vmx_set_cpu_caps(void)
 
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
@@ -7837,6 +7878,8 @@ static __init int hardware_setup(void)
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
 	int r, i, ept_lpage_level;
+	u64 cet_msr;
+	bool accessible;
 
 	store_idt(&dt);
 	host_idt_base = dt.address;
@@ -7850,6 +7893,21 @@ static __init int hardware_setup(void)
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
index d573cadf5baf..a500c4e260af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10197,6 +10197,14 @@ int kvm_arch_hardware_setup(void *opaque)
 
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
2.17.2

