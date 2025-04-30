Return-Path: <kvm+bounces-44891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D84DFAA4991
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 13:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 603617A921F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B86524C099;
	Wed, 30 Apr 2025 11:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="AOwFG/L1"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542A5189BAC;
	Wed, 30 Apr 2025 11:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746011532; cv=none; b=KVRFjDy9DAW3JwzbZoMnY7sBAZ0Z1NIwSA/3PPdjFQ8oDezyl9ZcqslSeskfzEu2usglQPQ9tkenrawUyPPo0mcdoL7HIyIhMcPBLzolrIn9bMNaMbGokOfHvEFvqIAjrCUUNaEX1/sFnQ37/4PqOZgaInNRIj3ieou1QOqAgbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746011532; c=relaxed/simple;
	bh=OT0IiRoi8vRRVlKujREKg/KIF7uTyePc9jasTPN2g+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ro+2+6PvyMaYGx8AKONrGwHq22/pE6ea66B2otc3XZf5L1gB9phfSFiFdX3SjKsvG+x9cxUYwbI6278MNbZ62wYg6dKB1w1Htk9ijt5RDBLYev9oTX1KHZ03HAsc5mSF+Qvo1QMHCTYtnRcXij1ih8n8fB1B3HunVlY2OEgfhc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=AOwFG/L1; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uA5M8-006UX6-0C; Wed, 30 Apr 2025 13:12:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=XB7MNWZvjvw2hD4pCHc8vraylIasO9NgE5mAXAKsQ9E=; b=AOwFG/L1kAMDKat2X75H20AQXQ
	8Vsnlt3uFMYbGWKSt5LcR5pyPxOK2TIRVaeU9pY74jPSxe1P5QcyORlKM9ic5PsdNUMprHrQWRuhp
	GP4bQ7BbJGUUcQWujuSVmW/ARENmypDzq/1411qI62WWA2zV+i4Bub7fu5dAYCeJ1dd8otvAW+/La
	ktWjupxMd3VCIVff2SOAYbh6UVNMvnR0sXFyz4mwOTj+Z//OB18nRiM1Wjg6fy8dUqEkIbOcbrPzm
	dB72O0+1pjUxqrEDf70tMBKbQanSbtiYXcBWMsyLla5efTrogC0xm8/et6jy6TAf/OMovwHESv5+5
	Uux13GQA==;
