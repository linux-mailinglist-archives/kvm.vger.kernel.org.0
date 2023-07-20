Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C187F75B114
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 16:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjGTOT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 10:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjGTOTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 10:19:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9235212C
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689862789; x=1721398789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eVQGxE7pHqQn9+y3PH0QlsM6Gp1yGX9TVxrLxXPWuZ0=;
  b=adCl+PBPmcT3l47EANdXh5cGthRJM9KmTLL/fef8g2tepdCTuIvZQkk8
   onm4C0z4fjArsoMEV3+IwFk53ajyVXRYEuA96sQ/xU2Sw1bRoJ/nlxS7O
   l1BWGqzmM6G/v26mE78iI+1RUpoGpJaiNiGB/kdYiAcIwrjianhppbI/M
   bedetCkbREbM8vdJv0O66kK++ggKF5ego7eyWj5Vcgo4vkAIUikSGig58
   NqzbailO3j4s23Tsh8Jw0wDTFA3dJnb5KR/8ZJRLQOxRkG+WC7yAqriAC
   cA2kD26RL3FuHrJd0qovROz+lBGFndHYxUWqQ41Yxs5C7VR0s5VFIrRQy
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="397629180"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="397629180"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:19:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="898295627"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="898295627"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 07:19:29 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, weijiang.yang@intel.com
Subject: [PATCH v2 4/4] target/i386: Advertise CET related flags in feature words
Date:   Thu, 20 Jul 2023 07:14:45 -0400
Message-Id: <20230720111445.99509-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230720111445.99509-1-weijiang.yang@intel.com>
References: <20230720111445.99509-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add SHSTK and IBT flags in feature words with entry/exit
control flags.

CET SHSTK and IBT feature are enumerated via CPUID(EAX=7,ECX=0)
ECX[bit 7] and EDX[bit 20]. CET states load/restore at vmentry/
vmexit are controlled by VMX_ENTRY_CTLS[bit 20] and VMX_EXIT_CTLS[bit 28].
Enable these flags so that KVM can enumerate the features properly.

CET feature is only available on platforms with IA32_VMX_BASIC[bit 56]
set, otherwise, CET features are disabled in KVM.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ea11b589e3..79a90e35bf 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -835,7 +835,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
             NULL, "avx512vbmi", "umip", "pku",
-            NULL /* ospke */, "waitpkg", "avx512vbmi2", NULL,
+            NULL /* ospke */, "waitpkg", "avx512vbmi2", "shstk",
             "gfni", "vaes", "vpclmulqdq", "avx512vnni",
             "avx512bitalg", NULL, "avx512-vpopcntdq", NULL,
             "la57", NULL, NULL, NULL,
@@ -858,7 +858,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "avx512-vp2intersect", NULL, "md-clear", NULL,
             NULL, NULL, "serialize", NULL,
             "tsx-ldtrk", NULL, NULL /* pconfig */, "arch-lbr",
-            NULL, NULL, "amx-bf16", "avx512-fp16",
+            "ibt", NULL, "amx-bf16", "avx512-fp16",
             "amx-tile", "amx-int8", "spec-ctrl", "stibp",
             NULL, "arch-capabilities", "core-capability", "ssbd",
         },
@@ -1120,7 +1120,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "vmx-exit-save-efer", "vmx-exit-load-efer",
                 "vmx-exit-save-preemption-timer", "vmx-exit-clear-bndcfgs",
             NULL, "vmx-exit-clear-rtit-ctl", NULL, NULL,
-            NULL, "vmx-exit-load-pkrs", NULL, NULL,
+            "vmx-exit-save-cet-ctl", "vmx-exit-load-pkrs", NULL, NULL,
         },
         .msr = {
             .index = MSR_IA32_VMX_TRUE_EXIT_CTLS,
@@ -1135,7 +1135,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, "vmx-entry-ia32e-mode", NULL, NULL,
             NULL, "vmx-entry-load-perf-global-ctrl", "vmx-entry-load-pat", "vmx-entry-load-efer",
             "vmx-entry-load-bndcfgs", NULL, "vmx-entry-load-rtit-ctl", NULL,
-            NULL, NULL, "vmx-entry-load-pkrs", NULL,
+            "vmx-entry-load-cet-ctl", NULL, "vmx-entry-load-pkrs", NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
         },
@@ -1192,6 +1192,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .feat_names = {
             [54] = "vmx-ins-outs",
             [55] = "vmx-true-ctls",
+            [56] = "vmx-hw-no-errcode",
         },
         .msr = {
             .index = MSR_IA32_VMX_BASIC,
-- 
2.27.0

