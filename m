Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78A461747C
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiKCCv4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbiKCCvZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:51:25 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CC715721;
        Wed,  2 Nov 2022 19:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667443865; x=1698979865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QZah9F13AjoVe9tv/CykWOC6OrnYXLMSXtZoIq5C0N0=;
  b=VPshaeWWC+w/wq2XqKqj43wHvKnGfJWlDgNRNLywEZjOf5JlkTscNPmC
   fqmbsuBHuyRMyQUQ0ekf63Iiv0r9Lv6tQjKvDSob/4KYUM0/EXg2k0BRa
   GBul/rjhP3vGk8afERl3pkiqV9GPR/aLdfWpmwNFk/WvsqREvZAUi8haX
   4EDc7q0Sn6POS3ahaUY0VEduU0qvsiRV4K4RfSk4AugPJHtTS2Xr3eaGy
   /HckDOTdu/ztIpzNKKMNbhCEJKCYn4n0CmV5u0a0simbPhAfYlUvmtYbi
   NG5tu/GttnCvE0Y895bC1KpWVTM24EQIeWfjydLPFGUrtcIivxmzRzp3I
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="307186654"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="307186654"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:51:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="698047919"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="698047919"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2022 19:51:00 -0700
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
Subject: [PATCH v2 6/8] x86: KVM: Advertise AVX-VNNI-INT8 CPUID to user space
Date:   Thu,  3 Nov 2022 10:50:28 +0800
Message-Id: <20221103025030.78371-7-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
References: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

