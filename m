Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A28C818BB38
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 16:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgCSPgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 11:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbgCSPgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 11:36:13 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1635D21556
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584632172;
        bh=p/B+fhi7kTckDWuDXt2TkHFiBI1WQNcNA2Sa0G/Pzkk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kDtEIJR+zlEaQ/No+7kRn4gYAD3sfU2FohOc6I6bLex8EKbRZ+YiNu5pKvs8E4Dz+
         y1kTaB6IzP0VvgIVn7CnlGmTQKijL05V4UIwcb8uBS/RdloqjAAsyyP+qTCKfZoZBN
         u9YvM1HKyem8L7u8RA9ZyHUpN5AZ7WyKdzwXgpx0=
Received: by mail-wm1-f52.google.com with SMTP id c187so2961003wme.1
        for <kvm@vger.kernel.org>; Thu, 19 Mar 2020 08:36:12 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2KcxP2dztPC0DKUx2n6cPCTk965/5STX87cspTAwX8kSa/eeqq
        7cc1U+xu06a0wUmy/DY/tVEgzrEVLuf69LVUON6Jaw==
X-Google-Smtp-Source: ADFU+vsYJk1iHN4pEM4zZ66rCnKS3xMKlbrb8V+A2LRCAZxaX77pLeIiTvN2Ikuq0ELD0wy47MEn9E4nb4r2hME/0yY=
X-Received: by 2002:a1c:b0c3:: with SMTP id z186mr4272698wme.36.1584632170436;
 Thu, 19 Mar 2020 08:36:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200319091407.1481-1-joro@8bytes.org> <20200319091407.1481-71-joro@8bytes.org>
In-Reply-To: <20200319091407.1481-71-joro@8bytes.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 19 Mar 2020 08:35:59 -0700
X-Gmail-Original-Message-ID: <CALCETrUOQneBHjoZkP-7T5PDijb=WOyv7xF7TD0GLR2Aw77vyA@mail.gmail.com>
Message-ID: <CALCETrUOQneBHjoZkP-7T5PDijb=WOyv7xF7TD0GLR2Aw77vyA@mail.gmail.com>
Subject: Re: [PATCH 70/70] x86/sev-es: Add NMI state tracking
To:     Joerg Roedel <joro@8bytes.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 2:14 AM Joerg Roedel <joro@8bytes.org> wrote:
>
> From: Joerg Roedel <jroedel@suse.de>
>
> Keep NMI state in SEV-ES code so the kernel can re-enable NMIs for the
> vCPU when it reaches IRET.

IIRC I suggested just re-enabling NMI in C from do_nmi().  What was
wrong with that approach?

> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +SYM_CODE_START(sev_es_iret_user)
> +       UNWIND_HINT_IRET_REGS offset=8
> +       /*
> +        * The kernel jumps here directly from
> +        * swapgs_restore_regs_and_return_to_usermode. %rsp points already to
> +        * trampoline stack, but %cr3 is still from kernel. User-regs are live
> +        * except %rdi. Switch to user CR3, restore user %rdi and user gs_base
> +        * and single-step over IRET
> +        */
> +       SWITCH_TO_USER_CR3_STACK scratch_reg=%rdi
> +       popq    %rdi
> +       SWAPGS
> +       /*
> +        * Enable single-stepping and execute IRET. When IRET is
> +        * finished the resulting #DB exception will cause a #VC
> +        * exception to be raised. The #VC exception handler will send a
> +        * NMI-complete message to the hypervisor to re-open the NMI
> +        * window.

This is distressing to say the least.  The sequence if events is, roughly:

1. We're here with NMI masking in an unknown state because do_nmi()
and any nested faults could have done IRET, at least architecturally.
NMI could occur or it could not.  I suppose that, on SEV-ES, as least
on current CPUs, NMI is definitely masked.  What about on newer CPUs?
What if we migrate?

> +        */
> +sev_es_iret_kernel:
> +       pushf
> +       btsq $X86_EFLAGS_TF_BIT, (%rsp)
> +       popf

Now we have TF on, NMIs (architecturally) in unknown state.

> +       iretq

This causes us to pop the NMI frame off the stack.  Assuming the NMI
restart logic is invoked (which is maybe impossible?), we get #DB,
which presumably is actually delivered.  And we end up on the #DB
stack, which might already have been in use, so we have a potential
increase in nesting.  Also, #DB may be called from an unexpected
context.

Now somehow #DB is supposed to invoke #VC, which is supposed to do the
magic hypercall, and all of this is supposed to be safe?  Or is #DB
unconditionally redirected to #VC?  What happens if we had no stack
(e.g. we interrupted SYSCALL) or we were already in #VC to begin with?

I think there are two credible ways to approach this:

1. Just put the NMI unmask in do_nmi().  The kernel *already* knows
how to handle running do_nmi() with NMIs unmasked.  This is much, much
simpler than your code.

2. Have an entirely separate NMI path for the
SEV-ES-on-misdesigned-CPU case.  And have very clear documentation for
what prevents this code from being executed on future CPUs (Zen3?)
that have this issue fixed for real?

This hybrid code is no good.

--Andy
