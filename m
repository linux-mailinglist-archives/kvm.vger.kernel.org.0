Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB3A205401
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 15:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbgFWN51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 09:57:27 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:50852 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732657AbgFWN50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 09:57:26 -0400
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: RxHCBkGn6WCYmKI8uhwqpDzWq9+T02hGLgx/4StGqp26rXVL/9EHUTW4ZgZWcdrwy973h8+FL1
 vuqOMF+AEy3R03F6tyzjQrt2Z04lpSzdTjGVedKmE+8goFjOSXq8bTLW7X1REC5Cfa0KZuLHu2
 2qD6s/B/VzsFyM3jt90pG1SIBE4FZqvelWngm1YJyUG8/pNVPZt+4klXSO5TluydnT49CwDygG
 limi5Xh2jdtnNS/3Y5BWVO88o78s3uWHLpkzsF9dVK1dQ3NXHK8JVP176FwTkg1lAJtb/ohx2C
 C6Y=
X-SBRS: 2.7
X-MesageID: 21024354
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,271,1589256000"; 
   d="scan'208";a="21024354"
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Joerg Roedel <jroedel@suse.de>, Andy Lutomirski <luto@kernel.org>,
        "Joerg Roedel" <joro@8bytes.org>,
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
        "Sean Christopherson" <sean.j.christopherson@intel.com>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <8413fe52-04ee-f4e1-873c-17595110856a@citrix.com>
 <20200623124712.GF4817@hirez.programming.kicks-ass.net>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Message-ID: <4113e368-6bc8-51b7-9412-3b4df2633ad6@citrix.com>
Date:   Tue, 23 Jun 2020 14:57:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623124712.GF4817@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/2020 13:47, Peter Zijlstra wrote:
> On Tue, Jun 23, 2020 at 12:51:03PM +0100, Andrew Cooper wrote:
>
>> There are cases which are definitely non-recoverable.
>>
>> For both ES and SNP, a malicious hypervisor can mess with the guest
>> physmap to make the the NMI, #VC and #DF stacks all alias.
>>
>> For ES, this had better result in the #DF handler deciding that crashing
>> is the way out, whereas for SNP, this had better escalate to Shutdown.
>> Crashing out hard if the hypervisor is misbehaving is acceptable.
> Then I'm thinking the only sensible option is to crash hard for any SNP
> #VC from kernel mode.
>
> Sadly that doesn't help with #VC needing to be IST :-( IST is such a
> frigging nightmare.

I presume you mean any #VC caused by RMP faults (i.e. something went
wrong with the memory owner/etc metadata) ?

If so, then yes.  Any failure here is a bug in the kernel or hypervisor
(and needs fixing) or a malicious hypervisor and the guest should
terminate for its own safety.

~Andrew
