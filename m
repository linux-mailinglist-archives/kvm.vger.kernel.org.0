Return-Path: <kvm+bounces-42627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 093E2A7B8E4
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A145A189E2E5
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 08:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60A4B19C55E;
	Fri,  4 Apr 2025 08:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KptVwNPA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D5F1991DD
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 08:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743755454; cv=none; b=WsAq9/PQlRA3MY7p0BQHLcdpLKMHxo9QtsNMsDEZABjgrQ+opdDErK7nyZlraBElBvLFCqGuV+0b7eFUSEacQMBbG5ETv8kMRGcpdEJGcWcz43AFecabalnipIGTuV15WnUV+7OlFjVTndKcOHnVgflki4yaB/z/4R1d/QWXV78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743755454; c=relaxed/simple;
	bh=8GewlxyW7eoP8HeCQK4EuVSYVIQ9APadJTENW0qBDpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WB/fGc6cp+m78RQFx2iD4rRQQgfTD4tzbrGsOh+X+9RC6JmENBswJ2CpRFjfbJCDacuGc++yfTwjT+SbeksUrOujjLLoRd5N+l89PZZjZnJStzCItynnEDKT9VA0EjeefqYsFgbIiO58YJlIxqbl2Q+fJMXzjAHLLUXEemsJw7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KptVwNPA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743755451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T3XzV/U7dY3geuoVqw6S19aFTsTGevyvWrfbHpg+jFw=;
	b=KptVwNPAaznqWtOegYbbcuJOEs314Cv/H3Rq90w5GObhUY5zbX5QwBXTFU1uMBBU0C110z
	GJpbsV+lHs6DpZrH3BzjlsUjJeVqJ6u4ogbQOYB5awsUHOZA9n12XD48WTybNc6g9XPfoA
	8AVo2rNb55mmDHHOVkWze5XW8b7zRW8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-SruME9cfMdC_COIXeAy0aw-1; Fri, 04 Apr 2025 04:30:50 -0400
X-MC-Unique: SruME9cfMdC_COIXeAy0aw-1
X-Mimecast-MFC-AGG-ID: SruME9cfMdC_COIXeAy0aw_1743755449
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43d01024089so14459945e9.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 01:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743755449; x=1744360249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3XzV/U7dY3geuoVqw6S19aFTsTGevyvWrfbHpg+jFw=;
        b=D9CjEGbslrXt5pVQyj59Qjev/ss4LPKrsvBwM5gGel/KV+//wJd5VmBcJeCt8xAKBO
         VKx4RvdoBqBYE1NKay8M5USObn6nUIhaYREgzsSNg3NabPK4MatFXh4Jlfb9YK+zkJuU
         UFgQQKzgHjImbQ3x3g1lonYaTeBkM4gUq3tJLReOoAM+QnteNU1KLNU8A4Viplt07+SN
         Fl7XZwDh6nUUlfuaLWEcNo+uRJA1Sp4ztHhusNsZ41F4RJTGPrcH+MRarjOQO1GXKKT6
         ZnBgdNe8ytmdq71xVaj9VHU3T+8gxwkWPuWZ9h/amOcz9gvKxaTu9wcuadUAY+I4hlhI
         ro1g==
X-Forwarded-Encrypted: i=1; AJvYcCVX478gc6ShBT0qnLBLYjyv3HBxO0nZh/UlXwDR1nYiPyOF+zyjMe29E/QzXxAkxAvGqyA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww0acf2FXWTGRN8eOFDqWES+Wgzw2Is5mtqGgmvoC1P2d/vb6+
	lv4gV8fy0gNyBECGUGKpfL1XxEk4IzUa/b8nwXTjyVvLhTkiqezswACVBkNdCtX3LJwq8/+JNfi
	2jckozoLyE/kze3SQK/02gGwV2kY03wSTIgnZtwVlIYqq54zItQ==
X-Gm-Gg: ASbGnctx/q7Yl4XAddaprMFkdVjOLun+zRmml4oAsC5+Ps2UwTCg0+WYNMAQhbw+lzL
	yHt4px0htj658yJOuUmj8CoLUebWAOa29ghcLCjVeUIoY0/gt5y4Zrx+TB3oE6rNGQG7dIHlDPB
	vT3rASuBuQRy14+PfEvI80l1cIOPwEk19oxQI1Uqj78k56FtVNhw+mUAFbHbyrY6PjYwUtTXVS1
	pLun2/Nam7iKREC8ZkRkqWzBxTj7Ym//vx40l5J1iPHAzLNGqJYCpmH7f46xsE/34QvoDdaO7D9
	5S5KuYHfpI+BAZzxzhJ5O2Yuj1HeBHCrtSNVxBBCo2mJpja1uLlXKuIlvyI=
X-Received: by 2002:a05:600c:468c:b0:43c:f75a:eb54 with SMTP id 5b1f17b1804b1-43ecf89dddcmr19881955e9.13.1743755449000;
        Fri, 04 Apr 2025 01:30:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH1wKJOBp0CxXmSt34i3bMjHqoK6bjtjR9iZitlzkAWs0gUdgf+hp6J8a0hZZYH5whJltcXUA==
X-Received: by 2002:a05:600c:468c:b0:43c:f75a:eb54 with SMTP id 5b1f17b1804b1-43ecf89dddcmr19881525e9.13.1743755448536;
        Fri, 04 Apr 2025 01:30:48 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-59.retail.telecomitalia.it. [87.11.6.59])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34a7615sm39259665e9.9.2025.04.04.01.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 01:30:47 -0700 (PDT)
