Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91655717A62
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 10:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbjEaIn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 04:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234931AbjEaIn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 04:43:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9DA113
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 01:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685522605; x=1717058605;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tdHez5vp4jS9ioxnU93LsxbiSFFkxThteRjsc69/woI=;
  b=RFbmu+DRiffturibchucl+V+acEpUmWMRWIwpmbRwqycEsrGG8hBdLmB
   DaQDq3mh9DnlMcfTnBJ4NRurAUTMqriCbHM8qWaeIA4bisw6zK/uUTh41
   Gz2oEtnjEqnNU/ZVe4w1NPBBe1/En7AW5JG+aCVhukMH2VZY2GsTelIfi
   XN1VYV3KUnZiaPOPRpP08wKM03Bfkmmy1rZYHTvuTnXY01Nes4oIougqh
   4jyzNsznEinDoloPTy3EwkmBgb4RvWi/6ZJT9YFGghc/4SUV6cUqoT6sH
   7TowimwjrSDgsU+mQHgppGJnool7oQRxFoTfdRA6/mBRUGFrVNkyYE3IK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418669266"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418669266"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 01:43:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="1036956422"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="1036956422"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 01:43:20 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>, lei4.wang@intel.com
Subject: [PATCH v4 3/8] target/i386/intel-pt: Introduce FeatureWordInfo for Intel PT CPUID leaf 0x14
Date:   Wed, 31 May 2023 04:43:06 -0400
Message-Id: <20230531084311.3807277-4-xiaoyao.li@intel.com>
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

CPUID leaf 0x14 subleaf 0x0 and 0x1 enumerate the resource and
capability of Intel PT.

Introduce FeatureWord FEAT_14_0_EBX, FEAT_14_1_EAX and FEAT_14_1_EBX,
and complete FEAT_14_0_ECX. Thus all the features of Intel PT can be
expanded when "-cpu host/max" and can be configured in named CPU model.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
v3:
 - Add bit 7 and 8 of FEAT_14_0_EBX
---
 target/i386/cpu.c | 138 +++++++++++++++++++++++++++++++++++++++++++---
 target/i386/cpu.h |   3 +
 2 files changed, 132 insertions(+), 9 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 7d2f20c84c7a..e735c366bc97 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1248,17 +1248,34 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
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
+            [7] = "intel-pt-event-trace",
+            [8] = "intel-pt-tnt-disable",
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
@@ -1268,6 +1285,79 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
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
@@ -1407,10 +1497,22 @@ static FeatureDep feature_dependencies[] = {
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
@@ -6871,7 +6973,25 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
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
index 7201a71de863..500693eb9847 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -621,7 +621,10 @@ typedef enum FeatureWord {
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
2.34.1

