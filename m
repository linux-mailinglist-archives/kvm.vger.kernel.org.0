Return-Path: <kvm+bounces-44122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D2272A9ABA8
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 13:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD7D918958BA
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 11:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5C89224AE4;
	Thu, 24 Apr 2025 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="MBgYNqNU"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13342701B1;
	Thu, 24 Apr 2025 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745493919; cv=none; b=keJvIdU4fEC0BtUoP8L/udZnhCH+MOtadUtqhXC/F4/z5Nh23db8p9b2GdIxVhwgBY3XUs3lHQse/Wm57SxObqKPShPK5yq8dxZkVyyyiC6wFjtEbRGs5NmYEPd/5k/07KPn6hw6oB9v+wwDjWxmdWLOAJqhVpTxuhKhIQrY2sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745493919; c=relaxed/simple;
	bh=W6tJpgnftyybvOmgb91AxxJLH5thveT4lxoF8PvYsBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ksNIWGrZW2jlk6GzyLTTA6aLBGneqbbVTV/R56qgKND7XJ+zlRhTwutnTL1ChgZJMAuRUUF5v7z4csSA1e8dczCaBxzOcTQuabCTMc6tmiPQSmIEU2bgmLuJxZiMeZUvyrQr/KduX/jsT4xqpdFFTKeYkhw297kd410pRa29xq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=MBgYNqNU; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1u7uhV-0085bP-6Z; Thu, 24 Apr 2025 13:25:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=JZApLhOYYL7Gqypq3hjscSfsYIt3RrbmRWc33u1K0sM=; b=MBgYNqNU8d5LkneO5n1eRve+2j
	0MyfUPk7oUhulA17+g9hJlICQl5cM3Ssy2rXQOj+dsBKFkUT0Ia/Q1a3Y7FTAjwQ5rWajb43VkFZe
	HnGNDotLiq6yd4B3k945gHHumhhKnco6TlpHOnD/o9Jk1mwn/gxFQQXKJ+fkQoIvCqUlGm2ZS2afk
	+pKKNDqXh/Zt7hUwbVkl6qXQItx/bM99j5iUcfXLsh2tFfbpYaecdF2w0mry/ftAl8O5DUrWanXQ8
	av+AEUYYE4Oe/drgfFqY901lk7pUp0Mv+W7sSlVCXirbIJb2AjgiFE4Ok1D+1YwUxdH/bdUZsA3gX
	tGpDJItQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1u7uhT-00051C-If; Thu, 24 Apr 2025 13:25:03 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1u7uhR-003pnq-DJ; Thu, 24 Apr 2025 13:25:01 +0200
Message-ID: <81940d67-1a9b-42e1-8594-33af86397df6@rbox.co>
Date: Thu, 24 Apr 2025 13:24:59 +0200
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
 <5a4f8925-0e4d-4e4c-9230-6c69af179d3e@rbox.co>
 <CAGxU2F6YSwrpV4wXH=mWSgK698sjxfQ=zzXS8tVmo3D84-bBqw@mail.gmail.com>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <CAGxU2F6YSwrpV4wXH=mWSgK698sjxfQ=zzXS8tVmo3D84-bBqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/24/25 10:36, Stefano Garzarella wrote:
