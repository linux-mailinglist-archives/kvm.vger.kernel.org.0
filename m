Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A962158A1A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 07:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBKGxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 01:53:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:28362 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgBKGxJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 01:53:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2020 22:53:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,427,1574150400"; 
   d="scan'208";a="405848668"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 10 Feb 2020 22:53:06 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, jmattson@google.com,
        aaronlewis@google.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [RFC PATCH 1/2] KVM: CPUID: Enable supervisor XSAVE states in CPUID enumeration and XSS
Date:   Tue, 11 Feb 2020 14:57:05 +0800
Message-Id: <20200211065706.3462-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID.(EAX=DH, ECX={i}H i>=0) enumerates XSAVE related leaves/sub-leaves,
but supervisor states are not taken into account. Meanwhile,more and more
new features, e.g., CET, PT, LBR, rely on supervisor states to enhance
performance, so updating related KVM code becomes necessary.

With Aaron Lewis's <aaronlewis@google.com> patches in place, i.e.,
{c90992bfb080, 52297436199d, 864e2ab2b46d, 139a12cfe1a0, 9753d68865c5,
312a1c87798e, 78958563d802, c034f2aa8622, 7204160eb780}, this patch
is to enable suppervisor XSAVE states support in CPUID enumeration and
MSR IA32_XSS. KVM_SUPPORTED_XSS is a static mask for KVM/Guest supervisor
states and guest_supported_xss is a dynamic mask which consolidates
current host IA32_XSS and QEMU configuration together with static mask.

Right now, supervisor states in IA32_XSS haven't been used in upstreamed
KVM code, so set KVM_SUPPORTED_XSS to 0 in the patch, new XSAVES related
features can expand the macro to enable save/restore with XSAVES/XSTORS
instruction.

To test the patch, I first set the KVM_SUPPORTED_XSS to 0x3900 and inject
value to IA32_XSS too, 0x3900 corresponds to the most recent possible
candidate supervisor states on Intel platforms, tested on TGL platform as
results below:

cpuid.[d.0]: eax = 0x000002e7, ebx = 0x00000a88, ecx = 0x00000a88, edx = 0x00000000
cpuid.[d.1]: eax = 0x0000000f, ebx = 0x00000a38, ecx = 0x00003900, edx = 0x00000000
cpuid.[d.2]: eax = 0x00000100, ebx = 0x00000240, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.5]: eax = 0x00000040, ebx = 0x00000440, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.6]: eax = 0x00000200, ebx = 0x00000480, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.7]: eax = 0x00000400, ebx = 0x00000680, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.8]: eax = 0x00000080, ebx = 0x00000000, ecx = 0x00000001, edx = 0x00000000
cpuid.[d.9]: eax = 0x00000008, ebx = 0x00000a80, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.11]: eax = 0x00000010, ebx = 0x00000000, ecx = 0x00000001, edx = 0x00000000
cpuid.[d.12]: eax = 0x00000018, ebx = 0x00000000, ecx = 0x00000001, edx = 0x00000000
cpuid.[d.13]: eax = 0x00000008, ebx = 0x00000000, ecx = 0x00000001, edx = 0x00000000
bit[8] in MSR_IA32_XSS is supported
bit[11] in MSR_IA32_XSS is supported
bit[12] in MSR_IA32_XSS is supported
bit[13] in MSR_IA32_XSS is supported
Supported bit mask in MSR_IA32_XSS is : 0x3900

When IA32_XSS and KVM_SUPPORTED_XSS are 0, got below output:
cpuid.[d.0]: eax = 0x000002e7, ebx = 0x00000a88, ecx = 0x00000a88, edx = 0x00000000
cpuid.[d.1]: eax = 0x0000000f, ebx = 0x00000988, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.2]: eax = 0x00000100, ebx = 0x00000240, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.5]: eax = 0x00000040, ebx = 0x00000440, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.6]: eax = 0x00000200, ebx = 0x00000480, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.7]: eax = 0x00000400, ebx = 0x00000680, ecx = 0x00000000, edx = 0x00000000
cpuid.[d.9]: eax = 0x00000008, ebx = 0x00000a80, ecx = 0x00000000, edx = 0x00000000
Supported bit mask in MSR_IA32_XSS is : 0x0

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/cpuid.c            | 111 ++++++++++++++++++++++----------
 arch/x86/kvm/x86.c              |   4 +-
 arch/x86/kvm/x86.h              |   8 +++
 4 files changed, 87 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b79cd6aa4075..627284fa4369 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -638,6 +638,7 @@ struct kvm_vcpu_arch {
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
 	u32 guest_xstate_size;
 
 	struct kvm_pio_request pio;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index cfafa320a8cf..9546271d4038 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -62,6 +62,12 @@ u64 kvm_supported_xcr0(void)
 	return xcr0;
 }
 
+extern int host_xss;
+u64 kvm_supported_xss(void)
+{
+	return KVM_SUPPORTED_XSS & host_xss;
+}
+
 #define F(x) bit(X86_FEATURE_##x)
 
 int kvm_update_cpuid(struct kvm_vcpu *vcpu)
@@ -112,10 +118,17 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		vcpu->arch.guest_xstate_size = best->ebx =
 			xstate_required_size(vcpu->arch.xcr0, false);
 	}
-
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
-	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+	if (best && (best->eax & (F(XSAVES) | F(XSAVEC)))) {
+		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
+
+		best->ebx = xstate_required_size(xstate, true);
+		vcpu->arch.guest_supported_xss =
+			(best->ecx | ((u64)best->edx << 32)) &
+			kvm_supported_xss();
+	} else {
+		vcpu->arch.guest_supported_xss = 0;
+	}
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -426,6 +439,56 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
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
+		if (!u_supported) {
+			entry->eax = 0;
+			entry->ebx = 0;
+			entry->ecx = 0;
+			entry->edx = 0;
+			return false;
+		}
+		entry->eax &= u_supported;
+		entry->ebx = xstate_required_size(u_supported, false);
+		entry->ecx = entry->ebx;
+		entry->edx &= u_supported >> 32;
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
+
+			if (entry[i].eax == 0 && entry[i].ebx == 0 &&
+			    entry[i].ecx == 0 && entry[i].edx == 0)
+				continue;
+
+			if (!do_cpuid_0xd_mask(&entry[i], idx))
+				continue;
 			++*nent;
 			++i;
 		}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf917139de6b..908a6cdb2151 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -177,7 +177,7 @@ struct kvm_shared_msrs {
 static struct kvm_shared_msrs_global __read_mostly shared_msrs_global;
 static struct kvm_shared_msrs __percpu *shared_msrs;
 
-static u64 __read_mostly host_xss;
+u64 __read_mostly host_xss;
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "pf_fixed", VCPU_STAT(pf_fixed) },
@@ -2732,7 +2732,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * RDMSR/WRMSR rather than XSAVES/XRSTORS to save/restore PT
 		 * MSRs.
 		 */
-		if (data != 0)
+		if (data & ~vcpu->arch.guest_supported_xss)
 			return 1;
 		vcpu->arch.ia32_xss = data;
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 29391af8871d..9e7725f8bb46 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -296,6 +296,14 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
 				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
+
+/*
+ * In future, new XSS bits can be ORed here to make them available
+ * to KVM and guest, right now, it's 0, meaning no XSS bits are
+ * supported.
+ */
+#define KVM_SUPPORTED_XSS 0
+
 extern u64 host_xcr0;
 
 extern u64 kvm_supported_xcr0(void);
-- 
2.17.2

