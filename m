Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E6C35B93E
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhDLEWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:22:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:53377 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229888AbhDLEWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:18 -0400
IronPort-SDR: qj2uvmYZ9KoFgOPhu0I3qcQhFAtzi6U2zJWE+5QcyNoziRU0wrbri9Zh3rPzZV1Jz1VSFaZn7Y
 vQ1QCH3Wde/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="258083758"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="258083758"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:01 -0700
IronPort-SDR: s1J+Fi5QvcbEu3C/TlSqz9r/CiT3dHuyO47A3u/bHWu4vx2Rrd4BvWxLtJEgUGT4buhgsTHxUs
 l3HWZ5+jkC3Q==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030358"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:21:57 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v5 03/11] KVM: x86: Add support for reverse CPUID lookup of scattered features
Date:   Mon, 12 Apr 2021 16:21:35 +1200
Message-Id: <16cad8d00475f67867fb36701fc7fb7c1ec86ce1.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
References: <cover.1618196135.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Introduce a scheme that allows KVM's CPUID magic to support features
that are scattered in the kernel's feature words.  To advertise and/or
query guest support for CPUID-based features, KVM requires the bit
number of an X86_FEATURE_* to match the bit number in its associated
CPUID entry.  For scattered features, this does not hold true.

Add a framework to allow defining KVM-only words, stored in
kvm_cpu_caps after the shared kernel caps, that can be used to gather
the scattered feature bits by translating X86_FEATURE_* flags into their
KVM-defined feature.

Note, because reverse_cpuid_check() effectively forces kvm_cpu_caps
lookups to be resolved at compile time, there is no runtime cost for
translating from kernel-defined to kvm-defined features.

More details here:  https://lkml.kernel.org/r/X/jxCOLG+HUO4QlZ@google.com

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/cpuid.c | 32 +++++++++++++++++++++++++++-----
 arch/x86/kvm/cpuid.h | 39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6bd2f8b830e4..a0e7be9ed449 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -28,7 +28,7 @@
  * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
  * aligned to sizeof(unsigned long) because it's not accessed via bitops.
  */
-u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
+u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_cpu_caps);
 
 static u32 xstate_required_size(u64 xstate_bv, bool compacted)
@@ -53,6 +53,7 @@ static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 }
 
 #define F feature_bit
+#define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
 
 static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
 	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
@@ -347,13 +348,13 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
+/* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
+static __always_inline void __kvm_cpu_cap_mask(enum cpuid_leafs leaf)
 {
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
 	struct kvm_cpuid_entry2 entry;
 
 	reverse_cpuid_check(leaf);
-	kvm_cpu_caps[leaf] &= mask;
 
 	cpuid_count(cpuid.function, cpuid.index,
 		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
@@ -361,6 +362,26 @@ static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
 	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
 }
 
+static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
+{
+	/* Use the "init" variant for scattered leafs. */
+	BUILD_BUG_ON(leaf >= NCAPINTS);
+
+	kvm_cpu_caps[leaf] &= mask;
+
+	__kvm_cpu_cap_mask(leaf);
+}
+
+static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
+{
+	/* Use the "mask" variant for hardwared-defined leafs. */
+	BUILD_BUG_ON(leaf < NCAPINTS);
+
+	kvm_cpu_caps[leaf] = mask;
+
+	__kvm_cpu_cap_mask(leaf);
+}
+
 void kvm_set_cpu_caps(void)
 {
 	unsigned int f_nx = is_efer_nx() ? F(NX) : 0;
@@ -371,12 +392,13 @@ void kvm_set_cpu_caps(void)
 	unsigned int f_gbpages = 0;
 	unsigned int f_lm = 0;
 #endif
+	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
 
-	BUILD_BUG_ON(sizeof(kvm_cpu_caps) >
+	BUILD_BUG_ON(sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)) >
 		     sizeof(boot_cpu_data.x86_capability));
 
 	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
-	       sizeof(kvm_cpu_caps));
+	       sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)));
 
 	kvm_cpu_cap_mask(CPUID_1_ECX,
 		/*
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index ded84d244f19..315fa45eb7c8 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -7,7 +7,20 @@
 #include <asm/processor.h>
 #include <uapi/asm/kvm_para.h>
 
-extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
+/*
+ * Hardware-defined CPUID leafs that are scattered in the kernel, but need to
+ * be directly used by KVM.  Note, these word values conflict with the kernel's
+ * "bug" caps, but KVM doesn't use those.
+ */
+enum kvm_only_cpuid_leafs {
+	NR_KVM_CPU_CAPS = NCAPINTS,
+
+	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
+};
+
+#define X86_KVM_FEATURE(w, f)		((w)*32 + (f))
+
+extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
@@ -100,6 +113,20 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
 	BUILD_BUG_ON(reverse_cpuid[x86_leaf].function == 0);
 }
 
+/*
+ * Translate feature bits that are scattered in the kernel's cpufeatures word
+ * into KVM feature words that align with hardware's definitions.
+ */
+static __always_inline u32 __feature_translate(int x86_feature)
+{
+	return x86_feature;
+}
+
+static __always_inline u32 __feature_leaf(int x86_feature)
+{
+	return __feature_translate(x86_feature) / 32;
+}
+
 /*
  * Retrieve the bit mask from an X86_FEATURE_* definition.  Features contain
  * the hardware defined bit number (stored in bits 4:0) and a software defined
@@ -108,6 +135,8 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_bit(int x86_feature)
 {
+	x86_feature = __feature_translate(x86_feature);
+
 	reverse_cpuid_check(x86_feature / 32);
 	return 1 << (x86_feature & 31);
 }
@@ -116,7 +145,7 @@ static __always_inline u32 __feature_bit(int x86_feature)
 
 static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_feature)
 {
-	unsigned int x86_leaf = x86_feature / 32;
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
 	reverse_cpuid_check(x86_leaf);
 	return reverse_cpuid[x86_leaf];
@@ -316,7 +345,7 @@ static inline bool cpuid_fault_enabled(struct kvm_vcpu *vcpu)
 
 static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
 {
-	unsigned int x86_leaf = x86_feature / 32;
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
 	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
@@ -324,7 +353,7 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
 
 static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 {
-	unsigned int x86_leaf = x86_feature / 32;
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
 	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
@@ -332,7 +361,7 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 
 static __always_inline u32 kvm_cpu_cap_get(unsigned int x86_feature)
 {
-	unsigned int x86_leaf = x86_feature / 32;
+	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
 	reverse_cpuid_check(x86_leaf);
 	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
-- 
2.30.2

