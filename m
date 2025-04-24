Return-Path: <kvm+bounces-44091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46016A9A4E8
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:53:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6310C923B69
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:53:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175381F4190;
	Thu, 24 Apr 2025 07:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="U31FCzkO"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656541F1518;
	Thu, 24 Apr 2025 07:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745481196; cv=none; b=rFNve9w482lisqnMGeKyhrlXkBJpGN77XveayMVSgaHco+N5cqCxmongIPuSAqjqJ4CSMxRR8vtcpvyaVgdRYkfW/m2qLWGPjaGL+rxwacNauzyk6xxa4dpBZ1hhhjg4XcpxFvmCU5tZQN1g469aOwPizoZ5FinVRaa0aiNiEn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745481196; c=relaxed/simple;
	bh=9mFMZroc5oBoDKj6d/82lLiLqDCPw7MT5bI7GBzcQ1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O6QEuFiNK8U7XGGDUjcYnsn/OeKmPq1AplODmVxQmlrILIlQw3awXabx7f1CvJE6ZLy+2Pb7Rm/r3XEE/IkhT6WoghsAL5CzfMeTyHccMvqrMlcz4+nQxV0ef0ERJu9R3VjbYPT6lxVsDnWn3C8FqGyWrpSwtqTZkbkZipJ3yoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=U31FCzkO; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u7rOJ-007dEz-5P; Thu, 24 Apr 2025 09:53:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=uw9+BDHjFakD/ccZx/zIKGbt3jtgtXmvzKA3XvGg8XI=; b=U31FCzkOUcP1pVuVaU04HwXs5+
	ttE1C+krUyX634t/HHNvoucwfnhBA4nn2snaGxqVL0YqpGX967IdJsLL8OJkhmgEQIZoqjKohEDwd
	0NijhGSwt0NzDeHAz4drrSdwH1aTs9VqQeTSVRJiIm6iIHKN8wsaPrRm2s9S/GlefJtLMxWxvdYe7
	e6Cdth6Fu7MAnIB/lYuUb1X5E2ztOSS/dvOxLBp8/gQhv5TZkPk5/HnZTWee3AWiR3N+qvqoZUZmI
	fV4+Q8ElnTYy4h621zV7V30JDD+8FPhQgu2Bs2gu+dpCQFePScyyAqIvJw/BuiOI+hF+lFov7BmpK
	E2wVqguA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u7rOI-0004x6-4b; Thu, 24 Apr 2025 09:53:02 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u7rO4-002vfC-SB; Thu, 24 Apr 2025 09:52:48 +0200
Message-ID: <5a4f8925-0e4d-4e4c-9230-6c69af179d3e@rbox.co>
Date: Thu, 24 Apr 2025 09:52:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 1/3] vsock: Linger on unsent data
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Luigi Leonardi <leonardi@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
 <20250421-vsock-linger-v2-1-fe9febd64668@rbox.co>
 <km2nad6hkdi3ngtho2xexyhhosh4aq37scir2hgxkcfiwes2wd@5dyliiq7cpuh>
 <k47d2h7dwn26eti2p6nv2fupuybabvbexwinvxv7jnfbn6o3ep@cqtbaqlqyfrq>
 <ee09df9b-9804-49de-b43b-99ccd4cbe742@rbox.co>
 <wnonuiluxgy6ixoioi57lwlixfgcu27kcewv4ajb3k3hihi773@nv3om2t3tsgo>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <wnonuiluxgy6ixoioi57lwlixfgcu27kcewv4ajb3k3hihi773@nv3om2t3tsgo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/24/25 09:28, Stefano Garzarella wrote:
