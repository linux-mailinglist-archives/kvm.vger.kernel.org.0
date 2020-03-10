Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4BB1807C5
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 20:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCJTQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 15:16:33 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40568 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgCJTQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 15:16:33 -0400
Received: by mail-io1-f66.google.com with SMTP id d8so13959499ion.7
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 12:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vO89uoO5QFEj26FcgeL9MRe8fkoMwwnb528wy1OTkc=;
        b=LAfP0hGQ0JuxYo8FTEA0i3H/1JOBcoZRvOfSkkqjFMYYbErI0YmtorhG+RNj7YoamJ
         2V7pb5SCnc+YIaXwSIkHeAqRrbrIVNeMlr1KYu7tdNnZ6HFF1m+xTrQu+pGh86sJ/is8
         ycTfRunjcDBZQPiJEz4kUGogwlR22da1vbtCHXxV8PiZ9jelJDQCf0zVdMKbMnks84z/
         QSUgC+0IJzGMyq7kLiHLooMY39MAQaHofcj6CcUeL29h5/VibdR2kqPnguOujIil4rG0
         CPuez0SYuzn3XcRLn03A9FnrBEsYu0ZmiCs0GMvtCx0dbD66/U/ETdSIuat5ib60zF5r
         J2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vO89uoO5QFEj26FcgeL9MRe8fkoMwwnb528wy1OTkc=;
        b=YdJh4Ohi7B/epCzqea47gOSVGxr7t41nDEXW+ZPDwrqWccmLsxC/9VZAB5QyOQKoWV
         ZDkefmYc9fJjlJ5vrnk8BwTrzrGdBWLjaXran8BpztbJZdivQcZSqYh1EdyIdGk9uY38
         LcYhxFtgNC0tKQq/aiWnZu2wWGtYbgWqOhrfN0/QRwGsm97nHYuj3h9x13efKXWLfvuB
         EBfahhb2uxByXmh+zi5YErsgDjsbkxxjVJYTP0UkPG5PE1eC2Xx7N4wloW6iXPyLWd1d
         jxb98JHuddXSymILdrp4i4ciev9ttN6LVtggZtBvzRHvS8XtiX1bGshkjAqEk0Jq7+QY
         wr4w==
X-Gm-Message-State: ANhLgQ1sp6exAb0gYRcEgpwVMND56288YkHQcvijGxwz+rj7aCAzFIAb
        HJfsqJcIM+qgboN7dtgQumFF50jawQuHDZM7WOMMVi58
X-Google-Smtp-Source: ADFU+vuFsn5g5vu3QCGLo90YnmgsDX0H0Qo+WjzylqV1Mi7Y5oTv/hvp/jWe2q5gl2vS4bwf2hdSF9/prC7qDjOktng=
X-Received: by 2002:a02:3b24:: with SMTP id c36mr21615094jaa.23.1583867792379;
 Tue, 10 Mar 2020 12:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200310171024.15528-1-ubizjak@gmail.com> <20200310182422.GG9305@linux.intel.com>
In-Reply-To: <20200310182422.GG9305@linux.intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Tue, 10 Mar 2020 20:16:21 +0100
Message-ID: <CAFULd4Z6+LNORYOShsjixy9_7ntgzYjFGx0X0vGyM1-+7Zdw+g@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: access regs array in vmenter.S in its natural order
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 7:24 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Mar 10, 2020 at 06:10:24PM +0100, Uros Bizjak wrote:
> > Registers in "regs" array are indexed as rax/rcx/rdx/.../rsi/rdi/r8/...
> > Reorder access to "regs" array in vmenter.S to follow its natural order.
>
> Any reason other than preference?  I wouldn't exactly call the register
> indices "natural", e.g. IMO it's easier to visually confirm correctness if
> A/B/C/D are ordered alphabetically.

