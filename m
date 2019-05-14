Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A39F1CEAD
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 20:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfENSJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 14:09:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:17908 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfENSJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 14:09:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 11:09:49 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga007.jf.intel.com with ESMTP; 14 May 2019 11:09:50 -0700
Date:   Tue, 14 May 2019 11:09:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
Message-ID: <20190514180936.GA1977@linux.intel.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
 <20190514070941.GE2589@hirez.programming.kicks-ass.net>
 <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
 <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net>
 <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
 <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com>
 <e5fedad9-4607-0aa4-297e-398c0e34ae2b@oracle.com>
 <20190514170522.GW2623@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514170522.GW2623@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 07:05:22PM +0200, Peter Zijlstra wrote:
> On Tue, May 14, 2019 at 06:24:48PM +0200, Alexandre Chartre wrote:
> > On 5/14/19 5:23 PM, Andy Lutomirski wrote:
> 
> > > How important is the ability to enable IRQs while running with the KVM
> > > page tables?
> > > 
> > 
> > I can't say, I would need to check but we probably need IRQs at least for
> > some timers. Sounds like you would really prefer IRQs to be disabled.
> > 
> 
> I think what amluto is getting at, is:
> 
> again:
> 	local_irq_disable();
> 	switch_to_kvm_mm();
> 	/* do very little -- (A) */
> 	VMEnter()
> 
> 		/* runs as guest */
> 
> 	/* IRQ happens */
> 	WMExit()
> 	/* inspect exit raisin */
> 	if (/* IRQ pending */) {
> 		switch_from_kvm_mm();
> 		local_irq_restore();
> 		goto again;
> 	}
> 
> 
> but I don't know anything about VMX/SVM at all, so the above might not
> be feasible, specifically I read something about how VMX allows NMIs
> where SVM did not somewhere around (A) -- or something like that,
> earlier in this thread.

For IRQs it's somewhat feasible, but not for NMIs since NMIs are unblocked
on VMX immediately after VM-Exit, i.e. there's no way to prevent an NMI
from occuring while KVM's page tables are loaded.

Back to Andy's question about enabling IRQs, the answer is "it depends".
Exits due to INTR, NMI and #MC are considered high priority and are
serviced before re-enabling IRQs and preemption[1].  All other exits are
handled after IRQs and preemption are re-enabled.

A decent number of exit handlers are quite short, e.g. CPUID, most RDMSR
and WRMSR, any event-related exit, etc...  But many exit handlers require 
significantly longer flows, e.g. EPT violations (page faults) and anything
that requires extensive emulation, e.g. nested VMX.  In short, leaving
IRQs disabled across all exits is not practical.

Before going down the path of figuring out how to handle the corner cases
regarding kvm_mm, I think it makes sense to pinpoint exactly what exits
are a) in the hot path for the use case (configuration) and b) can be
handled fast enough that they can run with IRQs disabled.  Generating that
list might allow us to tightly bound the contents of kvm_mm and sidestep
many of the corner cases, i.e. select VM-Exits are handle with IRQs
disabled using KVM's mm, while "slow" VM-Exits go through the full context
switch.

[1] Technically, IRQs are actually enabled when SVM services INTR.  SVM
    hardware doesn't acknowledge the INTR/NMI on VM-Exit, but rather keeps
    it pending until the event is unblocked, e.g. servicing a VM-Exit due
    to an INTR is simply a matter of enabling IRQs.
