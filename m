Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9510F79C3AE
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241678AbjILDGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241576AbjILDGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:06:01 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08597218C8;
        Mon, 11 Sep 2023 19:41:45 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Ax1fDoz_9kVjclAA--.7147S3;
        Tue, 12 Sep 2023 10:41:44 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxkN3mz_9k5wQAAA--.135S3;
        Tue, 12 Sep 2023 10:41:42 +0800 (CST)
Message-ID: <ac56e2e3-186e-a0e5-2291-3aaad0c508a6@loongson.cn>
Date:   Tue, 12 Sep 2023 10:41:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v20 09/30] LoongArch: KVM: Implement vcpu get, vcpu set
 registers
Content-Language: en-US
To:     Huacai Chen <chenhuacai@kernel.org>,
        zhaotianrui <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn>
 <20230831083020.2187109-10-zhaotianrui@loongson.cn>
 <CAAhV-H6=e-Tg1tCdFhN5i2CSQpL-NDLovJdc9A=Sxt=3h-3Z0g@mail.gmail.com>
 <5bb1f2fa-c41d-9f0b-7eab-173af09df5a0@loongson.cn>
 <CAAhV-H7YcRfbVbQ=MpUp6wOeCDX5AGkdprwVgKv7AC=FxS4u7w@mail.gmail.com>
