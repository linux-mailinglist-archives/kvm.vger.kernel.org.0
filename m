Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070AC19CC6D
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 23:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388008AbgDBVe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 17:34:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40282 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgDBVe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 17:34:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z/v5upNKru7bgi4nvat+ytQ1c/d+NkT4gU2UVKRc/vY=; b=um20OvcihtVx4yBKVMrOdHa59L
        96zIBZs/1pCAbWieVVwYaLn5xqcIYdXBTn6qTViMYIt1URQFVq4NRAorjGH4N0pJznHjFRqOqXfXW
        KzEWGn1X4EECBFQqWMvcXqKZBz7mUce9GfnEpoz4kMSnJehyFOhp0x0IgnWiPb8L5tcDVztxi2ci3
        RF5ji0Y699jkL7e9akuNoZQNTJUyzrRKg9mydRB3DuJ/Cx+yP2FTNucb1XyAfQWAjby4LqcdWgSMZ
        ULTXt4OwcIUVS1u69pBvKXHmEvlOSq3OhCZgAnFViENmhOUm7MInHFJdyyCR7KJKxb2D+W7mLQwi3
        8aPIZ/MA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jK7Tt-0003oa-T1; Thu, 02 Apr 2020 21:34:34 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 838709834EB; Thu,  2 Apr 2020 23:34:31 +0200 (CEST)
Date:   Thu, 2 Apr 2020 23:34:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Paul McKenney <paulmck@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RESEND][patch V3 06/23] bug: Annotate WARN/BUG/stackfail as
 noinstr safe
Message-ID: <20200402213431.GK2452@worktop.programming.kicks-ass.net>
References: <20200320175956.033706968@linutronix.de>
 <20200320180032.994128577@linutronix.de>
 <20200402210115.zpk52dyc6ofg2bve@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402210115.zpk52dyc6ofg2bve@treble>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 02, 2020 at 04:01:15PM -0500, Josh Poimboeuf wrote:
> On Fri, Mar 20, 2020 at 07:00:02PM +0100, Thomas Gleixner wrote:
> > Warnings, bugs and stack protection fails from noinstr sections, e.g. low
> > level and early entry code, are likely to be fatal.
> > 
> > Mark them as "safe" to be invoked from noinstr protected code to avoid
> > annotating all usage sites. Getting the information out is important.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  arch/x86/include/asm/bug.h |    3 +++
> >  include/asm-generic/bug.h  |    9 +++++++--
> >  kernel/panic.c             |    4 +++-
> >  3 files changed, 13 insertions(+), 3 deletions(-)
> > 
> > --- a/arch/x86/include/asm/bug.h
> > +++ b/arch/x86/include/asm/bug.h
> > @@ -70,13 +70,16 @@ do {									\
> >  #define HAVE_ARCH_BUG
> >  #define BUG()							\
> >  do {								\
> > +	instr_begin();						\
> >  	_BUG_FLAGS(ASM_UD2, 0);					\
> >  	unreachable();						\
> >  } while (0)
> 
> For visual symmetry at least, it seems like this wants an instr_end()
> before the unreachable().  Does objtool not like that?

Can't remember, but I think it's weird to put something after you know
it unreachable.
