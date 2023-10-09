Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE89E7BEEE6
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 01:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379049AbjJIXKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 19:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379151AbjJIXKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 19:10:05 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB30212B
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 16:09:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f4f2a9ef0so80355337b3.2
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 16:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696892954; x=1697497754; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oU4noWX+M22GGQML7cBNq1w1ZUMxVHTzQhjdHmQVeoI=;
        b=Alf0+6177HyeFcSr/mmjZGH0nIKkO9nB0Y0cti9+NFWOFjs/VJjvHDH4aSK8l9eohm
         Xe/60aJz3+cv3ShXCQ84ph4bK9rBU0+ylR4uUsmcDAHHi34v0AhUjxjZ5OIYfu+WRoJi
         TiTQI0dZIE/+vj5OlUugE75+RaJVKLuoiuxnIqphX9F+apNy7mQaquoIS0yENDCgPByW
         R8S1b+AgToTgCrms95ujg9IEGKENTRnaF4fFPQU7uNAnuXct27CAmlaET3NRMa/4nfyF
         wiNeW+UKeLKnaeGpRhVO1cTMikGZ21L7+6i33erc98a46eILwbGWqk1jy7Ut1m3VsPZA
         Ep0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892954; x=1697497754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oU4noWX+M22GGQML7cBNq1w1ZUMxVHTzQhjdHmQVeoI=;
        b=OzJwN7NtlfGfFOVkuzwpPMAuz49Wg8B8XsdMI3+Y4aNtIas43mMy0apUJiKiYmSDsu
         ZEbS0gMbElV1eNIhakjQkiItntLetESsFhkn+WNLSizdTcAUPoB8ab7B3TP99dsO5by4
         P9qbflkQV+cinrROqW9ISwq8w/d6TdRnvp/w0ASlsJbzPsKy7wV1p9iiU2CKScy/m2Av
         NWoqWMXnXRGArx8AAW25mnNQuJfhBH25BpIeP+tjvjKFcmJQekpiyIj3zYVWw2fHhAJb
         N0vWDk9Q8f1S4mHHmeR9LfJnNWD5lhVLGh222l7K3awGaoA8yLMX5OVNgAjhkPzTtAM3
         /fCQ==
X-Gm-Message-State: AOJu0YxV0ZJxr+Uznwv+7MYYtf0b7UI3clNaQFOwDxNw+Wc5EwkKlys8
        QwY6lERd2EJKWh2EH4vK3gj0AG/XR5Yt
X-Google-Smtp-Source: AGHT+IEXDzH1+afJ8cf7TDx9pdO2F95eZQD6ZkN/B4VvJbmw/2ecN6YJPeH0PWJ5WjhnKMQLNDzpvdGbPQAP
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:20a1])
 (user=rananta job=sendgmr) by 2002:a25:910f:0:b0:d9a:59cb:8bed with SMTP id
 v15-20020a25910f000000b00d9a59cb8bedmr4492ybl.5.1696892954182; Mon, 09 Oct
 2023 16:09:14 -0700 (PDT)
Date:   Mon,  9 Oct 2023 23:08:56 +0000
In-Reply-To: <20231009230858.3444834-1-rananta@google.com>
Mime-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <20231009230858.3444834-11-rananta@google.com>
Subject: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce
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
        autolearn=ham autolearn_force=no version=3.4.6
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
 .../kvm/aarch64/vpmu_counter_access.c         | 247 ++++++++++++++++++
 2 files changed, 248 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a3bb36fb3cfc..416700aa196c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -149,6 +149,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
new file mode 100644
index 000000000000..58949b17d76e
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vpmu_counter_access - Test vPMU event counter access
+ *
+ * Copyright (c) 2022 Google LLC.
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
+			pmcr_n, expected_pmcr_n);
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
+
+	/* Make sure that PMUv3 support is indicated in the ID register */
+	vcpu_get_reg(vpmu_vm.vcpu,
+		     KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
+	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
+	TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
+		    pmuver >= ID_AA64DFR0_PMUVER_8_0,
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
+/*
+ * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
+ * and run the test.
+ */
+static void run_test(uint64_t pmcr_n)
+{
+	struct kvm_vcpu *vcpu;
+	uint64_t sp, pmcr;
+	struct kvm_vcpu_init init;
+
+	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
+	create_vpmu_vm(guest_code);
+
+	vcpu = vpmu_vm.vcpu;
+
+	/* Save the initial sp to restore them later to run the guest again */
+	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
+
+	/* Update the PMCR_EL0.N with @pmcr_n */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	set_pmcr_n(&pmcr, pmcr_n);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
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
+	struct kvm_vcpu *vcpu;
+	uint64_t pmcr, pmcr_orig;
+
+	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
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
+	TEST_ASSERT(pmcr_orig == pmcr,
+		    "PMCR.N modified by KVM to a larger value (PMCR: 0x%lx) for pmcr_n: 0x%lx\n",
+		    pmcr, pmcr_n);
+
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
2.42.0.609.gbb76f46606-goog