From:   bibo mao <maobibo@loongson.cn>
In-Reply-To: <CAAhV-H7YcRfbVbQ=MpUp6wOeCDX5AGkdprwVgKv7AC=FxS4u7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxkN3mz_9k5wQAAA--.135S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3ur4kGw4UGr4fuF1xKF1kXrc_yoWkJw17pr
        WUAa15Zr48tr17Jw10qwn0grnIqry8Kr1xZry7Gayayr1qyFy3tF4Fkry5CFy8Cr18CF1I
        vFyDJF4S9F1rA3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
        6F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
        Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
        Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
        CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
        IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcbAwUUUUU
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/9/11 19:49, Huacai Chen 写道:
> Hi, Tianrui,
> 
> On Mon, Sep 11, 2023 at 6:03 PM zhaotianrui <zhaotianrui@loongson.cn> wrote:
>>
>>
>> 在 2023/9/11 下午5:03, Huacai Chen 写道:
>>> Hi, Tianrui,
>>>
>>> On Thu, Aug 31, 2023 at 4:30 PM Tianrui Zhao <zhaotianrui@loongson.cn> wrote:
>>>> Implement LoongArch vcpu get registers and set registers operations, it
>>>> is called when user space use the ioctl interface to get or set regs.
>>>>
>>>> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
>>>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>>>> ---
>>>>   arch/loongarch/kvm/csr_ops.S |  67 ++++++++++++
>>>>   arch/loongarch/kvm/vcpu.c    | 206 +++++++++++++++++++++++++++++++++++
>>>>   2 files changed, 273 insertions(+)
>>>>   create mode 100644 arch/loongarch/kvm/csr_ops.S
>>>>
>>>> diff --git a/arch/loongarch/kvm/csr_ops.S b/arch/loongarch/kvm/csr_ops.S
>>>> new file mode 100644
>>>> index 0000000000..53e44b23a5
>>>> --- /dev/null
>>>> +++ b/arch/loongarch/kvm/csr_ops.S
>>>> @@ -0,0 +1,67 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/*
>>>> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
>>>> + */
>>>> +
>>>> +#include <asm/regdef.h>
>>>> +#include <linux/linkage.h>
>>>> +       .text
>>>> +       .cfi_sections   .debug_frame
>>>> +/*
>>>> + * we have splited hw gcsr into three parts, so we can
>>>> + * calculate the code offset by gcsrid and jump here to
>>>> + * run the gcsrwr instruction.
>>>> + */
>>>> +SYM_FUNC_START(set_hw_gcsr)
>>>> +       addi.d      t0,   a0,   0
>>>> +       addi.w      t1,   zero, 96
>>>> +       bltu        t1,   t0,   1f
>>>> +       la.pcrel    t0,   10f
>>>> +       alsl.d      t0,   a0,   t0, 3
>>>> +       jr          t0
>>>> +1:
>>>> +       addi.w      t1,   a0,   -128
>>>> +       addi.w      t2,   zero, 15
>>>> +       bltu        t2,   t1,   2f
>>>> +       la.pcrel    t0,   11f
>>>> +       alsl.d      t0,   t1,   t0, 3
>>>> +       jr          t0
>>>> +2:
>>>> +       addi.w      t1,   a0,   -384
>>>> +       addi.w      t2,   zero, 3
>>>> +       bltu        t2,   t1,   3f
>>>> +       la.pcrel    t0,   12f
>>>> +       alsl.d      t0,   t1,   t0, 3
>>>> +       jr          t0
>>>> +3:
>>>> +       addi.w      a0,   zero, -1
>>>> +       jr          ra
>>>> +
>>>> +/* range from 0x0(KVM_CSR_CRMD) to 0x60(KVM_CSR_LLBCTL) */
>>>> +10:
>>>> +       csrnum = 0
>>>> +       .rept 0x61
>>>> +       gcsrwr a1, csrnum
>>>> +       jr ra
>>>> +       csrnum = csrnum + 1
>>>> +       .endr
>>>> +
>>>> +/* range from 0x80(KVM_CSR_IMPCTL1) to 0x8f(KVM_CSR_TLBRPRMD) */
>>>> +11:
>>>> +       csrnum = 0x80
>>>> +       .rept 0x10
>>>> +       gcsrwr a1, csrnum
>>>> +       jr ra
>>>> +       csrnum = csrnum + 1
>>>> +       .endr
>>>> +
>>>> +/* range from 0x180(KVM_CSR_DMWIN0) to 0x183(KVM_CSR_DMWIN3) */
>>>> +12:
>>>> +       csrnum = 0x180
>>>> +       .rept 0x4
>>>> +       gcsrwr a1, csrnum
>>>> +       jr ra
>>>> +       csrnum = csrnum + 1
>>>> +       .endr
>>>> +
>>>> +SYM_FUNC_END(set_hw_gcsr)
>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>> index ca4e8d074e..f17422a942 100644
>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>> @@ -13,6 +13,212 @@
>>>>   #define CREATE_TRACE_POINTS
>>>>   #include "trace.h"
>>>>
>>>> +int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v)
>>>> +{
>>>> +       unsigned long val;
>>>> +       struct loongarch_csrs *csr = vcpu->arch.csr;
>>>> +
>>>> +       if (get_gcsr_flag(id) & INVALID_GCSR)
>>>> +               return -EINVAL;
>>>> +
>>>> +       if (id == LOONGARCH_CSR_ESTAT) {
>>>> +               /* interrupt status IP0 -- IP7 from GINTC */
>>>> +               val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_GINTC) & 0xff;
>>>> +               *v = kvm_read_sw_gcsr(csr, id) | (val << 2);
>>>> +               return 0;
>>>> +       }
>>>> +
>>>> +       /*
>>>> +        * get software csr state if csrid is valid, since software
>>>> +        * csr state is consistent with hardware
>>>> +        */
>>> After a long time thinking, I found this is wrong. Of course
>>> _kvm_setcsr() saves a software copy of the hardware registers, but the
>>> hardware status will change. For example, during a VM running, it may
>>> change the EUEN register if it uses fpu.
>>>
>>> So, we should do things like what we do in our internal repo,
>>> _kvm_getcsr() should get values from hardware for HW_GCSR registers.
>>> And we also need a get_hw_gcsr assembly function.
>>>
>>>
>>> Huacai
>> This is a asynchronous vcpu ioctl action, that is to say  this action
>> take place int the vcpu thread after vcpu get out of guest mode, and the
>> guest registers have been saved in software, so we could return software
>> register value when get guest csr.
> Maybe you are right in this case, but it is still worthy to get from
> hardware directly (more straightforward, more understandable, more
> robust). And from my point of view, this is not a performance-critical
> path so the 'optimization' is unnecessary.
Current vcpu_load/vcpu_put is called with the flowing function:
  1. kvm_arch_vcpu_ioctl_get_regs/kvm_arch_vcpu_ioctl_set_regs pair
  2. kvm_arch_vcpu_ioctl
  3. kvm_sched_in/kvm_sched_out hook function, kvm_arch_vcpu_load is called
  4. kvm_arch_vcpu_ioctl_run
