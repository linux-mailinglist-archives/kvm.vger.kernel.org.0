Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3E6694EA5
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 19:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjBMSCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 13:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjBMSCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 13:02:50 -0500
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3933D1F907
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:42 -0800 (PST)
Received: by mail-il1-x149.google.com with SMTP id v17-20020a92ab11000000b00310c6708243so9945299ilh.23
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 10:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AsmO5eDYgPGzRFknyAuV3lp4/AdQBm/C7SIWaQDWgzs=;
        b=Cwyfu8Bq2PKtWPxrul5ebBEulrHVwsUaI40rkksHoY18wRNmgXilA9Ert3lhPhjxON
         UCkt9lQB7j/+RRwya+RbcV290veQl/3Jw9F88H6SqsjLrU4nnVODSYYiH9eJRouyB6II
         /qsFUZ1PIKaOYDahsLErY6Coe/tm9FDtSwspmSQtN/9CvXjv2wMaURvCiX889j+22PzX
         vuO8LqDxX6XxAYUscu7nk0JOconpZMPtvAIYFtHR8VruBW6vPhrRKWjPWxxQXFkgIak3
         EoV8Q6qNkksBj3c9dDHndoddsc+ebUAGqCjGhrZUp5yDhA/EKml6KO8XoFTYbGu4zm9S
         Fz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AsmO5eDYgPGzRFknyAuV3lp4/AdQBm/C7SIWaQDWgzs=;
        b=x3TXxq/4mGyXElVhfXPoP4zjnpu/ibc6sRCdY/vqJbDHTyjXxWvDvKwJyPNWUH9XsC
         MYU+XEeXjo2ZucRl2xyHbE6ckK5tHaIVRy9P2Jnj25Yk4y3UGvITTZWm5ATlm4YTvxJR
         5Om0WqrUum7YGlREJzgCBr/fGjG2ea4dflXKV9bIs9G6BwQ1ku6/Hii1RLvSKjIkM5xX
         zgibRmhlzLxXSFm+unUP1HhAPUcrSfQLF8LLzBD2IyRrTKHQLr+UfsEqI8zX5LXX2ku1
         ZOcO7jZxbvGk5y6nH98I9fb+k6dKfYSP4RMeKZnMR+ZRIJbTkpQfCH/gFNLN7Rhc5Lms
         MrhA==
X-Gm-Message-State: AO0yUKUtkY+xZy3jDOQoYeyGhjNZB5ARLUtU5xbD6AIMuzm0ncbHsJLd
        13l2QHM7ddswz1pAIo35UWV6mSzuMCvO
X-Google-Smtp-Source: AK7set9pNf3dQ3WTwUtipCs3HqOPBdYIZEdSHW/5bEFYmaEXSbjn7kq84XWVTKBORlsRqT+UT9RJi2sQZ2qi
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:a144:0:b0:3c4:8536:446a with SMTP id
 m4-20020a02a144000000b003c48536446amr241jah.1.1676311361559; Mon, 13 Feb 2023
 10:02:41 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:02:23 +0000
In-Reply-To: <20230213180234.2885032-1-rananta@google.com>
Mime-Version: 1.0
References: <20230213180234.2885032-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213180234.2885032-3-rananta@google.com>
Subject: [PATCH 02/13] selftests: KVM: aarch64: Refactor the vPMU counter
 access tests
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

Refactor the existing counter access tests into its own
independent functions and make running the tests generic
to make way for the upcoming tests.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 140 ++++++++++++------
 1 file changed, 98 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 581be0c463ad1..d72c3c9b9c39f 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -147,6 +147,11 @@ static inline void disable_counter(int idx)
 	isb();
 }
 
+static inline uint64_t get_pmcr_n(void)
+{
+	return FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0));
+}
+
 /*
  * The pmc_accessor structure has pointers to PMEV{CNTR,TYPER}<n>_EL0
  * accessors that test cases will use. Each of the accessors will
@@ -183,6 +188,23 @@ struct pmc_accessor pmc_accessors[] = {
 uint64_t expected_ec = INVALID_EC;
 uint64_t op_end_addr;
 
+struct vpmu_vm {
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd;
+};
+
+enum test_stage {
+	TEST_STAGE_COUNTER_ACCESS = 1,
+};
+
+struct guest_data {
+	enum test_stage test_stage;
+	uint64_t expected_pmcr_n;
+};
+
+static struct guest_data guest_data;
+
 static void guest_sync_handler(struct ex_regs *regs)
 {
 	uint64_t esr, ec;
@@ -295,7 +317,7 @@ static void test_bitmap_pmu_regs(int pmc_idx, bool set_op)
 		write_sysreg(test_bit, pmovsset_el0);
 
 		/* The bit will be set only if the counter is implemented */
