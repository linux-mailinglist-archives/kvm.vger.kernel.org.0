Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBE23896CD
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 21:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhESTfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 15:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhESTfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 15:35:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A72BC06175F;
        Wed, 19 May 2021 12:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Wm6Fg6hPEXzb07sPLpGnEeLDWpfOMrauzZEfAlcYzmM=; b=YmoOqAur2JknC74gPCU8jGvugp
        P88XBQSr2WV4USjdKsyTqVsgFLp9ogTq6CoyV9QmGmhOkRFRSH3OhA1Gk3od5PQ/k6IZ1Hg8LP6hE
        7e9XrO7uoMSxt3qWDgWa1kpNE2v+ksyiq1GD6PBLx9gLjWBri/dtPcGYBapdd8F0t/oqD88Wp1rHF
        cPWt5ZzNKurWzPdQrIaF5JmBLwEA7+dixraZw4EC7r3xNq4XFkH6CWVLR720EWcYK3U2dv/vKO7pB
        4WRNJMV+rsawx3qRiA4q1YRO4uIgJStawTWIEsweO9LksGnPfrFH3CyY3ftNEmem07is3KL5U/TSt
        F0CD3LEg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljRvD-00FFAb-4q; Wed, 19 May 2021 19:32:15 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4F1D1986465; Wed, 19 May 2021 21:31:58 +0200 (CEST)
Date:   Wed, 19 May 2021 21:31:58 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Hyunwook Baek <baekhw@google.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 5/8] x86/sev-es: Leave NMI-mode before sending signals
Message-ID: <20210519193158.GJ21560@worktop.programming.kicks-ass.net>
References: <20210519135251.30093-1-joro@8bytes.org>
 <20210519135251.30093-6-joro@8bytes.org>
 <20210519175450.GF21560@worktop.programming.kicks-ass.net>
 <YKVjRJmva/Y2EHPZ@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKVjRJmva/Y2EHPZ@suse.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 09:13:08PM +0200, Joerg Roedel wrote:
> Hi Peter,
> 
> thanks for your review.
> 
> On Wed, May 19, 2021 at 07:54:50PM +0200, Peter Zijlstra wrote:
> > On Wed, May 19, 2021 at 03:52:48PM +0200, Joerg Roedel wrote:
> > > --- a/arch/x86/kernel/sev.c
> > > +++ b/arch/x86/kernel/sev.c
> > > @@ -1343,9 +1343,10 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
> > >  		return;
> > >  	}
> > >  
> > > +	instrumentation_begin();
> > > +
> > >  	irq_state = irqentry_nmi_enter(regs);
> > >  	lockdep_assert_irqs_disabled();
> > > -	instrumentation_begin();
> > >  
> > >  	/*
> > >  	 * This is invoked through an interrupt gate, so IRQs are disabled. The
> > 
> > That's just plain wrong. No instrumentation is allowed before you enter
> > the exception context.
> 
> Okay.
> 
> > > +	irqentry_nmi_exit(regs, irq_state);
> > > +
> > 
> > And this is wrong too; because at this point the handler doesn't run in
> > _any_ context anymore, certainly not one you can call regular C code
> > from.
> 
> The #VC handler is at this point not running on the IST stack anymore,
> but on the stack it came from or on the task stack. So my believe was
> that at this point it inherits the context it came from (just like the
> page-fault handler). But I also don't fully understand the context
> tracking, so is my assumption wrong?

Being on the right stack is only part of the issue; you also need to
make sure your runtime environment is set up.

Regular kernel C expects a whole lot of things to be present; esp. so
with all the debug options on. The irqentry_*_enter() family of
functions very carefully sets up this environment and the
irqentry_*_exit() undoes it again. Before and after you really cannot
run normal code.

Just an example, RCU might not be watching, it might think the CPU is in
userspace and advance the GP while you're relying on it not doing so.

Similarly lockdep is in some undefined state and any lock used can
trigger random 'funny' things.

Just because this is 'C', doesn't immediately mean you can go call any
random function. Up until recently most of this was in ASM. There's a
reason for the noinstr annotations.
