Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845016A4DF5
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 23:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjB0WYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 17:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjB0WYB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 17:24:01 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F771CF6D
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 14:23:59 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id s17so4520502pgv.4
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 14:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXUMNyFz/pl9GBFXcJRM9eeMqaX7eTV4JVRyPtSpgq4=;
        b=JmLXT/PYxCpSLLNdblMZoJTSJH/XvbDkLYhXcLWi70d22qm1LjUHDpm/pfTpebyucE
         knDm2tBhPL+G5ay/Cg/LV2EyIO9BDc+1mwmqBcTOPQ4bGvejytzeK5i7xsa4IueQEfKp
         G61U2/vpmTMCFZDe0rs44P6IHoknXqE2p7ryCPiqCbuXC8J2VymZXb9Q28BrNKmfNfbK
         sUdZ/vcNFyR7q/9PtHkRaj+5OzhxeL+iIUKddMslbp5oLKoiYcJap/6VC29uWO/I40BS
         F9YwE3bm30TqTWlH+XRs/eCXrGHTw1aTY8dojPXl/SD/1Q3XBHrvI/1tufSaduEgOAOn
         GD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SXUMNyFz/pl9GBFXcJRM9eeMqaX7eTV4JVRyPtSpgq4=;
        b=3+lbNT2F7SCsB7nMj+jUSSLq2XLROZkf3Ac8IIHIa6p0Omu5o+pLF2pZ2551D/h57o
         xyc8b6aqpGfXuXRrXZ62HvAvRt8hzJLpHgJLU8hc8ca2GBSgTNOou8CCEsB7/Tqf/45+
         FBbM/8QnHG+DnXZV142HQFn67689q4mLm/CP50G8O1SBWpI0lO3ckvbkB4XKKyArwb97
         zXmuF3caA5hUR0VCUFekhnibVSHGmDBG4uR1gpn+y+KiPUr91kpSJWx/73KWaW8ifaMM
         OXeN42f+4RDA3of01O5CXSeZlIjHcIaP2WlILlFgJ6ckLF7+0606IcWgAiMKB+fhCgXT
         vCZA==
X-Gm-Message-State: AO0yUKXTE3FQuoaD5EEDThNp58bL+nqPrTILXskaqC+l+JJsSmS6ppp9
        QVCEOeA6PYTerqSAdWF5MD9A9NC6A2WDJOpL7DoIgbtmWDgnavQlAAs=
X-Google-Smtp-Source: AK7set+plm8z+vdGBibyWnXTMQc8z8ZFM5JKvM7iXMmxryjyBQPoWaTgxhxaTa/bzdYNJ1WSBqSuSnRt4isDxy0adUY=
X-Received: by 2002:a63:6fce:0:b0:503:77c6:2ca3 with SMTP id
 k197-20020a636fce000000b0050377c62ca3mr25522pgc.5.1677536638555; Mon, 27 Feb
 2023 14:23:58 -0800 (PST)
MIME-Version: 1.0
References: <20230212215830.2975485-1-jingzhangos@google.com>
 <20230212215830.2975485-6-jingzhangos@google.com> <CAAeT=Fz-G_EUmh=Pj3UHA7pnKKYi7UyYuedziJxfmSoKpntw3Q@mail.gmail.com>
 <CAAdAUtgZ7WF--jz13bydY8PLeF6OqW+cNgeLZOUNB=wquMh6iw@mail.gmail.com>
In-Reply-To: <CAAdAUtgZ7WF--jz13bydY8PLeF6OqW+cNgeLZOUNB=wquMh6iw@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 27 Feb 2023 14:23:41 -0800
Message-ID: <CAAeT=FyF9gx=M_+towV2SnwuNroM9FktVCRUuaBphLpM20netQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] KVM: arm64: Introduce ID register specific descriptor
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Sun, Feb 26, 2023 at 7:05=E2=80=AFPM Jing Zhang <jingzhangos@google.com>=
 wrote:
