Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E67BEEF0
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 01:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbjJIXK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 19:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbjJIXKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 19:10:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36177213C
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 16:09:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d99ec34829aso2312647276.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 16:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892955; x=1697497755; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q8/cmG/jke0wkFBeJgCzx1lwtlcLEtavaqJIlkPbcBE=;
        b=2Mixq2kf6nw83p3ea4/RXBzZZcOGRyQhTXt2MS++l+jocCGgGHCwTbsGsY8h5JsXeB
         zIJlKHYSEyF8VLTz4sMISzz0swhMMsfXuxotOiIXuw3yiM7TDjJWvsMsenK8h1DNOWHn
         563jdQBAlZs74X9HM9EeVRS3XktgsyH/omdDQhUG7EthIALqKGbxa0BwTwMLZcW+0PIa
         gtRp/v7yvbYaW6UGH0CqO2HRdKlo7SDAh3IV5ia8WHjAXhMte/Rf7w+uzHhAmmJ4l3Nk
         P2yOAhys1jihd4q69Kll1NGpgZKkawOBtRgfMhX4CGVHNeltTmL/1aOmsUQIb+2qgK0Z
         PWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892955; x=1697497755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8/cmG/jke0wkFBeJgCzx1lwtlcLEtavaqJIlkPbcBE=;
        b=b9jVLkUbzJpQA9698TyqcbkYgmdsEa88RoosLSmte95oGlztS388TnSQ7gF79L1GKh
         Ees/rnXspex0HkhUWcnCQul0mhvxzg2Q1Yde3ma9wd+7rt8CVYjgCMosqzuliHtxU18C
         SqIOxqxjtRHEz2mwFoSwU9RbUYWG49lmmDFUUIf6Xj2O7rcDfyOAbbdyMPS1MNgGd5Z8
         Wz8nKoLohW3vDps3An1mQSqt7ShZKd0sbNKWc/7sRKaZPx+JE/P72o5oqlTTqEGGewsD
         1NN3o4yWONGkDD0FWQChSfRr0tuf8cYMhicw74n/0dZdLdxugWzpBW8npf5p/0RFvg1N
         Hj/g==
X-Gm-Message-State: AOJu0Yy+629g+hsDSvlNHcZ5bmuZeuQuASxZ1sKIyodgnOmZC299smnA
        WVWSvSRs2eBNIXtkVXYqvyhimZ4tkNe2
X-Google-Smtp-Source: AGHT+IHWBVtIEVs2Pw2XqRlLgy5B50Lv0bfYwMqm0TejYiOhthdyHNufIfFC8cl7XhDghdpnjrtALhBKTu2Y
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a05:6902:24e:b0:d99:3750:d607 with SMTP id
 k14-20020a056902024e00b00d993750d607mr144704ybs.8.1696892955190; Mon, 09 Oct
 2023 16:09:15 -0700 (PDT)
Date:   Mon,  9 Oct 2023 23:08:57 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-12-rananta@google.com>
Subject: [PATCH v7 11/12] KVM: selftests: aarch64: vPMU register test for
 implemented counters
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

Add a new test case to the vpmu_counter_access test to check if PMU
registers or their bits for implemented counters on the vCPU are
readable/writable as expected, and can be programmed to count events.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../kvm/aarch64/vpmu_counter_access.c         | 270 +++++++++++++++++-
 1 file changed, 268 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 58949b17d76e..e92af3c0db03 100644
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
@@ -37,6 +38,259 @@ static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
 	*pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
 }
 
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
+/*
+ * Convert a pointer of pmc_accessor to an index in pmc_accessors[],
+ * assuming that the pointer is one of the entries in pmc_accessors[].
+ */
+#define PMC_ACC_TO_IDX(acc)	(acc - &pmc_accessors[0])
+
+#define GUEST_ASSERT_BITMAP_REG(regname, mask, set_expected)			 \
+{										 \
+	uint64_t _tval = read_sysreg(regname);					 \
+										 \
+	if (set_expected)							 \
+		__GUEST_ASSERT((_tval & mask),					 \
+				"tval: 0x%lx; mask: 0x%lx; set_expected: 0x%lx", \
+				_tval, mask, set_expected);			 \
+	else									 \
+		__GUEST_ASSERT(!(_tval & mask),					 \
+				"tval: 0x%lx; mask: 0x%lx; set_expected: 0x%lx", \
+				_tval, mask, set_expected);			 \
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
+		pmcr_n = get_pmcr_n(read_sysreg(pmcr_el0));
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
+	uint64_t write_data, read_data;
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
+	__GUEST_ASSERT(read_data == write_data,
+		       "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx; write_data: 0x%lx",
+		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
+
+
+	/*
+	 * Tests for reading/writing the event count register.
+	 */
+
+	read_data = acc->read_cntr(pmc_idx);
+
+	/* The count value must be 0, as it is not used after the reset */
+	__GUEST_ASSERT(read_data == 0,
+		       "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx",
+		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data);
+
+	write_data = read_data + pmc_idx + 0x12345;
+	acc->write_cntr(pmc_idx, write_data);
+	read_data = acc->read_cntr(pmc_idx);
+	__GUEST_ASSERT(read_data == write_data,
+		       "pmc_idx: 0x%lx; acc_idx: 0x%lx; read_data: 0x%lx; write_data: 0x%lx",
+		       pmc_idx, PMC_ACC_TO_IDX(acc), read_data, write_data);
+}
+
 static void guest_sync_handler(struct ex_regs *regs)
 {
 	uint64_t esr, ec;
@@ -49,11 +303,14 @@ static void guest_sync_handler(struct ex_regs *regs)
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
 
 	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
 			"Expected PMCR.N: 0x%lx; ARMv8 general counters: 0x%lx",
@@ -67,6 +324,15 @@ static void guest_code(uint64_t expected_pmcr_n)
 			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
 			pmcr_n, expected_pmcr_n);
 
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
 
-- 
2.42.0.609.gbb76f46606-goog

