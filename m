Return-Path: <kvm+bounces-42628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 567FCA7B90A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:38:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5E4F1897E8C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 08:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D884D19EEBD;
	Fri,  4 Apr 2025 08:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SmLy0KwM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E7417A305
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 08:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743755866; cv=none; b=eVpzOogTHH2ws9kLp1NZHbvcxKUQz/XFswFyxjY1USeA7Ef+o/ypbzUuNvnpDE1YY5vmJiO86YQ1LU5S03HyBQM3cAVKccwpuHxPJBy+NZkZD14L7aKL6iN7w4uKAjrazmjxRyLJmgx3JJo6BWSJYCNg1eh/nhAriDlp9vD20Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743755866; c=relaxed/simple;
	bh=QAhyu4E7HQ19zzaz86rUGI9nPrmZDX3iMt2qJViTveA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXrqctbXOqDJr1wEeO7o3K8CedISjcP8QypVY3jwMo6TapBYqIDFpuSLJ4iGpYifs1IOx3lKNx9Rv/4/AeP4DkgUXA0evqBbqmUhOt1OR0qwcW/Dm4yNUsCMl4mxGCiU6ux3qRsJYu+UdsiSYd9xkQLwYgFnAgBWpo4roPr1JCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SmLy0KwM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743755862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OI1Zt3NFcFi/P6TNraRk0oZkTYZ+LV6TSig6Xx970e4=;
	b=SmLy0KwMGtpSJy3Zp2nMTXpLKt5kEq8ONzPIx2aJoIPWGKZFFgxFidypDXVoU0q0IYyBdv
	BGtIsC7xD3l1V63+rkPJHB0sO8Poz47wliDaFLWWacJtKHqNl+hH/GvZL17rU64u0SiNdg
	2qbs2c6ZJuzcPUHCBmHO5HD8mD2E7Ec=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-dkIxukdKMRKpXnucG3h_sw-1; Fri, 04 Apr 2025 04:37:41 -0400
X-MC-Unique: dkIxukdKMRKpXnucG3h_sw-1
X-Mimecast-MFC-AGG-ID: dkIxukdKMRKpXnucG3h_sw_1743755861
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39c2da64df9so1203925f8f.0
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 01:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743755860; x=1744360660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OI1Zt3NFcFi/P6TNraRk0oZkTYZ+LV6TSig6Xx970e4=;
        b=t7fx1BeFgiaU37w/PGDgXbcR8Vsayah9MnrecTnIFNAkdF4/SJQcjJyEzyOA7L8LHr
         LptITM+qz/Zim/1NHj7yogN8AYVjXGKFdhd1Gl4ud7/QRAryZMKsuVQnLK35k2Zmyylr
         8xCuB3nSGH/ZVNxrYFaaIw9p0/N4D6RhnYppEmYqmtf9p+YmjPuxpBo226ORFMO2XDjf
         jx3dojfI7vrnpL+kCIEz9km6q+OYNz+M1S9MUatoAmb3L+EZDEmdCMZgAq70eYJP/uqu
         8DN1G13d4KMXDEnxXFyMh+/mkAOh/g24yfhTRtS27+Y+tEhaTv+1xFt+KtdBhfhsoMNa
         L/OA==
X-Forwarded-Encrypted: i=1; AJvYcCWpQEL4pMjiH1/FcRjDD/ZOi7J/tsVFzXfYYOXAKLFi/OUk9t+vlcAIH2ML4ojyWwhjygc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZGrAngTNNEx0SwseRBJj37+kBaVA5D7ZG9XcXmeBxePUz/Sht
	6OwKIMDeoR/lkRjpY6QbqcoPtywv++HNNkNtD8VNjfdH7WrMMErb2ow3coCgJ2taKYFk/KB6cvE
	toMW1cEOn1WSy6mKRTSR9FcCWtguP0nCu9nHtBnnXLmNfku+zNw==
