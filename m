Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1712977EE48
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 02:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347405AbjHQAbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 20:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347349AbjHQAap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 20:30:45 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC612736
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:44 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id 46e09a7af769-6b9c82fe107so7308350a34.2
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 17:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692232243; x=1692837043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GZ0JdVkhKqWypE65t5cwu0hfmEnTX5zk7I+0wyF8fjg=;
        b=axKugz1Lvq6rmf7nIH9YoM4aIS2y6kWELQDE/HFe/euJEP0uqBuMWyElwqBGLW+3ge
         J74Y8MVLt3/ZHybkRZbh75y80Vqgw9k57AD7AnpPxTSPWQpGn8JuUAmklojb0EJe/zUc
         6QQGMCTXkuVWf+M6HPc0qUhj2VyL9cF7MfEb7qzbj9GsRXzGTFxe48qO80GAc8Bu2cj7
         MGsRg9rlw+3pvY1p852L2jE68oY3lSdg9RUHZg0qPG1y0AptG1Fg0GoBbTwGlxFZYqii
         Jgw6578k5C0lghNZ2igbWI7amAgtQOqxPC/WnkTy0qBfd1TyOBKJuJCxaXIWNmCh48Ko
         KdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692232243; x=1692837043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GZ0JdVkhKqWypE65t5cwu0hfmEnTX5zk7I+0wyF8fjg=;
        b=QNMGxiRFIl3ED9XRQduBAosRhxA5gI20qBElDUsxWRG7GwMbBFZPkG48Epdtaz0eCV
         sQuwIXCecADZvhy39r2/nwYejkzCV4+2UIuEbQ+59w/hN4JWWY+6QEeM+8Ky4pzpeTsk
         E5cLRE5UNOAhIPfvalNS5ZLlqWhWJf4EpnbdwG8dtFONakOiz2GpoucEBzaG5zLGLBm/
         ETVYS01lWasz/pA/ZR1anFudX+km/Yznxtj1mPPCdR4eitGJK6/iUN5cwLAaM29UCoH3
         4WJhr5kRF3Ik1y9MPfB/LeMEJS7va+OBx4j1+cUfhre4q9g1smQnHLaW1kAUj0WZvYWI
         RNWg==
X-Gm-Message-State: AOJu0YzHIfyr7SIrSnDgikn+EPcIx5fYGBVw91GJczgpfJOONeBWpXUa
        vVYamUxfg4JOqEkzeCVhWrASaTN1g4hf
X-Google-Smtp-Source: AGHT+IHQdoyClxbnr4jHKzbUVE7qtATKwClVGC0nIcMogO4rGmt0H9zaKjuHNq1/MBpvLemPQc94znUT7igh
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6870:7688:b0:1c0:e7d1:2c0a with SMTP
 id dx8-20020a056870768800b001c0e7d12c0amr56538oab.10.1692232243220; Wed, 16
 Aug 2023 17:30:43 -0700 (PDT)
Date:   Thu, 17 Aug 2023 00:30:27 +0000
In-Reply-To: <20230817003029.3073210-1-rananta@google.com>
Mime-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
Message-ID: <20230817003029.3073210-11-rananta@google.com>
Subject: [PATCH v5 10/12] KVM: selftests: aarch64: Introduce
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
 .../kvm/aarch64/vpmu_counter_access.c         | 235 ++++++++++++++++++
 2 files changed, 236 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c692cc86e7da8..a1599e2b82e38 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -148,6 +148,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
