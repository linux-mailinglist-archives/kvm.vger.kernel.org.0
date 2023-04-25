Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426D26EE5EB
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbjDYQk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 12:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbjDYQk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 12:40:27 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B1AD32E
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 09:40:25 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6a5f7d10dd5so4506907a34.0
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 09:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682440824; x=1685032824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rO4YoZvadBGEgaNrbWHbPGT+yzgfbrpcvi3t+Sdq0Po=;
        b=I4t+p2cUv0/4jGmgyEJl4lHziOekzznANq2DKP0CX9awrJpFIv+S9DIR5DGOuCIYYw
         LC76u6MSUAj9UGkHVIkXdR1+N2dM92PoEz4eulr8chDj07cd8cb2lew87eTHhjOeixZK
         aZNqEWxZdfKDXtXOB+LCguq/IThgJrdyrXSLkVnOR4iQ/bXufL4W9fcE2nApcKWdnkpa
         uPtiiwITtjA5SGLc/+1NzxMu1j/JKjV4n0lkIhktJ0SCTTr0CH4d0RKy/xAajCS1I/fo
         J/NegVpr99BkZQTdZfMRv12BWWraMxbLAI18yIXD2F1B5Jgjzyu+kVBDv42NoWiXqots
         LNbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682440824; x=1685032824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rO4YoZvadBGEgaNrbWHbPGT+yzgfbrpcvi3t+Sdq0Po=;
        b=ScIYBROUnaC++wJQ1WrMlbqiEPy/ueA9X9VY/+rjSkXGIKorvn6NFlsozUS3LIHs4G
         eZntZHywl2MABH15v20z4iwMbDEfmFaJPex0vP38QYT7ZlmHqQCaRJJEz3a3/lQFlaDk
         OFxQlsB7Gi2oQ/S71oS8Fcg9tCUe103/fH4/uL7WByF4591U8OtTadQFaRTGMpSR2nBj
         zK98t3qfrk1zg7JLRayhSzQojCEqWR3KhLaCMSiikIbk1FxbKe49mxfmQkf21kVJfjRo
         63Iqi5Wa7IbAua/p9gSUHh3yaqkdJapz/IwSfgJzpVAajTUClF1oNxbt82ssgBwzCpoB
         h7bg==
X-Gm-Message-State: AAQBX9cec1V+D+M0b0BFp9st1gGips563lexQXQocnBiut7A7tgAJHcl
        onDKLp27fuGt7/ODVkiAlcJYh9lh1Qc73Rfbt0HpsQ==
X-Google-Smtp-Source: AKy350Z3tNyh/mM9xa9atf0r6IW4cQl/ctdf7+Lurrd/NtFnEowEH4t0K6LWPTKpLZRXf4CrgIL4n/OSOa+g/Yjss4w=
X-Received: by 2002:a05:6870:1f81:b0:18b:1df9:92ba with SMTP id
 go1-20020a0568701f8100b0018b1df992bamr10915593oac.1.1682440824194; Tue, 25
 Apr 2023 09:40:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230404035344.4043856-1-jingzhangos@google.com>
 <20230404035344.4043856-7-jingzhangos@google.com> <20230419045943.bxt2xizlgslaoggi@google.com>
 <CAAdAUtgHUV3ms7i2owWWkVMH430QzprmJgn2hDunZ9Shw7j=PQ@mail.gmail.com> <20230425021942.j7euryrduejjvueb@google.com>
