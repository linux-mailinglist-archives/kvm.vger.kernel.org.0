Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2478130CFCB
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 00:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbhBBXRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 18:17:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236418AbhBBXRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 18:17:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3921B64F74;
        Tue,  2 Feb 2021 23:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612307787;
        bh=vD9heg/ocCMzRX0Ub+/qDUdUBZRo012giLlKJyJKnX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EFsyhma1Q5g+lrYAateEcRPIy/yd6gkRp0Q3ct3t053VBnCYKIVfDfka6MnDs3QX6
         qVOPpSUOnfKCgXWqSJqVwnY0A8jaj6OHZSch0vD8LrQbab7vwd9zTElfoBqH+rqlZS
         N7msE4Jd4MWtdvhFGBktMfqSs4Hff5YMNDxBWndS7btcno+5cv0Cmq1WbHYfkwdJdf
         ULDHAOjFGTr22n9ofjymsP+9LHZ4PzoIYJ7f7HnxDjKjC2oKZpgCmtaURO4NZRsHF3
         P4ps7K+utOgH4ftThUKMQ9gFfQ15gcEe89U4domHTArAaCGOKMl9V+3bRscSzPj9ao
         bMyY1aMo9WBOw==
Date:   Wed, 3 Feb 2021 01:16:20 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBndRM9m0XHYwsPP@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <YBmMrqxlTxClg9Eb@kernel.org>
 <YBmX/wFFshokDqWM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBmX/wFFshokDqWM@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 10:20:47AM -0800, Sean Christopherson wrote:
> On Tue, Feb 02, 2021, Jarkko Sakkinen wrote:
> > On Mon, Feb 01, 2021 at 06:40:40PM +1300, Kai Huang wrote:
> > > On Sat, 30 Jan 2021 16:45:43 +0200 Jarkko Sakkinen wrote:
> > > > On Tue, Jan 26, 2021 at 10:31:00PM +1300, Kai Huang wrote:
> > > > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > > > even if the bare-metal SGX driver is disabled.  The bare-metal driver
> > > > > might be disabled if SGX Launch Control is in locked mode, or not
> > > > > supported in the hardware at all.  This allows (non-Linux) guests that
> > > > > support non-LC configurations to use SGX.
> > > > > 
> > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > ---
> > > > > v2->v3:
> > > > > 
> > > > >  - Changed from sgx_virt_epc_init() to sgx_vepc_init().
> > > > > 
> > > > > ---
> > > > >  arch/x86/kernel/cpu/sgx/main.c | 4 +++-
> > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > > > index 21c2ffa13870..93d249f7bff3 100644
> > > > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > > > @@ -12,6 +12,7 @@
> > > > >  #include "driver.h"
> > > > >  #include "encl.h"
> > > > >  #include "encls.h"
> > > > > +#include "virt.h"
> > > > >  
> > > > >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> > > > >  static int sgx_nr_epc_sections;
> > > > > @@ -712,7 +713,8 @@ static int __init sgx_init(void)
> > > > >  		goto err_page_cache;
> > > > >  	}
> > > > >  
> > > > > -	ret = sgx_drv_init();
> > > > > +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> > > > > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > > > 
> > > > If would create more dumb code and just add
> > > > 
> > > > ret = sgx_vepc_init()
> > > > if (ret)
> > > >         goto err_kthread;
> > > 
> > > Do you mean you want below?
> > > 
> > > 	ret = sgx_drv_init();
> > > 	ret = sgx_vepc_init();
> > > 	if (ret)
> > > 		goto err_kthread;
> > > 
> > > This was Sean's original code, but Dave didn't like it.
> > 
> > I think it should be like:
> > 
> > ret = sgx_drv_init();
> > if (ret)
> >         pr_warn("Driver initialization failed with %d\n", ret);
> > 
> > ret = sgx_vepc_init();
> > if (ret)
> > 	goto err_kthread;
> 
> And that's wrong, it doesn't correctly handle the case where sgx_drv_init()
> succeeds but sgx_vepc_init() fails.

After reading all of this, I think that the only acceptable way to
to manage this is to

ret = sgx_drv_init();
if (ret && ret != -ENODEV)
        goto err_kthread;

ret = sgx_vepc_init();
if (ret)
	goto err_kthread;

Anything else would be a bad idea.

We do support allowing KVM when the driver does not *support* SGX,
not when something is working incorrectly. In that case it is a bad
idea to allow any SGX related initialization to continue.

Agreed that my earlier example is incorrect but so is the condition
in the original patch.

/Jarkko 
