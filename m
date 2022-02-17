Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10CF4B9A1C
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 08:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbiBQHuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 02:50:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbiBQHuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 02:50:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BE192A39CF
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 23:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645084236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w+SWlmqdTXW/vwpa/W1PTCZvRCAVwOXfVJtRO06yo4I=;
        b=MrCOTH5GU27az4Jf6pnIxZHftzK9P8+KewoMDYPa1eSGUye5WtxqU6uNwoQz3w7+GAfVqY
        KSABQ1P+oYvnEekgCXq4Rd2cwtUlEgfLDP+0hSDCF4VzRDd/FIrjUG82qgpkFScLIzIPSz
        UsP9Qr/yHqBuIlLCVbkFVB7cS9kzf7g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-Lg11dNPHM06uXYSAqfMWew-1; Thu, 17 Feb 2022 02:50:34 -0500
X-MC-Unique: Lg11dNPHM06uXYSAqfMWew-1
Received: by mail-wr1-f70.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so1933595wrg.19
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 23:50:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w+SWlmqdTXW/vwpa/W1PTCZvRCAVwOXfVJtRO06yo4I=;
        b=L/fzGtQt8lsazBLjZaURJBc0/oVxxxsYH4DLT2xTnEZmpFxOGbSuX8xRSTe/cxQC2G
         6aOkg0QJOQIk0+kWXak4ocojiF77KBboPb2T0gd+JLZHywMG1KB7MmRYt3JmjLNxEq5D
         A8adESK23FVYAziFJuKTg37o4CERVrXPaKW4t0bzPyl67xN1RIi2j9294gikL/0S/MRY
         twYMhvWkARs81zut/3ewSaP0eBeZ3hBQBn5A8MopM2KCeq3dcs397IEXRexSef8RgvTF
         BI2CIodSppZ/QEHKBIIzZ2dADP3lJ2zVYSAU1oGDyt5tTYgiuDGYQY1j+do3ej4psE0R
         ofIQ==
X-Gm-Message-State: AOAM532WDYgK8a3djey185HN3b4plaGWv/ncZl9kYCPvbM/UuODhn4bm
        ZCuztfhWkFd/lx6dFCbBK6SEC/6cUhWPtd4Eid1Fn/9SaMKJn7ZYHhI0n7jHkst/1VCUuOhIbkr
        Z/9X00bnQ1wbb
X-Received: by 2002:adf:9f42:0:b0:1e7:e751:9656 with SMTP id f2-20020adf9f42000000b001e7e7519656mr1268886wrg.590.1645084233485;
        Wed, 16 Feb 2022 23:50:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw57VwM/1catFUUkrmi2KhjRFil7J/w4QZrPWIsW6CqSvS4FYyAAEPbPH6XyQzZ/Q25yrD01w==
X-Received: by 2002:adf:9f42:0:b0:1e7:e751:9656 with SMTP id f2-20020adf9f42000000b001e7e7519656mr1268862wrg.590.1645084233179;
        Wed, 16 Feb 2022 23:50:33 -0800 (PST)
Received: from redhat.com ([2.55.139.83])
        by smtp.gmail.com with ESMTPSA id g12sm469088wmq.28.2022.02.16.23.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 23:50:32 -0800 (PST)
Date:   Thu, 17 Feb 2022 02:50:29 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     syzbot <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com>,
        kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [syzbot] WARNING in vhost_dev_cleanup (2)
Message-ID: <20220217024359-mutt-send-email-mst@kernel.org>
References: <0000000000006f656005d82d24e2@google.com>
 <CACGkMEsyWBBmx3g613tr97nidHd3-avMyO=WRxS8RpcEk7j2=A@mail.gmail.com>
 <20220217023550-mutt-send-email-mst@kernel.org>
 <CACGkMEtuL_4eRYYWd4aQj6rG=cJDQjjr86DWpid3o_N-6xvTWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtuL_4eRYYWd4aQj6rG=cJDQjjr86DWpid3o_N-6xvTWQ@mail.gmail.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022 at 03:39:48PM +0800, Jason Wang wrote:
