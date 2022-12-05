Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46706420DE
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 01:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiLEAxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Dec 2022 19:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiLEAwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Dec 2022 19:52:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA85D11F;
        Sun,  4 Dec 2022 16:52:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F133B60F41;
        Mon,  5 Dec 2022 00:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635E2C4314B;
        Mon,  5 Dec 2022 00:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670201568;
        bh=jib82Q01YLW3qx/1zSi+9r7M6nVqOE5J7EtK6lVWsFM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c4OG6YkZrqiaTLIU3ys/J39EJHbE0hDlBhlf+ojGPQYhfQh0CYGbbMnVKCG5tJF2l
         W3T7Je3F86HVLFO/ukr9uJ4fBrxq7dl+BfPjdQdzPltQ4BuUHyuBAhaddRA+GYu8Ow
         m8zOfWR0d6CP3dXSDZxmcMCpWTfmya6+lsRPiX3cHEERrT1AwrdhYAj2ICX3XBncRb
         h8PK95kI+/xvvUw/96dBh1ytcCsrlXCsk7x3k8UDjq3xEywThzN5vOT7RhIg/2JYNx
         Pblx1hVINMQSVbiNNbcOo5BZHmjm3d/blXgf50K6+p6nvGZVe8C/nETLnKKrYyjUoX
         lPdOwhP515c6A==
Received: by mail-ed1-f53.google.com with SMTP id d20so13781560edn.0;
        Sun, 04 Dec 2022 16:52:48 -0800 (PST)
X-Gm-Message-State: ANoB5pnIHEVN/MrdMvIN0CQR1qOcvuH/7A39sJanjJrffzEZwPTL6SZa
        E2Zpi29hW+2YRvymVDSUZofuOtY2klMOWkJfEiw=
X-Google-Smtp-Source: AA0mqf5VP9XfCfgCkhATJpcc8UvnyeJpKoB1by9S6CKiv7vkMNqEOi5vgUQwxDp/IlwIZ8hrm8OQHac5gGxCl45oatQ=
X-Received: by 2002:a05:6402:538a:b0:458:fbd9:e3b1 with SMTP id
 ew10-20020a056402538a00b00458fbd9e3b1mr15849493edb.6.1670201566654; Sun, 04
 Dec 2022 16:52:46 -0800 (PST)
MIME-Version: 1.0
References: <20221204174632.3677-1-jszhang@kernel.org> <20221204174632.3677-13-jszhang@kernel.org>
In-Reply-To: <20221204174632.3677-13-jszhang@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Mon, 5 Dec 2022 08:52:35 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRRjnnQLvCtvmwf0rGJgoc08s3JGq4PSe4sYfrq2bsqDA@mail.gmail.com>
Message-ID: <CAJF2gTRRjnnQLvCtvmwf0rGJgoc08s3JGq4PSe4sYfrq2bsqDA@mail.gmail.com>
Subject: Re: [PATCH v2 12/13] riscv: KVM: Switch has_svinval() to riscv_has_extension_unlikely()
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
> From: Andrew Jones <ajones@ventanamicro.com>
>
> Switch has_svinval() from static branch to the new helper
> riscv_has_extension_unlikely().
>
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kvm/tlb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> index 309d79b3e5cd..aa3da18ad873 100644
> --- a/arch/riscv/kvm/tlb.c
> +++ b/arch/riscv/kvm/tlb.c
> @@ -15,8 +15,7 @@
>  #include <asm/hwcap.h>
>  #include <asm/insn-def.h>
>
> -#define has_svinval()  \
> -       static_branch_unlikely(&riscv_isa_ext_keys[RISCV_ISA_EXT_KEY_SVINVAL])
> +#define has_svinval()  riscv_has_extension_unlikely(RISCV_ISA_EXT_SVINVAL)
>
>  void kvm_riscv_local_hfence_gvma_vmid_gpa(unsigned long vmid,
>                                           gpa_t gpa, gpa_t gpsz,
> --
> 2.37.2
>


-- 
Best Regards
 Guo Ren
