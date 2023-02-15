Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F7F697329
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbjBOBIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbjBOBHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:07:54 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDCE32529
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:32 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id z25-20020a6be019000000b00716eaf80c1dso11118313iog.3
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b4AB06q1cmw2xfepDKSJYP3pCnth/5v7kXmR5lfk+6U=;
        b=bdUvRc4DFoVm18CrtgjPtwfSmf/jugjUOqPNo+23bsO4zspSHgom/Yv/uC66fCRW+7
         rJ4qlZc+9xxfBnXoTeZo3SB+07yRLx76s2NalRU5H4354eoQLSxxnLOjy3hWhX8D5k6C
         ObzdFQobYDiaXHWRE7F2Q7axtCzBfQ4ZViGvuEF3Fri9/US01mTPJR22ZrdOarchVYoE
         OlziY8aOOGAz6M3KBjhfGWmk+nujvFsivDkSdTUevM/VgaxTa6J5b1QcXrIZi2etNs/b
         5VTvodxVUBYlRcGRNuUQvYofDHYbXW3uIv/ss9KNSvikBMEGNO2ewLecnJQAMevPmdbd
         Shxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4AB06q1cmw2xfepDKSJYP3pCnth/5v7kXmR5lfk+6U=;
        b=Oi/xgeQY6574r0eYc4jXtKGFfBUA9DpjC3d1qMQxw/JGB71mwkTeoC2TLVPWGHykip
         fqLgrCUvHNXGGbUEV7R6Uw/VY5Gu+Yj99nqZ03vEayWeWbI6GZQhPnDWlgnX98YxeELR
         C60tIcX/OyyVEP/v71radjlT1oThw1Ie101RA5YonSDVclYEMMrRrb0RZWR/jpW078X7
         XLRJkM/V4oMwuYYxPqZfFeGYGvluBzFpfo2yVHgCWDmSq+/J4GOL7JdDjQHckpUs+5YU
         9pY87eUQEfLZZ/oRcEuHBzQcK7o18gL0dtJGSuzN8xz+rShB+O3pAJ/uAtdJxiKIk1jd
         4wrw==
X-Gm-Message-State: AO0yUKVU6P4cS+DUHdD005nsylCd4hB5KWSaK48vziy1ALPuWZir1EtT
        GiVq4ohK0oSxcBSisjAXDWfr1tIFv8qQ
X-Google-Smtp-Source: AK7set99bR7dInb6Kz+vuZES78IAF9nNNWrKmWdNrVdeJgfAodCapNt9RI16sxPqq9n205Lc9VucfelRLeF+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6638:1218:b0:3b7:1ec7:de9f with SMTP
 id n24-20020a056638121800b003b71ec7de9fmr578254jas.3.1676423252317; Tue, 14
 Feb 2023 17:07:32 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:10 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-10-rananta@google.com>
Subject: [REPOST PATCH 09/16] selftests: KVM: aarch64: Add KVM PMU event
 filter test
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests to validate KVM's KVM_ARM_VCPU_PMU_V3_FILTER
attribute by applying a series of filters to allow or
deny events from the userspace. Validation is done by
the guest in a way that it should be able to count
only the events that are allowed.

The workload to execute a precise number of instructions
(execute_precise_instrs() and precise_instrs_loop()) is taken
from the kvm-unit-tests' arm/pmu.c.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 261 +++++++++++++++++-
 1 file changed, 258 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 2b3a4fa3afa9c..3dfb770b538e9 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -2,12 +2,21 @@
 /*
  * vpmu_test - Test the vPMU
  *
- * Copyright (c) 2022 Google LLC.
+ * The test suit contains a series of checks to validate the vPMU
+ * functionality. This test runs only when KVM_CAP_ARM_PMU_V3 is
+ * supported on the host. The tests include:
  *
- * This test checks if the guest can see the same number of the PMU event
+ * 1. Check if the guest can see the same number of the PMU event
  * counters (PMCR_EL0.N) that userspace sets, if the guest can access
  * those counters, and if the guest cannot access any other counters.
- * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
+ *
+ * 2. Test the functionality of KVM's KVM_ARM_VCPU_PMU_V3_FILTER
+ * attribute by applying a series of filters in various combinations
+ * of allowing or denying the events. The guest validates it by
+ * checking if it's able to count only the events that are allowed.
+ *
+ * Copyright (c) 2022 Google LLC.
+ *
  */
 #include <kvm_util.h>
 #include <processor.h>
