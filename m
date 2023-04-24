Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E5C6ED526
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 21:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjDXTNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 15:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbjDXTNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 15:13:04 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B96059CA
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 12:12:48 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-18e8a69094dso542707fac.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 12:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682363567; x=1684955567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aT+1x4lbqwmdjBNj103Q5ZtalPy9ZDnbYHMyC0wCJDQ=;
        b=gqGsnxOjJwOEgsRpfV08CZHynkbvpFUERyamfPT+7tHCyZl725kcXwrsraQ4ZJxf+/
         ofaAGnAxfmM0kOUpMmNrfq03hmBPMaqL2yHDlUejLG8Iods7vKANTXRSae0ZPlpA+++9
         Fj4zdiayx8w0lMsXE6YRize0LpCJsLwinBJoH+6Q08oGIIDHk3rOo03+ZHWFbVDea5zt
         kZKuMwd/EKhpVwAFY2mu8z+nMOMz4+OHG5/M6pAz+3quk3n2SuP7wcAR+WT5pVFbwdLM
         8PM1Y8GMI5n+X0sP6Pa+ytQmcwejPaCpaBXrd9qDixK2quPINHuD76GZuohmzGFIwFoC
         ZdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682363567; x=1684955567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aT+1x4lbqwmdjBNj103Q5ZtalPy9ZDnbYHMyC0wCJDQ=;
        b=h4nUUj8IlcLrY907TLcdJrb47o7ZmNxCrRCm3AoQLrhhErYqG0q9jaW03VFXGV47KS
         W3DVu86Kb1VFkeJkX19eZQ3RZXJNHaDDVCqWct8UbWrcU8HfCpZikkKtwwF/8ac5zmiu
         0o+XdlNIFR7Tg/JNG9eEbicoH7AfQKObSRh9AYw0NDD1kB9pXjBtmn6K1N99d1UpIiWR
         Hu9PEN6Np/wU15BAAju2eNHCOZAP6kVCP52smtDahCz2HJTsvxSokRaCrgOGWFBl6Qry
         9gvDU1JEuUzzayaWgW54sFOeCTim/W7yWAYm85WpIfE1iQPHAMQMdm9x5/HDgt00zWX7
         AceQ==
X-Gm-Message-State: AC+VfDwhDgfidwFW9c8Hxn2rWwfyAb6JDp1msIM9zcjcpTVy+le4oQu2
        +VB7Y/t49V+pNkSVsE+II2eY07YAfGRnGn+rLZ9NfA==
X-Google-Smtp-Source: ACHHUZ5QA9uabLSmq3Ue/7H3/L2AxP+/+O29pdGTeGM8Ob/KrfSr/PWI3lRASKW+p+IYYgtepx3q/F//avAvqdY0dmo=
X-Received: by 2002:a05:6870:ac10:b0:18e:b4ce:a00c with SMTP id
 kw16-20020a056870ac1000b0018eb4cea00cmr1811968oab.1.1682363567465; Mon, 24
 Apr 2023 12:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230404035344.4043856-1-jingzhangos@google.com>
 <20230404035344.4043856-6-jingzhangos@google.com> <20230419040900.mqrk4jvkujkehic6@google.com>
