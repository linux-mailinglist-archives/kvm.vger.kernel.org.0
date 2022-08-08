Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F26C58C530
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 10:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiHHI65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 04:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242039AbiHHI6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 04:58:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B469A13EA8
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 01:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659949124; x=1691485124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y6Bd+emfUrUHrQ4u0Fcrr+Ou+CgIfyt+4yF4G7TtuEY=;
  b=H6d0b2sDgyRLSeb3bu/1m26ik/dvbCrNtRUglTOFV0AgZqdvWm64DqJ/
   X/gb4Ra/vMnUOW41i0vtlQgMy4RrBOXgpBO6dtQpPUGPzhaoihRhcu7rI
   jTlqdqXzkRBRYotBFXTkw1gZck2lVYzfBZHakQHOtw2gsXrXbdVjc7MqQ
   EOVj3xneNT3yvFyGN4yo6VRmcTDh60O9Y+LuyXAOixrihtTLTJyLv9ePR
   t5d8X+5cNONJPYSYoQAvIV2bw9ABrHKW5scnB8udC0mwoeu8GaxqUwty0
   zHGgdZIP792Ie5r/jXO3JUhHdzXSu1B0dhaDyxNuAwPYGzUljFjRWAtX6
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="376835074"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="376835074"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 01:58:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="931970607"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 08 Aug 2022 01:58:43 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 6/8] target/i386/intel-pt: Enable host pass through of Intel PT
Date:   Mon,  8 Aug 2022 16:58:32 +0800
Message-Id: <20220808085834.3227541-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220808085834.3227541-1-xiaoyao.li@intel.com>
References: <20220808085834.3227541-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
of ICX but expand automatically based on get_supported_cpuid reported by
host. Meanwhile, it needs to ensure named CPU model still has the fixed
PT feature set to not break the live migration case of
"-cpu named_cpu_model,+intel-pt"

Introduces env->use_default_intel_pt flag.
 - True means it's old CPU model that uses fixed PT feature set of ICX.
 - False means the named CPU model has its own PT feature set.

Besides, to keep the same behavior for old CPU models that validate PT
feature set against default fixed PT feature set of ICX in addition to
validate from host's capabilities (via get_supported_cpuid) in
x86_cpu_filter_features().

In the future, new named CPU model, e.g., Sapphire Rapids, can define
its own PT feature set by setting @has_specific_intel_pt_feature_set to
true and defines it's own FEAT_14_0_EBX, FEAT_14_0_ECX, FEAT_14_1_EAX
and FEAT_14_1_EBX.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 71 ++++++++++++++++++++++++++---------------------
 target/i386/cpu.h |  1 +
 2 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b08d2d63d8bf..2664b527b8e8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5192,6 +5192,21 @@ static void x86_cpu_load_model(X86CPU *cpu, X86CPUModel *model)
         env->features[w] = def->features[w];
     }
 
+    /*
+     * All (old) named CPU models have the same default values for INTEL_PT_*
+     *
+     * Assign the default value here since we don't want to manually copy/paste
+     * it to all entries in builtin_x86_defs.
+     */
+    if (!env->features[FEAT_14_0_EBX] && !env->features[FEAT_14_0_ECX] &&
+        !env->features[FEAT_14_1_EAX] && !env->features[FEAT_14_1_EBX]) {
+        env->use_default_intel_pt = true;
+        env->features[FEAT_14_0_EBX] = INTEL_PT_DEFAULT_0_EBX;
+        env->features[FEAT_14_0_ECX] = INTEL_PT_DEFAULT_0_ECX;
+        env->features[FEAT_14_1_EAX] = INTEL_PT_DEFAULT_1_EAX;
+        env->features[FEAT_14_1_EBX] = INTEL_PT_DEFAULT_1_EBX;
+    }
+
     /* legacy-cache defaults to 'off' if CPU model provides cache info */
     cpu->legacy_cache = !def->cache_info;
 
@@ -5714,14 +5729,11 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
 
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
@@ -6409,6 +6421,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
     CPUX86State *env = &cpu->env;
     FeatureWord w;
     const char *prefix = NULL;
+    uint64_t host_feat;
 
     if (verbose) {
         prefix = accel_uses_host_cpuid()
@@ -6417,8 +6430,7 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
     }
 
     for (w = 0; w < FEATURE_WORDS; w++) {
-        uint64_t host_feat =
-            x86_cpu_get_supported_feature_word(w, false);
+        host_feat = x86_cpu_get_supported_feature_word(w, false);
         uint64_t requested_features = env->features[w];
         uint64_t unavailable_features;
 
@@ -6442,31 +6454,26 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
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
+    if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_INTEL_PT) {
+        /*
+         * env->use_default_intel_pt is true means the CPU model doesn't have
+         * INTEL_PT_* specified. In this case, we need to check it has the
+         * value of default INTEL_PT to not break live migration
+         */
+        if (env->use_default_intel_pt &&
+            ((env->features[FEAT_14_0_EBX] != INTEL_PT_DEFAULT_0_EBX) ||
+             ((env->features[FEAT_14_0_ECX] & ~CPUID_14_0_ECX_LIP) !=
+              INTEL_PT_DEFAULT_0_ECX) ||
+             (env->features[FEAT_14_1_EAX] != INTEL_PT_DEFAULT_1_EAX) ||
+             (env->features[FEAT_14_1_EBX] != INTEL_PT_DEFAULT_1_EBX))) {
             mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT, prefix);
         }
+
+        host_feat = x86_cpu_get_supported_feature_word(FEAT_14_0_ECX, false);
+        if ((env->features[FEAT_14_0_ECX] ^ host_feat) & CPUID_14_0_ECX_LIP) {
+            warn_report("Cannot configure different Intel PT IP payload format than hardware");
+            mark_unavailable_features(cpu, FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT, NULL);
+        }
     }
 }
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 30aff5f0f41d..797f384e3fc4 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1749,6 +1749,7 @@ typedef struct CPUArchState {
     uint32_t cpuid_vendor2;
     uint32_t cpuid_vendor3;
     uint32_t cpuid_version;
+    bool use_default_intel_pt;
     FeatureWordArray features;
     /* Features that were explicitly enabled/disabled */
     FeatureWordArray user_features;
-- 
2.27.0

