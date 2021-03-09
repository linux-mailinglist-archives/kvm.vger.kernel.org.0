Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B01331F8F
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 07:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhCIGzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 01:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhCIGzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 01:55:06 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDFCC06175F
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 22:55:06 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id z128so11992952qkc.12
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 22:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f2bPry4S6r4S3ID+ZCMhgKWwpmYkYjT1/OMlDvwgN7I=;
        b=i59nqI12fvQaDTn9BFQQmaloLPN4PCiy/BAI006cnsmPI2df7d2SjT3Rm95TzeZzPY
         UWhkkkl+xF5WydVZkYvip5iN5pgr6kL5VSDt39TRsyTYbdHEpnyOhHabdv2XJ1fhD1Jf
         x26AjtAU18EHDhcc1W+9GJwTAEqxbQGklGhJNvB/jfm/ZUgBQMjBYBbpvLvEOoZ6HgTu
         n9fMkTLQkc9wDWUqF7CQoMT3A4Nv0NYKEt/K+qK4mDoIPKTI9yPZUn7mmdEugOrYwa/h
         hLxmNnplX3/FuIf+hYHgkBBj7thj3h85hb81o3NHlRFUqrkkwzZ59fLuAH591OO+LOfw
         heEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f2bPry4S6r4S3ID+ZCMhgKWwpmYkYjT1/OMlDvwgN7I=;
        b=Wdcb3NGY1tc854sR8jmjhbr/R1vr8mzMPpFjlpbP1FB2TSjm1CNLeWm75zmqg+C72t
         EGfwmXzBEyxo5f8xeSab5aHDbLYyukuaZTcPtL+DwIZw+lU66+PzV+h4UjSDKwACYdvF
         LUYMn8CIuCRdwSZh+G636pEkOHDGfvbbigms4E76EOiwyxFp8zZxLoDxjfrrE4Ezp5Qe
         Gbc42KKLMSIEDoSLlFqAzVitF95ZOySGgcSkfhCnx6+Rf0xbQeETLrfeA+8ypkeSw5PF
         zIGOETM/koPuMxDtHMPCO9xhR6he1kuiYisPZgqAdSn56dKEpmAsUWRSy53Lmn32EC7N
         XfIw==
X-Gm-Message-State: AOAM533QuMIjt9oHqfQyBfYhrxhYS4t/3QxPnFzOvnYBaQJTJGBDUt9O
        T4SNWgOBqPQqUz15janTA6hP8bzdVoEpwUikOEkt1Q==
X-Google-Smtp-Source: ABdhPJw8nsZO+P6qauJC8mSb2Mq7A/sNOQMzN2CkBC6GJXldRqq2hpGDo7HTgf6evQ0UdM1jyaigT7bLmxnw+CVPIP4=
X-Received: by 2002:a05:620a:410f:: with SMTP id j15mr24557038qko.424.1615272905098;
 Mon, 08 Mar 2021 22:55:05 -0800 (PST)
MIME-Version: 1.0
References: <0000000000003912cf05bd0cdd75@google.com> <YEazSAsa2l6KQZwL@google.com>
In-Reply-To: <YEazSAsa2l6KQZwL@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 9 Mar 2021 07:54:54 +0100
Message-ID: <CACT4Y+bwjEv_EQgk8KDNYO0W7iOkeeUBUarzzd-NOZ0FZcPSRw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in kvm_wait
To:     Sean Christopherson <seanjc@google.com>
Cc:     syzbot <syzbot+3c2bc6358072ede0f11b@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 9, 2021 at 12:29 AM 'Sean Christopherson' via
syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
>
> On Mon, Mar 08, 2021, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    a38fd874 Linux 5.12-rc2
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14158fdad00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=db9c6adb4986f2f2
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3c2bc6358072ede0f11b
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1096d35cd00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16bf1e52d00000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+3c2bc6358072ede0f11b@syzkaller.appspotmail.com
>
> Wanpeng has a patch posted to fix this[*], is there a way to retroactively point
> syzbot at that fix?
>
> [*] https://lkml.kernel.org/r/1614057902-23774-1-git-send-email-wanpengli@tencent.com

Great! Yes, it can be communicated to syzbot with:

#syz fix: x86/kvm: Fix broken irq restoration in kvm_wait

For details see: http://bit.do/syzbot#communication-with-syzbot