In-Reply-To: <20230419040900.mqrk4jvkujkehic6@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 24 Apr 2023 12:12:36 -0700
Message-ID: <CAAdAUtgPzakxPWsHTapv6zsNJJ81Va-XZ+7AdxQ=1p4KVUkRMA@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] KVM: arm64: Reuse fields of sys_reg_desc for idreg
To:     Reiji Watanabe <reijiw@google.com>
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
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Tue, Apr 18, 2023 at 9:09=E2=80=AFPM Reiji Watanabe <reijiw@google.com> =
wrote:
>
> Hi Jing,
>
> On Tue, Apr 04, 2023 at 03:53:43AM +0000, Jing Zhang wrote:
> > Since reset() and val are not used for idreg in sys_reg_desc, they woul=
d
> > be used with other purposes for idregs.
> > The callback reset() would be used to return KVM sanitised id register
> > values. The u64 val would be used as mask for writable fields in idregs=
.
> > Only bits with 1 in val are writable from userspace.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/id_regs.c  | 44 +++++++++++++++++++----------
> >  arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++------------
> >  arch/arm64/kvm/sys_regs.h | 10 ++++---
> >  3 files changed, 77 insertions(+), 36 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index 6f65d30693fe..fe37b6786b4c 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -55,6 +55,11 @@ static u8 pmuver_to_perfmon(u8 pmuver)
> >       }
> >  }
> >
> > +static u64 general_read_kvm_sanitised_reg(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *rd)
> > +{
> > +     return read_sanitised_ftr_reg(reg_to_encoding(rd));
> > +}
> > +
> >  u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >  {
> >       u64 val =3D IDREG(vcpu->kvm, id);
> > @@ -324,6 +329,17 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +/*
> > + * Since reset() callback and field val are not used for idregs, they =
will be
> > + * used for specific purposes for idregs.
> > + * The reset() would return KVM sanitised register value. The value wo=
uld be the
> > + * same as the host kernel sanitised value if there is no KVM sanitisa=
tion.
> > + * The val would be used as a mask indicating writable fields for the =
idreg.
> > + * Only bits with 1 are writable from userspace. This mask might not b=
e
>
> Nit: This comment update seems to be in the next patch,
> since 'val' for AA64PFR0, AA64DFR0 and DFR0 is zero yet.
Even the val is all zero in this commit, but it is used the first time
here. I guess it is okay to have the comment here.
>
>
> > + * necessary in the future whenever all ID registers are enabled as wr=
itable
> > + * from userspace.
> > + */
> > +
> >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> >  #define ID_SANITISED(name) {                 \
> >       SYS_DESC(SYS_##name),                   \
> > @@ -331,6 +347,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >       .get_user =3D get_id_reg,                 \
> >       .set_user =3D set_id_reg,                 \
> >       .visibility =3D id_visibility,            \
> > +     .reset =3D general_read_kvm_sanitised_reg,\
> > +     .val =3D 0,                               \
> >  }
> >
> >  /* sys_reg_desc initialiser for known cpufeature ID registers */
> > @@ -340,6 +358,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >       .get_user =3D get_id_reg,                 \
> >       .set_user =3D set_id_reg,                 \
> >       .visibility =3D aa32_id_visibility,       \
> > +     .reset =3D general_read_kvm_sanitised_reg,\
> > +     .val =3D 0,                               \
> >  }
> >
> >  /*
> > @@ -352,7 +372,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >       .access =3D access_id_reg,                        \
> >       .get_user =3D get_id_reg,                         \
> >       .set_user =3D set_id_reg,                         \
> > -     .visibility =3D raz_visibility                    \
> > +     .visibility =3D raz_visibility,                   \
> > +     .reset =3D NULL,                                  \
> > +     .val =3D 0,                                       \
> >  }
> >
> >  /*
> > @@ -366,6 +388,8 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >       .get_user =3D get_id_reg,                 \
> >       .set_user =3D set_id_reg,                 \
> >       .visibility =3D raz_visibility,           \
> > +     .reset =3D NULL,                          \
> > +     .val =3D 0,                               \
> >  }
> >
> >  const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] =3D {
> > @@ -476,10 +500,7 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct s=
ys_reg_params *params)
> >       return 1;
> >  }
> >
> > -/*
> > - * Set the guest's ID registers that are defined in id_reg_descs[]
> > - * with ID_SANITISED() to the host's sanitized value.
> > - */
> > +/* Initialize the guest's ID registers with KVM sanitised values. */
> >  void kvm_arm_init_id_regs(struct kvm *kvm)
> >  {
> >       int i;
> > @@ -492,16 +513,11 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
> >                       /* Shouldn't happen */
> >                       continue;
> >
> > -             /*
> > -              * Some hidden ID registers which are not in arm64_ftr_re=
gs[]
> > -              * would cause warnings from read_sanitised_ftr_reg().
> > -              * Skip those ID registers to avoid the warnings.
> > -              */
> > -             if (id_reg_descs[i].visibility =3D=3D raz_visibility)
> > -                     /* Hidden or reserved ID register */
> > -                     continue;
> > +             val =3D 0;
> > +             /* Read KVM sanitised register value if available */
> > +             if (id_reg_descs[i].reset)
> > +                     val =3D id_reg_descs[i].reset(NULL, &id_reg_descs=
[i]);
> >
> > -             val =3D read_sanitised_ftr_reg(id);
> >               IDREG(kvm, id) =3D val;
> >       }
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 15979c2b87ab..703cf833345a 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -540,10 +540,11 @@ static int get_bvr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *rd,
> >       return 0;
> >  }
> >
> > -static void reset_bvr(struct kvm_vcpu *vcpu,
> > +static u64 reset_bvr(struct kvm_vcpu *vcpu,
> >                     const struct sys_reg_desc *rd)
> >  {
> >       vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] =3D rd->val;
> > +     return rd->val;
> >  }
> >
> >  static bool trap_bcr(struct kvm_vcpu *vcpu,
> > @@ -576,10 +577,11 @@ static int get_bcr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *rd,
> >       return 0;
> >  }
> >
> > -static void reset_bcr(struct kvm_vcpu *vcpu,
> > +static u64 reset_bcr(struct kvm_vcpu *vcpu,
> >                     const struct sys_reg_desc *rd)
> >  {
> >       vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] =3D rd->val;
> > +     return rd->val;
> >  }
> >
> >  static bool trap_wvr(struct kvm_vcpu *vcpu,
> > @@ -613,10 +615,11 @@ static int get_wvr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *rd,
> >       return 0;
> >  }
> >
> > -static void reset_wvr(struct kvm_vcpu *vcpu,
> > +static u64 reset_wvr(struct kvm_vcpu *vcpu,
> >                     const struct sys_reg_desc *rd)
> >  {
> >       vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] =3D rd->val;
> > +     return rd->val;
> >  }
> >
> >  static bool trap_wcr(struct kvm_vcpu *vcpu,
> > @@ -649,25 +652,28 @@ static int get_wcr(struct kvm_vcpu *vcpu, const s=
truct sys_reg_desc *rd,
> >       return 0;
> >  }
> >
> > -static void reset_wcr(struct kvm_vcpu *vcpu,
> > +static u64 reset_wcr(struct kvm_vcpu *vcpu,
> >                     const struct sys_reg_desc *rd)
> >  {
> >       vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] =3D rd->val;
> > +     return rd->val;
> >  }
> >
> > -static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_re=
g_desc *r)
> > +static u64 reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg=
_desc *r)
> >  {
> >       u64 amair =3D read_sysreg(amair_el1);
> >       vcpu_write_sys_reg(vcpu, amair, AMAIR_EL1);
> > +     return amair;
> >  }
> >
> > -static void reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_de=
sc *r)
> > +static u64 reset_actlr(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r)
> >  {
> >       u64 actlr =3D read_sysreg(actlr_el1);
> >       vcpu_write_sys_reg(vcpu, actlr, ACTLR_EL1);
> > +     return actlr;
> >  }
> >
> > -static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_de=
sc *r)
> > +static u64 reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r)
> >  {
> >       u64 mpidr;
> >
> > @@ -681,7 +687,10 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, con=
st struct sys_reg_desc *r)
> >       mpidr =3D (vcpu->vcpu_id & 0x0f) << MPIDR_LEVEL_SHIFT(0);
> >       mpidr |=3D ((vcpu->vcpu_id >> 4) & 0xff) << MPIDR_LEVEL_SHIFT(1);
> >       mpidr |=3D ((vcpu->vcpu_id >> 12) & 0xff) << MPIDR_LEVEL_SHIFT(2)=
;
> > -     vcpu_write_sys_reg(vcpu, (1ULL << 31) | mpidr, MPIDR_EL1);
> > +     mpidr |=3D (1ULL << 31);
> > +     vcpu_write_sys_reg(vcpu, mpidr, MPIDR_EL1);
> > +
> > +     return mpidr;
> >  }
> >
> >  static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
> > @@ -693,13 +702,13 @@ static unsigned int pmu_visibility(const struct k=
vm_vcpu *vcpu,
> >       return REG_HIDDEN;
> >  }
> >
> > -static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
> > +static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_d=
esc *r)
> >  {
> >       u64 n, mask =3D BIT(ARMV8_PMU_CYCLE_IDX);
> >
> >       /* No PMU available, any PMU reg may UNDEF... */
> >       if (!kvm_arm_support_pmu_v3())
> > -             return;
> > +             return 0;
> >
> >       n =3D read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> >       n &=3D ARMV8_PMU_PMCR_N_MASK;
> > @@ -708,33 +717,41 @@ static void reset_pmu_reg(struct kvm_vcpu *vcpu, =
const struct sys_reg_desc *r)
> >
> >       reset_unknown(vcpu, r);
> >       __vcpu_sys_reg(vcpu, r->reg) &=3D mask;
> > +
> > +     return __vcpu_sys_reg(vcpu, r->reg);
> >  }
> >
> > -static void reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg=
_desc *r)
> > +static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
> >  {
> >       reset_unknown(vcpu, r);
> >       __vcpu_sys_reg(vcpu, r->reg) &=3D GENMASK(31, 0);
> > +
> > +     return __vcpu_sys_reg(vcpu, r->reg);
> >  }
> >
> > -static void reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_re=
g_desc *r)
> > +static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg=
_desc *r)
> >  {
> >       reset_unknown(vcpu, r);
> >       __vcpu_sys_reg(vcpu, r->reg) &=3D ARMV8_PMU_EVTYPE_MASK;
> > +
> > +     return __vcpu_sys_reg(vcpu, r->reg);
> >  }
> >
> > -static void reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_d=
esc *r)
> > +static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_de=
sc *r)
> >  {
> >       reset_unknown(vcpu, r);
> >       __vcpu_sys_reg(vcpu, r->reg) &=3D ARMV8_PMU_COUNTER_MASK;
> > +
> > +     return __vcpu_sys_reg(vcpu, r->reg);
> >  }
> >
> > -static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r)
> > +static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r)
> >  {
> >       u64 pmcr;
> >
> >       /* No PMU available, PMCR_EL0 may UNDEF... */
> >       if (!kvm_arm_support_pmu_v3())
> > -             return;
> > +             return 0;
> >
> >       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> >       pmcr =3D read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_=
PMU_PMCR_N_SHIFT);
> > @@ -742,6 +759,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r)
> >               pmcr |=3D ARMV8_PMU_PMCR_LC;
> >
> >       __vcpu_sys_reg(vcpu, r->reg) =3D pmcr;
> > +
> > +     return __vcpu_sys_reg(vcpu, r->reg);
> >  }
> >
> >  static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags=
)
> > @@ -1221,7 +1240,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, s=
truct sys_reg_params *p,
> >   * Fabricate a CLIDR_EL1 value instead of using the real value, which =
can vary
> >   * by the physical CPU which the vcpu currently resides in.
> >   */
> > -static void reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_de=
sc *r)
> > +static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_des=
c *r)
> >  {
> >       u64 ctr_el0 =3D read_sanitised_ftr_reg(SYS_CTR_EL0);
> >       u64 clidr;
> > @@ -1269,6 +1288,8 @@ static void reset_clidr(struct kvm_vcpu *vcpu, co=
nst struct sys_reg_desc *r)
> >               clidr |=3D 2 << CLIDR_TTYPE_SHIFT(loc);
> >
> >       __vcpu_sys_reg(vcpu, r->reg) =3D clidr;
> > +
> > +     return __vcpu_sys_reg(vcpu, r->reg);
> >  }
> >
> >  static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc =
*rd,
> > @@ -2622,19 +2643,21 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 i=
d,
> >   */
> >
> >  #define FUNCTION_INVARIANT(reg)                                       =
       \
