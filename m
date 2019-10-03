Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D86CB151
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388840AbfJCVjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:39:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:52655 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388092AbfJCVjA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:39:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051639"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 09/13] x86/cpufeature: Add detection of KVM XO
Date:   Thu,  3 Oct 2019 14:23:56 -0700
Message-Id: <20191003212400.31130-10-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new CPUID leaf to hold the contents of CPUID 0x40000030 EAX to
detect KVM defined generic VMM features.

The leaf was proposed to allow KVM to communicate features that are
defined by KVM, but available for any VMM to implement.

Add cpu_feature_enabled() support for features in this leaf (KVM XO), and
a pgtable_kvmxo_enabled() helper similar to pgtable_l5_enabled() so that
pgtable_kvmxo_enabled() can be used in early code that includes
arch/x86/include/asm/sparsemem.h.

Lastly, in head64.c detect and this feature and perform necessary
adjustments to physical_mask.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/cpufeature.h             |  6 ++-
 arch/x86/include/asm/cpufeatures.h            |  2 +-
 arch/x86/include/asm/disabled-features.h      |  3 +-
 arch/x86/include/asm/pgtable_32_types.h       |  1 +
 arch/x86/include/asm/pgtable_64_types.h       | 26 ++++++++++++-
 arch/x86/include/asm/required-features.h      |  3 +-
 arch/x86/include/asm/sparsemem.h              |  4 +-
 arch/x86/kernel/cpu/common.c                  |  5 +++
 arch/x86/kernel/head64.c                      | 38 ++++++++++++++++++-
 .../arch/x86/include/asm/disabled-features.h  |  3 +-
 10 files changed, 80 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 17127ffbc2a2..7d04ea4f1623 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -82,8 +82,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 16, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 19, feature_bit) ||	\
 	   REQUIRED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
 
 #define DISABLED_MASK_BIT_SET(feature_bit)				\
 	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
@@ -105,8 +106,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 16, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 19, feature_bit) ||	\
 	   DISABLED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
 
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 7ba217e894ea..9c1b07674401 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -13,7 +13,7 @@
 /*
  * Defines x86 CPU feature bits
  */
-#define NCAPINTS			19	   /* N 32-bit words worth of info */
+#define NCAPINTS			20	   /* N 32-bit words worth of info */
 #define NBUGINTS			1	   /* N 32-bit bug flags */
 
 /*
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index a5ea841cc6d2..f0f935f8d917 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -84,6 +84,7 @@
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define DISABLED_MASK19	0
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index b0bc0fff5f1f..57a11692715e 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -16,6 +16,7 @@
 #endif
 
 #define pgtable_l5_enabled() 0
+#define pgtable_kvmxo_enabled() 0
 
 #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
 #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 6b55b837ead4..7c7c9d1a199a 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -43,10 +43,34 @@ static inline bool pgtable_l5_enabled(void)
 extern unsigned int pgdir_shift;
 extern unsigned int ptrs_per_p4d;
 
+#ifdef CONFIG_KVM_XO
+extern unsigned int __pgtable_kvmxo_enabled;
+
+#ifdef USE_EARLY_PGTABLE
+/*
+ * cpu_feature_enabled() is not available in early boot code.
+ * Use variable instead.
+ */
+static inline bool pgtable_kvmxo_enabled(void)
+{
+	return __pgtable_kvmxo_enabled;
+}
+#else
+#define pgtable_kvmxo_enabled() cpu_feature_enabled(X86_FEATURE_KVM_XO)
+#endif /* USE_EARLY_PGTABLE */
+
+#else
+#define pgtable_kvmxo_enabled() 0
+#endif /* CONFIG_KVM_XO */
+
 #endif	/* !__ASSEMBLY__ */
 
 #define SHARED_KERNEL_PMD	0
 
+#if defined(CONFIG_X86_5LEVEL) || defined(CONFIG_KVM_XO)
+#define MAX_POSSIBLE_PHYSMEM_BITS	52
+#endif
+
 #ifdef CONFIG_X86_5LEVEL
 
 /*
@@ -64,8 +88,6 @@ extern unsigned int ptrs_per_p4d;
 #define P4D_SIZE		(_AC(1, UL) << P4D_SHIFT)
 #define P4D_MASK		(~(P4D_SIZE - 1))
 
-#define MAX_POSSIBLE_PHYSMEM_BITS	52
-
 #else /* CONFIG_X86_5LEVEL */
 
 /*
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 6847d85400a8..fa5700097f64 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -101,6 +101,7 @@
 #define REQUIRED_MASK16	0
 #define REQUIRED_MASK17	0
 #define REQUIRED_MASK18	0
-#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define REQUIRED_MASK19	0
+#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
diff --git a/arch/x86/include/asm/sparsemem.h b/arch/x86/include/asm/sparsemem.h
index 199218719a86..24b305195369 100644
--- a/arch/x86/include/asm/sparsemem.h
+++ b/arch/x86/include/asm/sparsemem.h
@@ -27,8 +27,8 @@
 # endif
 #else /* CONFIG_X86_32 */
 # define SECTION_SIZE_BITS	27 /* matt - 128 is convenient right now */
