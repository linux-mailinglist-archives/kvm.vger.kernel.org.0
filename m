Return-Path: <kvm+bounces-35286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 321F4A0B50D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 12:05:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CABF73A8CA6
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 11:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E6422AE65;
	Mon, 13 Jan 2025 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RPDvVvHC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B1F1BE871
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 11:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736766320; cv=none; b=tdQCSELiT1fT3shZN5x9x7MDUZnUEVlLonRTbuXC6d2YzQm6qD/UqBg5rtSaz+K7GVeZ8tdmYaBXpLcScsUVW97kBMne+3F9cEBxT20DGsfNrMC1K/s+ZHBqkHDkSjnM3j9Y6Mh/s8UMTBteK8x3gYDyGt29yfxo/Ru3vYLZo8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736766320; c=relaxed/simple;
	bh=Y/DjbpXTli+q6qXYniP9mDlDlQz3GWNZg2gJsGHgxs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgKTvpBc0gDqdnmTjGS/bd0N6c22AQdGdW6PAF5nyKo5E0gCsfuf6o1EvxvlIHTHvx++vDQws0O0rpFD4nKneuTHYHceBgA6BjbARtJPOg0BsdD/uPTAFgLJnrQbv60tvamlHKcF/RnPm1JM82tgccbIvG5Dkk8x9XOC2g6UpYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RPDvVvHC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736766317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nBhouD3nO1E5V4MavagLJ4BxPXoXO2uHY25LrPgF6oo=;
	b=RPDvVvHCFfGuVUHL6i8nFbQBjvjfQlh4zFobTwCtNxuHoihr6VyOX5jK/sVqNlqJKUntbe
	GG/kS1l/I6e5n9HSMEJDvCvx7sLCsYTTW29AH4shRFNZ0r3B/aW2JCC3x5VqV1B3y/OfqH
	60wwIGbY0SD694X47oz3yydJrjrUP/o=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-qHYkqL0ENN6lPls0cva5Cg-1; Mon, 13 Jan 2025 06:05:15 -0500
X-MC-Unique: qHYkqL0ENN6lPls0cva5Cg-1
X-Mimecast-MFC-AGG-ID: qHYkqL0ENN6lPls0cva5Cg
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7b6c51069f5so697947385a.3
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 03:05:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736766315; x=1737371115;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nBhouD3nO1E5V4MavagLJ4BxPXoXO2uHY25LrPgF6oo=;
        b=SP/ccSs8d0mabzb7IebL0Y619o3udfyflR1PnVoq1nQ2BIJ9CetXGPklwOjTGnMQq3
         +vdOD2v1gG3oWe7i4KiM451+qzIkAbWXZQUW3zPA+Zis4018QRXf413y/Lsh9ehdGw0z
         a/eAqsuNogeAY8FmPUhrBMz3sKfbYxW9QNIuD5o3E2db/TwFBCAdzr2DAPCZZ+Ku+8nK
         EeF0wA4GQBL0yDZnEigzbL3AeYOsR78nEVhc72CLL8cAPmtv08V8J6qlGNPzBDAeBbwZ
         tJGO5RjBYrW0edIggDDkll7bWxjZ7RPT16d+sqEV8WHEhO4Cy8xq/r4n1I1MG6LwJCoN
         RTgw==
X-Forwarded-Encrypted: i=1; AJvYcCUyHz/dDIaY5FDa8VjLVwDpyeR0yDqiSixxbgNMyHFsgjXcVzJ/SKSvXPJK1sPRFXsPyZo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxyAx6fGcZnIM2uZaQY/9ynJScFGSTNwL3wtaDpieldM+fJIhJ
	v025S3+jRBbCh3yLMVkL0sfZfFnyafsshA8sMnWFErpwrBICcrbR/FtFYKwmfnB1yXAWlHRjP5q
	YduT2YnaBMTFQ6EzoIom01t2rsnjlHYGTulsKKpz0P7W0VuKptQ==
X-Gm-Gg: ASbGncuqM6y0+pjgs+T++nm+U/C7j2HdFdFDpfqW8tZJGizEV3GSiY7mp8fmVu3cx2Q
	jOZ4aglI703V6v0YzpbWWyfR56fsk9947FEzFWzmAPmC0+cl5fm9uqCLTDYYXDMR2YcTLFuCxOr
	TS6Gzh+qjoOiFkLFr/B6ZSxR8XX69MZuaLqJ8fqC+Dr0AYOztgRZMnMhyYvL4mOIitGMvsnZ9MZ
	azIUT8jUi13Hb0lCU/1u+eFm6Jujb1VGm2tMhXbIw0OPMyNOLvLzkmIsO1h/HAOmULwoxeZTt+2
	saWEyuljJJpoKKypddQFt3epnAWPfbQJ
X-Received: by 2002:a05:620a:4090:b0:7b6:da21:751c with SMTP id af79cd13be357-7bcd96e6e7fmr3008276385a.11.1736766315361;
        Mon, 13 Jan 2025 03:05:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEudJmjiFx2X110aIZp/K+dX1C2vUPlCS9Q7jCzrlGeW5dRG0V5tRdS8MDrW/FDVcQi98EIoA==
