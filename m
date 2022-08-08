Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3D258C531
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 10:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241997AbiHHI67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 04:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242060AbiHHI6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 04:58:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1333E13F29
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 01:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659949126; x=1691485126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wi9mA7FfWCBhNKiC15z6es1zHAIF8vhybReqyecYHNM=;
  b=Y/tVHQRaC0hFe7qjfIr45uUyKk6RROw+6hd7w1IM31G3+LH1eLpFbEnm
   SgYWP0SSEKJfutPTaqfU0xGZ5KUPq6RjubmT30eyrQYexVNp3Rb8Q2KUK
   O9nH1Rq1dBV0k9S0D6jHID1kr7n40IDwjg06qjqDPiCplahi4GImPvfAj
   fiu4VlVoFrRW8YnQF5jFRUfrqS2bhY6P/Qa21+0OY78SqSACiOpeX5dO3
   v1WyyiTJ8UNjUxXTEsmjwc8soi92vKGwE6QrtaZ/WaBaAhvaP4h12BZSv
   MyIcjdvrzlXcQuMyKDPb3IY3qU74rPbmHJRbZk3xtr4JYgTxh2hGJiMkn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="376835076"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="376835076"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2022 01:58:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="931970621"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 08 Aug 2022 01:58:44 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v2 7/8] target/i386/intel-pt: Define specific PT feature set for IceLake-server and Snowridge
Date:   Mon,  8 Aug 2022 16:58:33 +0800
Message-Id: <20220808085834.3227541-8-xiaoyao.li@intel.com>
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

For IceLake-server, it's just the same as using the default PT
feature set since the default one is exact taken from ICX.

For Snowridge, define it according to real SNR silicon capabilities.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2664b527b8e8..3fc5305aa9dd 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -3456,6 +3456,14 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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
@@ -3733,6 +3741,16 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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

