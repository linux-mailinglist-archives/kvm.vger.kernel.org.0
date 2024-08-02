Return-Path: <kvm+bounces-23104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE9A5946332
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 729DC1F22819
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6389C1AA9FE;
	Fri,  2 Aug 2024 18:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j6fD5JHj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45683DAC14
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722623013; cv=none; b=FFIJSB+g6+bjCcm3hrtvRqP3B2moXbmK/DZSbkycHneOmFoTGTwBhXo2agTe8CmGyU1v3iLhFfpiyunm+/vq5opukswNFUao6ed/A4aOZU6I8p+O4kgIx09oN7NyR4hOz/1qGMN/CsdsN8CDbmVHC3l69wEf2docJCRIRQwsNeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722623013; c=relaxed/simple;
	bh=Hy9USAPl/fxfVcQvWF7nOsOSt5AFSjwtbZ9xWp/GK5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lN/BLoXa7z6qcZ3yZzMUDECfewFwJnvasjQcU1oVxasBo1f9JF44QEkkdodjjeKFkGl3YZ+lGE7TkidJYBFhEF3iztciptiTaXu0SAiBaIAHao6l29aHGXGx/3oxD3/nR0ZM7apRUrP8DQjFyrU8Jx+0+1oU4y4X7uKJs61COBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j6fD5JHj; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-66a2aee82a0so170391917b3.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722623010; x=1723227810; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qol+YYMNNHW38r0W/7ZoKB8bBGx6w/YDTBQ1ltxmcDM=;
        b=j6fD5JHjE0FAP7pCRlZiQ5oY1Dl3chfT4p6PaVmAmIs1gX6aZmPKcxJHu37VzHvZmU
         Ci2hkMjGVDNG1UxT4GcEWwgxmAYdRG7NnYi7smn3pG+rFyZnhFD5zQMcyH4063wJucEO
         P8O1+mT7aLroduLQWILx2DXJ2ejxTd501MlK4SviUbeFfiMu/7AKyko1csAJPwlh0Pul
         ixLz1fNwI0377BfdJQROHZTkCoZfpC2qUsNlqEJ5Vx2odOjq/TQCtBb3FVwJ6DYvFEvo
         MPbmu9+skT54asE8rpVr/yKDYwhZCgHp0yZL2E+hKDzUpMm3XojD8PFYyc+fNUn0OcRY
         J/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722623010; x=1723227810;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qol+YYMNNHW38r0W/7ZoKB8bBGx6w/YDTBQ1ltxmcDM=;
        b=njYTdMa3ADId9zN6KAdHO26DTeZRuiSvT7+0xxxq1/NObb1FzzksqNo90koUgJorjQ
         /2KmlbO60+OyDkAb2Ih/ED1ENMRH6eVjlB3XAstYfrVTy82W9yNXbsJ+9nds/7tzIFS8
         1/6VH6HCa8EU87QnrbWZocsCAR6OaY9f1yjkDcS0WJqxDQ2oC34xYHV5SEAHWv9BDzQq
         eNlbj5IYpClFTqGx+NQSi5YLDm+dOpDJbqB2BA/Y6YKxC2BhEGQp7qbc8/qUY8qnYPoS
         g/oW4MjthO0yW7Ch8Yhce8kgb+bA/L6TnxM4insWMInnE6l5m+Yom6+S6BOLbv6gHqrP
         psAA==
X-Gm-Message-State: AOJu0Yz9hv7kSsiOvym5Nh/ktgEfO7Z/6kg4BT8ffpLzryZi59idaQLx
	3Uj9ipHFpyagB7wI0ABAIsAqLPfhBJx1er/hjbI6eoSqVxr89Tru22lBHdaQHEEs+JuvSh/GsO+
	h9G2L9GRF9k05mDM2EZ621cN2uar6M7gHckLeflOOiRNR7GmA6k9o2PMMjo1nvd9I8rXPauoblD
	9rt69WTl4mo9L2gKattHE01c5SRB/1iz7PY2A2kfZzP6pVY3wenz4SJvc=
