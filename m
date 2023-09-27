Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC847AF96F
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjI0EeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjI0EdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:33:15 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0B8319E;
        Tue, 26 Sep 2023 20:10:08 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Cx5_ENnRNlGBctAA--.20513S3;
        Wed, 27 Sep 2023 11:10:05 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S9;
        Wed, 27 Sep 2023 11:10:03 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v22 07/25] LoongArch: KVM: Implement basic vcpu ioctl interfaces
Date:   Wed, 27 Sep 2023 11:09:41 +0800
Message-Id: <20230927030959.3629941-8-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S9
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement basic vcpu ioctl interfaces, including:

1, vcpu KVM_ENABLE_CAP ioctl interface.

2, vcpu get registers and set registers operations, it is called when
user space use the ioctl interface to get or set regs.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 261 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 261 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 349cecca1e..4870655659 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -141,6 +141,267 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	return RESUME_GUEST;
 }
 
+static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *val)
+{
+	unsigned long gintc;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	if (get_gcsr_flag(id) & INVALID_GCSR)
+		return -EINVAL;
+
+	if (id == LOONGARCH_CSR_ESTAT) {
+		/* ESTAT IP0~IP7 get from GINTC */
+		gintc = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_GINTC) & 0xff;
+		*val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT) | (gintc << 2);
+		return 0;
+	}
+
+	/*
+	 * Get software CSR state since software state is consistent
+	 * with hardware for synchronous ioctl
+	 */
+	*val = kvm_read_sw_gcsr(csr, id);
+
+	return 0;
+}
+
+static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
+{
+	int ret = 0, gintc;
+	struct loongarch_csrs *csr = vcpu->arch.csr;
+
+	if (get_gcsr_flag(id) & INVALID_GCSR)
+		return -EINVAL;
+
+	if (id == LOONGARCH_CSR_ESTAT) {
+		/* ESTAT IP0~IP7 inject through GINTC */
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
+
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
+		id = KVM_GET_IOC_CSR_IDX(reg->id);
+		ret = _kvm_getcsr(vcpu, id, v);
+		break;
+	case KVM_REG_LOONGARCH_CPUCFG:
+		id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
+		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS)
+			*v = vcpu->arch.cpucfg[id];
+		else
+			ret = -EINVAL;
+		break;
+	case KVM_REG_LOONGARCH_KVM:
+		switch (reg->id) {
+		case KVM_REG_LOONGARCH_COUNTER:
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
+
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
+
+	return ret;
+}
+
+static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
+			const struct kvm_one_reg *reg, u64 v)
+{
+	int id, ret = 0;
+	u64 type = reg->id & KVM_REG_LOONGARCH_MASK;
+
+	switch (type) {
+	case KVM_REG_LOONGARCH_CSR:
+		id = KVM_GET_IOC_CSR_IDX(reg->id);
+		ret = _kvm_setcsr(vcpu, id, v);
+		break;
+	case KVM_REG_LOONGARCH_CPUCFG:
+		id = KVM_GET_IOC_CPUCFG_IDX(reg->id);
+		if (id >= 0 && id < KVM_MAX_CPUCFG_REGS)
+			vcpu->arch.cpucfg[id] = (u32)v;
+		else
+			ret = -EINVAL;
+		break;
+	case KVM_REG_LOONGARCH_KVM:
+		switch (reg->id) {
+		case KVM_REG_LOONGARCH_COUNTER:
+			/*
+			 * gftoffset is relative with board, not vcpu
+			 * only set for the first time for smp system
+			 */
+			if (vcpu->vcpu_id == 0)
+				vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
+			break;
+		case KVM_REG_LOONGARCH_VCPU_RESET:
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
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+{
+	return -ENOIOCTLCMD;
+}
+
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
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
+
+	vcpu->arch.gprs[0] = 0; /* zero is special, and cannot be set. */
+	vcpu->arch.pc = regs->pc;
+
+	return 0;
+}
+
+static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
+				     struct kvm_enable_cap *cap)
+{
+	/* FPU is enabled by default, will support LSX/LASX later. */
+	return -EINVAL;
+}
+
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
+{
+	long r;
+	void __user *argp = (void __user *)arg;
+	struct kvm_vcpu *vcpu = filp->private_data;
+
+	/*
+	 * Only software CSR should be modified
+	 *
+	 * If any hardware CSR register is modified, vcpu_load/vcpu_put pair
+	 * should be used. Since CSR registers owns by this vcpu, if switch
+	 * to other vcpus, other vcpus need reload CSR registers.
+	 *
+	 * If software CSR is modified, bit KVM_LARCH_HWCSR_USABLE should
+	 * be clear in vcpu->arch.aux_inuse, and vcpu_load will check
+	 * aux_inuse flag and reload CSR registers form software.
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
+	case KVM_ENABLE_CAP: {
+		struct kvm_enable_cap cap;
+
+		r = -EFAULT;
+		if (copy_from_user(&cap, argp, sizeof(cap)))
+			break;
+		r = kvm_vcpu_ioctl_enable_cap(vcpu, &cap);
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
2.39.3

