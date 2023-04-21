Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668836EA473
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 09:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjDUHQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 03:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjDUHQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 03:16:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6F5173D
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 00:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682061413; x=1713597413;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Gw9MANvnPGo+NUbmsWsIghJonaNlSR49MNlqyyD1Gn0=;
  b=X/85afgv8XvUP9BX9ecdldyzNKH0BzP1e6fcg7hL/yg5GZ9uWlVhHv5D
   gg7Czri8wFfyWpAcOw+k05oGAU2lZT0BO91WniBvvmEfvKc8V0IT+X99O
   BEvDaXTaP/abSMw9qJ20d/NEFFDlhGoPOwmMOAeED3ZaxMKbEju8fvKKK
   ycAbdj9RnJQD7i8kp7F+VsYUYprK7qWkdbvPHWTfp9HIQ0dpYZ0Xoxd1Z
   G3wDurGk83IsD4WpJ69d7vOhZfeVE2UGJYzKhoxG8V8zX96wFhd74jsbD
   /3VByNF//tWSckxNrb+6BlGapNCKd0E+yyjwk5cluvLPMJZRDaY5glJqr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="326260541"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="326260541"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="938385331"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="938385331"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 00:16:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, mtosatti@redhat.com, seanjc@google.com,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, weijiang.yang@intel.com
Subject: [PATCH 4/4] target/i386: Advertise CET flags in feature words
Date:   Fri, 21 Apr 2023 00:12:27 -0400
Message-Id: <20230421041227.90915-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421041227.90915-1-weijiang.yang@intel.com>
References: <20230421041227.90915-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add SHSTK and IBT flags in feature words alone with entry/exit
control flags.

CET SHSTK and IBT feature are enumerated via CPUID(EAX=7,ECX=0)
ECX[bit 7] and EDX[bit 20]. CET states load/restore at vmentry/
vmexit are controlled by VMX_ENTRY_CTLS[bit 20] and VMX_EXIT_CTLS[bit 28].
Enable these flags so that KVM can support the features properly.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index be86df8c1d..f11c5ce86c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -834,7 +834,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
             NULL, "avx512vbmi", "umip", "pku",
-            NULL /* ospke */, "waitpkg", "avx512vbmi2", NULL,
+            NULL /* ospke */, "waitpkg", "avx512vbmi2", "shstk",
             "gfni", "vaes", "vpclmulqdq", "avx512vnni",
             "avx512bitalg", NULL, "avx512-vpopcntdq", NULL,
             "la57", NULL, NULL, NULL,
@@ -857,7 +857,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "avx512-vp2intersect", NULL, "md-clear", NULL,
             NULL, NULL, "serialize", NULL,
             "tsx-ldtrk", NULL, NULL /* pconfig */, "arch-lbr",
-            NULL, NULL, "amx-bf16", "avx512-fp16",
+            "ibt", NULL, "amx-bf16", "avx512-fp16",
             "amx-tile", "amx-int8", "spec-ctrl", "stibp",
             NULL, "arch-capabilities", "core-capability", "ssbd",
         },
@@ -1119,7 +1119,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "vmx-exit-save-efer", "vmx-exit-load-efer",
                 "vmx-exit-save-preemption-timer", "vmx-exit-clear-bndcfgs",
             NULL, "vmx-exit-clear-rtit-ctl", NULL, NULL,
-            NULL, "vmx-exit-load-pkrs", NULL, NULL,
+            "vmx-exit-save-cet-ctl", "vmx-exit-load-pkrs", NULL, NULL,
         },
         .msr = {
             .index = MSR_IA32_VMX_TRUE_EXIT_CTLS,
@@ -1134,7 +1134,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, "vmx-entry-ia32e-mode", NULL, NULL,
             NULL, "vmx-entry-load-perf-global-ctrl", "vmx-entry-load-pat", "vmx-entry-load-efer",
             "vmx-entry-load-bndcfgs", NULL, "vmx-entry-load-rtit-ctl", NULL,
-            NULL, NULL, "vmx-entry-load-pkrs", NULL,
+            "vmx-entry-load-cet-ctl", NULL, "vmx-entry-load-pkrs", NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
         },
-- 
2.27.0

