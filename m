Return-Path: <kvm+bounces-66911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB51CEC8A7
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 21:48:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 52FB2300911B
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 20:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE5530EF62;
	Wed, 31 Dec 2025 20:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KO2pst7a";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pvP0z3pG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730E717C69
	for <kvm@vger.kernel.org>; Wed, 31 Dec 2025 20:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767214117; cv=none; b=nhs9rXdBq8dKBPNMTEeaDTI0gpJIaqRUWYeoI7y+XWgDFRBLgQqllA4vm2Zi5WXL5xcu0bdoNyKCb74EIrL0cTDYPSou+bNheN7eXsumUXe+wqK1rUPPvhO0XiUP0UGkb0VRTGBYHz46pgPtZQ8MCobUPJaUacewixL1jMkxJ5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767214117; c=relaxed/simple;
	bh=BpH6W25VRu697Yn7DFwf7krulZ0ceVuuDV1JpnQSClg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nis89W+8mDU0eBuujwmZRU7cqz0EJOF1yIwXDiTSGf3dnsPRyyhANLMhVILunczz3QoSoaho6t5bgvha9UeWX7ZMX2E6L8aBfh3NRzTcpENF0nx+1wjGy3fvJowFPhI430LfgyDA/9ZAL2Pvr56iSnnNA93d/GVGOL68w/zW5hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KO2pst7a; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pvP0z3pG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767214114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t2sN+P6W4rMfz5k+VlkZX24a7rMpvbJroFZ4fnRS1gs=;
	b=KO2pst7a6knSWN6rwQQ5+yUFBz7s4wLh4IGyTsMIGnvbkyIE/0qxnBMpRegE4yi2MmXl2s
	vff0dvjNVp0zDxOfz/B46oqVHAM7wvR2Azxy9iXq3hp3M6oed6ampl9o9l0xauspk84wAk
	cjzW7jrv5VoxMU+rxuxsP+aLjHY/wmc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-Z1E9W-4iMZOXj9tldqedWA-1; Wed, 31 Dec 2025 15:48:33 -0500
X-MC-Unique: Z1E9W-4iMZOXj9tldqedWA-1
X-Mimecast-MFC-AGG-ID: Z1E9W-4iMZOXj9tldqedWA_1767214112
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so111894705e9.0
        for <kvm@vger.kernel.org>; Wed, 31 Dec 2025 12:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767214112; x=1767818912; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t2sN+P6W4rMfz5k+VlkZX24a7rMpvbJroFZ4fnRS1gs=;
        b=pvP0z3pG4NqUkDHEluND0t26A7txfqzDiv+38R+RThoSWb5dEsO1hy7Cc4yqorCchh
         gik/JRZenBBZc51cql+BtTqJJ63YhG+FLqOw9wpzLarl/BMIS0RnUe/QPBsvoap2cNeP
         FPw9Um2+unbT1MD29TdHNIN5x6W6gv1CorNe9QPA67D0EGBlz4F2Pg+xnhbBbVQOPknf
         JfYCugGl1w2hambIeB0Hr1bPNMdkSO822uk37H8IbRyOPNuPt4eIr1xt94kQ5rA6TcXZ
         m2ERDOWtf+wCEVR++av9x3FewQECEcUv6ApsMPpFpR6DmoQcUZXLYWIoCdEXXmjyyXhP
         SN3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767214112; x=1767818912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2sN+P6W4rMfz5k+VlkZX24a7rMpvbJroFZ4fnRS1gs=;
        b=gJ3O4BJp96T1pyAi1Nahsq2vrwg0r4DHrtolDzhWwZ5pO8FnUckoHmXtUfmwOiej4I
         PLEu1MX0dLWjT61T5+fiRzILTEL1bPado1DyDnUpbWYLNEy6nVi9JsEls1NizhmKObH8
         4S3dQ+wMZzCDrCwoZkbwQ+1uFt/be0FhLDQwLfxl8663S9jt3ycqmTYVz6yrVbWL82Pd
         qw4HWfoXmNc1/6R7YvJ/Iub4arhZMXstN4VH+Mo1zZPgPXyuumKEM0SicLhLsrU3wIRs
         n5hOHmVWucm+pfgobBL0v9a9Ha3N5M3b6oNKGsd034P+NRX2jBkhUuXgHJSeBBL2LLMI
         z6Rg==
X-Forwarded-Encrypted: i=1; AJvYcCW11Er+L9ZqI8YA2RtgezmMizPkDr5HpIDOCo4l8rLyvBH/FMMAySgTA+8n/JG1M4IJKTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCNywCuua9ejYS/X/AUCom649YZ228rtgOzEArprXR/n2kE4Pj
	PLdaDDcNimF4Q/LfmuNkSP4dIPachnj9t8OLEgVIe4EgZMxplCHNnKnWREe7XC9NveReruQWXbU
	kac8SIBzV7hoBBtZMP2GiKvftux+wKi5Qk5J3P537sDnnKXrSdFQQqw==
