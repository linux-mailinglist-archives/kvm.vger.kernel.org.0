Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1125C2275
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 15:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731432AbfI3Nvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 09:51:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbfI3Nvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 09:51:31 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8863E5AFE9
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 13:51:30 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id j3so4539929wrn.7
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 06:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KJecfdV4cU2EkR1odbrtXYLFF3/KCfbmiXi5v/OdwmM=;
        b=A7WdEXtTSRC003hi+tLOMnPK9ogE7LyR0Io2pfZODIwX/YDDROv9A65Tqtpk/Iw7qd
         nYmVw7gNdPiFGD2+tyYsYNZoV9rwdTpynmuimByzmrhGcAzWRBkqD3BQh4vRfHpIx1um
         R4SoKJ7zzOPeZ8NSJsiTotwjyZd+D7JbrSUzffy9dugelsfGImGLO+7mgBG+X/BbbuwX
         VHO8Zt0tIGWRJFHE03brBa66iQkqT5CSBsPMb+sXnl3up7F4BugHV78GUYa9sLGg4doX
         HwTUnxQYNV5VdTD8VWPUWMk3+YsH+cxpvz7M5uV/vayE5fAfKwsFaLGfC5ABp0PF2VAs
         cpvQ==
X-Gm-Message-State: APjAAAVpTUm73HWXuIyxZzjoPtVR6LCzUSlEmn96pdP1OXtR5jZKDIjI
        iEFJKOnN9+QtcfdfmBFl8cxq7RqFsmM5uUevet3q8qmazzwp/uw6JhgM/3KSNiUe0ydTFzFM4qS
        RyIbyd34lAUlk
X-Received: by 2002:a05:600c:238a:: with SMTP id m10mr18590252wma.51.1569851489005;
        Mon, 30 Sep 2019 06:51:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwO29KpzdE/B4PZ3FyZQ0b+zqrWaXagG+JSizcZd8LEziw9BOwffjU331R6jmlmhQgquk4C4Q==
X-Received: by 2002:a05:600c:238a:: with SMTP id m10mr18590238wma.51.1569851488775;
        Mon, 30 Sep 2019 06:51:28 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id h63sm26377926wmf.15.2019.09.30.06.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 06:51:28 -0700 (PDT)
Date:   Mon, 30 Sep 2019 15:51:25 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "deepa.kernel@gmail.com" <deepa.kernel@gmail.com>,
        "ytht.net@gmail.com" <ytht.net@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Michael Kelley <mikelley@microsoft.com>,
        "jhansen@vmware.com" <jhansen@vmware.com>
Subject: Re: [PATCH net v2] vsock: Fix a lockdep warning in __vsock_release()
Message-ID: <20190930135125.prztj336splp74wq@steredhat>
References: <1569460241-57800-1-git-send-email-decui@microsoft.com>
 <20190926074749.sltehhkcgfduu7n2@steredhat.homenet.telecomitalia.it>
 <PU1P153MB01698C46C9348B9762D5E122BF810@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB01698C46C9348B9762D5E122BF810@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 27, 2019 at 05:37:20AM +0000, Dexuan Cui wrote:
> > From: linux-hyperv-owner@vger.kernel.org
> > <linux-hyperv-owner@vger.kernel.org> On Behalf Of Stefano Garzarella
> > Sent: Thursday, September 26, 2019 12:48 AM
> > 
> > Hi Dexuan,
> > 
> > On Thu, Sep 26, 2019 at 01:11:27AM +0000, Dexuan Cui wrote:
> > > ...
> > > NOTE: I only tested the code on Hyper-V. I can not test the code for
> > > virtio socket, as I don't have a KVM host. :-( Sorry.
> > >
> > > @Stefan, @Stefano: please review & test the patch for virtio socket,
> > > and let me know if the patch breaks anything. Thanks!
> > 
> > Comment below, I'll test it ASAP!
> 
> Stefano, Thank you!
> 
> BTW, this is how I tested the patch:
> 1. write a socket server program in the guest. The program calls listen()
> and then calls sleep(10000 seconds). Note: accept() is not called.
> 
> 2. create some connections to the server program in the guest.
> 
> 3. kill the server program by Ctrl+C, and "dmesg" will show the scary
> call-trace, if the kernel is built with 
> 	CONFIG_LOCKDEP=y
> 	CONFIG_LOCKDEP_SUPPORT=y
> 
> 4. Apply the patch, do the same test and we should no longer see the call-trace.
> 

Hi Dexuan,
I tested on virtio socket and it works as expected!

With your patch applied I don't have issues and call-trace. Without
the patch I have a very similar call-trace (as expected):
    ============================================
    WARNING: possible recursive locking detected
    5.3.0-vsock #17 Not tainted
    --------------------------------------------
    python3/872 is trying to acquire lock:
    ffff88802b650110 (sk_lock-AF_VSOCK){+.+.}, at: virtio_transport_release+0x34/0x330 [vmw_vsock_virtio_transport_common]

    but task is already holding lock:
    ffff88803597ce10 (sk_lock-AF_VSOCK){+.+.}, at: __vsock_release+0x3f/0x130 [vsock]

    other info that might help us debug this:
     Possible unsafe locking scenario:

           CPU0
           ----
      lock(sk_lock-AF_VSOCK);
      lock(sk_lock-AF_VSOCK);

     *** DEADLOCK ***

     May be due to missing lock nesting notation

    2 locks held by python3/872:
     #0: ffff88802c957180 (&sb->s_type->i_mutex_key#8){+.+.}, at: __sock_release+0x2d/0xb0
     #1: ffff88803597ce10 (sk_lock-AF_VSOCK){+.+.}, at: __vsock_release+0x3f/0x130 [vsock]

    stack backtrace:
    CPU: 0 PID: 872 Comm: python3 Not tainted 5.3.0-vsock #17
    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
    Call Trace:
     dump_stack+0x85/0xc0
     __lock_acquire.cold+0xad/0x22b
     lock_acquire+0xc4/0x1a0
     ? virtio_transport_release+0x34/0x330 [vmw_vsock_virtio_transport_common]
     lock_sock_nested+0x5d/0x80
     ? virtio_transport_release+0x34/0x330 [vmw_vsock_virtio_transport_common]
     virtio_transport_release+0x34/0x330 [vmw_vsock_virtio_transport_common]
     ? mark_held_locks+0x49/0x70
     ? _raw_spin_unlock_irqrestore+0x44/0x60
     __vsock_release+0x2d/0x130 [vsock]
     __vsock_release+0xb9/0x130 [vsock]
     vsock_release+0x12/0x30 [vsock]
     __sock_release+0x3d/0xb0
     sock_close+0x14/0x20
     __fput+0xc1/0x250
     task_work_run+0x93/0xb0
     exit_to_usermode_loop+0xd3/0xe0
     syscall_return_slowpath+0x205/0x310
     entry_SYSCALL_64_after_hwframe+0x49/0xbe


Feel free to add:

Tested-by: Stefano Garzarella <sgarzare@redhat.com>
