Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1569877D6E2
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 02:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240653AbjHPADg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 20:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240658AbjHPADD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 20:03:03 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1308E74
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 17:03:01 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b9b9f0387dso88914131fa.0
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 17:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692144180; x=1692748980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8FmgQMS4+VEtN3YWaf3XTC6qJSdTgKCK/OCtZRJ2AM=;
        b=uDD3wZbsa1FJm4jgmPqfC89zpb19U+Ch5I0RBSK6mIPi5HCVTnAUbXQGdlx+efArze
         KlKn/V+eLitTXMrjQLDP5xE5psTDnuzGO35YnDvUN1MQcj2Yv3X+WqOQMOBGJm+8iNs6
         qtN6nxZrIL23UulabY5gv7o0CFvQS9aK3X3mcTXhNyRgm+PnpcH8x6WWk6F79Gq8PSzf
         5bMBuB9SoBfWraZb07MoX41IZcjbZMSuA6TnUIJFxt8wFJso72YGkHKw4+Vv4UuLligy
         bXwZRahs3NOkWD1WK16+JCV+QgbZDc8GGmQdvyJhrmZenZULW8Wb7+Et2LTmgoPXyQNQ
         6w2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692144180; x=1692748980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I8FmgQMS4+VEtN3YWaf3XTC6qJSdTgKCK/OCtZRJ2AM=;
        b=ZRhQB1h3XXEw7M8gAT1SGfHmRx1+Yivf4oWSPT0os7XhvGiCkGd11VmfnfaJi0+k+4
         h2YWgxLceTnoBNn9PQHtCNre+bLOlqgMZQkR+CzT6rGYkhMLaTR8Jb0YbUix3yzzD1mM
         IOCnTnKvsOFTQAKySVmQ8dNcm9sZvD+GzVLlolNaxWzXR+dPG//wY+YntFti1RzYm3R2
         4CzxZ5f1QAuEjbLOK1dNy7TZsheGzFdZW1UOo3EVPjPo1+lmLPFDO98sFSPwupCacpd0
         rxgW0WPHRCBV6ZN9ZqqRt1/iNI/lbVy9S54wEbHXdTdVT43Ps2R2KJSx76fOjnAcw3hN
         AE8w==
X-Gm-Message-State: AOJu0YwN/hd5tT3yDPXMjAas5/Ot8NZ1mDOC/K0/kwxJEOqLcweTmhCl
        KakIpA4iAy95D9qe+Rv7B/nuuxqefgt0bao+0z58vQ==
X-Google-Smtp-Source: AGHT+IGzXSHI262nd8TAHecg5+PE5eyEfT/q71qRXLJuGAUfyX/wyH8dQPUrUJHQzlDTntpzBLv8+QSiDCIv/ZhlXYw=
X-Received: by 2002:a2e:a17b:0:b0:2b9:da28:c508 with SMTP id
 u27-20020a2ea17b000000b002b9da28c508mr199586ljl.31.1692144179945; Tue, 15 Aug
 2023 17:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230815183903.2735724-1-maz@kernel.org> <20230815183903.2735724-27-maz@kernel.org>
In-Reply-To: <20230815183903.2735724-27-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Tue, 15 Aug 2023 17:02:47 -0700
Message-ID: <CAAdAUtiQwwSjZ_LHmRP+sW2VWSoe_cSQ5Rrh92f7-o5C2x_s7g@mail.gmail.com>
Subject: Re: [PATCH v4 26/28] KVM: arm64: nv: Expose FGT to nested guests
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Aug 15, 2023 at 11:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Now that we have FGT support, expose the feature to NV guests.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 7f80f385d9e8..3facd8918ae3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -71,8 +71,9 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sy=
s_reg_params *p,
>                 break;
>
>         case SYS_ID_AA64MMFR0_EL1:
> -               /* Hide ECV, FGT, ExS, Secure Memory */
> -               val &=3D ~(GENMASK_ULL(63, 43)            |
> +               /* Hide ECV, ExS, Secure Memory */
> +               val &=3D ~(NV_FTR(MMFR0, ECV)             |
> +                        NV_FTR(MMFR0, EXS)             |
>                          NV_FTR(MMFR0, TGRAN4_2)        |
>                          NV_FTR(MMFR0, TGRAN16_2)       |
>                          NV_FTR(MMFR0, TGRAN64_2)       |
> --
> 2.34.1
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>

Jing
