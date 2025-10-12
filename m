Return-Path: <kvm+bounces-59853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C87BD0ADC
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 21:18:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AAB618923F4
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 19:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C83E2F1FD1;
	Sun, 12 Oct 2025 19:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jUYjAVCD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12B81E3DDB
	for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 19:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760296679; cv=none; b=eiRTBz+aBArjOU7e+lTpf9YdhMZL/u5IzT6lNgTxu9Ay3mSoqxRs4T472+gZJjWTPDhPrqNBaUmYtsDQZupNn1B3DbXxXPKY47ltRK22aS3Q3jGVoj5w5rkavnj7sGwA+SBDg4fyJG7E6OLImiNQ9K2PLmxzRokhFOzSNn1LD/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760296679; c=relaxed/simple;
	bh=A3Z0XV+aqR3Bg2mpMrZomWGUcAUm8fgeCMh6RsgVMqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiG4w8Wr07+Bk9BVmJG8OzSQo0D1eafA7kcGXMa00RRlBszZLwA3TObTqDDuXhP8DVK+og5u+5IbQ4erBVHTVWJpUBd53eiIERlzV3mlegGaplIQ4uPStKsveZ72IqPXTneiw70v4L5L8jCYQbc1/dmGWht/bstBUS8jAdLnOuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jUYjAVCD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760296676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v/dR7852yMs8pT9RLFFYNYHUOca2oMO/u0IxKaXqyfA=;
	b=jUYjAVCDWIr9cQINmf7HvRCdNqbr1nBs1zSH7Z7ljLkCUINYlGX6dZJwOV455cXBIHoYwe
	4Yi3O1WjPKmtc7Y+x61wQl9iDMqrSCPENavulNweRuqzGumG2UNvhCd6pbVFaiqzcU7dsf
	8eglZ9XtRK0+fzrjaaFEfrdoFXA66YE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-OymrhVY1Mg-0TGOWXxLAbQ-1; Sun, 12 Oct 2025 15:17:55 -0400
X-MC-Unique: OymrhVY1Mg-0TGOWXxLAbQ-1
X-Mimecast-MFC-AGG-ID: OymrhVY1Mg-0TGOWXxLAbQ_1760296674
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so39722015e9.2
        for <kvm@vger.kernel.org>; Sun, 12 Oct 2025 12:17:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760296674; x=1760901474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/dR7852yMs8pT9RLFFYNYHUOca2oMO/u0IxKaXqyfA=;
        b=EvdRRvmSX4j2aOLnBHJa5YdzaBPDmysTplXBnK6yPTsYyr8NtK+LZukChKV5v5x5Fh
         IGQoIvj3R5PClH1/VQvOlM6WWG1fNm2dYc+Oy3i72agd5ZLg7dN4UbiXdCgzalL7/AG4
         eFegyyN+qtXKVlmX3G2DAc/DVnSzo2b19hR4EeTp36nE7kSlWphmG2cyud53dpyPHnuH
         +BtAXen+jeMEEVg1MmckVua7+MNa9mW2shlvu4Qia5bd3b1r/EvP0JNxj0yjAYuU5E34
         /DdNpYTvkmS8Ro/tCH/HO3fBwi9HkPdfv/HGrCV5N8SvbEHxpSRJx6ZncZZczzAcDQOi
         dwgg==
X-Forwarded-Encrypted: i=1; AJvYcCUXmKdJoY4YXLWOGTH8bBTueiHpstYE7nV1wknOumMd0mUTWAgwzBhgauNTsrueVYwZpII=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv7UZTZk6hrCpyFlQEXxW3s9wtKmnA+nM6Mer7DimR/nF3amEZ
	l+0batlkZu4/caIlX2OMjz3oM9cCRcyf1WHkh9L2xuEAORdWDB96tbYHL0lY9Bs6ARLsMl8NTyv
	5ZSZdem+6yCS4U2lwebqTTzPhDsx8ypWNHZ0epVd+diaM4RWtF7Fpfw==
X-Gm-Gg: ASbGncv+9Np1FzpBzFOXPsKLMjXS//+uTYzzbYYIjOgm/mMANnR1zD7Qm+Vr5uus2Q8
	+UHcbJie1D6F5jnm2P/RtEg20JpbPCa2hwBS2oOP09iqghJcbnYiQBDvaagMzgbvN4FoRnmw+eC
	BYpHqYjxr2yEbQ/vbf471CBNTQxQ7t1XLgSBrvg8PaGqvnU8A0NgXVa1J1Rsp2W3clgxKBrVxdY
	EUNwQ0fhjXBveMiJUMaFwnwdyHw2GOhDTv3MPuXO7MVGMKQVdWN0iGccQdVIH1UWaP/0Jytxz6y
	mS3wTSSq+BdAhouvZKPkjNx/6arW1g==
