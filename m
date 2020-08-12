Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FF224288C
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 13:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHLLLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 07:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgHLLLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 07:11:40 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C49AC06174A;
        Wed, 12 Aug 2020 04:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jcPmC2auRogJHARE11xzaLxlaqUeMqrTs0Ff/bKTCYU=; b=CKfZz6o/zKU4NKPxoiaP8Z76h4
        +UT2BdHDqbQ9r9gOraHPMhkJbtWQgR/rVC/Yh6lAGDQyGsJflsAM2wVbj6YvDmCUm7vZfGjB1Q0v7
        KyR4iBsuCoL7qwco7sMr2WD8OmkeGsPwBtaDwRY/stXiGkOCBNfaMZyP73ovyEJs5kB9ZGi1ZQtrD
        enq7qf2VaSyrfaQTBvyTu/NEe2RSsZQyIdkQaUqiaB2rKdGtRlFHR2JzNeUgEOZD4+wFYf8PSNjDl
        4/vlbVDa1uSaU9uDy7ezoEejstQoMILIqVxD7JraUZQpqM1WnU+5KmP6gJYG/YDusAJODgeOgiiK0
        xgH6JKhA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5of8-0001mS-MD; Wed, 12 Aug 2020 11:11:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 324A8300DAE;
        Wed, 12 Aug 2020 13:11:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1A85E25D0D543; Wed, 12 Aug 2020 13:11:15 +0200 (CEST)
Date:   Wed, 12 Aug 2020 13:11:15 +0200
From:   peterz@infradead.org
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu@linux.intel.com>, Yao <yao.jin@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] KVM: x86/pmu: Add '.exclude_hv = 1' for guest perf_event
Message-ID: <20200812111115.GO2674@hirez.programming.kicks-ass.net>
References: <20200812050722.25824-1-like.xu@linux.intel.com>
 <5c41978e-8341-a179-b724-9aa6e7e8a073@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c41978e-8341-a179-b724-9aa6e7e8a073@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 12:25:43PM +0200, Paolo Bonzini wrote:
> On 12/08/20 07:07, Like Xu wrote:
> > To emulate PMC counter for guest, KVM would create an
> > event on the host with 'exclude_guest=0, exclude_hv=0'
> > which simply makes no sense and is utterly broken.
> > 
> > To keep perf semantics consistent, any event created by
> > pmc_reprogram_counter() should both set exclude_hv and
> > exclude_host in the KVM context.
> > 
> > Message-ID: <20200811084548.GW3982@worktop.programming.kicks-ass.net>
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > ---
> >  arch/x86/kvm/pmu.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 67741d2a0308..6a30763a10d7 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -108,6 +108,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> >  		.exclude_host = 1,
> >  		.exclude_user = exclude_user,
> >  		.exclude_kernel = exclude_kernel,
> > +		.exclude_hv = 1,
> >  		.config = config,
> >  	};
> >  
> > 
> 
> x86 does not have a hypervisor privilege level, so it never uses

Arguably it does when Xen, but I don't think we support that, so *phew*.

> exclude_hv; exclude_host already excludes all root mode activity for
> both ring0 and ring3.

Right, but we want to tighten the permission checks and not excluding_hv
is just sloppy.

That said; the exclude_host / exclude_guest thing is a giant trainwreck
and I'm really not sure what to do about it.

The thing is, we very much do not want to allow unpriv user to be able
to create: exclude_host=1, exclude_guest=0 counters (they currently
can).

So we really want to add:

	if ((!exclude_host || !exclude_guest || !exclude_hv) && !perf_allow_kernel())
		return -EACCESS;

But the problem is, they were added late, so lots of userspace will not
be setting those fields (or might not have even known about them), so we
got to somehow deal with:

	exclude_host == exclude_guest == 0

And because of that, we now also have genius code like
(intel_set_masks, amd_core_hw_config has even 'funnier' code):

	if (event->attr.exclude_host)
		__set_bit(idx, (unsigned long *)&cpuc->intel_ctrl_guest_mask);
	if (event->attr.exclude_guest)
		__set_bit(idx, (unsigned long *)&cpuc->intel_ctrl_host_mask);

Which is just confusing and bad, that really should've been:

	if (!event->attr.exclude_host)
		__set_bit(idx, (unsigned long *)&cpuc->intel_ctrl_host_mask);
	if (!event->attr.exclude_guest)
		__set_bit(idx, (unsigned long *)&cpuc->intel_ctrl_guest_mask);

:-(

Also, exclude_host is really poorly defined:

  https://lkml.kernel.org/r/20200806091827.GY2674@hirez.programming.kicks-ass.net

  "Suppose we have nested virt:

	  L0-hv
	  |
	  G0/L1-hv
	     |
	     G1

  And we're running in G0, then:

  - 'exclude_hv' would exclude L0 events
  - 'exclude_host' would ... exclude L1-hv events?
  - 'exclude_guest' would ... exclude G1 events?

  Then the next question is, if G0 is a host, does the L1-hv run in
  G0 userspace or G0 kernel space?

  I was assuming G0 userspace would not include anything L1 (kvm is a
  kernel module after all), but what do I know."

The way it is implemented, you basically have to always set
exclude_host=0, even if there is no virt at all and you want to measure
your own userspace thing -- which is just weird.

Meanwhile ARM64 couldn't quite figure out what it was all supposed to be
either and also implemented something -- and i've not tried to
understand what exactly, but hopefully compatible enough that we're not
in an even worse corner.



So on the one hand we're now leaking all sorts due to lack of permission
checks, on the other hand we can't fix it because we're not allowed to
break userspace :-(


I suppose the 'best' option at this point is something like:

	/*
	 * comment that explains the trainwreck.
	 */
	if (!exclude_host && !exclude_guest)
		exclude_guest = 1;

	if ((!exclude_hv || !exclude_guest) && !perf_allow_kernel())
		return -EPERM;

But that takes away the possibility of actually having:
'exclude_host=0, exclude_guest=0' to create an event that measures both,
which also sucks.


