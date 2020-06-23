Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004A720551C
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 16:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732848AbgFWOtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 10:49:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:38190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732738AbgFWOtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 10:49:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 16C4CADAA;
        Tue, 23 Jun 2020 14:49:43 +0000 (UTC)
Date:   Tue, 23 Jun 2020 16:49:40 +0200
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
Message-ID: <20200623144940.GE14101@suse.de>
References: <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200623094519.GF31822@suse.de>
 <20200623104559.GA4817@hirez.programming.kicks-ass.net>
 <20200623111107.GG31822@suse.de>
 <20200623111443.GC4817@hirez.programming.kicks-ass.net>
 <20200623114324.GA14101@suse.de>
 <20200623115014.GE4817@hirez.programming.kicks-ass.net>
 <20200623121237.GC14101@suse.de>
 <20200623130322.GH4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623130322.GH4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 03:03:22PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 23, 2020 at 02:12:37PM +0200, Joerg Roedel wrote:
> > On Tue, Jun 23, 2020 at 01:50:14PM +0200, Peter Zijlstra wrote:
> > > If SNP is the sole reason #VC needs to be IST, then I'd strongly urge
> > > you to only make it IST if/when you try and make SNP happen, not before.
> > 
> > It is not the only reason, when ES guests gain debug register support
> > then #VC also needs to be IST, because #DB can be promoted into #VC
> > then, and as #DB is IST for a reason, #VC needs to be too.
> 
> Didn't I read somewhere that that is only so for Rome/Naples but not for
> the later chips (Milan) which have #DB pass-through?

Probably, not sure which chips will get debug register virtualization
under SEV-ES. But even when it is supported, the HV can (and sometimes
will) intercept #DB, which then causes it to be promoted to #VC.

> We're talking about the 3rd case where the only reason things 'work' is
> because we'll have to panic():
> 
>  - #MC

Okay, #MC is special and can only be handled on a best-effort basis, as
#MC could happen anytime, also while already executing the #MC handler.

>  - #DB with BUS LOCK DEBUG EXCEPTION

If I understand the problem correctly, this can be solved by moving off
the IST stack to the current task stack in the #DB handler, like I plan
to do for #VC, no?

>  - #VC SNP

This has to panic for other reasons that can't be worked around. It
boils down to detecting that the HV is doing something fishy and bail
out to avoid further harm (like in the #MC handler).


Regards,

	Joerg
