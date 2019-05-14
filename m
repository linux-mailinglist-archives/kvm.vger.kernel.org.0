Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 698121CBC4
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfENPYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:24:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfENPYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 11:24:03 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66DCF21707
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 15:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557847441;
        bh=lEnwwmU1XbKwYI+07sS2BHHk1ukbBjXSFcW1oRTxeAo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eVCLg4/XxcMGOLsPFn6OR8b5+D0fSJ3C73EsiGv+ZP1UExvdsqIN8jEcRCYerQv8E
         JiJQI0nJ+Wm5vH2G6Wc56NLBhB0dSfY8L+kVXyatxe3O+MvvIlYBmHROcAADcXdyMu
         gmFnLgnQ5/GErDUj0tVtJM/DgF+Mw/f+QUS627hc=
Received: by mail-wr1-f50.google.com with SMTP id d9so11342277wrx.0
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 08:24:01 -0700 (PDT)
X-Gm-Message-State: APjAAAUvh7FhJfVk5EBsBTSKzmrhrOBOW8byfyjdhhM8bNWOyPUuvUPk
        6i7e2ztbvXp8+pzF5JkVt1x/HRBhe9hn3ZV9qgjjUw==
X-Google-Smtp-Source: APXvYqwp/EH6Ur2QGhQN9gAoRRiB/nJpoSiqieV+SAlyq4722fUPl9jhM5kLhCa86Aomekj/B2SnT/Jc8fHYaltd/GY=
X-Received: by 2002:adf:ec42:: with SMTP id w2mr21163913wrn.77.1557847439920;
 Tue, 14 May 2019 08:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
 <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
 <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
 <20190514070941.GE2589@hirez.programming.kicks-ass.net> <b8487de1-83a8-2761-f4a6-26c583eba083@oracle.com>
 <B447B6E8-8CEF-46FF-9967-DFB2E00E55DB@amacapital.net> <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
In-Reply-To: <4e7d52d7-d4d2-3008-b967-c40676ed15d2@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 14 May 2019 08:23:48 -0700
X-Gmail-Original-Message-ID: <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com>
Message-ID: <CALCETrXtwksWniEjiWKgZWZAyYLDipuq+sQ449OvDKehJ3D-fg@mail.gmail.com>
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 2:42 AM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
>
>
> On 5/14/19 10:34 AM, Andy Lutomirski wrote:
> >
> >
> >> On May 14, 2019, at 1:25 AM, Alexandre Chartre <alexandre.chartre@orac=
le.com> wrote:
> >>
> >>
> >>> On 5/14/19 9:09 AM, Peter Zijlstra wrote:
> >>>> On Mon, May 13, 2019 at 11:18:41AM -0700, Andy Lutomirski wrote:
> >>>> On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
> >>>> <alexandre.chartre@oracle.com> wrote:
> >>>>>
> >>>>> pcpu_base_addr is already mapped to the KVM address space, but this
> >>>>> represents the first percpu chunk. To access a per-cpu buffer not
> >>>>> allocated in the first chunk, add a function which maps all cpu
> >>>>> buffers corresponding to that per-cpu buffer.
> >>>>>
> >>>>> Also add function to clear page table entries for a percpu buffer.
> >>>>>
> >>>>
> >>>> This needs some kind of clarification so that readers can tell wheth=
er
> >>>> you're trying to map all percpu memory or just map a specific
> >>>> variable.  In either case, you're making a dubious assumption that
> >>>> percpu memory contains no secrets.
> >>> I'm thinking the per-cpu random pool is a secrit. IOW, it demonstrabl=
y
> >>> does contain secrits, invalidating that premise.
> >>
> >> The current code unconditionally maps the entire first percpu chunk
> >> (pcpu_base_addr). So it assumes it doesn't contain any secret. That is
> >> mainly a simplification for the POC because a lot of core information
> >> that we need, for example just to switch mm, are stored there (like
> >> cpu_tlbstate, current_task...).
> >
> > I don=E2=80=99t think you should need any of this.
> >
>
> At the moment, the current code does need it. Otherwise it can't switch f=
rom
> kvm mm to kernel mm: switch_mm_irqs_off() will fault accessing "cpu_tlbst=
ate",
> and then the page fault handler will fail accessing "current" before call=
ing
> the kvm page fault handler. So it will double fault or loop on page fault=
s.
> There are many different places where percpu variables are used, and I ha=
ve
> experienced many double fault/page fault loop because of that.

Now you're experiencing what working on the early PTI code was like :)

This is why I think you shouldn't touch current in any of this.

>
> >>
> >> If the entire first percpu chunk effectively has secret then we will
> >> need to individually map only buffers we need. The kvm_copy_percpu_map=
ping()
> >> function is added to copy mapping for a specified percpu buffer, so
> >> this used to map percpu buffers which are not in the first percpu chun=
k.
> >>
> >> Also note that mapping is constrained by PTE (4K), so mapped buffers
> >> (percpu or not) which do not fill a whole set of pages can leak adjace=
nt
> >> data store on the same pages.
> >>
> >>
> >
> > I would take a different approach: figure out what you need and put it =
in its
> > own dedicated area, kind of like cpu_entry_area.
>
> That's certainly something we can do, like Julian proposed with "Process-=
local
> memory allocations": https://lkml.org/lkml/2018/11/22/1240
>
> That's fine for buffers allocated from KVM, however, we will still need s=
ome
> core kernel mappings so the thread can run and interrupts can be handled.
>
> > One nasty issue you=E2=80=99ll have is vmalloc: the kernel stack is in =
the
> > vmap range, and, if you allow access to vmap memory at all, you=E2=80=
=99ll
> > need some way to ensure that *unmap* gets propagated. I suspect the
> > right choice is to see if you can avoid using the kernel stack at all
> > in isolated mode.  Maybe you could run on the IRQ stack instead.
>
> I am currently just copying the task stack mapping into the KVM page tabl=
e
> (patch 23) when a vcpu is created:
>
>         err =3D kvm_copy_ptes(tsk->stack, THREAD_SIZE);
>
> And this seems to work. I am clearing the mapping when the VM vcpu is fre=
ed,
> so I am making the assumption that the same task is used to create and fr=
ee
> a vcpu.
>

vCPUs are bound to an mm but not a specific task, right?  So I think
this is wrong in both directions.

Suppose a vCPU is created, then the task exits, the stack mapping gets
freed (the core code tries to avoid this, but it does happen), and a
new stack gets allocated at the same VA with different physical pages.
Now you're toast :)  On the flip side, wouldn't you crash if a vCPU is
created and then run on a different thread?

How important is the ability to enable IRQs while running with the KVM
page tables?
