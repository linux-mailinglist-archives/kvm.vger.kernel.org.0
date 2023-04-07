Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5A56DB733
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjDGXdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjDGXdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:33:08 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131EDE18A
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:33:07 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id k63-20020a638442000000b0050726979a86so42119pgd.4
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680910386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=scyiM5JietKX432Rv/g9zTfwsV+CmtnlW20m9otH4Hc=;
        b=mIOrqOHV5ql36umbkmioOg/5MERf77KpCS8SMMNlsDGBFlC6b5gayjaR/QlidX6hEl
         1AuKMXnsZ7jdifAVR+HQ0wCytqANt5XlGU7TnUMhLqA7mvTKtaHW2QIkAUaC06VPTjAC
         ZptJJh4g3RjfoC7pbhhq4UBT9wFDxoSqsZf7X1vbvkls0wu9HvHWJ9BsUcwIgyW8x4Rm
         k9eN83ve9RSiVCwAb5kOkIynSZGBdcR3Z1Nh+gdy/DKrMpDnL9GIECy9rZQOkZANi5Vo
         cmdsLgfCRXMVpJnqvIMdp4YwJzmjhD8rE2DdoGAtPr0PvtLriS+nbq/eFBeqTaGJzNnO
         gZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680910386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=scyiM5JietKX432Rv/g9zTfwsV+CmtnlW20m9otH4Hc=;
        b=P70Ins/Ky5f4F5f6eO1vPMZ0v2GET7j2QnD1yXlcmlz7WnPnLB+iP6QEVqFnFIpm/n
         T3+fsWWI7gYmd0GkgxvMcoKBFlpkn/FMbb2RujjZYYOHo0Zuo5gLJUZIIZPb9n0EBnLC
         sVLy4Y+7QyF5+WoTcuMXBc9FvhPcfkRzZxgNHzYcVySiI1olKWV/6W0dljVwf24mIbgl
         ufI1HhFjWnTbZz6QKFju657fRQG7sSbs8QzchAHvsIAAIb9F49wuqJlrvKNHg0Gmcp0i
         ARokWf7iTiwwxngWzQuV2vQ/a2tMsntVyx5ldIz9Ouhk2A2zXeF7Ng1LExOPEEQWumqc
         /Tbg==
X-Gm-Message-State: AAQBX9egGSjCDX4yVnanvODb5ViUj9vkaUyh1DBmNAGCVZxXwTk5Cw+1
        d3leNtX6Rm9ZdLWbA42ZMVXpBSHXauM=
X-Google-Smtp-Source: AKy350Z/7F1CKXl+O9g+6FIqIBw6R/U9SAzn0TgAWeqim5ip027qrweJGcB3qpNPDP3ntzAa9dLz/LewNRo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e552:b0:1a0:41ea:b9ba with SMTP id
 n18-20020a170902e55200b001a041eab9bamr1273410plf.8.1680910386608; Fri, 07 Apr
 2023 16:33:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  7 Apr 2023 16:32:53 -0700
In-Reply-To: <20230407233254.957013-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230407233254.957013-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407233254.957013-6-seanjc@google.com>
Subject: [PATCH v4 5/6] KVM: selftests: Copy full counter values from guest in
 PMU event filter test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a single struct to track all PMC event counts in the PMU filter test,
and copy the full struct to/from the guest when running and measuring each
guest workload.  Using a common struct avoids naming conflicts, e.g. the
loads/stores testcase has claimed "perf_counter", and eliminates the
unnecessary truncation of the counter values when they are propagated from
the guest MSRs to the host structs.

Zero the struct before running the guest workload to ensure that the test
doesn't get a false pass due to consuming data from a previous run.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 170 +++++++++---------
 1 file changed, 80 insertions(+), 90 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 0432ba347b22..5112aece3f95 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -71,6 +71,13 @@ static const uint64_t event_list[] = {
 	AMD_ZEN_BR_RETIRED,
 };
 
