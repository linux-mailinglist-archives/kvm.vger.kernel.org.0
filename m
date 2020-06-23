Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3402055F8
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbgFWPc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:32:29 -0400
Received: from esa3.hc3370-68.iphmx.com ([216.71.145.155]:36562 "EHLO
        esa3.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgFWPc3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:32:29 -0400
Authentication-Results: esa3.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: QP9Jx3H+HhvZhhEt4ggfsozV10N6bYVBVidEhPpOSKd2Kt2OP2Y8D1tWVy640iW+66S4ExUr29
 3JB3pFSLJftaItQlzTtDyzPlpXNy/W/T9+L+ZFgV14wTPrvC6XS7AuiDPdi1jxIxAzVAbCfu5M
 Wi9kMDH32VcQn1yx3GawArowkMnTUV+a0Z+YTDF9aj3mgsowvLagbbd5j5V50TxYrIF/rlg3p1
 7vyqf2bzbYlLiGxnmqC1s4QyuG9wzWCCA2OkMvKoLqQ9juszSl2yG5y7WK+owAQ4QX+oxC8Rpm
 kC4=
X-SBRS: 2.7
X-MesageID: 20733007
X-Ironport-Server: esa3.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,271,1589256000"; 
   d="scan'208";a="20733007"
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
References: <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200623094519.GF31822@suse.de>
 <20200623104559.GA4817@hirez.programming.kicks-ass.net>
 <20200623111107.GG31822@suse.de>
 <20200623111443.GC4817@hirez.programming.kicks-ass.net>
 <20200623114324.GA14101@suse.de>
 <20200623115014.GE4817@hirez.programming.kicks-ass.net>
 <20200623121237.GC14101@suse.de>
 <20200623130322.GH4817@hirez.programming.kicks-ass.net>
 <20200623144940.GE14101@suse.de>
 <20200623151607.GJ4817@hirez.programming.kicks-ass.net>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <fe0af2c8-92c8-8d66-e9f3-5a50d64837e5@citrix.com>
Date:   Tue, 23 Jun 2020 16:32:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623151607.GJ4817@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/2020 16:16, Peter Zijlstra wrote:
> On Tue, Jun 23, 2020 at 04:49:40PM +0200, Joerg Roedel wrote:
>>> We're talking about the 3rd case where the only reason things 'work' is
>>> because we'll have to panic():
>>>
>>>  - #MC
>> Okay, #MC is special and can only be handled on a best-effort basis, as
>> #MC could happen anytime, also while already executing the #MC handler.
> I think the hardware has a MCE-mask bit somewhere. Flaky though because
> clearing it isn't 'atomic' with IRET, so there's a 'funny' window.

MSR_MCG_STATUS.MCIP, and yes - any #MC before that point will
immediately Shutdown.  Any #MC between that point and IRET will clobber
its IST stack and end up sad.

> It also interacts really bad with the NMI handler. If we get an #MC
> early in the NMI, where we hard-rely on the NMI-mask being set to set-up
> the recursion stack, then the #MC IRET will clear the NMI-mask, and
> we're toast.
>
> Andy has wild and crazy ideas, but I don't think we need more crazy
> here.

Want, certainly not.  Need, maybe :-/
>>>  - #DB with BUS LOCK DEBUG EXCEPTION
>> If I understand the problem correctly, this can be solved by moving off
>> the IST stack to the current task stack in the #DB handler, like I plan
>> to do for #VC, no?
> Hmm, probably. Would take a bit of care, but should be doable.

Andy and I have spent some time considering this.

Having exactly one vector move off IST and onto an in-use task-stack is
doable, I think, so long as it can sort out self-recursion protections.

Having more than one vector do this is very complicated.  You've got to
take care to walk up the list of IST-nesting to see if any interrupted
context is in the middle of trying to copy themselves onto the stack, so
you don't clobber the frame they're in the middle of copying.

~Andrew
