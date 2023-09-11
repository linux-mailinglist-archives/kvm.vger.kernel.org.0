Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E4D79BEDB
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjIKUrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235613AbjIKJEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:04:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AD6CCC;
        Mon, 11 Sep 2023 02:04:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74176C433A9;
        Mon, 11 Sep 2023 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694423049;
        bh=jIlDzAd6Y2zBAGfpR03z1y19Cd9znjvuc3WHMy7zY14=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eMGkZVirD9iGvSzLNzAXs8MCuYuSmx0zLTBWTX+BpxgGThWCiU9jGZaj5Cq9KH7ay
         J3Aq9z3Fsqx1ZiNftAysBYWPXnX1abnde99poAbtsKiWCoq/qnxTDwEEWwclnrcKUn
         3IeQeHZ3uMWSUfQszJEOA86GgL/2WkICTqXbik+HXKtUrB32G19Yj5g4+mLy95S2fA
         M8nLAW+x0Ga2r12/cWrmMnTtSALVuSS4RPydNDc5GqfOH84r+51quNKODqllzfRDic
         ryMH/iZ/UsPTPcOcUr9vUQEUev3r8wrJFA3zqDCdiLM+W+/0Jo3rUpn3+HM32PylJj
         sRB8d48fCznjA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-99de884ad25so547697366b.3;
        Mon, 11 Sep 2023 02:04:09 -0700 (PDT)
X-Gm-Message-State: AOJu0Yztu/UgRwpiIkh4PEZpju6a+itoTTWTQtC66OIHNBQnvcF0dEDe
        TkZE2guQUvB6iwqSrOc5BSYR85KL3yY7ORVutdg=
X-Google-Smtp-Source: AGHT+IG6dIYXo1HaOT8AKRYe8T8M6JXkVELonmamgzNT9xOIY7/Ij+WADwdmCJ8XXlgiqH+XyoXu6KdqoM/9Q6M7JJ0=
X-Received: by 2002:a17:906:73c8:b0:9a5:cab0:b061 with SMTP id
 n8-20020a17090673c800b009a5cab0b061mr8174722ejl.51.1694423047815; Mon, 11 Sep
 2023 02:04:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230831083020.2187109-1-zhaotianrui@loongson.cn> <20230831083020.2187109-10-zhaotianrui@loongson.cn>
In-Reply-To: <20230831083020.2187109-10-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 11 Sep 2023 17:03:54 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6=e-Tg1tCdFhN5i2CSQpL-NDLovJdc9A=Sxt=3h-3Z0g@mail.gmail.com>
Message-ID: <CAAhV-H6=e-Tg1tCdFhN5i2CSQpL-NDLovJdc9A=Sxt=3h-3Z0g@mail.gmail.com>
Subject: Re: [PATCH v20 09/30] LoongArch: KVM: Implement vcpu get, vcpu set registers
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Tianrui,

