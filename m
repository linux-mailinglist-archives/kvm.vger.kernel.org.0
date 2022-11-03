Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30786175D6
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 05:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiKCE4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 00:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiKCE4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 00:56:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B153618B0C
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 21:56:09 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso4120669pjg.5
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 21:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfT+xH5daIHfYda7w4iKG23dA4fhlMkgmp12GuuMJAM=;
        b=RE1TEVrDFGOK40SDV8n92DwtM4R9QdvpnuP044aLs0Tuu7el3qO6aAjlog9lGXsaKM
         K7aaaLAOip9lO+NRhSbQBhZM+2353CSMLkHb72WNswRW73S8zlVsoRk4X9xcGPxxtxoD
         C9milF/3HzcTTywzmERWlnIuUIP5inF9pJSdl8O05YQ27CjkjMebR65EbeCpEKQ4ix9l
         J0LkfvqqpFZbgtV+9JfrwfveK5fEjvNkH45Apo2eNhueNGHBF57kWiL6aKpHa+bqkwyj
         eMgz7+ahe8p6MYa1CgaN4zqpkMS8QB00PTXVWCVSM5OHdxIQ5bFFJU4i5oSbfZf2yrSS
         DS5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZfT+xH5daIHfYda7w4iKG23dA4fhlMkgmp12GuuMJAM=;
        b=Ov2Phq10FypwNDfoqYn6h81FyJB1HsADQ/oDde0x8J7OdaNqO7v1T7PUBBazMt0w8g
         /QFIAr1kzh7I94RgauEzQ1dwv+yWRqzldOEZDURsWidiQnuHrYEHTgnz9QR4TEeiXZyq
         jv8xXGu0VHdAO3v1E0h6U6BMQjsaIKbnsHsy1CbQRMHp+zVkY5xKiMgsQdfzpkN3dNgu
         0nVxqDQpxUp3tJhHFvP+DFb+wWjeeFanheIOcS/vqNNyfiRQIL94hfQvdu2KMcFT5yk+
         km2Y68ZKRi43SfMXR/Aoks7f1wvQuAQPRx7JARD4uHOut9/RI+80yU3H2SFbGYTAdSXH
         GPUg==
X-Gm-Message-State: ACrzQf1X8Cw+B5goTRskF9vNOc4l3gBTZhnZVxE7RUNNnb0j/s907Gwc
        +7KWHDww01MfXv0LG4aAY5qmfcQ8Z8Kcf44wH6Ax9w==
X-Google-Smtp-Source: AMsMyM6h9BIasxCM9PdF/S+diyYhRBJW3VJCIBBriIZjDYXzzAy7xOtE0u5r7Dfk7N3A9fWqvstnPwFejtEzJeLWzM8=
X-Received: by 2002:a17:902:9049:b0:180:7922:ce36 with SMTP id
 w9-20020a170902904900b001807922ce36mr29190830plz.30.1667451369015; Wed, 02
 Nov 2022 21:56:09 -0700 (PDT)
MIME-Version: 1.0
References: <20221028105402.2030192-1-maz@kernel.org> <20221028105402.2030192-11-maz@kernel.org>
In-Reply-To: <20221028105402.2030192-11-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 2 Nov 2022 21:55:52 -0700
Message-ID: <CAAeT=FycObU5eHaR23OZ_PeR6-cQeNrmGs=Mi-VnrVuWR6ovSg@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver
 limit to VM creation
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
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

Hi Marc,

