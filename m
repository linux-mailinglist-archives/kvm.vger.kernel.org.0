Return-Path: <kvm+bounces-35291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3782A0B8BE
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 14:52:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF9F418834B0
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 13:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA26723DE82;
	Mon, 13 Jan 2025 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="BQxT0AMO"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846F023497C;
	Mon, 13 Jan 2025 13:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736776346; cv=none; b=ewvBUJ82UbeN/CsA/MopzKiycIArF5MImsD1Pe2CtWNk2oeYqmwZ4Navh7eRavFQLtAK+nRdJyJjUUfWJF5/Sbaa/eX0uRsXQ2gq2wp6+ZX0z2iAlUxu+HmPkSv6aotJ5JrO08rYwgx9+H7NrpUBGrH3WDU5pB4Shxqcmfla/mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736776346; c=relaxed/simple;
	bh=9AbuImX+qUA5xUGc1nAF+CP836w8rcdl4nd/P5mYNKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PWuL7WkCRW9w/UzOnrYFMAfEu9oFTLOAVWl7IGa7O63UzSNd+GVxhbEuCaoFogJT+ZQq3S2s87f5acvVDPoBWn8tJ6A77F+8gcewSJNYqprRMj7ezQfAa1nDP622RaPp9Lwzpv/wGnR12jAo2tH2c5W4Ij39Lb0OE49oIuNEIHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=BQxT0AMO; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tXKrW-00DoP9-NM; Mon, 13 Jan 2025 14:52:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=9/mNvCKWR3TaBBy6qMKu0clHap35DZ0yxeGdHeDIU+A=; b=BQxT0AMOkcYl2agGwxfQIklx5t
	+UVjYUoTV345uqtF1mDnoA69p0ZoilmYpBzkKKvj5/HPPlE+qzxWjSAby3Xqnhv9jDfI9q31yYuub
	kP7OZNP9NKRBx+ttcWU8Je0PyscOrPAl9zEHyz6U3ugP6mJH/F6i/wZL76LatX58KH4UgisKWd0Zx
	1unwFlLzHRRvybI4JRkhmvXxMlUrPXZp0dDFf0kr+uUAR1Bmet8yDRWjN84onV0u6z5Cuvkef56o+
	SF2T033rLm9SL932pDhMzky/K+C32AFv69sYKsCu+v2KNwSAkxOn8l0cf85p/IQvX1Nf3PueYdzTM
	Yt1O7cuQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tXKrV-0004mn-8Z; Mon, 13 Jan 2025 14:52:13 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tXKrI-00EPet-Dj; Mon, 13 Jan 2025 14:52:00 +0100
Message-ID: <903dd624-44e5-4792-8aac-0eaaf1e675c5@rbox.co>
Date: Mon, 13 Jan 2025 14:51:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 1/5] vsock/virtio: discard packets if the transport
 changes
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 Luigi Leonardi <leonardi@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Wongi Lee <qwerty@theori.io>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Eric Dumazet <edumazet@google.com>,
 kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Simon Horman <horms@kernel.org>, Hyunwoo Kim <v4bel@theori.io>,
 Jakub Kicinski <kuba@kernel.org>, virtualization@lists.linux.dev,
 Bobby Eshleman <bobby.eshleman@bytedance.com>, stable@vger.kernel.org
References: <20250110083511.30419-1-sgarzare@redhat.com>
 <20250110083511.30419-2-sgarzare@redhat.com>
 <1aa83abf-6baa-4cf1-a108-66b677bcfd93@rbox.co>
 <nedvcylhjxrkmkvgugsku2lpdjgjpo5exoke4o6clxcxh64s3i@jkjnvngazr5v>
 <CAGxU2F7BoMNi-z=SHsmCV5+99=CxHo4dxFeJnJ5=q9X=CM3QMA@mail.gmail.com>
 <cccb1a4f-5495-4db1-801e-eca211b757c3@rbox.co>
 <nzpj4hc6m4jlqhcwv6ngmozl3hcoxr6kehoia4dps7jytxf6df@iqglusiqrm5n>
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <nzpj4hc6m4jlqhcwv6ngmozl3hcoxr6kehoia4dps7jytxf6df@iqglusiqrm5n>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/13/25 12:05, Stefano Garzarella wrote:
> On Mon, Jan 13, 2025 at 11:12:52AM +0100, Michal Luczaj wrote:
>> On 1/13/25 10:07, Stefano Garzarella wrote:
>>> On Mon, 13 Jan 2025 at 09:57, Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>> On Sun, Jan 12, 2025 at 11:42:30PM +0100, Michal Luczaj wrote:
>>>
>>> [...]
>>>
>>>>>
>>>>> So, if I get this right:
>>>>> 1. vsock_create() (refcnt=1) calls vsock_insert_unbound() (refcnt=2)
>>>>> 2. transport->release() calls vsock_remove_bound() without checking if sk
>>>>>   was bound and moved to bound list (refcnt=1)
>>>>> 3. vsock_bind() assumes sk is in unbound list and before
>>>>>   __vsock_insert_bound(vsock_bound_sockets()) calls
>>>>>   __vsock_remove_bound() which does:
>>>>>      list_del_init(&vsk->bound_table); // nop
>>>>>      sock_put(&vsk->sk);               // refcnt=0
>>>>>
>>>>> The following fixes things for me. I'm just not certain that's the only
>>>>> place where transport destruction may lead to an unbound socket being
>>>>> removed from the unbound list.
>>>>>
>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>> index 7f7de6d88096..0fe807c8c052 100644
>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>> @@ -1303,7 +1303,8 @@ void virtio_transport_release(struct vsock_sock *vsk)
>>>>>
>>>>>       if (remove_sock) {
>>>>>               sock_set_flag(sk, SOCK_DONE);
>>>>> -              virtio_transport_remove_sock(vsk);
>>>>> +              if (vsock_addr_bound(&vsk->local_addr))
>>>>> +                      virtio_transport_remove_sock(vsk);
>>>>
>>>> I don't get this fix, virtio_transport_remove_sock() calls
>>>>    vsock_remove_sock()
>>>>      vsock_remove_bound()
>>>>        if (__vsock_in_bound_table(vsk))
>>>>            __vsock_remove_bound(vsk);
>>>>
>>>>
>>>> So, should already avoid this issue, no?
>>>
>>> I got it wrong, I see now what are you trying to do, but I don't think
>>> we should skip virtio_transport_remove_sock() entirely, it also purge
>>> the rx_queue.
>>
>> Isn't rx_queue empty-by-definition in case of !__vsock_in_bound_table(vsk)?
> 
> It could be.
> 
> But I see some other issues:
> - we need to fix also in the other transports, since they do the same

Ahh, yes, VMCI and Hyper-V would need that, too.

> - we need to check delayed cancel work too that call 
>    virtio_transport_remove_sock()

That's the "I'm just not certain" part. As with rx_queue, I though delayed
cancel can only happen for a bound socket. So, per architecture, no need to
deal with that here, right?

> An alternative approach, which would perhaps allow us to avoid all this, 
> is to re-insert the socket in the unbound list after calling release() 
> when we deassign the transport.
> 
> WDYT?

If we can't keep the old state (sk_state, transport, etc) on failed
re-connect() then reverting back to initial state sounds, uhh, like an
option :) I'm not sure how well this aligns with (user's expectations of)
good ol' socket API, but maybe that train has already left.

Another possibility would be to simply brick the socket on failed (re)connect.


