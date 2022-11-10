Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946D162394D
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiKJBys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbiKJByn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:54:43 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941E410561;
        Wed,  9 Nov 2022 17:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668045280; x=1699581280;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QZah9F13AjoVe9tv/CykWOC6OrnYXLMSXtZoIq5C0N0=;
  b=UD1ZT3Cf1XXKoxzRzWj0xcu9uCPZPM46qHKKY+QP7lAIDXzyY0q2eCKy
   YFZ5kTzFqti+hn2KlhId9tkTL0+G/spB2g7NYSiOCB8wvH/rP5VqXb1d5
   Ik0CIb6giZN1n+KulWpyzvA5xoCS3a1dcvM/+gaMWHBLaAKwjB/N+nxlr
   6QQmFAsGWSMEAG//1Dl36brdnPvNLq8wvV1V1Wj2syA3zqB9LjHKf2lLc
   4IlOM9BBeqe1xfuyPEQa4gtSmrK6S/G3/kjUeYVGJg6ZWi0qirumpjTq0
   RPOLF+h8ao8nk/DnlUNE+K5LT1wk7CtWoYMMuwrrCohbVftKEHT+nC/+9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="308803616"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="308803616"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 17:53:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="762100061"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="762100061"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga004.jf.intel.com with ESMTP; 09 Nov 2022 17:53:18 -0800
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/7] x86: KVM: Advertise AVX-VNNI-INT8 CPUID to user space
Date:   Thu, 10 Nov 2022 09:52:50 +0800
Message-Id: <20221110015252.202566-6-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
References: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVX-VNNI-INT8 is a new set of instructions in the latest Intel platform
Sierra Forest, aims for the platform to have superior AI capabilities.
This instruction multiplies the individual bytes of two unsigned or
unsigned source operands, then adds and accumulates the results into the
destination dword element size operand.

The bit definition:
CPUID.(EAX=7,ECX=1):EDX[bit 4]

This CPUID is exposed to user space. Besides, there is no other VMX
control for this instruction.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/kvm/cpuid.c         | 5 ++++-
 arch/x86/kvm/reverse_cpuid.h | 5 +++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e84c6216a72c..06dacf71ff9c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -661,6 +661,9 @@ void kvm_set_cpu_caps(void)
 		F(AVX_IFMA)
 	);
 
+	kvm_cpu_cap_init_scattered(CPUID_7_1_EDX,
+		F(AVX_VNNI_INT8));
+
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
 	);
@@ -914,9 +917,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 
 			cpuid_entry_override(entry, CPUID_7_1_EAX);
+			cpuid_entry_override(entry, CPUID_7_1_EDX);
 			entry->ebx = 0;
 			entry->ecx = 0;
-			entry->edx = 0;
 		}
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 954c0ceb1e90..819b4e0b13a3 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -14,6 +14,7 @@
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
 	CPUID_7_1_EAX,
+	CPUID_7_1_EDX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -32,6 +33,9 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AMX_FP16            KVM_X86_FEATURE(CPUID_7_1_EAX, 21)
 #define X86_FEATURE_AVX_IFMA            KVM_X86_FEATURE(CPUID_7_1_EAX, 23)
 
+/* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
+#define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -56,6 +60,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
 };
 
 /*
-- 
2.27.0

