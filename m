Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7080770A2B8
	for <lists+kvm@lfdr.de>; Sat, 20 May 2023 00:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjESWQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 18:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjESWQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 18:16:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1280418F
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 15:16:43 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1ae3f74c98bso19085ad.1
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 15:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684534602; x=1687126602;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iurqPZlRhueSwYrReb1arhB1aqRsuOVxedXEzmuJJAE=;
        b=NoUwoNhIHLB8itnjzfKI4PamgeS5xR3kDrwkbe7ms5V+k/2/w5hlLQG22rSU4uZZAE
         eCB/zkb7z5T6ZBA05OERrILYirzSRJ4RiBUFeeUMKgqwSPRwiep293ooztMycDFSxAlu
         qYXNDb+Vwzejx3suj6cbfoV3QpD6MJa1GaBo8t14Xhp0fofGfU+kpSJofYJidy+/Pwh1
         9mDn9rZyRdovuKBezyPmOoPe7zwYSjCwwjatwAMYoU+6qQiE2RMZXH16MkCu6+IueMe4
         3oOuYxv21hBgsRRAY7XXtE6IPSa7Im92T9n3dEx5lH/XdW3cRpUhP46Lheg2MCKJyCEd
         +Lgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684534602; x=1687126602;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iurqPZlRhueSwYrReb1arhB1aqRsuOVxedXEzmuJJAE=;
        b=fVfYxk7heYHwZcBWL+PjjvPbDIOm0Cf53NBXk8VxYpLvHsE6xCr8kp928QrrFVjCpJ
         JrKO6qrymFWz5Y+c/lfjNWnB3Su8hKXi2L/QnCwuoh6dFj6FIuq9HxTFAx0lHcjHWrCC
         6C6ZzYB1DO1RZNtS0uDODmBIYTzfGBx9z+FO2A3jBMLCqLDYfv/8WKeWwWUD6NKqMofi
         9RChOc4TqoVGtpoiMpXRaLBqghVnK5JVwO5xNEueTNmJvBxyhT0kj6cdjgFVJkXQyw9Q
         CzSpnxJx1QRA52DCpBby3eOZNzigc4PiD9ocNABAsFBtUsAxJ+TKmXbAoa7PZKRIKShy
         iqHw==
X-Gm-Message-State: AC+VfDw0czL02+kFIh6lgWbJgYJEcI6PHT75WAvNknYGkigYRlpKNLl1
        cK6BtKFy3nP7LWE70rnrAHuPMg==
X-Google-Smtp-Source: ACHHUZ6gAAPyU2HIbJvMWFIjTRBIwHsxxtsZ2iEbJhqn4lvzCdIWQWFuZOaz80BvIqJLuom6egRTPw==
X-Received: by 2002:a17:902:cec4:b0:1ac:36e6:2801 with SMTP id d4-20020a170902cec400b001ac36e62801mr378249plg.12.1684534602313;
        Fri, 19 May 2023 15:16:42 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id c33-20020a631c21000000b0053449457a25sm179720pgc.88.2023.05.19.15.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 15:16:41 -0700 (PDT)
Date:   Fri, 19 May 2023 15:16:36 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
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
Subject: Re: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized value
 per guest
Message-ID: <20230519221636.jey62kmyrsncuytu@google.com>
References: <20230517061015.1915934-1-jingzhangos@google.com>
 <20230517061015.1915934-2-jingzhangos@google.com>
 <2e727b02fe9141098ed474ef49ddc495@huawei.com>
 <CAAdAUtiWkqaymY3e3=m3YHw9FNGYf6rsFsAVkFKpUh-p9nd+gQ@mail.gmail.com>
 <f8ad69243ac5407f8d4d78689bba8c9a@huawei.com>
 <CAAdAUtiR9JWm7V++9jNPPznc4jBG9sDgkfDMW5Vck610O3XCUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAdAUtiR9JWm7V++9jNPPznc4jBG9sDgkfDMW5Vck610O3XCUw@mail.gmail.com>
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

