Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4F57A131B
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjIOBuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjIOBuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:50:06 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E6542710;
        Thu, 14 Sep 2023 18:50:01 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxLOtFuANlyf4nAA--.6079S3;
        Fri, 15 Sep 2023 09:49:57 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axndw9uANl+ioGAA--.11927S11;
        Fri, 15 Sep 2023 09:49:56 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v21 09/29] LoongArch: KVM: Implement vcpu get, vcpu set registers
Date:   Fri, 15 Sep 2023 09:49:29 +0800
Message-Id: <20230915014949.1222777-10-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axndw9uANl+ioGAA--.11927S11
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch vcpu get registers and set registers operations, it
is called when user space use the ioctl interface to get or set regs.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 244 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 244 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index bfc2ec1a88..1cc53f56d0 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -13,6 +13,250 @@
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
+int kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v)
+{
+	unsigned long val;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	if (get_gcsr_flag(id) & INVALID_GCSR)
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
+int kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
+{
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+	int ret = 0, gintc;
+
+	if (get_gcsr_flag(id) & INVALID_GCSR)
+		return -EINVAL;
+
+	if (id == LOONGARCH_CSR_ESTAT) {
+		/* estat IP0~IP7 inject through guestexcept */
+		gintc = (val >> 2) & 0xff;
+		kvm_set_sw_gcsr(csr, LOONGARCH_CSR_GINTC, gintc);
+
+		gintc = val & ~(0xffUL << 2);
+		kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
+
+		return ret;
+	}
+
+	kvm_write_sw_gcsr(csr, id, val);
+	return ret;
+}
+
+static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
+		const struct kvm_one_reg *reg, u64 *v)
+{
+	int id, ret = 0;
+	u64 type = reg->id & KVM_REG_LOONGARCH_MASK;
+
+	switch (type) {
+	case KVM_REG_LOONGARCH_CSR:
+		id = KVM_GET_IOC_CSRIDX(reg->id);
+		ret = kvm_getcsr(vcpu, id, v);
+		break;
+	case KVM_REG_LOONGARCH_CPUCFG:
+		id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
+		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS)
+			*v = vcpu->arch.cpucfg[id];
+		else
+			ret = -EINVAL;
+		break;
+	case KVM_REG_LOONGARCH_KVM:
+		switch (reg->id & 0xf) {
+		case 4: /* counter reg */
+			*v = drdtime() + vcpu->kvm->arch.time_offset;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int kvm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	int ret = 0;
+	u64 v, size = reg->id & KVM_REG_SIZE_MASK;
+
+	switch (size) {
+	case KVM_REG_SIZE_U64:
+		ret = kvm_get_one_reg(vcpu, reg, &v);
+		if (ret)
+			return ret;
+		ret = put_user(v, (u64 __user *)(long)reg->addr);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
+			const struct kvm_one_reg *reg,
+			u64 v)
+{
+	int id, ret = 0;
+	u64 type = reg->id & KVM_REG_LOONGARCH_MASK;
+
+	switch (type) {
+	case KVM_REG_LOONGARCH_CSR:
+		id = KVM_GET_IOC_CSRIDX(reg->id);
+		ret = kvm_setcsr(vcpu, id, v);
+		break;
+	case KVM_REG_LOONGARCH_CPUCFG:
+		id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
+		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS)
+			vcpu->arch.cpucfg[id] = (u32)v;
+		else
+			ret = -EINVAL;
+		break;
+	case KVM_REG_LOONGARCH_KVM:
+		switch (reg->id & 0xf) {
+		case 3: /* counter reg */
+			/*
+			 * gftoffset is relative with board, not vcpu
+			 * only set for the first time for smp system
+			 */
+			if (vcpu->vcpu_id == 0)
+				vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
+			break;
+		case 4: /* vcpu reset */
+			kvm_reset_timer(vcpu);
+			memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
+			memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int kvm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
+{
+	int ret = 0;
+	u64 v, size = reg->id & KVM_REG_SIZE_MASK;
+
+	switch (size) {
+	case KVM_REG_SIZE_U64:
+		ret = get_user(v, (u64 __user *)(long)reg->addr);
+		if (ret)
+			return ret;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return kvm_set_one_reg(vcpu, reg, v);
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
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
+		regs->gpr[i] = vcpu->arch.gprs[i];
+
+	regs->pc = vcpu->arch.pc;
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	int i;
+
+	for (i = 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
+		vcpu->arch.gprs[i] = regs->gpr[i];
+	vcpu->arch.gprs[0] = 0; /* zero is special, and cannot be set. */
+	vcpu->arch.pc = regs->pc;
+
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
+	/*
+	 * Only software CSR should be modified
+	 *
+	 * If any hardware CSR register is modified, vcpu_load/vcpu_put pair
+	 * should be used. Since CSR registers owns by this vcpu, if switch
+	 * to other vcpus, other vcpus need reload CSR register.
+	 *
+	 * If software CSR is modified, bit KVM_LARCH_HWCSR_USABLE should
+	 * be clear in vcpu->arch.aux_inuse, and vcpu_load will check
+	 * aux_inuse flag and reload CSR form sw
+	 */
+
+	switch (ioctl) {
+	case KVM_SET_ONE_REG:
+	case KVM_GET_ONE_REG: {
+		struct kvm_one_reg reg;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			break;
+		if (ioctl == KVM_SET_ONE_REG) {
+			r = kvm_set_reg(vcpu, &reg);
+			vcpu->arch.aux_inuse &= ~KVM_LARCH_HWCSR_USABLE;
+		} else
+			r = kvm_get_reg(vcpu, &reg);
+		break;
+	}
+	default:
+		r = -ENOIOCTLCMD;
+		break;
+	}
+
+	return r;
+}
+
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
 	return 0;
-- 
2.39.1

