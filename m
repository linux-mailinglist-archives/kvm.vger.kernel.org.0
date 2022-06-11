Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FC4547723
	for <lists+kvm@lfdr.de>; Sat, 11 Jun 2022 20:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiFKSiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jun 2022 14:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiFKSiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Jun 2022 14:38:08 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C3321825
        for <kvm@vger.kernel.org>; Sat, 11 Jun 2022 11:38:07 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id r206so3212787oib.8
        for <kvm@vger.kernel.org>; Sat, 11 Jun 2022 11:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xs8uTlhkm0yxZvl9ZPv6y+oBdIiDVMBnaFckx2/YwFs=;
        b=qrlIf23QC+/+YYfd/iBrITJEsFMxAPmrYnqxIPxctSu9Mne3uXPHRxFUKjfmAVijrw
         VW9X34uewzK5wSBrQROA4iDpRVtITeafCoe78LMSDERdm7xYf3HRkwgOpXtHF6m9ts+v
         YSJO2bBDqsJ7WFvP7/qOJ7bGd8+9bolMun6rpUsE/tmosL6tmHsSADf9HNrJ7+WYnfWZ
         Xa+zDJkDfP/0eX2D3ubwAylb0IKjXEOTCFmRdv2vAU+T+vguB92CQlISjY2Ei2logeOu
         HWzAL5B68l8S7kEmFkWNMu+CxRXYbjVMXHs61/W3NHn4PI2m2rPr4ms+8B8j76/bQkje
         sFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xs8uTlhkm0yxZvl9ZPv6y+oBdIiDVMBnaFckx2/YwFs=;
        b=bqBkZMU0Z2igN2d8Yq54SZhUftCiZzP21a1MMN7N3E3lBKL4mK1aeH8HG0xF7f6tTb
         euERysxAyWRF6cDHuvhG5U/KhybnIvPQSuBebxj7bpYMHl10X4pvQnXBDFY36zNHZ7Kz
         6BnPB4Sr71D4AbN39KD5zx3gaGCQmt9YIQpyl1UtXcd0UUvczC64PNBOZbvakdbT88ct
         85xtlDkOz0PQl1HIH9N4UxJLHDH3tQu96gt4SSywsK7eGrtSNkabEvjbQiYQvX+Y6JA4
         IJzJG8c8ptnvrBM4rlvs627IhJ0uCDnar+tphNEKIViKR2UhbpLBgt9N3vh6CJqMj64C
         I/zw==
X-Gm-Message-State: AOAM531Ns8xA4ijyWknwR4fN2FVY0A/FBneyqcGKx7tUa6ByCQ3C8n2g
        F09bBJ1jSM4jZ1A3b/lh4z19xWt1Tf1QW25M2Nvj4g==
X-Google-Smtp-Source: ABdhPJw7tXu1b8dVOKxTSnAh5gbv8di1OCAQ1O999DYbmxN1zbqRW6SfDG7qKBmoytsNW4pLT2zLJrDJcRtYbxdRcJo=
X-Received: by 2002:aca:1901:0:b0:32f:7cf:db5e with SMTP id
 l1-20020aca1901000000b0032f07cfdb5emr2983324oii.16.1654972686314; Sat, 11 Jun
 2022 11:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220610092838.1205755-1-maz@kernel.org> <20220610092838.1205755-6-maz@kernel.org>
In-Reply-To: <20220610092838.1205755-6-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 11 Jun 2022 11:37:50 -0700
Message-ID: <CAAeT=Fxu+s7JNYP-U-ov2yqhLVp7Nvf_yox0JaVZh06a=rHwzg@mail.gmail.com>
Subject: Re: [PATCH v2 05/19] KVM: arm64: Add helpers to manipulate vcpu flags
 among a set
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com
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

On Fri, Jun 10, 2022 at 2:28 AM Marc Zyngier <maz@kernel.org> wrote:
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

Reviewed-by: Reiji Watanabe <reijiw@google.com>

IMHO I would prefer to have 'v' enclosed in parentheses in the
implementation of __vcpu_{get,set,clear}_flag rather than in
the implementation of vcpu_{get,set,clear}_flag though.
(That was what I meant in my comment for v1)

Thanks,
Reiji

> +#define vcpu_get_flag(v, ...)  __vcpu_get_flag((v), __VA_ARGS__)
> +#define vcpu_set_flag(v, ...)  __vcpu_set_flag((v), __VA_ARGS__)
> +#define vcpu_clear_flag(v, ...)        __vcpu_clear_flag((v), __VA_ARGS__)
> +
> +
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
>                              sve_ffr_offset((vcpu)->arch.sve_max_vl))
> --
> 2.34.1
>
