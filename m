Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2EE694EB4
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 19:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjBMSDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 13:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbjBMSDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 13:03:08 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78423C2D
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:49 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id y22-20020a5d94d6000000b007076e06ba3dso8842345ior.20
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BS2eIj6/WnJybsbailZVj7vXOCSqKu90WeWXBSqAGkA=;
        b=miWor8s0jqaZUd3xGtI4JBTTtHHMqBsmA5HUd209CbcgvQyMiCxhmIj64++D4RGVUx
         zOUakTN+WbmyJc4C78xTGot9kZ1TRe/KSWTN0bpi6hF+WVnpU0/dmbw0WrccUj1vTd9B
         j6YMabigiPCP6tqWjGaElGNojvU9Bo+s3tzO3qRKWFPfYD2rFIZeIdpyKo0nGUoUr6bU
         n/Dd+LajqjVo+FCHnCumcYYRwJzv1+FUYrv9G15MD7XiGehqTHK72wTJyLinYEhAl+Jt
         1CRcERI1uyamRWlZqHP0/QY9MLpgSBpNz5ytPZDElyqeePPkphsxrm3FcdKBwM6D7P6I
         A2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BS2eIj6/WnJybsbailZVj7vXOCSqKu90WeWXBSqAGkA=;
        b=4Z/zpY5t0QLqY5KpdM24O/H2a0+oi04zoVhSjzU4dtKduDBSxX/2v8gq/6Jf4wrkDw
         LWk6L/Vlw+X6TxSUU/Ykg3+tc6pLnxEyW7psIbncH4FnDflsxm9o0rINi46fxL2pY3yk
         0nOUQpxt9zD4kSVg1NwbW996ObgkcjLu9/53vkkpuDC4AoHaYAEj50z8Rtffd/3d+Sf1
         JrsjXDv2JiZ5eo8A3KK00jR1oKCQ7EUG/QSyQRltF8VMxKW24w2fBhm4kQdm+6bN+1Fs
         XmC8jcG89WvIJJLWFhF9OVuvjqh9HoXdzRrw9qWx4OHMaSV9q/V7/RRbdOUyiAUXhsdT
         t+4w==
X-Gm-Message-State: AO0yUKWsn94QrgY7qQaCE1ihyTRr/vwx87aHF1Mp9UJE3/GoKlRiKMvh
        xkSawO8E/56L/2Ksv6Jrv71xfRsp3KKz
X-Google-Smtp-Source: AK7set+pdx/dE8EiXxbf6oKANYP1HUfyveaDx4g8eQWjTRp3vLmsmLm3zVaQurH0YKQXfW3y4Mzx2sOx1mUP
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:735c:0:b0:3c4:88de:524 with SMTP id
 a28-20020a02735c000000b003c488de0524mr351jae.3.1676311369255; Mon, 13 Feb
 2023 10:02:49 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:02:30 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-10-rananta@google.com>
Subject: [PATCH 09/13] selftests: KVM: aarch64: Test PMU overflow/IRQ functionality
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the vCPU migration test to also validate the vPMU's
functionality when set up for overflow conditions.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 223 ++++++++++++++++--
 1 file changed, 198 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 0c9d801f4e602..066dc17fa3906 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -21,7 +21,9 @@
  *
  * 4. Since the PMU registers are per-cpu, stress KVM by frequently
  * migrating the guest vCPU to random pCPUs in the system, and check
- * if the vPMU is still behaving as expected.
+ * if the vPMU is still behaving as expected. The sub-tests include
+ * testing basic functionalities such as basic counters behavior,
+ * overflow, and overflow interrupts.
  *
  * Copyright (c) 2022 Google LLC.
  *
@@ -41,13 +43,27 @@
 #include <sys/sysinfo.h>
 
 #include "delay.h"
+#include "gic.h"
+#include "spinlock.h"
 
 /* The max number of the PMU event counters (excluding the cycle counter) */
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
 
+/* The cycle counter bit position that's common among the PMU registers */
+#define ARMV8_PMU_CYCLE_COUNTER_IDX	31
+
 /* The max number of event numbers that's supported */
 #define ARMV8_PMU_MAX_EVENTS		64
 