+struct {
+	uint64_t loads;
+	uint64_t stores;
+	uint64_t loads_stores;
+	uint64_t branches_retired;
+} pmc_results;
+
 /*
  * If we encounter a #GP during the guest PMU sanity check, then the guest
  * PMU is not functional. Inform the hypervisor via GUEST_SYNC(0).
@@ -100,13 +107,13 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
 		GUEST_SYNC(-EIO);
 }
 
-static uint64_t run_and_measure_loop(uint32_t msr_base)
+static void run_and_measure_loop(uint32_t msr_base)
 {
-	uint64_t branches_retired = rdmsr(msr_base + 0);
+	const uint64_t branches_retired = rdmsr(msr_base + 0);
 
 	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
 
-	return rdmsr(msr_base + 0) - branches_retired;
+	pmc_results.branches_retired = rdmsr(msr_base + 0) - branches_retired;
 }
 
 static void intel_guest_code(void)
@@ -117,15 +124,13 @@ static void intel_guest_code(void)
 	GUEST_SYNC(0);
 
 	for (;;) {
-		uint64_t count;
-
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 		wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | INTEL_BR_RETIRED);
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x1);
 
-		count = run_and_measure_loop(MSR_IA32_PMC0);
-		GUEST_SYNC(count);
+		run_and_measure_loop(MSR_IA32_PMC0);
+		GUEST_SYNC(0);
 	}
 }
 
@@ -141,14 +146,12 @@ static void amd_guest_code(void)
 	GUEST_SYNC(0);
 
 	for (;;) {
-		uint64_t count;
-
 		wrmsr(MSR_K7_EVNTSEL0, 0);
 		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | AMD_ZEN_BR_RETIRED);
 
-		count = run_and_measure_loop(MSR_K7_PERFCTR0);
-		GUEST_SYNC(count);
+		run_and_measure_loop(MSR_K7_PERFCTR0);
+		GUEST_SYNC(0);
 	}
 }
 
@@ -168,6 +171,19 @@ static uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
 	return uc.args[1];
 }
 
+static void run_vcpu_and_sync_pmc_results(struct kvm_vcpu *vcpu)
+{
+	uint64_t r;
+
+	memset(&pmc_results, 0, sizeof(pmc_results));
+	sync_global_to_guest(vcpu->vm, pmc_results);
+
+	r = run_vcpu_to_sync(vcpu);
+	TEST_ASSERT(!r, "Unexpected sync value: 0x%lx", r);
+
+	sync_global_from_guest(vcpu->vm, pmc_results);
+}
+
 /*
  * In a nested environment or if the vPMU is disabled, the guest PMU
  * might not work as architected (accessing the PMU MSRs may raise
@@ -244,92 +260,93 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
 	return f;
 }
 
-#define ASSERT_PMC_COUNTING_INSTRUCTIONS(count)						\
+#define ASSERT_PMC_COUNTING_INSTRUCTIONS()						\
 do {											\
-	if (count && count != NUM_BRANCHES)						\
+	uint64_t br = pmc_results.branches_retired;					\
+											\
+	if (br && br != NUM_BRANCHES)							\
 		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",	\
-			__func__, count, NUM_BRANCHES);					\
-	TEST_ASSERT(count, "%s: Branch instructions retired = %lu (expected > 0)",	\
-		    __func__, count);							\
+			__func__, br, NUM_BRANCHES);					\
+	TEST_ASSERT(br, "%s: Branch instructions retired = %lu (expected > 0)",		\
+		    __func__, br);							\
 } while (0)
 
-#define ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS(count)					\
+#define ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS()						\
 do {											\
-	TEST_ASSERT(!count, "%s: Branch instructions retired = %lu (expected 0)",	\
-		    __func__, count);							\
+	uint64_t br = pmc_results.branches_retired;					\
+											\
+	TEST_ASSERT(!br, "%s: Branch instructions retired = %lu (expected 0)",		\
+		    __func__, br);							\
 } while (0)
 
 static void test_without_filter(struct kvm_vcpu *vcpu)
 {
-	uint64_t count = run_vcpu_to_sync(vcpu);
+	run_vcpu_and_sync_pmc_results(vcpu);
 
-	ASSERT_PMC_COUNTING_INSTRUCTIONS(count);
+	ASSERT_PMC_COUNTING_INSTRUCTIONS();
 }
 
-static uint64_t test_with_filter(struct kvm_vcpu *vcpu,
-				 struct kvm_pmu_event_filter *f)
+static void test_with_filter(struct kvm_vcpu *vcpu,
+			     struct kvm_pmu_event_filter *f)
 {
 	vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, f);
-	return run_vcpu_to_sync(vcpu);
+	run_vcpu_and_sync_pmc_results(vcpu);
 }
 
 static void test_amd_deny_list(struct kvm_vcpu *vcpu)
 {
 	uint64_t event = EVENT(0x1C2, 0);
 	struct kvm_pmu_event_filter *f;
-	uint64_t count;
 
 	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY, 0);
-	count = test_with_filter(vcpu, f);
+	test_with_filter(vcpu, f);
 	free(f);
 
-	ASSERT_PMC_COUNTING_INSTRUCTIONS(count);
+	ASSERT_PMC_COUNTING_INSTRUCTIONS();
 }
 
 static void test_member_deny_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
-	uint64_t count = test_with_filter(vcpu, f);
 
+	test_with_filter(vcpu, f);
 	free(f);
 
-	ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS(count);
+	ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS();
 }
 
 static void test_member_allow_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
-	uint64_t count = test_with_filter(vcpu, f);
 
+	test_with_filter(vcpu, f);
 	free(f);
 
-	ASSERT_PMC_COUNTING_INSTRUCTIONS(count);
+	ASSERT_PMC_COUNTING_INSTRUCTIONS();
 }
 
 static void test_not_member_deny_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
-	uint64_t count;
 
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
-	count = test_with_filter(vcpu, f);
+	test_with_filter(vcpu, f);
 	free(f);
 
-	ASSERT_PMC_COUNTING_INSTRUCTIONS(count);
+	ASSERT_PMC_COUNTING_INSTRUCTIONS();
 }
 
 static void test_not_member_allow_list(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
-	uint64_t count;
 
 	remove_event(f, INTEL_BR_RETIRED);
 	remove_event(f, AMD_ZEN_BR_RETIRED);
-	count = test_with_filter(vcpu, f);
+	test_with_filter(vcpu, f);
 	free(f);
 
-	ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS(count);
+	ASSERT_PMC_NOT_COUNTING_INSTRUCTIONS();
 }
 
 /*
@@ -458,51 +475,30 @@ static bool supports_event_mem_inst_retired(void)
 #define EXCLUDE_MASKED_ENTRY(event_select, mask, match) \
 	KVM_PMU_ENCODE_MASKED_ENTRY(event_select, mask, match, true)
 
-struct perf_counter {
-	union {
-		uint64_t raw;
-		struct {
-			uint64_t loads:22;
-			uint64_t stores:22;
-			uint64_t loads_stores:20;
-		};
-	};
-};
-
-static uint64_t masked_events_guest_test(uint32_t msr_base)
+static void masked_events_guest_test(uint32_t msr_base)
 {
-	uint64_t ld0, ld1, st0, st1, ls0, ls1;
-	struct perf_counter c;
-	int val;
-
 	/*
-	 * The acutal value of the counters don't determine the outcome of
+	 * The actual value of the counters don't determine the outcome of
 	 * the test.  Only that they are zero or non-zero.
 	 */
