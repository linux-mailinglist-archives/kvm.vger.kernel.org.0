Return-Path: <kvm+bounces-32922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF599E1B3D
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 12:48:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00890282E28
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 11:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC17D1E47B6;
	Tue,  3 Dec 2024 11:48:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5110C1DE3B2;
	Tue,  3 Dec 2024 11:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733226507; cv=none; b=aUu78SolzOpkA0N+GDq38Rx399TJMUo5/Tpm6Ma3aXBOOylmjv8pjU0AJA5CMu7xtYBpZE0zlyR8uUHJvUu3fmE3BL6SPAw1LN3pDjB41oiO5us4DmwpppyaPXlw0onNR2yCQDhLsQ15H0zP9LYra9mqqswxOrWfpCU2LKdKuTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733226507; c=relaxed/simple;
	bh=/drD2/Nz3lpMlYdqWQ4BpWJ6JqHzPM+6kdpTRSc0f6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPSDVLD5kU9uSVcG5Eory9LlQynfEtmTtTb6lrAhjr6D86CH5mHn+hbl4ptaZvsiZ320JoxhlxUOi7wvIbd5KkGnnIQXydcTAUIiN8BfdW6xcphTQrXxAJbvuy+7H1UxIuG19JZte2s3Z3HBc/jo9gge3rMnj+OYnQNVp8mTBns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [223.64.68.38])
	by gateway (Coremail) with SMTP id _____8CxSOEE8E5n4LJPAA--.23424S3;
	Tue, 03 Dec 2024 19:48:20 +0800 (CST)
Received: from localhost.localdomain (unknown [223.64.68.38])
	by front1 (Coremail) with SMTP id qMiowMAxmsH3705ne9JzAA--.9972S3;
	Tue, 03 Dec 2024 19:48:18 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xuerui Wang <kernel@xen0n.name>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	stable@vger.kernel.org
Subject: [PATCH V2 2/2] LoongArch: KVM: Protect kvm_io_bus_{read,write}() with SRCU
Date: Tue,  3 Dec 2024 19:47:59 +0800
Message-ID: <20241203114759.419261-2-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241203114759.419261-1-chenhuacai@loongson.cn>
References: <20241203114759.419261-1-chenhuacai@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAxmsH3705ne9JzAA--.9972S3
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Ar1rCFWkCr4rKw4UCw4rJFc_yoWxurWkpr
	yrZ393ur4rJr97AwnrAr1DZr1jq3yvkF18JrWkJr4fGr1jvrn8JF48trW7ZFy5K34rCa17
	ZF1xJr1Ykr1UAwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Fb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v2
	6r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7IU8EeHDUUUUU==

When we enable lockdep we get such a warning:

 =============================
 WARNING: suspicious RCU usage
 6.12.0-rc7+ #1891 Tainted: G        W
 -----------------------------
 arch/loongarch/kvm/../../../virt/kvm/kvm_main.c:5945 suspicious rcu_dereference_check() usage!
 other info that might help us debug this:
 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by qemu-system-loo/948:
  #0: 90000001184a00a8 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0xf4/0xe20 [kvm]
 stack backtrace:
 CPU: 2 UID: 0 PID: 948 Comm: qemu-system-loo Tainted: G        W          6.12.0-rc7+ #1891
 Tainted: [W]=WARN
 Hardware name: Loongson Loongson-3A5000-7A1000-1w-CRB/Loongson-LS3A5000-7A1000-1w-CRB, BIOS vUDK2018-LoongArch-V2.0.0-prebeta9 10/21/2022
 Stack : 0000000000000089 9000000005a0db9c 90000000071519c8 900000012c578000
         900000012c57b940 0000000000000000 900000012c57b948 9000000007e53788
         900000000815bcc8 900000000815bcc0 900000012c57b7b0 0000000000000001
         0000000000000001 4b031894b9d6b725 0000000005dec000 9000000100427b00
         00000000000003d2 0000000000000001 000000000000002d 0000000000000003
         0000000000000030 00000000000003b4 0000000005dec000 0000000000000000
         900000000806d000 9000000007e53788 00000000000000b4 0000000000000004
         0000000000000004 0000000000000000 0000000000000000 9000000107baf600
         9000000008916000 9000000007e53788 9000000005924778 000000001fe001e5
         00000000000000b0 0000000000000007 0000000000000000 0000000000071c1d
         ...
 Call Trace:
 [<9000000005924778>] show_stack+0x38/0x180
 [<90000000071519c4>] dump_stack_lvl+0x94/0xe4
 [<90000000059eb754>] lockdep_rcu_suspicious+0x194/0x240
 [<ffff80000221f47c>] kvm_io_bus_read+0x19c/0x1e0 [kvm]
 [<ffff800002225118>] kvm_emu_mmio_read+0xd8/0x440 [kvm]
 [<ffff8000022254bc>] kvm_handle_read_fault+0x3c/0xe0 [kvm]
 [<ffff80000222b3c8>] kvm_handle_exit+0x228/0x480 [kvm]

