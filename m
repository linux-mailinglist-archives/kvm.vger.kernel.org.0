Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FD36C2448
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCTWK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCTWK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:10:56 -0400
Received: from out-54.mta1.migadu.com (out-54.mta1.migadu.com [IPv6:2001:41d0:203:375::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A60E65BA
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:10:52 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679350249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5QiGPiGNM91vJrdHaHtuBdnuzIhv0JJsQir3ZJY6jgQ=;
        b=IwtyWbIYf1dEuS2Epo2bjFrk2NTblWUaE/9xxCv0KiJ6id5bAAbfP4oiQh2JmOZTrlH74k
        FTal34mt3eN2vkNFeQVrDP/szdfjD5nRNQDKXLJ0Mcwd975+3O9FovqgLQrYEnPlbruqKM
        Jy20y7HSF/VFDz1YpQ2Mz5HT6nHqHh0=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 11/11] KVM: selftests: Add test for SMCCC filter
Date:   Mon, 20 Mar 2023 22:10:02 +0000
Message-Id: <20230320221002.4191007-12-oliver.upton@linux.dev>
In-Reply-To: <20230320221002.4191007-1-oliver.upton@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a selftest for the SMCCC filter, ensuring basic UAPI constraints
(e.g. reserved ranges, non-overlapping ranges) are upheld. Additionally,
test that the DENIED and FWD_TO_USER work as intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/smccc_filter.c      | 196 ++++++++++++++++++
 2 files changed, 197 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/smccc_filter.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 84a627c43795..d66a0642cffd 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -141,6 +141,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
+TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/aarch64/smccc_filter.c b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
new file mode 100644
index 000000000000..7f4950d18b42
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/smccc_filter.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * smccc_filter - Tests for the SMCCC filter UAPI.
+ *
+ * Copyright (c) 2023 Google LLC
+ *
+ * This test includes:
+ *  - Tests that the UAPI constraints are upheld by KVM. For example, userspace
+ *    is prevented from filtering the architecture range of SMCCC calls.
+ *  - Test that the filter actions (DENIED, FWD_TO_USER) work as intended.
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/psci.h>
+#include <stdint.h>
+
+#include "processor.h"
+#include "test_util.h"
+
+enum smccc_conduit {
+	HVC_INSN,
+	SMC_INSN,
+};
+
+#define for_each_conduit(conduit)					\
+	for (conduit = HVC_INSN; conduit <= SMC_INSN; conduit++)
+
+static void guest_main(uint32_t func_id, enum smccc_conduit conduit)
+{
+	struct arm_smccc_res res;
+
+	if (conduit == SMC_INSN)
+		smccc_smc(func_id, 0, 0, 0, 0, 0, 0, 0, &res);
+	else
+		smccc_hvc(func_id, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	GUEST_SYNC(res.a0);
+}
+
+static int __set_smccc_filter(struct kvm_vm *vm, uint32_t start, uint32_t nr_functions,
+			      enum kvm_smccc_filter_action action)
+{
+	struct kvm_smccc_filter filter = {
+		.base		= start,
+		.nr_functions	= nr_functions,
+		.action		= action,
+	};
+
+	return __kvm_device_attr_set(vm->fd, KVM_ARM_VM_SMCCC_CTRL,
+				     KVM_ARM_VM_SMCCC_FILTER, &filter);
+}
+
+static void set_smccc_filter(struct kvm_vm *vm, uint32_t start, uint32_t nr_functions,
+			     enum kvm_smccc_filter_action action)
+{
+	int ret = __set_smccc_filter(vm, start, nr_functions, action);
+
+	TEST_ASSERT(!ret, "failed to configure SMCCC filter: %d", ret);
+}
+
+static struct kvm_vm *setup_vm(struct kvm_vcpu **vcpu)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vm *vm;
+
+	vm = vm_create(1);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+
+	/*
+	 * Enable in-kernel emulation of PSCI to ensure that calls are denied
+	 * due to the SMCCC filter, not because of KVM.
+	 */
+	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
+
+	*vcpu = aarch64_vcpu_add(vm, 0, &init, guest_main);
+	return vm;
+}
+
+/* Ensure that userspace cannot filter the Arm Architecture SMCCC range */
+static void test_filter_reserved_range(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = setup_vm(&vcpu);
+	int r;
+
+	r = __set_smccc_filter(vm, ARM_SMCCC_ARCH_WORKAROUND_1,
+			       1, KVM_SMCCC_FILTER_DENY);
+	TEST_ASSERT(r, "Attempt to filter reserved range unexpectedly succeeded");
+
+	kvm_vm_free(vm);
+}
+
+/* Test that overlapping configurations of the SMCCC filter are rejected */
+static void test_filter_overlap(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = setup_vm(&vcpu);
+	int r;
+
+	set_smccc_filter(vm, PSCI_0_2_FN64_CPU_ON, 1, KVM_SMCCC_FILTER_DENY);
+
+	r = __set_smccc_filter(vm, PSCI_0_2_FN64_CPU_ON, 1, KVM_SMCCC_FILTER_DENY);
+	TEST_ASSERT(r, "Attempt to filter already configured range unexpectedly succeeded");
+
+	kvm_vm_free(vm);
+}
+
+static void expect_call_denied(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	if (get_ucall(vcpu, &uc) != UCALL_SYNC)
+		TEST_FAIL("Unexpected ucall: %lu\n", uc.cmd);
+
+	TEST_ASSERT(uc.args[1] == SMCCC_RET_NOT_SUPPORTED,
+		    "Unexpected SMCCC return code: %lu", uc.args[1]);
+}
+
+/* Denied SMCCC calls have a return code of SMCCC_RET_NOT_SUPPORTED */
+static void test_filter_denied(void)
+{
+	enum smccc_conduit conduit;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	for_each_conduit(conduit) {
+		vm = setup_vm(&vcpu);
+
+		set_smccc_filter(vm, PSCI_0_2_FN_PSCI_VERSION, 1, KVM_SMCCC_FILTER_DENY);
+		vcpu_args_set(vcpu, 2, PSCI_0_2_FN_PSCI_VERSION, conduit);
+
+		vcpu_run(vcpu);
+		expect_call_denied(vcpu);
+
+		kvm_vm_free(vm);
+	}
+}
+
+static void expect_call_fwd_to_user(struct kvm_vcpu *vcpu, uint32_t func_id,
+				    enum smccc_conduit conduit)
+{
+	struct kvm_run *run = vcpu->run;
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_HYPERCALL,
+		    "Unexpected exit reason: %u", run->exit_reason);
+	TEST_ASSERT(run->hypercall.nr == func_id,
+		    "Unexpected SMCCC function: %llu", run->hypercall.nr);
+
+	if (conduit == SMC_INSN)
+		TEST_ASSERT(run->hypercall.flags & KVM_HYPERCALL_EXIT_SMC,
+			    "KVM_HYPERCALL_EXIT_SMC is not set");
+	else
+		TEST_ASSERT(!(run->hypercall.flags & KVM_HYPERCALL_EXIT_SMC),
+			    "KVM_HYPERCAL_EXIT_SMC is set");
+}
+
+/* SMCCC calls forwarded to userspace cause KVM_EXIT_HYPERCALL exits */
+static void test_filter_fwd_to_user(void)
+{
+	enum smccc_conduit conduit;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	for_each_conduit(conduit) {
+		vm = setup_vm(&vcpu);
+
+		set_smccc_filter(vm, PSCI_0_2_FN_PSCI_VERSION, 1, KVM_SMCCC_FILTER_FWD_TO_USER);
+		vcpu_args_set(vcpu, 2, PSCI_0_2_FN_PSCI_VERSION, conduit);
+
+		vcpu_run(vcpu);
+		expect_call_fwd_to_user(vcpu, PSCI_0_2_FN_PSCI_VERSION, conduit);
+
+		kvm_vm_free(vm);
+	}
+}
+
+static bool kvm_supports_smccc_filter(void)
+{
+	struct kvm_vm *vm = vm_create_barebones();
+	int r;
+
+	r = __kvm_has_device_attr(vm->fd, KVM_ARM_VM_SMCCC_CTRL, KVM_ARM_VM_SMCCC_FILTER);
+
+	kvm_vm_free(vm);
+	return !r;
+}
+
+int main(void)
+{
+	TEST_REQUIRE(kvm_supports_smccc_filter());
+
+	test_filter_reserved_range();
+	test_filter_overlap();
+	test_filter_denied();
+	test_filter_fwd_to_user();
+}
-- 
2.40.0.rc1.284.g88254d51c5-goog

