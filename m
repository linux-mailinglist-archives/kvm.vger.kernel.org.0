Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D5B63B3D8
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 22:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbiK1VEC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 16:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiK1VEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 16:04:00 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7296B2725
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:03:59 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id g51-20020a9d12b6000000b0066dbea0d203so7802829otg.6
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 13:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ND1tOqB0oBTvRxF9O3G4bI9whp4Sthfh8GG8dmfGdQk=;
        b=AcU82FtIdY53Q+r2FwFa06LoIYwX4kW/YFLPokX/T/Jgx8JyDOGBajrSH4qRbaEqY9
         ekvjrt3h+35Vnj/bLz7TPZjEdspoLd+8lIRKp4bUn3qU7lOez/OJ62caDsa79DoQdqQt
         JeW3/R5NkEcFg3FNheUJ7FEOXfxxWa+SwUQ/w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ND1tOqB0oBTvRxF9O3G4bI9whp4Sthfh8GG8dmfGdQk=;
        b=I9u1FcqH7PtIIBY3h1rbtMuOWAWrjzLpKrGriVj/wL1yeSuhdv2U8ehAMGg2pN6AWz
         WTKjnrhWapxLsXaG+/rB6NP3GbAD0AZq4dHZ0V2bxtPYIDESzOjT1PrLw/HvX1dp406I
         FKCtxJ8fWO8S+sgM9iMr81avz/9JpI7sDSsgc4GKfw3EhYY0+hHbMZvZg+wEQ0pizjpo
         z/J92OLMTXQbVTQlegC34/JvKLPurU/KH80qMHxIwOLwQpXnrhndpBrTBxGam4BajNVN
         k2h647CddSnox+QOC8zl7NK8Q6TPoBISAK7OSkduW1zEO2EA5C2oqNVZq7Khjp9KJksi
         hd9g==
X-Gm-Message-State: ANoB5pmuwIi8nFU7yhQnsGenyVKublkTxZPyniRT9e6IKeVo2CyShOWs
        wYjFmS8qZdJwIxh5lSSxM19L0OFCPZtKyEABhbaJ
X-Google-Smtp-Source: AA0mqf5gBKJg1tXLYyD7tEB8qdO8Vhv8Bt5iOOXz+gzCY+TAeVcPVtinX0bdDrwSvAsh+98qBlffz/W9tkMlevYpNss=
X-Received: by 2002:a9d:4812:0:b0:66d:1e19:684b with SMTP id
 c18-20020a9d4812000000b0066d1e19684bmr27369484otf.44.1669669437312; Mon, 28
 Nov 2022 13:03:57 -0800 (PST)
MIME-Version: 1.0
References: <20221128161424.608889-1-apatel@ventanamicro.com> <20221128161424.608889-2-apatel@ventanamicro.com>
In-Reply-To: <20221128161424.608889-2-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Mon, 28 Nov 2022 13:03:46 -0800
Message-ID: <CAOnJCUL4oNd8vN9s2zxvDGzUOmZDtDzSYHsBfGeyBv9BSxrtTw@mail.gmail.com>
Subject: Re: [PATCH 1/9] RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 8:14 AM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The reg_val check in kvm_riscv_vcpu_set_reg_config() should only
> be done for isa config register.
>
> Fixes: 9bfd900beeec ("RISC-V: KVM: Improve ISA extension by using a bitmap")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 17d5b3f8c2ee..982a3f5e7130 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -296,12 +296,15 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>         if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
>                 return -EFAULT;
>
> -       /* This ONE REG interface is only defined for single letter extensions */
> -       if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
> -               return -EINVAL;
> -
>         switch (reg_num) {
>         case KVM_REG_RISCV_CONFIG_REG(isa):
> +               /*
> +                * This ONE REG interface is only defined for
> +                * single letter extensions.
> +                */
> +               if (fls(reg_val) >= RISCV_ISA_EXT_BASE)
> +                       return -EINVAL;
> +
>                 if (!vcpu->arch.ran_atleast_once) {
>                         /* Ignore the enable/disable request for certain extensions */
>                         for (i = 0; i < RISCV_ISA_EXT_BASE; i++) {
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
-- 
Regards,
Atish
