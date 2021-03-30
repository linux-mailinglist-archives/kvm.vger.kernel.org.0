Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A43234DD98
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 03:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhC3BeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 21:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhC3BeE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 21:34:04 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E248CC061762;
        Mon, 29 Mar 2021 18:34:03 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 68-20020a9d0f4a0000b02901b663e6258dso14069595ott.13;
        Mon, 29 Mar 2021 18:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d3Jpagx3DhvHP/1KqfdL+Qn6Aesr5PznlWbZNZ/71p0=;
        b=u8IDKhGJkGoc1FKr0T4btNSrxT8GaCAz+MB2nDU04XFaZev53IWDSbawcc0ddCuVna
         V3K53nMstT6wG3VyOUf19IGUjKoH/FUXRWYZW9LeipF/BlaVYl17GBsQ04TiGQef+uub
         w+VF3H1nzAyOmR4bEUPE/AjroE5oMhDTohs6+Y8TflXfE/X3AYRnIR0ETbULZ6tey8WE
         6Rs58ZBoy4/liGjRWB8DfmwvW1uVU7YLVpXantv7HfggqQ16kCJlRZUU7uNfUi8QoQtd
         4BDUFA70qLSes3i+ocTiLaTvbi1qTzLSJF2NJYgBnRqzoOLrrl6v0HS9Z4gFeVDVUgR/
         gvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d3Jpagx3DhvHP/1KqfdL+Qn6Aesr5PznlWbZNZ/71p0=;
        b=VFoWI2ZQ8cs3hLWnqCG+7KJDaDCz4F2oPj+3fIQBs4aBCxV98nxL3Mm7rPVj3H3oQA
         Dio6I9QaxcxUjL/LZ5of+xM6sLL2HjDLoqSmxwyF0VypjI4onsOsGvCD7iAti79Wknc8
         Pt+eavZ00CzkPuK3BAzSD2P+e4Cen+v/DzfNgcI7mMF9gMI36ucBIuol4uSbBEzqxCIU
         Eqvi/lNyJchFsilPCoq4gH+OllJuxPUL4gh5J/pTrNbzz81lcS8D+86i9FshJCf+0rZc
         gLP0juR8L4/kKbEbFhLeQsBAMr+1ZvpZlGWl7CO57NxsTVDxdVt9DlUCzAsPsFjGkh47
         3Hsw==
X-Gm-Message-State: AOAM530+eIwQ86ORTKGT2XN1e/LxDUhDp+W9IIU06s5GO+VeEzdNA3AD
        808I9mFXQYqY1lKMylicsM/bB/S/Z94x5eSo+SY=
X-Google-Smtp-Source: ABdhPJyg/2vAyonkuB5bZTTHsXI4S8QOwTwh1Bj7Qv33RIsUA8ERrRlQv15OpWPxJcxNHhK2qd37w5CB9zXsRLyPQ9M=
X-Received: by 2002:a9d:470b:: with SMTP id a11mr24115745otf.254.1617068043225;
 Mon, 29 Mar 2021 18:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <1617011036-11734-1-git-send-email-wanpengli@tencent.com> <YGILHM7CHpjXtxaH@google.com>
In-Reply-To: <YGILHM7CHpjXtxaH@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 30 Mar 2021 09:33:51 +0800
Message-ID: <CANRm+CxXAt7z5H1v_Zpjg44Ka09eWc7gaJ7HRq9USUurjqrG3A@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Properly account for guest CPU time when
 considering context tracking
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Mar 2021 at 01:15, Sean Christopherson <seanjc@google.com> wrote:
>
> +Thomas
>
> On Mon, Mar 29, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=209831
> > reported that the guest time remains 0 when running a while true
> > loop in the guest.
> >
> > The commit 87fa7f3e98a131 ("x86/kvm: Move context tracking where it
> > belongs") moves guest_exit_irqoff() close to vmexit breaks the
> > tick-based time accouting when the ticks that happen after IRQs are
> > disabled are incorrectly accounted to the host/system time. This is
> > because we exit the guest state too early.
> >
> > vtime-based time accounting is tied to context tracking, keep the
> > guest_exit_irqoff() around vmexit code when both vtime-based time
> > accounting and specific cpu is context tracking mode active.
> > Otherwise, leave guest_exit_irqoff() after handle_exit_irqoff()
> > and explicit IRQ window for tick-based time accouting.
> >
> > Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
> > Cc: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 3 ++-
> >  arch/x86/kvm/vmx/vmx.c | 3 ++-
> >  arch/x86/kvm/x86.c     | 2 ++
> >  3 files changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 58a45bb..55fb5ce 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3812,7 +3812,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> >        * into world and some more.
> >        */
> >       lockdep_hardirqs_off(CALLER_ADDR0);
> > -     guest_exit_irqoff();
> > +     if (vtime_accounting_enabled_this_cpu())
> > +             guest_exit_irqoff();
> >
> >       instrumentation_begin();
> >       trace_hardirqs_off_finish();
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 32cf828..85695b3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6689,7 +6689,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> >        * into world and some more.
> >        */
> >       lockdep_hardirqs_off(CALLER_ADDR0);
> > -     guest_exit_irqoff();
> > +     if (vtime_accounting_enabled_this_cpu())
> > +             guest_exit_irqoff();
>
> This looks ok, as CONFIG_CONTEXT_TRACKING and CONFIG_VIRT_CPU_ACCOUNTING_GEN are
> selected by CONFIG_NO_HZ_FULL=y, and can't be enabled independently, e.g. the
> rcu_user_exit() call won't be delayed because it will never be called in the
> !vtime case.  But it still feels wrong poking into those details, e.g. it'll
> be weird and/or wrong guest_exit_irqoff() gains stuff that isn't vtime specific.

Could you elaborate what's the meaning of "it'll be weird and/or wrong
guest_exit_irqoff() gains stuff that isn't vtime specific."?

    Wanpeng
