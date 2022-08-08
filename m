Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12E558C52C
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 10:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbiHHI6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 04:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241893AbiHHI6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 04:58:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587E813E98
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 01:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659949120; x=1691485120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sMeNMCeZNXZfdLy9FS84VE+qEv8yvkewDl1wPPOst7U=;
  b=bKNTmddqRiuFAdk7YY3huazvjR+IdH/8cTUaOOjkDHbVycYHw5973Fn2
   7hUrUF3h9r2brAY15+evc408bhWvUL7hTm7IGip2dB3Lqj3xf63F+wz2Z
   3xiDCwu9HuCMUqjuxBIZhBJa7hxuIl2xlS9wnApykzKvXvp5o4GaeTNC+
   rjMjhov1LjmXdD72eAX/yAJjW6tXwdOVX92qjWnrXm2WXe5oCudLyZxO2
   dL4Jl+y8w+lTF/Y6mmTtv+n8O+bII9jyW9nNqOwglpEAQjLXmG/50JxND
   5ueP6DBTCdZK4CefG0jE+W+ZPw6ySedGvAunr7RVLOEZIVjZebJMepil3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="376835059"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="376835059"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 01:58:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="931970567"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 08 Aug 2022 01:58:38 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 3/8] target/i386/intel-pt: Introduce FeatureWordInfo for Intel PT CPUID leaf 0xD
Date:   Mon,  8 Aug 2022 16:58:29 +0800
Message-Id: <20220808085834.3227541-4-xiaoyao.li@intel.com>
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

CPUID leaf 0x14 subleaf 0x0 and 0x1 enumerate the resource and
capability of Intel PT.

Introduce FeatureWord FEAT_14_0_EBX, FEAT_14_1_EAX and FEAT_14_1_EBX,
and complete FEAT_14_0_ECX. Thus all the features of Intel PT can be
expanded when "-cpu host/max" and can be configured in named CPU model.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 136 +++++++++++++++++++++++++++++++++++++++++++---
 target/i386/cpu.h |   3 +
 2 files changed, 130 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index fa02910ce811..8b74d18c127f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1208,17 +1208,32 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         }
     },
 
+    [FEAT_14_0_EBX] = {
+        .type = CPUID_FEATURE_WORD,
+        .feat_names = {
+            [0] = "intel-pt-cr3-filter",
+            [1] = "intel-pt-psb",
+            [2] = "intel-pt-ip-filter",
+            [3] = "intel-pt-mtc",
+            [4] = "intel-pt-ptwrite",
+            [5] = "intel-pt-power-event",
+            [6] = "intel-pt-psb-pmi-preservation",
+        },
+        .cpuid = {
+            .eax = 0x14,
+            .needs_ecx = true, .ecx = 0,
+            .reg = R_EBX,
+        },
+    },
+
     [FEAT_14_0_ECX] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
-            NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, "intel-pt-lip",
+            [0] = "intel-pt-topa",
+            [1] = "intel-pt-multi-topa-entries",
+            [2] = "intel-pt-single-range",
+            [3] = "intel-pt-trace-transport-subsystem",
+            [31] = "intel-pt-lip",
         },
         .cpuid = {
             .eax = 0x14,
@@ -1228,6 +1243,79 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .tcg_features = TCG_14_0_ECX_FEATURES,
      },
 
