Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E980D73F39A
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 06:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjF0EnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 00:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjF0EmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 00:42:25 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C0826A8;
        Mon, 26 Jun 2023 21:39:35 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id A5B095FD20;
        Tue, 27 Jun 2023 07:39:30 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1687840770;
        bh=95OGPHRDGayh8A0YYyqNyKQ1yAf3hId+4mS4asKi6iA=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=ghf1LqwVimoV5AgcawNO04eGGiCBCjyEdL8auyfrIPdU5L4J5OmaTHhzqK6bE5+8J
         2OyZwfTTaLjv9aumSOdQjIwGYx7fSGnN1LFjwiWPvS1CDmNJT92MDYyYCvKwe9TCLD
         viZ3divoTp1VLsHQgqhzPuQtTAEcOmvAKXl3PCEwLpo2gIxP0OHNvY/YCXdxsCE9fn
         4nZ4S++FAsSQomKRUmENtb77xbwNyKoNNoP3rXSzidVOPFGrkoJCy/D7R7sHLYFt/M
         ZSb+IR+eCAafKKZu8be4GVLybrjHYt/uQegVLyEfQbCGZIyyYSplr9Mwaccz4TZx15
         NFf1IVlarzDcg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 27 Jun 2023 07:39:26 +0300 (MSK)
Message-ID: <9553a82f-ce31-e2e0-ff62-8abd2a6b639b@sberdevices.ru>
Date:   Tue, 27 Jun 2023 07:34:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 2/4] virtio/vsock: support MSG_PEEK for
 SOCK_SEQPACKET
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
References: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
 <20230618062451.79980-3-AVKrasnov@sberdevices.ru>
 <yiy3kssoiyzs6ehnlo7g2xsb26zee5vih3jpgyc7i3dvfcyfpv@xvokxez3lzpo>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <yiy3kssoiyzs6ehnlo7g2xsb26zee5vih3jpgyc7i3dvfcyfpv@xvokxez3lzpo>
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



On 26.06.2023 19:28, Stefano Garzarella wrote:
> On Sun, Jun 18, 2023 at 09:24:49AM +0300, Arseniy Krasnov wrote:
>> This adds support of MSG_PEEK flag for SOCK_SEQPACKET type of socket.
>> Difference with SOCK_STREAM is that this callback returns either length
>> of the message or error.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 63 +++++++++++++++++++++++--
>> 1 file changed, 60 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 2ee40574c339..352d042b130b 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -460,6 +460,63 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>     return err;
>> }
>>
>> +static ssize_t
>> +virtio_transport_seqpacket_do_peek(struct vsock_sock *vsk,
>> +                   struct msghdr *msg)
>> +{
>> +    struct virtio_vsock_sock *vvs = vsk->trans;
>> +    struct sk_buff *skb;
>> +    size_t total, len;
>> +
>> +    spin_lock_bh(&vvs->rx_lock);
>> +
>> +    if (!vvs->msg_count) {
>> +        spin_unlock_bh(&vvs->rx_lock);
>> +        return 0;
>> +    }
>> +
>> +    total = 0;
>> +    len = msg_data_left(msg);
>> +
>> +    skb_queue_walk(&vvs->rx_queue, skb) {
>> +        struct virtio_vsock_hdr *hdr;
>> +
>> +        if (total < len) {
>> +            size_t bytes;
>> +            int err;
>> +
>> +            bytes = len - total;
>> +            if (bytes > skb->len)
>> +                bytes = skb->len;
>> +
>> +            spin_unlock_bh(&vvs->rx_lock);
>> +
>> +            /* sk_lock is held by caller so no one else can dequeue.
>> +             * Unlock rx_lock since memcpy_to_msg() may sleep.
>> +             */
>> +            err = memcpy_to_msg(msg, skb->data, bytes);
>> +            if (err)
>> +                return err;
>> +
>> +            spin_lock_bh(&vvs->rx_lock);
>> +        }
>> +
>> +        total += skb->len;
>> +        hdr = virtio_vsock_hdr(skb);
>> +
>> +        if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM) {
>> +            if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOR)
>> +                msg->msg_flags |= MSG_EOR;
>> +
>> +            break;
>> +        }
>> +    }
>> +
>> +    spin_unlock_bh(&vvs->rx_lock);
>> +
>> +    return total;
> 
> Should we return the minimum between total and len?

I guess no, because seqpacket dequeue callback always returns length of message,
then, in af_vsock.c we return either number of bytes read or length of message
depending on MSG_TRUNC flags.

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
>> +}
>> +
>> static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>>                          struct msghdr *msg,
>>                          int flags)
>> @@ -554,9 +611,9 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
>>                    int flags)
>> {
>>     if (flags & MSG_PEEK)
>> -        return -EOPNOTSUPP;
>> -
>> -    return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
>> +        return virtio_transport_seqpacket_do_peek(vsk, msg);
>> +    else
>> +        return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
>> }
>> EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
>>
>> -- 
>> 2.25.1
>>
> 
