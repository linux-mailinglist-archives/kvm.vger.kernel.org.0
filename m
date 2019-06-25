Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441A355A2E
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 23:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfFYVrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 17:47:08 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45167 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfFYVrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 17:47:08 -0400
Received: by mail-io1-f69.google.com with SMTP id b197so10157iof.12
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 14:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UJMkyJRfZAWiYHQO3lkQRyIVJFbkUi74TqZBHCN7Auo=;
        b=o9o5sTxUsENxAvuEWLPx1b4zTfgo+g5hGHwDq/OtysLs8ocjoT/SNVyKrZ6Unh6Vkm
         wlX5+fKedD49oPOCWTKvtEv8JVGYPXYx1maW8yInLP2HZQPCLsBMvVD4qDbATeIl+DSP
         i+wzHhDgzZjTT48TQUKKP2aLvUMs+qfHG/A1/mDXjNSKaCeVNGDChR7K2wOgOjEiUZQO
         VEkWGQjpUfZYzm0973dY3g8Ms3os+eGlVW+xzkCTEEBq9LlqnH846oeesefRHFu7u0Ar
         /qoVpgV6iIIDHvgoTikjWtsyk0nqWWLgIlt8aikg7Cg1JPpRUxHlKuyWzUyRCwM3ndEh
         7yyg==
X-Gm-Message-State: APjAAAUgnvEEn0jrZH4RV9qRbW2Ehh51PUoq5TXIIxTNLyr9xculgl3o
        4zgOVtNTjruOLdkdr4ucgUfmwakohVOXLHnRbP9xjotm+kDV
X-Google-Smtp-Source: APXvYqyAaDeug+XSRMcY1hscRo0iI/PV7iVIJW/oB23694qZ8/PtfaNdxgoEdPyLafLNk9QV+H3egweaSrcC+TxpiPmjoWOpCZk4
MIME-Version: 1.0
X-Received: by 2002:a6b:b497:: with SMTP id d145mr1044980iof.17.1561499227149;
 Tue, 25 Jun 2019 14:47:07 -0700 (PDT)
Date:   Tue, 25 Jun 2019 14:47:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c05b7b058c2cde8a@google.com>
Subject: BUG: unable to handle kernel paging request in coalesced_mmio_write
From:   syzbot <syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=111932b1a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e5c77f8090a3b96b
dashboard link: https://syzkaller.appspot.com/bug?extid=983c866c3dd6efa3662a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13299fc9a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134b2826a00000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=108f9e06a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=148f9e06a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and  
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for  
details.
BUG: unable to handle page fault for address: ffffed12fb15ea1f
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21fff0067 P4D 21fff0067 PUD 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8945 Comm: syz-executor116 Not tainted 5.2.0-rc5+ #57
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:coalesced_mmio_write+0x28a/0x4d0  
arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:83
Code: 38 d0 7c 08 84 d2 0f 85 55 02 00 00 41 8b 47 04 48 8d 14 40 49 8d 7c  
d7 08 48 ba 00 00 00 00 00 fc ff df 48 89 fe 48 c1 ee 03 <80> 3c 16 00 0f  
85 1b 02 00 00 48 8d 14 40 48 be 00 00 00 00 00 fc
RSP: 0018:ffff8880a045f170 EFLAGS: 00010a02
RAX: 00000000f7d5760a RBX: 0000000000000000 RCX: ffffffff81080faa
RDX: dffffc0000000000 RSI: 1ffff112fb15ea1f RDI: ffff8897d8af50f8
RBP: ffff8880a045f1c0 R08: ffff888089e483c0 R09: 0000000000000000
R10: ffffed101408be1b R11: 0000000000000003 R12: 0000000000000001
R13: ffff8880a55dbf10 R14: 0000000000000001 R15: ffff88809cac4000
FS:  000055555573a940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed12fb15ea1f CR3: 00000000a0aee000 CR4: 00000000001426f0
Call Trace:
  kvm_iodevice_write include/kvm/iodev.h:54 [inline]
  __kvm_io_bus_write+0x29b/0x380  
arch/x86/kvm/../../../virt/kvm/kvm_main.c:3701
  kvm_io_bus_write+0x15c/0x290 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3726
  vcpu_mmio_write arch/x86/kvm/x86.c:5029 [inline]
  write_mmio+0x175/0x4e0 arch/x86/kvm/x86.c:5391
  emulator_read_write_onepage+0x429/0xd50 arch/x86/kvm/x86.c:5460
  emulator_read_write+0x1b7/0x5a0 arch/x86/kvm/x86.c:5509
  emulator_write_emulated+0x3c/0x50 arch/x86/kvm/x86.c:5546
  segmented_write+0xf0/0x150 arch/x86/kvm/emulate.c:1446
  writeback arch/x86/kvm/emulate.c:1808 [inline]
  writeback+0x3f4/0x6a0 arch/x86/kvm/emulate.c:1794
  x86_emulate_insn+0x1de1/0x48f0 arch/x86/kvm/emulate.c:5695
  x86_emulate_instruction+0xca3/0x1c50 arch/x86/kvm/x86.c:6509
  kvm_mmu_page_fault+0x370/0x1870 arch/x86/kvm/mmu.c:5430
  handle_ept_violation+0x1c8/0x500 arch/x86/kvm/vmx/vmx.c:5099
  vmx_handle_exit+0x280/0x1540 arch/x86/kvm/vmx/vmx.c:5861
  vcpu_enter_guest+0x1174/0x5f40 arch/x86/kvm/x86.c:8035
  vcpu_run arch/x86/kvm/x86.c:8099 [inline]
  kvm_arch_vcpu_ioctl_run+0x423/0x1740 arch/x86/kvm/x86.c:8307
  kvm_vcpu_ioctl+0x4dc/0xf90 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2755
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xd5f/0x1380 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4444e9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 1b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff46b48808 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fff46b48810 RCX: 00000000004444e9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000402240 R09: 0000000000402240
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000405590
R13: 0000000000405620 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: ffffed12fb15ea1f
---[ end trace 84ecc85af6872381 ]---
RIP: 0010:coalesced_mmio_write+0x28a/0x4d0  
arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:83
Code: 38 d0 7c 08 84 d2 0f 85 55 02 00 00 41 8b 47 04 48 8d 14 40 49 8d 7c  
d7 08 48 ba 00 00 00 00 00 fc ff df 48 89 fe 48 c1 ee 03 <80> 3c 16 00 0f  
85 1b 02 00 00 48 8d 14 40 48 be 00 00 00 00 00 fc
RSP: 0018:ffff8880a045f170 EFLAGS: 00010a02
RAX: 00000000f7d5760a RBX: 0000000000000000 RCX: ffffffff81080faa
RDX: dffffc0000000000 RSI: 1ffff112fb15ea1f RDI: ffff8897d8af50f8
RBP: ffff8880a045f1c0 R08: ffff888089e483c0 R09: 0000000000000000
R10: ffffed101408be1b R11: 0000000000000003 R12: 0000000000000001
R13: ffff8880a55dbf10 R14: 0000000000000001 R15: ffff88809cac4000
FS:  000055555573a940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed12fb15ea1f CR3: 00000000a0aee000 CR4: 00000000001426f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
