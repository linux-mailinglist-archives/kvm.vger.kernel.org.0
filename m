Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B018D40819F
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 22:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbhILUqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 16:46:35 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:47096 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236393AbhILUqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Sep 2021 16:46:33 -0400
Received: by mail-il1-f198.google.com with SMTP id w15-20020a056e021a6f00b0022b284d1de4so14046687ilv.13
        for <kvm@vger.kernel.org>; Sun, 12 Sep 2021 13:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=A0ZJRQdrrI6i3EJq4A72ZBHVin46xW5YDF0++94fM7g=;
        b=J6r8rOjwOtieSE1uqkiH3Q3kk78efNfBZUPmwdcoQxKRRnODQwJ+4NbdhL557/bN4U
         IesWjpcHZElH8rXBJV8bTb1YRTY8iZRXNXhtuQu14F1oYRFQ/cSIVcJiTfyWq+zx2Ihd
         8/KNJGw/YZgGa9Znkm1nEreqa/gcqxCjgALbKb4ML6Awq0EaJ1HEa72Rdogbxv7O9F75
         wGlog9ZOeU10tns5HiupS6FsYE6f8DR4//v2SxsjDXBJZOjr2M7Z0XalQ15WUe2hvMz8
         Xy6FhEC0yXJon45upvBSrFlvhwhHVnJDYbp6G9eXNcdFCs069jGi7q9XQyGzL+KZaEIA
         0B7w==
X-Gm-Message-State: AOAM531lCko6denkbj+zgKDA0KvAMYaUNsEJCseYIi5IFrgJPuFzC2QW
        1maXmiytDZFAIv4Zo6/ZZ9msTGZmO0TXINpVYJj3ch5f/NiW
X-Google-Smtp-Source: ABdhPJwC7T9Ggku58kyMUew9xg4gCYGyo71rL1HEDhi2O3cmJ5XlEK8CUKoGYFnbtQ/mjNxpTb6uZWhvn8gtQwKY/w17SDz6aWC/
MIME-Version: 1.0
X-Received: by 2002:a92:c6d1:: with SMTP id v17mr5274901ilm.302.1631479518430;
 Sun, 12 Sep 2021 13:45:18 -0700 (PDT)
Date:   Sun, 12 Sep 2021 13:45:18 -0700
In-Reply-To: <0000000000000f73a805afeb9be8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000278d5105cbd26d28@google.com>
Subject: Re: [syzbot] BUG: spinlock bad magic in synchronize_srcu
From:   syzbot <syzbot+05017ad275a64a3246f8@syzkaller.appspotmail.com>
To:     bcm-kernel-feedback-list@broadcom.com, bhelgaas@google.com,
        bp@alien8.de, devel@driverdev.osuosl.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, hpa@zytor.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, lorenzo.pieralisi@arm.com,
        mchehab@kernel.org, mingo@redhat.com, nsaenzjulienne@suse.de,
        pbonzini@redhat.com, robh@kernel.org,
        sean.j.christopherson@intel.com, seanjc@google.com,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    78e709522d2c Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16131d2b300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2150ebd7e72fa695
dashboard link: https://syzkaller.appspot.com/bug?extid=05017ad275a64a3246f8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b72895300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c42853300000

The issue was bisected to:

commit 5c313e22d61f8c27ab001ec40f823d2a19cd5e68
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu Oct 8 05:26:39 2020 +0000

    Merge remote-tracking branch 'usb/usb-next' into master

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15864a10500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17864a10500000
console output: https://syzkaller.appspot.com/x/log.txt?x=13864a10500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+05017ad275a64a3246f8@syzkaller.appspotmail.com
Fixes: 5c313e22d61f ("Merge remote-tracking branch 'usb/usb-next' into master")

BUG: spinlock bad magic on CPU#0, syz-executor959/7639
 lock: 0xffff8880b9c00040, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
