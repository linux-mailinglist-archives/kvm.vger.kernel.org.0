Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB06603CF1
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiJSIzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 04:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiJSIyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 04:54:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AD49620A;
        Wed, 19 Oct 2022 01:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666169475; x=1697705475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+X6cm8tXEq53y0cLc6cRR4TvIr9g+2l/NPCkvPotupE=;
  b=aM8QV0DubBd1jl08CrpYJxL6nf55tub/CGuPNKAZb/i3eW4k73apdiWb
   zJc6I9XVZaaDrqKbmZoDDfm7tBxisD6VXTNF7KEsouPKdNa8+0kdsznSH
   tcWeDgg86GCPs70fM3H2xl28q675dbbuQ/5JNV/lxEI+kIiIHc7/p5iZx
   SQ0CuFuXpSxUAisG/8mcE2k/9t2IfbgUDftUb3McbESw8Z9sFkU8aX/iC
   +hDbts3fz2MDBpuCnny66hS0QZfdXvOc5k1UvU230cBK2FPWeLBciw+6g
   7Lv4mMo9OFtGDcDRltlBkO+zgsutOl95hNStuEJqCnlBo2X9SXA2OKrIB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="286739743"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="286739743"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 01:48:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="804196026"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="804196026"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga005.jf.intel.com with ESMTP; 19 Oct 2022 01:48:02 -0700
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
Subject: [PATCH 5/6] x86: KVM: Enable AVX-NE-CONVERT CPUID and expose it to guest
Date:   Wed, 19 Oct 2022 16:47:33 +0800
Message-Id: <20221019084734.3590760-6-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
References: <20221019084734.3590760-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AVX-NE-CONVERT is a new set of instructions in the latest Intel platform
Sierra Forest, which can convert low precision floating point like
BF16/FP16 to high precision floating point FP32. It can also convert
FP32 elements to BF16. This instruction allows the platform to have
improved AI capabilities and better compatibility.

The bit definition:
CPUID.(EAX=7,ECX=1):EDX[bit 5]

This patch enables this CPUID in the kernel feature bits and expose it
to guest OS.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b2aa761ea110..4e0bbffedbb4 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -425,6 +425,7 @@
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EDX), word 20 */
 #define X86_FEATURE_AVX_VNNI_INT8       (20*32+ 4) /* Support for VPDPB[SU,UU,SS]D[,S] */
+#define X86_FEATURE_AVX_NE_CONVERT      (20*32+ 5) /* AVX NE CONVERT Instructions */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1b53a5c788a..fcd00c68e546 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -661,7 +661,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX_IFMA));
 
 	kvm_cpu_cap_mask(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8));
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT)
+	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
-- 
2.27.0

