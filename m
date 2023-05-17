Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C01F706E26
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 18:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjEQQ2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 12:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjEQQ2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 12:28:43 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8559B2709
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 09:28:39 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-394c7ba4cb5so376225b6e.1
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 09:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684340919; x=1686932919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3QgUHhC4JatePpcTmhPB3qhllcSFBfrYsd2mZsiUSGc=;
        b=vForUt72iRFRfuNzyPSOkOdHSHW+KeeVPAQzYm8GDTh4fK7hhWNqnDnU8JNPrLzexH
         0bMUs0d8vmQwHReADr5ObxWyXaOFcass3YqBtHgor4veie2rAjny7MrgJlualP6RHgWR
         rFadfAj7xtIIntrNuHZeveXA8bDM/hYhMHkX7eoWvI1CkK6gfn9Kx6flDkntHHaoAsbO
         yWjXfQ4CpcK5385D1AeiOFUh8+rIzivtuA+jiq4iiX3HadlPZklW7dy/b+67Q0pFtvrh
         4gB8c40wgz8kD8J1gV11P85VsbCjJfCL8ldHwBMVXjqaurDgM1X1MoyMktE/RvbLTt5r
         Ot/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684340919; x=1686932919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3QgUHhC4JatePpcTmhPB3qhllcSFBfrYsd2mZsiUSGc=;
        b=ec876i9JuIIDC6GjymvCasMH2LT+B80EQGYFKYY7Ljlgs4cTRj5yCWPWR4awaiCEmf
         w7tyiNqapqT1/+Re9NTEk4MZRrGAq4W5pbRjXjed7khEXT3bK3mOtQgRgrEiixkPozxl
         YuFwVKqVnB7mVAUpS3HBOOuWgO7mvT8lZE3WS2vsTKGF53pD2YC4CEL1aqu1XuCPT/zk
         Mu6tgKFbT375xurvR8LyK8otz3vLL/HDVCOsmegLQQkQVuHTkFrfhOk9PlQ9CxvwuDvH
         RZ5hJ73iN12QS4L0v7CmJLPi/AC0Qi9l9rGTEgj0edKWdG/OEEsCkoURp+86vhg8E63C
         LLrg==
X-Gm-Message-State: AC+VfDz/k9n0rA9OPxzE81VutDd48R2rdjEsjnBsOgB4R5HMbo8izJFt
        dBxX+SyUzauFiTq+102jnb7gsAPxmqAtHEpVGm+EVD9gssTsg+A7aUc=
X-Google-Smtp-Source: ACHHUZ5B62w2XtjEh1j0FNvdywiAs5+OnqxjGaWSdNJK+6Pq2+zsclWBeVt3S+tVM3V1rTWfp8jDzER1615TvtFA0iY=
X-Received: by 2002:a05:6808:1599:b0:396:63a:a715 with SMTP id
 t25-20020a056808159900b00396063aa715mr6419455oiw.56.1684340918674; Wed, 17
 May 2023 09:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <20230503171618.2020461-3-jingzhangos@google.com> <86wn17l811.wl-maz@kernel.org>
In-Reply-To: <86wn17l811.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 17 May 2023 09:28:26 -0700
Message-ID: <CAAdAUtiiXNLJKXLea1okB25i45FtM52umY2P5WgKxZ1dHz5CYg@mail.gmail.com>
Subject: Re: [PATCH v8 2/6] KVM: arm64: Save ID registers' sanitized value per guest
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

Hi Marc,

