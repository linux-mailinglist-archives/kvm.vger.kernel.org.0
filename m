Return-Path: <kvm+bounces-5003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A024581B1E9
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:17:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09F5F1F2231E
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEDA6584C1;
	Thu, 21 Dec 2023 09:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SNdoiLV4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDB0563AF;
	Thu, 21 Dec 2023 09:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149433; x=1734685433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=joyrJlds/SFQrii3K4ni5puSmr15f7iVA1rz6BGV/qY=;
  b=SNdoiLV45e0XXtjoL4VbqotK7mZ50ccoASHtF7YdOEJWuQAzlA+joQZx
   7bxwLWl+DKjURfVRZJSQtrS6WULLe0gzp4GmMX8VwKrGtEwNrRJ2hAFKV
   rmh14+zpt6u7+CS/IuN9mEAd1fX0KEhdw6xl1bMPgk19XqiFR1/euAglz
   fQ+7it9XNIYt2VsIXRQ3y6XHnV7SeBlRZr0+U+sMKSx7c9CLoXHZc8gJk
   a/DChhdJawIpkIHYgRLuZM/dKYaOSSZoHtbJ1XiNEA6Ma3r1jRtkpGFCf
   4XadJF4ngSWM2KcG7kzMUhTjMcXjbpM6QAN86urfqprGDbSIka6EvUozJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729699"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729699"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028644"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028644"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:12 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v8 24/26] KVM: x86: Enable CET virtualization for VMX and advertise to userspace
Date: Thu, 21 Dec 2023 09:02:37 -0500
Message-Id: <20231221140239.4349-25-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose CET features to guest if KVM/host can support them, clear CPUID
feature bits if KVM/host cannot support.

Set CPUID feature bits so that CET features are available in guest CPUID.
Add CR4.CET bit support in order to allow guest set CET master control
bit.

Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
KVM does not support emulating CET.

The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
guest CET xstates isolated from host's.

On platforms with VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error
code will fail, and if VMX_BASIC[bit56] == 1, #CP injection with or without
error code is allowed. Disable CET feature bits if the MSR bit is cleared
so that nested VMM can inject #CP if and only if VMX_BASIC[bit56] == 1.

Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
in host XSS or if XSAVES isn't supported.

CET MSR contents after reset, power-up and INIT are set to 0s, clears the
guest fpstate fields so that the guest MSRs are reset to 0s after the events.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h  |  2 +-
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/cpuid.c             | 19 +++++++++++++++++--
 arch/x86/kvm/vmx/capabilities.h  |  6 ++++++
 arch/x86/kvm/vmx/vmx.c           | 29 ++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h           |  6 ++++--
 arch/x86/kvm/x86.c               | 31 +++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.h               |  3 +++
 8 files changed, 89 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6efaaaa15945..161d0552be5f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -134,7 +134,7 @@
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
-			  | X86_CR4_LAM_SUP))
+			  | X86_CR4_LAM_SUP | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d51e1850ed0..233e00c01e62 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1102,6 +1102,7 @@
 #define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
 #define VMX_BASIC_MEM_TYPE_WB	6LLU
 #define VMX_BASIC_INOUT		0x0040000000000000LLU
+#define VMX_BASIC_NO_HW_ERROR_CODE_CC	0x0100000000000000LLU
 
 /* Resctrl MSRs: */
 /* - Intel: */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cfc0ac8ddb4a..18d1a0eb0f64 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -665,7 +665,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
-		F(SGX_LC) | F(BUS_LOCK_DETECT)
+		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
@@ -683,7 +683,8 @@ void kvm_set_cpu_caps(void)
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
-		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D) |
+		F(IBT)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
+	/*
+	 * Don't use boot_cpu_has() to check availability of IBT because the
+	 * feature bit is cleared in boot_cpu_data when ibt=off is applied
+	 * in host cmdline.
+	 *
+	 * As currently there's no HW bug which requires disabling IBT feature
+	 * while CPU can enumerate it, host cmdline option ibt=off is most
+	 * likely due to administrative reason on host side, so KVM refers to
+	 * CPU CPUID enumeration to enable the feature. In future if there's
+	 * actually some bug clobbered ibt=off option, then enforce additional
+	 * check here to disable the support in KVM.
+	 */
+	if (cpuid_edx(7) & F(IBT))
+		kvm_cpu_cap_set(X86_FEATURE_IBT);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index ee8938818c8a..e12bc233d88b 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -79,6 +79,12 @@ static inline bool cpu_has_vmx_basic_inout(void)
 	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
 }
 
