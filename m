Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F266D2786D1
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 14:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbgIYMQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 08:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgIYMQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 08:16:32 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F23C0613D4
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 05:16:31 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id z18so1185238qvp.6
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 05:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yln7AR3ZR4p27n/j7+7xhsbcOtNwJrCtmwDsHN2fdUQ=;
        b=DzWU05b6w2zZiVHCrTpprsoQhBqCNrX3HmdPZzyihbcxzdqULiEJxSULmYcebb7VnB
         362O7PeU+3mlVppNYw1xEsrBaBo9tPocZsBewaSl6xhyp1cyVmpkFI13O2n11dfsQa6l
         vaGFGZUhQntMlUEE0uZY98lECN90iL4yOISZ3NwP50fC9GDjkfQmsx+vL9viYYiZo3Kd
         gtUUegf2EBm5w7CDKGP1iFq5Z1zlcJ3ylHQVbCb5jVvdZrWYGDKq+aCV6zSEZCuCUGSY
         LVXxUf8Inas33vLGk4Hn1bWTHt81cOqwStUeqbUcGTzQr4rvFnub1QQdiwTk75mq4jly
         l86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yln7AR3ZR4p27n/j7+7xhsbcOtNwJrCtmwDsHN2fdUQ=;
        b=VeCoMeXMieSeMgDt8NNlbLBuZIvxlEwS18M+3gnCGQuqaY9Py/+YojpOi9Rh5Lw5nM
         SRknMj6TnbLPdNrG5ByXdIj7iayrzmKLHqFU+UVt0KI+gG2znUM9eXyA5Dfcg64xJYrj
         i7MljoqemK22qbtkjdy9v+5ZsM8Mj0/gCSeQgDFK6TV03Fyzy6PLiAvqa0IMeFt3mqjs
         mmxLaKutX128f8QaQPjdfFOTyRz6ZG9OB5o04eC3VcZhc2WRfc3Dq2kY+tZQDeI0Zf79
         T5YMoQbSaWf5nlKk6KmHlAZy9PxRxIbZ3uIy6Wtov/xRGNEaNUjb91hjg0MNPrxYLMHR
         XGMw==
X-Gm-Message-State: AOAM531dh6cXIusgJ2L73sarRK59CkdS+h8NuViKi2fimw7BJXN+XSek
        kLQRx+iIjoSdXik1UgdWSvUvMPlp/hwTsni6nPqjYA==
X-Google-Smtp-Source: ABdhPJx9B2hS6GJWN+2kXk2lxO9y8nuAjLORtds3pD9dp9ZxvQFWebC9/7WeLieRBLfx2ZqQzgHT1ZycMDbLplaYZ+8=
X-Received: by 2002:ad4:47cc:: with SMTP id p12mr4045516qvw.26.1601036190515;
 Fri, 25 Sep 2020 05:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000002c37a605afce4504@google.com> <CACT4Y+ZMMu1o7HTjFYC++JYWQoEN3STMo38utqpmFRCkQy2u-Q@mail.gmail.com>
