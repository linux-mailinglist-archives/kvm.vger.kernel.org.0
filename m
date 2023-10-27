Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EF17D94FD
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 12:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345738AbjJ0KQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 06:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345724AbjJ0KQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 06:16:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59E7DC
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 03:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698401734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/3RUe/42QKtvFOMbEd083sCtycO90wm6iZz1XgOvH0k=;
        b=X3sMzJrcUw5pmWZsRMWLzbz0A//T2IyC7SfNjR82zmXXUs2dE/uH7IJeImCkHf4Rl6FN4M
        7JH3XT7jqgZOZSwQPm6LdvqqR2BcV/dC9zPC19KtpO0AdOMvUxDqZAyF2DWni/I/obTm0L
        tehZxv+0smII3WXIFYmz5QFZsdj+NQE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-m75M3zjQMT-RsRtBCfn_gQ-1; Fri, 27 Oct 2023 06:15:32 -0400
X-MC-Unique: m75M3zjQMT-RsRtBCfn_gQ-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-41cba27f8b2so23260181cf.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 03:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698401732; x=1699006532;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/3RUe/42QKtvFOMbEd083sCtycO90wm6iZz1XgOvH0k=;
        b=NO8x0nTQhIKgoeteftmHF2i9vVlCjMM/eXwlCmG8tu3bZ+X0h4F0uyU/byR3uMTizJ
         mm7zhV1EOgygoanDIUzYKA583hmcCT1AGSUL7YSrtha/atx/2twqI7e1NX/njC1oRfNx
         iC6Gsm8kgYJpi7y3w1/0oNDcEdrVO9tioR3bZZRO9zdNMSQq6Z2QI1IT1c4WT+LTodjf
         phyE6P/vA6SxfbCqYp1rlqvyVFVcw7zEzgH43gUtS916DbsQQ9MW2qSJekOAnBrUIg8A
         krAXQ9beMGheyjyTR/LaJ58n72h3Y79Rp5vqpLNNY81JaoAGxe+2aMImqaxER0X7/ITu
         UcGA==
X-Gm-Message-State: AOJu0Yx8RBoiFgPjbmhU18lA65HagYH9gqqVNQdb0hLDLNkfibg8p5yK
        vM/OvI9JAkv2WwW3RQ2mWSfyUIb92NrWRfvwEMWBIfknQxP2BKr2tZYrb361XZ50Ikk7YJduRuI
        eEvGrKlfLo8Mw
X-Received: by 2002:ac8:5d07:0:b0:418:1235:5c86 with SMTP id f7-20020ac85d07000000b0041812355c86mr2910748qtx.43.1698401731785;
        Fri, 27 Oct 2023 03:15:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTEePNVAmHZb/864E4GdsNkiYTWojqEFJErvbBvnJDxMpu5e0tdtlubNMMIbyRvGLZJkKphA==
X-Received: by 2002:ac8:5d07:0:b0:418:1235:5c86 with SMTP id f7-20020ac85d07000000b0041812355c86mr2910723qtx.43.1698401731427;
        Fri, 27 Oct 2023 03:15:31 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-185-56.business.telecomitalia.it. [87.12.185.56])
        by smtp.gmail.com with ESMTPSA id g21-20020ac85815000000b00418122186ccsm460002qtg.12.2023.10.27.03.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 03:15:31 -0700 (PDT)
Date:   Fri, 27 Oct 2023 12:15:25 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     syzbot <syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, syoshida@redhat.com
Subject: Re: [syzbot] [net?] KMSAN: uninit-value in virtio_transport_recv_pkt
Message-ID: <6pljp7toxsxk4ljnggvn44djqzbi2g3bfou5snhugdrbabu7wv@fpueaouu26ly>
References: <00000000000008b2940608ae3ce9@google.com>
 <ooihytsfbk3brbwi2oj27ju3ff43ns36qhksfixrxdau2nieor@ervvukakvk4n>
 <CANn89i+kKiSL6KJ6cEW_J5BmV3vSswbNPMNVm8ysKjDynF9d5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+kKiSL6KJ6cEW_J5BmV3vSswbNPMNVm8ysKjDynF9d5w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 27, 2023 at 10:48:39AM +0200, Eric Dumazet wrote:
