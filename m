Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCC26CC96F
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjC1Rhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjC1RhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:37:11 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED773D520
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:37:09 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-17786581fe1so13497713fac.10
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 10:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680025029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1lTYmIUfv1W+dqnUwKGNp7rACY3uUecXu2kNzZOYCLI=;
        b=qz6FcSeo97dliuna9F7YRpmbFP/weEV7V2we2vRFKVVZI0Ko0QKsI+I7QsGAycwf7Y
         Fem0ieifDbSiTvUSGOEEFUR+M6FiWGa7IOqZl5y3T8Psme2MksRyNyis+yhEmDi4W4Os
         ZBvE5uXXNQDxmcRPviifXO+gGahYzaX22fe7GQKUzisUpwU8DC4YM+YmOHLZFUFhbu/+
         /gqV/36l75zM75tDvQl0kF5ZxyoHtzRxTgXzTGYXmgoaPmOQNrJ72rxWja/YuFheayFo
         IF1TpjtjCIFxCM7igdVV4uAcWfSBH/a1p9fJorNMKFbDqt8LGUgqXZA6gE/zXWFqU/8f
         nRfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680025029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1lTYmIUfv1W+dqnUwKGNp7rACY3uUecXu2kNzZOYCLI=;
        b=U2FxLXS3Jbk9AP86Vad5bbKwlaDGgYVsxb7krq7EWsD6VfnTaMFaAI2UBo4c5ckWUT
         mhR6aCr3WnF5pKX1zDLSNf9ThIOVUuN8vFp5cTGo9jVuu4ThF568OYJ/fKjHiaWoA7JX
         KuIfu/taTlLxlYxGhZVrLfn2d3TXhjKpYDxUkcl+6NvsBKoDE7gsEDRyiRQpsVaf0MLO
         c95IAlWwrIHaH6w7+NwY2pPn1+mZlcygaV8TYIUndi5M4NEfcHwluJsM1Bjbf/qjHzUw
         tE1PdQhYjtyAZuwX87YxyQZgIUQCzAIvWB+Wg8/i1YkvJRY0Gjp2LEcENkhWbAh2fG0A
         Vziw==
X-Gm-Message-State: AO0yUKX+GDwWLoWkCNr0TWojFegm8ZMc2ZCNG2wqCbSKYp4j/pPyvOib
        vPA1S1lHV4Ho9gtvplhWp/3MuxBb7x0rTLZkfo7a9A==
X-Google-Smtp-Source: AK7set+fEuf/FOU/+P6LwC0uwTggf0IUKykQmKlVYk6BhMuiCYdyVzzyK+qYf6Ft8C09WvltixkIOfy2FN53Wfqgky4=
X-Received: by 2002:a05:6871:8891:b0:17e:7304:6a98 with SMTP id
 tg17-20020a056871889100b0017e73046a98mr5315022oab.8.1680025029124; Tue, 28
 Mar 2023 10:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-3-jingzhangos@google.com> <861qlaxzyw.wl-maz@kernel.org>
In-Reply-To: <861qlaxzyw.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 28 Mar 2023 10:36:58 -0700
Message-ID: <CAAdAUtjp1tdyadjtU0RrdsRq-D3518G8eqP_coYNJ1vFEvrz2Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: Save ID registers' sanitized value per guest
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

On Mon, Mar 27, 2023 at 3:15=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 17 Mar 2023 05:06:33 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> > and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> > Use the saved ones when ID registers are read by the guest or
> > userspace (via KVM_GET_ONE_REG).
> >
> > No functional change intended.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Co-developed-by: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 11 ++++++++
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/id_regs.c          | 44 ++++++++++++++++++++++++-------
> >  arch/arm64/kvm/sys_regs.c         |  2 +-
> >  arch/arm64/kvm/sys_regs.h         |  1 +
> >  5 files changed, 49 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index a1892a8f6032..fb6b50b1f111 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -245,6 +245,15 @@ struct kvm_arch {
> >        * the associated pKVM instance in the hypervisor.
> >        */
> >       struct kvm_protected_vm pkvm;
> > +
> > +     /*
> > +      * Save ID registers for the guest in id_regs[].
> > +      * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in i=
t
> > +      * is (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > +      */
> > +#define KVM_ARM_ID_REG_NUM   56
> > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) << 3) | s=
ys_reg_Op2(id))
> > +     u64 id_regs[KVM_ARM_ID_REG_NUM];
>
> Place these registers in their own structure, and place this structure
> *before* the pvm structure. Document what guards these registers when
> updated (my hunch is that this should rely on Oliver's locking fixes
> if the update comes from a vcpu).
Sure, I will put them in their own structure and place it before the
pkvm structure.
IIUC, usually we don't need a specific locking to update idregs here.
All idregs are 64 bit and can be read/written atomically. The only
case that may need a locking is to keep the consistency for PMUVer in
AA64DFR0_EL1 and PerfMon in DFR0_EL1. If there is no use case for two
VCPU threads in a VM to update PMUVer and PerfMon concurrently, then
we don't need the locking as in later patch by using the kvm lock.
WDTY?
>
> >  };
> >
> >  struct kvm_vcpu_fault_info {
> > @@ -1005,6 +1014,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *v=
cpu,
> >  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >                               struct kvm_arm_copy_mte_tags *copy_tags);
> >
> > +void kvm_arm_set_default_id_regs(struct kvm *kvm);
> > +
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf087..4579c878ab30 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -153,6 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)
> >
> >       set_default_spectre(kvm);
> >       kvm_arm_init_hypercalls(kvm);
> > +     kvm_arm_set_default_id_regs(kvm);
> >
> >       /*
> >        * Initialise the default PMUver before there is a chance to
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index 08b738852955..e393b5730557 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -52,16 +52,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
> >       }
> >  }
> >
> > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
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
> > +     u64 val =3D vcpu->kvm->arch.id_regs[IDREG_IDX(id)];
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
> > @@ -504,3 +505,28 @@ int kvm_arm_walk_id_regs(struct kvm_vcpu *vcpu, u6=
4 __user *uind)
> >       }
> >       return total;
> >  }
> > +
> > +/*
> > + * Set the guest's ID registers that are defined in id_reg_descs[]
> > + * with ID_SANITISED() to the host's sanitized value.
> > + */
> > +void kvm_arm_set_default_id_regs(struct kvm *kvm)
> > +{
> > +     int i;
> > +     u32 id;
> > +     u64 val;
> > +
> > +     for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > +             id =3D reg_to_encoding(&id_reg_descs[i]);
> > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > +                     /* Shouldn't happen */
> > +                     continue;
> > +
> > +             if (id_reg_descs[i].visibility =3D=3D raz_visibility)
> > +                     /* Hidden or reserved ID register */
> > +                     continue;
>
> Relying on function pointer comparison is really fragile. If I wrap
> raz_visibility() in another function, this won't catch it. It also
> doesn't bode well with your 'inline' definition of this function.
>
> More importantly, why do we care about checking for visibility at all?
> We can happily populate the array and rely on the runtime visibility.
Right. I'll remove this checking.
>
> > +
> > +             val =3D read_sanitised_ftr_reg(id);
> > +             kvm->arch.id_regs[IDREG_IDX(id)] =3D val;
> > +     }
> > +}
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