-# define MAX_PHYSADDR_BITS	(pgtable_l5_enabled() ? 52 : 44)
-# define MAX_PHYSMEM_BITS	(pgtable_l5_enabled() ? 52 : 46)
+# define MAX_PHYSADDR_BITS	((pgtable_l5_enabled() ? 52 : 44) - !!pgtable_kvmxo_enabled())
+# define MAX_PHYSMEM_BITS	((pgtable_l5_enabled() ? 52 : 46) - !!pgtable_kvmxo_enabled())
 #endif
 
 #endif /* CONFIG_SPARSEMEM */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4f08e164c0b1..ee204aefbcfd 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -933,6 +933,11 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[CPUID_D_1_EAX] = eax;
 	}
 
+	eax = cpuid_eax(0x40000000);
+	c->extended_cpuid_level = eax;
+	if (c->extended_cpuid_level >= 0x40000030)
+		c->x86_capability[CPUID_4000_0030_EAX] = cpuid_eax(0x40000030);
+
 	/* AMD-defined flags: level 0x80000001 */
 	eax = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = eax;
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 55f5294c3cdf..7091702a7bec 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -52,6 +52,11 @@ unsigned int ptrs_per_p4d __ro_after_init = 1;
 EXPORT_SYMBOL(ptrs_per_p4d);
 #endif
 
+#ifdef CONFIG_KVM_XO
+unsigned int __pgtable_kvmxo_enabled __ro_after_init;
+unsigned int __pgtable_kvmxo_bit __ro_after_init;
+#endif /* CONFIG_KVM_XO */
+
 #ifdef CONFIG_DYNAMIC_MEMORY_LAYOUT
 unsigned long page_offset_base __ro_after_init = __PAGE_OFFSET_BASE_L4;
 EXPORT_SYMBOL(page_offset_base);
@@ -73,12 +78,14 @@ static unsigned long __head *fixup_long(void *ptr, unsigned long physaddr)
 	return fixup_pointer(ptr, physaddr);
 }
 
-#ifdef CONFIG_X86_5LEVEL
+#if defined(CONFIG_X86_5LEVEL) || defined(CONFIG_KVM_XO)
 static unsigned int __head *fixup_int(void *ptr, unsigned long physaddr)
 {
 	return fixup_pointer(ptr, physaddr);
 }
+#endif
 
+#ifdef CONFIG_X86_5LEVEL
 static bool __head check_la57_support(unsigned long physaddr)
 {
 	/*
@@ -104,6 +111,33 @@ static bool __head check_la57_support(unsigned long physaddr)
 }
 #endif
 
+#ifdef CONFIG_KVM_XO
+static void __head check_kvmxo_support(unsigned long physaddr)
+{
+	unsigned long physbits;
+
+	if ((native_cpuid_eax(0x40000000) < 0x40000030) ||
+	    !(native_cpuid_eax(0x40000030) & (1 << (X86_FEATURE_KVM_XO & 31))))
+		return;
+
+	if (native_cpuid_eax(0x80000000) < 0x80000008)
+		return;
+
+	physbits = native_cpuid_eax(0x80000008) & 0xff;
+
+	/*
+	 * If KVM XO is active, the top physical address bit is the permisison
+	 * bit, so zero it in the mask.
+	 */
+	physical_mask &= ~(1UL << physbits);
+
+	*fixup_int(&__pgtable_kvmxo_enabled, physaddr) = 1;
+	*fixup_int(&__pgtable_kvmxo_bit, physaddr) = physbits;
+}
+#else /* CONFIG_KVM_XO */
+static void __head check_kvmxo_support(unsigned long physaddr) { }
+#endif /* CONFIG_KVM_XO */
+
 /* Code in __startup_64() can be relocated during execution, but the compiler
  * doesn't have to generate PC-relative relocations when accessing globals from
  * that function. Clang actually does not generate them, which leads to
@@ -127,6 +161,8 @@ unsigned long __head __startup_64(unsigned long physaddr,
 
 	la57 = check_la57_support(physaddr);
 
+	check_kvmxo_support(physaddr);
+
 	/* Is the address too large? */
 	if (physaddr >> MAX_PHYSMEM_BITS)
 		for (;;);
diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
index a5ea841cc6d2..f0f935f8d917 100644
--- a/tools/arch/x86/include/asm/disabled-features.h
+++ b/tools/arch/x86/include/asm/disabled-features.h
@@ -84,6 +84,7 @@
 #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define DISABLED_MASK19	0
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
-- 
2.17.1

