Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A99389D33
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 07:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhETFpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 01:45:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:47737 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhETFo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 01:44:59 -0400
IronPort-SDR: AzvPvrPk3pxGovB3rIjHHxTMHZ5xqH4flI5U6Kh/jvfCfG4avLcYQZpnGUKtOyG2QhPkeUoKt/
 gG1JPeXJ2FRw==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="180751710"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="180751710"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 22:43:38 -0700
IronPort-SDR: X046M9kit6O+KxosRLzmdIpqGw7kIR0IPI+3yCpsCuxmdVSCNn2vqSQLT3FBAhMFdV/cbZvV/v
 V2jOpawWE8tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440160296"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.172])
  by fmsmga008.fm.intel.com with ESMTP; 19 May 2021 22:43:36 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 2/6] target/i386: Enable XSS feature CPUID enumeration
Date:   Thu, 20 May 2021 13:57:07 +0800
Message-Id: <1621490231-4765-3-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621490231-4765-1-git-send-email-weijiang.yang@intel.com>
References: <1621490231-4765-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, CPUID.(EAX=0DH,ECX=01H) doesn't enumerate features in XSS
properly, so enable the support. XCR0 bits indicate user-mode XSAVE
components, and XSS bits indicate supervisor-mode XSAVE components.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.c | 68 +++++++++++++++++++++++++++++++++++++++--------
 target/i386/cpu.h |  9 +++++++
 2 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5c76186883..d74d68e319 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1062,6 +1062,24 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         },
         .tcg_features = TCG_XSAVE_FEATURES,
     },
+    [FEAT_XSAVE_XSS_LO] = {
+        .type = CPUID_FEATURE_WORD,
+        .cpuid = {
+            .eax = 0xD,
+            .needs_ecx = true,
+            .ecx = 1,
+            .reg = R_ECX,
+        },
+    },
+    [FEAT_XSAVE_XSS_HI] = {
+        .type = CPUID_FEATURE_WORD,
+        .cpuid = {
+            .eax = 0xD,
+            .needs_ecx = true,
+            .ecx = 1,
+            .reg = R_EDX
+        },
+    },
     [FEAT_6_EAX] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
@@ -1453,6 +1471,9 @@ typedef struct ExtSaveArea {
     uint32_t offset, size;
 } ExtSaveArea;
 
