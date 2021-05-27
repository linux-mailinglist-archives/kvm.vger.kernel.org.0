Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BEB3926B3
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 07:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhE0FDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 01:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbhE0FDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 01:03:12 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA42C061574;
        Wed, 26 May 2021 22:01:38 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 69-20020a9d0a4b0000b02902ed42f141e1so3288898otg.2;
        Wed, 26 May 2021 22:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DIK2MOYtXTz8u/COwFfkEUBc1F17aIjpQwkU8e8HnG4=;
        b=hovM366yPdOjJhudKnIBOrLFHbGxlKMe4kde9ZZEtCyhdQSIy0GY44P5SWYFwG4rqt
         ykxKk8ISwJ7m5mBdp+bfdmiqbq77F95dma9zswVifgjavO10CwVjitOjhPAp+sdrXdhm
         46zgNNIQBVw37ptR8UUS7iMJCusslA0DMwJspzj1pmLiplCOZ3z1xh4oDtAqEGrdGewe
         X9YlWcNEXR4xNnj4dU7C4JCbajb3mxKah9xZe84gg3zNFk32zwcFHiwjnEJrG3G4YBBw
         gXK5njeVgT2K320YTmQ8lpLzekMHJqXtJ/LoULGtwl2Zyex8bDXrqnjpdxHOTrpS8G65
         BoTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DIK2MOYtXTz8u/COwFfkEUBc1F17aIjpQwkU8e8HnG4=;
        b=gWkZfEH6mDjH1ZrQS4GioKJs5VD1ABAs56+VnXjcMevUpVnhzX4vYuDLfgNn+inSOg
         mWK5aJPE0IIbqCIDhVFPK5ChA4dEqXgZto1j/3m6SrcyXBIkHuN4fMRgoXV3CfLtETl8
         4Wi89Q7ms9/9IR18AeTSvNuKmedICvbL5AMMT7FETKOJduGJHFfXlonhndNXEKUYeYM3
         hidhfFe46bI9oxp/Az4/NQUuc9sxnvQTLr8R+4FzNEE9uf3GcZsGxKBtLlE58zF/7vgO
         nsHF7E/QujrahSNgW07a/YeY3y8sLhfZYaJgCbv1rLQTHLp3sh0TFlCt84XrEOo6aM8Z
         WRyw==
X-Gm-Message-State: AOAM533dqvtKU+hb5/VViGtCUYgUngJuY6zNIfyUDl+e9ISrRh2GziGD
        omDq6uij85wf20NkwV/DQNPbEP0Xh0h0B6JTo5A=
X-Google-Smtp-Source: ABdhPJy3zn9EMrhIm28+FpEzc47MCQ+tfLr43fPZTRroAGEhnk3DKyn1eo1OADbJ6r32Gf8RbEZlSWm4LGoUOxLwsog=
X-Received: by 2002:a9d:4b0e:: with SMTP id q14mr1316258otf.254.1622091698046;
 Wed, 26 May 2021 22:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <1621911767-11703-1-git-send-email-wanpengli@tencent.com> <YK6Ky7+QJUZjO0DT@google.com>
In-Reply-To: <YK6Ky7+QJUZjO0DT@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 27 May 2021 13:01:26 +0800
Message-ID: <CANRm+CxaDUKOx7OFEREi76DHBuX0kZhjbh4D1SKjLUtvxjdJUA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: X86: Fix warning caused by stale emulation context
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

On Thu, 27 May 2021 at 01:52, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, May 24, 2021, Wanpeng Li wrote:
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
> > emulation context initialization, actually we don't have the EMULTYPE_NO_DECODE flag
> > here and the emulation context will not be reused. Commit c8848cee74ff (KVM: x86:
> > set ctxt->have_exception in x86_decode_insn()) triggers the warning because it
> > catches the stale emulation context has #UD, however, it is not during instruction
> > decoding which should result in EMULATION_FAILED. This patch fixes it by moving
> > the second part emulation context initialization into init_emulate_ctxt() and
> > before hardware breakpoints check. The ctxt->ud will be dropped by a follow-up
> > patch.
> >
> > syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000
> >
> > Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
> > Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v1 -> v2:
> >  * move the second part emulation context initialization into init_emulate_ctxt()
> >
> >  arch/x86/kvm/x86.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index bed7b53..3c109d3 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7228,6 +7228,11 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
> >       BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
> >       BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
> >
> > +     ctxt->interruptibility = 0;
> > +     ctxt->have_exception = false;
> > +     ctxt->exception.vector = -1;
> > +     ctxt->perm_ok = false;
> > +
> >       init_decode_cache(ctxt);
> >       vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
> >  }
> > @@ -7554,6 +7559,8 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
> >
> >       init_emulate_ctxt(vcpu);
> >
> > +     ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
>
> Heh, you sent the delta relative to v1.  To avoid confusion, can you post v3
> with this squashed in?

Do it in v3.

    Wanpeng