+static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
+{
+	return	((u64)vmcs_config.basic_cap << 32) &
+		 VMX_BASIC_NO_HW_ERROR_CODE_CC;
+}
+
 static inline bool cpu_has_virtual_nmis(void)
 {
 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e9c0b571b3bb..c802e790c0d5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2609,6 +2609,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
@@ -4934,6 +4935,15 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+		vmcs_writel(GUEST_SSP, 0);
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
+	    kvm_cpu_cap_has(X86_FEATURE_IBT))
+		vmcs_writel(GUEST_S_CET, 0);
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    IS_ENABLED(CONFIG_X86_64))
+		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
+
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	vpid_sync_context(vmx->vpid);
@@ -6353,6 +6363,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
 		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
+	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE) {
+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
+		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
+		pr_err("INTR SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(GUEST_INTR_SSP_TABLE));
+	}
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
@@ -6430,6 +6446,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
 		pr_err("Virtual processor ID = 0x%04x\n",
 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
+	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE) {
+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
+		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
+		pr_err("INTR SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(HOST_INTR_SSP_TABLE));
+	}
 }
 
 /*
@@ -7966,7 +7988,6 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
@@ -7978,6 +7999,12 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
+	    !cpu_has_vmx_basic_no_hw_errcode()) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	}
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e3b0985bb74a..d0cad2624564 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -484,7 +484,8 @@ static inline u8 vmx_get_rvi(void)
 	 VM_ENTRY_LOAD_IA32_EFER |					\
 	 VM_ENTRY_LOAD_BNDCFGS |					\
 	 VM_ENTRY_PT_CONCEAL_PIP |					\
-	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
+	 VM_ENTRY_LOAD_CET_STATE)
 
 #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
@@ -506,7 +507,8 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
+	       VM_EXIT_LOAD_CET_STATE)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9596763fae8d..5058c9c5f4cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -231,7 +231,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
-#define KVM_SUPPORTED_XSS     0
+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
+				 XFEATURE_MASK_CET_KERNEL)
 
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
@@ -9921,6 +9922,20 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		kvm_caps.supported_xss = 0;
 
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~(XFEATURE_CET_USER |
+					    XFEATURE_CET_KERNEL);
+
+	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
+	     XFEATURE_MASK_CET_KERNEL)) !=
+	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~(XFEATURE_CET_USER |
+					    XFEATURE_CET_KERNEL);
+	}
+
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
 #undef __kvm_cpu_cap_has
@@ -12392,7 +12407,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 static inline bool is_xstate_reset_needed(void)
 {
-	return kvm_cpu_cap_has(X86_FEATURE_MPX);
+	return kvm_cpu_cap_has(X86_FEATURE_MPX) ||
+	       kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
+	       kvm_cpu_cap_has(X86_FEATURE_IBT);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -12469,6 +12486,16 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 						       XFEATURE_BNDCSR);
 		}
 
+		if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+			fpstate_clear_xstate_component(fpstate,
+						       XFEATURE_CET_USER);
+			fpstate_clear_xstate_component(fpstate,
+						       XFEATURE_CET_KERNEL);
+		} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+			fpstate_clear_xstate_component(fpstate,
+						       XFEATURE_CET_USER);
+		}
+
 		if (init_event)
 			kvm_load_guest_fpu(vcpu);
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 656107e64c93..cc585051d24b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -533,6 +533,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_PCIDE;       \
 	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
 		__reserved_bits |= X86_CR4_LAM_SUP;     \
+	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
+	    !__cpu_has(__c, X86_FEATURE_IBT))           \
+		__reserved_bits |= X86_CR4_CET;         \
 	__reserved_bits;                                \
 })
 
-- 
2.39.3


