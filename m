Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB1F3BA780
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 08:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhGCGIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jul 2021 02:08:00 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:46940 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhGCGH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jul 2021 02:07:59 -0400
Received: by mail-io1-f72.google.com with SMTP id a24-20020a5d95580000b029044cbcdddd23so8563244ios.13
        for <kvm@vger.kernel.org>; Fri, 02 Jul 2021 23:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2Suic0YB5IaI2sNTAuhGKoxddYnm5vTPA4KBJ9zRTd0=;
        b=bCP4o/+r6zOORHIZfb3Xo8Wh/Xz60lTHJqrgGqt18ewo0cGAF9D9W1WDtbSc4XbjSG
         WB8izcktOU7sVF6hSC8hKlIs4mXVjEznVrNCIbe4fgN/X3A11s9Gmn1M4V9DAVhnKykM
         XSNYL8ae6BgeKcvcQhi/j4ZRjqRm66bTqT+SeKnJrwoxU9M/JyEa7xQmWWw5EEExH9xE
         WwXdZnIKj6ih2RethHzQ9JojhsDryX4c/G9LnA908MpwFSGSoSwAx5/g6kje1IQTFGIG
         MaulL8jiq7cBf5fWZse8nHOa5BVYXK5+CP3Km+b1c1yY1rOGnu2wfUrHbD2PrSURYqbA
         vH2A==
X-Gm-Message-State: AOAM530smfBpKerq9szbBcYtpGyaYCN/01mBiLSaTAfPBGt44O7RCazk
        Cj0O1zrzj7hRkBaTKTea1RfsBcHMXX2w8Ik2UShDQrQ05/iX
X-Google-Smtp-Source: ABdhPJzQcLmfp8fkdejaUJYvIT0RAzwwItZWgRjvm3hfytRNnJFI0z1P+DNROtz7cbDqSppEZCSmX1jQoyib4CtIlfJgqjU4XP9/
MIME-Version: 1.0
X-Received: by 2002:a5d:8b85:: with SMTP id p5mr2779107iol.43.1625292326022;
 Fri, 02 Jul 2021 23:05:26 -0700 (PDT)
