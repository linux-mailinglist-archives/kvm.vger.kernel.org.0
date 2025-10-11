Return-Path: <kvm+bounces-59804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D64BCFA58
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 19:43:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFFD91898C47
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 17:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C42283FE6;
	Sat, 11 Oct 2025 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SGrLl8zV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1044A2836A3
	for <kvm@vger.kernel.org>; Sat, 11 Oct 2025 17:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760204575; cv=none; b=TTh+jHpK3er31Tixo3lZh+iRqHO2cuDvorOejF4D/ALcTtk/FdfVe9ahNxphCl/xTfu+aP+gd8lzFvBYDQe4/p7jkwjS7Nu1rHKCDb8pVeZSEEVqakRwLp4C8XRp2lS39bnbDdvHzMwMpOPxZx6/YAWXIA9IjREEOnEmcKBw8U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760204575; c=relaxed/simple;
	bh=+XORBWOfOoSgbPifqtxEJHlGrWYpXTS+d55JX3wMoO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgDPcBpaI5VzEuttt/dWHcPVJHwo3jzwE+oGpkt4zVuqmp52gy3/T3jirF7c4y1ZGRlAis7BmaswiZfyj2RrkhWCpUy1gmgVqy+PzyMv0kMVpHVxzMSowhQjFzG0YfF+hYahYObRoF/EiVWYO4v9SUcsp9aNWfX/2UjW2C68iqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SGrLl8zV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760204572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=THkkeCujAz7WFSbw0zVRRMF8zd65cL2y27OLjm1PRmo=;
	b=SGrLl8zVFg2y3BOgypXrpBk0Vu0jQvERbSXjHLE8OKcBj/OSBW/kYwD6WpEWKR5NjeLaHB
	40Zt6ypgirWyPBZWC2olY+H+ACbW/m5rJqzzuNWt5aBLHnMwev314tyCqCCCuPQcOylqIM
	We7lXySOSn6QwVFKoQJ5K5B+ytHHvPs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-FmfKIuH6MTmodT_LLR-8TQ-1; Sat, 11 Oct 2025 13:42:50 -0400
X-MC-Unique: FmfKIuH6MTmodT_LLR-8TQ-1
X-Mimecast-MFC-AGG-ID: FmfKIuH6MTmodT_LLR-8TQ_1760204569
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e41c32209so15032255e9.0
        for <kvm@vger.kernel.org>; Sat, 11 Oct 2025 10:42:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760204569; x=1760809369;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THkkeCujAz7WFSbw0zVRRMF8zd65cL2y27OLjm1PRmo=;
        b=kdS8gDvXZCs5ki9z2JfwcR2Q6KyXRQdIvDEfN73NmaUgsw87EpD9j/QiKaxtUzvTut
         tPokvcEUmlBJRIyrAAf5lo2UJiYno0+tJbLOSpl60dX/+ZY+xJEtl/lk+HQ2llvIZCZL
         9IoWVznhyzCcGmH+lgrd/gwCLuWUVGwxfJVa+ZsQfi4m5LXp/Emz8SorQRuxzybrpuMM
         t7ODDcEbB41oZgWkoopFpEjcegS9D83xmAFmnh8JFPwkI8LUT3gm4omPjSFW8n1RglEq
         gvf9EDCgpY1LOAdmzgWMVkpgjuwXXhZhK3lY0jm/8jGOCDJbEOHhMSqFAUuyzHRSd2x5
         KYBw==
X-Forwarded-Encrypted: i=1; AJvYcCXO7t/JKWwc52WbL08uJqxP9cw2/ldIizBh46l3UX7WwlfUnSygZqNR0xr6yCiZZue2dhw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDHlUGLfXv/4I1BljheZWU/oRZSTtKzKtw3wpNs8KEY/Sv2ejI
	KbptEOd35c9mDlWHQGnwbPZ2DmPEeaLODfeGMcqyTAdSXtvO08ypMUcn3m1Z7G/S1vjyS5qtg4e
	BkkyoZ6py2CUpqDz3XqP3kDLRc43iH7ebAqrSXarGKt5u3Aspj8O0Lw==
X-Gm-Gg: ASbGncso7QJH0FzHJizJ67hERxacazET+J0y5tZEzC8KR8ZsIGCK5KkqQdylCFuTHfT
	U2g7tt8Ru/Lxi2hhbdbBME6MKZdxH1AJKB3D6Am5rO6Yqdrd2KY7wtpkCe2ZeJeEKmUNBWHpV29
	3eT13PFEBR2CnAjdoulsU6w67AYR+IEv+KxsQquUu9cbumqx9Lq5OcE7Xw0r/pAeg3JYTeSSUqP
	tzVcpB7QpwCLkOWgTjExP0570bsOpkmW1kOQPnEYP+9ZLwiAHmV2e7Qe+p4EgA8+tSWcfL3nDY4
	NT1HYyJ/zLDBqwH/oRhiuRLOQgzLo4etjcU=
