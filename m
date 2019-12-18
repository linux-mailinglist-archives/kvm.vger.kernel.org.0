Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815A7123FC4
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 07:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLRGkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 01:40:43 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41759 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRGkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 01:40:43 -0500
Received: by mail-qk1-f194.google.com with SMTP id x129so686120qke.8
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 22:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HtVF41M8LwEzuhthLZBV0egNx7nncp9w0m3QgjRzMjM=;
        b=ftcitIAsdZI+nlA4BqFqNkBPJzrg8DwjtT2poCp3qrFd5PLcLXSH4vTGOiLeVshlBw
         5biNL14Xbgg0EQ87LO8PFV8VSpddSfLpAneyHJNUVuaZIus5bf3b/iqNYAf15/WjWfUR
         g4vF6si4Bwj+sfYe3djdUN7OIpQygCuZm3SInAr3fSGJlosShc6vPJuNqzAfLHqWLp2b
         SNMn25r/zvgkXBB/UY4VBLsJ/Xvdi8gUtLxC735iQ2ikjcMgLh11zu7WAqRjloITShbK
         HguY9fxv+MQHVgVtZtwceHOElv094mFs4axGDtUm/dwauuQsu/XV7ofngK7hnouu+Wz8
         a6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HtVF41M8LwEzuhthLZBV0egNx7nncp9w0m3QgjRzMjM=;
        b=B6aDGTC6Kt5uzhGC2EyWcwWqtfCWecbaef+/SbbXq9uwDj0Ozj4veJRd710+3UT77L
         R/cGmuYVYwa3N3kVmVngUCd/0v1IyRR5uhffT4S9YOl4vF+OyoXY+X//accjBkWIPg28
         n+ouVE9x78aSeW4N8GqtBPvhZyfyG3XqScdAOUpV8LpQ2iZJO2TPjVB/nVHbaIb8ZSJf
         cJ1AHDl0L3M7/j48fML4Cq1nAjbg1gbxwY1DuvnecZxxiAHy9+bYvLuIO38UX4vqSOHD
         Hbq6zgWStISX7VtoCLv9voJfIkB6eQeeN9S8PIN9EcHJSCxoy9qMGWuviUD26GFwNyyF
         eE2A==
X-Gm-Message-State: APjAAAW8TeOAw25OrTWWunqkQ3bCmhLU9qbQ0/9BC8LSMoFkdZNmovae
        AXDCwLzC1m1jnoKGiiTYkFs5rqJE3htk0cHGgr1bAg==
X-Google-Smtp-Source: APXvYqxXtXap1NJSvBZPhvqHSnufwDzezPsZXliJ4dXGie2gHbjm3BmY60CHaXPYT+D0U0g++azwjl2iPPSy5r5HpBM=
X-Received: by 2002:a37:e312:: with SMTP id y18mr976595qki.250.1576651241550;
 Tue, 17 Dec 2019 22:40:41 -0800 (PST)
MIME-Version: 1.0
References: <0000000000003cffc30599d3d1a0@google.com> <20191218005518.GQ11771@linux.intel.com>
In-Reply-To: <20191218005518.GQ11771@linux.intel.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 18 Dec 2019 07:40:30 +0100
Message-ID: <CACT4Y+bcGqby633WuFOQoZ-22H6OzX4foyZpfM91h33+MwM-rA@mail.gmail.com>
Subject: Re: kernel BUG at arch/x86/kvm/mmu/mmu.c:LINE!
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     syzbot <syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 1:55 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Mon, Dec 16, 2019 at 07:25:11AM -0800, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    ae4b064e Merge tag 'afs-fixes-20191211' of git://git.kerne..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=149c0cfae00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
> > dashboard link: https://syzkaller.appspot.com/bug?extid=c9d1fb51ac9d0d10c39d
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a97b7ee00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15128396e00000
>
> Looks like the crash is basically 100% reproducible in syzkaller's
> environment, but bisection went off into the weeds because it hit a random
> unrelated failure.
>
> I've tried the C reproducer without "success".  Is it possible to adjust
> the bisection for this crash so that it can home in on the actual bug?

Hi Sean,

No, unfortunately it's not possible at the moment.

But we have something like 1/32-th of v4.17..v4.18. Perhaps there are
not many changes left that may be possibly related.


