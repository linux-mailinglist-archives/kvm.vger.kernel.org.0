Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE62EC006
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 09:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfKAItx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 04:49:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:34433 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbfKAItw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 04:49:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 01:49:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,254,1569308400"; 
   d="scan'208";a="194606595"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga008.jf.intel.com with ESMTP; 01 Nov 2019 01:49:49 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 1/7] KVM: CPUID: Fix IA32_XSS support in CPUID(0xd,i) enumeration
Date:   Fri,  1 Nov 2019 16:52:16 +0800
Message-Id: <20191101085222.27997-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191101085222.27997-1-weijiang.yang@intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The control bits in IA32_XSS MSR are being used for new features,
but current CPUID(0xd,i) enumeration code doesn't support them, so
fix existing code first.

The supervisor states in IA32_XSS haven't been used in public
KVM code, so set KVM_SUPPORTED_XSS to 0 now, anyone who's developing
IA32_XSS related feature may expand the macro to add the CPUID support,
otherwise, CPUID(0xd,i>1) always reports 0 of the subleaf to guest.

Extracted old code into a new filter and keep it same flavor as others.

This patch passed selftest on a few Intel platforms.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/cpuid.c            | 105 ++++++++++++++++++++++----------
 arch/x86/kvm/svm.c              |   7 +++
 arch/x86/kvm/vmx/vmx.c          |   6 ++
 arch/x86/kvm/x86.h              |   7 +++
 5 files changed, 94 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 74e88e5edd9c..d018df8c5f32 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1209,6 +1209,7 @@ struct kvm_x86_ops {
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+	u64 (*supported_xss)(void);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 22c2720cd948..dd387a785c1e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -62,6 +62,17 @@ u64 kvm_supported_xcr0(void)
 	return xcr0;
 }
 
+u64 kvm_supported_xss(void)
+{
+	u64 kvm_xss = KVM_SUPPORTED_XSS & kvm_x86_ops->supported_xss();
+
+	if (!kvm_x86_ops->xsaves_supported())
+		return 0;
+
+	return kvm_xss;
+}
+EXPORT_SYMBOL_GPL(kvm_supported_xss);
+
 #define F(x) bit(X86_FEATURE_##x)
 
 int kvm_update_cpuid(struct kvm_vcpu *vcpu)
@@ -414,6 +425,58 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 	}
 }
 
+static inline bool do_cpuid_0xd_mask(struct kvm_cpuid_entry2 *entry, int index)
+{
+	unsigned int f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
+	/* cpuid 0xD.1.eax */
+	const u32 kvm_cpuid_D_1_eax_x86_features =
+		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
+	u64 u_supported = kvm_supported_xcr0();
+	u64 s_supported = kvm_supported_xss();
+	u64 supported;
+
+	switch (index) {
+	case 0:
+		entry->eax &= u_supported;
+		entry->ebx = xstate_required_size(u_supported, false);
+		entry->ecx = entry->ebx;
+		entry->edx &= u_supported >> 32;
+
+		if (!u_supported) {
+			entry->eax = 0;
+			entry->ebx = 0;
+			entry->ecx = 0;
+			entry->edx = 0;
+			return false;
+		}
+		break;
+	case 1:
+		supported = u_supported | s_supported;
+		entry->eax &= kvm_cpuid_D_1_eax_x86_features;
+		cpuid_mask(&entry->eax, CPUID_D_1_EAX);
+		entry->ebx = 0;
+		entry->edx &= s_supported >> 32;
+		entry->ecx &= s_supported;
+		if (entry->eax & (F(XSAVES) | F(XSAVEC)))
+			entry->ebx = xstate_required_size(supported, true);
+
+		break;
+	default:
+		supported = (entry->ecx & 0x1) ? s_supported : u_supported;
+		if (!(supported & (BIT_ULL(index)))) {
+			entry->eax = 0;
+			entry->ebx = 0;
+			entry->ecx = 0;
+			entry->edx = 0;
+			return false;
+		}
+		if (entry->ecx & 0x1)
+			entry->ebx = 0;
+		break;
+	}
+	return true;
+}
+
 static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 				  int *nent, int maxnent)
 {
@@ -428,7 +491,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_lm = 0;
 #endif
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
-	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 
 	/* cpuid 1.edx */
@@ -482,10 +544,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
 		F(PMM) | F(PMM_EN);
 
-	/* cpuid 0xD.1.eax */
-	const u32 kvm_cpuid_D_1_eax_x86_features =
-		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
-
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
 
@@ -622,38 +680,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	}
 	case 0xd: {
-		int idx, i;
-		u64 supported = kvm_supported_xcr0();
+		int i, idx;
 
-		entry->eax &= supported;
-		entry->ebx = xstate_required_size(supported, false);
-		entry->ecx = entry->ebx;
-		entry->edx &= supported >> 32;
-		if (!supported)
+		if (!do_cpuid_0xd_mask(&entry[0], 0))
 			break;
-
-		for (idx = 1, i = 1; idx < 64; ++idx) {
-			u64 mask = ((u64)1 << idx);
+		for (i = 1, idx = 1; idx < 64; ++idx) {
 			if (*nent >= maxnent)
 				goto out;
-
 			do_host_cpuid(&entry[i], function, idx);
-			if (idx == 1) {
-				entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
-				cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
-				entry[i].ebx = 0;
-				if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
-					entry[i].ebx =
-						xstate_required_size(supported,
-								     true);
-			} else {
-				if (entry[i].eax == 0 || !(supported & mask))
-					continue;
-				if (WARN_ON_ONCE(entry[i].ecx & 1))
-					continue;
-			}
-			entry[i].ecx = 0;
-			entry[i].edx = 0;
+			if (entry[i].eax == 0 && entry[i].ebx == 0 &&
+			    entry[i].ecx == 0 && entry[i].edx == 0)
+				continue;
+
+			if (!do_cpuid_0xd_mask(&entry[i], idx))
+				continue;
+
 			++*nent;
 			++i;
 		}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e0368076a1ef..be967bf9a81d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7193,6 +7193,11 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static u64 svm_supported_xss(void)
+{
+	return 0;
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7329,6 +7334,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.nested_get_evmcs_version = NULL,
 
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
+
+	.supported_xss = svm_supported_xss,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c6f6b05004d9..a84198cff397 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1651,6 +1651,11 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
 	return !(val & ~valid_bits);
 }
 
+static inline u64 vmx_supported_xss(void)
+{
+	return host_xss;
+}
+
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
@@ -7799,6 +7804,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.nested_enable_evmcs = NULL,
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+	.supported_xss = vmx_supported_xss,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6594020c0691..f10c12b5197d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -293,6 +293,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
+
+/*
+ * Right now, no XSS states are used on x86 platform,
+ * expand the macro for new features.
+ */
+#define KVM_SUPPORTED_XSS	0
+
 extern u64 host_xcr0;
 
 extern u64 kvm_supported_xcr0(void);
-- 
2.17.2

