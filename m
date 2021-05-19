Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55B1389655
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 21:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhESTOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 15:14:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:47110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhESTOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 15:14:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 88F15AFAB;
        Wed, 19 May 2021 19:13:10 +0000 (UTC)
Date:   Wed, 19 May 2021 21:13:08 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <YKVjRJmva/Y2EHPZ@suse.de>
References: <20210519135251.30093-1-joro@8bytes.org>
 <20210519135251.30093-6-joro@8bytes.org>
 <20210519175450.GF21560@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519175450.GF21560@worktop.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

thanks for your review.

On Wed, May 19, 2021 at 07:54:50PM +0200, Peter Zijlstra wrote:
> On Wed, May 19, 2021 at 03:52:48PM +0200, Joerg Roedel wrote:
> > --- a/arch/x86/kernel/sev.c
> > +++ b/arch/x86/kernel/sev.c
> > @@ -1343,9 +1343,10 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
> >  		return;
> >  	}
> >  
> > +	instrumentation_begin();
> > +
> >  	irq_state = irqentry_nmi_enter(regs);
> >  	lockdep_assert_irqs_disabled();
> > -	instrumentation_begin();
> >  
> >  	/*
> >  	 * This is invoked through an interrupt gate, so IRQs are disabled. The
> 
> That's just plain wrong. No instrumentation is allowed before you enter
> the exception context.

Okay.

> > +	irqentry_nmi_exit(regs, irq_state);
> > +
> 
> And this is wrong too; because at this point the handler doesn't run in
> _any_ context anymore, certainly not one you can call regular C code
> from.

The #VC handler is at this point not running on the IST stack anymore,
but on the stack it came from or on the task stack. So my believe was
that at this point it inherits the context it came from (just like the
page-fault handler). But I also don't fully understand the context
tracking, so is my assumption wrong?

Regards,

	Joerg

