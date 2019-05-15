Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033EA1F695
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 16:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfEOOaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 10:30:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:6774 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbfEOOaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 10:30:17 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 07:30:16 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 15 May 2019 07:30:15 -0700
Date:   Wed, 15 May 2019 07:30:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: Re: [PATCH] KVM: VMX: Nop emulation of MSR_IA32_POWER_CTL
Message-ID: <20190515143015.GB5875@linux.intel.com>
References: <20190415154526.64709-1-liran.alon@oracle.com>
 <20190415181702.GH24010@linux.intel.com>
 <AD81166E-0C42-49FD-AC37-E6F385C23B13@oracle.com>
 <4848D424-F852-4E1C-8A86-6AA1A26D2E90@oracle.com>
 <2dad36e7-a0e5-9670-c902-819c5200466f@oracle.com>
 <CANRm+CyYkjFaLZMOHP3sMYVjFNo1P7uKbrRr7U3FfRHhG5jVkA@mail.gmail.com>
 <d930e87a-fbe3-cf63-b8a0-26e9f012442a@oracle.com>
 <20190510171733.GA16852@linux.intel.com>
 <CANRm+Cy4GKvNpJN0ORfMGXC=BfPHZ+khKZhJQzeWvFYVmTGVfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cy4GKvNpJN0ORfMGXC=BfPHZ+khKZhJQzeWvFYVmTGVfA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 05:13:29PM +0800, Wanpeng Li wrote:
> On Sat, 11 May 2019 at 01:17, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, May 10, 2019 at 11:34:41AM +0100, Joao Martins wrote:
> > > On 5/10/19 10:54 AM, Wanpeng Li wrote:
> > > > It is weird that we can observe intel_idle driver in the guest
> > > > executes mwait eax=0x20, and the corresponding pCPU enters C3 on HSW
> > > > server, however, we can't observe this on SKX/CLX server, it just
> > > > enters maximal C1.
> > >
> > > I assume you refer to the case where you pass the host mwait substates to the
> > > guests as is, right? Or are you zeroing/filtering out the mwait cpuid leaf EDX
> > > like my patch (attached in the previous message) suggests?
> > >
> > > Interestingly, hints set to 0x20 actually corresponds to C6 on HSW (based on
> > > intel_idle driver). IIUC From the SDM (see Vol 2B, "MWAIT for Power Management"
> > > in instruction set reference M-U) the hints register, doesn't necessarily
> > > guarantee the specified C-state depicted in the hints will be used. The manual
> > > makes it sound like it is tentative, and implementation-specific condition may
> > > either ignore it or enter a different one. It appears to be only guaranteed that
> > > it won't enter a C-{sub,}state deeper than the one depicted.
> >
> > Yep, section "MWAIT EXTENSIONS FOR ADVANCED POWER MANAGEMENT" is more
> > explicit on this point:
> >
> >   At CPL=0, system software can specify desired C-state and sub C-state by
> >   using the MWAIT hints register (EAX).  Processors will not go to C-state
> >   and sub C-state deeper than what is specified by the hint register.
> >
> > As for why SKX/CLX only enters C1, AFAICT SKX isn't configured to support
> > C3, e.g. skx_cstates in drivers/idle/intel_idle.c shows C1, C1E and C6.
> > A quick search brings up a variety of docs that confirm this.  My guess is
> > that C1E provides better power/performance than C3 for the majority of
> > server workloads, e.g. C3 doesn't provide enough power savings to justify
> > its higher latency and TLB flush.
> 
> You are right, I figure this out by referring to the SKX/CLX EDS, the
> Core C-States of these two generations just support CC0/CC1/CC1E/CC6.
> The issue here is after exposing mwait to the guest, SKX/CLX guest
> can't enter CC6, however, HSW guest can enter CC3/CC6. Both HSW and
> SKX/CLX hosts can enter CC6. We observe SKX/CLX guests execute mwait
> eax 0x20, however, we can't observe the corresponding pCPU enter CC6
> by turbostat or reading MSR_CORE_C6_RESIDENCY directly.

It's likely that the CPU is operating as expected and isn't dropping into
the deeper sleep state because of some heuristic or wake event.  It might
be something as simple as the combination of periodic tick interrupts
between host and guest occuring too frequently (to get to C6), or it could
be a much more complex scenario.  It's been several years since I've done
anything close to hands on debug with C-states, I have no idea what
capabilities are available to help debug this sort of thing.  Sorry I
can't be more helpful.
