Return-Path: <kvm+bounces-4223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C0B580F4E9
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:50:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D68291F216FF
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4936E7D8BF;
	Tue, 12 Dec 2023 17:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="RRAeW8Ca"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757F5AB;
	Tue, 12 Dec 2023 09:50:08 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 38CEE100049;
	Tue, 12 Dec 2023 20:50:05 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 38CEE100049
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1702403405;
	bh=+nCDWRlv+RAuwQZGplkp+PlM8k8l3Qzq2s7vLmgg3Sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=RRAeW8Ca1kes4HMYGXs2dQTgpWriiVwPBayBBqUwLiETNcaqNe6STJjhfzUNM/Neu
	 PK4pplaqftTReXk1KKp/5Tw+JMyIzJM0raNvUGQ0lkSDEo4ZEW8FOvxkcrFZEZRrOz
	 M5zgeNay99cNsbm7xmFb9d19fQXmx4E+H9r0TRMV9kpzuhc+HghXZPtpWd8YicDjv6
	 MB72Zy7YoI9eU1BYIw7iqBiX86PyFedokFmStLMHwQ5Yj3F/t8S8jKvqm4Nq17rUCh
	 +3gAPs+eVp4VofNiN6D5TXrJRlhHUUW3oWICy0X/7zI4S1RKJYH9fTrIwz+zp9MMP6
	 FHNBSERmoEkrA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Tue, 12 Dec 2023 20:50:04 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 12 Dec 2023 20:50:04 +0300
Message-ID: <43941eb1-f660-09eb-22c0-52b6613a0013@salutedevices.com>
Date: Tue, 12 Dec 2023 20:41:45 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v8 3/4] virtio/vsock: fix logic which reduces
 credit update messages
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231211211658.2904268-1-avkrasnov@salutedevices.com>
 <20231211211658.2904268-4-avkrasnov@salutedevices.com>
 <20231212105322-mutt-send-email-mst@kernel.org>
 <f8b52c41-9a33-def4-6ca1-fc29ed257446@salutedevices.com>
 <20231212110953-mutt-send-email-mst@kernel.org>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20231212110953-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 182068 [Dec 12 2023]
X-KSMG-AntiSpam-Version: 6.1.0.3
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 7 0.3.7 6d6bf5bd8eea7373134f756a2fd73e9456bb7d1a, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:5.0.1,7.1.1;salutedevices.com:7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/12 12:50:00 #22667219
X-KSMG-AntiVirus-Status: Clean, skipped



On 12.12.2023 19:11, Michael S. Tsirkin wrote:
> On Tue, Dec 12, 2023 at 06:50:39PM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 12.12.2023 18:54, Michael S. Tsirkin wrote:
>>> On Tue, Dec 12, 2023 at 12:16:57AM +0300, Arseniy Krasnov wrote:
>>>> Add one more condition for sending credit update during dequeue from
>>>> stream socket: when number of bytes in the rx queue is smaller than
>>>> SO_RCVLOWAT value of the socket. This is actual for non-default value
>>>> of SO_RCVLOWAT (e.g. not 1) - idea is to "kick" peer to continue data
>>>> transmission, because we need at least SO_RCVLOWAT bytes in our rx
>>>> queue to wake up user for reading data (in corner case it is also
>>>> possible to stuck both tx and rx sides, this is why 'Fixes' is used).
>>>
>>> I don't get what does "to stuck both tx and rx sides" mean.
>>
>> I meant situation when tx waits for the free space, while rx doesn't send
>> credit update, just waiting for more data. Sorry for my English :)
>>
>>> Besides being agrammatical, is there a way to do this without
>>> playing with SO_RCVLOWAT?
>>
>> No, this may happen only with non-default SO_RCVLOWAT values (e.g. != 1)
>>
>> Thanks, Arseniy 
> 
> I am split on whether we need the Fixes tag. I guess if the other side
> is vhost with SO_RCVLOWAT then it might be stuck and it might apply
> without SO_RCVLOWAT on the local kernel?

IIUC your question, then this problem is actual for any transports: g2h, h2g and
loopback.

Thanks, Arseniy

> 
> 
>>>
>>>>
>>>> Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
>>>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>>> ---
>>>>  Changelog:
>>>>  v6 -> v7:
>>>>   * Handle wrap of 'fwd_cnt'.
>>>>   * Do to send credit update when 'fwd_cnt' == 'last_fwd_cnt'.
>>>>  v7 -> v8:
>>>>   * Remove unneeded/wrong handling of wrap for 'fwd_cnt'.
>>>>
>>>>  net/vmw_vsock/virtio_transport_common.c | 13 ++++++++++---
>>>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>> index e137d740804e..8572f94bba88 100644
>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>> @@ -558,6 +558,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>>>  	struct virtio_vsock_sock *vvs = vsk->trans;
>>>>  	size_t bytes, total = 0;
>>>>  	struct sk_buff *skb;
>>>> +	u32 fwd_cnt_delta;
>>>> +	bool low_rx_bytes;
>>>>  	int err = -EFAULT;
>>>>  	u32 free_space;
>>>>  
>>>> @@ -601,7 +603,10 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>>>  		}
>>>>  	}
>>>>  
>>>> -	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
>>>> +	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
>>>> +	free_space = vvs->buf_alloc - fwd_cnt_delta;
>>>> +	low_rx_bytes = (vvs->rx_bytes <
>>>> +			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
>>>>  
>>>>  	spin_unlock_bh(&vvs->rx_lock);
>>>>  
>>>> @@ -611,9 +616,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>>>  	 * too high causes extra messages. Too low causes transmitter
>>>>  	 * stalls. As stalls are in theory more expensive than extra
>>>>  	 * messages, we set the limit to a high value. TODO: experiment
>>>> -	 * with different values.
>>>> +	 * with different values. Also send credit update message when
>>>> +	 * number of bytes in rx queue is not enough to wake up reader.
>>>>  	 */
>>>> -	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>>>> +	if (fwd_cnt_delta &&
>>>> +	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE || low_rx_bytes))
>>>>  		virtio_transport_send_credit_update(vsk);
>>>>  
>>>>  	return total;
>>>> -- 
>>>> 2.25.1
>>>
> 

