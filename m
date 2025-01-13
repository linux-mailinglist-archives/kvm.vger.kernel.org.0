Return-Path: <kvm+bounces-35280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCF8A0B444
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 11:13:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D44453A37E2
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FFA21ADC3;
	Mon, 13 Jan 2025 10:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="ja5p8TTx"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BE8235C07;
	Mon, 13 Jan 2025 10:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736763208; cv=none; b=GS+qstBP/T2w2GuwF25eVQuXmLyGGj5IqI5p1SjrxJ/hRTvQoPOm+wSOzDiam+CPOzrzEvae8brlq32OoWgWeXYbKMbmr9GniP4H4hAa+p/NNmF1VAreOz9j88qlohGsxmIaX1fc2IwesznwHakFSDSbxM0VwDkgj1fhafFoXXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736763208; c=relaxed/simple;
	bh=AbEypxldcB557r7ML3RWblxFpClAAQjKh+mk6I/n4hI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wlg15qLr+UOUOqCIm8CG13U/8Jaag9WN5yqCIk4WbpxkgYt3hcwXnd0nH88mya5YJ0rwPZkkJPRjv6hMZb1NHj0mVfX+aZWm+MoKjjECR+tzlO++Cmc3CSSeQUejxJYG9B4Dzr9DtCMdkFMo+XHlzaLzB3t/qvQ0Uo23/9dYYqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=ja5p8TTx; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1tXHRa-00DhCO-Tc; Mon, 13 Jan 2025 11:13:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID;
	bh=XmtGPnPvH6It0GR990T2qwUAKTVPIjKO4lymK4SpZf0=; b=ja5p8TTx11VmfSU8AkwM9xXOmC
	R0HlPnuhaO1aaA7LAjGwUBgO0aROIcDCW4554r3UreeZMe+JNAeN6PwYZdoPIeZ/a9Ltr0v6pqZk1
	pfgzT/3Cx6JtLcVuSP1PyMhcWVrhxendX5WNGukCBli1xObGZmO3AYDtBF4RaWeQH0hyrsaoDmXM5
	ctWBMBsU6CeUXHU/QRGCyegPn52elUhgWOvbCK3wwso/sAASLSTVO/V6u2dsF0xAxNy4nqza65VKJ
	o6G7pBxsDYS7UQt2L858VXvhHpMHcEgoILEFvv0/wl/CqRDS2y5sJxMQgal2aQkRXYRIjmhDq40nM
	mI39Dq5Q==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1tXHRZ-00030N-L5; Mon, 13 Jan 2025 11:13:13 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1tXHRG-00DToB-7D; Mon, 13 Jan 2025 11:12:54 +0100
Message-ID: <cccb1a4f-5495-4db1-801e-eca211b757c3@rbox.co>
Date: Mon, 13 Jan 2025 11:12:52 +0100
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
Content-Language: pl-PL, en-GB
From: Michal Luczaj <mhal@rbox.co>
In-Reply-To: <CAGxU2F7BoMNi-z=SHsmCV5+99=CxHo4dxFeJnJ5=q9X=CM3QMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/13/25 10:07, Stefano Garzarella wrote:
> On Mon, 13 Jan 2025 at 09:57, Stefano Garzarella <sgarzare@redhat.com> wrote:
>> On Sun, Jan 12, 2025 at 11:42:30PM +0100, Michal Luczaj wrote:
> 
> [...]
> 
>>>
>>> So, if I get this right:
>>> 1. vsock_create() (refcnt=1) calls vsock_insert_unbound() (refcnt=2)
>>> 2. transport->release() calls vsock_remove_bound() without checking if sk
>>>   was bound and moved to bound list (refcnt=1)
>>> 3. vsock_bind() assumes sk is in unbound list and before
>>>   __vsock_insert_bound(vsock_bound_sockets()) calls
>>>   __vsock_remove_bound() which does:
>>>      list_del_init(&vsk->bound_table); // nop
>>>      sock_put(&vsk->sk);               // refcnt=0
>>>
>>> The following fixes things for me. I'm just not certain that's the only
>>> place where transport destruction may lead to an unbound socket being
>>> removed from the unbound list.
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index 7f7de6d88096..0fe807c8c052 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -1303,7 +1303,8 @@ void virtio_transport_release(struct vsock_sock *vsk)
>>>
>>>       if (remove_sock) {
>>>               sock_set_flag(sk, SOCK_DONE);
>>> -              virtio_transport_remove_sock(vsk);
>>> +              if (vsock_addr_bound(&vsk->local_addr))
>>> +                      virtio_transport_remove_sock(vsk);
>>
>> I don't get this fix, virtio_transport_remove_sock() calls
>>    vsock_remove_sock()
>>      vsock_remove_bound()
>>        if (__vsock_in_bound_table(vsk))
>>            __vsock_remove_bound(vsk);
>>
>>
>> So, should already avoid this issue, no?
> 
> I got it wrong, I see now what are you trying to do, but I don't think
> we should skip virtio_transport_remove_sock() entirely, it also purge
> the rx_queue.

Isn't rx_queue empty-by-definition in case of !__vsock_in_bound_table(vsk)?

>> Can the problem be in vsock_bind() ?

Well, I wouldn't say so.

>> Is this issue pre-existing or introduced by this series?
> 
> I think this is pre-existing, can you confirm?

Yup, I agree, pre-existing.

> In that case, I'd not stop this series, and fix it in another patch/series.

Yeah, sure thing.

Thanks,
Michal


