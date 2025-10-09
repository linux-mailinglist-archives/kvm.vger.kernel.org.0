Return-Path: <kvm+bounces-59715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A294ABC9230
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 14:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD8133E4029
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 12:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994EB2E5B05;
	Thu,  9 Oct 2025 12:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EmD0KM70"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6ED26FA5E
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 12:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760014466; cv=none; b=DmucNDVhVTRxvm3RqhxPP/NSxKOUvjPCwzh0/0Zatf+I9xbvCw0U30gbaqeMfDI4x3V4KIv7XQPzEBgDAzIuBXQ03UA8u5sdeYX89DUVvgvk6/01RrJiw6PALPMhsKYt7kVv6NzfnW3sf0bEv5kUTcgaHP8uTICqjf2U8VWt3LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760014466; c=relaxed/simple;
	bh=d+WHqjD1e2xfxGWREFy8UIQh97c1/2BfHbOxP9RKa5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJ+A+U9OcM+4TpqHFFgIygTceXCkl9Ke9xUy+zzlEWLY50mr5TqcHOKyH47Lw1H/jG3uTTn5ompiuobtchCm5bSB348PY0z+m2Tzjrz3pJOujzOJR0VDqT6vywZg4bY2SKp96jhAgAI4c09ZxKKx1R4rsvixSO41q6ssSPs1n0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EmD0KM70; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760014464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sLVQWh+Znqw6JAYRNwQHXL1TFNSvZ0jniZ0MloD7+Hg=;
	b=EmD0KM70H+qEk6u1/odi44dhRuJ0K//SKUto1pWqhyzf2GbFFVJmOcA8n6hUqUnRG6J3QU
	V66IpEO7gxhbE/i6C5sVV7N2ypZ3zouB0z9/KPZJgawI7PqZe+yQy/OwGtLxTN2i6OM0NW
	IXwE7TQyw4TJTlhVRtezBhSW0uiMgHA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-N5RDkZ6WN-SaMaN9NuNkYw-1; Thu, 09 Oct 2025 08:54:23 -0400
X-MC-Unique: N5RDkZ6WN-SaMaN9NuNkYw-1
X-Mimecast-MFC-AGG-ID: N5RDkZ6WN-SaMaN9NuNkYw_1760014462
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-870d82c566fso302805385a.1
        for <kvm@vger.kernel.org>; Thu, 09 Oct 2025 05:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760014462; x=1760619262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLVQWh+Znqw6JAYRNwQHXL1TFNSvZ0jniZ0MloD7+Hg=;
        b=FLwfxm9egw5V5m2KKdq4BCRlHrgXwwPQ7S0mVjOcNWu3VrzUoTJCRN97+mxB3kl7sq
         1ad3DuzArLlfPnDUbvr6MWfIw3z5PX+F97Hgbg38HZh0Z6h4XThYkt35QrdhUssXqii+
         elcCPk63UNYtplxbpN6ZLzJ8xfnw5ejvuMk5pxyR4RSNFyzDH2H0pbhSv5rZoZlRmXS/
         H2V4MrbQZ+RHRQiO9q1f1DcZ/Lm+5k4OPTYuSamdCsVQjFq0y7vR7ug9bjJrTa93cnOT
         SpsV7PAo1e5BEVXzrl+uWZiukA/JITZh+3i8OUm0w0IxNbdvPfeOEEf6Y+qgwqelr1OU
         FbOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuY4LExAF6ujrUfEOFEBWIUJ3m0r2wrrbLpuD6epvsAJrmOGK1ODSB5J9hLORc76qxwxg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyahXVwIKFxiTNkU5WisZII3gCq5ynKBem2H/BPPp5e5H1fJW+E
	rcAEQLpTNQ6JvhBtSKFmDefZgZo7sR+Ssx+cuu9F1pyJQbE83aYgOAW7YTbZRjrNr+wg3fzWZGb
	hFLG05h1U0WRTNNOeIqoLDk6o/Hh+lmvJo62sAM8Kw1tGL4IiHbpFUQ==
