Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD712748B2
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 21:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgIVTCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 15:02:19 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:56893 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVTCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 15:02:18 -0400
Received: by mail-io1-f80.google.com with SMTP id d21so13390919iow.23
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 12:02:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nHsCmKJPjBDSQdxu0VnOLOZJSPOVVHdYyh0XmlY9b7U=;
        b=f1OoqcADCniAM5HqdUYhP/xAcomCKpyyhN3ihHIqoSSfD8hUMgfeg2EPlYJdGN7/hc
         5cqPTRyVT6dDR74KIx8c3V13w2FbFUkrQ6qVSEsW+GDSnaDtJCCr6WbwjT+wrxfqgcIb
         Hh71OEJsBNHcVg8+xx/DxPAt8ktjcf0Z3Ic6Sah/yMBpMzCqaj/gTccxINoMya+RPMWf
         BQMkDemMqEQRpYSaVGDGZA6hCXVaUc9nYU/Wvc4GH+RgbdYdaWZZ3Flo/9J5juQ4SXVl
         cXWs1rw7IHevGvqpQC2lrhGPNvSjJ4d5sTGuv6OLUGXTdybSEiXMFwfkpmf1NavdD33C
         I1eQ==
X-Gm-Message-State: AOAM532YhKUHXctqiAeAYxEvwjmeEHRQoJZZlsKV+mS5k9NUdZ1TU5H2
        bygPdN9ICzqFbg5oI6makgSJ+mh1FbSUcih6FmbI2L8vkAiO
X-Google-Smtp-Source: ABdhPJyFuK3qiXURXsE2nZa62nSxaHigLr9vN68t6uVdFqV1gxKIbgkfD0769AdCFmGdD1JIs012JMCrXdlvLiWspT0IhATdPJYs
MIME-Version: 1.0
X-Received: by 2002:a92:d8d0:: with SMTP id l16mr5763129ilo.47.1600801337208;
 Tue, 22 Sep 2020 12:02:17 -0700 (PDT)
Date:   Tue, 22 Sep 2020 12:02:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000f73a805afeb9be8@google.com>
Subject: BUG: spinlock bad magic in synchronize_srcu
From:   syzbot <syzbot+05017ad275a64a3246f8@syzkaller.appspotmail.com>
To:     bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b10b8ad8 Add linux-next specific files for 20200921
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11bb1e73900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3cf0782933432b43
dashboard link: https://syzkaller.appspot.com/bug?extid=05017ad275a64a3246f8
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+05017ad275a64a3246f8@syzkaller.appspotmail.com

BUG: spinlock bad magic on CPU#1, syz-executor.0/11108
 lock: 0xffff8880ae500040, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
CPU: 1 PID: 11108 Comm: syz-executor.0 Not tainted 5.9.0-rc5-next-20200921-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fb lib/dump_stack.c:118
 debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
 do_raw_spin_lock+0x216/0x2b0 kernel/locking/spinlock_debug.c:112
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:117 [inline]
 _raw_spin_lock_irqsave+0x9c/0xd0 kernel/locking/spinlock.c:159
 srcu_might_be_idle kernel/rcu/srcutree.c:772 [inline]
 synchronize_srcu+0x4f/0x1c0 kernel/rcu/srcutree.c:999
 kvm_arch_destroy_vm+0x415/0x570 arch/x86/kvm/x86.c:10049
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:820 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3914 [inline]
 kvm_dev_ioctl+0xf4b/0x13a0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3966
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5f9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc828d44c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000010d40 RCX: 000000000045d5f9
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffe02e94b2f R14: 00007fc828d459c0 R15: 000000000118cf4c
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 11108 Comm: syz-executor.0 Not tainted 5.9.0-rc5-next-20200921-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rcu_segcblist_enqueue+0x90/0xf0 kernel/rcu/rcu_segcblist.c:250
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 89 ea 48 c1 ea 03 <80> 3c 02 00 75 21 48 89 75 00 48 89 73 20 48 83 c4 08 5b 5d c3 48
RSP: 0018:ffffc90008317c08 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880ae400080 RCX: ffffffff815be040
RDX: 0000000000000000 RSI: ffffc90008317cf0 RDI: ffff8880ae4000a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52001062f73 R11: 6637303030302052 R12: ffffc90008317cf0
R13: 0000000000000000 R14: ffff8880ae400080 R15: ffff8880ae400040
FS:  00007fc828d45700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001590004 CR3: 00000000998bd000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __call_srcu+0x193/0xc50 kernel/rcu/srcutree.c:859
 __synchronize_srcu+0x128/0x220 kernel/rcu/srcutree.c:923
 kvm_arch_destroy_vm+0x415/0x570 arch/x86/kvm/x86.c:10049
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:820 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:3914 [inline]
 kvm_dev_ioctl+0xf4b/0x13a0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3966
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5f9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc828d44c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000010d40 RCX: 000000000045d5f9
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffe02e94b2f R14: 00007fc828d459c0 R15: 000000000118cf4c
Modules linked in:
---[ end trace 4393ceea4b4b1821 ]---
RIP: 0010:rcu_segcblist_enqueue+0x90/0xf0 kernel/rcu/rcu_segcblist.c:250
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 89 ea 48 c1 ea 03 <80> 3c 02 00 75 21 48 89 75 00 48 89 73 20 48 83 c4 08 5b 5d c3 48
RSP: 0018:ffffc90008317c08 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880ae400080 RCX: ffffffff815be040
RDX: 0000000000000000 RSI: ffffc90008317cf0 RDI: ffff8880ae4000a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52001062f73 R11: 6637303030302052 R12: ffffc90008317cf0
R13: 0000000000000000 R14: ffff8880ae400080 R15: ffff8880ae400040
FS:  00007fc828d45700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001590004 CR3: 00000000998bd000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
