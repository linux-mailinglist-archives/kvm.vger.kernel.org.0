Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92193717A65
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 10:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbjEaIoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 04:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234966AbjEaIn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 04:43:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A6C183
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 01:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685522619; x=1717058619;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qtxSQy+gTKsjprIgvXTBFPFgWEaxZXOK+kQoREo9KPY=;
  b=lQwXQOv138xJ2SMyiNN3WcSU3V1UKhPbWKC8BKv0chrp8AF90nYrtefx
   RcAb/H6xE5gkoqAJjIMPk1cLaFvuC4jlte0dYofgeKZyJsjVVG1f31tYa
   SWLBqYJ0mbsRbo60rH2ZIsrG3H5kZD3hJrAl/+ojjFlnN8jo/gR9Sqq/g
   CDtLTyUb/y+kTeo3Z8qm5oK/AvAItFoW+Jz9Ovgwsy+2RRz1QeSv3blAI
   cCippZPDAWIUH4HEVyvzyzkVg2fHZ536Ob10IvuCQJGtqKm3tTmLJKand
   FO7N0EWzFZ3Q4B/TqvJ8vxWwQ8fOxqh2LB/sCWomHPD5yv+Koyww7XtLz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418669296"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418669296"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 01:43:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="1036956464"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="1036956464"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 01:43:26 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>, lei4.wang@intel.com
Subject: [PATCH v4 6/8] target/i386/intel-pt: Enable host pass through of Intel PT
Date:   Wed, 31 May 2023 04:43:09 -0400
Message-Id: <20230531084311.3807277-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230531084311.3807277-1-xiaoyao.li@intel.com>
References: <20230531084311.3807277-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit e37a5c7fa459 ("i386: Add Intel Processor Trace feature support")
added the support of Intel PT by making CPUID[14] of PT as fixed feature
set (from ICX) for any CPU model on any host. This truly breaks the PT
exposure on Intel SPR platform because SPR has less supported bitmap of
CPUID(0x14,1):EBX[15:0] than ICX.

To fix the problem, enable pass through of host's PT capabilities for
the cases "-cpu host/max" that it won't use default fixed PT feature set
of ICX but expand automatically based on get_supported_cpuid() reported
by KVM.

Meanwhile, it needs to ensure (old) named CPU models still have
the fixed Intel PT feature set to not break the live migration case of
"-cpu named_cpu_model,+intel-pt" wiht old QEMU. To achieve this, assign
default Intel PT feature values to named CPU models if no value defined
in CPU models explicitly.

In the future, new named CPU model, e.g., Sapphire Rapids, can define
its own PT feature set by providing their own FEAT_14_0_EBX,
FEAT_14_0_ECX, FEAT_14_1_EAX and FEAT_14_1_EBX.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
 - drop use_default_intel_pt flag and the handling of validating final
   env->features[FEAT_14*] matches with INTEL_PT_DEFAULT_*. It's found
   unnecessary because old QEMU has no ability to customize Intel PT
   feature set with +/-feature.
---
 target/i386/cpu.c | 62 ++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 29dd79b16f6b..e47629aff68e 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5723,6 +5723,24 @@ static void x86_cpu_load_model(X86CPU *cpu, X86CPUModel *model)
         env->features[w] = def->features[w];
     }
 
+    /*
+     * All (old) named CPU models have the same default values for INTEL_PT if
+     * the leaf values are not explicitly specified.
+     *
+     * Assign the default value here since we don't want to manually copy/paste
+     * it to all entries in builtin_x86_defs[].
+     *
+     * It's safe to set values for Intel PT leaves here because they will be
+     * cleared due to feature_dependencies if CPUID_7_0_EBX_INTEL_PT is absent.
+     */
+    if (!env->features[FEAT_14_0_EBX] && !env->features[FEAT_14_0_ECX] &&
+        !env->features[FEAT_14_1_EAX] && !env->features[FEAT_14_1_EBX]) {
+        env->features[FEAT_14_0_EBX] = INTEL_PT_DEFAULT_0_EBX;
+        env->features[FEAT_14_0_ECX] = INTEL_PT_DEFAULT_0_ECX;
+        env->features[FEAT_14_1_EAX] = INTEL_PT_DEFAULT_1_EAX;
+        env->features[FEAT_14_1_EBX] = INTEL_PT_DEFAULT_1_EBX;
+    }
+
     /* legacy-cache defaults to 'off' if CPU model provides cache info */
     cpu->legacy_cache = !x86_cpu_get_versioned_cache_info(cpu, model);
 
