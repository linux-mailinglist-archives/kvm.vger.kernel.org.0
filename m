Return-Path: <kvm+bounces-15196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4668AA76E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 05:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6AA3285BE2
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 03:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE81C75801;
	Fri, 19 Apr 2024 03:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dQ8yRFLE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A061537E4;
	Fri, 19 Apr 2024 03:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713498367; cv=none; b=VjbrkOcFd/QZrMT9tJn8T2WTDUVYxMZGEyyTQeLxVB5Rs+M18YibVO8/87GIlni+yn5ivW6ZTHU9pJTH6YT5To5wrCBJlKWFQD97d5EkjrrZx95aw4Bl1o0XTbxTJgExgf6wSZLZqBKdYV6sk6+1nckX6NCAUWb+4K0kWsRxFqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713498367; c=relaxed/simple;
	bh=k5yeC6To8qfzgH7nrLV5GXePfcq/WaufQeG/owbIi/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hZtp8t6DjLlfaDPhJtCF+sBYzLMEiI0LXUfmYEU+BGYJLRZlIf6IyA2AjN4goYX5TvpaCVc2l6MpfChX0s0jFI1Mh5r2A4jiyHJ689TkUGUa9NqujpN+rUcmPEocyFw1SfM8lMh/Jw9zpgzr+N5/mS1ssddM2SOyfTxQ6ip2KYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dQ8yRFLE; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713498366; x=1745034366;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k5yeC6To8qfzgH7nrLV5GXePfcq/WaufQeG/owbIi/Y=;
  b=dQ8yRFLE6KokBCL+8JKdjxzXXHvkGSaF1VtQ1TdyxQAJOTgSmKA6sjPV
   J8W8/Q/SzA4fNvbWmWsh2aXFXlMwJnIKrX84ICU9XWpc6rrPwtoxeBpRc
   jcqqs/4s/kyTOKwv/E2DYVcdNaC8hDYb4/hZ/MuTFm1VtqukedMGtjfbW
   gfleSSwaRoSzGDciua0x5RVnWzVgQBw2zKCDvqyGIA1SaUhZmuhgHnrr7
   mau6pqHl+2CR/ZegzcdkL74l72ev1OMXaI37g9YF+y1GSUEk7lyn+VkbU
   QT/pGpii1dKxKY7NWsUG4gAq3B1+xe5f6z02RAmQWrv9fmDYAnusNnaNU
   A==;
X-CSE-ConnectionGUID: ITV8UmcXTeO/zQIiov2uWg==
X-CSE-MsgGUID: BEYQhsIrTL2W0a+D3jZy7A==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="31565480"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="31565480"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 20:46:06 -0700
X-CSE-ConnectionGUID: j4Rg0L6JSqaVG0N/ODX8sQ==
X-CSE-MsgGUID: yxu2/dNGRK6UJDax2KWosw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="54410249"
Received: from unknown (HELO dmi-pnp-i7.sh.intel.com) ([10.239.159.155])
  by fmviesa001.fm.intel.com with ESMTP; 18 Apr 2024 20:46:03 -0700
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
Subject: [kvm-unit-tests Patch v4 11/17] x86: pmu: Enable and disable PMCs in loop() asm blob
Date: Fri, 19 Apr 2024 11:52:27 +0800
Message-Id: <20240419035233.3837621-12-dapeng1.mi@linux.intel.com>
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

Currently enabling PMCs, executing loop() and disabling PMCs are divided
3 separated functions. So there could be other instructions executed
between enabling PMCS and running loop() or running loop() and disabling
PMCs, e.g. if there are multiple counters enabled in measure_many()
function, the instructions which enabling the 2nd and more counters
would be counted in by the 1st counter.

So current implementation can only verify the correctness of count by an
rough range rather than a precise count even for instructions and
branches events. Strictly speaking, this verification is meaningless as
the test could still pass even though KVM vPMU has something wrong and
reports an incorrect instructions or branches count which is in the rough
range.

Thus, move the PMCs enabling and disabling into the loop() asm blob and
ensure only the loop asm instructions would be counted, then the
instructions or branches events can be verified with an precise count
instead of an rough range.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 80 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 15 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 20bc6de9c936..d97309d7b8a3 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -18,6 +18,15 @@
 #define EXPECTED_INSTR 17
 #define EXPECTED_BRNCH 5
 
