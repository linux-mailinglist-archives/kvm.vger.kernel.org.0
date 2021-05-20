Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D5E389D32
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 07:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhETFpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 01:45:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:47737 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230345AbhETFo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 01:44:57 -0400
IronPort-SDR: zIYZwhyWYgxF+4fpS/MfYUdPlqgWzp0QG3pkGTITkGIEYD+ftRo2IPRUlZtNwMuFTqj/EQmsS4
 VCuuGjlujnKA==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="180751705"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="180751705"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 22:43:36 -0700
IronPort-SDR: uGMfOOcozJnBYZqIrDXGgVBRCe/m0H9ZGSCREuEbij73URjdKVHoq9lxMwRibbcacgw04qapq5
 v2Rz3mFpBaTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440160285"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.172])
  by fmsmga008.fm.intel.com with ESMTP; 19 May 2021 22:43:33 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 1/6] target/i386: Change XSAVE related feature-word names
Date:   Thu, 20 May 2021 13:57:06 +0800
Message-Id: <1621490231-4765-2-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621490231-4765-1-git-send-email-weijiang.yang@intel.com>
References: <1621490231-4765-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename XSAVE related feature-words for introducing XSAVES related
feature-words.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.c | 24 ++++++++++++------------
 target/i386/cpu.h |  4 ++--
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ad99cad0e7..5c76186883 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1077,7 +1077,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .cpuid = { .eax = 6, .reg = R_EAX, },
         .tcg_features = TCG_6_EAX_FEATURES,
     },
-    [FEAT_XSAVE_COMP_LO] = {
+    [FEAT_XSAVE_XCR0_LO] = {
         .type = CPUID_FEATURE_WORD,
         .cpuid = {
             .eax = 0xD,
@@ -1090,7 +1090,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
             XSTATE_PKRU_MASK,
     },
-    [FEAT_XSAVE_COMP_HI] = {
+    [FEAT_XSAVE_XCR0_HI] = {
         .type = CPUID_FEATURE_WORD,
         .cpuid = {
             .eax = 0xD,
@@ -1519,8 +1519,8 @@ static inline bool accel_uses_host_cpuid(void)
 
 static inline uint64_t x86_cpu_xsave_components(X86CPU *cpu)
 {
-    return ((uint64_t)cpu->env.features[FEAT_XSAVE_COMP_HI]) << 32 |
-           cpu->env.features[FEAT_XSAVE_COMP_LO];
+    return ((uint64_t)cpu->env.features[FEAT_XSAVE_XCR0_HI]) << 32 |
+           cpu->env.features[FEAT_XSAVE_XCR0_LO];
 }
 
 /* Return name of 32-bit register, from a R_* constant */
@@ -4811,8 +4811,8 @@ static const char *x86_cpu_feature_name(FeatureWord w, int bitnr)
     /* XSAVE components are automatically enabled by other features,
      * so return the original feature name instead
      */
-    if (w == FEAT_XSAVE_COMP_LO || w == FEAT_XSAVE_COMP_HI) {
-        int comp = (w == FEAT_XSAVE_COMP_HI) ? bitnr + 32 : bitnr;
+    if (w == FEAT_XSAVE_XCR0_LO || w == FEAT_XSAVE_XCR0_HI) {
+        int comp = (w == FEAT_XSAVE_XCR0_HI) ? bitnr + 32 : bitnr;
 
         if (comp < ARRAY_SIZE(x86_ext_save_areas) &&
             x86_ext_save_areas[comp].bits) {
@@ -5860,8 +5860,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 
         if (count == 0) {
             *ecx = xsave_area_size(x86_cpu_xsave_components(cpu));
-            *eax = env->features[FEAT_XSAVE_COMP_LO];
-            *edx = env->features[FEAT_XSAVE_COMP_HI];
+            *eax = env->features[FEAT_XSAVE_XCR0_LO];
+            *edx = env->features[FEAT_XSAVE_XCR0_HI];
             /*
              * The initial value of xcr0 and ebx == 0, On host without kvm
              * commit 412a3c41(e.g., CentOS 6), the ebx's value always == 0
@@ -6431,8 +6431,8 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
     uint64_t mask;
 
     if (!(env->features[FEAT_1_ECX] & CPUID_EXT_XSAVE)) {
-        env->features[FEAT_XSAVE_COMP_LO] = 0;
-        env->features[FEAT_XSAVE_COMP_HI] = 0;
+        env->features[FEAT_XSAVE_XCR0_LO] = 0;
+        env->features[FEAT_XSAVE_XCR0_HI] = 0;
         return;
     }
 
@@ -6444,8 +6444,8 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
         }
     }
 
-    env->features[FEAT_XSAVE_COMP_LO] = mask;
-    env->features[FEAT_XSAVE_COMP_HI] = mask >> 32;
+    env->features[FEAT_XSAVE_XCR0_LO] = mask;
+    env->features[FEAT_XSAVE_XCR0_HI] = mask >> 32;
 }
 
 /***** Steps involved on loading and filtering CPUID data
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 570f916878..84cb6adcaa 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -526,8 +526,8 @@ typedef enum FeatureWord {
     FEAT_SVM,           /* CPUID[8000_000A].EDX */
     FEAT_XSAVE,         /* CPUID[EAX=0xd,ECX=1].EAX */
     FEAT_6_EAX,         /* CPUID[6].EAX */
-    FEAT_XSAVE_COMP_LO, /* CPUID[EAX=0xd,ECX=0].EAX */
-    FEAT_XSAVE_COMP_HI, /* CPUID[EAX=0xd,ECX=0].EDX */
+    FEAT_XSAVE_XCR0_LO, /* CPUID[EAX=0xd,ECX=0].EAX */
+    FEAT_XSAVE_XCR0_HI, /* CPUID[EAX=0xd,ECX=0].EDX */
     FEAT_ARCH_CAPABILITIES,
     FEAT_CORE_CAPABILITY,
     FEAT_PERF_CAPABILITIES,
-- 
2.26.2

