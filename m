Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B68A33D424
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 13:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCPMo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 08:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232727AbhCPMod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 08:44:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AE2F65030;
        Tue, 16 Mar 2021 12:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615898672;
        bh=ORWKZXWbNUM9sFY2lofokOp2u+5tWB8wjn7PWneWHJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mocLmS19MSGeCEPfNqKsx8j43/g3z098NaedMinvErQcpFPpPoJIoAgN9xBaW350a
         4KOrkRtA3SIgIwTDSMy3nQKAR1vnhS1IBdiQk8qEDU0KKtpAkyAhfqHi9mipFciXE7
         +mDTJq982zuhaqX++xrkWeY9lFpvCKFn7j1hqOJu/8tCvSRmBDexs/U7FpDdmk656e
         tBohEaIYe60sNBJ/OyUHXqAFoDH7XtH/1GLRkrp0eUYqFpLNrjctg9rOvDMZZ7ozEO
         7evJQYBv9njNV4NOKvoB22mSxn6xs6O3WLgE0qjKeSYveOgjdI/kE8tTwyuTzFsg2w
         UIde7Z0lx87NQ==
Date:   Tue, 16 Mar 2021 14:44:07 +0200
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
Message-ID: <YFCoF7m0bp+BMUXd@kernel.org>
References: <YE0NeChRjBlldQ8H@kernel.org>
 <YE4M8JGGl9Xyx51/@kernel.org>
 <YE4rVnfQ9y7CnVvr@kernel.org>
 <20210315161317.9c72479dfcde4e22078abcd2@intel.com>
 <YE9beKYDaG1sMWq+@kernel.org>
 <YE9mVUF0KOPNSfA9@kernel.org>
 <20210316094859.7b5947b743a81dff7434615c@intel.com>
 <YE/oHt92suFDHJ7Z@kernel.org>
 <YE/o/IGBAB8N+fnt@kernel.org>
 <20210316124933.3921b390ae153af598b145df@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316124933.3921b390ae153af598b145df@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 12:49:33PM +1300, Kai Huang wrote:
