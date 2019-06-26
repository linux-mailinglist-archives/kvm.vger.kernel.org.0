Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE03456EEA
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfFZQhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 12:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbfFZQhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 12:37:34 -0400
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CFA4217D9
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561567052;
        bh=Bwoi/52zO9ILP6ACaFflaMC9eRq2pCusKuY50s//+DY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TUyISNDxdFqIEgj3On1gDi9E1NP3HQUJ5IyOaYpw+o0hjYu8F0CAfEa4YKLYjVGRP
         4jDZEyFOiVZvdZ+V/2oAS2z+/t/pU/Wh0n0NNHmhd4+f9xF98meomjXsPt+aLxb4HE
         55pOOm2B0L7f0xQg6cjPdhqwBAW2pYEEkgzhCeXA=
Received: by mail-wm1-f44.google.com with SMTP id 207so2798746wma.1
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 09:37:32 -0700 (PDT)
X-Gm-Message-State: APjAAAWKkPUefaUJs9m+ek4x+KxKJEuxjsoJX306zeWvzy1MaD1jo8zd
        oLS1EX9Zl3xUJlWBf+8rJraanFgYfce6os2G+abhww==
X-Google-Smtp-Source: APXvYqxRwb5cr2qiC3vK3YEiw0qCxogxmQvuNJwcAjmGFoynNsZ1yT+YsDO3pvTXiSN/dydwD1e10qbPtEzxcgjXXCM=
X-Received: by 2002:a1c:1a56:: with SMTP id a83mr3567922wma.161.1561567050755;
 Wed, 26 Jun 2019 09:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190613064813.8102-1-namit@vmware.com> <20190613064813.8102-7-namit@vmware.com>
 <cb28f2b4-92f0-f075-648e-dddfdbdd2e3c@intel.com> <401C4384-98A1-4C27-8F71-4848F4B4A440@vmware.com>
 <CALCETrWcUWw8ep-n6RaOeojnL924xOM7g7eb9g=3DRwOHQAgnA@mail.gmail.com>
 <35755C67-E8EB-48C3-8343-BB9ABEB4E32C@vmware.com> <CALCETrUPKj1rRn1bKDYkwZ8cv1navBne72kTCtGHjnhTM0cOVw@mail.gmail.com>
 <A52332CE-80A2-4705-ABB0-3CDDB7AEC889@vmware.com>
In-Reply-To: <A52332CE-80A2-4705-ABB0-3CDDB7AEC889@vmware.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 26 Jun 2019 09:37:19 -0700
X-Gmail-Original-Message-ID: <CALCETrW2kudQ-nt7KFKRizNjBAzDVfLW7qQRJmkuigSmsYBFhg@mail.gmail.com>
Message-ID: <CALCETrW2kudQ-nt7KFKRizNjBAzDVfLW7qQRJmkuigSmsYBFhg@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: x86: Provide paravirtualized flush_tlb_multi()
To:     Nadav Amit <namit@vmware.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 25, 2019 at 11:30 PM Nadav Amit <namit@vmware.com> wrote:
>
> > On Jun 25, 2019, at 8:56 PM, Andy Lutomirski <luto@kernel.org> wrote:
> >
> > On Tue, Jun 25, 2019 at 8:41 PM Nadav Amit <namit@vmware.com> wrote:
> >>> On Jun 25, 2019, at 8:35 PM, Andy Lutomirski <luto@kernel.org> wrote:
> >>>
> >>> On Tue, Jun 25, 2019 at 7:39 PM Nadav Amit <namit@vmware.com> wrote:
> >>>>> On Jun 25, 2019, at 2:40 PM, Dave Hansen <dave.hansen@intel.com> wr=
ote:
> >>>>>
> >>>>> On 6/12/19 11:48 PM, Nadav Amit wrote:
> >>>>>> Support the new interface of flush_tlb_multi, which also flushes t=
he
> >>>>>> local CPU's TLB, instead of flush_tlb_others that does not. This
> >>>>>> interface is more performant since it parallelize remote and local=
 TLB
