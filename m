Return-Path: <kvm+bounces-26911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90979978EB8
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 09:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5138B277F4
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 07:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415B51D12E1;
	Sat, 14 Sep 2024 07:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W2E6UzDW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137BE1CEAA1;
	Sat, 14 Sep 2024 07:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726297317; cv=none; b=PvI7imCrOZ9eZCEXAElgtfy4llTW1WbZK2pnchOPYYlLZI5nr1OxJW31zrwCQBTfCvMqMHLUlijelvAbvOVT4nnY7ZVXVRTjey5q+thmiXYLq9jFb6EG47PRuVCJxJokp6670UUMxpgojZ4rqVap65nDJ3YidXZ981f6mohnDPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726297317; c=relaxed/simple;
	bh=Rz3BSwdtyqkIaqhFWc6IZEQz107z+w5qDNmQ8HUMorU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sY52GCPxqXhlbuAaNiAqIG3UfzmolgDJcn5kZtim6aqsHUBEszwbnukMQgMBUUezUofgW1cgBQJ8qr7bdSV4Ou+0oY/iyRVL6dbnH3y2EhQx4hwKn4nquM45TV4xnWsfeGVvM+fI3YXL8iElt+FA/CULVp66EQzyzeCnIBYJZYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W2E6UzDW; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726297316; x=1757833316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rz3BSwdtyqkIaqhFWc6IZEQz107z+w5qDNmQ8HUMorU=;
  b=W2E6UzDW/rtfvaiTxKpGvdupl3uji9rMwTmJ5SQYgalCrkHKWjqvumJ0
   11IDsRqjrM4c3VZAOigOARzXt0KH17HOH8GfdVTwt5wweHOUylDzp9vZP
   WLqER8q846gJ2Zt6GbIjMnliyIEPTxlIOuqpccR4cIG5Ep9v1FaabGmoQ
   yfQ++1Gfbp3+zwnQ7Y2AAk1TSUP/3YXxrLeySKkE5+nZMHoP3oxlaSNNL
   y6ya/PeR8S4ixy63FEy0IwHXFFJvVejFb/C/hNSIzLHC8YqXt/wmUK1hz
   V1U9DnyswmHzKvH3fR9apMSvl/3ZBDqF9fu9x5hPABTO7dO3Q8BXlDQsf
   A==;
X-CSE-ConnectionGUID: EHiE1RfhTrCFP355GR2Bhg==
X-CSE-MsgGUID: TNTzKo5VTU2/tFintrL6mw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="35778882"
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="35778882"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2024 00:01:56 -0700
X-CSE-ConnectionGUID: 3urytuaeQcK2OFXa6aiANg==
X-CSE-MsgGUID: zwMVccmSSvGIBi+4NcqANQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,228,1719903600"; 
   d="scan'208";a="67951007"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa006.fm.intel.com with ESMTP; 14 Sep 2024 00:01:53 -0700
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
	Yongwei Ma <yongwei.ma@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests patch v6 16/18] x86: pmu: Add IBPB indirect jump asm blob
Date: Sat, 14 Sep 2024 10:17:26 +0000
Message-Id: <20240914101728.33148-17-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com>
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
index 47b6305d..279d418d 100644
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
@@ -101,6 +128,12 @@ static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 static unsigned int fixed_counters_num;
 
+static int has_ibpb(void)
+{
+	return this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
+	       this_cpu_has(X86_FEATURE_AMD_IBPB);
+}
+
 static inline void __loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
@@ -108,10 +141,14 @@ static inline void __loop(void)
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
@@ -128,10 +165,14 @@ static inline void __precise_loop(u64 cntrs)
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


