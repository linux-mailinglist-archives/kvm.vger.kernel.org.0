Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BF16CC8FB
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjC1RRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjC1RRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:17:11 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212259750
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:17:10 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id s8so9524790ois.2
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680023829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Evknxft0Ac0XGVBnsLo9FvaXJTOaQEI6guzSeaj2WBA=;
        b=s1aX/DxTJvPElnOn9pz6EToPibV0RWdA7GsBBAxwesEG2y7sHJL4/1Wtw8LCOUxL2R
         D0ZTZW4dW0okqngtsZsVtfhkqS4x7bscuOgnhIoEdDdxJ9BXk5JMt6sBwW1O+/abmlj7
         0i7swLG9Mqee1rBj7Lm0tlkyq/FfWaNxqn0sYT8armIzSZt2oXSzoj0SKp8rpN69IVg5
         REs9YcOlTYTuq6jfWYPyJGgVb1L5j1XEwYpJcMfg9MCLfr27fukneCc8ZoeUlZY2Chc9
         KYJgeKG4oyQWHSAJ+ppYcuICuCRmZlTsSeOJRwee3u0RFRt56k5CSEGk+ptADQvgdaNU
         ChLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680023829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Evknxft0Ac0XGVBnsLo9FvaXJTOaQEI6guzSeaj2WBA=;
        b=UudhVSY5dtZab5usuI1qt9PMwVa97dUSfTH4Ankdy9IRYX/hutm1uyt+mbW4CAkvxN
         3A0gGezs6oYBCT8Aj8yZ3S3sRxTvrU7JxZy0VWz25+X+n6v091cuFEEeJaDU//Y+rDyn
         MEfah8HRNNNLVwYeTuyCOToCMr5J4rMd+idGWFymV/X5dcem1jT5sCTv+pAeZACzRncf
         B0mLRad/wEjInwmtrTg+v/WTacLpX/6WKaOrGIItLOSI1IfMi0yISgDBJ/pyvZdc5n4v
         FR5jH535/IV1hZEL2fzOsoDEKUG3LZerZGIt2vo/516UP2iqI6TYYBMLeBOfn9pwWCMb
         m7TA==
X-Gm-Message-State: AO0yUKV3E17AwqmZKvt6DuUwMRHbCul30jYe51Jx77ThOaKwpeAFIJ7+
        O6AJ9EqEWH4ou13kT8Weovx0t8xdNQGYOJ4G+XTEGEMf0L2iXZVGUiY=
X-Google-Smtp-Source: AK7set/5LtuzR9X3f7/tCH+Z2PqUWuzCeLTFc2SOYR0NzB1M+A1DDESzJA7birpgAvEbzEsq2rj5DT3283FnI/p1htQ=
X-Received: by 2002:a54:4019:0:b0:386:a2d0:2814 with SMTP id
 x25-20020a544019000000b00386a2d02814mr9035915oie.4.1680023829187; Tue, 28 Mar
 2023 10:17:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-2-jingzhangos@google.com> <86355qy00k.wl-maz@kernel.org>
