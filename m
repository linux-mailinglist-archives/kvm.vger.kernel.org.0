Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D861176C6
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 13:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfEHLZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 07:25:15 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:35528 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbfEHLZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 07:25:14 -0400
Received: by mail-it1-f196.google.com with SMTP id u186so3261087ith.0
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 04:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qs73giyYpTiUfmwy7nNWzrtz649jldDc8aQGV262rVQ=;
        b=eQ7vaJGpj+DPMI+L/OWMV74xNcJnxXghm8ZOS7gHZiITPo0lcPhNiK7Krm9+/OAqNu
         ghXs03YfgH/A/g/OIoRqLyU6ZA95wLO17pi1IvjtoVvKVw8K7WnuEoY0y0W+fvQGC/BF
         K5ga7dzSj6YU+ROC0l9bddATkeeTg17tox3DQjuV1Q04l7EIuyMDIA5z0QJVonwLa0PQ
         vHOSt8EEu7WMM7/V1IUo3cz5TqHJmSutYPsv/MV0n0b6ctTEHiwdroWzGw0zTvDt2rH2
         yU7O9JJfr45fihpiGCZR4KID/TJ33gFHDZS3THB+PwD3iHOfWtqNrRPZh9SPeVI6lJIS
         tSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qs73giyYpTiUfmwy7nNWzrtz649jldDc8aQGV262rVQ=;
        b=dzvIqCPqFyDM++AbFlFZqsMwV1B9J/LN4cgNuhgZ03qtcUS4QcJRjxzq52lp9OSP+n
         8eDdUuubJQ7U7Beprk1HR+aQN2AtffgFRbqXNRgnB/NMjvnGG8rltwskuHhz9v+ibVJ+
         1cdJ0Z8aqD5pjLvzfC7K+uKwek4HSmS3NffHJkXCnyrcWRpez4/Ig+Rg5MWPOasoex3t
         on+4SGWXcT8XeGZXU9pvf1p7rZ/NjjuUSn3jr5UF0oFoc8CRx54wsfvXjkUcU4VJTgQC
         gY845WlftYXcw7/kYIgSxWMPlk+lEXb5AN9sx3D4VBhJhcYy6Nxp0606nE+RiUpOt/5z
         CyVw==
X-Gm-Message-State: APjAAAVe1mF9ziP2ZjKFeiNBLc/VpcqQFXO+yC2QB4tNp6ug38miEGJf
        PrKow5gE9oeTHB5GSg6s8CbOj3YNdVuM3b5rrAsFhw==
X-Google-Smtp-Source: APXvYqwySfHXy56sSF+6GAJw51/lPUKp9Sqrr+QqayjNg0KsZeyF8iSNIBqsvUi8R1rsLpwYNOYSB24HjmoxJj4T9Sg=
X-Received: by 2002:a02:b88b:: with SMTP id p11mr26973754jam.82.1557314712994;
 Wed, 08 May 2019 04:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000fb78720587d46fe9@google.com> <20190502023426.GA804@sol.localdomain>
In-Reply-To: <20190502023426.GA804@sol.localdomain>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 8 May 2019 13:25:01 +0200
Message-ID: <CACT4Y+YHFH8GAhDaNdNNTVFFx6YfKSL19cLPx2vpP-YngzS6kQ@mail.gmail.com>
Subject: Re: BUG: soft lockup in kvm_vm_ioctl
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     syzbot <syzbot+8d9bb6157e7b379f740e@syzkaller.appspotmail.com>,
        KVM list <kvm@vger.kernel.org>, adrian.hunter@intel.com,
        David Miller <davem@davemloft.net>,
        Artem Bityutskiy <dedekind1@gmail.com>, jbaron@redhat.com,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Rik van Riel <riel@surriel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Biggers <ebiggers@kernel.org>
Date: Thu, May 2, 2019 at 4:34 AM
To: syzbot, Dmitry Vyukov, <kvm@vger.kernel.org>
Cc: <adrian.hunter@intel.com>, <davem@davemloft.net>,
<dedekind1@gmail.com>, <jbaron@redhat.com>, <jpoimboe@redhat.com>,
<linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
<luto@kernel.org>, <mingo@kernel.org>, <peterz@infradead.org>,
<richard@nod.at>, <riel@surriel.com>, <rostedt@goodmis.org>,
<syzkaller-bugs@googlegroups.com>, <tglx@linutronix.de>

