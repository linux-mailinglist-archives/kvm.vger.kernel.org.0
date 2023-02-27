Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B026A3922
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 03:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjB0C5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 21:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjB0C5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 21:57:38 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA8410AA7
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 18:57:36 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-17213c961dfso6208771fac.0
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 18:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FpFsj3ew/x/ritkNu2zWkCLb1cRFDdj63V3TKW7f8oM=;
        b=fOhSUQGoLFXBF7hMGQiQGBI3M2m+LtIbx8sNWltR1fxrLAik1+wP4KIVjGp8nS2gwt
         DiFUYt7w93pNNYzWGQsWnU2RG4MmptJGkJyvLO94yb7/302zqKUOAQk0xoVpdORMsKvh
         QhKRoxwdOq7DuoxutMmyIqkOAdQRHdKDnhdCRKEsycXnvTFtxDp6gYk4VmPOryjD/bpP
         aKMIg/Z3O/VqjPhrbQdc1LxAh+qIM7qBznwSxNEyafjwYYTt5mgtOJ4aZmR39nBCLWg6
         DY+JOpbB0MSYQduorly5TnHpLx3Xj1SxKffARKAe9lmlYu5aM/9p815XAAWcLv2wr9KH
         0LuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FpFsj3ew/x/ritkNu2zWkCLb1cRFDdj63V3TKW7f8oM=;
        b=stqryqP7CE3DT/BHzfNI0mvfTpYIZJO5pm6i0/4Qic5L/fdXjMVo2zKGDO8/6R92IH
         bygvW6D+25uWX3TjVVT3FZmY4Pc1T4ZsYXPaFogLuUGfSuLGeqcSwM+OhWTS3gsMu+9+
         YEWPKdKalidkcDqQ3c0DUaQqD0qolRuq6sHPChgOtJJPM6R48Op0MO3Knm0H8HXeWktr
         cGiZ6z8lvhPFZCECqfUWZQOMhtlJlplZry1UATDCAN9axJqqJJZqQJj2ASVW7EoFLeIK
         je1O9MPJAsgbM3xdsP3+fMN43RqXQODSp3GYp/X6mAg+GpRZqc6J2sHvm1iRbw9P/idl
         +8xA==
X-Gm-Message-State: AO0yUKXUYVoqjm91oQZcNDSuxrR9XUd5WVGVlRmFJmaurD5OlV4+nKF3
        EAMPhR43PxbroKZ4Mn+ku/ptFBHN8cTF8R8LQY/1VQ==
X-Google-Smtp-Source: AK7set8rmvQzkN2d1qzmMbRL4MDd28eWwEi6kC+dilEaS3AK/F+lZPLdpDrMTLkNTr3zqljLc27sb7o6WDcYKqX9R+I=
X-Received: by 2002:a05:6870:715:b0:172:2b6d:e85f with SMTP id
 ea21-20020a056870071500b001722b6de85fmr3045945oab.11.1677466656098; Sun, 26
 Feb 2023 18:57:36 -0800 (PST)
MIME-Version: 1.0
References: <20230212215830.2975485-1-jingzhangos@google.com>
 <20230212215830.2975485-5-jingzhangos@google.com> <CAAeT=FxXNvkd4qg83oYciahbADGPSoHb+KYRfrCRWx2s43b7qA@mail.gmail.com>
In-Reply-To: <CAAeT=FxXNvkd4qg83oYciahbADGPSoHb+KYRfrCRWx2s43b7qA@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Sun, 26 Feb 2023 18:57:24 -0800
Message-ID: <CAAdAUthpDLRGcJdLZnbmEjKGXkHvGgYB3wZ3f6D1uai8QAqJjA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Fri, Feb 24, 2023 at 6:36 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Jing,
>
> On Sun, Feb 12, 2023 at 1:58 PM Jing Zhang <jingzhangos@google.com> wrote:
> >
> > With per guest ID registers, PMUver settings from userspace
> > can be stored in its corresponding ID register.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 11 ++++----
> >  arch/arm64/kvm/arm.c              |  6 -----
> >  arch/arm64/kvm/id_regs.c          | 44 +++++++++++++++++++++++--------
> >  include/kvm/arm_pmu.h             |  6 +++--
> >  4 files changed, 43 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f64347eb77c2..effb61a9a855 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -218,6 +218,12 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_EL1_32BIT                                4
> >         /* PSCI SYSTEM_SUSPEND enabled for the guest */
> >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
> > +       /*
> > +        * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
> > +        * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
> > +        * userspace for VCPUs without PMU.
> > +        */
> > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU
>
> As Oliver suggested, it might be better to not expose IMPDEF PMU
> (but expose as 0), since it is not effectively supported by KVM.
> (We need to be careful not to have migration from old KVM fail though)
>
>
Since that change is not related to writable ID register change
itself, I'd prefer to have that change in a separate commit or post.
> >
> >         unsigned long flags;
> >
> > @@ -230,11 +236,6 @@ struct kvm_arch {
> >
> >         cpumask_var_t supported_cpus;
> >
> > -       struct {
> > -               u8 imp:4;
> > -               u8 unimp:4;
> > -       } dfr0_pmuver;
> > -
> >         /* Hypercall features firmware registers' descriptor */
> >         struct kvm_smccc_features smccc_feat;
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index c78d68d011cb..fb2de2cb98cb 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >         kvm_arm_set_default_id_regs(kvm);
> >         kvm_arm_init_hypercalls(kvm);
> >
> > -       /*
> > -        * Initialise the default PMUver before there is a chance to
> > -        * create an actual PMU.
> > -        */
> > -       kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
> > -
> >         return 0;
> >
> >  err_free_cpumask:
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index bc4c408a43eb..14ae03a1d8d0 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -21,9 +21,12 @@
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >         if (kvm_vcpu_has_pmu(vcpu))
> > -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> > -
> > -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > +               return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> > +       else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
> > +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> > +       else
> > +               return 0;
> >  }
> >
> >  static u8 perfmon_to_pmuver(u8 perfmon)
> > @@ -267,10 +270,15 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> >         if (val)
> >                 return -EINVAL;
> >
> > -       if (valid_pmu)
> > -               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> > -       else
> > -               vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
> > +       if (valid_pmu) {
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
> > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
>
> The original code keeps ID_AA64DFR0_EL1.PMUVer and ID_DFR0_EL1.PerfMon
> values consistent (if one of them is update, the other one is also
> updated accordingly).  To keep the same behavior, shouldn't we update
> the other one as well when one of them is updated ?
>
Yes, will do that to keep the values consistent.
> Thank you,
> Reiji
>
>
> > +       } else if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> > +       } else {
> > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -307,10 +315,15 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >         if (val)
> >                 return -EINVAL;
> >
> > -       if (valid_pmu)
> > -               vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> > -       else
> > -               vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
> > +       if (valid_pmu) {
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
> > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
> > +       } else if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
> > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> > +       } else {
> > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -534,4 +547,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
> >         }
> >
> >         IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
> > +
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=
> > +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                          kvm_arm_pmu_get_pmuver_limit());
> >  }
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 628775334d5e..eef67b7d9751 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >  /*
> >   * Evaluates as true when emulating PMUv3p5, and false otherwise.
> >   */
> > -#define kvm_pmu_is_3p5(vcpu)                                           \
> > -       (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
> > +#define kvm_pmu_is_3p5(vcpu)                                                                   \
> > +       (kvm_vcpu_has_pmu(vcpu) &&                                                              \
> > +        FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),                                  \
> > +                IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
> >
> >  u8 kvm_arm_pmu_get_pmuver_limit(void);
> >
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >

Thanks,
Jing
