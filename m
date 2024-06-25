Return-Path: <kvm+bounces-20491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2540D9169BF
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 16:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A91101F255B8
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 14:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2A016D9B5;
	Tue, 25 Jun 2024 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="Hkm0O2ti"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CDDBE71;
	Tue, 25 Jun 2024 14:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719324048; cv=none; b=EbR0nJz199JX7TZ+q8i9M7GZP4VJ4FkUlhsdPRCgIM+wMelO6I7LqL+wK7KgCCYvf/fz4eoIIqeBFHHT+DdqJmU7miDuOmbCUqy7fPiqrFexzPoxhYodihkzoR2Uq5XldwIMD5xC4+b1+otCjBqSX4O+G65TnXlW2qphjr9xuyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719324048; c=relaxed/simple;
	bh=E8fBJqKCKcRbPkfSqdw1Aurg2TpWtnrvh9X7y4Gx7Co=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jP6biB3Xq7OgEyJMCxpS5uN/TH3EDugL15ljP8mdCgMn/qOA/+/e3XAosFak7Cvtt82MkDuRlJJmWFXW0EmdYqD7yHOUx+Amh4n1YHAUNWZe46rx2d2BLkP2Sam4mUDldNfhIKHCMBUI0S5fjAQIcFBBSVucwC7gkqwSgcm3Avw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=Hkm0O2ti; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id A6507120014;
	Tue, 25 Jun 2024 17:00:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A6507120014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1719324040;
	bh=W8oEHKzey12eKxkwiuXBjH9HHU7dEhdq40CCy19/1qE=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=Hkm0O2tiF85z9iR445GKbXK6D51i9k1POSTZsWU8m+CN1Egk1/pJzOHaA8yHvwSIA
	 jO4wVAZFeBhcWcYKY+UDGTyCs0cNFubQSDgpyRyrsJSt/xr5geZ9aUX0+YGYNbr5Xh
	 qfSE7j1h4+0yf2oKtFoLHMTNuv0EseUUb/0x48ZJ8qmWEE2dVkJ5fdX1q8HeL/FPER
	 zyNH9v9WzHEyGbPVgLY/danp+qWSRILZCP7ueNLLD7i9IcxmrJFtLOrOCQzJIlzfj6
	 qdkZ2bVi4PNVaMJNLLwz9O5WX/HO6CUCrP0Wb/4AtcJvD9IHzoS1ufQk0RgDzkfWpe
	 v4B9bgKI618LA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Tue, 25 Jun 2024 17:00:40 +0300 (MSK)
Received: from [172.28.65.100] (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 25 Jun 2024 17:00:39 +0300
Message-ID: <e22e0700-dde8-e559-f546-f22050c71b82@salutedevices.com>
Date: Tue, 25 Jun 2024 16:49:01 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 1/2] virtio/vsock: rework deferred credit update
 logic
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>,
	<oxffffaa@gmail.com>, Alexander Graf <graf@amazon.com>
References: <20240621192541.2082657-1-avkrasnov@salutedevices.com>
 <20240621192541.2082657-2-avkrasnov@salutedevices.com>
 <qkxvvvahksbz2n52s5eqk6s5yxsjjtyp4uehwy5gvrcq3sftvh@rred7jd2qsd4>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <qkxvvvahksbz2n52s5eqk6s5yxsjjtyp4uehwy5gvrcq3sftvh@rred7jd2qsd4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186130 [Jun 25 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 20 0.3.20 743589a8af6ec90b529f2124c2bbfc3ce1d2f20f, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:5.0.1,7.1.1;salutedevices.com:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/06/25 12:49:00 #25710474
X-KSMG-AntiVirus-Status: Clean, skipped



On 25.06.2024 16:46, Stefano Garzarella wrote:
> On Fri, Jun 21, 2024 at 10:25:40PM GMT, Arseniy Krasnov wrote:
>> Previous calculation of 'free_space' was wrong (but worked as expected
>> in most cases, see below), because it didn't account number of bytes in
>> rx queue. Let's rework 'free_space' calculation in the following way:
>> as this value is considered free space at rx side from tx point of view,
>> it must be equal to return value of 'virtio_transport_get_credit()' at
>> tx side. This function uses 'tx_cnt' counter and 'peer_fwd_cnt': first
>> is number of transmitted bytes (without wrap), second is last 'fwd_cnt'
>> value received from rx. So let's use same approach at rx side during
>> 'free_space' calculation: add 'rx_cnt' counter which is number of
>> received bytes (also without wrap) and subtract 'last_fwd_cnt' from it.
>> Now we have:
>> 1) 'rx_cnt' == 'tx_cnt' at both sides.
>> 2) 'last_fwd_cnt' == 'peer_fwd_cnt' - because first is last 'fwd_cnt'
>>   sent to tx, while second is last 'fwd_cnt' received from rx.
>>
>> Now 'free_space' is handled correctly and also we don't need
> 
> mmm, I don't know if it was wrong before, maybe we could say it was less accurate.

