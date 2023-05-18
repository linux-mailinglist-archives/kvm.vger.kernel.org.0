Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F73708898
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 21:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjERTtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 15:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjERTtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 15:49:06 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A97E6A
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:49:04 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-19a36435e81so34742fac.1
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 12:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684439343; x=1687031343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qk5Lbn69kj1bFKsvMlF20IOUXzLua8Iu4G9yP2dd/EI=;
        b=ocpMoi9fjhzQm3NNFbZ+ww90Vj1QVzcRB2U3Cch/3Klr+98dL/qQpASmVM6l1yBgbS
         4YE0cawWM6wZOLdoI4HQeRJchBwHWxFWQYWCTIi0MpttqTyhczoez6zvgeH22GZo6tl6
         /3g4i/YGmUB4IW50qRs5ssMjjSk9LhI7mSmicOoHe935Nbsxipc9Ym8xi3jzAkp9KwQt
         LreKwk66mFuQ99m1bGocWw+bRGzrCIKub6tOqhFdw3X79L2HBV6L20kwJD04yqbIgoYV
         rSoU0ZrSP/d7yMgD6pMfx/3H7EHOl5AzhhPwtcMQt8ZisgEHgFypqMf5ZX1hYW64Ko8e
         WoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684439343; x=1687031343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qk5Lbn69kj1bFKsvMlF20IOUXzLua8Iu4G9yP2dd/EI=;
        b=et60YqMkJ+i7gVh5fNRgmh00ta9Xg5mDcy4+OZHngJSKuo/GmAJBEdhLjpuZwdKx84
         IbmqZs+sZ/ZdQwn4uNY4Bkin+8OUkJUGOoYnxciZwlqFTGTHesS23YRoTCzTIczV95Hy
         0LqaCp5bLiDK7oAmjh4kqplvjyPVJZhsHwnTFiwuU77RwFcUe5xvroh7414rSKvoHlrY
         Hsm9h3ttJ7tr1mBOrWzzJf7h3y8sn9xAVE7GoVQHlnffCS2LabSGQgry8WgEvU224GrL
         oLnRJVei02cswXV5H5ecdUXMHENV6YTDvBT7YDdcysy/sCmCF8b1Hsx077Nah/d2IbQM
         QWCg==
X-Gm-Message-State: AC+VfDxBQTv9KtX1OpsJ13NisnIalU8kskpsRLua46XuBMBolo3sSkKm
        jjobCEkJo4tA9kiNXikO8aWdhjWjo3W4zOfPNMH0bA==
X-Google-Smtp-Source: ACHHUZ7HZXZEIv1lu9n48kvOiudc6d5E1YViqp6VaQGEmYLbUhtgMlmViU3shS53V91FoJDQGcNClrUp/aobJ8o6oMw=
X-Received: by 2002:a05:6870:9565:b0:196:37ab:95e9 with SMTP id
 v37-20020a056870956500b0019637ab95e9mr148775oal.8.1684439343565; Thu, 18 May
 2023 12:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
 <20230517061015.1915934-2-jingzhangos@google.com> <2e727b02fe9141098ed474ef49ddc495@huawei.com>
In-Reply-To: <2e727b02fe9141098ed474ef49ddc495@huawei.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 18 May 2023 12:48:52 -0700
Message-ID: <CAAdAUtiWkqaymY3e3=m3YHw9FNGYf6rsFsAVkFKpUh-p9nd+gQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized value per guest
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
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

Hi Shameerali,