X-Received: by 2002:a05:600c:4ed0:b0:46e:39e1:fc3c with SMTP id 5b1f17b1804b1-46fa9a8be52mr117921595e9.5.1760296674283;
        Sun, 12 Oct 2025 12:17:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmLezo5h9IdZASkzNABJRNf+q1estWeI7SsZRQXuBRZVVly4xzTsB0yzUTdppy7wFbEkBWcw==
X-Received: by 2002:a05:600c:4ed0:b0:46e:39e1:fc3c with SMTP id 5b1f17b1804b1-46fa9a8be52mr117921495e9.5.1760296673709;
        Sun, 12 Oct 2025 12:17:53 -0700 (PDT)
Received: from redhat.com ([31.187.78.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb4983053sm148394535e9.8.2025.10.12.12.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Oct 2025 12:17:53 -0700 (PDT)
Date: Sun, 12 Oct 2025 15:17:50 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] virtio: dwords->qwords
Message-ID: <20251012151345-mutt-send-email-mst@kernel.org>
References: <cover.1760008797.git.mst@redhat.com>
 <350d0abfaa2dcdb44678098f9119ba41166f375f.1760008798.git.mst@redhat.com>
 <26d7d26e-dd45-47bb-885b-45c6d44900bb@lunn.ch>
 <20251009093127-mutt-send-email-mst@kernel.org>
 <6ca20538-d2ab-4b73-8b1a-028f83828f3e@lunn.ch>
 <20251011134052-mutt-send-email-mst@kernel.org>
 <c4aa4304-b675-4a60-bb7e-adcf26a8694d@lunn.ch>
 <20251012031758-mutt-send-email-mst@kernel.org>
 <36501d9c-9db9-45e6-9a77-1efd530545ee@lunn.ch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36501d9c-9db9-45e6-9a77-1efd530545ee@lunn.ch>

On Sun, Oct 12, 2025 at 04:39:06PM +0200, Andrew Lunn wrote:
> > > DeviceFeaturesSel 0x014
> > > 
> > > Device (host) features word selection.
> > > Writing to this register selects a set of 32 device feature bits accessible by reading from DeviceFeatures.
> > > 
> > > and
> > > 
> > > DriverFeaturesSel 0x024
> > > 
> > > Activated (guest) features word selection
> > > Writing to this register selects a set of 32 activated feature bits accessible by writing to DriverFeatures.
> > > 
> > > I would interpret this as meaning a feature word is a u32. Hence a
> > > DWORD is a u64, as the current code uses.
> > > 
> > > 	Andrew
> > 
> > 
> > Hmm indeed.
> > At the same time, pci transport has:
> > 
> >          u8 padding[2];  /* Pad to full dword. */
> > 
> > and i2c has:
> > 
> > The \field{padding} is used to pad to full dword.
> > 
> > both of which use dword to mean 32 bit.
> > 
> > This comes from PCI which also does not define word but uses it
> > to mean 16 bit.
> 
> Yes, reading the spec, you need to consider the context 'word' is used
> in. Maybe this is something which can be cleaned up, made uniform
> across the whole document?

Yes and thanks for bringing this to my attention.
So MMIO can be "features set selection"

And pci can be "pad to 32 bit".


Less work than defining "word".

> > I don't have the problem changing everything to some other
> > wording completely but "chunk" is uninformative, and
> > more importantly does not give a clean way to refer to
> > 2 chunks and 4 chunks.
> > Similarly, if we use "word" to mean 32 bit there is n clean
> > way to refer to 16 bits which we use a lot.
> > 
> > 
> > using word as 16 bit has the advantage that you
> > can say byte/word/dword/qword and these do not
> > cause too much confusion.
> 
> > So I am still inclined to align everything on pci terminology
> > but interested to hear what alternative you suggest.
> 
> How about something simple:
> 
> #define VIRTIO_FEATURES_DU32WORDS	2
> #define VIRTIO_FEATURES_U32WORDS	(VIRTIO_FEATURES_D32WORDS * 2)
> 
> or, if the spec moves away from using 'word':
> 
> #define VIRTIO_FEATURES_U64S	2
> #define VIRTIO_FEATURES_U32S	(VIRTIO_FEATURES_U32S * 2)
> 
> The coding style says not to use Hungarian notation, but here it
> actually make sense, and avoids the ambiguity in the spec.
> 
> 	Andrew

I mean we can just define number of bits. Open-code / 32 or / 64
as needed. Hmm?


-- 
MST


