Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB64C1D0AE
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 22:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfENUdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 16:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfENUdf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 16:33:35 -0400
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 244B020873
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 20:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557866014;
        bh=/S2BDC6o9SOizwLDYiMYffbUvwSokVCxv3BmfflaHzY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U/yY8Nvhi8iji1+459+sjubgg/1JF0X07D7wRnqqKjlo6h1Ahjbdv/0J0MnwVVdl5
         PvBDOd4AkYiGhiqxEc6ukoCYeoOoDLIXKbu/M85AdHMxpL9STA5P0oBhzNoLQvnalz
         Wel3PIj0edEHiSp4UKTwYSZR0xDnIvhhppn9Cwe8=
Received: by mail-wm1-f54.google.com with SMTP id h11so366770wmb.5
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 13:33:34 -0700 (PDT)
X-Gm-Message-State: APjAAAV+YdkucG8lUKTgIfgjFXamMZrPR/+6DHapWqpfTyOyFqxCfCuE
        66Yu/wEovIGhPR9sXDPHvRcveUCmUqBQLwGJHwBNHA==
X-Google-Smtp-Source: APXvYqyXeyn0oYCthx1qDhe+XBQk39HmQh0lbW3xk+9rI/DwgWNX22XR5PLS9FUku0W/WER2EovhvkXecp1Ggfo8H90=
X-Received: by 2002:a1c:a745:: with SMTP id q66mr11466245wme.83.1557866012756;
 Tue, 14 May 2019 13:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
 <20190514070941.GE2589@hirez.programming.kicks-ass.net> <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
 <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net> <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
 <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com>
 <e5fedad9-4607-0aa4-297e-398c0e34ae2b@oracle.com> <20190514170522.GW2623@hirez.programming.kicks-ass.net>
 <20190514180936.GA1977@linux.intel.com>
In-Reply-To: <20190514180936.GA1977@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 14 May 2019 13:33:21 -0700
X-Gmail-Original-Message-ID: <CALCETrVzbBLokip5n0KEyG6irH6aoEWqyNODTy8embpXhB1GQg@mail.gmail.com>
Message-ID: <CALCETrVzbBLokip5n0KEyG6irH6aoEWqyNODTy8embpXhB1GQg@mail.gmail.com>
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 11:09 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, May 14, 2019 at 07:05:22PM +0200, Peter Zijlstra wrote:
> > On Tue, May 14, 2019 at 06:24:48PM +0200, Alexandre Chartre wrote:
> > > On 5/14/19 5:23 PM, Andy Lutomirski wrote:
> >
> > > > How important is the ability to enable IRQs while running with the KVM
> > > > page tables?
> > > >
> > >
> > > I can't say, I would need to check but we probably need IRQs at least for
> > > some timers. Sounds like you would really prefer IRQs to be disabled.
> > >
> >
> > I think what amluto is getting at, is:
> >
> > again:
> >       local_irq_disable();
> >       switch_to_kvm_mm();
> >       /* do very little -- (A) */
> >       VMEnter()
> >
> >               /* runs as guest */
> >
> >       /* IRQ happens */
> >       WMExit()
> >       /* inspect exit raisin */
> >       if (/* IRQ pending */) {
> >               switch_from_kvm_mm();
> >               local_irq_restore();
> >               goto again;
> >       }
> >
> >
> > but I don't know anything about VMX/SVM at all, so the above might not
> > be feasible, specifically I read something about how VMX allows NMIs
> > where SVM did not somewhere around (A) -- or something like that,
> > earlier in this thread.
>
> For IRQs it's somewhat feasible, but not for NMIs since NMIs are unblocked
> on VMX immediately after VM-Exit, i.e. there's no way to prevent an NMI
> from occuring while KVM's page tables are loaded.
>
> Back to Andy's question about enabling IRQs, the answer is "it depends".
> Exits due to INTR, NMI and #MC are considered high priority and are
> serviced before re-enabling IRQs and preemption[1].  All other exits are
> handled after IRQs and preemption are re-enabled.
>
> A decent number of exit handlers are quite short, e.g. CPUID, most RDMSR
> and WRMSR, any event-related exit, etc...  But many exit handlers require
> significantly longer flows, e.g. EPT violations (page faults) and anything
> that requires extensive emulation, e.g. nested VMX.  In short, leaving
> IRQs disabled across all exits is not practical.
>
> Before going down the path of figuring out how to handle the corner cases
> regarding kvm_mm, I think it makes sense to pinpoint exactly what exits
> are a) in the hot path for the use case (configuration) and b) can be
> handled fast enough that they can run with IRQs disabled.  Generating that
> list might allow us to tightly bound the contents of kvm_mm and sidestep
> many of the corner cases, i.e. select VM-Exits are handle with IRQs
> disabled using KVM's mm, while "slow" VM-Exits go through the full context
> switch.

I suspect that the context switch is a bit of a red herring.  A
PCID-don't-flush CR3 write is IIRC under 300 cycles.  Sure, it's slow,
but it's probably minor compared to the full cost of the vm exit.  The
pain point is kicking the sibling thread.

When I worked on the PTI stuff, I went to great lengths to never have
a copy of the vmalloc page tables.  The top-level entry is either
there or it isn't, so everything is always in sync.  I'm sure it's
*possible* to populate just part of it for this KVM isolation, but
it's going to be ugly.  It would be really nice if we could avoid it.
Unfortunately, this interacts unpleasantly with having the kernel
stack in there.  We can freely use a different stack (the IRQ stack,
for example) as long as we don't schedule, but that means we can't run
preemptable code.

Another issue is tracing, kprobes, etc -- I don't think anyone will
like it if a kprobe in KVM either dramatically changes performance by
triggering isolation exits or by crashing.  So you may need to
restrict the isolated code to a file that is compiled with tracing off
and has everything marked NOKPROBE.  Yuck.

I hate to say this, but at what point do we declare that "if you have
SMT on, you get to keep both pieces, simultaneously!"?