+    [FEAT_14_1_EAX] = {
+        .type = CPUID_FEATURE_WORD,
+        .feat_names = {
+            [0] = "intel-pt-addr-range-num-bit0",
+            [1] = "intel-pt-addr-range-num-bit1",
+            [2] = "intel-pt-addr-range-num-bit2",
+            [16] = "intel-pt-mtc-period-encoding-0",
+            [17] = "intel-pt-mtc-period-encoding-1",
+            [18] = "intel-pt-mtc-period-encoding-2",
+            [19] = "intel-pt-mtc-period-encoding-3",
+            [20] = "intel-pt-mtc-period-encoding-4",
+            [21] = "intel-pt-mtc-period-encoding-5",
+            [22] = "intel-pt-mtc-period-encoding-6",
+            [23] = "intel-pt-mtc-period-encoding-7",
+            [24] = "intel-pt-mtc-period-encoding-8",
+            [25] = "intel-pt-mtc-period-encoding-9",
+            [26] = "intel-pt-mtc-period-encoding-10",
+            [27] = "intel-pt-mtc-period-encoding-11",
+            [28] = "intel-pt-mtc-period-encoding-12",
+            [29] = "intel-pt-mtc-period-encoding-13",
+            [30] = "intel-pt-mtc-period-encoding-14",
+            [31] = "intel-pt-mtc-period-encoding-15",
+        },
+        .cpuid = {
+            .eax = 0x14,
+            .needs_ecx = true, .ecx = 1,
+            .reg = R_EAX,
+        },
+    },
+
+    [FEAT_14_1_EBX] = {
+        .type = CPUID_FEATURE_WORD,
+        .feat_names = {
+            [0] = "intel-pt-cyc-thresh-0",
+            [1] = "intel-pt-cyc-thresh-1",
+            [2] = "intel-pt-cyc-thresh-2",
+            [3] = "intel-pt-cyc-thresh-4",
+            [4] = "intel-pt-cyc-thresh-8",
+            [5] = "intel-pt-cyc-thresh-16",
+            [6] = "intel-pt-cyc-thresh-32",
+            [7] = "intel-pt-cyc-thresh-64",
+            [8] = "intel-pt-cyc-thresh-128",
+            [9] = "intel-pt-cyc-thresh-256",
+            [10] = "intel-pt-cyc-thresh-512",
+            [11] = "intel-pt-cyc-thresh-1024",
+            [12] = "intel-pt-cyc-thresh-2048",
+            [13] = "intel-pt-cyc-thresh-4096",
+            [14] = "intel-pt-cyc-thresh-8192",
+            [15] = "intel-pt-cyc-thresh-16384",
+            [16] = "intel-pt-psb-freq-2k",
+            [17] = "intel-pt-psb-freq-4k",
+            [18] = "intel-pt-psb-freq-8k",
+            [19] = "intel-pt-psb-freq-16k",
+            [20] = "intel-pt-psb-freq-32k",
+            [21] = "intel-pt-psb-freq-64k",
+            [22] = "intel-pt-psb-freq-128k",
+            [23] = "intel-pt-psb-freq-256k",
+            [24] = "intel-pt-psb-freq-512k",
+            [25] = "intel-pt-psb-freq-1m",
+            [26] = "intel-pt-psb-freq-2m",
+            [27] = "intel-pt-psb-freq-4m",
+            [28] = "intel-pt-psb-freq-8m",
+            [29] = "intel-pt-psb-freq-16m",
+            [30] = "intel-pt-psb-freq-32m",
+            [31] = "intel-pt-psb-freq-64m",
+        },
+        .cpuid = {
+            .eax = 0x14,
+            .needs_ecx = true, .ecx = 1,
+            .reg = R_EBX,
+        },
+    },
+
     [FEAT_SGX_12_0_EAX] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
@@ -1367,10 +1455,22 @@ static FeatureDep feature_dependencies[] = {
         .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_RDSEED },
         .to = { FEAT_VMX_SECONDARY_CTLS,    VMX_SECONDARY_EXEC_RDSEED_EXITING },
     },
+    {
+        .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_INTEL_PT },
+        .to = { FEAT_14_0_EBX,              ~0ull },
+    },
     {
         .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_INTEL_PT },
         .to = { FEAT_14_0_ECX,              ~0ull },
     },
+    {
+        .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_INTEL_PT },
+        .to = { FEAT_14_1_EAX,              ~0ull },
+    },
+    {
+        .from = { FEAT_7_0_EBX,             CPUID_7_0_EBX_INTEL_PT },
+        .to = { FEAT_14_1_EBX,              ~0ull },
+    },
     {
         .from = { FEAT_8000_0001_EDX,       CPUID_EXT2_RDTSCP },
         .to = { FEAT_VMX_SECONDARY_CTLS,    VMX_SECONDARY_EXEC_RDTSCP },
@@ -6318,7 +6418,25 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
         uint64_t host_feat =
             x86_cpu_get_supported_feature_word(w, false);
         uint64_t requested_features = env->features[w];
-        uint64_t unavailable_features = requested_features & ~host_feat;
+        uint64_t unavailable_features;
+
+        switch (w) {
+        case FEAT_14_1_EAX:
+            /* Handling the bits except INTEL_PT_ADDR_RANGES_NUM_MASK */
+            unavailable_features = (requested_features & ~host_feat) &
+                                   ~INTEL_PT_ADDR_RANGES_NUM_MASK;
+            /* Bits 2:0 are as a whole to represent INTEL_PT_ADDR_RANGES */
+            if ((requested_features & INTEL_PT_ADDR_RANGES_NUM_MASK) >
+                (host_feat & INTEL_PT_ADDR_RANGES_NUM_MASK)) {
+                unavailable_features |= requested_features &
+                                        INTEL_PT_ADDR_RANGES_NUM_MASK;
+            }
+            break;
+        default:
+            unavailable_features = requested_features & ~host_feat;
+            break;
+        }
+
         mark_unavailable_features(cpu, w, unavailable_features, prefix);
     }
 
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 82004b65b944..28584c78adbb 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -615,7 +615,10 @@ typedef enum FeatureWord {
     FEAT_VMX_EPT_VPID_CAPS,
     FEAT_VMX_BASIC,
     FEAT_VMX_VMFUNC,
+    FEAT_14_0_EBX,
     FEAT_14_0_ECX,
+    FEAT_14_1_EAX,
+    FEAT_14_1_EBX,
     FEAT_SGX_12_0_EAX,  /* CPUID[EAX=0x12,ECX=0].EAX (SGX) */
     FEAT_SGX_12_0_EBX,  /* CPUID[EAX=0x12,ECX=0].EBX (SGX MISCSELECT[31:0]) */
     FEAT_SGX_12_1_EAX,  /* CPUID[EAX=0x12,ECX=1].EAX (SGX ATTRIBUTES[31:0]) */
-- 
2.27.0

