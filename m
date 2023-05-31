Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC53717A66
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 10:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbjEaIoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 04:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbjEaIoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 04:44:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1287218B
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 01:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685522621; x=1717058621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=peLHOea+vLgXw1wTEoUDkKyMN9jSNL+bEhw7hF1VivU=;
  b=cIwhmoMh/EHCLl2q8hygv82D9aNoeAHqi0XLJty3pw7XB6D8led1SheT
   H60QPe9r8N1lqbNFnfbKOmfx2p6NiJzIVtOthp6/tTZZ3tFFFGmWBZ7gg
   1d9CuAUcgRhykKFW8vNs+FhcdCPhRA8BE58/yiqjvN73tafAsXRrGzr6C
   SoXg5hdR3hyD5aK6s2Hs+N6zcGXHKzcokgx2yXcd2GLf00ayRM9lEaxv4
   hM40t5MXW30Wq0I6rSaQdLtBi+zxs8ZLIOjyvmwK/Bm4J7jcPJHwvMEXW
   ZWg4PjHYBHY4RjnZdGEN10vsRYgR48d2a0RK3PAjevQIRJ9rJosSXk+P6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418669305"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="418669305"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 01:43:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="1036956478"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="1036956478"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga005.fm.intel.com with ESMTP; 31 May 2023 01:43:28 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>, lei4.wang@intel.com
Subject: [PATCH v4 7/8] target/i386/intel-pt: Define specific PT feature set for IceLake-server, Snowridge and SapphireRapids
Date:   Wed, 31 May 2023 04:43:10 -0400
Message-Id: <20230531084311.3807277-8-xiaoyao.li@intel.com>
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

For IceLake-server, it's just the same as using the default PT
feature set since the default one is exact taken from ICX.

For Snowridge and SapphireRapids, define it according to real silicon
capabilities.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
 - Add Intel PT capabilities for SapphireRapids cpu model;
---
 target/i386/cpu.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index e47629aff68e..182ba02e2fee 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -3699,6 +3699,14 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .features[FEAT_6_EAX] =
             CPUID_6_EAX_ARAT,
         /* Missing: Mode-based execute control (XS/XU), processor tracing, TSC scaling */
+        .features[FEAT_14_0_EBX] =
+            CPUID_14_0_EBX_CR3_FILTER | CPUID_14_0_EBX_PSB |
+            CPUID_14_0_EBX_IP_FILTER | CPUID_14_0_EBX_MTC,
+        .features[FEAT_14_0_ECX] =
+            CPUID_14_0_ECX_TOPA | CPUID_14_0_ECX_MULTI_ENTRIES |
+            CPUID_14_0_ECX_SINGLE_RANGE,
+        .features[FEAT_14_1_EAX] = 0x249 << 16 | 0x2,
+        .features[FEAT_14_1_EBX] = 0x003f << 16 | 0x1fff,
         .features[FEAT_VMX_BASIC] = MSR_VMX_BASIC_INS_OUTS |
              MSR_VMX_BASIC_TRUE_CTLS,
         .features[FEAT_VMX_ENTRY_CTLS] = VMX_VM_ENTRY_IA32E_MODE |
@@ -3869,6 +3877,15 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .features[FEAT_7_1_EAX] =
             CPUID_7_1_EAX_AVX_VNNI | CPUID_7_1_EAX_AVX512_BF16 |
             CPUID_7_1_EAX_FZRM | CPUID_7_1_EAX_FSRS | CPUID_7_1_EAX_FSRC,
+        .features[FEAT_14_0_EBX] =
+            CPUID_14_0_EBX_CR3_FILTER | CPUID_14_0_EBX_PSB |
+            CPUID_14_0_EBX_IP_FILTER | CPUID_14_0_EBX_MTC |
+	    CPUID_14_0_EBX_PTWRITE | CPUID_14_0_EBX_PSB_PMI_PRESERVATION,
+        .features[FEAT_14_0_ECX] =
+            CPUID_14_0_ECX_TOPA | CPUID_14_0_ECX_MULTI_ENTRIES |
+            CPUID_14_0_ECX_SINGLE_RANGE,
+        .features[FEAT_14_1_EAX] = 0x249 << 16 | 0x2,
+        .features[FEAT_14_1_EBX] = 0x003f << 16 | 0x3f,
         .features[FEAT_VMX_BASIC] =
             MSR_VMX_BASIC_INS_OUTS | MSR_VMX_BASIC_TRUE_CTLS,
         .features[FEAT_VMX_ENTRY_CTLS] =
@@ -4105,6 +4122,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             CPUID_XSAVE_XGETBV1,
         .features[FEAT_6_EAX] =
             CPUID_6_EAX_ARAT,
+        .features[FEAT_14_0_EBX] =
+            CPUID_14_0_EBX_CR3_FILTER | CPUID_14_0_EBX_PSB |
+            CPUID_14_0_EBX_IP_FILTER | CPUID_14_0_EBX_MTC |
+            CPUID_14_0_EBX_PTWRITE | CPUID_14_0_EBX_POWER_EVENT |
+            CPUID_14_0_EBX_PSB_PMI_PRESERVATION,
+        .features[FEAT_14_0_ECX] =
+            CPUID_14_0_ECX_TOPA | CPUID_14_0_ECX_MULTI_ENTRIES |
+            CPUID_14_0_ECX_SINGLE_RANGE | CPUID_14_0_ECX_LIP,
+        .features[FEAT_14_1_EAX] = 0x249 << 16 | 0x2,
+        .features[FEAT_14_1_EBX] = 0x003f << 16 | 0xffff,
         .features[FEAT_VMX_BASIC] = MSR_VMX_BASIC_INS_OUTS |
              MSR_VMX_BASIC_TRUE_CTLS,
         .features[FEAT_VMX_ENTRY_CTLS] = VMX_VM_ENTRY_IA32E_MODE |
-- 
2.34.1

