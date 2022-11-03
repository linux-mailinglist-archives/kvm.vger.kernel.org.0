Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70C461747A
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiKCCvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiKCCvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:51:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A271814036;
        Wed,  2 Nov 2022 19:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667443860; x=1698979860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qDIvJKQbDJZne66SN3OTzm4SJ9/jbIpx8cLqn7z/wuU=;
  b=iz/GVGE5QBtI4TYG4NahYz0/f/T7FIlc9l7j4ami0KHFb8gj9AYA/l06
   Ex2pG/CNpPSc7KlrjUWAStNs6t3L4z9CZoPxdu5qTmP530fAGeZhvPLdE
   P6b9hcqYuJT5+T83uJXVGZAzwIzorhlZ38ebCCXCdWQzingg7upTAxq0G
   Kxc5MFSsMcd5nboKVQ16yUAP0N1wG7Oen3qEnbDqLGErTeoGlm4SkiKOl
   p9E2RxN85ttR2l0pCrGzVOQ2B1SHbxgyZhYSB8wAG66bjHxwkyQ1KbA7l
   IThtwJ/IGmV6/F8i8Hy+Ume8fqwlvgfEQe9CZln+BGMS9M1Jf0FW8xqby
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="307186647"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="307186647"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:51:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="698047904"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="698047904"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2022 19:50:55 -0700
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
Subject: [PATCH v2 5/8] x86: KVM: Advertise AVX-IFMA CPUID to user space
Date:   Thu,  3 Nov 2022 10:50:27 +0800
Message-Id: <20221103025030.78371-6-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
References: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/cpuid.c         | 3 ++-
 arch/x86/kvm/reverse_cpuid.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 19ef02d5b11b..e84c6216a72c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -657,7 +657,8 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_init_scattered(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD) | F(AMX_FP16) |
+		F(AVX_IFMA)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 05fd43ebd226..954c0ceb1e90 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -30,6 +30,7 @@ enum kvm_only_cpuid_leafs {
 #define X86_FEATURE_AVX512_BF16         KVM_X86_FEATURE(CPUID_7_1_EAX, 5)
 #define X86_FEATURE_CMPCCXADD           KVM_X86_FEATURE(CPUID_7_1_EAX, 7)
 #define X86_FEATURE_AMX_FP16            KVM_X86_FEATURE(CPUID_7_1_EAX, 21)
+#define X86_FEATURE_AVX_IFMA            KVM_X86_FEATURE(CPUID_7_1_EAX, 23)
 
 struct cpuid_reg {
 	u32 function;
-- 
2.27.0

