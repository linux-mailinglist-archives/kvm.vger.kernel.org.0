Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C1A5AFB70
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 06:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiIGExN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 00:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIGExM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 00:53:12 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BB58035E
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 21:53:10 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id c3so13745672vsc.6
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 21:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=IB8D7t/VEzk35ELr98MItPXiflxE6OsuKH8uCTmfVu0=;
        b=N1hXa/JWneN7X9IKmS2ao6iy9YLDaictBmMhbFg9cxBE0NkduKrzAFcYl/y/xmoyzt
         3xH52+Rrdxv1/XQHNpBESXIuZb04hiO8kTyT5HpGbf32y40cBBgBt72l7BapgBjNFcx4
         zS/Ng4Kpxj1EsZ9Umceh5gRXPh2dfwTZ3IN3pc46taHI4yt8KPpEz3UMHC8sFRmcJ4XB
         LaWRtRKHYlXpNuRfvtU8CSlYXws1Yfxg9QQxhizldcDJgXvUC00ImExcNMF6UMhuHW1B
         adGT/aC3XvK7X45UkNBLfAM5f6lPc59hCxPJh/Li/4DwqzGSDk9ihVf/C0ZcVmCBFcAp
         Y8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=IB8D7t/VEzk35ELr98MItPXiflxE6OsuKH8uCTmfVu0=;
        b=hvk9hUHUBRg2yu8hYUn7SI1YDiRdFr5u5qQ4dITjlOm9kYL5PGl2JgwUIUpiYOiZXQ
         gaX8PIwummBWAmeDciEWoUCWrlJaS1uYqLPsbgupmCM4wco6WN+1YyedXzI1gYw/R/6t
         MQUhbl6dWPgIC6rdFgm6t6AsE33agXb1i8Fxz2DUiWxo+b455hLpHor5EGN/xHoGlKE5
         BcJQKYAua+xQk/VuyLg23oQU8A863SGp8R0110W2luGg0pnGZS0QVjDyJF4alQs8lFEq
         R6z7RVMVTahNYcEUT40dPlNrunFXREmlMaQn5mQsQ0RzQCE8/ODk4iQAP+HGPhzqCsN3
         +spA==
X-Gm-Message-State: ACgBeo0BgaSenDYsSpOiLpfOGmYZiJOZgwNZ+Z7QOTLnnb1YQYIVD71P
        kpnGyZRBxDF8X1qVIugwP/WbXyw6YMt0yIXA7c9BxQ==
X-Google-Smtp-Source: AA6agR4rCcd4O9978QvJHzO0pfaEsiyK7hjVqXjHxCjrcSZ0IqTMgr7I9V1ZuIniIvotAbRsX7V2bCI8HVlzNIUociw=
X-Received: by 2002:a67:b009:0:b0:38a:e0f2:4108 with SMTP id
 z9-20020a67b009000000b0038ae0f24108mr514173vse.9.1662526389280; Tue, 06 Sep
 2022 21:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220902154804.1939819-1-oliver.upton@linux.dev> <20220902154804.1939819-7-oliver.upton@linux.dev>
