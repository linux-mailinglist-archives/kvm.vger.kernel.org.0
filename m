Return-Path: <kvm+bounces-64676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD13C8AA15
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B57614E67C8
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 15:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6885C331A7C;
	Wed, 26 Nov 2025 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AVmbCXjz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CrFKSehg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E353321AD
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170756; cv=none; b=GXpfagPendobMaGz3NyqK0qzm8ew1S8hnrZG6nJILvroZyljgQiL/zgMghHIDD2YVYeDjYHGDL6Smkem7hefimWUq9ehf3JEu4dbahK1W9N1evJTfW6ouCUmF3EaJmoYePzLPgZHuxOztH3CmQAmq41/CG+4aibUb/21r4UYuRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170756; c=relaxed/simple;
	bh=MlNy/atfOJbZCeA0q/MGoSHM0JWfj9pD6YlEmXsdmCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rMmqHDeJHXsG4BugT8wFUsGrs+igbHJMgaURXKvuVPDbIdvnwJeuwm6p59666PlZTLEZBLnDce7NZcqQLWrIhH8gAbCCLmuWphOakSaFKhggmCBc9yPfJpXPET5BHVuTELpl/2HJYPW0OP5Rt6F4rnIHVxUuZDoKXsLtpmsdmbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AVmbCXjz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CrFKSehg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764170753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IdOd/whsaB5ha6Xltts70lCb5PGc5f2tglKc7q062f4=;
	b=AVmbCXjzydvNmn1c7t0JhKY3pkumBZdQb4lF+A6FRqFbpjf32ufR8lZXmK4hZeKEzRlmzs
	F/Rya2/PDPpPy9Mhm7JpBpDW2SE/ofthb3ti+YD6rf/VkvxRSe9u3Kj5HUx64Co8D5cfL1
	JO2Fl17NiK6Z5gTSpQxt7cylT1DCROU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-4U0ymmfxO26ncOa2tDv3Sg-1; Wed, 26 Nov 2025 10:25:52 -0500
X-MC-Unique: 4U0ymmfxO26ncOa2tDv3Sg-1
X-Mimecast-MFC-AGG-ID: 4U0ymmfxO26ncOa2tDv3Sg_1764170751
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b3c965ce5so6246776f8f.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 07:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764170749; x=1764775549; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IdOd/whsaB5ha6Xltts70lCb5PGc5f2tglKc7q062f4=;
        b=CrFKSehgTVATz5ItZ3SW5aIMvHYoe8RmV8ykOb+wphhtyd6jYk3JwjvcVP5LpU/vBV
         6vf6/+SmcGGExXk67kp1vuUIyCPFL3MR7wNn3jvH2x17yiML7NFG5VmZzq0AHG7BN3TL
         /+3zXLS2qaOFDMsqaqBzFLAhPBlTYz/EM99xszc598B/fuZzM9ea9qj79L+xjNISad5r
         eUxB8HtW4ZxYHccmBzymAOywYtFcurY6gOaBaFcRyAkdsI4Ly8UBzFVgKO/zJT6Ulyy2
         IYstD/lFXO3B5HowxI3AlwJq/DA3kbNY3ay8z7xxU+rYmg1PD8UPLUGvdnh/ylL8xY2d
         8ypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764170749; x=1764775549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IdOd/whsaB5ha6Xltts70lCb5PGc5f2tglKc7q062f4=;
        b=az8PxlZPqrgMtXjmTsZHLyMh5dwsh77RqjzZdFVGEDUyji8foRd6MFJZl4fcnJFtZB
         ZeQ8wladauZAYWW/yIxupre/19SRpwEq190JRQ3MjQ5B5hg2EYoZk7YqAD8vJwsvKv2y
         r4iwm1FPtaendNUAEf9NER39oT1VJzap6MNGE2LSUd641e1v+0R0yjWQUjClmsTcXe0h
         Cq7Vrz+jRg3+YXiVjKGdiCZrhGrT/nDQkff5OUYzfGbwfiFTUTC2Y4nKoG7P7L31XGw/
         OUBrJI9iZjLOHHFuygBppbmN9ZNeshZIlU7jT8zNacz3E3CFcbh1b8auXDo4cSkbIVHe
         BuWA==
X-Forwarded-Encrypted: i=1; AJvYcCVfxw34Hh870EkjF0OAhN656Ua9br0y+eRNrxRh+nI8C6rI/+ZhUOWAmyIxgG5mIbzzfBg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuQTfQStnFnC+7mgDDzYvQuk/v8nZL9O7XZKu9Odlqb9VVzobb
	LTD2AIYkjrJqgmaiPBU7pN8F2nFzpS6ZGOHDz1vV/HpUgic5kWtxTHSgMoUF5+l7bMuedOozMaN
	eN4Hw+LeoqiJD5+RsK2lOcFzV6aNxSdZVN2AVh6PNx6iwPvKsw7KGQg==
X-Gm-Gg: ASbGnctJ4NcI/9qY9S3souNyiip81YCW7K0iYi/s6nBlikhfcMm4XddezqtnxHrlCFx
	WhRZ380mZWkTNrfXsWrSZU4I1LiJHWRXCdjbdVkNcwiZjNGbah1qeX/zCRCnRjaWyM/4YEjKicK
	gQBzC0DuMzMELgXqBX0SMnT1Vmv07SsrFgcmPWQb2XNWyeMOc29hrYAkSlUEJUqLD0f87OC9b5z
	GaNMMMKvZgDyDVd2CADQd4ERKTWg+bI/8gJE5USsHes6R/MSybSX4ZLLltP4s4ij6lrcBBFls82
	1gKvTLEMYhz1h5ETWOPeF8IeLNeUbDF2Uyvo9rg7O4+ViSFJT7Oiyx3w1fvQfBQrdLPjkBGB6dE
	wh2BWoREB0IOMXrt3UjtAlHNrpYSIOw==
