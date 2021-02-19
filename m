Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179CC31F358
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 01:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhBSA3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 19:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhBSA3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 19:29:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04A0C64EDF
        for <kvm@vger.kernel.org>; Fri, 19 Feb 2021 00:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613694530;
        bh=XbsLoD79HzHQqly0S2VCaRsexsZhuulcwadlRryuFVI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EnEjMAplbBMgUU632l47b6HXvamYNlVa+mQE9mxN4F4s94i7qtxd+yapdnJScJDDq
         IXVBtGB+/LFTRSjADCif2XD+KpEXV8Dg70ZRZECSTl4iHUXZHMey0qS5KED3ATohJn
         C5cgquAM4QdQAIgdCNiBPZd7cvcD0iot1iUb89jJzbUCqzUxyUa4dvZPUveUdr055H
         Z4vBn2UIz7CkcYjOM0mISuooqMCrNrPMtmvurqGm/RN599eJCQ9b6Dfo5QH0g7p3i2
         uWtMcAqOqtG6+AiWtmGawtF+Q2FyQBFCSHshXf1L2tOGaMaXelCISBqBuWWHStjNDT
         SLENxy9qFpEyg==
Received: by mail-ed1-f49.google.com with SMTP id v22so6505585edx.13
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 16:28:49 -0800 (PST)
X-Gm-Message-State: AOAM530JBH0GTJf/B17g3NdzKAHwqLSYrh4So0EJb4onWwectQsxBvbq
        VgPkGSly5Ejsr6YznfRzPUskrHyzfC/W3Ysbeg+Zqg==
X-Google-Smtp-Source: ABdhPJx9Qwm+IMP0TSh4MJrTsmNPHFpGyuNNe6499NISrHkiZ2SBmP2qxLCKH+CtYfp41fQqlTZSqQIL14KE4DiEbFI=
X-Received: by 2002:a17:906:a44:: with SMTP id x4mr6276642ejf.101.1613694527433;
 Thu, 18 Feb 2021 16:28:47 -0800 (PST)
MIME-Version: 1.0
References: <20210217120143.6106-1-joro@8bytes.org> <20210217120143.6106-3-joro@8bytes.org>
 <CALCETrWw-we3O4_upDoXJ4NzZHsBqNO69ht6nBp3y+QFhwPgKw@mail.gmail.com>
 <20210218112500.GH7302@8bytes.org> <CALCETrUohqQPVTBJZZKh-pj=4aZrwDAu5UFSetj3k5pGLDPbkA@mail.gmail.com>
 <20210218192117.GL12716@suse.de>
In-Reply-To: <20210218192117.GL12716@suse.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 18 Feb 2021 16:28:36 -0800
X-Gmail-Original-Message-ID: <CALCETrUaOLwO51Js+OGNY03aep8BHoncZKTMr8sG1guUhLk40A@mail.gmail.com>
Message-ID: <CALCETrUaOLwO51Js+OGNY03aep8BHoncZKTMr8sG1guUhLk40A@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86/sev-es: Check if regs->sp is trusted before
 adjusting #VC IST stack
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021 at 11:21 AM Joerg Roedel <jroedel@suse.de> wrote:
>
> On Thu, Feb 18, 2021 at 09:49:06AM -0800, Andy Lutomirski wrote:
> > I don't understand what this means.  The whole entry mechanism on x86
> > is structured so that we call a C function *and return from that C
> > function without longjmp-like magic* with the sole exception of
> > unwind_stack_do_exit().  This means that you can match up enters and
> > exits, and that unwind_stack_do_exit() needs to unwind correctly.  In
> > the former case, it's normal C and we can use normal local variables.
> > In the latter case, we know exactly what state we're trying to restore
> > and we can restore it directly without any linked lists or similar.
>
> Okay, the unwinder will likely get confused by this logic.
>
> > What do you have in mind that requires a linked list?
>
> Cases when there are multiple IST vectors besides NMI that can hit while
> the #VC handler is still on its own IST stack. #MCE comes to mind, but
> that is broken anyway. At some point #VC itself will be one of them, but
> when that happens the code will kill the machine.
> This leaves #HV in the list, and I am not sure how that is going to be
> handled yet. I think the goal is that the #HV handler is not allowed to
> cause any #VC exception. In that case the linked-list logic will not be
> needed.

Can you give me an example, even artificial, in which the linked-list
logic is useful?

>
> > > I don't see how this would break, can you elaborate?
> > >
> > > What I think happens is:
> > >
> > > SYSCALL gap (RSP is from userspace and untrusted)
> > >
> > >         -> #VC - Handler on #VC IST stack detects that it interrupted
> > >            the SYSCALL gap and switches to the task stack.
> > >
> >
> > Can you point me to exactly what code you're referring to?  I spent a
> > while digging through the code and macro tangle and I can't find this.
>
> See the entry code in arch/x86/entry/entry_64.S, macro idtentry_vc. It
> creates the assembly code for the handler. At some point it calls
> vc_switch_off_ist(), which is a C function in arch/x86/kernel/traps.c.
> This function tries to find a new stack for the #VC handler.
>
> The first thing it does is checking whether the exception came from the
> SYSCALL gap and just uses the task stack in that case.
>
> Then it will check for other kernel stacks which are safe to switch
> to. If that fails it uses the fall-back stack (VC2), which will direct
> the handler to a separate function which, for now, just calls panic().
> Not safe are the entry or unknown stacks.

Can you explain your reasoning in considering the entry stack unsafe?
It's 4k bytes these days.

You forgot about entry_SYSCALL_compat.

Your 8-byte alignment is confusing to me.  In valid kernel code, SP
should be 8-byte-aligned already, and, if you're trying to match
architectural behavior, the CPU aligns to 16 bytes.

We're not robust against #VC, NMI in the #VC prologue before the magic
stack switch, and a new #VC in the NMI prologue.  Nor do we appear to
have any detection of the case where #VC nests directly inside its own
prologue.  Or did I miss something else here?

If we get NMI and get #VC in the NMI *asm*, the #VC magic stack switch
looks like it will merrily run itself in the NMI special-stack-layout
section, and that sounds really quite bad.

>
> The function then copies pt_regs and returns the new stack pointer to
> assembly code, which then writes it to %RSP.
>
> > Unless AMD is more magic than I realize, the MOV SS bug^Wfeature means
> > that #DB is *not* always called in safe places.
>
> You are right, forgot about this. The MOV SS bug can very well
> trigger a #VC(#DB) exception from the syscall gap.
>
> > > And with SNP we need to be able to at least detect a malicious HV so we
> > > can reliably kill the guest. Otherwise the HV could potentially take
> > > control over the guest's execution flow and make it reveal its secrets.
> >
> > True.  But is the rest of the machinery to be secure against EFLAGS.IF
> > violations and such in place yet?
>
> Not sure what you mean by EFLAGS.IF violations, probably enabling IRQs
> while in the #VC handler? The #VC handler _must_ _not_ enable IRQs
> anywhere in its call-path. If that ever happens it is a bug.
>

I mean that, IIRC, a malicious hypervisor can inject inappropriate
vectors at inappropriate times if the #HV mechanism isn't enabled.
For example, it could inject a page fault or an interrupt in a context
in which we have the wrong GSBASE loaded.

But the #DB issue makes this moot.  We have to use IST unless we turn
off SCE.  But I admit I'm leaning toward turning off SCE until we have
a solution that seems convincingly robust.