In-Reply-To: <20230425021942.j7euryrduejjvueb@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 25 Apr 2023 09:40:12 -0700
Message-ID: <CAAdAUtj8do+Ewa+KnYpukAyyVZ6CUMLyqw-LY5X1cemiusRz_A@mail.gmail.com>
Subject: Re: [PATCH v6 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
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

On Mon, Apr 24, 2023 at 7:19=E2=80=AFPM Reiji Watanabe <reijiw@google.com> =
wrote:
>
> Hi Jing,
>
> On Mon, Apr 24, 2023 at 12:19:50PM -0700, Jing Zhang wrote:
> > Hi Reiji,
> >
> > On Tue, Apr 18, 2023 at 9:59=E2=80=AFPM Reiji Watanabe <reijiw@google.c=
om> wrote:
> > >
> > > Hi Jing,
> > >
> > > On Tue, Apr 04, 2023 at 03:53:44AM +0000, Jing Zhang wrote:
> > > > Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> > > > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> > > > introduced by ID register descriptor array.
> > > >
> > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/cpufeature.h |   1 +
> > > >  arch/arm64/kernel/cpufeature.c      |   2 +-
> > > >  arch/arm64/kvm/id_regs.c            | 284 ++++++++++++++++++++----=
----
> > > >  3 files changed, 203 insertions(+), 84 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/inclu=
de/asm/cpufeature.h
> > > > index 6bf013fb110d..dc769c2eb7a4 100644
> > > > --- a/arch/arm64/include/asm/cpufeature.h
> > > > +++ b/arch/arm64/include/asm/cpufeature.h
> > > > @@ -915,6 +915,7 @@ static inline unsigned int get_vmid_bits(u64 mm=
fr1)
> > > >       return 8;
> > > >  }
> > > >
> > > > +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 ne=
w, s64 cur);
> > > >  struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
> > > >
> > > >  extern struct arm64_ftr_override id_aa64mmfr1_override;
> > > > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpu=
feature.c
> > > > index 2e3e55139777..677ec4fe9f6b 100644
> > > > --- a/arch/arm64/kernel/cpufeature.c
> > > > +++ b/arch/arm64/kernel/cpufeature.c
> > > > @@ -791,7 +791,7 @@ static u64 arm64_ftr_set_value(const struct arm=
64_ftr_bits *ftrp, s64 reg,
> > > >       return reg;
> > > >  }
> > > >
> > > > -static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp,=
 s64 new,
