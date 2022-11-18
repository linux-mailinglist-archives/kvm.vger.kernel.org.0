Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3230562F6F7
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 15:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242270AbiKROPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 09:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242243AbiKROPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 09:15:18 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB6466C9C;
        Fri, 18 Nov 2022 06:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668780917; x=1700316917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7eAM8q8qML3zf4XzRteOiwU10raMhgqwldWA8Pl8eiY=;
  b=AauEr6fdbbzxO1R814EphrkuVhRUFarF4ryDwvHKQbCQt65rGTC8674X
   bRD9b2BcSuJkbhtLABoMPkp6qcxaNk81ocItYTLvdefLBi+GWPvQduH1F
   fR9ZFaz2e2mi3IAytHZtxpgA3bAFFTiqqYYYhTKgxvMM4ErmLchH79Ob8
   cv1ZEAoyalGnwjMdyEykO5cq3yvRRjZ2P+TTT0BKxNXqVi2qBfPjtm3Zz
   wkT6Mz+eltEj3o8g7clM+GJbrYalpSApE1/IHxZEZnIvP/W8gsyuF/lKu
   e1F1vg2bjrXsfjri3JxegCC+BYCviw6vOPe+gwI3TzXOucBjvsXdowomJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="375274252"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="375274252"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 06:15:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="673204445"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="673204445"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga001.jf.intel.com with ESMTP; 18 Nov 2022 06:15:11 -0800
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
Subject: [PATCH v4 2/6] x86: KVM: Advertise AMX-FP16 CPUID to user space
Date:   Fri, 18 Nov 2022 22:15:05 +0800
Message-Id: <20221118141509.489359-3-jiaxi.chen@linux.intel.com>
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

From: "Chang S. Bae" <chang.seok.bae@intel.com>

Latest Intel platform Granite Rapids has introduced a new instruction -
AMX-FP16, which performs dot-products of two FP16 tiles and accumulates
the results into a packed single precision tile. This instruction adds
FP16 capability and also allows a FP16 GPU trained model to run faster
without loss of accuracy or added SW overhead.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[bit 21]

This CPUID is exposed to user space. Besides, there is no other VMX
control for this instruction.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 19db3940f262..df4a7f7505a9 100644
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
index 7ab7cc717b1c..2a334d4cd04e 100644
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

