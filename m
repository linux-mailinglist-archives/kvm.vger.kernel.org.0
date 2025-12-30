Return-Path: <kvm+bounces-66843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 840C1CE9C24
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 14:13:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72FDD301EC67
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 13:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0109F224891;
	Tue, 30 Dec 2025 13:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eLal6/B4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EntBm+Mc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1EA3BBF0
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 13:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767100376; cv=none; b=q/vjg5/CiOdkOyytX5N2DIqQcc3G6AWvFmwrZMVZtI2NVYkAZzKoozT11TyBX7UPPxDZ1ubQrXxn5dw9lyh7oNkGcCHCi/i66uTPAmu4IUSVxu8pz3QFqeMACqgMtTJPCG8sXnH4gOn0PjvZVtYAqpqkvHE0EumcbAboQ0J4ld4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767100376; c=relaxed/simple;
	bh=yshyoaf7aBfz+NMN2fw0sj4I02giqCATUhq7XTqk+IU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GB4KfZHn3eZpfVuVUpAO0mru49oew53kRYDpO46SFNkzJie8aFn+rR+gDO5mDIPxm2pA7ydagx8rpXjXPEWOLIyC2tS9/Gbo2GD/1t0B1Khy2Wodsvi3bVrjFU75qwNxQU6x9BxaYTEqEF3rdyhzB1JP3FZBQ0qnDqwwtWL6srQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eLal6/B4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EntBm+Mc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767100373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q4qKNRGg/6WWGMgB9lM5TR4Ah2AajR+atlTUoRuUE38=;
	b=eLal6/B4bmhInI0kPTvVc7x81z7Z6LCHMv2VLD20EL3hJFpHBJ8MeEbNlLbnU2gfsvPKMA
	E3IxGNbzjenyt3efh8cKV4t00Ej+V7vzN67a8hr92Otcei3V7hVtsFpNFb0AXLeOprHNr7
	L4cJYDEuvHKR9usda51MQ5oiAmtw3KM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-pNXWKY6cPVanAvtyykKyQw-1; Tue, 30 Dec 2025 08:12:52 -0500
X-MC-Unique: pNXWKY6cPVanAvtyykKyQw-1
X-Mimecast-MFC-AGG-ID: pNXWKY6cPVanAvtyykKyQw_1767100371
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-431026b6252so9520842f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 05:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767100371; x=1767705171; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q4qKNRGg/6WWGMgB9lM5TR4Ah2AajR+atlTUoRuUE38=;
        b=EntBm+McV7HllHm+mFVyEC9OdBlQTd9qDClzOeN1Ko0SHk8AzxPEhnAH8v7fcdFigP
         356Y5XAcoMkgrX71IqOftJT1Bv/7smE4gQ7FU1nNOAX8XccCgDuZ6d7QquSPbRXPJYm2
         KCmttkYerhh3qyPYrkmKYq0kPFVEekquFEan9CRDxBpORKANjmDnAEK91ocK28IPrdwY
         HcURfEmCIW7iL9VVugkDqV7FS7Ca/XLwS61fyihu9HgNgrucTuNE2q5TgouJ2sfjH25e
         sKprYyXvjCixz7hNKnlfycIC1b99WiuknF1AkhQ+fdUAba2Mx4b7h/2M44NsSXeeNXXj
         v7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767100371; x=1767705171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q4qKNRGg/6WWGMgB9lM5TR4Ah2AajR+atlTUoRuUE38=;
        b=tCqs6GSAjQYNSBa0sy1Qf17roR6mvABfxlMsMqc3a7t5yh236lAMhJBzpdNZ8CMvWd
         fG40Lt1yhOz9kJQO/DTulJc/MWzNBNtV7Fmudibec7bFloZgBBzWER7kekLkKucNdz3O
         H9Re4s/GwPbFOLMH+/W8dzvdw9K1fi+M329f0aG3zP34dE2pVk5sQ2GNsF88S94bGFGX
         Yz4yQxousN12mnZXjfysYpnKmjMg7N0Hz26UmEM/F+6f/C3HXKZ3JxSZCq16NytJIb7m
         FQoIh3hVjU6ImcWdPwIN7yVEzj3LtAL+sRjtbUh3ClSqZ0zQmxL2/94VFmv+siRGmdo8
         TDhw==
X-Forwarded-Encrypted: i=1; AJvYcCVnQvahE6mnFe63jZQErgkt5nh622m4tczUFwdlIvRtBf9/8xNl7Ql0v445iNVeXq/l5FQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXSBhQ4igr+78p8cHHIrInOVOEfEawofC/fl+VPOyttGeRl17l
	lcwbBiyBjgg4kJb0T/Vo7OGYBTe23PrKDZCgw/wAASouRJ20ap9XVM2qD/WcZycMtpE0BGlFmGi
	EO7Xhg5bztsQOqW+TCEcMpB/8v3nlyNYdNSscYPcyGJiXYjQypJT83Q==