@@ -6245,14 +6263,11 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 
         if (count == 0) {
             *eax = INTEL_PT_MAX_SUBLEAF;
-            *ebx = INTEL_PT_DEFAULT_0_EBX;
-            *ecx = INTEL_PT_DEFAULT_0_ECX;
-            if (env->features[FEAT_14_0_ECX] & CPUID_14_0_ECX_LIP) {
-                *ecx |= CPUID_14_0_ECX_LIP;
-            }
+            *ebx = env->features[FEAT_14_0_EBX];
+            *ecx = env->features[FEAT_14_0_ECX];
         } else if (count == 1) {
-            *eax = INTEL_PT_DEFAULT_1_EAX;
-            *ebx = INTEL_PT_DEFAULT_1_EBX;
+            *eax = env->features[FEAT_14_1_EAX];
+            *ebx = env->features[FEAT_14_1_EBX];
         }
         break;
     }
@@ -6964,6 +6979,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
     CPUX86State *env = &cpu->env;
     FeatureWord w;
     const char *prefix = NULL;
+    uint64_t host_feat;
 
     if (verbose) {
         prefix = accel_uses_host_cpuid()
@@ -6972,8 +6988,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
     }
 
     for (w = 0; w < FEATURE_WORDS; w++) {
-        uint64_t host_feat =
-            x86_cpu_get_supported_feature_word(w, false);
+        host_feat = x86_cpu_get_supported_feature_word(w, false);
         uint64_t requested_features = env->features[w];
         uint64_t unavailable_features;
 
@@ -6997,30 +7012,11 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
         mark_unavailable_features(cpu, w, unavailable_features, prefix);
     }
 
-    if ((env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) &&
-        kvm_enabled()) {
-        KVMState *s = CPU(cpu)->kvm_state;
-        uint32_t eax_0 = kvm_arch_get_supported_cpuid(s, 0x14, 0, R_EAX);
-        uint32_t ebx_0 = kvm_arch_get_supported_cpuid(s, 0x14, 0, R_EBX);
-        uint32_t ecx_0 = kvm_arch_get_supported_cpuid(s, 0x14, 0, R_ECX);
-        uint32_t eax_1 = kvm_arch_get_supported_cpuid(s, 0x14, 1, R_EAX);
-        uint32_t ebx_1 = kvm_arch_get_supported_cpuid(s, 0x14, 1, R_EBX);
-
-        if (!eax_0 ||
-           ((ebx_0 & INTEL_PT_DEFAULT_0_EBX) != INTEL_PT_DEFAULT_0_EBX) ||
-           ((ecx_0 & INTEL_PT_DEFAULT_0_ECX) != INTEL_PT_DEFAULT_0_ECX) ||
-           ((eax_1 & INTEL_PT_DEFAULT_MTC_BITMAP) != INTEL_PT_DEFAULT_MTC_BITMAP) ||
-           ((eax_1 & INTEL_PT_ADDR_RANGES_NUM_MASK) <
-                                      INTEL_PT_DEFAULT_ADDR_RANGES_NUM) ||
-           ((ebx_1 & INTEL_PT_DEFAULT_1_EBX) != INTEL_PT_DEFAULT_1_EBX) ||
-           ((ecx_0 & CPUID_14_0_ECX_LIP) !=
-                (env->features[FEAT_14_0_ECX] & CPUID_14_0_ECX_LIP))) {
-            /*
-             * Processor Trace capabilities aren't configurable, so if the
-             * host can't emulate the capabilities we report on
-             * cpu_x86_cpuid(), intel-pt can't be enabled on the current host.
-             */
-            mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT, prefix);
+    if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
+        host_feat = x86_cpu_get_supported_feature_word(FEAT_14_0_ECX, false);
+        if ((env->features[FEAT_14_0_ECX] ^ host_feat) & CPUID_14_0_ECX_LIP) {
+            warn_report("Cannot configure different Intel PT IP payload format than hardware");
+            mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT, NULL);
         }
     }
 }
-- 
2.34.1

