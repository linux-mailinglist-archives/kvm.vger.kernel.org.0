Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4605C692D9F
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 04:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBKDRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 22:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBKDRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 22:17:08 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEB1104
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:56 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pv1-20020a17090b3c8100b0022c1ab71110so5630885pjb.7
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wPXMBFxCqoYrwiivvwXne+XTeMTA3klE2uBM31zW1ys=;
        b=cja+vAiw8k+i2hIVpWa7aAWcmEPiCuXyefqPQsrGYYybRSa5LiWk7Eo0IHowCHtxvU
         7KLP7ALZmImYUkAd6upP9oKOaeHwptROdjTkJaQzWjAgyw+Vf6qUyPadJrG6T3/nzQ5n
         NcYxQ1bwHwmu+dpJz0m74IqYrirrManZkepMdg/fIepE+DhjGc1tQgITIaZvWvgwNBWw
         tseitkYA2vS7yBD4OAZ1vHtZPIinNHKDeihZU3pId7BYAPDgoEcB8YNlHkzSdd7JCrY/
         HbJ/KnJ756b3hhPou2L+FmD7c6aju29nllPW38QxNGm+BNiAwk5LBVNj4hC5FIjFyDz1
         WnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wPXMBFxCqoYrwiivvwXne+XTeMTA3klE2uBM31zW1ys=;
        b=1uRQL5jD5zykcaamZk/rUfsW0E3vepv/tcxApyZDgvGWveJ4sTr5K5q9rc6rlem7e0
         oysHlxaws3l+qqFqMYBIwnFI3HlA3ZRyHkfAud8YiF2qQqpJfMOSMHmEJyyOQzarDoSq
         0XMfQjzE0Fe8uEPOZrrvfy2B/9kyoaF57+Tek4wqlR8078/KnJdtpMAzjIT5hsY8e6RK
         0ox4Kadj47EEpm57OqhH4kTy5d6Ihb2i7AVWP5N2qEsjNMPFuERNpL7AyeyPOuYPN6xU
         GCWuyR1t2F9uOom8A+MMQsQuXuUdf8lm3wDRYWgpFsUhjHj554UKFW6aXhh/j7J2Ate7
         qEEQ==
X-Gm-Message-State: AO0yUKW5J2wTEJu6179bH9/Xayu1ebergd1wRXBODeP1DrhNKmwf/LZi
        vyttMRmM/uLG5+eZ5Ej7S2uZaUGVf4w=
X-Google-Smtp-Source: AK7set+zPjo9UKrem8qX+boWMLL1O0kvJguAjagPXqN/TOuEqmLZZx7r8y5NKGscuBE+i1Ccnf8kCRxVsXA=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a62:16ce:0:b0:57f:a5e6:20fd with SMTP id
 197-20020a6216ce000000b0057fa5e620fdmr3623983pfw.11.1676085416217; Fri, 10
 Feb 2023 19:16:56 -0800 (PST)
Date:   Fri, 10 Feb 2023 19:15:05 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-14-reijiw@google.com>
Subject: [PATCH v4 13/14] KVM: selftests: aarch64: vPMU register test for
 implemented counters
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Reiji Watanabe <reijiw@google.com>
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

Add a new test case to the vpmu_counter_access test to check if PMU
registers or their bits for implemented counters on the vCPU are
readable/writable as expected, and can be programmed to count events.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../kvm/aarch64/vpmu_counter_access.c         | 350 +++++++++++++++++-
 1 file changed, 347 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 7a4333f64dae..b6593eee2be3 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -5,7 +5,8 @@
  * Copyright (c) 2022 Google LLC.
  *
  * This test checks if the guest can see the same number of the PMU event
- * counters (PMCR_EL0.N) that userspace sets.
+ * counters (PMCR_EL0.N) that userspace sets, and if the guest can access
+ * those counters.
  * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
  */
 #include <kvm_util.h>
@@ -18,14 +19,348 @@
 /* The max number of the PMU event counters (excluding the cycle counter) */
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
 
