Return-Path: <kvm+bounces-20877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0D4E924DAD
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 709001F2625E
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91CC777A1E;
	Wed,  3 Jul 2024 02:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ixl0mE4x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A92861FFB;
	Wed,  3 Jul 2024 02:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972795; cv=none; b=Ma8GGrLIlMCv12EeoqDv7zonZcrTJKQ9ZaJmu8aSL2G30V1IHB63c0KjTT1Sl+pI3rksMmjnSGbiOAnqbEC+5cl6P3+PC221tT0TcO6WxAtYbSoY8vI4eIiemrGbNvfYbytkdwHWMyl8rb1nx0fGUs9Y4QYhnP2qa3wXqdHcmGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972795; c=relaxed/simple;
	bh=iQdi4gGhSljc/r7rV+lLy/f6YfOXx8nDMF2O3B0DeX0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OOxHMP0SuySIb0iuJwsTmeY7med6nUYPFAPnz5mLs8XqdXLc9yify5HGWTc+8jbxLX//b5eMqVkjVjqM+oLAm4hBjUpYn/V3E8l0rBYaQPP3k/tg1gVW5hkp2NHR2K8KEwW+sbxFiir7V6mFEh9YtPpJiO6ZaFxwYaakNXPpwQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ixl0mE4x; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972794; x=1751508794;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iQdi4gGhSljc/r7rV+lLy/f6YfOXx8nDMF2O3B0DeX0=;
  b=Ixl0mE4xCKJlHZRIqQAdpL/aqOni+iEWDXTEoOtOtue3CoDNAnKtIbrT
   bnVMDlY3dXjIMbBM6Wl+uVl+LATmGyZkvZPblmhVrrjr98OKnksyjr3LY
   cnsVKkNvE2RM4wZHd6UItspr8kXAq6+X4vugHmyc+3QNvelo8zZ7G2pfG
   cQ1RVtU9BIOJLvgWHq0KtEMIRv0b+ev0GYCeFaUvxF2U5KAlyS63dkAMp
   XnhtRT+o+6jXykeJ2dYp3rVgQnEWkMZ+n7+R+/pXSrSJ5IDsKzK1Iur1P
   1VX82r9+ohnXzXB7IPFbUdzNfNy2I/Fam59q8PHxcOmV4IIsD+1RWTV7q
   Q==;
X-CSE-ConnectionGUID: DjaMnhNuQhqxo5DrPyau2w==
X-CSE-MsgGUID: 5MRuqrfXQs+ND2VVdudyZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311126"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311126"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:14 -0700
X-CSE-ConnectionGUID: D+LLzHFfSum+rAB87xPR3Q==
X-CSE-MsgGUID: B2hzyWKwSUqHiYttPWrFWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148803"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:13:11 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch v5 15/18] x86: pmu: Add IBPB indirect jump asm blob
Date: Wed,  3 Jul 2024 09:57:09 +0000
Message-Id: <20240703095712.64202-16-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
References: <20240703095712.64202-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the lower boundary of branch misses event is set to 0.
Strictly speaking 0 shouldn't be a valid count since it can't tell us if
branch misses event counter works correctly or even disabled. Whereas
it's also possible and reasonable that branch misses event count is 0
especailly for such simple loop() program with advanced branch
predictor.

To eliminate such ambiguity and make branch misses event verification
more acccurately, an extra IBPB indirect jump asm blob is appended and
IBPB command is leveraged to clear the branch target buffer and force to
cause a branch miss for the indirect jump.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 71 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 56 insertions(+), 15 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index c9c5fc19..498b18d0 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -19,25 +19,52 @@
 #define EXPECTED_INSTR 17
 #define EXPECTED_BRNCH 5
 