Received: from [10.9.9.74] (helo=submission03.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uA5M6-0006lV-Fl; Wed, 30 Apr 2025 13:11:58 +0200
Received: by submission03.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uA5Lx-000xlG-Ui; Wed, 30 Apr 2025 13:11:50 +0200
Message-ID: <f1943412-ccbf-4913-a5c5-818f0f586db1@rbox.co>
Date: Wed, 30 Apr 2025 13:11:48 +0200
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
 <fa71ef5e-7603-4241-bfd3-7aa7b5ea8945@rbox.co>
 <CAGxU2F62CTUKVjuG9Fjo29E6uopVzOK8zgr+HwooqMr4V_RvLQ@mail.gmail.com>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <CAGxU2F62CTUKVjuG9Fjo29E6uopVzOK8zgr+HwooqMr4V_RvLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/30/25 12:37, Stefano Garzarella wrote:
> On Wed, 30 Apr 2025 at 12:33, Michal Luczaj <mhal@rbox.co> wrote:
>>
>> On 4/30/25 11:36, Stefano Garzarella wrote:
>>> On Wed, Apr 30, 2025 at 11:10:29AM +0200, Michal Luczaj wrote:
>>>> Lingering should be transport-independent in the long run. In preparation
>>>> for supporting other transports, as well the linger on shutdown(), move
>>>> code to core.
>>>>
>>>> Guard against an unimplemented vsock_transport::unsent_bytes() callback.
>>>>
>>>> Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>>>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>>>> ---
>>>> include/net/af_vsock.h                  |  1 +
>>>> net/vmw_vsock/af_vsock.c                | 25 +++++++++++++++++++++++++
>>>> net/vmw_vsock/virtio_transport_common.c | 23 +----------------------
>>>> 3 files changed, 27 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>>> index 9e85424c834353d016a527070dd62e15ff3bfce1..bd8b88d70423051dd05fc445fe37971af631ba03 100644
>>>> --- a/include/net/af_vsock.h
>>>> +++ b/include/net/af_vsock.h
>>>> @@ -221,6 +221,7 @@ void vsock_for_each_connected_socket(struct vsock_transport *transport,
>>>>                                   void (*fn)(struct sock *sk));
>>>> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
>>>> bool vsock_find_cid(unsigned int cid);
>>>> +void vsock_linger(struct sock *sk, long timeout);
>>>>
>>>> /**** TAP ****/
>>>>
>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>> index fc6afbc8d6806a4d98c66abc3af4bd139c583b08..946b37de679a0e68b84cd982a3af2a959c60ee57 100644
>>>> --- a/net/vmw_vsock/af_vsock.c
>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>> @@ -1013,6 +1013,31 @@ static int vsock_getname(struct socket *sock,
>>>>      return err;
>>>> }
>>>>
>>>> +void vsock_linger(struct sock *sk, long timeout)
>>>> +{
>>>> +    DEFINE_WAIT_FUNC(wait, woken_wake_function);
>>>> +    ssize_t (*unsent)(struct vsock_sock *vsk);
>>>> +    struct vsock_sock *vsk = vsock_sk(sk);
>>>> +
>>>> +    if (!timeout)
>>>> +            return;
>>>> +
>>>> +    /* unsent_bytes() may be unimplemented. */
>>>> +    unsent = vsk->transport->unsent_bytes;
>>>> +    if (!unsent)
>>>> +            return;
>>>> +
>>>> +    add_wait_queue(sk_sleep(sk), &wait);
>>>> +
>>>> +    do {
>>>> +            if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>>>> +                    break;
>>>> +    } while (!signal_pending(current) && timeout);
>>>> +
>>>> +    remove_wait_queue(sk_sleep(sk), &wait);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(vsock_linger);
>>>> +
>>>> static int vsock_shutdown(struct socket *sock, int mode)
>>>> {
>>>>      int err;
>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>> index 4425802c5d718f65aaea425ea35886ad64e2fe6e..9230b8358ef2ac1f6e72a5961bae39f9093c8884 100644
>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>> @@ -1192,27 +1192,6 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
>>>>      vsock_remove_sock(vsk);
>>>> }
>>>>
>>>> -static void virtio_transport_wait_close(struct sock *sk, long timeout)
>>>> -{
>>>> -    DEFINE_WAIT_FUNC(wait, woken_wake_function);
>>>> -    ssize_t (*unsent)(struct vsock_sock *vsk);
>>>> -    struct vsock_sock *vsk = vsock_sk(sk);
>>>> -
>>>> -    if (!timeout)
>>>> -            return;
>>>> -
>>>> -    unsent = vsk->transport->unsent_bytes;
>>>> -
>>>> -    add_wait_queue(sk_sleep(sk), &wait);
>>>> -
>>>> -    do {
>>>> -            if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
>>>> -                    break;
>>>> -    } while (!signal_pending(current) && timeout);
>>>> -
>>>> -    remove_wait_queue(sk_sleep(sk), &wait);
>>>> -}
>>>> -
>>>> static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
>>>>                                             bool cancel_timeout)
>>>> {
>>>> @@ -1283,7 +1262,7 @@ static bool virtio_transport_close(struct vsock_sock *vsk)
>>>>              (void)virtio_transport_shutdown(vsk, SHUTDOWN_MASK);
>>>>
>>>>      if (sock_flag(sk, SOCK_LINGER) && !(current->flags & PF_EXITING))
>>>> -            virtio_transport_wait_close(sk, sk->sk_lingertime);
>>>> +            vsock_linger(sk, sk->sk_lingertime);
>>>
>>> Ah, I'd also move the check in that function, I mean:
>>>
>>> void vsock_linger(struct sock *sk) {
>>>       ...
>>>       if (!sock_flag(sk, SOCK_LINGER) || (current->flags & PF_EXITING))
>>>               return;
>>>
>>>       ...
>>> }
>>
>> One note: if we ever use vsock_linger() in vsock_shutdown(), the PF_EXITING
>> condition would be unnecessary checked for that caller, right?
> 
> Right, for shutdown it should always be false, so maybe better to keep
> the check in the caller.

Or split it? Check `!sock_flag(sk, SOCK_LINGER) || !timeout` in
vsock_linger() and defer `!(flags & PF_EXITING)` to whoever does the socket
release?


