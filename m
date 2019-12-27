Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCD712B069
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2019 03:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfL0CH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Dec 2019 21:07:27 -0500
Received: from mga17.intel.com ([192.55.52.151]:38918 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfL0CH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Dec 2019 21:07:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 18:07:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,361,1571727600"; 
   d="scan'208";a="223675021"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 26 Dec 2019 18:07:26 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 1/7] KVM: CPUID: Fix IA32_XSS support in CPUID(0xd,i) enumeration
Date:   Fri, 27 Dec 2019 10:11:27 +0800
Message-Id: <20191227021133.11993-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191227021133.11993-1-weijiang.yang@intel.com>
References: <20191227021133.11993-1-weijiang.yang@intel.com>
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
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/cpuid.c            | 105 ++++++++++++++++++++++----------
 arch/x86/kvm/svm.c              |   7 +++
 arch/x86/kvm/vmx/vmx.c          |   8 +++
 arch/x86/kvm/x86.h              |   7 +++
 5 files changed, 97 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4fc61483919a..4e59f17ded50 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1216,6 +1216,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+
+	u64 (*supported_xss)(void);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f68c0c753c38..546cfe123ba7 100644
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
@@ -426,6 +437,58 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
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
@@ -440,7 +503,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_lm = 0;
 #endif
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
-	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 
 	/* cpuid 1.edx */
@@ -495,10 +557,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
 		F(PMM) | F(PMM_EN);
 
-	/* cpuid 0xD.1.eax */
-	const u32 kvm_cpuid_D_1_eax_x86_features =
-		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
-
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
 
@@ -639,38 +697,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
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
index c5673bda4b66..0b596efddf31 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7178,6 +7178,11 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
 }
 
+static u64 svm_supported_xss(void)
+{
+	return 0;
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7316,6 +7321,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.supported_xss = svm_supported_xss,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7cd6c5e67337..477173e4a85d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1743,6 +1743,11 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
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
@@ -7898,7 +7903,10 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.nested_enable_evmcs = NULL,
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+
+	.supported_xss = vmx_supported_xss,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index dbf7442a822b..c29783afebed 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -293,6 +293,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
+
+/*
+ * In future, applicable XSS state bits can be added here
+ * to make them available to KVM and guest.
+ */
+#define KVM_SUPPORTED_XSS	0
+
 extern u64 host_xcr0;
 
 extern u64 kvm_supported_xcr0(void);
-- 
2.17.2

