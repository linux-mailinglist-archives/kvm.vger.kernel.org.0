Return-Path: <kvm+bounces-65967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EA5CBE427
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5A7330DF026
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 14:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B6A33BBA5;
	Mon, 15 Dec 2025 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SyAaXabP";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Km5bXhrt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5634E3B8D78
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 14:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765808137; cv=none; b=YvPsXN84yZ+UvdS+Gyrrt1Se1hawaVHMsPCIe0KJ5XVV5uY6geYtoAO7T7HzE8gdVwTbaqhXOAqn2iRWJw0jpaN3CLArWfNHpJhBCBEctOVCQEuQy7YPzwxNQZGProeLHqhFBlbuSx2iD37TiHjiPtcALtRThPkQrgSsXqa8K2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765808137; c=relaxed/simple;
	bh=XCaTRYYtdjBnDMmtW6LMz2eDeLZgPQs0Zj1KdxrUzfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oLf6fSWHNFYb4Bg3Poef64of4lbXpZ7uptnKnB5WsHqAB8HRFlMGqG1xgLk9D+E2pNltB8dDVR4czibD/4UzZwRDe/6y9kx09kkhepHY8lcd6SoyaqAUSZR+fhc9tO42gRo3ECUf6jYEjKVx2N9TAPm5Qqjdj5P/PpkVv3KSodo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SyAaXabP; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Km5bXhrt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765808134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L49NIO1n5q1751W/k8gzxOpfDxRxrpcTIrbILgaPsTg=;
	b=SyAaXabPOew/UPzAF/9JpNlLNz85XzGdgrkLONai9PtUh5eZApVGEp9AV4XQ8c9RB0w9mM
	n7ymdzNq9umdUU5BK9+voxi5jg7YbE7L7aBQy1y7GvwtXOsscHjbzppIFb7wsee3Rb7kD7
	fs4kXJPhh6IU1eAm39TjAvqwAqeQR+w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-PHhl2XCMMDKWSU03xldCZw-1; Mon, 15 Dec 2025 09:15:33 -0500
X-MC-Unique: PHhl2XCMMDKWSU03xldCZw-1
X-Mimecast-MFC-AGG-ID: PHhl2XCMMDKWSU03xldCZw_1765808132
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47a83800743so17182825e9.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 06:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765808132; x=1766412932; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L49NIO1n5q1751W/k8gzxOpfDxRxrpcTIrbILgaPsTg=;
        b=Km5bXhrtdN2KikWd5IIL/6aCY0asNiWVxdAlBBlZjrJb2H2uFyl9cjXpr7SIT1H6aN
         kiVx7sThAasJcTGofSio393QL5u5TRIweCFugqMDVqMltC2m45BDMLKFlA7JUodU2JKJ
         DNhNXMf1K9BAfTl4C8BrBQ4OdC0E1Ww0ye/vm0tJOLzgb0cM9DsYupvh3DX10ACJBkoy
         VbZLSci7zcab5NE0LIsojyBPYlYOWXic1mTSDup4k/BCI7Laz2ijBKOYl5gsSPE6XcmV
         oTJ4yRJXoQhcJN/Kq47oRp6Rjr65n4gsTKJLX/65ugJtOVCPtPb6VkmeKC4F+cvmCtBX
         pV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765808132; x=1766412932;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L49NIO1n5q1751W/k8gzxOpfDxRxrpcTIrbILgaPsTg=;
        b=QPu5IxHd/vd5qUmh1C2OiLk6WJxNB/aj/BWxvO0MIwhKpEapFGjp3QFA42DoCqikEF
         ygTiEsSf490tLD+ybJBteIBDXHcv6lFQ9zN6FHE6jkX0btmZBRmukBCU5UOCc/3phrLK
         MRFNjz3/WVxYIGTYao+n0TSTIJvI75Yq0f/sReJ1g+PDSG+F+Fcj8zVh0ac4UFo5+bb1
         WimHU0JqtTvv863mvZiE8x+/jXGN1zIOsEh1MxYPFmPZuUNiUxQ5spk0Fb3c/lB9V7X2
         tj77ewY4YnR7tbgQPzBk7h0/ybWUq48Ff+9YKZGIUdV8YjRvFTWmS0LxFU6IYetGbTrC
         5VZw==
