Return-Path: <kvm+bounces-3566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 938D78053F6
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 13:16:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E3462814FA
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12D65C065;
	Tue,  5 Dec 2023 12:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="N4ZKnLli"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A21BD7;
	Tue,  5 Dec 2023 04:15:59 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 0304F100061;
	Tue,  5 Dec 2023 15:15:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 0304F100061
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701778556;
	bh=kWklx3LIC74gThjkSfgiYRQGmqo1VZpnoPcqXj732lM=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=N4ZKnLlizlk/1pmFEMcXN9S9gJyvMBLx+k0q9UbkB5ETTkZUtz36e8lccUemnCKbx
	 OGq/8vd3FZSqwq/Pf3uN3cw091poOsYgVVhQP/7YB5FdiDi6x2SEQXBQq7ZIdH2zAE
	 n5S+dB10YN1wHY+Z+8GrH3xfViLKpGK3DovEP2piAPdG7gaF+H9/kl5ljqdBgTOMx0
	 hE+AR9ihS9t0/JdIw6ftjnH3hp/cyyG+GhnBPx8YJKoXvDf/h3KXKzs3weBocQLCsJ
	 8z2+VWP+4tQ4OSU7EYtleOhaGYrrvR33ZkN7ALfJvswkOfFGJVSSMehO9fw/xe9bG8
	 PUfZ791og/eEg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Tue,  5 Dec 2023 15:15:55 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 5 Dec 2023 15:15:54 +0300
Message-ID: <809a8962-0082-6443-4e59-549eb28b9a82@salutedevices.com>
Date: Tue, 5 Dec 2023 15:07:47 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v6 3/4] virtio/vsock: fix logic which reduces
 credit update messages
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231205064806.2851305-1-avkrasnov@salutedevices.com>
 <20231205064806.2851305-4-avkrasnov@salutedevices.com>
 <v335g4fjrn5f6tsw4nysztaklze2obnjwpezps3jgb2xickpge@ea5woxob52nc>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <v335g4fjrn5f6tsw4nysztaklze2obnjwpezps3jgb2xickpge@ea5woxob52nc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181841 [Dec 05 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;salutedevices.com:7.1.1;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/05 03:59:00 #22607474
X-KSMG-AntiVirus-Status: Clean, skipped



On 05.12.2023 13:54, Stefano Garzarella wrote:
> On Tue, Dec 05, 2023 at 09:48:05AM +0300, Arseniy Krasnov wrote:
>> Add one more condition for sending credit update during dequeue from
>> stream socket: when number of bytes in the rx queue is smaller than
>> SO_RCVLOWAT value of the socket. This is actual for non-default value
>> of SO_RCVLOWAT (e.g. not 1) - idea is to "kick" peer to continue data
>> transmission, because we need at least SO_RCVLOWAT bytes in our rx
>> queue to wake up user for reading data (in corner case it is also
>> possible to stuck both tx and rx sides, this is why 'Fixes' is used).
>>
>> Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 9 +++++++--
>> 1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index e137d740804e..461c89882142 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -558,6 +558,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>     struct virtio_vsock_sock *vvs = vsk->trans;
>>     size_t bytes, total = 0;
>>     struct sk_buff *skb;
>> +    bool low_rx_bytes;
>>     int err = -EFAULT;
>>     u32 free_space;
>>
>> @@ -602,6 +603,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>     }
>>
>>     free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
>> +    low_rx_bytes = (vvs->rx_bytes <
>> +            sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
> 
> As in the previous patch, should we avoid the update it if `fwd_cnt` and `last_fwd_cnt` are the same?
> 
> Now I'm thinking if it is better to add that check directly in virtio_transport_send_credit_update().

Good point, but I think, that it is better to keep this check here, because access to 'fwd_cnt' and 'last_fwd_cnt'
requires taking rx_lock - so I guess it is better to avoid taking this lock every time in 'virtio_transport_send_credit_update()'.
So may be we can do something like:


fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
free_space = vvs->buf_alloc - fwd_cnt_delta;

and then, after lock is released:

if (fwd_cnt_delta && (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE ||
    low_rx_bytes))
        virtio_transport_send_credit_update(vsk);

WDYT?

Also, I guess that next idea to update this optimization(in next patchset), is to make
threshold depends on vvs->buf_alloc. Because if someone changes minimum buffer size to
for example 32KB, and then sets buffer size to 32KB, then free_space will be always
non-zero, thus optimization is off now and credit update is sent on every read.

Thanks, Arseniy

> 
> Stefano
> 
>>
>>     spin_unlock_bh(&vvs->rx_lock);
>>
>> @@ -611,9 +614,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>      * too high causes extra messages. Too low causes transmitter
>>      * stalls. As stalls are in theory more expensive than extra
>>      * messages, we set the limit to a high value. TODO: experiment
>> -     * with different values.
>> +     * with different values. Also send credit update message when
>> +     * number of bytes in rx queue is not enough to wake up reader.
>>      */
>> -    if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>> +    if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE ||
>> +        low_rx_bytes)
>>         virtio_transport_send_credit_update(vsk);
>>
>>     return total;
>> -- 
>> 2.25.1
>>
> 

