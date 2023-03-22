Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C32B6C54DD
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 20:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjCVT0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 15:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjCVT0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 15:26:16 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5426362339
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 12:26:13 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x3so77279310edb.10
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 12:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1679513172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TC6eNLv6iVcM+dLqVd9h+kHjsMmIK0cHmLbQH5XvCQ4=;
        b=YWt+tkLlfdne2Kd0Awx/G4k2qdpzdqxUYDyTBl1Ztnt2ciLuzV00hGhXgAwtJraOta
         foR02SN4g6mrdL4klrVO+c7tFOawmQREXUGb39aqVJgplHebbVKbDKt4rfoJICjBvCMu
         wBK2gDh8hkB0IAhJCytrzvJckPBgh5K8Bt8+sUhwVZuFARuNc2HPfnpZAWb/gZhAHBHq
         kdsvBwn5zagJhUTI8/WriLqEs0UsqOBQ2L8AwQN8ZEYSgKvcT+c7MRTTgCRjZ+bdh0qB
         sZ+7dpMJR+G+PGeubi3mV2QNhg22WsB2UIRYmJqmyL2COl0dZwD8v2RsGie0Xjj8WSpI
         WVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679513172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TC6eNLv6iVcM+dLqVd9h+kHjsMmIK0cHmLbQH5XvCQ4=;
        b=XjqNn5vswDW1oHU4DmGrDSihMGbiZLtMup4u5niuA4pmuD/QgQyRmYGiR0UzJ/d6iz
         xzqiQS5wotN/racJX+spW4cPLDNuCneTs/J7JzCBRfr2QAf4bXGQmx8ErqiBv8VNOqJk
         ylNyc0BFTJJ6+BEugH5A2LRNYlnrebPwog3uPoR1lbhBbpw4TdnFmUX9xNpb//4TH0tO
         LwtbY49HyrnGONiY+dIsH2I80pWZHfkWHmIMa096Isd9q/vYwx5nZBHVax0EE6rjYTkF
         coC9oacZFczA0YxrHgXX6hLlrXsBkdWEWlqLirupqwpgIabnTmj3uLk2woj+Jhq3i1qK
         RNTQ==
X-Gm-Message-State: AO0yUKXg+eyTVOEJkBwZWejmKmPcnDp8zlWg6ek8qPS9Q9NJ3o2nT8kH
        kwyHxLUXDXyuntbFByF97MOX3w==
X-Google-Smtp-Source: AK7set/uwReF6l3N0b+QrVmoQo5JsU4Z8X/6Kjo6ne/T8bhKCGGJPKxX52G9T9KTbzd4uWztJ0Q8Ww==
X-Received: by 2002:a17:906:c257:b0:932:6452:2396 with SMTP id bl23-20020a170906c25700b0093264522396mr7250972ejb.74.1679513171843;
        Wed, 22 Mar 2023 12:26:11 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id k19-20020a1709063fd300b00928de86245fsm7587557ejj.135.2023.03.22.12.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:26:11 -0700 (PDT)
Date:   Wed, 22 Mar 2023 20:26:10 +0100
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Conor Dooley <conor@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        regressions@leemhuis.info, regressions@lists.linux.dev
Subject: Re: [PATCH] riscv: require alternatives framework when selecting FPU
 support
Message-ID: <20230322192610.sad42xau33ye5ayn@orel>
References: <ZBruFRwt3rUVngPu@zx2c4.com>
 <20230322120907.2968494-1-Jason@zx2c4.com>
 <20230322124631.7p67thzeblrawsqj@orel>
 <1884bd96-2783-4556-bc57-8b733758baff@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1884bd96-2783-4556-bc57-8b733758baff@spud>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 03:17:13PM +0000, Conor Dooley wrote:
> On Wed, Mar 22, 2023 at 01:46:31PM +0100, Andrew Jones wrote:
> > On Wed, Mar 22, 2023 at 01:09:07PM +0100, Jason A. Donenfeld wrote:
> > > When moving switch_to's has_fpu() over to using riscv_has_extension_
> > > likely() rather than static branchs, the FPU code gained a dependency on
> > > the alternatives framework. If CONFIG_RISCV_ALTERNATIVE isn't selected
> > > when CONFIG_FPU is, then has_fpu() returns false, and switch_to does not
> > > work as intended. So select CONFIG_RISCV_ALTERNATIVE when CONFIG_FPU is
> > > selected.
> > > 
> > > Fixes: 702e64550b12 ("riscv: fpu: switch has_fpu() to riscv_has_extension_likely()")
> > > Link: https://lore.kernel.org/all/ZBruFRwt3rUVngPu@zx2c4.com/
> > > Cc: Jisheng Zhang <jszhang@kernel.org>
> > > Cc: Andrew Jones <ajones@ventanamicro.com>
> > > Cc: Heiko Stuebner <heiko@sntech.de>
> > > Cc: Conor Dooley <conor.dooley@microchip.com>
> 
> Thanks for fixing it!
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> 
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > ---
> > >  arch/riscv/Kconfig | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > > index c5e42cc37604..0f59350c699d 100644
> > > --- a/arch/riscv/Kconfig
> > > +++ b/arch/riscv/Kconfig
> > > @@ -467,6 +467,7 @@ config TOOLCHAIN_HAS_ZIHINTPAUSE
> > >  config FPU
> > >  	bool "FPU support"
> > >  	default y
> > > +	select RISCV_ALTERNATIVE
> > >  	help
> > >  	  Say N here if you want to disable all floating-point related procedure
> > >  	  in the kernel.
> > > -- 
> > > 2.40.0
> > >
> > 
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > 
> > I took a look to see if we missed anything else and see that we should
> > do the same patch for KVM. I'll send one.
> > 
> > (It's tempting to just select RISCV_ALTERNATIVE from RISCV, but maybe we
> >  can defer that wedding a bit longer.)
> 
> At that point, the config option should just go away entirely, no?

Ah, yes, and that makes the idea even more attractive, as we could remove
several ifdefs.

Thanks,
drew
