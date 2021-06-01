Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2AE396F7D
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhFAIuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:50:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:45129 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233722AbhFAItq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:49:46 -0400
IronPort-SDR: CuAJ249u78JZPGcT5ku5h+jdZKxVAr7tPQfF5LspHq4hXGOj8cJA4+NPsKcIK3f6obLI0Zp9TQ
 g2j2zbQ4LQOg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381299"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381299"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:04 -0700
IronPort-SDR: SLmp6cTjwsUa+6fPYO7Rpn2tj6hYCW5AzKdpBqR2GUDRzFhnZ40jozGSgA+PF4JbNp7tGrvNYc
 lg8IFzhMXuFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967751"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:00 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 02/15] x86/cpufeatures: Define Key Locker sub feature flags
Date:   Tue,  1 Jun 2021 16:47:41 +0800
Message-Id: <1622537274-146420-3-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Though KeyLocker is generally enumerated by
CPUID.(07H,0):ECX.KL[bit23], CPUID.19H:{EBX,ECX} enumerate
more details of KeyLocker supporting status.
Define them in scattered cpuid bits.

CPUID.19H:EBX
bit0 enumerates if OS (CR4.KeyLocker) and BIOS have enabled KeyLocker.
bit2 enumerates if wide Key Locker instructions are supported.
bit4 enumerates if IWKey backup is supported.
CPUID.19H:ECX
bit0 enumerates if the NoBackup parameter to LOADIWKEY is supported.
bit1 enumerates if IWKey randomization is supported.

Most of above features don't necessarily appear in /proc/cpuinfo,
except "iwkey_rand", which we think might be interesting to indicate
that the system supports randomized IWKey.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/cpufeatures.h | 5 +++++
 arch/x86/kernel/cpu/scattered.c    | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 578cf3f..8dd7271 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -294,6 +294,11 @@
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
 #define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
 #define X86_FEATURE_SGX2		(11*32+ 9) /* "" SGX Enclave Dynamic Memory Management (EDMM) */
+#define X86_FEATURE_KL_INS_ENABLED	(11*32 + 10) /* "" Key Locker instructions */
+#define X86_FEATURE_KL_WIDE		(11*32 + 11) /* "" Wide Key Locker instructions */
+#define X86_FEATURE_IWKEY_BACKUP	(11*32 + 12) /* "" IWKey backup */
+#define X86_FEATURE_IWKEY_NOBACKUP	(11*32 + 13) /* "" NoBackup parameter to LOADIWKEY */
+#define X86_FEATURE_IWKEY_RAND		(11*32 + 14) /* IWKey Randomization */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 21d1f06..de8677c 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -38,6 +38,11 @@ struct cpuid_bit {
 	{ X86_FEATURE_PER_THREAD_MBA,	CPUID_ECX,  0, 0x00000010, 3 },
 	{ X86_FEATURE_SGX1,		CPUID_EAX,  0, 0x00000012, 0 },
 	{ X86_FEATURE_SGX2,		CPUID_EAX,  1, 0x00000012, 0 },
+	{ X86_FEATURE_KL_INS_ENABLED,	CPUID_EBX,  0, 0x00000019, 0 },
+	{ X86_FEATURE_KL_WIDE,		CPUID_EBX,  2, 0x00000019, 0 },
+	{ X86_FEATURE_IWKEY_BACKUP,	CPUID_EBX,  4, 0x00000019, 0 },
+	{ X86_FEATURE_IWKEY_NOBACKUP,	CPUID_ECX,  0, 0x00000019, 0 },
+	{ X86_FEATURE_IWKEY_RAND,	CPUID_ECX,  1, 0x00000019, 0 },
 	{ X86_FEATURE_HW_PSTATE,	CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
-- 
1.8.3.1

