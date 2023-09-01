Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E287978F841
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 07:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348305AbjIAF7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 01:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjIAF73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 01:59:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50ACF10C2
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 22:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693547967; x=1725083967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dgdPhUMzK6D3ckRjnlBJala0jrjc4SAmU3BSPc0PwkE=;
  b=DTN0Bujt3LZ6J0NsLSW1b9mNPpSL2qXeR9Ie2c94UYy/4Z5XLiF2TJ/U
   78bwTX/09f26VFszZUZPaonOHETDdoco0a3B0ZSqjm2QE6cd9jSA0V3uo
   v6kudS035VsHlgEUi+k5rKsjFwkL5XSSKqTFrSFMVU4l1wQaOsHM2KFy4
   1Uqse/AZP6kYESf5ENSDn+LNC8dBdO1CYHzL/W7cM9E7vDN+unDn8iQwI
   HSR43Qcwk/o/oqMCwIzp8O4YbKMd1ag5TKTFSHQ8YSkEFlTnHDF6ooDTO
   NIwHuxT237FaIYFFM0HYvNSdF/NlS1rvKbF7SlJMa8zJtmtq5iETNU4R2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="356456625"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="356456625"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 22:59:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="739816157"
X-IronPort-AV: E=Sophos;i="6.02,218,1688454000"; 
   d="scan'208";a="739816157"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 31 Aug 2023 22:59:25 -0700
From:   Xin Li <xin3.li@intel.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        chao.gao@intel.com, hpa@zytor.com, xiaoyao.li@intel.com,
        weijiang.yang@intel.com
Subject: [PATCH 1/4] target/i386: add support for FRED in CPUID enumeration
Date:   Thu, 31 Aug 2023 22:30:19 -0700
Message-Id: <20230901053022.18672-2-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230901053022.18672-1-xin3.li@intel.com>
References: <20230901053022.18672-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FRED, i.e., the Intel flexible return and event delivery architecture,
defines simple new transitions that change privilege level (ring
transitions).

In addition to these transitions, the FRED architecture defines a new
instruction (LKGS) for managing the state of the GS segment register.
The LKGS instruction can be used by 64-bit operating systems that do
not use the new FRED transitions.

The CPUID feature flag CPUID.(EAX=7,ECX=1):EAX[17] enumerates FRED, and
the CPUID feature flag CPUID.(EAX=7,ECX=1):EAX[18] enumerates LKGS.

Add CPUID definitions for FRED/LKGS, and expose them to KVM guests only.

Because FRED relies on LKGS, add it to feature dependency map.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 target/i386/cpu.c | 6 +++++-
 target/i386/cpu.h | 4 ++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 00f913b638..3dba6b46d9 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -963,7 +963,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "avx-vnni", "avx512-bf16", NULL, "cmpccxadd",
             NULL, NULL, "fzrm", "fsrs",
             "fsrc", NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
+            NULL, "fred", "lkgs", NULL,
             NULL, "amx-fp16", NULL, "avx-ifma",
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
@@ -1549,6 +1549,10 @@ static FeatureDep feature_dependencies[] = {
         .from = { FEAT_VMX_SECONDARY_CTLS,  VMX_SECONDARY_EXEC_ENABLE_USER_WAIT_PAUSE },
         .to = { FEAT_7_0_ECX,               CPUID_7_0_ECX_WAITPKG },
     },
+    {
+        .from = { FEAT_7_1_EAX,             CPUID_7_1_EAX_LKGS },
+        .to = { FEAT_7_1_EAX,               CPUID_7_1_EAX_FRED },
+    },
 };
 
 typedef struct X86RegisterInfo32 {
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index a6000e93bd..064decbc85 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -932,6 +932,10 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_7_1_EDX_AVX_NE_CONVERT    (1U << 5)
 /* PREFETCHIT0/1 Instructions */
 #define CPUID_7_1_EDX_PREFETCHITI       (1U << 14)
+/* Flexible return and event delivery (FRED) */
+#define CPUID_7_1_EAX_FRED              (1U << 17)
+/* Load into IA32_KERNEL_GS_BASE (LKGS) */
+#define CPUID_7_1_EAX_LKGS              (1U << 18)
 
 /* Do not exhibit MXCSR Configuration Dependent Timing (MCDT) behavior */
 #define CPUID_7_2_EDX_MCDT_NO           (1U << 5)
-- 
2.34.1