-	ld0 = rdmsr(msr_base + 0);
-	st0 = rdmsr(msr_base + 1);
-	ls0 = rdmsr(msr_base + 2);
+	const uint64_t loads = rdmsr(msr_base + 0);
+	const uint64_t stores = rdmsr(msr_base + 1);
+	const uint64_t loads_stores = rdmsr(msr_base + 2);
+	int val;
+
 
 	__asm__ __volatile__("movl $0, %[v];"
 			     "movl %[v], %%eax;"
 			     "incl %[v];"
 			     : [v]"+m"(val) :: "eax");
 
-	ld1 = rdmsr(msr_base + 0);
-	st1 = rdmsr(msr_base + 1);
-	ls1 = rdmsr(msr_base + 2);
-
-	c.loads = ld1 - ld0;
-	c.stores = st1 - st0;
-	c.loads_stores = ls1 - ls0;
-
-	return c.raw;
+	pmc_results.loads = rdmsr(msr_base + 0) - loads;
+	pmc_results.stores = rdmsr(msr_base + 1) - stores;
+	pmc_results.loads_stores = rdmsr(msr_base + 2) - loads_stores;
 }
 
 static void intel_masked_events_guest_code(void)
 {
-	uint64_t r;
-
 	for (;;) {
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
@@ -515,16 +511,13 @@ static void intel_masked_events_guest_code(void)
 
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
 
-		r = masked_events_guest_test(MSR_IA32_PMC0);
-
-		GUEST_SYNC(r);
+		masked_events_guest_test(MSR_IA32_PMC0);
+		GUEST_SYNC(0);
 	}
 }
 
 static void amd_masked_events_guest_code(void)
 {
-	uint64_t r;
-
 	for (;;) {
 		wrmsr(MSR_K7_EVNTSEL0, 0);
 		wrmsr(MSR_K7_EVNTSEL1, 0);
@@ -537,26 +530,22 @@ static void amd_masked_events_guest_code(void)
 		wrmsr(MSR_K7_EVNTSEL2, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | LS_DISPATCH_LOAD_STORE);
 
-		r = masked_events_guest_test(MSR_K7_PERFCTR0);
-
-		GUEST_SYNC(r);
+		masked_events_guest_test(MSR_K7_PERFCTR0);
+		GUEST_SYNC(0);
 	}
 }
 
