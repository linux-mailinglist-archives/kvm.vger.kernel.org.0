Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E8C7D90C7
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 10:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjJ0IL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 04:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjJ0IL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 04:11:27 -0400
Received: from mail-oa1-f77.google.com (mail-oa1-f77.google.com [209.85.160.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7021A1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:11:25 -0700 (PDT)
Received: by mail-oa1-f77.google.com with SMTP id 586e51a60fabf-1e98b1bad34so2221939fac.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:11:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698394284; x=1698999084;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EQ32SRc19lBHfQ6VyTvyZZBauBB8JfuUmyD+6MpGeKg=;
        b=n1TQjIrpEEm6nJWQzUs06Paxzr4gitFDWYKMFXUzyX2HV1ulMmmv9SeW8aMKl7HhQc
         Qa3dax3gEk5etPZ2IMXRVVdal1pXFJUQq5HDO7rCd6p2+Jo9x1ajZfCKKGonqOeA2pO3
         4TVwk/1w7VhW+QbAhUu2mV1zquAtoTV6q9Y40KtYflAMoXoR1b3b8AqNdGr2/QtFfb8L
         MZQj+S0njIt191al2IHhj0MjVVFk85rq1Qv/ieiSZU/7TjxnIm1sgIX0yRWLWdlje/XG
         T9I+NvwP7LIVhWzLsLbOJkLWbtwg0oIk77yGswoBQ/PYejXCPxtsKk/K3O9jsDO78Vvb
         1CIA==
X-Gm-Message-State: AOJu0Yw1gQAiPWuysGGkKEbzSjWHUV3B2y1AYUWCw3OgpxJd4ER/p/pI
        TukRYqpHY4O51J9iRmKzjKXXq35Tw+rc6kMqKcdnNRxAo6K9
X-Google-Smtp-Source: AGHT+IHp0Zhq5ysKUW9EQGKuuBm1m1vlCI6USEOTyE5VkUqJAyr7SOitFaGiPT+nY6wj+KRAtcF+VMuCBQ9jKsH5bpQNtyi54oiq
MIME-Version: 1.0
X-Received: by 2002:a05:6870:b684:b0:1e9:c362:a397 with SMTP id
 cy4-20020a056870b68400b001e9c362a397mr984213oab.10.1698394284796; Fri, 27 Oct
 2023 01:11:24 -0700 (PDT)
Date:   Fri, 27 Oct 2023 01:11:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000008b2940608ae3ce9@google.com>
Subject: [syzbot] [net?] KMSAN: uninit-value in virtio_transport_recv_pkt
From:   syzbot <syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sgarzare@redhat.com,
        stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d90b0276af8f Merge tag 'hardening-v6.6-rc3' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=102c8b22680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f1a4029b69273f3
dashboard link: https://syzkaller.appspot.com/bug?extid=0c8ce1da0ac31abbadcd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101e58ec680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f7adb6680000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/83ae10beee39/disk-d90b0276.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c231992300f6/vmlinux-d90b0276.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6377c9c2ea97/bzImage-d90b0276.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in virtio_transport_recv_pkt+0x1c42/0x2580 net/vmw_vsock/virtio_transport_common.c:1421
 virtio_transport_recv_pkt+0x1c42/0x2580 net/vmw_vsock/virtio_transport_common.c:1421
 vsock_loopback_work+0x3e2/0x5d0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
 worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
 kthread+0x3e8/0x540 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

Uninit was stored to memory at:
 virtio_transport_space_update net/vmw_vsock/virtio_transport_common.c:1274 [inline]
 virtio_transport_recv_pkt+0x1ea4/0x2580 net/vmw_vsock/virtio_transport_common.c:1415
 vsock_loopback_work+0x3e2/0x5d0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
 worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
 kthread+0x3e8/0x540 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

Uninit was created at:
 slab_post_alloc_hook+0x12f/0xb70 mm/slab.h:767
 slab_alloc_node mm/slub.c:3478 [inline]
 kmem_cache_alloc_node+0x577/0xa80 mm/slub.c:3523
 kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:559
 __alloc_skb+0x318/0x740 net/core/skbuff.c:650
 alloc_skb include/linux/skbuff.h:1286 [inline]
 virtio_vsock_alloc_skb include/linux/virtio_vsock.h:66 [inline]
 virtio_transport_alloc_skb+0x8b/0x1170 net/vmw_vsock/virtio_transport_common.c:58
 virtio_transport_reset_no_sock net/vmw_vsock/virtio_transport_common.c:957 [inline]
 virtio_transport_recv_pkt+0x1531/0x2580 net/vmw_vsock/virtio_transport_common.c:1387
 vsock_loopback_work+0x3e2/0x5d0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
 worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
 kthread+0x3e8/0x540 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

CPU: 0 PID: 8 Comm: kworker/0:0 Not tainted 6.6.0-rc2-syzkaller-00337-gd90b0276af8f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
Workqueue: vsock-loopback vsock_loopback_work
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
