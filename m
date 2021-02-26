Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51804325B78
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 03:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhBZCKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 21:10:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:38815 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhBZCKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 21:10:40 -0500
IronPort-SDR: nmv1+Q10UMgi96fmVub3EZcwpZwqhuvBkBtkIOeIYE/+unUFViVzxkwSOWjrWGIr8tJTEE/jua
 VMrM8zlg/wEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185801057"
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="185801057"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2021 18:09:40 -0800
IronPort-SDR: wStmTtDX93fdampCzql84sre2j4URVf8d/sD4BMi2z7RCR0l6gO3bB84MWA3sTVRSV0/SDqp3v
 if4FVIWtiHRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="404680191"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 25 Feb 2021 18:09:37 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, richard.henderson@linaro.org,
        ehabkost@redhat.com, mtosatti@redhat.com,
        sean.j.christopherson@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 6/6] target/i386: Advise CET bits in CPU/MSR feature words
Date:   Fri, 26 Feb 2021 10:20:58 +0800
Message-Id: <20210226022058.24562-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210226022058.24562-1-weijiang.yang@intel.com>
References: <20210226022058.24562-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET SHSTK and IBT feature are enumerated via CPUID.(EAX=07H,ECX=0H):ECX[bit 7]
and EDX[bit 20]. CET state load/restore at vmentry/vmexit are enabled via
VMX_ENTRY_CTLS[bit 20] and VMX_EXIT_CTLS[bit 28].

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ef786b920e..d1dcc7210d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -954,7 +954,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
             NULL, "avx512vbmi", "umip", "pku",
-            NULL /* ospke */, "waitpkg", "avx512vbmi2", NULL,
+            NULL /* ospke */, "waitpkg", "avx512vbmi2", "shstk",
             "gfni", "vaes", "vpclmulqdq", "avx512vnni",
             "avx512bitalg", NULL, "avx512-vpopcntdq", NULL,
             "la57", NULL, NULL, NULL,
@@ -977,7 +977,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "avx512-vp2intersect", NULL, "md-clear", NULL,
             NULL, NULL, "serialize", NULL,
             "tsx-ldtrk", NULL, NULL /* pconfig */, NULL,
-            NULL, NULL, NULL, NULL,
+            "ibt", NULL, NULL, NULL,
             NULL, NULL, "spec-ctrl", "stibp",
             NULL, "arch-capabilities", "core-capability", "ssbd",
         },
@@ -1239,7 +1239,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "vmx-exit-save-efer", "vmx-exit-load-efer",
                 "vmx-exit-save-preemption-timer", "vmx-exit-clear-bndcfgs",
             NULL, "vmx-exit-clear-rtit-ctl", NULL, NULL,
-            NULL, NULL, NULL, NULL,
+            "vmx-exit-save-cet-ctl", NULL, NULL, NULL,
         },
         .msr = {
             .index = MSR_IA32_VMX_TRUE_EXIT_CTLS,
@@ -1254,7 +1254,7 @@ static FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, "vmx-entry-ia32e-mode", NULL, NULL,
             NULL, "vmx-entry-load-perf-global-ctrl", "vmx-entry-load-pat", "vmx-entry-load-efer",
             "vmx-entry-load-bndcfgs", NULL, "vmx-entry-load-rtit-ctl", NULL,
-            NULL, NULL, NULL, NULL,
+            "vmx-entry-load-cet-ctl", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
         },
-- 
2.26.2