> >>>>>> flushes.
> >>>>>>
> >>>>>> The actual implementation of flush_tlb_multi() is almost identical=
 to
> >>>>>> that of flush_tlb_others().
> >>>>>
> >>>>> This confused me a bit.  I thought we didn't support paravirtualize=
d
> >>>>> flush_tlb_multi() from reading earlier in the series.
> >>>>>
> >>>>> But, it seems like that might be Xen-only and doesn't apply to KVM =
and
> >>>>> paravirtualized KVM has no problem supporting flush_tlb_multi().  I=
s
> >>>>> that right?  It might be good to include some of that background in=
 the
> >>>>> changelog to set the context.
> >>>>
> >>>> I=E2=80=99ll try to improve the change-logs a bit. There is no inher=
ent reason for
> >>>> PV TLB-flushers not to implement their own flush_tlb_multi(). It is =
left
> >>>> for future work, and here are some reasons:
> >>>>
> >>>> 1. Hyper-V/Xen TLB-flushing code is not very simple
> >>>> 2. I don=E2=80=99t have a proper setup
> >>>> 3. I am lazy
> >>>
> >>> In the long run, I think that we're going to want a way for one CPU t=
o
> >>> do a remote flush and then, with appropriate locking, update the
> >>> tlb_gen fields for the remote CPU.  Getting this right may be a bit
> >>> nontrivial.
> >>
> >> What do you mean by =E2=80=9Cdo a remote flush=E2=80=9D?
> >
> > I mean a PV-assisted flush on a CPU other than the CPU that started
> > it.  If you look at flush_tlb_func_common(), it's doing some work that
> > is rather fancier than just flushing the TLB.  By replacing it with
> > just a pure flush on Xen or Hyper-V, we're losing the potential CR3
> > switch and this bit:
> >
> >        /* Both paths above update our state to mm_tlb_gen. */
> >        this_cpu_write(cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen, mm_tlb=
_gen);
> >
> > Skipping the former can hurt idle performance, although we should
> > consider just disabling all the lazy optimizations on systems with PV
> > flush.  (And I've asked Intel to help us out here in future hardware.
> > I have no idea what the result of asking will be.)  Skipping the
> > cpu_tlbstate write means that we will do unnecessary flushes in the
> > future, and that's not doing us any favors.
> >
> > In principle, we should be able to do something like:
> >
> > flush_tlb_multi(...);
> > for(each CPU that got flushed) {
> >  spin_lock(something appropriate?);
> >  per_cpu_write(cpu, cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen, f->new_t=
lb_gen);
> >  spin_unlock(...);
> > }
> >
> > with the caveat that it's more complicated than this if the flush is a
> > partial flush, and that we'll want to check that the ctx_id still
> > matches, etc.
> >
> > Does this make sense?
>
> Thanks for the detailed explanation. Let me check that I got it right.
>
> You want to optimize cases in which:
>
> 1. A virtual machine

Yes.

>
> 2. Which issues mtultiple (remote) TLB shootdowns

Yes.  Or just one followed by a context switch.  Right now it's
suboptimal with just two vCPUs and a single remote flush.  If CPU 0
does a remote PV flush of CPU1 and then CPU1 context switches away
from the running mm and back, it will do an unnecessary flush on the
way back because the tlb_gen won't match.

>
> 2. To remote vCPU which is preempted by the hypervisor

Yes, or even one that isn't preempted.

>
> 4. And unlike KVM, the hypervisor does not provide facilities for the VM =
to
> know which vCPU is preempted, and atomically request TLB flush when the v=
CPU
> is scheduled.
>

I'm not sure this makes much difference to the case I'm thinking of.

All this being said, do we currently have any system that supports
PCID *and* remote flushes?  I guess KVM has some mechanism, but I'm
not that familiar with its exact capabilities.  If I remember right,
Hyper-V doesn't expose PCID yet.


> Right?
>
