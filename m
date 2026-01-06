Return-Path: <kvm+bounces-67139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D479ACF8E84
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 15:55:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C02B3061DD3
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 14:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A103321A1;
	Tue,  6 Jan 2026 14:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q6N9B7rq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aoAHoHrm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13376331222
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711011; cv=none; b=myMcvuBb14JJCRlwKRWNyftVyz5qA6kQLNBLZqsPx5qMyLyO21lxDXLNLFAlFzn41DE3+kqCbCWK0SGoCgy8My8MnqryyTHjM7XQWBp8HauY4p+Ox8xATPydN8p+udZkJeCww2kh1c1fhAbPnW9rvNWHCSFk6/WxXZ3LCqs7tl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711011; c=relaxed/simple;
	bh=RqfJjI32FdZ7MpeaFMqvXp4bO7LyOB4RofYVb7BWxmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEuA4N7Fgl/qJfZp1vNNGm98QZU05uJn8yv+J+YuiKHc9O1VZeMSJm/lU+opVKtTvIirLpmGIj4IDIoGZkmWGR9fXH+cATJntE440ikjC20Np3Ih2+5Iywur73lcbQEAZrHZawMTIIjLWMdmg9Pr1k/FxOkg8HlGAdcnyiDuUgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q6N9B7rq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aoAHoHrm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767711008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0jRp3cPG5jRtvX04esVBCT8Xv2J8JEx5kZGeR0bhCr4=;
	b=Q6N9B7rqBOy0edULfnPlNXw7pyLqnuaZ2kNeNi/0yvEpuUlPAM74/ALShcP0D8LK8pl7aE
	RyAIL7DkJq/N2Ik4ubtpFZ3y3dt9u5EJyLMNZ0u8EGrDZmXZAP3Y4N4X5EElvXoGhAjASm
	9e+El8SlpopjnrZbBE0ZpFD7PJKDNUA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-G5MPC7WUNqmzTAc4Zr97pQ-1; Tue, 06 Jan 2026 09:50:06 -0500
X-MC-Unique: G5MPC7WUNqmzTAc4Zr97pQ-1
X-Mimecast-MFC-AGG-ID: G5MPC7WUNqmzTAc4Zr97pQ_1767711005
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477c49f273fso10752835e9.3
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 06:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767711005; x=1768315805; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0jRp3cPG5jRtvX04esVBCT8Xv2J8JEx5kZGeR0bhCr4=;
        b=aoAHoHrmwMZxBs2Qp69OPcSFyaa1ig8teHOPJlTckRJ36lo6MAUEbtcC31JPG6FdXt
         r8wn0YoUmXby44f4lHbgR1uSQGC250mufP2o8GPX7n8jjsh3a/4d0o7zyVeYiY7or4wP
         5fNAD2ypUG6iOfyMx50WuECY+vE25qV7VYCmDh2JcvSmkuCmk0jV6tgIRzf+JgvRWkZV
         /tyDnQ8+btDHVPo2V53lrmTUi6h1X5KXIFtPigLUhEhrf0OZfRoIPXQSNa8Sq6KPyslf
         ekrDkyLn4FoULpuMDI1pdSm/qjS0v7F1JRtZwgfRIfIsynaHmQ0FNYWqHLh8MavZgcjF
         OJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767711005; x=1768315805;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0jRp3cPG5jRtvX04esVBCT8Xv2J8JEx5kZGeR0bhCr4=;
        b=EA0OhBHXn3qb9HuuBoiDEh1KmfUOTj11zEwHVSWYmqTISZ08JgzfGE28Vl3ggsqW5R
         GgpEnM41Ai8+xJveSDN4o7WeN1VbUc9kVQnNufhcz4qxd1iNuXWYWvv60SA7N/KXyt8+
         ue1ZN//bM4JO54l0ENtda0BOuxAXZtOxXEKsdQjbJ8PSRodc1aeNV4bZU5gYzsjqWIUu
         tjzh0JnI0l4CHdtVqWGQk1efXqKVea4eFU0dw1UOLR4/S05ErSFHjsexCeiKKvpS1U4X
         RxTf4CUET9KTUK0yq0iV/y0Is95Hd/vEXnHDztREyoE+CIWIHcLqBrN+lrMK1ni5hPWO
         K/zQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+h+H2nmR080FoPKaJCofK9k+vRTI4P/dOjgdkN2S99LZhxRnkpbLO6yVSvXWitQNJss4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX+D3C7U0vb2c1/syxatAYn2Ry7pgxYGVUVAZ1BKmqFIQBDZAo
	zTrIyWuIBEM3vjRgz57BzouMR9crpEXGDozAoTu7riEXhSfQEvyuSxOF5gb2qO3aMjHzFxgtzb/
	jAkQ4rEVb//rWs4h1CfSB1qEyb0+ZtrL8JkQBq0tgldoip+pqDbpcEg==