> On Thu, 24 Apr 2025 at 09:53, Michal Luczaj <mhal@rbox.co> wrote:
>>
>> On 4/24/25 09:28, Stefano Garzarella wrote:
>>> On Wed, Apr 23, 2025 at 11:06:33PM +0200, Michal Luczaj wrote:
>>>> On 4/23/25 18:34, Stefano Garzarella wrote:
>>>>> On Wed, Apr 23, 2025 at 05:53:12PM +0200, Luigi Leonardi wrote:
>>>>>> Hi Michal,
>>>>>>
>>>>>> On Mon, Apr 21, 2025 at 11:50:41PM +0200, Michal Luczaj wrote:
>>>>>>> Currently vsock's lingering effectively boils down to waiting (or timing
>>>>>>> out) until packets are consumed or dropped by the peer; be it by receiving
>>>>>>> the data, closing or shutting down the connection.
>>>>>>>
>>>>>>> To align with the semantics described in the SO_LINGER section of man
>>>>>>> socket(7) and to mimic AF_INET's behaviour more closely, change the logic
>>>>>>> of a lingering close(): instead of waiting for all data to be handled,
>>>>>>> block until data is considered sent from the vsock's transport point of
>>>>>>> view. That is until worker picks the packets for processing and decrements
>>>>>>> virtio_vsock_sock::bytes_unsent down to 0.
>>>>>>>
>>>>>>> Note that such lingering is limited to transports that actually implement
>>>>>>> vsock_transport::unsent_bytes() callback. This excludes Hyper-V and VMCI,
>>>>>>> under which no lingering would be observed.
>>>>>>>
>>>>>>> The implementation does not adhere strictly to man page's interpretation of
>>>>>>> SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
>>>>>>>
>>>>>>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
>>>>>>> ---
>>>>>>> net/vmw_vsock/virtio_transport_common.c | 13 +++++++++++--
>>>>>>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>>>> index 7f7de6d8809655fe522749fbbc9025df71f071bd..aeb7f3794f7cfc251dde878cb44fdcc54814c89c 100644
>>>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>>>> @@ -1196,12 +1196,21 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
>>>>>>> {
>>>>>>>   if (timeout) {
>>>>>>>           DEFINE_WAIT_FUNC(wait, woken_wake_function);
>>>>>>> +         ssize_t (*unsent)(struct vsock_sock *vsk);
>>>>>>> +         struct vsock_sock *vsk = vsock_sk(sk);
>>>>>>> +
>>>>>>> +         /* Some transports (Hyper-V, VMCI) do not implement
>>>>>>> +          * unsent_bytes. For those, no lingering on close().
>>>>>>> +          */
>>>>>>> +         unsent = vsk->transport->unsent_bytes;
>>>>>>> +         if (!unsent)
>>>>>>> +                 return;
>>>>>>
>>>>>> IIUC if `unsent_bytes` is not implemented, virtio_transport_wait_close
>>>>>> basically does nothing. My concern is that we are breaking the
>>>>>> userspace due to a change in the behavior: Before this patch, with a
>>>>>> vmci/hyper-v transport, this function would wait for SOCK_DONE to be
>>>>>> set, but not anymore.
>>>>>
>>>>> Wait, we are in virtio_transport_common.c, why we are talking about
>>>>> Hyper-V and VMCI?
>>>>>
>>>>> I asked to check `vsk->transport->unsent_bytes` in the v1, because this
>>>>> code was part of af_vsock.c, but now we are back to virtio code, so I'm
>>>>> confused...
>>>>
>>>> Might your confusion be because of similar names?
>>>
>>> In v1 this code IIRC was in af_vsock.c, now you pushed back on virtio
>>> common code, so I still don't understand how
>>> virtio_transport_wait_close() can be called with vmci or hyper-v
>>> transports.
>>>
>>> Can you provide an example?
>>
>> You're right, it was me who was confused. VMCI and Hyper-V have their own
>> vsock_transport::release callbacks that do not call
>> virtio_transport_wait_close().
>>
>> So VMCI and Hyper-V never lingered anyway?
> 
> I think so.
> 
> Indeed I was happy with v1, since I think this should be supported by
> the vsock core and should not depend on the transport.
> But we can do also later.

OK, for now let me fix this nonsense in comment and commit message.

But I'll wait for your opinion on [1] (drop, squash, change order of
patches?) before posting v3.

[1]:
https://lore.kernel.org/netdev/20250421-vsock-linger-v2-2-fe9febd64668@rbox.co/

Thanks,
Michal


