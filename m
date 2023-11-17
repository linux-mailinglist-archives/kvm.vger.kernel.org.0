Return-Path: <kvm+bounces-1914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 786757EEC88
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CCB39B20BA9
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 07:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AAC7DF4D;
	Fri, 17 Nov 2023 07:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="D6NFNpiP"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A327D51;
	Thu, 16 Nov 2023 23:17:57 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id A33E2100053;
	Fri, 17 Nov 2023 10:17:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A33E2100053
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1700205472;
	bh=1fkmIGYzp5c7rAK+NR4+zP/oYo2cB5TkkjHXMWdQCgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=D6NFNpiPLM+x8x/5pPmInanARsPkHeQ9DY9bAjY6pfaCMIzIIqRMfrhDCITnqd8sA
	 rcXdWJTYQqWPqbpWp9qUJOTLptmzgaWQ4H8eP0hpNZdcvxhhzNPjgvQQrSOenIGXWm
	 rN6uDqi+kpYS4T6/kSmMbfAvdvj5AvKGXqgPOHJT4hIgi707M2kijApzQ5NgWFmvWI
	 jSKwW4raAHISahMXFwRkTu/4V2h9xS976ZUF03kY6Zmv82m1Dstic+q4TaiSoWTbXW
	 hAQaZfye17Jw2PqqcGUa0eIuC/fpbLYENKhnfR4UIw2OaHo5g9L1OiUpAia327o6Rq
	 1tvE0tNkkgtuQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 17 Nov 2023 10:17:51 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 17 Nov 2023 10:17:51 +0300
Message-ID: <99935734-4006-509f-5e02-3229f0847b67@salutedevices.com>
Date: Fri, 17 Nov 2023 10:10:08 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 1/2] virtio/vsock: send credit update during
 setting SO_RCVLOWAT
To: Stefano Garzarella <sgarzare@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231108072004.1045669-1-avkrasnov@salutedevices.com>
 <20231108072004.1045669-2-avkrasnov@salutedevices.com>
 <6owgy5zo5lmx3w2vsu6ux552olyuq4lnqzrawngc3gmi5fonn6@6emsez7krq7f>
Content-Language: en-US
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <6owgy5zo5lmx3w2vsu6ux552olyuq4lnqzrawngc3gmi5fonn6@6emsez7krq7f>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181429 [Nov 17 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 543 543 1e3516af5cdd92079dfeb0e292c8747a62cb1ee4, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/17 06:08:00 #22469568
X-KSMG-AntiVirus-Status: Clean, skipped



On 15.11.2023 14:08, Stefano Garzarella wrote:
> On Wed, Nov 08, 2023 at 10:20:03AM +0300, Arseniy Krasnov wrote:
>> This adds sending credit update message when SO_RCVLOWAT is updated and
>> it is bigger than number of bytes in rx queue. It is needed, because
>> 'poll()' will wait until number of bytes in rx queue will be not smaller
>> than SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual
>> hungup for tx/rx is possible: sender waits for free space and receiver
>> is waiting data in 'poll()'.
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> drivers/vhost/vsock.c                   |  2 ++
>> include/linux/virtio_vsock.h            |  1 +
>> net/vmw_vsock/virtio_transport.c        |  2 ++
>> net/vmw_vsock/virtio_transport_common.c | 31 +++++++++++++++++++++++++
>> net/vmw_vsock/vsock_loopback.c          |  2 ++
>> 5 files changed, 38 insertions(+)
>>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index f75731396b7e..ecfa5c11f5ee 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -451,6 +451,8 @@ static struct virtio_transport vhost_transport = {
>>         .notify_buffer_size       = virtio_transport_notify_buffer_size,
>>
>>         .read_skb = virtio_transport_read_skb,
>> +
>> +        .set_rcvlowat             = virtio_transport_set_rcvlowat
>>     },
>>
>>     .send_pkt = vhost_transport_send_pkt,
>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> index ebb3ce63d64d..97dc1bebc69c 100644
>> --- a/include/linux/virtio_vsock.h
>> +++ b/include/linux/virtio_vsock.h
>> @@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>> void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
>> int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>> int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
>> +int virtio_transport_set_rcvlowat(struct vsock_sock *vsk, int val);
>> #endif /* _LINUX_VIRTIO_VSOCK_H */
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index af5bab1acee1..cf3431189d0c 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -539,6 +539,8 @@ static struct virtio_transport virtio_transport = {
>>         .notify_buffer_size       = virtio_transport_notify_buffer_size,
>>
>>         .read_skb = virtio_transport_read_skb,
>> +
>> +        .set_rcvlowat             = virtio_transport_set_rcvlowat
>>     },
>>
>>     .send_pkt = virtio_transport_send_pkt,
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index e22c81435ef7..88a58163046e 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -1676,6 +1676,37 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>> }
>> EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>>
>> +int virtio_transport_set_rcvlowat(struct vsock_sock *vsk, int val)
>> +{
>> +    struct virtio_vsock_sock *vvs = vsk->trans;
>> +    bool send_update = false;
> 
> I'd declare this not initialized.
> 
>> +
>> +    spin_lock_bh(&vvs->rx_lock);
>> +
>> +    /* If number of available bytes is less than new
>> +     * SO_RCVLOWAT value, kick sender to send more
>> +     * data, because sender may sleep in its 'send()'
>> +     * syscall waiting for enough space at our side.
>> +     */
>> +    if (vvs->rx_bytes < val)
>> +        send_update = true;
> 
> Then here just:
>     send_update = vvs->rx_bytes < val;
> 
>> +
>> +    spin_unlock_bh(&vvs->rx_lock);
>> +
>> +    if (send_update) {
>> +        int err;
>> +
>> +        err = virtio_transport_send_credit_update(vsk);
>> +        if (err < 0)
>> +            return err;
>> +    }
>> +
>> +    WRITE_ONCE(sk_vsock(vsk)->sk_rcvlowat, val ? : 1);
> 
> Not in this patch, but what about doing this in vsock_set_rcvlowat() in af_vsock.c?
> 
> I mean avoid to return if `transport->set_rcvlowat(vsk, val)` is
> successfully, so set sk_rcvlowat in a single point.

Yes, we can do it, I'll include new patch as 0001 in v2, don't remember why it wasn't implemented in this
way before.

Thanks, Arseniy

> 
> The rest LGTM!
> 
> Stefano
> 
>> +
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_transport_set_rcvlowat);
>> +
>> MODULE_LICENSE("GPL v2");
>> MODULE_AUTHOR("Asias He");
>> MODULE_DESCRIPTION("common code for virtio vsock");
>> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>> index 048640167411..388c157f6633 100644
>> --- a/net/vmw_vsock/vsock_loopback.c
>> +++ b/net/vmw_vsock/vsock_loopback.c
>> @@ -98,6 +98,8 @@ static struct virtio_transport loopback_transport = {
>>         .notify_buffer_size       = virtio_transport_notify_buffer_size,
>>
>>         .read_skb = virtio_transport_read_skb,
>> +
>> +        .set_rcvlowat             = virtio_transport_set_rcvlowat
>>     },
>>
>>     .send_pkt = vsock_loopback_send_pkt,
>> -- 2.25.1
>>
> 

