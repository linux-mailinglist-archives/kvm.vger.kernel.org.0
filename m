Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD24716C90
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 20:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjE3Sc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 14:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjE3ScW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 14:32:22 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76741102
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 11:32:15 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id 46e09a7af769-6af8aac7a2eso3491170a34.3
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 11:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685471534; x=1688063534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cheEfXaFj2n8kemDuWbwvrlht35ZpiS3kuINGwf+1Bo=;
        b=T0dIdCJ2NvfXxI03oPi/SrCqf51S5DNcI4eU4Ho1PdBB7c7d+q/YxKhIan0iinGw1s
         rj/x6zATnFTweiFMytx2nz9LjhrYmMT0ftxWR5UJQdr2/bSZLUkxAFk0b6j04uuDnojG
         vbDDjzVEO+F2mWzNvPBlYlud4mIvb+MZOmxP+RvF8MnLFJVJVie3u7CHqIuX3pStdUWU
         QjijlTtInBuJdJ7ymuH1LXNfWDTPP6k9aoi4BlMWaLld2cXc/RyArjAH8R5P2In7dnGQ
         xAgkZOjfBLJHKTwejbEwHi9DNVONuDrPnJLpI1YFDY1NhiLh6SY5mabA4YkdLERX1C43
         Bw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685471534; x=1688063534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cheEfXaFj2n8kemDuWbwvrlht35ZpiS3kuINGwf+1Bo=;
        b=NJdnJ/eoacdCAcZkwAIZmZfra/DHmoalWZftfobBY9LY8qNpGsPcORv6/87uGg47PZ
         BAvF8ck1eJS81dvQr0w4sgOigUavfXufyMaLDVCvgrmorLvR4NJPMRWhNt7xNwsrlyE9
         uigSeE5S9C8zXdAI8aEbCSALN2Pji7q2eFYH18c91Sv9NGwiiMrTxLKd/vDQrRUrrxWH
         UjLArRFuc8kg+jzSGtbC7GJc9NQts75JwrH9fqxO2UlMoXuuhyE8sVN5xhJO94PaLWDv
         deUrAGdsYpX00A0aFN6fr9ch/mCMk0Z6bd5M6pdRK5bfLDvE8Pe2FPheHAKlg5fopuOf
         Y8nw==
X-Gm-Message-State: AC+VfDxpODINn7qYqzY5tpqguld7q6JlmlnhJw/OK0QgNc4PlKUdntbI
        6v7U74OL2/sUhr59uwIprTfgr5+xjGFiiju4iDsAnA==
X-Google-Smtp-Source: ACHHUZ70ClM3dSCArz+o4nkMNyD3bDT6WfLodoMcSMoqXCcEQbAybY4oJZmZm5x5eUm9DMc+5bmJdJKxY4DvoZAjZ7c=
X-Received: by 2002:a05:6871:c10a:b0:19a:1571:f9dc with SMTP id
 yq10-20020a056871c10a00b0019a1571f9dcmr1557311oab.49.1685471534496; Tue, 30
 May 2023 11:32:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
 <20230522221835.957419-3-jingzhangos@google.com> <87sfbgoik6.wl-maz@kernel.org>
In-Reply-To: <87sfbgoik6.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 30 May 2023 11:32:02 -0700
Message-ID: <CAAdAUtgk7BBQEgUSwWWS+YmN5PmVkeU+NvaCJaZ-dEoxk4D06g@mail.gmail.com>
Subject: Re: [PATCH v10 2/5] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

