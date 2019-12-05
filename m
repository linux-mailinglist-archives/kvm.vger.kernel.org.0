Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE012113F62
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 11:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfLEKbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 05:31:40 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:41732 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728707AbfLEKbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 05:31:40 -0500
Received: by mail-qv1-f66.google.com with SMTP id b18so1073321qvo.8
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 02:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AIwfFBjY5pjo/AwQlYLo1XDjqkJbAe8kAMyvBg+3yAM=;
        b=eYZMat2HE3FLjyOA43FqB/w1GkyQ6frF+j0XPKrIc1es0ljwtwwex1ueuRIGRIMTBZ
         uD+v4Pu8j72Kr9PWzQSPmIJG+vAutrUoXY/DlvJLqYzq5Mb/MQS4MLbL7d8bKQHe1CLm
         /obGnlsvGr3IPK2Vijtfo13yPAeYuZFUYqQkYHaAeMoqlrCkVVKjcDjzVsYKs3oi/E8k
         b+AnNdv8b+VIdUWVko0227dY1YSR3tuiDGqWP2ttdlmRuhCA6DLLr4suNNTt1QEYRlE9
         nBUheeQUAyU8L/9eU7qRmuCPsDRs7GTa8MiaTjkR0yLps1RW1cvnWRVFxTxEORtDL2EI
         xkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AIwfFBjY5pjo/AwQlYLo1XDjqkJbAe8kAMyvBg+3yAM=;
        b=jk3y62e2eJLp2Hqj6NcVYXFNDXRkAscztyaY72WPawapbt2Ds3L0Nk76pQohpAdJrL
         PBqIxNklPzGqb+wKonGqN6Y2kWtt/u+BCPnMHfbxHjBraVVCFVsqJyOan2JQvHChKRkO
         4ZrCKOCBXU9lVTter0a/qJiwj6OiCV8tmweW8N9DXJZ2EQKzvIradIgck1xmegQP2PbA
         0rPQg4xwkxaH7w7EJdAoESsUnFOqsWUx4jkLvkgnJQl/OVpgrf8IKYONO2iFYQAvOrMq
         NMzDe2lSujEsCOhZPQ0PIx9pOhYDi56eNzbEUGRGg4Y6P/7gcKDLtzRHXO7tKU0iNjPF
         dRsg==
X-Gm-Message-State: APjAAAWt9C5zFrOuOPnEVoFMMq6u5ivANCB4W8dDW2MiDbc6+6v3Xqhd
        KQwRmSKYDxhyKPBOTN3Sf07x1786yGGH+05OlqoGRg==
X-Google-Smtp-Source: APXvYqzUwvRfklGx7jn2Qx5E8Ckootk5Q7YtZLTMNHA7rrZOeakEoQMPUMd3z45mweABnO/Dvphg9v6UIqE2DS3Vf+k=
X-Received: by 2002:a0c:f8d1:: with SMTP id h17mr6889518qvo.80.1575541898628;
 Thu, 05 Dec 2019 02:31:38 -0800 (PST)
MIME-Version: 1.0
References: <0000000000003e640e0598e7abc3@google.com> <41c082f5-5d22-d398-3bdd-3f4bf69d7ea3@redhat.com>
 <CACT4Y+bCHOCLYF+TW062n8+tqfK9vizaRvyjUXNPdneciq0Ahg@mail.gmail.com> <f4db22f2-53a3-68ed-0f85-9f4541530f5d@redhat.com>
In-Reply-To: <f4db22f2-53a3-68ed-0f85-9f4541530f5d@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 5 Dec 2019 11:31:27 +0100
Message-ID: <CACT4Y+ZHCmTu4tdfP+iCswU3r6+_NBM9M-pAZEypVSZ9DEq3TQ@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in fbcon_get_font
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     syzbot <syzbot+4455ca3b3291de891abc@syzkaller.appspotmail.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI <dri-devel@lists.freedesktop.org>, ghalat@redhat.com,
        Gleb Natapov <gleb@kernel.org>, gwshan@linux.vnet.ibm.com,
        "H. Peter Anvin" <hpa@zytor.com>, James Morris <jmorris@namei.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        KVM list <kvm@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Russell Currey <ruscur@russell.cc>,
        Sam Ravnborg <sam@ravnborg.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, stewart@linux.vnet.ibm.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 5, 2019 at 11:22 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/12/19 11:16, Dmitry Vyukov wrote:
> > On Thu, Dec 5, 2019 at 11:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 04/12/19 22:41, syzbot wrote:
> >>> syzbot has bisected this bug to:
> >>>
> >>> commit 2de50e9674fc4ca3c6174b04477f69eb26b4ee31
> >>> Author: Russell Currey <ruscur@russell.cc>
> >>> Date:   Mon Feb 8 04:08:20 2016 +0000
> >>>
> >>>     powerpc/powernv: Remove support for p5ioc2
> >>>
> >>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127a042ae00000
> >>> start commit:   76bb8b05 Merge tag 'kbuild-v5.5' of
> >>> git://git.kernel.org/p..
> >>> git tree:       upstream
> >>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=117a042ae00000
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=167a042ae00000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=dd226651cb0f364b
> >>> dashboard link:
> >>> https://syzkaller.appspot.com/bug?extid=4455ca3b3291de891abc
> >>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11181edae00000
> >>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105cbb7ae00000
> >>>
> >>> Reported-by: syzbot+4455ca3b3291de891abc@syzkaller.appspotmail.com
> >>> Fixes: 2de50e9674fc ("powerpc/powernv: Remove support for p5ioc2")
> >>>
> >>> For information about bisection process see:
> >>> https://goo.gl/tpsmEJ#bisection
> >>>
> >>
> >> Why is everybody being CC'd, even if the bug has nothing to do with the
> >> person's subsystem?
> >
> > The To list should be intersection of 2 groups of emails: result of
> > get_maintainers.pl on the file identified as culprit in the crash
> > message + emails extracted from the bisected to commit.
>
> Ah, and because the machine is a KVM guest, kvm_wait appears in a lot of
> backtrace and I get to share syzkaller's joy every time. :)

I don't see any mention of "kvm" in the crash report. And it's only 1
file, not all of them, in this case I would expect it to be
drivers/video/fbdev/core/fbcon.c. So it should be something different.

> This bisect result is bogus, though Tetsuo found the bug anyway.
> Perhaps you can exclude commits that only touch architectures other than
> x86?

We do this. It work sometimes. But sometimes it hits non-deterministic
kernel build bugs:
https://github.com/google/syzkaller/issues/1271#issuecomment-559093018
And in this case it hit some git bisect weirdness which I can't explain yet:
https://github.com/google/syzkaller/issues/1527
