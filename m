Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5231118A
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 04:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfEBCeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 22:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbfEBCeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 22:34:31 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7F992085A;
        Thu,  2 May 2019 02:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556764469;
        bh=UAOAH/zGLNO2iuCFWWOHB5s4sEf5FLEX5WY9hLoLXLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UvknmYvk3r6cFoX7tg2YFBMqGHinOupnE3uhE+Q+ptKHdpNOPA1jJ90nhLt7m290P
         OlLDvubxZfpAcsJYgoRjEdPVuur4AspQAPqGowADSrN8Qz5ET+oBbhKLz8klB1teBR
         buS0pV43LeCLcQ6eT8AT6nszmOBBBKgMPLGbf6LY=
Date:   Wed, 1 May 2019 19:34:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     syzbot <syzbot+8d9bb6157e7b379f740e@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>, kvm@vger.kernel.org
Cc:     adrian.hunter@intel.com, davem@davemloft.net, dedekind1@gmail.com,
        jbaron@redhat.com, jpoimboe@redhat.com,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        luto@kernel.org, mingo@kernel.org, peterz@infradead.org,
        richard@nod.at, riel@surriel.com, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Subject: Re: BUG: soft lockup in kvm_vm_ioctl
Message-ID: <20190502023426.GA804@sol.localdomain>
References: <000000000000fb78720587d46fe9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000fb78720587d46fe9@google.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 01, 2019 at 07:36:05AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    baf76f0c slip: make slhc_free() silently accept an error p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1407f57f200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a42d110b47dd6b36
> dashboard link: https://syzkaller.appspot.com/bug?extid=8d9bb6157e7b379f740e
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1266a588a00000
> 
> The bug was bisected to:
> 
> commit 252153ba518ac0bcde6b7152c63380d4415bfe5d
> Author: Eric Biggers <ebiggers@google.com>
> Date:   Wed Nov 29 20:43:17 2017 +0000
> 
>     ubifs: switch to fscrypt_prepare_setattr()
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1448f588a00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1648f588a00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1248f588a00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+8d9bb6157e7b379f740e@syzkaller.appspotmail.com
> Fixes: 252153ba518a ("ubifs: switch to fscrypt_prepare_setattr()")
> 
> watchdog: BUG: soft lockup - CPU#0 stuck for 123s! [syz-executor.3:22023]
> Modules linked in:
> irq event stamp: 26556
> hardirqs last  enabled at (26555): [<ffffffff81006673>]
> trace_hardirqs_on_thunk+0x1a/0x1c
> hardirqs last disabled at (26556): [<ffffffff8100668f>]
> trace_hardirqs_off_thunk+0x1a/0x1c
> softirqs last  enabled at (596): [<ffffffff87400662>]
> __do_softirq+0x662/0x95a kernel/softirq.c:320
> softirqs last disabled at (517): [<ffffffff8144e4e0>] invoke_softirq
> kernel/softirq.c:374 [inline]
> softirqs last disabled at (517): [<ffffffff8144e4e0>] irq_exit+0x180/0x1d0
> kernel/softirq.c:414
> CPU: 0 PID: 22023 Comm: syz-executor.3 Not tainted 5.1.0-rc6+ #89
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:csd_lock_wait kernel/smp.c:108 [inline]
> RIP: 0010:smp_call_function_single+0x13e/0x420 kernel/smp.c:302
> Code: 00 48 8b 4c 24 08 48 8b 54 24 10 48 8d 74 24 40 8b 7c 24 1c e8 23 fa
> ff ff 41 89 c5 eb 07 e8 e9 87 0a 00 f3 90 44 8b 64 24 58 <31> ff 41 83 e4 01
> 44 89 e6 e8 54 89 0a 00 45 85 e4 75 e1 e8 ca 87
> RSP: 0018:ffff88809277f3e0 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
> RAX: ffff8880a8bfc040 RBX: 1ffff110124efe80 RCX: ffffffff8166051c
> RDX: 0000000000000000 RSI: ffffffff81660507 RDI: 0000000000000005
> RBP: ffff88809277f4b8 R08: ffff8880a8bfc040 R09: ffffed1015d25be9
> R10: ffffed1015d25be8 R11: ffff8880ae92df47 R12: 0000000000000003
> R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
> FS:  00007fd569980700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd56997e178 CR3: 00000000a4fd2000 CR4: 00000000001426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  smp_call_function_many+0x750/0x8c0 kernel/smp.c:434
>  smp_call_function+0x42/0x90 kernel/smp.c:492
>  on_each_cpu+0x31/0x200 kernel/smp.c:602
>  text_poke_bp+0x107/0x19b arch/x86/kernel/alternative.c:821
>  __jump_label_transform+0x263/0x330 arch/x86/kernel/jump_label.c:91
>  arch_jump_label_transform+0x2b/0x40 arch/x86/kernel/jump_label.c:99
>  __jump_label_update+0x16a/0x210 kernel/jump_label.c:389
>  jump_label_update kernel/jump_label.c:752 [inline]
>  jump_label_update+0x1ce/0x3d0 kernel/jump_label.c:731
>  static_key_slow_inc_cpuslocked+0x1c1/0x250 kernel/jump_label.c:129
>  static_key_slow_inc+0x1b/0x30 kernel/jump_label.c:144
>  kvm_arch_vcpu_init+0x6b7/0x870 arch/x86/kvm/x86.c:9068
>  kvm_vcpu_init+0x272/0x370 arch/x86/kvm/../../../virt/kvm/kvm_main.c:320
>  vmx_create_vcpu+0x191/0x2540 arch/x86/kvm/vmx/vmx.c:6577
>  kvm_arch_vcpu_create+0x80/0x120 arch/x86/kvm/x86.c:8755
>  kvm_vm_ioctl_create_vcpu arch/x86/kvm/../../../virt/kvm/kvm_main.c:2569
> [inline]
>  kvm_vm_ioctl+0x5ce/0x19c0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3105
>  vfs_ioctl fs/ioctl.c:46 [inline]
>  file_ioctl fs/ioctl.c:509 [inline]
>  do_vfs_ioctl+0xd6e/0x1390 fs/ioctl.c:696
>  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
>  __do_sys_ioctl fs/ioctl.c:720 [inline]
>  __se_sys_ioctl fs/ioctl.c:718 [inline]
>  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
>  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x458da9
> Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fd56997fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458da9
> RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000005
> RBP: 000000000073bfa0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fd5699806d4
> R13: 00000000004c1905 R14: 00000000004d40d0 R15: 00000000ffffffff
> Sending NMI from CPU 0 to CPUs 1:
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000fb78720587d46fe9%40google.com.
> For more options, visit https://groups.google.com/d/optout.

Can the KVM maintainers take a look at this?  This doesn't have anything to do
with my commit that syzbot bisected it to.

+Dmitry, statistics lession: if a crash occurs only 1 in 10 times, as was the
case here, then often it will happen 0 in 10 times by chance.  syzbot needs to
run the reproducer more times if it isn't working reliably.  Otherwise it ends
up blaming some random commit.

I'm also curious how syzbot found the list of people to send this to, as it
seems very random.  This should obviously have gone to the kvm mailing list, but
it wasn't sent there; I had to manually add it.

- Eric
