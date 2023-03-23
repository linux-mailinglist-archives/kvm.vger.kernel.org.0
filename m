Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7F46C60AE
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 08:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjCWH1m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 03:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjCWH1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 03:27:40 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8632A6D7;
        Thu, 23 Mar 2023 00:27:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id z19so11111062plo.2;
        Thu, 23 Mar 2023 00:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679556457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHgR8WnUGtyQlzlXJoBF94+5SlpfH7HFwfB03S3iMjg=;
        b=k25/JmpULurq7a+KwS00111eD3hcJsdFkYd2R+WTM/eDcosEvnl/WTVZX/0pso7TM+
         s77HTnChysFAL+H8QdiRZBcn9kmkI3pXVcAEXNveRPsOxAN94d/2FBG1XuhP1mriRDWP
         ck03f6B9q0AfQums0mckX79XZ+wzKGFxVSZ1QsJA7fKBW9Ujh99Bq+lyLdsJr166H7Df
         3o2DpCcfyvA2ZOQQIogObdwIhu4g1b5/xTUN0z8V/ReVJ9BUwHPMkP4K6AyS0vMxr9ic
         d6MpLz5x47FVM8fG/vbW0zZB5nPCpsMbvoUk2EehRiUXHV988ujCaeYQrggr8q3Aa7R6
         Sm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679556457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHgR8WnUGtyQlzlXJoBF94+5SlpfH7HFwfB03S3iMjg=;
        b=zxbXxnyDR65mVks2BGu5FY5N1nZ9DgsOrkhx0afkbZeeByUqud812187pHfW1bWum9
         Kf20nHQHB3DeXXZlkHpYTYFRySRTkbASmmfNpXUIl/feeWxRV6iNncpnNKZqF21nYl5w
         vOpOvwnP3mPgRTtX9Cqri6Iqba7bAM7ESQRvKlUiNPcdX8b/sIijp93f91IWFm/qmK11
         i/J8+aVXW9Oo+HfY87zSBAEG9sWGB3pBGWT3V8RGSYDal2f/bzS2jPOkzVJs2+EDW8X4
         2dWYllw8wXyVRVT535yQsbPoRGq+3a2HbiyQCLMqo/kAwTC0M6mzOH3wJHxx2PaiTuM2
         jnRw==
X-Gm-Message-State: AO0yUKV32cWEwPQuI0e+Irdo6o4frur7p8JI6tJtFifkl5/8JPH4g1mt
        NbH2LZjZFD6JiYc1NokFPRo=
X-Google-Smtp-Source: AK7set9G62XWGMycWIpk9Ve2tXMtC8+bS7oASx1uWpyeNDJSPN/s2LBbyoBbZtzoRZkwRWr/QF/JPw==
X-Received: by 2002:a17:903:2345:b0:19e:cfbf:f68d with SMTP id c5-20020a170903234500b0019ecfbff68dmr6564770plh.23.1679556456689;
        Thu, 23 Mar 2023 00:27:36 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017a032d7ae4sm11645447plg.104.2023.03.23.00.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 00:27:36 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/7] KVM: selftests: Test Intel PMU architectural events on gp counters
Date:   Thu, 23 Mar 2023 15:27:08 +0800
Message-Id: <20230323072714.82289-2-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230323072714.82289-1-likexu@tencent.com>
References: <20230323072714.82289-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 202 ++++++++++++++++++
 2 files changed, 203 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 84a627c43795..8aa63081b3e6 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -78,6 +78,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
 TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
