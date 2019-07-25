Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC379743B7
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 05:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389779AbfGYDLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 23:11:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:24587 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389769AbfGYDLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 23:11:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 20:11:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,305,1559545200"; 
   d="scan'208";a="321537735"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 24 Jul 2019 20:11:22 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v6 3/8] KVM: x86: Implement CET CPUID enumeration for Guest
Date:   Thu, 25 Jul 2019 11:12:41 +0800
Message-Id: <20190725031246.8296-4-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190725031246.8296-1-weijiang.yang@intel.com>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID.(EAX=7, ECX=0):ECX[bit 7] and EDX[bit 20] correspond to
CET SHSTK and IBT respectively.
CET xsave components for supervisor and user mode are reported
via CPUID.(EAX=0xD, ECX=1):ECX[bit 11] and ECX[bit 12]
respectively.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 52 ++++++++++++---------------------
 arch/x86/kvm/vmx/vmx.c          |  6 ++++
 arch/x86/kvm/x86.h              |  4 +++
 4 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 26d1eb83f72a..3731ac37119a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1199,6 +1199,7 @@ struct kvm_x86_ops {
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+	u64 (*supported_xss)(void);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 29cbde7538a3..d96269a6bcf5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -62,6 +62,11 @@ u64 kvm_supported_xcr0(void)
 	return xcr0;
 }
 
+u64 kvm_supported_xss(void)
+{
+	return KVM_SUPPORTED_XSS & kvm_x86_ops->supported_xss();
+}
+
 #define F(x) bit(X86_FEATURE_##x)
 
 int kvm_update_cpuid(struct kvm_vcpu *vcpu)
@@ -446,13 +451,13 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | F(SHSTK);
 
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR);
+		F(MD_CLEAR) | F(IBT);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
@@ -608,44 +613,23 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	}
 	case 0xd: {
-		int idx, i;
-		u64 supported = kvm_supported_xcr0();
+		u64 u_supported = kvm_supported_xcr0();
+		u64 s_supported = kvm_supported_xss();
+		u32 eax_mask = kvm_cpuid_D_1_eax_x86_features;
 
-		entry->eax &= supported;
-		entry->ebx = xstate_required_size(supported, false);
+		entry->eax &= u_supported;
+		entry->ebx = xstate_required_size(u_supported, false);
 		entry->ecx = entry->ebx;
-		entry->edx &= supported >> 32;
+		entry->edx &= u_supported >> 32;
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-		if (!supported)
+
+		if (!u_supported && !s_supported)
 			break;
 
-		for (idx = 1, i = 1; idx < 64; ++idx) {
-			u64 mask = ((u64)1 << idx);
-			if (*nent >= maxnent)
-				goto out;
+		if (__do_cpuid_dx_leaf(entry, nent, maxnent, s_supported,
+				       u_supported, eax_mask) < 0)
+			goto out;
 
-			do_cpuid_1_ent(&entry[i], function, idx);
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
-			entry[i].flags |=
-			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-			++*nent;
-			++i;
-		}
 		break;
 	}
 	/* Intel PT */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 652b3876ea5c..ce1d6fe21780 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1637,6 +1637,11 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
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
@@ -7724,6 +7729,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_vmcs12_pages = NULL,
 	.nested_enable_evmcs = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+	.supported_xss = vmx_supported_xss,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a470ff0868c5..6a1870044752 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -288,6 +288,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
+
+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER \
+				| XFEATURE_MASK_CET_KERNEL)
+
 extern u64 host_xcr0;
 
 extern u64 kvm_supported_xcr0(void);
-- 
2.17.2