In-Reply-To: <20220902154804.1939819-7-oliver.upton@linux.dev>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 6 Sep 2022 21:52:53 -0700
Message-ID: <CAAeT=FxARdyXJyDgh_E4L-w0azuCY+47WgoM9MheBwyS8SdX1Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Treat 32bit ID registers as RAZ/WI on
 64bit-only system
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Fri, Sep 2, 2022 at 8:48 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> One of the oddities of the architecture is that the AArch64 views of the
> AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any EL.
> Nonetheless, KVM exposes these registers to userspace for the sake of
> save/restore. It is possible that the UNKNOWN value could differ between
> systems, leading to a rejected write from userspace.
>
> Avoid the issue altogether by handling the AArch32 ID registers as
> RAZ/WI when on an AArch64-only system.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 63 ++++++++++++++++++++++++++-------------
>  1 file changed, 43 insertions(+), 20 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 6d0511247df4..9569772cf09a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1144,6 +1144,20 @@ static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
>         return 0;
>  }
>
> +static unsigned int aa32_id_visibility(const struct kvm_vcpu *vcpu,
> +                                      const struct sys_reg_desc *r)
> +{
> +       /*
> +        * AArch32 ID registers are UNKNOWN if AArch32 isn't implemented at any
> +        * EL. Promote to RAZ/WI in order to guarantee consistency between
> +        * systems.
> +        */
> +       if (!kvm_supports_32bit_el0())
> +               return REG_RAZ | REG_USER_WI;
> +
> +       return id_visibility(vcpu, r);
> +}
> +
>  static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
>                                    const struct sys_reg_desc *r)
>  {
> @@ -1331,6 +1345,15 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>         .visibility = id_visibility,            \
>  }
>
> +/* sys_reg_desc initialiser for known cpufeature ID registers */
> +#define AA32_ID_SANITISED(name) {              \
> +       SYS_DESC(SYS_##name),                   \
> +       .access = access_id_reg,                \
> +       .get_user = get_id_reg,                 \
> +       .set_user = set_id_reg,                 \
> +       .visibility = aa32_id_visibility,       \
> +}
> +
>  /*
>   * sys_reg_desc initialiser for architecturally unallocated cpufeature ID
>   * register with encoding Op0=3, Op1=0, CRn=0, CRm=crm, Op2=op2
> @@ -1418,33 +1441,33 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>
>         /* AArch64 mappings of the AArch32 ID registers */
>         /* CRm=1 */
> -       ID_SANITISED(ID_PFR0_EL1),
> -       ID_SANITISED(ID_PFR1_EL1),
> -       ID_SANITISED(ID_DFR0_EL1),
> +       AA32_ID_SANITISED(ID_PFR0_EL1),
> +       AA32_ID_SANITISED(ID_PFR1_EL1),
> +       AA32_ID_SANITISED(ID_DFR0_EL1),
>         ID_HIDDEN(ID_AFR0_EL1),
> -       ID_SANITISED(ID_MMFR0_EL1),
> -       ID_SANITISED(ID_MMFR1_EL1),
> -       ID_SANITISED(ID_MMFR2_EL1),
> -       ID_SANITISED(ID_MMFR3_EL1),
> +       AA32_ID_SANITISED(ID_MMFR0_EL1),
> +       AA32_ID_SANITISED(ID_MMFR1_EL1),
> +       AA32_ID_SANITISED(ID_MMFR2_EL1),
> +       AA32_ID_SANITISED(ID_MMFR3_EL1),
>
>         /* CRm=2 */
> -       ID_SANITISED(ID_ISAR0_EL1),
> -       ID_SANITISED(ID_ISAR1_EL1),
> -       ID_SANITISED(ID_ISAR2_EL1),
> -       ID_SANITISED(ID_ISAR3_EL1),
> -       ID_SANITISED(ID_ISAR4_EL1),
> -       ID_SANITISED(ID_ISAR5_EL1),
> -       ID_SANITISED(ID_MMFR4_EL1),
> -       ID_SANITISED(ID_ISAR6_EL1),
> +       AA32_ID_SANITISED(ID_ISAR0_EL1),
> +       AA32_ID_SANITISED(ID_ISAR1_EL1),
> +       AA32_ID_SANITISED(ID_ISAR2_EL1),
> +       AA32_ID_SANITISED(ID_ISAR3_EL1),
> +       AA32_ID_SANITISED(ID_ISAR4_EL1),
> +       AA32_ID_SANITISED(ID_ISAR5_EL1),
> +       AA32_ID_SANITISED(ID_MMFR4_EL1),
> +       AA32_ID_SANITISED(ID_ISAR6_EL1),
>
>         /* CRm=3 */
> -       ID_SANITISED(MVFR0_EL1),
> -       ID_SANITISED(MVFR1_EL1),
> -       ID_SANITISED(MVFR2_EL1),
> +       AA32_ID_SANITISED(MVFR0_EL1),
> +       AA32_ID_SANITISED(MVFR1_EL1),
> +       AA32_ID_SANITISED(MVFR2_EL1),
>         ID_UNALLOCATED(3,3),
> -       ID_SANITISED(ID_PFR2_EL1),
> +       AA32_ID_SANITISED(ID_PFR2_EL1),
>         ID_HIDDEN(ID_DFR1_EL1),

Perhaps it might be better to handle ID_AFR0_EL1 and ID_DFR1_EL1
in the same way as the other AArch32 ID registers for consistency ?
(i.e. treat them RAZ/USER_WI instead of RAZ if kvm_supports_32bit_el0()
 is false instead of RAZ)

Thank you,
Reiji


> -       ID_SANITISED(ID_MMFR5_EL1),
> +       AA32_ID_SANITISED(ID_MMFR5_EL1),
>         ID_UNALLOCATED(3,7),
>
>         /* AArch64 ID registers */
> --
> 2.37.2.789.g6183377224-goog
>
