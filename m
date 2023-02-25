Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4EA6A26D2
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 03:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBYCgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 21:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBYCgG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 21:36:06 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C481B2DD
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 18:36:04 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so1111411pjz.1
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 18:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oJ4h5Gqoyl05jSC/FXmh53k03kp+gFsTu89ZEOLEYMg=;
        b=Ix3+5FH8YfS1+VGeYEXLuBQZPzo2WZCOWWrA3ac5Gg22L8VNhcoz928BknbmdFbjny
         kaz46jJRwxN/8jO9KIzkcJyNc3meYusVaqi41SgEQKUlXDTVMCfF9HexiGNFXlHUJdik
         iLpRxuOgys6JwfbUuxT2qnjoEeLa9j49M3dkdmsuJFLTNDxexgQvCKQFVX4r0VTbvWtR
         /pF1LlpY0ot4y4imKuobKWUod5mkbzmI+eFL/a6IzgmSCZ41iNcr+km2FgUdtBtaq8TF
         nReVGNVOdGUbB/LxFvLPSSo7Wf/Hg+G/r1Tx5OU3uzT3QgpJqcQeMMaAakBaT/+NHmnr
         mP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJ4h5Gqoyl05jSC/FXmh53k03kp+gFsTu89ZEOLEYMg=;
        b=zx3xc72bXuleTfGlS8d5isfEjKs++eCTCofUa+3ixoTUXV3A+6LZ/okJNA4QCFGTYE
         kGIcOpQ5jZo/HR1lqeHOFj6Q8xnWYwLeWgrfpnJo9D5bgatuYd7JDT6Eq2QdHxIf6thj
         AQixJ6l6bvyvzmGfxhpuR2gBV2L6yvCiFWP/ZiAqZ0XlCbymvz6wJN4+NrCqNMGh8yGh
         S9DGkGLTzLSFrO9ebbagfv5BIAsrgpaUfvNeOiXIZDPVsOkYfPFHc/GAGynr/HScH5NJ
         d49BdqNYgG59yRUt3EwdC8T2zjrid3l4uZa3/0gmY+j5z9JMqi3qyS4Zwgf+2c8ocW3P
         6dZg==
X-Gm-Message-State: AO0yUKWZxwV+npv+F+k4yZ7DHcS9UKxdsB4YcI7xZkR53uGdqXbk9q+b
        smVYlsUAnb72ouPqmcO9QVecNxreJojS/WMRViXYvw==
X-Google-Smtp-Source: AK7set/Jp9EcqT0pkztNybGqBbTHDrVZWovLCFuf4Jsdhl/SusPMRD3rZHrZFa41Y7d8yyj2IrXuDBTyREmnPerDazg=
X-Received: by 2002:a17:902:f782:b0:19c:b3ce:d316 with SMTP id
 q2-20020a170902f78200b0019cb3ced316mr2788547pln.2.1677292563766; Fri, 24 Feb
 2023 18:36:03 -0800 (PST)
MIME-Version: 1.0
References: <20230212215830.2975485-1-jingzhangos@google.com> <20230212215830.2975485-5-jingzhangos@google.com>
In-Reply-To: <20230212215830.2975485-5-jingzhangos@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 24 Feb 2023 18:35:47 -0800
Message-ID: <CAAeT=FxXNvkd4qg83oYciahbADGPSoHb+KYRfrCRWx2s43b7qA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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

Hi Jing,

On Sun, Feb 12, 2023 at 1:58 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> With per guest ID registers, PMUver settings from userspace
> can be stored in its corresponding ID register.
>
> No functional change intended.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 11 ++++----
>  arch/arm64/kvm/arm.c              |  6 -----
>  arch/arm64/kvm/id_regs.c          | 44 +++++++++++++++++++++++--------
>  include/kvm/arm_pmu.h             |  6 +++--
>  4 files changed, 43 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f64347eb77c2..effb61a9a855 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -218,6 +218,12 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_EL1_32BIT                                4
>         /* PSCI SYSTEM_SUSPEND enabled for the guest */
>  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
> +       /*
> +        * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
> +        * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
> +        * userspace for VCPUs without PMU.
> +        */
> +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU

As Oliver suggested, it might be better to not expose IMPDEF PMU
(but expose as 0), since it is not effectively supported by KVM.
(We need to be careful not to have migration from old KVM fail though)


>
>         unsigned long flags;
>
> @@ -230,11 +236,6 @@ struct kvm_arch {
>
>         cpumask_var_t supported_cpus;
>
> -       struct {
> -               u8 imp:4;
> -               u8 unimp:4;
> -       } dfr0_pmuver;
> -
>         /* Hypercall features firmware registers' descriptor */
>         struct kvm_smccc_features smccc_feat;
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c78d68d011cb..fb2de2cb98cb 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         kvm_arm_set_default_id_regs(kvm);
>         kvm_arm_init_hypercalls(kvm);
>
> -       /*
> -        * Initialise the default PMUver before there is a chance to
> -        * create an actual PMU.
> -        */
> -       kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
> -
>         return 0;
>
>  err_free_cpumask:
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index bc4c408a43eb..14ae03a1d8d0 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -21,9 +21,12 @@
>  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
>  {
>         if (kvm_vcpu_has_pmu(vcpu))
> -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> -
> -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> +               return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> +                               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> +       else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
> +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> +       else
> +               return 0;
>  }
>
>  static u8 perfmon_to_pmuver(u8 perfmon)
> @@ -267,10 +270,15 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>         if (val)
>                 return -EINVAL;
>
> -       if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> -       else
> -               vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
> +       if (valid_pmu) {
> +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
> +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);

The original code keeps ID_AA64DFR0_EL1.PMUVer and ID_DFR0_EL1.PerfMon
values consistent (if one of them is update, the other one is also
updated accordingly).  To keep the same behavior, shouldn't we update
the other one as well when one of them is updated ?

Thank you,
Reiji


> +       } else if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> +       } else {
> +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> +       }
>
>         return 0;
>  }
> @@ -307,10 +315,15 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>         if (val)
>                 return -EINVAL;
>
> -       if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> -       else
> -               vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
> +       if (valid_pmu) {
> +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
> +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
> +       } else if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
> +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> +       } else {
> +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> +       }
>
>         return 0;
>  }
> @@ -534,4 +547,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
>         }
>
>         IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
> +
> +       /*
> +        * Initialise the default PMUver before there is a chance to
> +        * create an actual PMU.
> +        */
> +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=
> +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> +                          kvm_arm_pmu_get_pmuver_limit());
>  }
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 628775334d5e..eef67b7d9751 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>  /*
>   * Evaluates as true when emulating PMUv3p5, and false otherwise.
>   */
> -#define kvm_pmu_is_3p5(vcpu)                                           \
> -       (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
> +#define kvm_pmu_is_3p5(vcpu)                                                                   \
> +       (kvm_vcpu_has_pmu(vcpu) &&                                                              \
> +        FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),                                  \
> +                IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
>
>  u8 kvm_arm_pmu_get_pmuver_limit(void);
>
> --
> 2.39.1.581.gbfd45094c4-goog
>
