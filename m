Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208D35A1FE4
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 06:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244652AbiHZEeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 00:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbiHZEeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 00:34:19 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D208BCD7A5
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 21:34:17 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id d14so162931ual.9
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 21:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=4Hu0rO8zG72NHJho0aO6SAbm6Tq2VbIsxhqXb5H0q+o=;
        b=jX/fbSZgb102YlcVtGLQfgdzgGnMYamLbssIUN/GEPTAszBrleoBMFtyL240p5mHv0
         h2xxtWr8VA45O2ritPAxrh9MfAMooSJESzldSjhPJ2mu6s17jyuTRjwvWikq+p9uKXt7
         nyY/uVy4Dau4rwCkxnQSEtfdySr+pdT2ktasBzYTYYPbx9/kuMBPCBWidRaojMuZ3iaU
         u/hbIqBQdJHJ7hzXv3BzauJYGQgJPpdAuOE0fKOrdMe6VlOg2SlopZzODgy9epMordPY
         eqNFcW8Lkjb00Xc/6drZAeIV13aclpnoewJ9+qOnT6QlJCXSJ9iRmuYKQx+yRRfpY9G6
         AKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=4Hu0rO8zG72NHJho0aO6SAbm6Tq2VbIsxhqXb5H0q+o=;
        b=0SOWErZCHlCsaV4Z9XI0YS1hnIRSubPbWhAEK12QHlVNGkOfbeBBZn8uAFQqVFyYqn
         4uPKH/R8sv2Ct3rR0TiUa0bvRBLzNEeaGDbckaAkoaJMbdbVVQNRZ9WoWbWBdnT+rfBz
         1wfK8I9dXsAqmmr55rswGHlfEXyOPoY7n72nly5Ep+j7aZgAxizDKsinyZw5LsK0Yo2V
         y778U2Mj6W3FGorKfUQmmWbcAvrirOtZBPcH6lCProiXdHxkkkN29cU1t4NmDs4FIVfc
         DjyavfcV8UjYG93VjSuiUdgcqKIFmXoC3BcOAzLHb2JJYhTn6V1yQB38PWgHwJ9a5sIV
         FLzQ==
X-Gm-Message-State: ACgBeo2u/qmRWIkWvqKe5V2i04P/1zMreBqmoW6OmkPQwMsQ16mgXsLl
        dcQTlnTkQ+HcnE22yMkqhCcNmSwMW+o2K0kj2/tLkLUSzWA85g==
X-Google-Smtp-Source: AA6agR7/RKAs0E6jrT0i52j7V9NOIYq3DwZJIFlTOaz7LTbxucLEE9/EHM8ghuH4Cw5QLQ1j5sI/C979ZNVWpAI0/c0=
X-Received: by 2002:ab0:13ed:0:b0:39a:2447:e4ae with SMTP id
 n42-20020ab013ed000000b0039a2447e4aemr2567135uae.37.1661488456875; Thu, 25
 Aug 2022 21:34:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org> <20220805135813.2102034-7-maz@kernel.org>
In-Reply-To: <20220805135813.2102034-7-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 25 Aug 2022 21:34:01 -0700
Message-ID: <CAAeT=FzXyr7D24QCcwGckgnPFuo8QtN3GrPg9h+s+3uGETE9Dw@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver
 limit to VM creation
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Aug 5, 2022 at 6:58 AM Marc Zyngier <maz@kernel.org> wrote:
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
>  arch/arm64/kvm/arm.c              |  6 ++++++
>  arch/arm64/kvm/pmu-emul.c         | 11 +++++++++++
>  arch/arm64/kvm/sys_regs.c         | 26 +++++++++++++++++++++-----
>  include/kvm/arm_pmu.h             |  6 ++++++
>  5 files changed, 45 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f38ef299f13b..411114510634 100644
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
> index 8fe73ee5fa84..e4f80f0c1e97 100644
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
> +       kvm->arch.dfr0_pmuver = kvm_arm_pmu_get_host_pmuver();
> +
>         return ret;
>  out_free_stage2_pgd:
>         kvm_free_stage2_pgd(&kvm->arch.mmu);
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index ddd79b64b38a..33a88ca7b7fd 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1021,3 +1021,14 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>         return -ENXIO;
>  }
> +
> +u8 kvm_arm_pmu_get_host_pmuver(void)

Nit: Since this function doesn't simply return the host's pmuver, but the
pmuver limit for guests, perhaps "kvm_arm_pmu_get_guest_pmuver_limit"
might be more clear (closer to what it does) ?

> +{
> +       u64 tmp;
> +
> +       tmp = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> +       tmp = cpuid_feature_cap_perfmon_field(tmp,
> +                                             ID_AA64DFR0_PMUVER_SHIFT,
> +                                             ID_AA64DFR0_PMUVER_8_4);
> +       return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), tmp);
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 333efddb1e27..55451f49017c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1062,6 +1062,22 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>         return true;
>  }
>
> +static u8 pmuver_to_perfmon(const struct kvm_vcpu *vcpu)
> +{
> +       if (!kvm_vcpu_has_pmu(vcpu))
> +               return 0;
> +
> +       switch (vcpu->kvm->arch.dfr0_pmuver) {
> +       case ID_AA64DFR0_PMUVER_8_0:
> +               return ID_DFR0_PERFMON_8_0;
> +       case ID_AA64DFR0_PMUVER_IMP_DEF:
> +               return 0;
> +       default:
> +               /* Anything ARMv8.4+ has the same value. For now. */
> +               return vcpu->kvm->arch.dfr0_pmuver;
> +       }
> +}
> +
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>                 struct sys_reg_desc const *r, bool raz)
> @@ -1112,10 +1128,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>                 /* Limit debug to ARMv8.0 */
>                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER);
>                 val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), 6);
> -               /* Limit guests to PMUv3 for ARMv8.4 */
> -               val = cpuid_feature_cap_perfmon_field(val,
> -                                                     ID_AA64DFR0_PMUVER_SHIFT,
> -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
> +               /* Set PMUver to the required version */
> +               val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER);
> +               val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER),
> +                                 kvm_vcpu_has_pmu(vcpu) ? vcpu->kvm->arch.dfr0_pmuver : 0);
>                 /* Hide SPE from guests */
>                 val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_PMSVER);
>                 break;
> @@ -1123,7 +1139,7 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>                 /* Limit guests to PMUv3 for ARMv8.4 */

Nit: I think the comment above should be removed like you did for
ID_AA64DFR0_EL1 (or move it to kvm_arm_pmu_get_host_pmuver()?).

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you,
Reiji



>                 val = cpuid_feature_cap_perfmon_field(val,
>                                                       ID_DFR0_PERFMON_SHIFT,
> -                                                     kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_4 : 0);
> +                                                     pmuver_to_perfmon(vcpu));
>                 break;
>         }
>
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 96b192139a23..6bda9b071084 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -89,6 +89,8 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>                         vcpu->arch.pmu.events = *kvm_get_pmu_events();  \
>         } while (0)
>
> +u8 kvm_arm_pmu_get_host_pmuver(void);
> +
>  #else
>  struct kvm_pmu {
>  };
> @@ -154,6 +156,10 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>  static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> +static inline u8 kvm_arm_pmu_get_host_pmuver(void)
> +{
> +       return 0;
> +}
>
>  #endif
>
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
