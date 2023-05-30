Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224DB716260
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 15:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjE3NnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 09:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbjE3NnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 09:43:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01E5C7;
        Tue, 30 May 2023 06:43:19 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-64d5f65a2f7so3273008b3a.1;
        Tue, 30 May 2023 06:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454199; x=1688046199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TkeHipjU/WOmNcf2agkrfrA9ywo3jxvZYQ67k2ChX2Q=;
        b=Ggx7A7nu8hMYGnS0JNBq61x6vI4SEOq4OH0T1r/gjftJl7123I6eZD6VfJj41ANsjq
         mIQn8JXbo91yRk0i9Nv3N76NloD/p5wYtNX36Ff8GwA8UXebnzZP/5G1SDOKZM86AYHJ
         GaJw2yIleGYnVq/bqFCKjUJyK4hnVRpqoxDqn+enZwsqvJikEDTMiNhOrJovAa8AxQb8
         VfkVSQ+q1TC7fOA9Aoe0id1EZ9NGLWL2LNUNHZdxjmKpgPCgFFRLvrWkMo9RlD0TLHFe
         xGf9hV8q/MyicyQKdMvdIzJGBSssZXz1/lgqVECxSxwRq3h05krRkftWJatJ+aOhpb85
         aAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454199; x=1688046199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TkeHipjU/WOmNcf2agkrfrA9ywo3jxvZYQ67k2ChX2Q=;
        b=KHV86up92vJ/9CcCLpIsiWshX+66aSQhkH1NpBHK7+yXLBnkBKJU2LFmNLPchCAvLT
         uL6pixjfW0uAyPl9yMGLy8GpbhP62Y8dk7WILlsQ6HtJ/6I9ERp6QUPVwFMcIUMS8yXr
         jjDK1R94WCUSI+YZpmtNxl4ocD24ku1smZefC67qh+pH2sW2iekzFuhDT+l3h875SWmM
         SliD1OWjfjaRp8BuzWNbPIX3DzLpoOdy/qOuxirHWNPgW26CFW2+v1XnuKN5scIVdPgn
         HCm4Q+tkgOpzepX/GzRj0sHzJwB8amZyaAyqzeSqVBahpFMRlZksvg6AE7vpru5QSCvD
         CTZQ==
X-Gm-Message-State: AC+VfDyH6A/5xbh8l6Xg36QYJltOMdCqr0/L/ltg53zUVZM6FkO1VsKP
        lNs3ElPWXjjHv+BjknHXaZo=
X-Google-Smtp-Source: ACHHUZ4Ah6zxicMD1cULmHHkbCdXxuTzkyLV2WhU1Y/ZL0kKGWpBBaZuEaPTBusXK/OJGbKreNDGoA==
X-Received: by 2002:a05:6a21:99a7:b0:105:53:998 with SMTP id ve39-20020a056a2199a700b0010500530998mr2854299pzb.12.1685454198952;
        Tue, 30 May 2023 06:43:18 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090ac24a00b00256a4d59bfasm1977186pjx.23.2023.05.30.06.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 06:43:18 -0700 (PDT)
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
Subject: [PATCH v2 3/8] KVM: selftests: Test Intel PMU architectural events on gp counters
Date:   Tue, 30 May 2023 21:42:43 +0800
Message-Id: <20230530134248.23998-4-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530134248.23998-1-cloudliang@tencent.com>
References: <20230530134248.23998-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Add test cases to check if different Architectural events are available
after it's marked as unavailable via CPUID. It covers vPMU event filtering
logic based on Intel CPUID, which is a complement to pmu_event_filter.

According to Intel SDM, the number of architectural events is reported
through CPUID.0AH:EAX[31:24] and the architectural event x is
supported if EBX[x]=0 && EAX[31:24]>x.

Co-developed-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/pmu_basic_functionality_test.c | 168 ++++++++++++++++++
 2 files changed, 169 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 18cadc669798..f636968709c4 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -78,6 +78,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_basic_functionality_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
