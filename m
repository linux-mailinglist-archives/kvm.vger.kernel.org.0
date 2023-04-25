Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173C36EDA37
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 04:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjDYCTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 22:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjDYCTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 22:19:50 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E679ED6
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 19:19:47 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a950b982d4so346795ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 19:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682389187; x=1684981187;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ImY/M0dFuKXsX34f8uMywVTEfe5FJzXp0uCLTkktILM=;
        b=4w5jCPtVlcLD0jzf7MG+vy/UPJCGO6r/iTQ96hoa7zDoEB/qPlSXwYMUbdu51OHgCU
         yeF/ldlgJf9uDmP3DzaAYP/cpjmV1XrKqXNW2S+mYgvreFsAVlF+mR7wh0qJjQlSgExL
         bjNHRS+NfSt0v0q1UmSqDC59Yyjnpc0DQ5Bi5JGbCynGbYs+1AdvVJ8Ky9d43+UZCsgD
         FLkbUySGRwpsXG63VYlAwvfru7Y43XdmaddRl16KnudfOFjUTT5ZZ6b352Xc4mmijnMj
         SmFfrREu3xW3btdISNLOwLGo1MlxQMO0DIsG6OERa/Zj+sPCjOpEFym2cu04r+DNR7+9
         ZX0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682389187; x=1684981187;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ImY/M0dFuKXsX34f8uMywVTEfe5FJzXp0uCLTkktILM=;
        b=gyELey0lUglWgC1+qLaM5QcUMkbsryNESrZnLLh9pTbaaXd/dw4aIFwhAeVisY5/SA
         zdGk9Sw+B80e9K9UN39/h2+jd3/XOb5/QLBNTadj2v52vqVOqfhWt0toHML22fQ7/9Av
         mlHpWpw4rs42TsIYqdfk7wTawfE+NvCWsLOymQT/Eg6bMArcMOw3K4B9EIOCD1PCEIiK
         Jtz+qowpdnPGp7L3a1pDobu4eOyY2/yYsxYkKsigBQfoJCjdP20wqVx3GNcxByhCZAul
         WjStOz2OsRFLrRevpCzvYrbD0Z2jQsQ6GuRyyVQ7Ax8wCcHnPA+khS6M76WzDOuU223F
         U6aw==
X-Gm-Message-State: AC+VfDwpKRTPhbgCqojDOWSookDEJCM4nT6/BLFBDNkuZDZkPRrB0YeY
        Heaxx/wzCP5h/y0V3bn9SLRhJw==
X-Google-Smtp-Source: ACHHUZ775i8yF6FEsnBYfhm4zO2hpN+8YkvMwPcIJQ8yluhbemU5wFk1xzIWXL0sNHMGs6AlM5LW8w==
X-Received: by 2002:a17:903:2407:b0:1a6:42f0:e575 with SMTP id e7-20020a170903240700b001a642f0e575mr70750plo.5.1682389186949;
        Mon, 24 Apr 2023 19:19:46 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id w24-20020a170902a71800b001a64dbfc5d7sm7100269plq.145.2023.04.24.19.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 19:19:46 -0700 (PDT)
