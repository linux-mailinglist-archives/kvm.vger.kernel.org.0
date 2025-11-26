Return-Path: <kvm+bounces-64707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C116C8B689
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:16:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C5D4B4E155E
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 18:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F0030ACF0;
	Wed, 26 Nov 2025 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eU4U2cXW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HqrkbP22"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2D2254AE1
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764180987; cv=none; b=a3k7qaD0A2O4tfEcm5XQHSm8OmmF8xEoGtK7WniUkoBid10gJgIWxn3akvaMDyopey2yZc/rm13sOIXR6RIC5aBrc+kSBfIqY82+m1OaS5BHd78I9EXG2B1Wb0w9I6amxpaR3/MqMsZ8Qjny0vu/RuulT+2UQuhCsmfKcLpJWDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764180987; c=relaxed/simple;
	bh=kyULVipYGXF8pQ4S/uAyjcoQp2UuofAj8by9h0Na7sQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZOXCza/RC+ZOnuNAcyjps3jVCZDJ8s/RmzphJR7jamT0BsvLQA9iYd2otuSSVQgdpu38yJDD0RYMfz+DCRjhD/miY5QEHe09BpbFmoZrvxwMhIwxLPe9maTCrRUnn1yG+9sW1Gxo+yegjwi5s5arrigqGU1L5q8DZcNroMwY1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eU4U2cXW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HqrkbP22; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764180984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZzdcbGa6XCDNLwt3NmSWbQLiICgwvwTMHTS5/gnpeU=;
	b=eU4U2cXWqAX1GSpXjRfHwA0fmmArlXaXhaFjlSpNUxRbNsOBSUdXQ9wg0jxQNBtby85PgH
	8SsIvDk06CbFR1vYrNxFCNT/vzHKhOdhOawL7tL0r81U+jibvhXhZIbfsxXxdTy69e4rkm
	P1SJmsdjr7hi19LCPg7DzcjOfkI1Rvs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-8D9bQs-6OBqAwwoEshSDZA-1; Wed, 26 Nov 2025 13:16:12 -0500
X-MC-Unique: 8D9bQs-6OBqAwwoEshSDZA-1
X-Mimecast-MFC-AGG-ID: 8D9bQs-6OBqAwwoEshSDZA_1764180971
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b2c8fb84fso58177f8f.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 10:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764180971; x=1764785771; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qZzdcbGa6XCDNLwt3NmSWbQLiICgwvwTMHTS5/gnpeU=;
        b=HqrkbP22EnIlPIuMwv/ysMJ5ORZZ/yEnOz8KSVbh5j2/olcmJHu8KQ89cP5eAzw3Kn
         c+IRjh/HMiHRpvOHpwBY/rThE6pEeRShEG+l+mUyIksumKFJmXIPl3N4IBorM41ElGFA
         S4Ig3Iz9ZldYiqbcTnIiaoKo00WoZGc7YbkOF4XMU0NQ4X4xbn0yNiQw18Mw2v/j1Nto
         AGkxwiQZ8sPldLdLUx2zhxC24lQYnzzN/IrwvzASL5T+EWloprjfsqQin3VccxbJ6Xqn
         cwr4aQjdHX+pyf/setBL+0x8WYhrdMwky6lU2MsZcNQVcOT3kRsLvPcfJ12bjW23rz/3
         xn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764180971; x=1764785771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qZzdcbGa6XCDNLwt3NmSWbQLiICgwvwTMHTS5/gnpeU=;
        b=Y2JZsiSamMJj8J6deom752yHyPSPsYzVqNWO1Jf5ZXOg7tLotlXZTXXrNscjfPwJVK
         Io6cxi+JF/CoJ413E0jceKmXehM6n3cmssvNZfgmEgb1owOMjB0Gfi7mBJLanT+jQO44
         3bBWu1xTmyjB4e8jHGL1AYgJTkQBV+kc9lR0wjFs1yrgYYPOMQWjOHtfSIYGjDmfmE8R
         AHWLsMULWJIZr3Mkij5ldjhQL00hdYrD42IPTzLdoF5wgvhDnNxzeO7FTEyGALIb8w/j
         NLR1HGiX1FqFU8lx4b8dqVNvcXavEd8EqbkdQV1Z4uJpxCOXAl9t6CAn5v7AqzfvFfDV
         QQtA==