On Thu, Aug 31, 2023 at 4:30=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
> Implement LoongArch vcpu get registers and set registers operations, it
> is called when user space use the ioctl interface to get or set regs.
>
> Reviewed-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/csr_ops.S |  67 ++++++++++++
>  arch/loongarch/kvm/vcpu.c    | 206 +++++++++++++++++++++++++++++++++++
>  2 files changed, 273 insertions(+)
>  create mode 100644 arch/loongarch/kvm/csr_ops.S
>
> diff --git a/arch/loongarch/kvm/csr_ops.S b/arch/loongarch/kvm/csr_ops.S
> new file mode 100644
> index 0000000000..53e44b23a5
> --- /dev/null
> +++ b/arch/loongarch/kvm/csr_ops.S
> @@ -0,0 +1,67 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <asm/regdef.h>
> +#include <linux/linkage.h>
> +       .text
> +       .cfi_sections   .debug_frame
> +/*
> + * we have splited hw gcsr into three parts, so we can
> + * calculate the code offset by gcsrid and jump here to
> + * run the gcsrwr instruction.
> + */
> +SYM_FUNC_START(set_hw_gcsr)
> +       addi.d      t0,   a0,   0
> +       addi.w      t1,   zero, 96
> +       bltu        t1,   t0,   1f
> +       la.pcrel    t0,   10f
> +       alsl.d      t0,   a0,   t0, 3
> +       jr          t0
> +1:
> +       addi.w      t1,   a0,   -128
> +       addi.w      t2,   zero, 15
> +       bltu        t2,   t1,   2f
> +       la.pcrel    t0,   11f
> +       alsl.d      t0,   t1,   t0, 3
> +       jr          t0
> +2:
> +       addi.w      t1,   a0,   -384
> +       addi.w      t2,   zero, 3
> +       bltu        t2,   t1,   3f
> +       la.pcrel    t0,   12f
> +       alsl.d      t0,   t1,   t0, 3
> +       jr          t0
> +3:
> +       addi.w      a0,   zero, -1
> +       jr          ra
> +
> +/* range from 0x0(KVM_CSR_CRMD) to 0x60(KVM_CSR_LLBCTL) */
> +10:
> +       csrnum =3D 0
> +       .rept 0x61
> +       gcsrwr a1, csrnum
> +       jr ra
> +       csrnum =3D csrnum + 1
> +       .endr
> +
> +/* range from 0x80(KVM_CSR_IMPCTL1) to 0x8f(KVM_CSR_TLBRPRMD) */
> +11:
> +       csrnum =3D 0x80
> +       .rept 0x10
> +       gcsrwr a1, csrnum
> +       jr ra
> +       csrnum =3D csrnum + 1
> +       .endr
> +
> +/* range from 0x180(KVM_CSR_DMWIN0) to 0x183(KVM_CSR_DMWIN3) */
> +12:
> +       csrnum =3D 0x180
> +       .rept 0x4
> +       gcsrwr a1, csrnum
> +       jr ra
> +       csrnum =3D csrnum + 1
> +       .endr
> +
> +SYM_FUNC_END(set_hw_gcsr)
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index ca4e8d074e..f17422a942 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -13,6 +13,212 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>
> +int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v)
> +{
> +       unsigned long val;
> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> +
> +       if (get_gcsr_flag(id) & INVALID_GCSR)
> +               return -EINVAL;
> +
> +       if (id =3D=3D LOONGARCH_CSR_ESTAT) {
> +               /* interrupt status IP0 -- IP7 from GINTC */
> +               val =3D kvm_read_sw_gcsr(csr, LOONGARCH_CSR_GINTC) & 0xff=
;
> +               *v =3D kvm_read_sw_gcsr(csr, id) | (val << 2);
> +               return 0;
> +       }
> +
> +       /*
> +        * get software csr state if csrid is valid, since software
> +        * csr state is consistent with hardware
> +        */
After a long time thinking, I found this is wrong. Of course
_kvm_setcsr() saves a software copy of the hardware registers, but the
hardware status will change. For example, during a VM running, it may
change the EUEN register if it uses fpu.

So, we should do things like what we do in our internal repo,
_kvm_getcsr() should get values from hardware for HW_GCSR registers.
And we also need a get_hw_gcsr assembly function.


Huacai

> +       *v =3D kvm_read_sw_gcsr(csr, id);
> +
> +       return 0;
> +}
> +
> +int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
> +{
> +       struct loongarch_csrs *csr =3D vcpu->arch.csr;
> +       int ret =3D 0, gintc;
> +
> +       if (get_gcsr_flag(id) & INVALID_GCSR)
> +               return -EINVAL;
> +
> +       if (id =3D=3D LOONGARCH_CSR_ESTAT) {
> +               /* estat IP0~IP7 inject through guestexcept */
> +               gintc =3D (val >> 2) & 0xff;
> +               write_csr_gintc(gintc);
> +               kvm_set_sw_gcsr(csr, LOONGARCH_CSR_GINTC, gintc);
> +
> +               gintc =3D val & ~(0xffUL << 2);
> +               write_gcsr_estat(gintc);
> +               kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
> +
> +               return ret;
> +       }
> +
> +       if (get_gcsr_flag(id) & HW_GCSR) {
> +               set_hw_gcsr(id, val);
> +               /* write sw gcsr to keep consistent with hardware */
> +               kvm_write_sw_gcsr(csr, id, val);
> +       } else
> +               kvm_write_sw_gcsr(csr, id, val);
> +
> +       return ret;
> +}
> +
> +static int _kvm_get_one_reg(struct kvm_vcpu *vcpu,
> +               const struct kvm_one_reg *reg, s64 *v)
> +{
> +       int reg_idx, ret =3D 0;
> +
> +       if ((reg->id & KVM_REG_LOONGARCH_MASK) =3D=3D KVM_REG_LOONGARCH_C=
SR) {
> +               reg_idx =3D KVM_GET_IOC_CSRIDX(reg->id);
> +               ret =3D _kvm_getcsr(vcpu, reg_idx, v);
> +       } else if (reg->id =3D=3D KVM_REG_LOONGARCH_COUNTER)
> +               *v =3D drdtime() + vcpu->kvm->arch.time_offset;
> +       else
> +               ret =3D -EINVAL;
> +
> +       return ret;
> +}
> +
> +static int _kvm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg =
*reg)
> +{
> +       int ret =3D -EINVAL;
> +       s64 v;
> +
> +       if ((reg->id & KVM_REG_SIZE_MASK) !=3D KVM_REG_SIZE_U64)
> +               return ret;
> +
> +       if (_kvm_get_one_reg(vcpu, reg, &v))
> +               return ret;
> +
> +       return put_user(v, (u64 __user *)(long)reg->addr);
> +}
> +
> +static int _kvm_set_one_reg(struct kvm_vcpu *vcpu,
> +                       const struct kvm_one_reg *reg,
> +                       s64 v)
> +{
> +       int ret =3D 0;
> +       unsigned long flags;
> +       u64 val;
> +       int reg_idx;
> +
> +       val =3D v;
> +       if ((reg->id & KVM_REG_LOONGARCH_MASK) =3D=3D KVM_REG_LOONGARCH_C=
SR) {
> +               reg_idx =3D KVM_GET_IOC_CSRIDX(reg->id);
> +               ret =3D _kvm_setcsr(vcpu, reg_idx, val);
> +       } else if (reg->id =3D=3D KVM_REG_LOONGARCH_COUNTER) {
> +               local_irq_save(flags);
> +               /*
> +                * gftoffset is relative with board, not vcpu
> +                * only set for the first time for smp system
> +                */
> +               if (vcpu->vcpu_id =3D=3D 0)
> +                       vcpu->kvm->arch.time_offset =3D (signed long)(v -=
 drdtime());
> +               write_csr_gcntc((ulong)vcpu->kvm->arch.time_offset);
> +               local_irq_restore(flags);
> +       } else if (reg->id =3D=3D KVM_REG_LOONGARCH_VCPU_RESET) {
> +               kvm_reset_timer(vcpu);
> +               memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_=
pending));
> +               memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_cl=
ear));
> +       } else
> +               ret =3D -EINVAL;
> +
> +       return ret;
> +}
> +
> +static int _kvm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg =
*reg)
> +{
> +       s64 v;
> +       int ret =3D -EINVAL;
> +
> +       if ((reg->id & KVM_REG_SIZE_MASK) !=3D KVM_REG_SIZE_U64)
> +               return ret;
> +
> +       if (get_user(v, (u64 __user *)(long)reg->addr))
> +               return ret;
> +
> +       return _kvm_set_one_reg(vcpu, reg, v);
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
> +                                 struct kvm_sregs *sregs)
> +{
> +       return -ENOIOCTLCMD;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> +                                 struct kvm_sregs *sregs)
> +{
> +       return -ENOIOCTLCMD;
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs =
*regs)
> +{
> +       int i;
> +
> +       vcpu_load(vcpu);
> +
> +       for (i =3D 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
> +               regs->gpr[i] =3D vcpu->arch.gprs[i];
> +
> +       regs->pc =3D vcpu->arch.pc;
> +
> +       vcpu_put(vcpu);
> +       return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs =
*regs)
> +{
> +       int i;
> +
> +       vcpu_load(vcpu);
> +
> +       for (i =3D 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
> +               vcpu->arch.gprs[i] =3D regs->gpr[i];
> +       vcpu->arch.gprs[0] =3D 0; /* zero is special, and cannot be set. =
*/
> +       vcpu->arch.pc =3D regs->pc;
> +
> +       vcpu_put(vcpu);
> +       return 0;
> +}
> +
> +long kvm_arch_vcpu_ioctl(struct file *filp,
> +                        unsigned int ioctl, unsigned long arg)
> +{
> +       struct kvm_vcpu *vcpu =3D filp->private_data;
> +       void __user *argp =3D (void __user *)arg;
> +       long r;
> +
> +       vcpu_load(vcpu);
> +
> +       switch (ioctl) {
> +       case KVM_SET_ONE_REG:
> +       case KVM_GET_ONE_REG: {
> +               struct kvm_one_reg reg;
> +
> +               r =3D -EFAULT;
> +               if (copy_from_user(&reg, argp, sizeof(reg)))
> +                       break;
> +               if (ioctl =3D=3D KVM_SET_ONE_REG)
> +                       r =3D _kvm_set_reg(vcpu, &reg);
> +               else
> +                       r =3D _kvm_get_reg(vcpu, &reg);
> +               break;
> +       }
> +       default:
> +               r =3D -ENOIOCTLCMD;
> +               break;
> +       }
> +
> +       vcpu_put(vcpu);
> +       return r;
> +}
> +
>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>  {
>         return 0;
> --
> 2.27.0
>
