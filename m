Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8604B8367
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 09:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiBPIyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 03:54:24 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbiBPIyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 03:54:21 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6240A2ABD1B
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 00:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645001649; x=1676537649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QzBCP5M4wMF4q22jDeU36YFp1BmxRx/56eXR+XroOIE=;
  b=O27PsFqudNa+aJLyq00T6c+9KoWuKS30fi37vrVFOlSaWdLfeSh+o02L
   sXNylQ7va+BTb4mEnsgf+3wFHEvtIozFkezaBHZzR9kbAW7RhJ2mzg8wW
   IS04JwF7u4jSUVZPGhft1a9FtiuE71ElO49aMDTRdo5sy0rdRnUjRXa7V
   WGZjQr+9tRIhUWrEbr5S6CyPKU/yROZIp5hJQZXr2qj30c0q7Nl6mVEaA
   We6PUjVi/lY+qMMbKgdMlypvzq3X+go0yfK6LjEEbzDAAyZjYa4hpSMFj
   slPwoRXN6B1cZJCeXH5aZQt9t4PVCfxh8ukbv+dKQoXfdY7DvCIhZqJnp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="275135819"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="275135819"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:08 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="633418296"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 00:54:07 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        like.xu.linux@gmail.com, wei.w.wang@intel.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH 8/8] target/i386: Support Arch LBR in CPUID enumeration
Date:   Tue, 15 Feb 2022 14:52:58 -0500
Message-Id: <20220215195258.29149-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215195258.29149-1-weijiang.yang@intel.com>
References: <20220215195258.29149-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If CPUID.(EAX=07H, ECX=0):EDX[19] is set to 1, the processor
supports Architectural LBRs. In this case, CPUID leaf 01CH
indicates details of the Architectural LBRs capabilities.
XSAVE support for Architectural LBRs is enumerated in
CPUID.(EAX=0DH, ECX=0FH).

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 target/i386/cpu.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e505c926b2..1092618683 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -858,7 +858,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "fsrm", NULL, NULL, NULL,
             "avx512-vp2intersect", NULL, "md-clear", NULL,
             NULL, NULL, "serialize", NULL,
-            "tsx-ldtrk", NULL, NULL /* pconfig */, NULL,
+            "tsx-ldtrk", NULL, NULL /* pconfig */, "arch-lbr",
             NULL, NULL, "amx-bf16", "avx512-fp16",
             "amx-tile", "amx-int8", "spec-ctrl", "stibp",
             NULL, "arch-capabilities", "core-capability", "ssbd",
@@ -5494,6 +5494,12 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         assert(!(*eax & ~0x1f));
         *ebx &= 0xffff; /* The count doesn't need to be reliable. */
         break;
+    case 0x1C:
+        *eax = kvm_arch_get_supported_cpuid(cs->kvm_state, 0x1C, 0, R_EAX);
+        *ebx = kvm_arch_get_supported_cpuid(cs->kvm_state, 0x1C, 0, R_EBX);
+        *ecx = kvm_arch_get_supported_cpuid(cs->kvm_state, 0x1C, 0, R_ECX);
+        *edx = 0;
+        break;
     case 0x1F:
         /* V2 Extended Topology Enumeration Leaf */
         if (env->nr_dies < 2) {
@@ -5556,6 +5562,19 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *ebx = xsave_area_size(xstate, true);
             *ecx = env->features[FEAT_XSAVE_XSS_LO];
             *edx = env->features[FEAT_XSAVE_XSS_HI];
+            if (kvm_enabled() && cpu->enable_pmu &&
+                (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR) &&
+                (*eax & CPUID_XSAVE_XSAVES)) {
+                *ecx |= XSTATE_ARCH_LBR_MASK;
+            } else {
+                *ecx &= ~XSTATE_ARCH_LBR_MASK;
+            }
+        } else if (count == 0xf && kvm_enabled() && cpu->enable_pmu &&
+                   (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
+            *eax = kvm_arch_get_supported_cpuid(cs->kvm_state, 0xD, 0xf, R_EAX);
+            *ebx = kvm_arch_get_supported_cpuid(cs->kvm_state, 0xD, 0xf, R_EBX);
+            *ecx = kvm_arch_get_supported_cpuid(cs->kvm_state, 0xD, 0xf, R_ECX);
+            *edx = kvm_arch_get_supported_cpuid(cs->kvm_state, 0xD, 0xf, R_EDX);
         } else if (count < ARRAY_SIZE(x86_ext_save_areas)) {
             const ExtSaveArea *esa = &x86_ext_save_areas[count];
 
-- 
2.27.0