@@ -230,6 +239,12 @@ struct pmc_accessor pmc_accessors[] = {
 
 #define MAX_EVENT_FILTERS_PER_VM 10
 
+#define EVENT_ALLOW(ev) \
+	{.base_event = ev, .nevents = 1, .action = KVM_PMU_EVENT_ALLOW}
+
+#define EVENT_DENY(ev) \
+	{.base_event = ev, .nevents = 1, .action = KVM_PMU_EVENT_DENY}
+
 #define INVALID_EC	(-1ul)
 uint64_t expected_ec = INVALID_EC;
 uint64_t op_end_addr;
@@ -243,11 +258,13 @@ struct vpmu_vm {
 
 enum test_stage {
 	TEST_STAGE_COUNTER_ACCESS = 1,
+	TEST_STAGE_KVM_EVENT_FILTER,
 };
 
 struct guest_data {
 	enum test_stage test_stage;
 	uint64_t expected_pmcr_n;
+	unsigned long *pmu_filter;
 };
 
 static struct guest_data guest_data;
@@ -329,6 +346,113 @@ static bool pmu_event_is_supported(uint64_t event)
 		GUEST_ASSERT_3(!(_tval & mask), _tval, mask, set_expected);\
 }
 
+
+/*
+ * Extra instructions inserted by the compiler would be difficult to compensate
+ * for, so hand assemble everything between, and including, the PMCR accesses
+ * to start and stop counting. isb instructions are inserted to make sure
+ * pmccntr read after this function returns the exact instructions executed
+ * in the controlled block. Total instrs = isb + nop + 2*loop = 2 + 2*loop.
+ */
+static inline void precise_instrs_loop(int loop, uint32_t pmcr)
+{
+	uint64_t pmcr64 = pmcr;
+
+	asm volatile(
+	"	msr	pmcr_el0, %[pmcr]\n"
+	"	isb\n"
+	"1:	subs	%w[loop], %w[loop], #1\n"
+	"	b.gt	1b\n"
+	"	nop\n"
+	"	msr	pmcr_el0, xzr\n"
+	"	isb\n"
+	: [loop] "+r" (loop)
+	: [pmcr] "r" (pmcr64)
+	: "cc");
+}
+
+/*
+ * Execute a known number of guest instructions. Only even instruction counts
+ * greater than or equal to 4 are supported by the in-line assembly code. The
+ * control register (PMCR_EL0) is initialized with the provided value (allowing
+ * for example for the cycle counter or event counters to be reset). At the end
+ * of the exact instruction loop, zero is written to PMCR_EL0 to disable
+ * counting, allowing the cycle counter or event counters to be read at the
+ * leisure of the calling code.
+ */
+static void execute_precise_instrs(int num, uint32_t pmcr)
+{
+	int loop = (num - 2) / 2;
+
+	GUEST_ASSERT_2(num >= 4 && ((num - 2) % 2 == 0), num, loop);
+	precise_instrs_loop(loop, pmcr);
+}
+
+static void test_instructions_count(int pmc_idx, bool expect_count)
+{
+	int i;
+	struct pmc_accessor *acc;
+	uint64_t cnt;
+	int instrs_count = 100;
+
+	enable_counter(pmc_idx);
+
+	/* Test the event using all the possible way to configure the event */
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		acc = &pmc_accessors[i];
+
+		pmu_disable_reset();
+
+		acc->write_typer(pmc_idx, ARMV8_PMUV3_PERFCTR_INST_RETIRED);
+
+		/* Enable the PMU and execute precisely number of instructions as a workload */
+		execute_precise_instrs(instrs_count, read_sysreg(pmcr_el0) | ARMV8_PMU_PMCR_E);
+
+		/* If a count is expected, the counter should be increased by 'instrs_count' */
+		cnt = acc->read_cntr(pmc_idx);
+		GUEST_ASSERT_4(expect_count == (cnt == instrs_count),
+				i, expect_count, cnt, instrs_count);
+	}
+
+	disable_counter(pmc_idx);
+}
+
+static void test_cycles_count(bool expect_count)
+{
+	uint64_t cnt;
+
+	pmu_enable();
+	reset_cycle_counter();
+
+	/* Count cycles in EL0 and EL1 */
+	write_pmccfiltr(0);
+	enable_cycle_counter();
+
+	cnt = read_cycle_counter();
+
+	/*
+	 * If a count is expected by the test, the cycle counter should be increased by
+	 * at least 1, as there is at least one instruction between enabling the
+	 * counter and reading the counter.
+	 */
+	GUEST_ASSERT_2(expect_count == (cnt > 0), cnt, expect_count);
+
+	disable_cycle_counter();
+	pmu_disable_reset();
+}
+
+static void test_event_count(uint64_t event, int pmc_idx, bool expect_count)
+{
+	switch (event) {
+	case ARMV8_PMUV3_PERFCTR_INST_RETIRED:
+		test_instructions_count(pmc_idx, expect_count);
+		break;
+	case ARMV8_PMUV3_PERFCTR_CPU_CYCLES:
+		test_cycles_count(expect_count);
+		break;
+	}
+}
+
 /*
  * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
  * are set or cleared as specified in @set_expected.
@@ -532,12 +656,37 @@ static void guest_counter_access_test(uint64_t expected_pmcr_n)
 	}
 }
 
+static void guest_event_filter_test(unsigned long *pmu_filter)
+{
+	uint64_t event;
+
+	/*
+	 * Check if PMCEIDx_EL0 is advertized as configured by the userspace.
+	 * It's possible that even though the userspace allowed it, it may not be supported
+	 * by the hardware and could be advertized as 'disabled'. Hence, only validate against
+	 * the events that are advertized.
+	 *
+	 * Furthermore, check if the event is in fact counting if enabled, or vice-versa.
+	 */
+	for (event = 0; event < ARMV8_PMU_MAX_EVENTS - 1; event++) {
+		if (pmu_event_is_supported(event)) {
+			GUEST_ASSERT_1(test_bit(event, pmu_filter), event);
+			test_event_count(event, 0, true);
+		} else {
+			test_event_count(event, 0, false);
+		}
+	}
+}
+
 static void guest_code(void)
 {
 	switch (guest_data.test_stage) {
 	case TEST_STAGE_COUNTER_ACCESS:
 		guest_counter_access_test(guest_data.expected_pmcr_n);
 		break;
+	case TEST_STAGE_KVM_EVENT_FILTER:
+		guest_event_filter_test(guest_data.pmu_filter);
+		break;
 	default:
 		GUEST_ASSERT_1(0, guest_data.test_stage);
 	}
@@ -760,9 +909,115 @@ static void run_counter_access_tests(uint64_t pmcr_n)
 		run_counter_access_error_test(i);
 }
 
