Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3FF62395A
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiKJBzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiKJBy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:54:58 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3541A29CB7;
        Wed,  9 Nov 2022 17:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668045297; x=1699581297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JwR3352mQmtvv3jNZ1XhkuwmOLMITQeiSm1roomzunE=;
  b=ZXfVE4Yb05m6NPFUCyDK6lApk9Au3uFRXaqPRw3PcRBn7gLzb4/ypK37
   gXsqU4Rqta/XCPceGJ3Uk/hfHMGfC93jQptBayxaqXd9SuShtxqyN79sz
   R95Ueb8jHURgnvG63OpUTYMZPYqYWdZbKPYrXg1mC2om3gnJ3jZ9FKSwk
   T8LUsS7bw1G7ZvsN/1oJFI6wZsIC6XuacsO9gtiAsGVJtcfynbuHZ/dQT
   soUprHNdHjlQ0SGLjy1RC1KHcoSzS/DUV2bhkN1cnbdnn8NsUtGrZM17/
   /IUeSPhzi2JtHV3okZCDwMRAdxhBviKWhPybOQp591qf+mB5d5t7z9WqN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="294522235"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="294522235"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 17:53:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="762100153"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="762100153"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga004.jf.intel.com with ESMTP; 09 Nov 2022 17:53:30 -0800
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
Subject: [PATCH v3 7/7] x86: KVM: Advertise PREFETCHIT0/1 CPUID to user space
Date:   Thu, 10 Nov 2022 09:52:52 +0800
Message-Id: <20221110015252.202566-8-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
References: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
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
index 47ac2a502d91..9021a80b3553 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -662,7 +662,7 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init_scattered(CPUID_7_1_EDX,
-		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT)
+		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index b8addd85b062..884aebe7b3c2 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -36,6 +36,7 @@ enum kvm_only_cpuid_leafs {
 /* Intel-defined sub-features, CPUID level 0x00000007:1 (EDX) */
 #define X86_FEATURE_AVX_VNNI_INT8       KVM_X86_FEATURE(CPUID_7_1_EDX, 4)
 #define X86_FEATURE_AVX_NE_CONVERT      KVM_X86_FEATURE(CPUID_7_1_EDX, 5)
+#define X86_FEATURE_PREFETCHITI         KVM_X86_FEATURE(CPUID_7_1_EDX, 14)
 
 struct cpuid_reg {
 	u32 function;
-- 
2.27.0