X-Received: by 2002:a05:620a:4090:b0:7b6:da21:751c with SMTP id af79cd13be357-7bcd96e6e7fmr3008272185a.11.1736766314973;
        Mon, 13 Jan 2025 03:05:14 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-100.retail.telecomitalia.it. [82.53.134.100])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7bce3516193sm474979185a.117.2025.01.13.03.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 03:05:14 -0800 (PST)
Date: Mon, 13 Jan 2025 12:05:07 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: netdev@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Leonardi <leonardi@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Wongi Lee <qwerty@theori.io>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Eric Dumazet <edumazet@google.com>, kvm@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Simon Horman <horms@kernel.org>, Hyunwoo Kim <v4bel@theori.io>, 
	Jakub Kicinski <kuba@kernel.org>, virtualization@lists.linux.dev, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH net v2 1/5] vsock/virtio: discard packets if the
 transport changes
Message-ID: <nzpj4hc6m4jlqhcwv6ngmozl3hcoxr6kehoia4dps7jytxf6df@iqglusiqrm5n>
References: <20250110083511.30419-1-sgarzare@redhat.com>
 <20250110083511.30419-2-sgarzare@redhat.com>
 <1aa83abf-6baa-4cf1-a108-66b677bcfd93@rbox.co>
 <nedvcylhjxrkmkvgugsku2lpdjgjpo5exoke4o6clxcxh64s3i@jkjnvngazr5v>
 <CAGxU2F7BoMNi-z=SHsmCV5+99=CxHo4dxFeJnJ5=q9X=CM3QMA@mail.gmail.com>
 <cccb1a4f-5495-4db1-801e-eca211b757c3@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cccb1a4f-5495-4db1-801e-eca211b757c3@rbox.co>

On Mon, Jan 13, 2025 at 11:12:52AM +0100, Michal Luczaj wrote:
>On 1/13/25 10:07, Stefano Garzarella wrote:
>> On Mon, 13 Jan 2025 at 09:57, Stefano Garzarella <sgarzare@redhat.com> wrote:
>>> On Sun, Jan 12, 2025 at 11:42:30PM +0100, Michal Luczaj wrote:
>>
>> [...]
>>
>>>>
>>>> So, if I get this right:
>>>> 1. vsock_create() (refcnt=1) calls vsock_insert_unbound() (refcnt=2)
>>>> 2. transport->release() calls vsock_remove_bound() without checking if sk
>>>>   was bound and moved to bound list (refcnt=1)
>>>> 3. vsock_bind() assumes sk is in unbound list and before
>>>>   __vsock_insert_bound(vsock_bound_sockets()) calls
>>>>   __vsock_remove_bound() which does:
>>>>      list_del_init(&vsk->bound_table); // nop
>>>>      sock_put(&vsk->sk);               // refcnt=0
>>>>
>>>> The following fixes things for me. I'm just not certain that's the only
>>>> place where transport destruction may lead to an unbound socket being
>>>> removed from the unbound list.
>>>>
>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>> index 7f7de6d88096..0fe807c8c052 100644
>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>> @@ -1303,7 +1303,8 @@ void virtio_transport_release(struct vsock_sock *vsk)
>>>>
>>>>       if (remove_sock) {
>>>>               sock_set_flag(sk, SOCK_DONE);
>>>> -              virtio_transport_remove_sock(vsk);
>>>> +              if (vsock_addr_bound(&vsk->local_addr))
>>>> +                      virtio_transport_remove_sock(vsk);
>>>
>>> I don't get this fix, virtio_transport_remove_sock() calls
>>>    vsock_remove_sock()
>>>      vsock_remove_bound()
>>>        if (__vsock_in_bound_table(vsk))
>>>            __vsock_remove_bound(vsk);
>>>
>>>
>>> So, should already avoid this issue, no?
>>
>> I got it wrong, I see now what are you trying to do, but I don't think
>> we should skip virtio_transport_remove_sock() entirely, it also purge
>> the rx_queue.
>
>Isn't rx_queue empty-by-definition in case of !__vsock_in_bound_table(vsk)?

It could be.

But I see some other issues:
- we need to fix also in the other transports, since they do the same
- we need to check delayed cancel work too that call 
   virtio_transport_remove_sock()

An alternative approach, which would perhaps allow us to avoid all this, 
is to re-insert the socket in the unbound list after calling release() 
when we deassign the transport.

WDYT?

Stefano

>
>>> Can the problem be in vsock_bind() ?
>
>Well, I wouldn't say so.
>
>>> Is this issue pre-existing or introduced by this series?
>>
>> I think this is pre-existing, can you confirm?
>
>Yup, I agree, pre-existing.
>
>> In that case, I'd not stop this series, and fix it in another patch/series.
>
>Yeah, sure thing.
>
>Thanks,
>Michal
>


