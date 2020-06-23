Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4392C205628
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733038AbgFWPjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:39:33 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:56281 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732978AbgFWPjc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:39:32 -0400
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: eiqxVBWKC88b1iIh5nTj/f7V8Jh2ethNUebZFkujWdRGxn9kUdey47KybRdBPzpPU3UaTmRUbu
 hhEzIKGB0mKgn/ZmC+NiJ8ZJHLfOksnJ/vSslBnIPYj9seYdLRSUz7dZQO5BZc0yl6bA4IjueI
 bn/dF7MfxrIDT5AJWZamzmm2rM+4+z+TgKWNEpAvbpz8sL4gjqSGcJ87E0t/npmOhY35o2I+VS
 bM3rkhL4sTcknZFOm6T2ilmQIhGnWQVAsmrT/yXfdhHaHKXse6ioUbmCYLyCKwuA42B/Hhy1WM
 Epo=
X-SBRS: 2.7
X-MesageID: 21039380
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,271,1589256000"; 
   d="scan'208";a="21039380"
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
To:     Peter Zijlstra <peterz@infradead.org>,
        Joerg Roedel <jroedel@suse.de>
CC:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "Mike Stunes" <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
 <20200623135916.GI4817@hirez.programming.kicks-ass.net>
 <20200623145344.GA117543@hirez.programming.kicks-ass.net>
 <20200623145914.GF14101@suse.de>
 <20200623152326.GL4817@hirez.programming.kicks-ass.net>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <56af2f70-a1c6-aa64-006e-23f2f3880887@citrix.com>
Date:   Tue, 23 Jun 2020 16:39:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623152326.GL4817@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/2020 16:23, Peter Zijlstra wrote:
> On Tue, Jun 23, 2020 at 04:59:14PM +0200, Joerg Roedel wrote:
>> On Tue, Jun 23, 2020 at 04:53:44PM +0200, Peter Zijlstra wrote:
>>> +noinstr void idtentry_validate_ist(struct pt_regs *regs)
>>> +{
>>> +	if ((regs->sp & ~(EXCEPTION_STKSZ-1)) ==
>>> +	    (_RET_IP_ & ~(EXCEPTION_STKSZ-1)))
>>> +		die("IST stack recursion", regs, 0);
>>> +}
>> Yes, this is a start, it doesn't cover the case where the NMI stack is
>> in-between, so I think you need to walk down regs->sp too.
> That shouldn't be possible with the current code, I think.

NMI; #MC; Anything which IRET but isn't fatal - #DB, or #BP from
patching, #GP from *_safe(), etc; NMI

Sure its a corner case, but did you hear that IST is evil?

~Andrew

P.S. did you also hear that with Rowhammer, userspace has a nonzero
quantity of control over generating #MC, depending on how ECC is
configured on the platform.