On Thu, May 18, 2023 at 12:17=E2=80=AFAM Shameerali Kolothum Thodi
<shameerali.kolothum.thodi@huawei.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Jing Zhang [mailto:jingzhangos@google.com]
> > Sent: 17 May 2023 07:10
> > To: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
> > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
> > <maz@kernel.org>; Oliver Upton <oupton@google.com>
> > Cc: Will Deacon <will@kernel.org>; Paolo Bonzini <pbonzini@redhat.com>;
> > James Morse <james.morse@arm.com>; Alexandru Elisei
> > <alexandru.elisei@arm.com>; Suzuki K Poulose <suzuki.poulose@arm.com>;
> > Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
> > Raghavendra Rao Ananta <rananta@google.com>; Jing Zhang
> > <jingzhangos@google.com>
> > Subject: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized value =
per
> > guest
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
> >  arch/arm64/include/asm/kvm_host.h | 20 +++++++++
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/sys_regs.c         | 69
> > +++++++++++++++++++++++++------
> >  arch/arm64/kvm/sys_regs.h         |  7 ++++
> >  4 files changed, 85 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h
> > b/arch/arm64/include/asm/kvm_host.h
> > index 7e7e19ef6993..949a4a782844 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -178,6 +178,21 @@ struct kvm_smccc_features {
> >       unsigned long vendor_hyp_bmap;
> >  };
> >
> > +/*
> > + * Emulated CPU ID registers per VM
> > + * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> > + * is (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > + *
> > + * These emulated idregs are VM-wide, but accessed from the context of=
 a
> > vCPU.
> > + * Access to id regs are guarded by kvm_arch.config_lock.
> > + */
> > +#define KVM_ARM_ID_REG_NUM   56
> > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) << 3) | s=
ys_reg_Op2(id))
> > +#define IDREG(kvm, id)               ((kvm)->arch.idregs.regs[IDREG_ID=
X(id)])
> > +struct kvm_idregs {
> > +     u64 regs[KVM_ARM_ID_REG_NUM];
> > +};
> >
>
> Not sure we really need this struct here. Why can't this array be moved t=
o
> struct kvm_arch directly?
It was put in kvm_arch directly before, then got into its own
structure in v5 according to the comments here:
https://lore.kernel.org/all/861qlaxzyw.wl-maz@kernel.org/#t
>
> >  typedef unsigned int pkvm_handle_t;
> >
> >  struct kvm_protected_vm {
> > @@ -253,6 +268,9 @@ struct kvm_arch {
> >       struct kvm_smccc_features smccc_feat;
> >       struct maple_tree smccc_filter;
> >
> > +     /* Emulated CPU ID registers */
> > +     struct kvm_idregs idregs;
> > +
> >       /*
> >        * For an untrusted host VM, 'pkvm.handle' is used to lookup
> >        * the associated pKVM instance in the hypervisor.
> > @@ -1045,6 +1063,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm
> > *kvm,
> >  int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> >                                   struct kvm_arm_counter_offset *offset=
);
> >
> > +void kvm_arm_init_id_regs(struct kvm *kvm);
> > +
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 14391826241c..774656a0718d 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -163,6 +163,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned
> > long type)
> >
> >       set_default_spectre(kvm);
> >       kvm_arm_init_hypercalls(kvm);
> > +     kvm_arm_init_id_regs(kvm);
> >
> >       /*
> >        * Initialise the default PMUver before there is a chance to
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 71b12094d613..d2ee3a1c7f03 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -41,6 +41,7 @@
> >   * 64bit interface.
> >   */
> >
> > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> >  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> >
> >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> > @@ -364,7 +365,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> >                         struct sys_reg_params *p,
> >                         const struct sys_reg_desc *r)
> >  {
> > -     u64 val =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > +     u64 val =3D kvm_arm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> >       u32 sr =3D reg_to_encoding(r);
> >
> >       if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
> > @@ -1208,16 +1209,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
> >       }
> >  }
> >
> > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > -static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_des=
c
> > const *r)
> > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
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
> > @@ -1280,6 +1274,26 @@ static u64 read_id_reg(const struct kvm_vcpu
> > *vcpu, struct sys_reg_desc const *r
> >       return val;
> >  }
> >
> > +/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_des=
c
> > const *r)
> > +{
> > +     if (sysreg_visible_as_raz(vcpu, r))
> > +             return 0;
> > +
> > +     return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
> > +}
> > +
> > +/*
> > + * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
> > + * (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > + */
> > +static inline bool is_id_reg(u32 id)
> > +{
> > +     return (sys_reg_Op0(id) =3D=3D 3 && sys_reg_Op1(id) =3D=3D 0 &&
> > +             sys_reg_CRn(id) =3D=3D 0 && sys_reg_CRm(id) >=3D 1 &&
> > +             sys_reg_CRm(id) < 8);
> > +}
> > +
> >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> >                                 const struct sys_reg_desc *r)
> >  {
> > @@ -2244,8 +2258,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> >       if (p->is_write) {
> >               return ignore_write(vcpu, p);
> >       } else {
> > -             u64 dfr =3D read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > -             u64 pfr =3D read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > +             u64 dfr =3D kvm_arm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1=
);
> > +             u64 pfr =3D kvm_arm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1=
);
>
> Does this change the behavior slightly as now within the kvm_arm_read_id_=
reg()
> the val will be further adjusted based on KVM/vCPU?
That's a good question. Although the actual behavior would be the same
no matter read idreg with read_sanitised_ftr_reg or
kvm_arm_read_id_reg, it is possible that the behavior would change
potentially in the future.
Since now every guest has its own idregs, for every guest, the idregs
should be read from kvm_arm_read_id_reg instead of
read_sanitised_ftr_reg.
The point is, for trap_dbgdidr, we should read AA64DFR0/AA64PFR0 from
host or the VM-scope?
>
> Thanks,
> Shameer
>
> >               u32 el3 =3D !!cpuid_feature_extract_unsigned_field(pfr,
> > ID_AA64PFR0_EL1_EL3_SHIFT);
> >
> >               p->regval =3D ((((dfr >> ID_AA64DFR0_EL1_WRPs_SHIFT) & 0x=
f) <<
> > 28) |
> > @@ -3343,6 +3357,37 @@ int kvm_arm_copy_sys_reg_indices(struct
> > kvm_vcpu *vcpu, u64 __user *uindices)
> >       return write_demux_regids(uindices);
> >  }
> >
> > +/*
> > + * Set the guest's ID registers with ID_SANITISED() to the host's sani=
tized
> > value.
> > + */
> > +void kvm_arm_init_id_regs(struct kvm *kvm)
> > +{
> > +     const struct sys_reg_desc *idreg;
> > +     struct sys_reg_params params;
> > +     u32 id;
> > +
> > +     /* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. */
> > +     id =3D SYS_ID_PFR0_EL1;
> > +     params =3D encoding_to_params(id);
> > +     idreg =3D find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_des=
cs));
> > +     if (WARN_ON(!idreg))
> > +             return;
> > +
> > +     /* Initialize all idregs */
> > +     while (is_id_reg(id)) {
> > +             /*
> > +              * Some hidden ID registers which are not in arm64_ftr_re=
gs[]
> > +              * would cause warnings from read_sanitised_ftr_reg().
> > +              * Skip those ID registers to avoid the warnings.
> > +              */
> > +             if (idreg->visibility !=3D raz_visibility)
> > +                     IDREG(kvm, id) =3D read_sanitised_ftr_reg(id);
> > +
> > +             idreg++;
> > +             id =3D reg_to_encoding(idreg);
> > +     }
> > +}
> > +
> >  int __init kvm_sys_reg_table_init(void)
> >  {
> >       bool valid =3D true;
> > diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> > index 6b11f2cc7146..eba10de2e7ae 100644
> > --- a/arch/arm64/kvm/sys_regs.h
> > +++ b/arch/arm64/kvm/sys_regs.h
> > @@ -27,6 +27,13 @@ struct sys_reg_params {
> >       bool    is_write;
> >  };
> >
> > +#define encoding_to_params(reg)                                       =
       \
> > +     ((struct sys_reg_params){ .Op0 =3D sys_reg_Op0(reg),             =
 \
> > +                               .Op1 =3D sys_reg_Op1(reg),             =
 \
> > +                               .CRn =3D sys_reg_CRn(reg),             =
 \
> > +                               .CRm =3D sys_reg_CRm(reg),             =
 \
> > +                               .Op2 =3D sys_reg_Op2(reg) })
> > +
> >  #define esr_sys64_to_params(esr)
> > \
> >       ((struct sys_reg_params){ .Op0 =3D ((esr) >> 20) & 3,
> > \
> >                                 .Op1 =3D ((esr) >> 14) & 0x7,          =
        \
> > --
> > 2.40.1.606.ga4b1b128d6-goog
> >
>
Thanks,
Jing
