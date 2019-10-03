Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D91DCB143
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388135AbfJCVjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:39:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:52653 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387933AbfJCVjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:39:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051618"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 02/13] kvm: Add support for X86_FEATURE_KVM_XO
Date:   Thu,  3 Oct 2019 14:23:49 -0700
Message-Id: <20191003212400.31130-3-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add X86_FEATURE_KVM_XO which reduces the physical address bits exposed by
CPUID and uses the hosts highest physical address bit as an XO/NR
permission bit in the guest page tables. Adjust reserved mask so KVM guest
page tables walks are aware this bit is not reserved.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/cpufeature.h    |  1 +
 arch/x86/include/asm/cpufeatures.h   |  3 +++
 arch/x86/include/uapi/asm/kvm_para.h |  3 +++
 arch/x86/kvm/cpuid.c                 |  7 +++++++
 arch/x86/kvm/cpuid.h                 |  1 +
 arch/x86/kvm/mmu.c                   | 18 ++++++++++++------
 6 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 58acda503817..17127ffbc2a2 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -30,6 +30,7 @@ enum cpuid_leafs
 	CPUID_7_ECX,
 	CPUID_8000_0007_EBX,
 	CPUID_7_EDX,
+	CPUID_4000_0030_EAX
 };
 
 #ifdef CONFIG_X86_FEATURE_NAMES
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index e880f2408e29..7ba217e894ea 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -364,6 +364,9 @@
 #define X86_FEATURE_ARCH_CAPABILITIES	(18*32+29) /* IA32_ARCH_CAPABILITIES MSR (Intel) */
 #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative Store Bypass Disable */
 
+/* KVM-defined CPU features, CPUID level 0x40000030 (EAX), word 19 */
+#define X86_FEATURE_KVM_XO		(19*32+0) /* KVM EPT based execute only memory support */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 2a8e0b6b9805..ecff0ff25cf4 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -34,6 +34,9 @@
 
 #define KVM_HINTS_REALTIME      0
 
+#define KVM_CPUID_FEAT_GENERIC	0x40000030
+#define KVM_FEATURE_GENERIC_XO		0
+
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
  */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 22c2720cd948..bcbf3f93602d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -700,6 +700,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
 
+		entry->ebx = 0;
+		entry->ecx = 0;
+		entry->edx = 0;
+		break;
+	case KVM_CPUID_FEAT_GENERIC:
+		entry->eax = (1 << KVM_FEATURE_GENERIC_XO);
 		entry->ebx = 0;
 		entry->ecx = 0;
 		entry->edx = 0;
@@ -845,6 +851,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 		{ .func = 0x80000000 },
 		{ .func = 0xC0000000, .qualifier = is_centaur_cpu },
 		{ .func = KVM_CPUID_SIGNATURE },
+		{ .func = KVM_CPUID_FEAT_GENERIC },
 	};
 
 	if (cpuid->nent < 1)
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d78a61408243..c36d462a0e01 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -53,6 +53,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_ECX]         = {         7, 0, CPUID_ECX},
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
+	[CPUID_4000_0030_EAX] = {0x40000030, 0, CPUID_EAX},
 };
 
 static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a63964e7cec7..e44a8053af78 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4358,12 +4358,15 @@ static void
 __reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 			struct rsvd_bits_validate *rsvd_check,
 			int maxphyaddr, int level, bool nx, bool gbpages,
-			bool pse, bool amd)
+			bool pse, bool amd, bool xo)
 {
 	u64 exb_bit_rsvd = 0;
 	u64 gbpages_bit_rsvd = 0;
 	u64 nonleaf_bit8_rsvd = 0;
 
+	/* Adjust maxphyaddr to include the XO bit if in use */
+	maxphyaddr += xo;
+
 	rsvd_check->bad_mt_xwr = 0;
 
 	if (!nx)
@@ -4448,10 +4451,12 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu *context)
 {
 	__reset_rsvds_bits_mask(vcpu, &context->guest_rsvd_check,
-				cpuid_maxphyaddr(vcpu), context->root_level,
+				cpuid_maxphyaddr(vcpu),
+				context->root_level,
 				context->nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
-				is_pse(vcpu), guest_cpuid_is_amd(vcpu));
+				is_pse(vcpu), guest_cpuid_is_amd(vcpu),
+				guest_cpuid_has(vcpu, X86_FEATURE_KVM_XO));
 }
 
 static void
@@ -4520,7 +4525,7 @@ reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 				shadow_phys_bits,
 				context->shadow_root_level, uses_nx,
 				guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES),
-				is_pse(vcpu), true);
+				is_pse(vcpu), true, false);
 
 	if (!shadow_me_mask)
 		return;
@@ -4557,7 +4562,7 @@ reset_tdp_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 					shadow_phys_bits,
 					context->shadow_root_level, false,
 					boot_cpu_has(X86_FEATURE_GBPAGES),
-					true, true);
+					true, true, false);
 	else
 		__reset_rsvds_bits_mask_ept(shadow_zero_check,
 					    shadow_phys_bits,
@@ -4818,7 +4823,8 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	ext.cr4_pse = !!is_pse(vcpu);
 	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
 	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
-	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
+	ext.maxphyaddr = cpuid_maxphyaddr(vcpu)
+			 + guest_cpuid_has(vcpu, X86_FEATURE_KVM_XO);
 
 	ext.valid = 1;
 
-- 
2.17.1

