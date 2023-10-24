Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F2A7D43F7
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbjJXA1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbjJXA1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:27:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1526910F6
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:52 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1c9bc9e6a89so28851905ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107211; x=1698712011; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0U+dLPR8elz3+cGklc6/3G8uITKyjqrZ5KLIjMTZ3q8=;
        b=yU1A3L10BSMTA6J2kZ593aTlbJ7631hanoC4gNl2rTP6fQ7wgVbTPa3+ExDiRICWDp
         qMgaeRkd0SBl/TBpLh2yAyfp+iCgibWfqpkoUjE+gOr9roCdicYQYl6L6B71U2Z30OvF
         kCTea/DCcpUykKLj7n7gPgoLa6MJBPlGtgoS914YjvDNy98Tg+8zacG7GMlKuq+BrgwD
         JNdZ+aTz7e+WM5Xlc0XXK93E487SjI7AlRwTmFaPeUDr0zzh/npVktOJpGFirTBfrRTE
         Rod8OZtUCrH+wT5+qbFA2SVBuRsPBeu07qBozr01n2g0MnlfI629RKOwVc7mHC8uoEbR
         /K0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107211; x=1698712011;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0U+dLPR8elz3+cGklc6/3G8uITKyjqrZ5KLIjMTZ3q8=;
        b=EogD/PdQgTRJJpSxf0wwp3lSKqdIw7aIHnNFKpDrousdhtkdszpJnvwiAvCAd1Qs7K
         J4hum3udhJrw+3lMdFFuWm7av8QFlT5cjd6wHI0O9e9Bqcih1KuFv/TFpcK49f6u4s4O
         5jQPlPnPlKWBoYxJbOSPYiTyYAdyCelwh4YKjbCmKv+/nty2KBjKqBFrA/lyiZM3rPDh
         YnXTNcRMAxbbij4jr2FLEIHfstahI31rPrkD4/QGQjMGwiGxTHegPhDFaZVzT0ojXfoq
         eAAL/zJUlrSOXvrKO917tmRhLvKTMVVxCQDOIgf1mwB/Wwe51ETCDmZM3Of4Kgs7di5W
         240A==
X-Gm-Message-State: AOJu0YywV+EmVmpAYDODJ/m2HkdTqWT9hmUTl36j7kgPoGgYGkns7kwA
        yFRua666YNBwzmkDcT8VqGI9ZpBhBQo=
X-Google-Smtp-Source: AGHT+IHJPhKSTPumJNPYucEF66kLkluGKltC6POP4Mk2CjXcoY1UlV+wSJc0iVRs0oDFt6rua4PJ4SuyZNo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:64c2:b0:1cb:de60:874c with SMTP id
 y2-20020a17090264c200b001cbde60874cmr37994pli.12.1698107211277; Mon, 23 Oct
 2023 17:26:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:28 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-9-seanjc@google.com>
Subject: [PATCH v5 08/13] KVM: selftests: Test Intel PMU architectural events
 on gp counters
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

Add test cases to check if different Architectural events are available
after it's marked as unavailable via CPUID. It covers vPMU event filtering
logic based on Intel CPUID, which is a complement to pmu_event_filter.

According to Intel SDM, the number of architectural events is reported
through CPUID.0AH:EAX[31:24] and the architectural event x is supported
if EBX[x]=0 && EAX[31:24]>x.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 189 ++++++++++++++++++
 2 files changed, 190 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ed1c17cabc07..4c024fb845b4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -82,6 +82,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_counters_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
