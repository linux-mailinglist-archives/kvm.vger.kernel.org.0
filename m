Return-Path: <kvm+bounces-3199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0EED801889
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E30D01C20A94
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A977C2F49;
	Sat,  2 Dec 2023 00:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yWcFmTbb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485B11FC4
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:50 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6cd855b6003so3763572b3a.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475490; x=1702080290; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fQKCFlRMTddXiUjWGw43tDsciec1TGCKMhPO1rpniB4=;
        b=yWcFmTbbKAKleIwxU/y4YcxzkR3DkBH4M7cstHur6uhR3WFr4ZAJjjOSlX5MG54qy5
         b96Yj4otOJoEVepAFvsR0DjvbFNXKpUSodPjiFohiQDTkulpu7GEXMImQSzdqoL9cTRI
         s6qDN+zdDeFFRWYbGXI97ziKs6H6CBCQjaEdIEJLzotfT2VDxiTWjhw1Yqm6ttu5zgKn
         D3tXy5dVHD8lLnmc6mMQ512pwGFicNEpVF5FAC9/8zP+D75buzGPCzUfNmzUIUGPBgCH
         F8N7hm8icOPuGNwQOiTu0oLA9ccoVZ9TibBnBigV21Xdd+/PytkoM/xNqNTblmztUkh+
         oZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475490; x=1702080290;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fQKCFlRMTddXiUjWGw43tDsciec1TGCKMhPO1rpniB4=;
        b=Osp408X+dpEr8BoU9uSbWcz/SItqrhPSW8eqTqSgUf5CEDfN/ibdXvyNaRM1M5yk4N
         FfULbQFcfc3CcpwTUvII3ZbEaHXLxj5W1ZP476FfSjlLpiGvrteGVo4k/dFmRoJ+hj7m
         oJ0dg1mMYzkb/gLoqx2tkXWPNy182MYFuuDTq4tbVwbN79uD2UbJ0/UUcFruwIdEkqUq
         stCol7yQwpQKmtnsfp3Ta1+z1+3td92oYyOA+2p+FG2S2B72ssckUmtuhNmFRPPBh4N7
         TTZrAG+6a5FntDPwvQUw1njOducK9rcuV4I/X6GAZ1M7SZ2Lp0XM5scTT/G9eAVgMnZP
         LWJw==
X-Gm-Message-State: AOJu0YwwTyLwopgKbQfXeQf0f0h+THM9yM8Gfe5aZXPY9VAnKGulJCZb
	AAezE8X0OgsxyzeLPszq3QuzA5THcrQ=
X-Google-Smtp-Source: AGHT+IGVeuxUH1II7ZW1JxdF8SBASqbcDcWS39wrqxjsTD2ZHL7sGeibq4LYIvDew45l6LyUGnG4xUy+ow8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3991:b0:6bc:f819:fcf6 with SMTP id
 fi17-20020a056a00399100b006bcf819fcf6mr6290038pfb.5.1701475489746; Fri, 01
 Dec 2023 16:04:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:04 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-16-seanjc@google.com>
Subject: [PATCH v9 15/28] KVM: selftests: Test Intel PMU architectural events
 on gp counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Add test cases to verify that Intel's Architectural PMU events work as
expected when they are available according to guest CPUID.  Iterate over a
range of sane PMU versions, with and without full-width writes enabled,
and over interesting combinations of lengths/masks for the bit vector that
enumerates unavailable events.

Test up to vPMU version 5, i.e. the current architectural max.  KVM only
officially supports up to version 2, but the behavior of the counters is
backwards compatible, i.e. KVM shouldn't do something completely different
for a higher, architecturally-defined vPMU version.  Verify KVM behavior
against the effective vPMU version, e.g. advertising vPMU 5 when KVM only
supports vPMU 2 shouldn't magically unlock vPMU 5 features.

According to Intel SDM, the number of architectural events is reported
through CPUID.0AH:EAX[31:24] and the architectural event x is supported
if EBX[x]=0 && EAX[31:24]>x.

