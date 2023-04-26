Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1259F6EECE0
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 06:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbjDZEBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 00:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjDZEBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 00:01:20 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AACD10FE
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 21:01:17 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 5614622812f47-38dfdc1daa9so3768179b6e.1
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 21:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682481676; x=1685073676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qHY6h3hNkkFEPHwHsQwq+F8sgWI3ZrGdKW8QmbX4Kxs=;
        b=vQxgNDOhyb7Yg0iBvinGF4Ux09UdqqhMXXJgi85qMyfans6d8ON6Ug/54tibv92odv
         dI8GZeJXDHyFUwL0MLebe76NYgO6gGgJW3wLiKN47zcWsj3M8n3NYR4YcPeYHqKbh22D
         4z/Zs9dAzjeL+g+dBMGw0NcbkgP6hftN3TAsePCxqFbh5Flw3nwmH6Rcb1qcCB6niT/m
         FC0k0cea/itzaUpmf322n0Z9GdOM6HhGUB062nbYQmpkNhhLLIUSY/Zi8jLDprNKluN1
         112RVGTIED2e/QPgg/4QqRm0hldtiuL8giCzLu2+UxKyklpYstS2DvcIOt2RM+I4dg49
         6EJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682481676; x=1685073676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qHY6h3hNkkFEPHwHsQwq+F8sgWI3ZrGdKW8QmbX4Kxs=;
        b=Xc5eEqYAIVvOm7RSr/dDlJ3qqenkPS3qxLGU1yVDTjofKVIHMcxbQ3qhP7dmPS5Ug1
         AgsVQ/RkP6lo0NRaQh5XDmhs8Jh+6Uct8YUTgjn+i7Iz1CUycccQWNBJ8uPB0fhguCkU
         2D6gITfjiyQWuu8ZuYWNXA71B7yWNa+ICj5ko40ELeu4ojF9eJ2Z2FcnCO7LUPacKAEt
         C+ds9Al9KkO4fA4yyiUobxZnurDvVTuEdkAui/ksaKvXlgos2h1/ZCx7cmvPxI9hlCRP
         aKf2O16efu5YLnSFbtSIYkToIcj121rCK1PTgLqq/CcaSe8CA9lCFeHb8qRfJngnS7la
         HfXg==
X-Gm-Message-State: AAQBX9e0YbIyhxUoLZ/PsF7yu8BCmexsq5La44tkGBsFUc22qvJB/21G
        trEdFSwboo1RN1C1zC0NVVizGQaiwPK4o1USXJXIcQ==
X-Google-Smtp-Source: AKy350byh8JWLoLwRpgtDRnhM0bT2xxozsIFi27AvYcKsGC0oONK4aIGbp/TulglADb9qt73DzAdJD5dVUQkEqcMj08=
X-Received: by 2002:a05:6808:190a:b0:38d:ec65:aa85 with SMTP id
 bf10-20020a056808190a00b0038dec65aa85mr12878023oib.19.1682481674908; Tue, 25
 Apr 2023 21:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230424234704.2571444-1-jingzhangos@google.com>
 <20230424234704.2571444-3-jingzhangos@google.com> <ZEeGnwVxytVuZejC@linux.dev>
In-Reply-To: <ZEeGnwVxytVuZejC@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 25 Apr 2023 21:01:02 -0700
Message-ID: <CAAdAUtgkeAjijwtYGJBV85SR=GjkJ1dom140Lwhf90Rf_MUYzA@mail.gmail.com>
Subject: Re: [PATCH v7 2/6] KVM: arm64: Save ID registers' sanitized value per guest
To:     Oliver Upton <oliver.upton@linux.dev>
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

Hi Oliver,

