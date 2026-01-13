Return-Path: <kvm+bounces-67924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3D5D17C07
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 10:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB0F03053835
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 09:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63DF4366560;
	Tue, 13 Jan 2026 09:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SlZAgJRE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qe4f/O7u"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E5236997D
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 09:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768297021; cv=none; b=mfl7pg/azL9BbCQvXkVjrQpkALH7/Fmo7sd3ke2fbxRIF7gTmaAgoerWPAVIFp7qwAYG/x6bwdy5Xdo4Zw3W7eRG079nAEV8EATvHYSYRy5nzw09vXqyWU9vFOf9Ci5DGY9iuKrx+7oyc7s/R1dgZcAvojZWYRg0iHqm6GBLH2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768297021; c=relaxed/simple;
	bh=i7jmKtKg7PeuT25Uc1BWE7cT/g0kspLdiSl6D9EotN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A1fOnmdOzowXdqnZn2VHQKF+adcmHV8nJ677KQ24B+eHu5GlMomqjalNUkdmQ5vLIN3pzsOH0cTpeDhZcy1GcRdVk81fTMS5M83m8uCrStjXReXJx8Tm8ybBLvJ3sNIAyotdChgMSVOxv4CbYTywtZ7xdYjDrDQj9AyzvRGzv98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SlZAgJRE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qe4f/O7u; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768297017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pg4CF8mbdvXgdlxK3eag1qF9zBIQiZ4lLsv36mMbgWM=;
	b=SlZAgJREKq6/7bFnGegvS8Zw9s4pro4zbRfUcI3Sob2kfplDz+t+pcVUfQKDzKrzt8PIQL
	KvxgpZ91ylkCnnwS4Ss+/Ugg/gdz5JSLgcByPZaP+FDhEdl/tYcr5rdD8HmbiBOqknV72o
	bAiUwCu3cvVVsVRlDXGhfhsZryvV/uE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-9VUVu8TkOSS__cKl3Ww4QQ-1; Tue, 13 Jan 2026 04:36:56 -0500
X-MC-Unique: 9VUVu8TkOSS__cKl3Ww4QQ-1
X-Mimecast-MFC-AGG-ID: 9VUVu8TkOSS__cKl3Ww4QQ_1768297015
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47edfdc6c1aso241535e9.3
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 01:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768297011; x=1768901811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pg4CF8mbdvXgdlxK3eag1qF9zBIQiZ4lLsv36mMbgWM=;
        b=Qe4f/O7uRm8C2wshHKoVgSo0Kl26YcWaIctRvc5+rRbcMp2yIlc8OFcugjYLKVOeq9
         Tzj3Q5U08ZrP2R0Xxm3iRN7AqvjusR8A1Dk/XusPD9tQLfw+cAORRGSyFrMKd/oMwIhI
         cadGQq+aELEVKZ+nopOlKUSbdvd/sEKEn72y9F729NaZWohibBmgfzB1pT7ZSuil5idq
         dqm5ajjqHPdj7utUjFTJPk8zqS3nic+LjyBpUOSMKlCcE5BvfO6KwBQ+JX5b/Xbs7452
         JE6MAsYjCiWwIzCVr23zrG17w190MruR0v7YSznoXTrrLz5a0XXVwrslrz56d12hcnqr
         iE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768297011; x=1768901811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pg4CF8mbdvXgdlxK3eag1qF9zBIQiZ4lLsv36mMbgWM=;
        b=t9OjOMEgJZKozy6WIliX6Wt5THiY/PdandXCi5KOQv7XHx7pm6O7WJkRuN2xexBToT
         w09fN2X5U4wHgxcVv0cglzJr4tr7WtR+pr7/rOHuwBFs7HDoi7eKQye6JpO6rwVWffst
         Ua1+v/E7ukjdJHcyr9G8+7PNI5Tf54dv+V9vbbzmz4rAylA4OLpyrBOM67eu5rQ/iOUu
         /6TmmlTzajt4xH+YpHR6cfyhvih10DKmwVzYze9U5hUs/jK4ZJ+U22X31sj79M2MYNSX
         aG69iiqHYWwbYIOIaIIihMc4d03Rxh1BsiGSyK9ABbb6T/7FaTUkTR6xV3OXvzwHKRfe
         9u7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKp8yCJdue2vFzQDE05AceUy9yqKEfBTa9V2KFotrQqwfOu3qoqrXnxRr2wXmAmVjHsvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVhcad5b53PiQncbYZbw5sborWIqt5AVjmvZ6ihfJarrwTkNVm
	fotEVZmkTxvB3N6o32gNYYDzlU/2hcZh8PhAP/SWWWJkaq1y3AGScU0iFTbxV4YU8VFqfdI1YuC
	+TcaGigkYuVXaP7n/uZEljCmYkuSlzj76OtkZZ8qEuWxajCs0AiiJNw==
