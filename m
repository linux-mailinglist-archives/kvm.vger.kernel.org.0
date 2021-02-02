Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5289230B3F0
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 01:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhBBANB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 19:13:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:14122 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhBBANA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 19:13:00 -0500
IronPort-SDR: 1JtRBZrW7re9Wcu4GqANrA00rhJI0HjJ6x1t0PMDmi2F5a5FkpTNO+Hb7x91w+NLmWSRV0MEBQ
 pRABYXRGmJRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="199680664"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="199680664"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 16:12:17 -0800
IronPort-SDR: FOQN8h8rNiqo1GQ/xhm8q2xkM9V8SIjdpOBLYxhzRXQ2KjELc0M9gkT/I2glhIvoHxC0GtRQkc
 uh7i/Kq5QTZQ==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="507045754"
Received: from gsabbine-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.23.28])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 16:12:09 -0800
Date:   Tue, 2 Feb 2021 13:12:07 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver
 even when SGX driver is disabled
Message-Id: <20210202131207.a806a0c35140a9a210aaccec@intel.com>
In-Reply-To: <YBg5BradIvA4jNGw@google.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
        <YBVxF2kAl7VzeRPS@kernel.org>
        <20210201184040.646ea9923c2119c205b3378d@intel.com>
        <dc3bc76e-fd89-011d-513b-fac6c6f5e0f0@intel.com>
        <YBg5BradIvA4jNGw@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 09:23:18 -0800 Sean Christopherson wrote:
> On Mon, Feb 01, 2021, Dave Hansen wrote:
> > On 1/31/21 9:40 PM, Kai Huang wrote:
> > >>> -	ret = sgx_drv_init();
> > >>> +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> > >>> +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > >> If would create more dumb code and just add
> > >>
> > >> ret = sgx_vepc_init()
> > >> if (ret)
> > >>         goto err_kthread;
> > 
> > Jarkko, I'm not sure I understand this suggestion.
> > 
> > > Do you mean you want below?
> > > 
> > > 	ret = sgx_drv_init();
> > > 	ret = sgx_vepc_init();
> > > 	if (ret)
> > > 		goto err_kthread;
> > > 
> > > This was Sean's original code, but Dave didn't like it.
> 
> The problem is it's wrong.  That snippet would incorrectly bail if drv_init()
> succeeds but vepc_init() fails.
> 
> The alternative to the bitwise AND is to snapshot the result in two separate
> variables:
> 
> 	ret = sgx_drv_init();
> 	ret2 = sgx_vepc_init();
> 	if (ret && ret2)
> 		goto err_kthread;
> 
> or check the return from drv_init() _after_ vepc_init():
> 
> 	ret = sgx_drv_init();
> 	if (sgx_vepc_init() && ret)
> 		goto err_kthread;
> 
> 
> As evidenced by this thread, the behavior is subtle and easy to get wrong.  I
> deliberately chose the option that was the weirdest specifically to reduce the
> probability of someone incorrectly "cleaning up" the code.
> 
> > Are you sure?  I remember the !!&!! abomination being Sean's doing. :)
> 
> Yep!  That 100% functionally correct horror is my doing.
> 
> > > Sean/Dave,
> > > 
> > > Please let me know which way you prefer.
> > 
> > Kai, I don't really know you are saying here.  In the end,
> > sgx_vepc_init() has to run regardless of whether sgx_drv_init() is
> > successful or not.  Also, we only want to 'goto err_kthraed' if *BOTH*
> > fail.  The code you have above will, for instance, 'goto err_kthread' if
> > sgx_drv_init() succeeds but sgx_vepc_init() fails.  It entirely
> > disregards the sgx_drv_init() error code.
> 

Hi Dave, Sean,

Yeah sorry my bad. The example I provided won't work. So I'd like keep the !!
&!! :)

Thanks. 

Jarkko, please let us know if you still have concern.