>
> Hi Reiji,
>
> On Fri, Feb 24, 2023 at 8:00 PM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Jing,
> >
> > On Sun, Feb 12, 2023 at 1:58 PM Jing Zhang <jingzhangos@google.com> wro=
te:
> > >
> > > Introduce an ID feature register specific descriptor to include ID
> > > register specific fields and callbacks besides its corresponding
> > > general system register descriptor.
> > > New fields for ID register descriptor would be added later when it
> > > is necessary to support a writable ID register.
> > >
> > > No functional change intended.
> > >
> > > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  arch/arm64/kvm/id_regs.c  | 187 +++++++++++++++++++++++++++++-------=
--
> > >  arch/arm64/kvm/sys_regs.c |   2 +-
> > >  arch/arm64/kvm/sys_regs.h |   1 +
> > >  3 files changed, 144 insertions(+), 46 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > > index 14ae03a1d8d0..15d0338742b6 100644
> > > --- a/arch/arm64/kvm/id_regs.c
> > > +++ b/arch/arm64/kvm/id_regs.c
> > > @@ -18,6 +18,10 @@
> > >
> > >  #include "sys_regs.h"
> > >
> > > +struct id_reg_desc {
> > > +       const struct sys_reg_desc       reg_desc;
> > > +};
> > > +
> > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > >  {
> > >         if (kvm_vcpu_has_pmu(vcpu))
> > > @@ -329,21 +333,25 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcp=
u,
> > >  }
> > >
> > >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> > > -#define ID_SANITISED(name) {                   \
> > > -       SYS_DESC(SYS_##name),                   \
> > > -       .access =3D access_id_reg,                \
> > > -       .get_user =3D get_id_reg,                 \
> > > -       .set_user =3D set_id_reg,                 \
> > > -       .visibility =3D id_visibility,            \
> > > +#define ID_SANITISED(name) {                           \
> > > +       .reg_desc =3D {                                   \
> > > +               SYS_DESC(SYS_##name),                   \
> > > +               .access =3D access_id_reg,                \
> > > +               .get_user =3D get_id_reg,                 \
> > > +               .set_user =3D set_id_reg,                 \
> > > +               .visibility =3D id_visibility,            \
> > > +       },                                              \
> > >  }
> > >
> > >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> > > -#define AA32_ID_SANITISED(name) {              \
> > > -       SYS_DESC(SYS_##name),                   \
> > > -       .access =3D access_id_reg,                \
> > > -       .get_user =3D get_id_reg,                 \
> > > -       .set_user =3D set_id_reg,                 \
> > > -       .visibility =3D aa32_id_visibility,       \
> > > +#define AA32_ID_SANITISED(name) {                      \
> > > +       .reg_desc =3D {                                   \
> > > +               SYS_DESC(SYS_##name),                   \
> > > +               .access =3D access_id_reg,                \
> > > +               .get_user =3D get_id_reg,                 \
> > > +               .set_user =3D set_id_reg,                 \
> > > +               .visibility =3D aa32_id_visibility,       \
> > > +       },                                              \
> > >  }
> > >
> > >  /*
> > > @@ -351,12 +359,14 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcp=
u,
> > >   * register with encoding Op0=3D3, Op1=3D0, CRn=3D0, CRm=3Dcrm, Op2=
=3Dop2
> > >   * (1 <=3D crm < 8, 0 <=3D Op2 < 8).
> > >   */
> > > -#define ID_UNALLOCATED(crm, op2) {                     \
> > > -       Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> > > -       .access =3D access_id_reg,                        \
> > > -       .get_user =3D get_id_reg,                         \
> > > -       .set_user =3D set_id_reg,                         \
> > > -       .visibility =3D raz_visibility                    \
> > > +#define ID_UNALLOCATED(crm, op2) {                             \
> > > +       .reg_desc =3D {                                           \
> > > +               Op0(3), Op1(0), CRn(0), CRm(crm), Op2(op2),     \
> > > +               .access =3D access_id_reg,                        \
> > > +               .get_user =3D get_id_reg,                         \
> > > +               .set_user =3D set_id_reg,                         \
> > > +               .visibility =3D raz_visibility                    \
> > > +       },                                                      \
> > >  }
> > >
> > >  /*
> > > @@ -364,15 +374,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcp=
u,
> > >   * For now, these are exposed just like unallocated ID regs: they ap=
pear
> > >   * RAZ for the guest.
> > >   */
> > > -#define ID_HIDDEN(name) {                      \
> > > -       SYS_DESC(SYS_##name),                   \
> > > -       .access =3D access_id_reg,                \
> > > -       .get_user =3D get_id_reg,                 \
> > > -       .set_user =3D set_id_reg,                 \
> > > -       .visibility =3D raz_visibility,           \
> > > +#define ID_HIDDEN(name) {                              \
> > > +       .reg_desc =3D {                                   \
> > > +               SYS_DESC(SYS_##name),                   \
> > > +               .access =3D access_id_reg,                \
> > > +               .get_user =3D get_id_reg,                 \
> > > +               .set_user =3D set_id_reg,                 \
> > > +               .visibility =3D raz_visibility,           \
> > > +       },                                              \
> > >  }
> > >
> > > -static const struct sys_reg_desc id_reg_descs[] =3D {
> > > +static const struct id_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] =3D=
 {
> > >         /*
> > >          * ID regs: all ID_SANITISED() entries here must have corresp=
onding
> > >          * entries in arm64_ftr_regs[].
> > > @@ -382,9 +394,13 @@ static const struct sys_reg_desc id_reg_descs[] =
=3D {
> > >         /* CRm=3D1 */
> > >         AA32_ID_SANITISED(ID_PFR0_EL1),
> > >         AA32_ID_SANITISED(ID_PFR1_EL1),
> > > -       { SYS_DESC(SYS_ID_DFR0_EL1), .access =3D access_id_reg,
> > > -         .get_user =3D get_id_reg, .set_user =3D set_id_dfr0_el1,
> > > -         .visibility =3D aa32_id_visibility, },
> > > +       { .reg_desc =3D {
> > > +               SYS_DESC(SYS_ID_DFR0_EL1),
> > > +               .access =3D access_id_reg,
> > > +               .get_user =3D get_id_reg,
> > > +               .set_user =3D set_id_dfr0_el1,
> > > +               .visibility =3D aa32_id_visibility, },
> > > +       },
> > >         ID_HIDDEN(ID_AFR0_EL1),
> > >         AA32_ID_SANITISED(ID_MMFR0_EL1),
> > >         AA32_ID_SANITISED(ID_MMFR1_EL1),
> > > @@ -413,8 +429,12 @@ static const struct sys_reg_desc id_reg_descs[] =
=3D {
> > >
> > >         /* AArch64 ID registers */
> > >         /* CRm=3D4 */
> > > -       { SYS_DESC(SYS_ID_AA64PFR0_EL1), .access =3D access_id_reg,
> > > -         .get_user =3D get_id_reg, .set_user =3D set_id_aa64pfr0_el1=
, },
> > > +       { .reg_desc =3D {
> > > +               SYS_DESC(SYS_ID_AA64PFR0_EL1),
> > > +               .access =3D access_id_reg,
> > > +               .get_user =3D get_id_reg,
> > > +               .set_user =3D set_id_aa64pfr0_el1, },
> > > +       },
> > >         ID_SANITISED(ID_AA64PFR1_EL1),
> > >         ID_UNALLOCATED(4, 2),
> > >         ID_UNALLOCATED(4, 3),
> > > @@ -424,8 +444,12 @@ static const struct sys_reg_desc id_reg_descs[] =
=3D {
> > >         ID_UNALLOCATED(4, 7),
> > >
> > >         /* CRm=3D5 */
> > > -       { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access =3D access_id_reg,
> > > -         .get_user =3D get_id_reg, .set_user =3D set_id_aa64dfr0_el1=
, },
> > > +       { .reg_desc =3D {
> > > +               SYS_DESC(SYS_ID_AA64DFR0_EL1),
> > > +               .access =3D access_id_reg,
> > > +               .get_user =3D get_id_reg,
> > > +               .set_user =3D set_id_aa64dfr0_el1, },
> > > +       },
> > >         ID_SANITISED(ID_AA64DFR1_EL1),
> > >         ID_UNALLOCATED(5, 2),
> > >         ID_UNALLOCATED(5, 3),
> > > @@ -457,7 +481,13 @@ static const struct sys_reg_desc id_reg_descs[] =
=3D {
> > >
> > >  const struct sys_reg_desc *kvm_arm_find_id_reg(const struct sys_reg_=
params *params)
> > >  {
> > > -       return find_reg(params, id_reg_descs, ARRAY_SIZE(id_reg_descs=
));
> > > +       u32 id;
> > > +
> > > +       id =3D reg_to_encoding(params);
> > > +       if (!is_id_reg(id))
> > > +               return NULL;
> > > +
> > > +       return &id_reg_descs[IDREG_IDX(id)].reg_desc;
> > >  }
> > >
> > >  void kvm_arm_reset_id_regs(struct kvm_vcpu *vcpu)
> > > @@ -465,39 +495,106 @@ void kvm_arm_reset_id_regs(struct kvm_vcpu *vc=
pu)
> > >         unsigned long i;
> > >
> > >         for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++)
> > > -               if (id_reg_descs[i].reset)
> > > -                       id_reg_descs[i].reset(vcpu, &id_reg_descs[i])=
;
> > > +               if (id_reg_descs[i].reg_desc.reset)
> > > +                       id_reg_descs[i].reg_desc.reset(vcpu, &id_reg_=
descs[i].reg_desc);
> > >  }
> > >
> > >  int kvm_arm_get_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_r=
eg *reg)
> > >  {
> > > -       return kvm_sys_reg_get_user(vcpu, reg,
> > > -                                   id_reg_descs, ARRAY_SIZE(id_reg_d=
escs));
> > > +       u64 __user *uaddr =3D (u64 __user *)(unsigned long)reg->addr;
> > > +       const struct sys_reg_desc *r;
> > > +       struct sys_reg_params params;
> > > +       u64 val;
> > > +       int ret;
> > > +       u32 id;
> > > +
> > > +       if (!index_to_params(reg->id, &params))
> > > +               return -ENOENT;
> > > +       id =3D reg_to_encoding(&params);
> > > +
> > > +       if (!is_id_reg(id))
> > > +               return -ENOENT;
> > > +
> > > +       r =3D &id_reg_descs[IDREG_IDX(id)].reg_desc;
> > > +       if (r->get_user) {
> > > +               ret =3D (r->get_user)(vcpu, r, &val);
> > > +       } else {
> > > +               ret =3D 0;
> > > +               val =3D 0;
> >
> > When get_user is NULL, I wonder why you want to treat them RAZ.
> > It can be achieved by using visibility(), which I think might be
> > better to use before calling get_user.
> > Another option would be simply reading from IDREG(), which I would
> > guess might be useful(?) when no special handling is necessary.
> >
> Will simply use the value from IDREG().
> >
> > > +       }
> > > +
> > > +       if (!ret)
> > > +               ret =3D put_user(val, uaddr);
> > > +
> > > +       return ret;
> > >  }
> > >
> > >  int kvm_arm_set_id_reg(struct kvm_vcpu *vcpu, const struct kvm_one_r=
eg *reg)
> > >  {
> > > -       return kvm_sys_reg_set_user(vcpu, reg,
> > > -                                   id_reg_descs, ARRAY_SIZE(id_reg_d=
escs));
> > > +       u64 __user *uaddr =3D (u64 __user *)(unsigned long)reg->addr;
> > > +       const struct sys_reg_desc *r;
> > > +       struct sys_reg_params params;
> > > +       u64 val;
> > > +       int ret;
> > > +       u32 id;
> > > +
> > > +       if (!index_to_params(reg->id, &params))
> > > +               return -ENOENT;
> > > +       id =3D reg_to_encoding(&params);
> > > +
> > > +       if (!is_id_reg(id))
> > > +               return -ENOENT;
> > > +
> > > +       if (get_user(val, uaddr))
> > > +               return -EFAULT;
> > > +
> > > +       r =3D &id_reg_descs[IDREG_IDX(id)].reg_desc;
> > > +
> > > +       if (sysreg_user_write_ignore(vcpu, r))
> > > +               return 0;
> > > +
> > > +       if (r->set_user)
> > > +               ret =3D (r->set_user)(vcpu, r, val);
> > > +       else
> > > +               ret =3D 0;
> >
> > This appears to be the same handling as WI.
> > How do you plan to use this set_user =3D=3D NULL case ?
> > I don't think this shouldn't happen with the current code.
> > You might want to use WARN_ONCE here ?
> Yes, you are right. It won't happen with current code. WIll use WARN_ONCE=
 here.
> >
> > > +
> > > +       return ret;
> > >  }
> > >
> > >  bool kvm_arm_check_idreg_table(void)
> > >  {
> > > -       return check_sysreg_table(id_reg_descs, ARRAY_SIZE(id_reg_des=
cs), false);
> > > +       unsigned int i;
> > > +
> > > +       for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > > +               const struct sys_reg_desc *r =3D &id_reg_descs[i].reg=
_desc;
> > > +
> > > +               if (r->reg && !r->reset) {
> >
> > I don't think we need to check "!r->reset".
> > If r->reg is not NULL, I believe the entry must be incorrect.
> I am not sure I got your idea here? r->reg usually should not be NULL.

In general (not for ID registers), the r->reg is used as an index of sys_re=
g[].
In this patch, ID registers are not saved in sys_regs[], but in kvm_arch's
id_regs[].  So, I think the r->reg should be NULL for the ID registers.
(In fact, it is NULL for all ID registers in the current patch, right ?)

Or am I missing something ?

> >
> > > +                       kvm_err("sys_reg table %pS entry %d lacks res=
et\n", r, i);
> > > +                       return false;
> > > +               }
> > > +
> > > +               if (i && cmp_sys_reg(&id_reg_descs[i-1].reg_desc, r) =
>=3D 0) {
> >
> > In this table, each ID register needs to be in the proper place.
> > So, I would think what should be checked would be if each entry
> > in the table includes the right ID register.
> > (e.g. id_reg_descs[0] must be for ID_PFR0_EL1, etc)
> This comparison does the work, I think. It can detect any duplicate or
> non-ID entry, unless all entries are wrong and in the order.

Yes, I agree it does some work. There are some more cases that the
checking can't detect though (e.g. if one ID register is missing
from the table, I don't think the check can detect that).
I would prefer to adjust the checking specifically for this table
(i.e. Instead of checking the ordering, make sure that the entry
is for an ID register, and it is located in the right position).
What do you think ?

Thank you,
Reiji
