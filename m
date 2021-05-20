Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA706389D36
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 07:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhETFpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 01:45:08 -0400
Received: from mga12.intel.com ([192.55.52.136]:47747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230394AbhETFpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 01:45:06 -0400
IronPort-SDR: dQ47l+XiQIdS9wWFIirqZsxpCjr4Rspj7/Uzlg81V4I1R16CEuWqyvWI6Y2Vsem9HWUo/YeNu4
 D+QE82HqcnkQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="180751712"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="180751712"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 22:43:44 -0700
IronPort-SDR: ar0N9UY+xr+HJvOfO2f4rKmGcGWNRQKYWaLSpahhINj89QNu6AMCJASfI73y9NJnpau60EGe0A
 iKFoBQEL3N9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440160306"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.172])
  by fmsmga008.fm.intel.com with ESMTP; 19 May 2021 22:43:38 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 3/6] target/i386: Enable XSAVES support for CET states
Date:   Thu, 20 May 2021 13:57:08 +0800
Message-Id: <1621490231-4765-4-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621490231-4765-1-git-send-email-weijiang.yang@intel.com>
References: <1621490231-4765-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET Shadow Stack(SHSTK) and Indirect Branch Tracking(IBT) are enumerated
via CPUID.(EAX=07H,ECX=0H):ECX[bit 7] and EDX[bit 20] respectively.
Two CET bits (bit 11 and 12) are defined in MSR_IA32_XSS for XSAVES.
They correspond to CET states in user and supervisor mode respectively.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.h | 21 +++++++++++++++++++++
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d74d68e319..bae827c8d5 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1064,6 +1064,16 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     },
     [FEAT_XSAVE_XSS_LO] = {
         .type = CPUID_FEATURE_WORD,
+        .feat_names = {
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, "cet-u",
+            "cet-s", NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+        },
         .cpuid = {
             .eax = 0xD,
             .needs_ecx = true,
@@ -1472,7 +1482,7 @@ typedef struct ExtSaveArea {
 } ExtSaveArea;
 
 /* CPUID feature bits available in XSS */
-#define CPUID_XSTATE_XSS_MASK    0
+#define CPUID_XSTATE_XSS_MASK    (XSTATE_CET_U_MASK)
 
 static const ExtSaveArea x86_ext_save_areas[] = {
     [XSTATE_FP_BIT] = {
@@ -1517,6 +1527,19 @@ static const ExtSaveArea x86_ext_save_areas[] = {
           { .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_PKU,
             .offset = offsetof(X86XSaveArea, pkru_state),
             .size = sizeof(XSavePKRU) },
+    [XSTATE_CET_U_BIT] = {
+            .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_CET_SHSTK,
+        /*
+         * The features enabled in XSS MSR always use compacted format
+         * to store the data, in this case .offset == 0. And CET bits
+         * fall into this category.
+         */
+            .offset = 0,
+            .size = sizeof(XSavesCETU) },
+    [XSTATE_CET_S_BIT] = {
+            .feature = FEAT_7_0_ECX, .bits = CPUID_7_0_ECX_CET_SHSTK,
+            .offset = 0,
+            .size = sizeof(XSavesCETS) },
 };
 
 static uint32_t xsave_area_size(uint64_t mask, bool compacted)
@@ -6486,6 +6509,23 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
         if (env->features[esa->feature] & esa->bits) {
             mask |= (1ULL << i);
         }
+
+        /*
+         * Both CET SHSTK and IBT feature requires XSAVES support, but two
+         * features can be controlled independently by kernel, and we only
+         * have one correlated bit set in x86_ext_save_areas, so if either
+         * of two features is enabled, we set the XSAVES support bit to make
+         * the enabled feature work.
+         */
+        if (i == XSTATE_CET_U_BIT || i == XSTATE_CET_S_BIT) {
+            uint64_t ecx = env->features[FEAT_7_0_ECX];
+            uint64_t edx = env->features[FEAT_7_0_EDX];
+
+            if ((ecx & CPUID_7_0_ECX_CET_SHSTK) ||
+                (edx & CPUID_7_0_EDX_CET_IBT)) {
+                mask |= (1ULL << i);
+            }
+        }
     }
 
     env->features[FEAT_XSAVE_XCR0_LO] = mask & CPUID_XSTATE_XCR0_MASK;
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 42f835d455..593a2d6823 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -492,6 +492,8 @@ typedef enum X86Seg {
 #define XSTATE_ZMM_Hi256_BIT            6
 #define XSTATE_Hi16_ZMM_BIT             7
 #define XSTATE_PKRU_BIT                 9
+#define XSTATE_CET_U_BIT                11
+#define XSTATE_CET_S_BIT                12
 
 #define XSTATE_FP_MASK                  (1ULL << XSTATE_FP_BIT)
 #define XSTATE_SSE_MASK                 (1ULL << XSTATE_SSE_BIT)
@@ -502,6 +504,8 @@ typedef enum X86Seg {
 #define XSTATE_ZMM_Hi256_MASK           (1ULL << XSTATE_ZMM_Hi256_BIT)
 #define XSTATE_Hi16_ZMM_MASK            (1ULL << XSTATE_Hi16_ZMM_BIT)
 #define XSTATE_PKRU_MASK                (1ULL << XSTATE_PKRU_BIT)
+#define XSTATE_CET_U_MASK               (1ULL << XSTATE_CET_U_BIT)
+#define XSTATE_CET_S_MASK               (1ULL << XSTATE_CET_S_BIT)
 
 /* CPUID feature bits available in XCR0 */
 #define CPUID_XSTATE_XCR0_MASK  (XSTATE_FP_MASK | XSTATE_SSE_MASK | \
@@ -761,6 +765,8 @@ typedef uint64_t FeatureWordArray[FEATURE_WORDS];
 #define CPUID_7_0_ECX_WAITPKG           (1U << 5)
 /* Additional AVX-512 Vector Byte Manipulation Instruction */
 #define CPUID_7_0_ECX_AVX512_VBMI2      (1U << 6)
+/* CET SHSTK feature */
+#define CPUID_7_0_ECX_CET_SHSTK         (1U << 7)
 /* Galois Field New Instructions */
 #define CPUID_7_0_ECX_GFNI              (1U << 8)
 /* Vector AES Instructions */
@@ -800,6 +806,8 @@ typedef uint64_t FeatureWordArray[FEATURE_WORDS];
 #define CPUID_7_0_EDX_SERIALIZE         (1U << 14)
 /* TSX Suspend Load Address Tracking instruction */
 #define CPUID_7_0_EDX_TSX_LDTRK         (1U << 16)
+/* CET IBT feature */
+#define CPUID_7_0_EDX_CET_IBT           (1U << 20)
 /* AVX512_FP16 instruction */
 #define CPUID_7_0_EDX_AVX512_FP16       (1U << 23)
 /* Speculation Control */
@@ -1301,6 +1309,19 @@ typedef struct XSavePKRU {
     uint32_t padding;
 } XSavePKRU;
 
+/* Ext. save area 11: User mode CET state */
+typedef struct XSavesCETU {
+    uint64_t u_cet;
+    uint64_t user_ssp;
+} XSavesCETU;
+
+/* Ext. save area 12: Supervisor mode CET state */
+typedef struct XSavesCETS {
+    uint64_t kernel_ssp;
+    uint64_t pl1_ssp;
+    uint64_t pl2_ssp;
+} XSavesCETS;
+
 typedef struct X86XSaveArea {
     X86LegacyXSaveArea legacy;
     X86XSaveHeader header;
-- 
2.26.2

