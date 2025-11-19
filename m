Return-Path: <kvm+bounces-63746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E02C70D52
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 20:35:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D57464E4341
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 19:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC8731ED79;
	Wed, 19 Nov 2025 19:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XdlJDak+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08837369233
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 19:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763580688; cv=none; b=hoDobJ7IZdu5tM0Y0DJ+v883PRx3KRXrCOU3n6S9VLvsqdmEXb7s6cSTLboOlkakJWphSFx6QxzClvFWQJ5bhZX7WORKWLgFx79EcX8Uz5MhKKz9Deo5v4ON0z0UUrN6irOriS1lZ7EiYcTKnxmzsl2X2BYBTMCSq8XkhdrPGGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763580688; c=relaxed/simple;
	bh=31o43Jiq7+42iBKuCHD0EJijctYU11Xzmoh7F9+p7aA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfDp8bMZ8jOkQhngyE+IAe9zRliocJ8y840qQRF60Xe0dJbtCCE1TEIo8+SvBLuVqWeOfl73L7lvDxxmgRfQoNWbZwyHknbJOy8o0SsnZQ+p2mKhGtFPWzsAC/XzsfexFTinYJkIMjg5PGeJU6VQUnACPHMlDTdk6YLXuFyRU7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XdlJDak+; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ee2014c228so741411cf.2
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 11:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763580676; x=1764185476; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h7MnLKcAx1SQL4BtR2OdhLpsdZ14wJj1fNMBVXMaHpI=;
        b=XdlJDak+5BK913SU3JuefgTys0Pu3jagmK7yJRyg0hso6vBbEnNWrP/4T4ol0frYeQ
         v72slbgWiUzUkvc5J9nruxngr4U8bjd49BPaZVmvFk3nVkQeWMFAA9u86tKqv9X1hNhK
         MlqYYLa9OWUP32XsBcZxKrfLx3/P5R6PJ+h5hBO1AY350/0bZcNA4a3VB+Mm2EZq+tuy
         2zW8VsnOjICqJWrFFskAlkKYKVrHI+m3LVPh9ZWULCzK0B6ii9jOvGUvNr+rAbET5gKT
         aIqFqtGZMVR1/oWhdLlQH/aHK4RI3YFZ+ToY0lGX/NpOTOSRqsVtdilqIlqws45I3kGI
         vpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763580676; x=1764185476;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h7MnLKcAx1SQL4BtR2OdhLpsdZ14wJj1fNMBVXMaHpI=;
        b=IBQRSzHdRGmokhGqrvRUKZ7soCmJR8S8uztb1l50GIiwQqlibrcrGnBQO2mRvH12bU
         PDf0x292yBlo7xxw+huwyek6ISPznH1+WlBxRT6ZipN1k2Pavnm60F7BceS1i6Z9QjQx
         rqQutDN9FeRowFrwwOdxUPxjtzpRAiHBznSipPcD8HRaBJ8ctaV7FD97lGjgkzUVvIlp
         H5HqpqvQcjHKiQ5vR0EkQbfGNAGeXdM4pva+Rb0dj49QcB8Xs8B6Dsfu1iFbBUzRVetU
         LqhhaQsn3b9gUxNEOuI17d8J6N/s22mfAInAPraV788ur76ZDNItZKjdi21+HBQJ4EqL
         C8GQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNYdTv8edA86uUZ/JrFSSbNea014yvoDKEHjIndmHNaWNGZT9PEaMdd1OI2CSxbnmZlO8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0sPHKZKryLNy0ujXWW/XMYBxM64eqjMO/ygkKR4pc4jDhzuhz
	LHXsYAmum9Ht+ut7OXsz3KC6QNRpldN/DgtLLDufbhCtUaMhwZGoAMkD0qGa8aoVB8E=
X-Gm-Gg: ASbGncujnfaioPUbamX5Cv5iZ34IM191vKXX0yvMskPh1jaQY5WviNKShzQZeQoENXB
	j2T12YZAA6OwEbGnq2r+E5+mTkvkhkVCL4V0HVCTKrw0GYp6fdvlfyxHtNNX3GRFh9YqsRPCo28
	rLaVS0/r+VrXnIdJ1cwWcWp0liL/Uv6hy/Y6Pogf6rVHWk5pSOhpfmC+DXe/OFrylfvqvr5nBNo
	p+woIn0tevw7VdxO2m31DGceUUr68vx4EDBfBHvkpbAqh6YVemkO7u/jNy46qNUckdB1gkkcULK
	+VMlavmWQg2nGdi89Jjqwv80lEl2P87VPOygJ5UEXDEOf10GfUfgFWuolWXDWHFY7nUFecnE34G
	gICFLO0UaDmB/x7SMCe9wbiTCDPwFJRReQ5S3mFFX90L6WxJOns5H6OxskDbFvnJ8z9BeYsTNnQ
	pIl6/j7W3JwLT8zt+BoDYVkWOxOB33ReGiJfyx51r6L7MpsvusEIaxpUZiB+fcFPEp5Vs=
X-Google-Smtp-Source: AGHT+IH0hpvR5twkqRmVGMRtAcrCxesRIOb4Xizv2z5I0TXHRJV8nSPA0Y9PLt873fJAl178vHWixw==
X-Received: by 2002:ac8:7e4c:0:b0:4ee:4a3a:bd18 with SMTP id d75a77b69052e-4ee4a3abe64mr1136891cf.76.1763580675980;
        Wed, 19 Nov 2025 11:31:15 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee48e46ed0sm2807721cf.20.2025.11.19.11.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 11:31:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLnta-00000000bWq-3r3x;
	Wed, 19 Nov 2025 15:31:14 -0400
Date: Wed, 19 Nov 2025 15:31:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251119193114.GP17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>

On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:

> >>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> >>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
> >>> +		if (!dma->state) {
> >>> +			ret = -ENOMEM;
> >>> +			goto err_free_dma;
> >>> +		}
> >>> +
> >>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
> >>
> >> Oh, that is a clear no-go for the core DMA-buf code.
> >>
> >> It's intentionally up to the exporter how to create the DMA
> >> addresses the importer can work with.
> > 
> > I can't fully understand this remark?
> 
> The exporter should be able to decide if it actually wants to use
> P2P when the transfer has to go through the host bridge (e.g. when
> IOMMU/bridge routing bits are enabled).

Sure, but this is a simplified helper for exporters that don't have
choices where the memory comes from.

I fully expet to see changes to this to support more use cases,
including the one above. We should do those changes along with users
making use of them so we can evaluate what works best.

> But only take that as Acked-by, I would need at least a day (or
> week) of free time to wrap my head around all the technical details
> again. And that is something I won't have before January or even
> later.

Sure, it is alot, and I think DRM community in general should come up
to speed on the new DMA API and how we are pushing to see P2P work
within Linux.

So thanks, we can take the Acked-by and progress here. Interested
parties can pick it up from this point when time allows.

We can also have a mini-community call to give a summary/etc on these
topics.

Thanks,
Jason

