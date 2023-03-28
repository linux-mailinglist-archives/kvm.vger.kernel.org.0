Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844B46CCAF6
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 21:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjC1TzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 15:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjC1TzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 15:55:01 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A71B1BE1
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:54:56 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id bi31so9882994oib.9
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680033295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oY2DefvwRjMVYZvNMynZ/BXtgK+qZddJQJabRj+b6wg=;
        b=tU0NKl9Uw3dwSuxQGdfcI//TWLhzZrf2U+SJ0M8hepFKei1tdLnfK5uuBXMptFbAdf
         DYGPUk3N3SlQ4aYDjox1Cwm57j2YbBGPFrciRk0Y9S6O//tRDZPq6iwmqMPUPh2pMaHH
         FsiBiIfDW18RSEUI24VQsnnVPRwpNBlIqeLI0Q4vni1SMfOcjoYIV/EAE6mtFbUKN6Td
         G6IeVoSiEE/EUIeg5rfMa6xd5aqAtGCI6U2EDRmhWlN4Sx/XdDrouHMBq7FKbDW/PM+A
         SzNmmhFEr5iEPzb39iDjktbHWBkP6WfRDwY+MmDInEZRqOd5OuzqentgNqveIeibb4r9
         Kmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680033295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oY2DefvwRjMVYZvNMynZ/BXtgK+qZddJQJabRj+b6wg=;
        b=y6dqVn7LkxS/knA42sGpOS2q67tc6SKl4LaP747ukcYxdhkGwdC15XQ4KGUBRMsTUa
         SxkhgK3TNO2REcAAmZrYwJVR+azOwMe9c7Vsx6NIhuluoFA4iH9dz7KSxnODW2KSFcnc
         FVcPqzGxv1xv2QgDXf6W8jQ1JN7qP++q7/6GqYep0d321ro87AzDoiosp9KAheF38k4d
         e6bCgg20v+apyi2oQJhz17PRuo5HFGmRY11uEjBREkwV9zmbi1xSHkVlcYHvXof+zuwB
         uFu0EuzEJIVDz9GBgcaUZQRbKaIe8qXFJdsLqkdAm2Ms9cpjt7tJZkvBGMM2BU6D9SBJ
         GArA==
X-Gm-Message-State: AO0yUKXjlb7DESjFhXP+i/FH2wCPCGcs6pWZrCbp5rc1OFEN2Q71ExqT
        ZdtCeZSn2tnYRLd1lR8Z9OXNzADO2Cy9TNPFF150uQ==
X-Google-Smtp-Source: AK7set8uSU3gun+sT9WnD+Q9CK8fW/xAHDHJwNRpmEpEn2GgFB0wqRVTKI5JR9NDXsz40fywXeN3qYOkqmqpV+aOD1s=
X-Received: by 2002:a05:6808:b38:b0:387:1afd:5924 with SMTP id
 t24-20020a0568080b3800b003871afd5924mr4722534oij.8.1680033295293; Tue, 28 Mar
 2023 12:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-4-jingzhangos@google.com> <86zg7ywkmd.wl-maz@kernel.org>
In-Reply-To: <86zg7ywkmd.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 28 Mar 2023 12:54:43 -0700
Message-ID: <CAAdAUtgEXdv1czttmTJZ6Thg1z-XPmbRP9i3EiYvQ9fH=FwRXA@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Use per guest ID register for ID_AA64PFR0_EL1.[CSV2|CSV3]
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

