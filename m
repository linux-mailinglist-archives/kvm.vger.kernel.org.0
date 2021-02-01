Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B79130A21E
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 07:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhBAGnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 01:43:09 -0500
Received: from mga07.intel.com ([134.134.136.100]:57255 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhBAFl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:41:27 -0500
IronPort-SDR: WcjKEc16qNm1BVR2jC0CGEZabGoXC2bKcVXJbEuzWzrBW9vtN1mvmzArWKTH76PWeJm5S0VMnP
 n9xEabmRxxGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="244719189"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="244719189"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:40:44 -0800
IronPort-SDR: /54s9mM4Am73VgEz12gL36Rg4Npm4NklzgB81WLstnX/ew70oNp4wLBCq5nidYGzB9XaDOWNzG
 BN2nihMGIdcw==
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="371422526"
Received: from jaramosm-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.79.53])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:40:41 -0800
Date:   Mon, 1 Feb 2021 18:40:40 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver
 even when SGX driver is disabled
Message-Id: <20210201184040.646ea9923c2119c205b3378d@intel.com>
In-Reply-To: <YBVxF2kAl7VzeRPS@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
        <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
        <YBVxF2kAl7VzeRPS@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 30 Jan 2021 16:45:43 +0200 Jarkko Sakkinen wrote:
> On Tue, Jan 26, 2021 at 10:31:00PM +1300, Kai Huang wrote:
> > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > even if the bare-metal SGX driver is disabled.  The bare-metal driver
> > might be disabled if SGX Launch Control is in locked mode, or not
> > supported in the hardware at all.  This allows (non-Linux) guests that
> > support non-LC configurations to use SGX.
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> > v2->v3:
> > 
> >  - Changed from sgx_virt_epc_init() to sgx_vepc_init().
> > 
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 21c2ffa13870..93d249f7bff3 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -12,6 +12,7 @@
> >  #include "driver.h"
> >  #include "encl.h"
> >  #include "encls.h"
> > +#include "virt.h"
> >  
> >  struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
> >  static int sgx_nr_epc_sections;
> > @@ -712,7 +713,8 @@ static int __init sgx_init(void)
> >  		goto err_page_cache;
> >  	}
> >  
> > -	ret = sgx_drv_init();
> > +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> 
> If would create more dumb code and just add
> 
> ret = sgx_vepc_init()
> if (ret)
>         goto err_kthread;

Do you mean you want below?

	ret = sgx_drv_init();
	ret = sgx_vepc_init();
	if (ret)
		goto err_kthread;

This was Sean's original code, but Dave didn't like it.

Sean/Dave,

Please let me know which way you prefer.

> 
> >  	if (ret)
> >  		goto err_kthread;
> >  
> > -- 
> > 2.29.2
> > 
> 
> /Jarkko
> > 
