Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777067D929B
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 10:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345518AbjJ0ItT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 04:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345706AbjJ0Is4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 04:48:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD7710E4
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:48:52 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-53f647c84d4so10791a12.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698396531; x=1699001331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eopWR7hzxdYBX0Qk2wgiI2DI9yTPwgIf0SgwKfaDrAM=;
        b=Ir0gjaC9LkbX2aKMdNsmbS+ZmhKqXO0fF/TcYpIVbMLwWbEuHznZzvSw/jb6yppn9r
         3QWLUJRBYQdygmY4XtEviFlNOlRinqYCIckDNDNNPzETYBuyzQejTkPv/4N4M5D0EOIX
         D5iv+XWysfWSRpJDzuyGoLhlnNci6bkveuw1pPgz+HOXgGRysoY0+ClajfHoDIE9Jsm7
         XXdmlynOpds8dp522TD5k56YnWgyKzT4sU5gzq5E3MZhMwLT6SREN7Uv5wSkW/dsaEGO
         WMN/02UWQIkZgX39qx7amPMJNmNeWQU951x2Cw1dnz+4UH6BrXYItOJqm8gEzEZdd12u
         tXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698396531; x=1699001331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eopWR7hzxdYBX0Qk2wgiI2DI9yTPwgIf0SgwKfaDrAM=;
        b=NYPXUTAd553BqTzo/HJDMEKMgR4Eg8NnO9OnW8jXWF9iJn3yxuNgAfpjG0Odv297yC
         a+KIR2YWBjVjWyz7BtzUklhDB0VjbttWMASYrwtSM1ArbbHO0v020EsDX8SQbIOJYSV0
         C3wCwXYVuxEcjpmsZ1MdaMnSV7DtWuEOgXaSv8f48/2NIYupfbAWM5e7/KQI8XXedKxx
         lqyAYUPYA9nWPMpjmwnMI2erAv/QyWEJ2zswRk+hBCVK2+bGB+JSD/i8QuP5qktUyUgX
         aIPZhd8/TZu30MGc7q9+RsifpUPe1CAtcHVKGhli1pzeJKvEavfT89HsSH6a1g+2dXI1
         crHA==
X-Gm-Message-State: AOJu0YyG86P+Ifp/M/sD60R2mKzdymS0cx/vCp1UJomjRR3BSl1ExUYZ
        NAbTmf1PbRx0XYNQ0k6qmf/6vJMylcR/77kFx86P2A==
X-Google-Smtp-Source: AGHT+IGLx1NE8+JdKjMMatUrOtTEatvfuzVyH5V7hCl3qV2cZj9w1pQgQMnWDlTxCd/HCS83jpdw9+UZPBp1eJAkA3A=
X-Received: by 2002:a50:cc88:0:b0:540:e63d:3cfb with SMTP id
 q8-20020a50cc88000000b00540e63d3cfbmr54276edi.3.1698396530554; Fri, 27 Oct
 2023 01:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000008b2940608ae3ce9@google.com> <ooihytsfbk3brbwi2oj27ju3ff43ns36qhksfixrxdau2nieor@ervvukakvk4n>
