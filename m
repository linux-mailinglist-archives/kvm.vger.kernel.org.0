Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C033938D5
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 00:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbhE0Wz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 18:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbhE0Wz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 18:55:28 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF26C061574;
        Thu, 27 May 2021 15:53:53 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id r1-20020a4aa2c10000b029023e8c840a7fso487874ool.12;
        Thu, 27 May 2021 15:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+EJ6sxZg+iZq5SyACwpFG7jwil6kjli0sk5B+eWOAW0=;
        b=ZdrzkPsL9jz1a2+fMy6IC2ulimh2PMpaprPQ9gjyGRhiRgVs7/WD1iaWgL0qh+Hkxy
         OQku0AYABivHaoPhy6F55jPNiEc2/kEfOgTk8tpPnTuS9G/cHfN1/Sx1xERZ9CN2I//F
         wb3xFVCpDASwbqBuddOvRznC3s8yqudhVB4HlF+x1zNtGq6JNC7paeIOQPJEmz+NbzPH
         JkIvf1mZmVhF0asriZfYyYQIYqoGnJvBJqRhbkJfIBx05fQ+b5qr4JHKvM0mTpTWNcam
         0DMhuaf59jmy/GfsA2DXGx/5xh/glY1duqijrN0Bt8mqm0PqRAn5W7OtR6QfhcORn2T6
         1ZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+EJ6sxZg+iZq5SyACwpFG7jwil6kjli0sk5B+eWOAW0=;
        b=gVQU9AvIOBX1NUzJcEhKoKcOq98qbxgDEV0Y8dCQtuJpiGFiWXzGS2KipC2xNysJHu
         qdu6dLNqC+ewnqvMHyyurcznYno3EQe5eXt+btlGcJfAORDWGVtNLosjBCNXgDmg6XK/
         nTngFpcAbB3kK8k958whIFr83zII6MtrucVqD1hGqQTC8AkcygtwI1d/eb6eRLP4WJSh
         kjgoi01B4kLnZaSGnmQF09v1HA9RZeBA8tfLOzrESNKM9ohXMpvr6/D2M9tl/vi11NGH
         VH0wLA3+GELLfkLUGnTYGEjGA1EIfVb+3Nj8HMWuPkGaS5t0qSorLiCJA0NnNQTes5o8
         q6Ew==
X-Gm-Message-State: AOAM532NlqoBJuGYXbqn5y8fsCPbTuIpwRfmUne6q3XaZVFR87eoovDe
        wYiGFjkfIM6uenc+M5PvMxLdK7gdSwFle8CMD58=
X-Google-Smtp-Source: ABdhPJxcBm4s9gtJLmJ8g0BCl8pHtkb2zVuw9bw7z9dQuvMCu9ncGe1IBFNEgTK9lf/Mck0s2WJ08wTl73IsC92wlBQ=
X-Received: by 2002:a4a:d41a:: with SMTP id n26mr4667143oos.66.1622156032883;
 Thu, 27 May 2021 15:53:52 -0700 (PDT)