X-Forwarded-Encrypted: i=1; AJvYcCX/6l/KJln7y7L5e1qBUQBnuBn4lD4YfY1Fl4fn6yPKq/Z4pLBXu4W+FcngokOMjkQ6+50=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1vP1KP+h0guo+4kBWBx3MSA6N+v2clg4RwI6w8CyUuQqOuMko
	9fJ6sLZ494ESBBXeG6Yo9y0dhNuGmhsdQ0QrMnQjSL35Ge5CD/n4XD2HW8goJ/nqFdUi0t+0ynn
	wtLbYSKI9nramlfkNUjNW1ZYJixsOPGjU+bBhmvpcVKTCrOdjXCQftQ==
X-Gm-Gg: ASbGnctHIG32mwWOXQrlbMbFfT+OKhL5DpGCtisqZNWkkc1QdO6my2/pMtrzJtYq8KO
	mg6Hsvr4jx141niWvDIRiiWiCvSNtRZjFzrBAKLxFMtNR7LXFJ+fpnVPFzZ7MAECKYPHhs3l25D
	Jzd8HZsjYlrCGwh9k0fZ0QrDqJmZkROV6utQqPB+DR7wD59wQXiOuey05kUwCazVf+0fpG9mtr5
	HEnzf67G6+RgSDIbqCFtVRt2M6rLw6/eE0w00FL/tiOAbPtY38TTC1PxnU8h+Z60Yg49Gqg7lK/
	ASiNerQggcZhdWFsZ/MH3WYLcVutyqVP51FZjl2yaA+YVaGUYvF2WcUoEc2MVoxKhi8qZcDgDa4
	7COi7LeF8JrjcaZgDbgtdMN46Tpn1cQ==
X-Received: by 2002:a05:600c:5252:b0:45d:e28c:875a with SMTP id 5b1f17b1804b1-47904b248demr87345815e9.31.1764180970585;
        Wed, 26 Nov 2025 10:16:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgRL93Ppj04AXVDEje5Q42qgkdWU1MdkDElxcXzRopk1GruOFcZ+Ewr6pGrw/CAbF8TMGXHA==
X-Received: by 2002:a05:600c:5252:b0:45d:e28c:875a with SMTP id 5b1f17b1804b1-47904b248demr87345385e9.31.1764180970053;
        Wed, 26 Nov 2025 10:16:10 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e598sm41453547f8f.4.2025.11.26.10.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 10:16:09 -0800 (PST)
Date: Wed, 26 Nov 2025 13:16:06 -0500
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
Message-ID: <20251126130226-mutt-send-email-mst@kernel.org>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <20251120152914.1127975-4-simon.schippers@tu-dortmund.de>
 <20251125100655-mutt-send-email-mst@kernel.org>
 <4db234bd-ebd7-4325-9157-e74eccb58616@tu-dortmund.de>
 <20251126100007-mutt-send-email-mst@kernel.org>
 <c0fc512a-5bee-48da-9dfb-2b8101f3dec6@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0fc512a-5bee-48da-9dfb-2b8101f3dec6@tu-dortmund.de>

