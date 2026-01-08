Return-Path: <kvm+bounces-67389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 801AFD03735
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 15:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 63C0331576C1
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 14:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0894D89F6;
	Thu,  8 Jan 2026 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Dw0oXzQU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136694D1650
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881450; cv=none; b=uF6dzmxFoDRftVP5On8ssjSid2lmzdnqpSzEq5VH1Ro5vpL2jrB5/h4pw7UF1HKlut+YWQdcohur9lt7rA45QwPc7RdxFDNEiBJBXNSFMaGl3KYmdMSADE2FBQruhEyQKtvszV+Lx6JMRSWMCLayRE/lz/v4DP35N1K1FC/iJ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881450; c=relaxed/simple;
	bh=mOyKu2qnINj2x88v5g/B8RjO1LOcLsg2eN246pYG+9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Upx5kfMKAlZmre2Owm9GcsLfEg54VYwhRrcUfh5ElKqsAo04+MznCn8dH09uqVvdb9KGgphq3Ov+m4iWDsUvsgGobxDvlR90UHvQd2VOSpCIDWhPIyub7b3d2hMTK31iYqqbjs1LeFh1gSD6IQsWJ0MTkikrobtEKgiIPbV7/NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Dw0oXzQU; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4f4cd02f915so23872831cf.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 06:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767881448; x=1768486248; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oDbkV3lGC5q9hIUjdqkuvar4sKouEItjHMXNdXEEOOY=;
        b=Dw0oXzQUUelmqmGXwTPn16P1HIMNpjgh5MUGjza5ljvke9CJbGeApM1iz54fcR1eJK
         Aj/osLXYekG8ctsTHFg6lq9RSd1zaDP5vVcWcPZ2SKjpAE9UIavEBwN+IyP3Y9leiOqm
         a5yW//KYkhnMn04G97HVYf3ztnxeGofHGJv7C+HuXYZtkl/rJBoPWvyWEoxE2ZcD4cKO
         LAg776359gEcA6avWMXwKBBBRrd+UNOMU+OYq9OMhi2uroi872dOZxmGoZz8jYDga6rX
         uM4+IEn5fO8ZrZ7pQN18++BY4Fg1KuIr9rM4BZ//VkeqYtDZ3Lhg13kAuCF+4FvkY6At
         fbeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881448; x=1768486248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oDbkV3lGC5q9hIUjdqkuvar4sKouEItjHMXNdXEEOOY=;
        b=XK1B5UBb6G12za9Qf9+0+twKv+8wPLAQyVvD5Qv3bkX9Yshy6hOlNLdnDjjhFcWC8/
         1TDpsE7LzXTEX9RYijaq1oUzA+LZ3eYKV96y+ZatpIynzAawlwhKxnzFCYRUgOhD1VjD
         j7icPlDpQCO7Y/xg5KD1b3qgOLrVczMZvHQv50KdQrw1NAxwiNvbBKh0lyMCjDutS/EF
         Z28Kl0tNQ7Gcw4labFiqQQSrTlfLaS4DhxGHsnTDTwXmLs+tIu5rw08DUgo3xUo1ZIe1
         tmIvoo1Pq74SSLm3T/Ie6Pg8uV1BJeWLK8nWVotwoJOiPob+wWpCB2NZnWSByqtlYTEY
         /Vjg==
X-Forwarded-Encrypted: i=1; AJvYcCXFt3ASS5zLi8vcwHjpKYBsnag4qta3BW4rrAhmD1MlKAHXQH0278IGJZpX6vC5FO39w2c=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbe2xYLVR52XN9ktZKW74bxuUVEJDM+FGrJO3vNBLg9O95v2zc
	OUtdEmOgh7AzLB37B23bv6QPe/9gTyM4oXLfLmZs7KpMLN9MaD8X0XjiaP4EVCfKHMM=
