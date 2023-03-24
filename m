Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D476C79FE
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 09:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjCXIjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 04:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjCXIji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 04:39:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F221166F
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 01:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679647134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h1D7m14P56RNT5JGoAPdQmecs24aXusOMR+kHr7Nd7Q=;
        b=TESFt/tvm3TssglqPCsLooj7tKV+gHgUILI2NaTi9Y3MgCQi4tGffuNSopVOAuIM1GdUNg
        610Lw54bGleHXLZsDat3vYy7weG9GLz4YMlVvVyA6LhtlOjP0KiqhpTUY2HobOFECqFnbK
        OTJHyg+yi2+BtDBFw0c2kBxKoNPD2Ts=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-_I30EULyOxOeV0edwP8vjw-1; Fri, 24 Mar 2023 04:38:53 -0400
X-MC-Unique: _I30EULyOxOeV0edwP8vjw-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5419fb7d6c7so12052207b3.11
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 01:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679647130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h1D7m14P56RNT5JGoAPdQmecs24aXusOMR+kHr7Nd7Q=;
        b=t3lae6e5aVM3Qfy6E8ibldOelFGXqW1tmykSCji7waNlvib8eJfgicAd2Lk5TwRAgS
         xgSbS7p5Y0yNgf6TND6VJFbXS0M+sOVQC6GAp3Hv2N8RY5JFb+to8twim14x6OXfgkKj
         uN/9ol7Ck1y7589PeHs0uZ4qm51iLexUpFhjTugyRHP404F+oTAONdIA2VZ7qyq02cPV
         Ehuu6GRYBkwXSSsovTx1YBut+8E4pzXlMzycc4Q/D/+qpcjkRRgAbdkbjWSlzxAB4+le
         x1AogCLBXwNccUAKyyk7JBg3CkWLibo/yA6INE6xLmsebz18NMlOHBNO2Hjmh5VFpyxu
         cvUQ==
X-Gm-Message-State: AAQBX9ex07KAPIPA7lJFsEZ5x1hKRIxPB838Ima6hgx3pN8f3z0RMYBX
        wc/EULPYJzS0aW0aMro75x+ieBxTSR7QoMKfZmXlYP041JXQl3xODBvQdAFKVWiBx9A6bvuDJOG
        6PSbNUqYzWFJs5vIZBHmQ5oT8SUEX
X-Received: by 2002:a25:b948:0:b0:acd:7374:f154 with SMTP id s8-20020a25b948000000b00acd7374f154mr902980ybm.7.1679647130011;
        Fri, 24 Mar 2023 01:38:50 -0700 (PDT)
X-Google-Smtp-Source: AKy350bJUkE56r+OXAAnA3zX4sKtvZzf+/cqdiByb/Kp2K9FLab9w7761QG8IjcA/36OfL1v2BkST2kJZovF/6N6wps=
X-Received: by 2002:a25:b948:0:b0:acd:7374:f154 with SMTP id
 s8-20020a25b948000000b00acd7374f154mr902969ybm.7.1679647129774; Fri, 24 Mar
 2023 01:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000075bebb05f79acfde@google.com>
In-Reply-To: <00000000000075bebb05f79acfde@google.com>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Fri, 24 Mar 2023 09:38:38 +0100
Message-ID: <CAGxU2F4jxdzK8Y-jaoKRaX_bDhoMtomOT6TyMek+un-Bp8RX3g@mail.gmail.com>
Subject: Re: [syzbot] [net?] [virt?] [io-uring?] [kvm?] BUG: soft lockup in vsock_connect
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     syzbot <syzbot+0bc015ebddc291a97116@syzkaller.appspotmail.com>,
        axboe@kernel.dk, davem@davemloft.net, edumazet@google.com,
        io-uring@vger.kernel.org, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bobby,
FYI we have also this one, but it seems related to
syzbot+befff0a9536049e7902e@syzkaller.appspotmail.com

Thanks,
Stefano