X-Google-Smtp-Source: AGHT+IGNzvwJVCOdLqjHczjzlL6CV2UT0H8kVhxoi4rG8s6rOHGUtmwrsdUfGPs2+YGpxcURkb6OWNN3+Ek80veW+A==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:9d0b:0:b0:e0b:f69b:da0a with SMTP
 id 3f1490d57ef6-e0bf69be01amr93276.12.1722623009765; Fri, 02 Aug 2024
 11:23:29 -0700 (PDT)
Date: Fri,  2 Aug 2024 18:22:39 +0000
In-Reply-To: <20240802182240.1916675-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802182240.1916675-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802182240.1916675-6-coltonlewis@google.com>
Subject: [PATCH 5/6] KVM: x86: selftests: Test core events
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Mingwei Zhang <mizhang@google.com>, Jinrong Liang <ljr.kernel@gmail.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Test events on core counters by iterating through every combination of
events in amd_pmu_zen_events with every core counter.

For each combination, calculate the appropriate register addresses for
the event selection/control register and the counter register. The
base addresses and layout schemes change depending on whether we have
the CoreExt feature.

To do the testing, reuse GUEST_TEST_EVENT to run a standard known
workload. Decouple it from guest_assert_event_count (now
guest_assert_intel_event_count) to generalize to AMD.

Then assert the most specific detail that can be reasonably known
about the counter result. Exact count is defined and known for some
events and for other events merely asserted to be nonzero.

Note on exact counts: AMD counts one more branch than Intel for the
same workload. Though I can't confirm a reason, the only thing it
could be is the boundary of the loop instruction being counted
differently. Presumably, when the counter reaches 0 and execution
continues to the next instruction, AMD counts this as a branch and
Intel doesn't.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 87 ++++++++++++++++---
 1 file changed, 77 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 9620fc33d26e..fae078b444b3 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -29,6 +29,9 @@
 /* Total number of instructions retired within the measured section. */
 #define NUM_INSNS_RETIRED		(NUM_LOOPS * NUM_INSNS_PER_LOOP + NUM_EXTRA_INSNS)
 
+/* AMD counting one extra branch. Probably at loop boundary condition. */
+#define NUM_BRANCH_INSNS_RETIRED_AMD	(NUM_LOOPS+1)
+#define NUM_INSNS_RETIRED_AMD		(NUM_INSNS_RETIRED+1)
 
 static uint8_t kvm_pmu_version;
 static bool kvm_has_perf_caps;
@@ -98,7 +101,7 @@ static uint8_t guest_get_pmu_version(void)
  * Sanity check that in all cases, the event doesn't count when it's disabled,
  * and that KVM correctly emulates the write of an arbitrary value.
  */
