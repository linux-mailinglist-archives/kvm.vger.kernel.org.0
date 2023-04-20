Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353316E96CD
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 16:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjDTOQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 10:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjDTOQW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 10:16:22 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A78C5FFB;
        Thu, 20 Apr 2023 07:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682000181; x=1713536181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=mBqjl0yhEeb8HytbOFw3rMDfti8h06Ban5qDOvLFqy8=;
  b=fQwdg0q9wJaME2h+ePIxss6z6WIOGNZOE+lkFBr7SdxMsNulLMQ5g+za
   EdaxQQDy6y5r5TgvdfEu+ilPQLvTy3frTK/keponnTSbMjylWgl/bOfA0
   ijM0RO5EOtRQd/GJqeI92GVIaaVnbaU6pcHaR0Xgb1FTI2u/9fjzI1uXO
   XEoPrbcqZiz4nIjyDWB5kngCVo2aVw2RXdawkv7RmK9iUykiN6tsUxbR+
   xaYvJdAEDOyHGPxLy4Tpf0Nd5WJvC7tTSOzeFm60J+6O4NM+uyxYKUaVl
   Z2zAXaOV4rNnnKjgE84G6LbRfZz5JPPgdZMSUCsEn2/ezi7udenIbY77k
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="343217882"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="343217882"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:16:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="816028928"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="816028928"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.53])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 07:16:16 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH 6/6] KVM: x86: Set KVM LASS based on hardware capability
Date:   Thu, 20 Apr 2023 21:37:24 +0800
Message-Id: <20230420133724.11398-7-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230420133724.11398-1-guang.zeng@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host kernel may clear LASS capability in boot_cpu_data.x86_capability
besides explicitly using clearcpuid parameter. That will cause guest
not being able to manage LASS independently. So set KVM LASS directly
based on hardware capability to eliminate the dependency.

Add new helper functions to facilitate getting result of CPUID sub-leaf.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/include/asm/cpuid.h | 36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/cpuid.c         |  4 ++++
 2 files changed, 40 insertions(+)

diff --git a/arch/x86/include/asm/cpuid.h b/arch/x86/include/asm/cpuid.h
index 9bee3e7bf973..a25dd00b7c0a 100644
--- a/arch/x86/include/asm/cpuid.h
+++ b/arch/x86/include/asm/cpuid.h
@@ -127,6 +127,42 @@ static inline unsigned int cpuid_edx(unsigned int op)
 	return edx;
 }
 
+static inline unsigned int cpuid_count_eax(unsigned int op, int count)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid_count(op, count, &eax, &ebx, &ecx, &edx);
+
+	return eax;
+}
+
+static inline unsigned int cpuid_count_ebx(unsigned int op, int count)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid_count(op, count, &eax, &ebx, &ecx, &edx);
+
+	return ebx;
+}
+
+static inline unsigned int cpuid_count_ecx(unsigned int op, int count)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid_count(op, count, &eax, &ebx, &ecx, &edx);
+
+	return ecx;
+}
+
+static inline unsigned int cpuid_count_edx(unsigned int op, int count)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	cpuid_count(op, count, &eax, &ebx, &ecx, &edx);
+
+	return edx;
+}
+
 static __always_inline bool cpuid_function_is_indexed(u32 function)
 {
 	switch (function) {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5facb8037140..e99b99ebe1fe 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -667,6 +667,10 @@ void kvm_set_cpu_caps(void)
 		F(AMX_FP16) | F(AVX_IFMA)
 	);
 
+	/* Set LASS based on hardware capability */
+	if (cpuid_count_eax(7, 1) & F(LASS))
+		kvm_cpu_cap_set(X86_FEATURE_LASS);
+
 	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
 		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
 	);
-- 
2.27.0

