Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F5273D852
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 09:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjFZHQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 03:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjFZHQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 03:16:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FA41B9
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 00:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687763729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oRpAZ7Nti36ln6bLh1OetP04CWB4zN6419jS3K9TtVg=;
        b=iXFHdR/Xz5xH4s8IagMU1C/ymfgeAwCew6qwmQcQOEI5LHbqLagzV0KW2/sL9hADwvdIFY
        bx3jG067bdh0Jqo+uKGf602BuxOB752stduwxszIEpuSkYYUs4ysb+hAW8eZRQ4jnYqQun
        3vJTH6T5CCtuAa0GLOrckUW6+eFnOdI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-e9B3AvVAMtyvZ99Uayfquw-1; Mon, 26 Jun 2023 03:15:27 -0400
X-MC-Unique: e9B3AvVAMtyvZ99Uayfquw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-313e65772d8so2341766f8f.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 00:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687763726; x=1690355726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oRpAZ7Nti36ln6bLh1OetP04CWB4zN6419jS3K9TtVg=;
        b=ktwIq14hSK7Q9qyom2msgKxVf3pKVZX0r1Njmq7sQ8pRxt8Z7AIaxe+GM11/KI9vEF
         OrhQpYbg6vBotg8acLM0rWz3wLuceUe4no7KPyl+Ng5KCanMg8qUGXXehEqAoQPQfYae
         +008Owuu1+vHDS89Q21qeCaLoFR7lqBkhHR1MKT8FJ9Y2NMSYTxS1nwmlvy9xHddR9lN
         e728MEueeUGqqBAqud4GYaxHbhcqoGn/hteLxoSV5D3zI9SMLOQIAgT8F49598XgRKr7
         bg1ufgdCCPVFYVeKeTRRWN54WUWkphnv1oYGvQsU9mEN03kf9Y97wXpwHCDO3g9kdWZh
         hbew==
X-Gm-Message-State: AC+VfDwrasAiXGR+QriBkdUPCYF7cXirVeu1FvH+X6xU+jzxsRWth2kI
        lWYL3oWtvIUB2CiQpvQM6kH2cGoRhb3J/uxgR1FSCLLZr7F5NiZnEua7JEU+3VZ7AmINU5wkuPy
        qfvc8po+05Giz
X-Received: by 2002:a5d:63c5:0:b0:30d:673e:1547 with SMTP id c5-20020a5d63c5000000b0030d673e1547mr31614815wrw.41.1687763726394;
        Mon, 26 Jun 2023 00:15:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4IfQOVFgnyM9im+2Beb7wrvIRhCpIKB6kM8gY1Yc9KBzl/+EAkyeCECJFGYDJJTl85veKcRQ==
X-Received: by 2002:a5d:63c5:0:b0:30d:673e:1547 with SMTP id c5-20020a5d63c5000000b0030d673e1547mr31614793wrw.41.1687763726045;
        Mon, 26 Jun 2023 00:15:26 -0700 (PDT)
Received: from redhat.com ([2.52.156.102])
        by smtp.gmail.com with ESMTPSA id m8-20020adffe48000000b002c71b4d476asm6416594wrs.106.2023.06.26.00.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 00:15:25 -0700 (PDT)
Date:   Mon, 26 Jun 2023 03:15:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     syzbot <syzbot+8540db210d403f1aa214@syzkaller.appspotmail.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.christie@oracle.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] [net?] [virt?] [kvm?] KASAN: slab-use-after-free Read
 in __vhost_vq_attach_worker
Message-ID: <20230626031411-mutt-send-email-mst@kernel.org>
References: <000000000000df3e3b05ff02fe20@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000df3e3b05ff02fe20@google.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 12:06:54AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8d2be868b42c Add linux-next specific files for 20230623
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12872950a80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d8ac8dd33677e8e0
> dashboard link: https://syzkaller.appspot.com/bug?extid=8540db210d403f1aa214
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c1b70f280000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=122ee4cb280000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/2a004483aca3/disk-8d2be868.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5688cb13b277/vmlinux-8d2be868.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/76de0b63bc53/bzImage-8d2be868.xz
> 
> The issue was bisected to:
> 
> commit 21a18f4a51896fde11002165f0e7340f4131d6a0
> Author: Mike Christie <michael.christie@oracle.com>
> Date:   Tue Jun 13 01:32:46 2023 +0000
> 
>     vhost: allow userspace to create workers
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=130850bf280000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=108850bf280000
> console output: https://syzkaller.appspot.com/x/log.txt?x=170850bf280000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8540db210d403f1aa214@syzkaller.appspotmail.com
> Fixes: 21a18f4a5189 ("vhost: allow userspace to create workers")