On Fri, May 19, 2023 at 10:44:41AM -0700, Jing Zhang wrote:
> HI Shameerali,
> 
> On Fri, May 19, 2023 at 1:08 AM Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com> wrote:
> >
> >
> >
> > > -----Original Message-----
> > > From: Jing Zhang [mailto:jingzhangos@google.com]
> > > Sent: 18 May 2023 20:49
> > > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> > > Cc: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
> > > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
> > > <maz@kernel.org>; Oliver Upton <oupton@google.com>; Will Deacon
> > > <will@kernel.org>; Paolo Bonzini <pbonzini@redhat.com>; James Morse
> > > <james.morse@arm.com>; Alexandru Elisei <alexandru.elisei@arm.com>;
> > > Suzuki K Poulose <suzuki.poulose@arm.com>; Fuad Tabba
> > > <tabba@google.com>; Reiji Watanabe <reijiw@google.com>; Raghavendra
> > > Rao Ananta <rananta@google.com>
> > > Subject: Re: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized value
> > > per guest
> > >
> > > Hi Shameerali,
> > >
> > > On Thu, May 18, 2023 at 12:17 AM Shameerali Kolothum Thodi
> > > <shameerali.kolothum.thodi@huawei.com> wrote:
> > > >
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Jing Zhang [mailto:jingzhangos@google.com]
> > > > > Sent: 17 May 2023 07:10
> > > > > To: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
> > > > > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
> > > > > <maz@kernel.org>; Oliver Upton <oupton@google.com>
> > > > > Cc: Will Deacon <will@kernel.org>; Paolo Bonzini
> > > <pbonzini@redhat.com>;
> > > > > James Morse <james.morse@arm.com>; Alexandru Elisei
> > > > > <alexandru.elisei@arm.com>; Suzuki K Poulose
> > > <suzuki.poulose@arm.com>;
> > > > > Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
> > > > > Raghavendra Rao Ananta <rananta@google.com>; Jing Zhang
> > > > > <jingzhangos@google.com>
> > > > > Subject: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized value
> > > per
> > > > > guest
> > > > >
> > > > > Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> > > > > and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> > > > > Use the saved ones when ID registers are read by the guest or
> > > > > userspace (via KVM_GET_ONE_REG).
> > > > >
> > > > > No functional change intended.
> > > > >
> > > > > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > > ---
> > > > >  arch/arm64/include/asm/kvm_host.h | 20 +++++++++
> > > > >  arch/arm64/kvm/arm.c              |  1 +
> > > > >  arch/arm64/kvm/sys_regs.c         | 69
> > > > > +++++++++++++++++++++++++------
> > > > >  arch/arm64/kvm/sys_regs.h         |  7 ++++
> > > > >  4 files changed, 85 insertions(+), 12 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm64/include/asm/kvm_host.h
> > > > > b/arch/arm64/include/asm/kvm_host.h
> > > > > index 7e7e19ef6993..949a4a782844 100644
> > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > @@ -178,6 +178,21 @@ struct kvm_smccc_features {
> > > > >       unsigned long vendor_hyp_bmap;
> > > > >  };
> > > > >
> > > > > +/*
> > > > > + * Emulated CPU ID registers per VM
> > > > > + * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> > > > > + * is (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
> > > > > + *
> > > > > + * These emulated idregs are VM-wide, but accessed from the context of
> > > a
> > > > > vCPU.
> > > > > + * Access to id regs are guarded by kvm_arch.config_lock.

Nit: This statement doesn't seem to be true yet :)


> > > > > + */
> > > > > +#define KVM_ARM_ID_REG_NUM   56
> > > > > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) << 3) |
> > > sys_reg_Op2(id))
> > > > > +#define IDREG(kvm, id)
> > > ((kvm)->arch.idregs.regs[IDREG_IDX(id)])
> > > > > +struct kvm_idregs {
> > > > > +     u64 regs[KVM_ARM_ID_REG_NUM];
> > > > > +};
> > > > >
> > > >
> > > > Not sure we really need this struct here. Why can't this array be moved to
> > > > struct kvm_arch directly?
> > > It was put in kvm_arch directly before, then got into its own
> > > structure in v5 according to the comments here:
> > > https://lore.kernel.org/all/861qlaxzyw.wl-maz@kernel.org/#t
> >
> > Ok.
> >
> > > > >  typedef unsigned int pkvm_handle_t;
> > > > >
> > > > >  struct kvm_protected_vm {
> > > > > @@ -253,6 +268,9 @@ struct kvm_arch {
> > > > >       struct kvm_smccc_features smccc_feat;
> > > > >       struct maple_tree smccc_filter;
> > > > >
> > > > > +     /* Emulated CPU ID registers */
> > > > > +     struct kvm_idregs idregs;
> > > > > +
> > > > >       /*
> > > > >        * For an untrusted host VM, 'pkvm.handle' is used to lookup
> > > > >        * the associated pKVM instance in the hypervisor.
> > > > > @@ -1045,6 +1063,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm
> > > > > *kvm,
> > > > >  int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> > > > >                                   struct kvm_arm_counter_offset
> > > *offset);
> > > > >
> > > > > +void kvm_arm_init_id_regs(struct kvm *kvm);
> > > > > +
> > > > >  /* Guest/host FPSIMD coordination helpers */
> > > > >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > > > >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > index 14391826241c..774656a0718d 100644
> > > > > --- a/arch/arm64/kvm/arm.c
> > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > @@ -163,6 +163,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned
> > > > > long type)
> > > > >
> > > > >       set_default_spectre(kvm);
> > > > >       kvm_arm_init_hypercalls(kvm);
> > > > > +     kvm_arm_init_id_regs(kvm);
> > > > >
> > > > >       /*
> > > > >        * Initialise the default PMUver before there is a chance to
> > > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > > index 71b12094d613..d2ee3a1c7f03 100644
> > > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > > @@ -41,6 +41,7 @@
> > > > >   * 64bit interface.
> > > > >   */
> > > > >
> > > > > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> > > > >  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> > > > >
> > > > >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> > > > > @@ -364,7 +365,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> > > > >                         struct sys_reg_params *p,
> > > > >                         const struct sys_reg_desc *r)
> > > > >  {
> > > > > -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > > > > +     u64 val = kvm_arm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> > > > >       u32 sr = reg_to_encoding(r);
> > > > >
> > > > >       if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
> > > > > @@ -1208,16 +1209,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
> > > > >       }
> > > > >  }
> > > > >
> > > > > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > > > > -static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc
> > > > > const *r)
> > > > > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> > > > >  {
> > > > > -     u32 id = reg_to_encoding(r);
> > > > > -     u64 val;
> > > > > -
> > > > > -     if (sysreg_visible_as_raz(vcpu, r))
> > > > > -             return 0;
> > > > > -
> > > > > -     val = read_sanitised_ftr_reg(id);
> > > > > +     u64 val = IDREG(vcpu->kvm, id);
> > > > >
> > > > >       switch (id) {
> > > > >       case SYS_ID_AA64PFR0_EL1:
> > > > > @@ -1280,6 +1274,26 @@ static u64 read_id_reg(const struct
> > > kvm_vcpu
> > > > > *vcpu, struct sys_reg_desc const *r
> > > > >       return val;
> > > > >  }
> > > > >
> > > > > +/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > > > > +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct
> > > sys_reg_desc
> > > > > const *r)
> > > > > +{
> > > > > +     if (sysreg_visible_as_raz(vcpu, r))
> > > > > +             return 0;
> > > > > +
> > > > > +     return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
> > > > > + * (3, 0, 0, crm, op2), where 1<=crm<8, 0<=op2<8.
> > > > > + */
> > > > > +static inline bool is_id_reg(u32 id)
> > > > > +{
> > > > > +     return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
> > > > > +             sys_reg_CRn(id) == 0 && sys_reg_CRm(id) >= 1 &&
> > > > > +             sys_reg_CRm(id) < 8);
> > > > > +}
> > > > > +
> > > > >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> > > > >                                 const struct sys_reg_desc *r)
> > > > >  {
> > > > > @@ -2244,8 +2258,8 @@ static bool trap_dbgdidr(struct kvm_vcpu
> > > *vcpu,
> > > > >       if (p->is_write) {
> > > > >               return ignore_write(vcpu, p);
> > > > >       } else {
> > > > > -             u64 dfr =
> > > read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > > > > -             u64 pfr =
> > > read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > > > > +             u64 dfr = kvm_arm_read_id_reg(vcpu,
> > > SYS_ID_AA64DFR0_EL1);
> > > > > +             u64 pfr = kvm_arm_read_id_reg(vcpu,
> > > SYS_ID_AA64PFR0_EL1);
> > > >
> > > > Does this change the behavior slightly as now within the
> > > kvm_arm_read_id_reg()
> > > > the val will be further adjusted based on KVM/vCPU?
> > > That's a good question. Although the actual behavior would be the same
> > > no matter read idreg with read_sanitised_ftr_reg or
> > > kvm_arm_read_id_reg, it is possible that the behavior would change
> > > potentially in the future.
> > > Since now every guest has its own idregs, for every guest, the idregs
> > > should be read from kvm_arm_read_id_reg instead of
> > > read_sanitised_ftr_reg.
> > > The point is, for trap_dbgdidr, we should read AA64DFR0/AA64PFR0 from
> > > host or the VM-scope?
> >
> > Ok. I was just double checking whether it changes the behavior now itself or
> > not as we claim no functional changes in this series. As far as host vs VM
> > scope, I am not sure as well. From a quick look through the history of debug
> > support, couldn’t find anything that mandates host values though.

We should use the VM-scope AA64DFR0/AA64PFR0 values here.
As trap_dbgdidr() is the emulation code for the guest's reading DBGDIDR,
its WRPs, BRPs, CTX_CMPs, and EL3 field must be consistent with the ones
in the guest's AA64DFR0_EL1/AA64PFR0_EL1 values.

As Jing said, it doesn't matter practically until we allow userspace to
modify those fields though :)

Thank you,
Reiji