X-Received: by 2002:a05:6000:2489:b0:42b:3a84:1ee6 with SMTP id ffacd0b85a97d-42e0f22a2c8mr8023534f8f.24.1764170748932;
        Wed, 26 Nov 2025 07:25:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG+KQvLghlDUQh9afZD+PVNCo1iNTuBYw29hyUe/fgigkK4QndBh9YrGoJcdMGDn9uA+ZGhNA==
X-Received: by 2002:a05:6000:2489:b0:42b:3a84:1ee6 with SMTP id ffacd0b85a97d-42e0f22a2c8mr8023493f8f.24.1764170748385;
        Wed, 26 Nov 2025 07:25:48 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e581sm38903906f8f.8.2025.11.26.07.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 07:25:47 -0800 (PST)
Date: Wed, 26 Nov 2025 10:25:44 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	jon@nutanix.com, tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v6 3/8] tun/tap: add synchronized ring
 produce/consume with queue management
Message-ID: <20251126100007-mutt-send-email-mst@kernel.org>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <20251120152914.1127975-4-simon.schippers@tu-dortmund.de>
 <20251125100655-mutt-send-email-mst@kernel.org>
 <4db234bd-ebd7-4325-9157-e74eccb58616@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4db234bd-ebd7-4325-9157-e74eccb58616@tu-dortmund.de>

On Wed, Nov 26, 2025 at 10:23:50AM +0100, Simon Schippers wrote:
> On 11/25/25 17:54, Michael S. Tsirkin wrote:
> > On Thu, Nov 20, 2025 at 04:29:08PM +0100, Simon Schippers wrote:
> >> Implement new ring buffer produce and consume functions for tun and tap
> >> drivers that provide lockless producer-consumer synchronization and
> >> netdev queue management to prevent ptr_ring tail drop and permanent
> >> starvation.
> >>
> >> - tun_ring_produce(): Produces packets to the ptr_ring with proper memory
> >>   barriers and proactively stops the netdev queue when the ring is about
> >>   to become full.
> >>
> >> - __tun_ring_consume() / __tap_ring_consume(): Internal consume functions
> >>   that check if the netdev queue was stopped due to a full ring, and wake
> >>   it when space becomes available. Uses memory barriers to ensure proper
> >>   ordering between producer and consumer.
> >>
> >> - tun_ring_consume() / tap_ring_consume(): Wrapper functions that acquire
> >>   the consumer lock before calling the internal consume functions.
> >>
> >> Key features:
> >> - Proactive queue stopping using __ptr_ring_full_next() to stop the queue
> >>   before it becomes completely full.
> >> - Not stopping the queue when the ptr_ring is full already, because if
> >>   the consumer empties all entries in the meantime, stopping the queue
> >>   would cause permanent starvation.
> > 
> > what is permanent starvation? this comment seems to answer this
> > question:
> > 
> > 
> > 	/* Do not stop the netdev queue if the ptr_ring is full already.
> > 	 * The consumer could empty out the ptr_ring in the meantime
> > 	 * without noticing the stopped netdev queue, resulting in a
> > 	 * stopped netdev queue and an empty ptr_ring. In this case the
> > 	 * netdev queue would stay stopped forever.
> > 	 */
> > 
> > 
> > why having a single entry in
> > the ring we never use helpful to address this?
> > 
> > 
> > 
> > 
> > In fact, all your patch does to solve it, is check
> > netif_tx_queue_stopped on every consumed packet.
> > 
> > 
> > I already proposed:
> > 
> > static inline int __ptr_ring_peek_producer(struct ptr_ring *r)
> > {
> >         if (unlikely(!r->size) || r->queue[r->producer])
> >                 return -ENOSPC;
> >         return 0;
> > }
> > 
> > And with that, why isn't avoiding the race as simple as
> > just rechecking after stopping the queue?
>  
> I think you are right and that is quite similar to what veth [1] does.
> However, there are two differences:
> 
> - Your approach avoids returning NETDEV_TX_BUSY by already stopping
>   when the ring becomes full (and not when the ring is full already)
> - ...and the recheck of the producer wakes on !full instead of empty.
> 
> I like both aspects better than the veth implementation.

Right.

Though frankly, someone should just fix NETDEV_TX_BUSY already
at least with the most popular qdiscs.

It is a common situation and it is just annoying that every driver has
to come up with its own scheme.





> Just one thing: like the veth implementation, we probably need a
> smp_mb__after_atomic() after netif_tx_stop_queue() as they also discussed
> in their v6 [2].

yea makes sense.

> 
> On the consumer side, I would then just do:
> 
> __ptr_ring_consume();
> if (unlikely(__ptr_ring_consume_created_space()))
>     netif_tx_wake_queue(txq);
> 
> Right?
> 
> And for the batched consume method, I would just call this in a loop.

Well tun does not use batched consume does it?


> Thank you!
> 
> [1] Link: https://lore.kernel.org/netdev/174559288731.827981.8748257839971869213.stgit@firesoul/T/#m2582fcc48901e2e845b20b89e0e7196951484e5f
> [2] Link: https://lore.kernel.org/all/174549933665.608169.392044991754158047.stgit@firesoul/T/#m63f2deb86ffbd9ff3a27e1232077a3775606c14d
> 
> > 
> > __ptr_ring_produce();
> > if (__ptr_ring_peek_producer())
> > 	netif_tx_stop_queue
> 
> smp_mb__after_atomic(); // Right here
> 
> > 	if (!__ptr_ring_peek_producer())
> > 		netif_tx_wake_queue(txq);
> > 
> > 
> > 
> > 
> > 
> > 
> > 