On Sun, May 28, 2023 at 3:29=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 22 May 2023 23:18:32 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
> > userspace can be stored in its corresponding ID register.
> >
> > The setting of CSV bits for protected VMs are removed according to the
> > discussion from Fuad below:
> > https://lore.kernel.org/all/CA+EHjTwXA9TprX4jeG+-D+c8v9XG+oFdU1o6TSkvVy=
e145_OvA@mail.gmail.com
> >
> > Besides the removal of CSV bits setting for protected VMs, No other
> > functional change intended.
>
> One thing that you don't mention is the addition of some locking,
> which is a pretty significant change.
Will update the commit message.
>
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 --
> >  arch/arm64/kvm/arm.c              | 17 ---------
> >  arch/arm64/kvm/sys_regs.c         | 58 +++++++++++++++++++++++++------
> >  3 files changed, 47 insertions(+), 30 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 069606170c82..8a2fde6c04c4 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -257,8 +257,6 @@ struct kvm_arch {
> >
> >       cpumask_var_t supported_cpus;
> >
> > -     u8 pfr0_csv2;
> > -     u8 pfr0_csv3;
> >       struct {
> >               u8 imp:4;
> >               u8 unimp:4;
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 774656a0718d..5114521ace60 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -102,22 +102,6 @@ static int kvm_arm_default_max_vcpus(void)
> >       return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
> >  }
> >
> > -static void set_default_spectre(struct kvm *kvm)
> > -{
> > -     /*
> > -      * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> > -      * Although this is a per-CPU feature, we make it global because
> > -      * asymmetric systems are just a nuisance.
> > -      *
> > -      * Userspace can override this as long as it doesn't promise
> > -      * the impossible.
> > -      */
> > -     if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED)
> > -             kvm->arch.pfr0_csv2 =3D 1;
> > -     if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED)
> > -             kvm->arch.pfr0_csv3 =3D 1;
> > -}
> > -
> >  /**
> >   * kvm_arch_init_vm - initializes a VM data structure
> >   * @kvm:     pointer to the KVM struct
> > @@ -161,7 +145,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
> >       /* The maximum number of VCPUs is limited by the host's GIC model=
 */
