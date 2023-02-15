Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB79369731F
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjBOBHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjBOBHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:07:30 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1E62CC42
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:26 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52f1641b79aso89089227b3.16
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cu9ya3q/z6nc/xU+J5zlAOmWao9LGcxeHPAl4gmxetg=;
        b=K5wam+e+wpbMEHXcHiGE71fKuJ39a7A9AaRX308CunrTvb0vwUxmjkdYru/4ZZ9lcp
         GOK58ahy2vLxBI5aJ95hc4A02kHTx/vjtcI3f/aRxFDj6TGV5SH739yiY5+dwCI7hylo
         jAtNJXyy4Wb/jn2bkfXXjF0oGSEH44fhEwzxr4dl0sLFjnkg4KVqeNlC/cHp0DRlrLT6
         EaUfFZaPokh4MYxeDbdIVCAsMRJ8HjXgXjnfyZKC9SvxHGPKKD2ZLwGXC5BkpWKXgBaS
         6p/gxgoKuoAo6bfnwwGJO+B7Od8+AfUEgd9tZ5Q9boXyh6S53MWaD/vl3cWA3TvwkwKN
         yK0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cu9ya3q/z6nc/xU+J5zlAOmWao9LGcxeHPAl4gmxetg=;
        b=KJt+lhttRUKwKDZObg6oyJk/Du+CvC5LOBm7Wl03f20YzpLVoYRM1OE/a7kdWjTVVi
         2FYj/xzoO9yc8joZowDfBDe2we/5AE25C3vOk+/1um68Wa/A8+AW3pyELwp5n2dJv3lx
         MC2XsP8ydpz9p9j5rMXMWfjPxGG+d81AB+JCXftAL2iXBXrAHA7d5GIz54t0f9+wmZES
         IQiEj7Q7+0Ofe2G0XXNYRlZUgcvgdXJRYuSsQcZBpBCz+h2QzWB+tq0R6oFEG30D/0qW
         i8uqTw2nuCOsA+c9Rn3mHYo8r1XWjwn2cKYLf9L3JbmGVtctnnWfY83a8QtEkokNjesA
         ZkPg==
X-Gm-Message-State: AO0yUKWtdoLYk8e3ue1IlhJi9SoqAquXK7/0gHp7sr49sZziTowD22A1
        NwumKX32pBUgRoFHsMhnQhlkh/8UdFhe
X-Google-Smtp-Source: AK7set92VavwRC6hdtJrTarPTSUlJGunS3jkjl3HEw2Yfq8P8qkaZHe1cu0aIME/YVHWyQdR1zJIYVU7SBdw
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6902:18b:b0:80b:b72a:34c0 with SMTP id
 t11-20020a056902018b00b0080bb72a34c0mr38461ybh.80.1676423246098; Tue, 14 Feb
 2023 17:07:26 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:06 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-6-rananta@google.com>
Subject: [REPOST PATCH 05/16] selftests: KVM: aarch64: Refactor the vPMU
 counter access tests
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

Refactor the existing counter access tests into its own
independent functions and make running the tests generic
to make way for the upcoming tests.

As a part of the refactoring, rename the test file to a more
genetric name vpmu_test.c.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../{vpmu_counter_access.c => vpmu_test.c}    | 142 ++++++++++++------
 2 files changed, 100 insertions(+), 44 deletions(-)
 rename tools/testing/selftests/kvm/aarch64/{vpmu_counter_access.c => vpmu_test.c} (88%)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index b27fea0ce5918..a4d262e139b18 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -143,7 +143,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
-TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
+TEST_GEN_PROGS_aarch64 += aarch64/vpmu_test
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
similarity index 88%
rename from tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
rename to tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 453f0dd240f44..d72c3c9b9c39f 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * vpmu_counter_access - Test vPMU event counter access
+ * vpmu_test - Test the vPMU
  *
  * Copyright (c) 2022 Google LLC.
  *
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