Date: Fri, 4 Apr 2025 10:30:43 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, Asias He <asias@redhat.com>, 
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, "David S . Miller" <davem@davemloft.net>, 
	nh-open-source@amazon.com
Subject: Re: [PATCH v2] vsock/virtio: Remove queued_replies pushback logic
Message-ID: <fiyxlnv7gglcfkr7ue4tiaktqjptdkr5or6skrr6f7dof26d56@wmg3zhhqlcoj>
References: <20250401201349.23867-1-graf@amazon.com>
 <20250402161424.GA305204@fedora>
 <20250403073111-mutt-send-email-mst@kernel.org>
 <32ca5221-5b25-4bfd-acd7-9eebae8c3635@amazon.com>
 <20250404041050-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250404041050-mutt-send-email-mst@kernel.org>

On Fri, Apr 04, 2025 at 04:14:51AM -0400, Michael S. Tsirkin wrote:
>On Fri, Apr 04, 2025 at 10:04:38AM +0200, Alexander Graf wrote:
>>
>> On 03.04.25 14:21, Michael S. Tsirkin wrote:
>> > On Wed, Apr 02, 2025 at 12:14:24PM -0400, Stefan Hajnoczi wrote:
>> > > On Tue, Apr 01, 2025 at 08:13:49PM +0000, Alexander Graf wrote:
>> > > > Ever since the introduction of the virtio vsock driver, it included
>> > > > pushback logic that blocks it from taking any new RX packets until the
>> > > > TX queue backlog becomes shallower than the virtqueue size.
>> > > >
>> > > > This logic works fine when you connect a user space application on the
>> > > > hypervisor with a virtio-vsock target, because the guest will stop
>> > > > receiving data until the host pulled all outstanding data from the VM.
>> > > >
>> > > > With Nitro Enclaves however, we connect 2 VMs directly via vsock:
>> > > >
>> > > >    Parent      Enclave
>> > > >
>> > > >      RX -------- TX
>> > > >      TX -------- RX
>> > > >
>> > > > This means we now have 2 virtio-vsock backends that both have the pushback
>> > > > logic. If the parent's TX queue runs full at the same time as the
>> > > > Enclave's, both virtio-vsock drivers fall into the pushback path and
>> > > > no longer accept RX traffic. However, that RX traffic is TX traffic on
>> > > > the other side which blocks that driver from making any forward
>> > > > progress. We're now in a deadlock.
>> > > >
>> > > > To resolve this, let's remove that pushback logic altogether and rely on
>> > > > higher levels (like credits) to ensure we do not consume unbounded
>> > > > memory.
>> > > The reason for queued_replies is that rx packet processing may emit tx
>> > > packets. Therefore tx virtqueue space is required in order to process
>> > > the rx virtqueue.
>> > >
>> > > queued_replies puts a bound on the amount of tx packets that can be
>> > > queued in memory so the other side cannot consume unlimited memory. Once
>> > > that bound has been reached, rx processing stops until the other side
>> > > frees up tx virtqueue space.
>> > >
>> > > It's been a while since I looked at this problem, so I don't have a
>> > > solution ready. In fact, last time I thought about it I wondered if the
>> > > design of virtio-vsock fundamentally suffers from deadlocks.
>> > >
>> > > I don't think removing queued_replies is possible without a replacement
>> > > for the bounded memory and virtqueue exhaustion issue though. Credits
>> > > are not a solution - they are about socket buffer space, not about
>> > > virtqueue space, which includes control packets that are not accounted
>> > > by socket buffer space.
>> >
>> > Hmm.
>> > Actually, let's think which packets require a response.
>> >
>> > VIRTIO_VSOCK_OP_REQUEST
>> > VIRTIO_VSOCK_OP_SHUTDOWN
>> > VIRTIO_VSOCK_OP_CREDIT_REQUEST
>> >
>> >
>> > the response to these always reports a state of an existing socket.
>> > and, only one type of response is relevant for each socket.
>> >
>> > So here's my suggestion:
>> > stop queueing replies on the vsock device, instead,
>> > simply store the response on the socket, and create a list of sockets
>> > that have replies to be transmitted
>> >
>> >
>> > WDYT?
>>
>>
>> Wouldn't that create the same problem again? The socket will eventually push
>> back any new data that it can take because its FIFO is full. At that point,
>> the "other side" could still have a queue full of requests on exactly that
>> socket that need to get processed. We can now not pull those packets off the
>> virtio queue, because we can not enqueue responses.
>
>Either I don't understand what you wrote or I did not explain myself
>clearly.

I didn't fully understand either, but with this last message of yours 
it's clear to me and I like the idea!

>
>In this idea there needs to be a single response enqueued
>like this in the socket, because, no more than one ever needs to
>be outstanding per socket.
>
>For example, until VIRTIO_VSOCK_OP_REQUEST
>is responded to, the socket is not active and does not need to
>send anything.

One case I see is responding when we don't have the socket listening 
(e.g. the port is not open), so if before the user had a message that 
the port was not open, now instead connect() will timeout. So we could 
respond if we have space in the virtqueue, otherwise discard it without 
losing any important information or guarantee of a lossless channel.

So in summary:

- if we have an associated socket, then always respond (possibly
   allocating memory in the intermediate queue if the virtqueue is full
   as we already do). We need to figure out if a flood of
   VIRTIO_VSOCK_OP_CREDIT_REQUEST would cause problems, but we can always
   decide not to respond if we have sent this identical information
   before.

- if there is no associated socket, we only respond if virtqueue has
   space.

I like it and it seems feasible without changing anything in the 
specification.

Did I get it right?

Thanks,
Stefano


