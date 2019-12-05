Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6658B113F2E
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 11:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbfLEKQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 05:16:20 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41377 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbfLEKQU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 05:16:20 -0500
Received: by mail-qt1-f196.google.com with SMTP id v2so2994988qtv.8
        for <kvm@vger.kernel.org>; Thu, 05 Dec 2019 02:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5K3iSfguK9BgLZmuNv+P78rfwEAvYBwmmPVubK0s/pU=;
        b=lCZ22bHzgt5kpBC9O6jPqAKgkhjGIQobnqGoJRzGTE90z5sZbBQhcrTLXtFcemHhB2
         Rg6cHalQvuAg0CIGToyD3T1xZXTb8k08Xh/1ZXrZfMLT6UwzJTzrWHYUV3cRRsMl9xPd
         e2lg4dNPpTTrEainmBfCe3YWqbVqS2qeYG0Nik6vGzaNGrFbe12HLZZYeSLDGc8yczVq
         K2LGYznvnziZpgOoBDpITggU3BXGsdLpk9EFF28TtBghesL8yDOXMt+EAiYCuONfcNpA
         hNkCtewjlvVS5UvMzp8S1YY2cKnjX69xWEx0oGyaM3qO8U9AuNswgHen3fj/MgNdK9d4
         7GcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5K3iSfguK9BgLZmuNv+P78rfwEAvYBwmmPVubK0s/pU=;
        b=qf7g9OE1DogbmucEro/SKcyS9FaQDy7dHelUe5rvF+1r7z0yPNYyF+pzBkEXZUVyzV
         na1tsTPinxF2BJwRqtqbY+n+ThXmsB86RyUOXe90fkhx+mIg4INpghr+agm/eq3vnOcI
         iWkjleND0pGvjQwU+bza+t0cFTOnP65IvLgfMw+UBr9utl3aHGk8eTEvAYEEWfwI3ZEM
         Nw2jH6WRP0U1F76JJ7m/Kac9lwlv+qEVUz2Te2ibQXYQdHIKz7+wxgAG4vshKl+86EPP
         S5oMqh/SCwyR/fWp1Ylv8rYR3Bwv7Y9pQ11ArkjqDnwRQnPfS7L+1rId4DnN0yZ/Fj2I
         7VPw==
X-Gm-Message-State: APjAAAWN77h7TT/sPJdmYxbBqcuf22v4EaDEhl3RrtuQUL7KMqK1FOzG
        xj8Ul76ZORyskzvMW2TCHk3nrZjOB0qO5SRwFWyOog==
X-Google-Smtp-Source: APXvYqzKqDCCc0kbBiNwk/8CDZ3khjRTfsJD5k2PvUhdgdLt8YCzmfSIZLXTyRfa9Tebhhcml+smc9OpBFFXQlE1Yqk=
X-Received: by 2002:ac8:2489:: with SMTP id s9mr6779647qts.257.1575540979068;
 Thu, 05 Dec 2019 02:16:19 -0800 (PST)
MIME-Version: 1.0
References: <0000000000003e640e0598e7abc3@google.com> <41c082f5-5d22-d398-3bdd-3f4bf69d7ea3@redhat.com>
In-Reply-To: <41c082f5-5d22-d398-3bdd-3f4bf69d7ea3@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 5 Dec 2019 11:16:08 +0100
Message-ID: <CACT4Y+bCHOCLYF+TW062n8+tqfK9vizaRvyjUXNPdneciq0Ahg@mail.gmail.com>
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

On Thu, Dec 5, 2019 at 11:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 04/12/19 22:41, syzbot wrote:
> > syzbot has bisected this bug to:
> >
> > commit 2de50e9674fc4ca3c6174b04477f69eb26b4ee31
> > Author: Russell Currey <ruscur@russell.cc>
> > Date:   Mon Feb 8 04:08:20 2016 +0000
> >
> >     powerpc/powernv: Remove support for p5ioc2
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127a042ae00000
> > start commit:   76bb8b05 Merge tag 'kbuild-v5.5' of
> > git://git.kernel.org/p..
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=117a042ae00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=167a042ae00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=dd226651cb0f364b
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=4455ca3b3291de891abc
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11181edae00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105cbb7ae00000
> >
> > Reported-by: syzbot+4455ca3b3291de891abc@syzkaller.appspotmail.com
> > Fixes: 2de50e9674fc ("powerpc/powernv: Remove support for p5ioc2")
> >
> > For information about bisection process see:
> > https://goo.gl/tpsmEJ#bisection
> >
>
> Why is everybody being CC'd, even if the bug has nothing to do with the
> person's subsystem?

The To list should be intersection of 2 groups of emails: result of
get_maintainers.pl on the file identified as culprit in the crash
message + emails extracted from the bisected to commit.
