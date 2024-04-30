Return-Path: <kvm+bounces-16222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 46C318B6CC1
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 10:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDC421F236C0
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 08:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E59B782C8E;
	Tue, 30 Apr 2024 08:25:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAAB7BB15
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 08:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714465528; cv=none; b=gcivYc5V1032El3fEqLZR4Kz7P6g/VeA8efMwD8OErLIKUc/RhLDnAI3lJmAMv5NKBKV2pCv9zgxtP9zxKRIMtZdd+jgH/xpOalJmEd4eE2SgRwOgw7qrDBXvs3HT9vJYuYy7X1iDFN3yrZsEmMnQdALtsVGeEdKRfuNnr013Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714465528; c=relaxed/simple;
	bh=4ixa4AJA1AcmugQgrnRc890ddG3UNGgKP0VNegmldDk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tggim2QzifkvYWy00WLc1nImGHADi1lOKOsJ/s0jeYSXdaPNrEHceWdvmwPSkEcHnsjkakTwEUF+li34AdCBqnx+KmWRHW+XG860X9zRbByMMZTJWSFVdGHyapscQL54Z3YUOufpasbW4OCp5JKXUx7QHqcUAcLGvzpE8VmRbZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7dec58efbfaso290478339f.3
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 01:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714465526; x=1715070326;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BDLpZykDX0uPFmtajDTO6uKyG/VoHz6dOOFLwRLwY6s=;
        b=kfqTAohBjC4JFjKrHzCJ4KYsAvIC+fbMsXZM5dD105kwofhLjPZ9qFfr+c9j4nYT/7
         +1DolGRgqbLX42US3+n2TNaPcqF0qOVIbSf21rKMLjDX9blXQYw9fYcGndTcHhsPjv8c
         /wxsNQVtUYjaZUgQrRV9j0743R5KlwJCO2uudKqYLToU9fnLfGuQRRBaS/rLk5j26Xo5
         x8F6/hA87m29SwlAd/vBJ2EnsFEvoUsERkB5oVkUH1pNtr2ZIkeeefSls6qmAIi+KQC3
         StCnIroLCj9rTd0ZesOxqJ6iEEEUhkXq+TejzEOcjb0i1m7aKYWrDoKkmzIdosGgLjbp
         EVcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrhzxhkiyk72QOUuiNkltxILzX5uRhnEbg/+j/OqbzSbukpUK0hHKhK03aaVbw0xlstZtNq7aMb8cAY2EOUs8skTfD
X-Gm-Message-State: AOJu0YwfIXzxRWn/kLr8ogwfSmpo1u2BtesHl9wGL86jv2FrdcVlC8fX
	TUPaFecDqKccPGtNRlFE+drhmXOpfdWFKERThdOOcgHg1m83285Q9qGIRdyPl+l+J43smhTeXWP
	3nY7ZzqpZ0YPMCZy+Sir/hSGbb/BRaEDMQbUg2aggqPTm7RB8ZCaxnjY=
X-Google-Smtp-Source: AGHT+IHcbObiGhPgHA7wp+8WAI09h+H5TEn3Q68GmZGA3hr6s0jXcTjYJIrzj7D76eVd1Kl07nXz0U2+Eow/PP684H8r8lgwxYyt
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a43:b0:36c:5029:1925 with SMTP id
 u3-20020a056e021a4300b0036c50291925mr240729ilv.0.1714465526073; Tue, 30 Apr
 2024 01:25:26 -0700 (PDT)
Date: Tue, 30 Apr 2024 01:25:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a9613006174c1c4c@google.com>
Subject: [syzbot] [net?] [virt?] [kvm?] KASAN: slab-use-after-free Read in vhost_task_fn
From: syzbot <syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com>
To: jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	michael.christie@oracle.com, mst@redhat.com, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bb7a2467e6be Add linux-next specific files for 20240426
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=123bf96b180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c6a0288262dd108
dashboard link: https://syzkaller.appspot.com/bug?extid=98edc2df894917b3431f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c8a4ef180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c30028980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5175af7dda64/disk-bb7a2467.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/70db0462e868/vmlinux-bb7a2467.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3217fb825698/bzImage-bb7a2467.xz

The issue was bisected to:

commit a3df30984f4faf82d63d2a96f8ac773403ce935d
Author: Mike Christie <michael.christie@oracle.com>
Date:   Sat Mar 16 00:47:06 2024 +0000

    vhost_task: Handle SIGKILL by flushing work and exiting

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14423917180000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16423917180000
console output: https://syzkaller.appspot.com/x/log.txt?x=12423917180000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com
Fixes: a3df30984f4f ("vhost_task: Handle SIGKILL by flushing work and exiting")

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-use-after-free in atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
BUG: KASAN: slab-use-after-free in __mutex_unlock_slowpath+0xef/0x750 kernel/locking/mutex.c:921
Read of size 8 at addr ffff88802a9d9080 by task vhost-5103/5104

