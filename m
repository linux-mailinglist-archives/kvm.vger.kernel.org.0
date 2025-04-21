Return-Path: <kvm+bounces-43732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68342A9587B
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 23:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAE613A69E3
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 21:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C6C21B8F2;
	Mon, 21 Apr 2025 21:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="NgDsamrU"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18CB1EDA0E;
	Mon, 21 Apr 2025 21:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745272390; cv=none; b=FKcPDPj592flw6OyA3PNKShzcjAjSDqj8agRHMcQs5loGfTslVlahQ6gzveC2I8ROEl27wLoG6ImVGs+sHa9LLKQxDP1GWU8nVTyH8cKZi/vLn30qtYfyjMzKtMov6tUpJX/ouwYtfAJN8MDv6NMwjnfZ5mu8xNLtgI0hIekBF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745272390; c=relaxed/simple;
	bh=6TVrMtlu19zY/wxbixXpv8KgBzM6j+9175a7iqm9jAo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=S4qgO5Cn4uFZvBmnuTjmqyZpBiHNB4ea9rx/tA6zy2YehjaJfPHf0hZyPxXzquqA/yVpe71Q3A66mTf9xMQRez3NKxIBGwQ6uhCWP0LCYddcCQa7t13f9lchcSf98tGaHfn3YIXobpFZaiIXQynsHEUDOQqyLXMK9I48k8ECFa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=NgDsamrU; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u6z4W-001iJv-OO; Mon, 21 Apr 2025 23:53:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID;
	bh=M+FkH4VAKYH9xhhtQ8r3p9M8RjS2pfNv3Ius6h/Rf3c=; b=NgDsamrU276JwI7Hq5C68Fr0FW
	pCbhcU7mGT1oVl3aaz3RpEyO8/2zirwH5K64s5NKmlUMIAWQAOds4L9bm8giYZXVwwZjax+J2oJat
	cZruhUzWN6B4hJ+IIz1WbDD+2uFYmnBUR0hedTxHWGnKEe3Zy+H71/0w20aIYPoK7IR6sxwfIRaWI
	lyekHxWisYpBw6BIKD4X5JKA6MtUhdggFXOUKwlBr6P+irKGWe+oThcSWFwHgljx+lguvUQU75k3G
	MyvgkcPz4/Ymo6VcGUdb3Wd5As8JQWDulkXXy2V+LtHPT89k9GzYZaODvhZm7yH9YkP0Sc82p/xDV
	M4qlVb6g==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u6z4V-0008Lh-5M; Mon, 21 Apr 2025 23:52:59 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u6z4Q-004YWS-AU; Mon, 21 Apr 2025 23:52:54 +0200
Message-ID: <d16f61d2-df65-41b9-a042-f54466b7e764@rbox.co>
Date: Mon, 21 Apr 2025 23:52:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH net-next 1/2] vsock: Linger on unsent data
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250407-vsock-linger-v1-0-1458038e3492@rbox.co>
 <20250407-vsock-linger-v1-1-1458038e3492@rbox.co>
 <p5toijsqhehc4kp7gztto3nmrqa33f62duozoxn7u5hh6d2xpe@lfzy6kdszegf>
Content-Language: pl-PL, en-GB
In-Reply-To: <p5toijsqhehc4kp7gztto3nmrqa33f62duozoxn7u5hh6d2xpe@lfzy6kdszegf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 15:43, Stefano Garzarella wrote:
> On Mon, Apr 07, 2025 at 08:41:43PM +0200, Michal Luczaj wrote:
>> Change the behaviour of a lingering close(): instead of waiting for all
>> data to be consumed, block until data is considered sent, i.e. until worker
>> picks the packets and decrements virtio_vsock_sock::bytes_unsent down to 0.
>>
>> Do linger on shutdown() just as well.
> 
> I think this should go in a separate patch.

As discussed, dropping linger on shutdown() for now.

>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..383c6644d047589035c0439c47d1440273e67ea9 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1013,6 +1013,29 @@ static int vsock_getname(struct socket *sock,
>> 	return err;
>> }
>>
>> +void vsock_linger(struct sock *sk, long timeout)
>> +{
>> +	if (timeout) {
> 
> I would prefer to avoid a whole nested block and return immediately
> in such a case. (It's pre-existing, but since we are moving this code
> I'd fix it).
> 
> 	if (!timeout)
> 		return;

In v2 no code is moved (since no shutdown() lingering), so I'll reduce the
indentation in a separate patch. Let me know if it's not worth the churn
anymore.

>> +		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>> +		ssize_t (*unsent)(struct vsock_sock *vsk);
>> +		struct vsock_sock *vsk = vsock_sk(sk);
>> +
> 
> transport->unsent_bytes can be NULL, this will panic with hyperv or
> vmci transport, especially because we now call this function in
> vsock_shutdown().
> 
> I'd skip that call if transports don't implement it, but please add
> a comment on top of this function about that.

I'm not sure I understand. I am calling it only conditionally, see below.
Nevertheless, I'll add a comment.

>> +		unsent = vsk->transport->unsent_bytes;
>> +		if (!unsent)
>> +			return;
>> +
>> +		add_wait_queue(sk_sleep(sk), &wait);
>> +
>> +		do {
>> +			if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>> +				break;
>> +		} while (!signal_pending(current) && timeout);
>> +
>> +		remove_wait_queue(sk_sleep(sk), &wait);
>> +	}
>> +}

...

>> -	if (sock_flag(sk, SOCK_DONE)) {
>> +	if (sock_flag(sk, SOCK_DONE))
>> 		return true;
>> -	}
> 
> Please avoid this unrelated changes, if you really want to fix them,
> add another patch in the series where to fix them.
> 
>>
>> 	sock_hold(sk);
>> -	INIT_DELAYED_WORK(&vsk->close_work,
>> -			  virtio_transport_close_timeout);
>> +	INIT_DELAYED_WORK(&vsk->close_work, virtio_transport_close_timeout);
> 
> Ditto.
> 
> These 2 could go together in a single `cleanup` patch, although I
> usually avoid it so that `git blame` makes sense. But if we want to
> make checkpatch happy, that's fine.

All right, dropping these. I've thought, since I was touching this function
and this wasn't a bug fix (and wouldn't be backported), it'd be okay to do
some trivial cleanups along the way.

Here's v2:
https://lore.kernel.org/netdev/20250421-vsock-linger-v2-0-fe9febd64668@rbox.co/

Thanks,
Michal

