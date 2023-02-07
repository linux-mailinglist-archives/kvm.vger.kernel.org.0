Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5A468CF03
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 06:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjBGFa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 00:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjBGFaW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 00:30:22 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193032B63E
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 21:30:06 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d2so10203029pjd.5
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 21:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wvb+XdJ65X85Ikm3/pcMB5vsFDk7JabNhMEJG/99I1k=;
        b=EUQ56BUlF1VcY9rlUhFr3Y3hK0tuyGpgsjgei3eSoZEqcKrvsBYtYn0mUn/iBR4YK2
         E+/gZ4Pm07VxkxrVqiDtd4iW0jDCWx3Y9elzmQCDQnzY2xLHxgFeF1rgsMRFTIaP4vyM
         JGklmhP4fAh0KUFqsFW0E8wr8bWvaBquy5MVGoJGkV0Cvd2+5YwyyQxm9ZpowbvacSBT
         qMmE3Xn2Y98vYmlNEkNOZVLRXQGyOL30J4Vh+46sAHMcRil5AfSeo6MfXamIqjI+ijCm
         Pob2h31ldAnz4JoFYn0WgWGJHJ/i6HMWC2zf2gf7fSLYyHzbK2h9u5Im9J+pRvLtdHjx
         nR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wvb+XdJ65X85Ikm3/pcMB5vsFDk7JabNhMEJG/99I1k=;
        b=HrYqbkhEqU2RbKFI+37/A6GGKs6IibZVq+/0kENhQg6qDYL9D1SvSIalGDIzh8M2dW
         ti4F/M//LUwMNB8HCEf8vYBrmf06WBBJSxyih+UtIv2KYM2Wh5B0dwQCco4C2Mx4P9It
         O9lHRGFZmEAxos7/imanWzeSW+quA/cZnc9tQYuav8Hmjax7AP+7uhJKwKEABh5dc+rb
         wNuqQeb9rBRpdo1aGOTOpqe9uPVRYQuiLRsQRM+3rRKvpbUYIKacNrzqHi66YyaxaHbc
         rdoLeecAhEKSFRjHV9NPIpb6PozEYCsKV/Po47uPdwuVBGymp1LX5urhhkCGhZGhJr3w
         xoTg==
X-Gm-Message-State: AO0yUKWKsr1ra6NO2h+2Y8qxBTeY+h6P5cWtQaT2H3YXsC//1s4hmtUs
        KJmwJDUhn1W22rHmErbzaLJhKxkfP2M1vscRUH872w==
X-Google-Smtp-Source: AK7set8uCBqw0CGO0CUU8VeqCYy9ApBNiIuh8p72WFZVv2u+GSmiNYx4rNDv50KH3OV5QeAudPVs4K/RY7NzUyXn8Kg=
X-Received: by 2002:a17:90b:198d:b0:230:d99b:5ac8 with SMTP id
 mv13-20020a17090b198d00b00230d99b5ac8mr675363pjb.91.1675747805127; Mon, 06
 Feb 2023 21:30:05 -0800 (PST)
MIME-Version: 1.0
References: <20230201025048.205820-1-jingzhangos@google.com> <20230201025048.205820-5-jingzhangos@google.com>
In-Reply-To: <20230201025048.205820-5-jingzhangos@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 6 Feb 2023 21:29:48 -0800
Message-ID: <CAAeT=Fy8PN3i-FTMN+c8dauP8qToXZM_toaUx=34Y4hima8teQ@mail.gmail.com>
Subject: Re: [PATCH v1 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
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

On Tue, Jan 31, 2023 at 6:51 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> With per guest ID registers, PMUver settings from userspace
> can be stored in its corresponding ID register.
>
> No functional change intended.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  5 -----
>  arch/arm64/kvm/arm.c              |  6 ------
>  arch/arm64/kvm/id_regs.c          | 33 ++++++++++++++++++++-----------
>  include/kvm/arm_pmu.h             |  6 ++++--
>  4 files changed, 25 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index fabb30185a4a..1ab443b52c46 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -225,11 +225,6 @@ struct kvm_arch {
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
> index d8ba5106bf51..25bd95650223 100644
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
> index bc5d9bc84eb1..5eade7d380af 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -19,10 +19,12 @@
>
>  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
>  {
> -       if (kvm_vcpu_has_pmu(vcpu))
> -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> -
> -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> +       u8 pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> +                       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> +       if (kvm_vcpu_has_pmu(vcpu) || pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> +               return pmuver;
> +       else
> +               return 0;
>  }
>
>  static u8 perfmon_to_pmuver(u8 perfmon)
> @@ -263,10 +265,9 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
>         if (val)
>                 return -EINVAL;
>
> -       if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> -       else
> -               vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
> +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
> +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);

Did you consider there could be guests that have vCPUs with and
without PMU ? It looks like the code doesn't work for such guests.
(e.g. for such guests, if setting the register is done for vCPUs
 without PMU, this code seems to make PMUVer zero or 0xf
 even for vCPUs with PMU)

Thanks,
Reiji

>
>         return 0;
>  }
> @@ -303,10 +304,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>         if (val)
>                 return -EINVAL;
>
> -       if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> -       else
> -               vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
> +       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> +       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
> +               FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
>
>         return 0;
>  }
> @@ -530,4 +530,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
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
> 2.39.1.456.gfc5497dd1b-goog
>
