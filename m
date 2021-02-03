Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0195830D07D
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 01:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhBCAt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 19:49:59 -0500
Received: from mga05.intel.com ([192.55.52.43]:44605 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233096AbhBCAty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 19:49:54 -0500
IronPort-SDR: AS/Bc8XyV1nCvUcuaV0+hHzph2wYB+CutmWk796sceXQsujSCM84O3FB+cAZ0UH/XA+JAfQF8O
 XhBFHD2BoiUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="265791961"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="265791961"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:49:12 -0800
IronPort-SDR: tzA16BLZv9dIOZqzc1TKzbKibf7yVwBtivrG1BS7RY+rqMi5H5pkDTD8iqu8PaiAkafbctN6In
 Y1XWz9wI+oLw==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="406364440"
Received: from asalasax-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.175])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:49:09 -0800
Date:   Wed, 3 Feb 2021 13:49:06 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver
 even when SGX driver is disabled
Message-Id: <20210203134906.78b5265502c65f13bacc5e68@intel.com>
In-Reply-To: <YBndRM9m0XHYwsPP@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
        <YBVxF2kAl7VzeRPS@kernel.org>
        <20210201184040.646ea9923c2119c205b3378d@intel.com>
        <YBmMrqxlTxClg9Eb@kernel.org>
        <YBmX/wFFshokDqWM@google.com>
        <YBndRM9m0XHYwsPP@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Feb 2021 01:16:20 +0200 Jarkko Sakkinen wrote:
> On Tue, Feb 02, 2021 at 10:20:47AM -0800, Sean Christopherson wrote:
> > On Tue, Feb 02, 2021, Jarkko Sakkinen wrote:
> > > On Mon, Feb 01, 2021 at 06:40:40PM +1300, Kai Huang wrote:
> > > > On Sat, 30 Jan 2021 16:45:43 +0200 Jarkko Sakkinen wrote:
> > > > > On Tue, Jan 26, 2021 at 10:31:00PM +1300, Kai Huang wrote:
> > > > > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > > > > even if the bare-metal SGX driver is disabled.  The bare-metal driver
> > > > > > might be disabled if SGX Launch Control is in locked mode, or not
> > > > > > supported in the hardware at all.  This allows (non-Linux) guests that
> > > > > > support non-LC configurations to use SGX.
> > > > > > 
> > > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > > ---
> > > > > > v2->v3:
> > > > > > 
> > > > > >  - Changed from sgx_virt_epc_init() to sgx_vepc_init().
> > > > > > 
> > > > > > ---
> > > > > >  arch/x86/kernel/cpu/sgx/main.c | 4 +++-
> > > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > > > > index 21c2ffa13870..93d249f7bff3 100644
> > > > > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > > > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > > > > @@ -12,6 +12,7 @@
> > > > > >  #include "driver.h"
> > > > > >  #include "encl.h"
> > > > > >  #include "encls.h"
> > > > > > +#include "virt.h"
> > > > > >  
> > > > > >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> > > > > >  static int sgx_nr_epc_sections;
> > > > > > @@ -712,7 +713,8 @@ static int __init sgx_init(void)
> > > > > >  		goto err_page_cache;
> > > > > >  	}
> > > > > >  
> > > > > > -	ret = sgx_drv_init();
> > > > > > +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> > > > > > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > > > > 
> > > > > If would create more dumb code and just add
> > > > > 
> > > > > ret = sgx_vepc_init()
> > > > > if (ret)
> > > > >         goto err_kthread;
> > > > 
> > > > Do you mean you want below?
> > > > 
> > > > 	ret = sgx_drv_init();
> > > > 	ret = sgx_vepc_init();
> > > > 	if (ret)
> > > > 		goto err_kthread;
> > > > 
> > > > This was Sean's original code, but Dave didn't like it.
> > > 
> > > I think it should be like:
> > > 
> > > ret = sgx_drv_init();
> > > if (ret)
> > >         pr_warn("Driver initialization failed with %d\n", ret);
> > > 
> > > ret = sgx_vepc_init();
> > > if (ret)
> > > 	goto err_kthread;
> > 
> > And that's wrong, it doesn't correctly handle the case where sgx_drv_init()
> > succeeds but sgx_vepc_init() fails.
> 
> After reading all of this, I think that the only acceptable way to
> to manage this is to
> 
> ret = sgx_drv_init();
> if (ret && ret != -ENODEV)
>         goto err_kthread;

Why? From SGX virtualization's perspective, it doesn't care what error code
caused driver not being initialized properly. Actually it even doesn't care
about whether driver initialization is successful or not.

> 
> ret = sgx_vepc_init();
> if (ret)
> 	goto err_kthread;
> 
> Anything else would be a bad idea.
> 
> We do support allowing KVM when the driver does not *support* SGX,
> not when something is working incorrectly. 

What working *incorrectly* thing is related to SGX virtualization? The things
SGX virtualization requires (basically just raw EPC allocation) are all in
sgx/main.c. 

In that case it is a bad
> idea to allow any SGX related initialization to continue.
> 
> Agreed that my earlier example is incorrect but so is the condition
> in the original patch.
> 
> /Jarkko 
