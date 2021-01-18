Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65782F9833
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 04:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbhARD1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Jan 2021 22:27:49 -0500
Received: from mga14.intel.com ([192.55.52.115]:9511 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbhARD1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Jan 2021 22:27:47 -0500
IronPort-SDR: OJuk4Nwu1M0ONch/pRl+yUJSAxTVlgr/ujhBCw7cvFVsGjD3R4Sln9tpRy+1LLv1w9OBWuR7RP
 9XjLptxuzk2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="177975324"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="177975324"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:04 -0800
IronPort-SDR: CTq0FajyKyTvJ09uqyQEFk5C/TJOb38s49qlC/sX6tOmybNm78qzyfzaEiSJwWrEi47u2XA336
 ClHSGHMO+0eQ==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573150713"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:27:01 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 01/26] x86/cpufeatures: Add SGX1 and SGX2 sub-features
Date:   Mon, 18 Jan 2021 16:26:49 +1300
Message-Id: <87385f646120a3b5b34dc20480dbce77b8005acd.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add SGX1 and SGX2 feature flags, via CPUID.0x12.0x0.EAX, as scattered
features.  As part of virtualizing SGX, KVM will expose the SGX CPUID
leafs to its guest, and to do so correctly needs to query hardware and
kernel support for SGX1 and SGX2.

Also add SGX related feature bits to CPUID dependency table to make
clearing SGX feature easier.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 ++
 arch/x86/kernel/cpu/cpuid-deps.c   | 3 +++
 arch/x86/kernel/cpu/feat_ctl.c     | 1 -
 arch/x86/kernel/cpu/scattered.c    | 2 ++
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 84b887825f12..18b2d0c8bbbe 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -292,6 +292,8 @@
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
 #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
 #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
+#define X86_FEATURE_SGX1		(11*32+ 8) /* Software Guard Extensions sub-feature SGX1 */
+#define X86_FEATURE_SGX2        	(11*32+ 9) /* Software Guard Extensions sub-feature SGX2 */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 42af31b64c2c..7d341bfe7f57 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -72,6 +72,9 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AVX512_FP16,		X86_FEATURE_AVX512BW  },
 	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
+	{ X86_FEATURE_SGX_LC,			X86_FEATURE_SGX       },
+	{ X86_FEATURE_SGX1,			X86_FEATURE_SGX       },
+	{ X86_FEATURE_SGX2,			X86_FEATURE_SGX1      },
 	{}
 };
 
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 3b1b01f2b248..7937a315f8cf 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -96,7 +96,6 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 static void clear_sgx_caps(void)
 {
 	setup_clear_cpu_cap(X86_FEATURE_SGX);
-	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
 }
 
 static int __init nosgx(char *str)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 236924930bf0..fea0df867d18 100644
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

