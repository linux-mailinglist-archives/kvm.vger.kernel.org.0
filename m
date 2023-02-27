Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7185D6A430C
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 14:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjB0Nkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 08:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjB0Nkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 08:40:51 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06DC83FA
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:40:49 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id ff4so4439797qvb.2
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 05:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bluespec-com.20210112.gappssmtp.com; s=20210112; t=1677505249;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8JIiHToWm3JJX3vLcdAdWPiMyNkhL1NymqgcmOqFXnc=;
        b=E6fDCBRzXaSEcmbwYppIr9fPG+rbeM4a7GwiXp3RIMWLGIV2hWHjvG4lfYVUELvHR1
         3vE7Rtnst+AMB2XcOoBcViFlLK79I75brt9VDJQE69HvFDx4MlWzw2n41KoEcU9NZmdA
         00AcATFg9PM2emTkkLKBI7uiWkVg6TXuvNg+QrnxI8Aevzs2AfaueO+dXN3ZHNkb0RSJ
         BlKoc01/zX+q386MMzpPhXIsnv43o2eM+Fa0eDmiHlvpNtcsVn7EzBvTKS3NBGx8pImz
         8CmcBN4v00Iua9D7twVrIPnr0IRR9Ax3X8/iaP44Qrgr7hngvwbE/BD8l2Q9Mhlt2s7z
         oarg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677505249;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8JIiHToWm3JJX3vLcdAdWPiMyNkhL1NymqgcmOqFXnc=;
        b=GGUTAIpVMdiXCzNGUcDW3Q72eLS3mTZWCBgAMYihp/bp5CaPSBUvnd8seYCNp+qZ/G
         NgMl190/rB6uGSvRawEo0pRQIyBJ4hig5oIA/FGwLMV3HvYNbw5HCHiQm0l53sdg5sdn
         293b2H1kJZKZZ3y2sxg4PNTI5h1wejA07yExwfd4HNxzodhwieIuKjcmPejvb1T5ldmY
         zkjFsAz0NTK9javfSmYT2rGePsx+mnvdbFh0vNYRoJIX3gX3pHLVvB2pfOmmJJVEUpJe
         Gj09sx4skJ2p0Q69fID4+vMn7KpN5bwkBlOdvbG9QXn8H9uhqHzwHZKa6nK5ECIdlnwj
         iJZw==
X-Gm-Message-State: AO0yUKUl8Y5mWx+xwzYdKhhEhirVZUsO/M/VSAsFANg9Rrkrzt4Wz+Ri
        QFuyGMedj3Qp52RXyf0qGNdw
X-Google-Smtp-Source: AK7set962+ZodxtJuVn4KwIsiWzvasBAywTTkE+5fyPW8lu8CRTF3VS1E28pdLmsqnRVvjQBwlLV7Q==
X-Received: by 2002:a05:6214:194a:b0:56e:a88f:70d0 with SMTP id q10-20020a056214194a00b0056ea88f70d0mr51430834qvk.27.1677505248894;
        Mon, 27 Feb 2023 05:40:48 -0800 (PST)
Received: from bruce.bluespec.com ([102.129.235.233])
        by smtp.gmail.com with ESMTPSA id 124-20020a370b82000000b007425ef4cbc2sm4884423qkl.100.2023.02.27.05.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 05:40:48 -0800 (PST)
Date:   Mon, 27 Feb 2023 08:40:46 -0500
From:   Darius Rad <darius@bluespec.com>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v14 19/19] riscv: Enable Vector code to be built
Message-ID: <Y/yy3sDX2AxvBD0f@bruce.bluespec.com>
Mail-Followup-To: Conor Dooley <conor.dooley@microchip.com>,
        Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-20-andy.chiu@sifive.com>
 <Y/yDeurep0ZBnLdR@wendy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/yDeurep0ZBnLdR@wendy>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NEUTRAL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 10:18:34AM +0000, Conor Dooley wrote:
> Hey Andy,
> 
> On Fri, Feb 24, 2023 at 05:01:18PM +0000, Andy Chiu wrote:
> > From: Guo Ren <guoren@linux.alibaba.com>
> > 
> > This patch adds a config which enables vector feature from the kernel
> > space.
> > 
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> > Suggested-by: Atish Patra <atishp@atishpatra.org>
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> 
> At this point, you've basically re-written this patch and should be
> listed as a co-author at the very least!
> 
> > ---
> >  arch/riscv/Kconfig  | 18 ++++++++++++++++++
> >  arch/riscv/Makefile |  3 ++-
> >  2 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index 81eb031887d2..19deeb3bb36b 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -418,6 +418,24 @@ config RISCV_ISA_SVPBMT
> >  
> >  	   If you don't know what to do here, say Y.
> >  
> > +config TOOLCHAIN_HAS_V
> > +	bool
> > +	default y
> > +	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64iv)
> > +	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32iv)
> > +	depends on LLD_VERSION >= 140000 || LD_VERSION >= 23800
> > +
> > +config RISCV_ISA_V
> > +	bool "VECTOR extension support"
> > +	depends on TOOLCHAIN_HAS_V
> > +	select DYNAMIC_SIGFRAME
> 
> So, nothing here makes V depend on CONFIG_FPU...
> 
> > +	default y
> > +	help
> > +	  Say N here if you want to disable all vector related procedure
> > +	  in the kernel.
> > +
> > +	  If you don't know what to do here, say Y.
> > +
> >  config TOOLCHAIN_HAS_ZBB
> >  	bool
> >  	default y
> > diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> > index 76989561566b..375a048b11cb 100644
> > --- a/arch/riscv/Makefile
> > +++ b/arch/riscv/Makefile
> > @@ -56,6 +56,7 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
> >  riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
> >  riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
> 
> ...but march only contains fd if CONFIG_FPU is enabled...
> 
> >  riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
> > +riscv-march-$(CONFIG_RISCV_ISA_V)	:= $(riscv-march-y)v
> >  
> >  # Newer binutils versions default to ISA spec version 20191213 which moves some
> >  # instructions from the I extension to the Zicsr and Zifencei extensions.
> > @@ -65,7 +66,7 @@ riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
> >  # Check if the toolchain supports Zihintpause extension
> >  riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZIHINTPAUSE) := $(riscv-march-y)_zihintpause
> >  
> > -KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
> > +KBUILD_CFLAGS += -march=$(subst fdv,,$(riscv-march-y))
> 
> ...so I think this will not work if !CONFIG_FPU && RISCV_ISA_V.
> IIRC, vector uses some floating point opcodes, but does it (or Linux's
> implementation) actually depend on having floating point support in the
> kernel?

Yes.

"The V extension requires the scalar processor implements the F and D
extensions", RISC-V "V" Vector Extension, Section 18.3. V: Vector Extension
for Application Processors.

> If not, this cannot be done in a oneliner. Otherwise, CONFIG_RISCV_ISA_V
> should explicitly depend on CONFIG_FPU.
> 
> >  KBUILD_AFLAGS += -march=$(riscv-march-y)
> >  
> >  KBUILD_CFLAGS += -mno-save-restore
> > -- 
> > 2.17.1
> > 
> > 

