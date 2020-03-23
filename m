Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D899918FA99
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgCWQ5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:57:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39098 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgCWQ5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:57:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id b22so7487188pgb.6
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 09:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tkNJ2UmLjV4ApEsFFknqUQDdSIA2E0Fh+l4Y3g/LsCM=;
        b=B39b0zc2oZZ5Gh0Ng85cQRtN1NaIkQzxq1N2LCaTr46l4HzUnn99DPUrggBOS6EP7q
         I78k8ss2qJvNARogQHChpSGHrI/bRnIRniHWxTkuXY7ryAOMSAWxMoMtSgfo4WZxduxe
         lnNlLOv+bEUyt47nbZ27SMg2titwDw0hRS+CCusOcrocy2/5CvJDAmU5s0gPxHD+OJ6K
         JvCqxtE4ybaT2rbh01S1qEI+CzkFXjYNe3NLD9VlQ0sbXni2GIx089dFEZEWs6DB0Sx1
         6L7mINAkMk+bs1aLvy0iciKtEhokUxJcpXzqoJEsONw8ZHwjvGbqgM4PGVfCZXzIAyJt
         UhYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tkNJ2UmLjV4ApEsFFknqUQDdSIA2E0Fh+l4Y3g/LsCM=;
        b=enlp0a7NlSF0Fz2nZvMLJSGcyvAgO69smNcoIkYdL/ehrZVHQ+xc9BsI5xzbzheAzT
         0J+Zc1b6k3GSGg877+Qp/H40c9u72WZPnGAE/6ifzIv0dtivBl6X8NFDzOt/dWEUHNyv
         WueyL/59Nj5vi7RLkmZgoxUmBtMXbqQ1D4GIOctcgt3kAYai3AyGpomsRfCtRHEWUtTv
         RN8T1wsoVkWV9fLZKPueR55mStp6xc0VCyQw0SqjQVTtndgyyhpC0OQPnZf+HkIBK83J
         MKldNlFAkKwaJ3WMMfq8gLgHIoyGos0bHndwFjkluuCgdZgwqxx6hWgdRsiQpUw1WOX2
         pJHw==
X-Gm-Message-State: ANhLgQ2y8dTfgQ54BLg6rYsbuIT2ikX5ehtutfUVOdvos5A8xwP+uNx3
        c8TIWMidspH6iR0CXaglY4xsIo6Hv3lh7Jr07K8IzQ==
X-Google-Smtp-Source: ADFU+vvIOUp1V6KsMC/3na/2JsKBqlMueF1nZsdGXm5tMw0c2pQvaZDOD8yMa9n7Zm6XKP1Q/Os5aAwOti3QeyDL+lg=
X-Received: by 2002:aa7:8b54:: with SMTP id i20mr24735682pfd.39.1584982663685;
 Mon, 23 Mar 2020 09:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000277a0405a16bd5c9@google.com> <CACT4Y+b1WFT87pWQaXD3CWjyjoQaP1jcycHdHF+rtxoR5xW1ww@mail.gmail.com>
 <5058aabe-f32d-b8ef-57ed-f9c0206304c5@redhat.com> <CAG_fn=WYtSoyi63ACaz-ya=Dbi+BFU-_mADDpL6gQvDimQscmw@mail.gmail.com>
 <20200323163925.GP28711@linux.intel.com>
