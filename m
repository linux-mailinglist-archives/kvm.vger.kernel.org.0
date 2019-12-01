Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7575710E0F2
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2019 08:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfLAHFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Dec 2019 02:05:11 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:37721 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfLAHFK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Dec 2019 02:05:10 -0500
Received: by mail-io1-f71.google.com with SMTP id p2so23546628iof.4
        for <kvm@vger.kernel.org>; Sat, 30 Nov 2019 23:05:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sVJfn8rJ2gIp74tK7+hxDmMwjF/b8IMnVIXNefmEtNQ=;
        b=VZgqQuWGrJ/cfTde+5VZYFaq4OGx1mkFLlNxwYuIf6XIua9PNaoFV00rjV35vlX7uK
         nCz17hbp8u8lVGRNoqprbLurK5puOB1xvMOzMzMTBFLWlatEoSlyeHDGGv2j91x8TrUR
         kRgQgBGEooB9QjYKEkvUlsr5TIQVajNmWtoAoVvSGLwcJbcUqRbgAQqXRfr6CoEbU6/0
         /2X6Chvmi7TFrjfiD5c8aP8DjaxFWo2Ypt4XpywqWySwXNIHo4d13VJw8djtYlqAOUN9
         M1aI6/ek+HGGkMPAr8l7spfdLmzMVKuyqcgym+2t4OfeAYr35/IeJkPUuXPbNjfVNvrn
         yjUg==
X-Gm-Message-State: APjAAAUnrByK+sseoQ3VC/NfowN88RgoWxVcXiUeH8yYEKG7ZPD2b91/
        sMHFJIXMqT34kC9VUmJcABGRKZFDw81gsV+V0QwRvAWaFscm
X-Google-Smtp-Source: APXvYqxwNXgzb30H6/92ZMPnaVi7ngNCOj4QuO9fnKu8jDWRPc7FjkkXJPGHU7gfk4lUbxnBr4Kqbmg6EAC8kZCcY3Ay2tfovrOd
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2806:: with SMTP id d6mr13018994ioe.299.1575183908296;
 Sat, 30 Nov 2019 23:05:08 -0800 (PST)
Date:   Sat, 30 Nov 2019 23:05:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004f5ec705989f1585@google.com>
Subject: BUG: unable to handle kernel paging request in __call_srcu
From:   syzbot <syzbot+b16ea6c233022c222d63@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    131b7b67 Add linux-next specific files for 20191126
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12aa31f2e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=11aacf1d97714af4
dashboard link: https://syzkaller.appspot.com/bug?extid=b16ea6c233022c222d63
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174cbb5ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b16ea6c233022c222d63@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffc90009080868
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD aa54b067 P4D aa54b067 PUD aa54c067 PMD 99900067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 31521 Comm: syz-executor.4 Not tainted  
5.4.0-next-20191126-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__lock_acquire+0x125e/0x4a00 kernel/locking/lockdep.c:3828
Code: f0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 b8 00 00 00 00 00 fc  
ff df 4c 89 f2 48 c1 ea 03 80 3c 02 00 0f 85 0b 28 00 00 <49> 81 3e e0 dc  
08 8a 0f 84 5f ee ff ff 83 fe 01 0f 87 62 ee ff ff
RSP: 0018:ffff88809727f7f0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 1ffff9200121010d RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88809727f908 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff139ebd0 R11: ffff88808e750540 R12: ffffc90009080868
R13: 0000000000000000 R14: ffffc90009080868 R15: 0000000000000001
FS:  00007ffb1ae47700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90009080868 CR3: 000000009f42f000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
  _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
  srcu_funnel_gp_start kernel/rcu/srcutree.c:643 [inline]
  __call_srcu kernel/rcu/srcutree.c:871 [inline]
  __call_srcu+0x53f/0xcc0 kernel/rcu/srcutree.c:834
  __synchronize_srcu+0x18d/0x250 kernel/rcu/srcutree.c:920
  synchronize_srcu_expedited kernel/rcu/srcutree.c:946 [inline]
  synchronize_srcu+0x239/0x3e8 kernel/rcu/srcutree.c:997
  kvm_page_track_unregister_notifier+0xe7/0x130  
arch/x86/kvm/mmu/page_track.c:212
  kvm_mmu_uninit_vm+0x1e/0x30 arch/x86/kvm/mmu/mmu.c:5928
  kvm_arch_destroy_vm+0x4a2/0x5f0 arch/x86/kvm/x86.c:9666
  kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:758 [inline]
  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3519  
[inline]
  kvm_dev_ioctl+0x1167/0x1770 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3571
  vfs_ioctl fs/ioctl.c:47 [inline]
  file_ioctl fs/ioctl.c:545 [inline]
  do_vfs_ioctl+0x977/0x14e0 fs/ioctl.c:732
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:749
  __do_sys_ioctl fs/ioctl.c:756 [inline]
  __se_sys_ioctl fs/ioctl.c:754 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:754
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a649
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffb1ae46c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a649
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffb1ae476d4
R13: 00000000004c38f2 R14: 00000000004d7de8 R15: 00000000ffffffff
Modules linked in:
CR2: ffffc90009080868
---[ end trace e17de659c9276288 ]---
RIP: 0010:__lock_acquire+0x125e/0x4a00 kernel/locking/lockdep.c:3828
Code: f0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 b8 00 00 00 00 00 fc  
ff df 4c 89 f2 48 c1 ea 03 80 3c 02 00 0f 85 0b 28 00 00 <49> 81 3e e0 dc  
08 8a 0f 84 5f ee ff ff 83 fe 01 0f 87 62 ee ff ff
RSP: 0018:ffff88809727f7f0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 1ffff9200121010d RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff88809727f908 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff139ebd0 R11: ffff88808e750540 R12: ffffc90009080868
R13: 0000000000000000 R14: ffffc90009080868 R15: 0000000000000001
FS:  00007ffb1ae47700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90009080868 CR3: 000000009f42f000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
