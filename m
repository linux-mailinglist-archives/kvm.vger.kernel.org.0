Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F146CBF21
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjC1Mb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbjC1Mbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:31:47 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A13F49038;
        Tue, 28 Mar 2023 05:31:24 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxJIQa3iJkCBkTAA--.29367S3;
        Tue, 28 Mar 2023 20:31:22 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxPL4X3iJku2cPAA--.12046S11;
        Tue, 28 Mar 2023 20:31:22 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PING PATCH v4 09/29] LoongArch: KVM: Implement vcpu get, vcpu set registers
Date:   Tue, 28 Mar 2023 20:30:59 +0800
Message-Id: <20230328123119.3649361-10-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxPL4X3iJku2cPAA--.12046S11
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3ArW5uw4rCrW3Cr1Dur4xCrg_yoW3Aw43pF
        17Aa90qrWxKFWxCwn3Jrs09r1Ygr97KryxZFyxuFWSyr1UtryFyF4vkr9xJFy5GryruF1I
        9as0yF409Fs0y37anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        b4AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6x
        kF7I0E14v26F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVWDJVCq3wCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAI
        w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
        kF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7xRiTKZJUUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement loongarch vcpu get registers and set registers operations, it
is called when user space use the ioctl interface to get or set regs.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/csr_ops.S |  76 ++++++++++++
 arch/loongarch/kvm/vcpu.c    | 228 +++++++++++++++++++++++++++++++++++
 2 files changed, 304 insertions(+)
 create mode 100644 arch/loongarch/kvm/csr_ops.S

