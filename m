Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7C667F9AE
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 17:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbjA1Qxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 11:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjA1Qxi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 11:53:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D7F25286;
        Sat, 28 Jan 2023 08:53:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7729B8069D;
        Sat, 28 Jan 2023 16:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670D8C433D2;
        Sat, 28 Jan 2023 16:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674924814;
        bh=v/CtqhVfGpAQw4Ngw2O+HeRUmhaWbbQs7pcp4hkRZVw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uesfwittlLwxxzvYiXZ3RbH4v5b9g6T3bULdwgrsZOe5aI1bGgmTH866m1QYGr29e
         UvcnVUTEC5Tcj40kgA80NXRueJhBNW4wu0ERd8Gd/CvqKLU8BfR0Z0GmA4T6tR4Ssf
         XVbLfXKxc+YToHraAAdWfzFzwS5fC/rA25U0/tY/d274QejgSOQqyiuXQODH7SyyiJ
         PMsXMhk/Z/n5/FrPd4kcNs8guLE8DPDYTRB+4ojrM2Zks6JielSq5OnyKQz/83IleD
         G3Na5QiegutOaOQDUmgOP+Yd6n+tFiyco9WsElprQQ9jaT9OVsZsXe/RHSu87ak/TY
         ScuWQFzpu3+lQ==
Date:   Sun, 29 Jan 2023 00:43:06 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Andrew Jones <ajones@ventanamicro.com>
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
Message-ID: <Y9VQmprEF6Jg7A7S@xhacker>
References: <20230115154953.831-1-jszhang@kernel.org>
 <20230115154953.831-10-jszhang@kernel.org>
 <20230120183418.ngdppppvwzysqtcr@orel>
 <20230126070930.wvqsrrcmcuq5vv2x@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230126070930.wvqsrrcmcuq5vv2x@orel>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 08:09:30AM +0100, Andrew Jones wrote:
> On Fri, Jan 20, 2023 at 07:34:18PM +0100, Andrew Jones wrote:
> > On Sun, Jan 15, 2023 at 11:49:49PM +0800, Jisheng Zhang wrote:
> > ...
> > >  #define ALT_ENTRY(oldptr, newptr, vendor_id, errata_id, newlen)		\
> > > -	RISCV_PTR " " oldptr "\n"					\
> > > -	RISCV_PTR " " newptr "\n"					\
> > > -	REG_ASM " " vendor_id "\n"					\
> > > -	REG_ASM " " newlen "\n"						\
> > > -	".word " errata_id "\n"
> > > +	".4byte	((" oldptr ") - .) \n"					\
> > > +	".4byte	((" newptr ") - .) \n"					\
> > > +	".2byte	" vendor_id "\n"					\
> > > +	".2byte " newlen "\n"						\
> > > +	".4byte	" errata_id "\n"
> > >
> > 
> > Hi Jisheng,
> > 
> > This patch breaks loading the KVM module for me. I got "kvm: Unknown
> > relocation type 34". My guess is that these 2 byte fields are inspiring
> > the compiler to emit 16-bit relocation types. The patch below fixes
> > things for me. If you agree with fixing it this way, rather than
> > changing something in alternatives, like not using 2 byte fields,
> > then please pick the below patch up in your series.
> 
> Hi Jisheng,
> 
> I'm poking again on this as I see this series is now working its way
> to be merged into for-next. I'd rather avoid the bisection breakage
> which will be present if we fix this issue afterwards by having a
> v5 merged which addresses the issue in the correct patch order.

Hi Andrew,

Sorry for being late. I was on holiday in the past few days. I'm
cooking v5 and will send out it soon.

Thanks so much

> 
> Thanks,
> drew
> 
> > 
> > From 4d203697aa745a0cd3a9217d547a9fb7fa2a87c7 Mon Sep 17 00:00:00 2001
> > From: Andrew Jones <ajones@ventanamicro.com>
> > Date: Fri, 20 Jan 2023 19:05:44 +0100
> > Subject: [PATCH] riscv: module: Add ADD16 and SUB16 rela types
> > Content-type: text/plain
> > 
> > To prepare for 16-bit relocation types to be emitted in alternatives
> > add support for ADD16 and SUB16.
> > 
> > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> >  arch/riscv/kernel/module.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
> > index 76f4b9c2ec5b..7c651d55fcbd 100644
> > --- a/arch/riscv/kernel/module.c
> > +++ b/arch/riscv/kernel/module.c
> > @@ -268,6 +268,13 @@ static int apply_r_riscv_align_rela(struct module *me, u32 *location,
> >  	return -EINVAL;
> >  }
> >  
> > +static int apply_r_riscv_add16_rela(struct module *me, u32 *location,
> > +				    Elf_Addr v)
> > +{
> > +	*(u16 *)location += (u16)v;
> > +	return 0;
> > +}
> > +
> >  static int apply_r_riscv_add32_rela(struct module *me, u32 *location,
> >  				    Elf_Addr v)
> >  {
> > @@ -282,6 +289,13 @@ static int apply_r_riscv_add64_rela(struct module *me, u32 *location,
> >  	return 0;
> >  }
> >  
> > +static int apply_r_riscv_sub16_rela(struct module *me, u32 *location,
> > +				    Elf_Addr v)
> > +{
> > +	*(u16 *)location -= (u16)v;
> > +	return 0;
> > +}
> > +
> >  static int apply_r_riscv_sub32_rela(struct module *me, u32 *location,
> >  				    Elf_Addr v)
> >  {
> > @@ -315,8 +329,10 @@ static int (*reloc_handlers_rela[]) (struct module *me, u32 *location,
> >  	[R_RISCV_CALL]			= apply_r_riscv_call_rela,
> >  	[R_RISCV_RELAX]			= apply_r_riscv_relax_rela,
> >  	[R_RISCV_ALIGN]			= apply_r_riscv_align_rela,
> > +	[R_RISCV_ADD16]			= apply_r_riscv_add16_rela,
> >  	[R_RISCV_ADD32]			= apply_r_riscv_add32_rela,
> >  	[R_RISCV_ADD64]			= apply_r_riscv_add64_rela,
> > +	[R_RISCV_SUB16]			= apply_r_riscv_sub16_rela,
> >  	[R_RISCV_SUB32]			= apply_r_riscv_sub32_rela,
> >  	[R_RISCV_SUB64]			= apply_r_riscv_sub64_rela,
> >  };
> > -- 
> > 2.39.0
> > 