Yes. Looking at assembly, the offsets now increase nicely:

  71:   48 8b 48 08             mov    0x8(%rax),%rcx
  75:   48 8b 50 10             mov    0x10(%rax),%rdx
  79:   48 8b 58 18             mov    0x18(%rax),%rbx
  7d:   48 8b 68 28             mov    0x28(%rax),%rbp
  81:   48 8b 70 30             mov    0x30(%rax),%rsi
  85:   48 8b 78 38             mov    0x38(%rax),%rdi
  89:   4c 8b 40 40             mov    0x40(%rax),%r8
  8d:   4c 8b 48 48             mov    0x48(%rax),%r9
  91:   4c 8b 50 50             mov    0x50(%rax),%r10
  95:   4c 8b 58 58             mov    0x58(%rax),%r11
  99:   4c 8b 60 60             mov    0x60(%rax),%r12
  9d:   4c 8b 68 68             mov    0x68(%rax),%r13
  a1:   4c 8b 70 70             mov    0x70(%rax),%r14
  a5:   4c 8b 78 78             mov    0x78(%rax),%r15

and noticing that ptrace.c processes registers in the order of their
position in pt_regs, I was under impression that the current vmenter.S
order is some remnant of recent __asm to .S conversion.

For sure, I can happily live with current order, so not a big thing,
and the patch could be ignored without much fuss.

FYI, the original x86 registers were not named in alphabetical order.
Their names are explained in e.g. [1].

[1] https://en.wikibooks.org/wiki/X86_Assembly/X86_Architecture

>
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > ---
> >  arch/x86/kvm/vmx/vmenter.S | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 81ada2ce99e7..ca2065166d1d 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -135,12 +135,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >       cmpb $0, %bl
> >
> >       /* Load guest registers.  Don't clobber flags. */
> > -     mov VCPU_RBX(%_ASM_AX), %_ASM_BX
> >       mov VCPU_RCX(%_ASM_AX), %_ASM_CX
> >       mov VCPU_RDX(%_ASM_AX), %_ASM_DX
> > +     mov VCPU_RBX(%_ASM_AX), %_ASM_BX
> > +     mov VCPU_RBP(%_ASM_AX), %_ASM_BP
> >       mov VCPU_RSI(%_ASM_AX), %_ASM_SI
> >       mov VCPU_RDI(%_ASM_AX), %_ASM_DI
> > -     mov VCPU_RBP(%_ASM_AX), %_ASM_BP
> >  #ifdef CONFIG_X86_64
> >       mov VCPU_R8 (%_ASM_AX),  %r8
> >       mov VCPU_R9 (%_ASM_AX),  %r9
> > @@ -168,12 +168,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >
> >       /* Save all guest registers, including RAX from the stack */
> >       __ASM_SIZE(pop) VCPU_RAX(%_ASM_AX)
> > -     mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
> >       mov %_ASM_CX,   VCPU_RCX(%_ASM_AX)
> >       mov %_ASM_DX,   VCPU_RDX(%_ASM_AX)
> > +     mov %_ASM_BX,   VCPU_RBX(%_ASM_AX)
> > +     mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
> >       mov %_ASM_SI,   VCPU_RSI(%_ASM_AX)
> >       mov %_ASM_DI,   VCPU_RDI(%_ASM_AX)
> > -     mov %_ASM_BP,   VCPU_RBP(%_ASM_AX)
> >  #ifdef CONFIG_X86_64
> >       mov %r8,  VCPU_R8 (%_ASM_AX)
> >       mov %r9,  VCPU_R9 (%_ASM_AX)
> > @@ -197,12 +197,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >        * free.  RSP and RAX are exempt as RSP is restored by hardware during
> >        * VM-Exit and RAX is explicitly loaded with 0 or 1 to return VM-Fail.
> >        */
> > -1:   xor %ebx, %ebx
> > -     xor %ecx, %ecx
> > +1:   xor %ecx, %ecx
> >       xor %edx, %edx
> > +     xor %ebx, %ebx
> > +     xor %ebp, %ebp
> >       xor %esi, %esi
> >       xor %edi, %edi
> > -     xor %ebp, %ebp
> >  #ifdef CONFIG_X86_64
> >       xor %r8d,  %r8d
> >       xor %r9d,  %r9d
> > --
> > 2.24.1
> >