In-Reply-To: <86355qy00k.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 28 Mar 2023 10:16:57 -0700
Message-ID: <CAAdAUtgFs_SmTqcCHMzCx-9og9L58+vvrMfKaE8m-CoLiupL1Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] KVM: arm64: Move CPU ID feature registers
 emulation into a separate file
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Mar 27, 2023 at 3:14=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 17 Mar 2023 05:06:32 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Create a new file id_regs.c for CPU ID feature registers emulation code=
,
> > which are moved from sys_regs.c and tweak sys_regs code accordingly.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/Makefile   |   2 +-
> >  arch/arm64/kvm/id_regs.c  | 506 ++++++++++++++++++++++++++++++++++++++
> >  arch/arm64/kvm/sys_regs.c | 464 ++--------------------------------
> >  arch/arm64/kvm/sys_regs.h |  41 +++
> >  4 files changed, 575 insertions(+), 438 deletions(-)
> >  create mode 100644 arch/arm64/kvm/id_regs.c
> >
> > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > index c0c050e53157..a6a315fcd81e 100644
> > --- a/arch/arm64/kvm/Makefile
> > +++ b/arch/arm64/kvm/Makefile
> > @@ -13,7 +13,7 @@ obj-$(CONFIG_KVM) +=3D hyp/
> >  kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
> >        inject_fault.o va_layout.o handle_exit.o \
> >        guest.o debug.o reset.o sys_regs.o stacktrace.o \
> > -      vgic-sys-reg-v3.o fpsimd.o pkvm.o \
> > +      vgic-sys-reg-v3.o fpsimd.o pkvm.o id_regs.o \
> >        arch_timer.o trng.o vmid.o emulate-nested.o nested.o \
> >        vgic/vgic.o vgic/vgic-init.o \
> >        vgic/vgic-irqfd.o vgic/vgic-v2.o \
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > new file mode 100644
> > index 000000000000..08b738852955
> > --- /dev/null
> > +++ b/arch/arm64/kvm/id_regs.c
>
> [...]
>
> > +/**
> > + * emulate_id_reg - Emulate a guest access to an AArch64 CPU ID featur=
e register
> > + * @vcpu: The VCPU pointer
> > + * @params: Decoded system register parameters
> > + *
> > + * Return: true if the ID register access was successful, false otherw=
ise.
> > + */
> > +int emulate_id_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *param=
s)
> > +{
> > +     const struct sys_reg_desc *r;
> > +
> > +     r =3D find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_descs));
> > +
> > +     if (likely(r)) {
> > +             perform_access(vcpu, params, r);
> > +     } else {
> > +             print_sys_reg_msg(params,
> > +                               "Unsupported guest id_reg access at: %l=
x [%08lx]\n",
> > +                               *vcpu_pc(vcpu), *vcpu_cpsr(vcpu));
> > +             kvm_inject_undefined(vcpu);
> > +     }
> > +
> > +     return 1;
> > +}
> > +
> > +
> > +void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     unsigned long i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++)
> > +             if (id_reg_descs[i].reset)
> > +                     id_reg_descs[i].reset(vcpu, &id_reg_descs[i]);
> > +}
>
> What does this mean? None of the idregs have a reset function, given
> that they are global. Maybe this will make sense in the following
> patches, but definitely not here.
>
You are right. It actually does nothing for idregs which have no reset func=
tion.
Will remove this.
> > +
> > +int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg=
 *reg)
> > +{
> > +     return kvm_sys_reg_get_user(vcpu, reg,
> > +                                 id_reg_descs, ARRAY_SIZE(id_reg_descs=
));
> > +}
> > +
> > +int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg=
 *reg)
> > +{
> > +     return kvm_sys_reg_set_user(vcpu, reg,
> > +                                 id_reg_descs, ARRAY_SIZE(id_reg_descs=
));
> > +}
> > +
> > +bool kvm_arm_check_idreg_table(void)
> > +{
> > +     return check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_descs),=
 false);
