Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB5162F6FE
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 15:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242320AbiKROQE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 09:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242318AbiKROPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 09:15:44 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058BB8D49C;
        Fri, 18 Nov 2022 06:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668780934; x=1700316934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E78mPBT56iuZpMseRQ2hY1+suXL8PzPfFDv7KOMJuwA=;
  b=O6ISyipG24t9cFbPEoJNSQ/tUaFlPrsik+PN9w3Q9371uWngHEtFDLbI
   3fqljmvH7K3iodoVSUVl7Wsv+J42v66G+/ppgsjXInSuTrBOdHi0fOlch
   lefog+kJwn9qvmHPZnJxiQsKLlG4xm6VrsrI/JJnqVzl3jxPYss/cHqvX
   B6PbGEnU2lOTIQ+xDHEfJ+2EmeszKjRXxuIbZRCjONMr8sF2BF0KAAx/8
   /7OuB8gNsAlPzQk59h+mibniigLDZRsa+Ogi5eyCshu/GbZn2MR0HhQmy
   xYQzcA5m7pd7d/K4m+2NywEjiSnu9deKZHhK6LO5AsLxBay+sLf+ylLAo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="311845191"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="311845191"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 06:15:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="673204483"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="673204483"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga001.jf.intel.com with ESMTP; 18 Nov 2022 06:15:28 -0800
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
Subject: [PATCH v4 5/6] x86: KVM: Advertise AVX-NE-CONVERT CPUID to user space
Date:   Fri, 18 Nov 2022 22:15:08 +0800
Message-Id: <20221118141509.489359-6-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
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
index e2b8e5485474..f87292ae69d2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -661,7 +661,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX_IFMA));
 
 	kvm_cpu_cap_init_scattered(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8));
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT)
+	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 8357480b75d6..d0fc43c3b2fd 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -27,6 +27,7 @@ enum kvm_only_cpuid_leafs {
 
 /* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
 #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
+#define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
 
 struct cpuid_reg {
 	u32 function;
-- 
2.27.0