On Wed, May 17, 2023 at 12:41=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Wed, 03 May 2023 18:16:14 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> > and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> > Use the saved ones when ID registers are read by the guest or
> > userspace (via KVM_GET_ONE_REG).
> >
> > No functional change intended.
> >
> > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 20 ++++++++++++++
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/id_regs.c          | 46 +++++++++++++++++++++++++------
> >  arch/arm64/kvm/sys_regs.c         | 11 +++++++-
> >  arch/arm64/kvm/sys_regs.h         |  3 +-
> >  5 files changed, 69 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index bcd774d74f34..a7d4d9e093e3 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -177,6 +177,21 @@ struct kvm_smccc_features {
> >       unsigned long vendor_hyp_bmap;
> >  };
> >
> > +/*
> > + * Emulated CPU ID registers per VM
> > + * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> > + * is (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > + *
> > + * These emulated idregs are VM-wide, but accessed from the context of=
 a vCPU.
> > + * Access to id regs are guarded by kvm_arch.config_lock.
> > + */
> > +#define KVM_ARM_ID_REG_NUM   56
>
> You already have this as part of patch #1 in another include file, and
> then move it here. Surely you can do that in one go. I'd also like it
> to be defined in terms of encodings, and not as a raw value.
Sure, will do.
>
> > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) << 3) | s=
ys_reg_Op2(id))
> > +#define IDREG(kvm, id)               kvm->arch.idregs.regs[IDREG_IDX(i=
d)]
>
> Missing brackets around 'kvm'.
Thanks, will fix.
>
> > +struct kvm_idregs {
> > +     u64 regs[KVM_ARM_ID_REG_NUM];
> > +};
> > +
> >  typedef unsigned int pkvm_handle_t;
> >
> >  struct kvm_protected_vm {
> > @@ -243,6 +258,9 @@ struct kvm_arch {
> >       /* Hypercall features firmware registers' descriptor */
> >       struct kvm_smccc_features smccc_feat;
> >
> > +     /* Emulated CPU ID registers */
> > +     struct kvm_idregs idregs;
> > +
> >       /*
> >        * For an untrusted host VM, 'pkvm.handle' is used to lookup
> >        * the associated pKVM instance in the hypervisor.
> > @@ -1008,6 +1026,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *v=
cpu,
> >  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >                               struct kvm_arm_copy_mte_tags *copy_tags);
> >
> > +void kvm_arm_init_id_regs(struct kvm *kvm);
> > +
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 4b2e16e696a8..e34744c36406 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -153,6 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
> >
> >       set_default_spectre(kvm);
> >       kvm_arm_init_hypercalls(kvm);
> > +     kvm_arm_init_id_regs(kvm);
> >
> >       /*
> >        * Initialise the default PMUver before there is a chance to
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index 96b4c43a5100..e769223bcee2 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -52,16 +52,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
> >       }
> >  }
> >
> > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
>
> Why getting rid of this comment instead of moving it next to the
> (re-implemented) function?
>
Right, will move it to the re-implemented function.
> > -static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_des=
c const *r)
> > +u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >  {
> > -     u32 id =3D reg_to_encoding(r);
> > -     u64 val;
> > -
> > -     if (sysreg_visible_as_raz(vcpu, r))
> > -             return 0;
> > -
> > -     val =3D read_sanitised_ftr_reg(id);
> > +     u64 val =3D IDREG(vcpu->kvm, id);
> >
> >       switch (id) {
> >       case SYS_ID_AA64PFR0_EL1:
> > @@ -126,6 +119,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu=
, struct sys_reg_desc const *r
> >       return val;
> >  }
> >
> > +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_des=
c const *r)
> > +{
> > +     if (sysreg_visible_as_raz(vcpu, r))
> > +             return 0;
> > +
> > +     return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
> > +}
> > +
> >  /* cpufeature ID register access trap handlers */
> >
> >  static bool access_id_reg(struct kvm_vcpu *vcpu,
> > @@ -458,3 +459,30 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct s=
ys_reg_params *params)
> >
> >       return 1;
> >  }
> > +
> > +/*
> > + * Set the guest's ID registers that are defined in id_reg_descs[]
> > + * with ID_SANITISED() to the host's sanitized value.
> > + */
> > +void kvm_arm_init_id_regs(struct kvm *kvm)
> > +{
> > +     u64 val;
> > +     u32 id;
> > +     int i;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > +             id =3D reg_to_encoding(&id_reg_descs[i]);
> > +
> > +             /*
> > +              * Some hidden ID registers which are not in arm64_ftr_re=
gs[]
> > +              * would cause warnings from read_sanitised_ftr_reg().
> > +              * Skip those ID registers to avoid the warnings.
> > +              */
> > +             if (id_reg_descs[i].visibility =3D=3D raz_visibility)
> > +                     /* Hidden or reserved ID register */
> > +                     continue;
>
> Are you sure? What about other visibility attributes that are normally
> evaluated at runtime? This may work as a short term hack, but I'm not
> sure this is the correct long-term solution...
Yes, this is a short term hack. It would be replaced by checking the
reset() function of idregs in patch #5 in this series.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