X-Forwarded-Encrypted: i=1; AJvYcCV82aCWis40w8yb52/J9z+bbTjMG2GBF4mimF6u9+Z6wyOQ1Iu5KQZKnXlVyQSmvMlCQIY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1gfONsoKbBKXwnjrMdIK0Fnj8D1GBGIiRbBeU0v2y2OW5bLZ2
	LFKrRZ0Se9lD2xT6IIjx7gXl3Ff7901Su/+GttFvZ0oG/0FMa1wUq2rZGJq6AZNaIfchfYoF4pT
	yybp1/DfylWLV4vXSZTHinVt5M/B8ErVIfM1zgA1xqs45/iaziWQ95w==
X-Gm-Gg: AY/fxX4jWfQeqWemqkzXJ2L5iCKlNye34WzAZb7VAHRNqKDMUJMqmzIm6fiPAVmU+Bc
	zES1Nt7O89JVsc0Mt5qjLwT02MUeWmwldxblN5Z1V3J+Y0GmJTsPYpnI+aZBlyQ6tvp2Lc7sj7A
	dEOT/lrYcBNGBPBqquvpG9c7Od7oWEvOPohLhVDBPTVHMxRUGP+Me5LR8onIaJSx51HewxcmNuj
	0njINoWGMV6+2xFbkC/LI64CSiM7VbNICOI6WjWI/ZI92WWit5hM+j/1lqgbjukAyT4IAL+4vrA
	G1ryjn41xKatW38aZ6NSY83zTHUKmjCEg0jRAU5opOPlH/W6+iiSvr33pJYQPk7s2h/dA+Xwujm
	sOmt7m6Pwc1qJdG4K
X-Received: by 2002:a05:600c:c0d2:10b0:477:9cec:c83e with SMTP id 5b1f17b1804b1-47a89d9c2f9mr119399505e9.1.1765808132060;
        Mon, 15 Dec 2025 06:15:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnn39+IGc8T4gbIMiapFrAkLpdN3U9Oa1ixlw3v9TO5MUF+UqsPDl1fUxMRulxmuHP3h3NgA==
X-Received: by 2002:a05:600c:c0d2:10b0:477:9cec:c83e with SMTP id 5b1f17b1804b1-47a89d9c2f9mr119399175e9.1.1765808131556;
        Mon, 15 Dec 2025 06:15:31 -0800 (PST)
Received: from sgarzare-redhat ([193.207.203.161])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f8e90f2sm186130175e9.13.2025.12.15.06.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 06:15:30 -0800 (PST)
Date: Mon, 15 Dec 2025 15:15:22 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, stefanha@redhat.com, 
	kvm@vger.kernel.org, netdev@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	eperezma@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org
Subject: Re: [PATCH net v3] vsock/virtio: cap TX credit to local buffer size
Message-ID: <wssxyvbgq3a3icydzxsbj5bliqd67xreffaqqusfia2suxrjdk@gcke3jemvycx>
References: <20251211125104.375020-1-mlbnkm1@gmail.com>
 <20251211080251-mutt-send-email-mst@kernel.org>
 <zlhixzduyindq24osaedkt2xnukmatwhugfkqmaugvor6wlcol@56jsodxn4rhi>
 <CAMKc4jDpMsk1TtSN-GPLM1M_qp_jpoE1XL1g5qXRUiB-M0BPgQ@mail.gmail.com>
 <CAGxU2F7WOLs7bDJao-7Qd=GOqj_tOmS+EptviMphGqSrgsadqg@mail.gmail.com>
 <CAMKc4jDLdcGsL5_d+4CP6n-57s-R0vzrX2M7Ni=1GeCB1cxVYA@mail.gmail.com>
 <bwmol6raorw233ryb3dleh4meaui5vbe7no53boixckl3wgclz@s6grefw5dqen>
 <deccf66c-dcd3-4187-9fb6-43ddf7d0a905@gmail.com>
 <tandvvk6vas3kgqjuo6w3aagqai246qxejfnzhkbvbxds3w4y6@umqvf7f3m5ie>
 <24b9961d-7e0d-4239-97b3-39799524909f@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24b9961d-7e0d-4239-97b3-39799524909f@gmail.com>

