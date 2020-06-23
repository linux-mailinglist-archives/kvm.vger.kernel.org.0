Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2842051B9
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 14:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732541AbgFWMEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 08:04:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:38642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729552AbgFWMEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 08:04:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D932EAFB0;
        Tue, 23 Jun 2020 12:04:35 +0000 (UTC)
Date:   Tue, 23 Jun 2020 14:04:33 +0200
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
Message-ID: <20200623120433.GB14101@suse.de>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623114818.GD4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 01:48:18PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 23, 2020 at 01:30:07PM +0200, Joerg Roedel wrote:

> But you cannot do a recursion check in #VC, because the NMI can happen
> on the first instruction of #VC, before we can increment our counter,
> and then the #VC can happen on NMI because the IST stack is a goner, and
> we're fscked again (or on a per-cpu variable we touch in our elaborate
> NMI setup, etc..).

No, the recursion check is fine, because overwriting an already used IST
stack doesn't matter (as long as it can be detected) if we are going to
panic anyway. It doesn't matter because the kernel will not leave the
currently running handler anymore.

I agree there is no way to keep the system running if that happens, but
that is also not what is wanted. If stack recursion happens, something
malicious from the HV side is going on, and all the kernel needs to be
able to is to safely and reliably detect the situation and panic the VM
to prevent any data corruption or loss or even leakage.

> I'll keep repeating this, x86_64 exceptions are a trainwreck, and IST in
> specific is utter crap.

I agree, but don't forget the most prominent underlying reason for IST:
The SYSCALL gap. If SYSCALL would switch stacks most of those issues
would not exist. IST would still be needed because there are no task
gates in x86-64, but still...

Regards,

	Joerg

