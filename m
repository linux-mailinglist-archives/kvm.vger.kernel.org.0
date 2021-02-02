Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5230C7EB
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbhBBRfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:35:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237619AbhBBRdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 12:33:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCFFA64E9C;
        Tue,  2 Feb 2021 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612287157;
        bh=M04SyJQ3T5b23EF8TLLqUAMtt12G2frfLwd0wJ9JWQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lRxlVEhEKodVWMocEvyPe3sQzPs9mOXAwDb6/SMLVVqNyrCjd0DOQWHR2btcxPiZp
         ZZrdMff5hUFPzoiDew4VHSK8uKINZp301DKBfW8QeMlt+hbPeYsjbp1BMBFkQsz/oK
         5HYbBmDU1+URsjyx5sUmxP1Lc8FxtIXQ+KnAg9q1H7dVz9ShgMVk77gDTFQPyfYg6U
         uYMUS2mRfmmoiTw4REPX9VFT3Jl+u5VGphRmwT1tE8ykU0DWSso2WCsZk+zEI90jwe
         hKevJyTOxMz6cVS4YFHneY15O6c0P4z777MnE1SnAobeFTPWEHTrdmts4sqhghnDVJ
         73iULHZRVzdug==
Date:   Tue, 2 Feb 2021 19:32:30 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBmMrqxlTxClg9Eb@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201184040.646ea9923c2119c205b3378d@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 06:40:40PM +1300, Kai Huang wrote:
> On Sat, 30 Jan 2021 16:45:43 +0200 Jarkko Sakkinen wrote:
> > On Tue, Jan 26, 2021 at 10:31:00PM +1300, Kai Huang wrote:
> > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > even if the bare-metal SGX driver is disabled.  The bare-metal driver
> > > might be disabled if SGX Launch Control is in locked mode, or not
> > > supported in the hardware at all.  This allows (non-Linux) guests that
> > > support non-LC configurations to use SGX.
> > > 
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > > v2->v3:
> > > 
> > >  - Changed from sgx_virt_epc_init() to sgx_vepc_init().
> > > 
> > > ---
> > >  arch/x86/kernel/cpu/sgx/main.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > index 21c2ffa13870..93d249f7bff3 100644
> > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > @@ -12,6 +12,7 @@
> > >  #include "driver.h"
> > >  #include "encl.h"
> > >  #include "encls.h"
> > > +#include "virt.h"
> > >  
> > >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> > >  static int sgx_nr_epc_sections;
> > > @@ -712,7 +713,8 @@ static int __init sgx_init(void)
> > >  		goto err_page_cache;
> > >  	}
> > >  
> > > -	ret = sgx_drv_init();
> > > +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> > > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > 
> > If would create more dumb code and just add
> > 
> > ret = sgx_vepc_init()
> > if (ret)
> >         goto err_kthread;
> 
> Do you mean you want below?
> 
> 	ret = sgx_drv_init();
> 	ret = sgx_vepc_init();
> 	if (ret)
> 		goto err_kthread;
> 
> This was Sean's original code, but Dave didn't like it.

I think it should be like:

ret = sgx_drv_init();
if (ret)
        pr_warn("Driver initialization failed with %d\n", ret);

ret = sgx_vepc_init();
if (ret)
	goto err_kthread;

There is problem here anyhow. I.e. -ENODEV's from sgx_drv_init().  I think
how driver.c should be changed would be just to return 0 in the places
where it now return -ENODEV. Consider "not initialized" as a successful
initialization.

/Jarkko