+/*
+ * The macros and functions below for reading/writing PMEVT{CNTR,TYPER}<n>_EL0
+ * were basically copied from arch/arm64/kernel/perf_event.c.
+ */
+#define PMEVN_CASE(n, case_macro) \
+	case n: case_macro(n); break
+
+#define PMEVN_SWITCH(x, case_macro)				\
+	do {							\
+		switch (x) {					\
+		PMEVN_CASE(0,  case_macro);			\
+		PMEVN_CASE(1,  case_macro);			\
+		PMEVN_CASE(2,  case_macro);			\
+		PMEVN_CASE(3,  case_macro);			\
+		PMEVN_CASE(4,  case_macro);			\
+		PMEVN_CASE(5,  case_macro);			\
+		PMEVN_CASE(6,  case_macro);			\
+		PMEVN_CASE(7,  case_macro);			\
+		PMEVN_CASE(8,  case_macro);			\
+		PMEVN_CASE(9,  case_macro);			\
+		PMEVN_CASE(10, case_macro);			\
+		PMEVN_CASE(11, case_macro);			\
+		PMEVN_CASE(12, case_macro);			\
+		PMEVN_CASE(13, case_macro);			\
+		PMEVN_CASE(14, case_macro);			\
+		PMEVN_CASE(15, case_macro);			\
+		PMEVN_CASE(16, case_macro);			\
+		PMEVN_CASE(17, case_macro);			\
+		PMEVN_CASE(18, case_macro);			\
+		PMEVN_CASE(19, case_macro);			\
+		PMEVN_CASE(20, case_macro);			\
+		PMEVN_CASE(21, case_macro);			\
+		PMEVN_CASE(22, case_macro);			\
+		PMEVN_CASE(23, case_macro);			\
+		PMEVN_CASE(24, case_macro);			\
+		PMEVN_CASE(25, case_macro);			\
+		PMEVN_CASE(26, case_macro);			\
+		PMEVN_CASE(27, case_macro);			\
+		PMEVN_CASE(28, case_macro);			\
+		PMEVN_CASE(29, case_macro);			\
+		PMEVN_CASE(30, case_macro);			\
+		default:					\
+			GUEST_ASSERT_1(0, x);			\
+		}						\
+	} while (0)
+
+#define RETURN_READ_PMEVCNTRN(n) \
+	return read_sysreg(pmevcntr##n##_el0)
+static unsigned long read_pmevcntrn(int n)
+{
+	PMEVN_SWITCH(n, RETURN_READ_PMEVCNTRN);
+	return 0;
+}
+
+#define WRITE_PMEVCNTRN(n) \
+	write_sysreg(val, pmevcntr##n##_el0)
+static void write_pmevcntrn(int n, unsigned long val)
+{
+	PMEVN_SWITCH(n, WRITE_PMEVCNTRN);
+	isb();
+}
+
+#define READ_PMEVTYPERN(n) \
+	return read_sysreg(pmevtyper##n##_el0)
+static unsigned long read_pmevtypern(int n)
+{
+	PMEVN_SWITCH(n, READ_PMEVTYPERN);
+	return 0;
+}
+
+#define WRITE_PMEVTYPERN(n) \
+	write_sysreg(val, pmevtyper##n##_el0)
+static void write_pmevtypern(int n, unsigned long val)
+{
+	PMEVN_SWITCH(n, WRITE_PMEVTYPERN);
+	isb();
+}
+
+/* Read PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
+static inline unsigned long read_sel_evcntr(int sel)
+{
+	write_sysreg(sel, pmselr_el0);
+	isb();
+	return read_sysreg(pmxevcntr_el0);
+}
+
+/* Write PMEVTCNTR<n>_EL0 through PMXEVCNTR_EL0 */
+static inline void write_sel_evcntr(int sel, unsigned long val)
+{
+	write_sysreg(sel, pmselr_el0);
+	isb();
+	write_sysreg(val, pmxevcntr_el0);
+	isb();
+}
+
+/* Read PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
+static inline unsigned long read_sel_evtyper(int sel)
+{
+	write_sysreg(sel, pmselr_el0);
+	isb();
+	return read_sysreg(pmxevtyper_el0);
+}
+
+/* Write PMEVTYPER<n>_EL0 through PMXEVTYPER_EL0 */
+static inline void write_sel_evtyper(int sel, unsigned long val)
+{
+	write_sysreg(sel, pmselr_el0);
+	isb();
+	write_sysreg(val, pmxevtyper_el0);
+	isb();
+}
+
+static inline void enable_counter(int idx)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(BIT(idx) | v, pmcntenset_el0);
+	isb();
+}
+
+static inline void disable_counter(int idx)
+{
+	uint64_t v = read_sysreg(pmcntenset_el0);
+
+	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
+	isb();
+}
+
+/*
+ * The pmc_accessor structure has pointers to PMEVT{CNTR,TYPER}<n>_EL0
+ * accessors that test cases will use. Each of the accessors will
+ * either directly reads/writes PMEVT{CNTR,TYPER}<n>_EL0
+ * (i.e. {read,write}_pmev{cnt,type}rn()), or reads/writes them through
+ * PMXEV{CNTR,TYPER}_EL0 (i.e. {read,write}_sel_ev{cnt,type}r()).
+ *
+ * This is used to test that combinations of those accessors provide
+ * the consistent behavior.
+ */
+struct pmc_accessor {
+	/* A function to be used to read PMEVTCNTR<n>_EL0 */
+	unsigned long	(*read_cntr)(int idx);
+	/* A function to be used to write PMEVTCNTR<n>_EL0 */
+	void		(*write_cntr)(int idx, unsigned long val);
+	/* A function to be used to read PMEVTYPER<n>_EL0 */
+	unsigned long	(*read_typer)(int idx);
+	/* A function to be used to write PMEVTYPER<n>_EL0 */
+	void		(*write_typer)(int idx, unsigned long val);
+};
+
+struct pmc_accessor pmc_accessors[] = {
+	/* test with all direct accesses */
+	{ read_pmevcntrn, write_pmevcntrn, read_pmevtypern, write_pmevtypern },
+	/* test with all indirect accesses */
+	{ read_sel_evcntr, write_sel_evcntr, read_sel_evtyper, write_sel_evtyper },
+	/* read with direct accesses, and write with indirect accesses */
+	{ read_pmevcntrn, write_sel_evcntr, read_pmevtypern, write_sel_evtyper },
+	/* read with indirect accesses, and write with direct accesses */
+	{ read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevtypern },
+};
+
+static void pmu_disable_reset(void)
+{
+	uint64_t pmcr = read_sysreg(pmcr_el0);
+
+	/* Reset all counters, disabling them */
+	pmcr &= ~ARMV8_PMU_PMCR_E;
+	write_sysreg(pmcr | ARMV8_PMU_PMCR_P, pmcr_el0);
+	isb();
+}
+
+static void pmu_enable(void)
+{
+	uint64_t pmcr = read_sysreg(pmcr_el0);
+
+	/* Reset all counters, disabling them */
+	pmcr |= ARMV8_PMU_PMCR_E;
+	write_sysreg(pmcr | ARMV8_PMU_PMCR_P, pmcr_el0);
+	isb();
+}
+
+static bool pmu_event_is_supported(uint64_t event)
+{
+	GUEST_ASSERT_1(event < 64, event);
+	return (read_sysreg(pmceid0_el0) & BIT(event));
+}
+
+#define GUEST_ASSERT_BITMAP_REG(regname, mask, set_expected)		\
+{									\
+	uint64_t _tval = read_sysreg(regname);				\
+									\
+	if (set_expected)						\
+		GUEST_ASSERT_3((_tval & mask), _tval, mask, set_expected); \
+	else								   \
+		GUEST_ASSERT_3(!(_tval & mask), _tval, mask, set_expected);\
+}
+
+/*
+ * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
+ * are set or cleared as specified in @set_expected.
+ */
+static void check_bitmap_pmu_regs(uint64_t mask, bool set_expected)
+{
+	GUEST_ASSERT_BITMAP_REG(pmcntenset_el0, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmcntenclr_el0, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmintenset_el1, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmintenclr_el1, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmovsset_el0, mask, set_expected);
+	GUEST_ASSERT_BITMAP_REG(pmovsclr_el0, mask, set_expected);
+}
+
+/*
+ * Check if the bit in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers corresponding
+ * to the specified counter (@pmc_idx) can be read/written as expected.
+ * When @set_op is true, it tries to set the bit for the counter in
+ * those registers by writing the SET registers (the bit won't be set
+ * if the counter is not implemented though).
+ * Otherwise, it tries to clear the bits in the registers by writing
+ * the CLR registers.
+ * Then, it checks if the values indicated in the registers are as expected.
+ */
+static void test_bitmap_pmu_regs(int pmc_idx, bool set_op)
+{
+	uint64_t pmcr_n, test_bit = BIT(pmc_idx);
+	bool set_expected = false;
+
+	if (set_op) {
+		write_sysreg(test_bit, pmcntenset_el0);
+		write_sysreg(test_bit, pmintenset_el1);
+		write_sysreg(test_bit, pmovsset_el0);
+
+		/* The bit will be set only if the counter is implemented */
+		pmcr_n = FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0));
+		set_expected = (pmc_idx < pmcr_n) ? true : false;
+	} else {
+		write_sysreg(test_bit, pmcntenclr_el0);
+		write_sysreg(test_bit, pmintenclr_el1);
+		write_sysreg(test_bit, pmovsclr_el0);
+	}
+	check_bitmap_pmu_regs(test_bit, set_expected);
+}
+
+/*
+ * Tests for reading/writing registers for the (implemented) event counter
+ * specified by @pmc_idx.
+ */
+static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
+{
+	uint64_t write_data, read_data, read_data_prev;
+
+	/* Disable all PMCs and reset all PMCs to zero. */
+	pmu_disable_reset();
+
+
+	/*
+	 * Tests for reading/writing {PMCNTEN,PMINTEN,PMOVS}{SET,CLR}_EL1.
+	 */
+
+	/* Make sure that the bit in those registers are set to 0 */
+	test_bitmap_pmu_regs(pmc_idx, false);
+	/* Test if setting the bit in those registers works */
+	test_bitmap_pmu_regs(pmc_idx, true);
+	/* Test if clearing the bit in those registers works */
+	test_bitmap_pmu_regs(pmc_idx, false);
+
+
+	/*
+	 * Tests for reading/writing the event type register.
+	 */
+
+	read_data = acc->read_typer(pmc_idx);
+	/*
+	 * Set the event type register to an arbitrary value just for testing
+	 * of reading/writing the register.
+	 * ArmARM says that for the event from 0x0000 to 0x003F,
+	 * the value indicated in the PMEVTYPER<n>_EL0.evtCount field is
+	 * the value written to the field even when the specified event
+	 * is not supported.
+	 */
+	write_data = (ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMUV3_PERFCTR_INST_RETIRED);
+	acc->write_typer(pmc_idx, write_data);
+	read_data = acc->read_typer(pmc_idx);
+	GUEST_ASSERT_4(read_data == write_data,
+		       pmc_idx, acc, read_data, write_data);
+
+
+	/*
+	 * Tests for reading/writing the event count register.
+	 */
+
+	read_data = acc->read_cntr(pmc_idx);
+
+	/* The count value must be 0, as it is not used after the reset */
+	GUEST_ASSERT_3(read_data == 0, pmc_idx, acc, read_data);
+
+	write_data = read_data + pmc_idx + 0x12345;
+	acc->write_cntr(pmc_idx, write_data);
+	read_data = acc->read_cntr(pmc_idx);
+	GUEST_ASSERT_4(read_data == write_data,
+		       pmc_idx, acc, read_data, write_data);
+
+
+	/* The following test requires the INST_RETIRED event support. */
+	if (!pmu_event_is_supported(ARMV8_PMUV3_PERFCTR_INST_RETIRED))
+		return;
+
+	pmu_enable();
+	acc->write_typer(pmc_idx, ARMV8_PMUV3_PERFCTR_INST_RETIRED);
+
+	/*
+	 * Make sure that the counter doesn't count the INST_RETIRED
+	 * event when disabled, and the counter counts the event when enabled.
+	 */
+	disable_counter(pmc_idx);
+	read_data_prev = acc->read_cntr(pmc_idx);
+	read_data = acc->read_cntr(pmc_idx);
+	GUEST_ASSERT_4(read_data == read_data_prev,
+		       pmc_idx, acc, read_data, read_data_prev);
+
+	enable_counter(pmc_idx);
+	read_data = acc->read_cntr(pmc_idx);
+
+	/*
+	 * The counter should be increased by at least 1, as there is at
+	 * least one instruction between enabling the counter and reading
+	 * the counter (the test assumes that all event counters are not
+	 * being used by the host's higher priority events).
+	 */
+	GUEST_ASSERT_4(read_data > read_data_prev,
+		       pmc_idx, acc, read_data, read_data_prev);
+}
+
 /*
  * The guest is configured with PMUv3 with @expected_pmcr_n number of
  * event counters.
- * Check if @expected_pmcr_n is consistent with PMCR_EL0.N.
+ * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
+ * if reading/writing PMU registers for implemented counters can work
+ * as expected.
  */
 static void guest_code(uint64_t expected_pmcr_n)
 {
 	uint64_t pmcr, pmcr_n;
+	int i, pmc;
 
 	GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS);
 
@@ -35,6 +370,15 @@ static void guest_code(uint64_t expected_pmcr_n)
 	/* Make sure that PMCR_EL0.N indicates the value userspace set */
 	GUEST_ASSERT_2(pmcr_n == expected_pmcr_n, pmcr_n, expected_pmcr_n);
 
+	/*
+	 * Tests for reading/writing PMU registers for implemented counters.
+	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		for (pmc = 0; pmc < pmcr_n; pmc++)
+			test_access_pmc_regs(&pmc_accessors[i], pmc);
+	}
+
 	GUEST_DONE();
 }
 
@@ -91,7 +435,7 @@ static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_2(uc, "values:%#lx %#lx");
+		REPORT_GUEST_ASSERT_4(uc, "values:%#lx %#lx %#lx %#lx");
 		break;
 	case UCALL_DONE:
 		break;
-- 
2.39.1.581.gbfd45094c4-goog

