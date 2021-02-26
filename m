Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9CE325B74
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 03:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBZCKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 21:10:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:38821 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhBZCKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 21:10:12 -0500
IronPort-SDR: bf+vhVg+nbDxNAEovWhys303dBXpmtxwLIUdLCF4rS4S7Z9nAGPwXwlXIynQphaNi5TEzZ571O
 6te46mRYWFEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185801007"
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="185801007"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2021 18:09:30 -0800
IronPort-SDR: z8elN4nmMyPkRHVMlzUQRR5Wz+T0BW3LoL+nlkrCvb3JTdz0Vdmjx+5+YsKohwU3UZv90mNwhK
 cnfRArgsykTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="404679990"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 25 Feb 2021 18:09:28 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, richard.henderson@linaro.org,
        ehabkost@redhat.com, mtosatti@redhat.com,
        sean.j.christopherson@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 2/6] target/i386: Enable XSS feature enumeration for CPUID
Date:   Fri, 26 Feb 2021 10:20:54 +0800
Message-Id: <20210226022058.24562-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210226022058.24562-1-weijiang.yang@intel.com>
References: <20210226022058.24562-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, CPUID.(EAX=0DH,ECX=01H) doesn't enumerate features in
XSS properly, add the support here. XCR0 bits indicate user-mode XSAVE
components, and XSS bits indicate supervisor-mode XSAVE components.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.c | 48 ++++++++++++++++++++++++++++++++++++++++++-----
 target/i386/cpu.h | 12 ++++++++++++
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 89edab4240..f3923988ed 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1058,6 +1058,24 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
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
@@ -1478,6 +1496,9 @@ static uint32_t xsave_area_size(uint64_t mask)
     for (i = 0; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
         const ExtSaveArea *esa = &x86_ext_save_areas[i];
         if ((mask >> i) & 1) {
+            if (i >= 2 && !esa->offset) {
+                continue;
+            }
             ret = MAX(ret, esa->offset + esa->size);
         }
     }
@@ -1489,12 +1510,18 @@ static inline bool accel_uses_host_cpuid(void)
     return kvm_enabled() || hvf_enabled();
 }
 
-static inline uint64_t x86_cpu_xsave_components(X86CPU *cpu)
+static inline uint64_t x86_cpu_xsave_xcr0_components(X86CPU *cpu)
 {
     return ((uint64_t)cpu->env.features[FEAT_XSAVE_XCR0_HI]) << 32 |
            cpu->env.features[FEAT_XSAVE_XCR0_LO];
 }
 
+static inline uint64_t x86_cpu_xsave_xss_components(X86CPU *cpu)
+{
+    return ((uint64_t)cpu->env.features[FEAT_XSAVE_XSS_HI]) << 32 |
+           cpu->env.features[FEAT_XSAVE_XSS_LO];
+}
+
 const char *get_register_name_32(unsigned int reg)
 {
     if (reg >= CPU_NB_REGS32) {
@@ -5716,7 +5743,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
 
         if (count == 0) {
-            *ecx = xsave_area_size(x86_cpu_xsave_components(cpu));
+            *ecx = xsave_area_size(x86_cpu_xsave_xcr0_components(cpu));
             *eax = env->features[FEAT_XSAVE_XCR0_LO];
             *edx = env->features[FEAT_XSAVE_XCR0_HI];
             /*
@@ -5728,11 +5755,17 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *ebx = kvm_enabled() ? *ecx : xsave_area_size(env->xcr0);
         } else if (count == 1) {
             *eax = env->features[FEAT_XSAVE];
+            *ecx = env->features[FEAT_XSAVE_XSS_LO];
+            *edx = env->features[FEAT_XSAVE_XSS_HI];
         } else if (count < ARRAY_SIZE(x86_ext_save_areas)) {
-            if ((x86_cpu_xsave_components(cpu) >> count) & 1) {
-                const ExtSaveArea *esa = &x86_ext_save_areas[count];
+            const ExtSaveArea *esa = &x86_ext_save_areas[count];
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
@@ -6059,6 +6092,9 @@ static void x86_cpu_reset(DeviceState *dev)
     }
     for (i = 2; i < ARRAY_SIZE(x86_ext_save_areas); i++) {
         const ExtSaveArea *esa = &x86_ext_save_areas[i];
+        if (!esa->offset) {
+            continue;
+        }
         if (env->features[esa->feature] & esa->bits) {
             xcr0 |= 1ull << i;
         }
@@ -6295,8 +6331,10 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
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
index 52f31335c4..8aeaa8869a 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -504,6 +504,16 @@ typedef enum X86Seg {
 #define XSTATE_Hi16_ZMM_MASK            (1ULL << XSTATE_Hi16_ZMM_BIT)
 #define XSTATE_PKRU_MASK                (1ULL << XSTATE_PKRU_BIT)
 
+/* CPUID feature bits available in XCR0 */
+#define CPUID_XSTATE_XCR0_MASK  (XSTATE_FP_MASK | XSTATE_SSE_MASK | \
+                                 XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | \
+                                 XSTATE_BNDCSR_MASK | XSTATE_OPMASK_MASK | \
+                                 XSTATE_ZMM_Hi256_MASK | \
+                                 XSTATE_Hi16_ZMM_MASK | XSTATE_PKRU_MASK)
+
+/* CPUID feature bits available in XSS */
+#define CPUID_XSTATE_XSS_MASK    0
+
 /* CPUID feature words */
 typedef enum FeatureWord {
     FEAT_1_EDX,         /* CPUID[1].EDX */
@@ -541,6 +551,8 @@ typedef enum FeatureWord {
     FEAT_VMX_EPT_VPID_CAPS,
     FEAT_VMX_BASIC,
     FEAT_VMX_VMFUNC,
+    FEAT_XSAVE_XSS_LO,     /* CPUID[EAX=0xd,ECX=1].ECX */
+    FEAT_XSAVE_XSS_HI,     /* CPUID[EAX=0xd,ECX=1].EDX */
     FEATURE_WORDS,
 } FeatureWord;
 
-- 
2.26.2

