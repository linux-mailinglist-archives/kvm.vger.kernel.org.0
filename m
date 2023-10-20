Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA9B7D1858
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 23:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345393AbjJTVl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 17:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345374AbjJTVlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 17:41:23 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C059D10D4
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a8ead739c3so17198977b3.3
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 14:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697838066; x=1698442866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L236C8yOZWDE7W9p7++uJvgiZykA3vOascJYMI8fzRM=;
        b=l5aVentSQDePVV8ZmrggGn6EEcx8fZK/STxkTcvWIDkZn3n7vIwzRn5S/eaxArLHtP
         Z+98Gr1rUnE44S8+hdZ/Y3ErMfdJYnLe1EEGXfjCjvkz/0Woob3SkXnpRdcNsFgMm84+
         PCGpPbOc+cNKH7z5UB0Ufc4psc44wZCQSZkqdku5QbUySZpKhZRGwhdKKVhlK/s5ZHtf
         FzVU9dwllwLuaHOCys6YYl1olBKNlrlSnJCJhBlRM5m8rv3CM+LxQxN5D0ta4e3b3LBK
         /5zBYF/IFEX9KevzkW0KpRVTuNI312ScbhG/clrt0jwHrxwzLDGuuU1vwX6bd0oBm9kT
         pRLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697838066; x=1698442866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L236C8yOZWDE7W9p7++uJvgiZykA3vOascJYMI8fzRM=;
        b=byWOwOAFcqs1q/pB0Y5Pk1qteQrzKotHbFJI8phjohWzcEJdsglxexlxUZklqnrFVE
         pnJi1RxLbdGXGVP1F9wTR/PA7rb7QUJiDMY3gUYWm574/n2NlLwEwee0TU/TpPYbCV4j
         z9H//qLsF9zVgz2r3j97eSTFTM1a6w/vpCsl9M6fABB3tsiGeIYUUng5mkpoiYYnSREP
         EB9tyzlTMPkozyYmdvhgFjKPFYvJmCsRR0XnDWA+AmL1Yr3GdxIMXZ0MdNwES6mZmbMp
         i4ld44cohjC2VnMgIYItRMcZG+tx0zf8A1BGBsxoZKFNNuMHhNdT9La/C+k/TkqiJayX
         HjMw==
X-Gm-Message-State: AOJu0YwTcF4ZEHIzm0TC7xZ7EbL4thnPIgcOqknVVsvogby8h5gROkCu
        Oug43lmZr0uzh4aJkwotIHw7dSOUD9P2
X-Google-Smtp-Source: AGHT+IEKtqlRWTU3SbNUgdAXBKzM4uYvNHQD9Rmb0mjqTbkN6voYtOq+M32+o1v5cHnwMXGrACQqj+xxEoi+
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a81:a04a:0:b0:5a7:be10:461d with SMTP id
 x71-20020a81a04a000000b005a7be10461dmr73448ywg.2.1697838065932; Fri, 20 Oct
 2023 14:41:05 -0700 (PDT)
Date:   Fri, 20 Oct 2023 21:40:49 +0000
In-Reply-To: <20231020214053.2144305-1-rananta@google.com>
Mime-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <20231020214053.2144305-10-rananta@google.com>
Subject: [PATCH v8 09/13] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

Introduce vpmu_counter_access test for arm64 platforms.
The test configures PMUv3 for a vCPU, sets PMCR_EL0.N for the vCPU,
and check if the guest can consistently see the same number of the
PMU event counters (PMCR_EL0.N) that userspace sets.
This test case is done with each of the PMCR_EL0.N values from
0 to 31 (With the PMCR_EL0.N values greater than the host value,
the test expects KVM_SET_ONE_REG for the PMCR_EL0 to fail).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 255 ++++++++++++++++++
 2 files changed, 256 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4f4f6ad025f4b..f047eda7b1c0b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -161,6 +161,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