-		pmcr_n = FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0));
+		pmcr_n = get_pmcr_n();
 		set_expected = (pmc_idx < pmcr_n) ? true : false;
 	} else {
 		write_sysreg(test_bit, pmcntenclr_el0);
@@ -424,15 +446,14 @@ static void test_access_invalid_pmc_regs(struct pmc_accessor *acc, int pmc_idx)
  * if reading/writing PMU registers for implemented or unimplemented
  * counters can work as expected.
  */
-static void guest_code(uint64_t expected_pmcr_n)
+static void guest_counter_access_test(uint64_t expected_pmcr_n)
 {
-	uint64_t pmcr, pmcr_n, unimp_mask;
+	uint64_t pmcr_n, unimp_mask;
 	int i, pmc;
 
 	GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS);
 
-	pmcr = read_sysreg(pmcr_el0);
-	pmcr_n = FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
+	pmcr_n = get_pmcr_n();
 
 	/* Make sure that PMCR_EL0.N indicates the value userspace set */
 	GUEST_ASSERT_2(pmcr_n == expected_pmcr_n, pmcr_n, expected_pmcr_n);
@@ -462,6 +483,18 @@ static void guest_code(uint64_t expected_pmcr_n)
 		for (pmc = pmcr_n; pmc < ARMV8_PMU_MAX_GENERAL_COUNTERS; pmc++)
 			test_access_invalid_pmc_regs(&pmc_accessors[i], pmc);
 	}
+}
+
+static void guest_code(void)
+{
+	switch (guest_data.test_stage) {
+	case TEST_STAGE_COUNTER_ACCESS:
+		guest_counter_access_test(guest_data.expected_pmcr_n);
+		break;
+	default:
+		GUEST_ASSERT_1(0, guest_data.test_stage);
+	}
+
 	GUEST_DONE();
 }
 
@@ -469,14 +502,14 @@ static void guest_code(uint64_t expected_pmcr_n)
 #define GICR_BASE_GPA	0x80A0000ULL
 
 /* Create a VM that has one vCPU with PMUv3 configured. */