-static void guest_assert_event_count(uint8_t idx,
+static void guest_assert_intel_event_count(uint8_t idx,
 				     struct kvm_x86_pmu_feature event,
 				     uint32_t pmc, uint32_t pmc_msr)
 {
@@ -140,6 +143,33 @@ static void guest_assert_event_count(uint8_t idx,
 	GUEST_ASSERT_EQ(_rdpmc(pmc), 0xdead);
 }
 
+static void guest_assert_amd_event_count(uint8_t evt_idx, uint8_t cnt_idx, uint32_t pmc_msr)
+{
+	uint64_t count;
+	uint64_t count_pmc;
+
+	count = rdmsr(pmc_msr);
+	count_pmc = _rdpmc(cnt_idx);
+	GUEST_ASSERT_EQ(count, count_pmc);
+
+	switch (evt_idx) {
+	case AMD_ZEN_CORE_CYCLES_INDEX:
+		GUEST_ASSERT_NE(count, 0);
+		break;
+	case AMD_ZEN_INSTRUCTIONS_INDEX:
+		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED_AMD);
+		break;
+	case AMD_ZEN_BRANCHES_INDEX:
+		GUEST_ASSERT_EQ(count, NUM_BRANCH_INSNS_RETIRED_AMD);
+		break;
+	case AMD_ZEN_BRANCH_MISSES_INDEX:
+		GUEST_ASSERT_NE(count, 0);
+		break;
+	default:
+		break;
+	}
+
+}
 /*
  * Enable and disable the PMC in a monolithic asm blob to ensure that the
  * compiler can't insert _any_ code into the measured sequence.  Note, ECX
@@ -172,28 +202,29 @@ do {										\
 	);									\
 } while (0)
 
-#define GUEST_TEST_EVENT(_idx, _event, _pmc, _pmc_msr, _ctrl_msr, _value, FEP)	\
+#define GUEST_TEST_EVENT(_pmc_msr, _ctrl_msr, _ctrl_value, FEP)			\
 do {										\
 	wrmsr(_pmc_msr, 0);							\
 										\
 	if (this_cpu_has(X86_FEATURE_CLFLUSHOPT))				\
-		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflushopt .", FEP);	\
+		GUEST_MEASURE_EVENT(_ctrl_msr, _ctrl_value, "clflushopt .", FEP);	\
 	else if (this_cpu_has(X86_FEATURE_CLFLUSH))				\
-		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "clflush .", FEP);	\
+		GUEST_MEASURE_EVENT(_ctrl_msr, _ctrl_value, "clflush .", FEP);	\
 	else									\
-		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "nop", FEP);		\
-										\
-	guest_assert_event_count(_idx, _event, _pmc, _pmc_msr);			\
+		GUEST_MEASURE_EVENT(_ctrl_msr, _ctrl_value, "nop", FEP);		\
 } while (0)
 
 static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature event,
 				    uint32_t pmc, uint32_t pmc_msr,
 				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
 {
-	GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
+	GUEST_TEST_EVENT(pmc_msr, ctrl_msr, ctrl_msr_value, "");
+	guest_assert_intel_event_count(idx, event, pmc, pmc_msr);
 
-	if (is_forced_emulation_enabled)
-		GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
+	if (is_forced_emulation_enabled) {
+		GUEST_TEST_EVENT(pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
+		guest_assert_intel_event_count(idx, event, pmc, pmc_msr);
+	}
 }
 
 #define X86_PMU_FEATURE_NULL						\
@@ -684,9 +715,45 @@ static void guest_test_rdwr_core_counters(void)
 	}
 }
 
+static void __guest_test_core_event(uint8_t event_idx, uint8_t counter_idx)
+{
+	/* One fortunate area of actual compatibility! This register
+	 * layout is the same for both AMD and Intel.
+	 */
+	uint64_t eventsel = ARCH_PERFMON_EVENTSEL_OS |
+		ARCH_PERFMON_EVENTSEL_ENABLE |
+		amd_pmu_zen_events[event_idx];
+	bool core_ext = this_cpu_has(X86_FEATURE_PERF_CTR_EXT_CORE);
+	uint64_t esel_msr_base = core_ext ? MSR_F15H_PERF_CTL : MSR_K7_EVNTSEL0;
+	uint64_t cnt_msr_base = core_ext ? MSR_F15H_PERF_CTR : MSR_K7_PERFCTR0;
+	uint64_t msr_step = core_ext ? 2 : 1;
+	uint64_t esel_msr = esel_msr_base + msr_step * counter_idx;
+	uint64_t cnt_msr = cnt_msr_base + msr_step * counter_idx;
+
+	GUEST_TEST_EVENT(cnt_msr, esel_msr, eventsel, "");
+	guest_assert_amd_event_count(event_idx, counter_idx, cnt_msr);
+
+	if (is_forced_emulation_enabled) {
+		GUEST_TEST_EVENT(cnt_msr, esel_msr, eventsel, KVM_FEP);
+		guest_assert_amd_event_count(event_idx, counter_idx, cnt_msr);
+	}
+
+}
+
+static void guest_test_core_events(void)
+{
+	uint8_t nr_counters = this_cpu_property(X86_PROPERTY_NUM_PERF_CTR_CORE);
+
+	for (uint8_t i = 0; i < NR_AMD_ZEN_EVENTS; i++) {
+		for (uint8_t j = 0; j < nr_counters; j++)
+			__guest_test_core_event(i, j);
+	}
+}
+
 static void guest_test_core_counters(void)
 {
 	guest_test_rdwr_core_counters();
+	guest_test_core_events();
 	GUEST_DONE();
 }
 
-- 
2.46.0.rc2.264.g509ed76dc8-goog


