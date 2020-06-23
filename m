Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F5F204E4D
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732095AbgFWJpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:45:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:45664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731921AbgFWJpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:45:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 07763AE8C;
        Tue, 23 Jun 2020 09:45:22 +0000 (UTC)
Date:   Tue, 23 Jun 2020 11:45:19 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
Message-ID: <20200623094519.GF31822@suse.de>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andy,

On Mon, Apr 27, 2020 at 10:37:41AM -0700, Andy Lutomirski wrote:
> 1. Use IST for #VC and deal with all the mess that entails.

With the removal of IST shifting I wonder what you would suggest on how
to best implement an NMI-safe IST handler with nesting support.

My current plan is to implement an IST handler which switches itself off
the IST stack as soon as possible, freeing it for re-use.

The flow would be roughly like this upon entering the handler;

	build_pt_regs();

	RSP = pt_regs->sp;

	if (RSP in VC_IST_stack)
		error("unallowed nesting")

	if (RSP in current_kernel_stack)
		RSP = round_down_to_8(RSP)
	else
		RSP = current_top_of_stack() // non-ist kernel stack

	copy_pt_regs(pt_regs, RSP);
	switch_stack_to(RSP);

To make this NMI safe, the NMI handler needs some logic too. Upon
entering NMI, it needs to check the return RSP, and if it is in the #VC
IST stack, it must do the above flow by itself and update the return RSP
and RIP. It needs to take into account the case when PT_REGS is not
fully populated on the return side.

Alternativly the NMI handler could safe/restore the contents of the #VC
IST stack or just switch to a special #VC-in-NMI IST stack.

All in all it could get complicated, and imho shift_ist would have been
simpler, but who am I anyway...

Or maybe you have a better idea how to implement this, so I'd like to
hear your opinion first before I spend too many days implementing
something.

Regards,

	Joerg