diff --git a/arch/loongarch/kvm/csr_ops.S b/arch/loongarch/kvm/csr_ops.S
new file mode 100644
index 000000000..962b96d82
--- /dev/null
+++ b/arch/loongarch/kvm/csr_ops.S
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <asm/regdef.h>
+#include <linux/linkage.h>
+	.text
+	.section        .text
+	.cfi_sections   .debug_frame
+/*
+ * we have splited hw gcsr into three parts, so we can
+ * calculate the code offset by gcsrid and jump here to
+ * run the gcsrwr instruction.
+ */
+SYM_FUNC_START(set_hw_gcsr)
+	addi.d      t0,   a0,   0
+	addi.w      t1,   zero, 96
+	bltu        t1,   t0,   1f
+	la.pcrel    t0,   10f
+	alsl.d      t0,   a0,   t0, 3
+	jirl        zero, t0,   0
+1:
+	addi.w      t1,   a0,   -128
+	addi.w      t2,   zero, 15
+	bltu        t2,   t1,   2f
+	la.pcrel    t0,   11f
+	alsl.d      t0,   t1,   t0, 3
+	jirl        zero, t0,   0
+2:
+	addi.w      t1,   a0,   -384
+	addi.w      t2,   zero, 3
+	bltu        t2,   t1,   3f
+	la.pcrel    t0,   12f
+	alsl.d      t0,   t1,   t0, 3
+	jirl        zero, t0,   0
+3:
+	addi.w      a0,   zero, -1
+	jirl        zero, ra,   0
+/*
+ * write guest csr
+ * 0x05000000 | (LOONGARCH_CSR_XXX << 10) | 1 << 5 | a1
+ * range from 0x0(KVM_CSR_CRMD) to 0x60 (KVM_CSR_LLBCTL)
+ */
+10:
+	csrnum = 0
+	.rept 0x61
+		.word 0x05000020 | csrnum << 10 | 5
+		jirl zero, ra, 0
+		csrnum = csrnum + 1
+	.endr
+/*
+ * write guest csr
+ * 0x05000000 | (LOONGARCH_CSR_XXX << 10) | 1<<5 | a1
+ * range from 0x80 (KVM_CSR_IMPCTL1) to 0x8f (KVM_CSR_TLBRPRMD)
+ */
+11:
+	csrnum = 0x80
+	.rept 0x10
+		.word 0x05000020 | csrnum << 10 | 5
+		jirl zero, ra, 0
+		csrnum = csrnum + 1
+	.endr
+/*
+ * write guest csr
+ * 0x05000000 | (LOONGARCH_CSR_XXX << 10) | 1<<5 | a1
+ * range from 0x180(KVM_CSR_DMWIN0) to 0x183(KVM_CSR_DMWIN3)
+ */
+12:
+	csrnum = 0x180
+	.rept 0x4
+		.word 0x05000020 | csrnum << 10 | 5
+		jirl zero, ra, 0
+		csrnum = csrnum + 1
+	.endr
+SYM_FUNC_END(set_hw_gcsr)
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 651ae5ca0..dba6db363 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -13,6 +13,234 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v)
+{
+	unsigned long val;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	if (id >= CSR_ALL_SIZE || !(get_gcsr_flag(id) & (HW_GCSR | SW_GCSR)))
+		return -EINVAL;
+
+	if (id == LOONGARCH_CSR_ESTAT) {
+		/* interrupt status IP0 -- IP7 from GINTC */
+		val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_GINTC) & 0xff;
+		*v = kvm_read_sw_gcsr(csr, id) | (val << 2);
+		return 0;
+	}
+
+	/*
+	 * get software csr state if csrid is valid, since software
+	 * csr state is consistent with hardware
+	 */
+	*v = kvm_read_sw_gcsr(csr, id);
+
+	return 0;
+}
+
+int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	int ret = 0, gintc;
+
+	if (id >= CSR_ALL_SIZE || !(get_gcsr_flag(id) & (HW_GCSR | SW_GCSR)))
+		return -EINVAL;
+
+	if (id == LOONGARCH_CSR_ESTAT) {
+		/* estat IP0~IP7 inject through guestexcept */
+		gintc = (val >> 2) & 0xff;
+		write_csr_gintc(gintc);
+		kvm_set_sw_gcsr(csr, LOONGARCH_CSR_GINTC, gintc);
+
+		gintc = val & ~(0xffUL << 2);
+		write_gcsr_estat(gintc);
+		kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
+
+		return ret;
+	}
+
+	if (get_gcsr_flag(id) & HW_GCSR) {
+		set_hw_gcsr(id, val);
+		/* write sw gcsr to keep consistent with hardware */
+		kvm_write_sw_gcsr(csr, id, val);
+	} else
+		kvm_write_sw_gcsr(csr, id, val);
+
+	return ret;
+}
+
+static int _kvm_get_one_reg(struct kvm_vcpu *vcpu,
+		const struct kvm_one_reg *reg, s64 *v)
+{
+	int reg_idx, ret = 0;
+
+	if ((reg->id & KVM_REG_LOONGARCH_MASK) == KVM_REG_LOONGARCH_CSR) {
+		reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
+		ret = _kvm_getcsr(vcpu, reg_idx, v);
+	} else if (reg->id == KVM_REG_LOONGARCH_COUNTER)
+		*v = drdtime() + vcpu->kvm->arch.time_offset;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
+static int _kvm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	int ret;
+	s64 v;
+
+	ret = _kvm_get_one_reg(vcpu, reg, &v);
+	if (ret)
+		return ret;
+
+	ret = -EINVAL;
+	if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U64) {
+		u64 __user *uaddr = (u64 __user *)(long)reg->addr;
+
+		ret = put_user(v, uaddr);
+	} else if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U32) {
+		u32 __user *uaddr = (u32 __user *)(long)reg->addr;
+		u32 v32 = (u32)v;
+
+		ret = put_user(v32, uaddr);
+	}
+
+	return ret;
+}
+
+static int _kvm_set_one_reg(struct kvm_vcpu *vcpu,
+			const struct kvm_one_reg *reg,
+			s64 v)
+{
+	int ret = 0;
+	unsigned long flags;
+	u64 val;
+	int reg_idx;
+
+	val = v;
+	if ((reg->id & KVM_REG_LOONGARCH_MASK) == KVM_REG_LOONGARCH_CSR) {
+		reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
+		ret = _kvm_setcsr(vcpu, reg_idx, val);
+	} else if (reg->id == KVM_REG_LOONGARCH_COUNTER) {
+		local_irq_save(flags);
+		/*
+		 * gftoffset is relative with board, not vcpu
+		 * only set for the first time for smp system
+		 */
+		if (vcpu->vcpu_id == 0)
+			vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
+		write_csr_gcntc((ulong)vcpu->kvm->arch.time_offset);
+		local_irq_restore(flags);
+	} else if (reg->id == KVM_REG_LOONGARCH_VCPU_RESET) {
+		kvm_reset_timer(vcpu);
+		memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
+		memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
+	} else
+		ret = -EINVAL;
+
+	return ret;
+}
+
+static int _kvm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	s64 v;
+	int ret;
+
+	ret = -EINVAL;
+	if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U64) {
+		u64 __user *uaddr;
+
+		uaddr = (u64 __user *)(long)reg->addr;
+		ret = get_user(v, uaddr);
+	} else if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U32) {
+		u32 __user *uaddr;
+		s32 v32;
+
+		uaddr = (u32 __user *)(long)reg->addr;
+		ret = get_user(v32, uaddr);
+		v = (s64)v32;
+	}
+
+	if (ret)
+		return -EFAULT;
+
+	return _kvm_set_one_reg(vcpu, reg, v);
+}
+
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -ENOIOCTLCMD;
+}
+
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -ENOIOCTLCMD;
+}
+
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	int i;
+
+	vcpu_load(vcpu);
+
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
+		regs->gpr[i] = vcpu->arch.gprs[i];
+
+	regs->pc = vcpu->arch.pc;
+
+	vcpu_put(vcpu);
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	int i;
+
+	vcpu_load(vcpu);
+
+	for (i = 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
+		vcpu->arch.gprs[i] = regs->gpr[i];
+	vcpu->arch.gprs[0] = 0; /* zero is special, and cannot be set. */
+	vcpu->arch.pc = regs->pc;
+
+	vcpu_put(vcpu);
+	return 0;
+}
+
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
+{
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	long r;
+
+	vcpu_load(vcpu);
+
+	switch (ioctl) {
+	case KVM_SET_ONE_REG:
+	case KVM_GET_ONE_REG: {
+		struct kvm_one_reg reg;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			break;
+		if (ioctl == KVM_SET_ONE_REG)
+			r = _kvm_set_reg(vcpu, &reg);
+		else
+			r = _kvm_get_reg(vcpu, &reg);
+		break;
+	}
+	default:
+		r = -ENOIOCTLCMD;
+		break;
+	}
+
+	vcpu_put(vcpu);
+	return r;
+}
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	return 0;
-- 
2.31.1

