Return-Path: <kvm+bounces-5500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1133E822777
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:13:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1268A1C22D90
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21915199D7;
	Wed,  3 Jan 2024 03:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixumY8aB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0B5199BA;
	Wed,  3 Jan 2024 03:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251407; x=1735787407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z72wvalERNtglXdFe8pPE83KEOIKaIWcyGSzLUbOvDI=;
  b=ixumY8aBQOIA1m9LZaMEx+qy7AZHiVz52HmKzcu6l//fAJ2NBF/2zVBr
   mpERtf11o9D85zSiw6up3ufVuXrdPKgyvr+YZbr77JJiXQtpCdaWTthqZ
   qVFvaXE6xEd9GDKbedJETIzdxNkni54XtGHLKdB9P06E95B1v8We4TU2W
   3fc2vB0nZrMucpDayYizIcgZYssl+lZAQNaFpOGDjWPiswYLhPrbmJmIq
   fiDx6aRfC8sNmqdmOj7eCEezwdHjMXWe83Wfh8dPaq1lhGfRAhq8MHh9J
   t1RUbn/0M7S+uWnlzYw+Fj8RwWRxkTg6ivKpDHIRWskGVZfftrG75ACwQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343176"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343176"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:10:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729666003"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729666003"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:10:02 -0800
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v3 10/11] x86: pmu: Add IBPB indirect jump asm blob
Date: Wed,  3 Jan 2024 11:14:08 +0800
Message-Id: <20240103031409.2504051-11-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
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
 x86/pmu.c | 56 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 8fd3db0fbf81..c8d4a0dcd362 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -27,14 +27,26 @@
 	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
 	"loop 1b;\n\t"
 
-/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
-#define PRECISE_EXTRA_INSTRNS  (2 + 4 + 2)
+#define IBPB_JMP_INSTRNS      7
+#define IBPB_JMP_BRANCHES     1
+#define IBPB_JMP_ASM(_wrmsr)				\
+	"mov $1, %%eax; xor %%edx, %%edx;\n\t"		\
+	"mov $73, %%ecx;\n\t"				\
+	_wrmsr "\n\t"					\
+	"lea 2f, %%rax;\n\t"				\
+	"jmp *%%rax;\n\t"				\
+	"nop;\n\t"					\
+	"2: nop;\n\t"
+
+/* GLOBAL_CTRL enable + disable + clflush/mfence + IBPB_JMP */
+#define PRECISE_EXTRA_INSTRNS  (2 + 4 + 2 + IBPB_JMP_INSTRNS)
 #define PRECISE_LOOP_INSTRNS   (N * LOOP_INSTRNS + PRECISE_EXTRA_INSTRNS)
-#define PRECISE_LOOP_BRANCHES  (N)
-#define PRECISE_LOOP_ASM(_clflush)					\
+#define PRECISE_LOOP_BRANCHES  (N + IBPB_JMP_BRANCHES)
+#define PRECISE_LOOP_ASM(_clflush, _wrmsr)				\
 	"wrmsr;\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
 	LOOP_ASM(_clflush)						\
+	IBPB_JMP_ASM(_wrmsr)						\
 	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
 	"wrmsr;\n\t"
 
@@ -74,30 +86,42 @@ char *buf;
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 
-#define _loop_asm(_clflush)					\
+#define _loop_asm(_clflush, _wrmsr)				\
 do {								\
 	asm volatile(LOOP_ASM(_clflush)				\
+		     IBPB_JMP_ASM(_wrmsr)			\
 		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)	\
-		     : "0"(N), "1"(buf));			\
+		     : "0"(N), "1"(buf)				\
+		     : "eax", "edx");				\
 } while (0)
 
-#define _precise_loop_asm(_clflush)				\
+#define _precise_loop_asm(_clflush, _wrmsr)			\
 do {								\
-	asm volatile(PRECISE_LOOP_ASM(_clflush)			\
+	asm volatile(PRECISE_LOOP_ASM(_clflush, _wrmsr)		\
 		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
 		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
 		       "0"(N), "1"(buf)				\
 		     : "edi");					\
 } while (0)
 
+static int has_ibpb(void)
+{
+	return this_cpu_has(X86_FEATURE_SPEC_CTRL) ||
+	       this_cpu_has(X86_FEATURE_AMD_IBPB);
+}
+
 static inline void __loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
 
-	if (this_cpu_has(X86_FEATURE_CLFLUSH))
-		_loop_asm("clflush (%1)");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH) && has_ibpb())
+		_loop_asm("clflush (%1)", "wrmsr");
+	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("clflush (%1)", "nop");
+	else if (has_ibpb())
+		_loop_asm("nop", "wrmsr");
 	else
-		_loop_asm("nop");
+		_loop_asm("nop", "nop");
 }
 
 /*
@@ -114,10 +138,14 @@ static inline void __precise_count_loop(u64 cntrs)
 	u32 eax = cntrs & (BIT_ULL(32) - 1);
 	u32 edx = cntrs >> 32;
 
-	if (this_cpu_has(X86_FEATURE_CLFLUSH))
-		_precise_loop_asm("clflush (%1)");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH) && has_ibpb())
+		_precise_loop_asm("clflush (%1)", "wrmsr");
+	else if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_precise_loop_asm("clflush (%1)", "nop");
+	else if (has_ibpb())
+		_precise_loop_asm("nop", "wrmsr");
 	else
-		_precise_loop_asm("nop");
+		_precise_loop_asm("nop", "nop");
 }
 
 static inline void loop(u64 cntrs)
-- 
2.34.1


