Return-Path: <kvm+bounces-10568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F11E86D900
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 02:39:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9EE901C21314
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 01:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5433436120;
	Fri,  1 Mar 2024 01:39:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D602E416
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 01:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.101.248.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709257162; cv=none; b=WepJ9HE6Peak9QcV44f4LdGcUfP8FLTrMLkImTVZoyjTG4R+3NdslQ47fRc7FVqg3zs6m+g2hLS3eb5baeUs/ov7KoF+TgW5SNUss3/wdpK9lC5NsU5f7fTPfgkqM4g3xYj8llrOMbC9MWRIY6ScKbSBG8lQFEFDFrDs2CFFHKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709257162; c=relaxed/simple;
	bh=vpAjm6YpQYkIsCjfkUCvdmbErjM3v3bSP8SmL6U5bbU=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References; b=o0e6gYYLpSGrQ1ETgHWM2TTYsz7v8kfw422o1zL7K6ihLMnUZXSIeWl42H/+8/tcCXkvXhVTZCOm5wqigAS0gE2nrnp24jJZrb6bjLTfRJGWzzh1bDJdyl33wYdM03ypdtnSptaDZiGd0eS0ZDonFCcxgfn8ReS+FkZecSqqw9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=46.101.248.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgCnJfucMeFljDIdAA--.45179S7;
	Fri, 01 Mar 2024 09:38:46 +0800 (CST)
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
	duchao713@qq.com
Subject: [PATCH v2 3/3] RISC-V: KVM: selftests: Add breakpoints test support
Date: Fri,  1 Mar 2024 01:35:45 +0000
Message-Id: <20240301013545.10403-4-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240301013545.10403-1-duchao@eswincomputing.com>
References: <20240301013545.10403-1-duchao@eswincomputing.com>
X-CM-TRANSID:TAJkCgCnJfucMeFljDIdAA--.45179S7
X-Coremail-Antispam: 1UD129KBjvJXoW7KF1rtr1xCFW7Ww15Xw1kKrg_yoW8tw1Up3
	WxCwn09rWvqry3Gw4xAw4DuF4fKrykWF48Jr1fW34jvrWUtr4rJrnagFy7Ar9I93yrXw1f
	Aa4fW3WS9F4DJw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP2b7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
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
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8Sf
	O7UUUUU==
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Initial support for RISC-V KVM breakpoint test. Check the exit reason
and the PC when guest debug is enabled.

Signed-off-by: Chao Du <duchao@eswincomputing.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/riscv/breakpoints.c | 49 +++++++++++++++++++
 2 files changed, 50 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/riscv/breakpoints.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 492e937fab00..5f9048a740b0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -184,6 +184,7 @@ TEST_GEN_PROGS_s390x += rseq_test
 TEST_GEN_PROGS_s390x += set_memory_region_test
 TEST_GEN_PROGS_s390x += kvm_binary_stats_test
 
+TEST_GEN_PROGS_riscv += riscv/breakpoints
 TEST_GEN_PROGS_riscv += demand_paging_test
 TEST_GEN_PROGS_riscv += dirty_log_test
 TEST_GEN_PROGS_riscv += get-reg-list
diff --git a/tools/testing/selftests/kvm/riscv/breakpoints.c b/tools/testing/selftests/kvm/riscv/breakpoints.c
new file mode 100644
index 000000000000..be2d94837c83
--- /dev/null
+++ b/tools/testing/selftests/kvm/riscv/breakpoints.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * RISC-V KVM breakpoint tests.
+ *
+ * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
+ *
+ */
+#include "kvm_util.h"
+
+#define PC(v) ((uint64_t)&(v))
+
+extern unsigned char sw_bp;
+
+static void guest_code(void)
+{
+	asm volatile("sw_bp: ebreak");
+	asm volatile("nop");
+	asm volatile("nop");
+	asm volatile("nop");
+
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_guest_debug debug;
+	uint64_t pc;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	memset(&debug, 0, sizeof(debug));
+	debug.control = KVM_GUESTDBG_ENABLE;
+	vcpu_guest_debug_set(vcpu, &debug);
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);
+
+	vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &pc);
+
+	TEST_ASSERT_EQ(pc, PC(sw_bp));
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.17.1


