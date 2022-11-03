Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB8E61747E
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiKCCwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiKCCvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:51:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B8F16585;
        Wed,  2 Nov 2022 19:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667443871; x=1698979871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z3o7gjqmPQSafhqSVWDWNYduM/0WLm1c0YsgTUqZbj8=;
  b=OxvPh9f9UgtEKHIgGYdQJNUGNlWVXtIRz0HsUhjg3XwusXPIqx2ATPp/
   BlL/BMU6yWimZOLm95L9rmAbOdGppDWXHhtcmMP99pGt3n42kMj9fDpJd
   c9sl4JDSW2N1LSt1n7xE9UWO2ErnmpV1h3xgk1XPWUPZdlB3OBag8EiPg
   yTACcoObMSK9p0cFGj9TLQeOp3K5u3LrqXFWNRHhO2tea0fE11P5jZudx
   iSfbTmMTRIoZCbyBX9DB6B16GplzT/Yem/9kvgSfbA0i+kBIpXJjVUzMp
   YmazmjBwFbXGyETaK9T/JROrke1JPcP4uaLKPVbf+RgXSLFjUPeKDYcDT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="289282952"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="289282952"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:51:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="698047930"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="698047930"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2022 19:51:05 -0700
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
Subject: [PATCH v2 7/8] x86: KVM: Advertise AVX-NE-CONVERT CPUID to user space
Date:   Thu,  3 Nov 2022 10:50:29 +0800
Message-Id: <20221103025030.78371-8-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
References: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVX-NE-CONVERT is a new set of instructions which can convert low
precision floating point like BF16/FP16 to high precision floating point
FP32, and can also convert FP32 elements to BF16. This instruction
allows the platform to have improved AI capabilities and better
compatibility.

The bit definition:
CPUID.(EAX=7,ECX=1):EDX[bit 5]

This CPUID is exposed to user space. Besides, there is no other VMX
control for this instruction.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/kvm/cpuid.c         | 3 ++-
 arch/x86/kvm/reverse_cpuid.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 06dacf71ff9c..47ac2a502d91 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -662,7 +662,8 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init_scattered(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8));
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT)
+	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 819b4e0b13a3..b8addd85b062 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -35,6 +35,7 @@ enum kvm_only_cpuid_leafs {
 
 /* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
 #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
+#define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
 
 struct cpuid_reg {
 	u32 function;
-- 
2.27.0

