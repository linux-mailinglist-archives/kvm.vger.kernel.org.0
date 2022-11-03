Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D4F617475
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiKCCvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiKCCux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:50:53 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE0113EBD;
        Wed,  2 Nov 2022 19:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667443850; x=1698979850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=taX06KsU8mQXBQxKFDkHqGSkrqNdhC3yQd3XBk1YjEY=;
  b=CeKtBCj0x/ogv/QsliI8isa0w0OrNf97R7JgVQSWru0J+VNhkXfuMnUd
   vuxWpfheD3RRYh33X5bt30twBCRssonjos2Ob1LzrYBCbG9TRfW3RsgQR
   rDuIRawUC7ZklcRB77qV7B1eko7Q8KZuUVwl2X8fFax27GJAvjNIrhplP
   G/TWEhW8vCG+ACMuaYb2BTdc8SgLMVduM/Pgh/Q5rUSPwOFGHgBM4KKOt
   F93FCTc+RvbCwAvyKph0O3INoLWGJh+Jxp2D02XqOB/WeIa5LJcL4sNZE
   M7l+Z1tZ0ELWxD4ADIypDT+5jlfo/WGoc7dZNNN7MiHR78aJJL3oCHGgk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="308289832"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="308289832"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="698047890"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="698047890"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2022 19:50:45 -0700
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
Subject: [PATCH v2 3/8] x86: KVM: Advertise CMPccXADD CPUID to user space
Date:   Thu,  3 Nov 2022 10:50:25 +0800
Message-Id: <20221103025030.78371-4-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
References: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CMPccXADD is a new set of instructions in the latest Intel platform
Sierra Forest. This new instruction set includes a semaphore operation
that can compare and add the operands if condition is met, which can
improve database performance.

The bit definition:
CPUID.(EAX=7,ECX=1):EAX[bit 7]

This CPUID is exposed to userspace. Besides, there is no other VMX
control for this instruction.

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/kvm/cpuid.c         | 2 +-
 arch/x86/kvm/reverse_cpuid.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 89f5e7f0402b..b388ef52f8c8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -657,7 +657,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
 	kvm_cpu_cap_init_scattered(CPUID_7_1_EAX,
-		F(AVX_VNNI) | F(AVX512_BF16)
+		F(AVX_VNNI) | F(AVX512_BF16) | F(CMPCCXADD)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 674de5b24f8d..24f570ddb225 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -28,6 +28,7 @@ enum kvm_only_cpuid_leafs {
 /* Intel-defined sub-features, CPUID level 0x00000007:1 (EAX) */
 #define X86_FEATURE_AVX_VNNI            KVM_X86_FEATURE(CPUID_7_1_EAX, 4)
 #define X86_FEATURE_AVX512_BF16         KVM_X86_FEATURE(CPUID_7_1_EAX, 5)
+#define X86_FEATURE_CMPCCXADD           KVM_X86_FEATURE(CPUID_7_1_EAX, 7)
 
 struct cpuid_reg {
 	u32 function;
-- 
2.27.0

