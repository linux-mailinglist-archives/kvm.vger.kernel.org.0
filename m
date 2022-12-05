Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D8B6420DA
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 01:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiLEAwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 19:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiLEAwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 19:52:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1020EB47;
        Sun,  4 Dec 2022 16:52:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EC8360F22;
        Mon,  5 Dec 2022 00:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82A0C4347C;
        Mon,  5 Dec 2022 00:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670201551;
        bh=s/KjoeG/YvGoR0oEAgkt8KtClqhFUTJq63bmI6YsBPo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YwHBWZu3PWtUDVuqFJLR0W1ZNGPezh3BT3/s0SwlOPcliyBz8sqes75kSelI6l/aW
         xSt5a1WLghAIdbZiamT1JUQks8nsgR5BSiJiviVusYQr/QJO3eyqVwwrSF1Kw7iEed
         tV2kVS1JRKsmtG7Z+Ht/PER/hLZ0g+d68TupN8Hx7MzIy1rvXk1pMkADTqV+Lw/58w
         zEWxT3UZtQN8X8TWO5tTgRfv2Sqq0Ol58omxYSWWJ9RgnFxFPIBGIbwUN+Pecy7ruw
         0tKdcx0qNjoRYR3Pj38CIEtRlarUtIOggl7NZrduZYuoZTr8vgPLuAeJ5Dz525pTFB
         V4RhS0ef51d0Q==
Received: by mail-ej1-f43.google.com with SMTP id vp12so24194917ejc.8;
        Sun, 04 Dec 2022 16:52:31 -0800 (PST)
X-Gm-Message-State: ANoB5pkX3+czrf9ZrV5Z/Db7UmTq5nQ0UrVd8RpTJFbDft2bF0hMV63N
        lGv0dlucwngM+W6ohWUmZpD2cO9HJ6DlVLYt8aU=
X-Google-Smtp-Source: AA0mqf6u3mfU1nSek+u3koHoY/aoUcux+SiCgRRELDXAjku/7GldOJ01M1jUGx1KmiiWZPp1QZaKXwpErigUqf5MuRM=
X-Received: by 2002:a17:906:ee2:b0:78d:3f96:b7aa with SMTP id
 x2-20020a1709060ee200b0078d3f96b7aamr52877797eji.74.1670201550218; Sun, 04
 Dec 2022 16:52:30 -0800 (PST)
MIME-Version: 1.0
References: <20221204174632.3677-1-jszhang@kernel.org> <20221204174632.3677-12-jszhang@kernel.org>
In-Reply-To: <20221204174632.3677-12-jszhang@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Mon, 5 Dec 2022 08:52:18 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSBdJ53BDB5kXmh5y9cMZOmoVHqN6mhuNFqMB07E_T64g@mail.gmail.com>
Message-ID: <CAJF2gTSBdJ53BDB5kXmh5y9cMZOmoVHqN6mhuNFqMB07E_T64g@mail.gmail.com>
Subject: Re: [PATCH v2 11/13] riscv: cpu_relax: switch to riscv_has_extension_likely()
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Guo Ren <guoren@kernel.org>

On Mon, Dec 5, 2022 at 1:57 AM Jisheng Zhang <jszhang@kernel.org> wrote:
>
> Switch cpu_relax() from statich branch to the new helper
> riscv_has_extension_likely()
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  arch/riscv/include/asm/vdso/processor.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/include/asm/vdso/processor.h b/arch/riscv/include/asm/vdso/processor.h
> index fa70cfe507aa..edf0e25e43d1 100644
> --- a/arch/riscv/include/asm/vdso/processor.h
> +++ b/arch/riscv/include/asm/vdso/processor.h
> @@ -10,7 +10,7 @@
>
>  static inline void cpu_relax(void)
>  {
> -       if (!static_branch_likely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_ZIHINTPAUSE])) {
> +       if (!riscv_has_extension_likely(RISCV_ISA_EXT_ZIHINTPAUSE)) {
>  #ifdef __riscv_muldiv
>                 int dummy;
>                 /* In lieu of a halt instruction, induce a long-latency stall. */
> --
> 2.37.2
>


-- 
Best Regards
 Guo Ren
