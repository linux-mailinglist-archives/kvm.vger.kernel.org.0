Return-Path: <kvm+bounces-9036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D954E859DA3
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C97B7B22F43
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111D944386;
	Mon, 19 Feb 2024 07:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WnP60YHF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E1F383AB;
	Mon, 19 Feb 2024 07:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328880; cv=none; b=SrfZNXPyO28tfbOUbLtgiIOdPNGbiwR9anqUpqL85LXLSl3/+iX3vUBN7gdNz5ylGx32t+N2Vno4DUn23N9DrxTeHS+XBu9E+eHahFTmhosB5RqcSPUYOda2SnUa6bEHogEto6PKt4d+ZG/Dkrh+ExOcf80yH8aF9y3+OYx/kxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328880; c=relaxed/simple;
	bh=DCjPPc/YW+5nlsJpiVIipFWghIYTaoPxr0s0Kqx5JLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7xM/fKpJxZLMN0Q9FlnnS00e7rTnQ+YqQbedcgrXTAnDq/dGfbztqUyUn0OPhDL7u2n0OrrmRtjtp470Qmlveb6HtFnS1ahnt6k53/fmbb5J0TRMxI4rDbU1RH5X/yvJkeGI3jELcOd5tPyu6RW5ukYZeMs+8/TYq2Gvne6pxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WnP60YHF; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328876; x=1739864876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DCjPPc/YW+5nlsJpiVIipFWghIYTaoPxr0s0Kqx5JLU=;
  b=WnP60YHF/J7wMTr7Ui8Uca75iecRRrp/iMXkrLc86J7ICSeB1spGTQgT
   7x1CH9j/+c3iOv//y7hS2oYZ0ISZFJUhWXw6iXm+xLd+e5sbw1OwbKthW
   xpiuO/Aa1Z84WzHp0iz4D7dGz/rUHVq3WSnAcjqtL2Y6qTjb75PpykieP
   OzTXdBZnztG/MAh/AXhdEgYgPllWygl6+hJTqaKSiAhmYDqksbGKyfnhm
   czAmzpgMYMn3fZQHPeBpWPSWBS17SmuO/M5u1HsHYxmbzLUJNUh+KS/xs
   oEb6NnieRuzLg0uxoGnrlqDWTOg038Gx1ue6evfGPZ+K+6xfyVW/kz+ND
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535165"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535165"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966131"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966131"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and advertise to userspace
Date: Sun, 18 Feb 2024 23:47:30 -0800
Message-ID: <20240219074733.122080-25-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h  |  2 +-
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/cpuid.c             | 25 ++++++++++++++++++++-----
 arch/x86/kvm/vmx/capabilities.h  |  6 ++++++
 arch/x86/kvm/vmx/vmx.c           | 30 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h           |  6 ++++--
 arch/x86/kvm/x86.c               | 26 ++++++++++++++++++++++++--
 arch/x86/kvm/x86.h               |  3 +++
 8 files changed, 88 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 79f7c18c487b..3b263fa171a1 100644
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
index f1bd7b91b3c6..4aa9aaa295f0 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1110,6 +1110,7 @@
 #define VMX_BASIC_MEM_TYPE_MASK	0x003c000000000000LLU
 #define VMX_BASIC_MEM_TYPE_WB	6LLU
 #define VMX_BASIC_INOUT		0x0040000000000000LLU
+#define VMX_BASIC_NO_HW_ERROR_CODE_CC	0x0100000000000000LLU
 
 /* Resctrl MSRs: */
 /* - Intel: */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c0e13040e35b..d37f41472043 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -150,14 +150,14 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 	}
 	/*
-	 * Prevent 32-bit guest launch if shadow stack is exposed as SSP
-	 * state is not defined for 32-bit SMRAM.
+	 * CET is not supported for 32-bit guest, prevent guest launch if
+	 * shadow stack or IBT is enabled for 32-bit guest.
 	 */
 	best = cpuid_entry2_find(entries, nent, 0x80000001,
 				 KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	if (best && !(best->edx & F(LM))) {
 		best = cpuid_entry2_find(entries, nent, 0x7, 0);
-		if (best && (best->ecx & F(SHSTK)))
+		if (best && ((best->ecx & F(SHSTK)) || (best->edx & F(IBT))))
 			return -EINVAL;
 	}
 
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
index 342b5b94c892..9df25c9e80f5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2609,6 +2609,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
@@ -4934,6 +4935,14 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		vmcs_writel(GUEST_SSP, 0);
+		vmcs_writel(GUEST_S_CET, 0);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
+	} else if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		vmcs_writel(GUEST_S_CET, 0);
+	}
+
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	vpid_sync_context(vmx->vpid);
@@ -6353,6 +6362,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
 		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
+	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE)
+		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(GUEST_S_CET), vmcs_readl(GUEST_SSP),
+		       vmcs_readl(GUEST_INTR_SSP_TABLE));
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
@@ -6383,6 +6396,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
 	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
 		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
+	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE)
+		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(HOST_S_CET), vmcs_readl(HOST_SSP),
+		       vmcs_readl(HOST_INTR_SSP_TABLE));
 
 	pr_err("*** Control State ***\n");
 	pr_err("CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
@@ -7965,7 +7982,6 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
@@ -7977,6 +7993,18 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	/*
+	 * Disable CET if unrestricted_guest is unsupported as KVM doesn't
+	 * enforce CET HW behaviors in emulator. On platforms with
+	 * VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error code
+	 * fails, so disable CET in this case too.
+	 */
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
index 73a55d388dd9..cd656099fbfd 100644
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
@@ -9943,6 +9944,20 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		kvm_caps.supported_xss = 0;
 
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
+					    XFEATURE_MASK_CET_KERNEL);
+
+	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
+	     XFEATURE_MASK_CET_KERNEL)) !=
+	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
+					    XFEATURE_MASK_CET_KERNEL);
+	}
+
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
 #undef __kvm_cpu_cap_has
@@ -12402,7 +12417,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 }
 
 #define XSTATE_NEED_RESET_MASK	(XFEATURE_MASK_BNDREGS | \
-				 XFEATURE_MASK_BNDCSR)
+				 XFEATURE_MASK_BNDCSR | \
+				 XFEATURE_MASK_CET_USER | \
+				 XFEATURE_MASK_CET_KERNEL)
 
 static bool kvm_vcpu_has_xstate(unsigned long xfeature)
 {
@@ -12410,6 +12427,11 @@ static bool kvm_vcpu_has_xstate(unsigned long xfeature)
 	case XFEATURE_MASK_BNDREGS:
 	case XFEATURE_MASK_BNDCSR:
 		return kvm_cpu_cap_has(X86_FEATURE_MPX);
+	case XFEATURE_CET_USER:
+		return kvm_cpu_cap_has(X86_FEATURE_SHSTK) ||
+		       kvm_cpu_cap_has(X86_FEATURE_IBT);
+	case XFEATURE_CET_KERNEL:
+		return kvm_cpu_cap_has(X86_FEATURE_SHSTK);
 	default:
 		return false;
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
2.43.0


