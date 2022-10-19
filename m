Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14851603CDA
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 10:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiJSIxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 04:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiJSIwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 04:52:35 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1D51FCF4;
        Wed, 19 Oct 2022 01:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666169409; x=1697705409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yv4TuyK9cOpIJfyoOHskJ3JXY6oP4TpsI2dJ99hsGpM=;
  b=JJPLHN/RVD4iBpNRXI3ZnL1s6qd48JShNX/bpebI1Lp6iCH8T79EUqxj
   oZefYIjBqB6+cD7g0ykzLJzuu+HHdFS0gqHl9QGiMvRAjwVS6nQzesH2D
   Cr3QY51wIXITnmZh6K22ZXRuZ0hA+3u+ErhCvi7ZKYi2fohBuBe1//Z7R
   r47x4j4hHqGrawASFzxT90BtHFfP/LsJLFhQKGrhZs37dPdVicDqfotbJ
   TLvKrlkcUyPOGn+OBcZCzqVbivrLBBna1JWFTVc12Q6+tAIAKrIpjAVpv
   46cYUdB/wvlGHutwf50iHr4ssSHOXfaqUZtvTxrOBRBA4EMZBDOgyS5Cq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="307456596"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="307456596"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 01:47:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="804195881"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="804195881"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga005.jf.intel.com with ESMTP; 19 Oct 2022 01:47:45 -0700
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jiaxi.chen@linux.intel.com, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org,
        jane.malalane@citrix.com, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] x86: KVM: Enable AMX-FP16 CPUID and expose it to guest
Date:   Wed, 19 Oct 2022 16:47:30 +0800
Message-Id: <20221019084734.3590760-3-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Chang S. Bae" <chang.seok.bae@intel.com>

Latest Intel platform Granite Rapids has introduced a new instruction -
AMX-FP16, which performs dot-products of two FP16 tiles and accumulates
the results into a packed single precision tile. This instruction adds
FP16 capability and also allows a FP16 GPU trained model to run faster
without loss of accuracy or added SW overhead.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[bit 21]

This patch enables this CPUID in the kernel feature bits and expose it
to guest OS.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 445626cb5779..9313240e3cdd 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -309,6 +309,7 @@
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
 #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* CMPccXADD instructions */
+#define X86_FEATURE_AMX_FP16		(12*32+21) /* AMX fp16 Support */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3f745f6fdc43..d983ddb974ba 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -657,7 +657,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-- 
2.27.0

