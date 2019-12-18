Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9245123C06
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 01:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfLRAzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 19:55:20 -0500
Received: from mga06.intel.com ([134.134.136.31]:21852 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfLRAzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 19:55:20 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 16:55:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="266734571"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Dec 2019 16:55:18 -0800
Date:   Tue, 17 Dec 2019 16:55:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     syzbot <syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Subject: Re: kernel BUG at arch/x86/kvm/mmu/mmu.c:LINE!
Message-ID: <20191218005518.GQ11771@linux.intel.com>
References: <0000000000003cffc30599d3d1a0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003cffc30599d3d1a0@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 07:25:11AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    ae4b064e Merge tag 'afs-fixes-20191211' of git://git.kerne..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=149c0cfae00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=79f79de2a27d3e3d
> dashboard link: https://syzkaller.appspot.com/bug?extid=c9d1fb51ac9d0d10c39d
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a97b7ee00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15128396e00000

Looks like the crash is basically 100% reproducible in syzkaller's
environment, but bisection went off into the weeds because it hit a random
unrelated failure.

I've tried the C reproducer without "success".  Is it possible to adjust
the bisection for this crash so that it can home in on the actual bug?

  kernel signature: 77bc4f2c8b034884ef0b5f4a64115ae7447012ed
  run #0: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
  run #1: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
  run #2: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
  run #3: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
  run #4: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
  run #5: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
  run #6: crashed: kernel BUG at arch/x86/kvm/mmu.c:LINE!
  run #7: boot failed: KASAN: use-after-free Write in call_usermodehelper_exec_work
  run #8: boot failed: KASAN: use-after-free Write in call_usermodehelper_exec_work
  run #9: boot failed: KASAN: use-after-free Write in call_usermodehelper_exec_work
  # git bisect bad f39c6b29ae1d3727d9c65a4ab99d5150b558be5e
  Bisecting: 901 revisions left to test after this (roughly 10 steps)
  [7d6541fba19c970cf5ebbc2c56b0fb04eab89f98] Merge tag 'mlx5e-updates-2018-05-14'
  testing commit 7d6541fba19c970cf5ebbc2c56b0fb04eab89f98 with gcc (GCC) 8.1.0
  kernel signature: 6d4fcd644552059ed7f799240ae8f63e4634fa35
  all runs: OK
  # git bisect good 7d6541fba19c970cf5ebbc2c56b0fb04eab89f98
  Bisecting: 450 revisions left to test after this (roughly 9 steps)
  [73bf1fc58dc4376d0111a4c1c9eab27e2759f468] Merge branch 'net-ipv6-Fix-route'
  testing commit 73bf1fc58dc4376d0111a4c1c9eab27e2759f468 with gcc (GCC) 8.1.0
  kernel signature: b651b65951b60c06906f2717756395fc5176e7b5
  run #0: OK
  run #1: OK
  run #2: OK
  run #3: OK
  run #4: OK
  run #5: OK
  run #6: OK
  run #7: OK
  run #8: OK
  run #9: crashed: WARNING in __static_key_slow_dec_cpuslocked
  # git bisect bad 73bf1fc58dc4376d0111a4c1c9eab27e2759f468

> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> kernel BUG at arch/x86/kvm/mmu/mmu.c:3416!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 9988 Comm: syz-executor218 Not tainted 5.5.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:transparent_hugepage_adjust+0x4c8/0x550
> arch/x86/kvm/mmu/mmu.c:3416
> Code: ff ff e8 eb 5d 5e 00 48 8b 45 b8 48 83 e8 01 48 89 45 c8 e9 a3 fd ff
> ff 48 89 df e8 c2 f8 9b 00 e9 7b fb ff ff e8 c8 5d 5e 00 <0f> 0b 48 8b 7d c8
> e8 ad f8 9b 00 e9 ba fc ff ff 49 8d 7f 30 e8 7f
> RSP: 0018:ffffc90001f27678 EFLAGS: 00010293
> RAX: ffff8880a875a200 RBX: ffffc90001f27768 RCX: ffffffff8116cc87
> RDX: 0000000000000000 RSI: ffffffff8116cdc8 RDI: 0000000000000007
> RBP: ffffc90001f276c0 R08: ffff8880a875a200 R09: ffffed1010d79682
> R10: ffffed1010d79681 R11: ffff888086bcb40b R12: 00000000000001d3
> R13: 0000000000094dd3 R14: 0000000000094dd1 R15: 0000000000000000
> FS:  0000000000fff880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000009af1b000 CR4: 00000000001426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  tdp_page_fault+0x580/0x6a0 arch/x86/kvm/mmu/mmu.c:4315
>  kvm_mmu_page_fault+0x1dd/0x1800 arch/x86/kvm/mmu/mmu.c:5539
>  handle_ept_violation+0x259/0x560 arch/x86/kvm/vmx/vmx.c:5163
>  vmx_handle_exit+0x29f/0x1730 arch/x86/kvm/vmx/vmx.c:5921
>  vcpu_enter_guest+0x334f/0x6110 arch/x86/kvm/x86.c:8290
>  vcpu_run arch/x86/kvm/x86.c:8354 [inline]
>  kvm_arch_vcpu_ioctl_run+0x430/0x17b0 arch/x86/kvm/x86.c:8561
>  kvm_vcpu_ioctl+0x4dc/0xfc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2847
>  vfs_ioctl fs/ioctl.c:47 [inline]
>  file_ioctl fs/ioctl.c:545 [inline]
>  do_vfs_ioctl+0x977/0x14e0 fs/ioctl.c:732
>  ksys_ioctl+0xab/0xd0 fs/ioctl.c:749
>  __do_sys_ioctl fs/ioctl.c:756 [inline]
>  __se_sys_ioctl fs/ioctl.c:754 [inline]
>  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
>  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x440359
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffc16334278 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440359
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
> RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
> R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401be0
> R13: 0000000000401c70 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace e1a5b9c09fef2e33 ]---
> RIP: 0010:transparent_hugepage_adjust+0x4c8/0x550
> arch/x86/kvm/mmu/mmu.c:3416
> Code: ff ff e8 eb 5d 5e 00 48 8b 45 b8 48 83 e8 01 48 89 45 c8 e9 a3 fd ff
> ff 48 89 df e8 c2 f8 9b 00 e9 7b fb ff ff e8 c8 5d 5e 00 <0f> 0b 48 8b 7d c8
> e8 ad f8 9b 00 e9 ba fc ff ff 49 8d 7f 30 e8 7f
> RSP: 0018:ffffc90001f27678 EFLAGS: 00010293
> RAX: ffff8880a875a200 RBX: ffffc90001f27768 RCX: ffffffff8116cc87
> RDX: 0000000000000000 RSI: ffffffff8116cdc8 RDI: 0000000000000007
> RBP: ffffc90001f276c0 R08: ffff8880a875a200 R09: ffffed1010d79682
> R10: ffffed1010d79681 R11: ffff888086bcb40b R12: 00000000000001d3
> R13: 0000000000094dd3 R14: 0000000000094dd1 R15: 0000000000000000
> FS:  0000000000fff880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000009af1b000 CR4: 00000000001426f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
