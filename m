Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B60C7D3DA4
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 19:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjJWR2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 13:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjJWR2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 13:28:42 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BEE10D8
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 10:28:35 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-3529f5f5dadso5075ab.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 10:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698082114; x=1698686914; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hh5gbGTjwswNSJut0j41J9mky6NNqMMsm33VLdUTGQU=;
        b=ARHEb9Uw32OUtRDh2U8KGmEmLIl89Gy+AiTgHDj3OL8gOv24T7ht8nGPr6WLw5PnnP
         edUWMjzneYNV2Bqv8P9EP6f3dw5EXLPe87B/qWDwumYEVVFFGWf+LuZuK1uBGf5jXGmI
         Z/Ibc2Ft9Wfd/nBto4G3HFa72tzTR+xSZNgWbYcpSH6v65/G55EqDGgeQ/CJNJJHxV/n
         l1javPbmR9OnkrYu6WHRfDhqjS+I4QsXnyfoahEWHqoNu46qur0vFJbklD+4XdQVFsPf
         USo2u+jxbGkLyWZeQWDEZ4Fw2S0W4zeaTdc0U1aYIr5J3+4NbbO5hUf+IPTc2G2hwUFD
         6s3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698082114; x=1698686914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hh5gbGTjwswNSJut0j41J9mky6NNqMMsm33VLdUTGQU=;
        b=j6bM3njPG4ctRtP2DHozqfy+taukV7e6HMk5Y7GQAsz61fnoMgqiadm+A7Y15zJQhK
         qdK+I4Zous3ihg/u9zV6sffFKaafkoHBwi6j8WZDWCVV27JKm2CMlVIW0f0iPGZ5PpIl
         6tPK1VKso175SmA1Nr3MzySVe/I7uFkd01AKn1ZpUD7GQGIqkb4PwY/FSjjk2wG7yD+w
         OCK0Zf4sejRSUNlp18Q+E3v9EgTciLds1RdDBRfVKiJ5lWbu0anUCFk+2K3V/dBZ3LDB
         UAF+PYs+dW1U+O9aukmQqJm7sIFDKFEOcRNOpDsiohCuIOIXigP4eU4aVWZs9QQW8H0n
         SO+w==
X-Gm-Message-State: AOJu0YzLRiLo2DJ4x8FB7uoA/zqGwg7BrDkp6+XqxNbMJwDjHop6kvkm
        7z+Ki3DAcF1AGs655XmMuIojDIisy1zuazWGtr9jQw==
X-Google-Smtp-Source: AGHT+IGVUVY7CGh97Fb45OyO1PzaUAleRd5IyCXNtJ+bUNq5F5zhjHvvOXBRC7PVZbE40qgq9FQjlIBjiiboUleG7b8=
X-Received: by 2002:a92:ac07:0:b0:351:ad4:85b with SMTP id r7-20020a92ac07000000b003510ad4085bmr27471ilh.4.1698082113782;
 Mon, 23 Oct 2023 10:28:33 -0700 (PDT)
MIME-Version: 1.0
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-6-rananta@google.com>
 <86zg094j1o.wl-maz@kernel.org>
In-Reply-To: <86zg094j1o.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 23 Oct 2023 10:28:21 -0700
Message-ID: <CAJHc60z97PZ5adQEzW-m2GyTPf2=f5RECMQ5P-2e-rObr1LbaQ@mail.gmail.com>
Subject: Re: [PATCH v8 05/13] KVM: arm64: Add {get,set}_user for
 PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Mon, Oct 23, 2023 at 5:31=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 20 Oct 2023 22:40:45 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > For unimplemented counters, the bits in PM{C,I}NTEN{SET,CLR} and