new file mode 100644
index 0000000000000..4c6e1fe87e0e6
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vpmu_counter_access - Test vPMU event counter access
+ *
+ * Copyright (c) 2023 Google LLC.
+ *
+ * This test checks if the guest can see the same number of the PMU event
+ * counters (PMCR_EL0.N) that userspace sets.
+ * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
+ */
+#include <kvm_util.h>
+#include <processor.h>
+#include <test_util.h>
+#include <vgic.h>
+#include <perf/arm_pmuv3.h>
+#include <linux/bitfield.h>
+
+/* The max number of the PMU event counters (excluding the cycle counter) */
+#define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
+
+struct vpmu_vm {
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd;
+};
+
+static struct vpmu_vm vpmu_vm;
+
+static uint64_t get_pmcr_n(uint64_t pmcr)
+{
+	return (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+}
+
+static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
+{
+	*pmcr = *pmcr & ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	*pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
+}
+
+static void guest_sync_handler(struct ex_regs *regs)
+{
+	uint64_t esr, ec;
+
+	esr = read_sysreg(esr_el1);
+	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
+	__GUEST_ASSERT(0, "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx", regs->pc, esr, ec);
+}
+
+/*
+ * The guest is configured with PMUv3 with @expected_pmcr_n number of
+ * event counters.
+ * Check if @expected_pmcr_n is consistent with PMCR_EL0.N.
+ */
+static void guest_code(uint64_t expected_pmcr_n)
+{
+	uint64_t pmcr, pmcr_n;
+
+	__GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS,
+			"Expected PMCR.N: 0x%lx; ARMv8 general counters: 0x%lx",
+			expected_pmcr_n, ARMV8_PMU_MAX_GENERAL_COUNTERS);
+
+	pmcr = read_sysreg(pmcr_el0);
+	pmcr_n = get_pmcr_n(pmcr);
+
+	/* Make sure that PMCR_EL0.N indicates the value userspace set */
+	__GUEST_ASSERT(pmcr_n == expected_pmcr_n,
+			"Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
+			expected_pmcr_n, pmcr_n);
+
+	GUEST_DONE();
+}
+
+#define GICD_BASE_GPA	0x8000000ULL
+#define GICR_BASE_GPA	0x80A0000ULL
+
+/* Create a VM that has one vCPU with PMUv3 configured. */
+static void create_vpmu_vm(void *guest_code)
+{
+	struct kvm_vcpu_init init;
+	uint8_t pmuver, ec;
+	uint64_t dfr0, irq = 23;
+	struct kvm_device_attr irq_attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
+		.addr = (uint64_t)&irq,
+	};
+	struct kvm_device_attr init_attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
+	};
+
+	/* The test creates the vpmu_vm multiple times. Ensure a clean state */
+	memset(&vpmu_vm, 0, sizeof(vpmu_vm));
+
+	vpmu_vm.vm = vm_create(1);
+	vm_init_descriptor_tables(vpmu_vm.vm);
+	for (ec = 0; ec < ESR_EC_NUM; ec++) {
+		vm_install_sync_handler(vpmu_vm.vm, VECTOR_SYNC_CURRENT, ec,
+					guest_sync_handler);
+	}
+
+	/* Create vCPU with PMUv3 */
+	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
+	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
+	vpmu_vm.gic_fd = vgic_v3_setup(vpmu_vm.vm, 1, 64,
+					GICD_BASE_GPA, GICR_BASE_GPA);
+	__TEST_REQUIRE(vpmu_vm.gic_fd >= 0,
+		       "Failed to create vgic-v3, skipping");
+
+	/* Make sure that PMUv3 support is indicated in the ID register */
+	vcpu_get_reg(vpmu_vm.vcpu,
+		     KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
+	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), dfr0);
+	TEST_ASSERT(pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF &&
+		    pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP,
+		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
+
+	/* Initialize vPMU */
+	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
+	vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
+}
+
+static void destroy_vpmu_vm(void)
+{
+	close(vpmu_vm.gic_fd);
+	kvm_vm_free(vpmu_vm.vm);
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
+{
+	struct ucall uc;
+
+	vcpu_args_set(vcpu, 1, pmcr_n);
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		break;
+	}
+}
+
+static void test_create_vpmu_vm_with_pmcr_n(uint64_t pmcr_n, bool expect_fail)
+{
+	struct kvm_vcpu *vcpu;
+	uint64_t pmcr, pmcr_orig;
+
+	create_vpmu_vm(guest_code);
+	vcpu = vpmu_vm.vcpu;
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
+	pmcr = pmcr_orig;
+
+	/*
+	 * Setting a larger value of PMCR.N should not modify the field, and
+	 * return a success.
+	 */
+	set_pmcr_n(&pmcr, pmcr_n);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+
+	if (expect_fail)
+		TEST_ASSERT(pmcr_orig == pmcr,
+			    "PMCR.N modified by KVM to a larger value (PMCR: 0x%lx) for pmcr_n: 0x%lx\n",
+			    pmcr, pmcr_n);
+	else
+		TEST_ASSERT(pmcr_n == get_pmcr_n(pmcr),
+			    "Failed to update PMCR.N to %lu (received: %lu)\n",
+			    pmcr_n, get_pmcr_n(pmcr));
+}
+
+/*
+ * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
+ * and run the test.
+ */
+static void run_test(uint64_t pmcr_n)
+{
+	uint64_t sp;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu_init init;
+
+	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
+
+	test_create_vpmu_vm_with_pmcr_n(pmcr_n, false);
+	vcpu = vpmu_vm.vcpu;
+
+	/* Save the initial sp to restore them later to run the guest again */
+	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	/*
+	 * Reset and re-initialize the vCPU, and run the guest code again to
+	 * check if PMCR_EL0.N is preserved.
+	 */
+	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	aarch64_vcpu_setup(vcpu, &init);
+	vcpu_init_descriptor_tables(vcpu);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	destroy_vpmu_vm();
+}
+
+/*
+ * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
+ * the vCPU to @pmcr_n, which is larger than the host value.
+ * The attempt should fail as @pmcr_n is too big to set for the vCPU.
+ */
+static void run_error_test(uint64_t pmcr_n)
+{
+	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+
+	test_create_vpmu_vm_with_pmcr_n(pmcr_n, true);
+	destroy_vpmu_vm();
+}
+
+/*
+ * Return the default number of implemented PMU event counters excluding
+ * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
+ */
+static uint64_t get_pmcr_n_limit(void)
+{
+	uint64_t pmcr;
+
+	create_vpmu_vm(guest_code);
+	vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	destroy_vpmu_vm();
+	return get_pmcr_n(pmcr);
+}
+
+int main(void)
+{
+	uint64_t i, pmcr_n;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
+
+	pmcr_n = get_pmcr_n_limit();
+	for (i = 0; i <= pmcr_n; i++)
+		run_test(i);
+
+	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
+		run_error_test(i);
+
+	return 0;
+}
-- 
2.42.0.655.g421f12c284-goog

