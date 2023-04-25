Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7D36ED9FF
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 03:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjDYBpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 21:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbjDYBpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 21:45:18 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80498AF0A
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 18:45:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a9290a6f96so578765ad.1
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 18:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682387117; x=1684979117;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fNs0pUTvP1d4kW6KiccRdby8kAtqOyOOnmaY53ILjo4=;
        b=gKEa1LL3o2+xw+wePXTydV+rcr9Ex4hicbcKO/7xjFyHSfGvPjJkL9Bzgp5PvDHBrk
         KNEvdVuAemDTCbscp0Lu15YTOm76I7i6+ZYX30CHnxULuvxF0x74QALRry4nAeZz5Y4N
         SR4d0pv8w60kskieQZLMZ/nJB+hhcJwxFpCuM5sF8O3e0vFM22oYFB6RzmUiuoR2G2jn
         QEMkjen0i2vAD9ull9M4gXsvTI3SZ43mxcBnw+uHSCne/2QdQ2gBMts+yytY8FBE7MAA
         5Al0jPgoIkp27/4XqIZJ9GMZjNX3wUEM6k4QA+MAWcINfGc6pEIVAZA406QzWiue9Kpa
         v+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682387117; x=1684979117;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fNs0pUTvP1d4kW6KiccRdby8kAtqOyOOnmaY53ILjo4=;
        b=JSgLvB5NUKMKTzI5YBdkB/uiI4x5nP+qJxaFvyhcmsyKOyouqqITN9g3fS2NdGeCx6
         i9SoCXUS6ZErDPt1VXIDeAEmKiBapo97FVk92rMRG6HjEF4OJf5vs2pOq+PyYJtJec5s
         8giCKxaL8LCA1B2BsC6g59EFtcmzSdScwejxYe8ChytQzMMP+Gpfu2NjeI5DYclqfnh3
         qIcDB7SDF3Ltk4qzkd8WKJKT1UxhwieSsIwf/JcEeO41bmcsUXDtntUPr/MFHfQXjVbs
         GMIRcQj1Rbwv3NOUSih8kxuqGcdfi6T5XMPqVd5zWobtxVf7CqrOb8piPFUDSO/64jJs
         ugkQ==
X-Gm-Message-State: AC+VfDycPWvhSlzrlHoSrrW/QThgGPNP6Utk3mXg+LQEYLEyCEXVfOWl
        3fUe17QMlKTq1rliRUA2FODz2w==
X-Google-Smtp-Source: ACHHUZ6yMuR0KL6S7F8pQVQGZbspyS4K1EVM25hPSv5iLwSvlUGa5nXvVfgPYjXfCNKZ+2YFiYQejw==
X-Received: by 2002:a17:902:f691:b0:1a1:c3bf:810b with SMTP id l17-20020a170902f69100b001a1c3bf810bmr136917plg.6.1682387116794;
        Mon, 24 Apr 2023 18:45:16 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id i12-20020a62870c000000b0063b7f3250e9sm7960372pfe.7.2023.04.24.18.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:45:15 -0700 (PDT)
Date:   Mon, 24 Apr 2023 18:45:11 -0700
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
Subject: Re: [PATCH v6 4/6] KVM: arm64: Use per guest ID register for
 ID_AA64DFR0_EL1.PMUVer
Message-ID: <20230425014511.ipwj7gr4d4ai5als@google.com>
References: <20230404035344.4043856-1-jingzhangos@google.com>
 <20230404035344.4043856-5-jingzhangos@google.com>
 <20230419034042.r56jdectha4asyqi@google.com>
 <CAAdAUtgpHCnoAJoVOW51C=_=7Hs9dJGUw1cjZAKMPuV-8eyLJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAdAUtgpHCnoAJoVOW51C=_=7Hs9dJGUw1cjZAKMPuV-8eyLJw@mail.gmail.com>
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