X-Gm-Gg: ASbGnctOqT3BSu5WDoduA/MBtNouKtMiYmoxcUQ7PMcKQgJUMez3pOwu3lUpA8F0gSr
	b4nEFYX1M1RuxkGZVVRpeTlt7C5sR8RHia2kT3DR+vjTH4omM7FZK4WZrT2V8a5A27VD9JM5pCd
	+gJqfK8jcIrKHutSuPOGb6URNOCBFX9F1AkV8mAcLPRmaRJJXpTMIi1tpnS0nPlwLql8pJXQ/kR
	yrIojUERimBgCuQtANFc29HjknOqarcePjVRh84JqCSry3DwuJkYdy9coL2JK3LvxwHKKCLEXT3
	3PmT3vp77ZKKV0SjkfHqidOW1OXRufDhXgs=
X-Received: by 2002:a05:620a:269f:b0:82b:5e2e:bc46 with SMTP id af79cd13be357-8820d18e350mr1885885085a.35.1760014461565;
        Thu, 09 Oct 2025 05:54:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqMpvtMJcanZP3rlvKbgdpkQAf5WVURwTPSiw1JSFVgNS1mLi/kxcHSU28QD1hy96VkYKztg==
X-Received: by 2002:a05:620a:269f:b0:82b:5e2e:bc46 with SMTP id af79cd13be357-8820d18e350mr1885875985a.35.1760014460576;
        Thu, 09 Oct 2025 05:54:20 -0700 (PDT)
Received: from redhat.com ([138.199.52.81])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8849f9ad8dasm190766385a.21.2025.10.09.05.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 05:54:20 -0700 (PDT)
Date: Thu, 9 Oct 2025 08:54:15 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH 3/3] vhost: use checked versions of VIRTIO_BIT
Message-ID: <20251009085057-mutt-send-email-mst@kernel.org>
References: <cover.1760008797.git.mst@redhat.com>
 <6629538adfd821c8626ab8b9def49c23781e6775.1760008798.git.mst@redhat.com>
 <d4fcd2d8-ac84-4d9f-a47a-fecc50e18e20@lunn.ch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4fcd2d8-ac84-4d9f-a47a-fecc50e18e20@lunn.ch>

On Thu, Oct 09, 2025 at 02:47:53PM +0200, Andrew Lunn wrote:
> On Thu, Oct 09, 2025 at 07:24:16AM -0400, Michael S. Tsirkin wrote:
> > This adds compile-time checked versions of VIRTIO_BIT that set bits in
> > low and high qword, respectively.  Will prevent confusion when people
> > set bits in the wrong qword.
> > 
> > Cc: "Paolo Abeni" <pabeni@redhat.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/vhost/net.c             | 4 ++--
> >  include/linux/virtio_features.h | 9 +++++++++
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index 43d51fb1f8ea..8b98e1a8baaa 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -76,8 +76,8 @@ static const u64 vhost_net_features[VIRTIO_FEATURES_QWORDS] = {
> >  	(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> >  	(1ULL << VIRTIO_F_RING_RESET) |
> >  	(1ULL << VIRTIO_F_IN_ORDER),
> > -	VIRTIO_BIT(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
> > -	VIRTIO_BIT(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),
> > +	VIRTIO_BIT_HI(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO) |
> > +	VIRTIO_BIT_HI(VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO),
> 
> How any bits in vhost_net_features are currently in use?

68

> How likely is
> it to go from 2x 64bit words to 3x 64 bit words?

Maybe.

> Rather than _LO, _HI,
> would _1ST, _2ND be better leaving it open for _3RD?

I can just open-code

	VIRTIO_BIT_QWORD(VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO, 1)


> I would also be tempted to rename these macros to include _LO_ and
> _HI_ in them. VIRTIO_BIT_HI(VIRTIO_LO_F_IN_ORDER) is more likely to be
> spotted as wrong this way.

Hmm but with my macros compiler will warn so why uglify then?


> An alternative would be to convert to a linux bitmap, which is
> arbitrary length so you just use bit number and leave the
> implementation to map that to the correct offset in the underlying
> data structure.
> 
> 	Andrew

Right but it's a bit more work as we then have to change
all drivers. Not ruling this out, but this patchset
is not aiming that high.

-- 
MST


