Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277D0646919
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 07:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiLHGZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 01:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLHGZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 01:25:30 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36189E459
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 22:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670480729; x=1702016729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fOmR1JCdiaffCYVDbb1S5VJR9D6xo/R7Jt4fOToUMvU=;
  b=HEtKk9vUjHbx8/tvkS6YIoo2sdqtEumedfoS3jF6YiQJMi2nVOB0P8zu
   WHI6Ws1vjpDDAI3NiuyjJmurh3ZK6Sg0we2pzo7EZcBhvj6xnNi4kAoVG
   vc0Y1BeKA9aNbjUeqeF6BBoX9TljLtHHTDKFDTG+V2wV9pBrKWUrzdTqQ
   Q04V5GE8HS7fdyqrLKmKvlWQ75VYXUUKJ3HuQNZq5MXl+VWAD/bhp2F06
   S3+fpMSqRDwMTaIAQw5UtBxH69Kose5KTdZ+x3NPdFdhoQfsUqjciyrpY
   sgMB8BDQFkOtUkrU/GwYSxUA5oWQkf6YtgkygUrYx2K9yzur8pB8+Aplq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="297444505"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="297444505"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 22:25:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="679413433"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="679413433"
Received: from lxy-dell.sh.intel.com ([10.239.48.100])
  by orsmga001.jf.intel.com with ESMTP; 07 Dec 2022 22:25:26 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com
Subject: [PATCH v3 7/8] target/i386/intel-pt: Define specific PT feature set for IceLake-server and Snowridge
Date:   Thu,  8 Dec 2022 14:25:12 +0800
Message-Id: <20221208062513.2589476-8-xiaoyao.li@intel.com>
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

For IceLake-server, it's just the same as using the default PT
feature set since the default one is exact taken from ICX.

For Snowridge, define it according to real SNR silicon capabilities.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 24f3c7b06698..ef574c819671 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -3458,6 +3458,14 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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
@@ -3735,6 +3743,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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
2.27.0

