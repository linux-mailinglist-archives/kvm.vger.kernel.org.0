Return-Path: <kvm+bounces-2858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 221B37FEB11
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:44:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B795B20F97
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 08:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1CC43067F;
	Thu, 30 Nov 2023 08:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="JD3N97eQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D6412C;
	Thu, 30 Nov 2023 00:44:14 -0800 (PST)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 3F9B1120028;
	Thu, 30 Nov 2023 11:44:11 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 3F9B1120028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701333851;
	bh=OqaK0CN4E7VbyGA0xV65PXd1DINTieOgHEsowFYpIuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=JD3N97eQPOlymq0NTTuWBF8GWphFd6MS53W31+ZnpbEFHr/jhA6LeENiwx1qBB5+X
	 FctuJVJegkrGpVWijXAmY+tg5WU+UY0n4dtkcXnZgTLWviOVukat14+IwosnsV/tp/
	 mhyaN+SqvHjkAh3XDbh2sNzBzSR5U2QO1kHYhzjK/TXtFK05Nc3KtrW9AvvZ5FaM8Q
	 Am1e/w6qVAhHzhjuSZxT4QpkjI+80b25Dnhj2+2BmxCwXEFYnqCNDkz7ArA47YgOG5
	 cEOPz+GptyWNH6JSo9NunkOlAgyDWJtKPQUr5Ecp4FDnf6HrCqAtcszJz9EDQZLS8C
	 dk0DmGXBo3isg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu, 30 Nov 2023 11:44:11 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 30 Nov 2023 11:44:04 +0300
Message-ID: <3fa2e016-364c-e4a9-0ee6-a2dc09a9a495@salutedevices.com>
Date: Thu, 30 Nov 2023 11:36:06 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v4 2/3] virtio/vsock: send credit update during
 setting SO_RCVLOWAT
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231129212519.2938875-1-avkrasnov@salutedevices.com>
 <20231129212519.2938875-3-avkrasnov@salutedevices.com>
 <cdgg4rtr6t3ez7l7vbgngmeitsmrplwg7vgpebodrxkpouh4yn@yb4aug7zergh>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <cdgg4rtr6t3ez7l7vbgngmeitsmrplwg7vgpebodrxkpouh4yn@yb4aug7zergh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181719 [Nov 30 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/30 05:19:00 #22579688
X-KSMG-AntiVirus-Status: Clean, skipped



On 30.11.2023 11:38, Stefano Garzarella wrote:
> On Thu, Nov 30, 2023 at 12:25:18AM +0300, Arseniy Krasnov wrote:
>> Send credit update message when SO_RCVLOWAT is updated and it is bigger
>> than number of bytes in rx queue. It is needed, because 'poll()' will
>> wait until number of bytes in rx queue will be not smaller than
>> SO_RCVLOWAT, so kick sender to send more data. Otherwise mutual hungup
>> for tx/rx is possible: sender waits for free space and receiver is
>> waiting data in 'poll()'.
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> Changelog:
>> v1 -> v2:
>>  * Update commit message by removing 'This patch adds XXX' manner.
>>  * Do not initialize 'send_update' variable - set it directly during
>>    first usage.
>> v3 -> v4:
>>  * Fit comment in 'virtio_transport_notify_set_rcvlowat()' to 80 chars.
>>
>> drivers/vhost/vsock.c                   |  3 ++-
>> include/linux/virtio_vsock.h            |  1 +
>> net/vmw_vsock/virtio_transport.c        |  3 ++-
>> net/vmw_vsock/virtio_transport_common.c | 27 +++++++++++++++++++++++++
>> net/vmw_vsock/vsock_loopback.c          |  3 ++-
>> 5 files changed, 34 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index f75731396b7e..c5e58a60a546 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -449,8 +449,9 @@ static struct virtio_transport vhost_transport = {
>>         .notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
>>         .notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
>>         .notify_buffer_size       = virtio_transport_notify_buffer_size,
>> +        .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>>
>> -        .read_skb = virtio_transport_read_skb,
>> +        .read_skb = virtio_transport_read_skb
> 
> I think it is better to avoid this change, so when we will need to add
> new callbacks, we don't need to edit this line again.
> 
> Please avoid it also in the other place in this patch.
> 
> The rest LGTM.

Yes, I see, I thought about that, but chose beauty instead of pragmatism :)
Ok, I'll fix it:)

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
>>     },
>>
>>     .send_pkt = vhost_transport_send_pkt,
>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> index ebb3ce63d64d..c82089dee0c8 100644
>> --- a/include/linux/virtio_vsock.h
>> +++ b/include/linux/virtio_vsock.h
>> @@ -256,4 +256,5 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
>> void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
>> int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
>> int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
>> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val);
>> #endif /* _LINUX_VIRTIO_VSOCK_H */
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index af5bab1acee1..8b7bb7ca8ea5 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -537,8 +537,9 @@ static struct virtio_transport virtio_transport = {
>>         .notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
>>         .notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
>>         .notify_buffer_size       = virtio_transport_notify_buffer_size,
>> +        .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>>
>> -        .read_skb = virtio_transport_read_skb,
>> +        .read_skb = virtio_transport_read_skb
>>     },
>>
>>     .send_pkt = virtio_transport_send_pkt,
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index f6dc896bf44c..1cb556ad4597 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -1684,6 +1684,33 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
>> }
>> EXPORT_SYMBOL_GPL(virtio_transport_read_skb);
>>
>> +int virtio_transport_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
>> +{
>> +    struct virtio_vsock_sock *vvs = vsk->trans;
>> +    bool send_update;
>> +
>> +    spin_lock_bh(&vvs->rx_lock);
>> +
>> +    /* If number of available bytes is less than new SO_RCVLOWAT value,
>> +     * kick sender to send more data, because sender may sleep in its
>> +     * 'send()' syscall waiting for enough space at our side.
>> +     */
>> +    send_update = vvs->rx_bytes < val;
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
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(virtio_transport_notify_set_rcvlowat);
>> +
>> MODULE_LICENSE("GPL v2");
>> MODULE_AUTHOR("Asias He");
>> MODULE_DESCRIPTION("common code for virtio vsock");
>> diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>> index 048640167411..454f69838c2a 100644
>> --- a/net/vmw_vsock/vsock_loopback.c
>> +++ b/net/vmw_vsock/vsock_loopback.c
>> @@ -96,8 +96,9 @@ static struct virtio_transport loopback_transport = {
>>         .notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
>>         .notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
>>         .notify_buffer_size       = virtio_transport_notify_buffer_size,
>> +        .notify_set_rcvlowat      = virtio_transport_notify_set_rcvlowat,
>>
>> -        .read_skb = virtio_transport_read_skb,
>> +        .read_skb = virtio_transport_read_skb
>>     },
>>
>>     .send_pkt = vsock_loopback_send_pkt,
>> -- 
>> 2.25.1
>>
> 

