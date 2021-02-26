Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1837D325B73
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 03:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhBZCKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 21:10:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:38817 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhBZCKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 21:10:09 -0500
IronPort-SDR: bAex37otdPAZZOEWOxBkDyVihQqY3UTDGDs8ZfOyy040bsNPqZXtU6LhBSJwkJmoYeQ4Jx9tB+
 dcFcRPVUSAGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185800998"
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="185800998"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2021 18:09:28 -0800
IronPort-SDR: bjxgzeF6JzUJvY+97ND+UZZ8321fSgbVuxHpTasxMTYoKWPQrp3t/mcZWYUPaCKZYopX/0jmow
 tZDhYwDD6zgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="404679946"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 25 Feb 2021 18:09:26 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, richard.henderson@linaro.org,
        ehabkost@redhat.com, mtosatti@redhat.com,
        sean.j.christopherson@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 1/6] target/i386: Change XSAVE related feature-word names
Date:   Fri, 26 Feb 2021 10:20:53 +0800
Message-Id: <20210226022058.24562-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210226022058.24562-1-weijiang.yang@intel.com>
References: <20210226022058.24562-1-weijiang.yang@intel.com>
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
index 5a8c96072e..89edab4240 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1073,7 +1073,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .cpuid = { .eax = 6, .reg = R_EAX, },
         .tcg_features = TCG_6_EAX_FEATURES,
     },
-    [FEAT_XSAVE_COMP_LO] = {
+    [FEAT_XSAVE_XCR0_LO] = {
         .type = CPUID_FEATURE_WORD,
         .cpuid = {
             .eax = 0xD,
@@ -1086,7 +1086,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
             XSTATE_PKRU_MASK,
     },
-    [FEAT_XSAVE_COMP_HI] = {
+    [FEAT_XSAVE_XCR0_HI] = {
         .type = CPUID_FEATURE_WORD,
         .cpuid = {
             .eax = 0xD,
@@ -1491,8 +1491,8 @@ static inline bool accel_uses_host_cpuid(void)
 
 static inline uint64_t x86_cpu_xsave_components(X86CPU *cpu)
 {
-    return ((uint64_t)cpu->env.features[FEAT_XSAVE_COMP_HI]) << 32 |
-           cpu->env.features[FEAT_XSAVE_COMP_LO];
+    return ((uint64_t)cpu->env.features[FEAT_XSAVE_XCR0_HI]) << 32 |
+           cpu->env.features[FEAT_XSAVE_XCR0_LO];
 }
 
 const char *get_register_name_32(unsigned int reg)
@@ -4663,8 +4663,8 @@ static const char *x86_cpu_feature_name(FeatureWord w, int bitnr)
     /* XSAVE components are automatically enabled by other features,
      * so return the original feature name instead
      */
-    if (w == FEAT_XSAVE_COMP_LO || w == FEAT_XSAVE_COMP_HI) {
-        int comp = (w == FEAT_XSAVE_COMP_HI) ? bitnr + 32 : bitnr;
+    if (w == FEAT_XSAVE_XCR0_LO || w == FEAT_XSAVE_XCR0_HI) {
+        int comp = (w == FEAT_XSAVE_XCR0_HI) ? bitnr + 32 : bitnr;
 
         if (comp < ARRAY_SIZE(x86_ext_save_areas) &&
             x86_ext_save_areas[comp].bits) {
@@ -5717,8 +5717,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 
         if (count == 0) {
             *ecx = xsave_area_size(x86_cpu_xsave_components(cpu));
-            *eax = env->features[FEAT_XSAVE_COMP_LO];
-            *edx = env->features[FEAT_XSAVE_COMP_HI];
+            *eax = env->features[FEAT_XSAVE_XCR0_LO];
+            *edx = env->features[FEAT_XSAVE_XCR0_HI];
             /*
              * The initial value of xcr0 and ebx == 0, On host without kvm
              * commit 412a3c41(e.g., CentOS 6), the ebx's value always == 0
@@ -6282,8 +6282,8 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
     uint64_t mask;
 
     if (!(env->features[FEAT_1_ECX] & CPUID_EXT_XSAVE)) {
-        env->features[FEAT_XSAVE_COMP_LO] = 0;
-        env->features[FEAT_XSAVE_COMP_HI] = 0;
+        env->features[FEAT_XSAVE_XCR0_LO] = 0;
+        env->features[FEAT_XSAVE_XCR0_HI] = 0;
         return;
     }
 
@@ -6295,8 +6295,8 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
         }
     }
 
-    env->features[FEAT_XSAVE_COMP_LO] = mask;
-    env->features[FEAT_XSAVE_COMP_HI] = mask >> 32;
+    env->features[FEAT_XSAVE_XCR0_LO] = mask;
+    env->features[FEAT_XSAVE_XCR0_HI] = mask >> 32;
 }
 
 /***** Steps involved on loading and filtering CPUID data
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 88e8586f8f..52f31335c4 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -527,8 +527,8 @@ typedef enum FeatureWord {
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