> >       kvm->max_vcpus =3D kvm_arm_default_max_vcpus();
> >
> > -     set_default_spectre(kvm);
> >       kvm_arm_init_hypercalls(kvm);
> >       kvm_arm_init_id_regs(kvm);
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index d2ee3a1c7f03..9fb1c2f8f5a5 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1218,10 +1218,6 @@ static u64 kvm_arm_read_id_reg(const struct kvm_=
vcpu *vcpu, u32 id)
> >               if (!vcpu_has_sve(vcpu))
> >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE)=
;
> >               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2), (u64)vcpu->kvm->arch.pfr0_csv2);
> > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3), (u64)vcpu->kvm->arch.pfr0_csv3);
> >               if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
> >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC)=
;
> >                       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR=
0_EL1_GIC), 1);
> > @@ -1359,7 +1355,11 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *=
vcpu,
> >                              const struct sys_reg_desc *rd,
> >                              u64 val)
> >  {
> > +     struct kvm_arch *arch =3D &vcpu->kvm->arch;
>
> The use of kvm_arch as an anchor is very non-idiomatic. Use the kvm
> pointer for this if you must, but I'd rather you spell the whole thing
> out.
Sure, will spell the whole thing out.
>
> > +     u64 old_val =3D read_id_reg(vcpu, rd);
> > +     u64 new_val =3D val;
> >       u8 csv2, csv3;
> > +     int ret =3D 0;
> >
> >       /*
> >        * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> > @@ -1377,17 +1377,26 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu =
*vcpu,
> >           (csv3 && arm64_get_meltdown_state() !=3D SPECTRE_UNAFFECTED))
> >               return -EINVAL;
> >
> > +     mutex_lock(&arch->config_lock);
> >       /* We can only differ with CSV[23], and anything else is an error=
 */
> > -     val ^=3D read_id_reg(vcpu, rd);
> > +     val ^=3D old_val;
> >       val &=3D ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> >                ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> > -     if (val)
> > -             return -EINVAL;
> > -
> > -     vcpu->kvm->arch.pfr0_csv2 =3D csv2;
> > -     vcpu->kvm->arch.pfr0_csv3 =3D csv3;
> > +     if (val) {
> > +             ret =3D -EINVAL;
> > +             goto out;
> > +     }
> >
> > -     return 0;
> > +     /* Only allow userspace to change the idregs before VM running */
> > +     if (kvm_vm_has_ran_once(vcpu->kvm)) {
> > +             if (new_val !=3D old_val)
> > +                     ret =3D -EBUSY;
>
> This sort of check should be done exactly once in a central spot. For
> similar reasons, the config_lock should be take in a unique location
> so that we can actually reason about this globally rather than at a
> microscopic level.
>
> Something like this (which applies to the full series):
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b3eacfc592eb..e184b9350166 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1534,7 +1534,6 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcp=
u,
>                                const struct sys_reg_desc *rd,
>                                u64 val)
>  {
> -       struct kvm_arch *arch =3D &vcpu->kvm->arch;
>         u8 pmuver, host_pmuver;
>         bool valid_pmu;
>         int ret =3D 0;
> @@ -1557,14 +1556,6 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vc=
pu,
>         if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
>                 return -EINVAL;
>
> -       mutex_lock(&arch->config_lock);
> -       /* Only allow userspace to change the idregs before VM running */
> -       if (kvm_vm_has_ran_once(vcpu->kvm)) {
> -               if (val !=3D read_id_reg(vcpu, rd))
> -                       ret =3D -EBUSY;
> -               goto out;
> -       }
> -
>         if (!valid_pmu) {
>                 /*
>                  * Ignore the PMUVer field in @val. The PMUVer would be d=
etermined
> @@ -1592,7 +1583,6 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcp=
u,
>                            pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
>
>  out:
> -       mutex_unlock(&arch->config_lock);
>         return ret;
>  }
>
> @@ -1617,7 +1607,6 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>                            const struct sys_reg_desc *rd,
>                            u64 val)
>  {
> -       struct kvm_arch *arch =3D &vcpu->kvm->arch;
>         u8 perfmon, host_perfmon;
>         bool valid_pmu;
>         int ret =3D 0;
> @@ -1641,14 +1630,6 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>         if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
>                 return -EINVAL;
>
> -       mutex_lock(&arch->config_lock);
> -       /* Only allow userspace to change the idregs before VM running */
> -       if (kvm_vm_has_ran_once(vcpu->kvm)) {
> -               if (val !=3D read_id_reg(vcpu, rd))
> -                       ret =3D -EBUSY;
> -               goto out;
> -       }
> -
>         if (!valid_pmu) {
>                 /*
>                  * Ignore the PerfMon field in @val. The PerfMon would be=
 determined
> @@ -1676,7 +1657,6 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>                            perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF);
>
>  out:
> -       mutex_unlock(&arch->config_lock);
>         return ret;
>  }
>
> @@ -1690,11 +1670,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
rd,
>                       u64 *val)
>  {
> -       struct kvm_arch *arch =3D &vcpu->kvm->arch;
> -
> -       mutex_lock(&arch->config_lock);
>         *val =3D read_id_reg(vcpu, rd);
> -       mutex_unlock(&arch->config_lock);
>
>         return 0;
>  }
> @@ -1702,21 +1678,12 @@ static int get_id_reg(struct kvm_vcpu *vcpu, cons=
t struct sys_reg_desc *rd,
>  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
rd,
>                       u64 val)
>  {
> -       struct kvm_arch *arch =3D &vcpu->kvm->arch;
>         u32 id =3D reg_to_encoding(rd);
>         int ret =3D 0;
>
> -       mutex_lock(&arch->config_lock);
> -       /* Only allow userspace to change the idregs before VM running */
> -       if (kvm_vm_has_ran_once(vcpu->kvm)) {
> -               if (val !=3D read_id_reg(vcpu, rd))
> -                       ret =3D -EBUSY;
> -       } else {
> -               ret =3D arm64_check_features(vcpu, rd, val);
> -               if (!ret)
> -                       IDREG(vcpu->kvm, id) =3D val;
> -       }
> -       mutex_unlock(&arch->config_lock);
> +       ret =3D arm64_check_features(vcpu, rd, val);
> +       if (!ret)
> +               IDREG(vcpu->kvm, id) =3D val;
>
>         return ret;
>  }
> @@ -3438,6 +3405,9 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, con=
st struct kvm_one_reg *reg,
>         if (!r || sysreg_hidden_user(vcpu, r))
>                 return -ENOENT;
>
> +       if (is_id_reg(reg_to_encoding(r)))
> +               mutex_lock(&vcpu->kvm->arch.config_lock);
> +
>         if (r->get_user) {
>                 ret =3D (r->get_user)(vcpu, r, &val);
>         } else {
> @@ -3445,6 +3415,9 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, con=
st struct kvm_one_reg *reg,
>                 ret =3D 0;
>         }
>
> +       if (is_id_reg(reg_to_encoding(r)))
> +               mutex_unlock(&vcpu->kvm->arch.config_lock);
> +
>         if (!ret)
>                 ret =3D put_user(val, uaddr);
>
> @@ -3482,9 +3455,21 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, co=
nst struct kvm_one_reg *reg,
>         if (!r || sysreg_hidden_user(vcpu, r))
>                 return -ENOENT;
>
> +       /* Only allow userspace to change the idregs before VM running */
> +       if (is_id_reg(reg_to_encoding(r)) &&
> +           kvm_vm_has_ran_once(vcpu->kvm)) {
> +               if (val =3D=3D read_id_reg(vcpu, r))
> +                       return 0;
> +               return -EBUSY;
> +       }
> +
>         if (sysreg_user_write_ignore(vcpu, r))
>                 return 0;
>
> +       /* ID regs are global to the VM and cannot be updated concurrentl=
y */
> +       if (is_id_reg(reg_to_encoding(r)))
> +               mutex_lock(&vcpu->kvm->arch.config_lock);
> +
>         if (r->set_user) {
>                 ret =3D (r->set_user)(vcpu, r, val);
>         } else {
> @@ -3492,6 +3477,9 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, con=
st struct kvm_one_reg *reg,
>                 ret =3D 0;
>         }
>
> +       if (is_id_reg(reg_to_encoding(r)))
> +               mutex_unlock(&vcpu->kvm->arch.config_lock);
> +
>         return ret;
>  }
>
> and you can then restore the code to its original shape, as there is
> no need to change the control flow anymore.
Thanks. Will do as you suggested.
>
> > +     } else {
> > +             IDREG(vcpu->kvm, reg_to_encoding(rd)) =3D new_val;
> > +     }
> > +out:
> > +     mutex_unlock(&arch->config_lock);
> > +     return ret;
> >  }
> >
> >  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > @@ -1479,7 +1488,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu=
,
> >  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *rd,
> >                     u64 *val)
> >  {
>
> Right above this function is a comment that says the idreg are
> immutable. Time to revisit it?
Will update the comment.
>
> > +     struct kvm_arch *arch =3D &vcpu->kvm->arch;
> > +
> > +     mutex_lock(&arch->config_lock);
> >       *val =3D read_id_reg(vcpu, rd);
> > +     mutex_unlock(&arch->config_lock);
> > +
> >       return 0;
> >  }
> >
> > @@ -3364,6 +3378,7 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
> >  {
> >       const struct sys_reg_desc *idreg;
> >       struct sys_reg_params params;
> > +     u64 val;
> >       u32 id;
> >
> >       /* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
> > @@ -3386,6 +3401,27 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
> >               idreg++;
> >               id =3D reg_to_encoding(idreg);
> >       }
> > +
> > +     /*
> > +      * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> > +      * Although this is a per-CPU feature, we make it global because
> > +      * asymmetric systems are just a nuisance.
> > +      *
> > +      * Userspace can override this as long as it doesn't promise
> > +      * the impossible.
> > +      */
> > +     val =3D IDREG(kvm, SYS_ID_AA64PFR0_EL1);
> > +
> > +     if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > +             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2), 1);
> > +     }
> > +     if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > +             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3), 1);
> > +     }
> > +
> > +     IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> >  }
> >
> >  int __init kvm_sys_reg_table_init(void)
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
Thanks,
Jing
