Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91318692DA0
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 04:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjBKDRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 22:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBKDRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 22:17:11 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41D316ACD
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:58 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id oa13-20020a17090b1bcd00b0023120cf3c2dso4709445pjb.3
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 19:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1n1ZSSh2wSAgJw7Cln005IkKja5FB1PRSIQF1orA4kI=;
        b=F8eM/g390Z7UuzXCu0stoOL5UzNNd2eT6QtL2krL67nCYf2HDd2eDD39n9H88Edncr
         5m0J6/gdEkFWhdxPVU26zjXOhJI2j/9oFSqwu4fLOHX2k+yw9hn5b6t9yw4mJ+ifg80M
         ZwsoaibJRQhjj8RvoBRq3mD9+Z4nQ0vesFT3rF1xwl3t4Ge1Is/bQsQnksiK59Eb4Yt2
         i/s+mz0bM0oHXa3P6zzhIIplJJ8Wgv9OTVtbVJTFseT21sD3UPOWkOCvUFnMGVtatWGQ
         Jaifgva43tVx9b4AjA6mn5eRu15uSfGQrw6beIH6dqbtKw33ouM4J4JmEnMyigUPyBg7
         qShg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1n1ZSSh2wSAgJw7Cln005IkKja5FB1PRSIQF1orA4kI=;
        b=8JrdtCIh53n61DRRYcq/7yO8FDkKLhNn7B0ISkM6D7tIyt/pMWdUfrMIr/M4s7rXmq
         PL+qqHYD+C3pJSc7Iob/ZUkBG/3HGuxpG4sgdM4OW4m4gvFIS4F/V/ib8kug6IalQiLp
         OqpZboSAPxzScPiKHEQ40/PgRk2E+1JAIT5+sQFnanuIAlsZxim30p1kOo7trmEU0Rki
         HUNE9C6pzhdgg3xSGHgbqoqgb8O/5eC0nKvTtDEi180aMXDMwBZqXXQPJtSii9e/7l/c
         cs6N5TwDNOcf6V0pZas/Ubtg1A5/MxpRd2UqsNPq9lzQ/2LzSXsUevrP9dh8UtJkEq28
         SlRw==
X-Gm-Message-State: AO0yUKV7mJd8V0BKHePooGjeLH2qG6M33z0o0EA4fzOfM9KvP68kPPwe
        A1LrsVj8CASw8MECRbI/Z1Spj0u8ogs=
X-Google-Smtp-Source: AK7set9zThTklPx2Okak1Tl1pXqreEEJ8mHT05dSHksc7gy1kyPl6zFtcKyzMrGsT5nx5oj1BwT2Bj4Whzc=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a63:7304:0:b0:4da:d745:98dd with SMTP id
 o4-20020a637304000000b004dad74598ddmr3358702pgc.62.1676085417846; Fri, 10 Feb
 2023 19:16:57 -0800 (PST)
Date:   Fri, 10 Feb 2023 19:15:06 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-15-reijiw@google.com>
Subject: [PATCH v4 14/14] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
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

Add a new test case to the vpmu_counter_access test to check
if PMU registers or their bits for unimplemented counters are not
accessible or are RAZ, as expected.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../kvm/aarch64/vpmu_counter_access.c         | 111 ++++++++++++++++--
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 2 files changed, 102 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index b6593eee2be3..453f0dd240f4 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -5,8 +5,8 @@
  * Copyright (c) 2022 Google LLC.
  *
  * This test checks if the guest can see the same number of the PMU event
- * counters (PMCR_EL0.N) that userspace sets, and if the guest can access
- * those counters.
+ * counters (PMCR_EL0.N) that userspace sets, if the guest can access
+ * those counters, and if the guest cannot access any other counters.
  * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
  */
 #include <kvm_util.h>
@@ -20,7 +20,7 @@
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
 
 /*
- * The macros and functions below for reading/writing PMEVT{CNTR,TYPER}<n>_EL0
+ * The macros and functions below for reading/writing PMEV{CNTR,TYPER}<n>_EL0
  * were basically copied from arch/arm64/kernel/perf_event.c.
  */
 #define PMEVN_CASE(n, case_macro) \
@@ -148,9 +148,9 @@ static inline void disable_counter(int idx)
 }
 
 /*
- * The pmc_accessor structure has pointers to PMEVT{CNTR,TYPER}<n>_EL0
+ * The pmc_accessor structure has pointers to PMEV{CNTR,TYPER}<n>_EL0
  * accessors that test cases will use. Each of the accessors will
- * either directly reads/writes PMEVT{CNTR,TYPER}<n>_EL0
+ * either directly reads/writes PMEV{CNTR,TYPER}<n>_EL0
  * (i.e. {read,write}_pmev{cnt,type}rn()), or reads/writes them through
  * PMXEV{CNTR,TYPER}_EL0 (i.e. {read,write}_sel_ev{cnt,type}r()).
  *
@@ -179,6 +179,51 @@ struct pmc_accessor pmc_accessors[] = {
 	{ read_sel_evcntr, write_pmevcntrn, read_sel_evtyper, write_pmevtypern },
 };
 
+#define INVALID_EC	(-1ul)
+uint64_t expected_ec = INVALID_EC;
+uint64_t op_end_addr;
+
+static void guest_sync_handler(struct ex_regs *regs)
+{
+	uint64_t esr, ec;
+
+	esr = read_sysreg(esr_el1);
+	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
+	GUEST_ASSERT_4(op_end_addr && (expected_ec == ec),
+		       regs->pc, esr, ec, expected_ec);
+
+	/* Will go back to op_end_addr after the handler exits */
+	regs->pc = op_end_addr;
+
+	/*
+	 * Clear op_end_addr, and setting expected_ec to INVALID_EC
+	 * as a sign that an exception has occurred.
+	 */
+	op_end_addr = 0;
+	expected_ec = INVALID_EC;
+}
+
+/*
+ * Run the given operation that should trigger an exception with the
+ * given exception class. The exception handler (guest_sync_handler)
+ * will reset op_end_addr to 0, and expected_ec to INVALID_EC, and
+ * will come back to the instruction at the @done_label.
+ * The @done_label must be a unique label in this test program.
+ */
+#define TEST_EXCEPTION(ec, ops, done_label)		\
+{							\
+	extern int done_label;				\
+							\
+	WRITE_ONCE(op_end_addr, (uint64_t)&done_label);	\
+	GUEST_ASSERT(ec != INVALID_EC);			\
+	WRITE_ONCE(expected_ec, ec);			\
+	dsb(ish);					\
+	ops;						\
+	asm volatile(#done_label":");			\
+	GUEST_ASSERT(!op_end_addr);			\
+	GUEST_ASSERT(expected_ec == INVALID_EC);	\
+}
+
 static void pmu_disable_reset(void)
 {
 	uint64_t pmcr = read_sysreg(pmcr_el0);
@@ -350,16 +395,38 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 		       pmc_idx, acc, read_data, read_data_prev);
 }
 
