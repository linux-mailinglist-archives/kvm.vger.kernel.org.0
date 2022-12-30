Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480F1659488
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 05:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbiL3EBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 23:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiL3EBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 23:01:31 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1740CD133
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 20:01:29 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id h12-20020a17090a604c00b00225b2dbe4cfso8263875pjm.1
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 20:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TF6mtXCSZiwAgtARbQ5xLSrPWgFz4SHEJ+nKUXLPeJ8=;
        b=sU5Q2FZB1j3zoL2IyByPHp4XXlV347Lgzl2S/dL8FIDS6Q2Gk5gLVaYY0mql2Dp6Ou
         KisxGHgGXlWLqy0KrCm2jzMx6MW2DUdsSKYrvTMRQzTkIP9n++TZxJNW5O7MKxr4/+u1
         y5AtwhDj5bQkpOMw4Rt3TEsg9R3+Nx3N5SwHtOOOHaLq+xbJBQ7qymHu5n5oPGJsFhZD
         JZltvpqhshV0s0u4yV8AiKaVmx6dZd0jT75t4Jl9ACLOcRVNz/c6KlNj8gwquqeyYcTq
         5YaMYUnKjoDopeUfn2jtR5j+bKqWjhgC2qrimfQn1WGUUn8dqPl3crbncgC3P1Un3vGK
         fC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TF6mtXCSZiwAgtARbQ5xLSrPWgFz4SHEJ+nKUXLPeJ8=;
        b=YAhmikUILWn7mOzduqFb7A4AGBlqvodd1L01Q6NuFv6X8m+jhWmcKTEGTBKQPYwwt3
         NZkrGoCMfu1w5s7OxQJ/vQSPY1PttTTraMTX6IQJ15uek2td40cm+BCRqqJvLIFMwTvV
         Z8zM9NaKUVNW06qgisGvtT6xm5ECQA/P3B8kecc/W/8XZThc2VtCJU4iK/7aoOyNptp4
         VavP2iug4yTQze5UwRfewMrdgCAk6CWIAYf5aKyciIWfm/k45+qqhvZtDstyloARPlKp
         F23atdhH9mpWPxGbkBLdOvoWbAvOgL0Lq/7j4sMirgkr17ZyYfDbO1kFeqYIqDj9Ewb0
         /YDw==
X-Gm-Message-State: AFqh2kr7AXbr+5X+tB4KXf2mHAftATPrZf1UcsiE2lgZ3td/quaMWhpx
        lQnLhXt9Rrft+lFyUBaqIqFyMeM4pFo=
X-Google-Smtp-Source: AMrXdXu5U/lKBFXfJCQ+vyRfT4vdWYzYWTLMDKD8zziBxUMakTgcKuR9JnE7SThBpiyZZGBEQxkoI0dzeRs=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90b:4d83:b0:220:1f03:129b with SMTP id
 oj3-20020a17090b4d8300b002201f03129bmr181538pjb.0.1672372888381; Thu, 29 Dec
 2022 20:01:28 -0800 (PST)
Date:   Thu, 29 Dec 2022 19:59:28 -0800
In-Reply-To: <20221230035928.3423990-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230035928.3423990-8-reijiw@google.com>
Subject: [PATCH 7/7] KVM: selftests: aarch64: vPMU register test for
 unimplemented counters
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
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
 .../kvm/aarch64/vpmu_counter_access.c         | 103 +++++++++++++++++-
 .../selftests/kvm/include/aarch64/processor.h |   1 +
 2 files changed, 98 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
index 5b9d837f903a..af1abdfa2be2 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -5,8 +5,8 @@
  * Copyright (c) 2022 Google LLC.
  *
  * This test checks if the guest can see the same number of the PMU event
- * counters (PMCR_EL1.N) that userspace sets, and if the guest can access
- * those counters.
+ * counters (PMCR_EL1.N) that userspace sets, if the guest can access
+ * those counters, and if the guest cannot access any other counters.
  * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
  */
 #include <kvm_util.h>
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
@@ -352,16 +397,38 @@ static void test_access_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
 		       pmc_idx, acc, read_data, read_data_prev);
 }
 
+/*
+ * Tests for reading/writing registers for the unimplemented event counter
+ * specified by @pmc_idx (>= PMCR_EL1.N).
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
@@ -372,6 +439,14 @@ static void guest_code(uint64_t expected_pmcr_n)
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
 	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
@@ -381,6 +456,14 @@ static void guest_code(uint64_t expected_pmcr_n)
 			test_access_pmc_regs(&pmc_accessors[i], pmc);
 	}
 
+	/*
+	 * Tests for reading/writing PMU registers for unimplemented counters.
+	 * Use each combination of PMEVT{CNTR,TYPER}<n>_EL0 accessor functions.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pmc_accessors); i++) {
+		for (pmc = pmcr_n; pmc < ARMV8_PMU_MAX_GENERAL_COUNTERS; pmc++)
+			test_access_invalid_pmc_regs(&pmc_accessors[i], pmc);
+	}
 	GUEST_DONE();
 }
 
@@ -394,7 +477,7 @@ static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vcpu_init init;
-	uint8_t pmuver;
+	uint8_t pmuver, ec;
 	uint64_t dfr0, irq = 23;
 	struct kvm_device_attr irq_attr = {
 		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
@@ -408,11 +491,18 @@ static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
 
 	vm = vm_create(1);
 	ucall_init(vm, NULL);
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
@@ -481,6 +571,7 @@ static void run_test(uint64_t pmcr_n)
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
2.39.0.314.g84b9a713c41-goog

