Return-Path: <kvm+bounces-43996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 331A6A996CE
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 19:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 612E11893F15
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0607228C5CA;
	Wed, 23 Apr 2025 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nECGOegw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C368288C80
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 17:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745429789; cv=none; b=i5Y/RYJmLgbqXfSUcMCWRQ7WezWTgnbH2BJNL7bGvY16J5eaFoje2IQOCKfB+LDRw22IwweS6b6xyBVQtzrrl8P3mEIXrfS4y7X24/TAM87mOHUuNW4NvNoNb6WxycV09wF5qpdqk8+hu6PN/EP3idppz4woNGpgCqtrC7r9edk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745429789; c=relaxed/simple;
	bh=drAiBKTIiyi9mLR+BwbEskkyvzsYVuH4EzXGje0dF0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Khh1iwo2HRKiQjYd6uAMol8V/qUX0ojlgWsr7BgTe83GNhJQg7vXjVY9KjjYKZcML9QMhx76CjQk5tqs01CC8SPKbWxT7ip8cAREExcjml5q0sgXtMuXRFPvK+h7W+C4DQU09CiKbZTdGbRrlPqiE5yTOgxVZyvjAHybwxx45rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=nECGOegw; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7c5aecec8f3so11797585a.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 10:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1745429786; x=1746034586; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rNJodNA/CGOE8qYPmCoAIvEyeqrCcwNf4apB4pxSGaA=;
        b=nECGOegwoDaon8i7eVtKxXoiAeyi+dwz/Mu4/CD/hldn1xswY9Jn8BCh4H3ajxW1i0
         LYO5ucHVY+hQ6Enk8MJef6znkZLkmrsKK498EwoF216ulIsuSKn9KaxdU4cFdbcPVGD4
         jalkaWuOrHVCdfs5yVqjLX7mi2DMOINJAtF2iY1DKphNwhBU1BAt8TNjjo/7TQi9EWoE
         10WiL8VhTOgMQMWGR9lRHkTcsIOzU7y12U8RAeJT32k19zA0zXtL3WLyTpaYzOO+dcno
         stvqp3Wc7DgapQLNyGoyKUxeLxhjaHDNkRzqHhIwiuTIRTwQ+OimLmRQ9y52fkxYGEJG
         LN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745429786; x=1746034586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNJodNA/CGOE8qYPmCoAIvEyeqrCcwNf4apB4pxSGaA=;
        b=mxg1ff+no/IB/ao1OcDBnFksITC9MpJkppdjz3VvCSThSYlsg2hS1oYjtmVHZV1L5J
         cBX7+G5DF7IMyQvy0bCMPLa2sVDBngL0kEevuxtBxTyvRzL4BnvKFzost/0+739lPh8j
         VB3WcEqhvbnfy4mCKyoalRZLdS0E7c1jacFb5zi5UzPoLMb7cDzvnk+9FAStRk9k9w9p
         FrYEB4yOBkxxRRZr5Pm4zfwO/rmVGqAzNNZncJZ2oX+IDxbfjQcdrDm+v9VF5EHhXis4
         8OpUJCvLdHTxadDCpnNCV83EhdHlEPm9ZhHjak21lqgWSRgNbNdsN0XWDJNO213IDSgc
         NmaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFyXRYKMYDIi4nHoaR78w74KVCfzeqelIQcORbm62PccqBeStVRQDHN878U+DXI/2EnrY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJBf8c4sM3QdhMVjD4YuKIRxJTiuyRMXzeb8vzVmzPoCwULr2E
	g4+moayjdvzTcu+yUsb6bV0pcPjkqLsYfJNJEiMWJ55sVuPu+m9r22N+TsqYstk=
X-Gm-Gg: ASbGncvDdPhxpG0JQJ/VcWFxUmFfQrDKyxE7nXoLT630qYR2KvWJ+k7UFKYe4dYV78m
	QIwJlYYEw09W2Va0KemZgxIYrWYeUhdQPqp5VONb3wns0lv/K0V7HafVWaitmQTXN1/+r0aT0xM
	IxxZ6gJFmYKmWQ+kGIR4JLHO0J6Z+ed6pDsW9Z4YEm+1MWiMInx12FPgcMN2v/1s+EqEf4zdGgL
	uf7U6tX1gljrFLRudgOj5q+fdif3KTvh2i6YqzTYYmQecKqs2poy4qKv0GUv4xhKbvTJaG8fal0
	IMKIlUXeBlUu1FSvfUNHzNx0Nh9q1xShlPEUIvbGiRxo5BSPGHoVM+z+fHw5UrYSc2UY1mGaE2e
	pyWvF0lrdjp/J7+QZ4So=
X-Google-Smtp-Source: AGHT+IFfYFJ3H6MHGXkZxUwtNrKhvKS2i7aEibqmChB9ejFnkuFqgY0c21HHcZ68bh6mda7wa7inKA==
X-Received: by 2002:a05:620a:44d3:b0:7c7:a5ce:aaf1 with SMTP id af79cd13be357-7c928018e95mr2986289985a.35.1745429786563;
        Wed, 23 Apr 2025 10:36:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-219-86.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.219.86])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c925a6eb31sm709808085a.3.2025.04.23.10.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 10:36:26 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1u7e1J-00000007Lca-2cT8;
	Wed, 23 Apr 2025 14:36:25 -0300
Date: Wed, 23 Apr 2025 14:36:25 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v9 13/24] RDMA/core: Convert UMEM ODP DMA mapping to
 caching IOVA and page linkage
Message-ID: <20250423173625.GO1213339@ziepe.ca>
References: <cover.1745394536.git.leon@kernel.org>
 <7d6f3d50c4e6eb3ab75fd4c5bbaa8efcb1a15b3c.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d6f3d50c4e6eb3ab75fd4c5bbaa8efcb1a15b3c.1745394536.git.leon@kernel.org>

On Wed, Apr 23, 2025 at 11:13:04AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Reuse newly added DMA API to cache IOVA and only link/unlink pages
> in fast path for UMEM ODP flow.
> 
> Tested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/core/umem_odp.c   | 104 ++++++---------------------
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  11 +--
>  drivers/infiniband/hw/mlx5/odp.c     |  40 +++++++----
>  drivers/infiniband/hw/mlx5/umr.c     |  12 +++-
>  drivers/infiniband/sw/rxe/rxe_odp.c  |   4 +-
>  include/rdma/ib_umem_odp.h           |  13 +---
>  6 files changed, 71 insertions(+), 113 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

