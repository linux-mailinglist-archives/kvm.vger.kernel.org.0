Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD26617470
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 03:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiKCCur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 22:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiKCCum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 22:50:42 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E30F11164;
        Wed,  2 Nov 2022 19:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667443840; x=1698979840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OrIoPfAaFxyGwyJ42VnSxwQIBSLZ5vI600fUBQrgg84=;
  b=N9By31Nm3WrJH4uoTxmqZRHOWL7UmMZKvZD0GU50u4KGS/VV34plA72A
   xax5n1Z3ZeHhRRyPmX2e1bFcQv//1zpaw5ccE9ZoMIXEIGGhjwPth+1Su
   ZEYF1+nSK+q2NGLWf6gzV7g78vyB2orQRctRwow32ENvIKJLAJvkBvdbT
   Gu+GCHdwoX2apjLODBEeVJ1clXTvmnN2pP5HNlOFzn2InDhh6p6kgfcqv
   ujadCowDqFibpGj19/bBGdSPgk7aSZVtQFFq5DtAY4VUXeDgapDG2d2/T
   0tTrsLZBDRxj04vquQCWGrbrYH/22QS+aw01nSAmZkyp6hDTtN6KUUUIf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="289961921"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="289961921"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 19:50:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="698047821"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="698047821"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2022 19:50:35 -0700
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
Subject: [PATCH v2 1/8] x86: KVM: Move existing x86 CPUID leaf [CPUID_7_1_EAX] to kvm-only leaf
Date:   Thu,  3 Nov 2022 10:50:23 +0800
Message-Id: <20221103025030.78371-2-jiaxi.chen@linux.intel.com>
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

cpuid_leaf[12] CPUID_7_1_EAX has only two bits are in use currently:

 - AVX-VNNI CPUID.(EAX=7,ECX=1):EAX[bit 4]
 - AVX512-BF16 CPUID.(EAX=7,ECX=1):EAX[bit 5]

These two bits have no other kernel usages other than the guest
CPUID advertisement in KVM. Given that and to save space for kernel
feature bits, move these two bits to the kvm-only subleaves. The
existing leaf cpuid_leafs[12] is set to CPUID_DUMMY so future feature
can pick it. This basically reverts:

 - commit b85a0425d805 ("Enumerate AVX Vector Neural Network
instructions")
 - commit b302e4b176d0 ("x86/cpufeatures: Enumerate the new AVX512
BFLOAT16 instructions")
 - commit 1085a6b585d7 ("KVM: Expose AVX_VNNI instruction to guset")

Signed-off-by: Jiaxi Chen <jiaxi.chen@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h  | 2 +-
 arch/x86/include/asm/cpufeatures.h | 4 ----
 arch/x86/kernel/cpu/common.c       | 6 ------
 arch/x86/kernel/cpu/cpuid-deps.c   | 1 -
 arch/x86/kvm/cpuid.c               | 2 +-
 arch/x86/kvm/reverse_cpuid.h       | 5 +++++
 6 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1a85e1fb0922..fbb4e7bd2288 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -24,7 +24,7 @@ enum cpuid_leafs
 	CPUID_7_0_EBX,
 	CPUID_D_1_EAX,
 	CPUID_LNX_4,
-	CPUID_7_1_EAX,
+	CPUID_DUMMY,
 	CPUID_8000_0008_EBX,
 	CPUID_6_EAX,
 	CPUID_8000_000A_EDX,
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ef4775c6db01..cabe96df9555 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -305,10 +305,6 @@
 #define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
-/* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
-#define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
-#define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
-
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
 #define X86_FEATURE_IRPERF		(13*32+ 1) /* Instructions Retired Count */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3e508f239098..0c19c84d7ba0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1026,12 +1026,6 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[CPUID_7_0_EBX] = ebx;
 		c->x86_capability[CPUID_7_ECX] = ecx;
 		c->x86_capability[CPUID_7_EDX] = edx;
-
-		/* Check valid sub-leaf index before accessing it */
-		if (eax >= 1) {
-			cpuid_count(0x00000007, 1, &eax, &ebx, &ecx, &edx);
-			c->x86_capability[CPUID_7_1_EAX] = eax;
-		}
 	}
 
 	/* Extended state features: level 0x0000000d */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index c881bcafba7d..a88e0e8c39fa 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -68,7 +68,6 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_CQM_OCCUP_LLC,		X86_FEATURE_CQM_LLC   },
 	{ X86_FEATURE_CQM_MBM_TOTAL,		X86_FEATURE_CQM_LLC   },
 	{ X86_FEATURE_CQM_MBM_LOCAL,		X86_FEATURE_CQM_LLC   },
-	{ X86_FEATURE_AVX512_BF16,		X86_FEATURE_AVX512VL  },
 	{ X86_FEATURE_AVX512_FP16,		X86_FEATURE_AVX512BW  },
 	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7065462378e2..89f5e7f0402b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -656,7 +656,7 @@ void kvm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
-	kvm_cpu_cap_mask(CPUID_7_1_EAX,
+	kvm_cpu_cap_init_scattered(CPUID_7_1_EAX,
 		F(AVX_VNNI) | F(AVX512_BF16)
 	);
 
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473d0184..674de5b24f8d 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_7_1_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -24,6 +25,10 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 
+/* Intel-defined sub-features, CPUID level 0x00000007:1 (EAX) */
+#define X86_FEATURE_AVX_VNNI            KVM_X86_FEATURE(CPUID_7_1_EAX, 4)
+#define X86_FEATURE_AVX512_BF16         KVM_X86_FEATURE(CPUID_7_1_EAX, 5)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
-- 
2.27.0