> On Tue, 16 Mar 2021 01:08:44 +0200 Jarkko Sakkinen wrote:
> > On Tue, Mar 16, 2021 at 01:05:05AM +0200, Jarkko Sakkinen wrote:
> > > On Tue, Mar 16, 2021 at 09:48:59AM +1300, Kai Huang wrote:
> > > > On Mon, 15 Mar 2021 15:51:17 +0200 Jarkko Sakkinen wrote:
> > > > > On Mon, Mar 15, 2021 at 03:04:59PM +0200, Jarkko Sakkinen wrote:
> > > > > > On Mon, Mar 15, 2021 at 04:13:17PM +1300, Kai Huang wrote:
> > > > > > > On Sun, 14 Mar 2021 17:27:18 +0200 Jarkko Sakkinen wrote:
> > > > > > > > On Sun, Mar 14, 2021 at 05:25:26PM +0200, Jarkko Sakkinen wrote:
> > > > > > > > > On Sat, Mar 13, 2021 at 09:07:36PM +0200, Jarkko Sakkinen wrote:
> > > > > > > > > > On Sat, Mar 13, 2021 at 09:05:36PM +0200, Jarkko Sakkinen wrote:
> > > > > > > > > > > On Fri, Mar 12, 2021 at 01:44:58PM -0800, Sean Christopherson wrote:
> > > > > > > > > > > > On Tue, Mar 09, 2021, Kai Huang wrote:
> > > > > > > > > > > > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > > > > > > > > > > > even if the SGX driver is disabled.  The SGX driver might be disabled
> > > > > > > > > > > > > if SGX Launch Control is in locked mode, or not supported in the
> > > > > > > > > > > > > hardware at all.  This allows (non-Linux) guests that support non-LC
> > > > > > > > > > > > > configurations to use SGX.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > > > > > > > > > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > > > > > > > > > ---
> > > > > > > > > > > > >  arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
> > > > > > > > > > > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > > > > > > > > > > > 
> > > > > > > > > > > > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > > > > > > > > > > > index 44fe91a5bfb3..8c922e68274d 100644
> > > > > > > > > > > > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > > > > > > > > > > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > > > > > > > > > > > @@ -712,7 +712,15 @@ static int __init sgx_init(void)
> > > > > > > > > > > > >  		goto err_page_cache;
> > > > > > > > > > > > >  	}
> > > > > > > > > > > > >  
> > > > > > > > > > > > > -	ret = sgx_drv_init();
> > > > > > > > > > > > > +	/*
> > > > > > > > > > > > > +	 * Always try to initialize the native *and* KVM drivers.
> > > > > > > > > > > > > +	 * The KVM driver is less picky than the native one and
> > > > > > > > > > > > > +	 * can function if the native one is not supported on the
> > > > > > > > > > > > > +	 * current system or fails to initialize.
> > > > > > > > > > > > > +	 *
> > > > > > > > > > > > > +	 * Error out only if both fail to initialize.
> > > > > > > > > > > > > +	 */
> > > > > > > > > > > > > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > > > > > > > > > > > 
> > > > > > > > > > > > I love this code.
> > > > > > > > > > > > 
> > > > > > > > > > > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > > > > > > > > > > 
> > > > > > > > > > > I'm still wondering why this code let's go through when sgx_drv_init()
> > > > > > > > > > > succeeds and sgx_vepc_init() fails.
> > > > > > > > > > > 
> > > > > > > > > > > The inline comment explains only the mirrored case (which does make
> > > > > > > > > > > sense).
> > > > > > > > > > 
> > > > > > > > > > I.e. if sgx_drv_init() succeeds, I'd expect that sgx_vepc_init() must
> > > > > > > > > > succeed. Why expect legitly anything else?
> > > > > > > > >  
> > > > > > > > > Apologies coming with these ideas at this point, but here is what this
> > > > > > > > > led me.
> > > > > > > > > 
> > > > > > > > > I think that the all this complexity comes from a bad code structure.
> > > > > > > > > 
> > > > > > > > > So, what is essentially happening here:
> > > > > > > > > 
> > > > > > > > > - We essentially want to make EPC always work.
> > > > > > > > > - Driver optionally.
> > > > > > > > > 
> > > > > > > > > So what this sums to is something like:
> > > > > > > > > 
> > > > > > > > >         ret = sgx_epc_init();
> > > > > > > > >         if (ret) {
> > > > > > > > >                 pr_err("EPC initialization failed.\n");
> > > > > > > > >                 return ret;
> > > > > > > > >         }
> > > > > > > > > 
> > > > > > > > >         ret = sgx_drv_init();
> > > > > > > > >         if (ret)
> > > > > > > > >                 pr_info("Driver could not be initialized.\n");
> > > > > > > > > 
> > > > > > > > >         /* continue */
> > > > > > > > > 
> > > > > > > > > I.e. I think there should be a single EPC init, which does both EPC
> > > > > > > > > bootstrapping and vepc, and driver initialization comes after that.
> > > > > > > > 
> > > > > > > > In other words, from SGX point of view, the thing that KVM needs is
> > > > > > > > to cut out EPC and driver part into different islands. How this is now
> > > > > > > > implemented in the current patch set is half-way there but not yet what
> > > > > > > > it should be.
> > > > > > > 
> > > > > > > Well conceptually, SGX virtualization and SGX driver are two independently
> > > > > > > functionalities can be enabled separately, although they both requires some
> > > > > > > come functionalities, such as /dev/sgx_provision, which we have moved to
> > > > > > > sgx/main.c exactly for this purpose. THerefore, conceptually, it is bad to make
> > > > > > > assumption that, if SGX virtualization initialization succeeded, SGX driver
> > > > > > > must succeed -- we can potentially add more staff in SGX virtualization in the
> > > > > > > future..
> > > > > > > 
> > > > > > > If the name sgx_vepc_init() confuses you, I can rename it to sgx_virt_init().
> > > > > > 
> > > > > > I don't understand what would be the bad thing here. Can you open that
> > > > > > up please? I'm neither capable of predicting the future...
> > > > 
> > > > Conceptually they are two different functionalities, and doesn't depend on each
> > > > other. Why calling SGX driver initialization only when SGX virtualization
> > > > succeeded?
> > > > 
> > > > We might want to add reclaiming EPC page (VMM EPC oversubscription) from KVM
> > > > guest in the future, which may bring more initialization staff sgx_vepc_init(),
> > > > and those new staff should not impact SGX driver.
> > > > 
> > > > I don't see your approach is any better, both from concept and flexibility.
> > > > 
> > > > Like I said, we can rename to sgx_virt_init() to be more generic, but I
> > > > strongly disagree your approach.
> > > > 
> > > > > 
> > > > > Right, so since vepc_init() does only just device file initialization the
> > > > > current function structure is fine. I totally forgot that sgx_drv_init()
> > > > > does not call EPC initialization when I wrote the above :-) We refactored
> > > > > during the inital cycle the driver so many times that I sometimes fix up
> > > > > thing, sorry about.
> > > > > 
> > > > > To meld this into code:
> > > > > 
> > > > >         ret = sgx_vepc_init();
> > > > >         if (ret != -ENODEV) {
> > > > >                 pr_err("vEPC initialization failed with %d.\n", ret);
> > > > >                 return ret;
> > > > >         }
> > > > > 
> > > > >         ret = sgx_drv_init();
> > > > >         if (ret != ENODEV)
> > > > >                 pr_info("Driver initialization failed %d.\n", ret);
> > > > 
> > > > Hmm.. Let's say an extreme case: misc_register() failed in sgx_vepc_init(), due
> > > > to -ENOMEM. Then OOM kill gets involved, and kills bunch of apps. And then In
> > > > this case, theoretically, misc_register() in sgx_drv_init() doesn't need to
> > > > fail.
> > > > 
> > > > The point is really SGX driver and SGX virt are two independent
> > > > functionalities, so don't make dependency on them, manually. Plus I don't see
> > > > any benefit of your approach, but only cons.
> > > 
> > > The way I've understood it is that given that KVM can support SGX
> > > without FLC, vEPC should be available even if driver cannot be
> > > enabled.
> > > 
> > > This is also exactly what the short summary states.
> > > 
> > > "Initialize virtual EPC driver even when SGX driver is disabled"
> > > 
> > > It *does not* state:
> > > 
> > > "Initialize SGX driver even when vEPC driver is disabled"
> 
> OK. The patch title can be improved. How about:
> 
> "Initialize SGX driver and virtual EPC driver independently"
> 
> ?
> 
> > > 
> > > Also, this is how I interpret the inline comment.
> > > 
> > > All this considered, the other direction is undocumented functionality.
> 
> OK. How about below?
> 
> /*
>  * Always try to initialize the native *and* KVM drivers. They are independent
>  * functionalities and one can be initialized even when the other is not
>  * supported or fails to initialize.
>  */
> 
> The explicit saying of "not supported or fails to initialize" was requested by
> you -- you wanted to distinguish -ENODEV with other error codes.
> 
> > 
> > Also:
> > 
> > 1. There is *zero* good practical reasons to support the "2nd direction".
> >    For KVM getting init'd with SGX, on the other hand, we have good
> >    practical reasons.
> 
> Why there's *zero* good practical reasons? With initializing them
> independently, people don't need to worry about *internal* of
> sgx_vepc_init() and sgx_drv_init(), but just need pay attention of the logic
> that they are two independent functionalities. Being able to initialize them
> independently is much more clear and easier to understand. And like I said, in
> this way it is more flexible to extend -- for instance, we may add more staff
> to support VMM EPC oversubscription. So why there is *zero* good practical
> reasons?

Then things would be reconsidered.

> 
> Btw, there are customers that want to just use KVM SGX, but not SGX driver in
> host, for which people may want to add separate CONFIG option, say,
> CONFIG_X86_SGX_DRIVER, to be able to disable/enable SGX driver code, just like
> CONFIG_X86_SGX_KVM. Make them independent logically  just make things more
> clear.

Why?

> 
> > 2. We can get something practically useful with simpler and more verbose
> >    code, i.e. better logging.
> 
> I can add error msg in sgx_vepc_init() upon misc_register() if you want.
> 
> > 
> > /Jarkko
> 

/Jarkko