In-Reply-To: <20200323163925.GP28711@linux.intel.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 23 Mar 2020 09:57:32 -0700
Message-ID: <CAKwvOdkE8OAu=Gj4MKWwpctka6==6EtrbF3e1tvF=jS2hBB3Ow@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in handle_external_interrupt_irqoff
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Alexander Potapenko <glider@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+3f29ca2efb056a761e38@syzkaller.appspotmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 23, 2020 at 9:39 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Mar 23, 2020 at 05:31:15PM +0100, Alexander Potapenko wrote:
> > On Mon, Mar 23, 2020 at 9:18 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > >
> > > On 22/03/20 07:59, Dmitry Vyukov wrote:
> > > >
> > > > The commit range is presumably
> > > > fb279f4e238617417b132a550f24c1e86d922558..63849c8f410717eb2e6662f3953ff674727303e7
> > > > But I don't see anything that says "it's me". The only commit that
> > > > does non-trivial changes to x86/vmx seems to be "KVM: VMX: check
> > > > descriptor table exits on instruction emulation":
> > >
> > > That seems unlikely, it's a completely different file and it would only
> > > affect the outside (non-nested) environment rather than your own kernel.
> > >
> > > The only instance of "0x86" in the registers is in the flags:
> > >
> > > > RSP: 0018:ffffc90001ac7998 EFLAGS: 00010086
> > > > RAX: ffffc90001ac79c8 RBX: fffffe0000000000 RCX: 0000000000040000
> > > > RDX: ffffc9000e20f000 RSI: 000000000000b452 RDI: 000000000000b453
> > > > RBP: 0000000000000ec0 R08: ffffffff83987523 R09: ffffffff811c7eca
> > > > R10: ffff8880a4e94200 R11: 0000000000000002 R12: dffffc0000000000
> > > > R13: fffffe0000000ec8 R14: ffffffff880016f0 R15: fffffe0000000ecb
> > > > FS:  00007fb50e370700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 000000000000005c CR3: 0000000092fc7000 CR4: 00000000001426f0
> > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > >
> > > That would suggest a miscompilation of the inline assembly, which does
> > > push the flags:
> > >
> > > #ifdef CONFIG_X86_64
> > >                 "mov %%" _ASM_SP ", %[sp]\n\t"
> > >                 "and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
> > >                 "push $%c[ss]\n\t"
> > >                 "push %[sp]\n\t"
> > > #endif
> > >                 "pushf\n\t"
> > >                 __ASM_SIZE(push) " $%c[cs]\n\t"
> > >                 CALL_NOSPEC
> > >
> > >
> > > It would not explain why it suddenly started to break, unless the clang
> > > version also changed, but it would be easy to ascertain and fix (in
> > > either KVM or clang).  Dmitry, can you send me the vmx.o and
> > > kvm-intel.ko files?
> >
> > On a quick glance, Clang does not miscompile this part.
>
> Clang definitely miscompiles the asm, the indirect call operates on the
> EFLAGS value, not on @entry as expected.  It looks like clang doesn't honor
> ASM_CALL_CONSTRAINT, which effectively tells the compiler that %rsp is
> getting clobbered, e.g. the "mov %r14,0x8(%rsp)" is loading @entry for
> "callq *0x8(%rsp)", which breaks because of asm's pushes.
>
> clang:
>
>         kvm_before_interrupt(vcpu);
>
>         asm volatile(
> ffffffff811b798e:       4c 89 74 24 08          mov    %r14,0x8(%rsp)
> ffffffff811b7993:       48 89 e0                mov    %rsp,%rax
> ffffffff811b7996:       48 83 e4 f0             and    $0xfffffffffffffff0,%rsp
> ffffffff811b799a:       6a 18                   pushq  $0x18
> ffffffff811b799c:       50                      push   %rax
> ffffffff811b799d:       9c                      pushfq
> ffffffff811b799e:       6a 10                   pushq  $0x10
> ffffffff811b79a0:       ff 54 24 08             callq  *0x8(%rsp) <--------- calls the EFLAGS value
> kvm_after_interrupt():
>
>
> gcc:
>         kvm_before_interrupt(vcpu);
>
>         asm volatile(
> ffffffff8118e17c:       48 89 e0                mov    %rsp,%rax
> ffffffff8118e17f:       48 83 e4 f0             and    $0xfffffffffffffff0,%rsp
> ffffffff8118e183:       6a 18                   pushq  $0x18
> ffffffff8118e185:       50                      push   %rax
> ffffffff8118e186:       9c                      pushfq
> ffffffff8118e187:       6a 10                   pushq  $0x10
> ffffffff8118e189:       ff d3                   callq  *%rbx <-------- calls @entry
> kvm_after_interrupt():

Thanks for this analysis, it looks like this is dependent on some
particular configuration; here's clang+defconfig+CONFIG_KVM_INTEL=y:

   0x000000000000528f <+127>:   pushq  $0x18
   0x0000000000005291 <+129>:   push   %rcx
   0x0000000000005292 <+130>:   pushfq
   0x0000000000005293 <+131>:   pushq  $0x10
   0x0000000000005295 <+133>:   callq  *%rax

-- 
Thanks,
~Nick Desaulniers