Date:   Mon, 24 Apr 2023 19:19:42 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Jing Zhang <jingzhangos@google.com>
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
Subject: Re: [PATCH v6 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
Message-ID: <20230425021942.j7euryrduejjvueb@google.com>
References: <20230404035344.4043856-1-jingzhangos@google.com>
 <20230404035344.4043856-7-jingzhangos@google.com>
 <20230419045943.bxt2xizlgslaoggi@google.com>
 <CAAdAUtgHUV3ms7i2owWWkVMH430QzprmJgn2hDunZ9Shw7j=PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAdAUtgHUV3ms7i2owWWkVMH430QzprmJgn2hDunZ9Shw7j=PQ@mail.gmail.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

On Mon, Apr 24, 2023 at 12:19:50PM -0700, Jing Zhang wrote:
> Hi Reiji,
> 
> On Tue, Apr 18, 2023 at 9:59 PM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Jing,
> >
> > On Tue, Apr 04, 2023 at 03:53:44AM +0000, Jing Zhang wrote:
> > > Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> > > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> > > introduced by ID register descriptor array.
> > >
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  arch/arm64/include/asm/cpufeature.h |   1 +
> > >  arch/arm64/kernel/cpufeature.c      |   2 +-
> > >  arch/arm64/kvm/id_regs.c            | 284 ++++++++++++++++++++--------
> > >  3 files changed, 203 insertions(+), 84 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > > index 6bf013fb110d..dc769c2eb7a4 100644
> > > --- a/arch/arm64/include/asm/cpufeature.h
> > > +++ b/arch/arm64/include/asm/cpufeature.h
> > > @@ -915,6 +915,7 @@ static inline unsigned int get_vmid_bits(u64 mmfr1)
> > >       return 8;
> > >  }
> > >
> > > +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new, s64 cur);
> > >  struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
> > >
> > >  extern struct arm64_ftr_override id_aa64mmfr1_override;
> > > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > > index 2e3e55139777..677ec4fe9f6b 100644
> > > --- a/arch/arm64/kernel/cpufeature.c
> > > +++ b/arch/arm64/kernel/cpufeature.c
> > > @@ -791,7 +791,7 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
> > >       return reg;
> > >  }
> > >
> > > -static s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
> > > +s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
> > >                               s64 cur)
> > >  {
> > >       s64 ret = 0;
> > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > > index fe37b6786b4c..33968ada29bb 100644
> > > --- a/arch/arm64/kvm/id_regs.c
> > > +++ b/arch/arm64/kvm/id_regs.c
> > > @@ -18,6 +18,66 @@
> > >
> > >  #include "sys_regs.h"
> > >
> > > +/**
> > > + * arm64_check_features() - Check if a feature register value constitutes
> > > + * a subset of features indicated by the idreg's KVM sanitised limit.
> > > + *
> > > + * This function will check if each feature field of @val is the "safe" value
> > > + * against idreg's KVM sanitised limit return from reset() callback.
> > > + * If a field value in @val is the same as the one in limit, it is always
> > > + * considered the safe value regardless For register fields that are not in
> > > + * writable, only the value in limit is considered the safe value.
> > > + *
> > > + * Return: 0 if all the fields are safe. Otherwise, return negative errno.
> > > + */
> > > +static int arm64_check_features(struct kvm_vcpu *vcpu,
> > > +                             const struct sys_reg_desc *rd,
> > > +                             u64 val)
> > > +{
> > > +     const struct arm64_ftr_reg *ftr_reg;
> > > +     const struct arm64_ftr_bits *ftrp = NULL;
> > > +     u32 id = reg_to_encoding(rd);
> > > +     u64 writable_mask = rd->val;
> > > +     u64 limit = 0;
> > > +     u64 mask = 0;
> > > +
> > > +     /* For hidden and unallocated idregs without reset, only val = 0 is allowed. */
> > > +     if (rd->reset) {
> > > +             limit = rd->reset(vcpu, rd);
> > > +             ftr_reg = get_arm64_ftr_reg(id);
> > > +             if (!ftr_reg)
> > > +                     return -EINVAL;
> > > +             ftrp = ftr_reg->ftr_bits;
> > > +     }
> > > +
> > > +     for (; ftrp && ftrp->width; ftrp++) {
> > > +             s64 f_val, f_lim, safe_val;
> > > +             u64 ftr_mask;
> > > +
> > > +             ftr_mask = arm64_ftr_mask(ftrp);
> > > +             if ((ftr_mask & writable_mask) != ftr_mask)
> > > +                     continue;
> > > +
> > > +             f_val = arm64_ftr_value(ftrp, val);
> > > +             f_lim = arm64_ftr_value(ftrp, limit);
> > > +             mask |= ftr_mask;
> > > +
> > > +             if (f_val == f_lim)
> > > +                     safe_val = f_val;
> > > +             else
> > > +                     safe_val = arm64_ftr_safe_value(ftrp, f_val, f_lim);
> >
> > Since PMUVer and PerfMon is defined as FTR_EXACT, I believe having lower
> > value in those two fields than the limit always ends up getting -E2BIG.
> > Or am I missing something ??
> > FYI. IIRC, we have some more fields in other ID registers that KVM
> > shouldn't use as is.
> Yes, you are right. I will add code to handle these exceptions.
> >
> > > +
> > > +             if (safe_val != f_val)
> > > +                     return -E2BIG;
> > > +     }
> > > +
> > > +     /* For fields that are not writable, values in limit are the safe values. */
> > > +     if ((val & ~mask) != (limit & ~mask))
> > > +             return -E2BIG;
> > > +
> > > +     return 0;
> > > +}
> > > +
> > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > >  {
> > >       if (kvm_vcpu_has_pmu(vcpu))
> > > @@ -68,7 +128,6 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> > >       case SYS_ID_AA64PFR0_EL1:
> > >               if (!vcpu_has_sve(vcpu))
> > >                       val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE);
> > > -             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > >               if (kvm_vgic_global_state.type == VGIC_V3) {
> > >                       val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC);
> > >                       val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC), 1);
> > > @@ -95,15 +154,10 @@ u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> > >                       val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
> > >               break;
> > >       case SYS_ID_AA64DFR0_EL1:
> > > -             /* Limit debug to ARMv8.0 */
> > > -             val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> > > -             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
> > >               /* Set PMUver to the required version */
> > >               val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > >               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > >                                 vcpu_pmuver(vcpu));
> > > -             /* Hide SPE from guests */
> > > -             val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
> > >               break;
> > >       case SYS_ID_DFR0_EL1:
> > >               val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > > @@ -162,9 +216,14 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > >  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > >                     u64 val)
> > >  {
> > > -     /* This is what we mean by invariant: you can't change it. */
> > > -     if (val != read_id_reg(vcpu, rd))
> > > -             return -EINVAL;
> > > +     u32 id = reg_to_encoding(rd);
> > > +     int ret;
> > > +
> > > +     ret = arm64_check_features(vcpu, rd, val);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     IDREG(vcpu->kvm, id) = val;
> > >
> > >       return 0;
> > >  }
> > > @@ -198,12 +257,40 @@ static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
> > >       return id_visibility(vcpu, r);
> > >  }
> > >
> > > +static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > > +                                       const struct sys_reg_desc *rd)
> > > +{
> > > +     u64 val;
> > > +     u32 id = reg_to_encoding(rd);
> > > +
> > > +     val = read_sanitised_ftr_reg(id);
> > > +     /*
> > > +      * The default is to expose CSV2 == 1 if the HW isn't affected.
> > > +      * Although this is a per-CPU feature, we make it global because
> > > +      * asymmetric systems are just a nuisance.
> > > +      *
> > > +      * Userspace can override this as long as it doesn't promise
> > > +      * the impossible.
> > > +      */
> > > +     if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
> > > +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > > +             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
> > > +     }
> > > +     if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
> > > +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > > +             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
> > > +     }
> > > +
> > > +     val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > > +
> > > +     return val;
> > > +}
> > > +
> > >  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > >                              const struct sys_reg_desc *rd,
> > >                              u64 val)
> > >  {
> > >       u8 csv2, csv3;
> > > -     u64 sval = val;
> > >
> > >       /*
> > >        * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long as
> > > @@ -219,16 +306,30 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > >       if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
> > >               return -EINVAL;
> > >
> > > -     /* We can only differ with CSV[23], and anything else is an error */
> > > -     val ^= read_id_reg(vcpu, rd);
> > > -     val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> > > -              ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> > > -     if (val)
> > > -             return -EINVAL;
> > > +     return set_id_reg(vcpu, rd, val);
> > > +}
> > > +
> > > +static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > > +                                       const struct sys_reg_desc *rd)
> > > +{
> > > +     u64 val;
> > > +     u32 id = reg_to_encoding(rd);
> > >
> > > -     IDREG(vcpu->kvm, reg_to_encoding(rd)) = sval;
> > > +     val = read_sanitised_ftr_reg(id);
> > > +     /* Limit debug to ARMv8.0 */
> > > +     val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> > > +     val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
> > > +     /*
> > > +      * Initialise the default PMUver before there is a chance to
> > > +      * create an actual PMU.
> > > +      */
> > > +     val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > +     val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > > +                       kvm_arm_pmu_get_pmuver_limit());
> > > +     /* Hide SPE from guests */
> > > +     val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
> > >
> > > -     return 0;
> > > +     return val;
> > >  }
> > >
> > >  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > > @@ -237,6 +338,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > >  {
> > >       u8 pmuver, host_pmuver;
> > >       bool valid_pmu;
> > > +     int ret;
> > >
> > >       host_pmuver = kvm_arm_pmu_get_pmuver_limit();
> > >
> > > @@ -256,36 +358,61 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > >       if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
> > >               return -EINVAL;
> > >
> > > -     /* We can only differ with PMUver, and anything else is an error */
> > > -     val ^= read_id_reg(vcpu, rd);
> > > -     val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > -     if (val)
> > > -             return -EINVAL;
> > > +     if (!valid_pmu) {
> > > +             /*
> > > +              * Ignore the PMUVer filed in @val. The PMUVer would be determined
> > > +              * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > > +              */
> > > +             pmuver = FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK, read_id_reg(vcpu, rd));
> >
> > As vPMU is not configured for this vCPU, I believe pmuver will be
> > 0x0 or 0xf.  I think that is not what we want there.
> > Or am I missing something ?
> As stated in the comment, when vPMU is not configured, the PMUVer
> observed by the guest would be determined by arch flags bit
> KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU. The value in the fields of idreg
> doesn't matter. Here is just a trick to ignore the check for the
> PMUVer field.

That sounds like what I understand.  But, I still think the code is
different from that.
When we get here, this vcpu has no PMU. Since PMUVer in the @val is
already validated earlier in this function, PMUVer in the @val is
0 or 0xf.  As this vcpu has no PMU, the "pmuver" (the current PMUVer
for this vcpu) is also 0 or 0xf.  So, I wonder why the field in
@val needs to be updated with the "pmuver".  Do you want to simply
clear the field or do you mean IDREG() instead of read_id_reg() ?

Thank you,
Reiji

> >
> >
> > > +             val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > > +             val |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
> > > +     }
> > >
> > > -     if (valid_pmu) {
> > > -             mutex_lock(&vcpu->kvm->arch.config_lock);
> > > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> > > -                                                                 pmuver);
> > > +     mutex_lock(&vcpu->kvm->arch.config_lock);
> > >
> > > -             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
> > > -             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> > > -                                                             pmuver_to_perfmon(pmuver));
> > > +     ret = set_id_reg(vcpu, rd, val);
> > > +     if (ret) {
> > >               mutex_unlock(&vcpu->kvm->arch.config_lock);
> > > -     } else {
> > > +             return ret;
> > > +     }
> > > +
> > > +     IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
> > > +     IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> > > +                                                     pmuver_to_perfmon(pmuver));
> > > +
> > > +     if (!valid_pmu)
> > >               assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
> > >                          pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
> > > -     }
> > > +
> > > +     mutex_unlock(&vcpu->kvm->arch.config_lock);
> > >
> > >       return 0;
> > >  }
> > >
> > > +static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > > +                                   const struct sys_reg_desc *rd)
> > > +{
> > > +     u64 val;
> > > +     u32 id = reg_to_encoding(rd);
> > > +
> > > +     val = read_sanitised_ftr_reg(id);
> > > +     /*
> > > +      * Initialise the default PMUver before there is a chance to
> > > +      * create an actual PMU.
> > > +      */
> > > +     val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > > +     val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), kvm_arm_pmu_get_pmuver_limit());
> > > +
> > > +     return val;
> > > +}
> > > +
> > >  static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > >                          const struct sys_reg_desc *rd,
> > >                          u64 val)
> > >  {
> > >       u8 perfmon, host_perfmon;
> > >       bool valid_pmu;
> > > +     int ret;
> > >
> > >       host_perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
> > >
> > > @@ -306,25 +433,33 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > >       if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
> > >               return -EINVAL;
> > >
> > > -     /* We can only differ with PerfMon, and anything else is an error */
> > > -     val ^= read_id_reg(vcpu, rd);
> > > -     val &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > > -     if (val)
> > > -             return -EINVAL;
> > > +     if (!valid_pmu) {
> > > +             /*
> > > +              * Ignore the PerfMon filed in @val. The PerfMon would be determined
> > > +              * by arch flags bit KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > > +              */
> >
> > I have the same comment as set_id_aa64dfr0_el1().
> >
> > Thank you,
> > Reiji
> >
> > > +             perfmon = FIELD_GET(ID_DFR0_EL1_PerfMon_MASK, read_id_reg(vcpu, rd));
> > > +             val &= ~ID_DFR0_EL1_PerfMon_MASK;
> > > +             val |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
> > > +     }
> > >
> > > -     if (valid_pmu) {
> > > -             mutex_lock(&vcpu->kvm->arch.config_lock);
> > > -             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
> > > -             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
> > > +     mutex_lock(&vcpu->kvm->arch.config_lock);
> > >
> > > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > > -             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> > > -                                                                 perfmon_to_pmuver(perfmon));
> > > +     ret = set_id_reg(vcpu, rd, val);
> > > +     if (ret) {
> > >               mutex_unlock(&vcpu->kvm->arch.config_lock);
> > > -     } else {
> > > +             return ret;
> > > +     }
> > > +
> > > +     IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > > +     IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> > > +                                                         perfmon_to_pmuver(perfmon));
> > > +
> > > +     if (!valid_pmu)
> > >               assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
> > >                          perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
> > > -     }
> > > +
> > > +     mutex_unlock(&vcpu->kvm->arch.config_lock);
> > >
> > >       return 0;
> > >  }
> > > @@ -402,9 +537,13 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
> > >       /* CRm=1 */
> > >       AA32_ID_SANITISED(ID_PFR0_EL1),
> > >       AA32_ID_SANITISED(ID_PFR1_EL1),
> > > -     { SYS_DESC(SYS_ID_DFR0_EL1), .access = access_id_reg,
> > > -       .get_user = get_id_reg, .set_user = set_id_dfr0_el1,
> > > -       .visibility = aa32_id_visibility, },
> > > +     { SYS_DESC(SYS_ID_DFR0_EL1),
> > > +       .access = access_id_reg,
> > > +       .get_user = get_id_reg,
> > > +       .set_user = set_id_dfr0_el1,
> > > +       .visibility = aa32_id_visibility,
> > > +       .reset = read_sanitised_id_dfr0_el1,
> > > +       .val = ID_DFR0_EL1_PerfMon_MASK, },
> > >       ID_HIDDEN(ID_AFR0_EL1),
> > >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> > >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > > @@ -433,8 +572,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
> > >
> > >       /* AArch64 ID registers */
> > >       /* CRm=4 */
> > > -     { SYS_DESC(SYS_ID_AA64PFR0_EL1), .access = access_id_reg,
> > > -       .get_user = get_id_reg, .set_user = set_id_aa64pfr0_el1, },
> > > +     { SYS_DESC(SYS_ID_AA64PFR0_EL1),
> > > +       .access = access_id_reg,
> > > +       .get_user = get_id_reg,
> > > +       .set_user = set_id_aa64pfr0_el1,
> > > +       .reset = read_sanitised_id_aa64pfr0_el1,
> > > +       .val = ID_AA64PFR0_EL1_CSV2_MASK | ID_AA64PFR0_EL1_CSV3_MASK, },
> > >       ID_SANITISED(ID_AA64PFR1_EL1),
> > >       ID_UNALLOCATED(4, 2),
> > >       ID_UNALLOCATED(4, 3),
> > > @@ -444,8 +587,12 @@ const struct sys_reg_desc id_reg_descs[KVM_ARM_ID_REG_NUM] = {
> > >       ID_UNALLOCATED(4, 7),
> > >
> > >       /* CRm=5 */
> > > -     { SYS_DESC(SYS_ID_AA64DFR0_EL1), .access = access_id_reg,
> > > -       .get_user = get_id_reg, .set_user = set_id_aa64dfr0_el1, },
> > > +     { SYS_DESC(SYS_ID_AA64DFR0_EL1),
> > > +       .access = access_id_reg,
> > > +       .get_user = get_id_reg,
> > > +       .set_user = set_id_aa64dfr0_el1,
> > > +       .reset = read_sanitised_id_aa64dfr0_el1,
> > > +       .val = ID_AA64DFR0_EL1_PMUVer_MASK, },
> > >       ID_SANITISED(ID_AA64DFR1_EL1),
> > >       ID_UNALLOCATED(5, 2),
> > >       ID_UNALLOCATED(5, 3),
> > > @@ -520,33 +667,4 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
> > >
> > >               IDREG(kvm, id) = val;
> > >       }
> > > -
> > > -     /*
> > > -      * The default is to expose CSV2 == 1 if the HW isn't affected.
> > > -      * Although this is a per-CPU feature, we make it global because
> > > -      * asymmetric systems are just a nuisance.
> > > -      *
> > > -      * Userspace can override this as long as it doesn't promise
> > > -      * the impossible.
> > > -      */
> > > -     val = IDREG(kvm, SYS_ID_AA64PFR0_EL1);
> > > -
> > > -     if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED) {
> > > -             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > > -             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
> > > -     }
> > > -     if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED) {
> > > -             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > > -             val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
> > > -     }
> > > -
> > > -     IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
> > > -
> > > -     /*
> > > -      * Initialise the default PMUver before there is a chance to
> > > -      * create an actual PMU.
> > > -      */
> > > -     IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > -     IDREG(kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > > -                                                   kvm_arm_pmu_get_pmuver_limit());
> > >  }
> > > --
> > > 2.40.0.348.gf938b09366-goog
> > >
> Thanks,
> Jing
