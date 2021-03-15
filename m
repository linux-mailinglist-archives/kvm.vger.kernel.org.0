Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1033133C9A9
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhCOXFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233454AbhCOXF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:05:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A546964E07;
        Mon, 15 Mar 2021 23:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615849528;
        bh=mThrypAfS1ZWYKktlz1+6DLIOR3JnDe9Dwd1coWe4Kw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kICSplKy6VgcSY3GYz50VYln+QyowsHZVyqj2X7Bcgd/MtITEJlcWpLOcK69LnMrM
         CfFPajbxfW6YoXjU+pA0wRF+J7orizeDfCV1PwLjXkl8Woed1evBVvmqfk/9SYT3SX
         Q1KGnIJNYZplVGDAbsazluPiFlbi2eaoQMPvI1F3TLP7kHYHi5vg2LUqWwXvCj608T
         zTXbI3jUUlGlhQBMjeKYDzKhHSbVH+bd4tCnCEYZFE7Eh3nxu+xUQAaP/JGIFvLTDE
         V6g6eh06ayzD9PH6V/VDqm2M12fct4iukF6bTFYs8DpwkW6TQKDsqXwNSY3wVWBz9K
         audVCwX5mATKA==
Date:   Tue, 16 Mar 2021 01:05:02 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YE/oHt92suFDHJ7Z@kernel.org>
References: <d2ebcffeb9193d26a1305e08fe1aa1347feb1c62.1615250634.git.kai.huang@intel.com>
 <YEvg2vNfiDYoc9u3@google.com>
 <YE0M/VoETPw7YZIy@kernel.org>
 <YE0NeChRjBlldQ8H@kernel.org>
 <YE4M8JGGl9Xyx51/@kernel.org>
 <YE4rVnfQ9y7CnVvr@kernel.org>
 <20210315161317.9c72479dfcde4e22078abcd2@intel.com>
 <YE9beKYDaG1sMWq+@kernel.org>
 <YE9mVUF0KOPNSfA9@kernel.org>
 <20210316094859.7b5947b743a81dff7434615c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316094859.7b5947b743a81dff7434615c@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 09:48:59AM +1300, Kai Huang wrote:
