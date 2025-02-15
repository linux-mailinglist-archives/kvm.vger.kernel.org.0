Return-Path: <kvm+bounces-38266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC9E5A36B1B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BDD216C168
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863A815198B;
	Sat, 15 Feb 2025 01:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lXbEyQIt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E06714D28C
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583420; cv=none; b=UdSN3tIHGkhxD4AQ9u522KCu/ywD7EzafSko3mmXapmYXANQLMIDtEQPia7H/rNofQ1Lsq51NTKHqMnQq4Wlbds5bDAva7SSp/eNrUXBJr7uRs/1ynuv6yEea8lfQJJFx0DxWssKeVEkCtHmLi5Q7tYGzxf54OCh9NJ3IJcU22E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583420; c=relaxed/simple;
	bh=fUYY46i7w9LO7WrU5SQHhs5W1ahNXwxxLPM4zLiftgU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I6Fn0uHi5+rl3OrfV8MuMXoAhisY3C2fvH435O+W/X4OQ3u/mVksKuAkcOG2Qt7SldEV1E66fQ6wEZacEuQqFLdKDcZ4Yecy1+rGCpHvDUSUkKb7F3j+rx/cse6H2ZkkYrPeFaJVzFYPattT4qwnKCVdpML+tZz2yHHO/pOZhd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lXbEyQIt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso8553635a91.2
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583418; x=1740188218; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9IuIoBCLpTMTrH+jakBvAL4oIS1s5PHSNd7gOE0pZeA=;
        b=lXbEyQItmX7HXVV8QVSj37dCdBLhUXWTZqdMVbkzM/XUrWmQcZ7mCEQjXnK4dvfCiA
         RlInZnOrqhViVm1pAZNeT7WBmJ7BRbgK4KMVAW6u9ydOlDC/nnSBijmz/VOcCQ/iay3V
         Cu8zAslzyA3bfDLrzbr7gCHxRcNqHBtqKM8jXYMoAqQBQ5XXDMKDRRuZ6UoI9halML91
         qCRTMB0cvm3py/odpQ1XATVYxrhE4CL1Hm/KJ+b6mFiWhyTEUSeqzyJYesTfKhSqiGY5
         fpLS3KOHtoY92VY0lCfSjcM2suyX6Xc7hKBhwlL34EtxQPRffPWPFCfASAHU4l+Lpqor
         QmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583418; x=1740188218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9IuIoBCLpTMTrH+jakBvAL4oIS1s5PHSNd7gOE0pZeA=;
        b=mqzpGSnm+fRp338vnm3jEYwGlvCl4Y1l1XGN0Z71VgNvWxTczDj1sXhIV7XwptzYCS
         4SB4Ht+cnIaBlMpr18fi2ZBQVxmGpwaSD8BGZLCNPfQf7VfBuGWbdOYD4N6CrIMtNeYm
         7yXUEeO4r9PMFmIVXMk4EHF9krsBj0xVXIrYXvjcoXNSbVRYfxJsUlGboyrsHrU8+9qT
         FGWhcENyLoqf6os2TI9NNiMTvdbxwUr/mZOJjzBJUH4U2txdbOjf4TreMtm8/wfYfA6K
         ssXrTS44oyoxzpQ5MCuYxiDD7m2WUKoK7cgXNc/sXafLnDAbAAQviA47a2o+29U3sm/c
         OEQw==
X-Gm-Message-State: AOJu0YzOlJR273atM2zWwe4wd5Dcupzn8ku8DU9407DH/0UGTeSJlYD7
	hKJQa+i4VkqKGwGUuS4Jj8clD3/JcFFjj2l6473zkg9o/xzgWS65WtuG5mzjjMCtiMqqJgK0MqT
	LdA==
X-Google-Smtp-Source: AGHT+IEnNV2iaakmt/FWuCtgy/2Jun93x1oVNthP95ZlBsBF2t7SXIpR61LBzGbduG+W8pxyOa8vNvVxEEk=
X-Received: from pjbqn13.prod.google.com ([2002:a17:90b:3d4d:b0:2ee:4b69:50e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d86:b0:2f4:432d:250d
 with SMTP id 98e67ed59e1d1-2fc40f23849mr1813231a91.21.1739583418475; Fri, 14
 Feb 2025 17:36:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:29 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-13-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 12/18] x86: pmu: Enable and disable PMCs in
 loop() asm blob
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 80 ++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 15 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index c7eda47a..06d867d9 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -19,6 +19,15 @@
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
@@ -75,13 +84,43 @@ static struct pmu_event *gp_events;
 static unsigned int gp_events_size;
 static unsigned int fixed_counters_num;
 
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
@@ -181,18 +220,17 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
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
@@ -204,14 +242,24 @@ static void stop_event(pmu_counter_t *evt)
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
@@ -221,9 +269,11 @@ static void measure_one(pmu_counter_t *evt)
 
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
@@ -495,7 +545,7 @@ static void check_running_counter_wrmsr(void)
 	report_prefix_push("running counter wrmsr");
 
 	start_event(&evt);
-	loop();
+	__loop();
 	wrmsr(MSR_GP_COUNTERx(0), 0);
 	stop_event(&evt);
 	report(evt.count < gp_events[instruction_idx].min, "cntr");
@@ -512,7 +562,7 @@ static void check_running_counter_wrmsr(void)
 
 	wrmsr(MSR_GP_COUNTERx(0), count);
 
-	loop();
+	__loop();
 	stop_event(&evt);
 
 	if (this_cpu_has_perf_global_status()) {
@@ -653,7 +703,7 @@ static void warm_up(void)
 	 * the real verification.
 	 */
 	for (i = 0; i < 10; i++)
-		loop();
+		loop(0);
 }
 
 static void check_counters(void)
-- 
2.48.1.601.g30ceb7b040-goog