On Fri, Mar 24, 2023 at 1:52=E2=80=AFAM syzbot
<syzbot+0bc015ebddc291a97116@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    fe15c26ee26e Linux 6.3-rc1
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux=
.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1577c97ec8000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D7573cbcd881a8=
8c9
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D0bc015ebddc291a=
97116
> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Deb=
ian) 2.35.2
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1077c996c80=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D17e38929c8000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/89d41abd07bd/dis=
k-fe15c26e.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/fa75f5030ade/vmlinu=
x-fe15c26e.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/590d0f5903ee/I=
mage-fe15c26e.gz.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+0bc015ebddc291a97116@syzkaller.appspotmail.com
>
> watchdog: BUG: soft lockup - CPU#0 stuck for 27s! [syz-executor244:6747]
> Modules linked in:
> irq event stamp: 6033
> hardirqs last  enabled at (6032): [<ffff8000124604ac>] __exit_to_kernel_m=
ode arch/arm64/kernel/entry-common.c:84 [inline]
> hardirqs last  enabled at (6032): [<ffff8000124604ac>] exit_to_kernel_mod=
e+0xe8/0x118 arch/arm64/kernel/entry-common.c:94
> hardirqs last disabled at (6033): [<ffff80001245e188>] __el1_irq arch/arm=
64/kernel/entry-common.c:468 [inline]
> hardirqs last disabled at (6033): [<ffff80001245e188>] el1_interrupt+0x24=
/0x68 arch/arm64/kernel/entry-common.c:486
> softirqs last  enabled at (616): [<ffff80001066ca80>] spin_unlock_bh incl=
ude/linux/spinlock.h:395 [inline]
> softirqs last  enabled at (616): [<ffff80001066ca80>] lock_sock_nested+0x=
e8/0x138 net/core/sock.c:3480
> softirqs last disabled at (618): [<ffff8000122dbcfc>] spin_lock_bh includ=
e/linux/spinlock.h:355 [inline]
> softirqs last disabled at (618): [<ffff8000122dbcfc>] virtio_transport_pu=
rge_skbs+0x11c/0x500 net/vmw_vsock/virtio_transport_common.c:1372
> CPU: 0 PID: 6747 Comm: syz-executor244 Not tainted 6.3.0-rc1-syzkaller-gf=
e15c26ee26e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 03/02/2023
> pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> pc : __sanitizer_cov_trace_pc+0xc/0x8c kernel/kcov.c:203
> lr : virtio_transport_purge_skbs+0x19c/0x500 net/vmw_vsock/virtio_transpo=
rt_common.c:1374
> sp : ffff80001e787890
> x29: ffff80001e7879e0 x28: 1ffff00003cf0f2a x27: ffff80001a487a60
> x26: ffff80001e787950 x25: ffff0000ce2d3b80 x24: ffff80001a487a78
> x23: 1ffff00003490f4c x22: ffff80001a29c1a8 x21: dfff800000000000
> x20: ffff80001a487a60 x19: ffff80001e787940 x18: 1fffe000368951b6
> x17: ffff800015cdd000 x16: ffff8000085110b0 x15: 0000000000000000
> x14: 1ffff00002b9c0b2 x13: dfff800000000000 x12: ffff700003cf0efc
> x11: ff808000122dbee8 x10: 0000000000000000 x9 : ffff8000122dbee8
> x8 : ffff0000ce511b40 x7 : ffff8000122dbcfc x6 : 0000000000000000
> x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff80000832d758
> x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>  get_current arch/arm64/include/asm/current.h:19 [inline]
>  __sanitizer_cov_trace_pc+0xc/0x8c kernel/kcov.c:206
>  vsock_loopback_cancel_pkt+0x28/0x3c net/vmw_vsock/vsock_loopback.c:48
>  vsock_transport_cancel_pkt net/vmw_vsock/af_vsock.c:1284 [inline]
>  vsock_connect+0x6b8/0xaec net/vmw_vsock/af_vsock.c:1426
>  __sys_connect_file net/socket.c:2004 [inline]
>  __sys_connect+0x268/0x290 net/socket.c:2021
>  __do_sys_connect net/socket.c:2031 [inline]
>  __se_sys_connect net/socket.c:2028 [inline]
>  __arm64_sys_connect+0x7c/0x94 net/socket.c:2028
>  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>  invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
>  el0_svc_common+0x138/0x258 arch/arm64/kernel/syscall.c:142
>  do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:193
>  el0_svc+0x58/0x168 arch/arm64/kernel/entry-common.c:637
>  el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
>  el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>

