Return-Path: <kvm+bounces-67785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 892BAD142D6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:52:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A323F303C982
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 16:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2927D36C0A7;
	Mon, 12 Jan 2026 16:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KxmUZUU7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YgZOeLUd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D0036C0AD
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768236559; cv=none; b=Qh2bVX7DvReBfNBojxinNFYE2eHmS6gNifxdYhNrZT9vidJzcza3SzBRqbWv0A9xzHG+a4Wgs8j2vG+ozq/GS/xKmXz3EozMVAONNC1NoFiSYjxyXWsF/yizm1IuhOrsKwcEQPbDxhbzrjwoN8yZAAQ5uz2hSZrlzF+ua+c+3RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768236559; c=relaxed/simple;
	bh=rSpDYYDAlrC2qkyCkQQP9wvtpup8H0/216lHMC+q/jI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XYX7v5JG5k5uNQs+HNIBIbULMrdrrqgvcTC5hCG3VV9gW8+zONZC7P886RI82aqRTzdGjhh8eQ6og1uCKQUDaJc+lYblFy90tXQs5lWcSV5yzLW0DY5Xl7xV5HEYDycABd9qS50A77hdvqGVix7758+6AzgHAN4ZVuU4YNtLMvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KxmUZUU7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YgZOeLUd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768236554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7/pAFr0/aoSxJfBcAQjHBP8K9Jsu2l/1rwtc+O6U0sw=;
	b=KxmUZUU7MZfcOQI9YpVgEx33b2F6UZklh5F373JIpc56rKG6CIAsc4UiOphS4eQW74ZtDn
	pBhUPBpAj/Ll7nFHxSvLOrOAVhpJyPJoiWIptGJyARZcxJ8aMrb+HCW5GPFGbEydHzfCEP
	8fYgNPha6k1qfvRpmwq8oSRH5h6WFJ0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-_B4fwesIOP2zBtx-MIE3iw-1; Mon, 12 Jan 2026 11:49:12 -0500
X-MC-Unique: _B4fwesIOP2zBtx-MIE3iw-1
X-Mimecast-MFC-AGG-ID: _B4fwesIOP2zBtx-MIE3iw_1768236552
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47d3c4468d8so42735255e9.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 08:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768236551; x=1768841351; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7/pAFr0/aoSxJfBcAQjHBP8K9Jsu2l/1rwtc+O6U0sw=;
        b=YgZOeLUdV3qfhMEqiDu8okLFTjc37c9d2amQ6hvc5TtmHWm3IiRKtiQK4IrQubkGut
         NwIlHPOFDekx8lrt6c1oi4Y1bKjlgKifpA/mvUGdWgwzyKVgFXMXspmdMFiJw7m963uy
         lApWF1okdig11IInab5cMoSAM0YJqi52Tw/cn6sSvdMFxGXkqm5QMNXWLQftVnyjrPgO
         olvE17ccMfcmuEaDXUY22A4gNp7SlPr0mCM0LyH56SzTJOC1LpH9LscZPKmtM0UXMssT
         cOK063RbiSTO7CI0HnyCki3HWLZ03EOH/cfmEIqkuUfmeV1s+6lEjHgLWthXUpPVvr8P
         w4+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768236551; x=1768841351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/pAFr0/aoSxJfBcAQjHBP8K9Jsu2l/1rwtc+O6U0sw=;
        b=mUUetmtN/xuIrgS0cmHV6/WPekvjBThCLLcDP0+HOZb7KNUY87UNYi6+X1DNyEz7je
         yKK/MCoy+X2JGBJJD6GItlLFGxMtG+uOUgksIKT9/mwxTbPMxh4zoi7WRgwwOwi+uyUf
         3uTmpI6uIiKJBECiAPl5Nh69ttJJFZERkVuNIanc4royL14pC4On/7c2y+5uEpwwbMbn
         Gswgsc+sJNlnnQvXFADkCmdHqYeNkPgkxUvP+N6TilU/nhqTAGfKFY+G/5CYuEGHK24O
         Tz9YuZW7mxVMg3cK9asgNPLW/J8kWWlT/urdlMoEoV1FBHNshSkqugtwZIgXgAm800pZ
         2a8g==
X-Forwarded-Encrypted: i=1; AJvYcCW5KDyejzZFXcMQZ0PS4Zt8u9xHsGl95n0s56hOaS7j7aT7TXAZRqO6y3GAFgMK/L5GWgA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKf95K8crGHr+KlEFtHOIv9AtJTOrJhWwCTcMqm6FrafSQ1wBx
	NyopHPw30vYMetY4hT7UYNYwlG9OHZYZEvhsZpGQPRoOgxe1fAXcdTSZqMTWwyxzS8fjQ0cxELs
	k5pfx0Kewc6I4nW7zX/pdzB3nfG56qCWW+z3aziOG53+SlrgyAfpT0Q==
