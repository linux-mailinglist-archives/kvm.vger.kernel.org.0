Return-Path: <kvm+bounces-13338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6994D894B69
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1494028385E
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F8C422331;
	Tue,  2 Apr 2024 06:31:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E8618E1C
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 06:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.21.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712039460; cv=none; b=s59Y2Nf1Yg8VEX9sUEwkno6Jy+GaK1cSSHBEWGVSRQTi0C6kr1WpOaB4TiVOwvGUWZB8R5f9AOtFrARV+p9UH8R6aOa2BJ+DOHBDG/JEj4FILDIYHCz7Jc3VMnTb4uLGFrx15BvzjuYLkLC4JjAKt5m9UKAW2bnBirCkisxoqVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712039460; c=relaxed/simple;
	bh=DCPA4NtsHOX6Jjw6B7IKGSuJW8oyOpdJj3+73E4s/po=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References; b=r2mT1Cgw8ZVW7sXwWo+wWZvyZErtMf7emCyxuqFhFS4mNr3kuIreXWBTxbQ3NgalJU+UIlvlMR6MC+04BPMlziFrzhtVMZ8c+vt7O3czplvxhWUflBiypM8exCNFWfnXMiZZmza6towAZXbEpz6jj4vuKyfc7wID9b4Ro3iQBU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=206.189.21.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app2 (Coremail) with SMTP id TQJkCgBHWry1pQtm5G0EAA--.36929S7;
	Tue, 02 Apr 2024 14:29:20 +0800 (CST)
From: Chao Du <duchao@eswincomputing.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	shuah@kernel.org,
	dbarboza@ventanamicro.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	haibo1.xu@intel.com,
	duchao713@qq.com
Subject: [PATCH v4 3/3] RISC-V: KVM: selftests: Add ebreak test support
Date: Tue,  2 Apr 2024 06:26:28 +0000
Message-Id: <20240402062628.5425-4-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240402062628.5425-1-duchao@eswincomputing.com>
References: <20240402062628.5425-1-duchao@eswincomputing.com>
X-CM-TRANSID:TQJkCgBHWry1pQtm5G0EAA--.36929S7
X-Coremail-Antispam: 1UD129KBjvJXoWxWF47WF48GF1kZFW3Kw13twb_yoW5ZFW3p3
	4Ik34j9F4vqF43Gw4fGw1kuF4fKrZ7XF4xXryfW34jkrWUta95JFnagFyYkFWqvrW8Xr13
	Za4YgFnrZF48JrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP2b7Iv0xC_Cr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUWwA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2
	xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8FD
	73UUUUU==
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Initial support for RISC-V KVM ebreak test. Check the exit reason and
the PC when guest debug is enabled. Also to make sure the guest could
handle the ebreak exception without exiting to the VMM when guest debug
is not enabled.

Signed-off-by: Chao Du <duchao@eswincomputing.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/riscv/ebreak_test.c | 82 +++++++++++++++++++
 2 files changed, 83 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/riscv/ebreak_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 741c7dc16afc..7f4430242c9e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -189,6 +189,7 @@ TEST_GEN_PROGS_s390x += rseq_test
 TEST_GEN_PROGS_s390x += set_memory_region_test
 TEST_GEN_PROGS_s390x += kvm_binary_stats_test
 
+TEST_GEN_PROGS_riscv += riscv/ebreak_test
 TEST_GEN_PROGS_riscv += arch_timer
 TEST_GEN_PROGS_riscv += demand_paging_test
 TEST_GEN_PROGS_riscv += dirty_log_test
diff --git a/tools/testing/selftests/kvm/riscv/ebreak_test.c b/tools/testing/selftests/kvm/riscv/ebreak_test.c
new file mode 100644
index 000000000000..823c132069b4
--- /dev/null
+++ b/tools/testing/selftests/kvm/riscv/ebreak_test.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * RISC-V KVM ebreak test.
+ *
+ * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
+ *
+ */
+#include "kvm_util.h"
+
+#define LABEL_ADDRESS(v) ((uint64_t)&(v))
+
+extern unsigned char sw_bp_1, sw_bp_2;
+static uint64_t sw_bp_addr;
+
+static void guest_code(void)
+{
+	asm volatile(
+		".option push\n"
+		".option norvc\n"
+		"sw_bp_1: ebreak\n"
+		"sw_bp_2: ebreak\n"
+		".option pop\n"
+	);
+	GUEST_ASSERT_EQ(READ_ONCE(sw_bp_addr), LABEL_ADDRESS(sw_bp_2));
+
+	GUEST_DONE();
+}
+
+static void guest_breakpoint_handler(struct ex_regs *regs)
+{
+	WRITE_ONCE(sw_bp_addr, regs->epc);
+	regs->epc += 4;
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	uint64_t pc;
+	struct kvm_guest_debug debug = {
+		.control = KVM_GUESTDBG_ENABLE,
+	};
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_init_vector_tables(vm);
+	vcpu_init_vector_tables(vcpu);
+	vm_install_exception_handler(vm, EXC_BREAKPOINT,
+					guest_breakpoint_handler);
+
+	/*
+	 * Enable the guest debug.
+	 * ebreak should exit to the VMM with KVM_EXIT_DEBUG reason.
+	 */
+	vcpu_guest_debug_set(vcpu, &debug);
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
+
+	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &pc);
+	TEST_ASSERT_EQ(pc, LABEL_ADDRESS(sw_bp_1));
+
+	/* skip sw_bp_1 */
+	vcpu_set_reg(vcpu, RISCV_CORE_REG(regs.pc), pc + 4);
+
+	/*
+	 * Disable all debug controls.
+	 * Guest should handle the ebreak without exiting to the VMM.
+	 */
+	memset(&debug, 0, sizeof(debug));
+	vcpu_guest_debug_set(vcpu, &debug);
+
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.17.1