X-Gm-Gg: AY/fxX7QqwEBhVo/lpGCoJ96S9rmbqoHHidcvx9kmdnsaVImiDX1uZw8fN6wJLoLNnd
	kb349npm2TlOV1Vpt5FGdM+bvG95u4XrOl3hssjEcQjwkOO2mo1LKfIm9lA3kQObxiAXBbEvyV+
	pVxtLbScbcaSU+VQDfaPCcweK3B02knMbBnkYBF53770EA3lmk65etPsQNFwy3jtaG6Ssjzdkdp
	MZSyIKFe1s4Sb6z1PPtuFQSVcTA7hc/BirPbfxk+CGm55RqztWvvq8kliyDm1u9ftUQmL/n5vHR
	sXVpp1BTjgEeen8p+G2B9zfPYIwWb75Oo3ovfEE5dA9a2HyfurqXQpTjrGsW5174QOho7iB+Ja8
	NHxU7Bo8Uxi/MxuU3LHKjagIUO8cX5xHH0Q==
X-Received: by 2002:a05:600c:c0c5:b0:47d:6856:9bd9 with SMTP id 5b1f17b1804b1-47d8383d75cmr7820685e9.23.1767711005512;
        Tue, 06 Jan 2026 06:50:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXHeGoEH1PxicAu3pvp2IKmLzneQBM5bSFfOKMFfLat4mQRdOWLJ6nIuVR4bStC0oG3LJdHw==
X-Received: by 2002:a05:600c:c0c5:b0:47d:6856:9bd9 with SMTP id 5b1f17b1804b1-47d8383d75cmr7820345e9.23.1767711004990;
        Tue, 06 Jan 2026 06:50:04 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f695956sm48129575e9.6.2026.01.06.06.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:50:04 -0800 (PST)
Date: Tue, 6 Jan 2026 09:50:00 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 10/15] virtio_scsi: fix DMA cacheline issues for events
Message-ID: <20260106094824-mutt-send-email-mst@kernel.org>
References: <cover.1767601130.git.mst@redhat.com>
 <8801aeef7576a155299f19b6887682dd3a272aba.1767601130.git.mst@redhat.com>
 <20260105181939.GA59391@fedora>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105181939.GA59391@fedora>

On Mon, Jan 05, 2026 at 01:19:39PM -0500, Stefan Hajnoczi wrote:
> On Mon, Jan 05, 2026 at 03:23:29AM -0500, Michael S. Tsirkin wrote:
> > @@ -61,7 +62,7 @@ struct virtio_scsi_cmd {
> >  
> >  struct virtio_scsi_event_node {
> >  	struct virtio_scsi *vscsi;
> > -	struct virtio_scsi_event event;
> > +	struct virtio_scsi_event *event;
> >  	struct work_struct work;
> >  };
> >  
> > @@ -89,6 +90,11 @@ struct virtio_scsi {
> >  
> >  	struct virtio_scsi_vq ctrl_vq;
> >  	struct virtio_scsi_vq event_vq;
> > +
> > +	__dma_from_device_group_begin();
> > +	struct virtio_scsi_event events[VIRTIO_SCSI_EVENT_LEN];
> > +	__dma_from_device_group_end();
> 
> If the device emits two events in rapid succession, could the CPU see
> stale data for the second event because it already holds the cache line
> for reading the first event?

No because virtio does unmap and syncs the cache line.

In other words, CPU reads cause no issues.

The issues are exclusively around CPU writes dirtying the
cache and writeback overwriting DMA data.

> In other words, it's not obvious to me that the DMA warnings are indeed
> spurious and should be silenced here.
> 
> It seems safer and simpler to align and pad the struct virtio_scsi_event
> field in struct virtio_scsi_event_node rather than packing these structs
> into a single array here they might share cache lines.
> 
> Stefan