MIME-Version: 1.0
References: <1622091679-31683-1-git-send-email-wanpengli@tencent.com> <YK/Q7ESa44lcqlMM@google.com>
In-Reply-To: <YK/Q7ESa44lcqlMM@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 28 May 2021 06:53:41 +0800
Message-ID: <CANRm+Cxy+jfuB8nop=EB6cdvqUAE5QuaeBTQW3BunJADmQXz1w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: X86: Fix warning caused by stale emulation context
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 May 2021 at 01:03, Sean Christopherson <seanjc@google.com> wrote=
:
>
> On Wed, May 26, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Reported by syzkaller:
> >
> >   WARNING: CPU: 7 PID: 10526 at /home/kernel/ssd/linux/arch/x86/kvm//x8=
6.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]
>
> "/home/kernel/ssd/linux/" can be omitted to make the line length a bit sh=
orter.
> checkpatch also complains about using absolute path instead of relative p=
ath.
>
> >   RIP: 0010:x86_emulate_instruction+0x41b/0x510 [kvm]
> >   Call Trace:
> >    kvm_mmu_page_fault+0x126/0x8f0 [kvm]
> >    vmx_handle_exit+0x11e/0x680 [kvm_intel]
> >    vcpu_enter_guest+0xd95/0x1b40 [kvm]
> >    kvm_arch_vcpu_ioctl_run+0x377/0x6a0 [kvm]
> >    kvm_vcpu_ioctl+0x389/0x630 [kvm]
> >    __x64_sys_ioctl+0x8e/0xd0
> >    do_syscall_64+0x3c/0xb0
> >    entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > Commit 4a1e10d5b5d8c (KVM: x86: handle hardware breakpoints during emul=
ation())
> > adds hardware breakpoints check before emulation the instruction and pa=
rts of
> > emulation context initialization, actually we don't have the EMULTYPE_N=
O_DECODE flag
> > here and the emulation context will not be reused. Commit c8848cee74ff =
(KVM: x86:
> > set ctxt->have_exception in x86_decode_insn()) triggers the warning bec=
ause it
> > catches the stale emulation context has #UD, however, it is not during =
instruction
> > decoding which should result in EMULATION_FAILED. This patch fixes it b=
y moving
> > the second part emulation context initialization into init_emulate_ctxt=
() and
> > before hardware breakpoints check.
> >
> > syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=3D134683fdd=
00000
> >
> > Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
> > Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emula=
tion)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v2 -> v3:
> >  * squash ctxt->ud
> > v1 -> v2:
> >  * move the second part emulation context initialization into init_emul=
ate_ctxt()
> >
> >  arch/x86/kvm/x86.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index bbc4e04..ae47b19 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7226,6 +7226,13 @@ static void init_emulate_ctxt(struct kvm_vcpu *v=
cpu)
> >       BUILD_BUG_ON(HF_SMM_MASK !=3D X86EMUL_SMM_MASK);
> >       BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK !=3D X86EMUL_SMM_INSIDE_NMI_M=
ASK);
> >
> > +     ctxt->interruptibility =3D 0;
> > +     ctxt->have_exception =3D false;
> > +     ctxt->exception.vector =3D -1;
> > +     ctxt->perm_ok =3D false;
> > +
> > +     ctxt->ud =3D emulation_type & EMULTYPE_TRAP_UD;
>
> "ctxt->ud" should be left where it is in patch 01.  "emulation_type" isn'=
t passed

I misunderstand your "squashed in" in reply to v2, it seems it should
be not moving "ctxt->ud".

> to init_emulate_ctxt(), and I don't see any reason to add it to the param=
s since
> ctxt->ud is only consumed by x86_decode_insn(), i.e. moving ctxt->ud isn'=
t
> necessary to fix the bug.
>
> arch/x86/kvm/x86.c: In function =E2=80=98init_emulate_ctxt=E2=80=99:
> arch/x86/kvm/x86.c:7236:13: error: =E2=80=98emulation_type=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98exception_type=E2=
=80=99?
>  7236 |  ctxt->ud =3D emulation_type & EMULTYPE_TRAP_UD;
>       |             ^~~~~~~~~~~~~~
>       |             exception_type
> arch/x86/kvm/x86.c:7236:13: note: each undeclared identifier is reported =
only once for each function it appears in
>
> > +
> >       init_decode_cache(ctxt);
> >       vcpu->arch.emulate_regs_need_sync_from_vcpu =3D false;
> >  }
> > @@ -7561,13 +7568,6 @@ int x86_decode_emulated_instruction(struct kvm_v=
cpu *vcpu, int emulation_type,
> >           kvm_vcpu_check_breakpoint(vcpu, &r))
> >               return r;
> >
> > -     ctxt->interruptibility =3D 0;
> > -     ctxt->have_exception =3D false;
> > -     ctxt->exception.vector =3D -1;
> > -     ctxt->perm_ok =3D false;
> > -
> > -     ctxt->ud =3D emulation_type & EMULTYPE_TRAP_UD;
> > -
> >       r =3D x86_decode_insn(ctxt, insn, insn_len);
> >
> >       trace_kvm_emulate_insn_start(vcpu);
> > --
> > 2.7.4
> >