> On Thu, Feb 17, 2022 at 3:36 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Feb 17, 2022 at 03:34:13PM +0800, Jason Wang wrote:
> > > On Thu, Feb 17, 2022 at 10:01 AM syzbot
> > > <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    c5d9ae265b10 Merge tag 'for-linus' of git://git.kernel.org..
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=132e687c700000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=1e3ea63db39f2b4440e0
> > > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > > >
> > > > Unfortunately, I don't have any reproducer for this issue yet.
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> > > >
> > > > WARNING: CPU: 1 PID: 10828 at drivers/vhost/vhost.c:715 vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
> > > > Modules linked in:
> > > > CPU: 0 PID: 10828 Comm: syz-executor.0 Not tainted 5.17.0-rc4-syzkaller-00051-gc5d9ae265b10 #0
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > > RIP: 0010:vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
> > >
> > > Probably a hint that we are missing a flush.
> > >
> > > Looking at vhost_vsock_stop() that is called by vhost_vsock_dev_release():
> > >
> > > static int vhost_vsock_stop(struct vhost_vsock *vsock)
> > > {
> > > size_t i;
> > >         int ret;
> > >
> > >         mutex_lock(&vsock->dev.mutex);
> > >
> > >         ret = vhost_dev_check_owner(&vsock->dev);
> > >         if (ret)
> > >                 goto err;
> > >
> > > Where it could fail so the device is not actually stopped.
> > >
> > > I wonder if this is something related.
> > >
> > > Thanks
> >
> >
> > But then if that is not the owner then no work should be running, right?
> 
> Could it be a buggy user space that passes the fd to another process
> and changes the owner just before the mutex_lock() above?
> 
> Thanks

Maybe, but can you be a bit more explicit? what is the set of
conditions you see that can lead to this?


> >
> >
> > >
> > > > Code: c7 85 90 01 00 00 00 00 00 00 e8 53 6e a2 fa 48 89 ef 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f e9 7d d6 ff ff e8 38 6e a2 fa <0f> 0b e9 46 ff ff ff 48 8b 7c 24 10 e8 87 00 ea fa e9 75 f7 ff ff
> > > > RSP: 0018:ffffc9000fe6fa18 EFLAGS: 00010293
> > > > RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
> > > > RDX: ffff888021b63a00 RSI: ffffffff86d66fe8 RDI: ffff88801cc200b0
> > > > RBP: ffff88801cc20000 R08: 0000000000000001 R09: 0000000000000001
> > > > R10: ffffffff817f1e08 R11: 0000000000000000 R12: ffff88801cc200d0
> > > > R13: ffff88801cc20120 R14: ffff88801cc200d0 R15: 0000000000000002
> > > > FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 0000001b2de25000 CR3: 000000004c9cd000 CR4: 00000000003506f0
> > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > Call Trace:
> > > >  <TASK>
> > > >  vhost_vsock_dev_release+0x36e/0x4b0 drivers/vhost/vsock.c:771
> > > >  __fput+0x286/0x9f0 fs/file_table.c:313
> > > >  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
> > > >  exit_task_work include/linux/task_work.h:32 [inline]
> > > >  do_exit+0xb29/0x2a30 kernel/exit.c:806
> > > >  do_group_exit+0xd2/0x2f0 kernel/exit.c:935
> > > >  get_signal+0x45a/0x2490 kernel/signal.c:2863
> > > >  arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
> > > >  handle_signal_work kernel/entry/common.c:148 [inline]
> > > >  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
> > > >  exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
> > > >  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
> > > >  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
> > > >  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
> > > >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > > RIP: 0033:0x7f4027a46481
> > > > Code: Unable to access opcode bytes at RIP 0x7f4027a46457.
> > > > RSP: 002b:00007f402808ba68 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
> > > > RAX: fffffffffffffffc RBX: 00007f402622e700 RCX: 00007f4027a46481
> > > > RDX: 00007f402622e9d0 RSI: 00007f402622e2f0 RDI: 00000000003d0f00
> > > > RBP: 00007f402808bcb0 R08: 00007f402622e700 R09: 00007f402622e700
> > > > R10: 00007f402622e9d0 R11: 0000000000000206 R12: 00007f402808bb1e
> > > > R13: 00007f402808bb1f R14: 00007f402622e300 R15: 0000000000022000
> > > >  </TASK>
> > > >
> > > >
> > > > ---
> > > > This report is generated by a bot. It may contain errors.
> > > > See https://goo.gl/tpsmEJ for more information about syzbot.
> > > > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > > >
> > > > syzbot will keep track of this issue. See:
> > > > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > > >
> >