Date:   Fri, 02 Jul 2021 23:05:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bfb6cf05c631db0b@google.com>
Subject: [syzbot] memory leak in kvm_dev_ioctl
From:   syzbot <syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e058a84b Merge tag 'drm-next-2021-07-01' of git://anongit...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=171fbbdc300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c46abb9076f44dc
dashboard link: https://syzkaller.appspot.com/bug?extid=c87d2efb740931ec76c7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119d1efc300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c58c28300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c87d2efb740931ec76c7@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff888101be6180 (size 32):
  comm "syz-executor591", pid 8432, jiffies 4294944117 (age 12.420s)
  hex dump (first 32 bytes):
    00 10 dc 00 00 c9 ff ff 20 ee 80 84 ff ff ff ff  ........ .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81043830>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff81043830>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff81043830>] kvm_create_vm_debugfs arch/x86/kvm/../../../virt/kvm/kvm_main.c:916 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4471 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl+0x710/0xb60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4498
    [<ffffffff81588bec>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff81588bec>] __do_sys_ioctl fs/ioctl.c:1069 [inline]
    [<ffffffff81588bec>] __se_sys_ioctl fs/ioctl.c:1055 [inline]
    [<ffffffff81588bec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:1055
    [<ffffffff84396e45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84396e45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888101c620a0 (size 32):
  comm "syz-executor591", pid 8432, jiffies 4294944117 (age 12.420s)
  hex dump (first 32 bytes):
    00 10 dc 00 00 c9 ff ff e0 ee 80 84 ff ff ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81043830>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff81043830>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff81043830>] kvm_create_vm_debugfs arch/x86/kvm/../../../virt/kvm/kvm_main.c:916 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4471 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl+0x710/0xb60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4498
    [<ffffffff81588bec>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff81588bec>] __do_sys_ioctl fs/ioctl.c:1069 [inline]
    [<ffffffff81588bec>] __se_sys_ioctl fs/ioctl.c:1055 [inline]
    [<ffffffff81588bec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:1055
    [<ffffffff84396e45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84396e45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888101c62360 (size 32):
  comm "syz-executor591", pid 8432, jiffies 4294944118 (age 12.410s)
  hex dump (first 32 bytes):
    00 10 dc 00 00 c9 ff ff 20 ef 80 84 ff ff ff ff  ........ .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81043830>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff81043830>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff81043830>] kvm_create_vm_debugfs arch/x86/kvm/../../../virt/kvm/kvm_main.c:916 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4471 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl+0x710/0xb60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4498
    [<ffffffff81588bec>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff81588bec>] __do_sys_ioctl fs/ioctl.c:1069 [inline]
    [<ffffffff81588bec>] __se_sys_ioctl fs/ioctl.c:1055 [inline]
    [<ffffffff81588bec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:1055
    [<ffffffff84396e45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84396e45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888101c62ba0 (size 32):
  comm "syz-executor591", pid 8432, jiffies 4294944118 (age 12.410s)
  hex dump (first 32 bytes):
    00 10 dc 00 00 c9 ff ff 60 ef 80 84 ff ff ff ff  ........`.......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81043830>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff81043830>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff81043830>] kvm_create_vm_debugfs arch/x86/kvm/../../../virt/kvm/kvm_main.c:916 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4471 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl+0x710/0xb60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4498
    [<ffffffff81588bec>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff81588bec>] __do_sys_ioctl fs/ioctl.c:1069 [inline]
    [<ffffffff81588bec>] __se_sys_ioctl fs/ioctl.c:1055 [inline]
    [<ffffffff81588bec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:1055
    [<ffffffff84396e45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84396e45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888101c62b20 (size 32):
  comm "syz-executor591", pid 8432, jiffies 4294944118 (age 12.410s)
  hex dump (first 32 bytes):
    00 10 dc 00 00 c9 ff ff a0 ef 80 84 ff ff ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81043830>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff81043830>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff81043830>] kvm_create_vm_debugfs arch/x86/kvm/../../../virt/kvm/kvm_main.c:916 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4471 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl+0x710/0xb60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4498
    [<ffffffff81588bec>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff81588bec>] __do_sys_ioctl fs/ioctl.c:1069 [inline]
    [<ffffffff81588bec>] __se_sys_ioctl fs/ioctl.c:1055 [inline]
    [<ffffffff81588bec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:1055
    [<ffffffff84396e45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84396e45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888101c62660 (size 32):
  comm "syz-executor591", pid 8432, jiffies 4294944118 (age 12.410s)
  hex dump (first 32 bytes):
    00 10 dc 00 00 c9 ff ff e0 ef 80 84 ff ff ff ff  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81043830>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff81043830>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff81043830>] kvm_create_vm_debugfs arch/x86/kvm/../../../virt/kvm/kvm_main.c:916 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4471 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl+0x710/0xb60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4498
    [<ffffffff81588bec>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff81588bec>] __do_sys_ioctl fs/ioctl.c:1069 [inline]
    [<ffffffff81588bec>] __se_sys_ioctl fs/ioctl.c:1055 [inline]
    [<ffffffff81588bec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:1055
    [<ffffffff84396e45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84396e45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888101c62460 (size 32):
  comm "syz-executor591", pid 8432, jiffies 4294944118 (age 12.410s)
  hex dump (first 32 bytes):
    00 10 dc 00 00 c9 ff ff 20 f0 80 84 ff ff ff ff  ........ .......
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81043830>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff81043830>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff81043830>] kvm_create_vm_debugfs arch/x86/kvm/../../../virt/kvm/kvm_main.c:916 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:4471 [inline]
    [<ffffffff81043830>] kvm_dev_ioctl+0x710/0xb60 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4498
    [<ffffffff81588bec>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff81588bec>] __do_sys_ioctl fs/ioctl.c:1069 [inline]
    [<ffffffff81588bec>] __se_sys_ioctl fs/ioctl.c:1055 [inline]
    [<ffffffff81588bec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:1055
    [<ffffffff84396e45>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff84396e45>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