new file mode 100644
index 0000000000000..d0afec07948ef
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -0,0 +1,235 @@
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
+static void guest_sync_handler(struct ex_regs *regs)
+{
+	uint64_t esr, ec;
+
+	esr = read_sysreg(esr_el1);
+	ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
+	GUEST_ASSERT_3(0, regs->pc, esr, ec);
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
+	GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS);
+
+	pmcr = read_sysreg(pmcr_el0);
+	pmcr_n = FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
+
+	/* Make sure that PMCR_EL0.N indicates the value userspace set */
+	GUEST_ASSERT_2(pmcr_n == expected_pmcr_n, pmcr_n, expected_pmcr_n);
+
+	GUEST_DONE();
+}
+
+#define GICD_BASE_GPA	0x8000000ULL
+#define GICR_BASE_GPA	0x80A0000ULL
+
+/* Create a VM that has one vCPU with PMUv3 configured. */
+static struct vpmu_vm *create_vpmu_vm(void *guest_code)
+{
+	struct kvm_vcpu_init init;
+	uint8_t pmuver, ec;
+	uint64_t dfr0, irq = 23;
+	struct vpmu_vm *vpmu_vm;
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
+	vpmu_vm = calloc(1, sizeof(*vpmu_vm));
+	TEST_ASSERT(vpmu_vm, "Failed to allocate vpmu_vm");
+
+	vpmu_vm->vm = vm_create(1);
+	vm_init_descriptor_tables(vpmu_vm->vm);
+	for (ec = 0; ec < ESR_EC_NUM; ec++) {
+		vm_install_sync_handler(vpmu_vm->vm, VECTOR_SYNC_CURRENT, ec,
+					guest_sync_handler);
+	}
+
+	/* Create vCPU with PMUv3 */
+	vm_ioctl(vpmu_vm->vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	vpmu_vm->vcpu = aarch64_vcpu_add(vpmu_vm->vm, 0, &init, guest_code);
+	vcpu_init_descriptor_tables(vpmu_vm->vcpu);
+	vpmu_vm->gic_fd = vgic_v3_setup(vpmu_vm->vm, 1, 64,
+					GICD_BASE_GPA, GICR_BASE_GPA);
+
+	/* Make sure that PMUv3 support is indicated in the ID register */
+	vcpu_get_reg(vpmu_vm->vcpu,
+		     KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
+	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
+	TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
+		    pmuver >= ID_AA64DFR0_PMUVER_8_0,
+		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
+
+	/* Initialize vPMU */
+	vcpu_ioctl(vpmu_vm->vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
+	vcpu_ioctl(vpmu_vm->vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
+
+	return vpmu_vm;
+}
+
+static void destroy_vpmu_vm(struct vpmu_vm *vpmu_vm)
+{
+	close(vpmu_vm->gic_fd);
+	kvm_vm_free(vpmu_vm->vm);
+	free(vpmu_vm);
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
+		REPORT_GUEST_ASSERT_2(uc, "values:%#lx %#lx");
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
+	struct vpmu_vm *vpmu_vm;
+	struct kvm_vcpu *vcpu;
+	uint64_t sp, pmcr, pmcr_orig;
+	struct kvm_vcpu_init init;
+
+	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
+	vpmu_vm = create_vpmu_vm(guest_code);
+
+	vcpu = vpmu_vm->vcpu;
+
+	/* Save the initial sp to restore them later to run the guest again */
+	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
+
+	/* Update the PMCR_EL0.N with @pmcr_n */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
+	pmcr = pmcr_orig & ~ARMV8_PMU_PMCR_N;
+	pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	/*
+	 * Reset and re-initialize the vCPU, and run the guest code again to
+	 * check if PMCR_EL0.N is preserved.
+	 */
+	vm_ioctl(vpmu_vm->vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	aarch64_vcpu_setup(vcpu, &init);
+	vcpu_init_descriptor_tables(vcpu);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	destroy_vpmu_vm(vpmu_vm);
+}
+
+/*
+ * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
+ * the vCPU to @pmcr_n, which is larger than the host value.
+ * The attempt should fail as @pmcr_n is too big to set for the vCPU.
+ */
+static void run_error_test(uint64_t pmcr_n)
+{
+	struct vpmu_vm *vpmu_vm;
+	struct kvm_vcpu *vcpu;
+	int ret;
+	uint64_t pmcr, pmcr_orig;
+
+	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	vpmu_vm = create_vpmu_vm(guest_code);
+	vcpu = vpmu_vm->vcpu;
+
+	/* Update the PMCR_EL0.N with @pmcr_n */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
+	pmcr = pmcr_orig & ~ARMV8_PMU_PMCR_N;
+	pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
+
+	/* This should fail as @pmcr_n is too big to set for the vCPU */
+	ret = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
+	TEST_ASSERT(ret, "Setting PMCR to 0x%lx (orig PMCR 0x%lx) didn't fail",
+		    pmcr, pmcr_orig);
+
+	destroy_vpmu_vm(vpmu_vm);
+}
+
+/*
+ * Return the default number of implemented PMU event counters excluding
+ * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
+ */
+static uint64_t get_pmcr_n_limit(void)
+{
+	struct vpmu_vm *vpmu_vm;
+	uint64_t pmcr;
+
+	vpmu_vm = create_vpmu_vm(guest_code);
+	vcpu_get_reg(vpmu_vm->vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	destroy_vpmu_vm(vpmu_vm);
+	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
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
2.41.0.694.ge786442a9b-goog