+#define PMU_IRQ				23
+
+#define COUNT_TO_OVERFLOW	0xFULL
+#define PRE_OVERFLOW_32		(GENMASK(31, 0) - COUNT_TO_OVERFLOW + 1)
+#define PRE_OVERFLOW_64		(GENMASK(63, 0) - COUNT_TO_OVERFLOW + 1)
+
+#define GICD_BASE_GPA	0x8000000ULL
+#define GICR_BASE_GPA	0x80A0000ULL
+
 #define msecs_to_usecs(msec)		((msec) * 1000LL)
 
 /*
@@ -162,6 +178,17 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
 	isb();
 }
 
+static inline void write_pmovsclr(unsigned long val)
+{
+	write_sysreg(val, pmovsclr_el0);
+	isb();
+}
+
+static unsigned long read_pmovsclr(void)
+{
+	return read_sysreg(pmovsclr_el0);
+}
+
 static inline void enable_counter(int idx)
 {
 	uint64_t v = read_sysreg(pmcntenset_el0);
@@ -178,11 +205,33 @@ static inline void disable_counter(int idx)
 	isb();
 }
 
+static inline void enable_irq(int idx)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(BIT(idx) | v, pmintenset_el1);
+	isb();
+}
+
+static inline void disable_irq(int idx)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(BIT(idx) | v, pmintenclr_el1);
+	isb();
+}
+
 static inline uint64_t read_cycle_counter(void)
 {
 	return read_sysreg(pmccntr_el0);
 }
 
+static inline void write_cycle_counter(uint64_t v)
+{
+	write_sysreg(v, pmccntr_el0);
+	isb();
+}
+
 static inline void reset_cycle_counter(void)
 {
 	uint64_t v = read_sysreg(pmcr_el0);
@@ -289,6 +338,15 @@ struct guest_data {
 
 static struct guest_data guest_data;
 
+/* Data to communicate among guest threads */
+struct guest_irq_data {
+	uint32_t pmc_idx_bmap;
+	uint32_t irq_received_bmap;
+	struct spinlock lock;
+};
+
+static struct guest_irq_data guest_irq_data;
+
 #define VCPU_MIGRATIONS_TEST_ITERS_DEF		1000
 #define VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS	2
 
@@ -322,6 +380,79 @@ static void guest_sync_handler(struct ex_regs *regs)
 	expected_ec = INVALID_EC;
 }
 
