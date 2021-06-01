Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD54396F7A
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbhFAIus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:50:48 -0400
Received: from mga07.intel.com ([134.134.136.100]:45208 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233813AbhFAIuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:50:22 -0400
IronPort-SDR: nulyBmdU0wcg3FjdYAUGmbbpy/Pf1F/hi5s02WznrO/oI5tObkX0XjGsHIJP+Dw0I28PSgDnAC
 LYltx+dde82Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381416"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381416"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:24 -0700
IronPort-SDR: LckntoZwfGAbor9II+7dgzhSuNyZ5pUXvjsNlFgA53Y40Qsu1oIgscdPH2w+9Tm3onCwLob7kf
 oQcfnSZRdvgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967817"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:21 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 09/15] kvm/cpuid: Enumerate Key Locker feature in KVM
Date:   Tue,  1 Jun 2021 16:47:48 +0800
Message-Id: <1622537274-146420-10-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_set_cpu_caps(), add Key Locker feature enumeration, under the
condition that 1) HW supports this feature 2) host Kernel isn't
enabled with this feature.

Among its sub-features, filter out randomization support bit
(CPUID.0x19.ECX[1]), as by design it cannot be supported at this moment.
(Refer to Intel Key Locker Spec.)

Also, CPUID.0x19.EBX[0] (Key Locker instructions is enabled) is dynamic,
based on CR4.KL status, thus reserve CR4.KL, and update this CPUID bit
dynamically.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/cpuid.c            | 26 ++++++++++++++++++++++++--
 arch/x86/kvm/reverse_cpuid.h    | 32 ++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.h              |  2 ++
 5 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4b929dc..aec9ccc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -103,7 +103,7 @@
 			  | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
-			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
+			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP | X86_CR4_KEYLOCKER))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 19606a3..f3b00ae 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -135,6 +135,12 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
+	/* update CPUID.0x19.EBX[0], depends on CR4.KL */
+	best = kvm_find_cpuid_entry(vcpu, 0x19, 0);
+	if (best)
+		cpuid_entry_change(best, X86_FEATURE_KL_INS_ENABLED,
+					kvm_read_cr4_bits(vcpu, X86_CR4_KEYLOCKER));
+
 	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
@@ -456,14 +462,20 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_ECX,
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
-		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
+		F(VAES) | 0 /*KEYLOCKER*/ | F(VPCLMULQDQ) | F(AVX512_VNNI) |
+		F(AVX512_BITALG) | F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
 		F(SGX_LC)
 	);
+
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
 		kvm_cpu_cap_set(X86_FEATURE_LA57);
 
+	/* At present, host and guest can only exclusively use KeyLocker */
+	if (!boot_cpu_has(X86_FEATURE_KEYLOCKER) && (cpuid_ecx(0x7) &
+		feature_bit(KEYLOCKER)))
+		kvm_cpu_cap_set(X86_FEATURE_KEYLOCKER);
+
 	/*
 	 * PKU not yet implemented for shadow paging and requires OSPKE
 	 * to be set on the host. Clear it if that is not the case
@@ -500,6 +512,10 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_init_scattered(CPUID_12_EAX,
 		SF(SGX1) | SF(SGX2)
 	);
+	kvm_cpu_cap_init_scattered(CPUID_19_EBX, SF(KL_INS_ENABLED) | SF(KL_WIDE) |
+		SF(IWKEY_BACKUP));
+	/* No randomize exposed to guest */
+	kvm_cpu_cap_init_scattered(CPUID_19_ECX, SF(IWKEY_NOBACKUP));
 
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
 		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
@@ -870,6 +886,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 		}
 		break;
+	/* KeyLocker */
+	case 0x19:
+		cpuid_entry_override(entry, CPUID_19_EBX);
+		cpuid_entry_override(entry, CPUID_19_ECX);
+		break;
+
 	case KVM_CPUID_SIGNATURE: {
 		static const char signature[12] = "KVMKVMKVM\0\0";
 		const u32 *sigptr = (const u32 *)signature;
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473..3ea8875 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,9 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_19_EBX,
+	CPUID_19_ECX,
+
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -24,6 +27,13 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 
+/* Intel-defined Key Locker sub-features, CPUID level 0x19 (EBX). */
+#define KVM_X86_FEATURE_KL_INS_ENABLED   KVM_X86_FEATURE(CPUID_19_EBX, 0)
+#define KVM_X86_FEATURE_KL_WIDE          KVM_X86_FEATURE(CPUID_19_EBX, 2)
+#define KVM_X86_FEATURE_IWKEY_BACKUP     KVM_X86_FEATURE(CPUID_19_EBX, 4)
+#define KVM_X86_FEATURE_IWKEY_NOBACKUP   KVM_X86_FEATURE(CPUID_19_ECX, 0)
+#define KVM_X86_FEATURE_IWKEY_RAND       KVM_X86_FEATURE(CPUID_19_ECX, 1)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -48,6 +58,8 @@ struct cpuid_reg {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_19_EBX]        = {      0x19, 0, CPUID_EBX},
+	[CPUID_19_ECX]        = {      0x19, 0, CPUID_ECX},
 };
 
 /*
@@ -74,12 +86,24 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_translate(int x86_feature)
 {
-	if (x86_feature == X86_FEATURE_SGX1)
+	switch (x86_feature) {
+	case X86_FEATURE_SGX1:
 		return KVM_X86_FEATURE_SGX1;
-	else if (x86_feature == X86_FEATURE_SGX2)
+	case X86_FEATURE_SGX2:
 		return KVM_X86_FEATURE_SGX2;
-
-	return x86_feature;
+	case X86_FEATURE_KL_INS_ENABLED:
+		return KVM_X86_FEATURE_KL_INS_ENABLED;
+	case X86_FEATURE_KL_WIDE:
+		return KVM_X86_FEATURE_KL_WIDE;
+	case X86_FEATURE_IWKEY_BACKUP:
+		return KVM_X86_FEATURE_IWKEY_BACKUP;
+	case X86_FEATURE_IWKEY_NOBACKUP:
+		return KVM_X86_FEATURE_IWKEY_NOBACKUP;
+	case X86_FEATURE_IWKEY_RAND:
+		return KVM_X86_FEATURE_IWKEY_RAND;
+	default:
+		return x86_feature;
+	}
 }
 
 static __always_inline u32 __feature_leaf(int x86_feature)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 752b1e4..da4c123 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3507,7 +3507,7 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	vmcs_writel(CR4_READ_SHADOW, cr4);
 	vmcs_writel(GUEST_CR4, hw_cr4);
 
-	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
+	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE | X86_CR4_KEYLOCKER))
 		kvm_update_cpuid_runtime(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 521f74e..b0cf5f7 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -485,6 +485,8 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_KEYLOCKER))		\
+		__reserved_bits |= X86_CR4_KEYLOCKER;	\
 	__reserved_bits;                                \
 })
 
-- 
1.8.3.1