new file mode 100644
index 000000000000..2a6336b994d5
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -0,0 +1,189 @@
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
+/* Guest payload for any performance counter counting */
+#define NUM_BRANCHES		10
+
+static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
+						  void *guest_code)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_one_vcpu(vcpu, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(*vcpu);
+
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
+		case UCALL_DONE:
+			break;
+		default:
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+		}
+	} while (uc.cmd != UCALL_DONE);
+}
+
+static bool pmu_is_intel_event_stable(uint8_t idx)
+{
+	switch (idx) {
+	case INTEL_ARCH_CPU_CYCLES:
+	case INTEL_ARCH_INSTRUCTIONS_RETIRED:
+	case INTEL_ARCH_REFERENCE_CYCLES:
+	case INTEL_ARCH_BRANCHES_RETIRED:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static void guest_measure_pmu_v1(struct kvm_x86_pmu_feature event,
+				 uint32_t counter_msr, uint32_t nr_gp_counters)
+{
+	uint8_t idx = event.f.bit;
+	unsigned int i;
+
+	for (i = 0; i < nr_gp_counters; i++) {
+		wrmsr(counter_msr + i, 0);
+		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
+		      ARCH_PERFMON_EVENTSEL_ENABLE | intel_pmu_arch_events[idx]);
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+
+		if (pmu_is_intel_event_stable(idx))
+			GUEST_ASSERT_EQ(this_pmu_has(event), !!_rdpmc(i));
+
+		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
+		      !ARCH_PERFMON_EVENTSEL_ENABLE |
+		      intel_pmu_arch_events[idx]);
+		wrmsr(counter_msr + i, 0);
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+
+		if (pmu_is_intel_event_stable(idx))
+			GUEST_ASSERT(!_rdpmc(i));
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_measure_loop(uint8_t idx)
+{
+	const struct {
+		struct kvm_x86_pmu_feature gp_event;
+	} intel_event_to_feature[] = {
+		[INTEL_ARCH_CPU_CYCLES]		   = { X86_PMU_FEATURE_CPU_CYCLES },
+		[INTEL_ARCH_INSTRUCTIONS_RETIRED]  = { X86_PMU_FEATURE_INSNS_RETIRED },
+		[INTEL_ARCH_REFERENCE_CYCLES]	   = { X86_PMU_FEATURE_REFERENCE_CYCLES },
+		[INTEL_ARCH_LLC_REFERENCES]	   = { X86_PMU_FEATURE_LLC_REFERENCES },
+		[INTEL_ARCH_LLC_MISSES]		   = { X86_PMU_FEATURE_LLC_MISSES },
+		[INTEL_ARCH_BRANCHES_RETIRED]	   = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED },
+		[INTEL_ARCH_BRANCHES_MISPREDICTED] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED },
+	};
+
+	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
+	struct kvm_x86_pmu_feature gp_event;
+	uint32_t counter_msr;
+	unsigned int i;
+
+	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+		counter_msr = MSR_IA32_PMC0;
+	else
+		counter_msr = MSR_IA32_PERFCTR0;
+
+	gp_event = intel_event_to_feature[idx].gp_event;
+	TEST_ASSERT_EQ(idx, gp_event.f.bit);
+
+	if (pmu_version < 2) {
+		guest_measure_pmu_v1(gp_event, counter_msr, nr_gp_counters);
+		return;
+	}
+
+	for (i = 0; i < nr_gp_counters; i++) {
+		wrmsr(counter_msr + i, 0);
+		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
+		      ARCH_PERFMON_EVENTSEL_ENABLE |
+		      intel_pmu_arch_events[idx]);
+
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+		if (pmu_is_intel_event_stable(idx))
+			GUEST_ASSERT_EQ(this_pmu_has(gp_event), !!_rdpmc(i));
+	}
+
+	GUEST_DONE();
+}
+
+static void test_arch_events_cpuid(uint8_t i, uint8_t j, uint8_t idx)
+{
+	uint8_t arch_events_unavailable_mask = BIT_ULL(j);
+	uint8_t arch_events_bitmap_size = BIT_ULL(i);
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_measure_loop);
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH,
+				arch_events_bitmap_size);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EVENTS_MASK,
+				arch_events_unavailable_mask);
+
+	vcpu_args_set(vcpu, 1, idx);
+
+	run_vcpu(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+static void test_intel_arch_events(void)
+{
+	uint8_t idx, i, j;
+
+	for (idx = 0; idx < NR_INTEL_ARCH_EVENTS; idx++) {
+		/*
+		 * A brute force iteration of all combinations of values is
+		 * likely to exhaust the limit of the single-threaded thread
+		 * fd nums, so it's test by iterating through all valid
+		 * single-bit values.
+		 */
+		for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {
+			for (j = 0; j < NR_INTEL_ARCH_EVENTS; j++)
+				test_arch_events_cpuid(i, j, idx);
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
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
+
+	test_intel_arch_events();
+
+	return 0;
+}
-- 
2.42.0.758.gaed0368e0e-goog

