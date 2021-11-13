Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F4B44F08D
	for <lists+kvm@lfdr.de>; Sat, 13 Nov 2021 02:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235702AbhKMB0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 20:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235820AbhKMB0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 20:26:01 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBDAC061224
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:23:08 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u5-20020a63d3450000b029023a5f6e6f9bso5610164pgi.21
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 17:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a9yoG4Tqo8lUV1x6xFG75nrLi42gXDfwK7UCDmtG5M4=;
        b=ANXTdYq4U+mA4DSdGarfXnFS4H7ezhtDjTfhzhA7I4E9NXbwOhGlldk+BkhTWoBJ/j
         Q/nUXdAQbLojgZ9aNljDrIUOLDAIgcHH3k9RRi76DCyuyJsGt0GLYWhUduy2lBdQ1Zjv
         019Ynz5GMLNRBIMTmLrBFTHb5xLM5tOmYEy71BXWUx61hpRIYDg9TzsXGX35YJnI6HMe
         w1PD0EmqlMGYpRCbZpyHTF4obzzZvRUotFl7mt6gbrzxVQa+HCUiX/plqLWG1dEYFrs7
         A7RtHULYs5PIMqG6XHVCoutefX5CFVv1SGJ9P43VO0LiPwlwaEmAL1QvQHtztj6arkCF
         ND+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a9yoG4Tqo8lUV1x6xFG75nrLi42gXDfwK7UCDmtG5M4=;
        b=MlEUOQX/Vffcf5vAuyMKvJNAYyogcYvCHZug4sckZmIGObqybWDxOq5uhnDqIVDdBm
         lgzy3Aj+/VXZDNh4PsJlZOKKPcaiiVn3gCfSKhz1jyuX1o1+6XlHGlFYuSoo4UkT7iit
         UDtJh1hgkoJl2QrcHqciPs8GBDvk9QJjQdOU2VSFZafkZASPlEBajb7A80gcp43EMb4e
         1BPUzR0TuxC0sktIwbArm4DUqRVCXXwgF9AtzBwvCpUilNVB9nG/iyQ0UYDsdBshgq9l
         RN3QVG8WGLZhHbExRq+c3UrEkgmIW1iJKK4bql1IY/+goNatEfMNJFSiR7CIUhp/LXNy
         V/ew==
X-Gm-Message-State: AOAM533Aum9PX0NVgZ8VPSblHpmPOZ3P8uC1aSrZLK9Zvl1tIH/KQwq7
        DXpbKr2AWm62S4IPs6JLCra9u2yD1vZC
X-Google-Smtp-Source: ABdhPJwuH0wz14M876CKSlsnT/HNoIXeLt3W7J3xl/hyZGzvxJncj4A/RcFx9uBvCwUr7im9Nd1IGPDk+9W5
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:d2cd:b0:141:fbe2:b658 with SMTP id
 n13-20020a170902d2cd00b00141fbe2b658mr12856668plc.49.1636766587790; Fri, 12
 Nov 2021 17:23:07 -0800 (PST)