> > +}
>
> All these helpers are called from sys_regs.c and directly call back
> into it. Why not simply have a helper that gets the base and size of
> the array, and stick to pure common code?
>
As you know from the later patches in this series, a per VM idregs
array and an idregs specific structure are used. All these functions
would be implemented based on that.
> > +
> > +int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
> > +{
> > +     const struct sys_reg_desc *i2, *end2;
> > +     unsigned int total =3D 0;
> > +     int err;
> > +
> > +     i2 =3D id_reg_descs;
> > +     end2 =3D id_reg_descs + ARRAY_SIZE(id_reg_descs);
> > +
> > +     while (i2 !=3D end2) {
> > +             err =3D walk_one_sys_reg(vcpu, i2++, &uind, &total);
> > +             if (err)
> > +                     return err;
> > +     }
> > +     return total;
> > +}
>
> This is an exact copy of walk_sys_regs. Surely this can be made common
> code.
The reason for not using common code is the same as last comment. An
idregs specific data structure would be used.
>
> [...]
>
> > @@ -2912,6 +2482,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
> >  {
> >       unsigned long i;
> >
> > +     kvm_arm_reset_id_regs(vcpu);
> > +
> >       for (i =3D 0; i < ARRAY_SIZE(sys_reg_descs); i++)
> >               if (sys_reg_descs[i].reset)
> >                       sys_reg_descs[i].reset(vcpu, &sys_reg_descs[i]);
> > @@ -2932,6 +2504,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
> >       params =3D esr_sys64_to_params(esr);
> >       params.regval =3D vcpu_get_reg(vcpu, Rt);
> >
> > +     if (is_id_reg(reg_to_encoding(&params)))
> > +             return emulate_id_reg(vcpu, &params);
> > +
> >       if (!emulate_sys_reg(vcpu, &params))
> >               return 1;
> >
> > @@ -3160,6 +2735,10 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcp=
u, const struct kvm_one_reg *reg
> >       if (err !=3D -ENOENT)
> >               return err;
> >
> > +     err =3D kvm_arm_get_id_reg(vcpu, reg);
>
> Why not check for the encoding here? or in the helpers? It feels that
> this is an overhead that would be easy to reduce, given that we have
> fewer idregs than normal sysregs.
Sure, will move the encoding check here.
>
> > +     if (err !=3D -ENOENT)
> > +             return err;
> > +
> >       return kvm_sys_reg_get_user(vcpu, reg,
> >                                   sys_reg_descs, ARRAY_SIZE(sys_reg_des=
cs));
> >  }
> > @@ -3204,6 +2783,10 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcp=
u, const struct kvm_one_reg *reg
> >       if (err !=3D -ENOENT)
> >               return err;
> >
> > +     err =3D kvm_arm_set_id_reg(vcpu, reg);
>
> Same here.
Agreed.
>
> > +     if (err !=3D -ENOENT)
> > +             return err;
> > +
> >       return kvm_sys_reg_set_user(vcpu, reg,
> >                                   sys_reg_descs, ARRAY_SIZE(sys_reg_des=
cs));
> >  }
> > @@ -3250,10 +2833,10 @@ static bool copy_reg_to_user(const struct sys_r=
eg_desc *reg, u64 __user **uind)
> >       return true;
> >  }
> >
> > -static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
> > -                         const struct sys_reg_desc *rd,
> > -                         u64 __user **uind,
> > -                         unsigned int *total)
> > +int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
> > +                  const struct sys_reg_desc *rd,
> > +                  u64 __user **uind,
> > +                  unsigned int *total)
> >  {
> >       /*
> >        * Ignore registers we trap but don't save,
> > @@ -3294,6 +2877,7 @@ unsigned long kvm_arm_num_sys_reg_descs(struct kv=
m_vcpu *vcpu)
> >  {
> >       return ARRAY_SIZE(invariant_sys_regs)
> >               + num_demux_regs()
> > +             + kvm_arm_walk_id_regs(vcpu, (u64 __user *)NULL)
> >               + walk_sys_regs(vcpu, (u64 __user *)NULL);
> >  }
> >
> > @@ -3309,6 +2893,11 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu=
 *vcpu, u64 __user *uindices)
> >               uindices++;
> >       }
> >
> > +     err =3D kvm_arm_walk_id_regs(vcpu, uindices);
> > +     if (err < 0)
> > +             return err;
> > +     uindices +=3D err;
> > +
> >       err =3D walk_sys_regs(vcpu, uindices);
> >       if (err < 0)
> >               return err;
> > @@ -3323,6 +2912,7 @@ int __init kvm_sys_reg_table_init(void)
> >       unsigned int i;
> >
> >       /* Make sure tables are unique and in order. */
> > +     valid &=3D kvm_arm_check_idreg_table();
> >       valid &=3D check_sysreg_table(sys_reg_descs, ARRAY_SIZE(sys_reg_d=
escs), false);
> >       valid &=3D check_sysreg_table(cp14_regs, ARRAY_SIZE(cp14_regs), t=
rue);
> >       valid &=3D check_sysreg_table(cp14_64_regs, ARRAY_SIZE(cp14_64_re=
gs), true);
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index 6b11f2cc7146..ad41305348f7 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -210,6 +210,35 @@ find_reg(const struct sys_reg_params *params, cons=
t struct sys_reg_desc table[],
> >       return __inline_bsearch((void *)pval, table, num, sizeof(table[0]=
), match_sys_reg);
> >  }
> >
> > +static inline unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
> > +                                       const struct sys_reg_desc *r)
> > +{
> > +     return REG_RAZ;
> > +}
>
> No, please. This is used as a function pointer. You now potentially
> force the compiler to emit as many copy of this as there are pointers.
>
Thanks, will fix this.
> > +
> > +static inline bool write_to_read_only(struct kvm_vcpu *vcpu,
> > +                                   struct sys_reg_params *params,
> > +                                   const struct sys_reg_desc *r)
> > +{
> > +     WARN_ONCE(1, "Unexpected sys_reg write to read-only register\n");
> > +     print_sys_reg_instr(params);
> > +     kvm_inject_undefined(vcpu);
> > +     return false;
> > +}
>
> Please make this common code, and not an inline function.
Sure, will do.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
