Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6F2158E9C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 13:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgBKMid (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 07:38:33 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:39090 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727954AbgBKMid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 07:38:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oxjM1lyVFBW4RHs88S9RTOZ+n3z0Ab4hzDGdR1eROMQ=; b=D+a4ql07h54FNTVT1ClJXeYcqM
        AeSYdLBj7pnrKZnyq7t99w3O1iAJDCvg5xS+DE1ouN/gF46F20HJkGRkxXVZ30/vqXfUJlmX16Fq0
        V3QIgLMmsHQsoHNjScjM8VvknuWkhyuUdLMjOAnInO2uD5OwPYP7iluz9Y0FECxSDuGkmMYBnlV7r
        xxg5/v6ADmthv5gOpDlmGHOKb91Bd18TY/YakJ7qmZmH2dWtWkVXTHW7sDNAt3XjQH4Sg1PWYO44a
        qX3UPZPap/HCxbCaqlx9QivR8ds74LPUz7pDr5cPoEBfjlNyeiW0tEcyo84nUSbBCvetsDDJIgR08
        +L22Dcsg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j1Uo4-00006E-4H; Tue, 11 Feb 2020 12:38:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 31A4230066E;
        Tue, 11 Feb 2020 13:36:33 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DA2BD2B88D75F; Tue, 11 Feb 2020 13:38:21 +0100 (CET)
Date:   Tue, 11 Feb 2020 13:38:21 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v2 5/6] kvm: x86: Emulate MSR IA32_CORE_CAPABILITIES
Message-ID: <20200211123821.GO14914@hirez.programming.kicks-ass.net>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
 <20200203151608.28053-6-xiaoyao.li@intel.com>
 <20200203214300.GI19638@linux.intel.com>
 <829bd606-6852-121f-0d95-e9f1d35a3dde@intel.com>
 <20200204093725.GC14879@hirez.programming.kicks-ass.net>
 <CALCETrUAsUzqLhhNkLSC2612odskjqPQvj4uXgBOaoBGoCQD0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUAsUzqLhhNkLSC2612odskjqPQvj4uXgBOaoBGoCQD0A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 10, 2020 at 07:52:13PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 4, 2020 at 1:37 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Tue, Feb 04, 2020 at 05:19:26PM +0800, Xiaoyao Li wrote:
> >
> > > > > + case MSR_IA32_CORE_CAPS:
> > > > > +         if (!msr_info->host_initiated)
> > > >
> > > > Shouldn't @data be checked against kvm_get_core_capabilities()?
> > >
> > > Maybe it's for the case that userspace might have the ability to emulate SLD
> > > feature? And we usually let userspace set whatever it wants, e.g.,
> > > ARCH_CAPABILITIES.
> >
> > If the 'sq_misc.split_lock' event is sufficiently accurate, I suppose
> > the host could use that to emulate the feature at the cost of one
> > counter used.
> 
> I would be impressed if the event were to fire before executing the
> offending split lock.  Wouldn't the best possible result be for it to
> fire with RIP pointing to the *next* instruction?  This seems like it
> could be quite confusing to a guest.

True; and I see no indication the event is PEBS capable, so even that is
pushing it.

However, it's virt; isn't that confused per definition? ;-))