Date:   Sat, 13 Nov 2021 01:22:33 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-11-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 10/11] selftests: KVM: aarch64: Introduce hypercall ABI test
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a KVM selftest to check the hypercall interface
for arm64 platforms. The test validates the user-space's
IOCTL interface to read/write the psuedo-firmware registers
as well as its effects on the guest upon certain configurations.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/hypercalls.c        | 367 ++++++++++++++++++
 3 files changed, 369 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 9d9571d19a29..f3662b10aa7f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,6 +2,7 @@
 /aarch64/arch_timer
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
+/aarch64/hypercalls
 /aarch64/psci_test
 /aarch64/vgic_init
 /s390x/memop
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4ef9fa47597b..4f462d7b2e40 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -91,6 +91,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
+TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
new file mode 100644
index 000000000000..c89f73109f1d
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -0,0 +1,367 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <errno.h>
+#include <linux/arm-smccc.h>
+#include <asm/kvm.h>
+#include <kvm_util.h>
+
+#include "processor.h"
+
+#define FW_REG_ULIMIT_VAL(max_feat_bit) (GENMASK_ULL(max_feat_bit, 0))
+
+struct kvm_fw_reg_info {
+	uint64_t reg;		/* Register definition */
+	uint64_t max_feat_bit;	/* Bit that represents the upper limit of the feature-map */
+};
+
+#define FW_REG_INFO(r, bit_max)			\
+	{					\
+		.reg = r,			\
+		.max_feat_bit = bit_max,	\
+	}
+
+static const struct kvm_fw_reg_info fw_reg_info[] = {
+	FW_REG_INFO(KVM_REG_ARM_STD_BMAP, KVM_REG_ARM_STD_BMAP_BIT_MAX),
+	FW_REG_INFO(KVM_REG_ARM_STD_HYP_BMAP, KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX),
+	FW_REG_INFO(KVM_REG_ARM_VENDOR_HYP_BMAP, KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX),
+};
+
+enum test_stage {
+	TEST_STAGE_REG_IFACE,
+	TEST_STAGE_HVC_IFACE_FEAT_DISABLED,
+	TEST_STAGE_HVC_IFACE_FEAT_ENABLED,
+	TEST_STAGE_END,
+};
+
+static int stage;
+
+struct test_hvc_info {
+	uint32_t func_id;
+	int64_t arg0;
+
+	void (*test_hvc_disabled)(const struct test_hvc_info *hc_info,
+					struct arm_smccc_res *res);
+	void (*test_hvc_enabled)(const struct test_hvc_info *hc_info,
+					struct arm_smccc_res *res);
+};
+
+#define TEST_HVC_INFO(f, a0, test_disabled, test_enabled)	\
+	{							\
+		.func_id = f,					\
+		.arg0 = a0,					\
+		.test_hvc_disabled = test_disabled,		\
+		.test_hvc_enabled = test_enabled,		\
+	}
+
+static void
+test_ptp_feat_hvc_disabled(const struct test_hvc_info *hc_info, struct arm_smccc_res *res)
+{
+	GUEST_ASSERT_3((res->a0 & BIT(ARM_SMCCC_KVM_FUNC_PTP)) == 0,
+			res->a0, hc_info->func_id, hc_info->arg0);
+}
+
+static void
+test_ptp_feat_hvc_enabled(const struct test_hvc_info *hc_info, struct arm_smccc_res *res)
+{
+	GUEST_ASSERT_3((res->a0 & BIT(ARM_SMCCC_KVM_FUNC_PTP)) != 0,
+			res->a0, hc_info->func_id, hc_info->arg0);
+}
+
+static const struct test_hvc_info hvc_info[] = {
+	/* KVM_REG_ARM_STD_BMAP: KVM_REG_ARM_STD_BIT_TRNG_V1_0 */
+	TEST_HVC_INFO(ARM_SMCCC_TRNG_VERSION, 0, NULL, NULL),
+	TEST_HVC_INFO(ARM_SMCCC_TRNG_FEATURES, ARM_SMCCC_TRNG_RND64, NULL, NULL),
+	TEST_HVC_INFO(ARM_SMCCC_TRNG_GET_UUID, 0, NULL, NULL),
+	TEST_HVC_INFO(ARM_SMCCC_TRNG_RND32, 0, NULL, NULL),
+	TEST_HVC_INFO(ARM_SMCCC_TRNG_RND64, 0, NULL, NULL),
+
+	/* KVM_REG_ARM_STD_HYP_BMAP: KVM_REG_ARM_STD_HYP_BIT_PV_TIME */
+	TEST_HVC_INFO(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			ARM_SMCCC_HV_PV_TIME_FEATURES, NULL, NULL),
+	TEST_HVC_INFO(ARM_SMCCC_HV_PV_TIME_FEATURES,
+			ARM_SMCCC_HV_PV_TIME_ST, NULL, NULL),
+	TEST_HVC_INFO(ARM_SMCCC_HV_PV_TIME_ST, 0, NULL, NULL),
+
+	/* KVM_REG_ARM_VENDOR_HYP_BMAP: KVM_REG_ARM_VENDOR_HYP_BIT_PTP */
+	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
+			ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+			test_ptp_feat_hvc_disabled, test_ptp_feat_hvc_enabled),
+	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+			KVM_PTP_VIRT_COUNTER, NULL, NULL),
+};
+
+static void guest_test_hvc(int stage)
+{
+	unsigned int i;
+	struct arm_smccc_res res;
+
+	for (i = 0; i < ARRAY_SIZE(hvc_info); i++) {
+		const struct test_hvc_info *hc_info  = &hvc_info[i];
+
+		memset(&res, 0, sizeof(res));
+		smccc_hvc(hc_info->func_id, hc_info->arg0, 0, 0, 0, 0, 0, 0, &res);
+
+		switch (stage) {
+		case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
+			if (hc_info->test_hvc_disabled)
+				hc_info->test_hvc_disabled(hc_info, &res);
+			else
+				GUEST_ASSERT_3(res.a0 == SMCCC_RET_NOT_SUPPORTED,
+					res.a0, hc_info->func_id, hc_info->arg0);
+			break;
+		case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
+			if (hc_info->test_hvc_enabled)
+				hc_info->test_hvc_enabled(hc_info, &res);
+			else
+				GUEST_ASSERT_3(res.a0 != SMCCC_RET_NOT_SUPPORTED,
+					res.a0, hc_info->func_id, hc_info->arg0);
+			break;
+		default:
+			GUEST_ASSERT_1(0, stage);
+		}
+	}
+}
+
+static void guest_code(void)
+{
+	while (stage != TEST_STAGE_END) {
+		switch (stage) {
+		case TEST_STAGE_REG_IFACE:
+			break;
+		case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
+		case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
+			guest_test_hvc(stage);
+			break;
+		default:
+			GUEST_ASSERT_1(0, stage);
+		}
+
+		GUEST_SYNC(stage);
+	}
+
+	GUEST_DONE();
+}
+
+static int set_fw_reg(struct kvm_vm *vm, uint64_t id, uint64_t val)
+{
+	struct kvm_one_reg reg = {
+		.id = KVM_REG_ARM_FW_REG(id),
+		.addr = (uint64_t)&val,
+	};
+
+	return _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+}
+
+static void get_fw_reg(struct kvm_vm *vm, uint64_t id, uint64_t *addr)
+{
+	struct kvm_one_reg reg = {
+		.id = KVM_REG_ARM_FW_REG(id),
+		.addr = (uint64_t)addr,
+	};
+
+	return vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &reg);
+}
+
+struct st_time {
+	uint32_t rev;
+	uint32_t attr;
+	uint64_t st_time;
+};
+
+#define STEAL_TIME_SIZE		((sizeof(struct st_time) + 63) & ~63)
+#define ST_GPA_BASE		(1 << 30)
+
+static void steal_time_init(struct kvm_vm *vm)
+{
+	uint64_t st_ipa = (ulong)ST_GPA_BASE;
+	unsigned int gpages;
+	struct kvm_device_attr dev = {
+		.group = KVM_ARM_VCPU_PVTIME_CTRL,
+		.attr = KVM_ARM_VCPU_PVTIME_IPA,
+		.addr = (uint64_t)&st_ipa,
+	};
+
+	gpages = vm_calc_num_guest_pages(VM_MODE_DEFAULT, STEAL_TIME_SIZE);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, ST_GPA_BASE, 1, gpages, 0);
+
+	vcpu_ioctl(vm, 0, KVM_SET_DEVICE_ATTR, &dev);
+}
+
+static void test_fw_regs_first_read(struct kvm_vm *vm)
+{
+	uint64_t val;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(fw_reg_info); i++) {
+		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
+
+		/* First read should be an upper limit of the features supported */
+		get_fw_reg(vm, reg_info->reg, &val);
+		TEST_ASSERT(val == FW_REG_ULIMIT_VAL(reg_info->max_feat_bit),
+			"Expected all the features to be set for reg: 0x%lx; expected: 0x%llx; read: 0x%lx\n",
+			reg_info->reg, GENMASK_ULL(reg_info->max_feat_bit, 0), val);
+	}
+}
+
+static void test_fw_regs_before_vm_start(struct kvm_vm *vm)
+{
+	uint64_t val;
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(fw_reg_info); i++) {
+		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
+
+		/* Test 'write' by disabling all the features of the register map */
+		ret = set_fw_reg(vm, reg_info->reg, 0);
+		TEST_ASSERT(ret == 0,
+			"Failed to clear all the features of reg: 0x%lx; ret: %d\n",
+			reg_info->reg, errno);
+
+		get_fw_reg(vm, reg_info->reg, &val);
+		TEST_ASSERT(val == 0,
+			"Expected all the features to be cleared for reg: 0x%lx\n", reg_info->reg);
+
+		/*
+		 * Test enabling a feature that's not supported.
+		 * Avoid this check if all the bits are occupied.
+		 */
+		if (reg_info->max_feat_bit < 63) {
+			ret = set_fw_reg(vm, reg_info->reg, BIT(reg_info->max_feat_bit + 1));
+			TEST_ASSERT(ret != 0 && errno == EINVAL,
+			"Unexpected behavior or return value (%d) while setting an unsupported feature for reg: 0x%lx\n",
+			errno, reg_info->reg);
+		}
+	}
+}
+
+static void test_fw_regs_after_vm_start(struct kvm_vm *vm)
+{
+	uint64_t val;
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(fw_reg_info); i++) {
+		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
+
+		/*
+		 * Before starting the VM, the test clears all the bits.
+		 * Check if that's still the case.
+		 */
+		get_fw_reg(vm, reg_info->reg, &val);
+		TEST_ASSERT(val == 0,
+			"Expected all the features to be cleared for reg: 0x%lx\n",
+			reg_info->reg);
+
+		/*
+		 * Test setting the last known value. KVM should allow this
+		 * even if VM has started running.
+		 */
+		ret = set_fw_reg(vm, reg_info->reg, 0);
+		TEST_ASSERT(ret == 0,
+			"Failed to clear all the features of reg: 0x%lx; ret: %d\n",
+			reg_info->reg, errno);
+
+		/*
+		 * Set all the features for this register again. KVM shouldn't
+		 * allow this as the VM is running.
+		 */
+		ret = set_fw_reg(vm, reg_info->reg, FW_REG_ULIMIT_VAL(reg_info->max_feat_bit));
+		TEST_ASSERT(ret != 0 && errno == EBUSY,
+		"Unexpected behavior or return value (%d) while setting a feature while VM is running for reg: 0x%lx\n",
+		errno, reg_info->reg);
+	}
+}
+
+static struct  kvm_vm *test_vm_create(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_ARM_HVC_FW_REG_BMAP,
+	};
+
+	vm = vm_create_default(0, 0, guest_code);
+
+	vm_enable_cap(vm, &cap);
+
+	ucall_init(vm, NULL);
+	steal_time_init(vm);
+
+	/* Read all the registers to mark them as 'accessed' */
+	test_fw_regs_first_read(vm);
+
+	return vm;
+}
+
+static struct kvm_vm *test_guest_stage(struct kvm_vm *vm)
+{
+	struct kvm_vm *ret_vm = vm;
+
+	pr_debug("Stage: %d\n", stage);
+
+	switch (stage) {
+	case TEST_STAGE_REG_IFACE:
+		test_fw_regs_after_vm_start(vm);
+		break;
+	case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
+		/* Start a new VM so that all the features are now enabled by default */
+		kvm_vm_free(vm);
+		ret_vm = test_vm_create();
+		break;
+	case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
+		break;
+	default:
+		TEST_FAIL("Unknown test stage: %d\n", stage);
+	}
+
+	stage++;
+	sync_global_to_guest(vm, stage);
+
+	return ret_vm;
+}
+
+static void test_run(void)
+{
+	struct kvm_vm *vm;
+	struct ucall uc;
+	bool guest_done = false;
+
+	vm = test_vm_create();
+
+	test_fw_regs_before_vm_start(vm);
+
+	while (!guest_done) {
+		vcpu_run(vm, 0);
+
+		switch (get_ucall(vm, 0, &uc)) {
+		case UCALL_SYNC:
+			vm = test_guest_stage(vm);
+			break;
+		case UCALL_DONE:
+			guest_done = true;
+			break;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld\n\tvalues: 0x%lx, %lu; %lu, stage: %u",
+			(const char *)uc.args[0], __FILE__, uc.args[1],
+			uc.args[2], uc.args[3], uc.args[4], stage);
+			break;
+		default:
+			TEST_FAIL("Unexpected guest exit\n");
+		}
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	setbuf(stdout, NULL);
+
+	if (kvm_check_cap(KVM_CAP_ARM_HVC_FW_REG_BMAP) != 1) {
+		print_skip("ARM64 fw registers bitmap not supported\n");
+		exit(KSFT_SKIP);
+	}
+
+	test_run();
+	return 0;
+}
-- 
2.34.0.rc1.387.gb447b232ab-goog

