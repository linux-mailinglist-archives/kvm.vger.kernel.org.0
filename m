Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8353BF7AA
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 11:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhGHJii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 05:38:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:54020 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231281AbhGHJih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jul 2021 05:38:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196751874"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196751874"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 02:35:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="498366019"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jul 2021 02:35:54 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [kvm-unit-tests PATCH] x86: add Key Locker LOADIWKEY in vmexit test suite
Date:   Thu,  8 Jul 2021 17:35:51 +0800
Message-Id: <1625736951-14197-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Key Locker feature is enumerated by CPUID.0x7:ECX[23].
Its loadiwkey instruction will cause VM-Exit.

Note: in current KVM implementation, host and guest can only exclusively
use this feature, i.e. host shall "clearcpuid=535" to expose this to guest.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 lib/x86/processor.h |  2 ++
 x86/vmexit.c        | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 173520f..4168682 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -154,6 +154,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_MCE			(CPUID(0x1, 0, EDX, 7))
 #define	X86_FEATURE_APIC		(CPUID(0x1, 0, EDX, 9))
 #define	X86_FEATURE_CLFLUSH		(CPUID(0x1, 0, EDX, 19))
+#define	X86_FEATURE_FXSR		(CPUID(0x1, 0, EDX, 24))
 #define	X86_FEATURE_XMM			(CPUID(0x1, 0, EDX, 25))
 #define	X86_FEATURE_XMM2		(CPUID(0x1, 0, EDX, 26))
 #define	X86_FEATURE_TSC_ADJUST		(CPUID(0x7, 0, EBX, 1))
@@ -171,6 +172,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
 #define	X86_FEATURE_SHSTK		(CPUID(0x7, 0, ECX, 7))
 #define	X86_FEATURE_IBT			(CPUID(0x7, 0, EDX, 20))
+#define	X86_FEATURE_KEYLOCKER		(CPUID(0x7, 0, ECX, 23))
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
diff --git a/x86/vmexit.c b/x86/vmexit.c
index 999babf..88e64da 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -459,6 +459,24 @@ static void wr_ibpb_msr(void)
 	wrmsr(MSR_IA32_PRED_CMD, 1);
 }
 
+#define LOADIWKEY	".byte 0xf3,0x0f,0x38,0xdc,0xd1"
+#define CR4_KEYLOCKER (1 << 19)
+#define CR4_OSFXSR	  (1 << 9)
+static int has_keylocker(void)
+{
+	return !!(this_cpu_has(X86_FEATURE_KEYLOCKER)) &&
+		   !!(this_cpu_has(X86_FEATURE_FXSR));
+}
+
+static void loadiwkey(void)
+{
+	ulong cr4 = read_cr4();
+	/* loadiwkey instruction requires CR4.KL and CR4.OSFXSR */
+	write_cr4(cr4 | CR4_KEYLOCKER | CR4_OSFXSR);
+	asm volatile(LOADIWKEY : : "a" (0x0));
+	write_cr4(cr4 & ~(CR4_KEYLOCKER | CR4_OSFXSR));
+}
+
 static struct test tests[] = {
 	{ cpuid_test, "cpuid", .parallel = 1,  },
 	{ vmcall, "vmcall", .parallel = 1, },
@@ -466,6 +484,7 @@ static struct test tests[] = {
 	{ mov_from_cr8, "mov_from_cr8", .parallel = 1, },
 	{ mov_to_cr8, "mov_to_cr8" , .parallel = 1, },
 #endif
+	{ loadiwkey, "loadiwkey", has_keylocker, .parallel = 1,},
 	{ inl_pmtimer, "inl_from_pmtimer", .parallel = 1, },
 	{ inl_nop_qemu, "inl_from_qemu", .parallel = 1 },
 	{ inl_nop_kernel, "inl_from_kernel", .parallel = 1 },
-- 
1.8.3.1

