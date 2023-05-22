Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0562B70C42D
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 19:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjEVRXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 13:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjEVRXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 13:23:47 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31766D2
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 10:23:46 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-19a77e4c8dcso1839832fac.1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 10:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684776225; x=1687368225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZSnv4bli4iV2Esr3aUCBY1DaTSt3snZyODc48A9xgyA=;
        b=aY5tSnr4cGu4IFnIKfJbzyju0pLLFUmd0ga76OzTL3wdayvWC4Gk/Xj/8j8iItftbd
         EdCwKhr30AUvlDll1HlVfSiSX/nUP0lr1QfPEy71SRXckWb0G3VODJyXxzsqHim3oo6F
         CNwn0seOWyfBwyu+IGRDmP6ZFmA2hnPQvW+DbWEvRidzhIMSdQV6DbIZ/Dya2oQ3vN2e
         2KIlpoqovw5Mj5iY7d4Da2wzFJL6Wrmf9llEFBYNMqCWuFyoQ2gWksNnfavNhxHBTqa4
         j5uy/N3bxFS3tOgFjdu/y6HTMasH3E0UG/0OlnFUVzY22BJ3+IK6GKVxrLzIv9Z8K1Nw
         mY2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684776225; x=1687368225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZSnv4bli4iV2Esr3aUCBY1DaTSt3snZyODc48A9xgyA=;
        b=KOp763X7f2sgs5rDIyirqsUBgNT6lhBQKrty2EUHZ1TrUtnnlp6a1lclKw8qwrqw5q
         7OZl4xRjLgltiP3G38vM4abGeeeN4RjdlrAYI66wp1suIhyuTm69+UdsB8sY7S2RyPq6
         gNacyk+kFxgxkmcoybjthJf//QSFHism5Wa1g31naXgsIOOzsPH0WxFqNY4GTdHJ+Ki7
         Vz1aogzNivOEFo3PYJBlTKzU3PpT+YNa/jFRBWtMvnDnCUV9VFtk2QJY5zHk0j/GMXAU
         8izC1iDvcLlTIbNmwY00WsWt5O8HF8n1WLXRVjxFsqizLvAGyEcJ1ksbqdzKzwM330X4
         lMEQ==
X-Gm-Message-State: AC+VfDz7gMPwT85St2RbzJEDJ2fq7xi/27MQOhR/2NuDcbkw07HWJaNP
        pmfEgWUT4kG6mfsiUxIQMmuiD9P8f9LGcSowdh7fVg==
X-Google-Smtp-Source: ACHHUZ6MLvfCVG9nQp7PdVIJL5YnAE8tq9A8vpLKtTS0GfSy0R18AoJuXZc4fmu0FfMk67m24giFPh9Y66ocsezlSSs=
X-Received: by 2002:a05:6871:3d4:b0:18e:a08d:188e with SMTP id
 a20-20020a05687103d400b0018ea08d188emr5451995oag.34.1684776225350; Mon, 22
 May 2023 10:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
 <20230517061015.1915934-3-jingzhangos@google.com> <20230519235225.jotppbswdvmjcanj@google.com>
In-Reply-To: <20230519235225.jotppbswdvmjcanj@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 22 May 2023 10:23:34 -0700
Message-ID: <CAAdAUtgaKwEkSCo0DbenQ3pkCXJyCyr+Jo4RVd2UiN381HswmQ@mail.gmail.com>
Subject: Re: [PATCH v9 2/5] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

On Fri, May 19, 2023 at 4:52=E2=80=AFPM Reiji Watanabe <reijiw@google.com> =
wrote:
>
> Hi Jing,
>
> On Wed, May 17, 2023 at 06:10:11AM +0000, Jing Zhang wrote:
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
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 --
> >  arch/arm64/kvm/arm.c              | 17 ----------
> >  arch/arm64/kvm/sys_regs.c         | 55 +++++++++++++++++++++++++------
> >  3 files changed, 45 insertions(+), 29 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 949a4a782844..07f0e091ae48 100644
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
> > index d2ee3a1c7f03..3c52b136ade3 100644
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
> > @@ -1359,7 +1355,10 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *=
vcpu,
> >                              const struct sys_reg_desc *rd,
> >                              u64 val)
> >  {
> > +     struct kvm_arch *arch =3D &vcpu->kvm->arch;
> > +     u64 sval =3D val;
> >       u8 csv2, csv3;
> > +     int ret =3D 0;
> >
> >       /*
> >        * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> > @@ -1377,17 +1376,26 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu =
*vcpu,
> >           (csv3 && arm64_get_meltdown_state() !=3D SPECTRE_UNAFFECTED))
> >               return -EINVAL;
> >
> > +     mutex_lock(&arch->config_lock);
> >       /* We can only differ with CSV[23], and anything else is an error=
 */
> >       val ^=3D read_id_reg(vcpu, rd);
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
> > +     if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm->arch.flags))=
 {
>
> How about using kvm_vm_has_ran_once() instead ?
Sure.
>
>
> > +             if (sval !=3D read_id_reg(vcpu, rd))
>
> Rather than calling read_id_reg() twice in this function,
> perhaps you might want to save the original val we got earlier
> and re-use it here ?
Will do.
>
> Thank you,
> Reiji
>
>
>
>
> > +                     ret =3D -EBUSY;
> > +     } else {
> > +             IDREG(vcpu->kvm, reg_to_encoding(rd)) =3D sval;
> > +     }
> > +out:
> > +     mutex_unlock(&arch->config_lock);
> > +     return ret;
> >  }
> >
> >  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > @@ -1479,7 +1487,12 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu=
,
> >  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *rd,
> >                     u64 *val)
> >  {
> > +     struct kvm_arch *arch =3D &vcpu->kvm->arch;
> > +
> > +     mutex_lock(&arch->config_lock);
> >       *val =3D read_id_reg(vcpu, rd);
> > +     mutex_unlock(&arch->config_lock);
> > +
> >       return 0;
> >  }
> >
> > @@ -3364,6 +3377,7 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
> >  {
> >       const struct sys_reg_desc *idreg;
> >       struct sys_reg_params params;
> > +     u64 val;
> >       u32 id;
> >
> >       /* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
> > @@ -3386,6 +3400,27 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
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
> > --
> > 2.40.1.606.ga4b1b128d6-goog
> >
Thanks,
Jing
