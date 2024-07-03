Return-Path: <kvm+bounces-20875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB8F924DA9
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 04:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A09531C243DE
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 02:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A406AD53F;
	Wed,  3 Jul 2024 02:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K9QBjUQx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7055F4AEE7;
	Wed,  3 Jul 2024 02:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719972789; cv=none; b=IBBKas+lbjS6o/fu8MpKqM0JaI2yRSg3RJnOTd5RoMXcTDEERpkBgZARXj1luDxspxYNPcEjFqIoP+aes0JTCn7WwBloNwRakFzGS5+Z3dOy/wgZi2fFOaghQN6IBeV4ud0iEf3DNk1YiihrbfU6549jNY+awuW/dcfwN4iCBQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719972789; c=relaxed/simple;
	bh=q1ME73HKe5ZIfg8BdJo/w8w/zu5qJwk/fcxbRV/mxZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LVTwvwaWFQrmP8rF9onLNzySjJ+L76mqwz2OVv10tZpUHuRhJl/8xO7GrGpyBpzkyrakGFAU1wnLhrP2i5Wljl2p6fS8EckU+HELi5YADEboX6UTck2PaW+gt02YA7Vn8TaimJ3WsEDYGRKa/lvPG6GMZG4QTBHxDPEQIdBqumA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K9QBjUQx; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719972788; x=1751508788;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q1ME73HKe5ZIfg8BdJo/w8w/zu5qJwk/fcxbRV/mxZE=;
  b=K9QBjUQxt7KCttTKIzKYraDVy/HI7c0AzTbvl83oB0x2IeWF91h7SzP7
   UHt10MlngL0eCLISCdFNjp6SRaEdRlmR36FSPQOAC/gE79dRKDtqIpsiL
   u6+PWk0Nt86nzcPk0XYlRCOUsx1T85V5oqEvNr9aXTRI9d8S79KMxp916
   lhSP1hmjs0sFEqOJ/X2WOe1PXf+unhzz4Ko8AN3yTn1vHGvDDctTHedbo
   Tj5H6+J0v+PdE8G1vA+rJV8cPf7UasjHzEKp+VCjHNOArYppVbVqHMx42
   Db5YNecOi0xRj+KZD88HLQQ4mN91i0v3eDwHLdrkxroFbpRDJQB1IiaFa
   g==;
X-CSE-ConnectionGUID: PxpWIJz9Rnix8KO7ddMjxQ==
X-CSE-MsgGUID: E8X3WT2vTSeFVwR0vBhzBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="17311111"
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="17311111"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2024 19:13:08 -0700
X-CSE-ConnectionGUID: xVeNfu+qQSScb7j0/TM7jw==
X-CSE-MsgGUID: bjttMA5kRnexr7mMcjyoPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,180,1716274800"; 
   d="scan'208";a="46148748"
Received: from emr.sh.intel.com ([10.112.229.56])
  by fmviesa010.fm.intel.com with ESMTP; 02 Jul 2024 19:13:04 -0700
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
Subject: [Patch v5 13/18] x86: pmu: Improve LLC misses event verification
Date: Wed,  3 Jul 2024 09:57:07 +0000
Message-Id: <20240703095712.64202-14-dapeng1.mi@linux.intel.com>
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
index ffb7b4a4..799d8d5c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -20,19 +20,30 @@
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
@@ -88,14 +99,17 @@ char *buf;
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
@@ -108,15 +122,14 @@ static inline void __loop(void)
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
2.40.1


