Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F386C2053A4
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 15:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbgFWNkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 09:40:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:59130 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732631AbgFWNkH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 09:40:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6A681ACF2;
        Tue, 23 Jun 2020 13:40:05 +0000 (UTC)
Date:   Tue, 23 Jun 2020 15:40:03 +0200
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
Message-ID: <20200623134003.GD14101@suse.de>
References: <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623125201.GG4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 02:52:01PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 23, 2020 at 02:04:33PM +0200, Joerg Roedel wrote:
> > No, the recursion check is fine, because overwriting an already used IST
> > stack doesn't matter (as long as it can be detected) if we are going to
> > panic anyway. It doesn't matter because the kernel will not leave the
> > currently running handler anymore.
> 
> You only have that guarantee when any SNP #VC from kernel is an
> automatic panic. But in that case, what's the point of having the
> recursion count?

It is not a recursion count, it is a stack-recursion check. Basically
walk down the stack and look if your current stack is already in use.
Yes, this can be optimized, but that is what is needed.

IIRC the current prototype code for SNP just pre-validates all memory in
the VM and doesn't support moving pages around on the host. So any #VC
SNP exception would be fatal, yes.

In a scenario with on-demand validation of guest pages and support for
guest-assisted page-moving on the HV side it would be more complicated.
Basically all memory that is accessed during #VC exception handling must
stay validated at all times, including the IST stack.

So saying this, I don't understand why _all_ SNP #VC exceptions from
kernel space must be fatal?

Regards,

	Joerg

