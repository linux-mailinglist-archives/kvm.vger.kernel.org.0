Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9A93938E4
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 01:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhE0XFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 19:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbhE0XFL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 19:05:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97286C061574;
        Thu, 27 May 2021 16:03:37 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l1so2567111ejb.6;
        Thu, 27 May 2021 16:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S9besEpmPZmfRI3aBf2tbBwcQShTomayh485iY22oVA=;
        b=oUWb+S9PbFqilEYFBHn/Z4KzrfSY6rB+h6crboBnNCYufx5Ta4+0SvKfjpdZBEcfMH
         XtfZjtfuJ58kVrC2AcgnAQs+mCV1OSF7PeZtw/Kx1cUreyNxEnFORHtTdkFKq+0JIsvz
         p5HNpFmtVPYHZEvRSHEoGGj4tKbl17PZ97fNP6sX4F2EoVWAMehS9Xoi4qSRNA/EW4Lk
         GMkUxVbxmBzZRKyMzjGQrsAKPAiR2DdAf1lJ+3lPDM5qXeGUNPpsTuFRzZhwidbcSZwB
         sKUaBQldWyNN+49i6tt3+tp/zlOlWebBkefQiuWclZTobLC4qakJv8loK1inHrDmvWqD
         SvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S9besEpmPZmfRI3aBf2tbBwcQShTomayh485iY22oVA=;
        b=hY2KbdEnhTGEd3YUzHAXsF+O/jUworlJzHhnIfNaZsQZ+Vw09TV7onJ/b2lud54biI
         HfBPNtSEGXZyFUF6US8vhO9uTuE5oQF+pWy2fgLDNNGIRc6/vlD8jALfMtSZCUN8hUYX
         0MOfFuI927vmsN/JLyXktyCtdDV9gRg20kYmmbjMErLgL2gvhfW2dZ3mvX3QR0UiNP7/
         L9ltTSbA+nMcQIIfRxqMDiQYFYAWOftqK4Cc2+DedN9qbPUUJP1MIwF6ct0dshGKhdnw
         rVQlVNLhrqWm7VeniZis4jCzF8y4xE41kmYQrIKccOREBtHHHHktG0Ss3PmfGYAtKC34
         TDWw==
X-Gm-Message-State: AOAM532qTB5WL9tyoUIY6tAQeKJ1a4AtkIRWxb6yojRoy+Ydpb1tzvhI
        fr2gK3EdnZofficMt/sMX59FoaY2d+UDTKNd9nw=
X-Google-Smtp-Source: ABdhPJzZLL54J01xv+oFJrTdTOOm2zwkQnYQxL9UUVADFG1eA0OFVodZarOeSMKwIjXPQQtukXV3RQT9X9MouM1E+U8=
X-Received: by 2002:a17:906:f285:: with SMTP id gu5mr6402516ejb.226.1622156615069;
 Thu, 27 May 2021 16:03:35 -0700 (PDT)
MIME-Version: 1.0
References: <1622091679-31683-1-git-send-email-wanpengli@tencent.com> <YK/Q7ESa44lcqlMM@google.com>
In-Reply-To: <YK/Q7ESa44lcqlMM@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 28 May 2021 07:03:24 +0800
Message-ID: <CANRm+CwL-uS3FPZxpW_cB=vdD4WKLRDPTpd4hsn57eWpKZ_CtQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] KVM: X86: Fix warning caused by stale emulation context
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

On Fri, 28 May 2021 at 01:03, Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, May 26, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Reported by syzkaller:
> >
> >   WARNING: CPU: 7 PID: 10526 at /home/kernel/ssd/linux/arch/x86/kvm//x86.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]
>
> "/home/kernel/ssd/linux/" can be omitted to make the line length a bit shorter.
> checkpatch also complains about using absolute path instead of relative path.
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
> > Commit 4a1e10d5b5d8c (KVM: x86: handle hardware breakpoints during emulation())
> > adds hardware breakpoints check before emulation the instruction and parts of
> > emulation context initialization, actually we don't have the EMULTYPE_NO_DECODE flag
> > here and the emulation context will not be reused. Commit c8848cee74ff (KVM: x86:
> > set ctxt->have_exception in x86_decode_insn()) triggers the warning because it
> > catches the stale emulation context has #UD, however, it is not during instruction
> > decoding which should result in EMULATION_FAILED. This patch fixes it by moving
> > the second part emulation context initialization into init_emulate_ctxt() and
> > before hardware breakpoints check.
> >
> > syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000
> >
> > Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
> > Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v2 -> v3:
> >  * squash ctxt->ud
> > v1 -> v2:
> >  * move the second part emulation context initialization into init_emulate_ctxt()
> >
> >  arch/x86/kvm/x86.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index bbc4e04..ae47b19 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7226,6 +7226,13 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
> >       BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
> >       BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
> >
> > +     ctxt->interruptibility = 0;
> > +     ctxt->have_exception = false;
> > +     ctxt->exception.vector = -1;
> > +     ctxt->perm_ok = false;
> > +
> > +     ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
>
> "ctxt->ud" should be left where it is in patch 01.  "emulation_type" isn't passed
> to init_emulate_ctxt(), and I don't see any reason to add it to the params since
> ctxt->ud is only consumed by x86_decode_insn(), i.e. moving ctxt->ud isn't
> necessary to fix the bug.

How about this?

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bbc4e04..dba8077 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7226,6 +7226,11 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
        BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
        BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);

+       ctxt->interruptibility = 0;
+       ctxt->have_exception = false;
+       ctxt->exception.vector = -1;
+       ctxt->perm_ok = false;
+
        init_decode_cache(ctxt);
        vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
 }
@@ -7561,11 +7566,6 @@ int x86_decode_emulated_instruction(struct
kvm_vcpu *vcpu, int emulation_type,
            kvm_vcpu_check_breakpoint(vcpu, &r))
                return r;

-       ctxt->interruptibility = 0;
-       ctxt->have_exception = false;
-       ctxt->exception.vector = -1;
-       ctxt->perm_ok = false;
-
        ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;

        r = x86_decode_insn(ctxt, insn, insn_len);
