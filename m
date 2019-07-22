Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2D66F87B
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 06:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfGVE2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 00:28:51 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39685 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfGVE2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 00:28:51 -0400
Received: by mail-ot1-f66.google.com with SMTP id r21so32777000otq.6;
        Sun, 21 Jul 2019 21:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u9bIll45IkEv61GnSgi6Wk39bsONFi+netx8AhCfi7w=;
        b=NHUxNR/FbcDIls4wN/7K5xWw6t8TG9WA5uwgNKY3twE8BQCdSpTorc48b0xlAnS14F
         qUf7KXocl2+7NbhgxJd/93i5J81zHxQH/vSasc6+aKGXME0g61VTCydf1sfZTyGkQi41
         du3UKdzrgvosoE3hO50QGf/6dVGjB9BfHLL7OMjoR7tnnZRRhZux2fYTAmF49Sz0VtSv
         Ykp6WapqR6L55lEqWd7lzmc9YCMJvZrVEQbiF+Q02NuT2HeOcmfY1NGXjIr0DGNHUkMN
         a3Im6biTl3Z/+kKKoSj64+QOG4Ah4XLhBUdUA36xDzxETxN4PPw3bzzQNbYRs7VCB4vh
         2urA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u9bIll45IkEv61GnSgi6Wk39bsONFi+netx8AhCfi7w=;
        b=Ykx0QjP1k4xxvpVsgucWns1cTR52mRGPcFAWT/8T1V15DmtA6ojMFRhlzGq6k4eB6n
         Gkv0b1l3be/okOErOeUVosgju0Di+yPeh2QDymkzXgMzcTk0djCleLMOe8cihUc64z3p
         /k/LEmD6PVynFjDHjOkEJgI7nvwYCvf614+zD4o8/PBvy4LO0z5Pzxq3o4bogOACSW2I
         NQbzLj0BXThL5WTGr8p3tgSkn7ow9pNJpS4U/t7l5boWD+5ZVwawc3lnSieyizhIvxqp
         lu1kIZZWvxtzs+Avi0Tvn7vAoQPoyBGfH0X2keFmc2QiuQMOgMO5mZG12mHQFj4qfi5v
         /Eww==
X-Gm-Message-State: APjAAAWccNWQWDWlTy4jQHDw44YrQciNUBj1zdiNKfokyHniuotFzBxx
        G9mqbgWSB/PhUx8cGZgXrj29Hgpripg4M8/Aa24=
X-Google-Smtp-Source: APXvYqyxpVloP1FtjqIXhMKYQbprE+yYhKEYjJOhaWjBcK4B/AL3PjudcWZ4D5hPMOwpbMl/tKjdl9D1Dt9gJ30lSqw=
X-Received: by 2002:a9d:2c47:: with SMTP id f65mr50830747otb.185.1563769730249;
 Sun, 21 Jul 2019 21:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <217248af-e980-9cb0-ff0d-9773413b9d38@thomaslambertz.de>
 <CANRm+CxWbkr0=DB7DBdaQOsTTt0XS5vSk_BRL2iFeAAm81H8Bg@mail.gmail.com> <3ae96202-a121-70a9-fe00-4b5bb4970242@redhat.com>
In-Reply-To: <3ae96202-a121-70a9-fe00-4b5bb4970242@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 22 Jul 2019 12:28:42 +0800
Message-ID: <CANRm+CwiLn-FUM89t-rg-9za-e28KX9XQo5zVs3_XAq+Ya_0vA@mail.gmail.com>
Subject: Re: [5.2 regression] x86/fpu changes cause crashes in KVM guest
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Lambertz <mail@thomaslambertz.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Rik van Riel <riel@surriel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Jul 2019 at 19:09, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/07/19 10:59, Wanpeng Li wrote:
> > https://lkml.org/lkml/2017/11/14/891, "The scheduler will save the
> > guest fpu context when a vCPU thread is preempted, and restore it when
> > it is scheduled back in." But I can't find any scheduler codes do
> > this.
>
> That's because applying commit 240c35a37 was completely wrong.  The idea
> before commit 240c35a37 was that you have the following FPU states:
>
>                userspace (QEMU)             guest
> ---------------------------------------------------------------------------
>                processor                    vcpu->arch.guest_fpu
> >>> KVM_RUN: kvm_load_guest_fpu
>                vcpu->arch.user_fpu          processor
> >>> preempt out
>                vcpu->arch.user_fpu          current->thread.fpu
> >>> preempt in
>                vcpu->arch.user_fpu          processor
> >>> back to userspace
> >>> kvm_put_guest_fpu
>                processor                    vcpu->arch.guest_fpu
> ---------------------------------------------------------------------------
>
> After removing user_fpu, QEMU's FPU state is destroyed when KVM_RUN is
> preempted.  So that's already messed up (I'll send a revert), and given
> the diagram above your patch makes total sense.
>
> With the new lazy model we want to hook into kvm_vcpu_arch_load and get
> the state back to the processor from current->thread.fpu, and indeed
> switch_fpu_return is essentially copy_kernel_to_fpregs(&current->thread.
> fpu->state).
>
> However I would keep the fpregs_assert_state_consistent in
> kvm_arch_vcpu_load, and also
> WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD)) in vcpu_enter_guest.

Looks good to me, just send out two patches rebase on the revert.

Regards,
Wanpeng Li