+static void guest_validate_irq(int pmc_idx, uint32_t pmovsclr, uint32_t pmc_idx_bmap)
+{
+	/*
+	 * Fail if there's an interrupt from unexpected PMCs.
+	 * All the expected events' IRQs may not arrive at the same time.
+	 * Hence, check if the interrupt is valid only if it's expected.
+	 */
+	if (pmovsclr & BIT(pmc_idx)) {
+		GUEST_ASSERT_3(pmc_idx_bmap & BIT(pmc_idx), pmc_idx, pmovsclr, pmc_idx_bmap);
+		write_pmovsclr(BIT(pmc_idx));
+	}
+}
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	uint32_t pmc_idx_bmap;
+	uint64_t i, pmcr_n = get_pmcr_n();
+	uint32_t pmovsclr = read_pmovsclr();
+	unsigned int intid = gic_get_and_ack_irq();
+
+	/* No other IRQ apart from the PMU IRQ is expected */
+	GUEST_ASSERT_1(intid == PMU_IRQ, intid);
+
+	spin_lock(&guest_irq_data.lock);
+	pmc_idx_bmap = READ_ONCE(guest_irq_data.pmc_idx_bmap);
+
+	for (i = 0; i < pmcr_n; i++)
+		guest_validate_irq(i, pmovsclr, pmc_idx_bmap);
+	guest_validate_irq(ARMV8_PMU_CYCLE_COUNTER_IDX, pmovsclr, pmc_idx_bmap);
+
+	/* Mark IRQ as recived for the corresponding PMCs */
+	WRITE_ONCE(guest_irq_data.irq_received_bmap, pmovsclr);
+	spin_unlock(&guest_irq_data.lock);
+
+	gic_set_eoi(intid);
+}
+
+static int pmu_irq_received(int pmc_idx)
+{
+	bool irq_received;
+
+	spin_lock(&guest_irq_data.lock);
+	irq_received = READ_ONCE(guest_irq_data.irq_received_bmap) & BIT(pmc_idx);
+	WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc_idx_bmap & ~BIT(pmc_idx));
+	spin_unlock(&guest_irq_data.lock);
+
+	return irq_received;
+}
+
+static void pmu_irq_init(int pmc_idx)
+{
+	write_pmovsclr(BIT(pmc_idx));
+
+	spin_lock(&guest_irq_data.lock);
+	WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc_idx_bmap & ~BIT(pmc_idx));
+	WRITE_ONCE(guest_irq_data.pmc_idx_bmap, guest_irq_data.pmc_idx_bmap | BIT(pmc_idx));
+	spin_unlock(&guest_irq_data.lock);
+
+	enable_irq(pmc_idx);
+}
+
+static void pmu_irq_exit(int pmc_idx)
+{
+	write_pmovsclr(BIT(pmc_idx));
+
+	spin_lock(&guest_irq_data.lock);
+	WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc_idx_bmap & ~BIT(pmc_idx));
+	WRITE_ONCE(guest_irq_data.pmc_idx_bmap, guest_irq_data.pmc_idx_bmap & ~BIT(pmc_idx));
+	spin_unlock(&guest_irq_data.lock);
+
+	disable_irq(pmc_idx);
+}
+
 /*
  * Run the given operation that should trigger an exception with the
  * given exception class. The exception handler (guest_sync_handler)
@@ -420,12 +551,20 @@ static void execute_precise_instrs(int num, uint32_t pmcr)
 	precise_instrs_loop(loop, pmcr);
 }
 
-static void test_instructions_count(int pmc_idx, bool expect_count)
+static void test_instructions_count(int pmc_idx, bool expect_count, bool test_overflow)
 {
 	int i;
 	struct pmc_accessor *acc;
-	uint64_t cnt;
-	int instrs_count = 100;
+	uint64_t cntr_val = 0;
+	int instrs_count = 500;
+
+	if (test_overflow) {
+		/* Overflow scenarios can only be tested when a count is expected */
+		GUEST_ASSERT_1(expect_count, pmc_idx);
+
+		cntr_val = PRE_OVERFLOW_32;
+		pmu_irq_init(pmc_idx);
+	}
 
 	enable_counter(pmc_idx);
 
@@ -433,41 +572,68 @@ static void test_instructions_count(int pmc_idx, bool expect_count)
 	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
 		acc = &pmc_accessors[i];
 
-		pmu_disable_reset();
-
+		acc->write_cntr(pmc_idx, cntr_val);
 		acc->write_typer(pmc_idx, ARMV8_PMUV3_PERFCTR_INST_RETIRED);
 
-		/* Enable the PMU and execute precisely number of instructions as a workload */
-		execute_precise_instrs(instrs_count, read_sysreg(pmcr_el0) | ARMV8_PMU_PMCR_E);
+		/*
+		 * Enable the PMU and execute a precise number of instructions as a workload.
+		 * Since execute_precise_instrs() disables the PMU at the end, 'instrs_count'
+		 * should have enough instructions to raise an IRQ.
+		 */
+		execute_precise_instrs(instrs_count, ARMV8_PMU_PMCR_E);
 
-		/* If a count is expected, the counter should be increased by 'instrs_count' */
-		cnt = acc->read_cntr(pmc_idx);
-		GUEST_ASSERT_4(expect_count == (cnt == instrs_count),
-				i, expect_count, cnt, instrs_count);
+		/*
+		 * If an overflow is expected, only check for the overflag flag.
+		 * As overflow interrupt is enabled, the interrupt would add additional
+		 * instructions and mess up the precise instruction count. Hence, measure
+		 * the instructions count only when the test is not set up for an overflow.
+		 */
+		if (test_overflow) {
+			GUEST_ASSERT_2(pmu_irq_received(pmc_idx), pmc_idx, i);
+		} else {
+			uint64_t cnt = acc->read_cntr(pmc_idx);
+
+			GUEST_ASSERT_4(expect_count == (cnt == instrs_count),
+					pmc_idx, i, cnt, expect_count);
+		}
 	}
 