On Fri, Oct 28, 2022 at 4:16 AM Marc Zyngier <maz@kernel.org> wrote:
>
> As further patches will enable the selection of a PMU revision
> from userspace, sample the supported PMU revision at VM creation
> time, rather than building each time the ID_AA64DFR0_EL1 register
> is accessed.
>
> This shouldn't result in any change in behaviour.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/arm.c              |  6 +++++
>  arch/arm64/kvm/pmu-emul.c         | 11 +++++++++
>  arch/arm64/kvm/sys_regs.c         | 41 +++++++++++++++++++++++++------
>  include/kvm/arm_pmu.h             |  6 +++++
>  5 files changed, 57 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 45e2136322ba..90c9a2dd3f26 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -163,6 +163,7 @@ struct kvm_arch {
>
>         u8 pfr0_csv2;
>         u8 pfr0_csv3;
> +       u8 dfr0_pmuver;
>
>         /* Hypercall features firmware registers' descriptor */
>         struct kvm_smccc_features smccc_feat;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 94d33e296e10..6b3ed524630d 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -164,6 +164,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         set_default_spectre(kvm);
>         kvm_arm_init_hypercalls(kvm);
>
> +       /*
> +        * Initialise the default PMUver before there is a chance to
> +        * create an actual PMU.
> +        */
> +       kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_pmuver_limit();
> +
>         return ret;
>  out_free_stage2_pgd:
>         kvm_free_stage2_pgd(&kvm->arch.mmu);
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 87585c12ca41..f126b45aa6c6 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1049,3 +1049,14 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>         return -ENXIO;
>  }
> +
> +u8 kvm_arm_pmu_get_pmuver_limit(void)
> +{
> +       u64 tmp;
> +
> +       tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> +       tmp = cpuid_feature_cap_perfmon_field(tmp,
> +                                             ID_AA64DFR0_EL1_PMUVer_SHIFT,
> +                                             ID_AA64DFR0_EL1_PMUVer_V3P4);
> +       return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), tmp);
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f4a7c5abcbca..7a4cd644b9c0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1062,6 +1062,32 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>         return true;
>  }
>
> +static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> +{
> +       if (kvm_vcpu_has_pmu(vcpu))
> +               return vcpu->kvm->arch.dfr0_pmuver;
> +
> +       /* Special case for IMPDEF PMUs that KVM has exposed in the past... */
> +       if (vcpu->kvm->arch.dfr0_pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> +
> +       /* The real "no PMU" */
> +       return 0;
> +}
> +
> +static u8 pmuver_to_perfmon(u8 pmuver)
> +{
> +       switch (pmuver) {
> +       case ID_AA64DFR0_EL1_PMUVer_IMP:
> +               return ID_DFR0_PERFMON_8_0;
> +       case ID_AA64DFR0_EL1_PMUVer_IMP_DEF:
> +               return ID_DFR0_PERFMON_IMP_DEF;
> +       default:
> +               /* Anything ARMv8.1+ has the same value. For now. */
> +               return pmuver;
> +       }
> +}
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r)
>  {
> @@ -1111,18 +1137,17 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg_desc const *r
>                 /* Limit debug to ARMv8.0 */
>                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
>                 val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
> -               /* Limit guests to PMUv3 for ARMv8.4 */
> -               val = cpuid_feature_cap_perfmon_field(val,
> -                                                     ID_AA64DFR0_EL1_PMUVer_SHIFT,
> -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_EL1_PMUVer_V3P4 : 0);
> +               /* Set PMUver to the required version */
> +               val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> +                                 vcpu_pmuver(vcpu));
>                 /* Hide SPE from guests */
>                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
>                 break;
>         case SYS_ID_DFR0_EL1:
> -               /* Limit guests to PMUv3 for ARMv8.4 */
> -               val = cpuid_feature_cap_perfmon_field(val,
> -                                                     ID_DFR0_PERFMON_SHIFT,
> -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
> +               val &= ~ARM64_FEATURE_MASK(ID_DFR0_PERFMON);
> +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_PERFMON),
> +                                 pmuver_to_perfmon(vcpu_pmuver(vcpu)));

Shouldn't KVM expose the sanitized value as it is when AArch32 is
not supported at EL0 ? Since the register value is UNKNOWN when AArch32
is not supported at EL0, I would think this code might change the PERFMON
field value on such systems (could cause live migration to fail).

I should have noticed this with the previous version...

Thank you,
Reiji

>                 break;
>         }
>
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 96b192139a23..812f729c9108 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -89,6 +89,8 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>                         vcpu->arch.pmu.events = *kvm_get_pmu_events();  \
>         } while (0)
>
> +u8 kvm_arm_pmu_get_pmuver_limit(void);
> +
>  #else
>  struct kvm_pmu {
>  };
> @@ -154,6 +156,10 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>  static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> +static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
> +{
> +       return 0;
> +}
>
>  #endif
>
> --
> 2.34.1
>