On Tue, Apr 25, 2023 at 12:52=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> Hi Jing,
>
> On Mon, Apr 24, 2023 at 11:47:00PM +0000, Jing Zhang wrote:
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
> >  arch/arm64/include/asm/kvm_host.h | 47 +++++++++++++++++++++++++++++
> >  arch/arm64/kvm/arm.c              |  1 +
> >  arch/arm64/kvm/id_regs.c          | 49 +++++++++++++++++++++++++------
> >  arch/arm64/kvm/sys_regs.c         |  2 +-
> >  arch/arm64/kvm/sys_regs.h         |  3 +-
> >  5 files changed, 90 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index bcd774d74f34..2b1fe90a1790 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -177,6 +177,20 @@ struct kvm_smccc_features {
> >       unsigned long vendor_hyp_bmap;
> >  };
> >
> > +/*
> > + * Emualted CPU ID registers per VM
>
> typo: emulated
Will fix it.
>
> > + * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> > + * is (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > + *
> > + * These emulated idregs are VM-wide, but accessed from the context of=
 a vCPU.
> > + * Access to id regs are guarded by kvm_arch.config_lock.
> > + */
> > +#define KVM_ARM_ID_REG_NUM   56
> > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) << 3) | s=
ys_reg_Op2(id))
> > +struct kvm_idregs {
> > +     u64 regs[KVM_ARM_ID_REG_NUM];
> > +};
>
> What is the purpose of declaring the register array as a separate
> structure? It has no meaning (nor use) outside of the context of a VM.
>
> I'd prefer the 'regs' array be embedded directly in kvm_arch, and just
> name it 'idregs'. You can move your macro definitions there as well to
> immediately precede the field.
>
It was declared as you suggested in the older series. The separate
structure was suggested by Marc.
> >  typedef unsigned int pkvm_handle_t;
> >
> >  struct kvm_protected_vm {
> > @@ -243,6 +257,9 @@ struct kvm_arch {
> >       /* Hypercall features firmware registers' descriptor */
> >       struct kvm_smccc_features smccc_feat;
> >
> > +     /* Emulated CPU ID registers */
> > +     struct kvm_idregs idregs;
> > +
> >       /*
> >        * For an untrusted host VM, 'pkvm.handle' is used to lookup
> >        * the associated pKVM instance in the hypervisor.
> > @@ -1008,6 +1025,8 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *v=
cpu,
> >  long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >                               struct kvm_arm_copy_mte_tags *copy_tags);
> >
> > +void kvm_arm_init_id_regs(struct kvm *kvm);
> > +
> >  /* Guest/host FPSIMD coordination helpers */
> >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > @@ -1073,4 +1092,32 @@ static inline void kvm_hyp_reserve(void) { }
> >  void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
> >  bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
> >
> > +static inline u64 _idreg_read(struct kvm_arch *arch, u32 id)
>
> <bikeshed>
>
> Personally, I find passing 'kvm_arch' around to be a bit clunky. Almost
> all functions in KVM take 'struct kvm' as an argument, even if it only
> accesses the data in 'kvm_arch'.
>
> So, I'd prefer if all these helpers took 'struct kvm *'.
>
> </bikeshed>
>
There is a reason why 'struct kvm' was not used.
Usually arch dependent headers don't include <linux/kvm_host.h> which
declares the 'struct kvm'. But here we need to reference the fields in
'struct kvm', we need to include <linux/kvm_host.h>. But
<linux/kvm_host.h> is dependent on arch dependent structures defined
in <asm/kvm_host.h>.
To use 'struct kvm', one way is to include <linux/kvm_host.h> in the
middle of <asm/kvm_host.h> (after those arch dependent structures but
before those idregs read/write inlines). Or we can move these idregs
read/write functions to id_regs.c as non-static functions, since they
are not only used by id_regs.c.
> > +{
> > +     return arch->idregs.regs[IDREG_IDX(id)];
> > +}
> > +
> > +static inline void _idreg_write(struct kvm_arch *arch, u32 id, u64 val=
)
> > +{
> > +     arch->idregs.regs[IDREG_IDX(id)] =3D val;
> > +}
> > +
> > +static inline u64 idreg_read(struct kvm_arch *arch, u32 id)
> > +{
> > +     u64 val;
> > +
> > +     mutex_lock(&arch->config_lock);
> > +     val =3D _idreg_read(arch, id);
> > +     mutex_unlock(&arch->config_lock);
>
> What exactly are we protecting against by taking the config_lock here?
The intention is to use the config_lock to protect the whole id_regs[]
array, all idregs, not on the granularity of a single idreg.
IIUC, there might be some dependencies between feature fields in
different idregs, like the PMUVer and PerfMon. If there is no lock for
reads from the guest, the guest may get inconsistent values for PMUVer
and PerfMon.
But since no changes are allowed when the VM is running, the reads
from the guests don't have to use the lock as you suggested below.
>
> While I do believe there is value in serializing writers to the shared
> data, there isn't a need to serialize reads from the guest.
>
> What about implementing the following:
>
>  - Acquire the config_lock for handling writes. Only allow the value to
>    change if !kvm_vm_has_ran_once(). Otherwise, permit identical writes
>    (useful for hotplug, I imagine) or return EBUSY if userspace tried to
>    change something after running the VM.
Sure, will add this check for writes during VM running.
>
>  - Acquire the config_lock for handling reads *from userspace*
>
>  - Handle reads from the guest with a plain old load, avoiding the need
>    to acquire any locks.
Sure, will use this since as long as VM is running, the userspace
should not change the values of idregs.
>
> This has the benefit of avoiding lock contention for guest reads w/o
> requiring the use of atomic loads/stores (i.e. {READ,WRITE}_ONCE()) to
> protect said readers.
>
> > +     return val;
> > +}
> > +
> > +static inline void idreg_write(struct kvm_arch *arch, u32 id, u64 val)
> > +{
> > +     mutex_lock(&arch->config_lock);
> > +     _idreg_write(arch, id, val);
> > +     mutex_unlock(&arch->config_lock);
> > +}
> > +
> >  #endif /* __ARM64_KVM_HOST_H__ */
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
> > index 96b4c43a5100..d2fba2fde01c 100644
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
> > +     u64 val =3D idreg_read(&vcpu->kvm->arch, id);
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
> > @@ -458,3 +459,33 @@ int emulate_id_reg(struct kvm_vcpu *vcpu, struct s=
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
> > +     int i;
> > +     u32 id;
> > +     u64 val;
>
> nit: use reverse christmas/fir tree ordering for locals.
>
Will do.
> > +     for (i =3D 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > +             id =3D reg_to_encoding(&id_reg_descs[i]);
> > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > +                     /* Shouldn't happen */
> > +                     continue;
>
> I'll make the suggestion once more.
>
> Please do not implement these sort of sanity checks on static data
> structures at the point userspace has gotten involved. Sanity checking
> on id_reg_descs[] should happen at the time KVM is initialized. If
> anything is wrong at that point we should return an error and outright
> refuse to run KVM.
Sure, will move the check to kvm_sys_reg_table_init.
>
> --
> Thanks,
> Oliver
Thanks,
Jing
