Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11EE74A2D3
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjGFRIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjGFRIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:08:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434D9171D
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688663243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=By2LGKZLPMwb4okENAyVJVNIASG0Orcn6TU8PNkFNmA=;
        b=QCKi8GRY3j+la3E9RJ972+8xz3EfEVJUKYM2/ZHuDQSowqY0mG1o0PTPtNDoexRDisP6T5
        XTSO2wZP3JC9A9/ChUD4Q1SNqBl/Vse6eLXY2nY6JQW35T3DauwuWtul7s/hapMGKOunrE
        N08lpwxYF5+NysL8JAhge83CRcdrktY=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-9NTxgch3PJy_fyjVuUPIqA-1; Thu, 06 Jul 2023 13:07:21 -0400
X-MC-Unique: 9NTxgch3PJy_fyjVuUPIqA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-57325434999so10634737b3.1
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688663241; x=1691255241;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=By2LGKZLPMwb4okENAyVJVNIASG0Orcn6TU8PNkFNmA=;
        b=Xy0Du84iVbdXADxDr1SHTAvM8GFyg3oA8yIFQxyPDUdRsopKhOP7oCqRetYD33EYUm
         yLtOoqM7kTchLCbr8zVnRXvgDWpKrcfFSI+u1zfILL+tNPwYUA4weBSj4JUfPQ1P9Mk5
         w6tKvyvTK5eqLvey6oKWaA7rLT0PwQDijWH0cDrGkP76eU96r0gl99WR1GyOKc0Pdubt
         WnCIKyuNXhW/AJMqR4kb1nVNJXvXdJ7VmXSrPB4nfr8CIC3xEtWami5b7N/gklCOBmRG
         vgD3jYoWIlyYQR/jpKR8Lx2cHhxiHiXRG1m4GdQhcA30WSC2t+Sc/s3l23owW+ubKLMe
         FnWg==
X-Gm-Message-State: ABy/qLaAbnFX9Liq6zeVOrtXx+3KdKiv41GL35XIQE5C7vHp5f2BlaH6
        HV1voGx5Y+0IXL2AaJVNg9dKTsW7Y2+AIav9WP5G1Hfl0Z0kZBW9wAgkxFkBGkYJrYw2ShGu8d4
        yBr8vtOBgS4IshHDpL0kOsFPPuHNz
X-Received: by 2002:a81:6603:0:b0:577:1d1c:7b94 with SMTP id a3-20020a816603000000b005771d1c7b94mr2806021ywc.18.1688663240649;
        Thu, 06 Jul 2023 10:07:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF0iUHkbkEaZ2b9UE/eU/eJ3AYPKRAO/IOm8nOd8hCCdeMVkyBBHORmc6+nf+lV55CyTS5E7OHK18mNmK0vznc=
X-Received: by 2002:a81:6603:0:b0:577:1d1c:7b94 with SMTP id
 a3-20020a816603000000b005771d1c7b94mr2806008ywc.18.1688663240352; Thu, 06 Jul
 2023 10:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
