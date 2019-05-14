Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2060F1D102
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 23:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfENVGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 17:06:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:16245 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfENVGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 17:06:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 14:06:03 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 14 May 2019 14:06:03 -0700
Date:   Tue, 14 May 2019 14:06:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
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
Message-ID: <20190514210603.GD1977@linux.intel.com>
References: <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
 <20190514070941.GE2589@hirez.programming.kicks-ass.net>
 <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
 <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net>
 <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
 <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com>
 <e5fedad9-4607-0aa4-297e-398c0e34ae2b@oracle.com>
 <20190514170522.GW2623@hirez.programming.kicks-ass.net>
 <20190514180936.GA1977@linux.intel.com>
 <CALCETrVzbBLokip5n0KEyG6irH6aoEWqyNODTy8embpXhB1GQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVzbBLokip5n0KEyG6irH6aoEWqyNODTy8embpXhB1GQg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 01:33:21PM -0700, Andy Lutomirski wrote:
> On Tue, May 14, 2019 at 11:09 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> > For IRQs it's somewhat feasible, but not for NMIs since NMIs are unblocked
> > on VMX immediately after VM-Exit, i.e. there's no way to prevent an NMI
> > from occuring while KVM's page tables are loaded.
> >
> > Back to Andy's question about enabling IRQs, the answer is "it depends".
> > Exits due to INTR, NMI and #MC are considered high priority and are
> > serviced before re-enabling IRQs and preemption[1].  All other exits are
> > handled after IRQs and preemption are re-enabled.
> >
> > A decent number of exit handlers are quite short, e.g. CPUID, most RDMSR
> > and WRMSR, any event-related exit, etc...  But many exit handlers require
> > significantly longer flows, e.g. EPT violations (page faults) and anything
> > that requires extensive emulation, e.g. nested VMX.  In short, leaving
> > IRQs disabled across all exits is not practical.
> >
> > Before going down the path of figuring out how to handle the corner cases
> > regarding kvm_mm, I think it makes sense to pinpoint exactly what exits
> > are a) in the hot path for the use case (configuration) and b) can be
> > handled fast enough that they can run with IRQs disabled.  Generating that
> > list might allow us to tightly bound the contents of kvm_mm and sidestep
> > many of the corner cases, i.e. select VM-Exits are handle with IRQs
> > disabled using KVM's mm, while "slow" VM-Exits go through the full context
> > switch.
> 
> I suspect that the context switch is a bit of a red herring.  A
> PCID-don't-flush CR3 write is IIRC under 300 cycles.  Sure, it's slow,
> but it's probably minor compared to the full cost of the vm exit.  The
> pain point is kicking the sibling thread.

Speaking of PCIDs, a separate mm for KVM would mean consuming another
ASID, which isn't good.

> When I worked on the PTI stuff, I went to great lengths to never have
> a copy of the vmalloc page tables.  The top-level entry is either
> there or it isn't, so everything is always in sync.  I'm sure it's
> *possible* to populate just part of it for this KVM isolation, but
> it's going to be ugly.  It would be really nice if we could avoid it.
> Unfortunately, this interacts unpleasantly with having the kernel
> stack in there.  We can freely use a different stack (the IRQ stack,
> for example) as long as we don't schedule, but that means we can't run
> preemptable code.
> 
> Another issue is tracing, kprobes, etc -- I don't think anyone will
> like it if a kprobe in KVM either dramatically changes performance by
> triggering isolation exits or by crashing.  So you may need to
> restrict the isolated code to a file that is compiled with tracing off
> and has everything marked NOKPROBE.  Yuck.

Right, and all of the above is largely why I suggested compiling a list
of VM-Exits that "need" preferential treatment.  If the cumulative amount
of code and data that needs to be accessed is tiny, then this might be
feasible.  But if the goal is to be able to do things like handle IRQs
using the KVM mm, ouch.

> I hate to say this, but at what point do we declare that "if you have
> SMT on, you get to keep both pieces, simultaneously!"?