On Mon, Apr 24, 2023 at 12:07:31PM -0700, Jing Zhang wrote:
> Hi Reiji,
> 
> On Tue, Apr 18, 2023 at 8:40 PM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Jing,
> >
> > On Tue, Apr 04, 2023 at 03:53:42AM +0000, Jing Zhang wrote:
> > > With per guest ID registers, PMUver settings from userspace
> > > can be stored in its corresponding ID register.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 11 +++----
> > >  arch/arm64/kvm/arm.c              |  6 ----
> > >  arch/arm64/kvm/id_regs.c          | 50 ++++++++++++++++++++++++-------
> > >  include/kvm/arm_pmu.h             |  5 ++--
> > >  4 files changed, 49 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 67a55177fd83..da46a2729581 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -237,6 +237,12 @@ struct kvm_arch {
> > >  #define KVM_ARCH_FLAG_EL1_32BIT                              4
> > >       /* PSCI SYSTEM_SUSPEND enabled for the guest */
> > >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED         5
> > > +     /*
> > > +      * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
> > > +      * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
> > > +      * userspace for VCPUs without PMU.
> > > +      */
> > > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU           6
> > >
> > >       unsigned long flags;
> > >
> > > @@ -249,11 +255,6 @@ struct kvm_arch {
> > >
> > >       cpumask_var_t supported_cpus;
> > >
> > > -     struct {
> > > -             u8 imp:4;
> > > -             u8 unimp:4;
> > > -     } dfr0_pmuver;
> > > -
> > >       /* Hypercall features firmware registers' descriptor */
> > >       struct kvm_smccc_features smccc_feat;
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 64e1c19e5a9b..3fe28d545b54 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> > >       kvm_arm_init_hypercalls(kvm);
> > >       kvm_arm_init_id_regs(kvm);
> > >
> > > -     /*
> > > -      * Initialise the default PMUver before there is a chance to
> > > -      * create an actual PMU.
> > > -      */
> > > -     kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
> > > -
> > >       return 0;
> > >
> > >  err_free_cpumask:
> > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > > index 291311b1ecca..6f65d30693fe 100644
> > > --- a/arch/arm64/kvm/id_regs.c
> > > +++ b/arch/arm64/kvm/id_regs.c
> > > @@ -21,9 +21,12 @@
> > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > >  {
> > >       if (kvm_vcpu_has_pmu(vcpu))
> > > -             return vcpu->kvm->arch.dfr0_pmuver.imp;
> > > +             return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > > +                              IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> > > +     else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
> > > +             return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> > >
> > > -     return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > > +     return 0;
> > >  }
> > >
> > >  static u8 perfmon_to_pmuver(u8 perfmon)
> > > @@ -254,10 +257,20 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > >       if (val)
> > >               return -EINVAL;
> > >
> > > -     if (valid_pmu)
> > > -             vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> > > -     else
> > > -             vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
> > > +     if (valid_pmu) {
> > > +             mutex_lock(&vcpu->kvm->arch.config_lock);
> > > +             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > > +             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> > > +                                                                 pmuver);
> > > +
> > > +             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
> > > +             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> > > +                                                             pmuver_to_perfmon(pmuver));
> >
> > As those could be read without acquiring the lock, I don't think
> > we should expose the intermediate state of the register values.
> I will protect all reads/writes to KVM scope emulated ID registers
> with the lock.

Or I think we could resolve it by writing the new value atomically
(copy the value to a local variable, set the local variable to the
new value, and update the ID_REG value with WRITE_ONCE).

Thank you,
Reiji


> >
> >
> > > +             mutex_unlock(&vcpu->kvm->arch.config_lock);
> > > +     } else {
> > > +             assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
> > > +                        pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
> > > +     }
> > >
> > >       return 0;
> > >  }
> > > @@ -294,10 +307,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > >       if (val)
> > >               return -EINVAL;
> > >
> > > -     if (valid_pmu)
> > > -             vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> > > -     else
> > > -             vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
> > > +     if (valid_pmu) {
> > > +             mutex_lock(&vcpu->kvm->arch.config_lock);
> > > +             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
> > > +             IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
> > > +
> > > +             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > > +             IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> > > +                                                                 perfmon_to_pmuver(perfmon));
> >
> > I have the same comment as set_id_aa64dfr0_el1().
> >
> > Thank you,
> > Reiji
> >
> > > +             mutex_unlock(&vcpu->kvm->arch.config_lock);
> > > +     } else {
> > > +             assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
> > > +                        perfmon == ID_DFR0_EL1_PerfMon_IMPDEF);
> > > +     }
> > >
> > >       return 0;
> > >  }
> > > @@ -503,4 +525,12 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
> > >       }
> > >
> > >       IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
> > > +
> > > +     /*
> > > +      * Initialise the default PMUver before there is a chance to
> > > +      * create an actual PMU.
> > > +      */
> > > +     IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > +     IDREG(kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > > +                                                   kvm_arm_pmu_get_pmuver_limit());
> > >  }
> > > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > > index 628775334d5e..856ac59b6821 100644
> > > --- a/include/kvm/arm_pmu.h
> > > +++ b/include/kvm/arm_pmu.h
> > > @@ -92,8 +92,9 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> > >  /*
> > >   * Evaluates as true when emulating PMUv3p5, and false otherwise.
> > >   */
> > > -#define kvm_pmu_is_3p5(vcpu)                                         \
> > > -     (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
> > > +#define kvm_pmu_is_3p5(vcpu)                                                                 \
> > > +      (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),                                 \
> > > +              IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
> > >
> > >  u8 kvm_arm_pmu_get_pmuver_limit(void);
> > >
> > > --
> > > 2.40.0.348.gf938b09366-goog
> > >
> Thanks,
> Jing
