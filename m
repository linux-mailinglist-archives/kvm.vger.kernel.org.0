Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E3A4E73FA
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 14:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245068AbiCYNMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbiCYNMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 09:12:02 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA133917E
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 06:10:28 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id g5-20020a92dd85000000b002c79aa519f4so4548493iln.10
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 06:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KosOGWYuEGV0sf8h8ACjx6c7aC3WaEJkx0os9Bmapfg=;
        b=vOD0EkMW4UlTgrkhTvaMKiPYI/rclZ1oWUWny4PrWwBqWBzr1mFpAvOYKDM11LRZi3
         m7UJt6OoUNpS5TszEkUAhj5H8OJ+xhDRn/TPVq6EfvmdRklLdXzycBFW2qULQL3W/rKs
         DdcbGqHhgMWPakBMJrzaBtm8qb+WonxT0gWp/DUK9BT+d6OJfZUGzgsBYQHX/ycuyM3I
         XAGYjeZG0reSnbYZxn3e0ETSbwXi3QXfumFYu5nFkrFvVC8AR5mCG+XcmlyBGRZTH9kx
         5eI1yaUamr3w0OBN3dnI7AT9p5NBYWIbSkAXGwtbhR+1Wv+8Pvk/WNRUhwzdwKe3PtWr
         NrqA==
X-Gm-Message-State: AOAM533C7GCfmU9Bk36e6i6KfM65WEzdGMr0k0TWVpdBkyd144X2ruNi
        kUEgvzzhyXxfeBxqJCKFVx2szetVTJC7xRJTQrI0vmy3S+ci
X-Google-Smtp-Source: ABdhPJwQ5X+MQfNKFOQwNMsTy53/dAX5YJcxGhWsealzYCzZuW09tAa4Gyb2Ir1wBVWtVU+IN/lteS+zQndAqYqLWUhRAerS7rBA
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1389:b0:323:1301:7d2e with SMTP id
 w9-20020a056638138900b0032313017d2emr3393615jad.87.1648213826586; Fri, 25 Mar
 2022 06:10:26 -0700 (PDT)
Date:   Fri, 25 Mar 2022 06:10:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5cb1305db0aaf48@google.com>
Subject: [syzbot] general protection fault in kvm_mmu_uninit_tdp_mmu
From:   syzbot <syzbot+717ed82268812a643b28@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f9006d9269ea Add linux-next specific files for 20220321
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=101191bd700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c1619ffa2b0259a1
dashboard link: https://syzkaller.appspot.com/bug?extid=717ed82268812a643b28
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109e8f5d700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1666180b700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+717ed82268812a643b28@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000038: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000001c0-0x00000000000001c7]
CPU: 0 PID: 3614 Comm: syz-executor358 Tainted: G        W         5.17.0-next-20220321-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:flush_workqueue+0xf8/0x1440 kernel/workqueue.c:2828
Code: ff 89 de e8 ea 02 2c 00 84 db 0f 84 28 0f 00 00 e8 fd fe 2b 00 48 8b 85 e8 fe ff ff 48 8d b8 c0 01 00 00 48 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 74 08 3c 03 0f 8e f9 12 00 00 48 8b 85 e8 fe
RSP: 0018:ffffc90003affba8 EFLAGS: 00010202
RAX: 0000000000000038 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8880184b57c0 RSI: ffffffff814caa33 RDI: 00000000000001c0
RBP: ffffc90003affd18 R08: 0000000000000002 R09: 0000000000000001
R10: ffffffff814caa26 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffc90003affd70 R14: ffffc90003b29000 R15: ffffc90003b2a240
FS:  00007f26eaecd700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020404030 CR3: 00000000246a9000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvm_mmu_uninit_tdp_mmu+0x7f/0x170 arch/x86/kvm/mmu/tdp_mmu.c:51
 kvm_arch_destroy_vm+0x350/0x470 arch/x86/kvm/x86.c:11799
 kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1144 [inline]
 kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4736 [inline]
 kvm_dev_ioctl+0x104d/0x1c00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4791
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f26eaf5dac9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f26eaecd308 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f26eafe5448 RCX: 00007f26eaf5dac9
RDX: 0000000000000000 RSI: 000000000000ae01 RDI: 0000000000000005
RBP: 00007f26eafe5440 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f26eafe544c
R13: 00007f26eafb3074 R14: 6d766b2f7665642f R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:flush_workqueue+0xf8/0x1440 kernel/workqueue.c:2828
Code: ff 89 de e8 ea 02 2c 00 84 db 0f 84 28 0f 00 00 e8 fd fe 2b 00 48 8b 85 e8 fe ff ff 48 8d b8 c0 01 00 00 48 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 74 08 3c 03 0f 8e f9 12 00 00 48 8b 85 e8 fe
RSP: 0018:ffffc90003affba8 EFLAGS: 00010202

RAX: 0000000000000038 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8880184b57c0 RSI: ffffffff814caa33 RDI: 00000000000001c0
RBP: ffffc90003affd18 R08: 0000000000000002 R09: 0000000000000001
R10: ffffffff814caa26 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffc90003affd70 R14: ffffc90003b29000 R15: ffffc90003b2a240
FS:  00007f26eaecd700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020404030 CR3: 00000000246a9000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	ff 89 de e8 ea 02    	decl   0x2eae8de(%rcx)
   6:	2c 00                	sub    $0x0,%al
   8:	84 db                	test   %bl,%bl
   a:	0f 84 28 0f 00 00    	je     0xf38
  10:	e8 fd fe 2b 00       	callq  0x2bff12
  15:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
  1c:	48 8d b8 c0 01 00 00 	lea    0x1c0(%rax),%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	74 08                	je     0x3b
  33:	3c 03                	cmp    $0x3,%al
  35:	0f 8e f9 12 00 00    	jle    0x1334
  3b:	48                   	rex.W
  3c:	8b                   	.byte 0x8b
  3d:	85 e8                	test   %ebp,%eax
  3f:	fe                   	.byte 0xfe


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