+static struct kvm_pmu_event_filter pmu_event_filters[][MAX_EVENT_FILTERS_PER_VM] = {
+	/*
+	 * Each set of events denotes a filter configuration for that VM.
+	 * During VM creation, the filters will be applied in the sequence mentioned here.
+	 */
+	{
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+	},
+	{
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
+	},
+	{
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
+		EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+	},
+	{
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
+		EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+		EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
+	},
+	{
+		EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+		EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+	},
+	{
+		EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
+		EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+	},
+	{
+		EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+		EVENT_DENY(ARMV8_PMUV3_PERFCTR_CPU_CYCLES),
+	},
+	{
+		EVENT_DENY(ARMV8_PMUV3_PERFCTR_INST_RETIRED),
+	},
+};
+
+static void run_kvm_event_filter_error_tests(void)
+{
+	int ret;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct vpmu_vm *vpmu_vm;
+	struct kvm_vcpu_init init;
+	struct kvm_pmu_event_filter pmu_event_filter = EVENT_ALLOW(ARMV8_PMUV3_PERFCTR_CPU_CYCLES);
+	struct kvm_device_attr filter_attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_FILTER,
+		.addr = (uint64_t) &pmu_event_filter,
+	};
+
+	/* KVM should not allow configuring filters after the PMU is initialized */
+	vpmu_vm = create_vpmu_vm(guest_code, NULL);
+	ret = __vcpu_ioctl(vpmu_vm->vcpu, KVM_SET_DEVICE_ATTR, &filter_attr);
+	TEST_ASSERT(ret == -1 && errno == EBUSY,
+			"Failed to disallow setting an event filter after PMU init");
+	destroy_vpmu_vm(vpmu_vm);
+
+	/* Check for invalid event filter setting */
+	vm = vm_create(1);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+
+	pmu_event_filter.base_event = UINT16_MAX;
+	pmu_event_filter.nevents = 5;
+	ret = __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &filter_attr);
+	TEST_ASSERT(ret == -1 && errno == EINVAL, "Failed check for invalid filter configuration");
+	kvm_vm_free(vm);
+}
+
+static void run_kvm_event_filter_test(void)
+{
+	int i;
+	struct vpmu_vm *vpmu_vm;
+	struct kvm_vm *vm;
+	vm_vaddr_t pmu_filter_gva;
+	size_t pmu_filter_bmap_sz = BITS_TO_LONGS(ARMV8_PMU_MAX_EVENTS) * sizeof(unsigned long);
+
+	guest_data.test_stage = TEST_STAGE_KVM_EVENT_FILTER;
+
+	/* Test for valid filter configurations */
+	for (i = 0; i < ARRAY_SIZE(pmu_event_filters); i++) {
+		vpmu_vm = create_vpmu_vm(guest_code, pmu_event_filters[i]);
+		vm = vpmu_vm->vm;
+
+		pmu_filter_gva = vm_vaddr_alloc(vm, pmu_filter_bmap_sz, KVM_UTIL_MIN_VADDR);
+		memcpy(addr_gva2hva(vm, pmu_filter_gva), vpmu_vm->pmu_filter, pmu_filter_bmap_sz);
+		guest_data.pmu_filter = (unsigned long *) pmu_filter_gva;
+
+		run_vcpu(vpmu_vm->vcpu);
+
+		destroy_vpmu_vm(vpmu_vm);
+	}
+
+	/* Check if KVM is handling the errors correctly */
+	run_kvm_event_filter_error_tests();
+}
+
 static void run_tests(uint64_t pmcr_n)
 {
 	run_counter_access_tests(pmcr_n);
+	run_kvm_event_filter_test();
 }
 
 /*
-- 
2.39.1.581.gbfd45094c4-goog

