Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4957205175
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732463AbgFWL6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:58:15 -0400
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:19510 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732364AbgFWL6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:58:14 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2020 07:58:14 EDT
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: BCjzX3+BOpHiGycYt67E9CJmR9y9VmfqJlqeSes5AYEZnPtE4Y5U8EKDIJfULxlccVR1Unu4/t
 odza41iyN6Py2bb5aXuBwU4Vi/htf63bVfuD5PT+0l7Ew73sqwyUhQltOfiNB6RepD6loxfh6t
 tzXBrJQaqlUnAMFu4ZZw5Cu3pHjUZDnwtwaxqF07OJJSUXCDcJmFWFq8shx7DIAOlR3T+JCwb0
 PXhFSgojaIgXKZs28xNTKBcLx4pRtbBiCrlEyQ0T4T0i53E7GoBBWK8XwMEwKV/JCKQ31VV4Ls
 1UE=
X-SBRS: 2.7
X-MesageID: 20716528
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,271,1589256000"; 
   d="scan'208";a="20716528"
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
To:     Joerg Roedel <jroedel@suse.de>,
        Peter Zijlstra <peterz@infradead.org>
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
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <8413fe52-04ee-f4e1-873c-17595110856a@citrix.com>
Date:   Tue, 23 Jun 2020 12:51:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623113007.GH31822@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/2020 12:30, Joerg Roedel wrote:
> On Tue, Jun 23, 2020 at 01:07:06PM +0200, Peter Zijlstra wrote:
>> On Tue, Apr 28, 2020 at 09:55:12AM +0200, Joerg Roedel wrote:
>> So what happens if this #VC triggers on the first access to the #VC
>> stack, because the malicious host has craftily mucked with only the #VC
>> IST stack page?
>>
>> Or on the NMI IST stack, then we get #VC in NMI before the NMI can fix
>> you up.
>>
>> AFAICT all of that is non-recoverable.
> I am not 100% sure, but I think if the #VC stack page is not validated,
> the #VC should be promoted to a #DF.
>
> Note that this is an issue only with secure nested paging (SNP), which
> is not enabled yet with this patch-set. When it gets enabled a stack
> recursion check in the #VC handler is needed which panics the VM. That
> also fixes the #VC-in-early-NMI problem.

There are cases which are definitely non-recoverable.

For both ES and SNP, a malicious hypervisor can mess with the guest
physmap to make the the NMI, #VC and #DF stacks all alias.

For ES, this had better result in the #DF handler deciding that crashing
is the way out, whereas for SNP, this had better escalate to Shutdown.


What matters here is the security model in SNP.  The hypervisor is
relied upon for availability (because it could simply refuse to schedule
the VM), but market/business forces will cause it to do its best to keep
the VM running.  Therefore, the securely model is simply(?) that the
hypervisor can't do anything to undermine the confidentiality or
integrity of the VM.

Crashing out hard if the hypervisor is misbehaving is acceptable.  In a
cloud, I as a customer would (threaten to?) take my credit card
elsewhere, while for enterprise, I'd shout at my virtualisation vendor
until a fix happened (also perhaps threaten to take my credit card
elsewhere).

Therefore, it is reasonable to build on the expectation that the
hypervisor won't be messing around with remapping stacks/etc.  Most
#VC's are synchronous with guest actions (they equate to actions which
would have caused a VMExit), so you can safely reason about when the
first #VC might occur, presuming no funny business with the frames
backing any memory operands touched.

~Andrew