X-Received: by 2002:a05:600c:5247:b0:46f:b340:75e7 with SMTP id 5b1f17b1804b1-46fb34075efmr67029445e9.8.1760204569315;
        Sat, 11 Oct 2025 10:42:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLanRjSPD2Xtlxm8R6qQutwfzZwiu2kRm9erxJSoygqMN52KcMygCW4j6dhl5fQ2CtN6pGVA==
X-Received: by 2002:a05:600c:5247:b0:46f:b340:75e7 with SMTP id 5b1f17b1804b1-46fb34075efmr67029165e9.8.1760204568694;
        Sat, 11 Oct 2025 10:42:48 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab36cc32sm88406675e9.0.2025.10.11.10.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Oct 2025 10:42:48 -0700 (PDT)
Date: Sat, 11 Oct 2025 13:42:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] virtio: dwords->qwords
Message-ID: <20251011134052-mutt-send-email-mst@kernel.org>
References: <cover.1760008797.git.mst@redhat.com>
 <350d0abfaa2dcdb44678098f9119ba41166f375f.1760008798.git.mst@redhat.com>
 <26d7d26e-dd45-47bb-885b-45c6d44900bb@lunn.ch>
 <20251009093127-mutt-send-email-mst@kernel.org>
 <6ca20538-d2ab-4b73-8b1a-028f83828f3e@lunn.ch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ca20538-d2ab-4b73-8b1a-028f83828f3e@lunn.ch>

On Sat, Oct 11, 2025 at 07:25:55PM +0200, Andrew Lunn wrote:
> On Thu, Oct 09, 2025 at 09:37:20AM -0400, Michael S. Tsirkin wrote:
> > On Thu, Oct 09, 2025 at 02:31:04PM +0200, Andrew Lunn wrote:
> > > On Thu, Oct 09, 2025 at 07:24:08AM -0400, Michael S. Tsirkin wrote:
> > > > A "word" is 16 bit. 64 bit integers like virtio uses are not dwords,
> > > > they are actually qwords.
> > > 
> > > I'm having trouble with this....
> > > 
> > > This bit makes sense. 4x 16bits = 64 bits.
> > > 
> > > > -static const u64 vhost_net_features[VIRTIO_FEATURES_DWORDS] = {
> > > > +static const u64 vhost_net_features[VIRTIO_FEATURES_QWORDS] = {
> > > 
> > > If this was u16, and VIRTIO_FEATURES_QWORDS was 4, which the Q would
> > > imply, than i would agree with what you are saying. But this is a u64
> > > type.  It is already a QWORD, and this is an array of two of them.
> > 
> > I don't get what you are saying here.
> > It's an array of qwords and VIRTIO_FEATURES_QWORDS tells you
> > how many QWORDS are needed to fit all of them.
> > 
> > This is how C arrays are declared.
> > 
> > 
> > > I think the real issue here is not D vs Q, but WORD. We have a default
> > > meaning of a u16 for a word, especially in C. But that is not the
> > > actual definition of a word a computer scientist would use. Wikipedia
> > > has:
> > > 
> > >   In computing, a word is any processor design's natural unit of
> > >   data. A word is a fixed-sized datum handled as a unit by the
> > >   instruction set or the hardware of the processor.
> > > 
> > > A word can be any size. In this context, virtio is not referring to
> > > the instruction set, but a protocol. Are all fields in this protocol
> > > u64? Hence word is u64? And this is an array of two words? That would
> > > make DWORD correct, it is two words.
> > > 
> > > If you want to change anything here, i would actually change WORD to
> > > something else, maybe FIELD?
> > > 
> > > And i could be wrong here, i've not looked at the actual protocol, so
> > > i've no idea if all fields in the protocol are u64. There are
> > > protocols like this, IPv6 uses u32, not octets, and the length field
> > > in the headers refer to the number of u32s in the header.
> > > 
> > > 	Andrew
> > 
> > 
> > Virtio uses "dword" to mean "32 bits" in several places:
> 
> It also uses WORD to represent 32 bits:


That's not spec, that's linux driver. The spec is the source of truth.


> void
> vp_modern_get_driver_extended_features(struct virtio_pci_modern_device *mdev,
> 				       u64 *features)
> {
> 	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
> 	int i;
> 
> 	virtio_features_zero(features);
> 	for (i = 0; i < VIRTIO_FEATURES_WORDS; i++) {
> 		u64 cur;
> 
> 		vp_iowrite32(i, &cfg->guest_feature_select);
> 		cur = vp_ioread32(&cfg->guest_feature);
> 		features[i >> 1] |= cur << (32 * (i & 1));
> 	}
> }
> 
> And this is a function dealing features. So this seems to suggest a
> WORD is a u32, when dealing with features.

This is very recent with Paolo's patches/
That's exactly why my patches fix it.

> A DWORD would thus be a
> u64, making the current code correct.
> 
> As i said, the problem here is WORD. It means different things to
> different people. And it even has different means to different parts
> of the virtio code, as you pointed out.
>
>
> 
> If we want to change anything here, i suggest we change WORD to
> something else, to try to avoid the problem that word could be a u16,
> u32, or even a u42, depending on where it is used.
> 
> 	Andrew



