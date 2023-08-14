Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370E277B7D0
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjHNLwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjHNLvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:36 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C045110CE;
        Mon, 14 Aug 2023 04:51:32 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id 5614622812f47-3a7aedc57ffso3358899b6e.2;
        Mon, 14 Aug 2023 04:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013892; x=1692618692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TqYglirc6iqEIKO+wO9Xn7uOILA+ARNWEmI7KJ7F4M=;
        b=RFEzIm7P8aQRy+dmBC9a1djzShGMtfQiHVqQ240yzY6nDAGwlHB1FVRTAu6/z5AmL3
         5mfalY5AowD/VRzE7mUH7ZnfZT/QWx+ZB7mNE6/cbV+frzhhZLknZreBtg4TcWW63224
         lnYTenXDUMQEmy/p0XToNpcjdv3+gUuJGs5/hrQ8vH5LpwAT8NrElzaH7tn0mtnH4pK7
         HfFY7I1d0ONPKGcC3r0IlCuxuKm4IpesSiP+TfyNU++BDhY2915LDTxmWESmmoRxPaVC
         BiQTbRK/+imXX2OPkIWUaEdb6GTNYFPLrkWTj+6aVF9DPu4ATZaJz7ELkGvrOBqOOc8D
         7oAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013892; x=1692618692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9TqYglirc6iqEIKO+wO9Xn7uOILA+ARNWEmI7KJ7F4M=;
        b=FW7voQUOx/QHeF3WEtaKDBedbfZxN2t9BujTCAM46bz1OnXdQSbxyuVuNPF9Kg3nLz
         6Nw60XmUF0VHp6Mc8mcbPoc90jsiNiENiJ7QBjr7XMakDi7NlX0oZeLpbNr+BdxZS48J
         t+buKpEEhzN/QEixDYXUdAAVpds8KV4FHMN0ekN/Z8Jta27clVhQwfFEfmJYKNeMpvgR
         lppZGTiKQQQxmHrHMAsvsqawekVCoeqdYH8PP+Xgby55MZn+Q8orLs2+H4PwMkCnu/9j
         mzqcOzS99+JsxzaymXfdw6JTu7CwC4MWck0DBH/O0zg2svLoWsrTMDAcEgGgR5NNSMg/
         g97g==
X-Gm-Message-State: AOJu0Yx+e1DSPQvRps/acofSepRXsZI1fm1bB+3h8vKoAjX+/UtD1D/X
        R/ENsE9bi8IxnypS27fHgPw=
X-Google-Smtp-Source: AGHT+IE2TEstYAHJUFL4w+ilEpyMO371OQ50Hud9px2LSENpz9AWEEjG0yDL9EgVcMYQuMmAcVo1lA==
X-Received: by 2002:a05:6808:148b:b0:3a7:a2f4:9873 with SMTP id e11-20020a056808148b00b003a7a2f49873mr10455204oiw.35.1692013892084;
        Mon, 14 Aug 2023 04:51:32 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:31 -0700 (PDT)
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
Subject: [PATCH v3 03/11] KVM: selftests: Test Intel PMU architectural events on gp counters
Date:   Mon, 14 Aug 2023 19:51:00 +0800
Message-Id: <20230814115108.45741-4-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814115108.45741-1-cloudliang@tencent.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
 .../kvm/x86_64/pmu_basic_functionality_test.c | 158 ++++++++++++++++++
 2 files changed, 159 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 77026907968f..965a36562ef8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -80,6 +80,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_basic_functionality_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
new file mode 100644
index 000000000000..c04eb0bdf69f
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -0,0 +1,158 @@
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
+
+/* Guest payload for any performance counter counting */
+#define NUM_BRANCHES			10
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
+static uint64_t run_vcpu(struct kvm_vcpu *vcpu, uint64_t *ucall_arg)
+{
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_SYNC:
+		*ucall_arg = uc.args[1];
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+	}
+	return uc.cmd;
+}
+
+static void guest_measure_loop(uint64_t event_code)
+{
+	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
+	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
+	uint32_t counter_msr;
+	unsigned int i;
+
+	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+		counter_msr = MSR_IA32_PMC0;
+	else
+		counter_msr = MSR_IA32_PERFCTR0;
+
+	for (i = 0; i < nr_gp_counters; i++) {
+		wrmsr(counter_msr + i, 0);
+		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
+		      ARCH_PERFMON_EVENTSEL_ENABLE | event_code);
+
+		if (pmu_version > 1) {
+			wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
+			__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+			wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+			GUEST_SYNC(_rdpmc(i));
+		} else {
+			__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+			GUEST_SYNC(_rdpmc(i));
+		}
+	}
+
+	GUEST_DONE();
+}
+
+static void test_arch_events_cpuid(struct kvm_vcpu *vcpu,
+				   uint8_t arch_events_bitmap_size,
+				   uint8_t arch_events_unavailable_mask,
+				   uint8_t idx)
+{
+	uint64_t counter_val = 0;
+	bool is_supported;
+
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH,
+				arch_events_bitmap_size);
+	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EVENTS_MASK,
+				arch_events_unavailable_mask);
+
+	is_supported = arch_event_is_supported(vcpu, idx);
+	vcpu_args_set(vcpu, 1, intel_arch_events[idx]);
+
+	while (run_vcpu(vcpu, &counter_val) != UCALL_DONE)
+		TEST_ASSERT_EQ(is_supported, !!counter_val);
+}
+
+static void intel_check_arch_event_is_unavl(uint8_t idx)
+{
+	uint8_t eax_evt_vec, ebx_unavl_mask, i, j;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/*
+	 * A brute force iteration of all combinations of values is likely to
+	 * exhaust the limit of the single-threaded thread fd nums, so it's
+	 * tested here by iterating through all valid values on a single bit.
+	 */
+	for (i = 0; i < ARRAY_SIZE(intel_arch_events); i++) {
+		eax_evt_vec = BIT_ULL(i);
+		for (j = 0; j < ARRAY_SIZE(intel_arch_events); j++) {
+			ebx_unavl_mask = BIT_ULL(j);
+			vm = pmu_vm_create_with_one_vcpu(&vcpu,
+							 guest_measure_loop);
+			test_arch_events_cpuid(vcpu, eax_evt_vec,
+					       ebx_unavl_mask, idx);
+
+			kvm_vm_free(vm);
+		}
+	}
+}
+
+static void intel_test_arch_events(void)
+{
+	uint8_t idx;
+
+	for (idx = 0; idx < ARRAY_SIZE(intel_arch_events); idx++) {
+		/*
+		 * Given the stability of performance event recurrence,
+		 * only these arch events are currently being tested:
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
+		intel_check_arch_event_is_unavl(idx);
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
+	intel_test_arch_events();
+
+	return 0;
+}
-- 
2.39.3