X-Gm-Gg: AY/fxX6wdzUMlQ4zl3UBt7D51RUvO8DFR05fLK61a9HWt/wKjxbLy2K26GK68oTftUa
	UfI46WUj7FPPCdr7I5vnX6qu8qTKZQs2avdkyfLPpJ5xpeiMNCR3ay+PoKn2EZ46GbGpaxQOH9W
	LVldXTrKbHS+GnvUNJd8Pohk0yMhB3aN8hbuF4PF9Fffg3Gb4bwZUy5OG6wVeE2rwzyMeDGk3J5
	3Ktzr8NvsJ/GHxRXK4yuJ8DtFsN4LSlGy6A4Xqlz87TDxQOMEoFMSIuyp4woQUkl5E4Rr/+yF32
	1GfQdkhBXWk/LzHg2WwxPJYYvG/U7HVUXECD/lNOKuNzs9v1SS3+wakRrge9/GGzAcIHaQlm+s/
	YXFSakcpVQpA7uqLC5AJ+zKfEfTsWIDTcTHmKBBHzfIq2iXJfTUbLBLvqh7Y7HQ==
X-Received: by 2002:a05:600c:1394:b0:47d:3ffa:5f03 with SMTP id 5b1f17b1804b1-47d84b3467emr250088615e9.21.1768297011476;
        Tue, 13 Jan 2026 01:36:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBInHZFJ8RidwkWLMCKS42wGE9AndYw8hKlz7EsNrZzGfvzlSbcNPT7twl1koVSE4j25wDOQ==
X-Received: by 2002:a05:600c:1394:b0:47d:3ffa:5f03 with SMTP id 5b1f17b1804b1-47d84b3467emr250088215e9.21.1768297010851;
        Tue, 13 Jan 2026 01:36:50 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5fe83bsm43257713f8f.38.2026.01.13.01.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 01:36:50 -0800 (PST)
Date: Tue, 13 Jan 2026 10:36:42 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vsock/test: Add test for a linear and non-linear skb
 getting coalesced
Message-ID: <aWYQRK-fRHOqQNc8@sgarzare-redhat>
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
 <20260108-vsock-recv-coalescence-v1-2-26f97bb9a99b@rbox.co>
 <aWEqjjE1vb_t35lQ@sgarzare-redhat>
 <76ca0c9f-dcda-4a53-ac1f-c5c28d1ecf44@rbox.co>
 <aWT6EH8oWpw-ADtm@sgarzare-redhat>
 <080d7ae8-e184-4af8-bd72-765bb30b63a5@rbox.co>
 <aWUk0axv-GZu7VD2@sgarzare-redhat>
 <0b15644b-9394-4734-9c0e-0a6d1355604a@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0b15644b-9394-4734-9c0e-0a6d1355604a@rbox.co>

On Mon, Jan 12, 2026 at 10:20:50PM +0100, Michal Luczaj wrote:
>On 1/12/26 17:48, Stefano Garzarella wrote:
>>>>>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>>>>>> index bbe3723babdc..21c8616100f1 100644
>>>>>>> --- a/tools/testing/vsock/vsock_test.c
>>>>>>> +++ b/tools/testing/vsock/vsock_test.c
>>>>>>> @@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
>>>>>>> 		.run_client = test_stream_accepted_setsockopt_client,
>>>>>>> 		.run_server = test_stream_accepted_setsockopt_server,
>>>>>>> 	},
>>>>>>> +	{
>>>>>>> +		.name = "SOCK_STREAM MSG_ZEROCOPY coalescence corruption",
>>>>>>
>>>>>> This is essentially a regression test for virtio transport, so I'd add
>>>>>> virtio in the test name.
>>>>>
>>>>> Isn't virtio transport unaffected? It's about loopback transport (that
>>>>> shares common code with virtio transport).
>>>>
>>>> Why virtio transport is not affected?
>>>
>>> With the usual caveat that I may be completely missing something, aren't
>>> all virtio-transport's rx skbs linear? See virtio_vsock_alloc_linear_skb()
>>> in virtio_vsock_rx_fill().
>>>
>>
>> True, but what about drivers/vhost/vsock.c ?
>>
>> IIUC in vhost_vsock_handle_tx_kick() we call vhost_vsock_alloc_skb(),
>> that calls virtio_vsock_alloc_skb() and pass that skb to
>> virtio_transport_recv_pkt(). So, it's also affected right?
>
>virtio_vsock_alloc_skb() returns a non-linear skb only if size >
>SKB_WITH_OVERHEAD(PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)). And that is way
>more than GOOD_COPY_LEN, so we're good.
>
>At least until someone increases GOOD_COPY_LEN and/or reduces the size
>condition for non-linear allocation. So, yeah, a bit brittle.

I see, thanks for clarify. So please add all of this conclusions in the 
patch 1 description to make it clear that only loopback is affected, so 
no guest/host attack is possible. (not really severe CVE)

>
>> BTW in general we consider loopback as one of virtio devices since it
>> really shares with them most of the code.
>
>Fair enough, I'll add "virtio" to the test name.

Thanks.

>
>> That said, now I'm thinking more about Fixes tag.
>> Before commit 6693731487a8 ("vsock/virtio: Allocate nonlinear SKBs for
>> handling large transmit buffers") was that a real issue?
>
>I don't really think that commit changes anything for the zerocopy case. It
>only makes some big (>GOOD_COPY_LEN) non-ZC skbs turn non-linear.
>

I see.

Stefano