-	disable_counter(pmc_idx);
+	if (test_overflow)
+		pmu_irq_exit(pmc_idx);
 }
 
-static void test_cycles_count(bool expect_count)
+static void test_cycles_count(bool expect_count, bool test_overflow)
 {
 	uint64_t cnt;
 
-	pmu_enable();
-	reset_cycle_counter();
+	if (test_overflow) {
+		/* Overflow scenarios can only be tested when a count is expected */
+		GUEST_ASSERT(expect_count);
+
+		write_cycle_counter(PRE_OVERFLOW_64);
+		pmu_irq_init(ARMV8_PMU_CYCLE_COUNTER_IDX);
+	} else {
+		reset_cycle_counter();
+	}
 
 	/* Count cycles in EL0 and EL1 */
 	write_pmccfiltr(0);
 	enable_cycle_counter();
 
+	/* Enable the PMU and execute precisely number of instructions as a workload */
+	execute_precise_instrs(500, read_sysreg(pmcr_el0) | ARMV8_PMU_PMCR_E);
 	cnt = read_cycle_counter();
 
 	/*
 	 * If a count is expected by the test, the cycle counter should be increased by
-	 * at least 1, as there is at least one instruction between enabling the
+	 * at least 1, as there are a number of instructions between enabling the
 	 * counter and reading the counter.
 	 */
 	GUEST_ASSERT_2(expect_count == (cnt > 0), cnt, expect_count);
+	if (test_overflow) {
+		GUEST_ASSERT_2(pmu_irq_received(ARMV8_PMU_CYCLE_COUNTER_IDX), cnt, expect_count);
+		pmu_irq_exit(ARMV8_PMU_CYCLE_COUNTER_IDX);
+	}
 
 	disable_cycle_counter();
 	pmu_disable_reset();
@@ -477,19 +643,28 @@ static void test_event_count(uint64_t event, int pmc_idx, bool expect_count)
 {
 	switch (event) {
 	case ARMV8_PMUV3_PERFCTR_INST_RETIRED:
-		test_instructions_count(pmc_idx, expect_count);
+		test_instructions_count(pmc_idx, expect_count, false);
 		break;
 	case ARMV8_PMUV3_PERFCTR_CPU_CYCLES:
-		test_cycles_count(expect_count);
+		test_cycles_count(expect_count, false);
 		break;
 	}
 }
 
 static void test_basic_pmu_functionality(void)
 {
+	local_irq_disable();
+	gic_init(GIC_V3, 1, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+	gic_irq_enable(PMU_IRQ);
+	local_irq_enable();
+
 	/* Test events on generic and cycle counters */
-	test_instructions_count(0, true);
-	test_cycles_count(true);
+	test_instructions_count(0, true, false);
+	test_cycles_count(true, false);
+
+	/* Test overflow with interrupts on generic and cycle counters */
+	test_instructions_count(0, true, true);
+	test_cycles_count(true, true);
 }
 
 /*
@@ -813,9 +988,6 @@ static void guest_code(void)
 	GUEST_DONE();
 }
 
-#define GICD_BASE_GPA	0x8000000ULL
-#define GICR_BASE_GPA	0x80A0000ULL
-
 static unsigned long *
 set_event_filters(struct kvm_vcpu *vcpu, struct kvm_pmu_event_filter *pmu_event_filters)
 {
@@ -866,7 +1038,7 @@ create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_event_filters)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vcpu_init init;
 	uint8_t pmuver, ec;
-	uint64_t dfr0, irq = 23;
+	uint64_t dfr0, irq = PMU_IRQ;
 	struct vpmu_vm *vpmu_vm;
 	struct kvm_device_attr irq_attr = {
 		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
@@ -883,6 +1055,7 @@ create_vpmu_vm(void *guest_code, struct kvm_pmu_event_filter *pmu_event_filters)
 
 	vpmu_vm->vm = vm = vm_create(1);
 	vm_init_descriptor_tables(vm);
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
 
 	/* Catch exceptions for easier debugging */
 	for (ec = 0; ec < ESR_EC_NUM; ec++) {
-- 
2.39.1.581.gbfd45094c4-goog

