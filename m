Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04A64848ED
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiADTuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiADTuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:50:09 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB499C061398
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 11:49:52 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id z20-20020a63d014000000b0034270332922so193354pgf.1
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 11:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OKuVphlnu4rk/jRKph0yCcFS6yDHp3kGjcHbTzf7Ozk=;
        b=lYtsmMoZFeMzSsESHg/NOQkb3EDVKPeOmXaQK2dtbU98FNxhwKlx8uK0/z5bbFWXep
         nL0Hv9D8JqyrE9loCYE26pX+MELpZ/G4aBIT6x/eX7xBhkYpAeku/SW7TEIkDKcMDcxa
         7DcctkVzJUONxNqxqyHum0cBvUt1/0hcJL6mDm+hAkI+q7LCl6/mRwsGwWgqODSn0/Ok
         sBbsBnjIBfIbK8WjE2ieyT7p6/Nz10ucCg4UkWEcaBbmacnQNgEEa+7fuAG9Kd+1HNwW
         CYvI6ON/agkm8tiMM/Cj+SIfO/VTY/4VEJuSqGujUSXtxWa8sSr6FdfBLEhyp+cgeVU0
         5Oyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OKuVphlnu4rk/jRKph0yCcFS6yDHp3kGjcHbTzf7Ozk=;
        b=wrxc02MEhokGxLqiGwJYE52r16TINB8UjRsn6cZxG9n184VtmP9FeE3D1fdRSwDtpb
         y3OYwGteVC+zNVS/C9WDmL1QTCZPmaLShewNiVWO8OZcSFRoGf4Ko/S1Dohd2DdJHAGR
         QNDacj2CdZTOXpOu/xYIMdMoh1x0o3oIWZxM7jxSf5/PvtGw5oXi5U3XgwLeCc3bTgLG
         BgjJL6QWOTvGYo2WShioJWdRkBlDpjzJa1ZuqZIDy/jdetpZiV8j4JYnvjgD6f2sYzJs
         mjpmS9w60lcR6DHoP00jZlkqbLmnZXWd0lVWT2LZ6lAfgvhlrXOuIWvgnuKL1hMaq9qQ
         slmQ==
X-Gm-Message-State: AOAM532L/ITvlMlofxuYruAZdP9BhE2t8/L0ySWSq3p1f6FIQ07n2ai3
        z/ARAnXHcfs0lHMN/8WJDqBT9zpqeXQz
X-Google-Smtp-Source: ABdhPJybXe3CmtQCeJ2OE6n2CiN0QtTrY1mwjxcpcnUzkJ/vtS+VM6/Kq4TPu2f6P1d9Ryn0a5GUdH11/yAa
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:d512:b0:149:3915:6537 with SMTP id
 b18-20020a170902d51200b0014939156537mr52444403plg.152.1641325792458; Tue, 04
 Jan 2022 11:49:52 -0800 (PST)
Date:   Tue,  4 Jan 2022 19:49:17 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-11-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 10/11] selftests: KVM: aarch64: Introduce hypercall ABI test
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
 .../selftests/kvm/aarch64/hypercalls.c        | 358 ++++++++++++++++++
 3 files changed, 360 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 99ed78ddd63f..bdecb27411ad 100644
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
index 5be2690168a8..ea96a92493d5 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -94,6 +94,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
+TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
new file mode 100644
index 000000000000..386f754ca99d
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -0,0 +1,358 @@
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
+static void test_fw_regs_before_vm_start(struct kvm_vm *vm)
+{
+	uint64_t val;
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(fw_reg_info); i++) {
+		const struct kvm_fw_reg_info *reg_info = &fw_reg_info[i];
+
+		/* First read should be an upper limit of the features supported */
+		get_fw_reg(vm, reg_info->reg, &val);
+		TEST_ASSERT(val == FW_REG_ULIMIT_VAL(reg_info->max_feat_bit),
+			"Expected all the features to be set for reg: 0x%lx; expected: 0x%llx; read: 0x%lx\n",
+			reg_info->reg, GENMASK_ULL(reg_info->max_feat_bit, 0), val);
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
+		ret = set_fw_reg(vm, reg_info->reg, val);
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
+static struct kvm_vm *test_vm_create(void)
+{
+	struct kvm_vm *vm;
+
+	vm = vm_create_default(0, 0, guest_code);
+
+	ucall_init(vm, NULL);
+	steal_time_init(vm);
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
+	unsigned int num_fw_bmap_regs;
+
+	setbuf(stdout, NULL);
+
+	num_fw_bmap_regs = kvm_check_cap(KVM_CAP_ARM_HVC_FW_REG_BMAP);
+	if (!num_fw_bmap_regs) {
+		print_skip("ARM64 fw registers bitmap not supported\n");
+		exit(KSFT_SKIP);
+	} else if (num_fw_bmap_regs != ARRAY_SIZE(fw_reg_info)) {
+		print_skip("Mismatched fw registers between kernel (%u) and test (%lu)\n",
+				num_fw_bmap_regs, ARRAY_SIZE(fw_reg_info));
+		exit(KSFT_SKIP);
+	}
+
+	pr_info("Number of firmware bitmap registers discovered: %u\n", num_fw_bmap_regs);
+
+	test_run();
+	return 0;
+}
-- 
2.34.1.448.ga2b2bfdf31-goog