>On Fri, Oct 27, 2023 at 10:25 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Fri, Oct 27, 2023 at 01:11:24AM -0700, syzbot wrote:
>> >Hello,
>> >
>> >syzbot found the following issue on:
>> >
>> >HEAD commit:    d90b0276af8f Merge tag 'hardening-v6.6-rc3' of git://git.k..
>> >git tree:       upstream
>> >console+strace: https://syzkaller.appspot.com/x/log.txt?x=102c8b22680000
>> >kernel config:  https://syzkaller.appspot.com/x/.config?x=6f1a4029b69273f3
>> >dashboard link: https://syzkaller.appspot.com/bug?extid=0c8ce1da0ac31abbadcd
>> >compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>> >syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=101e58ec680000
>> >C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17f7adb6680000
>> >
>> >Downloadable assets:
>> >disk image: https://storage.googleapis.com/syzbot-assets/83ae10beee39/disk-d90b0276.raw.xz
>> >vmlinux: https://storage.googleapis.com/syzbot-assets/c231992300f6/vmlinux-d90b0276.xz
>> >kernel image: https://storage.googleapis.com/syzbot-assets/6377c9c2ea97/bzImage-d90b0276.xz
>> >
>> >IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> >Reported-by: syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com
>> >
>> >=====================================================
>> >BUG: KMSAN: uninit-value in virtio_transport_recv_pkt+0x1c42/0x2580 net/vmw_vsock/virtio_transport_common.c:1421
>> > virtio_transport_recv_pkt+0x1c42/0x2580 net/vmw_vsock/virtio_transport_common.c:1421
>> > vsock_loopback_work+0x3e2/0x5d0 net/vmw_vsock/vsock_loopback.c:120
>> > process_one_work kernel/workqueue.c:2630 [inline]
>> > process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
>> > worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
>> > kthread+0x3e8/0x540 kernel/kthread.c:388
>> > ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
>> > ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
>> >
>> >Uninit was stored to memory at:
>> > virtio_transport_space_update net/vmw_vsock/virtio_transport_common.c:1274 [inline]
>> > virtio_transport_recv_pkt+0x1ea4/0x2580 net/vmw_vsock/virtio_transport_common.c:1415
>> > vsock_loopback_work+0x3e2/0x5d0 net/vmw_vsock/vsock_loopback.c:120
>> > process_one_work kernel/workqueue.c:2630 [inline]
>> > process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
>> > worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
>> > kthread+0x3e8/0x540 kernel/kthread.c:388
>> > ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
>> > ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
>> >
>> >Uninit was created at:
>> > slab_post_alloc_hook+0x12f/0xb70 mm/slab.h:767
>> > slab_alloc_node mm/slub.c:3478 [inline]
>> > kmem_cache_alloc_node+0x577/0xa80 mm/slub.c:3523
>> > kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:559
>> > __alloc_skb+0x318/0x740 net/core/skbuff.c:650
>> > alloc_skb include/linux/skbuff.h:1286 [inline]
>> > virtio_vsock_alloc_skb include/linux/virtio_vsock.h:66 [inline]
>> > virtio_transport_alloc_skb+0x8b/0x1170 net/vmw_vsock/virtio_transport_common.c:58
>> > virtio_transport_reset_no_sock net/vmw_vsock/virtio_transport_common.c:957 [inline]
>> > virtio_transport_recv_pkt+0x1531/0x2580 net/vmw_vsock/virtio_transport_common.c:1387
>> > vsock_loopback_work+0x3e2/0x5d0 net/vmw_vsock/vsock_loopback.c:120
>> > process_one_work kernel/workqueue.c:2630 [inline]
>> > process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
>> > worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
>> > kthread+0x3e8/0x540 kernel/kthread.c:388
>> > ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
>> > ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
>> >
>> >CPU: 0 PID: 8 Comm: kworker/0:0 Not tainted 6.6.0-rc2-syzkaller-00337-gd90b0276af8f #0
>> >Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
>> >Workqueue: vsock-loopback vsock_loopback_work
>> >=====================================================
>> >
>>
>> Shigeru Yoshida already posted a patch here:
>>
>> https://lore.kernel.org/netdev/20231026150154.3536433-1-syoshida@redhat.com/
>
>Sure thing, this is why I released this syzbot report from my queue.
>

Thanks for that ;-)

Stefano

