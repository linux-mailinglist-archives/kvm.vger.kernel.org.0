Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5476279C06E
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbjIKUse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbjIKKNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 06:13:23 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D7989E5F;
        Mon, 11 Sep 2023 03:13:16 -0700 (PDT)
Received: from loongson.cn (unknown [10.40.46.158])
        by gateway (Coremail) with SMTP id _____8DxPOs76P5k24skAA--.576S3;
        Mon, 11 Sep 2023 18:13:15 +0800 (CST)
Received: from [192.168.124.126] (unknown [10.40.46.158])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxjiM56P5keyh3AA--.47114S3;
        Mon, 11 Sep 2023 18:13:14 +0800 (CST)
Subject: Re: [PATCH v20 09/30] LoongArch: KVM: Implement vcpu get, vcpu set
 registers
From:   zhaotianrui <zhaotianrui@loongson.cn>
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-10-zhaotianrui@loongson.cn>
 <CAAhV-H6=e-Tg1tCdFhN5i2CSQpL-NDLovJdc9A=Sxt=3h-3Z0g@mail.gmail.com>
 <5bb1f2fa-c41d-9f0b-7eab-173af09df5a0@loongson.cn>
Message-ID: <839321b9-fe5b-9548-84d7-1d0867a65ffd@loongson.cn>
Date:   Mon, 11 Sep 2023 18:13:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5bb1f2fa-c41d-9f0b-7eab-173af09df5a0@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf8AxjiM56P5keyh3AA--.47114S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoW3ZFW3KFyDXFWUGryrGw4DAwc_yoW8Gry5Ao
        WUKr1fJr15Xr1jgr1UJw4UJry3JF1UJr1DtryUGry7Jr1jyw1UA3yUJrWUt3yUJr18Gr1U
        Jr1UJry0yFyjvr15l-sFpf9Il3svdjkaLaAFLSUrUUUUeb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUO87kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVW8ZVWrXwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jz5lbUUU
        UU=
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2023/9/11 下午6:03, zhaotianrui 写道:
>
> 在 2023/9/11 下午5:03, Huacai Chen 写道:
>> Hi, Tianrui,
>>
>> On Thu, Aug 31, 2023 at 4:30 PM Tianrui Zhao 
>> <zhaotianrui@loongson.cn> wrote:
>>> Implement LoongArch vcpu get registers and set registers operations, it
>>> is called when user space use the ioctl interface to get or set regs.
>>>
>>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>>> ---
>>>   arch/loongarch/kvm/csr_ops.S |  67 ++++++++++++
>>>   arch/loongarch/kvm/vcpu.c    | 206 
>>> +++++++++++++++++++++++++++++++++++
>>>   2 files changed, 273 insertions(+)
>>>   create mode 100644 arch/loongarch/kvm/csr_ops.S
>>>
>>> diff --git a/arch/loongarch/kvm/csr_ops.S 
>>> b/arch/loongarch/kvm/csr_ops.S
>>> new file mode 100644
>>> index 0000000000..53e44b23a5
>>> --- /dev/null
>>> +++ b/arch/loongarch/kvm/csr_ops.S
>>> @@ -0,0 +1,67 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>>> + */
>>> +
>>> +#include <asm/regdef.h>
>>> +#include <linux/linkage.h>
>>> +       .text
>>> +       .cfi_sections   .debug_frame
>>> +/*
>>> + * we have splited hw gcsr into three parts, so we can
>>> + * calculate the code offset by gcsrid and jump here to
>>> + * run the gcsrwr instruction.
>>> + */
>>> +SYM_FUNC_START(set_hw_gcsr)
>>> +       addi.d      t0,   a0,   0
>>> +       addi.w      t1,   zero, 96
>>> +       bltu        t1,   t0,   1f
>>> +       la.pcrel    t0,   10f
>>> +       alsl.d      t0,   a0,   t0, 3
>>> +       jr          t0
>>> +1:
>>> +       addi.w      t1,   a0,   -128
>>> +       addi.w      t2,   zero, 15
>>> +       bltu        t2,   t1,   2f
>>> +       la.pcrel    t0,   11f
>>> +       alsl.d      t0,   t1,   t0, 3
>>> +       jr          t0
>>> +2:
>>> +       addi.w      t1,   a0,   -384
>>> +       addi.w      t2,   zero, 3
>>> +       bltu        t2,   t1,   3f
>>> +       la.pcrel    t0,   12f
>>> +       alsl.d      t0,   t1,   t0, 3
>>> +       jr          t0
>>> +3:
>>> +       addi.w      a0,   zero, -1
>>> +       jr          ra
>>> +
>>> +/* range from 0x0(KVM_CSR_CRMD) to 0x60(KVM_CSR_LLBCTL) */
>>> +10:
>>> +       csrnum = 0
>>> +       .rept 0x61
>>> +       gcsrwr a1, csrnum
>>> +       jr ra
>>> +       csrnum = csrnum + 1
>>> +       .endr
>>> +
>>> +/* range from 0x80(KVM_CSR_IMPCTL1) to 0x8f(KVM_CSR_TLBRPRMD) */
>>> +11:
>>> +       csrnum = 0x80
>>> +       .rept 0x10
>>> +       gcsrwr a1, csrnum
>>> +       jr ra
>>> +       csrnum = csrnum + 1
>>> +       .endr
>>> +
>>> +/* range from 0x180(KVM_CSR_DMWIN0) to 0x183(KVM_CSR_DMWIN3) */
>>> +12:
>>> +       csrnum = 0x180
>>> +       .rept 0x4
>>> +       gcsrwr a1, csrnum
>>> +       jr ra
>>> +       csrnum = csrnum + 1
>>> +       .endr
>>> +
>>> +SYM_FUNC_END(set_hw_gcsr)
>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>> index ca4e8d074e..f17422a942 100644
>>> --- a/arch/loongarch/kvm/vcpu.c
>>> +++ b/arch/loongarch/kvm/vcpu.c
>>> @@ -13,6 +13,212 @@
>>>   #define CREATE_TRACE_POINTS
>>>   #include "trace.h"
>>>
>>> +int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v)
>>> +{
>>> +       unsigned long val;
>>> +       struct loongarch_csrs *csr = vcpu->arch.csr;
>>> +
>>> +       if (get_gcsr_flag(id) & INVALID_GCSR)
>>> +               return -EINVAL;
>>> +
>>> +       if (id == LOONGARCH_CSR_ESTAT) {
>>> +               /* interrupt status IP0 -- IP7 from GINTC */
>>> +               val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_GINTC) & 
>>> 0xff;
>>> +               *v = kvm_read_sw_gcsr(csr, id) | (val << 2);
>>> +               return 0;
>>> +       }
>>> +
>>> +       /*
>>> +        * get software csr state if csrid is valid, since software
>>> +        * csr state is consistent with hardware
>>> +        */
>> After a long time thinking, I found this is wrong. Of course
>> _kvm_setcsr() saves a software copy of the hardware registers, but the
>> hardware status will change. For example, during a VM running, it may
>> change the EUEN register if it uses fpu.
>>
>> So, we should do things like what we do in our internal repo,
>> _kvm_getcsr() should get values from hardware for HW_GCSR registers.
>> And we also need a get_hw_gcsr assembly function.
>>
>>
>> Huacai
> This is a asynchronous vcpu ioctl action, that is to say  this action 
> take place int the vcpu thread after vcpu get out of guest mode, and 
> the guest registers have been saved in software, so we could return 
> software register value when get guest csr.
>
> Thanks
> Tianrui Zhao
This sentence should be This is a **synchronous** vcpu ioctl action, ... ...
Sorry this is my spelling mistake.

