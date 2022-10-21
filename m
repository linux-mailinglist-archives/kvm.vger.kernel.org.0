Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74745608050
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJUUvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiJUUvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:51:41 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28ED2892E1
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e10-20020a17090301ca00b00183d123e2a5so2260234plh.14
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+NUq1pnmzHdXnrMvd4KmYhaXcmeq2zps0wpBk//Fn7g=;
        b=ITpGVEkh6yyr27L8Ucc5XIGyQ2RHX0gs6QFp+TTv86sLbTx1BCMuQSBjq8mV1EsC4T
         rEFCVj+zRRnvrh2SwZJ3PKN+5C5VbixXh39J4Qv8WzXSZOhUUJ2/dFm+P23iZyPxR9cN
         XFuRtfoZUsBKfixwQMwXO3qBtkhtsowPTpEj+LKvmVkjTeYb0KjZ2S3H5UQVff2BwZuD
         5A5Yo99UpgsxprJOwb5QIGOHg36T2bnzKKU1YW7muaWoiw+MnjzM/zEdfQCIETs8MwcY
         QUdzZYmveHH3VEkGDIIxvHLqSiQU1875UrcBElEjFQ9N+SWV+4Mc2PofsTrY2Y3teLYd
         xUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+NUq1pnmzHdXnrMvd4KmYhaXcmeq2zps0wpBk//Fn7g=;
        b=V02G/jFM4qpk9VLpQVUePjXp/SIH2gK1Rf49gmRmLCLCFntUoOC3ePEYnh+fjWFibG
         TS6utbyw9T7HMUQ07o0NbCgRi0uM/bDmZKW9v2Zfo8z1r83guDj02xExmbAwJuaSKQRj
         Oykz3g+0QSX3hSEb62X1/9TNaXQM7Wx+BBOI1M1/F1tP8f6NetmCXof71qNWyoTrlU7B
         WlfTYcE+8/HTiqj6RX6u9SpiVLqhVDj1BszqtxSPzkUG4krqoDkyK6jBX9fwGCneVn6n
         93XdOWdZY1TwaRPeOyij4MNm5UCLgBZLKMu9ePxH5di6V7CXUssBPBLR8MYdNimJxJrK
         C8zg==
X-Gm-Message-State: ACrzQf0zUNrh4c3CTBfVKfcUtiLmFBf2B8LXGYw2UA1KJIsBr1MsgOcg
        RSh5PV1o3dSZJvhSgIyeR9CeuK/a0CzS3poyQGSBno7xXr0is+Wr/UjouOk7a0Gzo0BaqiJx6Km
        I2OG7nPIXdMyotiOWNTl9jjGYY1sBr2Y6WYQ6rdFdI/sjHQGsoqip6FdnOFRgyDfA8KmY
X-Google-Smtp-Source: AMsMyM7pbICA5w9nrLq/9c3D9CGqwq/2+bZGoZVGgpjpLw1tvmWYpf55bozfpg7wuXI2eUU5GV6wa/Kvf7jNt/8k
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:b944:b0:179:fdb0:1c39 with SMTP
 id h4-20020a170902b94400b00179fdb01c39mr21039281pls.98.1666385494620; Fri, 21
 Oct 2022 13:51:34 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:51:05 +0000
In-Reply-To: <20221021205105.1621014-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221021205105.1621014-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021205105.1621014-8-aaronlewis@google.com>
Subject: [PATCH v6 7/7] selftests: kvm/x86: Test masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add testing to show that a pmu event can be filtered with a generalized
match on it's unit mask.

These tests set up test cases to demonstrate various ways of filtering
a pmu event that has multiple unit mask values.  It does this by
setting up the filter in KVM with the masked events provided, then
enabling three pmu counters in the guest.  The test then verifies that
the pmu counters agree with which counters should be counting and which
counters should be filtered for both a sparse filter list and a dense
filter list.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 344 +++++++++++++++++-
 1 file changed, 342 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 0750e2fa7a38..926c449aac78 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -442,6 +442,337 @@ static bool use_amd_pmu(void)
 		 is_zen3(entry->eax));
 }
 
