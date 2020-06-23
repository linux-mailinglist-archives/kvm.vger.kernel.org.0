Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE912055E7
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732982AbgFWPaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:30:14 -0400
Received: from esa5.hc3370-68.iphmx.com ([216.71.155.168]:5214 "EHLO
        esa5.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732821AbgFWPaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:30:10 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2020 11:30:10 EDT
Authentication-Results: esa5.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: /GrFiUnpMH0W1AmH16iOP4fF+hxzWdtD9D+GISmoRYqR9NUtqwq7oNSKz4sucvE9pe0J4q44B7
 YPhx3w0bbMe7At7SPDagk+W+pBlnB3922l+qjz6SB7+59/ApAY01JpymxYxQB/94hJVnwwx0hu
 mFWsCVB1OyWETH6EOQgYMgbq3BvnqklFn/9U3YmTb/P+RlHggHk+LCKhL2ufV+TQIExUPEF/c/
 iBObNjUKWYetodeXq+AyoWV8QwqwHww4DnX12xwYBQL5sOXqBlQ7a5064JbCHOcBXl3kQZ+uQp
 tKU=
X-SBRS: 2.7
X-MesageID: 20952771
X-Ironport-Server: esa5.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,271,1589256000"; 
   d="scan'208";a="20952771"
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
References: <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200623094519.GF31822@suse.de>
 <20200623104559.GA4817@hirez.programming.kicks-ass.net>
 <20200623111107.GG31822@suse.de>
 <20200623111443.GC4817@hirez.programming.kicks-ass.net>
 <20200623114324.GA14101@suse.de>
 <20200623115014.GE4817@hirez.programming.kicks-ass.net>
 <20200623121237.GC14101@suse.de>
 <20200623130322.GH4817@hirez.programming.kicks-ass.net>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <9e3f9b2a-505e-dfd7-c936-461227b4033e@citrix.com>
Date:   Tue, 23 Jun 2020 16:22:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623130322.GH4817@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/2020 14:03, Peter Zijlstra wrote:
> On Tue, Jun 23, 2020 at 02:12:37PM +0200, Joerg Roedel wrote:
>> On Tue, Jun 23, 2020 at 01:50:14PM +0200, Peter Zijlstra wrote:
>>> If SNP is the sole reason #VC needs to be IST, then I'd strongly urge
>>> you to only make it IST if/when you try and make SNP happen, not before.
>> It is not the only reason, when ES guests gain debug register support
>> then #VC also needs to be IST, because #DB can be promoted into #VC
>> then, and as #DB is IST for a reason, #VC needs to be too.
> Didn't I read somewhere that that is only so for Rome/Naples but not for
> the later chips (Milan) which have #DB pass-through?

I don't know about hardware timelines, but some future part can now opt
in to having debug registers as part of the encrypted state, and swapped
by VMExit, which would make debug facilities generally usable, and
supposedly safe to the #DB infinite loop issues, at which point the
hypervisor need not intercept #DB for safety reasons.

Its worth nothing that on current parts, the hypervisor can set up debug
facilities on behalf of the guest (or behind its back) as the DR state
is unencrypted, but that attempting to intercept #DB will redirect to
#VC inside the guest and cause fun. (Also spare a thought for 32bit
kernels which have to cope with userspace singlestepping the SYSENTER
path with every #DB turning into #VC.)

>> Besides that, I am not a fan of delegating problems I already see coming
>> to future-Joerg and future-Peter, but if at all possible deal with them
>> now and be safe later.
> Well, we could just say no :-) At some point in the very near future
> this house of cards is going to implode.

What currently exists is a picture of a house of cards in front of
something which has fallen down.

> Did someone forget to pass the 'ISTs are *EVIL*' memo to the hardware
> folks? How come we're getting more and more of them?

I have tried to get this point across.  Then again - its far easier for
the software folk in the same company as the hardware folk to make this
point.

> (/me puts fingers
> in ears and goes la-la-la-la in anticipation of Andrew mentioning CET)

I wasn't going to bring it up, but seeing as you have - while there are
prohibitively-complicating issues preventing it from working on native,
I don't see any point even considering it for the mess which is #VC, or
the even bigger mess which is #HV.

~Andrew
