Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFED18BBE3
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 17:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgCSQHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 12:07:53 -0400
Received: from 8bytes.org ([81.169.241.247]:53886 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgCSQHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 12:07:53 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 2F7C1217; Thu, 19 Mar 2020 17:07:51 +0100 (CET)
Date:   Thu, 19 Mar 2020 17:07:49 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 70/70] x86/sev-es: Add NMI state tracking
Message-ID: <20200319160749.GC5122@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-71-joro@8bytes.org>
 <CALCETrUOQneBHjoZkP-7T5PDijb=WOyv7xF7TD0GLR2Aw77vyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUOQneBHjoZkP-7T5PDijb=WOyv7xF7TD0GLR2Aw77vyA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andy,

On Thu, Mar 19, 2020 at 08:35:59AM -0700, Andy Lutomirski wrote:
> On Thu, Mar 19, 2020 at 2:14 AM Joerg Roedel <joro@8bytes.org> wrote:
> >
> > From: Joerg Roedel <jroedel@suse.de>
> >
> > Keep NMI state in SEV-ES code so the kernel can re-enable NMIs for the
> > vCPU when it reaches IRET.
> 
> IIRC I suggested just re-enabling NMI in C from do_nmi().  What was
> wrong with that approach?

If I understand the code correctly a nested NMI will just reset the
interrupted NMI handler to start executing again at 'restart_nmi'.
The interrupted NMI handler could be in the #VC handler, and it is not
safe to just jump back to the start of the NMI handler from somewhere
within the #VC handler.

So I decided to not allow NMI nesting for SEV-ES and only re-enable the
NMI window when the first NMI returns. This is not implemented in this
patch, but I will do that once Thomas' entry-code rewrite is upstream.

> This causes us to pop the NMI frame off the stack.  Assuming the NMI
> restart logic is invoked (which is maybe impossible?), we get #DB,
> which presumably is actually delivered.  And we end up on the #DB
> stack, which might already have been in use, so we have a potential
> increase in nesting.  Also, #DB may be called from an unexpected
> context.

An SEV-ES hypervisor is required to intercept #DB, which means that the
#DB exception actually ends up being a #VC exception. So it will not end
up on the #DB stack.

> Now somehow #DB is supposed to invoke #VC, which is supposed to do the
> magic hypercall, and all of this is supposed to be safe?  Or is #DB
> unconditionally redirected to #VC?  What happens if we had no stack
> (e.g. we interrupted SYSCALL) or we were already in #VC to begin with?

Yeah, as I said above, the #DB is redirected to #VC, as the hypervisor
has to intercept #DB.

The stack-problem is the one that prevents the Single-step-over-iret
approach right now, because the NMI can hit while in kernel mode and on
entry stack, which the generic entry code (besided NMI) does not handle.
Getting a #VC exception there (like after an IRET to that state) breaks
things.

Last, in this version of the patch-set the #VC handler became
nesting-safe. It detects whether the per-cpu GHCB is in use and
safes/restores its contents in this case.


> I think there are two credible ways to approach this:
> 
> 1. Just put the NMI unmask in do_nmi().  The kernel *already* knows
> how to handle running do_nmi() with NMIs unmasked.  This is much, much
> simpler than your code.

Right, and I thought about that, but the implication is that the
complexity is moved somewhere else, namely into the #VC handler, which
then has to be restartable.

> 2. Have an entirely separate NMI path for the
> SEV-ES-on-misdesigned-CPU case.  And have very clear documentation for
> what prevents this code from being executed on future CPUs (Zen3?)
> that have this issue fixed for real?

That sounds like a good alternative, I will investigate this approach.
The NMI handler should be much simpler as it doesn't need to allow NMI
nesting. The question is, does the C code down the NMI path depend on
the NMI handlers stack frame layout (e.g. the in-nmi flag)?

Regards,

	Joerg
