Return-Path: <kvm+bounces-3777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F7E807AF2
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 23:01:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5183B211B3
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 22:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C27256393;
	Wed,  6 Dec 2023 22:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="jYw/YYl5"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386D912F;
	Wed,  6 Dec 2023 14:01:03 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id D29A010008C;
	Thu,  7 Dec 2023 01:01:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru D29A010008C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701900061;
	bh=JzyNiWl2gdrVX1kXonULVJjTpsF0XVhmt7tbHR+gCQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=jYw/YYl5JDz6vOJ0EiUCq5glEAvDGf1geLPpWaNn+IFtHe8YR94K5nqNdIYZqy/BG
	 29FrgTmTVkabKkwDvfuo+m4pfVBVukFVmabVLyw4Z1UF/0NfQA/Gw+0svDCoxRrB2f
	 uPUA9ngLQeOx4tjl05W0gCk0uXkNB+QyYSZveV+pdowX5J+XyZykN9AB18+DL2bnnM
	 wGLa/QOytvopSmv1B8Rx47aV5DaX565g1otzYXZ103XzNRvqg+h+6mSBjTnKxYeQJR
	 c8AeCT/YT022y6yvZ3wt0+IQo1CcU2+sB2V/dwhB1WDeAQ9iGH6YaWcJd0V9ftluOe
	 Zf1j4TxZC0Asw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu,  7 Dec 2023 01:01:01 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 7 Dec 2023 01:01:01 +0300
Message-ID: <d9d1ec6a-dd9b-61d9-9211-52e9437cbb1f@salutedevices.com>
Date: Thu, 7 Dec 2023 00:52:51 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v7 3/4] virtio/vsock: fix logic which reduces
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
References: <20231206211849.2707151-1-avkrasnov@salutedevices.com>
 <20231206211849.2707151-4-avkrasnov@salutedevices.com>
 <20231206165045-mutt-send-email-mst@kernel.org>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20231206165045-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181917 [Dec 06 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_from_domain_doesnt_match_to}, p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/06 19:07:00 #22622451
X-KSMG-AntiVirus-Status: Clean, skipped



On 07.12.2023 00:53, Michael S. Tsirkin wrote:
> On Thu, Dec 07, 2023 at 12:18:48AM +0300, Arseniy Krasnov wrote:
>> Add one more condition for sending credit update during dequeue from
>> stream socket: when number of bytes in the rx queue is smaller than
>> SO_RCVLOWAT value of the socket. This is actual for non-default value
>> of SO_RCVLOWAT (e.g. not 1) - idea is to "kick" peer to continue data
>> transmission, because we need at least SO_RCVLOWAT bytes in our rx
>> queue to wake up user for reading data (in corner case it is also
>> possible to stuck both tx and rx sides, this is why 'Fixes' is used).
>> Also handle case when 'fwd_cnt' wraps, while 'last_fwd_cnt' is still
>> not.
>>
>> Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>>  Changelog:
>>  v6 -> v7:
>>   * Handle wrap of 'fwd_cnt'.
>>   * Do to send credit update when 'fwd_cnt' == 'last_fwd_cnt'.
>>
>>  net/vmw_vsock/virtio_transport_common.c | 18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index e137d740804e..39f8660d825d 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -558,6 +558,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>  	struct virtio_vsock_sock *vvs = vsk->trans;
>>  	size_t bytes, total = 0;
>>  	struct sk_buff *skb;
>> +	u32 fwd_cnt_delta;
>> +	bool low_rx_bytes;
>>  	int err = -EFAULT;
>>  	u32 free_space;
>>  
>> @@ -601,7 +603,15 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>  		}
>>  	}
>>  
>> -	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
>> +	/* Handle wrap of 'fwd_cnt'. */
>> +	if (vvs->fwd_cnt < vvs->last_fwd_cnt)
>> +		fwd_cnt_delta = vvs->fwd_cnt + (U32_MAX - vvs->last_fwd_cnt);
> 
> Are you sure there's no off by one here? for example if fwd_cnt is 0
> and last_fwd_cnt is 0xfffffffff then apparently delta is 0.

Seems yes, I need +1 here

> 
> 
>> +	else
>> +		fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
> 
> I actually don't see what is wrong with just
> 	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt
> 32 bit unsigned math will I think handle wrap around correctly.
> 
> And given buf_alloc is also u32 - I don't see where the bug is in
> the original code.

I think problem is when fwd_cnt wraps, while last_fwd_cnt is not. In this
case fwd_cnt_delta will be too big, so we won't send credit update which
leads to stall for sender

Thanks, Arseniy

> 
> 
>> +
>> +	free_space = vvs->buf_alloc - fwd_cnt_delta;
>> +	low_rx_bytes = (vvs->rx_bytes <
>> +			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
>>  
>>  	spin_unlock_bh(&vvs->rx_lock);
>>  
>> @@ -611,9 +621,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>  	 * too high causes extra messages. Too low causes transmitter
>>  	 * stalls. As stalls are in theory more expensive than extra
>>  	 * messages, we set the limit to a high value. TODO: experiment
>> -	 * with different values.
>> +	 * with different values. Also send credit update message when
>> +	 * number of bytes in rx queue is not enough to wake up reader.
>>  	 */
>> -	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>> +	if (fwd_cnt_delta &&
>> +	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE || low_rx_bytes))
>>  		virtio_transport_send_credit_update(vsk);
>>  
>>  	return total;
>> -- 
>> 2.25.1
> 

