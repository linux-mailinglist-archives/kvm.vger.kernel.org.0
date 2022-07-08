Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48A056B293
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 08:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbiGHGN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 02:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbiGHGN4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 02:13:56 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C59017AAB
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 23:13:53 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id l190so3387902vsc.0
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 23:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9kdI7fJ9HKcnF+19AuXCv4R1tDk5TG26VjCxQHvO5u8=;
        b=YhLiZ57UkwJfno4mNVHsQc6j6NYYIB2FeqxM/ysU8y1foQ924puiAmNgczPDV842zx
         ZI8v8WIFjImHN0JgZQOzv7+pz0oqnfk5Ppni33ZKMaf6sKWpWjpWaPffdrUwwWOcjBia
         ZqKgv5zOcZCDbyw6pMHWMreNrWB2il8kUw73FgzugbWWwPYpO355dHFWQ1h+ndhhrvgj
         45xzhQhJTeJtQNaSXSvLp6sCN5H0QA0+xB1yguLGvuo2hTIdZ2UnCL/OUGjyV2juEWze
         GfmupVO2Ld9FTe8IrXo96KO4G+166D/b63z524NznPZtQp/BidA95aicX43e4Fa0XS9X
         LK9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9kdI7fJ9HKcnF+19AuXCv4R1tDk5TG26VjCxQHvO5u8=;
        b=ovU/Z86YtCbsLY9gMpWSX+T08lwOQBmNee9sEGZwYCNyJxJXPOp2agYl2cr8OVLLol
         XPfCU0nPWsrhaFYYDIasArMxu5kR+xom8Gpuey7cOADeTY8+QGkEIks0dcskb0jqRXAs
         NhB8IXTtqemNjApYIMNlpCchWZ7j2xwbXTxb4/HgyJa6Bd7SBCo1kIEkTv8mFJTOS4JY
         9DMp3kjLHfGKeahO8was6/EGo9zGhn8Z4kWE1dfOOl/EEGKQwu6GGGnVEIm3/6Omlmv7
         Y0Z2A+uDOIxwiKYPgLjl/p/js9GtxUYZNmNK6N+VvuxmsZ6Nru/alu6k2BZ1+3panQqJ
         sFXw==
X-Gm-Message-State: AJIora/lZcjxz2OWPL6A/wHRSJbHG2yceZMffG5GPgVcRJrKnu/42CGe
        IqzP/L9bHQP9f6BUkop/U8SE7+4nuxe6O2L756Fmpw==
X-Google-Smtp-Source: AGRyM1suSrk/70+H5gMThZ7ls53+MmoXup9DqDwa+knSTDnqvGP4RjQRi4hofApOL600gSPxUjm6/FE2Hp6HIWpzha4=
X-Received: by 2002:a67:5c41:0:b0:356:20ab:2f29 with SMTP id
 q62-20020a675c41000000b0035620ab2f29mr674569vsb.63.1657260832132; Thu, 07 Jul
 2022 23:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-5-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-5-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 7 Jul 2022 23:13:36 -0700
Message-ID: <CAAeT=Fz9+1=EV6fwqVMSncOj_9y7eRuuv1+P92MXbP1GOJeZaA@mail.gmail.com>
Subject: Re: [PATCH 04/19] KVM: arm64: Push checks for 64bit registers into
 the low-level accessors
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
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

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Make sure the check occurs on every paths where we can pick
> a sysreg from userspace, including the GICv3 paths.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0fbdb21a3600..89e7eddea937 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2656,6 +2656,10 @@ const struct sys_reg_desc *get_reg_by_id(u64 id,
>  {
>         struct sys_reg_params params;
>
> +       /* 64 bit is the only way */
> +       if (KVM_REG_SIZE(id) != sizeof(__u64))
> +               return NULL;

This doesn't seem to be necessary since the equivalent check
is done by index_to_params().

Thank you,
Reiji

> +
>         if (!index_to_params(id, &params))
>                 return NULL;
>
> @@ -2871,9 +2875,6 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>         if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
>                 return demux_c15_get(reg->id, uaddr);
>
> -       if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
> -               return -ENOENT;
> -
>         err = get_invariant_sys_reg(reg->id, uaddr);
>         if (err != -ENOENT)
>                 return err;
> @@ -2906,9 +2907,6 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>         if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
>                 return demux_c15_set(reg->id, uaddr);
>
> -       if (KVM_REG_SIZE(reg->id) != sizeof(__u64))
> -               return -ENOENT;
> -
>         err = set_invariant_sys_reg(reg->id, uaddr);
>         if (err != -ENOENT)
>                 return err;
> --
> 2.34.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
