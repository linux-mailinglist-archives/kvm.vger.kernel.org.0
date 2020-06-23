Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E89205010
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbgFWLLL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:11:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:37814 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732189AbgFWLLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:11:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 04EFDAEE6;
        Tue, 23 Jun 2020 11:11:09 +0000 (UTC)
Date:   Tue, 23 Jun 2020 13:11:07 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20200623111107.GG31822@suse.de>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200623094519.GF31822@suse.de>
 <20200623104559.GA4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623104559.GA4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On Tue, Jun 23, 2020 at 12:45:59PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 23, 2020 at 11:45:19AM +0200, Joerg Roedel wrote:
> > Or maybe you have a better idea how to implement this, so I'd like to
> > hear your opinion first before I spend too many days implementing
> > something.
> 
> OK, excuse my ignorance, but I'm not seeing how that IST shifting
> nonsense would've helped in the first place.
> 
> If I understand correctly the problem is:
> 
> 	<#VC>
> 	  shift IST
> 	  <NMI>
> 	    ... does stuff
> 	    <#VC> # again, safe because the shift
> 
> But what happens if you get the NMI before your IST adjustment?

The v3 patchset implements an unconditional shift of the #VC IST entry
in the NMI handler, before it can trigger a #VC exception.

> Either way around we get to fix this up in NMI (and any other IST
> exception that can happen while in #VC, hello #MC). And more complexity
> there is the very last thing we need :-(

Yes, in whatever way this gets implemented, it needs some fixup in the
NMI handler. But that can happen in C code, so it does not make the
assembly more complex, at least.

> There's no way you can fix up the IDT without getting an NMI first.

Not sure what you mean by this.

> This entire exception model is fundamentally buggered :-/

Regards,

	Joerg
