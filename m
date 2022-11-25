Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A3A638AB6
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiKYM7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiKYM7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:59:25 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B3431F97;
        Fri, 25 Nov 2022 04:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669381152; x=1700917152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jPQVnGMdqccMf+MxoNJO0uQw53INMkUJGNjpZ6qw38Q=;
  b=bwyIE4/aFXcXN2XztqMw2oGeq4Xk9wOagU8rgJanvk6OGzJ/OFdQXTKt
   a8NivG8lcygzhbil6QQvIKHmKBL+CIF0dSoSkvaSzI9+sgefuKhFxTw0Z
   cTtvey5Y4Yz9vOFtKt0finvtbCWrU4TVEZLpUthGGo6SemxKsTqS3GKSd
   340g59cAcWuCwFfH/8kREkp3KtC1fKFXVvX3mVaZPsghOe+2IBvQRlcR8
   qa16a0CcMAg79VYrYtG5i768cmgYN4+BkqNM6Y9wihjqHtP9wEowoxqnp
   XTXX3nSsLVGCV+kF2WvFDnuk4VIVPyBBvq1D6gqMbC0eZHkzw+iEyOaaa
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="376622357"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="376622357"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:59:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="706061313"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="706061313"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 25 Nov 2022 04:59:02 -0800
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
Subject: [PATCH v5 6/8] KVM: x86: Advertise AVX-VNNI-INT8 CPUID to user space
Date:   Fri, 25 Nov 2022 20:58:43 +0800
Message-Id: <20221125125845.1182922-7-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
References: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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

AVX-VNNI-INT8 is on a new and sparse CPUID leaf and all bits on this
leaf have no truly kernel use case for now. Given that and to save space
for kernel feature bits, move this new leaf to KVM-only subleaf and plus
an x86_FEATURE definition for AVX-VNNI-INT8 to direct it to the KVM
entry.

Advertise AVX-VNNI-INT8 to KVM userspace. This is safe because there are
no new VMX controls or additional host enabling required for guests to
use this feature.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/kvm/cpuid.c         | 6 +++++-
 arch/x86/kvm/reverse_cpuid.h | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8612cddd9838..2dfa8363b9d9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -667,6 +667,10 @@ void kvm_set_cpu_caps(void)
 		F(AVX_IFMA)
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
+		F(AVX_VNNI_INT8)
+	);
+
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
 	);
@@ -920,9 +924,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
index 443a6b3e66c0..84f56b662424 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_7_1_EDX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -36,6 +37,9 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 
+/* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
+#define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -60,6 +64,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
 };
 
 /*
-- 
2.27.0

