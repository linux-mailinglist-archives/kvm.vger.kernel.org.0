Return-Path: <kvm+bounces-31180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D124F9C1017
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:50:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50501B22778
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 20:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22784218333;
	Thu,  7 Nov 2024 20:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="m1xESsL1"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9B918F2C3;
	Thu,  7 Nov 2024 20:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731012619; cv=none; b=syz9Hz9vOBRVRO8nIUF9rZ124WV/y5buo1DV2cgBidvzME26pAYfNRJdz6zC5OYY7OwVxfQdMvjrz1b9SbrsFx23+1DrodhIvsNZPhD0hcDurW+dlV8Zd6YqEAsBPNrjJtcBDAqk/h+wiUnfk0DavRseskELhhzIyrk3Vw4z3iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731012619; c=relaxed/simple;
	bh=75CmgpEUiFxNaINSNyji5exhmMbinVN6FHw3Iqi0zKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uZfWmrm3j4n4wiGOEByXVzXvBHeBizBuRKv89zrwize6CuvH6TR0S7brfB5v3YLfXKCamFc8GGEuXr1Gz/YWE5ih82l2LiCv3VmmW+3ZeFRFiTE6j0MxWYBLfMtf1SxOWLsrW4NfuREWlt13aM1tk8+dEPd1cX9Q3CLs/hE9vFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=m1xESsL1; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1t99SD-001b80-Lc; Thu, 07 Nov 2024 21:50:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=IDOCcFgf0OUYloIAVth+wW23XWBOmQgJTVgWj1Hzoq4=; b=m1xESsL1AgLboIIcgv78T+RyD/
	llCu1PywaSBL1BNO/rP0/MCtKPTLCIQ4QolF0qLzcrWeKXCFf8uiKQmKZvWyrv171Tw9A7xl0IlVj
	0g6LLrdzxi6m4ggYqrp4zdJdkmQL4d62m7QD6Nope8uOB5USV/V6XKGlvydigW+c8mxe2h5wuT0B2
	xnjxIMpSRWws952TtMBHSoy3sFOf4Wnyr6c4J0i2c/JuzmFqg4l6VpenNnVo17DizFEj6edbFfRe0
	Bnw2mmamuIsyJYwTvHGPtXGlxcOUUtX5CJxukbWsgY2/eAKP2qwt8mVKw6RmMz6vm4SrgAZrz3FxJ
	UabaJSPw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1t99SB-0002sb-7z; Thu, 07 Nov 2024 21:50:07 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1t99S1-002t1L-OZ; Thu, 07 Nov 2024 21:49:57 +0100
Message-ID: <a3c80efc-94b2-463a-ab2e-e7f87245fd09@rbox.co>
Date: Thu, 7 Nov 2024 21:49:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/4] virtio/vsock: Fix sk_error_queue memory leak
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jia He <justin.he@arm.com>, Arseniy Krasnov <avkrasnov@salutedevices.com>,
 Dmitry Torokhov <dtor@vmware.com>, Andy King <acking@vmware.com>,
 George Zhang <georgezhang@vmware.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org
References: <20241106-vsock-mem-leaks-v1-0-8f4ffc3099e6@rbox.co>
 <20241106-vsock-mem-leaks-v1-2-8f4ffc3099e6@rbox.co>
 <vxc6tv6433tnyfhdq2gsh7edhuskawwh4g6ehafvrt2ca3cqf2@q3kxjlygq366>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <vxc6tv6433tnyfhdq2gsh7edhuskawwh4g6ehafvrt2ca3cqf2@q3kxjlygq366>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/7/24 11:17, Stefano Garzarella wrote:
> On Wed, Nov 06, 2024 at 06:51:19PM +0100, Michal Luczaj wrote:
>> Kernel queues MSG_ZEROCOPY completion notifications on the error queue.
>> Where they remain, until explicitly recv()ed. To prevent memory leaks,
>> clean up the queue when the socket is destroyed.
>>
>> unreferenced object 0xffff8881028beb00 (size 224):
>>  comm "vsock_test", pid 1218, jiffies 4294694897
>>  hex dump (first 32 bytes):
>>    90 b0 21 17 81 88 ff ff 90 b0 21 17 81 88 ff ff  ..!.......!.....
>>    00 00 00 00 00 00 00 00 00 b0 21 17 81 88 ff ff  ..........!.....
>>  backtrace (crc 6c7031ca):
>>    [<ffffffff81418ef7>] kmem_cache_alloc_node_noprof+0x2f7/0x370
>>    [<ffffffff81d35882>] __alloc_skb+0x132/0x180
>>    [<ffffffff81d2d32b>] sock_omalloc+0x4b/0x80
>>    [<ffffffff81d3a8ae>] msg_zerocopy_realloc+0x9e/0x240
>>    [<ffffffff81fe5cb2>] virtio_transport_send_pkt_info+0x412/0x4c0
>>    [<ffffffff81fe6183>] virtio_transport_stream_enqueue+0x43/0x50
>>    [<ffffffff81fe0813>] vsock_connectible_sendmsg+0x373/0x450
>>    [<ffffffff81d233d5>] ____sys_sendmsg+0x365/0x3a0
>>    [<ffffffff81d246f4>] ___sys_sendmsg+0x84/0xd0
>>    [<ffffffff81d26f47>] __sys_sendmsg+0x47/0x80
>>    [<ffffffff820d3df3>] do_syscall_64+0x93/0x180
>>    [<ffffffff8220012b>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>> ---
>> net/vmw_vsock/af_vsock.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 35681adedd9aaec3565495158f5342b8aa76c9bc..dfd29160fe11c4675f872c1ee123d65b2da0dae6 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -836,6 +836,9 @@ static void vsock_sk_destruct(struct sock *sk)
>> {
>> 	struct vsock_sock *vsk = vsock_sk(sk);
>>
>> +	/* Flush MSG_ZEROCOPY leftovers. */
>> +	__skb_queue_purge(&sk->sk_error_queue);
>> +
> 
> It is true that for now this is supported only in the virtio transport, 
> but it's more related to the core, so please remove `virtio` from the 
> commit title.
> 
> The rest LGTM.
> ...

OK, done. Here's v2 of the series:
https://lore.kernel.org/netdev/20241107-vsock-mem-leaks-v2-0-4e21bfcfc818@rbox.co/

Thanks for the reviews,
Michal