-static struct perf_counter run_masked_events_test(struct kvm_vcpu *vcpu,
-						 const uint64_t masked_events[],
-						 const int nmasked_events)
+static void run_masked_events_test(struct kvm_vcpu *vcpu,
+				   const uint64_t masked_events[],
+				   const int nmasked_events)
 {
 	struct kvm_pmu_event_filter *f;
-	struct perf_counter r;
 
 	f = create_pmu_event_filter(masked_events, nmasked_events,
 				    KVM_PMU_EVENT_ALLOW,
 				    KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
-	r.raw = test_with_filter(vcpu, f);
+	test_with_filter(vcpu, f);
 	free(f);
-
-	return r;
 }
 
 /* Matches KVM_PMU_EVENT_FILTER_MAX_EVENTS in pmu.c */
@@ -681,7 +670,6 @@ static void run_masked_events_tests(struct kvm_vcpu *vcpu, uint64_t *events,
 				    int nevents)
 {
 	int ntests = ARRAY_SIZE(test_cases);
-	struct perf_counter c;
 	int i, n;
 
 	for (i = 0; i < ntests; i++) {
@@ -693,13 +681,15 @@ static void run_masked_events_tests(struct kvm_vcpu *vcpu, uint64_t *events,
 
 		n = append_test_events(test, events, nevents);
 
-		c = run_masked_events_test(vcpu, events, n);
-		TEST_ASSERT(bool_eq(c.loads, test->flags & ALLOW_LOADS) &&
-			    bool_eq(c.stores, test->flags & ALLOW_STORES) &&
-			    bool_eq(c.loads_stores,
+		run_masked_events_test(vcpu, events, n);
+
+		TEST_ASSERT(bool_eq(pmc_results.loads, test->flags & ALLOW_LOADS) &&
+			    bool_eq(pmc_results.stores, test->flags & ALLOW_STORES) &&
+			    bool_eq(pmc_results.loads_stores,
 				    test->flags & ALLOW_LOADS_STORES),
-			    "%s  loads: %u, stores: %u, loads + stores: %u",
-			    test->msg, c.loads, c.stores, c.loads_stores);
+			    "%s  loads: %lu, stores: %lu, loads + stores: %lu",
+			    test->msg, pmc_results.loads, pmc_results.stores,
+			    pmc_results.loads_stores);
 	}
 }
 
-- 
2.40.0.577.gac1e443424-goog