On Wed, Nov 26, 2025 at 05:04:25PM +0100, Simon Schippers wrote:
> On 11/26/25 16:25, Michael S. Tsirkin wrote:
> > On Wed, Nov 26, 2025 at 10:23:50AM +0100, Simon Schippers wrote:
> >> On 11/25/25 17:54, Michael S. Tsirkin wrote:
> >>> On Thu, Nov 20, 2025 at 04:29:08PM +0100, Simon Schippers wrote:
> >>>> Implement new ring buffer produce and consume functions for tun and tap
> >>>> drivers that provide lockless producer-consumer synchronization and
> >>>> netdev queue management to prevent ptr_ring tail drop and permanent
> >>>> starvation.
> >>>>
> >>>> - tun_ring_produce(): Produces packets to the ptr_ring with proper memory
> >>>>   barriers and proactively stops the netdev queue when the ring is about
> >>>>   to become full.
> >>>>
> >>>> - __tun_ring_consume() / __tap_ring_consume(): Internal consume functions
> >>>>   that check if the netdev queue was stopped due to a full ring, and wake
> >>>>   it when space becomes available. Uses memory barriers to ensure proper
> >>>>   ordering between producer and consumer.
> >>>>
> >>>> - tun_ring_consume() / tap_ring_consume(): Wrapper functions that acquire
> >>>>   the consumer lock before calling the internal consume functions.
> >>>>
> >>>> Key features:
> >>>> - Proactive queue stopping using __ptr_ring_full_next() to stop the queue
> >>>>   before it becomes completely full.
> >>>> - Not stopping the queue when the ptr_ring is full already, because if
> >>>>   the consumer empties all entries in the meantime, stopping the queue
> >>>>   would cause permanent starvation.
> >>>
> >>> what is permanent starvation? this comment seems to answer this
> >>> question:
> >>>
> >>>
> >>> 	/* Do not stop the netdev queue if the ptr_ring is full already.
> >>> 	 * The consumer could empty out the ptr_ring in the meantime
> >>> 	 * without noticing the stopped netdev queue, resulting in a
> >>> 	 * stopped netdev queue and an empty ptr_ring. In this case the
> >>> 	 * netdev queue would stay stopped forever.
> >>> 	 */
> >>>
> >>>
> >>> why having a single entry in
> >>> the ring we never use helpful to address this?
> >>>
> >>>
> >>>
> >>>
> >>> In fact, all your patch does to solve it, is check
> >>> netif_tx_queue_stopped on every consumed packet.
> >>>
> >>>
> >>> I already proposed:
> >>>
> >>> static inline int __ptr_ring_peek_producer(struct ptr_ring *r)
> >>> {
> >>>         if (unlikely(!r->size) || r->queue[r->producer])
> >>>                 return -ENOSPC;
> >>>         return 0;
> >>> }
> >>>
> >>> And with that, why isn't avoiding the race as simple as
> >>> just rechecking after stopping the queue?
> >>  
> >> I think you are right and that is quite similar to what veth [1] does.
> >> However, there are two differences:
> >>
> >> - Your approach avoids returning NETDEV_TX_BUSY by already stopping
> >>   when the ring becomes full (and not when the ring is full already)
> >> - ...and the recheck of the producer wakes on !full instead of empty.
> >>
> >> I like both aspects better than the veth implementation.
> > 
> > Right.
> > 
> > Though frankly, someone should just fix NETDEV_TX_BUSY already
> > at least with the most popular qdiscs.
> > 
> > It is a common situation and it is just annoying that every driver has
> > to come up with its own scheme.
> 
> I can not judge it, but yes, it would have made this patchset way
> simpler.
> 
> > 
> > 
> > 
> > 
> > 
> >> Just one thing: like the veth implementation, we probably need a
> >> smp_mb__after_atomic() after netif_tx_stop_queue() as they also discussed
> >> in their v6 [2].
> > 
> > yea makes sense.
> > 
> >>
> >> On the consumer side, I would then just do:
> >>
> >> __ptr_ring_consume();
> >> if (unlikely(__ptr_ring_consume_created_space()))
> >>     netif_tx_wake_queue(txq);
> >>
> >> Right?
> >>
> >> And for the batched consume method, I would just call this in a loop.
> > 
> > Well tun does not use batched consume does it?
> 
> tun does not but vhost-net does.
> 
> Since vhost-net also uses tun_net_xmit() as its ndo_start_xmit in a
> tap+vhost-net setup, its consumer must also be changed. Else
> tun_net_xmit() would stop the queue, but it would never be woken again.


Ah, ok.



> > 
> > 
> >> Thank you!
> >>
> >> [1] Link: https://lore.kernel.org/netdev/174559288731.827981.8748257839971869213.stgit@firesoul/T/#m2582fcc48901e2e845b20b89e0e7196951484e5f
> >> [2] Link: https://lore.kernel.org/all/174549933665.608169.392044991754158047.stgit@firesoul/T/#m63f2deb86ffbd9ff3a27e1232077a3775606c14d
> >>
> >>>
> >>> __ptr_ring_produce();
> >>> if (__ptr_ring_peek_producer())
> >>> 	netif_tx_stop_queue
> >>
> >> smp_mb__after_atomic(); // Right here
> >>
> >>> 	if (!__ptr_ring_peek_producer())
> >>> 		netif_tx_wake_queue(txq);
> >>>
> >>>
> >>>
> >>>
> >>>
> >>>
> >>>
> > 


