Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133BD542781
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 09:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbiFHHGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 03:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244290AbiFHGKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 02:10:33 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CF643C4EE
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 22:27:07 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-fe15832ce5so210921fac.8
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 22:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gQbcZrMkiRKMjcf000Vd/gxeTXgq7dDJP9T2Rzdx8bA=;
        b=KGm67M6fDCiCqTOD+LgzJn4tRzL5H7Jda/FE6ARw7gzoEKIY5J0oqwXOwdNJDMJsu3
         39CDY34/gPUYqHQAHfx585CQyQOsngHesG7LmRpNWtzAEOe8pSPllepAlk3qj8rkOOJx
         jtsBLs22d0ca7iQlvbiycgd5kand0QO1Z+QwTErbDG8VuIfNKH9c/+tRbb/QHqNp4nsR
         IbNX+zROkrIETwJNFzc6dNF2zipkaJ11ekObK3JJmeSlMoDX1zZqKBcUvYygjX/07E36
         0MjYcPwKSEExVWONnqlKQNirtPD0YzLo/OWDGvoXegrfNRR+fGjRY3RQ13qOdOh3Dh/m
         G9/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gQbcZrMkiRKMjcf000Vd/gxeTXgq7dDJP9T2Rzdx8bA=;
        b=N5bjNQuYNs97MdqmF7cZQVIDwQEY7/LdNnWiPaCEtt+Y7Hgj14thB79Qfo1pGHhtD3
         dxoIhcIoitPP7CfSU79mWLltqRGVlMxArhMI97DEHFGXrPrspTtBEzTQRhNAGHd15QfQ
         /JO+kw+uA5CcgMpkmfIz9I4h685nBm/FlYs0JJrfkKDmlzZld01rb5+P02O/WXYVZL34
         1xsLGecRwiAp2DOk3WyPbHB4K6zAiJ4mHfoO8I2z4/hwtLq9+1UWUw43kpQjEpfIlEw/
         7wg18qWEdRomanaf2Ngo9TvEQaB1iDBixvB5E/ToqD7b3mQ0ggj8dYCy2vLg88nzHZ/o
         gvVw==
X-Gm-Message-State: AOAM531KpVSldU0Nm8fN1wKwGEEQrk39E80kcIOMLFSBpmV4RPsMjHoM
        Vy5H0T5pOGb7q6Brk2wtuzfceIAgrcJxW5f4fVz4K/mzd2plhA==
X-Google-Smtp-Source: ABdhPJyD1Nj5fusNP7VUimclAcbSfNFTD3GX5Z7nqpmH/vYRX4nSJ941ftf6wvyOic24AJEisuI5sK+oKKb0Zx57B0k=
X-Received: by 2002:a05:6870:5a8:b0:f4:2cf8:77eb with SMTP id
 m40-20020a05687005a800b000f42cf877ebmr1417214oap.16.1654666020584; Tue, 07
 Jun 2022 22:27:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220528113829.1043361-1-maz@kernel.org> <20220528113829.1043361-6-maz@kernel.org>
In-Reply-To: <20220528113829.1043361-6-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 7 Jun 2022 22:26:44 -0700
Message-ID: <CAAeT=FyruEc5pDhdg0wOtFcV0EFUnhOVyt+o5BMfn5GsooM9Jw@mail.gmail.com>
Subject: Re: [PATCH 05/18] KVM: arm64: Add helpers to manipulate vcpu flags
 among a set
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kernel-team@android.com, Will Deacon <will@kernel.org>,
        Mark Brown <broonie@kernel.org>
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

On Sat, May 28, 2022 at 4:38 AM Marc Zyngier <maz@kernel.org> wrote:
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
>  arch/arm64/include/asm/kvm_host.h | 33 +++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index a46f952b97f6..5eb6791df608 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -418,6 +418,39 @@ struct kvm_vcpu_arch {
>         } steal;
>  };
>
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

I think 'v' should be enclosed in parentheses in those three macros.


> +
> +#define vcpu_get_flag(v, ...)  __vcpu_get_flag(v, __VA_ARGS__)
> +#define vcpu_set_flag(v, ...)  __vcpu_set_flag(v, __VA_ARGS__)
> +#define vcpu_clear_flag(v, ...)        __vcpu_clear_flag(v, __VA_ARGS__)
> +
> +#define __vcpu_single_flag(_set, _f)   _set, (_f), (_f)
> +
> +#define __flag_unpack(_set, _f, _m)    _f

Nit: Probably it might be worth adding a comment that explains the
above two macros ? (e.g. what is each element of the triplets ?)

> +#define vcpu_flag_unpack(...)          __flag_unpack(__VA_ARGS__)

Minor nit: KVM Functions and macros whose names begin with "vcpu_"
make me think that they are the operations for a vCPU specified in
the argument, but this macro is not (this might just my own
assumption?). So, IMHO I would prefer a name whose prefix is not
"vcpu_". Having said that, I don't have any good suggestions though...
Perhaps I might prefer "unpack_vcpu_flag" a bit instead?

Thanks,
Reiji

> +
> +
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
>                              sve_ffr_offset((vcpu)->arch.sve_max_vl))
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