Fix it by protecting kvm_io_bus_{read,write}() with SRCU.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
V2: Fix copy-paste errors.

 arch/loongarch/kvm/exit.c     | 31 +++++++++++++++++++++----------
 arch/loongarch/kvm/intc/ipi.c |  6 +++++-
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 69f3e3782cc9..a7893bd01e73 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -156,7 +156,7 @@ static int kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
 
 int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 {
-	int ret;
+	int idx, ret;
 	unsigned long *val;
 	u32 addr, rd, rj, opcode;
 
@@ -167,7 +167,6 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 	rj = inst.reg2_format.rj;
 	opcode = inst.reg2_format.opcode;
 	addr = vcpu->arch.gprs[rj];
-	ret = EMULATE_DO_IOCSR;
 	run->iocsr_io.phys_addr = addr;
 	run->iocsr_io.is_write = 0;
 	val = &vcpu->arch.gprs[rd];
@@ -207,20 +206,28 @@ int kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
 	}
 
 	if (run->iocsr_io.is_write) {
-		if (!kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		if (ret == 0)
 			ret = EMULATE_DONE;
-		else
+		else {
+			ret = EMULATE_DO_IOCSR;
 			/* Save data and let user space to write it */
 			memcpy(run->iocsr_io.data, val, run->iocsr_io.len);
-
+		}
 		trace_kvm_iocsr(KVM_TRACE_IOCSR_WRITE, run->iocsr_io.len, addr, val);
 	} else {
-		if (!kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val))
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, run->iocsr_io.len, val);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+		if (ret == 0)
 			ret = EMULATE_DONE;
-		else
+		else {
+			ret = EMULATE_DO_IOCSR;
 			/* Save register id for iocsr read completion */
 			vcpu->arch.io_gpr = rd;
-
+		}
 		trace_kvm_iocsr(KVM_TRACE_IOCSR_READ, run->iocsr_io.len, addr, NULL);
 	}
 
@@ -359,7 +366,7 @@ static int kvm_handle_gspr(struct kvm_vcpu *vcpu)
 
 int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 {
-	int ret;
+	int idx, ret;
 	unsigned int op8, opcode, rd;
 	struct kvm_run *run = vcpu->run;
 
@@ -464,8 +471,10 @@ int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
 		 * it need not return to user space to handle the mmio
 		 * exception.
 		 */
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		ret = kvm_io_bus_read(vcpu, KVM_MMIO_BUS, vcpu->arch.badv,
 				      run->mmio.len, &vcpu->arch.gprs[rd]);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		if (!ret) {
 			update_pc(&vcpu->arch);
 			vcpu->mmio_needed = 0;
@@ -531,7 +540,7 @@ int kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
 {
-	int ret;
+	int idx, ret;
 	unsigned int rd, op8, opcode;
 	unsigned long curr_pc, rd_val = 0;
 	struct kvm_run *run = vcpu->run;
@@ -631,7 +640,9 @@ int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
 		 * it need not return to user space to handle the mmio
 		 * exception.
 		 */
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		ret = kvm_io_bus_write(vcpu, KVM_MMIO_BUS, vcpu->arch.badv, run->mmio.len, data);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		if (!ret)
 			return EMULATE_DONE;
 
diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index a233a323e295..4b7ff20ed438 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -98,7 +98,7 @@ static void write_mailbox(struct kvm_vcpu *vcpu, int offset, uint64_t data, int
 
 static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 {
-	int i, ret;
+	int i, idx, ret;
 	uint32_t val = 0, mask = 0;
 
 	/*
@@ -107,7 +107,9 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 	 */
 	if ((data >> 27) & 0xf) {
 		/* Read the old val */
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		ret = kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		if (unlikely(ret)) {
 			kvm_err("%s: : read date from addr %llx failed\n", __func__, addr);
 			return ret;
@@ -121,7 +123,9 @@ static int send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
 		val &= mask;
 	}
 	val |= ((uint32_t)(data >> 32) & ~mask);
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	ret = kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	if (unlikely(ret))
 		kvm_err("%s: : write date to addr %llx failed\n", __func__, addr);
 
-- 
2.43.5