CPU: 0 PID: 7639 Comm: syz-executor959 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 debug_spin_lock_before kernel/locking/spinlock_debug.c:85 [inline]
 do_raw_spin_lock+0x216/0x2b0 kernel/locking/spinlock_debug.c:114
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:117 [inline]
 _raw_spin_lock_irqsave+0x41/0x50 kernel/locking/spinlock.c:162
 srcu_might_be_idle kernel/rcu/srcutree.c:767 [inline]
 synchronize_srcu+0x4f/0x1c0 kernel/rcu/srcutree.c:1008
 kvm_mmu_uninit_vm+0x18/0x30 arch/x86/kvm/mmu/mmu.c:5711
 kvm_arch_destroy_vm+0x4e7/0x680 arch/x86/kvm/x86.c:11331
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1094 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4583 [inline]
 kvm_dev_ioctl+0x12e3/0x1ac0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4638
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4458f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb1165fa278 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004ca410 RCX: 00000000004458f9
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 00000000004ca41c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000049a0ac
R13: 00007fb1165fa280 R14: 6d766b2f7665642f R15: 00000000004ca418
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 7639 Comm: syz-executor959 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rcu_segcblist_enqueue+0xb9/0x130 kernel/rcu/rcu_segcblist.c:348
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 89 ea 48 c1 ea 03 <80> 3c 02 00 75 21 48 89 75 00 48 89 73 20 48 83 c4 08 5b 5d c3 48
RSP: 0018:ffffc90003287be0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880b9d00080 RCX: ffffffff815bd1d0
RDX: 0000000000000000 RSI: ffffc90003287cc8 RDI: ffff8880b9d000a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000650f6e R11: 0000000000000000 R12: ffffc90003287cc8
R13: ffff8880b9d00080 R14: 0000000000000000 R15: ffff8880b9d00040
FS:  00007fb1165fa700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb1165d9718 CR3: 000000006ab6b000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 srcu_gp_start_if_needed+0x116/0xbc0 kernel/rcu/srcutree.c:823
 __call_srcu kernel/rcu/srcutree.c:883 [inline]
 __synchronize_srcu+0x21f/0x290 kernel/rcu/srcutree.c:929
 kvm_mmu_uninit_vm+0x18/0x30 arch/x86/kvm/mmu/mmu.c:5711
 kvm_arch_destroy_vm+0x4e7/0x680 arch/x86/kvm/x86.c:11331
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1094 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4583 [inline]
 kvm_dev_ioctl+0x12e3/0x1ac0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4638
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4458f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb1165fa278 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004ca410 RCX: 00000000004458f9
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000003
RBP: 00000000004ca41c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000049a0ac
R13: 00007fb1165fa280 R14: 6d766b2f7665642f R15: 00000000004ca418
Modules linked in:
---[ end trace 3a47816aa768583b ]---
RIP: 0010:rcu_segcblist_enqueue+0xb9/0x130 kernel/rcu/rcu_segcblist.c:348
Code: 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 20 48 89 ea 48 c1 ea 03 <80> 3c 02 00 75 21 48 89 75 00 48 89 73 20 48 83 c4 08 5b 5d c3 48
RSP: 0018:ffffc90003287be0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff8880b9d00080 RCX: ffffffff815bd1d0
RDX: 0000000000000000 RSI: ffffc90003287cc8 RDI: ffff8880b9d000a0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000650f6e R11: 0000000000000000 R12: ffffc90003287cc8
R13: ffff8880b9d00080 R14: 0000000000000000 R15: ffff8880b9d00040
FS:  00007fb1165fa700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb1165d9718 CR3: 000000006ab6b000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 7 bytes skipped:
   0:	df 48 89             	fisttps -0x77(%rax)
   3:	fa                   	cli
   4:	48 c1 ea 03          	shr    $0x3,%rdx
   8:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   c:	75 4e                	jne    0x5c
   e:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  15:	fc ff df
  18:	48 8b 6b 20          	mov    0x20(%rbx),%rbp
  1c:	48 89 ea             	mov    %rbp,%rdx
  1f:	48 c1 ea 03          	shr    $0x3,%rdx
* 23:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  27:	75 21                	jne    0x4a
  29:	48 89 75 00          	mov    %rsi,0x0(%rbp)
  2d:	48 89 73 20          	mov    %rsi,0x20(%rbx)
  31:	48 83 c4 08          	add    $0x8,%rsp
  35:	5b                   	pop    %rbx
  36:	5d                   	pop    %rbp
  37:	c3                   	retq
  38:	48                   	rex.W

