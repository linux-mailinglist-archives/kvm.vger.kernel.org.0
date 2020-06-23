Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37A8205044
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbgFWLPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732261AbgFWLPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:15:12 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6074AC061573;
        Tue, 23 Jun 2020 04:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kbjAKWhzfgOj923ZSmk/+0La2WIuOqVntNXB3to3NaY=; b=xsXdYkCrqqHaG0/uNn9otnZ92O
        bQLlNydLgpYpRZ19BLNcTK51b7J6swMSOX2NKGX8Hy0bXAwxheGpBaivL2lF311orkcO5VSiZ7oxD
        OL8nBV4GZBkD2zuJ4wzQucOc4qbT2WIRLdws+iCHmAc78Ax3GgfArKXaDTmo5CSRLn4yoaDRxBr6i
        PMhRrAT3PLo+fp/Z6DY3wGLET4pisfFbcyBMjDvE+J2IkD8qPYM38ZgVlnMnoBbX22Wr8upCldDKq
        Og09chKT10e9T3DFlyzPLo8eOQVUPcwAHKeiia0mBkSiyxpwG8QvWNb7+VwWEKn0hC9alHDY009Kr
        /zssl0yA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jngt3-0008DI-3y; Tue, 23 Jun 2020 11:14:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6901730477A;
        Tue, 23 Jun 2020 13:14:43 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 55D892370FA07; Tue, 23 Jun 2020 13:14:43 +0200 (CEST)
Date:   Tue, 23 Jun 2020 13:14:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
Message-ID: <20200623111443.GC4817@hirez.programming.kicks-ass.net>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200623094519.GF31822@suse.de>
 <20200623104559.GA4817@hirez.programming.kicks-ass.net>
 <20200623111107.GG31822@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623111107.GG31822@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 01:11:07PM +0200, Joerg Roedel wrote:
> Hi Peter,
> 
> On Tue, Jun 23, 2020 at 12:45:59PM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 23, 2020 at 11:45:19AM +0200, Joerg Roedel wrote:
> > > Or maybe you have a better idea how to implement this, so I'd like to
> > > hear your opinion first before I spend too many days implementing
> > > something.
> > 
> > OK, excuse my ignorance, but I'm not seeing how that IST shifting
> > nonsense would've helped in the first place.
> > 
> > If I understand correctly the problem is:
> > 
> > 	<#VC>
> > 	  shift IST
> > 	  <NMI>
> > 	    ... does stuff
> > 	    <#VC> # again, safe because the shift
> > 
> > But what happens if you get the NMI before your IST adjustment?
> 
> The v3 patchset implements an unconditional shift of the #VC IST entry
> in the NMI handler, before it can trigger a #VC exception.

Going by that other thread -- where you said that any memory access can
trigger a #VC, there just isn't such a guarantee.

> > Either way around we get to fix this up in NMI (and any other IST
> > exception that can happen while in #VC, hello #MC). And more complexity
> > there is the very last thing we need :-(
> 
> Yes, in whatever way this gets implemented, it needs some fixup in the
> NMI handler. But that can happen in C code, so it does not make the
> assembly more complex, at least.
> 
> > There's no way you can fix up the IDT without getting an NMI first.
> 
> Not sure what you mean by this.

I was talking about the case where #VC would try and fix up its own IST.