+/*
+ * Tests for reading/writing registers for the unimplemented event counter
+ * specified by @pmc_idx (>= PMCR_EL0.N).
+ */
+static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
+{
+	/*
+	 * Reading/writing the event count/type registers should cause
+	 * an UNDEFINED exception.
+	 */
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_cntr(pmc_idx), inv_rd_cntr);
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_cntr(pmc_idx, 0), inv_wr_cntr);
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->read_typer(pmc_idx), inv_rd_typer);
+	TEST_EXCEPTION(ESR_EC_UNKNOWN, acc->write_typer(pmc_idx, 0), inv_wr_typer);
+	/*
+	 * The bit corresponding to the (unimplemented) counter in
+	 * {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers should be RAZ.
+	 */
+	test_bitmap_pmu_regs(pmc_idx, 1);
+	test_bitmap_pmu_regs(pmc_idx, 0);
+}
+
 /*
  * The guest is configured with PMUv3 with @expected_pmcr_n number of
  * event counters.
  * Check if @expected_pmcr_n is consistent with PMCR_EL0.N, and
- * if reading/writing PMU registers for implemented counters can work
- * as expected.
+ * if reading/writing PMU registers for implemented or unimplemented
+ * counters can work as expected.
  */
 static void guest_code(uint64_t expected_pmcr_n)
 {
-	uint64_t pmcr, pmcr_n;
+	uint64_t pmcr, pmcr_n, unimp_mask;
 	int i, pmc;
 
 	GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS);
@@ -370,15 +437,31 @@ static void guest_code(uint64_t expected_pmcr_n)
 	/* Make sure that PMCR_EL0.N indicates the value userspace set */
 	GUEST_ASSERT_2(pmcr_n == expected_pmcr_n, pmcr_n, expected_pmcr_n);
 
+	/*
+	 * Make sure that (RAZ) bits corresponding to unimplemented event
+	 * counters in {PMCNTEN,PMOVS}{SET,CLR}_EL1 registers are reset to zero.
+	 * (NOTE: bits for implemented event counters are reset to UNKNOWN)
+	 */
+	unimp_mask = GENMASK_ULL(ARMV8_PMU_MAX_GENERAL_COUNTERS - 1, pmcr_n);
+	check_bitmap_pmu_regs(unimp_mask, false);
+
 	/*
 	 * Tests for reading/writing PMU registers for implemented counters.
-	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
+	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
 	 */
 	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
 		for (pmc = 0; pmc < pmcr_n; pmc++)
 			test_access_pmc_regs(&pmc_accessors[i], pmc);
 	}
 
+	/*
+	 * Tests for reading/writing PMU registers for unimplemented counters.
+	 * Use each combination of PMEV{CNTR,TYPER}<n>_EL0 accessor functions.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		for (pmc = pmcr_n; pmc < ARMV8_PMU_MAX_GENERAL_COUNTERS; pmc++)
+			test_access_invalid_pmc_regs(&pmc_accessors[i], pmc);
+	}
 	GUEST_DONE();
 }
 
@@ -392,7 +475,7 @@ static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vcpu_init init;
-	uint8_t pmuver;
+	uint8_t pmuver, ec;
 	uint64_t dfr0, irq = 23;
 	struct kvm_device_attr irq_attr = {
 		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
@@ -405,11 +488,18 @@ static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
 	};
 
 	vm = vm_create(1);
+	vm_init_descriptor_tables(vm);
+	/* Catch exceptions for easier debugging */
+	for (ec = 0; ec < ESR_EC_NUM; ec++) {
+		vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ec,
+					guest_sync_handler);
+	}
 
 	/* Create vCPU with PMUv3 */
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	vcpu_init_descriptor_tables(vcpu);
 	*gic_fd = vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
 
 	/* Make sure that PMUv3 support is indicated in the ID register */
@@ -478,6 +568,7 @@ static void run_test(uint64_t pmcr_n)
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	aarch64_vcpu_setup(vcpu, &init);
+	vcpu_init_descriptor_tables(vcpu);
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
 
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 5f977528e09c..52d87809356c 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -104,6 +104,7 @@ enum {
 #define ESR_EC_SHIFT		26
 #define ESR_EC_MASK		(ESR_EC_NUM - 1)
 
+#define ESR_EC_UNKNOWN		0x0
 #define ESR_EC_SVC64		0x15
 #define ESR_EC_IABT		0x21
 #define ESR_EC_DABT		0x25
-- 
2.39.1.581.gbfd45094c4-goog

