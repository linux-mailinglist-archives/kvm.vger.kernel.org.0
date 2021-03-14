Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC7333A571
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 16:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhCNP2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 11:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbhCNP1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 11:27:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6533864E2E;
        Sun, 14 Mar 2021 15:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615735662;
        bh=86p6wprSOmz/IkwsRK20FPCNs/7/aHOVgPDG3uBcjx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dF+RyOTm22aLF0U1BiTVykTWgHdQITphAsIVCc0q7R+8uv0LtakjblP035Vk17e5u
         jgE5Hpw6sXFavRWps0MwGhwAObixlnVqMbztPq6ErbVo5eGn4xWNnMANGrWmV/BHY1
         MmDm5btRis3tD/r4VDIUbemNUh0TQCM+88PPSqlfAsuNTnD+g1DDPXSSB8nKIBXklC
         ur5n9SV8paG5hqfrf1blgFMq1dopszffOOPeurwCcZ0uAAVW2bS/8G3guQXtmP5e2x
         hMzIxqUtyhL/NnEsqx5WesR2KgxVixegKnTDeCtJJ4+cY/AwdkLZURDaQGCetE4x1/
         JyBjvCk9PD6Ig==
Date:   Sun, 14 Mar 2021 17:27:18 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v2 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YE4rVnfQ9y7CnVvr@kernel.org>
References: <cover.1615250634.git.kai.huang@intel.com>
 <d2ebcffeb9193d26a1305e08fe1aa1347feb1c62.1615250634.git.kai.huang@intel.com>
 <YEvg2vNfiDYoc9u3@google.com>
 <YE0M/VoETPw7YZIy@kernel.org>
 <YE0NeChRjBlldQ8H@kernel.org>
 <YE4M8JGGl9Xyx51/@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE4M8JGGl9Xyx51/@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 14, 2021 at 05:25:26PM +0200, Jarkko Sakkinen wrote:
> On Sat, Mar 13, 2021 at 09:07:36PM +0200, Jarkko Sakkinen wrote:
> > On Sat, Mar 13, 2021 at 09:05:36PM +0200, Jarkko Sakkinen wrote:
> > > On Fri, Mar 12, 2021 at 01:44:58PM -0800, Sean Christopherson wrote:
> > > > On Tue, Mar 09, 2021, Kai Huang wrote:
> > > > > Modify sgx_init() to always try to initialize the virtual EPC driver,
> > > > > even if the SGX driver is disabled.  The SGX driver might be disabled
> > > > > if SGX Launch Control is in locked mode, or not supported in the
> > > > > hardware at all.  This allows (non-Linux) guests that support non-LC
> > > > > configurations to use SGX.
> > > > > 
> > > > > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > ---
> > > > >  arch/x86/kernel/cpu/sgx/main.c | 10 +++++++++-
> > > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > > > > index 44fe91a5bfb3..8c922e68274d 100644
> > > > > --- a/arch/x86/kernel/cpu/sgx/main.c
> > > > > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > > > > @@ -712,7 +712,15 @@ static int __init sgx_init(void)
> > > > >  		goto err_page_cache;
> > > > >  	}
> > > > >  
> > > > > -	ret = sgx_drv_init();
> > > > > +	/*
> > > > > +	 * Always try to initialize the native *and* KVM drivers.
> > > > > +	 * The KVM driver is less picky than the native one and
> > > > > +	 * can function if the native one is not supported on the
> > > > > +	 * current system or fails to initialize.
> > > > > +	 *
> > > > > +	 * Error out only if both fail to initialize.
> > > > > +	 */
> > > > > +	ret = !!sgx_drv_init() & !!sgx_vepc_init();
> > > > 
> > > > I love this code.
> > > > 
> > > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > > 
> > > I'm still wondering why this code let's go through when sgx_drv_init()
> > > succeeds and sgx_vepc_init() fails.
> > > 
> > > The inline comment explains only the mirrored case (which does make
> > > sense).
> > 
> > I.e. if sgx_drv_init() succeeds, I'd expect that sgx_vepc_init() must
> > succeed. Why expect legitly anything else?
>  
> Apologies coming with these ideas at this point, but here is what this
> led me.
> 
> I think that the all this complexity comes from a bad code structure.
> 
> So, what is essentially happening here:
> 
> - We essentially want to make EPC always work.
> - Driver optionally.
> 
> So what this sums to is something like:
> 
>         ret = sgx_epc_init();
>         if (ret) {
>                 pr_err("EPC initialization failed.\n");
>                 return ret;
>         }
> 
>         ret = sgx_drv_init();
>         if (ret)
>                 pr_info("Driver could not be initialized.\n");
> 
>         /* continue */
> 
> I.e. I think there should be a single EPC init, which does both EPC
> bootstrapping and vepc, and driver initialization comes after that.

In other words, from SGX point of view, the thing that KVM needs is
to cut out EPC and driver part into different islands. How this is now
implemented in the current patch set is half-way there but not yet what
it should be.

/Jarkko