-static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
-				     int *gic_fd)
+static struct vpmu_vm *create_vpmu_vm(void *guest_code)
 {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vcpu_init init;
 	uint8_t pmuver, ec;
 	uint64_t dfr0, irq = 23;
+	struct vpmu_vm *vpmu_vm;
 	struct kvm_device_attr irq_attr = {
 		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
 		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
@@ -487,7 +520,10 @@ static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
 		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
 	};
 
-	vm = vm_create(1);
+	vpmu_vm = calloc(1, sizeof(*vpmu_vm));
+	TEST_ASSERT(vpmu_vm, "Failed to allocate vpmu_vm");
+
+	vpmu_vm->vm = vm = vm_create(1);
 	vm_init_descriptor_tables(vm);
 	/* Catch exceptions for easier debugging */
 	for (ec = 0; ec < ESR_EC_NUM; ec++) {
@@ -498,9 +534,9 @@ static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
 	/* Create vCPU with PMUv3 */
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
-	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	vpmu_vm->vcpu = vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
 	vcpu_init_descriptor_tables(vcpu);
-	*gic_fd = vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	vpmu_vm->gic_fd = vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
 
 	/* Make sure that PMUv3 support is indicated in the ID register */
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
@@ -513,15 +549,21 @@ static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
 	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
 	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
 
-	*vcpup = vcpu;
-	return vm;
+	return vpmu_vm;
+}
+
+static void destroy_vpmu_vm(struct vpmu_vm *vpmu_vm)
+{
+	close(vpmu_vm->gic_fd);
+	kvm_vm_free(vpmu_vm->vm);
+	free(vpmu_vm);
 }
 
-static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
+static void run_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
-	vcpu_args_set(vcpu, 1, pmcr_n);
+	sync_global_to_guest(vcpu->vm, guest_data);
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
@@ -539,16 +581,18 @@ static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
  * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
  * and run the test.
  */
-static void run_test(uint64_t pmcr_n)
+static void run_counter_access_test(uint64_t pmcr_n)
 {
-	struct kvm_vm *vm;
+	struct vpmu_vm *vpmu_vm;
 	struct kvm_vcpu *vcpu;
-	int gic_fd;
 	uint64_t sp, pmcr, pmcr_orig;
 	struct kvm_vcpu_init init;
 
+	guest_data.expected_pmcr_n = pmcr_n;
+
 	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
-	vm = create_vpmu_vm(guest_code, &vcpu, &gic_fd);
+	vpmu_vm = create_vpmu_vm(guest_code);
+	vcpu = vpmu_vm->vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
 	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
@@ -559,23 +603,22 @@ static void run_test(uint64_t pmcr_n)
 	pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
 
-	run_vcpu(vcpu, pmcr_n);
+	run_vcpu(vcpu);
 
 	/*
 	 * Reset and re-initialize the vCPU, and run the guest code again to
 	 * check if PMCR_EL0.N is preserved.
 	 */
-	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	vm_ioctl(vpmu_vm->vm, KVM_ARM_PREFERRED_TARGET, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	aarch64_vcpu_setup(vcpu, &init);
 	vcpu_init_descriptor_tables(vcpu);
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
 
-	run_vcpu(vcpu, pmcr_n);
+	run_vcpu(vcpu);
 
-	close(gic_fd);
-	kvm_vm_free(vm);
+	destroy_vpmu_vm(vpmu_vm);
 }
 
 /*
@@ -583,15 +626,18 @@ static void run_test(uint64_t pmcr_n)
  * the vCPU to @pmcr_n, which is larger than the host value.
  * The attempt should fail as @pmcr_n is too big to set for the vCPU.
  */
-static void run_error_test(uint64_t pmcr_n)
+static void run_counter_access_error_test(uint64_t pmcr_n)
 {
-	struct kvm_vm *vm;
+	struct vpmu_vm *vpmu_vm;
 	struct kvm_vcpu *vcpu;
-	int gic_fd, ret;
+	int ret;
 	uint64_t pmcr, pmcr_orig;
 
+	guest_data.expected_pmcr_n = pmcr_n;
+
 	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
-	vm = create_vpmu_vm(guest_code, &vcpu, &gic_fd);
+	vpmu_vm = create_vpmu_vm(guest_code);
+	vcpu = vpmu_vm->vcpu;
 
 	/* Update the PMCR_EL0.N with @pmcr_n */
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
@@ -603,8 +649,25 @@ static void run_error_test(uint64_t pmcr_n)
 	TEST_ASSERT(ret, "Setting PMCR to 0x%lx (orig PMCR 0x%lx) didn't fail",
 		    pmcr, pmcr_orig);
 
-	close(gic_fd);
-	kvm_vm_free(vm);
+	destroy_vpmu_vm(vpmu_vm);
+}
+
+static void run_counter_access_tests(uint64_t pmcr_n)
+{
+	uint64_t i;
+
+	guest_data.test_stage = TEST_STAGE_COUNTER_ACCESS;
+
+	for (i = 0; i <= pmcr_n; i++)
+		run_counter_access_test(i);
+
+	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
+		run_counter_access_error_test(i);
+}
+
+static void run_tests(uint64_t pmcr_n)
+{
+	run_counter_access_tests(pmcr_n);
 }
 
 /*
@@ -613,30 +676,23 @@ static void run_error_test(uint64_t pmcr_n)
  */
 static uint64_t get_pmcr_n_limit(void)
 {
-	struct kvm_vm *vm;
-	struct kvm_vcpu *vcpu;
-	int gic_fd;
+	struct vpmu_vm *vpmu_vm;
 	uint64_t pmcr;
 
-	vm = create_vpmu_vm(guest_code, &vcpu, &gic_fd);
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
-	close(gic_fd);
-	kvm_vm_free(vm);
+	vpmu_vm = create_vpmu_vm(guest_code);
+	vcpu_get_reg(vpmu_vm->vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	destroy_vpmu_vm(vpmu_vm);
 	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
 }
 
 int main(void)
 {
-	uint64_t i, pmcr_n;
+	uint64_t pmcr_n;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
 
 	pmcr_n = get_pmcr_n_limit();
-	for (i = 0; i <= pmcr_n; i++)
-		run_test(i);
-
-	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
-		run_error_test(i);
+	run_tests(pmcr_n);
 
 	return 0;
 }
-- 
2.39.1.581.gbfd45094c4-goog