Mike, would appreciate prompt attention to this as I am preparing
a pull request for the merge window and need to make a
decision on whether to include your userspace-controlled
threading patchset.

Thanks!


> ==================================================================
> BUG: KASAN: slab-use-after-free in __mutex_lock_common kernel/locking/mutex.c:582 [inline]
> BUG: KASAN: slab-use-after-free in __mutex_lock+0x1029/0x1350 kernel/locking/mutex.c:747
> Read of size 8 at addr ffff8880703fff68 by task syz-executor204/5105
> 
> CPU: 0 PID: 5105 Comm: syz-executor204 Not tainted 6.4.0-rc7-next-20230623-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>  print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:364
>  print_report mm/kasan/report.c:475 [inline]
>  kasan_report+0x11d/0x130 mm/kasan/report.c:588
>  __mutex_lock_common kernel/locking/mutex.c:582 [inline]
>  __mutex_lock+0x1029/0x1350 kernel/locking/mutex.c:747
>  __vhost_vq_attach_worker+0xe7/0x390 drivers/vhost/vhost.c:678
>  vhost_dev_set_owner+0x670/0xa60 drivers/vhost/vhost.c:892
>  vhost_net_set_owner drivers/vhost/net.c:1687 [inline]
>  vhost_net_ioctl+0x668/0x16a0 drivers/vhost/net.c:1737
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x19d/0x210 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fe7a9715629
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 21 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe7a96ba208 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007fe7a9715629
> RDX: 0000000000000000 RSI: 000000000000af01 RDI: 0000000000000003
> RBP: 00007fe7a979e240 R08: 00007fe7a979e248 R09: 00007fe7a979e248
> R10: 00007fe7a979e248 R11: 0000000000000246 R12: 00007fe7a979e24c
> R13: 00007ffcfa04d48f R14: 00007fe7a96ba300 R15: 0000000000022000
>  </TASK>
> 
> Allocated by task 5105:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  ____kasan_kmalloc mm/kasan/common.c:374 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:333 [inline]
>  __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
>  kmalloc include/linux/slab.h:579 [inline]
>  kzalloc include/linux/slab.h:700 [inline]
>  vhost_worker_create+0x9c/0x320 drivers/vhost/vhost.c:627
>  vhost_dev_set_owner+0x5b9/0xa60 drivers/vhost/vhost.c:885
>  vhost_net_set_owner drivers/vhost/net.c:1687 [inline]
>  vhost_net_ioctl+0x668/0x16a0 drivers/vhost/net.c:1737
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x19d/0x210 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Freed by task 5108:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  kasan_save_free_info+0x2b/0x40 mm/kasan/generic.c:521
>  ____kasan_slab_free mm/kasan/common.c:236 [inline]
>  ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
>  kasan_slab_free include/linux/kasan.h:164 [inline]
>  slab_free_hook mm/slub.c:1792 [inline]
>  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1818
>  slab_free mm/slub.c:3801 [inline]
>  __kmem_cache_free+0xb8/0x2d0 mm/slub.c:3814
>  vhost_worker_destroy drivers/vhost/vhost.c:600 [inline]
>  vhost_workers_free drivers/vhost/vhost.c:615 [inline]
>  vhost_dev_cleanup+0x66b/0x850 drivers/vhost/vhost.c:991
>  vhost_dev_reset_owner+0x25/0x160 drivers/vhost/vhost.c:923
>  vhost_net_reset_owner drivers/vhost/net.c:1621 [inline]
>  vhost_net_ioctl+0x807/0x16a0 drivers/vhost/net.c:1735
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x19d/0x210 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> The buggy address belongs to the object at ffff8880703fff00
>  which belongs to the cache kmalloc-cg-192 of size 192
> The buggy address is located 104 bytes inside of
>  freed 192-byte region [ffff8880703fff00, ffff8880703fffc0)
> 
> The buggy address belongs to the physical page:
> page:ffffea0001c0ffc0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x703ff
> flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
> page_type: 0xffffffff()
> raw: 00fff00000000200 ffff88801284ddc0 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x16cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NORETRY), pid 5034, tgid 5034 (syz-executor204), ts 72916757418, free_ts 72797036103
>  set_page_owner include/linux/page_owner.h:31 [inline]
>  post_alloc_hook+0x2db/0x350 mm/page_alloc.c:1570
>  prep_new_page mm/page_alloc.c:1577 [inline]
>  get_page_from_freelist+0xfd9/0x2c40 mm/page_alloc.c:3257
>  __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4513
>  alloc_pages+0x1aa/0x270 mm/mempolicy.c:2279
>  alloc_slab_page mm/slub.c:1862 [inline]
>  allocate_slab+0x25f/0x390 mm/slub.c:2009
>  new_slab mm/slub.c:2062 [inline]
>  ___slab_alloc+0xbc3/0x15d0 mm/slub.c:3215
>  __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3314
>  __slab_alloc_node mm/slub.c:3367 [inline]
>  slab_alloc_node mm/slub.c:3460 [inline]
>  __kmem_cache_alloc_node+0x143/0x350 mm/slub.c:3509
>  __do_kmalloc_node mm/slab_common.c:984 [inline]
>  __kmalloc_node+0x51/0x1a0 mm/slab_common.c:992
>  kmalloc_node include/linux/slab.h:599 [inline]
>  kvmalloc_node+0xa2/0x1a0 mm/util.c:604
>  kvmalloc include/linux/slab.h:717 [inline]
>  kvzalloc include/linux/slab.h:725 [inline]
>  netif_alloc_rx_queues net/core/dev.c:9847 [inline]
>  alloc_netdev_mqs+0xbde/0x1270 net/core/dev.c:10660
>  ieee80211_if_add+0x1b7/0x19d0 net/mac80211/iface.c:2099
>  ieee80211_register_hw+0x37e5/0x40e0 net/mac80211/main.c:1407
>  mac80211_hwsim_new_radio+0x26e6/0x4c70 drivers/net/wireless/virtual/mac80211_hwsim.c:5303
>  hwsim_new_radio_nl+0xacf/0x1210 drivers/net/wireless/virtual/mac80211_hwsim.c:5983
>  genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:970
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1161 [inline]
>  free_unref_page_prepare+0x62e/0xcb0 mm/page_alloc.c:2384
>  free_unref_page+0x33/0x370 mm/page_alloc.c:2479
>  __unfreeze_partials+0x1fe/0x220 mm/slub.c:2647
>  qlink_free mm/kasan/quarantine.c:166 [inline]
>  qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:185
>  kasan_quarantine_reduce+0x195/0x220 mm/kasan/quarantine.c:292
>  __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
>  kasan_slab_alloc include/linux/kasan.h:188 [inline]
>  slab_post_alloc_hook mm/slab.h:750 [inline]
>  slab_alloc_node mm/slub.c:3470 [inline]
>  __kmem_cache_alloc_node+0x1ce/0x350 mm/slub.c:3509
>  __do_kmalloc_node mm/slab_common.c:984 [inline]
>  __kmalloc_node+0x51/0x1a0 mm/slab_common.c:992
>  kmalloc_node include/linux/slab.h:599 [inline]
>  kvmalloc_node+0xa2/0x1a0 mm/util.c:604
>  kvmalloc include/linux/slab.h:717 [inline]
>  seq_buf_alloc fs/seq_file.c:38 [inline]
>  seq_read_iter+0x7fb/0x12d0 fs/seq_file.c:210
>  kernfs_fop_read_iter+0x4ce/0x690 fs/kernfs/file.c:279
>  call_read_iter include/linux/fs.h:1865 [inline]
>  new_sync_read fs/read_write.c:389 [inline]
>  vfs_read+0x4a8/0x8d0 fs/read_write.c:470
>  ksys_read+0x122/0x250 fs/read_write.c:613
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Memory state around the buggy address:
>  ffff8880703ffe00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff8880703ffe80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> >ffff8880703fff00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                           ^
>  ffff8880703fff80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff888070400000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 
> If the bug is already fixed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to change bug's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the bug is a duplicate of another bug, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