-
-/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
-#define EXTRA_INSTRNS  (3 + 3 + 2)
+#define IBPB_JMP_INSTRNS      9
+#define IBPB_JMP_BRANCHES     2
+
+#if defined(__i386__) || defined(_M_IX86) /* i386 */
+#define IBPB_JMP_ASM(_wrmsr)				\
+	"mov $1, %%eax; xor %%edx, %%edx;\n\t"		\
+	"mov $73, %%ecx;\n\t"				\
+	_wrmsr "\n\t"					\
+	"call 1f\n\t"					\
+	"1: pop %%eax\n\t"				\
+	"add $(2f-1b), %%eax\n\t"			\
+	"jmp *%%eax;\n\t"                               \
+	"nop;\n\t"					\
+	"2: nop;\n\t"
+#else /* x86_64 */
+#define IBPB_JMP_ASM(_wrmsr)				\
+	"mov $1, %%eax; xor %%edx, %%edx;\n\t"		\
+	"mov $73, %%ecx;\n\t"				\
+	_wrmsr "\n\t"					\
+	"call 1f\n\t"					\
+	"1: pop %%rax\n\t"				\
+	"add $(2f-1b), %%rax\n\t"                       \
+	"jmp *%%rax;\n\t"                               \
+	"nop;\n\t"					\
+	"2: nop;\n\t"
+#endif
+
+/* GLOBAL_CTRL enable + disable + clflush/mfence + IBPB_JMP */
+#define EXTRA_INSTRNS  (3 + 3 + 2 + IBPB_JMP_INSTRNS)
 #define LOOP_INSTRNS   (N * 10 + EXTRA_INSTRNS)
-#define LOOP_BRANCHES  (N)
-#define LOOP_ASM(_wrmsr, _clflush)					\
-	_wrmsr "\n\t"							\
+#define LOOP_BRANCHES  (N + IBPB_JMP_BRANCHES)
+#define LOOP_ASM(_wrmsr1, _clflush, _wrmsr2)				\
+	_wrmsr1 "\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
 	_clflush "\n\t"                                 		\
 	"mfence;\n\t"                                   		\
 	"1: mov (%1), %2; add $64, %1;\n\t"				\
 	"nop; nop; nop; nop; nop; nop; nop;\n\t"			\
 	"loop 1b;\n\t"							\
+	IBPB_JMP_ASM(_wrmsr2) 						\
 	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
-	_wrmsr "\n\t"
+	_wrmsr1 "\n\t"
 
-#define _loop_asm(_wrmsr, _clflush)				\
+#define _loop_asm(_wrmsr1, _clflush, _wrmsr2)			\
 do {								\
-	asm volatile(LOOP_ASM(_wrmsr, _clflush)			\
+	asm volatile(LOOP_ASM(_wrmsr1, _clflush, _wrmsr2)	\
 		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
 		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
 		       "0"(N), "1"(buf)				\
@@ -100,6 +127,12 @@ char *buf;
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 
+static int has_ibpb(void)
+{
+	return this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
+	       this_cpu_has(X86_FEATURE_AMD_IBPB);
+}
+
 static inline void __loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
@@ -107,10 +140,14 @@ static inline void __loop(void)
 	u32 eax = 0;
 	u32 edx = 0;
 
-	if (this_cpu_has(X86_FEATURE_CLFLUSH))
-		_loop_asm("nop", "clflush (%1)");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH) && has_ibpb())
+		_loop_asm("nop", "clflush (%1)", "wrmsr");
+	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("nop", "clflush (%1)", "nop");
+	else if (has_ibpb())
+		_loop_asm("nop", "nop", "wrmsr");
 	else
-		_loop_asm("nop", "nop");
+		_loop_asm("nop", "nop", "nop");
 }
 
 /*
@@ -127,10 +164,14 @@ static inline void __precise_loop(u64 cntrs)
 	u32 eax = cntrs & (BIT_ULL(32) - 1);
 	u32 edx = cntrs >> 32;
 
-	if (this_cpu_has(X86_FEATURE_CLFLUSH))
-		_loop_asm("wrmsr", "clflush (%1)");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH) && has_ibpb())
+		_loop_asm("wrmsr", "clflush (%1)", "wrmsr");
+	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("wrmsr", "clflush (%1)", "nop");
+	else if (has_ibpb())
+		_loop_asm("wrmsr", "nop", "wrmsr");
 	else
-		_loop_asm("wrmsr", "nop");
+		_loop_asm("wrmsr", "nop", "nop");
 }
 
 static inline void loop(u64 cntrs)
-- 
2.40.1