X-Gm-Gg: AY/fxX7z8+kSELKUqyzuBUGRAgb+/Bf2s1r2wz1OeTQ7DHYBzO6sXpZ9hFvEvTKaUWn
	r6r+auf/6Yti4dblOiaCan5gr3V6DZ7740LU96hCLaUEdfPYTlmzi5t+bkqm+sxFLE1MOVAwNO4
	mbJncA1B9NvGRTYzpLvDv/fJKlmFuv1Xx+ml/wNoZyzWb58EM3qnULq4pf4ftVLBYu2x805j6pj
	3Gz7czv0gwE/DRNAO1LlK7UZK+2wVUGV3Hva28V8JQOEyY5HWlPhlQigxHGCa9OMwO29qZElKWg
	5hVWHmnGIsd4ljRP3329rmd/xBTmRwaudivIsA/PUkbrosC9qlLQVEXs9z9+z6+aWbJoQwO0bL7
	FDFHVYmHpGovBiyZi8Uuni4qTNNYEd6bKLA==
X-Received: by 2002:a05:600c:444b:b0:477:9814:6882 with SMTP id 5b1f17b1804b1-47d1953b77fmr390890785e9.5.1767214111811;
        Wed, 31 Dec 2025 12:48:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUX2S3Ts6MrXbJAEZ1+1hODDbGMnh81w30kfQclg714E6BWRq3zDXGinSJodthec3i9GHMDw==
X-Received: by 2002:a05:600c:444b:b0:477:9814:6882 with SMTP id 5b1f17b1804b1-47d1953b77fmr390890515e9.5.1767214111286;
        Wed, 31 Dec 2025 12:48:31 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d19362345sm662070775e9.6.2025.12.31.12.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 12:48:30 -0800 (PST)
Date: Wed, 31 Dec 2025 15:48:26 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Petr Tesarik <ptesarik@suse.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
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
	Simon Horman <horms@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 01/13] dma-mapping: add
 __dma_from_device_align_begin/end
Message-ID: <20251231154722-mutt-send-email-mst@kernel.org>
References: <cover.1767089672.git.mst@redhat.com>
 <ca12c790f6dee2ca0e24f16c0ebf3591867ddc4a.1767089672.git.mst@redhat.com>
 <20251231150159.1779b585@mordecai>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231150159.1779b585@mordecai>

On Wed, Dec 31, 2025 at 03:01:59PM +0100, Petr Tesarik wrote:
> On Tue, 30 Dec 2025 05:15:46 -0500
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > When a structure contains a buffer that DMA writes to alongside fields
> > that the CPU writes to, cache line sharing between the DMA buffer and
> > CPU-written fields can cause data corruption on non-cache-coherent
> > platforms.
> > 
> > Add __dma_from_device_aligned_begin/__dma_from_device_aligned_end
> > annotations to ensure proper alignment to prevent this:
> > 
> > struct my_device {
> > 	spinlock_t lock1;
> > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > 	char dma_buffer2[16];
> > 	__dma_from_device_aligned_end spinlock_t lock2;
> > };
> > 
> > When the DMA buffer is the last field in the structure, just
> > __dma_from_device_aligned_begin is enough - the compiler's struct
> > padding protects the tail:
> > 
> > struct my_device {
> > 	spinlock_t lock;
> > 	struct mutex mlock;
> > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > 	char dma_buffer2[16];
> > };
> 
> This works, but it's a bit hard to read. Can we reuse the
> __cacheline_group_{begin, end}() macros from <linux/cache.h>?
> Something like this:
> 
> #define __dma_from_device_group_begin(GROUP)			\
> 	__cacheline_group_begin(GROUP)				\
> 	____dma_from_device_aligned
> #define __dma_from_device_group_end(GROUP)			\
> 	__cacheline_group_end(GROUP)				\
> 	____dma_from_device_aligned
> 
> And used like this (the "rxbuf" group id was chosen arbitrarily):
> 
> struct my_device {
> 	spinlock_t lock1;
> 	__dma_from_device_group_begin(rxbuf);
> 	char dma_buffer1[16];
> 	char dma_buffer2[16];
> 	__dma_from_device_group_end(rxbuf);
> 	spinlock_t lock2;
> };
> 
> Petr T

Made this change, and pushed out to my tree.

I'll post the new version in a couple of days, if no other issues
surface.




> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/dma-mapping.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> > 
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index aa36a0d1d9df..47b7de3786a1 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -703,6 +703,16 @@ static inline int dma_get_cache_alignment(void)
> >  }
> >  #endif
> >  
> > +#ifdef ARCH_HAS_DMA_MINALIGN
> > +#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
> > +#else
> > +#define ____dma_from_device_aligned
> > +#endif
> > +/* Apply to the 1st field of the DMA buffer */
> > +#define __dma_from_device_aligned_begin ____dma_from_device_aligned
> > +/* Apply to the 1st field beyond the DMA buffer */
> > +#define __dma_from_device_aligned_end ____dma_from_device_aligned
> > +
> >  static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
> >  		dma_addr_t *dma_handle, gfp_t gfp)
> >  {


