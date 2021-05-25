Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3080438F773
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 03:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhEYBSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 21:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhEYBSx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 21:18:53 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656B9C061574;
        Mon, 24 May 2021 18:17:22 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id u11so28788691oiv.1;
        Mon, 24 May 2021 18:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CezQ2GSvrIo6tikClGRI6z7Z2arV574QOxZvufIrmpk=;
        b=m2Ok2OMA4sNq0PAnrAummNbrn98SN3PADUmgIdodgNY7xWtv9WYSQZ9yaHj+QDimrj
         +jUfidDG7zNH4Wbsv5Z1t41JQD5nZKq+/ycBo460Qwe+4hsdrQcgAHqhzDiiuMp50uwu
         0jTmjVSiCAAqcALz8VYJcvphSCUX0p3TH78s451Ql6O9nczrX19nVZrSRrFarRxYWXCS
         QezDpJTv3/y2rSZ/DTxWRUpSBqjP/bTbY8/K9H6xjZz8qC2rFyV1HLjF+WtsNTFaTnta
         8/KZDlkA/E/0FuQYCjwBit7fLlYI5IGHoqRkChLMECRZTSPjpm6mZwMjwnoZlJAIIhHH
         PyZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CezQ2GSvrIo6tikClGRI6z7Z2arV574QOxZvufIrmpk=;
        b=jEFB6ld5hdsBUS4npcA/RPERdaWo8oNNDo6ZPercQp4qRSqkxeWDKqmx1C4krJW+XP
         cXGzmnZqOtfwpgjkw2QGKTeo1gQv2w7lL9wke8AN+Wlc2ClSdT35DAXv2plx3XdUkol+
         mc1+SwYNJqB0av/dxrt89Jc1AkFlGgTo5ruX8CDEJmqALJrCKJ/y6nUX+XxpFIM/KmJL
         pUrSBuu6jc/oFLXmaXbMSjxKSv/9SyH0Z6QhtJFTUli9NJH2KtLThWhNvo+Oy8lIM7Nn
         nLKLKusI02edrLnReeU+nR2CHOG/xkpQFCC/YDFCrRpHsv8cT86J8Z90abQEwPaWaNtO
         FhQw==
X-Gm-Message-State: AOAM5312NABX/v5DAn81Hakc7+XtfPAYC1JF0GwKFwJuwhVT/LLrcQla
        +VkJoXsR4+YAJYcsnwvUtVDShVBxUiEPvFx7Ano=
X-Google-Smtp-Source: ABdhPJzNBW2xftdbiej4FwZYmhsVlqV1ZNFE2CFYlYD2LCpNJUhHK5FaEhfJKmEPMvCgAlJS1COEnpc9h6ykobQPnG4=
X-Received: by 2002:a05:6808:206:: with SMTP id l6mr1117371oie.5.1621905441784;
 Mon, 24 May 2021 18:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <1621830954-31963-1-git-send-email-wanpengli@tencent.com> <YKvHFbPfGnaQ4huw@google.com>
In-Reply-To: <YKvHFbPfGnaQ4huw@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 25 May 2021 09:17:10 +0800
Message-ID: <CANRm+CyA=p+_bsP=3vZXMKnCqYKvE0rNR4xEfE6nUyg5Dmznyg@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Fix warning caused by stale emulation context
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 May 2021 at 23:32, Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, May 23, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Reported by syzkaller:
> >
> >   WARNING: CPU: 7 PID: 10526 at /home/kernel/ssd/linux/arch/x86/kvm//x86.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]
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
> > Commit 4a1e10d5b5d8c (KVM: x86: handle hardware breakpoints during emulation())
> > adds hardware breakpoints check before emulation the instruction and parts of
> > emulation context initialization, actually we don't have EMULTYPE_NO_DECODE flag
> > here and the emulation context will not be reused. Commit c8848cee74ff (KVM: x86:
> > set ctxt->have_exception in x86_decode_insn()) triggers the warning because it
> > catches the stale emulation context has #UD, however, it is not during instruction
> > decoding which should result in EMULATION_FAILED. This patch fixes it by moving
> > the second part emulation context initialization before hardware breakpoints check.
> >
> > syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000
> >
> > Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
> > Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/x86.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index bbc4e04..eca69f9 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7552,6 +7552,13 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
> >
> >       init_emulate_ctxt(vcpu);
> >
> > +     ctxt->interruptibility = 0;
> > +     ctxt->have_exception = false;
> > +     ctxt->exception.vector = -1;
> > +     ctxt->perm_ok = false;
>
> What about moving this block all the way into init_emulate_ctxt()?
>
> > +     ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
>
> This can be left where it is since ctxt->ud is consumed only by x86_decode_insn().
> I don't have a strong preference as it really only matters for the backport.  For
> upstream, we can kill it off in a follow-up patch by passing emulation_type to
> x86_decode_insn() and dropping ctxt->ud altogether.  Tracking that info in ctxt
> for literally one call is silly.

Good suggestion, will do in v2.

    Wanpeng
