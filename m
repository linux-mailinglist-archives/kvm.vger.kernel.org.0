Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4430735E696
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 20:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348104AbhDMSkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 14:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229877AbhDMSkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 14:40:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C2C613C5;
        Tue, 13 Apr 2021 18:40:11 +0000 (UTC)
Date:   Tue, 13 Apr 2021 14:40:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzkaller <syzkaller@googlegroups.com>,
        syzbot <syzbot+61e04e51b7ac86930589@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, masahiroy@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        rafael.j.wysocki@intel.com,
        Sean Christopherson <seanjc@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Subject: Re: [syzbot] possible deadlock in del_gendisk
Message-ID: <20210413144009.6ed2feb8@gandalf.local.home>
In-Reply-To: <CACT4Y+ZrkE=ZKKncTOJRJgOTNfU8PGz=k+8V+0602ftTCHkc6Q@mail.gmail.com>
References: <000000000000ae236f05bfde0678@google.com>
        <20210413134147.54556d9d@gandalf.local.home>
        <20210413134314.16068eeb@gandalf.local.home>
        <CACT4Y+ZrkE=ZKKncTOJRJgOTNfU8PGz=k+8V+0602ftTCHkc6Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 20:24:00 +0200
Dmitry Vyukov <dvyukov@google.com> wrote:

> On Tue, Apr 13, 2021 at 7:43 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Tue, 13 Apr 2021 13:41:47 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >  
> > > As the below splats look like it has nothing to do with this patch, and
> > > this patch will add a WARN() if there's broken logic somewhere, I bet the
> > > bisect got confused (if it is automated and does a panic_on_warning),
> > > because it will panic for broken code that his patch detects.
> > >
> > > That is, the bisect was confused because it was triggering on two different
> > > issues. One that triggered the reported splat below, and another that this
> > > commit detects and warns on.  
> >
> > Is it possible to update the the bisect to make sure that if it is failing
> > on warnings, to make sure the warnings are somewhat related, before decided
> > that its the same bug?  
> 
> It does not seem to be feasible, bugs manifest differently in both
> space and time. Also even if we somehow conclude the crash we see is
> different, it says nothing about the original bug. For more data see:
> https://groups.google.com/g/syzkaller/c/sR8aAXaWEF4/m/tTWYRgvmAwAJ

Sure, but if you trigger a lockdep bug, lockdep bugs are usually very
similar in all instances. It usually will include the same locks, or at
least be the same type of lockdep bug (where some types are related).

If the bisect saw an issue before and at this commit, I would think it
didn't trigger a lockdep bug at all, and simply triggered a warning.

In fact, according to:

  https://syzkaller.appspot.com/x/report.txt?x=15a7e77ed00000

That's exactly what it did.

That is, if the original bug is a lockdep warning, you should only be
interested in lockdep warnings (at a minimum). The final bug here had:

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 0 PID: 8777 at kernel/locking/irqflag-debug.c:9 warn_bogus_irq_restore kernel/locking/irqflag-debug.c:9 [inline]
WARNING: CPU: 0 PID: 8777 at kernel/locking/irqflag-debug.c:9 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:7
Modules linked in:
CPU: 0 PID: 8777 Comm: syz-executor.1 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:warn_bogus_irq_restore kernel/locking/irqflag-debug.c:9 [inline]
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:7
Code: 51 00 e9 3f fe ff ff cc cc cc cc cc cc 80 3d e0 b4 ce 0a 00 74 01 c3 48 c7 c7 60 f5 8a 88 c6 05 cf b4 ce 0a 01 e8 17 01 a4 06 <0f> 0b c3 48 c7 c0 a0 46 4d 8e 53 48 89 fb 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc900017bf9f8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8881477b2040 RCX: 0000000000000000
RDX: 0000000000000002 RSI: 0000000000000004 RDI: fffff520002f7f31
RBP: 0000000000000246 R08: 0000000000000001 R09: ffff8880b9e2015b
R10: ffffed10173c402b R11: 0000000000000001 R12: 0000000000000003
R13: ffffed1028ef6408 R14: 0000000000000001 R15: ffff8880b9e359c0
FS:  00000000017b8400(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000017c1848 CR3: 0000000010920000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvm_wait arch/x86/kernel/kvm.c:860 [inline]
 kvm_wait+0xc3/0xe0 arch/x86/kernel/kvm.c:837
 pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 ext4_lock_group fs/ext4/ext4.h:3379 [inline]
 __ext4_new_inode+0x2da2/0x44d0 fs/ext4/ialloc.c:1187
 ext4_mkdir+0x298/0x910 fs/ext4/namei.c:2793
 vfs_mkdir+0x413/0x660 fs/namei.c:3652
 do_mkdirat+0x1eb/0x250 fs/namei.c:3675
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x465567
Code: 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 53 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe00ad69f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00007ffe00ad6a90 RCX: 0000000000465567
RDX: 0000000000000000 RSI: 00000000000001ff RDI: 00007ffe00ad6a90
RBP: 00007ffe00ad6a6c R08: 0000000000000000 R09: 0000000000000006
R10: 00007ffe00ad6794 R11: 0000000000000202 R12: 0000000000000032
R13: 000000000006549a R14: 0000000000000002 R15: 00007ffe00ad6ad0



Which shows a WARN was triggered, and totally unrelated to what you were
bisecting.

Just matching types of warnings (lockdep to lockdep, or WARN_ON to WARN_ON)
would help reduce the number of bogus bisects you are having.

-- Steve