In-Reply-To: <ooihytsfbk3brbwi2oj27ju3ff43ns36qhksfixrxdau2nieor@ervvukakvk4n>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 27 Oct 2023 10:48:39 +0200
Message-ID: <CANn89i+kKiSL6KJ6cEW_J5BmV3vSswbNPMNVm8ysKjDynF9d5w@mail.gmail.com>
Subject: Re: [syzbot] [net?] KMSAN: uninit-value in virtio_transport_recv_pkt
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     syzbot <syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, syoshida@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 27, 2023 at 10:25=E2=80=AFAM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> On Fri, Oct 27, 2023 at 01:11:24AM -0700, syzbot wrote:
> >Hello,
> >
> >syzbot found the following issue on:
> >
> >HEAD commit:    d90b0276af8f Merge tag 'hardening-v6.6-rc3' of git://git=
.k..
> >git tree:       upstream
> >console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D102c8b226800=
00
> >kernel config:  https://syzkaller.appspot.com/x/.config?x=3D6f1a4029b692=
73f3
> >dashboard link: https://syzkaller.appspot.com/bug?extid=3D0c8ce1da0ac31a=
bbadcd
> >compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for De=
bian) 2.40
> >syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D101e58ec68=
0000
> >C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17f7adb66800=
00
> >
> >Downloadable assets:
> >disk image: https://storage.googleapis.com/syzbot-assets/83ae10beee39/di=
sk-d90b0276.raw.xz
> >vmlinux: https://storage.googleapis.com/syzbot-assets/c231992300f6/vmlin=
ux-d90b0276.xz
> >kernel image: https://storage.googleapis.com/syzbot-assets/6377c9c2ea97/=
bzImage-d90b0276.xz
> >
> >IMPORTANT: if you fix the issue, please add the following tag to the com=
mit:
> >Reported-by: syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com
> >
> >=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >BUG: KMSAN: uninit-value in virtio_transport_recv_pkt+0x1c42/0x2580 net/=
vmw_vsock/virtio_transport_common.c:1421
> > virtio_transport_recv_pkt+0x1c42/0x2580 net/vmw_vsock/virtio_transport_=
common.c:1421
> > vsock_loopback_work+0x3e2/0x5d0 net/vmw_vsock/vsock_loopback.c:120
> > process_one_work kernel/workqueue.c:2630 [inline]
> > process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
> > worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
> > kthread+0x3e8/0x540 kernel/kthread.c:388
> > ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
> > ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> >
> >Uninit was stored to memory at:
> > virtio_transport_space_update net/vmw_vsock/virtio_transport_common.c:1=
274 [inline]
> > virtio_transport_recv_pkt+0x1ea4/0x2580 net/vmw_vsock/virtio_transport_=
common.c:1415
> > vsock_loopback_work+0x3e2/0x5d0 net/vmw_vsock/vsock_loopback.c:120
> > process_one_work kernel/workqueue.c:2630 [inline]
> > process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
> > worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
> > kthread+0x3e8/0x540 kernel/kthread.c:388
> > ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
> > ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> >
> >Uninit was created at:
> > slab_post_alloc_hook+0x12f/0xb70 mm/slab.h:767
> > slab_alloc_node mm/slub.c:3478 [inline]
> > kmem_cache_alloc_node+0x577/0xa80 mm/slub.c:3523
> > kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:559
> > __alloc_skb+0x318/0x740 net/core/skbuff.c:650
> > alloc_skb include/linux/skbuff.h:1286 [inline]
> > virtio_vsock_alloc_skb include/linux/virtio_vsock.h:66 [inline]
> > virtio_transport_alloc_skb+0x8b/0x1170 net/vmw_vsock/virtio_transport_c=
ommon.c:58
> > virtio_transport_reset_no_sock net/vmw_vsock/virtio_transport_common.c:=
957 [inline]
> > virtio_transport_recv_pkt+0x1531/0x2580 net/vmw_vsock/virtio_transport_=
common.c:1387
> > vsock_loopback_work+0x3e2/0x5d0 net/vmw_vsock/vsock_loopback.c:120
> > process_one_work kernel/workqueue.c:2630 [inline]
> > process_scheduled_works+0x104e/0x1e70 kernel/workqueue.c:2703
> > worker_thread+0xf45/0x1490 kernel/workqueue.c:2784
> > kthread+0x3e8/0x540 kernel/kthread.c:388
> > ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
> > ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> >
> >CPU: 0 PID: 8 Comm: kworker/0:0 Not tainted 6.6.0-rc2-syzkaller-00337-gd=
90b0276af8f #0
> >Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 08/04/2023
> >Workqueue: vsock-loopback vsock_loopback_work
> >=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> >
>
> Shigeru Yoshida already posted a patch here:
>
> https://lore.kernel.org/netdev/20231026150154.3536433-1-syoshida@redhat.c=
om/

Sure thing, this is why I released this syzbot report from my queue.
