Return-Path: <kvm+bounces-34923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2A9A07842
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 14:55:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F2867A273F
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 13:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B33219A8F;
	Thu,  9 Jan 2025 13:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="SLpARO5/"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4526B218EA8;
	Thu,  9 Jan 2025 13:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736430925; cv=none; b=hzgbs75Fn63SCqfMHRX1NHOuFxnTLd1oeqK7FfhdP3LhqUZIqKnG2eG0ZO7ncSLaGBoq4DRZteBWXAKZJiBVmShXum04b0V1GOK+hpDjpsRUOFjhbnL753Vnyrlk4+Cx1RCOd7UopR7mU7qJBfodH9ABcgR4pTD0dGzc79lZFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736430925; c=relaxed/simple;
	bh=+t6xL6aUUlHqw/1BySaYl0XfaP/8IBcJEMltDRiNodQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TGZG9ZIwSacPYCWy+lgG91gFwcJW9BOIXbMMrExe/fSBxnwUAw3hszbwIXQ0ygWJTi3VULArYTNUMnH9JShhm4VPXMOopUnnKqJku2ELrUF5/e3hij8uPm784pcsf9kw5dkS9dcYViJmVcAfvqyRetpKbFTigkT2EjAG8jJslNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=SLpARO5/; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tVsN6-002xng-0t; Thu, 09 Jan 2025 14:14:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=3cUkymQJSJr9t9+pyatWi8KGoJKjDsSNQ5WB+gYAx38=; b=SLpARO5/+f9xc+MCY3o5+fIY4m
	n/M0P0FembpPsxfv9pfCtkC2FqUGFZiWj+C2EqMgYv3ugkDKr8SL+zMlIODzoulXcQ++9O5c2oT1V
	M8J46X3fy2lezu3dn//tLXmZ+8KUQMfqqp+gRH3IDzN8KgpIdVO3Z1R6R+oswEDviWYo8vEqbifnZ
	iNyPVXpvMdCc4Up545J2klv1IRx54+ot1HzuX20VrN1wbEsS1m9K46NjGeSxoRaXFvhz5cIWDF0xU
	x9dWdU9YdVeXKtw3QnsSemb4NXO3Ulia30lbX2GzC/fwTNMwN9Bm6niVIixwJgEvPJTTHWaJCIRMB
	ZDvo98Ow==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tVsN4-0003CP-FR; Thu, 09 Jan 2025 14:14:46 +0100
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tVsMw-006OkQ-0S; Thu, 09 Jan 2025 14:14:38 +0100
Message-ID: <c0896f6a-d8b8-4db5-804d-0e4b35827a62@rbox.co>
Date: Thu, 9 Jan 2025 14:14:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/2] vsock/bpf: return early if transport is not
 assigned
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
 <20250108180617.154053-3-sgarzare@redhat.com>
From: Michal Luczaj <mhal@rbox.co>
Content-Language: pl-PL, en-GB
In-Reply-To: <20250108180617.154053-3-sgarzare@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/25 19:06, Stefano Garzarella wrote:
> Some of the core functions can only be called if the transport
> has been assigned.
> 
> As Michal reported, a socket might have the transport at NULL,
> for example after a failed connect(), causing the following trace:
> 
>     BUG: kernel NULL pointer dereference, address: 00000000000000a0
>     #PF: supervisor read access in kernel mode
>     #PF: error_code(0x0000) - not-present page
>     PGD 12faf8067 P4D 12faf8067 PUD 113670067 PMD 0
>     Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
>     CPU: 15 UID: 0 PID: 1198 Comm: a.out Not tainted 6.13.0-rc2+
>     RIP: 0010:vsock_connectible_has_data+0x1f/0x40
>     Call Trace:
>      vsock_bpf_recvmsg+0xca/0x5e0
>      sock_recvmsg+0xb9/0xc0
>      __sys_recvfrom+0xb3/0x130
>      __x64_sys_recvfrom+0x20/0x30
>      do_syscall_64+0x93/0x180
>      entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> So we need to check the `vsk->transport` in vsock_bpf_recvmsg(),
> especially for connected sockets (stream/seqpacket) as we already
> do in __vsock_connectible_recvmsg().
> 
> Fixes: 634f1a7110b4 ("vsock: support sockmap")
> Reported-by: Michal Luczaj <mhal@rbox.co>
> Closes: https://lore.kernel.org/netdev/5ca20d4c-1017-49c2-9516-f6f75fd331e9@rbox.co/
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Tested-by: Michal Luczaj <mhal@rbox.co>


> ---
>  net/vmw_vsock/vsock_bpf.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
> index 4aa6e74ec295..f201d9eca1df 100644
> --- a/net/vmw_vsock/vsock_bpf.c
> +++ b/net/vmw_vsock/vsock_bpf.c
> @@ -77,6 +77,7 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  			     size_t len, int flags, int *addr_len)
>  {
>  	struct sk_psock *psock;
> +	struct vsock_sock *vsk;
>  	int copied;
>  
>  	psock = sk_psock_get(sk);
> @@ -84,6 +85,13 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  		return __vsock_recvmsg(sk, msg, len, flags);
>  
>  	lock_sock(sk);
> +	vsk = vsock_sk(sk);
> +
> +	if (!vsk->transport) {
> +		copied = -ENODEV;
> +		goto out;
> +	}
> +
>  	if (vsock_has_data(sk, psock) && sk_psock_queue_empty(psock)) {
>  		release_sock(sk);
>  		sk_psock_put(sk, psock);
> @@ -108,6 +116,7 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  		copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
>  	}
>  
> +out:
>  	release_sock(sk);
>  	sk_psock_put(sk, psock);
>  


