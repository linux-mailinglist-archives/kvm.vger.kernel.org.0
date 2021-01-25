Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC45303290
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 04:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbhAYJZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 04:25:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:22889 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726503AbhAYJYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:24:51 -0500
IronPort-SDR: LUjGTxxN9jvUlvFEMi2cdE0Ho5itiYDw/fKtu5a+EF+hOUSw47jMGYi2Xn2oBzT6dGlxFUAKjg
 yXn1oXzwtJDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915776"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915776"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:04 -0800
IronPort-SDR: ywGu0M7hzIWe5wSix6f8QBri7jH40rme7PA4ItRNPT69YDov3gf3B55I5KAVE4alYFWAulMXO9
 QjGWfGVZNhaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223823"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:02 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 02/12] x86/cpufeature: Add CPUID.19H:{EBX,ECX} cpuid leaves
Date:   Mon, 25 Jan 2021 17:06:10 +0800
Message-Id: <1611565580-47718-3-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Though KeyLocker is generally enumerated by
CPUID.(07H,0):ECX.KL[bit23], CPUID.19H:{EBX,ECX} enumerate
more details of KeyLocker supporting status.

CPUID.19H:EBX
bit0 enumerates if OS (CR4.KeyLocker) and BIOS have enabled KeyLocker.
bit2 enumerates if wide Key Locker instructions are supported.
bit4 enumerates if IWKey backup is supported.
CPUID.19H:ECX
bit0 enumerates if the NoBackup parameter to LOADIWKEY is supported.
bit1 enumerates if IWKey randomization is supported.

Define these 2 cpuid_leafs so that get_cpu_cap() will have these
capabilities included, which will be the knowledge source of KVM on
host KeyLocker capabilities.

Most of above features don't have the necessity to appear in /proc/cpuinfo,
except "iwkey_rand", which we think might be interesting for user to easily
know if his system is using randomized IWKey.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h        |  6 ++++--
 arch/x86/include/asm/cpufeatures.h       | 11 ++++++++++-
 arch/x86/include/asm/disabled-features.h |  2 +-
 arch/x86/include/asm/required-features.h |  2 +-
 arch/x86/kernel/cpu/common.c             |  7 +++++++
 5 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 59bf91c..f9fea5f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -30,6 +30,8 @@ enum cpuid_leafs
 	CPUID_7_ECX,
 	CPUID_8000_0007_EBX,
 	CPUID_7_EDX,
+	CPUID_19_EBX,
+	CPUID_19_ECX,
 };
 
 #ifdef CONFIG_X86_FEATURE_NAMES
@@ -89,7 +91,7 @@ enum cpuid_leafs
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
 	   REQUIRED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
 
 #define DISABLED_MASK_BIT_SET(feature_bit)				\
 	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
@@ -112,7 +114,7 @@ enum cpuid_leafs
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
 	   DISABLED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
 
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8f2f050..d4a883a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -13,7 +13,7 @@
 /*
  * Defines x86 CPU feature bits
  */
-#define NCAPINTS			19	   /* N 32-bit words worth of info */
+#define NCAPINTS			21	   /* N 32-bit words worth of info */
 #define NBUGINTS			1	   /* N 32-bit bug flags */
 
 /*
@@ -382,6 +382,15 @@
 #define X86_FEATURE_CORE_CAPABILITIES	(18*32+30) /* "" IA32_CORE_CAPABILITIES MSR */
 #define X86_FEATURE_SPEC_CTRL_SSBD	(18*32+31) /* "" Speculative Store Bypass Disable */
 
+/* Intel-defined KeyLocker feature CPUID level 0x00000019 (EBX), word 20*/
+#define X86_FEATURE_KL_INS_ENABLED  (19*32 + 0) /* "" Key Locker instructions */
+#define X86_FEATURE_KL_WIDE  (19*32 + 2) /* "" Wide Key Locker instructions */
+#define X86_FEATURE_IWKEY_BACKUP  (19*32 + 4) /* "" IWKey backup */
+
+/* Intel-defined KeyLocker feature CPUID level 0x00000019 (ECX), word 21*/
+#define X86_FEATURE_IWKEY_NOBACKUP  (20*32 + 0) /* "" NoBackup parameter to LOADIWKEY */
+#define X86_FEATURE_IWKEY_RAND  (20*32 + 1) /* IWKey Randomization */
+
 /*
  * BUG word(s)
  */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 0ac9414..904baf8 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -91,6 +91,6 @@
 			 DISABLE_ENQCMD|DISABLE_KEYLOCKER)
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 3ff0d48..a165a16 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -101,6 +101,6 @@
 #define REQUIRED_MASK16	0
 #define REQUIRED_MASK17	0
 #define REQUIRED_MASK18	0
-#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
+#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 48881d8..ea46956 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -995,6 +995,13 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[CPUID_D_1_EAX] = eax;
 	}
 
+	/* Additional Intel-defined KeyLocker flags: level 0x00000019 */
+	if (c->cpuid_level >= 0x00000019) {
+		cpuid(0x00000019, &eax, &ebx, &ecx, &edx);
+		c->x86_capability[CPUID_19_EBX] = ebx;
+		c->x86_capability[CPUID_19_ECX] = ecx;
+	}
+
 	/* AMD-defined flags: level 0x80000001 */
 	eax = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = eax;
-- 
1.8.3.1