+/*
+ * "MEM_INST_RETIRED.ALL_LOADS", "MEM_INST_RETIRED.ALL_STORES", and
+ * "MEM_INST_RETIRED.ANY" from https://perfmon-events.intel.com/
+ * supported on Intel Xeon processors:
+ *  - Sapphire Rapids, Ice Lake, Cascade Lake, Skylake.
+ */
+#define MEM_INST_RETIRED		0xD0
+#define MEM_INST_RETIRED_LOAD		EVENT(MEM_INST_RETIRED, 0x81)
+#define MEM_INST_RETIRED_STORE		EVENT(MEM_INST_RETIRED, 0x82)
+#define MEM_INST_RETIRED_LOAD_STORE	EVENT(MEM_INST_RETIRED, 0x83)
+
+static bool supports_event_mem_inst_retired(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+
+	cpuid(1, &eax, &ebx, &ecx, &edx);
+	if (x86_family(eax) == 0x6) {
+		switch (x86_model(eax)) {
+		/* Sapphire Rapids */
+		case 0x8F:
+		/* Ice Lake */
+		case 0x6A:
+		/* Skylake */
+		/* Cascade Lake */
+		case 0x55:
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static int num_gp_counters(void)
+{
+	const struct kvm_cpuid_entry2 *entry;
+
+	entry = kvm_get_supported_cpuid_entry(0xa);
+	union cpuid10_eax eax = { .full = entry->eax };
+
+	return eax.split.num_counters;
+}
+
+/*
+ * "LS Dispatch", from Processor Programming Reference
+ * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
+ * Preliminary Processor Programming Reference (PPR) for AMD Family
+ * 17h Model 31h, Revision B0 Processors, and Preliminary Processor
+ * Programming Reference (PPR) for AMD Family 19h Model 01h, Revision
+ * B1 Processors Volume 1 of 2.
+ */
+#define LS_DISPATCH		0x29
+#define LS_DISPATCH_LOAD	EVENT(LS_DISPATCH, BIT(0))
+#define LS_DISPATCH_STORE	EVENT(LS_DISPATCH, BIT(1))
+#define LS_DISPATCH_LOAD_STORE	EVENT(LS_DISPATCH, BIT(2))
+
+#define INCLUDE_MASKED_ENTRY(event_select, mask, match) \
+	KVM_PMU_ENCODE_MASKED_ENTRY(event_select, mask, match, false)
+#define EXCLUDE_MASKED_ENTRY(event_select, mask, match) \
+	KVM_PMU_ENCODE_MASKED_ENTRY(event_select, mask, match, true)
+
+struct perf_counter {
+	union {
+		uint64_t raw;
+		struct {
+			uint64_t loads:22;
+			uint64_t stores:22;
+			uint64_t loads_stores:20;
+		};
+	};
+};
+
+static uint64_t masked_events_guest_test(uint32_t msr_base)
+{
+	uint64_t ld0, ld1, st0, st1, ls0, ls1;
+	struct perf_counter c;
+	int val;
+
+	ld0 = rdmsr(msr_base + 0);
+	st0 = rdmsr(msr_base + 1);
+	ls0 = rdmsr(msr_base + 2);
+
+	__asm__ __volatile__("movl $0, %[v];"
+			     "movl %[v], %%eax;"
+			     "incl %[v];"
+			     : [v]"+m"(val) :: "eax");
+
+	ld1 = rdmsr(msr_base + 0);
+	st1 = rdmsr(msr_base + 1);
+	ls1 = rdmsr(msr_base + 2);
+
+	c.loads = ld1 - ld0;
+	c.stores = st1 - st0;
+	c.loads_stores = ls1 - ls0;
+
+	return c.raw;
+}
+
+static void intel_masked_events_guest_code(void)
+{
+	uint64_t r;
+
+	for (;;) {
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+		wrmsr(MSR_P6_EVNTSEL0 + 0, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | MEM_INST_RETIRED_LOAD);
+		wrmsr(MSR_P6_EVNTSEL0 + 1, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | MEM_INST_RETIRED_STORE);
+		wrmsr(MSR_P6_EVNTSEL0 + 2, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | MEM_INST_RETIRED_LOAD_STORE);
+
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
+
+		r = masked_events_guest_test(MSR_IA32_PMC0);
+
+		GUEST_SYNC(r);
+	}
+}
+
+static void amd_masked_events_guest_code(void)
+{
+	uint64_t r;
+
+	for (;;) {
+		wrmsr(MSR_K7_EVNTSEL0, 0);
+		wrmsr(MSR_K7_EVNTSEL1, 0);
+		wrmsr(MSR_K7_EVNTSEL2, 0);
+
+		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | LS_DISPATCH_LOAD);
+		wrmsr(MSR_K7_EVNTSEL1, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | LS_DISPATCH_STORE);
+		wrmsr(MSR_K7_EVNTSEL2, ARCH_PERFMON_EVENTSEL_ENABLE |
+		      ARCH_PERFMON_EVENTSEL_OS | LS_DISPATCH_LOAD_STORE);
+
+		r = masked_events_guest_test(MSR_K7_PERFCTR0);
+
+		GUEST_SYNC(r);
+	}
+}
+
+static struct perf_counter run_masked_events_test(struct kvm_vcpu *vcpu,
+						 const uint64_t masked_events[],
+						 const int nmasked_events)
+{
+	struct kvm_pmu_event_filter *f;
+	struct perf_counter r;
+
+	f = create_pmu_event_filter(masked_events, nmasked_events,
+				    KVM_PMU_EVENT_ALLOW,
+				    KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	r.raw = test_with_filter(vcpu, f);
+	free(f);
+
+	return r;
+}
+
+/* Matches KVM_PMU_EVENT_FILTER_MAX_EVENTS in pmu.c */
+#define MAX_FILTER_EVENTS	300
+#define MAX_TEST_EVENTS		10
+
+#define ALLOW_LOADS		BIT(0)
+#define ALLOW_STORES		BIT(1)
+#define ALLOW_LOADS_STORES	BIT(2)
+
+struct masked_events_test {
+	uint64_t intel_events[MAX_TEST_EVENTS];
+	uint64_t intel_event_end;
+	uint64_t amd_events[MAX_TEST_EVENTS];
+	uint64_t amd_event_end;
+	const char *msg;
+	uint32_t flags;
+};
+
+/*
+ * These are the test cases for the masked events tests.
+ *
+ * For each test, the guest enables 3 PMU counters (loads, stores,
+ * loads + stores).  The filter is then set in KVM with the masked events
+ * provided.  The test then verifies that the counters agree with which
+ * ones should be counting and which ones should be filtered.
+ */
+const struct masked_events_test test_cases[] = {
+	{
+		.intel_events = {
+			INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x81),
+		},
+		.amd_events = {
+			INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(0)),
+		},
+		.msg = "Only allow loads.",
+		.flags = ALLOW_LOADS,
+	}, {
+		.intel_events = {
+			INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x82),
+		},
+		.amd_events = {
+			INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(1)),
+		},
+		.msg = "Only allow stores.",
+		.flags = ALLOW_STORES,
+	}, {
+		.intel_events = {
+			INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x83),
+		},
+		.amd_events = {
+			INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(2)),
+		},
+		.msg = "Only allow loads + stores.",
+		.flags = ALLOW_LOADS_STORES,
+	}, {
+		.intel_events = {
+			INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0x7C, 0),
+			EXCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x83),
+		},
+		.amd_events = {
+			INCLUDE_MASKED_ENTRY(LS_DISPATCH, ~(BIT(0) | BIT(1)), 0),
+		},
+		.msg = "Only allow loads and stores.",
+		.flags = ALLOW_LOADS | ALLOW_STORES,
+	}, {
+		.intel_events = {
+			INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0x7C, 0),
+			EXCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFF, 0x82),
+		},
+		.amd_events = {
+			INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xF8, 0),
+			EXCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(1)),
+		},
+		.msg = "Only allow loads and loads + stores.",
+		.flags = ALLOW_LOADS | ALLOW_LOADS_STORES
+	}, {
+		.intel_events = {
+			INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0xFE, 0x82),
+		},
+		.amd_events = {
+			INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xF8, 0),
+			EXCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xFF, BIT(0)),
+		},
+		.msg = "Only allow stores and loads + stores.",
+		.flags = ALLOW_STORES | ALLOW_LOADS_STORES
+	}, {
+		.intel_events = {
+			INCLUDE_MASKED_ENTRY(MEM_INST_RETIRED, 0x7C, 0),
+		},
+		.amd_events = {
+			INCLUDE_MASKED_ENTRY(LS_DISPATCH, 0xF8, 0),
+		},
+		.msg = "Only allow loads, stores, and loads + stores.",
+		.flags = ALLOW_LOADS | ALLOW_STORES | ALLOW_LOADS_STORES
+	},
+};
+
+static int append_test_events(const struct masked_events_test *test,
+			      uint64_t *events, int nevents)
+{
+	const uint64_t *evts;
+	int i;
+
+	evts = use_intel_pmu() ? test->intel_events : test->amd_events;
+	for (i = 0; i < MAX_TEST_EVENTS; i++) {
+		if (evts[i] == 0)
+			break;
+
+		events[nevents + i] = evts[i];
+	}
+
+	return nevents + i;
+}
+
+static bool bool_eq(bool a, bool b)
+{
+	return a == b;
+}
+
+static void run_masked_events_tests(struct kvm_vcpu *vcpu, uint64_t *events,
+				    int nevents)
+{
+	int ntests = ARRAY_SIZE(test_cases);
+	struct perf_counter c;
+	int i, n;
+
+	for (i = 0; i < ntests; i++) {
+		const struct masked_events_test *test = &test_cases[i];
+
+		/* Do any test case events overflow MAX_TEST_EVENTS? */
+		assert(test->intel_event_end == 0);
+		assert(test->amd_event_end == 0);
+
+		n = append_test_events(test, events, nevents);
+
+		c = run_masked_events_test(vcpu, events, n);
+		TEST_ASSERT(bool_eq(c.loads, test->flags & ALLOW_LOADS) &&
+			    bool_eq(c.stores, test->flags & ALLOW_STORES) &&
+			    bool_eq(c.loads_stores,
+				    test->flags & ALLOW_LOADS_STORES),
+			    "%s  loads: %u, stores: %u, loads + stores: %u",
+			    test->msg, c.loads, c.stores, c.loads_stores);
+	}
+}
+
+static void add_dummy_events(uint64_t *events, int nevents)
+{
+	int i;
+
+	for (i = 0; i < nevents; i++) {
+		int event_select = i % 0xFF;
+		bool exclude = ((i % 4) == 0);
+
+		if (event_select == MEM_INST_RETIRED ||
+		    event_select == LS_DISPATCH)
+			event_select++;
+
+		events[i] = KVM_PMU_ENCODE_MASKED_ENTRY(event_select, 0,
+							0, exclude);
+	}
+}
+
+static void test_masked_events(struct kvm_vcpu *vcpu)
+{
+	int nevents = MAX_FILTER_EVENTS - MAX_TEST_EVENTS;
+	uint64_t events[MAX_FILTER_EVENTS];
+
+	/* Run the test cases against a sparse PMU event filter. */
+	run_masked_events_tests(vcpu, events, 0);
+
+	/* Run the test cases against a dense PMU event filter. */
+	add_dummy_events(events, MAX_FILTER_EVENTS);
+	run_masked_events_tests(vcpu, events, nevents);
+}
+
 static int run_filter_test(struct kvm_vcpu *vcpu, const uint64_t *events,
 			   int nevents, uint32_t flags)
 {
@@ -470,7 +801,7 @@ static void test_filter_ioctl(struct kvm_vcpu *vcpu)
 	r = run_filter_test(vcpu, &e, 1, KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
 	TEST_ASSERT(r != 0, "Invalid PMU Event Filter is expected to fail");
 
-	e = KVM_PMU_EVENT_ENCODE_MASKED_ENTRY(0xff, 0xff, 0xff, 0xf);
+	e = KVM_PMU_ENCODE_MASKED_ENTRY(0xff, 0xff, 0xff, 0xf);
 	r = run_filter_test(vcpu, &e, 1, KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
 	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
 }
@@ -478,7 +809,7 @@ static void test_filter_ioctl(struct kvm_vcpu *vcpu)
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void);
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu, *vcpu2 = NULL;
 	struct kvm_vm *vm;
 
 	/* Tell stdout not to buffer its content */
@@ -506,6 +837,15 @@ int main(int argc, char *argv[])
 	test_not_member_deny_list(vcpu);
 	test_not_member_allow_list(vcpu);
 
+	if (use_intel_pmu() &&
+	    supports_event_mem_inst_retired() &&
+	    num_gp_counters() >= 3)
+		vcpu2 = vm_vcpu_add(vm, 2, intel_masked_events_guest_code);
+	else if (use_amd_pmu())
+		vcpu2 = vm_vcpu_add(vm, 2, amd_masked_events_guest_code);
+
+	if (vcpu2)
+		test_masked_events(vcpu2);
 	test_filter_ioctl(vcpu);
 
 	kvm_vm_free(vm);
-- 
2.38.0.135.g90850a2211-goog