Thanks
Tianrui Zhao
>>
>>> +       *v = kvm_read_sw_gcsr(csr, id);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>>> +{
>>> +       struct loongarch_csrs *csr = vcpu->arch.csr;
>>> +       int ret = 0, gintc;
>>> +
>>> +       if (get_gcsr_flag(id) & INVALID_GCSR)
>>> +               return -EINVAL;
>>> +
>>> +       if (id == LOONGARCH_CSR_ESTAT) {
>>> +               /* estat IP0~IP7 inject through guestexcept */
>>> +               gintc = (val >> 2) & 0xff;
>>> +               write_csr_gintc(gintc);
>>> +               kvm_set_sw_gcsr(csr, LOONGARCH_CSR_GINTC, gintc);
>>> +
>>> +               gintc = val & ~(0xffUL << 2);
>>> +               write_gcsr_estat(gintc);
>>> +               kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
>>> +
>>> +               return ret;
>>> +       }
>>> +
>>> +       if (get_gcsr_flag(id) & HW_GCSR) {
>>> +               set_hw_gcsr(id, val);
>>> +               /* write sw gcsr to keep consistent with hardware */
>>> +               kvm_write_sw_gcsr(csr, id, val);
>>> +       } else
>>> +               kvm_write_sw_gcsr(csr, id, val);
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +static int _kvm_get_one_reg(struct kvm_vcpu *vcpu,
>>> +               const struct kvm_one_reg *reg, s64 *v)
>>> +{
>>> +       int reg_idx, ret = 0;
>>> +
>>> +       if ((reg->id & KVM_REG_LOONGARCH_MASK) == 
>>> KVM_REG_LOONGARCH_CSR) {
>>> +               reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
>>> +               ret = _kvm_getcsr(vcpu, reg_idx, v);
>>> +       } else if (reg->id == KVM_REG_LOONGARCH_COUNTER)
>>> +               *v = drdtime() + vcpu->kvm->arch.time_offset;
>>> +       else
>>> +               ret = -EINVAL;
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +static int _kvm_get_reg(struct kvm_vcpu *vcpu, const struct 
>>> kvm_one_reg *reg)
>>> +{
>>> +       int ret = -EINVAL;
>>> +       s64 v;
>>> +
>>> +       if ((reg->id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
>>> +               return ret;
>>> +
>>> +       if (_kvm_get_one_reg(vcpu, reg, &v))
>>> +               return ret;
>>> +
>>> +       return put_user(v, (u64 __user *)(long)reg->addr);
>>> +}
>>> +
>>> +static int _kvm_set_one_reg(struct kvm_vcpu *vcpu,
>>> +                       const struct kvm_one_reg *reg,
>>> +                       s64 v)
>>> +{
>>> +       int ret = 0;
>>> +       unsigned long flags;
>>> +       u64 val;
>>> +       int reg_idx;
>>> +
>>> +       val = v;
>>> +       if ((reg->id & KVM_REG_LOONGARCH_MASK) == 
>>> KVM_REG_LOONGARCH_CSR) {
>>> +               reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
>>> +               ret = _kvm_setcsr(vcpu, reg_idx, val);
>>> +       } else if (reg->id == KVM_REG_LOONGARCH_COUNTER) {
>>> +               local_irq_save(flags);
>>> +               /*
>>> +                * gftoffset is relative with board, not vcpu
>>> +                * only set for the first time for smp system
>>> +                */
>>> +               if (vcpu->vcpu_id == 0)
>>> +                       vcpu->kvm->arch.time_offset = (signed 
>>> long)(v - drdtime());
>>> + write_csr_gcntc((ulong)vcpu->kvm->arch.time_offset);
>>> +               local_irq_restore(flags);
>>> +       } else if (reg->id == KVM_REG_LOONGARCH_VCPU_RESET) {
>>> +               kvm_reset_timer(vcpu);
>>> +               memset(&vcpu->arch.irq_pending, 0, 
>>> sizeof(vcpu->arch.irq_pending));
>>> +               memset(&vcpu->arch.irq_clear, 0, 
>>> sizeof(vcpu->arch.irq_clear));
>>> +       } else
>>> +               ret = -EINVAL;
>>> +
>>> +       return ret;
>>> +}
>>> +
>>> +static int _kvm_set_reg(struct kvm_vcpu *vcpu, const struct 
>>> kvm_one_reg *reg)
>>> +{
>>> +       s64 v;
>>> +       int ret = -EINVAL;
>>> +
>>> +       if ((reg->id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
>>> +               return ret;
>>> +
>>> +       if (get_user(v, (u64 __user *)(long)reg->addr))
>>> +               return ret;
>>> +
>>> +       return _kvm_set_one_reg(vcpu, reg, v);
>>> +}
>>> +
>>> +int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
>>> +                                 struct kvm_sregs *sregs)
>>> +{
>>> +       return -ENOIOCTLCMD;
>>> +}
>>> +
>>> +int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>>> +                                 struct kvm_sregs *sregs)
>>> +{
>>> +       return -ENOIOCTLCMD;
>>> +}
>>> +
>>> +int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct 
>>> kvm_regs *regs)
>>> +{
>>> +       int i;
>>> +
>>> +       vcpu_load(vcpu);
>>> +
>>> +       for (i = 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
>>> +               regs->gpr[i] = vcpu->arch.gprs[i];
>>> +
>>> +       regs->pc = vcpu->arch.pc;
>>> +
>>> +       vcpu_put(vcpu);
>>> +       return 0;
>>> +}
>>> +
>>> +int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct 
>>> kvm_regs *regs)
>>> +{
>>> +       int i;
>>> +
>>> +       vcpu_load(vcpu);
>>> +
>>> +       for (i = 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
>>> +               vcpu->arch.gprs[i] = regs->gpr[i];
>>> +       vcpu->arch.gprs[0] = 0; /* zero is special, and cannot be 
>>> set. */
>>> +       vcpu->arch.pc = regs->pc;
>>> +
>>> +       vcpu_put(vcpu);
>>> +       return 0;
>>> +}
>>> +
>>> +long kvm_arch_vcpu_ioctl(struct file *filp,
>>> +                        unsigned int ioctl, unsigned long arg)
>>> +{
>>> +       struct kvm_vcpu *vcpu = filp->private_data;
>>> +       void __user *argp = (void __user *)arg;
>>> +       long r;
>>> +
>>> +       vcpu_load(vcpu);
>>> +
>>> +       switch (ioctl) {
>>> +       case KVM_SET_ONE_REG:
>>> +       case KVM_GET_ONE_REG: {
>>> +               struct kvm_one_reg reg;
>>> +
>>> +               r = -EFAULT;
>>> +               if (copy_from_user(&reg, argp, sizeof(reg)))
>>> +                       break;
>>> +               if (ioctl == KVM_SET_ONE_REG)
>>> +                       r = _kvm_set_reg(vcpu, &reg);
>>> +               else
>>> +                       r = _kvm_get_reg(vcpu, &reg);
>>> +               break;
>>> +       }
>>> +       default:
>>> +               r = -ENOIOCTLCMD;
>>> +               break;
>>> +       }
>>> +
>>> +       vcpu_put(vcpu);
>>> +       return r;
>>> +}
>>> +
>>>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>>>   {
>>>          return 0;
>>> -- 
>>> 2.27.0
>>>