+#define LOOP_ASM(_wrmsr)						\
+	_wrmsr "\n\t"							\
+	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
+	"1: mov (%1), %2; add $64, %1;\n\t"				\
+	"nop; nop; nop; nop; nop; nop; nop;\n\t"			\
+	"loop 1b;\n\t"							\
+	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
+	_wrmsr "\n\t"
+
 typedef struct {
 	uint32_t ctr;
 	uint32_t idx;
@@ -73,13 +82,43 @@ char *buf;
 static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 
-static inline void loop(void)
+
+static inline void __loop(void)
+{
+	unsigned long tmp, tmp2, tmp3;
+
+	asm volatile(LOOP_ASM("nop")
+		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
+		     : "0"(N), "1"(buf));
+}
+
+/*
+ * Enable and disable counters in a whole asm blob to ensure
+ * no other instructions are counted in the window between
+ * counters enabling and really LOOP_ASM code executing.
+ * Thus counters can verify instructions and branches events
+ * against precise counts instead of a rough valid count range.
+ */
+static inline void __precise_loop(u64 cntrs)
 {
 	unsigned long tmp, tmp2, tmp3;
+	unsigned int global_ctl = pmu.msr_global_ctl;
+	u32 eax = cntrs & (BIT_ULL(32) - 1);
+	u32 edx = cntrs >> 32;
 
-	asm volatile("1: mov (%1), %2; add $64, %1; nop; nop; nop; nop; nop; nop; nop; loop 1b"
-			: "=c"(tmp), "=r"(tmp2), "=r"(tmp3): "0"(N), "1"(buf));
+	asm volatile(LOOP_ASM("wrmsr")
+		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
+		     : "a"(eax), "d"(edx), "c"(global_ctl),
+		       "0"(N), "1"(buf)
+		     : "edi");
+}
 
+static inline void loop(u64 cntrs)
+{
+	if (!this_cpu_has_perf_global_ctrl())
+		__loop();
+	else
+		__precise_loop(cntrs);
 }
 
 volatile uint64_t irq_received;
@@ -178,18 +217,17 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
 	    ctrl = (ctrl & ~(0xf << shift)) | (usrospmi << shift);
 	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
     }
-    global_enable(evt);
     apic_write(APIC_LVTPC, PMI_VECTOR);
 }
 
 static void start_event(pmu_counter_t *evt)
 {
 	__start_event(evt, 0);
+	global_enable(evt);
 }
 
-static void stop_event(pmu_counter_t *evt)
+static void __stop_event(pmu_counter_t *evt)
 {
-	global_disable(evt);
 	if (is_gp(evt)) {
 		wrmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
 		      evt->config & ~EVNTSEL_EN);
@@ -201,14 +239,24 @@ static void stop_event(pmu_counter_t *evt)
 	evt->count = rdmsr(evt->ctr);
 }
 
+static void stop_event(pmu_counter_t *evt)
+{
+	global_disable(evt);
+	__stop_event(evt);
+}
+
 static noinline void measure_many(pmu_counter_t *evt, int count)
 {
 	int i;
+	u64 cntrs = 0;
+
+	for (i = 0; i < count; i++) {
+		__start_event(&evt[i], 0);
+		cntrs |= BIT_ULL(event_to_global_idx(&evt[i]));
+	}
+	loop(cntrs);
 	for (i = 0; i < count; i++)
-		start_event(&evt[i]);
-	loop();
-	for (i = 0; i < count; i++)
-		stop_event(&evt[i]);
+		__stop_event(&evt[i]);
 }
 
 static void measure_one(pmu_counter_t *evt)
@@ -218,9 +266,11 @@ static void measure_one(pmu_counter_t *evt)
 
 static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 {
+	u64 cntrs = BIT_ULL(event_to_global_idx(evt));
+
 	__start_event(evt, count);
-	loop();
-	stop_event(evt);
+	loop(cntrs);
+	__stop_event(evt);
 }
 
 static bool verify_event(uint64_t count, struct pmu_event *e)
@@ -483,7 +533,7 @@ static void check_running_counter_wrmsr(void)
 	report_prefix_push("running counter wrmsr");
 
 	start_event(&evt);
-	loop();
+	__loop();
 	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
 	report(evt.count < gp_events[instruction_idx].min, "cntr");
@@ -500,7 +550,7 @@ static void check_running_counter_wrmsr(void)
 
 	wrmsr(MSR_GP_COUNTERx(0), count);
 
-	loop();
+	__loop();
 	stop_event(&evt);
 
 	if (this_cpu_has_perf_global_status()) {
@@ -641,7 +691,7 @@ static void warm_up(void)
 	 * the real verification.
 	 */
 	while (i--)
-		loop();
+		loop(0);
 }
 
 static void check_counters(void)
-- 
2.34.1


