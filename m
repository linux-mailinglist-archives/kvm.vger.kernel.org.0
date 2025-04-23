Return-Path: <kvm+bounces-44016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 751BCA999E7
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 23:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 105F31798C7
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 21:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB2D1F237A;
	Wed, 23 Apr 2025 21:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="GNOR0nNI"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653FC82D98;
	Wed, 23 Apr 2025 21:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745442422; cv=none; b=cFuEQtoOBiT2woL83zhTJrJLaNPBieH7r3QHlB+3bk2HBpEH3Z+A97qimilHRgjFCV2g3Vg1kHHXJggNjAqLcSk+6v1e9+cSoCivhBoOqdWQUtKS7qTHYxzuedRm2/Qr0jsH5Osb9PJ505t8g0j/56mDYKDZbEPHdvaQdn3ofl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745442422; c=relaxed/simple;
	bh=zjf+eXgupeic2NaH/eGimc8iMxf81f1qq6U1j6+oTT8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=TsDpEHzJmTI8YtmLHxiY7z1bYaXKugXj2yc5HWthfvMUoY9PzJNgbw1WtVSDcMPrBtFjA1cuDXz5mQpzHj3v2aj6KmGY8Y3ZTo+Pw6DM2E9HCO/sNNVfpzsFpJAoyikjahRQwD5hQRg22L2xeR6kAk6b0nQ+CEANu1+JsJB+2QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=GNOR0nNI; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u7hIm-007XIA-I3; Wed, 23 Apr 2025 23:06:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
	Cc:To:Subject:From:MIME-Version:Date:Message-ID;
	bh=phjtsSuA7wXOgFfhHsYA1FEf7UdFgY655or67qmY9Pc=; b=GNOR0nNIQ2FiqFC/eDoT+vExNp
	FsA5Grmx2TCUGJL8W5swIWk3n+rQcFlHyUj+jRkGnPvFlG8SRGUrVWDH7hhmQoSawrRMQUd072214
	3zXaGoAQLjhFwQPl2Yi09ZjgWRFJ8F3N/FiCeudMXnL8j2xg0ryh0ygxH1BFtXAzLXq33hfAZwvC/
	Jy6uEwHGYXzHSFZEmeeu2cCjqofuDA/9x755HtfqjaePb8ROXUuNfbf1rvgZUj/3QMJ16cE8sHx//
	yi5jSHeB9GKveUUATGbvSqrrR+aQnPNiXQ1SIYx6NxBXLZcSS5Af3YMFa6GzVbQhyBu4srwIV9b2y
	HG/ZA6CQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u7hIl-0006FL-Eq; Wed, 23 Apr 2025 23:06:39 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u7hIh-000BZQ-4r; Wed, 23 Apr 2025 23:06:35 +0200
Message-ID: <ee09df9b-9804-49de-b43b-99ccd4cbe742@rbox.co>
Date: Wed, 23 Apr 2025 23:06:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH net-next v2 1/3] vsock: Linger on unsent data
To: Stefano Garzarella <sgarzare@redhat.com>,
 Luigi Leonardi <leonardi@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
 <20250421-vsock-linger-v2-1-fe9febd64668@rbox.co>
 <km2nad6hkdi3ngtho2xexyhhosh4aq37scir2hgxkcfiwes2wd@5dyliiq7cpuh>
 <k47d2h7dwn26eti2p6nv2fupuybabvbexwinvxv7jnfbn6o3ep@cqtbaqlqyfrq>
Content-Language: pl-PL, en-GB
In-Reply-To: <k47d2h7dwn26eti2p6nv2fupuybabvbexwinvxv7jnfbn6o3ep@cqtbaqlqyfrq>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/23/25 18:34, Stefano Garzarella wrote:
> On Wed, Apr 23, 2025 at 05:53:12PM +0200, Luigi Leonardi wrote:
>> Hi Michal,
>>
>> On Mon, Apr 21, 2025 at 11:50:41PM +0200, Michal Luczaj wrote:
>>> Currently vsock's lingering effectively boils down to waiting (or timing
>>> out) until packets are consumed or dropped by the peer; be it by receiving
>>> the data, closing or shutting down the connection.
>>>
>>> To align with the semantics described in the SO_LINGER section of man
>>> socket(7) and to mimic AF_INET's behaviour more closely, change the logic
>>> of a lingering close(): instead of waiting for all data to be handled,
>>> block until data is considered sent from the vsock's transport point of
>>> view. That is until worker picks the packets for processing and decrements
>>> virtio_vsock_sock::bytes_unsent down to 0.
>>>
>>> Note that such lingering is limited to transports that actually implement
>>> vsock_transport::unsent_bytes() callback. This excludes Hyper-V and VMCI,
>>> under which no lingering would be observed.
>>>
>>> The implementation does not adhere strictly to man page's interpretation of
>>> SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
>>>
>>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>>> ---
>>> net/vmw_vsock/virtio_transport_common.c | 13 +++++++++++--
>>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index 7f7de6d8809655fe522749fbbc9025df71f071bd..aeb7f3794f7cfc251dde878cb44fdcc54814c89c 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -1196,12 +1196,21 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
>>> {
>>> 	if (timeout) {
>>> 		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>>> +		ssize_t (*unsent)(struct vsock_sock *vsk);
>>> +		struct vsock_sock *vsk = vsock_sk(sk);
>>> +
>>> +		/* Some transports (Hyper-V, VMCI) do not implement
>>> +		 * unsent_bytes. For those, no lingering on close().
>>> +		 */
>>> +		unsent = vsk->transport->unsent_bytes;
>>> +		if (!unsent)
>>> +			return;
>>
>> IIUC if `unsent_bytes` is not implemented, virtio_transport_wait_close 
>> basically does nothing. My concern is that we are breaking the 
>> userspace due to a change in the behavior: Before this patch, with a 
>> vmci/hyper-v transport, this function would wait for SOCK_DONE to be 
>> set, but not anymore.
> 
> Wait, we are in virtio_transport_common.c, why we are talking about 
> Hyper-V and VMCI?
> 
> I asked to check `vsk->transport->unsent_bytes` in the v1, because this 
> code was part of af_vsock.c, but now we are back to virtio code, so I'm 
> confused...

Might your confusion be because of similar names?
vsock_transport::unsent_bytes != virtio_vsock_sock::bytes_unsent

I agree with Luigi, it is a breaking change for userspace depending on a
non-standard behaviour. What's the protocol here; do it anyway, then see if
anyone complains?

As for Hyper-V and VMCI losing the "lingering", do we care? And if we do,
take Hyper-V, is it possible to test any changes without access to
proprietary host/hypervisor?

