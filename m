Return-Path: <kvm+bounces-44886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F87BAA4871
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 12:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 779521B613E5
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 10:32:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A23248F6F;
	Wed, 30 Apr 2025 10:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="bgR4oOEG"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F2421ADAB;
	Wed, 30 Apr 2025 10:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746009046; cv=none; b=u13RPc55xydu49PSOJMR1fb8l/vUFlx+fDfOHluq4n2HF3ahZ1Fgi17rfKFo77yn3qJAtH+QyMzIHNtHKUxoPaLrdf6xkue9HjUY4SfhvqmXE/ufTDeWChAXvFrcATz+Om2jHlyANgSiQ6r26DukWclXC3svvQNy2u16HZHVDmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746009046; c=relaxed/simple;
	bh=TxM+V5dYOFTWJ0bCfOaqPYVRA3R8pttwwxurIrD9WHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=utysE9ZoohVJZW6zERSg9CJuKYU/HCadWG8JqyeJjS5ALM/d/o7kbZozP6EY4hbmFzaEWVoFbuv3e3zjroUc8vriv7cWmYSR6qfa/XkF6ujAgisYog5OjhgerJwFZ/lbffyym5UUTc14b1s1h5QaaHRSlEC3Ad02lOcfi1c3sGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=bgR4oOEG; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uA4i3-006PLf-S4; Wed, 30 Apr 2025 12:30:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=GnPH0ihymA5hwTrx+YQBYVDBtTayw/0GWDJmjjYsRhY=; b=bgR4oOEGPyjfBo3oU5mZi4AuuY
	ixVaOdfIfYOrtC6bavNB8EcFqrw80TkfbDyGUO28Untbb/TTFbQHPYsJ3/Z4uuXtUiEV+asRJ9wZD
	mGs43nPrMraN6ZoikaXp8Y+8vsB/lJUZMlQ3Aq+LLF4BuQ0qOw0FEKCZO6FsTZyKbqFLblDfJx6Lr
	JzJcmJyLrPg3zK2D7IRYfHDHefs4nupMYP9JmjXY6uXUq/OHJYH52y6KxqIZeM6vOyQL2qNTALXCu
	Qz724cgYDUnHolI4xT4uor9nC5ONvXiybwdaiZecXOT0vTZSDLr5cILMYUuMIzellyN0CM4fVikAE
	STi36WAA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uA4i2-0003Jn-Lh; Wed, 30 Apr 2025 12:30:34 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uA4hi-00Cdcx-1G; Wed, 30 Apr 2025 12:30:14 +0200
Message-ID: <cc2d5c7c-a031-402d-b2d7-fe57fa0bf321@rbox.co>
Date: Wed, 30 Apr 2025 12:30:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 3/4] vsock: Move lingering logic to af_vsock
 core
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
 <20250430-vsock-linger-v3-3-ddbe73b53457@rbox.co>
 <kz3s5mu7bc5kqb22g6voacrinda3wszwhlda7nnwhm5bciweuc@dpsyq2yfrs7f>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <kz3s5mu7bc5kqb22g6voacrinda3wszwhlda7nnwhm5bciweuc@dpsyq2yfrs7f>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/30/25 11:33, Stefano Garzarella wrote:
> On Wed, Apr 30, 2025 at 11:10:29AM +0200, Michal Luczaj wrote:
>> Lingering should be transport-independent in the long run. In preparation
>> for supporting other transports, as well the linger on shutdown(), move
>> code to core.
>>
>> Guard against an unimplemented vsock_transport::unsent_bytes() callback.
>>
>> Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>> ---
>> include/net/af_vsock.h                  |  1 +
>> net/vmw_vsock/af_vsock.c                | 25 +++++++++++++++++++++++++
>> net/vmw_vsock/virtio_transport_common.c | 23 +----------------------
>> 3 files changed, 27 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> index 9e85424c834353d016a527070dd62e15ff3bfce1..bd8b88d70423051dd05fc445fe37971af631ba03 100644
>> --- a/include/net/af_vsock.h
>> +++ b/include/net/af_vsock.h
>> @@ -221,6 +221,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
>> 				     void (*fn)(struct sock *sk));
>> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
>> bool vsock_find_cid(unsigned int cid);
>> +void vsock_linger(struct sock *sk, long timeout);
>>
>> /**** TAP ****/
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..946b37de679a0e68b84cd982a3af2a959c60ee57 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -1013,6 +1013,31 @@ static int vsock_getname(struct socket *sock,
>> 	return err;
>> }
>>
>> +void vsock_linger(struct sock *sk, long timeout)
>> +{
>> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>> +	ssize_t (*unsent)(struct vsock_sock *vsk);
>> +	struct vsock_sock *vsk = vsock_sk(sk);
>> +
>> +	if (!timeout)
>> +		return;
>> +
>> +	/* unsent_bytes() may be unimplemented. */
>> +	unsent = vsk->transport->unsent_bytes;
>> +	if (!unsent)
>> +		return;
>> +
>> +	add_wait_queue(sk_sleep(sk), &wait);
>> +
>> +	do {
>> +		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>> +			break;
>> +	} while (!signal_pending(current) && timeout);
>> +
>> +	remove_wait_queue(sk_sleep(sk), &wait);
>> +}
>> +EXPORT_SYMBOL_GPL(vsock_linger);
>> +
>> static int vsock_shutdown(struct socket *sock, int mode)
>> {
>> 	int err;
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 4425802c5d718f65aaea425ea35886ad64e2fe6e..9230b8358ef2ac1f6e72a5961bae39f9093c8884 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -1192,27 +1192,6 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
>> 	vsock_remove_sock(vsk);
>> }
>>
>> -static void virtio_transport_wait_close(struct sock *sk, long timeout)
>> -{
>> -	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>> -	ssize_t (*unsent)(struct vsock_sock *vsk);
>> -	struct vsock_sock *vsk = vsock_sk(sk);
>> -
>> -	if (!timeout)
>> -		return;
>> -
>> -	unsent = vsk->transport->unsent_bytes;
>> -
>> -	add_wait_queue(sk_sleep(sk), &wait);
>> -
>> -	do {
>> -		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>> -			break;
>> -	} while (!signal_pending(current) && timeout);
>> -
>> -	remove_wait_queue(sk_sleep(sk), &wait);
>> -}
>> -
>> static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
>> 					       bool cancel_timeout)
>> {
>> @@ -1283,7 +1262,7 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
>> 		(void)virtio_transport_shutdown(vsk, SHUTDOWN_MASK);
>>
>> 	if (sock_flag(sk, SOCK_LINGER) && !(current->flags & PF_EXITING))
>> -		virtio_transport_wait_close(sk, sk->sk_lingertime);
>> +		vsock_linger(sk, sk->sk_lingertime);
> 
> What about removing the `sk->sk_lingertime` parameter here?
> vsock_linger() can get it from sk.

Certainly. I assume this does not need a separate patch and can be done
while moving (and de-indenting) the code?

> BTW, the change LGTM, would be great to call vsock_linger() directly in 
> __vsock_release(), but we can do it later.
> 
> Thanks,
> Stefano
> 
>>
>> 	if (sock_flag(sk, SOCK_DONE)) {
>> 		return true;
>>
>> -- 
>> 2.49.0

