Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1715A7477
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 05:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiHaDaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 23:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiHaD3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 23:29:55 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FC055B1
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 20:29:53 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id k2so13387878vsk.8
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 20:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=wH6SkmsubtAEMe+Oltypmgiq7J+rOERnNBJpjeaMrvA=;
        b=CDo6Z44yrRgjpbGohbYOniKRV+E/B8UYbGeUnUlkzXXIylwcDIZdQ+Sx8VOh+dVnf1
         pbOlZsl12uJKm+tUl3QyfYfGFXY4ANvoVdv4TGWJK5OuwkobzqaGZkZhHQZu9AfeUxkJ
         9YlNnxAYXeGE3Bf0CQ4FrimfXXjQpYMX6dy+WDDMg8e6OKrfgYUyVsQLL+HPgBqMolyM
         rAoByc/zvaP09HZNoVZupaSLSv8OrNdqso5qEaU/H+dKuawAbzJdxSXT60ZV2G5muzA7
         m5WWM62So7XPY82nxGWRmQCsNY0r59hR8vA+juhse5d8TOY05EAN9wmtIsPym3YxDGQ5
         yoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=wH6SkmsubtAEMe+Oltypmgiq7J+rOERnNBJpjeaMrvA=;
        b=69C7JkNN7kI02/14JqL4YIcpZxnxNqGknwQCYLVjAPsFrxIhEzzPjGy/n0OZ85tO11
         rN5DgUFPPhqikf0o+482aJ6f3LcenLj8q+u0wYDNV09cb7XDBVBHQQUnKlhrKGaF0t0W
         BnF0G2Uh9/9Me4Rbb5qJjMcscn+/GhubFXaHv8pttr1w7MmjsUm4vB/UQmWnWX0SVuqE
         2cJX+u61s/wjEeuctpnniB5EXL1WVSGQZ9wRvSBFcLXttTuOIp4u9OCjiKNwmk2DXMlH
         PD+WEccGtQMingulP86LYGRiy+kbnfuuvSvLRFbNsZb/YDdpyc7CdCJGSMtXFc7bbCck
         H75w==
X-Gm-Message-State: ACgBeo2I/+kgAfBDdZo7uyLwIvQRjo+/xJLiXVzePshESx3f9FxAgT3h
        QfPnfIKpJ+Z0OfByDb887RVcsJoMLjEvc6gGr1pvmC3ROXFAVg==
X-Google-Smtp-Source: AA6agR4wfp0eqT1lfWS6iZGkY2lniXyKPHAVAyC2erCUgxtEjOhhAVDZK0dA8SqsKzKRoy5IARzHVLIjMCIz3tgUzA8=
X-Received: by 2002:a05:6102:1349:b0:390:e185:9541 with SMTP id
 j9-20020a056102134900b00390e1859541mr4396415vsl.58.1661916592982; Tue, 30 Aug
 2022 20:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220817214818.3243383-1-oliver.upton@linux.dev> <20220817214818.3243383-5-oliver.upton@linux.dev>
In-Reply-To: <20220817214818.3243383-5-oliver.upton@linux.dev>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 30 Aug 2022 20:29:37 -0700
Message-ID: <CAAeT=FzQkgf7g3yXP++u_2zio1XL9mRSzPZ6hxmanwVk4QUNbQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] KVM: arm64: Add a visibility bit to ignore user writes
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Oliver,

On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> We're about to ignore writes to AArch32 ID registers on AArch64-only
> systems. Add a bit to indicate a register is handled as write ignore
> when accessed from userspace.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 3 +++
>  arch/arm64/kvm/sys_regs.h | 7 +++++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 26210f3a0b27..9f06c85f26b8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1232,6 +1232,9 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  {
>         bool raz = sysreg_visible_as_raz(vcpu, rd);
>
> +       if (sysreg_user_write_ignore(vcpu, rd))
> +               return 0;

Since the visibility flags are not ID register specific,
have you considered checking REG_USER_WI from kvm_sys_reg_set_user()
rather than the ID register specific function ?

This patch made me reconsider my comment for the patch-2.
Perhaps it might be more appropriate to check RAZ visibility from
kvm_sys_reg_get_user() rather than the ID register specific function ?

REG_HIDDEN is already checked from kvm_sys_reg_{s,g}et_user() (indirectly).

Thank you,
Reiji

> +
>         /* This is what we mean by invariant: you can't change it. */
>         if (val != read_id_reg(vcpu, rd, raz))
>                 return -EINVAL;
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index e78b51059622..e4ebb3a379fd 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -86,6 +86,7 @@ struct sys_reg_desc {
>
>  #define REG_HIDDEN             (1 << 0) /* hidden from userspace and guest */
>  #define REG_RAZ                        (1 << 1) /* RAZ from userspace and guest */
> +#define REG_USER_WI            (1 << 2) /* WI from userspace only */
>
>  static __printf(2, 3)
>  inline void print_sys_reg_msg(const struct sys_reg_params *p,
> @@ -157,6 +158,12 @@ static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
>         return sysreg_visibility(vcpu, r) & REG_RAZ;
>  }
>
> +static inline bool sysreg_user_write_ignore(const struct kvm_vcpu *vcpu,
> +                                           const struct sys_reg_desc *r)
> +{
> +       return sysreg_visibility(vcpu, r) & REG_USER_WI;
> +}
> +
>  static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>                               const struct sys_reg_desc *i2)
>  {
> --
> 2.37.1.595.g718a3a8f04-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