Yeap, we can remove vcpu_load/vcpu_put function call during 1) and 2).

Here is pseudo code when vm starts to run.
   kvm_arch_vcpu_ioctl(KVM_SET_ONE_REG, ..)
   kvm_arch_vcpu_ioctl(KVM_SET_ONE_REG, ..)
   kvm_vcpu_ioctl(KVM_RUN)
kvm_arch_vcpu_ioctl(KVM_SET_ONE_REG) may run in CPU0, and kvm_vcpu_ioctl(KVM_RUN)
runs in CPU1. so kvm_arch_vcpu_ioctl_run needs restores hw csr from sw, and
 _kvm_setcsr needs set csr to sw.

KVM_LARCH_CSR flag is for optimization for kvm_sched_in/kvm_sched_out hook function,
there is another scenario such as CPU/Memory is shared by multiple VMs, memory will
be swapped out and there will be multiple page faults for the second mmu, vcpu may
be preempted since physical CPU is shared by multiple VM. In this scenario 
kvm_sched_in/kvm_sched_out hook function call will be frequent.

Regards
Bibo Mao
> 
> Huacai
> 
>>
>> Thanks
>> Tianrui Zhao
>>>
>>>> +       *v = kvm_read_sw_gcsr(csr, id);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>>>> +{
>>>> +       struct loongarch_csrs *csr = vcpu->arch.csr;
>>>> +       int ret = 0, gintc;
>>>> +
>>>> +       if (get_gcsr_flag(id) & INVALID_GCSR)
>>>> +               return -EINVAL;
>>>> +
>>>> +       if (id == LOONGARCH_CSR_ESTAT) {
>>>> +               /* estat IP0~IP7 inject through guestexcept */
>>>> +               gintc = (val >> 2) & 0xff;
>>>> +               write_csr_gintc(gintc);
>>>> +               kvm_set_sw_gcsr(csr, LOONGARCH_CSR_GINTC, gintc);
>>>> +
>>>> +               gintc = val & ~(0xffUL << 2);
>>>> +               write_gcsr_estat(gintc);
>>>> +               kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
>>>> +
>>>> +               return ret;
>>>> +       }
>>>> +
>>>> +       if (get_gcsr_flag(id) & HW_GCSR) {
>>>> +               set_hw_gcsr(id, val);
>>>> +               /* write sw gcsr to keep consistent with hardware */
>>>> +               kvm_write_sw_gcsr(csr, id, val);
>>>> +       } else
>>>> +               kvm_write_sw_gcsr(csr, id, val);
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int _kvm_get_one_reg(struct kvm_vcpu *vcpu,
>>>> +               const struct kvm_one_reg *reg, s64 *v)
>>>> +{
>>>> +       int reg_idx, ret = 0;
>>>> +
>>>> +       if ((reg->id & KVM_REG_LOONGARCH_MASK) == KVM_REG_LOONGARCH_CSR) {
>>>> +               reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
>>>> +               ret = _kvm_getcsr(vcpu, reg_idx, v);
>>>> +       } else if (reg->id == KVM_REG_LOONGARCH_COUNTER)
>>>> +               *v = drdtime() + vcpu->kvm->arch.time_offset;
>>>> +       else
>>>> +               ret = -EINVAL;
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int _kvm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>> +{
>>>> +       int ret = -EINVAL;
>>>> +       s64 v;
>>>> +
>>>> +       if ((reg->id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
>>>> +               return ret;
>>>> +
>>>> +       if (_kvm_get_one_reg(vcpu, reg, &v))
>>>> +               return ret;
>>>> +
>>>> +       return put_user(v, (u64 __user *)(long)reg->addr);
>>>> +}
>>>> +
>>>> +static int _kvm_set_one_reg(struct kvm_vcpu *vcpu,
>>>> +                       const struct kvm_one_reg *reg,
>>>> +                       s64 v)
>>>> +{
>>>> +       int ret = 0;
>>>> +       unsigned long flags;
>>>> +       u64 val;
>>>> +       int reg_idx;
>>>> +
>>>> +       val = v;
>>>> +       if ((reg->id & KVM_REG_LOONGARCH_MASK) == KVM_REG_LOONGARCH_CSR) {
>>>> +               reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
>>>> +               ret = _kvm_setcsr(vcpu, reg_idx, val);
>>>> +       } else if (reg->id == KVM_REG_LOONGARCH_COUNTER) {
>>>> +               local_irq_save(flags);
>>>> +               /*
>>>> +                * gftoffset is relative with board, not vcpu
>>>> +                * only set for the first time for smp system
>>>> +                */
>>>> +               if (vcpu->vcpu_id == 0)
>>>> +                       vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
>>>> +               write_csr_gcntc((ulong)vcpu->kvm->arch.time_offset);
>>>> +               local_irq_restore(flags);
>>>> +       } else if (reg->id == KVM_REG_LOONGARCH_VCPU_RESET) {
>>>> +               kvm_reset_timer(vcpu);
>>>> +               memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
>>>> +               memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
>>>> +       } else
>>>> +               ret = -EINVAL;
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int _kvm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>>> +{
>>>> +       s64 v;
>>>> +       int ret = -EINVAL;
>>>> +
>>>> +       if ((reg->id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
>>>> +               return ret;
>>>> +
>>>> +       if (get_user(v, (u64 __user *)(long)reg->addr))
>>>> +               return ret;
>>>> +
>>>> +       return _kvm_set_one_reg(vcpu, reg, v);
>>>> +}
>>>> +
>>>> +int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
>>>> +                                 struct kvm_sregs *sregs)
>>>> +{
>>>> +       return -ENOIOCTLCMD;
>>>> +}
>>>> +
>>>> +int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
>>>> +                                 struct kvm_sregs *sregs)
>>>> +{
>>>> +       return -ENOIOCTLCMD;
>>>> +}
>>>> +
>>>> +int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>>>> +{
>>>> +       int i;
>>>> +
>>>> +       vcpu_load(vcpu);
>>>> +
>>>> +       for (i = 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
>>>> +               regs->gpr[i] = vcpu->arch.gprs[i];
>>>> +
>>>> +       regs->pc = vcpu->arch.pc;
>>>> +
>>>> +       vcpu_put(vcpu);
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>>>> +{
>>>> +       int i;
>>>> +
>>>> +       vcpu_load(vcpu);
>>>> +
>>>> +       for (i = 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
>>>> +               vcpu->arch.gprs[i] = regs->gpr[i];
>>>> +       vcpu->arch.gprs[0] = 0; /* zero is special, and cannot be set. */
>>>> +       vcpu->arch.pc = regs->pc;
>>>> +
>>>> +       vcpu_put(vcpu);
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +long kvm_arch_vcpu_ioctl(struct file *filp,
>>>> +                        unsigned int ioctl, unsigned long arg)
>>>> +{
>>>> +       struct kvm_vcpu *vcpu = filp->private_data;
>>>> +       void __user *argp = (void __user *)arg;
>>>> +       long r;
>>>> +
>>>> +       vcpu_load(vcpu);
>>>> +
>>>> +       switch (ioctl) {
>>>> +       case KVM_SET_ONE_REG:
>>>> +       case KVM_GET_ONE_REG: {
>>>> +               struct kvm_one_reg reg;
>>>> +
>>>> +               r = -EFAULT;
>>>> +               if (copy_from_user(&reg, argp, sizeof(reg)))
>>>> +                       break;
>>>> +               if (ioctl == KVM_SET_ONE_REG)
>>>> +                       r = _kvm_set_reg(vcpu, &reg);
>>>> +               else
>>>> +                       r = _kvm_get_reg(vcpu, &reg);
>>>> +               break;
>>>> +       }
>>>> +       default:
>>>> +               r = -ENOIOCTLCMD;
>>>> +               break;
>>>> +       }
>>>> +
>>>> +       vcpu_put(vcpu);
>>>> +       return r;
>>>> +}
>>>> +
>>>>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>>>>   {
>>>>          return 0;
>>>> --
>>>> 2.27.0
>>>>
>>

