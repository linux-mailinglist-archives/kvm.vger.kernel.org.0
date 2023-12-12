Return-Path: <kvm+bounces-4205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F323780F1B2
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0964F1C20C3B
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 15:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F0477649;
	Tue, 12 Dec 2023 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="uRS1yxzc"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78BF8E;
	Tue, 12 Dec 2023 07:59:20 -0800 (PST)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id A6E1112003B;
	Tue, 12 Dec 2023 18:58:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A6E1112003B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1702396739;
	bh=JpylhQnVxqtL6DhjTBxWBLd339v5yT6kjF9fzhhVmoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=uRS1yxzc5Pw3BJRLbVkUqoTL2ILMI7X4Pc4654voF5AdLhTPpvtXwmkXOWNBIdmk2
	 1huK7ihyIEJc+SyQvrgU1cxNhEHOA2hEHWpuMEYZ0KbKtLuch3LAOFbZIfLsdIVYud
	 5m6Cw/5+mrYVJa1Phr2FZID2BYroVm6vkfbiu4PSWBCmppI7Hhyyllbly8V0OvOcgb
	 rjY3kMmRtdx6lAktpOrbAdmmxSUmSy+bHdl26d3g+3uKmt1GT8T5zSPLVHFLg2OHg1
	 m4MOl0nffjYTwYfF/l3WY5rR2QLOgr0ki+HmdLvZ+C5Ij8XSD3ux4/D8hvQnJ/LTXc
	 aRQn3V4CVx0Dg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Tue, 12 Dec 2023 18:58:59 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 12 Dec 2023 18:58:59 +0300
Message-ID: <f8b52c41-9a33-def4-6ca1-fc29ed257446@salutedevices.com>
Date: Tue, 12 Dec 2023 18:50:39 +0300
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
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20231212105322-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 182066 [Dec 12 2023]
X-KSMG-AntiSpam-Version: 6.1.0.3
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 7 0.3.7 6d6bf5bd8eea7373134f756a2fd73e9456bb7d1a, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:5.0.1,7.1.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/12 12:50:00 #22667219
X-KSMG-AntiVirus-Status: Clean, skipped



On 12.12.2023 18:54, Michael S. Tsirkin wrote:
> On Tue, Dec 12, 2023 at 12:16:57AM +0300, Arseniy Krasnov wrote:
>> Add one more condition for sending credit update during dequeue from
>> stream socket: when number of bytes in the rx queue is smaller than
>> SO_RCVLOWAT value of the socket. This is actual for non-default value
>> of SO_RCVLOWAT (e.g. not 1) - idea is to "kick" peer to continue data
>> transmission, because we need at least SO_RCVLOWAT bytes in our rx
>> queue to wake up user for reading data (in corner case it is also
>> possible to stuck both tx and rx sides, this is why 'Fixes' is used).
> 
> I don't get what does "to stuck both tx and rx sides" mean.

I meant situation when tx waits for the free space, while rx doesn't send
credit update, just waiting for more data. Sorry for my English :)

> Besides being agrammatical, is there a way to do this without
> playing with SO_RCVLOWAT?

No, this may happen only with non-default SO_RCVLOWAT values (e.g. != 1)

Thanks, Arseniy 

> 
>>
>> Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>>  Changelog:
>>  v6 -> v7:
>>   * Handle wrap of 'fwd_cnt'.
>>   * Do to send credit update when 'fwd_cnt' == 'last_fwd_cnt'.
>>  v7 -> v8:
>>   * Remove unneeded/wrong handling of wrap for 'fwd_cnt'.
>>
>>  net/vmw_vsock/virtio_transport_common.c | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index e137d740804e..8572f94bba88 100644
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
>> @@ -601,7 +603,10 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>  		}
>>  	}
>>  
>> -	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
>> +	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
>> +	free_space = vvs->buf_alloc - fwd_cnt_delta;
>> +	low_rx_bytes = (vvs->rx_bytes <
>> +			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
>>  
>>  	spin_unlock_bh(&vvs->rx_lock);
>>  
>> @@ -611,9 +616,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
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