On Mon, Mar 27, 2023 at 3:32=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 17 Mar 2023 05:06:34 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > With per guest ID registers, ID_AA64PFR0_EL1.[CSV2|CSV3] settings from
> > userspace can be stored in its corresponding ID register.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h  |  2 --
> >  arch/arm64/kvm/arm.c               | 19 +------------------
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c |  7 +++----
> >  arch/arm64/kvm/id_regs.c           | 30 ++++++++++++++++++++++--------
> >  4 files changed, 26 insertions(+), 32 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index fb6b50b1f111..e926ea91a73c 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -230,8 +230,6 @@ struct kvm_arch {
> >
> >       cpumask_var_t supported_cpus;
> >
> > -     u8 pfr0_csv2;
> > -     u8 pfr0_csv3;
> >       struct {
> >               u8 imp:4;
> >               u8 unimp:4;
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 4579c878ab30..c78d68d011cb 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -104,22 +104,6 @@ static int kvm_arm_default_max_vcpus(void)
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
> > @@ -151,9 +135,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
> >       /* The maximum number of VCPUs is limited by the host's GIC model=
 */
> >       kvm->max_vcpus =3D kvm_arm_default_max_vcpus();
> >
> > -     set_default_spectre(kvm);
> > -     kvm_arm_init_hypercalls(kvm);
> >       kvm_arm_set_default_id_regs(kvm);
> > +     kvm_arm_init_hypercalls(kvm);
>
> Please document the ordering dependency between idregs and hypercalls.
I didn't see an ordering dependency here. The reason I put
kvm_arm_set_default_id_regs before kvm_arm_init_hypercalls is that
kvm_arm_set_default_id_regs includes the code in set_default_spectre.
>
> >
> >       /*
> >        * Initialise the default PMUver before there is a chance to
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nv=
he/sys_regs.c
> > index 08d2b004f4b7..0e1988740a65 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -93,10 +93,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu=
 *vcpu)
> >               PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
> >
> >       /* Spectre and Meltdown mitigation in KVM */
> > -     set_mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2)=
,
> > -                            (u64)kvm->arch.pfr0_csv2);
> > -     set_mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3)=
,
> > -                            (u64)kvm->arch.pfr0_csv3);
> > +     set_mask |=3D vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_E=
L1)] &
>
> This really want an accessor.
>
> > +             (ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> > +                     ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> >
> >       return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
> >  }
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index e393b5730557..b60ca1058301 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -61,12 +61,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
> >               if (!vcpu_has_sve(vcpu))
> >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE)=
;
> >               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V2),
> > -                               (u64)vcpu->kvm->arch.pfr0_csv2);
> > -             val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > -             val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CS=
V3),
> > -                               (u64)vcpu->kvm->arch.pfr0_csv3);
> >               if (kvm_vgic_global_state.type =3D=3D VGIC_V3) {
> >                       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC)=
;
> >                       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR=
0_EL1_GIC), 1);
> > @@ -201,6 +195,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcp=
u,
> >                              u64 val)
> >  {
> >       u8 csv2, csv3;
> > +     u64 sval =3D val;
> >
> >       /*
> >        * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> > @@ -225,8 +220,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcp=
u,
> >       if (val)
> >               return -EINVAL;
> >
> > -     vcpu->kvm->arch.pfr0_csv2 =3D csv2;
> > -     vcpu->kvm->arch.pfr0_csv3 =3D csv3;
> > +     vcpu->kvm->arch.id_regs[IDREG_IDX(reg_to_encoding(rd))] =3D sval;
>
> Accessor needed here to.
>
> >
> >       return 0;
> >  }
> > @@ -529,4 +523,24 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
> >               val =3D read_sanitised_ftr_reg(id);
> >               kvm->arch.id_regs[IDREG_IDX(id)] =3D val;
> >       }
> > +     /*
>
> Add a blank line after the closing bracket.
Will do.
>
> > +      * The default is to expose CSV2 =3D=3D 1 if the HW isn't affecte=
d.
> > +      * Although this is a per-CPU feature, we make it global because
> > +      * asymmetric systems are just a nuisance.
> > +      *
> > +      * Userspace can override this as long as it doesn't promise
> > +      * the impossible.
> > +      */
> > +     val =3D kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)];
>
> Accessor.
>
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
> > +     kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] =3D val;
>
> Accessor.
Sure, I'll use the macro IDREG() as in the last version of the patch series=
.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
