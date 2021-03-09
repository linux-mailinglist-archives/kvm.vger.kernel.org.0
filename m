Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B90C331C5D
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhCIBjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:39:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:62452 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhCIBjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:39:19 -0500
IronPort-SDR: ufAZ/g7SvpATAsW/CckOGdEZmRG/M9ET4PpfqfGdo57M/+sJMk+NFIEPQKfG2yVcFnnFaIW/BC
 6YvkQS5OJ/bQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="187500177"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="187500177"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:39:19 -0800
IronPort-SDR: XM8DgMN1IluVRc5DSXiMbyXwpj8Z+lGisH7Rz8AViuq8y/DD/toCOUAQe1mBKqt+PpJp/LIL1m
 RoicIore+DLg==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="447327145"
Received: from kzliu-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.128.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 17:39:15 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 02/25] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Date:   Tue,  9 Mar 2021 14:39:00 +1300
Message-Id: <164745a2de1b9c5bede8c08a3a57566b75a61ae1.1615250634.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615250634.git.kai.huang@intel.com>
References: <cover.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
features, since adding a new leaf for only two bits would be wasteful.
As part of virtualizing SGX, KVM will expose the SGX CPUID leafs to its
guest, and to do so correctly needs to query hardware and kernel support
for SGX1 and SGX2.

Suppress both SGX1 and SGX2 from /proc/cpuinfo. SGX1 basically means
SGX, and for SGX2 there is no concrete use case of using it in
/proc/cpuinfo.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
v1->v2:

 - Changed to hide both SGX1 and SGX2 from /proc/cpuinfo, since no concrete
   use case, per Boris.
 - Refined commit msg to explain why to hide SGX1 and SGX2 in /proc/cpuinfo.

---
 arch/x86/include/asm/cpufeatures.h | 2 ++
 arch/x86/kernel/cpu/cpuid-deps.c   | 2 ++
 arch/x86/kernel/cpu/scattered.c    | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index cc96e26d69f7..af82b8f935e0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -290,6 +290,8 @@
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
+#define X86_FEATURE_SGX1		(11*32+ 8) /* "" Basic SGX */
+#define X86_FEATURE_SGX2        	(11*32+ 9) /* "" SGX Enclave Dynamic Memory Management (EDMM) */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index d40f8e0a54ce..defda61f372d 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -73,6 +73,8 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
 	{ X86_FEATURE_SGX_LC,			X86_FEATURE_SGX	      },
+	{ X86_FEATURE_SGX1,			X86_FEATURE_SGX       },
+	{ X86_FEATURE_SGX2,			X86_FEATURE_SGX1      },
 	{}
 };
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 972ec3bfa9c0..21d1f062895a 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -36,6 +36,8 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CDP_L2,		CPUID_ECX,  2, 0x00000010, 2 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  3, 0x00000010, 0 },
 	{ X86_FEATURE_PER_THREAD_MBA,	CPUID_ECX,  0, 0x00000010, 3 },
+	{ X86_FEATURE_SGX1,		CPUID_EAX,  0, 0x00000012, 0 },
+	{ X86_FEATURE_SGX2,		CPUID_EAX,  1, 0x00000012, 0 },
 	{ X86_FEATURE_HW_PSTATE,	CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
-- 
2.29.2