X-Gm-Gg: AY/fxX6Ezvjtfx2CEvQfltx0UYoC9M15TsK6egW2vO79LWas6DOxf+0P1JmG1CDKNCR
	ziSiEXco0uE7k8B/l0KbFhghKbZ76FtKMv56+78HjAjuXx7iL5ZwRZBKdJUTVbCU8pGohrAxuav
	wswReXWS28JDWnANsC3xqtOb+u9GUROJxIo0+zlGaGDBMKZaP1VdQPTPAAkYjcKmnO62y+rGGHy
	vQBvl5Yk2tFl0r8YAixdlEn9FBROl0vNnU7dfeEDMVkR+p3yPtOZ6eher15/X3/UXKNSoCp9AOb
	zA7W/Cpye1vkfO6V8q7KaR80Uv7P7Z/YTcXn+BWHVPEwBnxRbpalontFNycvRnyGtICvnlUF7zd
	v6F6PtvO4M4zCtu5AEzmTz3aZfxFN+uFeDxyyBlpd2TlwMI7AFinWo/16ypw2Kw==
X-Received: by 2002:a05:600c:1991:b0:477:55c9:c3ea with SMTP id 5b1f17b1804b1-47d84b40aa4mr239691915e9.35.1768236550745;
        Mon, 12 Jan 2026 08:49:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbfHpDO7Px43Be+w7n1YsI5iuj6cCFBAlIOAFZDgERsn4SYfumZjikc9aia43Emr8rvTaF4g==
X-Received: by 2002:a05:600c:1991:b0:477:55c9:c3ea with SMTP id 5b1f17b1804b1-47d84b40aa4mr239691475e9.35.1768236550199;
        Mon, 12 Jan 2026 08:49:10 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-25-233.business.telecomitalia.it. [87.12.25.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8718b1a6sm133003075e9.13.2026.01.12.08.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 08:49:09 -0800 (PST)
Date: Mon, 12 Jan 2026 17:48:56 +0100
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
Message-ID: <aWUk0axv-GZu7VD2@sgarzare-redhat>
References: <20260108-vsock-recv-coalescence-v1-0-26f97bb9a99b@rbox.co>
 <20260108-vsock-recv-coalescence-v1-2-26f97bb9a99b@rbox.co>
 <aWEqjjE1vb_t35lQ@sgarzare-redhat>
 <76ca0c9f-dcda-4a53-ac1f-c5c28d1ecf44@rbox.co>
 <aWT6EH8oWpw-ADtm@sgarzare-redhat>
 <080d7ae8-e184-4af8-bd72-765bb30b63a5@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <080d7ae8-e184-4af8-bd72-765bb30b63a5@rbox.co>

On Mon, Jan 12, 2026 at 04:52:02PM +0100, Michal Luczaj wrote:
>On 1/12/26 14:44, Stefano Garzarella wrote:
>> On Sun, Jan 11, 2026 at 11:59:54AM +0100, Michal Luczaj wrote:
>>>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>>>> index bbe3723babdc..21c8616100f1 100644
>>>>> --- a/tools/testing/vsock/vsock_test.c
>>>>> +++ b/tools/testing/vsock/vsock_test.c
>>>>> @@ -2403,6 +2403,11 @@ static struct test_case test_cases[] = {
>>>>> 		.run_client = test_stream_accepted_setsockopt_client,
>>>>> 		.run_server = test_stream_accepted_setsockopt_server,
>>>>> 	},
>>>>> +	{
>>>>> +		.name = "SOCK_STREAM MSG_ZEROCOPY coalescence corruption",
>>>>
>>>> This is essentially a regression test for virtio transport, so I'd add
>>>> virtio in the test name.
>>>
>>> Isn't virtio transport unaffected? It's about loopback transport (that
>>> shares common code with virtio transport).
>>
>> Why virtio transport is not affected?
>
>With the usual caveat that I may be completely missing something, aren't
>all virtio-transport's rx skbs linear? See virtio_vsock_alloc_linear_skb()
>in virtio_vsock_rx_fill().
>

True, but what about drivers/vhost/vsock.c ?

IIUC in vhost_vsock_handle_tx_kick() we call vhost_vsock_alloc_skb(), 
that calls virtio_vsock_alloc_skb() and pass that skb to 
virtio_transport_recv_pkt(). So, it's also affected right?

BTW in general we consider loopback as one of virtio devices since it 
really shares with them most of the code.

That said, now I'm thinking more about Fixes tag.
Before commit 6693731487a8 ("vsock/virtio: Allocate nonlinear SKBs for 
handling large transmit buffers") was that a real issue?

Thanks,
Stefano