>   kernel signature: 77bc4f2c8b034884ef0b5f4a64115ae7447012ed
>   run #0: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
>   run #1: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
>   run #2: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
>   run #3: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
>   run #4: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
>   run #5: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
>   run #6: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
>   run #7: boot failed: KASAN: use-after-free Write in call_usermodehelper_exec_work
>   run #8: boot failed: KASAN: use-after-free Write in call_usermodehelper_exec_work
>   run #9: boot failed: KASAN: use-after-free Write in call_usermodehelper_exec_work
>   # git bisect bad f39c6b29ae1d3727d9c65a4ab99d5150b558be5e
>   Bisecting: 901 revisions left to test after this (roughly 10 steps)
>   [7d6541fba19c970cf5ebbc2c56b0fb04eab89f98] Merge tag 'mlx5e-updates-2018-05-14'
>   testing commit 7d6541fba19c970cf5ebbc2c56b0fb04eab89f98 with gcc (GCC) 8.1.0
>   kernel signature: 6d4fcd644552059ed7f799240ae8f63e4634fa35
>   all runs: OK
>   # git bisect good 7d6541fba19c970cf5ebbc2c56b0fb04eab89f98
>   Bisecting: 450 revisions left to test after this (roughly 9 steps)
>   [73bf1fc58dc4376d0111a4c1c9eab27e2759f468] Merge branch 'net-ipv6-Fix-route'
>   testing commit 73bf1fc58dc4376d0111a4c1c9eab27e2759f468 with gcc (GCC) 8.1.0
>   kernel signature: b651b65951b60c06906f2717756395fc5176e7b5
>   run #0: OK
>   run #1: OK
>   run #2: OK
>   run #3: OK
>   run #4: OK
>   run #5: OK
>   run #6: OK
>   run #7: OK
>   run #8: OK
>   run #9: crashed: WARNING in __static_key_slow_dec_cpuslocked
>   # git bisect bad 73bf1fc58dc4376d0111a4c1c9eab27e2759f468
>
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > kernel BUG at arch/x86/kvm/mmu/mmu.c:3416!
> > invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 9988 Comm: syz-executor218 Not tainted 5.5.0-rc1-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:transparent_hugepage_adjust+0x4c8/0x550
> > arch/x86/kvm/mmu/mmu.c:3416
> > Code: ff ff e8 eb 5d 5e 00 48 8b 45 b8 48 83 e8 01 48 89 45 c8 e9 a3 fd ff
> > ff 48 89 df e8 c2 f8 9b 00 e9 7b fb ff ff e8 c8 5d 5e 00 <0f> 0b 48 8b 7d c8
> > e8 ad f8 9b 00 e9 ba fc ff ff 49 8d 7f 30 e8 7f
> > RSP: 0018:ffffc90001f27678 EFLAGS: 00010293
> > RAX: ffff8880a875a200 RBX: ffffc90001f27768 RCX: ffffffff8116cc87
> > RDX: 0000000000000000 RSI: ffffffff8116cdc8 RDI: 0000000000000007
> > RBP: ffffc90001f276c0 R08: ffff8880a875a200 R09: ffffed1010d79682
> > R10: ffffed1010d79681 R11: ffff888086bcb40b R12: 00000000000001d3
> > R13: 0000000000094dd3 R14: 0000000000094dd1 R15: 0000000000000000
> > FS:  0000000000fff880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000000 CR3: 000000009af1b000 CR4: 00000000001426f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  tdp_page_fault+0x580/0x6a0 arch/x86/kvm/mmu/mmu.c:4315
> >  kvm_mmu_page_fault+0x1dd/0x1800 arch/x86/kvm/mmu/mmu.c:5539
> >  handle_ept_violation+0x259/0x560 arch/x86/kvm/vmx/vmx.c:5163
> >  vmx_handle_exit+0x29f/0x1730 arch/x86/kvm/vmx/vmx.c:5921
> >  vcpu_enter_guest+0x334f/0x6110 arch/x86/kvm/x86.c:8290
> >  vcpu_run arch/x86/kvm/x86.c:8354 [inline]
> >  kvm_arch_vcpu_ioctl_run+0x430/0x17b0 arch/x86/kvm/x86.c:8561
> >  kvm_vcpu_ioctl+0x4dc/0xfc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2847
> >  vfs_ioctl fs/ioctl.c:47 [inline]
> >  file_ioctl fs/ioctl.c:545 [inline]
> >  do_vfs_ioctl+0x977/0x14e0 fs/ioctl.c:732
> >  ksys_ioctl+0xab/0xd0 fs/ioctl.c:749
> >  __do_sys_ioctl fs/ioctl.c:756 [inline]
> >  __se_sys_ioctl fs/ioctl.c:754 [inline]
> >  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
> >  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x440359
> > Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
> > 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> > 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007ffc16334278 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440359
> > RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
> > RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
> > R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401be0
> > R13: 0000000000401c70 R14: 0000000000000000 R15: 0000000000000000
> > Modules linked in:
> > ---[ end trace e1a5b9c09fef2e33 ]---
> > RIP: 0010:transparent_hugepage_adjust+0x4c8/0x550
> > arch/x86/kvm/mmu/mmu.c:3416
> > Code: ff ff e8 eb 5d 5e 00 48 8b 45 b8 48 83 e8 01 48 89 45 c8 e9 a3 fd ff
> > ff 48 89 df e8 c2 f8 9b 00 e9 7b fb ff ff e8 c8 5d 5e 00 <0f> 0b 48 8b 7d c8
> > e8 ad f8 9b 00 e9 ba fc ff ff 49 8d 7f 30 e8 7f
> > RSP: 0018:ffffc90001f27678 EFLAGS: 00010293
> > RAX: ffff8880a875a200 RBX: ffffc90001f27768 RCX: ffffffff8116cc87
> > RDX: 0000000000000000 RSI: ffffffff8116cdc8 RDI: 0000000000000007
> > RBP: ffffc90001f276c0 R08: ffff8880a875a200 R09: ffffed1010d79682
> > R10: ffffed1010d79681 R11: ffff888086bcb40b R12: 00000000000001d3
> > R13: 0000000000094dd3 R14: 0000000000094dd1 R15: 0000000000000000
> > FS:  0000000000fff880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000000 CR3: 000000009af1b000 CR4: 00000000001426f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20191218005518.GQ11771%40linux.intel.com.
