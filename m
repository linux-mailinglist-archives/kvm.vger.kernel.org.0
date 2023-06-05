Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E60D7226C9
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbjFENEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjFENEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:04:12 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAB46A1;
        Mon,  5 Jun 2023 06:04:09 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8BxF_FH3X1kwxgAAA--.306S3;
        Mon, 05 Jun 2023 21:04:07 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxGOVG3X1k4oAAAA--.2379S3;
        Mon, 05 Jun 2023 21:04:06 +0800 (CST)
Message-ID: <8a358331-2cc6-f4e7-69ea-4a574a336892@loongson.cn>
Date:   Mon, 5 Jun 2023 21:04:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 09/31] LoongArch: KVM: Implement vcpu get, vcpu set
 registers
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-10-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-10-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxGOVG3X1k4oAAAA--.2379S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3AF1UKr1xWF43tr4UCr1fXwc_yoW3CryUpF
        yUAwsxWrWxtF1xCw1ftFn09Fs09r4kKr17u3srCrWSyrnrtry5tF4kKrZxAFW5GrykZF1I
        vF1YyF4I9F4Dt3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        tVWrXwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
        xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
        c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267
        AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_
        Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j873
        kUUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Bibo, Mao <maobibo@loongson.cn>

在 2023/5/30 09:52, Tianrui Zhao 写道:
> Implement LoongArch vcpu get registers and set registers operations, it
> is called when user space use the ioctl interface to get or set regs.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/csr_ops.S |  76 +++++++++++++
>  arch/loongarch/kvm/vcpu.c    | 206 +++++++++++++++++++++++++++++++++++
>  2 files changed, 282 insertions(+)
>  create mode 100644 arch/loongarch/kvm/csr_ops.S
> 
> diff --git a/arch/loongarch/kvm/csr_ops.S b/arch/loongarch/kvm/csr_ops.S
> new file mode 100644
> index 000000000000..962b96d8291a
> --- /dev/null
> +++ b/arch/loongarch/kvm/csr_ops.S
> @@ -0,0 +1,76 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <asm/regdef.h>
> +#include <linux/linkage.h>
> +	.text
> +	.section        .text
> +	.cfi_sections   .debug_frame
> +/*
> + * we have splited hw gcsr into three parts, so we can
> + * calculate the code offset by gcsrid and jump here to
> + * run the gcsrwr instruction.
> + */
> +SYM_FUNC_START(set_hw_gcsr)
> +	addi.d      t0,   a0,   0
> +	addi.w      t1,   zero, 96
> +	bltu        t1,   t0,   1f
> +	la.pcrel    t0,   10f
> +	alsl.d      t0,   a0,   t0, 3
> +	jirl        zero, t0,   0
> +1:
> +	addi.w      t1,   a0,   -128
> +	addi.w      t2,   zero, 15
> +	bltu        t2,   t1,   2f
> +	la.pcrel    t0,   11f
> +	alsl.d      t0,   t1,   t0, 3
> +	jirl        zero, t0,   0
> +2:
> +	addi.w      t1,   a0,   -384
> +	addi.w      t2,   zero, 3
> +	bltu        t2,   t1,   3f
> +	la.pcrel    t0,   12f
> +	alsl.d      t0,   t1,   t0, 3
> +	jirl        zero, t0,   0
> +3:
> +	addi.w      a0,   zero, -1
> +	jirl        zero, ra,   0
> +/*
> + * write guest csr
> + * 0x05000000 | (LOONGARCH_CSR_XXX << 10) | 1 << 5 | a1
> + * range from 0x0(KVM_CSR_CRMD) to 0x60 (KVM_CSR_LLBCTL)
> + */
> +10:
> +	csrnum = 0
> +	.rept 0x61
> +		.word 0x05000020 | csrnum << 10 | 5
> +		jirl zero, ra, 0
> +		csrnum = csrnum + 1
> +	.endr
> +/*
> + * write guest csr
> + * 0x05000000 | (LOONGARCH_CSR_XXX << 10) | 1<<5 | a1
> + * range from 0x80 (KVM_CSR_IMPCTL1) to 0x8f (KVM_CSR_TLBRPRMD)
> + */
> +11:
> +	csrnum = 0x80
> +	.rept 0x10
> +		.word 0x05000020 | csrnum << 10 | 5
> +		jirl zero, ra, 0
> +		csrnum = csrnum + 1
> +	.endr
> +/*
> + * write guest csr
> + * 0x05000000 | (LOONGARCH_CSR_XXX << 10) | 1<<5 | a1
> + * range from 0x180(KVM_CSR_DMWIN0) to 0x183(KVM_CSR_DMWIN3)
> + */
> +12:
> +	csrnum = 0x180
> +	.rept 0x4
> +		.word 0x05000020 | csrnum << 10 | 5
> +		jirl zero, ra, 0
> +		csrnum = csrnum + 1
> +	.endr
> +SYM_FUNC_END(set_hw_gcsr)
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index ddea480fa5b0..278fbafc59b4 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -12,6 +12,212 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>  
> +int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v)
> +{
> +	unsigned long val;
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +
> +	if (id >= CSR_MAX_NUMS || !(get_gcsr_flag(id) & (HW_GCSR | SW_GCSR)))
> +		return -EINVAL;
> +
> +	if (id == LOONGARCH_CSR_ESTAT) {
> +		/* interrupt status IP0 -- IP7 from GINTC */
> +		val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_GINTC) & 0xff;
> +		*v = kvm_read_sw_gcsr(csr, id) | (val << 2);
> +		return 0;
> +	}
> +
> +	/*
> +	 * get software csr state if csrid is valid, since software
> +	 * csr state is consistent with hardware
> +	 */
> +	*v = kvm_read_sw_gcsr(csr, id);
> +
> +	return 0;
> +}
> +
> +int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
> +{
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +	int ret = 0, gintc;
> +
> +	if (id >= CSR_MAX_NUMS || !(get_gcsr_flag(id) & (HW_GCSR | SW_GCSR)))
> +		return -EINVAL;
> +
> +	if (id == LOONGARCH_CSR_ESTAT) {
> +		/* estat IP0~IP7 inject through guestexcept */
> +		gintc = (val >> 2) & 0xff;
> +		write_csr_gintc(gintc);
> +		kvm_set_sw_gcsr(csr, LOONGARCH_CSR_GINTC, gintc);
> +
> +		gintc = val & ~(0xffUL << 2);
> +		write_gcsr_estat(gintc);
> +		kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
> +
> +		return ret;
> +	}
> +
> +	if (get_gcsr_flag(id) & HW_GCSR) {
> +		set_hw_gcsr(id, val);
> +		/* write sw gcsr to keep consistent with hardware */
> +		kvm_write_sw_gcsr(csr, id, val);
> +	} else
> +		kvm_write_sw_gcsr(csr, id, val);
> +
> +	return ret;
> +}
> +
> +static int _kvm_get_one_reg(struct kvm_vcpu *vcpu,
> +		const struct kvm_one_reg *reg, s64 *v)
> +{
> +	int reg_idx, ret = 0;
> +
> +	if ((reg->id & KVM_REG_LOONGARCH_MASK) == KVM_REG_LOONGARCH_CSR) {
> +		reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
> +		ret = _kvm_getcsr(vcpu, reg_idx, v);
> +	} else if (reg->id == KVM_REG_LOONGARCH_COUNTER)
> +		*v = drdtime() + vcpu->kvm->arch.time_offset;
> +	else
> +		ret = -EINVAL;
> +
> +	return ret;
> +}
> +
> +static int _kvm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	int ret = -EINVAL;
> +	s64 v;
> +
> +	if ((reg->id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
> +		return ret;
> +
> +	if (_kvm_get_one_reg(vcpu, reg, &v))
> +		return ret;
> +
> +	return put_user(v, (u64 __user *)(long)reg->addr);
> +}
> +
> +static int _kvm_set_one_reg(struct kvm_vcpu *vcpu,
> +			const struct kvm_one_reg *reg,
> +			s64 v)
> +{
> +	int ret = 0;
> +	unsigned long flags;
> +	u64 val;
> +	int reg_idx;
> +
> +	val = v;
> +	if ((reg->id & KVM_REG_LOONGARCH_MASK) == KVM_REG_LOONGARCH_CSR) {
> +		reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
> +		ret = _kvm_setcsr(vcpu, reg_idx, val);
> +	} else if (reg->id == KVM_REG_LOONGARCH_COUNTER) {
> +		local_irq_save(flags);
> +		/*
> +		 * gftoffset is relative with board, not vcpu
> +		 * only set for the first time for smp system
> +		 */
> +		if (vcpu->vcpu_id == 0)
> +			vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
> +		write_csr_gcntc((ulong)vcpu->kvm->arch.time_offset);
> +		local_irq_restore(flags);
> +	} else if (reg->id == KVM_REG_LOONGARCH_VCPU_RESET) {
> +		kvm_reset_timer(vcpu);
> +		memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
> +		memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
> +	} else
> +		ret = -EINVAL;
> +
> +	return ret;
> +}
> +
> +static int _kvm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	s64 v;
> +	int ret = -EINVAL;
> +
> +	if ((reg->id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
> +		return ret;
> +
> +	if (get_user(v, (u64 __user *)(long)reg->addr))
> +		return ret;
> +
> +	return _kvm_set_one_reg(vcpu, reg, v);
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
> +				  struct kvm_sregs *sregs)
> +{
> +	return -ENOIOCTLCMD;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> +				  struct kvm_sregs *sregs)
> +{
> +	return -ENOIOCTLCMD;
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> +{
> +	int i;
> +
> +	vcpu_load(vcpu);
> +
> +	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
> +		regs->gpr[i] = vcpu->arch.gprs[i];
> +
> +	regs->pc = vcpu->arch.pc;
> +
> +	vcpu_put(vcpu);
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> +{
> +	int i;
> +
> +	vcpu_load(vcpu);
> +
> +	for (i = 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
> +		vcpu->arch.gprs[i] = regs->gpr[i];
> +	vcpu->arch.gprs[0] = 0; /* zero is special, and cannot be set. */
> +	vcpu->arch.pc = regs->pc;
> +
> +	vcpu_put(vcpu);
> +	return 0;
> +}
> +
> +long kvm_arch_vcpu_ioctl(struct file *filp,
> +			 unsigned int ioctl, unsigned long arg)
> +{
> +	struct kvm_vcpu *vcpu = filp->private_data;
> +	void __user *argp = (void __user *)arg;
> +	long r;
> +
> +	vcpu_load(vcpu);
> +
> +	switch (ioctl) {
> +	case KVM_SET_ONE_REG:
> +	case KVM_GET_ONE_REG: {
> +		struct kvm_one_reg reg;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&reg, argp, sizeof(reg)))
> +			break;
> +		if (ioctl == KVM_SET_ONE_REG)
> +			r = _kvm_set_reg(vcpu, &reg);
> +		else
> +			r = _kvm_get_reg(vcpu, &reg);
> +		break;
> +	}
> +	default:
> +		r = -ENOIOCTLCMD;
> +		break;
> +	}
> +
> +	vcpu_put(vcpu);
> +	return r;
> +}
> +
>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>  {
>  	return 0;