> > > > +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 ne=
w,
> > > >                               s64 cur)
> > > >  {
> > > >       s64 ret =3D 0;
> > > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > > > index fe37b6786b4c..33968ada29bb 100644
> > > > --- a/arch/arm64/kvm/id_regs.c
> > > > +++ b/arch/arm64/kvm/id_regs.c
> > > > @@ -18,6 +18,66 @@
> > > >
> > > >  #include "sys_regs.h"
> > > >
> > > > +/**
> > > > + * arm64_check_features() - Check if a feature register value cons=
titutes
> > > > + * a subset of features indicated by the idreg's KVM sanitised lim=
it.
> > > > + *
> > > > + * This function will check if each feature field of @val is the "=
safe" value
> > > > + * against idreg's KVM sanitised limit return from reset() callbac=
k.
> > > > + * If a field value in @val is the same as the one in limit, it is=
 always
> > > > + * considered the safe value regardless For register fields that a=
re not in
> > > > + * writable, only the value in limit is considered the safe value.
> > > > + *
> > > > + * Return: 0 if all the fields are safe. Otherwise, return negativ=
e errno.
> > > > + */
> > > > +static int arm64_check_features(struct kvm_vcpu *vcpu,
> > > > +                             const struct sys_reg_desc *rd,
> > > > +                             u64 val)
> > > > +{
> > > > +     const struct arm64_ftr_reg *ftr_reg;
> > > > +     const struct arm64_ftr_bits *ftrp =3D NULL;
> > > > +     u32 id =3D reg_to_encoding(rd);
> > > > +     u64 writable_mask =3D rd->val;
> > > > +     u64 limit =3D 0;
> > > > +     u64 mask =3D 0;
> > > > +
> > > > +     /* For hidden and unallocated idregs without reset, only val =
=3D 0 is allowed. */
> > > > +     if (rd->reset) {
> > > > +             limit =3D rd->reset(vcpu, rd);
> > > > +             ftr_reg =3D get_arm64_ftr_reg(id);
> > > > +             if (!ftr_reg)
> > > > +                     return -EINVAL;
> > > > +             ftrp =3D ftr_reg->ftr_bits;
> > > > +     }
> > > > +
> > > > +     for (; ftrp && ftrp->width; ftrp++) {
> > > > +             s64 f_val, f_lim, safe_val;
> > > > +             u64 ftr_mask;
> > > > +
> > > > +             ftr_mask =3D arm64_ftr_mask(ftrp);
> > > > +             if ((ftr_mask & writable_mask) !=3D ftr_mask)
> > > > +                     continue;
> > > > +
> > > > +             f_val =3D arm64_ftr_value(ftrp, val);
> > > > +             f_lim =3D arm64_ftr_value(ftrp, limit);
> > > > +             mask |=3D ftr_mask;
> > > > +
> > > > +             if (f_val =3D=3D f_lim)
> > > > +                     safe_val =3D f_val;
> > > > +             else
> > > > +                     safe_val =3D arm64_ftr_safe_value(ftrp, f_val=
, f_lim);
> > >
> > > Since PMUVer and PerfMon is defined as FTR_EXACT, I believe having lo=
wer
> > > value in those two fields than the limit always ends up getting -E2BI=
G.
> > > Or am I missing something ??
> > > FYI. IIRC, we have some more fields in other ID registers that KVM
> > > shouldn't use as is.
> > Yes, you are right. I will add code to handle these exceptions.
> > >
> > > > +
> > > > +             if (safe_val !=3D f_val)
> > > > +                     return -E2BIG;
> > > > +     }
> > > > +
> > > > +     /* For fields that are not writable, values in limit are the =
safe values. */
> > > > +     if ((val & ~mask) !=3D (limit & ~mask))
> > > > +             return -E2BIG;
> > > > +
> > > > +     return 0;
> > > > +}
> > > > +
> > > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > > >  {
> > > >       if (kvm_vcpu_has_pmu(vcpu))
> > > > @@ -68,7 +128,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *v=
cpu, u32 id)
> > > >       case SYS_ID_AA64PFR0_EL1:
> > > >               if (!vcpu_has_sve(vcpu))
> > > >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_=
SVE);
> > > > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > > >               if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
> > > >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_=
GIC);
> > > >                       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA6=
4PFR0_EL1_GIC), 1);
> > > > @@ -95,15 +154,10 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu =
*vcpu, u32 id)
> > > >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1=
_WFxT);
> > > >               break;
> > > >       case SYS_ID_AA64DFR0_EL1:
> > > > -             /* Limit debug to ARMv8.0 */
> > > > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer=
);
> > > > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL=
1_DebugVer), 6);
> > > >               /* Set PMUver to the required version */
> > > >               val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > >               val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL=
1_PMUVer),
> > > >                                 vcpu_pmuver(vcpu));
> > > > -             /* Hide SPE from guests */
> > > > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
> > > >               break;
> > > >       case SYS_ID_DFR0_EL1:
> > > >               val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > > > @@ -162,9 +216,14 @@ static int get_id_reg(struct kvm_vcpu *vcpu, c=
onst struct sys_reg_desc *rd,
> > > >  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *rd,
> > > >                     u64 val)
> > > >  {
> > > > -     /* This is what we mean by invariant: you can't change it. */
> > > > -     if (val !=3D read_id_reg(vcpu, rd))
> > > > -             return -EINVAL;
> > > > +     u32 id =3D reg_to_encoding(rd);
> > > > +     int ret;
> > > > +
> > > > +     ret =3D arm64_check_features(vcpu, rd, val);
> > > > +     if (ret)
> > > > +             return ret;
> > > > +
> > > > +     IDREG(vcpu->kvm, id) =3D val;
> > > >
> > > >       return 0;
> > > >  }
> > > > @@ -198,12 +257,40 @@ static unsigned int aa32_id_visibility(const =
struct kvm_vcpu *vcpu,
> > > >       return id_visibility(vcpu, r);
> > > >  }
> > > >
> > > > +static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > > > +                                       const struct sys_reg_desc *=
rd)
> > > > +{
> > > > +     u64 val;
> > > > +     u32 id =3D reg_to_encoding(rd);
> > > > +
> > > > +     val =3D read_sanitised_ftr_reg(id);
> > > > +     /*
> > > > +      * The default is to expose CSV2 =3D=3D 1 if the HW isn't aff=
ected.
> > > > +      * Although this is a per-CPU feature, we make it global beca=
use
> > > > +      * asymmetric systems are just a nuisance.
> > > > +      *
> > > > +      * Userspace can override this as long as it doesn't promise
> > > > +      * the impossible.
> > > > +      */
> > > > +     if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> > > > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > > > +             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL=
1_CSV2), 1);
> > > > +     }
> > > > +     if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> > > > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > > > +             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL=
1_CSV3), 1);
> > > > +     }
> > > > +
> > > > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > > > +
> > > > +     return val;
> > > > +}
> > > > +
> > > >  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > > >                              const struct sys_reg_desc *rd,
> > > >                              u64 val)
> > > >  {
> > > >       u8 csv2, csv3;
> > > > -     u64 sval =3D val;
> > > >
> > > >       /*
> > > >        * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long a=
s
> > > > @@ -219,16 +306,30 @@ static int set_id_aa64pfr0_el1(struct kvm_vcp=
u *vcpu,
> > > >       if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() !=3D SPEC=
TRE_UNAFFECTED))
> > > >               return -EINVAL;
> > > >
> > > > -     /* We can only differ with CSV[23], and anything else is an e=
rror */
> > > > -     val ^=3D read_id_reg(vcpu, rd);
> > > > -     val &=3D ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> > > > -              ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> > > > -     if (val)
> > > > -             return -EINVAL;
> > > > +     return set_id_reg(vcpu, rd, val);
> > > > +}
> > > > +
> > > > +static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > > > +                                       const struct sys_reg_desc *=
rd)
> > > > +{
> > > > +     u64 val;
> > > > +     u32 id =3D reg_to_encoding(rd);
> > > >
> > > > -     IDREG(vcpu->kvm, reg_to_encoding(rd)) =3D sval;
> > > > +     val =3D read_sanitised_ftr_reg(id);
> > > > +     /* Limit debug to ARMv8.0 */
> > > > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> > > > +     val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugV=
er), 6);
> > > > +     /*
> > > > +      * Initialise the default PMUver before there is a chance to
> > > > +      * create an actual PMU.
> > > > +      */
> > > > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > > +     val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer=
),
> > > > +                       kvm_arm_pmu_get_pmuver_limit());
> > > > +     /* Hide SPE from guests */
> > > > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
> > > >
> > > > -     return 0;
> > > > +     return val;
> > > >  }
> > > >
> > > >  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > > > @@ -237,6 +338,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu =
*vcpu,
> > > >  {
> > > >       u8 pmuver, host_pmuver;
> > > >       bool valid_pmu;
> > > > +     int ret;
> > > >
> > > >       host_pmuver =3D kvm_arm_pmu_get_pmuver_limit();
> > > >
> > > > @@ -256,36 +358,61 @@ static int set_id_aa64dfr0_el1(struct kvm_vcp=
u *vcpu,
> > > >       if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
> > > >               return -EINVAL;
> > > >
> > > > -     /* We can only differ with PMUver, and anything else is an er=
ror */
> > > > -     val ^=3D read_id_reg(vcpu, rd);
> > > > -     val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > > -     if (val)
> > > > -             return -EINVAL;
> > > > +     if (!valid_pmu) {
> > > > +             /*
> > > > +              * Ignore the PMUVer filed in @val. The PMUVer would =
be determined
> > > > +              * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_P=
MU,
> > > > +              */
> > > > +             pmuver =3D FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK, rea=
d_id_reg(vcpu, rd));
> > >
> > > As vPMU is not configured for this vCPU, I believe pmuver will be
> > > 0x0 or 0xf.  I think that is not what we want there.
> > > Or am I missing something ?
> > As stated in the comment, when vPMU is not configured, the PMUVer
> > observed by the guest would be determined by arch flags bit
> > KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU. The value in the fields of idreg
> > doesn't matter. Here is just a trick to ignore the check for the
> > PMUVer field.
>
> That sounds like what I understand.  But, I still think the code is
> different from that.
> When we get here, this vcpu has no PMU. Since PMUVer in the @val is
> already validated earlier in this function, PMUVer in the @val is
> 0 or 0xf.  As this vcpu has no PMU, the "pmuver" (the current PMUVer
> for this vcpu) is also 0 or 0xf.  So, I wonder why the field in
> @val needs to be updated with the "pmuver".  Do you want to simply
> clear the field or do you mean IDREG() instead of read_id_reg() ?
Update the @val with the "pmuver" is to let the @val pass the
arm64_check_features called in set_id_reg. Otherwise, we need to keep
the code to check if PMUVer field is the only change. Marc has strong
objection to keep that code.
>
> Thank you,
> Reiji
>
> > >
> > >
> > > > +             val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > > > +             val |=3D FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuv=
er);
> > > > +     }
> > > >
> > > > -     if (valid_pmu) {
> > > > -             mutex_lock(&vcpu->kvm->arch.config_lock);
> > > > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ID_AA64DF=
R0_EL1_PMUVer_MASK;
> > > > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP=
(ID_AA64DFR0_EL1_PMUVer_MASK,
> > > > -                                                                 p=
muver);
> > > > +     mutex_lock(&vcpu->kvm->arch.config_lock);
> > > >
> > > > -             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ID_DFR0_EL1_P=
erfMon_MASK;
> > > > -             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(ID_=
DFR0_EL1_PerfMon_MASK,
> > > > -                                                             pmuve=
r_to_perfmon(pmuver));
> > > > +     ret =3D set_id_reg(vcpu, rd, val);
> > > > +     if (ret) {
> > > >               mutex_unlock(&vcpu->kvm->arch.config_lock);
> > > > -     } else {
> > > > +             return ret;
> > > > +     }
> > > > +
> > > > +     IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ID_DFR0_EL1_PerfMon_M=
ASK;
> > > > +     IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(ID_DFR0_EL1=
_PerfMon_MASK,
> > > > +                                                     pmuver_to_per=
fmon(pmuver));
> > > > +
> > > > +     if (!valid_pmu)
> > > >               assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu-=
>kvm->arch.flags,
> > > >                          pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_D=
EF);
> > > > -     }
> > > > +
> > > > +     mutex_unlock(&vcpu->kvm->arch.config_lock);
> > > >
> > > >       return 0;
> > > >  }
> > > >
> > > > +static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > > > +                                   const struct sys_reg_desc *rd)
> > > > +{
> > > > +     u64 val;
> > > > +     u32 id =3D reg_to_encoding(rd);
> > > > +
> > > > +     val =3D read_sanitised_ftr_reg(id);
> > > > +     /*
> > > > +      * Initialise the default PMUver before there is a chance to
> > > > +      * create an actual PMU.
> > > > +      */
> > > > +     val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > > > +     val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), =
kvm_arm_pmu_get_pmuver_limit());
> > > > +
> > > > +     return val;
> > > > +}
> > > > +
> > > >  static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > > >                          const struct sys_reg_desc *rd,
> > > >                          u64 val)
> > > >  {
> > > >       u8 perfmon, host_perfmon;
> > > >       bool valid_pmu;
> > > > +     int ret;
> > > >
> > > >       host_perfmon =3D pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_lim=
it());
> > > >
> > > > @@ -306,25 +433,33 @@ static int set_id_dfr0_el1(struct kvm_vcpu *v=
cpu,
> > > >       if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
> > > >               return -EINVAL;
> > > >
> > > > -     /* We can only differ with PerfMon, and anything else is an e=
rror */
> > > > -     val ^=3D read_id_reg(vcpu, rd);
> > > > -     val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > > > -     if (val)
> > > > -             return -EINVAL;
> > > > +     if (!valid_pmu) {
> > > > +             /*
> > > > +              * Ignore the PerfMon filed in @val. The PerfMon woul=
d be determined
> > > > +              * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_P=
MU,
> > > > +              */
> > >
> > > I have the same comment as set_id_aa64dfr0_el1().
> > >
> > > Thank you,
> > > Reiji
> > >
> > > > +             perfmon =3D FIELD_GET(ID_DFR0_EL1_PerfMon_MASK, read_=
id_reg(vcpu, rd));
> > > > +             val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > > > +             val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon=
);
> > > > +     }
> > > >
> > > > -     if (valid_pmu) {
> > > > -             mutex_lock(&vcpu->kvm->arch.config_lock);
> > > > -             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ID_DFR0_EL1_P=
erfMon_MASK;
> > > > -             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(ID_=
DFR0_EL1_PerfMon_MASK, perfmon);
> > > > +     mutex_lock(&vcpu->kvm->arch.config_lock);
> > > >
> > > > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ID_AA64DF=
R0_EL1_PMUVer_MASK;
> > > > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP=
(ID_AA64DFR0_EL1_PMUVer_MASK,
> > > > -                                                                 p=
erfmon_to_pmuver(perfmon));
> > > > +     ret =3D set_id_reg(vcpu, rd, val);
> > > > +     if (ret) {
> > > >               mutex_unlock(&vcpu->kvm->arch.config_lock);
> > > > -     } else {
> > > > +             return ret;
> > > > +     }
> > > > +
> > > > +     IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ID_AA64DFR0_EL1_P=
MUVer_MASK;
> > > > +     IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP(ID_AA64=
DFR0_EL1_PMUVer_MASK,
> > > > +                                                         perfmon_t=
o_pmuver(perfmon));
> > > > +
> > > > +     if (!valid_pmu)
> > > >               assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu-=
>kvm->arch.flags,
> > > >                          perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF)=
;
> > > > -     }
> > > > +
> > > > +     mutex_unlock(&vcpu->kvm->arch.config_lock);
> > > >
> > > >       return 0;
> > > >  }
> > > > @@ -402,9 +537,13 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM=
_ID_REG_NUM] =3D {
> > > >       /* CRm=3D1 */
> > > >       AA32_ID_SANITISED(ID_PFR0_EL1),
> > > >       AA32_ID_SANITISED(ID_PFR1_EL1),
> > > > -     { SYS_DESC(SYS_ID_DFR0_EL1), .access =3D access_id_reg,
> > > > -       .get_user =3D get_id_reg, .set_user =3D set_id_dfr0_el1,
> > > > -       .visibility =3D aa32_id_visibility, },
> > > > +     { SYS_DESC(SYS_ID_DFR0_EL1),
> > > > +       .access =3D access_id_reg,
> > > > +       .get_user =3D get_id_reg,
> > > > +       .set_user =3D set_id_dfr0_el1,
> > > > +       .visibility =3D aa32_id_visibility,
> > > > +       .reset =3D read_sanitised_id_dfr0_el1,
> > > > +       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > > >       ID_HIDDEN(ID_AFR0_EL1),
> > > >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> > > >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > > > @@ -433,8 +572,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM=
_ID_REG_NUM] =3D {
> > > >
> > > >       /* AArch64 ID registers */
> > > >       /* CRm=3D4 */
> > > > -     { SYS_DESC(SYS_ID_AA64PFR0_EL1), .access =3D access_id_reg,
> > > > -       .get_user =3D get_id_reg, .set_user =3D set_id_aa64pfr0_el1=
, },
> > > > +     { SYS_DESC(SYS_ID_AA64PFR0_EL1),
> > > > +       .access =3D access_id_reg,
> > > > +       .get_user =3D get_id_reg,
> > > > +       .set_user =3D set_id_aa64pfr0_el1,
> > > > +       .reset =3D read_sanitised_id_aa64pfr0_el1,
> > > > +       .val =3D ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_M=
ASK, },
> > > >       ID_SANITISED(ID_AA64PFR1_EL1),
> > > >       ID_UNALLOCATED(4, 2),
> > > >       ID_UNALLOCATED(4, 3),
> > > > @@ -444,8 +587,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM=
_ID_REG_NUM] =3D {
> > > >       ID_UNALLOCATED(4, 7),
> > > >
> > > >       /* CRm=3D5 */
> > > > -     { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access =3D access_id_reg,
> > > > -       .get_user =3D get_id_reg, .set_user =3D set_id_aa64dfr0_el1=
, },
> > > > +     { SYS_DESC(SYS_ID_AA64DFR0_EL1),
> > > > +       .access =3D access_id_reg,
> > > > +       .get_user =3D get_id_reg,
> > > > +       .set_user =3D set_id_aa64dfr0_el1,
> > > > +       .reset =3D read_sanitised_id_aa64dfr0_el1,
> > > > +       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > > >       ID_SANITISED(ID_AA64DFR1_EL1),
> > > >       ID_UNALLOCATED(5, 2),
> > > >       ID_UNALLOCATED(5, 3),
> > > > @@ -520,33 +667,4 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
> > > >
> > > >               IDREG(kvm, id) =3D val;
> > > >       }
> > > > -
> > > > -     /*
> > > > -      * The default is to expose CSV2 =3D=3D 1 if the HW isn't aff=
ected.
> > > > -      * Although this is a per-CPU feature, we make it global beca=
use
> > > > -      * asymmetric systems are just a nuisance.
> > > > -      *
> > > > -      * Userspace can override this as long as it doesn't promise
> > > > -      * the impossible.
> > > > -      */
> > > > -     val =3D IDREG(kvm, SYS_ID_AA64PFR0_EL1);
> > > > -
> > > > -     if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> > > > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > > > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL=
1_CSV2), 1);
> > > > -     }
> > > > -     if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> > > > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > > > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL=
1_CSV3), 1);
> > > > -     }
> > > > -
> > > > -     IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> > > > -
> > > > -     /*
> > > > -      * Initialise the default PMUver before there is a chance to
> > > > -      * create an actual PMU.
> > > > -      */
> > > > -     IDREG(kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE_MASK(ID_A=
A64DFR0_EL1_PMUVer);
> > > > -     IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP(ARM64_FEATURE=
_MASK(ID_AA64DFR0_EL1_PMUVer),
> > > > -                                                   kvm_arm_pmu_get=
_pmuver_limit());
> > > >  }
> > > > --
> > > > 2.40.0.348.gf938b09366-goog
> > > >
> > Thanks,
> > Jing
