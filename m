Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47C8401180
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 22:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238014AbhIEUX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 16:23:29 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:42829 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236049AbhIEUX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 16:23:28 -0400
Received: by mail-il1-f200.google.com with SMTP id z14-20020a92d18e0000b029022418b34bc9so2789725ilz.9
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 13:22:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+rPDgNSzrLHkZMxn4POnNNUzX99qgQeVfqX1qOJ/i+Y=;
        b=oT9xChzq6vp96h4sFffef+11U+9l4YfN4uV5sox5aA+tny05xvVc2M2eWftiPxNM9n
         iXo+S6mEyWg40hDWjIgUKAv8zYY8KeyapKeRFuMIBEzSzlTGiMvozpTqAvPGf2lbEQN1
         upMhyktX4WhHYFRoc6y9T1EQiP1tLdGeGTW+Q54OOykiiVpUk78Qb/ESadYmNETQPK/G
         UmO19r2dh+TDULFb17lQro2iycP+uNONpC1GXVFEi7hm+wx2wHLjbDQ1nDBzY/2O2U/q
         L4WnKLVlokRvaBlSIn2Banq1Vf7Gcnezc4jF0Zt2LJSp4RdP2C8cnQTdeSTSQRyJgfqG
         ECjg==
X-Gm-Message-State: AOAM531llUZ2RlFY/m17QbbZNGxFbw+Qx+dJ3iwJSUDDnN2OLBnVOb7c
        sSlaVCJEJdNS9TWtiEaoQUuqadIZnKRQ7yWXqd/vucuOg2Ms
X-Google-Smtp-Source: ABdhPJyCiLjtVk7bcmv5SV1YROdQgrWx5SlnNRnIvCzXPcYQfZnvsh4mWSBPjmQnqAVqRELawgeTZtjwlG+o49ITr8nYinh8+HbG
MIME-Version: 1.0
X-Received: by 2002:a92:4453:: with SMTP id a19mr6024050ilm.221.1630873344577;
 Sun, 05 Sep 2021 13:22:24 -0700 (PDT)
Date:   Sun, 05 Sep 2021 13:22:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006096fa05cb454a9c@google.com>
Subject: [syzbot] WARNING: kmalloc bug in memslot_rmap_alloc
From:   syzbot <syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f1583cb1be35 Merge tag 'linux-kselftest-next-5.15-rc1' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11dd6315300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c582b69de20dde2
dashboard link: https://syzkaller.appspot.com/bug?extid=e0de2333cbf95ea473e8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15db7e5d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170e66cd300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com

L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 8419 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 0 PID: 8419 Comm: syz-executor520 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 ed 17 0d 00 49 89 c5 e9 69 ff ff ff e8 90 0a d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 7f 0a d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 66
RSP: 0018:ffffc90001a7f828 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888027ee5580 RSI: ffffffff81a51341 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: 00000000ffffffff
R10: ffffffff81a512fe R11: 0000000000000000 R12: 0000000380000000
R13: 0000000000000000 R14: 00000000ffffffff R15: dffffc0000000000
FS:  0000000000707300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faeea03f6c0 CR3: 0000000074a57000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvmalloc include/linux/mm.h:806 [inline]
 kvmalloc_array include/linux/mm.h:824 [inline]
 kvcalloc include/linux/mm.h:829 [inline]
 memslot_rmap_alloc+0xf6/0x310 arch/x86/kvm/x86.c:11320
 kvm_alloc_memslot_metadata arch/x86/kvm/x86.c:11388 [inline]
 kvm_arch_prepare_memory_region+0x48d/0x610 arch/x86/kvm/x86.c:11462
 kvm_set_memslot+0xfe/0x1700 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1505
 __kvm_set_memory_region+0x761/0x10e0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1668
 kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1689 [inline]
 kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1701 [inline]
 kvm_vm_ioctl+0x4c6/0x2330 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4236
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ee99
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc276d5138 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ee99
RDX: 00000000200005c0 RSI: 000000004020ae46 RDI: 0000000000000004
RBP: 0000000000402e80 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402f10
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