+/* CPUID feature bits available in XSS */
+#define CPUID_XSTATE_XSS_MASK    0
+
 static const ExtSaveArea x86_ext_save_areas[] = {
     [XSTATE_FP_BIT] = {
         /* x87 FP state component is always enabled if XSAVE is supported */
@@ -1498,15 +1519,18 @@ static const ExtSaveArea x86_ext_save_areas[] = {
             .size = sizeof(XSavePKRU) },
 };
 
-static uint32_t xsave_area_size(uint64_t mask)
+static uint32_t xsave_area_size(uint64_t mask, bool compacted)
 {
+    uint64_t ret = x86_ext_save_areas[0].size;
+    const ExtSaveArea *esa;
+    uint32_t offset = 0;
     int i;
-    uint64_t ret = 0;
 
-    for (i = 0; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
-        const ExtSaveArea *esa = &x86_ext_save_areas[i];
+    for (i = 2; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
+        esa = &x86_ext_save_areas[i];
         if ((mask >> i) & 1) {
-            ret = MAX(ret, esa->offset + esa->size);
+            offset = compacted ? ret : esa->offset;
+            ret = MAX(ret, offset + esa->size);
         }
     }
     return ret;
@@ -1517,7 +1541,7 @@ static inline bool accel_uses_host_cpuid(void)
     return kvm_enabled() || hvf_enabled();
 }
 
-static inline uint64_t x86_cpu_xsave_components(X86CPU *cpu)
+static inline uint64_t x86_cpu_xsave_xcr0_components(X86CPU *cpu)
 {
     return ((uint64_t)cpu->env.features[FEAT_XSAVE_XCR0_HI]) << 32 |
            cpu->env.features[FEAT_XSAVE_XCR0_LO];
@@ -1532,6 +1556,12 @@ static const char *get_register_name_32(unsigned int reg)
     return x86_reg_info_32[reg].name;
 }
 
+static inline uint64_t x86_cpu_xsave_xss_components(X86CPU *cpu)
+{
+    return ((uint64_t)cpu->env.features[FEAT_XSAVE_XSS_HI]) << 32 |
+           cpu->env.features[FEAT_XSAVE_XSS_LO];
+}
+
 /*
  * Returns the set of feature flags that are supported and migratable by
  * QEMU, for a given FeatureWord.
@@ -5859,7 +5889,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
 
         if (count == 0) {
-            *ecx = xsave_area_size(x86_cpu_xsave_components(cpu));
+            *ecx = xsave_area_size(x86_cpu_xsave_xcr0_components(cpu), false);
             *eax = env->features[FEAT_XSAVE_XCR0_LO];
             *edx = env->features[FEAT_XSAVE_XCR0_HI];
             /*
@@ -5868,14 +5898,25 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
              * even through guest update xcr0, this will crash some legacy guest
              * (e.g., CentOS 6), So set ebx == ecx to workaroud it.
              */
-            *ebx = kvm_enabled() ? *ecx : xsave_area_size(env->xcr0);
+            *ebx = kvm_enabled() ? *ecx : xsave_area_size(env->xcr0, false);
         } else if (count == 1) {
+            uint64_t xstate = x86_cpu_xsave_xcr0_components(cpu) |
+                              x86_cpu_xsave_xss_components(cpu);
+
             *eax = env->features[FEAT_XSAVE];
+            *ebx = xsave_area_size(xstate, true);
+            *ecx = env->features[FEAT_XSAVE_XSS_LO];
+            *edx = env->features[FEAT_XSAVE_XSS_HI];
         } else if (count < ARRAY_SIZE(x86_ext_save_areas)) {
-            if ((x86_cpu_xsave_components(cpu) >> count) & 1) {
-                const ExtSaveArea *esa = &x86_ext_save_areas[count];
+            const ExtSaveArea *esa = &x86_ext_save_areas[count];
+
+            if ((x86_cpu_xsave_xcr0_components(cpu) >> count) & 1) {
                 *eax = esa->size;
                 *ebx = esa->offset;
+            } else if ((x86_cpu_xsave_xss_components(cpu) >> count) & 1) {
+                *eax = esa->size;
+                *ebx = 0;
+                *ecx = 1;
             }
         }
         break;
@@ -6206,6 +6247,9 @@ static void x86_cpu_reset(DeviceState *dev)
     }
     for (i = 2; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
         const ExtSaveArea *esa = &x86_ext_save_areas[i];
+        if (!((1 << i) & CPUID_XSTATE_XCR0_MASK)) {
+            continue;
+        }
         if (env->features[esa->feature] & esa->bits) {
             xcr0 |= 1ull << i;
         }
@@ -6444,8 +6488,10 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
         }
     }
 
-    env->features[FEAT_XSAVE_XCR0_LO] = mask;
+    env->features[FEAT_XSAVE_XCR0_LO] = mask & CPUID_XSTATE_XCR0_MASK;
     env->features[FEAT_XSAVE_XCR0_HI] = mask >> 32;
+    env->features[FEAT_XSAVE_XSS_LO] = mask & CPUID_XSTATE_XSS_MASK;
+    env->features[FEAT_XSAVE_XSS_HI] = mask >> 32;
 }
 
 /***** Steps involved on loading and filtering CPUID data
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 84cb6adcaa..42f835d455 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -503,6 +503,13 @@ typedef enum X86Seg {
 #define XSTATE_Hi16_ZMM_MASK            (1ULL << XSTATE_Hi16_ZMM_BIT)
 #define XSTATE_PKRU_MASK                (1ULL << XSTATE_PKRU_BIT)
 
+/* CPUID feature bits available in XCR0 */
+#define CPUID_XSTATE_XCR0_MASK  (XSTATE_FP_MASK | XSTATE_SSE_MASK | \
+                                 XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | \
+                                 XSTATE_BNDCSR_MASK | XSTATE_OPMASK_MASK | \
+                                 XSTATE_ZMM_Hi256_MASK | \
+                                 XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK)
+
 /* CPUID feature words */
 typedef enum FeatureWord {
     FEAT_1_EDX,         /* CPUID[1].EDX */
@@ -541,6 +548,8 @@ typedef enum FeatureWord {
     FEAT_VMX_BASIC,
     FEAT_VMX_VMFUNC,
     FEAT_14_0_ECX,
+    FEAT_XSAVE_XSS_LO,     /* CPUID[EAX=0xd,ECX=1].ECX */
+    FEAT_XSAVE_XSS_HI,     /* CPUID[EAX=0xd,ECX=1].EDX */
     FEATURE_WORDS,
 } FeatureWord;
 
-- 
2.26.2

