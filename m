Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2C603D3A
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 11:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJSJAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 05:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiJSI72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 04:59:28 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EBE1260F;
        Wed, 19 Oct 2022 01:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666169696; x=1697705696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xh50grAc2J9OL82QlhScNH50h2hDqC36SRcoKoSLDwA=;
  b=lCbh+6FxrCSqBrcKL2DjQzfd1gqBG4pkiH6CCZRZy33Pb1cf4JsxHbHm
   1F+6UJO7lgMxsycSskJLtYnOXK5cWvfVt9kaacIQLkkTtsO1Xlp0/OFhA
   SgwUjCFy28XrFcAQ9mLOEj3V2bPCG7v6Ww96ye/LMGLzMIBFc5Fy/G8Hw
   k8aYZ8sLI0PpEeifBsPK318vhnQfJ9DzAy5Z2GnDy6gVg+x1G10omPj96
   2vuJFu+xnVMLP/JO/wZMrTOMAd+wLMHL4ZKo4ORzLZTMKZBc4SCp9PicK
   zsSMYBlzrTpaCHhu/9ZhuVGHh4gp/IlEXpxvcj4uXmO/PGRxLBSv9wM72
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="370567294"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="370567294"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 01:48:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="804196060"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="804196060"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga005.jf.intel.com with ESMTP; 19 Oct 2022 01:48:07 -0700
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
Subject: [PATCH 6/6] x86: KVM: Enable PREFETCHIT0/1 CPUID and expose it to guest
Date:   Wed, 19 Oct 2022 16:47:34 +0800
Message-Id: <20221019084734.3590760-7-jiaxi.chen@linux.intel.com>
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

Latest Intel platform Granite Rapids has introduced a new instruction -
PREFETCHIT0/1, which moves code to memory (cache) closer to the processor
depending on specific hints.

The bit definition:
CPUID.(EAX=7,ECX=1):EDX[bit 14]

This patch enables this CPUID in the kernel feature bits and expose it
to guest OS.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4e0bbffedbb4..de8aa62bbdb1 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -426,6 +426,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EDX), word 20 */
 #define X86_FEATURE_AVX_VNNI_INT8       (20*32+ 4) /* Support for VPDPB[SU,UU,SS]D[,S] */
 #define X86_FEATURE_AVX_NE_CONVERT      (20*32+ 5) /* AVX NE CONVERT Instructions */
+#define X86_FEATURE_PREFETCHITI         (20*32+14) /* PREFETCHIT0/1 Instructions */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index fcd00c68e546..e73307732d10 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -661,7 +661,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX_IFMA));
 
 	kvm_cpu_cap_mask(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT)
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-- 
2.27.0