X-Gm-Gg: AY/fxX5iZWbWITrCRbKf6mDQD6H5Za652oKLwHvw6U0Uzs/btfmluWTqcHqD6/7tw5p
	BqlhXJf7shUS7Qh5h2QbH/dvtUaKOdvrnUtNkk5z2xcxr+5paxzOmDy0I3/7K/157/1um1+19Lo
	F1RpNHgbMq0Zx3OgVkhqGf4r8D+sbC9C/kg7sd/ci/MlvRNahK7Sb18wR0AXGlLDrb0lfOBe5ut
	igzaaBhNk6I1qzqL+KyDsvWFkuUSEApj48p2em5jD6X3I/Ssj3u4svXPxDC9jp+MBd6Ul6uZ8nT
	i4jG/Oefy7X4LPCifCRHaajRpobbDenCjxLiEnY7RmOzw1009aoTXKfeXZQzCdKCucluwKGfQMe
	Flk06mwG2OtYtQSfxou6aTP1feLaTFz36Vg==
X-Received: by 2002:a05:6000:250a:b0:431:369:e7b with SMTP id ffacd0b85a97d-4324e4cd1eemr36325949f8f.18.1767100370790;
        Tue, 30 Dec 2025 05:12:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuV3/ZjKqoSSHFRBYNJUPg47idnrIgoJm7eIDekNLmSLi3bfRdDLg5urxUISPXXKwMDGaCjQ==
X-Received: by 2002:a05:6000:250a:b0:431:369:e7b with SMTP id ffacd0b85a97d-4324e4cd1eemr36325923f8f.18.1767100370365;
        Tue, 30 Dec 2025 05:12:50 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1b1bdsm67844200f8f.8.2025.12.30.05.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 05:12:49 -0800 (PST)
Date: Tue, 30 Dec 2025 08:12:47 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Cong Wang <cwang@multikernel.io>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [Patch net] vsock: fix DMA cacheline overlap warning using
 coherent memory
Message-ID: <20251230081220-mutt-send-email-mst@kernel.org>
References: <20251228015451.1253271-1-xiyou.wangcong@gmail.com>
 <20251228104521-mutt-send-email-mst@kernel.org>
 <aVGz39EoF5ScJfIP@pop-os.localdomain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVGz39EoF5ScJfIP@pop-os.localdomain>

On Sun, Dec 28, 2025 at 02:49:03PM -0800, Cong Wang wrote:
> On Sun, Dec 28, 2025 at 02:31:36PM -0500, Michael S. Tsirkin wrote:
> > On Sat, Dec 27, 2025 at 05:54:51PM -0800, Cong Wang wrote:
> > > From: Cong Wang <cwang@multikernel.io>
> > > 
> > > The virtio-vsock driver triggers a DMA debug warning during probe:
> > > 
> [...]
> > > This occurs because event_list[8] contains 8 struct virtio_vsock_event
> > > entries, each only 4 bytes (__le32 id). When virtio_vsock_event_fill()
> > > creates DMA mappings for all 8 events via virtqueue_add_inbuf(), these
> > > 32 bytes all fit within a single 64-byte cacheline.
> > > 
> > > The DMA debug subsystem warns about this because multiple DMA_FROM_DEVICE
> > > mappings within the same cacheline can cause data corruption: if the CPU
> > > writes to one event while the device is writing another event in the same
> > > cacheline, the CPU cache writeback could overwrite device data.
> > 
> > But the CPU never writes into one of these, or did I miss anything?
> > 
> > The real issue is other data in the same cache line?
> 
> You are right, it is misleading.
> 
> The CPU never writes to the event buffers themselves, it only reads them
> after the device writes. The problem is other struct fields in the same
> cacheline.
> 
> I will update the commit message.
> 
> > 
> > You want virtqueue_map_alloc_coherent/virtqueue_map_free_coherent
> > methinks.
> > 
> > Then you can use normal inbuf/outbut and not muck around with premapped.
> > 
> > 
> > I prefer keeping fancy premapped APIs for perf sensitive code,
> > let virtio manage DMA API otherwise.
> 
> Yes, I was not aware of these API's, they are indeed better than using
> DMA API's directly.
> 
> Thanks!
> Cong

BTW I sent an RFC fixing these bugs in all drivers. Review/testing would
be appreciated.