> > PMOVS{SET,CLR} registers are expected to RAZ. To honor this,
> > explicitly implement the {get,set}_user functions for these
> > registers to mask out unimplemented counters for userspace reads
> > and writes.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 91 ++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 85 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index faf97878dfbbb..2e5d497596ef8 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -987,6 +987,45 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vc=
pu, struct sys_reg_params *p,
> >       return true;
> >  }
> >
> > +static void set_pmreg_for_valid_counters(struct kvm_vcpu *vcpu,
> > +                                       u64 reg, u64 val, bool set)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +
> > +     mutex_lock(&kvm->arch.config_lock);
> > +
> > +     /* Make the register immutable once the VM has started running */
> > +     if (kvm_vm_has_ran_once(kvm)) {
> > +             mutex_unlock(&kvm->arch.config_lock);
> > +             return;
> > +     }
> > +
> > +     val &=3D kvm_pmu_valid_counter_mask(vcpu);
> > +     mutex_unlock(&kvm->arch.config_lock);
> > +
> > +     if (set)
> > +             __vcpu_sys_reg(vcpu, reg) |=3D val;
> > +     else
> > +             __vcpu_sys_reg(vcpu, reg) &=3D ~val;
> > +}
> > +
> > +static int get_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r,
> > +                     u64 *val)
> > +{
> > +     u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> > +
> > +     *val =3D __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
> > +     return 0;
> > +}
> > +
> > +static int set_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r,
> > +                     u64 val)
> > +{
> > +     /* r->Op2 & 0x1: true for PMCNTENSET_EL0, else PMCNTENCLR_EL0 */
> > +     set_pmreg_for_valid_counters(vcpu, PMCNTENSET_EL0, val, r->Op2 & =
0x1);
> > +     return 0;
> > +}
>
> Huh, this is really ugly. Why the explosion of pointless helpers when
> the whole design of the sysreg infrastructure to have *common* helpers
> for registers that behave the same way?
>
> I'd expect something like the hack below instead.
>
>         M.
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a2c5f210b3d6..8f560a2496f2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -987,42 +987,46 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcp=
u, struct sys_reg_params *p,
>         return true;
>  }
>
> -static void set_pmreg_for_valid_counters(struct kvm_vcpu *vcpu,
> -                                         u64 reg, u64 val, bool set)
> +static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
, u64 val)
>  {
>         struct kvm *kvm =3D vcpu->kvm;
> +       bool set;
>
>         mutex_lock(&kvm->arch.config_lock);
>
>         /* Make the register immutable once the VM has started running */
>         if (kvm_vm_has_ran_once(kvm)) {
>                 mutex_unlock(&kvm->arch.config_lock);
> -               return;
> +               return 0;
>         }
>
>         val &=3D kvm_pmu_valid_counter_mask(vcpu);
>         mutex_unlock(&kvm->arch.config_lock);
>
> +       switch(r->reg) {
> +       case PMOVSSET_EL0:
> +               /* CRm[1] being set indicates a SET register, and CLR oth=
erwise */
> +               set =3D r->CRm & 2;
> +               break;
> +       default:
> +               /* Op2[0] being set indicates a SET register, and CLR oth=
erwise */
> +               set =3D r->Op2 & 1;
> +               break;
> +       }
> +
>         if (set)
> -               __vcpu_sys_reg(vcpu, reg) |=3D val;
> +               __vcpu_sys_reg(vcpu, r->reg) |=3D val;
>         else
> -               __vcpu_sys_reg(vcpu, reg) &=3D ~val;
> -}
> -
> -static int get_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r,
> -                       u64 *val)
> -{
> -       u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> +               __vcpu_sys_reg(vcpu, r->reg) &=3D ~val;
>
> -       *val =3D __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
>         return 0;
>  }
>
> -static int set_pmcnten(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r,
> -                       u64 val)
> +static int get_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
, u64 *val)
>  {
> -       /* r->Op2 & 0x1: true for PMCNTENSET_EL0, else PMCNTENCLR_EL0 */
> -       set_pmreg_for_valid_counters(vcpu, PMCNTENSET_EL0, val, r->Op2 & =
0x1);
> +       u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> +
> +       *val =3D __vcpu_sys_reg(vcpu, r->reg) & mask;
>         return 0;
>  }
>
> @@ -1054,23 +1058,6 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, =
struct sys_reg_params *p,
>         return true;
>  }
>
> -static int get_pminten(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r,
> -                       u64 *val)
> -{
> -       u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> -
> -       *val =3D __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
> -       return 0;
> -}
> -
> -static int set_pminten(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*r,
> -                       u64 val)
> -{
> -       /* r->Op2 & 0x1: true for PMINTENSET_EL1, else PMINTENCLR_EL1 */
> -       set_pmreg_for_valid_counters(vcpu, PMINTENSET_EL1, val, r->Op2 & =
0x1);
> -       return 0;
> -}
> -
>  static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params =
*p,
>                            const struct sys_reg_desc *r)
>  {
> @@ -1095,23 +1082,6 @@ static bool access_pminten(struct kvm_vcpu *vcpu, =
struct sys_reg_params *p,
>         return true;
>  }
>
> -static int set_pmovs(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
> -                     u64 val)
> -{
> -       /* r->CRm & 0x2: true for PMOVSSET_EL0, else PMOVSCLR_EL0 */
> -       set_pmreg_for_valid_counters(vcpu, PMOVSSET_EL0, val, r->CRm & 0x=
2);
> -       return 0;
> -}
> -
> -static int get_pmovs(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r=
,
> -                     u64 *val)
> -{
> -       u64 mask =3D kvm_pmu_valid_counter_mask(vcpu);
> -
> -       *val =3D __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
> -       return 0;
> -}
> -
>  static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p=
,
>                          const struct sys_reg_desc *r)
>  {
> @@ -2311,10 +2281,10 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>
>         { PMU_SYS_REG(PMINTENSET_EL1),
>           .access =3D access_pminten, .reg =3D PMINTENSET_EL1,
> -         .get_user =3D get_pminten, .set_user =3D set_pminten },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         { PMU_SYS_REG(PMINTENCLR_EL1),
>           .access =3D access_pminten, .reg =3D PMINTENSET_EL1,
> -         .get_user =3D get_pminten, .set_user =3D set_pminten },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         { SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
>
>         { SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 =
},
> @@ -2366,13 +2336,13 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>           .reg =3D PMCR_EL0, .get_user =3D get_pmcr, .set_user =3D set_pm=
cr },
>         { PMU_SYS_REG(PMCNTENSET_EL0),
>           .access =3D access_pmcnten, .reg =3D PMCNTENSET_EL0,
> -         .get_user =3D get_pmcnten, .set_user =3D set_pmcnten },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         { PMU_SYS_REG(PMCNTENCLR_EL0),
>           .access =3D access_pmcnten, .reg =3D PMCNTENSET_EL0,
> -         .get_user =3D get_pmcnten, .set_user =3D set_pmcnten },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         { PMU_SYS_REG(PMOVSCLR_EL0),
>           .access =3D access_pmovs, .reg =3D PMOVSSET_EL0,
> -         .get_user =3D get_pmovs, .set_user =3D set_pmovs },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>         /*
>          * PM_SWINC_EL0 is exposed to userspace as RAZ/WI, as it was
>          * previously (and pointlessly) advertised in the past...
> @@ -2401,7 +2371,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>           .reset =3D reset_val, .reg =3D PMUSERENR_EL0, .val =3D 0 },
>         { PMU_SYS_REG(PMOVSSET_EL0),
>           .access =3D access_pmovs, .reg =3D PMOVSSET_EL0,
> -         .get_user =3D get_pmovs, .set_user =3D set_pmovs },
> +         .get_user =3D get_pmreg, .set_user =3D set_pmreg },
>
>         { SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
>         { SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
>

Thanks for the suggestion. I'll consider this in the next iteration.

- Raghavendra