> On Mon, 15 Mar 2021 15:51:17 +0200 Jarkko Sakkinen wrote:
> > On Mon, Mar 15, 2021 at 03:04:59PM +0200, Jarkko Sakkinen wrote:
> > > On Mon, Mar 15, 2021 at 04:13:17PM +1300, Kai Huang wrote:
> > > > On Sun, 14 Mar 2021 17:27:18 +0200 Jarkko Sakkinen wrote:
> > > > > On Sun, Mar 14, 2021 at 05:25:26PM +0200, Jarkko Sakkinen wrote:
> > > > > > On Sat, Mar 13, 2021 at 09:07:36PM +0200, Jarkko Sakkinen wrote:
> > > > > > > On Sat, Mar 13, 2021 at 09:05:36PM +0200, Jarkko Sakkinen wrote:
> > > > > > > > On Fri, Mar 12, 2021 at 01:44:58PM -0800, Sean Christopherson wrote:
> > > > > > > > > On Tue, Mar 09, 2021, Kai Huang wrote:
> > > > > > > > > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > > > > > > > > even if the SGX driver is disabled.  The SGX driver might be disabled
> > > > > > > > > > if SGX Launch Control is in locked mode, or not supported in the
> > > > > > > > > > hardware at all.  This allows (non-Linux) guests that support non-LC
> > > > > > > > > > configurations to use SGX.
> > > > > > > > > > 
> > > > > > > > > > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > > > > > > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > > > > > > ---
> > > > > > > > > >  arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
> > > > > > > > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > > > > > > > > index 44fe91a5bfb3..8c922e68274d 100644
> > > > > > > > > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > > > > > > > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > > > > > > > > @@ -712,7 +712,15 @@ static int __init sgx_init(void)
> > > > > > > > > >  		goto err_page_cache;
> > > > > > > > > >  	}
> > > > > > > > > >  
> > > > > > > > > > -	ret = sgx_drv_init();
> > > > > > > > > > +	/*
> > > > > > > > > > +	 * Always try to initialize the native *and* KVM drivers.
> > > > > > > > > > +	 * The KVM driver is less picky than the native one and
> > > > > > > > > > +	 * can function if the native one is not supported on the
> > > > > > > > > > +	 * current system or fails to initialize.
> > > > > > > > > > +	 *
> > > > > > > > > > +	 * Error out only if both fail to initialize.
> > > > > > > > > > +	 */
> > > > > > > > > > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > > > > > > > > 
> > > > > > > > > I love this code.
> > > > > > > > > 
> > > > > > > > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > > > > > > > 
> > > > > > > > I'm still wondering why this code let's go through when sgx_drv_init()
> > > > > > > > succeeds and sgx_vepc_init() fails.
> > > > > > > > 
> > > > > > > > The inline comment explains only the mirrored case (which does make
> > > > > > > > sense).
> > > > > > > 
> > > > > > > I.e. if sgx_drv_init() succeeds, I'd expect that sgx_vepc_init() must
> > > > > > > succeed. Why expect legitly anything else?
> > > > > >  
> > > > > > Apologies coming with these ideas at this point, but here is what this
> > > > > > led me.
> > > > > > 
> > > > > > I think that the all this complexity comes from a bad code structure.
> > > > > > 
> > > > > > So, what is essentially happening here:
> > > > > > 
> > > > > > - We essentially want to make EPC always work.
> > > > > > - Driver optionally.
> > > > > > 
> > > > > > So what this sums to is something like:
> > > > > > 
> > > > > >         ret = sgx_epc_init();
> > > > > >         if (ret) {
> > > > > >                 pr_err("EPC initialization failed.\n");
> > > > > >                 return ret;
> > > > > >         }
> > > > > > 
> > > > > >         ret = sgx_drv_init();
> > > > > >         if (ret)
> > > > > >                 pr_info("Driver could not be initialized.\n");
> > > > > > 
> > > > > >         /* continue */
> > > > > > 
> > > > > > I.e. I think there should be a single EPC init, which does both EPC
> > > > > > bootstrapping and vepc, and driver initialization comes after that.
> > > > > 
> > > > > In other words, from SGX point of view, the thing that KVM needs is
> > > > > to cut out EPC and driver part into different islands. How this is now
> > > > > implemented in the current patch set is half-way there but not yet what
> > > > > it should be.
> > > > 
> > > > Well conceptually, SGX virtualization and SGX driver are two independently
> > > > functionalities can be enabled separately, although they both requires some
> > > > come functionalities, such as /dev/sgx_provision, which we have moved to
> > > > sgx/main.c exactly for this purpose. THerefore, conceptually, it is bad to make
> > > > assumption that, if SGX virtualization initialization succeeded, SGX driver
> > > > must succeed -- we can potentially add more staff in SGX virtualization in the
> > > > future..
> > > > 
> > > > If the name sgx_vepc_init() confuses you, I can rename it to sgx_virt_init().
> > > 
> > > I don't understand what would be the bad thing here. Can you open that
> > > up please? I'm neither capable of predicting the future...
> 
> Conceptually they are two different functionalities, and doesn't depend on each
> other. Why calling SGX driver initialization only when SGX virtualization
> succeeded?
> 
> We might want to add reclaiming EPC page (VMM EPC oversubscription) from KVM
> guest in the future, which may bring more initialization staff sgx_vepc_init(),
> and those new staff should not impact SGX driver.
> 
> I don't see your approach is any better, both from concept and flexibility.
> 
> Like I said, we can rename to sgx_virt_init() to be more generic, but I
> strongly disagree your approach.
> 
> > 
> > Right, so since vepc_init() does only just device file initialization the
> > current function structure is fine. I totally forgot that sgx_drv_init()
> > does not call EPC initialization when I wrote the above :-) We refactored
> > during the inital cycle the driver so many times that I sometimes fix up
> > thing, sorry about.
> > 
> > To meld this into code:
> > 
> >         ret = sgx_vepc_init();
> >         if (ret != -ENODEV) {
> >                 pr_err("vEPC initialization failed with %d.\n", ret);
> >                 return ret;
> >         }
> > 
> >         ret = sgx_drv_init();
> >         if (ret != ENODEV)
> >                 pr_info("Driver initialization failed %d.\n", ret);
> 
> Hmm.. Let's say an extreme case: misc_register() failed in sgx_vepc_init(), due
> to -ENOMEM. Then OOM kill gets involved, and kills bunch of apps. And then In
> this case, theoretically, misc_register() in sgx_drv_init() doesn't need to
> fail.
> 
> The point is really SGX driver and SGX virt are two independent
> functionalities, so don't make dependency on them, manually. Plus I don't see
> any benefit of your approach, but only cons.

The way I've understood it is that given that KVM can support SGX
without FLC, vEPC should be available even if driver cannot be
enabled.

This is also exactly what the short summary states.

"Initialize virtual EPC driver even when SGX driver is disabled"

It *does not* state:

"Initialize SGX driver even when vEPC driver is disabled"

Also, this is how I interpret the inline comment.

All this considered, the other direction is undocumented functionality.


/Jarkko
