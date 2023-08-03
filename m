Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B896276E1CC
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbjHCHhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbjHCHgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:16 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B749E1;
        Thu,  3 Aug 2023 00:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047941; x=1722583941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wm2XCAb9bRVJi4ilyUjYIez95nMsPWAgZHk7NlDWZyY=;
  b=KmAfsxHOYAWQWa8wHaSYYsOvN2wUhNll0JU7LYWo0pTEoMWwwvXu5yKz
   UtXK6vgiVdNDT9KsQYkQPn5O5RXLbNEib5U4vd7g5m6vR921lRvmm4iJR
   jhWOYk8zVks5KbvHVVAIFtzChA0DtMeqG410iPsfToGbgLcQmd9V6tido
   ksecJHlCsaZwywV8OlChVSytcfKj6MzWWGVIt1TBOzllXe3S7i61YaabP
   fCYnHHpt1vC9KHmHV1nsObvGK8bIP0PNepeAWRsTZgHme/SsEJH6T1zKi
   FUY3wftLFriWq9P1S48J3Yv3V9dq5j6+wUcvrcj6XKpt8pft8HSUdaXJd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708169"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708169"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888517"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888517"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:18 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 16/19] KVM:x86: Enable CET virtualization for VMX and advertise to userspace
Date:   Thu,  3 Aug 2023 00:27:29 -0400
Message-Id: <20230803042732.88515-17-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable CET related feature bits in KVM capabilities array and make
X86_CR4_CET available to guest. Remove the feature bits if host side
dependencies cannot be met.

Set the feature bits so that CET features are available in guest CPUID.
Add CR4.CET bit support in order to allow guest set CET master control
bit(CR4.CET).

Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
KVM does not support emulating CET.
Don't expose CET feature if dependent CET bit(U_CET) is cleared in host
XSS or if XSAVES isn't supported.

The CET bits in VM_ENTRY/VM_EXIT control fields should be set to make guest
CET states isolated from host side. CET is only available on platforms that
enumerate VMX_BASIC[bit 56] as 1.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h  |  3 ++-
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/cpuid.c             | 12 ++++++++++--
 arch/x86/kvm/vmx/capabilities.h  |  6 ++++++
 arch/x86/kvm/vmx/vmx.c           | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h           |  6 ++++--
 arch/x86/kvm/x86.c               | 16 +++++++++++++++-
 arch/x86/kvm/x86.h               |  3 +++
 8 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c50b555234fb..f883696723f4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -125,7 +125,8 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
+			  | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3aedae61af4f..7ce0850c6067 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1078,6 +1078,7 @@
 #define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
 #define VMX_BASIC_MEM_TYPE_WB	6LLU
 #define VMX_BASIC_INOUT		0x0040000000000000LLU
+#define VMX_BASIC_NO_HW_ERROR_CODE	0x0100000000000000LLU
 
 /* Resctrl MSRs: */
 /* - Intel: */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0338316b827c..1a601be7b4fa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -624,7 +624,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
 		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
-		F(SGX_LC) | F(BUS_LOCK_DETECT)
+		F(SGX_LC) | F(BUS_LOCK_DETECT) | F(SHSTK)
 	);
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
@@ -642,7 +642,8 @@ void kvm_set_cpu_caps(void)
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
-		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D) |
+		F(IBT)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -655,6 +656,13 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
+	/*
+	 * The feature bit in boot_cpu_data.x86_capability could have been
+	 * cleared due to ibt=off cmdline option, then add it back if CPU
+	 * supports IBT.
+	 */
+	if (cpuid_edx(7) & F(IBT))
+		kvm_cpu_cap_set(X86_FEATURE_IBT);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) |
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index b1883f6c08eb..2948a288d0b4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -79,6 +79,12 @@ static inline bool cpu_has_vmx_basic_inout(void)
 	return	(((u64)vmcs_config.basic_cap << 32) & VMX_BASIC_INOUT);
 }
 
+static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
+{
+	return	((u64)vmcs_config.basic_cap << 32) &
+		 VMX_BASIC_NO_HW_ERROR_CODE;
+}
+
 static inline bool cpu_has_virtual_nmis(void)
 {
 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96e22515ed13..2f2b6f7c33d9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2624,6 +2624,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
@@ -6357,6 +6358,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -6434,6 +6441,12 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -7970,6 +7983,13 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
+	    !cpu_has_vmx_basic_no_hw_errcode()) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~CET_XSTATE_MASK;
+	}
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 32384ba38499..4e88b5fb45e8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -481,7 +481,8 @@ static inline u8 vmx_get_rvi(void)
 	 VM_ENTRY_LOAD_IA32_EFER |					\
 	 VM_ENTRY_LOAD_BNDCFGS |					\
 	 VM_ENTRY_PT_CONCEAL_PIP |					\
-	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
+	 VM_ENTRY_LOAD_CET_STATE)
 
 #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
@@ -503,7 +504,8 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
+	       VM_EXIT_LOAD_CET_STATE)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa3e7f7c639f..aa92dec66f1e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -230,7 +230,7 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
 
-#define KVM_SUPPORTED_XSS     0
+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER)
 
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
@@ -9669,6 +9669,20 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	kvm_ops_update(ops);
 
+	if (!kvm_is_cet_supported()) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	}
+
+	/*
+	 * If SHSTK and IBT are not available in KVM, clear CET user bit in
+	 * kvm_caps.supported_xss so that kvm_is_cet__supported() returns
+	 * false when called.
+	 */
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~CET_XSTATE_MASK;
+
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);
 		if (r < 0)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e42e5263fcf7..373386fb9ed2 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -542,6 +542,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
+	    !__cpu_has(__c, X86_FEATURE_IBT))           \
+		__reserved_bits |= X86_CR4_CET;         \
 	__reserved_bits;                                \
 })
 
-- 
2.27.0