May be "now 'free_space' is handled in more precise way and also we ..." ?

> 
> That said, could we have the same problem now if we have a lot of producers and the virtqueue becomes full?
> 

I guess if virtqueue is full, we just wait by returning skb back to tx queue... e.g.
data exchange between two sockets just freezes. ?

>> 'low_rx_bytes' flag - this was more like a hack.
>>
>> Previous calculation of 'free_space' worked (in 99% cases), because if
>> we take a look on behaviour of both expressions (new and previous):
>>
>> '(rx_cnt - last_fwd_cnt)' and '(fwd_cnt - last_fwd_cnt)'
>>
>> Both of them always grows up, with almost same "speed": only difference
>> is that 'rx_cnt' is incremented earlier during packet is received,
>> while 'fwd_cnt' in incremented when packet is read by user. So if 'rx_cnt'
>> grows "faster", then resulting 'free_space' become smaller also, so we
>> send credit updates a little bit more, but:
>>
>>  * 'free_space' calculation based on 'rx_cnt' gives the same value,
>>    which tx sees as free space at rx side, so original idea of
> 
> Ditto, what happen if the virtqueue is full?
> 
>>    'free_space' is now implemented as planned.
>>  * Hack with 'low_rx_bytes' now is not needed.
> 
> Yeah, so this patch should also mitigate issue reported by Alex (added in CC), right?
> 
> If yes, please mention that problem and add a Reported-by giving credit to Alex.

Yes, of course!

> 
>>
>> Also here is some performance comparison between both versions of
>> 'free_space' calculation:
>>
>> *------*----------*----------*
>> |      | 'rx_cnt' | previous |
>> *------*----------*----------*
>> |H -> G|   8.42   |   7.82   |
>> *------*----------*----------*
>> |G -> H|   11.6   |   12.1   |
>> *------*----------*----------*
> 
> How many seconds did you run it? How many repetitions? There's a little discrepancy anyway, but I can't tell if it's just noise.

I run 4 times, each run for ~10 seconds... I think I can also add number of credit update messages to this report.

> 
>>
>> As benchmark 'vsock-iperf' with default arguments was used. There is no
>> significant performance difference before and after this patch.
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> include/linux/virtio_vsock.h            | 1 +
>> net/vmw_vsock/virtio_transport_common.c | 8 +++-----
>> 2 files changed, 4 insertions(+), 5 deletions(-)
> 
> Thanks for working on this, I'll do more tests but the approach LGTM.

Got it, Thanks

> 
> Thanks,
> Stefano
> 
>>
>> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>> index c82089dee0c8..3579491c411e 100644
>> --- a/include/linux/virtio_vsock.h
>> +++ b/include/linux/virtio_vsock.h
>> @@ -135,6 +135,7 @@ struct virtio_vsock_sock {
>>     u32 peer_buf_alloc;
>>
>>     /* Protected by rx_lock */
>> +    u32 rx_cnt;
>>     u32 fwd_cnt;
>>     u32 last_fwd_cnt;
>>     u32 rx_bytes;
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 16ff976a86e3..1d4e2328e06e 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -441,6 +441,7 @@ static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>>         return false;
>>
>>     vvs->rx_bytes += len;
>> +    vvs->rx_cnt += len;
>>     return true;
>> }
>>
>> @@ -558,7 +559,6 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>     size_t bytes, total = 0;
>>     struct sk_buff *skb;
>>     u32 fwd_cnt_delta;
>> -    bool low_rx_bytes;
>>     int err = -EFAULT;
>>     u32 free_space;
>>
>> @@ -603,9 +603,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>     }
>>
>>     fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
>> -    free_space = vvs->buf_alloc - fwd_cnt_delta;
>> -    low_rx_bytes = (vvs->rx_bytes <
>> -            sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
>> +    free_space = vvs->buf_alloc - (vvs->rx_cnt - vvs->last_fwd_cnt);
>>
>>     spin_unlock_bh(&vvs->rx_lock);
>>
>> @@ -619,7 +617,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>      * number of bytes in rx queue is not enough to wake up reader.
>>      */
>>     if (fwd_cnt_delta &&
>> -        (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE || low_rx_bytes))
>> +        (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE))
>>         virtio_transport_send_credit_update(vsk);
>>
>>     return total;
>> -- 
>> 2.25.1
>>
>>
> 

