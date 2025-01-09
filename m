Return-Path: <kvm+bounces-34914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B956A07786
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 14:35:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21EE11603FC
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42DEC218E82;
	Thu,  9 Jan 2025 13:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="dPeu0oXw"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC6F2185B2;
	Thu,  9 Jan 2025 13:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736429686; cv=none; b=FlF5O0RjANvnStjyOzVwjLcodwvgNL1mlGdKjSKg2L1SNoLS5/ZWQF4LkGwL/2dqt2kb30VnRP0RFVUvVAjmotLX0XWzHo31llbXgQuh5wH+QztleO3/Hmi1ETYc7i/pAZYU+DMqgRHtl4yVKu28jwClllGz8autNHj0dC5VWKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736429686; c=relaxed/simple;
	bh=2iOVx27y8FWIvxdxYvHRDO2A/7X5KLbji8GiY5iP4HE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=fQXh8wchHW59YPYeT4cSVgax5W6WoAcPEsqbD4Gm4ufBefawKTpwdR79/y2GZn7C9e8i3tNwYmYQOWiOG1s7XOY0ZAyeLBKqoGKWKxGBZbPy6nVaTJUXwGbDPNTuGWEqsN2bIfm/q7q2csM/qq1/MjGHpvh4NZmTpukC3RXSVEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=dPeu0oXw; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tVsgD-00305I-SD; Thu, 09 Jan 2025 14:34:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID;
	bh=w1/9gczPFPtb52AVap22ovoMq0pU+nsu8ng9Iwts42I=; b=dPeu0oXwrUl7zzbPhKigqr74+4
	vQMAkuk363gZiWpmLVjGFes/MI9NAT5EDa2sXOWXEcH4sjrMQ74AW4hpMn12BloZ2Xu0gBGHgs+yh
	2sjDk/M+IwHonhz+fzexA59U79RrqLjmBYWXWAkF9nqxm6i9yG6gsIuz5u8Fj9nMClfkGfZMD1DeU
	QnHHar22KkbMoyxh4uonqaoTki9ObYh5nRmZn3+0G/lde2IMcQWxflWHApo/dYWoljXwmWtHHybQQ
	gtJBy+uteaBMQ8mkOpjfX2VN40FAJzytCzKEIgkXBuJkQ5XLCmEhKqOqCq9bC9CCkWcUzULb2BNL2
	3qfCyXtA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tVsgC-0004nq-Nj; Thu, 09 Jan 2025 14:34:32 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tVsgA-006cIo-Fi; Thu, 09 Jan 2025 14:34:30 +0100
Message-ID: <2b3062e3-bdaa-4c94-a3c0-2930595b9670@rbox.co>
Date: Thu, 9 Jan 2025 14:34:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH net 1/2] vsock/virtio: discard packets if the transport
 changes
To: Stefano Garzarella <sgarzare@redhat.com>, netdev@vger.kernel.org
Cc: Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>,
 linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Wongi Lee <qwerty@theori.io>,
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 Bobby Eshleman <bobby.eshleman@bytedance.com>,
 virtualization@lists.linux.dev, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Luigi Leonardi <leonardi@redhat.com>,
 bpf@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Hyunwoo Kim <v4bel@theori.io>,
 kvm@vger.kernel.org
References: <20250108180617.154053-1-sgarzare@redhat.com>
 <20250108180617.154053-2-sgarzare@redhat.com>
Content-Language: pl-PL, en-GB
In-Reply-To: <20250108180617.154053-2-sgarzare@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/25 19:06, Stefano Garzarella wrote:
> If the socket has been de-assigned or assigned to another transport,
> we must discard any packets received because they are not expected
> and would cause issues when we access vsk->transport.
> 
> A possible scenario is described by Hyunwoo Kim in the attached link,
> where after a first connect() interrupted by a signal, and a second
> connect() failed, we can find `vsk->transport` at NULL, leading to a
> NULL pointer dereference.
> 
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Reported-by: Hyunwoo Kim <v4bel@theori.io>
> Reported-by: Wongi Lee <qwerty@theori.io>
> Closes: https://lore.kernel.org/netdev/Z2LvdTTQR7dBmPb5@v4bel-B760M-AORUS-ELITE-AX/
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 9acc13ab3f82..51a494b69be8 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -1628,8 +1628,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>  
>  	lock_sock(sk);
>  
> -	/* Check if sk has been closed before lock_sock */
> -	if (sock_flag(sk, SOCK_DONE)) {
> +	/* Check if sk has been closed or assigned to another transport before
> +	 * lock_sock (note: listener sockets are not assigned to any transport)
> +	 */
> +	if (sock_flag(sk, SOCK_DONE) ||
> +	    (sk->sk_state != TCP_LISTEN && vsk->transport != &t->transport)) {
>  		(void)virtio_transport_reset_no_sock(t, skb);
>  		release_sock(sk);
>  		sock_put(sk);

FWIW, I've tried simplifying Hyunwoo's repro to toy with some tests. Ended
up with

```
from threading import *
from socket import *
from signal import *

def listener(tid):
	while True:
		s = socket(AF_VSOCK, SOCK_SEQPACKET)
		s.bind((1, 1234))
		s.listen()
		pthread_kill(tid, SIGUSR1)

signal(SIGUSR1, lambda *args: None)
Thread(target=listener, args=[get_ident()]).start()

while True:
	c = socket(AF_VSOCK, SOCK_SEQPACKET)
	c.connect_ex((1, 1234))
	c.connect_ex((42, 1234))
```

which gives me splats with or without this patch.

That said, when I apply this patch, but drop the `sk->sk_state !=
TCP_LISTEN &&`: no more splats.