> On Wed, May 01, 2019 at 07:36:05AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    baf76f0c slip: make slhc_free() silently accept an error p..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1407f57f200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=a42d110b47dd6b36
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8d9bb6157e7b379f740e
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1266a588a00000
> >
> > The bug was bisected to:
> >
> > commit 252153ba518ac0bcde6b7152c63380d4415bfe5d
> > Author: Eric Biggers <ebiggers@google.com>
> > Date:   Wed Nov 29 20:43:17 2017 +0000
> >
> >     ubifs: switch to fscrypt_prepare_setattr()
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1448f588a00000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1648f588a00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1248f588a00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+8d9bb6157e7b379f740e@syzkaller.appspotmail.com
> > Fixes: 252153ba518a ("ubifs: switch to fscrypt_prepare_setattr()")
> >
> > watchdog: BUG: soft lockup - CPU#0 stuck for 123s! [syz-executor.3:22023]
> > Modules linked in:
> > irq event stamp: 26556
> > hardirqs last  enabled at (26555): [<ffffffff81006673>]
> > trace_hardirqs_on_thunk+0x1a/0x1c
> > hardirqs last disabled at (26556): [<ffffffff8100668f>]
> > trace_hardirqs_off_thunk+0x1a/0x1c
> > softirqs last  enabled at (596): [<ffffffff87400662>]
> > __do_softirq+0x662/0x95a kernel/softirq.c:320
> > softirqs last disabled at (517): [<ffffffff8144e4e0>] invoke_softirq
> > kernel/softirq.c:374 [inline]
> > softirqs last disabled at (517): [<ffffffff8144e4e0>] irq_exit+0x180/0x1d0
> > kernel/softirq.c:414
> > CPU: 0 PID: 22023 Comm: syz-executor.3 Not tainted 5.1.0-rc6+ #89
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:csd_lock_wait kernel/smp.c:108 [inline]
> > RIP: 0010:smp_call_function_single+0x13e/0x420 kernel/smp.c:302
> > Code: 00 48 8b 4c 24 08 48 8b 54 24 10 48 8d 74 24 40 8b 7c 24 1c e8 23 fa
> > ff ff 41 89 c5 eb 07 e8 e9 87 0a 00 f3 90 44 8b 64 24 58 <31> ff 41 83 e4 01
> > 44 89 e6 e8 54 89 0a 00 45 85 e4 75 e1 e8 ca 87
> > RSP: 0018:ffff88809277f3e0 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
> > RAX: ffff8880a8bfc040 RBX: 1ffff110124efe80 RCX: ffffffff8166051c
> > RDX: 0000000000000000 RSI: ffffffff81660507 RDI: 0000000000000005
> > RBP: ffff88809277f4b8 R08: ffff8880a8bfc040 R09: ffffed1015d25be9
> > R10: ffffed1015d25be8 R11: ffff8880ae92df47 R12: 0000000000000003
> > R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
> > FS:  00007fd569980700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fd56997e178 CR3: 00000000a4fd2000 CR4: 00000000001426f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  smp_call_function_many+0x750/0x8c0 kernel/smp.c:434
> >  smp_call_function+0x42/0x90 kernel/smp.c:492
> >  on_each_cpu+0x31/0x200 kernel/smp.c:602
> >  text_poke_bp+0x107/0x19b arch/x86/kernel/alternative.c:821
> >  __jump_label_transform+0x263/0x330 arch/x86/kernel/jump_label.c:91
> >  arch_jump_label_transform+0x2b/0x40 arch/x86/kernel/jump_label.c:99
> >  __jump_label_update+0x16a/0x210 kernel/jump_label.c:389
> >  jump_label_update kernel/jump_label.c:752 [inline]
> >  jump_label_update+0x1ce/0x3d0 kernel/jump_label.c:731
> >  static_key_slow_inc_cpuslocked+0x1c1/0x250 kernel/jump_label.c:129
> >  static_key_slow_inc+0x1b/0x30 kernel/jump_label.c:144
> >  kvm_arch_vcpu_init+0x6b7/0x870 arch/x86/kvm/x86.c:9068
> >  kvm_vcpu_init+0x272/0x370 arch/x86/kvm/../../../virt/kvm/kvm_main.c:320
> >  vmx_create_vcpu+0x191/0x2540 arch/x86/kvm/vmx/vmx.c:6577
> >  kvm_arch_vcpu_create+0x80/0x120 arch/x86/kvm/x86.c:8755
> >  kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:2569
> > [inline]
> >  kvm_vm_ioctl+0x5ce/0x19c0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3105
> >  vfs_ioctl fs/ioctl.c:46 [inline]
> >  file_ioctl fs/ioctl.c:509 [inline]
> >  do_vfs_ioctl+0xd6e/0x1390 fs/ioctl.c:696
> >  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
> >  __do_sys_ioctl fs/ioctl.c:720 [inline]
> >  __se_sys_ioctl fs/ioctl.c:718 [inline]
> >  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
> >  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x458da9
> > Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> > 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> > 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007fd56997fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
> > RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000005
> > RBP: 000000000073bfa0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00007fd5699806d4
> > R13: 00000000004c1905 R14: 00000000004d40d0 R15: 00000000ffffffff
> > Sending NMI from CPU 0 to CPUs 1:

> Can the KVM maintainers take a look at this?  This doesn't have anything to do
> with my commit that syzbot bisected it to.
>
> +Dmitry, statistics lession: if a crash occurs only 1 in 10 times, as was the
> case here, then often it will happen 0 in 10 times by chance.  syzbot needs to
> run the reproducer more times if it isn't working reliably.  Otherwise it ends
> up blaming some random commit.

Added a note to https://github.com/google/syzkaller/issues/1051
Thanks