new file mode 100644
index 000000000000..1f100fd94d67
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
@@ -0,0 +1,168 @@
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
+#define NUM_BRANCHES 10
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
+		TEST_ASSERT(false, "Unexpected exit: %s",
+			    exit_reason_str(vcpu->run->exit_reason));
+	}
+	return uc.cmd;
+}
+
+static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
+				       uint32_t ctr_base_msr, uint64_t evt_code)
+{
+	uint32_t global_msr = MSR_CORE_PERF_GLOBAL_CTRL;
+	unsigned int i;
+
+	for (i = 0; i < max_gp_num; i++) {
+		wrmsr(ctr_base_msr + i, 0);
+		wrmsr(MSR_P6_EVNTSEL0 + i, EVENTSEL_OS | EVENTSEL_EN | evt_code);
+		if (version > 1)
+			wrmsr(global_msr, BIT_ULL(i));
+
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+
+		if (version > 1)
+			wrmsr(global_msr, 0);
+
+		GUEST_SYNC(_rdpmc(i));
+	}
+
+	GUEST_DONE();
+}
+
+static void test_arch_events_cpuid(struct kvm_vcpu *vcpu, uint8_t evt_vector,
+				   uint8_t unavl_mask, uint8_t idx)
+{
+	struct kvm_cpuid_entry2 *entry;
+	uint32_t ctr_msr = MSR_IA32_PERFCTR0;
+	bool is_supported;
+	uint64_t counter_val = 0;
+
+	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
+	entry->eax = (entry->eax & ~EVT_LEN_MASK) |
+		(evt_vector << EVT_LEN_OFS_BIT);
+	entry->ebx = (entry->ebx & ~EVENTS_MASK) | unavl_mask;
+	vcpu_set_cpuid(vcpu);
+
+	if (vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
+		ctr_msr = MSR_IA32_PMC0;
+
+	/* Arch event x is supported if EBX[x]=0 && EAX[31:24]>x */
+	is_supported = !(entry->ebx & BIT_ULL(idx)) &&
+		(((entry->eax & EVT_LEN_MASK) >> EVT_LEN_OFS_BIT) > idx);
+
+	vcpu_args_set(vcpu, 4, X86_INTEL_PMU_VERSION, X86_INTEL_MAX_GP_CTR_NUM,
+		      ctr_msr, arch_events[idx]);
+
+	while (run_vcpu(vcpu, &counter_val) != UCALL_DONE)
+		TEST_ASSERT(is_supported == !!counter_val,
+			    "Unavailable arch event is counting.");
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
+	for (i = 0; i < ARRAY_SIZE(arch_events); i++) {
+		eax_evt_vec = BIT_ULL(i);
+		for (j = 0; j < ARRAY_SIZE(arch_events); j++) {
+			ebx_unavl_mask = BIT_ULL(j);
+			vm = pmu_vm_create_with_one_vcpu(&vcpu,
+							 intel_guest_run_arch_event);
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
+	for (idx = 0; idx < ARRAY_SIZE(arch_events); idx++) {
+		/*
+		 * Given the stability of performance event recurrence,
+		 * only these arch events are currently being tested:
+		 *
+		 * - Core cycle event (idx = 0)
+		 * - Instruction retired event (idx = 1)
+		 * - Reference cycles event (idx = 2)
+		 * - Branch instruction retired event (idx = 5)
+		 *
+		 * Note that reference cycles is one event that actually cannot
+		 * be successfully virtualized.
+		 */
+		if (idx > 2 && idx != 5)
+			continue;
+
+		intel_check_arch_event_is_unavl(idx);
+	}
+}
+
+static void intel_test_pmu_cpuid(void)
+{
+	intel_test_arch_events();
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
+
+	if (host_cpu_is_intel) {
+		TEST_REQUIRE(kvm_cpu_has_p(X86_PROPERTY_PMU_VERSION));
+		TEST_REQUIRE(X86_INTEL_PMU_VERSION > 0);
+		TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
+
+		intel_test_pmu_cpuid();
+	}
+
+	return 0;
+}
-- 
2.31.1

