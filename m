Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C764E546713
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 15:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343662AbiFJNG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 09:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242513AbiFJNGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 09:06:25 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A942A70B
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 06:06:23 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 93-20020a9d02e6000000b0060c252ee7a4so3365560otl.13
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 06:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ebXiX+kepLI2Qw0XY13GE4xS0GXBZo65rTV2JEU/MI=;
        b=r0iXm+ECrwbIGGwW7KlGtF0yJdsBcMHlE4hMJ4SXOUPArR/ih29baGIkqdoRmEseEO
         kR4ufVtDPBFugWHxlY7YlXTKmBAIoksSW5tPnHjVFjdSh9i2FF9CKThov13NopQrgpWB
         19vdsedFXIhd34+lTvRp9X9LsN7xm1M0e039aKwuPwBiRbEh1P2CtC+p94HOxhrJVGkR
         mfCQ4+IY/l0D5RERjRqFNKVHbwCSHy0SzH95s/OytvEmAQcKC8j3JBnAXSEm70rcX+RU
         m/meheKnwOW3RgIihgkqS9JFFSHKVIlyDa4QtXlE6LPrzWLG1WOIddzEuKROHlt4qZ8f
         rDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ebXiX+kepLI2Qw0XY13GE4xS0GXBZo65rTV2JEU/MI=;
        b=J6UQoqbAShP8PJY+DdPtbTWivCPNC2kI+22P2DCXWvtDyhKjzNNF6u3mFYiajiCAoP
         0Z4Xim00tILas4cgBGfOrwlDDDnWk14lmXv+OsQvQdATDH0yha1oy/wfWmSlWdHtuh5M
         9JcNchww83JrU/bvd0ErbTj6mNUmPIAct6sSRcBgxFBbUbGC+6ksFtnmxNo1M1FkdKEf
         6T4VLzb5kK8pmThyx5Dey4JDsplGY8XqSJx7/SruuGQCxbL26YFZYmHONsp1ve9YrKsd
         Uk/dqsoGa+BLKMGAjVkFDlPNYFQYhgmPykSucn4+rbB5ETcdpZr5Tpd8pmR289FFfUMN
         fmRA==
X-Gm-Message-State: AOAM532INiSRK+47sSmQ4Bcjf+mkZ51hIq0aY72suoGZqPJnCAbMUjfn
        JnoPce6tEKk/3+FkEmyE2DJKmUaF03qf1qo3+ryFQ4EV0Mc=
X-Google-Smtp-Source: ABdhPJws07QUSYA+aDl5QUraZzBJCoFdEH8iiTu7BE5zOytCnaRv8bQE/ltNd6eD1MjkNjL1RwSMLW116iSLjnB0qJc=
X-Received: by 2002:a9d:7057:0:b0:60c:406e:1a7 with SMTP id
 x23-20020a9d7057000000b0060c406e01a7mr206631otj.299.1654866382571; Fri, 10
 Jun 2022 06:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220610092838.1205755-1-maz@kernel.org> <20220610092838.1205755-6-maz@kernel.org>
In-Reply-To: <20220610092838.1205755-6-maz@kernel.org>
From:   Fuad Tabba <tabba@google.com>
Date:   Fri, 10 Jun 2022 14:05:46 +0100
Message-ID: <CA+EHjTw_ZJREm+E2PEqB8etjaDNN7psT9p09WQU=Tp3YvB_bkw@mail.gmail.com>
Subject: Re: [PATCH v2 05/19] KVM: arm64: Add helpers to manipulate vcpu flags
 among a set
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
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

Hi Marc,

On Fri, Jun 10, 2022 at 10:28 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Careful analysis of the vcpu flags show that this is a mix of
> configuration, communication between the host and the hypervisor,
> as well as anciliary state that has no consistency. It'd be a lot
> better if we could split these flags into consistent categories.
>
> However, even if we split these flags apart, we want to make sure
> that each flag can only be applied to its own set, and not across
> sets.
>
> To achieve this, use a preprocessor hack so that each flag is always
> associated with:
>
> - the set that contains it,
>
> - a mask that describe all the bits that contain it (for a simple
>   flag, this is the same thing as the flag itself, but we will
>   eventually have values that cover multiple bits at once).
>
> Each flag is thus a triplet that is not directly usable as a value,
> but used by three helpers that allow the flag to be set, cleared,
> and fetched. By mandating the use of such helper, we can easily
> enforce that a flag can only be used with the set it belongs to.
>
> Finally, one last helper "unpacks" the raw value from the triplet
> that represents a flag, which is useful for multi-bit values that
> need to be enumerated (in a switch statement, for example).
>
> Further patches will start making use of this infrastructure.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 44 +++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 372c5642cfab..6d30ac7e3164 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -415,6 +415,50 @@ struct kvm_vcpu_arch {
>         } steal;
>  };
>
> +/*
> + * Each 'flag' is composed of a comma-separated triplet:
> + *
> + * - the flag-set it belongs to in the vcpu->arch structure
> + * - the value for that flag
> + * - the mask for that flag
> + *
> + *  __vcpu_single_flag() builds such a triplet for a single-bit flag.
> + * unpack_vcpu_flag() extract the flag value from the triplet for
> + * direct use outside of the flag accessors.
> + */
> +#define __vcpu_single_flag(_set, _f)   _set, (_f), (_f)
> +
> +#define __unpack_flag(_set, _f, _m)    _f
> +#define unpack_vcpu_flag(...)          __unpack_flag(__VA_ARGS__)
> +
> +#define __vcpu_get_flag(v, flagset, f, m)                      \
> +       ({                                                      \
> +               v->arch.flagset & (m);                          \
> +       })
> +
> +#define __vcpu_set_flag(v, flagset, f, m)                      \
> +       do {                                                    \
> +               typeof(v->arch.flagset) *fset;                  \
> +                                                               \
> +               fset = &v->arch.flagset;                        \
> +               if (HWEIGHT(m) > 1)                             \
> +                       *fset &= ~(m);                          \
> +               *fset |= (f);                                   \
> +       } while (0)
> +
> +#define __vcpu_clear_flag(v, flagset, f, m)                    \
> +       do {                                                    \
> +               typeof(v->arch.flagset) *fset;                  \
> +                                                               \
> +               fset = &v->arch.flagset;                        \
> +               *fset &= ~(m);                                  \
> +       } while (0)
> +
> +#define vcpu_get_flag(v, ...)  __vcpu_get_flag((v), __VA_ARGS__)
> +#define vcpu_set_flag(v, ...)  __vcpu_set_flag((v), __VA_ARGS__)
> +#define vcpu_clear_flag(v, ...)        __vcpu_clear_flag((v), __VA_ARGS__)
> +
> +
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
>                              sve_ffr_offset((vcpu)->arch.sve_max_vl))

A bit of macro magic going on here, but with some help I think I've
wrapped my head around it. With that

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> --
> 2.34.1
>
