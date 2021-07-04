Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA71A3BACEA
	for <lists+kvm@lfdr.de>; Sun,  4 Jul 2021 13:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhGDLjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jul 2021 07:39:55 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56903 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGDLjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jul 2021 07:39:54 -0400
Received: by mail-io1-f72.google.com with SMTP id p19-20020a5d8b930000b02904a03acf5d82so11146929iol.23
        for <kvm@vger.kernel.org>; Sun, 04 Jul 2021 04:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yjcMZX4+hiIGwGy3zCxArtWiKk2nJbdGA45P5+4QRk4=;
        b=ml6ykky7G/Qfs6R2i9wAZB7lf+sfJv5/Ds0S0mTnZphZHusFpwpXzYfUpE+7z1a8y7
         Yc6/J+hXvlb1G9WFKjIxrL0UC7f4/GckZbjHzLrwF7GqSJLyb4Wn4Q+xg/x15rxB88s5
         crkNpvnJ6AkiCTackYWZOdwLG3O4IRuK19MVWlSexBL0RU8s/QpEYUNhmTZe8P1oF8XN
         fA9eIgWvy7jY3fGUGOFxLrvFEsD8SN6qs0kVLnRgidNuIKbTAdgyKvdzmrxdEWCFCxOz
         QTbLiRhVhV7JPYM5wxzG/SC2KOhloxQkL3+ZXOXME4CKroDgs0McaA+o2bhIFGIiHpgc
         OI1Q==
X-Gm-Message-State: AOAM532rqxY5iYRfoMU0H5tJPFdWG5ZJYFv3ONp1wQNL/1TJn2CZ6XfK
        DUjjxohT5qivhE1JBYx7507UwUInsZJVonBAfRJSeSABckdQ
X-Google-Smtp-Source: ABdhPJzE3syylZlC1GqQgMvTy9L/hBvOloVqp/1vVcLHpReqPSa5CL98RbnEHxiXapMfFh0nlrVtC0xdXebLjozN5qWFOcXv7y8+
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2259:: with SMTP id o25mr4554011ioo.173.1625398639366;
 Sun, 04 Jul 2021 04:37:19 -0700 (PDT)
Date:   Sun, 04 Jul 2021 04:37:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000084943605c64a9cbd@google.com>
Subject: [syzbot] general protection fault in rcu_segcblist_enqueue
From:   syzbot <syzbot+7590ddacf9f333c18f6c@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, bp@alien8.de, hpa@zytor.com, jack@suse.cz,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        paolo.valente@linaro.org, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    df04fbe8 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13eb6594300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a9c38351af1345a
dashboard link: https://syzkaller.appspot.com/bug?extid=7590ddacf9f333c18f6c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1326068c300000

The issue was bisected to:

commit 71217df39dc67a0aeed83352b0d712b7892036a2
Author: Paolo Valente <paolo.valente@linaro.org>
Date:   Mon Jan 25 19:02:48 2021 +0000

    block, bfq: make waker-queue detection more robust

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127c2700300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=117c2700300000
console output: https://syzkaller.appspot.com/x/log.txt?x=167c2700300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7590ddacf9f333c18f6c@syzkaller.appspotmail.com
Fixes: 71217df39dc6 ("block, bfq: make waker-queue detection more robust")

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 11479 Comm: syz-executor.0 Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rcu_segcblist_enqueue+0xb9/0x130 kernel/rcu/rcu_segcblist.c:348
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 89 ea 48 c1 ea 03 <80> 3c 02 00 75 21 48 89 75 00 48 89 73 20 48 83 c4 08 5b 5d c3 48
RSP: 0018:ffffc90003287be8 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880b9c00080 RCX: ffffffff815c5540
RDX: 0000000000000000 RSI: ffffc90003287cd0 RDI: ffff8880b9c000a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000650f6f R11: 0000000000000000 R12: ffffc90003287cd0
R13: ffff8880b9c00080 R14: 0000000000000000 R15: ffff8880b9c00040
FS:  00007fbfbe427700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000544038 CR3: 000000003a8e9000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 srcu_gp_start_if_needed+0x116/0xbc0 kernel/rcu/srcutree.c:828
 __call_srcu kernel/rcu/srcutree.c:888 [inline]
 __synchronize_srcu+0x1d1/0x280 kernel/rcu/srcutree.c:934
 kvm_mmu_uninit_vm+0x18/0x30 arch/x86/kvm/mmu/mmu.c:5555
 kvm_arch_destroy_vm+0x4fc/0x690 arch/x86/kvm/x86.c:11265
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1046 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4443 [inline]
 kvm_dev_ioctl+0x120e/0x1740 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4498
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbfbe427188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffc6c46097f R14: 00007fbfbe427300 R15: 0000000000022000
Modules linked in:
---[ end trace e798d58b3973533f ]---
RIP: 0010:rcu_segcblist_enqueue+0xb9/0x130 kernel/rcu/rcu_segcblist.c:348
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 89 ea 48 c1 ea 03 <80> 3c 02 00 75 21 48 89 75 00 48 89 73 20 48 83 c4 08 5b 5d c3 48
RSP: 0018:ffffc90003287be8 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880b9c00080 RCX: ffffffff815c5540
RDX: 0000000000000000 RSI: ffffc90003287cd0 RDI: ffff8880b9c000a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000650f6f R11: 0000000000000000 R12: ffffc90003287cd0
R13: ffff8880b9c00080 R14: 0000000000000000 R15: ffff8880b9c00040
FS:  00007fbfbe427700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000544038 CR3: 000000003a8e9000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
