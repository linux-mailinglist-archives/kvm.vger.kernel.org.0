Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C404642BB8
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiLEP2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiLEP10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:27:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE55E12627;
        Mon,  5 Dec 2022 07:26:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6632B61189;
        Mon,  5 Dec 2022 15:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108D6C433C1;
        Mon,  5 Dec 2022 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670253987;
        bh=3y+uaXO+kxCid8d08Ki1sQHHOYibYWoGV7Nme9/CknM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GstjGtnXbwCmkuruQRDKXhMSIrl3dVDX8eI1wmQkVOYQJg3U+JYa+lRF3OxUxWSJN
         r8/wQv74XWzmiSlGBPzrCZagXqX+N6SVLcufSbPSk1/iQBwdQ1Fyggc2x5+6oaEvQG
         r3RHFY1WAPCtpY5FzOb+zda7JXr76mhgcTkFtPLxCLodC3+wDpyYfyKidVNPuMJTdZ
         fqoWNswKBrIP/Z8MiJ01cP41hHZRr0kajuuzrJsmABSR0+FcsaJp4SgmikRHz8WE1q
         OUlCF0sUgmwvfJatGaFVAmOs2VOqy9IDvsRI9NJZ+OFftE7gIm7uuTcAW7lXwdnnWB
         mtEjLwrO41MHw==
Date:   Mon, 5 Dec 2022 23:16:30 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v2 02/13] riscv: move riscv_noncoherent_supported() out
 of ZICBOM probe
Message-ID: <Y44LTqySUMCtKoUi@xhacker>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-3-jszhang@kernel.org>
 <5629547.DvuYhMxLoT@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5629547.DvuYhMxLoT@diego>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 04, 2022 at 10:52:03PM +0100, Heiko Stübner wrote:
> Am Sonntag, 4. Dezember 2022, 18:46:21 CET schrieb Jisheng Zhang:
> > It's a bit weird to call riscv_noncoherent_supported() each time when
> > insmoding a module. Move the calling out of feature patch func.
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > ---
> >  arch/riscv/kernel/cpufeature.c | 1 -
> >  arch/riscv/kernel/setup.c      | 2 ++
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> > index c743f0adc794..364d1fe86bea 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -274,7 +274,6 @@ static bool __init_or_module cpufeature_probe_zicbom(unsigned int stage)
> >  	if (!riscv_isa_extension_available(NULL, ZICBOM))
> >  		return false;
> >  
> > -	riscv_noncoherent_supported();
> >  	return true;
> >  }
> >  
> > diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
> > index 86acd690d529..6eea40bf8c6b 100644
> > --- a/arch/riscv/kernel/setup.c
> > +++ b/arch/riscv/kernel/setup.c
> > @@ -300,6 +300,8 @@ void __init setup_arch(char **cmdline_p)
> >  	riscv_init_cbom_blocksize();
> >  	riscv_fill_hwcap();
> >  	apply_boot_alternatives();
> > +	if (riscv_isa_extension_available(NULL, ZICBOM))
> > +		riscv_noncoherent_supported();
> 
> hmm, this changes the behaviour slightly. In the probe function there
> is the
> 	if (!IS_ENABLED(CONFIG_RISCV_ISA_ZICBOM))
> 		return false;
> at the top, so with this change the second WARN_TAINT in arch_setup_dma_ops
> will behave differently

thanks for the information. below code can keep the behavior:

	if (IS_ENABLED(CONFIG_RISCV_ISA_ZICBOM) &&
	    riscv_isa_extension_available(NULL, ZICBOM))
		riscv_noncoherent_supported();

will wait for one more day for more review comments, then will send out
a v3
> 
> Heiko
> 
> 
> 