CPU: 1 PID: 5104 Comm: vhost-5103 Not tainted 6.9.0-rc5-next-20240426-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
 __mutex_unlock_slowpath+0xef/0x750 kernel/locking/mutex.c:921
 vhost_task_fn+0x3bc/0x3f0 kernel/vhost_task.c:65
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Allocated by task 5103:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 kmalloc_trace_noprof+0x19c/0x2b0 mm/slub.c:4146
 kmalloc_noprof include/linux/slab.h:660 [inline]
 kzalloc_noprof include/linux/slab.h:778 [inline]
 vhost_task_create+0x149/0x300 kernel/vhost_task.c:134
 vhost_worker_create+0x17b/0x3f0 drivers/vhost/vhost.c:667
 vhost_dev_set_owner+0x563/0x940 drivers/vhost/vhost.c:945
 vhost_dev_ioctl+0xda/0xda0 drivers/vhost/vhost.c:2108
 vhost_vsock_dev_ioctl+0x2bb/0xfa0 drivers/vhost/vsock.c:875
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5103:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2190 [inline]
 slab_free mm/slub.c:4430 [inline]
 kfree+0x149/0x350 mm/slub.c:4551
 vhost_worker_destroy drivers/vhost/vhost.c:629 [inline]
 vhost_workers_free drivers/vhost/vhost.c:648 [inline]
 vhost_dev_cleanup+0x9b0/0xba0 drivers/vhost/vhost.c:1051
 vhost_vsock_dev_release+0x3aa/0x410 drivers/vhost/vsock.c:751
 __fput+0x406/0x8b0 fs/file_table.c:422
 __do_sys_close fs/open.c:1555 [inline]
 __se_sys_close fs/open.c:1540 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1540
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88802a9d9000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 128 bytes inside of
 freed 512-byte region [ffff88802a9d9000, ffff88802a9d9200)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2a9d8
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff80000000040(head|node=0|zone=1|lastcpupid=0xfff)
page_type: 0xffffefff(slab)
raw: 00fff80000000040 ffff888015041c80 ffffea00007e4200 0000000000000002
raw: 0000000000000000 0000000080100010 00000001ffffefff 0000000000000000
head: 00fff80000000040 ffff888015041c80 ffffea00007e4200 0000000000000002
head: 0000000000000000 0000000080100010 00000001ffffefff 0000000000000000
head: 00fff80000000002 ffffea0000aa7601 ffffffffffffffff 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4750, tgid 4750 (S40network), ts 45835903170, free_ts 45731176473
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1468
 prep_new_page mm/page_alloc.c:1476 [inline]
 get_page_from_freelist+0x2ce2/0x2d90 mm/page_alloc.c:3438
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4696
 __alloc_pages_node_noprof include/linux/gfp.h:244 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:271 [inline]
 alloc_slab_page+0x5f/0x120 mm/slub.c:2259
 allocate_slab+0x5a/0x2e0 mm/slub.c:2422
 new_slab mm/slub.c:2475 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3661
 __slab_alloc+0x58/0xa0 mm/slub.c:3751
 __slab_alloc_node mm/slub.c:3804 [inline]
 slab_alloc_node mm/slub.c:3982 [inline]
 __do_kmalloc_node mm/slub.c:4114 [inline]
 __kmalloc_noprof+0x25e/0x400 mm/slub.c:4128
 kmalloc_noprof include/linux/slab.h:664 [inline]
 kzalloc_noprof include/linux/slab.h:778 [inline]
 tomoyo_init_log+0x1b3e/0x2050 security/tomoyo/audit.c:275
 tomoyo_supervisor+0x38a/0x11f0 security/tomoyo/common.c:2089
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission+0x243/0x360 security/tomoyo/file.c:587
 tomoyo_check_open_permission+0x2fb/0x500 security/tomoyo/file.c:777
 security_file_open+0x6a/0x730 security/security.c:2962
 do_dentry_open+0x36c/0x1720 fs/open.c:942
 do_open fs/namei.c:3650 [inline]
 path_openat+0x289f/0x3280 fs/namei.c:3807
 do_filp_open+0x235/0x490 fs/namei.c:3834
page last free pid 4749 tgid 4749 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1088 [inline]
 free_unref_page+0xd22/0xea0 mm/page_alloc.c:2601
 __slab_free+0x31b/0x3d0 mm/slub.c:4341
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9e/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:322
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3934 [inline]
 slab_alloc_node mm/slub.c:3994 [inline]
 kmem_cache_alloc_noprof+0x135/0x290 mm/slub.c:4001
 getname_flags+0xbd/0x4f0 fs/namei.c:139
 vfs_fstatat+0x11c/0x190 fs/stat.c:303
 __do_sys_newfstatat fs/stat.c:468 [inline]
 __se_sys_newfstatat fs/stat.c:462 [inline]
 __x64_sys_newfstatat+0x125/0x1b0 fs/stat.c:462
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88802a9d8f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88802a9d9000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802a9d9080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88802a9d9100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802a9d9180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

