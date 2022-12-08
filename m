Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AD3646914
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 07:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiLHGZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 01:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiLHGZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 01:25:22 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC2E1F2EC
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 22:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670480721; x=1702016721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qqDomaWAedABch5XRX7qa2ftKhkbEh7yFAQLtdbNsts=;
  b=mjJSurAlEv71715LfQJmP6wltSkfZw2ws7mXIi5adNq9z+uUP97Xz3mM
   bXC4baggrn7wFweBABvQ0Tx7iKTIP4Krxl9UX6+Dbmvkf+t21sodjP0ur
   ii7jbLXH+AZ2JmaRQ7BhVvC7XJyf3LpiB8Rw1IJqyyKqj1ooZkjuEPTMF
   igd/scTnxSiRDdYHtiVZSU986Ya0osymy0gxwPiOXMNjzQhfMELZJqARc
   Db/F9qU4zMWKILbv+9mByxMbipuWJc5gxh7q1hKim+ii0MXQyGf6NYBqr
   594QdDrikqnP5+I/qI2rjAGpDGuxJKQYn785a3wdgKZQORQyDfxCsrgr6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="297444459"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="297444459"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 22:25:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679413402"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="679413402"
Received: from lxy-dell.sh.intel.com ([10.239.48.100])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 22:25:19 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com
Subject: [PATCH v3 3/8] target/i386/intel-pt: Introduce FeatureWordInfo for Intel PT CPUID leaf 0x14
Date:   Thu,  8 Dec 2022 14:25:08 +0800
Message-Id: <20221208062513.2589476-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221208062513.2589476-1-xiaoyao.li@intel.com>
References: <20221208062513.2589476-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 9ae36639d380..65c6f8ae771a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1208,17 +1208,34 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
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
@@ -1228,6 +1245,79 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
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
@@ -1367,10 +1457,22 @@ static FeatureDep feature_dependencies[] = {
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
@@ -6332,7 +6434,25 @@ static void x86_cpu_filter_features(X86CPU *cpu, bool verbose)
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
index d4bc19577a21..d8b3535d5aa7 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -617,7 +617,10 @@ typedef enum FeatureWord {
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

