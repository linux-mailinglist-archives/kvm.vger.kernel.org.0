Return-Path: <kvm+bounces-67141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B763FCF8E7B
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 15:55:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F057730454A0
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 14:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6A95335541;
	Tue,  6 Jan 2026 14:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fz+VC9XS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FM0Ydb5f"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CC033436D
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711117; cv=none; b=kbPu0wpUMSe8IMHRlWq9H0Qe3SomwfM+pUJO989TIrA1pXTxX2ecKrVCm5q9ngdoRfvBAF1DErL9CiZ6xzBAJGHtQuP99Kmm6pBvt8njfQ65jbgVMMsbkgw16CzH4zRZQZZZ/oiDPg5kCpyS40WIOPg0d4Rvvht/v2Wo27AgLc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711117; c=relaxed/simple;
	bh=OtGN4S8+ZWGuAfn6+2YZp7eQlkz7c6TNLgozVUvUCR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKAR4LwwBUKLGYKV6kmc7yf4B7Y8RhV+4se5th9vZKbffzuEpoyz4DiBkIYlutZwhZVfKb6+U+UW0hz6spmjShdn+9zb1MbfyhlYOBK6pkDDGWEH7YXtwrjc+e59uxahlWwrBk3BSzxJyqyXd29V3kkFDXLRelDj3Ah+2oYn2qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fz+VC9XS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FM0Ydb5f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767711114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v8xGpc9e0AHSzqXJdY4dTy2UmvNhNHIufeUOIUm/LzQ=;
	b=Fz+VC9XSu90CRjcNJLIQR8xNtUCj1ZW9XBpV149bIDT3Qr89/Nk65oqEc5xrAecMOx92BB
	/eVHwbykvUmFSB34jwHAAn/uyuIlef66Ue5PPttGQ9H7uxgGnM+fWAImpDIr9g9yUZAcvM
	V8YPZK/Xk9Uqsfepli/BQQXn1xTY/Bc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-JrwOeMCnN2Kw3_ItNxzhyA-1; Tue, 06 Jan 2026 09:51:53 -0500
X-MC-Unique: JrwOeMCnN2Kw3_ItNxzhyA-1
X-Mimecast-MFC-AGG-ID: JrwOeMCnN2Kw3_ItNxzhyA_1767711112
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430f4609e80so488364f8f.3
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 06:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767711112; x=1768315912; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v8xGpc9e0AHSzqXJdY4dTy2UmvNhNHIufeUOIUm/LzQ=;
        b=FM0Ydb5fdan6x+pkR1pJDikE+5rPe3WwNvtNRo0JY14Evid+8FAayK9PXBBE19NE0V
         6zmoqhY0DFOh8fYaTQ2w8a69KO0ECm6f9yz6/NSy6/VZS/jtDSpgR87LSsEQVtgtQI6C
         Bm4swC4PpZaaXSSi+1Oswc7hFfYQjX22ZoqFwC51cURGKJrO06ZoOhjZ5eZZRNVMGH/R
         j7RZUi/wX1uXswo38RIPdWsCg4iwKcSnQ4YDfJ6vEwh4pq+EaWgBUP7DDSaV301bGKCp
         3WN9O3bTncPfs2vWtO7odr14bTSpvCTRf7UV8cA+BVh7m6Bzvi2UTfoEFMptn9FMl/Kb
         oPKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767711112; x=1768315912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v8xGpc9e0AHSzqXJdY4dTy2UmvNhNHIufeUOIUm/LzQ=;
        b=l8wpTs6TobsBA7A9BJOEV4I+soQXISYV4WK2rkwiuH8QJyzeTeV/BRtj6l3sjHpVdG
         UnW4oJ8uNpswmVoNYTaUzxy6RcByXAw36XdVNGWkyIskdjFYVKnSqGuWHijNzEWSnBR+
         jyyzS8BK/HV4UKeh1JxAybiMsE8RpSECtJqdNKLuTnoMmep+ZeP2ok39xvOWoBaAKS+o
         BHosJVjQj7J2qpCwa3niFZHuYhPowo6YgLdOsNH/XCdSE5BuklW9Ybt7RQvxUNVvDxNk
         CJEc+AB5K78qd7c/qFxzkN59T9Ogz0htFj+DJiV/zcZ0l0jX5rVTfXE/eR9q6hjxhVy/
         kUFA==
X-Forwarded-Encrypted: i=1; AJvYcCXe+TtJB1YcAS86H3V2jV3AboeRqw8U3af5NNxUIvuYil+ovz5MznE+fQ/hBP65axkUaKw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye39KcnhqzSA3KknjXJpv54gzjm1LIGCZD8SxPeQVqYBl21vRv
	r7sG6B0WeJgASs7fiDmK54yd2s9hNj3QdE1H0nUV0zzMuqzL/AaiOZJX8uFdXAfZY0iXzDsjiiF
	FvGuKCGfQ1UVGVoiMNFDJc0PZ+jhuf3BLhOcdTO2APCyYxAEJk/3OqQ==
X-Gm-Gg: AY/fxX7ZSQofuuRSHdRduZDFnTM4Z5HaF0pxYdltIjheZciBblV9U8zJjbCbSLZTd7C
	3ZQBFS7MclcqBUP6VdRRqJf4PMsl6jhLVl8M4v9UdzyjDTAvKCq1KbSNgsTfyGdJ4cnorWz7ouM
	84ZGNeWjaIlKz3YiDyuR2yT+UgcchW+9cztmvI9ZXcVlAlc/pGFEBWR6ApKRnCgs7dRmHjHmjo3
	xGub/gdEcwpEBC90dLlCZMgJk1gcZ53/VXerfQpXVvndeNxAXw/6g3s36cUYZVlEcmqPefSly7q
	lbVxBeTahP5eefxq++rHCf1twtDFdpMrS+uEOTxQv1Wbo9qWkZyfN0bQExhFzCGVzdNnbzViOoG
	QdB9UB3YtVswKvT0VoSk/VkLKf829VL63EA==
X-Received: by 2002:a05:6000:200f:b0:431:b6e:8be3 with SMTP id ffacd0b85a97d-432bc9f6dccmr4753192f8f.38.1767711112113;
        Tue, 06 Jan 2026 06:51:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGOynDA9QP29UwN/sUhG6OCzOdNXrD0Y6rHdaimQHcJZW2G3EKin+vfxrhBk6BDORYTgSmwkg==
X-Received: by 2002:a05:6000:200f:b0:431:b6e:8be3 with SMTP id ffacd0b85a97d-432bc9f6dccmr4753140f8f.38.1767711111656;
        Tue, 06 Jan 2026 06:51:51 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ede7esm4752453f8f.32.2026.01.06.06.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:51:51 -0800 (PST)
Date: Tue, 6 Jan 2026 09:51:46 -0500
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
Message-ID: <20260106095044-mutt-send-email-mst@kernel.org>
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
> 
> In other words, it's not obvious to me that the DMA warnings are indeed
> spurious and should be silenced here.
> 
> It seems safer and simpler to align and pad the struct virtio_scsi_event
> field in struct virtio_scsi_event_node rather than packing these structs
> into a single array here they might share cache lines.
> 
> Stefan



To add to what I wrote, that's a lot of overhead: 8 * 128 - about 1K on
some platforms, and these happen to be low end ones.

-- 
MST


