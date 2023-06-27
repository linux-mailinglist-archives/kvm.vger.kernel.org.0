Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D02573F3CF
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 07:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbjF0FBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 01:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjF0FBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 01:01:01 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6431729;
        Mon, 26 Jun 2023 22:00:58 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id EB26D5FD20;
        Tue, 27 Jun 2023 08:00:55 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1687842056;
        bh=cR8wN8uCO9kSFqkCaPfhCmBi9NgiHGpowitC3jFtgLA=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=dSTC2FIPr+wdijbcnUKO7EWqrr/k7Pd4BuiZli30mbNawfDP/8cok7Tjz6EjryZuK
         cc/PjK++k5FRPwFpaTOcTjBxBPqJAUjaulBvVLvm9JsjbzDh78yeq+MeWEEkqAfYvK
         rqU8wp8oblmmbaf1k1TJlPKj1shoYblFIBvyIV3ZG95CC3feOrA+j/9GULkv+qQh/l
         RXAy4zDMsZl7umtjhA1a8kb4mCioaKEA4Ni8pqpWdSbiazhP6f0D52bObIvxa3TpQh
         VrNW14qdDbxK5eQHGypKGFff1f73pvPq860bynjqtP+xuRcGWTyVChrwSgmAQkxVEB
         FWFupeFawYZDw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 27 Jun 2023 08:00:54 +0300 (MSK)
