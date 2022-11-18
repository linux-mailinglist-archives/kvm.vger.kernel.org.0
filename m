Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D857762F6F9
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 15:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242280AbiKROPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 09:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242278AbiKROP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 09:15:28 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D16FAC5;
        Fri, 18 Nov 2022 06:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668780923; x=1700316923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QoJokPLTFXjsYrc+DOubFMFw2lxiEOQBtYJNpzvRAXw=;
  b=B97gtDVra3gOB3XMRgCrOwaW7ZvKuNwfX1+OTgWt9I7bLZ3RMvxE24/V
   3y2ZoILGO3b/wmLAXLYpAG+fuwsZMKhOIAbsAkdajFJv+m+8N5OurfdMw
   CvDjZ1q5wrjknXBCitbMsnmmZf/u9XT4gTnp77sFFKLi1hToRdJ8oHGJI
   B6LdgkBg56UcXTv2fJRMXPU8HKdkf4gXH6N3xsqPa/6NWnogbi+EuCQrf
   kkNL2xbe/ro7+xCiC6COwY6tEgkRVYS91SVuiQf1bm3pwsRoxL93KGFoL
   Vw7C7P4EBuCUYS8PrxdwTsHif1FRMP2YZbptcEWdCxVkzUacCLjOhPNbS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="314292428"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="314292428"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 06:15:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="673204453"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="673204453"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga001.jf.intel.com with ESMTP; 18 Nov 2022 06:15:17 -0800
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
Subject: [PATCH v4 3/6] x86: KVM: Advertise AVX-IFMA CPUID to user space
Date:   Fri, 18 Nov 2022 22:15:06 +0800
Message-Id: <20221118141509.489359-4-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVX-IFMA is a new instruction in the latest Intel platform Sierra
Forest. This instruction packed multiplies unsigned 52-bit integers and
adds the low/high 52-bit products to Qword Accumulators.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[bit 23]

This CPUID is exposed to user space. Besides, there is no other VMX
control for this instruction.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index df4a7f7505a9..159f8b9898bf 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -310,6 +310,7 @@
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
 #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* AMX fp16 Support */
+#define X86_FEATURE_AVX_IFMA            (12*32+23) /* Support for VPMADD52[H,L]UQ */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2a334d4cd04e..5726afb2d14c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -657,8 +657,8 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
-	);
+		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
+		F(AVX_IFMA));
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
-- 
2.27.0