In-Reply-To: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Thu, 6 Jul 2023 19:07:09 +0200
Message-ID: <CAGxU2F4t6b1pxGebzDknvUA8w0B2J9mURzAtSSmKYDVa+zNmZA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 00/17] vsock: MSG_ZEROCOPY flag support
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 01, 2023 at 09:39:30AM +0300, Arseniy Krasnov wrote:
>Hello,
>
>                           DESCRIPTION
>
>this is MSG_ZEROCOPY feature support for virtio/vsock. I tried to follow
>current implementation for TCP as much as possible:
>
>1) Sender must enable SO_ZEROCOPY flag to use this feature. Without this
>   flag, data will be sent in "classic" copy manner and MSG_ZEROCOPY
>   flag will be ignored (e.g. without completion).
>
>2) Kernel uses completions from socket's error queue. Single completion
>   for single tx syscall (or it can merge several completions to single
>   one). I used already implemented logic for MSG_ZEROCOPY support:
>   'msg_zerocopy_realloc()' etc.
>
>Difference with copy way is not significant. During packet allocation,
>non-linear skb is created and filled with pinned user pages.
>There are also some updates for vhost and guest parts of transport - in
>both cases i've added handling of non-linear skb for virtio part. vhost
>copies data from such skb to the guest's rx virtio buffers. In the guest,
>virtio transport fills tx virtio queue with pages from skb.
>
>Head of this patchset is:
>https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d20dd0ea14072e8a90ff864b2c1603bd68920b4b
>
>
>This version has several limits/problems (all resolved at v5):
>
>1) As this feature totally depends on transport, there is no way (or it
>   is difficult) to check whether transport is able to handle it or not
>   during SO_ZEROCOPY setting. Seems I need to call AF_VSOCK specific
>   setsockopt callback from setsockopt callback for SOL_SOCKET, but this
>   leads to lock problem, because both AF_VSOCK and SOL_SOCKET callback
>   are not considered to be called from each other. So in current version
>   SO_ZEROCOPY is set successfully to any type (e.g. transport) of
>   AF_VSOCK socket, but if transport does not support MSG_ZEROCOPY,
>   tx routine will fail with EOPNOTSUPP.
>
>   ^^^ fixed in v5. Thanks to Bobby Eshleman.
>
>2) When MSG_ZEROCOPY is used, for each tx system call we need to enqueue
>   one completion. In each completion there is flag which shows how tx
>   was performed: zerocopy or copy. This leads that whole message must
>   be send in zerocopy or copy way - we can't send part of message with
>   copying and rest of message with zerocopy mode (or vice versa). Now,
>   we need to account vsock credit logic, e.g. we can't send whole data
>   once - only allowed number of bytes could sent at any moment. In case
>   of copying way there is no problem as in worst case we can send single
>   bytes, but zerocopy is more complex because smallest transmission
>   unit is single page. So if there is not enough space at peer's side
>   to send integer number of pages (at least one) - we will wait, thus
>   stalling tx side. To overcome this problem i've added simple rule -
>   zerocopy is possible only when there is enough space at another side
>   for whole message (to check, that current 'msghdr' was already used
>   in previous tx iterations i use 'iov_offset' field of it's iov iter).
>
>   ^^^
>   Discussed as ok during v2. Link:
>   https://lore.kernel.org/netdev/23guh3txkghxpgcrcjx7h62qsoj3xgjhfzgtbmqp2slrz3rxr4@zya2z7kwt75l/
>
>3) loopback transport is not supported, because it requires to implement
>   non-linear skb handling in dequeue logic (as we "send" fragged skb
>   and "receive" it from the same queue). I'm going to implement it in
>   next versions.
>
>   ^^^ fixed in v2
>
>4) Current implementation sets max length of packet to 64KB. IIUC this
>   is due to 'kmalloc()' allocated data buffers. I think, in case of
>   MSG_ZEROCOPY this value could be increased, because 'kmalloc()' is
>   not touched for data - user space pages are used as buffers. Also
>   this limit trims every message which is > 64KB, thus such messages
>   will be send in copy mode due to 'iov_offset' check in 2).
>
>   ^^^ fixed in v2
>
>                         PATCHSET STRUCTURE
>
>Patchset has the following structure:
>1) Handle non-linear skbuff on receive in virtio/vhost.
>2) Handle non-linear skbuff on send in virtio/vhost.
>3) Updates for AF_VSOCK.
>4) Enable MSG_ZEROCOPY support on transports.
>5) Tests/tools/docs updates.
>
>                            PERFORMANCE
>
>Performance: it is a little bit tricky to compare performance between
>copy and zerocopy transmissions. In zerocopy way we need to wait when
>user buffers will be released by kernel, so it is like synchronous
>path (wait until device driver will process it), while in copy way we
>can feed data to kernel as many as we want, don't care about device
>driver. So I compared only time which we spend in the 'send()' syscall.
>Then if this value will be combined with total number of transmitted
>bytes, we can get Gbit/s parameter. Also to avoid tx stalls due to not
>enough credit, receiver allocates same amount of space as sender needs.
>
>Sender:
>./vsock_perf --sender <CID> --buf-size <buf size> --bytes 256M [--zc]
>
>Receiver:
>./vsock_perf --vsk-size 256M
>
>I run tests on two setups: desktop with Core i7 - I use this PC for
>development and in this case guest is nested guest, and host is normal
>guest. Another hardware is some embedded board with Atom - here I don't
>have nested virtualization - host runs on hw, and guest is normal guest.
>
>G2H transmission (values are Gbit/s):
>
>   Core i7 with nested guest.            Atom with normal guest.
>
>*-------------------------------*   *-------------------------------*
>|          |         |          |   |          |         |          |
>| buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
>|          |         |          |   |          |         |          |
>*-------------------------------*   *-------------------------------*
>|   4KB    |    3    |    10    |   |   4KB    |   0.8   |   1.9    |
>*-------------------------------*   *-------------------------------*
>|   32KB   |   20    |    61    |   |   32KB   |   6.8   |   20.2   |
>*-------------------------------*   *-------------------------------*
>|   256KB  |   33    |   244    |   |   256KB  |   7.8   |   55     |
>*-------------------------------*   *-------------------------------*
>|    1M    |   30    |   373    |   |    1M    |   7     |   95     |
>*-------------------------------*   *-------------------------------*
>|    8M    |   22    |   475    |   |    8M    |   7     |   114    |
>*-------------------------------*   *-------------------------------*
>
>H2G:
>
>   Core i7 with nested guest.            Atom with normal guest.
>
>*-------------------------------*   *-------------------------------*
>|          |         |          |   |          |         |          |
>| buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
>|          |         |          |   |          |         |          |
>*-------------------------------*   *-------------------------------*
>|   4KB    |   20    |    10    |   |   4KB    |   4.37  |    3     |
>*-------------------------------*   *-------------------------------*
>|   32KB   |   37    |    75    |   |   32KB   |   11    |   18     |
>*-------------------------------*   *-------------------------------*
>|   256KB  |   44    |   299    |   |   256KB  |   11    |   62     |
>*-------------------------------*   *-------------------------------*
>|    1M    |   28    |   335    |   |    1M    |   9     |   77     |
>*-------------------------------*   *-------------------------------*
>|    8M    |   27    |   417    |   |    8M    |  9.35   |  115     |
>*-------------------------------*   *-------------------------------*
>
> * Let's look to the first line of both tables - where copy is better
>   than zerocopy. I analyzed this case more deeply and found that
>   bottleneck is function 'vhost_work_queue()'. With 4K buffer size,
>   caller spends too much time in it with zerocopy mode (comparing to
>   copy mode). This happens only with 4K buffer size. This function just
>   calls 'wake_up_process()' and its internal logic does not depends on
>   skb, so i think potential reason (may be) is interval between two
>   calls of this function (e.g. how often it is called). Note, that
>   'vhost_work_queue()' differs from the same function at guest's side of
>   transport: 'virtio_transport_send_pkt()' uses 'queue_work()' which
>   i think is more optimized for worker purposes, than direct call to
>   'wake_up_process()'. But again - this is just my assumption.
>
>Loopback:
>
>   Core i7 with nested guest.            Atom with normal guest.
>
>*-------------------------------*   *-------------------------------*
>|          |         |          |   |          |         |          |
>| buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
>|          |         |          |   |          |         |          |
>*-------------------------------*   *-------------------------------*
>|   4KB    |    8    |     7    |   |   4KB    |   1.8   |   1.3    |
>*-------------------------------*   *-------------------------------*
>|   32KB   |   38    |    44    |   |   32KB   |   10    |   10     |
>*-------------------------------*   *-------------------------------*
>|   256KB  |   55    |   168    |   |   256KB  |   15    |   36     |
>*-------------------------------*   *-------------------------------*
>|    1M    |   53    |   250    |   |    1M    |   12    |   45     |
>*-------------------------------*   *-------------------------------*
>|    8M    |   40    |   344    |   |    8M    |   11    |   74     |
>*-------------------------------*   *-------------------------------*
>
>I analyzed performace difference more deeply for the following setup:
>server: ./vsock_perf --vsk-size 16M
>client: ./vsock_perf --sender 2 --bytes 16M --buf-size 16K/4K [--zc]
>
>In other words I send 16M of data from guest to host in copy/zerocopy
>modes and with two different sizes of buffer - 4K and 64K. Let's see
>to tx path for both modes - it consists of two steps:
>
>copy:
>1) Allocate skb of buffer's length.
>2) Copy data to skb from buffer.
>
>zerocopy:
>1) Allocate skb with header space only.
>2) Pin pages of the buffer and insert them to skb.
>
>I measured average number of ns (returned by 'ktime_get()') for each
>step above:
>1) Skb allocation (for both copy and zerocopy modes).
>2) For copy mode in 'memcpy_to_msg()' - copying.
>3) For zerocopy mode in '__zerocopy_sg_from_iter()' - pinning.
>
>Here are results for copy mode:
>*-------------------------------------*
>| buf | skb alloc | 'memcpy_to_msg()' |
>*-------------------------------------*
>|     |           |                   |
>| 64K |  5000ns   |      25000ns      |
>|     |           |                   |
>*-------------------------------------*
>|     |           |                   |
>| 4K  |  800ns    |      2200ns       |
>|     |           |                   |
>*-------------------------------------*
>
>Here are results for zerocopy mode:
>*-----------------------------------------------*
>| buf | skb alloc | '__zerocopy_sg_from_iter()' |
>*-----------------------------------------------*
>|     |           |                             |
>| 64K |  250ns    |          3500ns             |
>|     |           |                             |
>*-----------------------------------------------*
>|     |           |                             |
>| 4K  |  250ns    |          3000ns             |
>|     |           |                             |
>*-----------------------------------------------*
>
>I guess that reason of zerocopy performance is low overhead for page
>pinning: there is big difference between 4K and 64K in case of copying
>(25000 vs 2200), but in pinning case - just 3000 vs 3500.
>
>So, zerocopy is faster than classic copy mode, but of course it requires
>specific architecture of application due to user pages pinning, buffer
>size and alignment.
>
>                             NOTES
>
>If host fails to send data with "Cannot allocate memory", check value
>/proc/sys/net/core/optmem_max - it is accounted during completion skb
>allocation. Try to update it to for example 1M and try send again:
>"echo 1048576 > /proc/sys/net/core/optmem_max" (as root).
>
>                            TESTING
>
>This patchset includes set of tests for MSG_ZEROCOPY feature. I tried to
>cover new code as much as possible so there are different cases for
>MSG_ZEROCOPY transmissions: with disabled SO_ZEROCOPY and several io
>vector types (different sizes, alignments, with unmapped pages). I also
>run tests with loopback transport and run vsockmon. In v3 i've added
>io_uring test as separated application.
>
>           LET'S SPLIT PATCHSET TO MAKE REVIEW EASIER
>
>In v3 Stefano Garzarella <sgarzare@redhat.com> asked to split this patchset
>for several parts, because it looks too big for review. I think in this
>version (v4) we can do it in the following way:
>
>[0001 - 0005] - this is preparation for virtio/vhost part.
>[0006 - 0009] - this is preparation for AF_VSOCK part.
>[0010 - 0014] - these patches allows to trigger logic from the previous
>                two parts. In addition 0014 is patch for Documentation.
>[0015 - rest] - updates for tests, utils. This part doesn't touch kernel
>                code and looks not critical.

Great!

So IIUC all the issues are fixed. I left some comments, but I think
you can start sending the virtio/vhost preparation patches to net-next
(when it will re-open).

I just pointend out something to fix, and that maybe we can merge
the first 2 patches.

I think you can restart with v0, describing in the cover letter that
the patches was part of this RFC.

Thanks,
Stefano