Message-ID: <352508dd-1ea2-5d2d-9ccf-dfcfbd2bb911@sberdevices.ru>
Date:   Tue, 27 Jun 2023 07:55:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v4 00/17] vsock: MSG_ZEROCOPY flag support
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <kilgxopbdguge4bd6pfdjb3oqzemttwzf4na54xurwl62hi7uc@2njjwuhox3al>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <kilgxopbdguge4bd6pfdjb3oqzemttwzf4na54xurwl62hi7uc@2njjwuhox3al>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/27 02:11:00 #21585463
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.06.2023 19:15, Stefano Garzarella wrote:
> On Sat, Jun 03, 2023 at 11:49:22PM +0300, Arseniy Krasnov wrote:
>> Hello,
>>
>>                           DESCRIPTION
>>
>> this is MSG_ZEROCOPY feature support for virtio/vsock. I tried to follow
>> current implementation for TCP as much as possible:
>>
>> 1) Sender must enable SO_ZEROCOPY flag to use this feature. Without this
>>   flag, data will be sent in "classic" copy manner and MSG_ZEROCOPY
>>   flag will be ignored (e.g. without completion).
>>
>> 2) Kernel uses completions from socket's error queue. Single completion
>>   for single tx syscall (or it can merge several completions to single
>>   one). I used already implemented logic for MSG_ZEROCOPY support:
>>   'msg_zerocopy_realloc()' etc.
>>
>> Difference with copy way is not significant. During packet allocation,
>> non-linear skb is created and filled with pinned user pages.
>> There are also some updates for vhost and guest parts of transport - in
>> both cases i've added handling of non-linear skb for virtio part. vhost
>> copies data from such skb to the guest's rx virtio buffers. In the guest,
>> virtio transport fills tx virtio queue with pages from skb.
>>
>> Head of this patchset is:
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=d20dd0ea14072e8a90ff864b2c1603bd68920b4b
>>
>>
>> This version has several limits/problems:
>>
>> 1) As this feature totally depends on transport, there is no way (or it
>>   is difficult) to check whether transport is able to handle it or not
>>   during SO_ZEROCOPY setting. Seems I need to call AF_VSOCK specific
>>   setsockopt callback from setsockopt callback for SOL_SOCKET, but this
>>   leads to lock problem, because both AF_VSOCK and SOL_SOCKET callback
>>   are not considered to be called from each other. So in current version
>>   SO_ZEROCOPY is set successfully to any type (e.g. transport) of
>>   AF_VSOCK socket, but if transport does not support MSG_ZEROCOPY,
>>   tx routine will fail with EOPNOTSUPP.
>>
>>   ^^^
>>   This is still no resolved :(
>>
>> 2) When MSG_ZEROCOPY is used, for each tx system call we need to enqueue
>>   one completion. In each completion there is flag which shows how tx
>>   was performed: zerocopy or copy. This leads that whole message must
>>   be send in zerocopy or copy way - we can't send part of message with
>>   copying and rest of message with zerocopy mode (or vice versa). Now,
>>   we need to account vsock credit logic, e.g. we can't send whole data
>>   once - only allowed number of bytes could sent at any moment. In case
>>   of copying way there is no problem as in worst case we can send single
>>   bytes, but zerocopy is more complex because smallest transmission
>>   unit is single page. So if there is not enough space at peer's side
>>   to send integer number of pages (at least one) - we will wait, thus
>>   stalling tx side. To overcome this problem i've added simple rule -
>>   zerocopy is possible only when there is enough space at another side
>>   for whole message (to check, that current 'msghdr' was already used
>>   in previous tx iterations i use 'iov_offset' field of it's iov iter).
>>
>>   ^^^
>>   Discussed as ok during v2. Link:
>>   https://lore.kernel.org/netdev/23guh3txkghxpgcrcjx7h62qsoj3xgjhfzgtbmqp2slrz3rxr4@zya2z7kwt75l/
>>
>> 3) loopback transport is not supported, because it requires to implement
>>   non-linear skb handling in dequeue logic (as we "send" fragged skb
>>   and "receive" it from the same queue). I'm going to implement it in
>>   next versions.
>>
>>   ^^^ fixed in v2
>>
>> 4) Current implementation sets max length of packet to 64KB. IIUC this
>>   is due to 'kmalloc()' allocated data buffers. I think, in case of
>>   MSG_ZEROCOPY this value could be increased, because 'kmalloc()' is
>>   not touched for data - user space pages are used as buffers. Also
>>   this limit trims every message which is > 64KB, thus such messages
>>   will be send in copy mode due to 'iov_offset' check in 2).
>>
>>   ^^^ fixed in v2
>>
>>                         PATCHSET STRUCTURE
>>
>> Patchset has the following structure:
>> 1) Handle non-linear skbuff on receive in virtio/vhost.
>> 2) Handle non-linear skbuff on send in virtio/vhost.
>> 3) Updates for AF_VSOCK.
>> 4) Enable MSG_ZEROCOPY support on transports.
>> 5) Tests/tools/docs updates.
>>
>>                            PERFORMANCE
>>
>> Performance: it is a little bit tricky to compare performance between
>> copy and zerocopy transmissions. In zerocopy way we need to wait when
>> user buffers will be released by kernel, so it is like synchronous
>> path (wait until device driver will process it), while in copy way we
>> can feed data to kernel as many as we want, don't care about device
>> driver. So I compared only time which we spend in the 'send()' syscall.
>> Then if this value will be combined with total number of transmitted
>> bytes, we can get Gbit/s parameter. Also to avoid tx stalls due to not
>> enough credit, receiver allocates same amount of space as sender needs.
>>
>> Sender:
>> ./vsock_perf --sender <CID> --buf-size <buf size> --bytes 256M [--zc]
>>
>> Receiver:
>> ./vsock_perf --vsk-size 256M
>>
>> I run tests on two setups: desktop with Core i7 - I use this PC for
>> development and in this case guest is nested guest, and host is normal
>> guest. Another hardware is some embedded board with Atom - here I don't
>> have nested virtualization - host runs on hw, and guest is normal guest.
>>
>> G2H transmission (values are Gbit/s):
>>
>>   Core i7 with nested guest.            Atom with normal guest.
>>
>> *-------------------------------*   *-------------------------------*
>> |          |         |          |   |          |         |          |
>> | buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
>> |          |         |          |   |          |         |          |
>> *-------------------------------*   *-------------------------------*
>> |   4KB    |    3    |    10    |   |   4KB    |   0.8   |   1.9    |
>> *-------------------------------*   *-------------------------------*
>> |   32KB   |   20    |    61    |   |   32KB   |   6.8   |   20.2   |
>> *-------------------------------*   *-------------------------------*
>> |   256KB  |   33    |   244    |   |   256KB  |   7.8   |   55     |
>> *-------------------------------*   *-------------------------------*
>> |    1M    |   30    |   373    |   |    1M    |   7     |   95     |
>> *-------------------------------*   *-------------------------------*
>> |    8M    |   22    |   475    |   |    8M    |   7     |   114    |
>> *-------------------------------*   *-------------------------------*
>>
>> H2G:
>>
>>   Core i7 with nested guest.            Atom with normal guest.
>>
>> *-------------------------------*   *-------------------------------*
>> |          |         |          |   |          |         |          |
>> | buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
>> |          |         |          |   |          |         |          |
>> *-------------------------------*   *-------------------------------*
>> |   4KB    |   20    |    10    |   |   4KB    |   4.37  |    3     |
>> *-------------------------------*   *-------------------------------*
>> |   32KB   |   37    |    75    |   |   32KB   |   11    |   18     |
>> *-------------------------------*   *-------------------------------*
>> |   256KB  |   44    |   299    |   |   256KB  |   11    |   62     |
>> *-------------------------------*   *-------------------------------*
>> |    1M    |   28    |   335    |   |    1M    |   9     |   77     |
>> *-------------------------------*   *-------------------------------*
>> |    8M    |   27    |   417    |   |    8M    |  9.35   |  115     |
>> *-------------------------------*   *-------------------------------*
>>
>> * Let's look to the first line of both tables - where copy is better
>>   than zerocopy. I analyzed this case more deeply and found that
>>   bottleneck is function 'vhost_work_queue()'. With 4K buffer size,
>>   caller spends too much time in it with zerocopy mode (comparing to
>>   copy mode). This happens only with 4K buffer size. This function just
>>   calls 'wake_up_process()' and its internal logic does not depends on
>>   skb, so i think potential reason (may be) is interval between two
>>   calls of this function (e.g. how often it is called). Note, that
>>   'vhost_work_queue()' differs from the same function at guest's side of
>>   transport: 'virtio_transport_send_pkt()' uses 'queue_work()' which
>>   i think is more optimized for worker purposes, than direct call to
>>   'wake_up_process()'. But again - this is just my assumption.
> 
> Thanks for the analysis, however for small payloads it makes sense that
> the cost might be too high that optimization does not bring benefits.
> 
>>
>> Loopback:
>>
>>   Core i7 with nested guest.            Atom with normal guest.
>>
>> *-------------------------------*   *-------------------------------*
>> |          |         |          |   |          |         |          |
>> | buf size |   copy  | zerocopy |   | buf size |   copy  | zerocopy |
>> |          |         |          |   |          |         |          |
>> *-------------------------------*   *-------------------------------*
>> |   4KB    |    8    |     7    |   |   4KB    |   1.8   |   1.3    |
>> *-------------------------------*   *-------------------------------*
>> |   32KB   |   38    |    44    |   |   32KB   |   10    |   10     |
>> *-------------------------------*   *-------------------------------*
>> |   256KB  |   55    |   168    |   |   256KB  |   15    |   36     |
>> *-------------------------------*   *-------------------------------*
>> |    1M    |   53    |   250    |   |    1M    |   12    |   45     |
>> *-------------------------------*   *-------------------------------*
>> |    8M    |   40    |   344    |   |    8M    |   11    |   74     |
>> *-------------------------------*   *-------------------------------*
>>
>> I analyzed performace difference more deeply for the following setup:
>> server: ./vsock_perf --vsk-size 16M
>> client: ./vsock_perf --sender 2 --bytes 16M --buf-size 16K/4K [--zc]
>>
>> In other words I send 16M of data from guest to host in copy/zerocopy
>> modes and with two different sizes of buffer - 4K and 64K. Let's see
>> to tx path for both modes - it consists of two steps:
>>
>> copy:
>> 1) Allocate skb of buffer's length.
>> 2) Copy data to skb from buffer.
>>
>> zerocopy:
>> 1) Allocate skb with header space only.
>> 2) Pin pages of the buffer and insert them to skb.
>>
>> I measured average number of ns (returned by 'ktime_get()') for each
>> step above:
>> 1) Skb allocation (for both copy and zerocopy modes).
>> 2) For copy mode in 'memcpy_to_msg()' - copying.
>> 3) For zerocopy mode in '__zerocopy_sg_from_iter()' - pinning.
>>
>> Here are results for copy mode:
>> *-------------------------------------*
>> | buf | skb alloc | 'memcpy_to_msg()' |
>> *-------------------------------------*
>> |     |           |                   |
>> | 64K |  5000ns   |      25000ns      |
>> |     |           |                   |
>> *-------------------------------------*
>> |     |           |                   |
>> | 4K  |  800ns    |      2200ns       |
>> |     |           |                   |
>> *-------------------------------------*
>>
>> Here are results for zerocopy mode:
>> *-----------------------------------------------*
>> | buf | skb alloc | '__zerocopy_sg_from_iter()' |
>> *-----------------------------------------------*
>> |     |           |                             |
>> | 64K |  250ns    |          3500ns             |
>> |     |           |                             |
>> *-----------------------------------------------*
>> |     |           |                             |
>> | 4K  |  250ns    |          3000ns             |
>> |     |           |                             |
>> *-----------------------------------------------*
>>
>> I guess that reason of zerocopy performance is low overhead for page
>> pinning: there is big difference between 4K and 64K in case of copying
>> (25000 vs 2200), but in pinning case - just 3000 vs 3500.
>>
>> So, zerocopy is faster than classic copy mode, but of course it requires
>> specific architecture of application due to user pages pinning, buffer
>> size and alignment.
> 
> Makes sense!
> 
>>
>>                             NOTES
>>
>> If host fails to send data with "Cannot allocate memory", check value
>> /proc/sys/net/core/optmem_max - it is accounted during completion skb
>> allocation. Try to update it to for example 1M and try send again:
>> "echo 1048576 > /proc/sys/net/core/optmem_max" (as root).
>>
>>                            TESTING
>>
>> This patchset includes set of tests for MSG_ZEROCOPY feature. I tried to
>> cover new code as much as possible so there are different cases for
>> MSG_ZEROCOPY transmissions: with disabled SO_ZEROCOPY and several io
>> vector types (different sizes, alignments, with unmapped pages). I also
>> run tests with loopback transport and run vsockmon. In v3 i've added
>> io_uring test as separated application.
>>
>>           LET'S SPLIT PATCHSET TO MAKE REVIEW EASIER
>>
>> In v3 Stefano Garzarella <sgarzare@redhat.com> asked to split this patchset
>> for several parts, because it looks too big for review. I think in this
>> version (v4) we can do it in the following way:
>>
>> [0001 - 0005] - this is preparation for virtio/vhost part.
>> [0006 - 0009] - this is preparation for AF_VSOCK part.
>> [0010 - 0013] - these patches allows to trigger logic from the previous
>>                two parts.
>> [0014 - rest] - updates for doc, tests, utils. This part doesn't touch
>>                kernel code and looks not critical.
> 
> Yeah, I like this split, but I'd include 14 in the (10, 13) group.
> 
> I have reviewed most of them and I think we are well on our way :-)
> I've already seen that Bobby suggested changes for v5, so I'll review
> that version better.
> 
> Great work so far!

Hello Stefano!

Thanks for review! I left some questions, but most of comments are clear
for me. So I guess that idea of split is that I still keep all patches in
a big single patchset, but preserve structure described above and we will
do review process step by step according split?

Or I should split this patchset for 3 separated sets? I guess this will be
more complex to review...

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