On Sun, Dec 14, 2025 at 06:38:22AM +0000, Melbin K Mathew wrote:
>
>
>On 12/12/2025 12:26, Stefano Garzarella wrote:
>>On Fri, Dec 12, 2025 at 11:40:03AM +0000, Melbin K Mathew wrote:
>>>
>>>
>>>On 12/12/2025 10:40, Stefano Garzarella wrote:
>>>>On Fri, Dec 12, 2025 at 09:56:28AM +0000, Melbin Mathew Antony wrote:
>>>>>Hi Stefano, Michael,
>>>>>
>>>>>Thanks for the suggestions and guidance.
>>>>
>>>>You're welcome, but please avoid top-posting in the future:
>>>>https://www.kernel.org/doc/html/latest/process/submitting- 
>>>>patches.html#use-trimmed-interleaved-replies-in-email-discussions
>>>>
>>>Sure. Thanks
>>>>>
>>>>>I’ve drafted a 4-part series based on the recap. I’ve included the
>>>>>four diffs below for discussion. Can wait for comments, iterate, and
>>>>>then send the patch series in a few days.
>>>>>
>>>>>---
>>>>>
>>>>>Patch 1/4 — vsock/virtio: make get_credit() s64-safe and clamp 
>>>>>negatives
>>>>>
>>>>>virtio_transport_get_credit() was doing unsigned arithmetic; if the
>>>>>peer shrinks its window, the subtraction can underflow and look like
>>>>>“lots of credit”. This makes it compute “space” in s64 and clamp < 0
>>>>>to 0.
>>>>>
>>>>>diff --git a/net/vmw_vsock/virtio_transport_common.c
>>>>>b/net/vmw_vsock/virtio_transport_common.c
>>>>>--- a/net/vmw_vsock/virtio_transport_common.c
>>>>>+++ b/net/vmw_vsock/virtio_transport_common.c
>>>>>@@ -494,16 +494,23 @@ 
>>>>>EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
>>>>>u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, 
>>>>>u32 credit)
>>>>>{
>>>>>+ s64 bytes;
>>>>> u32 ret;
>>>>>
>>>>> if (!credit)
>>>>> return 0;
>>>>>
>>>>> spin_lock_bh(&vvs->tx_lock);
>>>>>- ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>>>>>- if (ret > credit)
>>>>>- ret = credit;
>>>>>+ bytes = (s64)vvs->peer_buf_alloc -
>>>>
>>>>Why not just calling virtio_transport_has_space()?
>>>virtio_transport_has_space() takes struct vsock_sock *, while 
>>>virtio_transport_get_credit() takes struct virtio_vsock_sock *, so 
>>>I cannot directly call has_space() from get_credit() without 
>>>changing signatures.
>>>
>>>Would you be OK if I factor the common “space” calculation into a 
>>>small helper that operates on struct virtio_vsock_sock * and is 
>>>used by both paths? Something like:
>>
>>Why not just change the signature of virtio_transport_has_space()?
>Thanks, that is cleaner.
>
>For Patch 1 i'll change virtio_transport_has_space() to take
>struct virtio_vsock_sock * and call it from both
>virtio_transport_stream_has_space() and virtio_transport_get_credit().
>
>/*
> * Return available peer buffer space for TX (>= 0).
> *
> * Use s64 arithmetic so that if the peer shrinks peer_buf_alloc while
> * we have bytes in flight (tx_cnt - peer_fwd_cnt), the subtraction does
> * not underflow into a large positive value as it would with u32.
> *
> * Must be called with vvs->tx_lock held.
> */
>static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs)
>{
>	s64 bytes;
>
>	bytes = (s64)vvs->peer_buf_alloc -
>		((s64)vvs->tx_cnt - (s64)vvs->peer_fwd_cnt);

wait, why casting also the counters?
they are supposed to wrap, so should be fine to avoid the cast there.

Please, avoid too many changes in a single patch.

>	if (bytes < 0)
>		bytes = 0;
>
>	return bytes;
>}
>
>s64 virtio_transport_stream_has_space(struct vsock_sock *vsk)
>{
>	struct virtio_vsock_sock *vvs = vsk->trans;
>	s64 bytes;
>
>	spin_lock_bh(&vvs->tx_lock);
>	bytes = virtio_transport_has_space(vvs);
>	spin_unlock_bh(&vvs->tx_lock);
>
>	return bytes;
>}
>
>u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
>{
>	u32 ret;
>
>	if (!credit)
>		return 0;
>
>	spin_lock_bh(&vvs->tx_lock);
>	ret = min_t(u32, credit, (u32)virtio_transport_has_space(vvs));

min_t() is supposed to be use exactly to avoid to cast each member, so 
why adding the cast to the value returned by 
virtio_transport_has_space() ?

>	vvs->tx_cnt += ret;
>	vvs->bytes_unsent += ret;
>	spin_unlock_bh(&vvs->tx_lock);
>
>	return ret;
>}
>
>Does this look right?

Pretty much yes, a part some comments, but I'd like to see the final 
solution.

Thanks,
Stefano


