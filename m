Return-Path: <kvm+bounces-5499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC159822776
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:13:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 835A8B222A4
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C761946A;
	Wed,  3 Jan 2024 03:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jaOdIqdh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD34319463;
	Wed,  3 Jan 2024 03:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251403; x=1735787403;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ggD022wR84eJIDVFaJvrBBLC8iM3MXpUAJp9grwTY5c=;
  b=jaOdIqdhjNOVG2PVsQDLtksIY2ZirVCejRu9P0SlMsoTR7kOm6dhsT+7
   KU/YOf3E/f+U6PrV4Ql6Eu16nka87XPqOz3HZohY0K3/lK2A0hRgqDQZ4
   d4VvBP0FAtAN1Gi+vG2boC9QLau0uxuCx157YFClazgQnls7YK8Wlbmkg
   eY4w6tYIquyRv8wnsp+sOatbpk+P4fkS7E4tc0BvJtce1fAmGczfy7d+H
   30qDqFzwpI8ul5qaVv7OhEH+KYEXi5+r/Czo0uC9N6FmVnBJ8YIlatz/U
   CYZJOoQJL3icoqs5dUCJ8hVIn8MdRTyifyUYCAkH2RQk9vV/a5uual5yv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343171"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343171"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:10:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729665992"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729665992"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:09:59 -0800
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
Subject: [kvm-unit-tests Patch v3 09/11] x86: pmu: Improve LLC misses event verification
Date: Wed,  3 Jan 2024 11:14:07 +0800
Message-Id: <20240103031409.2504051-10-dapeng1.mi@linux.intel.com>
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

When running pmu test on SPR, sometimes the following failure is
reported.

1 <= 0 <= 1000000
FAIL: Intel: llc misses-4

Currently The LLC misses occurring only depends on probability. It's
possible that there is no LLC misses happened in the whole loop(),
especially along with processors have larger and larger cache size just
like what we observed on SPR.

Thus, add clflush instruction into the loop() asm blob and ensure once
LLC miss is triggered at least.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index b764827c1c3d..8fd3db0fbf81 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -20,19 +20,21 @@
 
 // Instrustion number of LOOP_ASM code
 #define LOOP_INSTRNS	10
-#define LOOP_ASM					\
+#define LOOP_ASM(_clflush)				\
+	_clflush "\n\t"                                 \
+	"mfence;\n\t"                                   \
 	"1: mov (%1), %2; add $64, %1;\n\t"		\
 	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
 	"loop 1b;\n\t"
 
-/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
-#define PRECISE_EXTRA_INSTRNS  (2 + 4)
+/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
+#define PRECISE_EXTRA_INSTRNS  (2 + 4 + 2)
 #define PRECISE_LOOP_INSTRNS   (N * LOOP_INSTRNS + PRECISE_EXTRA_INSTRNS)
 #define PRECISE_LOOP_BRANCHES  (N)
-#define PRECISE_LOOP_ASM						\
+#define PRECISE_LOOP_ASM(_clflush)					\
 	"wrmsr;\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
-	LOOP_ASM							\
+	LOOP_ASM(_clflush)						\
 	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
 	"wrmsr;\n\t"
 
@@ -72,14 +74,30 @@ char *buf;
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 
+#define _loop_asm(_clflush)					\
+do {								\
+	asm volatile(LOOP_ASM(_clflush)				\
+		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)	\
+		     : "0"(N), "1"(buf));			\
+} while (0)
+
+#define _precise_loop_asm(_clflush)				\
+do {								\
+	asm volatile(PRECISE_LOOP_ASM(_clflush)			\
+		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
+		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
+		       "0"(N), "1"(buf)				\
+		     : "edi");					\
+} while (0)
 
 static inline void __loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
 
-	asm volatile(LOOP_ASM
-		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
-		     : "0"(N), "1"(buf));
+	if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("clflush (%1)");
+	else
+		_loop_asm("nop");
 }
 
 /*
@@ -96,11 +114,10 @@ static inline void __precise_count_loop(u64 cntrs)
 	u32 eax = cntrs & (BIT_ULL(32) - 1);
 	u32 edx = cntrs >> 32;
 
-	asm volatile(PRECISE_LOOP_ASM
-		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
-		     : "a"(eax), "d"(edx), "c"(global_ctl),
-		       "0"(N), "1"(buf)
-		     : "edi");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_precise_loop_asm("clflush (%1)");
+	else
+		_precise_loop_asm("nop");
 }
 
 static inline void loop(u64 cntrs)
-- 
2.34.1


