Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F6162F700
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 15:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242363AbiKROQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 09:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242342AbiKROPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 09:15:53 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37126E549;
        Fri, 18 Nov 2022 06:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668780939; x=1700316939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iL9Gulkfj53aq2blQeCaJJySqTu7PhbaVSFImCV2Zpk=;
  b=Yqmj/TSHWbvo7nK1I9TFB8NVWgMCLLA0pf2+07M4vnLnqwt4aXyD7KN5
   8/m3Hk4heoldE9DUfWfiyEHib5fkiqegGHxoWDsnSFG69QNOrk8Ob7DnW
   1nYcRliW38acsDwvwp1rT+gWpWZZZjVx8Dw9cQiYKv9198iQQwAEa62f8
   uUe8bmzCq7POa63W14aM2aEREVevB0QcxMKy5PdLY5bX8SjDg8iBM8RA8
   QtY54sPE+bIMgbfZzrj2EsL2RxIyrgY3bTpZUVcH0QjEo7jYHiJ23mVXO
   G6SAPhjikvUo8QMzU+dHL+RmqpaAPsx1RuQsgZEPNt5zucT1Ck/PBOuSI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="339982428"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="339982428"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 06:15:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="673204507"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="673204507"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga001.jf.intel.com with ESMTP; 18 Nov 2022 06:15:33 -0800
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
Subject: [PATCH v4 6/6] x86: KVM: Advertise PREFETCHIT0/1 CPUID to user space
Date:   Fri, 18 Nov 2022 22:15:09 +0800
Message-Id: <20221118141509.489359-7-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Latest Intel platform Granite Rapids has introduced a new instruction -
PREFETCHIT0/1, which moves code to memory (cache) closer to the
processor depending on specific hints.

The bit definition:
CPUID.(EAX=7,ECX=1):EDX[bit 14]

This CPUID is exposed to user space. Besides, there is no other VMX
control for this instruction.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/kvm/cpuid.c         | 2 +-
 arch/x86/kvm/reverse_cpuid.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f87292ae69d2..35eaee40c1bb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -661,7 +661,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX_IFMA));
 
 	kvm_cpu_cap_init_scattered(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT)
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index d0fc43c3b2fd..49bb06163fb4 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -28,6 +28,7 @@ enum kvm_only_cpuid_leafs {
 /* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
 #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
+#define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 
 struct cpuid_reg {
 	u32 function;
-- 
2.27.0