In-Reply-To: <CACT4Y+ZMMu1o7HTjFYC++JYWQoEN3STMo38utqpmFRCkQy2u-Q@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 25 Sep 2020 14:16:19 +0200
Message-ID: <CACT4Y+ak9rtau8E8doyP1Dwqq0fVm5J0fdZ8EGy3=mnUr0-Yiw@mail.gmail.com>
Subject: Re: general protection fault in pvclock_gtod_notify (2)
To:     syzbot <syzbot+1dccfcb049726389379c@syzkaller.appspotmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        "the arch/x86 maintainers" <x86@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 21, 2020 at 10:10 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Mon, Sep 21, 2020 at 10:02 AM syzbot
> <syzbot+1dccfcb049726389379c@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    eb5f95f1 Merge tag 's390-5.9-6' of git://git.kernel.org/pu..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14720ac3900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=cd992d74d6c7e62
> > dashboard link: https://syzkaller.appspot.com/bug?extid=1dccfcb049726389379c
> > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+1dccfcb049726389379c@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0x1ffffffef40f602c: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 1 PID: 3915 Comm: systemd-udevd Not tainted 5.9.0-rc5-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:update_pvclock_gtod arch/x86/kvm/x86.c:1743 [inline]
> > RIP: 0010:pvclock_gtod_notify+0x11d/0x490 arch/x86/kvm/x86.c:7452
> > Code: 10 48 89 f8 48 c1 e8 03 42 80 3c 20 00 74 05 e8 69 76 a7 00 49 8b 47 10 48 89 05 f6 08 cb 09 49 8d 7f 08 48 89 f8 48 c1 e8 03 <42> 80 3c 70 07 77 00 e8 47 76 a7 00 49 8b 47 08 48 89 05 dc 08 cb
> > RSP: 0018:ffffc90000da8c50 EFLAGS: 00010806
> > RAX: 1ffffffff1707d7e RBX: ffffffff894cc67c RCX: ffffffff815adc44
> > RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffffffff8b83ebf0
> > RBP: ffffffff894bd1a8 R08: dffffc0000000000 R09: fffffbfff167daa0
> > R10: fffffbfff167daa0 R11: 0000000000000000 R12: dffffc0000000000
> > R13: 00000000ffffffff R14: ffffffff814f7157 R15: ffffffff8b83ebe8
> > FS:  00007f7a9e2c88c0(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000744138 CR3: 00000000a256d000 CR4: 00000000001526e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <IRQ>
> >  notifier_call_chain kernel/notifier.c:83 [inline]
> >  __raw_notifier_call_chain kernel/notifier.c:361 [inline]
> >  raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:368
> >  update_pvclock_gtod kernel/time/timekeeping.c:581 [inline]
> >  timekeeping_update+0x281/0x3f0 kernel/time/timekeeping.c:675
> >  timekeeping_advance+0x830/0xa00 kernel/time/timekeeping.c:2122
> >  tick_sched_do_timer kernel/time/tick-sched.c:147 [inline]
> >  tick_sched_timer+0xba/0x410 kernel/time/tick-sched.c:1321
> >  __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
> >  __hrtimer_run_queues+0x42d/0x930 kernel/time/hrtimer.c:1588
> >  hrtimer_interrupt+0x373/0xd60 kernel/time/hrtimer.c:1650
> >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
> >  __sysvec_apic_timer_interrupt+0xf0/0x260 arch/x86/kernel/apic/apic.c:1097
> >  asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
> >  </IRQ>
> >  __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
> >  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
> >  sysvec_apic_timer_interrupt+0x94/0xf0 arch/x86/kernel/apic/apic.c:1091
> >  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
> > RIP: 0010:___might_sleep+0x60/0x570 kernel/sched/core.c:7265
> > Code: ff ff e8 e3 d2 d9 06 85 c0 74 1f c6 05 49 10 39 08 01 48 c7 c7 2a 87 09 89 be 61 1c 00 00 48 c7 c2 11 89 09 89 e8 90 a4 08 00 <e8> 4b d5 d9 06 85 c0 74 3d 80 3d 22 10 39 08 00 75 34 48 c7 c7 20
> > RSP: 0018:ffffc900011f7b08 EFLAGS: 00000246
> > RAX: 0000000000000000 RBX: 0000000000000c40 RCX: dffffc0000000000
> > RDX: 0000000000000000 RSI: ffffffff894fe578 RDI: 0000000000000282
> > RBP: ffff8880aa440900 R08: dffffc0000000000 R09: fffffbfff167da9f
> > R10: fffffbfff167da9f R11: 0000000000000000 R12: 0000000000001000
> > R13: 0000000000000c40 R14: 0000000000000000 R15: 0000000000000000
> >  cache_alloc_debugcheck_before mm/slab.c:2984 [inline]
> >  slab_alloc mm/slab.c:3302 [inline]
> >  __do_kmalloc mm/slab.c:3653 [inline]
> >  __kmalloc+0x94/0x300 mm/slab.c:3664
> >  kmalloc include/linux/slab.h:559 [inline]
> >  tomoyo_realpath_from_path+0xd8/0x630 security/tomoyo/realpath.c:254
> >  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
> >  tomoyo_path_perm+0x17d/0x740 security/tomoyo/file.c:822
> >  security_inode_getattr+0xc0/0x140 security/security.c:1278
> >  vfs_getattr fs/stat.c:121 [inline]
> >  vfs_statx+0x118/0x380 fs/stat.c:206
> >  vfs_lstat include/linux/fs.h:3178 [inline]
> >  __do_sys_newlstat fs/stat.c:374 [inline]
> >  __se_sys_newlstat fs/stat.c:368 [inline]
> >  __x64_sys_newlstat+0x81/0xd0 fs/stat.c:368
> >  do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > RIP: 0033:0x7f7a9d13b335
> > Code: 69 db 2b 00 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 83 ff 01 48 89 f0 77 30 48 89 c7 48 89 d6 b8 06 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 03 f3 c3 90 48 8b 15 31 db 2b 00 f7 d8 64 89
> > RSP: 002b:00007fff5eaa2608 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
> > RAX: ffffffffffffffda RBX: 0000564636a00770 RCX: 00007f7a9d13b335
> > RDX: 00007fff5eaa2640 RSI: 00007fff5eaa2640 RDI: 00005646369ff770
> > RBP: 00007fff5eaa2700 R08: 00007f7a9d3fa178 R09: 0000000000001010
> > R10: 0000000000000020 R11: 0000000000000246 R12: 00005646369ff770
> > R13: 00005646369ff790 R14: 00005646369a42bb R15: 00005646369a42c0
> > Modules linked in:
> > ---[ end trace 4ff96b4858c23e64 ]---
> > RIP: 0010:update_pvclock_gtod arch/x86/kvm/x86.c:1743 [inline]
> > RIP: 0010:pvclock_gtod_notify+0x11d/0x490 arch/x86/kvm/x86.c:7452
> > Code: 10 48 89 f8 48 c1 e8 03 42 80 3c 20 00 74 05 e8 69 76 a7 00 49 8b 47 10 48 89 05 f6 08 cb 09 49 8d 7f 08 48 89 f8 48 c1 e8 03 <42> 80 3c 70 07 77 00 e8 47 76 a7 00 49 8b 47 08 48 89 05 dc 08 cb
> > RSP: 0018:ffffc90000da8c50 EFLAGS: 00010806
> > RAX: 1ffffffff1707d7e RBX: ffffffff894cc67c RCX: ffffffff815adc44
> > RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffffffff8b83ebf0
> > RBP: ffffffff894bd1a8 R08: dffffc0000000000 R09: fffffbfff167daa0
> > R10: fffffbfff167daa0 R11: 0000000000000000 R12: dffffc0000000000
> > R13: 00000000ffffffff R14: ffffffff814f7157 R15: ffffffff8b83ebe8
> > FS:  00007f7a9e2c88c0(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000744138 CR3: 00000000a256d000 CR4: 00000000001526e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> The failure mode looks somewhat similar to:
> general protection fault in perf_misc_flags
> https://syzkaller.appspot.com/bug?extid=ce179bc99e64377c24bc
> https://groups.google.com/g/syzkaller-bugs/c/d5GC1V8S34k/m/6LTarP8mBAAJ
>
> only clang, gpf in systems code, happened few times

There is strong indication that this is a manifestation of the same
problem we see in other crashes.
Let's make one canonical bug for this:

#syz dup: general protection fault in perf_misc_flags