X-Gm-Gg: AY/fxX55A02/fuEaPtIbGQBncy2wBTXYNc9aBvOTK0PC2COSzV3Q4zpJWiVPoKF25Nf
	ZkYb5Xm7MOyoiehbEtiZDlCJyBqhQPFDk93UinxKybvDQJJBySdI08YBuBGX517XGWOleMhdBUk
	bzUCWvQFem/pqCHeTmI10k+LotwBxki3e4uy6jvIjmc7R3O5F3L5rGMHGXkgxZ9jwqHTcn1QO0L
	FvmvpweXavu9G6/VaPVahYcP5uZ0WqOLtN0uVSoUPT5CQp2dVe8fEXWnhSaFGa3IgcTeKPsHvP5
	m++tPUXptp4HFRYeNpLMPn8433ggCHKLmCFIEDC5MhRDToih6Q4ltUcTsnAhvw2ARN43ADlq8df
	2uQ+UyW49DMlEFEhOxV05Xa/VsK/4o7DHOE9Tv13gFzqQTWTm9Ei3oHV8eNzXBMSA2pMz8TCfBN
	+EYUD2gcSzttraGgfc1+FXYhcFpf4Bwq8bW4SAvWIqa/a50HF8v7NBz4PYRkEX7LLtWRg=
X-Google-Smtp-Source: AGHT+IHLFsWgRSX6V5S9B7UJ9/MDZC7xvbmTJCziAAyGWoSQBDoda9rrddhfylBRHlUYqEmcr6mSKA==
X-Received: by 2002:a05:622a:1aa8:b0:4ec:fdaa:b31e with SMTP id d75a77b69052e-4ffb4933f5bmr83200721cf.32.1767881447747;
        Thu, 08 Jan 2026 06:10:47 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffb813ffb8sm26637331cf.20.2026.01.08.06.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:10:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vdqiq-00000002Lxb-3Inr;
	Thu, 08 Jan 2026 10:10:44 -0400
Date: Thu, 8 Jan 2026 10:10:44 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: David Matlack <dmatlack@google.com>, Alex Williamson <alex@shazbot.org>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] vfio: selftests: Add vfio_dma_mapping_mmio_test
Message-ID: <20260108141044.GC545276@ziepe.ca>
References: <20260107-scratch-amastro-vfio-dma-mapping-mmio-test-v1-1-0cec5e9ec89b@fb.com>
 <aV7yIchrL3mzNyFO@google.com>
 <20260108005406.GA545276@ziepe.ca>
 <aV8ZRoDjKzjZaw5r@devgpu015.cco6.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV8ZRoDjKzjZaw5r@devgpu015.cco6.facebook.com>

On Wed, Jan 07, 2026 at 06:41:10PM -0800, Alex Mastro wrote:
> On Wed, Jan 07, 2026 at 08:54:06PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 07, 2026 at 11:54:09PM +0000, David Matlack wrote:
> > > On 2026-01-07 02:13 PM, Alex Mastro wrote:
> > > > Test MMIO-backed DMA mappings by iommu_map()-ing mmap'ed BAR regions.
> > > 
> > > Thanks for adding this!
> > > 
> > > > Also update vfio_pci_bar_map() to align BAR mmaps for efficient huge
> > > > page mappings.
> > > > 
> > > > Only vfio_type1 variants are tested; iommufd variants can be added
> > > > once kernel support lands.
> > > 
> > > Are there plans to support mapping BARs via virtual address in iommufd?
> > > I thought the plan was only to support via dma-bufs. Maybe Jason can
> > > confirm.
> > 
> > Only dmabuf.
> 
> Ack. I got confused. I had thought iommufd's vfio container compatibility mode
> was going to support this, but realized that doesn't make sense given past
> discussions about the pitfalls of achieving these mappings the legacy way.

Oh, I was thinking about a compatability only flow only in the type 1
emulation that internally magically converts a VMA to a dmabuf, but I
haven't written anything.. It is a bit tricky and the type 1 emulation
has not been as popular as I expected??

Jason

