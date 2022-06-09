Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6595443A2
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238832AbiFIGQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbiFIGQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:16:08 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2606C13FBD3
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 23:16:07 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-fe32122311so1222665fac.7
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 23:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Z/1XTBKe1QWw98t46G1hNo7RgHv61Hc5Y6PJukHBko=;
        b=fkv+CAJR3Ffi7S0b0VTixB/Pb7JeMn6ZtnJSPTbyo34o893ptmubNaOhtImaGIow5/
         hBT02/qz5ELlaAuyx5hof3GQb79MONUthEXjruk2Pm6cxRXuAg6FKLqt8azO/XZXOpMW
         cjqv2dhW8KgLtX7WI9cm4S/v/v1KTdSkZwDKwgY7Ym4nrvHmXXHY4uVyiGpvtwqDMf8Q
         wzM0WHOAZ4WLuDIC5i4+pgMaWgCct3Cf98a7luDufg0HAIZINbx/+knXTBSmWLYmEw1B
         KWbFicxkMimB2vSE+uag41fob+QqwYqTc1nUV+dgY67jry3oIIQC9G7dBC9GZY/8QbKn
         pyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Z/1XTBKe1QWw98t46G1hNo7RgHv61Hc5Y6PJukHBko=;
        b=DUbYkBOF2Gx2rg39lhCn3d/bMM3KN56L+tscguqMVFGHOxjXceA1/K7bvrZ3Q9UoOM
         G7nzlkP+mL/KKENaT1WlJGL8AQmRz9ACyAVU3xOabvey+5aLWxP0hlkfA6b/GIawyraQ
         a3uDcZriuM78jedNRzNBmBCmc3MQ1KgvRnZeES31/lNVuqycaoEEFGXuxZMFDTq8tG3X
         qheWA/Yrk2AuUoy5Qj6BybL5lVMMUyeKEBVckflpDN2hpxWafjNsZisVfSxiEpBCEXsq
         Tc7GWrW4E5a4YqDrqQqVIowbAZs33/rzkVVzds5hnCaYfCctehONZG1O1Yp5l+nd19VQ
         B6yg==
X-Gm-Message-State: AOAM532B/bt57Uv7RBkLo3LYYPqGJxPTkn15KQrfzWAiIyU8aIVh5ksm
        ZrbJirjm8HHcXj8ABuJTiNdaf7xfG4DfXEh0oxuy6g==
X-Google-Smtp-Source: ABdhPJxuZNri2roMZCEB2LGASmwWsTjThZXGjNAEetdXoOcgFQbw6VAtsZpP1s2K4b8NuHuoFRKboLKUW48EoyIanrs=
X-Received: by 2002:a05:6870:5a8:b0:f4:2cf8:77eb with SMTP id
 m40-20020a05687005a800b000f42cf877ebmr844978oap.16.1654755366304; Wed, 08 Jun
 2022 23:16:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org> <20220528113829.1043361-8-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-8-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 8 Jun 2022 23:15:50 -0700
Message-ID: <CAAeT=FxVHfUH0=bvNxxU=L0oQk9utjeQGuozRkdSQnTMHwgaKg@mail.gmail.com>
Subject: Re: [PATCH 07/18] KVM: arm64: Move vcpu configuration flags into
 their own set
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,URI_DOTEDU,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
>
> The KVM_ARM64_{GUEST_HAS_SVE,VCPU_SVE_FINALIZED,GUEST_HAS_PTRAUTH}
> flags are purely configuration flags. Once set, they are never cleared,
> but evaluated all over the code base.
>
> Move these three flags into the configuration set in one go, using
> the new accessors, and take this opportunity to drop the KVM_ARM64_
> prefix which doesn't provide any help.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 17 ++++++++++-------
>  arch/arm64/kvm/reset.c            |  6 +++---
>  2 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c9dd0d4e22f2..2b8f1265eade 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -459,6 +459,13 @@ struct kvm_vcpu_arch {
>  #define __flag_unpack(_set, _f, _m)    _f
>  #define vcpu_flag_unpack(...)          __flag_unpack(__VA_ARGS__)
>
> +/* SVE exposed to guest */
> +#define GUEST_HAS_SVE          __vcpu_single_flag(cflags, BIT(0))
> +/* SVE config completed */
> +#define VCPU_SVE_FINALIZED     __vcpu_single_flag(cflags, BIT(1))
> +/* PTRAUTH exposed to guest */
> +#define GUEST_HAS_PTRAUTH      __vcpu_single_flag(cflags, BIT(2))
> +
>
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
> @@ -483,9 +490,6 @@ struct kvm_vcpu_arch {
>  /* vcpu_arch flags field values: */
>  #define KVM_ARM64_DEBUG_DIRTY          (1 << 0)
>  #define KVM_ARM64_HOST_SVE_ENABLED     (1 << 4) /* SVE enabled for EL0 */
> -#define KVM_ARM64_GUEST_HAS_SVE                (1 << 5) /* SVE exposed to guest */
> -#define KVM_ARM64_VCPU_SVE_FINALIZED   (1 << 6) /* SVE config completed */
> -#define KVM_ARM64_GUEST_HAS_PTRAUTH    (1 << 7) /* PTRAUTH exposed to guest */
>  #define KVM_ARM64_PENDING_EXCEPTION    (1 << 8) /* Exception pending */
>  /*
>   * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
> @@ -522,13 +526,13 @@ struct kvm_vcpu_arch {
>                                  KVM_GUESTDBG_SINGLESTEP)
>
>  #define vcpu_has_sve(vcpu) (system_supports_sve() &&                   \
> -                           ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> +                           vcpu_get_flag((vcpu), GUEST_HAS_SVE))

Minor nit: The parentheses around the vcpu above would be unnecessary.
(as was omitted for vcpu_has_ptrauth/kvm_arm_vcpu_sve_finalized)

Reviewed-by: Reiji Watanabe <reijiw@google.com>

The new infrastructure for those flags looks nice.

Thanks!
Reiji



>
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  #define vcpu_has_ptrauth(vcpu)                                         \
>         ((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||                \
>           cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&               \
> -        (vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
> +         vcpu_get_flag(vcpu, GUEST_HAS_PTRAUTH))
>  #else
>  #define vcpu_has_ptrauth(vcpu)         false
>  #endif
> @@ -885,8 +889,7 @@ void kvm_init_protected_traps(struct kvm_vcpu *vcpu);
>  int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature);
>  bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>
> -#define kvm_arm_vcpu_sve_finalized(vcpu) \
> -       ((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
> +#define kvm_arm_vcpu_sve_finalized(vcpu) vcpu_get_flag(vcpu, VCPU_SVE_FINALIZED)
>
>  #define kvm_has_mte(kvm)                                       \
>         (system_supports_mte() &&                               \
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 6c70c6f61c70..0e08fbe68715 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -81,7 +81,7 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
>          * KVM_REG_ARM64_SVE_VLS.  Allocation is deferred until
>          * kvm_arm_vcpu_finalize(), which freezes the configuration.
>          */
> -       vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SVE;
> +       vcpu_set_flag(vcpu, GUEST_HAS_SVE);
>
>         return 0;
>  }
> @@ -120,7 +120,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
>         }
>
>         vcpu->arch.sve_state = buf;
> -       vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
> +       vcpu_set_flag(vcpu, VCPU_SVE_FINALIZED);
>         return 0;
>  }
>
> @@ -177,7 +177,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>             !system_has_full_ptr_auth())
>                 return -EINVAL;
>
> -       vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
> +       vcpu_set_flag(vcpu, GUEST_HAS_PTRAUTH);
>         return 0;
>  }
>
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
