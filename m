Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DA069731B
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBOBHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbjBOBHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:07:25 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AA025BA3
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:23 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id t20-20020a6b5f14000000b007404263f2faso3239610iob.21
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f1XuYl7W4EZRzya084iED7e5cNSRia+m87PoIB/XYnk=;
        b=TPS6HlrHNsEiK3QpR1dJwHaTc+NdvOBx0q4ycbpxm32zJz01l7KLSpeH4VQdKFJsAC
         DfTS6qCgyr+y++3YmNbNlVeBeFeUf0OyusVhQjDAW1nxnVeTh5yrfC92eVwSGkHgm9qO
         kbPLA3CbJsOqSL+UpwuhGDBOPeU6QHXE939PaWA5otafBlESeHBaAFOdBModsHRnsyPw
         SBm3rXhIELbNZ/o6hoFgkkdxE+SNvXO4xIRj9BwoO59jl5TGqRKqinWDd72VdDlsMD2z
         iHddK8lrl0LDjSp+50pGHMGBLVTXE5kHlwMN3RLJUJfgVXNS3xi/LQIYECb+IQg/E7aM
         26hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f1XuYl7W4EZRzya084iED7e5cNSRia+m87PoIB/XYnk=;
        b=Vf6Uwy9uqynrGTmAw1oEJL6ScXo+ZX7ojkr6HmfVQwwuYr9It5Xg9ovmdB5zolMSfk
         Siq7rdEoKShIL6fR62Vcke0+IwH3MUVtOAiYsrlXAdQIeGZa/Ru5yRtVuYpQPvWjTUPD
         tdYXdnFhAuTpD18uEXhzKjoL9nqk9JiP5FPxojxTyAdigAoQ50dStSVObvW1VxipGObm
         h2u13jjqaplSo1M60yoEeiN3xE5PYALH2/hmAAxqQAKygaEmQlFIM5s6TdsOQhx+cId6
         06e4w84pLwQ0CriEVAzwqKSCOcaNKRxPZMo+lcrBMtSrJk0apBLX9u6ihX28xb3XfXrW
         yuhg==
X-Gm-Message-State: AO0yUKViZNkQ2gW/w9tH1W6PlpugJQWwtneorsEZIjGZ956Asn6BXaTt
        NNqSozvqeHhn4BUi3mj8b6ark1FqtvsA
X-Google-Smtp-Source: AK7set+q2eZtBSgqU1nJ8Ne14FZ2kDQE2+GhjkQRcEQYWX0OYHvYrDjJQgp6mTjShQnFgo4Z2IW3FySfmZR2
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6e02:66b:b0:310:fc49:1d9 with SMTP id
 l11-20020a056e02066b00b00310fc4901d9mr213006ilt.6.1676423243214; Tue, 14 Feb
 2023 17:07:23 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:03 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-3-rananta@google.com>
Subject: [REPOST PATCH 02/16] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
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
 .../kvm/aarch64/vpmu_counter_access.c         | 207 ++++++++++++++++++
 2 files changed, 208 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd9362..b27fea0ce5918 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -143,6 +143,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
new file mode 100644
index 0000000000000..7a4333f64daef
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -0,0 +1,207 @@
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
+#include <asm/perf_event.h>
+#include <linux/bitfield.h>
+
+/* The max number of the PMU event counters (excluding the cycle counter) */
+#define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
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
+static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
+				     int *gic_fd)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu_init init;
+	uint8_t pmuver;
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
+	vm = vm_create(1);
+
+	/* Create vCPU with PMUv3 */
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	*gic_fd = vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+
+	/* Make sure that PMUv3 support is indicated in the ID register */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
+	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
+	TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
+		    pmuver >= ID_AA64DFR0_PMUVER_8_0,
+		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
+
+	/* Initialize vPMU */
+	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
+	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
+
+	*vcpup = vcpu;
+	return vm;
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
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd;
+	uint64_t sp, pmcr, pmcr_orig;
+	struct kvm_vcpu_init init;
+
+	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
+	vm = create_vpmu_vm(guest_code, &vcpu, &gic_fd);
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
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	aarch64_vcpu_setup(vcpu, &init);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
+/*
+ * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
+ * the vCPU to @pmcr_n, which is larger than the host value.
+ * The attempt should fail as @pmcr_n is too big to set for the vCPU.
+ */
+static void run_error_test(uint64_t pmcr_n)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd, ret;
+	uint64_t pmcr, pmcr_orig;
+
+	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	vm = create_vpmu_vm(guest_code, &vcpu, &gic_fd);
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
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
+/*
+ * Return the default number of implemented PMU event counters excluding
+ * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
+ */
+static uint64_t get_pmcr_n_limit(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd;
+	uint64_t pmcr;
+
+	vm = create_vpmu_vm(guest_code, &vcpu, &gic_fd);
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	close(gic_fd);
+	kvm_vm_free(vm);
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
2.39.1.581.gbfd45094c4-goog