X-Gm-Gg: ASbGnctEjTI9Xpe9vkmBuV1iaJ5UTU56LYupqHvu6wZ/zbDlWF23RTVlIBTZsrnMAXM
	+3uSmD50Hzl4vOz5ZUh/Xy/dGd8AZNGXiqJms2RMV6CgN+c2OPfU/dVog5MpSS7nVSH95+fF79C
	46J1K6E2f0NZmmVvb94PWh4Tb79Pq5izAJhn6JEHxNPHsqvNGFvQs2ejblVhLwAA3ZPVbF1Iy7p
	mDwYnDUxyqVKefXBiuoLircEoa3NZUbNeq/o0lOb4UNc6vxnW8G7xpEqca4RzMesjCrkS/CxpOd
	66PlGtdz4w==
X-Received: by 2002:a05:6000:430c:b0:391:2e31:c7e5 with SMTP id ffacd0b85a97d-39cb36b2ab2mr2013765f8f.6.1743755860541;
        Fri, 04 Apr 2025 01:37:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeh87271OU/aKTaskLblwGps7bO+cJZTClXWXzF8apC0wBecu3MvRM0wP/QWFDltqL8vhYdA==
X-Received: by 2002:a05:6000:430c:b0:391:2e31:c7e5 with SMTP id ffacd0b85a97d-39cb36b2ab2mr2013743f8f.6.1743755860159;
        Fri, 04 Apr 2025 01:37:40 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301a7225sm3768866f8f.26.2025.04.04.01.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 01:37:39 -0700 (PDT)
Date: Fri, 4 Apr 2025 04:37:36 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Alexander Graf <graf@amazon.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Asias He <asias@redhat.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>, nh-open-source@amazon.com
Subject: Re: [PATCH v2] vsock/virtio: Remove queued_replies pushback logic
Message-ID: <20250404043326-mutt-send-email-mst@kernel.org>
References: <20250401201349.23867-1-graf@amazon.com>
 <20250402161424.GA305204@fedora>
 <20250403073111-mutt-send-email-mst@kernel.org>
 <32ca5221-5b25-4bfd-acd7-9eebae8c3635@amazon.com>
 <20250404041050-mutt-send-email-mst@kernel.org>
 <fiyxlnv7gglcfkr7ue4tiaktqjptdkr5or6skrr6f7dof26d56@wmg3zhhqlcoj>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fiyxlnv7gglcfkr7ue4tiaktqjptdkr5or6skrr6f7dof26d56@wmg3zhhqlcoj>

