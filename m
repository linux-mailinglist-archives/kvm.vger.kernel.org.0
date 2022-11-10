Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C65623947
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiKJByf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiKJByc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:54:32 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDFC27B35;
        Wed,  9 Nov 2022 17:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668045270; x=1699581270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=taX06KsU8mQXBQxKFDkHqGSkrqNdhC3yQd3XBk1YjEY=;
  b=c/aZyX/QBQk1sSFG1gsj6d1Ab/BOnOsxZsr94Ee0X0xB1MhK9VHSmuCS
   tI7tjQ26NcCsNQY/hnJQQpaqn90qHHKuQcXUR56StmRqfzzUvBsV4U1Wb
   LPa/I4WF4DXDfHBYGGjwnUbl7r1kK298mtlVVIxLYzf3vGHi9qITjOpa7
   iMie5KBENr7gPIAX4Oj+KyjfaejKaXBNe+mf2UhsEySaAiKYq9dhoBp8D
   RVQoWpfR6L6DnqL8pkDD7Bw2Qk0Bz/+xd4p1w2dImoOuhfCZqbbcLkwU8
   t/KLwSgHBvJ9Ukb7i4J0Vt4c8wLZNHtQ65hXtYu7ZY7X5RYIa1L4Ht/e/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="397475871"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="397475871"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 17:53:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="762099833"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="762099833"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by orsmga004.jf.intel.com with ESMTP; 09 Nov 2022 17:52:59 -0800
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
Subject: [PATCH v3 2/7] x86: KVM: Advertise CMPccXADD CPUID to user space
Date:   Thu, 10 Nov 2022 09:52:47 +0800
Message-Id: <20221110015252.202566-3-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
References: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
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

