Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5812267C4AC
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 08:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbjAZHJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 02:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbjAZHJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 02:09:34 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AC12D44
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 23:09:33 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id tz11so2837908ejc.0
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 23:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7xO4nzooOx9Fnx6HScH7rLurtje8d12bXHWmpEv5B74=;
        b=gadZBxYJO1f5wW9BHOnzxkgvjwqHRKsrgOiwY/lVQ0gvSkp3vez3CfMDhmrZBj0Lnf
         ApIU7RzjhdyD0nEtrlKpMVRpY4guv1hDTbG5t0n9pOkQF46mnKthnCntYbSg95lxY1jI
         OLVogMxma5vLCly8q+wf23YJuxZEVpEWUa4+YwROhMDpS1xblGyh6j3lYTgr29CEqzXf
         dYbSDlrZQ3Udhf78smFXWuPhiWBf5Syeqey6MtwYxSME53NemkdQ1tIdMtUc2daHt6C8
         2aCXnFvsDTXExi+qISr73vwCrKaxXXVe2uhfD3QZSWXPypY8AqZVYN4lQM0S7VFc8oiY
         JsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xO4nzooOx9Fnx6HScH7rLurtje8d12bXHWmpEv5B74=;
        b=fj/rHpMGQqgEpO83ggTOEHrm5EYU1n1YfaC+790GsS000OfVybVMZrcpovsLOYDnAR
         mqfl9bLe3fbx/S6yGu0SoCWns+iMOQNTtU9Ek7ciP8T/bPWIzKgQdx8cyikkqJ74KXXS
         pFBOfW61svKep2Tw7rXJE7mY6+epkxwPZZSTLsYVVzJcud2QwQjZggEYhd500zb9GEI8
         wZ7YGx+JY2UWSmG1d7/0RLxKQFZ66JMA/ZoFVFsyQ6aDQuVD7QQE2Bexer0F2RqDqW9N
         T8qjyWOILXy4wrylFZwe6raiue213c0R8jk8B9JL68mzOvp3mmU47dai/+QYHf6PGWV/
         NPnQ==
X-Gm-Message-State: AO0yUKXnAEGL18X7YyEKsui9e9mNsgeetRv27z4Jy5zdU+Fgjxl6Vuyt
        88t3nR5LoMMCSXY7j6Q1Ip2JBw==
X-Google-Smtp-Source: AK7set8UO5ZMp8niAX/8UCCEoMCN0FdlHBc2NmZLARlIC9nX5SOBUFOEP5ISGyT650Bud2+n6mftyQ==
X-Received: by 2002:a17:907:3f28:b0:878:6643:974a with SMTP id hq40-20020a1709073f2800b008786643974amr1106863ejc.35.1674716972259;
        Wed, 25 Jan 2023 23:09:32 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id b16-20020a170906d11000b0085ca279966esm155442ejz.119.2023.01.25.23.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:09:31 -0800 (PST)
Date:   Thu, 26 Jan 2023 08:09:30 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v4 09/13] riscv: switch to relative alternative entries
Message-ID: <20230126070930.wvqsrrcmcuq5vv2x@orel>
References: <20230115154953.831-1-jszhang@kernel.org>
 <20230115154953.831-10-jszhang@kernel.org>
 <20230120183418.ngdppppvwzysqtcr@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120183418.ngdppppvwzysqtcr@orel>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 07:34:18PM +0100, Andrew Jones wrote:
> On Sun, Jan 15, 2023 at 11:49:49PM +0800, Jisheng Zhang wrote:
> ...
> >  #define ALT_ENTRY(oldptr, newptr, vendor_id, errata_id, newlen)		\
> > -	RISCV_PTR " " oldptr "\n"					\
> > -	RISCV_PTR " " newptr "\n"					\
> > -	REG_ASM " " vendor_id "\n"					\
> > -	REG_ASM " " newlen "\n"						\
> > -	".word " errata_id "\n"
> > +	".4byte	((" oldptr ") - .) \n"					\
> > +	".4byte	((" newptr ") - .) \n"					\
> > +	".2byte	" vendor_id "\n"					\
> > +	".2byte " newlen "\n"						\
> > +	".4byte	" errata_id "\n"
> >
> 
> Hi Jisheng,
> 
> This patch breaks loading the KVM module for me. I got "kvm: Unknown
> relocation type 34". My guess is that these 2 byte fields are inspiring
> the compiler to emit 16-bit relocation types. The patch below fixes
> things for me. If you agree with fixing it this way, rather than
> changing something in alternatives, like not using 2 byte fields,
> then please pick the below patch up in your series.

Hi Jisheng,

I'm poking again on this as I see this series is now working its way
to be merged into for-next. I'd rather avoid the bisection breakage
which will be present if we fix this issue afterwards by having a
v5 merged which addresses the issue in the correct patch order.

Thanks,
drew

> 
> From 4d203697aa745a0cd3a9217d547a9fb7fa2a87c7 Mon Sep 17 00:00:00 2001
> From: Andrew Jones <ajones@ventanamicro.com>
> Date: Fri, 20 Jan 2023 19:05:44 +0100
> Subject: [PATCH] riscv: module: Add ADD16 and SUB16 rela types
> Content-type: text/plain
> 
> To prepare for 16-bit relocation types to be emitted in alternatives
> add support for ADD16 and SUB16.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>  arch/riscv/kernel/module.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
> index 76f4b9c2ec5b..7c651d55fcbd 100644
> --- a/arch/riscv/kernel/module.c
> +++ b/arch/riscv/kernel/module.c
> @@ -268,6 +268,13 @@ static int apply_r_riscv_align_rela(struct module *me, u32 *location,
>  	return -EINVAL;
>  }
>  
> +static int apply_r_riscv_add16_rela(struct module *me, u32 *location,
> +				    Elf_Addr v)
> +{
> +	*(u16 *)location += (u16)v;
> +	return 0;
> +}
> +
>  static int apply_r_riscv_add32_rela(struct module *me, u32 *location,
>  				    Elf_Addr v)
>  {
> @@ -282,6 +289,13 @@ static int apply_r_riscv_add64_rela(struct module *me, u32 *location,
>  	return 0;
>  }
>  
> +static int apply_r_riscv_sub16_rela(struct module *me, u32 *location,
> +				    Elf_Addr v)
> +{
> +	*(u16 *)location -= (u16)v;
> +	return 0;
> +}
> +
>  static int apply_r_riscv_sub32_rela(struct module *me, u32 *location,
>  				    Elf_Addr v)
>  {
> @@ -315,8 +329,10 @@ static int (*reloc_handlers_rela[]) (struct module *me, u32 *location,
>  	[R_RISCV_CALL]			= apply_r_riscv_call_rela,
>  	[R_RISCV_RELAX]			= apply_r_riscv_relax_rela,
>  	[R_RISCV_ALIGN]			= apply_r_riscv_align_rela,
> +	[R_RISCV_ADD16]			= apply_r_riscv_add16_rela,
>  	[R_RISCV_ADD32]			= apply_r_riscv_add32_rela,
>  	[R_RISCV_ADD64]			= apply_r_riscv_add64_rela,
> +	[R_RISCV_SUB16]			= apply_r_riscv_sub16_rela,
>  	[R_RISCV_SUB32]			= apply_r_riscv_sub32_rela,
>  	[R_RISCV_SUB64]			= apply_r_riscv_sub64_rela,
>  };
> -- 
> 2.39.0
> 
