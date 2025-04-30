Return-Path: <kvm+bounces-44887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6581AA48AF
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 12:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 689CB4E529F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 10:37:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C0925A320;
	Wed, 30 Apr 2025 10:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="UtOkDoEh"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199ABEC2;
	Wed, 30 Apr 2025 10:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746009222; cv=none; b=IVJ/d4tjL8qytnUKdhpJoiD+yaAq2V69tavy/wVTqNYP+WQxg9muW8fNuRHEKLSdiDs5o2vZx82jBZXir8l2ht7VWhTKB1tNn13m3fAWUg9jgpMKLPW7IwxgjWjeGeuk6CIw2tFGvcmryLw9wCB7JNzUnr50hAoyYGjxshabWCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746009222; c=relaxed/simple;
	bh=4NWCp9S1XMBq7XqKcv0nEa7YDA1nkdkl4JRgjdSone8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uNM5beLZtlaHG3FgYphPgNUTFJkVTqEweuWqi2aJ5oqIBtSgGgUIxg48S2XzGsPkbW7zp8O+T7O/plp2xgk4SXj6+Va/wXImotZtwMus1HQXXXV0sH/S3kemHFwTBNVqQzG8OYBEkINg7+Bk4K+AYGZ55AcF6CWHalTA6top9ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=UtOkDoEh; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uA4kx-008vds-4h; Wed, 30 Apr 2025 12:33:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=zUZM6N9l2mBWHjRXXpBLPft+3y03NrkhBpUa/Y86ZYw=; b=UtOkDoEhF7Ax7brGpkuhHjSefQ
	Dg5nPd+TwGR4O8fnSMxZ3/zZAosW0517o7NLQ8SGfez1EoIxrweuJnlHL8SXEikgLQNohW2aej+xV
	bz9vaMa7HY5RKhtVyLZ1mSjXxT8Wy/D0YyDHtaORzYTa9phklS1lDT1wGKhCPEA58zNXzslFj7bJh
	R/QOyPKy6EDwLCM1iyDci8IQ1aC4PffJuux4lxWIMSId/qY1+EVCPhKDCj79P2Z6Uwxmt8J2aVPA8
	FSM72nE5UMTwh76tuziwoGzqGb3uVCxN3eftMLsBppcMrXarFNvaHAbal/kJxzcB8BRKG9GV0od15
	W4utw8yA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uA4kw-0004aD-BP; Wed, 30 Apr 2025 12:33:34 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uA4kp-00Cec2-U6; Wed, 30 Apr 2025 12:33:28 +0200
Message-ID: <fa71ef5e-7603-4241-bfd3-7aa7b5ea8945@rbox.co>
Date: Wed, 30 Apr 2025 12:33:26 +0200
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
 <oo5tmbu7okyqojwxt4xked4jvq6jqydrddowspz3p66nsjzajt@36mxuduci4am>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <oo5tmbu7okyqojwxt4xked4jvq6jqydrddowspz3p66nsjzajt@36mxuduci4am>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/30/25 11:36, Stefano Garzarella wrote:
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
> Ah, I'd also move the check in that function, I mean:
> 
> void vsock_linger(struct sock *sk) {
> 	...
> 	if (!sock_flag(sk, SOCK_LINGER) || (current->flags & PF_EXITING))
> 		return;
> 
> 	...
> }

One note: if we ever use vsock_linger() in vsock_shutdown(), the PF_EXITING
condition would be unnecessary checked for that caller, right?

> Or, if we move the call to vsock_linger() in __vsock_release(), we can
> do the check there.
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
>>
>>


