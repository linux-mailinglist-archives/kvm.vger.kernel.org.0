Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FB530CA8B
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhBBSwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:52:37 -0500
Received: from mga17.intel.com ([192.55.52.151]:27098 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236794AbhBBSug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:50:36 -0500
IronPort-SDR: eY4m2ZcGJ/ZKYrRSL9y3g/hXMREy0Wyo5UirBZ57Go1La4a6FYllYrN6+YRBO6CYQLYBB8WKLk
 ERG2V4ITF0BA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="160674917"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="160674917"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 10:49:51 -0800
IronPort-SDR: RHEFA3wL1qnQS5Y8mIIsJtbUKkn5IafRFf/lzt4UCgSLHXskVm96SR6yXiWt0Ch7n9rD+eS0Ys
 U3tkci7cpNHw==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="391621380"
Received: from asalasax-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.175])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 10:49:48 -0800
Date:   Wed, 3 Feb 2021 07:49:45 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver
 even when SGX driver is disabled
Message-Id: <20210203074945.0e836486d6afc29e9b44fdbf@intel.com>
In-Reply-To: <YBmMrqxlTxClg9Eb@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
        <YBVxF2kAl7VzeRPS@kernel.org>
        <20210201184040.646ea9923c2119c205b3378d@intel.com>
        <YBmMrqxlTxClg9Eb@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 19:32:30 +0200 Jarkko Sakkinen wrote:
> On Mon, Feb 01, 2021 at 06:40:40PM +1300, Kai Huang wrote:
> > On Sat, 30 Jan 2021 16:45:43 +0200 Jarkko Sakkinen wrote:
> > > On Tue, Jan 26, 2021 at 10:31:00PM +1300, Kai Huang wrote:
> > > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > > even if the bare-metal SGX driver is disabled.  The bare-metal driver
> > > > might be disabled if SGX Launch Control is in locked mode, or not
> > > > supported in the hardware at all.  This allows (non-Linux) guests that
> > > > support non-LC configurations to use SGX.
> > > > 
> > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > ---
> > > > v2->v3:
> > > > 
> > > >  - Changed from sgx_virt_epc_init() to sgx_vepc_init().
> > > > 
> > > > ---
> > > >  arch/x86/kernel/cpu/sgx/main.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > > index 21c2ffa13870..93d249f7bff3 100644
> > > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > > @@ -12,6 +12,7 @@
> > > >  #include "driver.h"
> > > >  #include "encl.h"
> > > >  #include "encls.h"
> > > > +#include "virt.h"
> > > >  
> > > >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> > > >  static int sgx_nr_epc_sections;
> > > > @@ -712,7 +713,8 @@ static int __init sgx_init(void)
> > > >  		goto err_page_cache;
> > > >  	}
> > > >  
> > > > -	ret = sgx_drv_init();
> > > > +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> > > > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > > 
> > > If would create more dumb code and just add
> > > 
> > > ret = sgx_vepc_init()
> > > if (ret)
> > >         goto err_kthread;
> > 
> > Do you mean you want below?
> > 
> > 	ret = sgx_drv_init();
> > 	ret = sgx_vepc_init();
> > 	if (ret)
> > 		goto err_kthread;
> > 
> > This was Sean's original code, but Dave didn't like it.
> 
> I think it should be like:
> 
> ret = sgx_drv_init();
> if (ret)
>         pr_warn("Driver initialization failed with %d\n", ret);
> 
> ret = sgx_vepc_init();
> if (ret)
> 	goto err_kthread;
> 
> There is problem here anyhow. I.e. -ENODEV's from sgx_drv_init().  I think
> how driver.c should be changed would be just to return 0 in the places
> where it now return -ENODEV. Consider "not initialized" as a successful
> initialization.

Hi Jarkko,

Dave already pointed out above code won't work. The problem is failure to
initialize vepc will just goto err_kthread, no matter whether driver has been
initialized successfully or not. 

I am sticking to the original way (!! & !!).

> 
> /Jarkko
