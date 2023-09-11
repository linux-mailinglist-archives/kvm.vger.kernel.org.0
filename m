Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E995279C070
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233269AbjIKUrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbjIKLop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 07:44:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B41CDD;
        Mon, 11 Sep 2023 04:44:41 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-68fc1bbc94eso792493b3a.3;
        Mon, 11 Sep 2023 04:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694432680; x=1695037480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDR1USS05ZaWV094yR9sa0VOetEqT5uMEwWNa5JimWY=;
        b=ccGwUBVegu/3OanBxyVWgZN/th7/AdeOi3E4lXNjFvSew8YbYc830030QrjKHD+RGw
         m9bDVDr4CF2xTUnNQ+BcQUqaz1zOms0z3KKEc8cyoRL+tC53jVz4lZio0++Da+Az5COg
         NQAE17/eEXtz7Zzze12S2Pk8zfmT6KZ41dAd7TROC0k9dhCAN/1hv3h60y9KCOFIsyXA
         rcuFbyvDK6/Ha5Qcx6TSRE9YUfM7l1hpeowM1WKq4sMQw3A+uIpAGbNF0OCJFAsw5JYl
         P3Eo7PXKOh3kGYfJufWwXT48AfI0iOiZO6bwgb9+4vQLq/nR3fzTGz6VweNuecOUurMj
         6pKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694432680; x=1695037480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDR1USS05ZaWV094yR9sa0VOetEqT5uMEwWNa5JimWY=;
        b=v8ES5TCvV85W5ldnfjSRT2BnR/dWvgME7b4uvBeTU4drhHcAVD7LUv79OYJEdwUgRM
         rt7AuD+bJz8S4IIwciwNOedTJ8sEJsMCH5bfS95uG6kwtif10SJ6RS20Qp9EfjsPbjmf
         vkM0huQGTZuXiCsiBPoF/VyniKzzax9S4Brix/C6sU8WIAGGC7L9uQcVWgoH+KjWEubA
         dziltbiLcglGJzLJUUDDYpRgVPdo0yMC/y5UEbxm6jknp4dXs8UyPBdyThPSYj71ie/7
         uu/glBakcLAt0+Sy1vIY85Gg7cYkNUgabzV6XBnMuWbAP97pAAlNbyAC/hLf8YYhogWI
         4YbQ==
X-Gm-Message-State: AOJu0YxEc7V759sOvUrxsKKp1GX3oeMGlVdojKbFtwFEbrX/mnus1xhQ
        g+1WSmWehNVqgjjRMXidZip7OEVrN6ujw8VE
X-Google-Smtp-Source: AGHT+IG4L7UOowUAhxrkZ+60mll+o6pQOB3OR/jpmdATQ/NsgMY17s5QX/tcSC56ddonLaDUcEYePw==
X-Received: by 2002:a05:6a20:2591:b0:155:2c91:f8e5 with SMTP id k17-20020a056a20259100b001552c91f8e5mr5098170pzd.14.1694432680546;
        Mon, 11 Sep 2023 04:44:40 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b9-20020a17090a10c900b00273f65fa424sm3855390pje.8.2023.09.11.04.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 04:44:40 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/9] KVM: selftests: Test Intel PMU architectural events on gp counters
Date:   Mon, 11 Sep 2023 19:43:42 +0800
Message-Id: <20230911114347.85882-5-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230911114347.85882-1-cloudliang@tencent.com>
References: <20230911114347.85882-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 182 ++++++++++++++++++
 2 files changed, 183 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_counters_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 172c4223b286..7768e09de96c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -81,6 +81,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_counters_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
new file mode 100644
index 000000000000..f47853f3ab84
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -0,0 +1,182 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test the consistency of the PMU's CPUID and its features
+ *
+ * Copyright (C) 2023, Tencent, Inc.
+ *
+ * Check that the VM's PMU behaviour is consistent with the
+ * VM CPUID definition.
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
+static void guest_measure_pmu_v1(uint8_t idx, uint32_t counter_msr,
+				 uint32_t nr_gp_counters, bool expect)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_gp_counters; i++) {
+		wrmsr(counter_msr + i, 0);
+		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
+		      ARCH_PERFMON_EVENTSEL_ENABLE |
+		      intel_pmu_arch_events[idx]);
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		GUEST_ASSERT_EQ(expect, !!_rdpmc(i));
+
+		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
+		      !ARCH_PERFMON_EVENTSEL_ENABLE |
+		      intel_pmu_arch_events[idx]);
+		wrmsr(counter_msr + i, 0);
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		GUEST_ASSERT(!_rdpmc(i));
+	}
+
+	GUEST_DONE();
+}
+
+static void guest_measure_loop(uint8_t idx)
+{
+	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
+	uint32_t counter_msr;
+	unsigned int i;
+	bool expect;
+
+	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+		counter_msr = MSR_IA32_PMC0;
+	else
+		counter_msr = MSR_IA32_PERFCTR0;
+
+	expect = this_pmu_has_arch_event(KVM_X86_PMU_FEATURE(UNUSED, idx));
+
+	if (pmu_version < 2) {
+		guest_measure_pmu_v1(idx, counter_msr, nr_gp_counters, expect);
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
+		GUEST_ASSERT_EQ(expect, !!_rdpmc(i));
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
+static void check_arch_event_is_unavl(uint8_t idx)
+{
+	uint8_t i, j;
+
+	/*
+	 * A brute force iteration of all combinations of values is likely to
+	 * exhaust the limit of the single-threaded thread fd nums, so it's
+	 * tested here by iterating through all valid values on a single bit.
+	 */
+	for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {
+		for (j = 0; j < NR_INTEL_ARCH_EVENTS; j++)
+			test_arch_events_cpuid(i, j, idx);
+	}
+}
+
+static void test_intel_arch_events(void)
+{
+	uint8_t idx;
+
+	for (idx = 0; idx < NR_INTEL_ARCH_EVENTS; idx++) {
+		/*
+		 * Given the stability of performance event recurrence, only
+		 * these arch events are currently being tested:
+		 *
+		 * - Core cycle event (idx = 0)
+		 * - Instruction retired event (idx = 1)
+		 * - Reference cycles event (idx = 2)
+		 * - Branch instruction retired event (idx = 5)
+		 */
+		if (idx > INTEL_ARCH_INSTRUCTIONS_RETIRED &&
+		    idx != INTEL_ARCH_BRANCHES_RETIRED)
+			continue;
+
+		check_arch_event_is_unavl(idx);
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
2.39.3

