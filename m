Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3753242A63
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 15:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgHLNcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 09:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbgHLNcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 09:32:20 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363F2C06174A;
        Wed, 12 Aug 2020 06:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/1yLg7wLxOieDTHuV1+QBNxA0Zsi0S/5XXV3uZhAujE=; b=vW3XuBHqyaPnhcVdiv1s45fxSR
        B+4bL34CxRPANM/uvlEJDJsv5+UWQ6QREqWWrhFINjvVSx8ZhEM/Ug5d+diB28ApUJsplefzFQizU
        78G9GWuRcggLewM71Qn1IDbAlRZc9VXSU/ROAw3JFaO0oMzDEWGjuRmCwnSkJCYdPPu12vKrMD+Iw
        9wQ6+jc6H1uz5a7kyCWbZawzxVyL4+pmXh6jPOXVDiUkS/Zl6b2a9tZ7EqHcXDAVxi8yAs3DjMHeB
        48FzkYG9XWl018sLJU7ltfauo3IFHURiCU7jzzFDUBuSfQBAlCpfpgLuhkWiDfcC7qExvTFy/JaGS
        eV9dtNZQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5qrC-0004VV-TW; Wed, 12 Aug 2020 13:31:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9D6B43060C5;
        Wed, 12 Aug 2020 15:31:50 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 54DB42B76E7EB; Wed, 12 Aug 2020 15:31:50 +0200 (CEST)
Date:   Wed, 12 Aug 2020 15:31:50 +0200
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
Message-ID: <20200812133150.GQ2674@hirez.programming.kicks-ass.net>
References: <20200812050722.25824-1-like.xu@linux.intel.com>
 <5c41978e-8341-a179-b724-9aa6e7e8a073@redhat.com>
 <20200812111115.GO2674@hirez.programming.kicks-ass.net>
 <65eddd3c-c901-1c5a-681f-f0cb07b5fbb1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65eddd3c-c901-1c5a-681f-f0cb07b5fbb1@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 12, 2020 at 01:32:58PM +0200, Paolo Bonzini wrote:
> On 12/08/20 13:11, peterz@infradead.org wrote:
> > Right, but we want to tighten the permission checks and not excluding_hv
> > is just sloppy.
> 
> I would just document that it's ignored as it doesn't make sense.  ARM64
> does that too, for new processors where the kernel is not itself split
> between supervisor and hypervisor privilege levels.

This isn't about x86, I want these checks in generic code. We have the
flag, it needs checking.

unpriv users have no busniess getting anything from a possible hv.

> > The thing is, we very much do not want to allow unpriv user to be able
> > to create: exclude_host=1, exclude_guest=0 counters (they currently
> > can).
> 
> That would be the case of an unprivileged user that wants to measure
> performance of its guests.  It's a scenario that makes a lot of sense,
> are you worried about side channels?  Can perf-events on guests leak
> more about the host than perf-events on a random userspace program?

An unpriv user can run guests?

> > Also, exclude_host is really poorly defined:
> > 
> >   https://lkml.kernel.org/r/20200806091827.GY2674@hirez.programming.kicks-ass.net
> > 
> >   "Suppose we have nested virt:
> > 
> > 	  L0-hv
> > 	  |
> > 	  G0/L1-hv
> > 	     |
> > 	     G1
> > 
> >   And we're running in G0, then:
> > 
> >   - 'exclude_hv' would exclude L0 events
> >   - 'exclude_host' would ... exclude L1-hv events?
> >   - 'exclude_guest' would ... exclude G1 events?
> 
> From the point of view of G0, L0 *does not exist at all*.  You just
> cannot see L0 events if you're running in G0.

On x86, probably, in general, I'm not at all sure, we have that
exclude_hv flag after all.

> exclude_host/exclude_guest are the right definition.

For what? I still think exclude_host is absolute shit. If you set it,
you'll not get anything even without virt.

Run a native linux kernel, no kvm loaded, create a counter with
exclude_host=1 and you'll get nothing, that's just really confusing IMO.
There is no host, so excluding it should not affect anything.

> >   Then the next question is, if G0 is a host, does the L1-hv run in
> >   G0 userspace or G0 kernel space?
> 
> It's mostly kernel, but sometimes you're interested in events from QEMU
> or whoever else has opened /dev/kvm.  In that case you care about G0
> userspace too.

I really don't think userspace helpers should be consideed part of
the host, but whatever.

> > The way it is implemented, you basically have to always set
> > exclude_host=0, even if there is no virt at all and you want to measure
> > your own userspace thing -- which is just weird.
> 
> I understand regretting having exclude_guest that way; include_guest
> (defaulting to 0!) would have made more sense.  But defaulting to
> exclude_host==0 makes sense: if there is no virt at all, memset(0) does
> the right thing so it does not seem weird to me.

Sure, but having exclude_host affect anything outside of kvm is still
dodgy as heck.

> > I suppose the 'best' option at this point is something like:
> > 
> > 	/*
> > 	 * comment that explains the trainwreck.
> > 	 */
> > 	if (!exclude_host && !exclude_guest)
> > 		exclude_guest = 1;
> > 
> > 	if ((!exclude_hv || !exclude_guest) && !perf_allow_kernel())
> > 		return -EPERM;
> > 
> > But that takes away the possibility of actually having:
> > 'exclude_host=0, exclude_guest=0' to create an event that measures both,
> > which also sucks.
> 
> In fact both of the above "if"s suck. :(

If, as you seem to imply above, that unpriv users can create guests,
then maybe so, but if I look at /dev/kvm it seems to have 0660
permissions and thus really requires privileges.

