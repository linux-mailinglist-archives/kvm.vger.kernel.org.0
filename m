Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9398730CFBA
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 00:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbhBBXLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 18:11:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236088AbhBBXLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 18:11:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C7A364F49;
        Tue,  2 Feb 2021 23:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612307458;
        bh=eW8um/Ioo/THqZqn4fbfRLa1bLZzyvdNcBq7vNyKrrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mwGFlD2WRN5QZTYwT6fis8iqzHqxGeW5A4V8a8SDrLvwZ0PiN5DeNGrAwHAsSiq5A
         fz/fy7fEFJXDdg4lKm4jlyB4zUOI0Ie3jdRCBm9Ch0jvcHirDUeOHfxqkeIYAb5Y/T
         pkFFkwGEYs5NqVotFxVUN7dyNfUptzzkhQFEIBUCg1pfGQ5TrnAYfNEH6v61w3RRP2
         tP2cMURMHwzTj4JA5EElf7d2jtIlCQs/lRt0m1uI32Qx626Wc4/DF04lUDjTego794
         VYIoXiyQy6pj9N92HqpcpC42QH5dyrtZCQVt1rO6Vic4Y3zlcBBidQ6QAiu8N/U7eB
         zb2WwJSsdWYyw==
Date:   Wed, 3 Feb 2021 01:10:50 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBnb+hTkHqmuUeX3@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <dc3bc76e-fd89-011d-513b-fac6c6f5e0f0@intel.com>
 <YBg5BradIvA4jNGw@google.com>
 <20210202131207.a806a0c35140a9a210aaccec@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202131207.a806a0c35140a9a210aaccec@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 01:12:07PM +1300, Kai Huang wrote:
> On Mon, 1 Feb 2021 09:23:18 -0800 Sean Christopherson wrote:
> > On Mon, Feb 01, 2021, Dave Hansen wrote:
> > > On 1/31/21 9:40 PM, Kai Huang wrote:
> > > >>> -	ret = sgx_drv_init();
> > > >>> +	/* Success if the native *or* virtual EPC driver initialized cleanly. */
> > > >>> +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > > >> If would create more dumb code and just add
> > > >>
> > > >> ret = sgx_vepc_init()
> > > >> if (ret)
> > > >>         goto err_kthread;
> > > 
> > > Jarkko, I'm not sure I understand this suggestion.
> > > 
> > > > Do you mean you want below?
> > > > 
> > > > 	ret = sgx_drv_init();
> > > > 	ret = sgx_vepc_init();
> > > > 	if (ret)
> > > > 		goto err_kthread;
> > > > 
> > > > This was Sean's original code, but Dave didn't like it.
> > 
> > The problem is it's wrong.  That snippet would incorrectly bail if drv_init()
> > succeeds but vepc_init() fails.
> > 
> > The alternative to the bitwise AND is to snapshot the result in two separate
> > variables:
> > 
> > 	ret = sgx_drv_init();
> > 	ret2 = sgx_vepc_init();
> > 	if (ret && ret2)
> > 		goto err_kthread;
> > 
> > or check the return from drv_init() _after_ vepc_init():
> > 
> > 	ret = sgx_drv_init();
> > 	if (sgx_vepc_init() && ret)
> > 		goto err_kthread;
> > 
> > 
> > As evidenced by this thread, the behavior is subtle and easy to get wrong.  I
> > deliberately chose the option that was the weirdest specifically to reduce the
> > probability of someone incorrectly "cleaning up" the code.
> > 
> > > Are you sure?  I remember the !!&!! abomination being Sean's doing. :)
> > 
> > Yep!  That 100% functionally correct horror is my doing.
> > 
> > > > Sean/Dave,
> > > > 
> > > > Please let me know which way you prefer.
> > > 
> > > Kai, I don't really know you are saying here.  In the end,
> > > sgx_vepc_init() has to run regardless of whether sgx_drv_init() is
> > > successful or not.  Also, we only want to 'goto err_kthraed' if *BOTH*
> > > fail.  The code you have above will, for instance, 'goto err_kthread' if
> > > sgx_drv_init() succeeds but sgx_vepc_init() fails.  It entirely
> > > disregards the sgx_drv_init() error code.
> > 
> 
> Hi Dave, Sean,
> 
> Yeah sorry my bad. The example I provided won't work. So I'd like keep the !!
> &!! :)
> 
> Thanks. 
> 
> Jarkko, please let us know if you still have concern.

I'll just review the next version. I disagree with this packing though.

/Jarkko