+TEST_GEN_PROGS_x86_64 += x86_64/pmu_cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
new file mode 100644
index 000000000000..faab0a91e191
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
@@ -0,0 +1,202 @@
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
+#include "processor.h"
+
+/* Guest payload for any performance counter counting */
+#define NUM_BRANCHES 10
+
+#define EVENTSEL_OS BIT_ULL(17)
+#define EVENTSEL_EN BIT_ULL(22)
+#define PMU_CAP_FW_WRITES BIT_ULL(13)
+#define EVENTS_MASK GENMASK_ULL(7, 0)
+#define PMU_VERSION_MASK GENMASK_ULL(7, 0)
+#define GP_CTR_NUM_OFS_BIT 8
+#define GP_CTR_NUM_MASK GENMASK_ULL(15, GP_CTR_NUM_OFS_BIT)
+#define EVT_LEN_OFS_BIT 24
+#define EVT_LEN_MASK GENMASK_ULL(31, EVT_LEN_OFS_BIT)
+
+#define ARCH_EVENT(select, umask) (((select) & 0xff) | ((umask) & 0xff) << 8)
+
+/*
+ * Intel Pre-defined Architectural Performance Events. Note some events
+ * are skipped for testing due to difficulties in stable reproduction.
+ */
+static const uint64_t arch_events[] = {
+	[0] = ARCH_EVENT(0x3c, 0x0),
+	[1] = ARCH_EVENT(0xc0, 0x0),
+	[2] = ARCH_EVENT(0x3c, 0x1),
+	[3] = ARCH_EVENT(0x2e, 0x4f), /* LLC Reference */
+	[4] = ARCH_EVENT(0x2e, 0x41), /* LLC Misses */
+	[5] = ARCH_EVENT(0xc4, 0x0),
+	[6] = ARCH_EVENT(0xc5, 0x0),  /* Branch Misses Retired */
+	[7] = ARCH_EVENT(0xa4, 0x1), /* Topdown Slots */
+};
+
+static struct kvm_vcpu *new_vcpu(void *guest_code)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	return vcpu;
+}
+
+static void free_vcpu(struct kvm_vcpu *vcpu)
+{
+	kvm_vm_free(vcpu->vm);
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu, const char *msg,
+		     bool (*check_ucall)(struct ucall *uc, void *data),
+		     void *expect_args)
+{
+	struct ucall uc;
+
+	for (;;) {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT(check_ucall(&uc, expect_args), "%s", msg);
+			continue;
+		case UCALL_DONE:
+			break;
+		default:
+			TEST_ASSERT(false, "Unexpected exit: %s",
+				    exit_reason_str(vcpu->run->exit_reason));
+		}
+		break;
+	}
+}
+
+static bool first_uc_arg_non_zero(struct ucall *uc, void *data)
+{
+	return uc->args[1];
+}
+
+static void intel_guest_run_arch_event(uint8_t version, uint8_t max_gp_num,
+				       bool supported, uint32_t ctr_base_msr,
+				       uint64_t evt_code)
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
+		GUEST_SYNC(supported == !!_rdpmc(i));
+	}
+
+	GUEST_DONE();
+}
+
+static void test_arch_events_setup(struct kvm_vcpu *vcpu, uint8_t evt_vector,
+				   uint8_t unavl_mask, uint8_t idx)
+{
+	struct kvm_cpuid_entry2 *entry;
+	uint32_t ctr_msr = MSR_IA32_PERFCTR0;
+	bool is_supported;
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
+	vcpu_args_set(vcpu, 5, entry->eax & PMU_VERSION_MASK,
+		      (entry->eax & GP_CTR_NUM_MASK) >> GP_CTR_NUM_OFS_BIT,
+		      is_supported, ctr_msr, arch_events[idx]);
+}
+
+static void intel_check_arch_event_is_unavl(uint8_t idx)
+{
+	const char *msg = "Unavailable arch event is counting.";
+	uint8_t eax_evt_vec, ebx_unavl_mask, i, j;
+	struct kvm_vcpu *vcpu;
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
+
+			vcpu = new_vcpu(intel_guest_run_arch_event);
+			test_arch_events_setup(vcpu, eax_evt_vec,
+					       ebx_unavl_mask, idx);
+			run_vcpu(vcpu, msg, first_uc_arg_non_zero, NULL);
+			free_vcpu(vcpu);
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
+		 * - Core cycle event (idx = 0)
+		 * - Instruction retired event (idx = 1)
+		 * - Reference cycles event (idx = 2)
+		 * - Branch instruction retired event (idx = 5)
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
+		TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
+		TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
+
+		intel_test_pmu_cpuid();
+	}
+
+	return 0;
+}
-- 
2.40.0