Handcode the entirety of the measured section so that the test can
precisely assert on the number of instructions and branches retired.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 321 ++++++++++++++++++
 2 files changed, 322 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ccc354882d1a..65d9b7c7ff54 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -90,6 +90,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_counters_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/private_mem_conversions_test
 TEST_GEN_PROGS_x86_64 += x86_64/private_mem_kvm_exits_test
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
new file mode 100644
index 000000000000..5b8687bb4639
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -0,0 +1,321 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023, Tencent, Inc.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <x86intrin.h>
+
+#include "pmu.h"
+#include "processor.h"
+
+/* Number of LOOP instructions for the guest measurement payload. */
+#define NUM_BRANCHES		10
+/*
+ * Number of "extra" instructions that will be counted, i.e. the number of
+ * instructions that are needed to set up the loop and then disabled the
+ * counter.  2 MOV, 2 XOR, 1 WRMSR.
+ */
+#define NUM_EXTRA_INSNS		5
+#define NUM_INSNS_RETIRED	(NUM_BRANCHES + NUM_EXTRA_INSNS)
+
+static uint8_t kvm_pmu_version;
+static bool kvm_has_perf_caps;
+
+static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
+						  void *guest_code,
+						  uint8_t pmu_version,
+						  uint64_t perf_capabilities)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(vcpu, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(*vcpu);
+
+	sync_global_to_guest(vm, kvm_pmu_version);
+
+	/*
+	 * Set PERF_CAPABILITIES before PMU version as KVM disallows enabling
+	 * features via PERF_CAPABILITIES if the guest doesn't have a vPMU.
+	 */
+	if (kvm_has_perf_caps)
+		vcpu_set_msr(*vcpu, MSR_IA32_PERF_CAPABILITIES, perf_capabilities);
+
+	vcpu_set_cpuid_property(*vcpu, X86_PROPERTY_PMU_VERSION, pmu_version);
+	return vm;
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	do {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_PRINTF:
+			pr_info("%s", uc.buffer);
+			break;
+		case UCALL_DONE:
+			break;
+		default:
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+		}
+	} while (uc.cmd != UCALL_DONE);
+}
+
+static uint8_t guest_get_pmu_version(void)
+{
+	/*
+	 * Return the effective PMU version, i.e. the minimum between what KVM
+	 * supports and what is enumerated to the guest.  The host deliberately
+	 * advertises a PMU version to the guest beyond what is actually
+	 * supported by KVM to verify KVM doesn't freak out and do something
+	 * bizarre with an architecturally valid, but unsupported, version.
+	 */
+	return min_t(uint8_t, kvm_pmu_version, this_cpu_property(X86_PROPERTY_PMU_VERSION));
+}
+
+/*
+ * If an architectural event is supported and guaranteed to generate at least
+ * one "hit, assert that its count is non-zero.  If an event isn't supported or
+ * the test can't guarantee the associated action will occur, then all bets are
+ * off regarding the count, i.e. no checks can be done.
+ *
+ * Sanity check that in all cases, the event doesn't count when it's disabled,
+ * and that KVM correctly emulates the write of an arbitrary value.
+ */
+static void guest_assert_event_count(uint8_t idx,
+				     struct kvm_x86_pmu_feature event,
+				     uint32_t pmc, uint32_t pmc_msr)
+{
+	uint64_t count;
+
+	count = _rdpmc(pmc);
+	if (!this_pmu_has(event))
+		goto sanity_checks;
+
+	switch (idx) {
+	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
+		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
+		break;
+	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
+		GUEST_ASSERT_EQ(count, NUM_BRANCHES);
+		break;
+	case INTEL_ARCH_CPU_CYCLES_INDEX:
+	case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
+		GUEST_ASSERT_NE(count, 0);
+		break;
+	default:
+		break;
+	}
+
+sanity_checks:
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+	GUEST_ASSERT_EQ(_rdpmc(pmc), count);
+
+	wrmsr(pmc_msr, 0xdead);
+	GUEST_ASSERT_EQ(_rdpmc(pmc), 0xdead);
+}
+
+static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature event,
+				    uint32_t pmc, uint32_t pmc_msr,
+				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
+{
+	wrmsr(pmc_msr, 0);
+
+	/*
+	 * Enable and disable the PMC in a monolithic asm blob to ensure that
+	 * the compiler can't insert _any_ code into the measured sequence.
+	 * Note, ECX doesn't need to be clobbered as the input value, @pmc_msr,
+	 * is restored before the end of the sequence.
+	 */
+	__asm__ __volatile__("wrmsr\n\t"
+			     "mov $" __stringify(NUM_BRANCHES) ", %%ecx\n\t"
+			     "loop .\n\t"
+			     "mov %%edi, %%ecx\n\t"
+			     "xor %%eax, %%eax\n\t"
+			     "xor %%edx, %%edx\n\t"
+			     "wrmsr\n\t"
+			     :: "a"((uint32_t)ctrl_msr_value),
+				"d"(ctrl_msr_value >> 32),
+				"c"(ctrl_msr), "D"(ctrl_msr)
+			     );
+
+	guest_assert_event_count(idx, event, pmc, pmc_msr);
+}
+
+static void guest_test_arch_event(uint8_t idx)
+{
+	const struct {
+		struct kvm_x86_pmu_feature gp_event;
+	} intel_event_to_feature[] = {
+		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES },
+		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED },
+		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES },
+		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES },
+		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES },
+		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED },
+		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED },
+		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS },
+	};
+
+	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	uint32_t pmu_version = guest_get_pmu_version();
+	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
+	bool guest_has_perf_global_ctrl = pmu_version >= 2;
+	struct kvm_x86_pmu_feature gp_event;
+	uint32_t base_pmc_msr;
+	unsigned int i;
+
+	/* The host side shouldn't invoke this without a guest PMU. */
+	GUEST_ASSERT(pmu_version);
+
+	if (this_cpu_has(X86_FEATURE_PDCM) &&
+	    rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+		base_pmc_msr = MSR_IA32_PMC0;
+	else
+		base_pmc_msr = MSR_IA32_PERFCTR0;
+
+	gp_event = intel_event_to_feature[idx].gp_event;
+	GUEST_ASSERT_EQ(idx, gp_event.f.bit);
+
+	GUEST_ASSERT(nr_gp_counters);
+
+	for (i = 0; i < nr_gp_counters; i++) {
+		uint64_t eventsel = ARCH_PERFMON_EVENTSEL_OS |
+				    ARCH_PERFMON_EVENTSEL_ENABLE |
+				    intel_pmu_arch_events[idx];
+
+		wrmsr(MSR_P6_EVNTSEL0 + i, 0);
+		if (guest_has_perf_global_ctrl)
+			wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
+
+		__guest_test_arch_event(idx, gp_event, i, base_pmc_msr + i,
+					MSR_P6_EVNTSEL0 + i, eventsel);
+	}
+}
+
+static void guest_test_arch_events(void)
+{
+	uint8_t i;
+
+	for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++)
+		guest_test_arch_event(i);
+
+	GUEST_DONE();
+}
+
+static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
+			     uint8_t length, uint8_t unavailable_mask)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Testing arch events requires a vPMU (there are no negative tests). */
+	if (!pmu_version)
+		return;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_arch_events,
+					 pmu_version, perf_capabilities);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH,
+				length);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EVENTS_MASK,
+				unavailable_mask);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+static void test_intel_counters(void)
+{
+	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
+	unsigned int i;
+	uint8_t v, j;
+	uint32_t k;
+
+	const uint64_t perf_caps[] = {
+		0,
+		PMU_CAP_FW_WRITES,
+	};
+
+	/*
+	 * Test up to PMU v5, which is the current maximum version defined by
+	 * Intel, i.e. is the last version that is guaranteed to be backwards
+	 * compatible with KVM's existing behavior.
+	 */
+	uint8_t max_pmu_version = max_t(typeof(pmu_version), pmu_version, 5);
+
+	/*
+	 * Detect the existence of events that aren't supported by selftests.
+	 * This will (obviously) fail any time the kernel adds support for a
+	 * new event, but it's worth paying that price to keep the test fresh.
+	 */
+	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
+		    "New architectural event(s) detected; please update this test (length = %u, mask = %x)",
+		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
+
+	/*
+	 * Force iterating over known arch events regardless of whether or not
+	 * KVM/hardware supports a given event.
+	 */
+	nr_arch_events = max_t(typeof(nr_arch_events), nr_arch_events, NR_INTEL_ARCH_EVENTS);
+
+	for (v = 0; v <= max_pmu_version; v++) {
+		for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
+			if (!kvm_has_perf_caps && perf_caps[i])
+				continue;
+
+			pr_info("Testing arch events, PMU version %u, perf_caps = %lx\n",
+				v, perf_caps[i]);
+			/*
+			 * To keep the total runtime reasonable, test every
+			 * possible non-zero, non-reserved bitmap combination
+			 * only with the native PMU version and the full bit
+			 * vector length.
+			 */
+			if (v == pmu_version) {
+				for (k = 1; k < (BIT(nr_arch_events) - 1); k++)
+					test_arch_events(v, perf_caps[i], nr_arch_events, k);
+			}
+			/*
+			 * Test single bits for all PMU version and lengths up
+			 * the number of events +1 (to verify KVM doesn't do
+			 * weird things if the guest length is greater than the
+			 * host length).  Explicitly test a mask of '0' and all
+			 * ones i.e. all events being available and unavailable.
+			 */
+			for (j = 0; j <= nr_arch_events + 1; j++) {
+				test_arch_events(v, perf_caps[i], j, 0);
+				test_arch_events(v, perf_caps[i], j, 0xff);
+
+				for (k = 0; k < nr_arch_events; k++)
+					test_arch_events(v, perf_caps[i], j, BIT(k));
+			}
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+
+	TEST_REQUIRE(host_cpu_is_intel);
+	TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
+	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+
+	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
+	kvm_has_perf_caps = kvm_cpu_has(X86_FEATURE_PDCM);
+
+	test_intel_counters();
+
+	return 0;
+}
-- 
2.43.0.rc2.451.g8631bc7472-goog


