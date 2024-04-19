Return-Path: <kvm+bounces-15198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF9D8AA772
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6AE2285516
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7F87D419;
	Fri, 19 Apr 2024 03:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LwLrAjP7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECC07C6C8;
	Fri, 19 Apr 2024 03:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498373; cv=none; b=V2rAptZRhocJx5Xn97UCQHZL/tkdZlyxpRYkFWKk65gruHWTt8N7fAnDveSpGIUgZqLdtdBur7I/GCa4m7MCB2EBUBmCejklmPQgCGvjzM9N266EAyy9Ye0f8hJXpf7JqAq13Ail7TXAZ6Mcosr7GuG7K8wq+Fik7L2vZXD0SGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498373; c=relaxed/simple;
	bh=IYpNCAzV0Bjh1hMoxtoJMYlAI9fDHjiRenI3de/8ODs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h5niA9el2ZEg+oVgitdE7eD4504VInZF53s4wshf5BPMjm4STNQmQPjGRYJvHFQVL7MbEh5RFYIPfKBWnWNXyRo2jAlVKnqoJrcpgZt9Mn6YMhXkLl6pnpTNYsYsveYLEqLdefKSdsMQLv+HOa7sB7xb3k0e3x5BqbhNlIIrOtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LwLrAjP7; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498372; x=1745034372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IYpNCAzV0Bjh1hMoxtoJMYlAI9fDHjiRenI3de/8ODs=;
  b=LwLrAjP7R92eSbb//81VznQ1aLYooOca2OJgmPS7+2YoYyFZeq/Lw0+m
   ePCGlzHhJWY2en5yPgZefrNoWz99iUuEjc3gVFIKR7HoaSrJ+lDh3Kkbd
   EPVNgE8qlP8SXjX1bwsSqXrWvMBUKwgC86Ug/++Q3j4nYlCUdAHEJgvJK
   +PP21w4TuieLh8plGhBORh+34kTQyX9/9zhqFLrF50/yI0CBBuE/gaHyO
   wKokPwEmx4Z2LKolUsayMkYzQTLvnKTR+1SgHugdn+2kunSQC+QtCrwoy
   4PO46tEX+SRFLDqryZBh+0CjQvwz9AiuDhXQ5A+ZFuR7XYRvgdVyT9Cc1
   w==;
X-CSE-ConnectionGUID: 27aaRiNCRZau9CuxTOufQw==
X-CSE-MsgGUID: 1cZp3zSfRWmyIbFMijmw5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565493"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565493"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:46:12 -0700
X-CSE-ConnectionGUID: wc1/7mxXSP+TRHi8pOUmtQ==
X-CSE-MsgGUID: SE7hlfXoSumW+tWR1aFrsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410288"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:46:09 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v4 13/17] x86: pmu: Improve LLC misses event verification
Date: Fri, 19 Apr 2024 11:52:29 +0800
Message-Id: <20240419035233.3837621-14-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
References: <20240419035233.3837621-1-dapeng1.mi@linux.intel.com>
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
 x86/pmu.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 1f81d96030e4..fcae60d33966 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -19,19 +19,30 @@
 #define EXPECTED_BRNCH 5
 
 
-/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
-#define EXTRA_INSTRNS  (3 + 3)
+/* Enable GLOBAL_CTRL + disable GLOBAL_CTRL + clflush/mfence instructions */
+#define EXTRA_INSTRNS  (3 + 3 + 2)
 #define LOOP_INSTRNS   (N * 10 + EXTRA_INSTRNS)
 #define LOOP_BRANCHES  (N)
-#define LOOP_ASM(_wrmsr)						\
+#define LOOP_ASM(_wrmsr, _clflush)					\
 	_wrmsr "\n\t"							\
 	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
+	_clflush "\n\t"                                 		\
+	"mfence;\n\t"                                   		\
 	"1: mov (%1), %2; add $64, %1;\n\t"				\
 	"nop; nop; nop; nop; nop; nop; nop;\n\t"			\
 	"loop 1b;\n\t"							\
 	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
 	_wrmsr "\n\t"
 
+#define _loop_asm(_wrmsr, _clflush)				\
+do {								\
+	asm volatile(LOOP_ASM(_wrmsr, _clflush)			\
+		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)	\
+		     : "a"(eax), "d"(edx), "c"(global_ctl),	\
+		       "0"(N), "1"(buf)				\
+		     : "edi");					\
+} while (0)
+
 typedef struct {
 	uint32_t ctr;
 	uint32_t idx;
@@ -87,14 +98,17 @@ char *buf;
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 
-
 static inline void __loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
+	u32 global_ctl = 0;
+	u32 eax = 0;
+	u32 edx = 0;
 
-	asm volatile(LOOP_ASM("nop")
-		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
-		     : "0"(N), "1"(buf));
+	if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("nop", "clflush (%1)");
+	else
+		_loop_asm("nop", "nop");
 }
 
 /*
@@ -107,15 +121,14 @@ static inline void __loop(void)
 static inline void __precise_loop(u64 cntrs)
 {
 	unsigned long tmp, tmp2, tmp3;
-	unsigned int global_ctl = pmu.msr_global_ctl;
+	u32 global_ctl = pmu.msr_global_ctl;
 	u32 eax = cntrs & (BIT_ULL(32) - 1);
 	u32 edx = cntrs >> 32;
 
-	asm volatile(LOOP_ASM("wrmsr")
-		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
-		     : "a"(eax), "d"(edx), "c"(global_ctl),
-		       "0"(N), "1"(buf)
-		     : "edi");
+	if (this_cpu_has(X86_FEATURE_CLFLUSH))
+		_loop_asm("wrmsr", "clflush (%1)");
+	else
+		_loop_asm("wrmsr", "nop");
 }
 
 static inline void loop(u64 cntrs)
-- 
2.34.1