On Fri, Apr 04, 2025 at 10:30:43AM +0200, Stefano Garzarella wrote:
> On Fri, Apr 04, 2025 at 04:14:51AM -0400, Michael S. Tsirkin wrote:
> > On Fri, Apr 04, 2025 at 10:04:38AM +0200, Alexander Graf wrote:
> > > 
> > > On 03.04.25 14:21, Michael S. Tsirkin wrote:
> > > > On Wed, Apr 02, 2025 at 12:14:24PM -0400, Stefan Hajnoczi wrote:
> > > > > On Tue, Apr 01, 2025 at 08:13:49PM +0000, Alexander Graf wrote:
> > > > > > Ever since the introduction of the virtio vsock driver, it included
> > > > > > pushback logic that blocks it from taking any new RX packets until the
> > > > > > TX queue backlog becomes shallower than the virtqueue size.
> > > > > >
> > > > > > This logic works fine when you connect a user space application on the
> > > > > > hypervisor with a virtio-vsock target, because the guest will stop
> > > > > > receiving data until the host pulled all outstanding data from the VM.
> > > > > >
> > > > > > With Nitro Enclaves however, we connect 2 VMs directly via vsock:
> > > > > >
> > > > > >    Parent      Enclave
> > > > > >
> > > > > >      RX -------- TX
> > > > > >      TX -------- RX
> > > > > >
> > > > > > This means we now have 2 virtio-vsock backends that both have the pushback
> > > > > > logic. If the parent's TX queue runs full at the same time as the
> > > > > > Enclave's, both virtio-vsock drivers fall into the pushback path and
> > > > > > no longer accept RX traffic. However, that RX traffic is TX traffic on
> > > > > > the other side which blocks that driver from making any forward
> > > > > > progress. We're now in a deadlock.
> > > > > >
> > > > > > To resolve this, let's remove that pushback logic altogether and rely on
> > > > > > higher levels (like credits) to ensure we do not consume unbounded
> > > > > > memory.
> > > > > The reason for queued_replies is that rx packet processing may emit tx
> > > > > packets. Therefore tx virtqueue space is required in order to process
> > > > > the rx virtqueue.
> > > > >
> > > > > queued_replies puts a bound on the amount of tx packets that can be
> > > > > queued in memory so the other side cannot consume unlimited memory. Once
> > > > > that bound has been reached, rx processing stops until the other side
> > > > > frees up tx virtqueue space.
> > > > >
> > > > > It's been a while since I looked at this problem, so I don't have a
> > > > > solution ready. In fact, last time I thought about it I wondered if the
> > > > > design of virtio-vsock fundamentally suffers from deadlocks.
> > > > >
> > > > > I don't think removing queued_replies is possible without a replacement
> > > > > for the bounded memory and virtqueue exhaustion issue though. Credits
> > > > > are not a solution - they are about socket buffer space, not about
> > > > > virtqueue space, which includes control packets that are not accounted
> > > > > by socket buffer space.
> > > >
> > > > Hmm.
> > > > Actually, let's think which packets require a response.
> > > >
> > > > VIRTIO_VSOCK_OP_REQUEST
> > > > VIRTIO_VSOCK_OP_SHUTDOWN
> > > > VIRTIO_VSOCK_OP_CREDIT_REQUEST
> > > >
> > > >
> > > > the response to these always reports a state of an existing socket.
> > > > and, only one type of response is relevant for each socket.
> > > >
> > > > So here's my suggestion:
> > > > stop queueing replies on the vsock device, instead,
> > > > simply store the response on the socket, and create a list of sockets
> > > > that have replies to be transmitted
> > > >
> > > >
> > > > WDYT?
> > > 
> > > 
> > > Wouldn't that create the same problem again? The socket will eventually push
> > > back any new data that it can take because its FIFO is full. At that point,
> > > the "other side" could still have a queue full of requests on exactly that
> > > socket that need to get processed. We can now not pull those packets off the
> > > virtio queue, because we can not enqueue responses.
> > 
> > Either I don't understand what you wrote or I did not explain myself
> > clearly.
> 
> I didn't fully understand either, but with this last message of yours it's
> clear to me and I like the idea!
> 
> > 
> > In this idea there needs to be a single response enqueued
> > like this in the socket, because, no more than one ever needs to
> > be outstanding per socket.
> > 
> > For example, until VIRTIO_VSOCK_OP_REQUEST
> > is responded to, the socket is not active and does not need to
> > send anything.
> 
> One case I see is responding when we don't have the socket listening (e.g.
> the port is not open), so if before the user had a message that the port was
> not open, now instead connect() will timeout. So we could respond if we have
> space in the virtqueue, otherwise discard it without losing any important
> information or guarantee of a lossless channel.
> 
> So in summary:
> 
> - if we have an associated socket, then always respond (possibly
>   allocating memory in the intermediate queue if the virtqueue is full
>   as we already do). We need to figure out if a flood of
>   VIRTIO_VSOCK_OP_CREDIT_REQUEST would cause problems, but we can always
>   decide not to respond if we have sent this identical information
>   before.

If taking this path, need to consider not responding is within spec or not.
But again, credit update needed is just a single flag we need to set
on a socket. If we have anything we need to send, it can also update
the credits.


> - if there is no associated socket, we only respond if virtqueue has
>   space.
> 
> I like it and it seems feasible without changing anything in the
> specification.
> 
> Did I get it right?
> 
> Thanks,
> Stefano

That was the idea, yes.

-- 
MST