> > -     static void get_##reg(struct kvm_vcpu *v,                       \
> > +     static u64 get_##reg(struct kvm_vcpu *v,                        \
> >                             const struct sys_reg_desc *r)             \
> >       {                                                               \
> >               ((struct sys_reg_desc *)r)->val =3D read_sysreg(reg);    =
 \
> > +             return ((struct sys_reg_desc *)r)->val;                 \
> >       }
> >
> >  FUNCTION_INVARIANT(midr_el1)
> >  FUNCTION_INVARIANT(revidr_el1)
> >  FUNCTION_INVARIANT(aidr_el1)
> >
> > -static void get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc =
*r)
> > +static u64 get_ctr_el0(struct kvm_vcpu *v, const struct sys_reg_desc *=
r)
> >  {
> >       ((struct sys_reg_desc *)r)->val =3D read_sanitised_ftr_reg(SYS_CT=
R_EL0);
> > +     return ((struct sys_reg_desc *)r)->val;
> >  }
> >
> >  /* ->val is filled in by kvm_sys_reg_table_init() */
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index e88fd77309b2..21869319f6e1 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -65,12 +65,12 @@ struct sys_reg_desc {
> >                      const struct sys_reg_desc *);
> >
> >       /* Initialization for vcpu. */
> > -     void (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
> > +     u64 (*reset)(struct kvm_vcpu *, const struct sys_reg_desc *);
>
> Could you add a comment what is return from reset() ?
The returned value for idregs is described both in the commit message
and the comment block in previous change.
>
> Thank you,
> Reiji
>
> >
> >       /* Index into sys_reg[], or 0 if we don't need to save it. */
> >       int reg;
> >
> > -     /* Value (usually reset value) */
> > +     /* Value (usually reset value), or write mask for idregs */
> >       u64 val;
> >
> >       /* Custom get/set_user functions, fallback to generic if NULL */
> > @@ -123,19 +123,21 @@ static inline bool read_zero(struct kvm_vcpu *vcp=
u,
> >  }
> >
> >  /* Reset functions */
> > -static inline void reset_unknown(struct kvm_vcpu *vcpu,
> > +static inline u64 reset_unknown(struct kvm_vcpu *vcpu,
> >                                const struct sys_reg_desc *r)
> >  {
> >       BUG_ON(!r->reg);
> >       BUG_ON(r->reg >=3D NR_SYS_REGS);
> >       __vcpu_sys_reg(vcpu, r->reg) =3D 0x1de7ec7edbadc0deULL;
> > +     return __vcpu_sys_reg(vcpu, r->reg);
> >  }
> >
> > -static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_r=
eg_desc *r)
> > +static inline u64 reset_val(struct kvm_vcpu *vcpu, const struct sys_re=
g_desc *r)
> >  {
> >       BUG_ON(!r->reg);
> >       BUG_ON(r->reg >=3D NR_SYS_REGS);
> >       __vcpu_sys_reg(vcpu, r->reg) =3D r->val;
> > +     return __vcpu_sys_reg(vcpu, r->reg);
> >  }
> >
> >  static inline unsigned int sysreg_visibility(const struct kvm_vcpu *vc=
pu,
> > --
> > 2.40.0.348.gf938b09366-goog
> >
Thanks,
Jing