> On Wed, Apr 23, 2025 at 11:06:33PM +0200, Michal Luczaj wrote:
>> On 4/23/25 18:34, Stefano Garzarella wrote:
>>> On Wed, Apr 23, 2025 at 05:53:12PM +0200, Luigi Leonardi wrote:
>>>> Hi Michal,
>>>>
>>>> On Mon, Apr 21, 2025 at 11:50:41PM +0200, Michal Luczaj wrote:
>>>>> Currently vsock's lingering effectively boils down to waiting (or timing
>>>>> out) until packets are consumed or dropped by the peer; be it by receiving
>>>>> the data, closing or shutting down the connection.
>>>>>
>>>>> To align with the semantics described in the SO_LINGER section of man
>>>>> socket(7) and to mimic AF_INET's behaviour more closely, change the logic
>>>>> of a lingering close(): instead of waiting for all data to be handled,
>>>>> block until data is considered sent from the vsock's transport point of
>>>>> view. That is until worker picks the packets for processing and decrements
>>>>> virtio_vsock_sock::bytes_unsent down to 0.
>>>>>
>>>>> Note that such lingering is limited to transports that actually implement
>>>>> vsock_transport::unsent_bytes() callback. This excludes Hyper-V and VMCI,
>>>>> under which no lingering would be observed.
>>>>>
>>>>> The implementation does not adhere strictly to man page's interpretation of
>>>>> SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
>>>>>
>>>>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>>>>> ---
>>>>> net/vmw_vsock/virtio_transport_common.c | 13 +++++++++++--
>>>>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>> index 7f7de6d8809655fe522749fbbc9025df71f071bd..aeb7f3794f7cfc251dde878cb44fdcc54814c89c 100644
>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>> @@ -1196,12 +1196,21 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
>>>>> {
>>>>> 	if (timeout) {
>>>>> 		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>>>>> +		ssize_t (*unsent)(struct vsock_sock *vsk);
>>>>> +		struct vsock_sock *vsk = vsock_sk(sk);
>>>>> +
>>>>> +		/* Some transports (Hyper-V, VMCI) do not implement
>>>>> +		 * unsent_bytes. For those, no lingering on close().
>>>>> +		 */
>>>>> +		unsent = vsk->transport->unsent_bytes;
>>>>> +		if (!unsent)
>>>>> +			return;
>>>>
>>>> IIUC if `unsent_bytes` is not implemented, virtio_transport_wait_close
>>>> basically does nothing. My concern is that we are breaking the
>>>> userspace due to a change in the behavior: Before this patch, with a
>>>> vmci/hyper-v transport, this function would wait for SOCK_DONE to be
>>>> set, but not anymore.
>>>
>>> Wait, we are in virtio_transport_common.c, why we are talking about
>>> Hyper-V and VMCI?
>>>
>>> I asked to check `vsk->transport->unsent_bytes` in the v1, because this
>>> code was part of af_vsock.c, but now we are back to virtio code, so I'm
>>> confused...
>>
>> Might your confusion be because of similar names?
> 
> In v1 this code IIRC was in af_vsock.c, now you pushed back on virtio 
> common code, so I still don't understand how 
> virtio_transport_wait_close() can be called with vmci or hyper-v 
> transports.
> 
> Can you provide an example?

You're right, it was me who was confused. VMCI and Hyper-V have their own
vsock_transport::release callbacks that do not call
virtio_transport_wait_close().

So VMCI and Hyper-V never lingered anyway?

>> vsock_transport::unsent_bytes != virtio_vsock_sock::bytes_unsent
>>
>> I agree with Luigi, it is a breaking change for userspace depending on a
>> non-standard behaviour. What's the protocol here; do it anyway, then see if
>> anyone complains?
>>
>> As for Hyper-V and VMCI losing the "lingering", do we care? And if we do,
>> take Hyper-V, is it possible to test any changes without access to
>> proprietary host/hypervisor?
>>
> 
> Again, how this code can be called when using vmci or hyper-v 
> transports?

It cannot, you're right.

> If we go back on v1 implementation, I can understand it, but with this 
> version I really don't understand the scenario.
> 
> Stefano
> 

