Return-Path: <kvm+bounces-4469-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71DAC812DFA
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AB081F2186B
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 11:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4853E469;
	Thu, 14 Dec 2023 11:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="XTPV9i/4"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E1712A;
	Thu, 14 Dec 2023 03:01:16 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 9D06410002A;
	Thu, 14 Dec 2023 14:01:13 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 9D06410002A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1702551673;
	bh=Ocja7oLDcU2O2ANLOIyPEwBcA8pE24kYRcLiOan5xok=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=XTPV9i/4hEsj0ZH0ZnUL4L4qi6NFTyCbyJyrhwEBeG/40659PSOwVxLBaXYF36AqZ
	 OE4WoOaEaI2nUMisuHA9lIGp7EoDWeAH1w56j13GauAKBU8juoc0/7WY8kwHTYM6+P
	 /C9nfY/ntx/hX1uIPQrwJZDuVvJSpZxlygivzBezrvquTuxzTWfigV1wC8WEDzL8KY
	 /PFlkKqIyc3rNjx5zb0p1TrgcYHZFfwZZ92sZJ8OibH6/zEyeeC3HIFqNE9sOOGxfB
	 2QTMPl+LBUGY1EshExG2z8s+MVwqkxWQfGi1E4mzXM0+x1Cl8n5AEKIU0eXF6zdOHr
	 h/c4LW2IHdFwQ==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu, 14 Dec 2023 14:01:13 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 14 Dec 2023 14:01:13 +0300
Message-ID: <e0e601a9-6cb2-e484-eb70-f41e7ec69c65@salutedevices.com>
Date: Thu, 14 Dec 2023 13:52:50 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v9 3/4] vsock: update SO_RCVLOWAT setting
 callback
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231214091947.395892-1-avkrasnov@salutedevices.com>
 <20231214091947.395892-4-avkrasnov@salutedevices.com>
 <20231214052502-mutt-send-email-mst@kernel.org>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <20231214052502-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 182107 [Dec 14 2023]
X-KSMG-AntiSpam-Version: 6.1.0.3
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 7 0.3.7 6d6bf5bd8eea7373134f756a2fd73e9456bb7d1a, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/14 08:33:00 #22688916
X-KSMG-AntiVirus-Status: Clean, skipped



On 14.12.2023 13:29, Michael S. Tsirkin wrote:
> On Thu, Dec 14, 2023 at 12:19:46PM +0300, Arseniy Krasnov wrote:
>> Do not return if transport callback for SO_RCVLOWAT is set (only in
>> error case). In this case we don't need to set 'sk_rcvlowat' field in
>> each transport - only in 'vsock_set_rcvlowat()'. Also, if 'sk_rcvlowat'
>> is now set only in af_vsock.c, change callback name from 'set_rcvlowat'
>> to 'notify_set_rcvlowat'.
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Maybe squash this with patch 2/4?

You mean just do 'git squash' without updating commit message manually?

Thanks, Arseniy

> 
>> ---
>>  Changelog:
>>  v3 -> v4:
>>   * Rename 'set_rcvlowat' to 'notify_set_rcvlowat'.
>>   * Commit message updated.
>>
>>  include/net/af_vsock.h           | 2 +-
>>  net/vmw_vsock/af_vsock.c         | 9 +++++++--
>>  net/vmw_vsock/hyperv_transport.c | 4 ++--
>>  3 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index e302c0e804d0..535701efc1e5 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -137,7 +137,6 @@ struct vsock_transport {
>>  	u64 (*stream_rcvhiwat)(struct vsock_sock *);
>>  	bool (*stream_is_active)(struct vsock_sock *);
>>  	bool (*stream_allow)(u32 cid, u32 port);
>> -	int (*set_rcvlowat)(struct vsock_sock *vsk, int val);
>>  
>>  	/* SEQ_PACKET. */
>>  	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>> @@ -168,6 +167,7 @@ struct vsock_transport {
>>  		struct vsock_transport_send_notify_data *);
>>  	/* sk_lock held by the caller */
>>  	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
>> +	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
>>  
>>  	/* Shutdown. */
>>  	int (*shutdown)(struct vsock_sock *, int);
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 816725af281f..54ba7316f808 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -2264,8 +2264,13 @@ static int vsock_set_rcvlowat(struct sock *sk, int val)
>>  
>>  	transport = vsk->transport;
>>  
>> -	if (transport && transport->set_rcvlowat)
>> -		return transport->set_rcvlowat(vsk, val);
>> +	if (transport && transport->notify_set_rcvlowat) {
>> +		int err;
>> +
>> +		err = transport->notify_set_rcvlowat(vsk, val);
>> +		if (err)
>> +			return err;
>> +	}
>>  
>>  	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
>>  	return 0;
> 
> 
> 
> I would s
> 
>> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>> index 7cb1a9d2cdb4..e2157e387217 100644
>> --- a/net/vmw_vsock/hyperv_transport.c
>> +++ b/net/vmw_vsock/hyperv_transport.c
>> @@ -816,7 +816,7 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vsk, ssize_t written,
>>  }
>>  
>>  static
>> -int hvs_set_rcvlowat(struct vsock_sock *vsk, int val)
>> +int hvs_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
>>  {
>>  	return -EOPNOTSUPP;
>>  }
>> @@ -856,7 +856,7 @@ static struct vsock_transport hvs_transport = {
>>  	.notify_send_pre_enqueue  = hvs_notify_send_pre_enqueue,
>>  	.notify_send_post_enqueue = hvs_notify_send_post_enqueue,
>>  
>> -	.set_rcvlowat             = hvs_set_rcvlowat
>> +	.notify_set_rcvlowat      = hvs_notify_set_rcvlowat
>>  };
>>  
>>  static bool hvs_check_transport(struct vsock_sock *vsk)
>> -- 
>> 2.25.1
> 

