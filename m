Return-Path: <kvm+bounces-63399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1056DC657C8
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AA4163A214E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 17:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14AF13093A0;
	Mon, 17 Nov 2025 17:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="St0q6+iO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B25130504D
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 17:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763399785; cv=none; b=DrSufqeWBdpkYM+t8liD3mbjtgmPpHiK+K+Y4ZzRpm/QpOf7LD5xdeXVL9z59FOiyhNC+vVTHiJR8Hym3D61w+vHZmogeRnKAsx1j6CTsZ0MioAkJHAY5Zi6XMV/n2GGwTiOT3Gij0WXaHD/EPPpDPiJdN9ZpprmnC0PCo88iUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763399785; c=relaxed/simple;
	bh=2sNLnkk8V5VHxiND7V+FoGQrjFZ2T5dAZtQ/cFM2bC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=evrdp7vDfAwOcCsQknGzGvkfURZzjKjXiCsX0xWD09iEqB3bqdrPwP/OSVCR9qYg3A3sFwXBz9KAywGKbhG6RVOeJdItjc4NlevQrLamgZEcjTNzyU+vXAL26M84QBa6z3LCH4qBK0NMfydlrc35KXk6pnP3BASzqP/2l3SvXok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=St0q6+iO; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee1a3ef624so10487081cf.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 09:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763399780; x=1764004580; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P1EKuTl21MaZwOVAnrWkECo68IZFcqZRr/UNlppTPmo=;
        b=St0q6+iOpxbQP/6k4YKopb2b5abxIoNmFDBUjCQhyPHK+h7d8HKH6xaNs1SrXfm6OZ
         SX3+iU7AfSkVpcl9Oh20UsDOxLGNyrTJJc60M57mpWVYDN6AnVbBn3x/F0Pr/nl/c57p
         5jOlIOnA23o0k+wKKWoTyTffzSAy9/U+iWg/cLqgA3zQq/msJHRR/LgxbQaTSBBwO6MZ
         HKzAgSbvvmGmW1PFfxSgqU9DWWWbgWBmTKIdeGJueyBjy9frttHn2vvAydk/HIgrAZxw
         cGoTxy1YwOwm3TyCYh3mvEIbvhY1xGP7VBnVqBapoxOOhc2WUKsxkMK9G0cuu6VQah0D
         A6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763399780; x=1764004580;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1EKuTl21MaZwOVAnrWkECo68IZFcqZRr/UNlppTPmo=;
        b=Qvql9eaE5dSCAR5ZEljpreFvW82RRb5v5rbVqcTENJEP95lHs7zweJ8b62Nmt2zPu8
         l33iWwYoNgmssA9OfcgiLwCkNSt2MXI6M2TPkG92rPbBxZO5DoLdmaQmWCBF6QyIPEnP
         fWPTJ/+8BSbdREJVqOoAqBcemQN48YOrk4FsyEWQ7qOlqfePt1BWW/gF83J51Ww1bToi
         +nTuunN+Lgcq1C1dOOilnYEBS9ce6gPZnoi+X/WmY+U1rhULQB4xTKk1/XmIvrgc45LZ
         bil8qbDq2Yk8AiUqPxysD5r1f4FGexjZ6BNABUomGkj5W5QEdNieK0pibWPlkb7v5HCR
         OxzA==
X-Forwarded-Encrypted: i=1; AJvYcCWs2K8TFgPUznoDzMSSLn+zDdVOvD/OJac5ORMIROqlAS/UjmNy6XkO4aFPR51EwlfH1YA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrHv3NfJ+rzmY5lMN3ZmGr2XKFz65hpHn5YeNyByf6ejJ5Geqq
	n7CUj5vaRH46kMJqPH2yWZxvMGWSFQ5z8+Wr4/KRRb5/a+C6uAsUKeghAHcxCJYhYXM=
X-Gm-Gg: ASbGncuxvGuz07Dx6Lw+igE7mazpQ+gKJzBJYmqg+taJPj7xb2Dm+/QHhMEZMrRU7HW
	+N86rlHZ9tNcyTLO9AYfxTMNcK2JPCYzTiCCFkGIR1U0IATmftvQ0g31OquBzr7hpK8c00yOMcX
	YySiuirkCIf2bI01YHBn3BFw2teU57p5JnnlPZ8zEUk8sFF73nfXDt5pYZBUMQmpL1THbW3jmys
	qHRvFctsB6Vbf5HQZkop+xAsIo0Fu5HTZ8MypFl/U6DbntP4fa+2RTnjK8UeAu5wuMUhTO7h+rM
	b+uObfL+DH06Bn7eiI2Ac7VNklva2o+nWA9Hpkm/qDMcX8tD1vY2yLIcfdSdsJWEUA8/JesMBZ9
	vMZFpC1D5UH/GuC+H7R8zaXP/h9fBKkrUnelPf0nSeULjnj3bYxjwbWhDWJ2DKSfDnoE421IUUL
	WX/t745rDuS90C6J+URGl6x2GRkk3wb6/HzTRVt3VXiy/3XNn6flfP0Hyd
X-Google-Smtp-Source: AGHT+IHdomOA3fXFLRj5Qifi24Z8ILoy1R2tZQWL9HXByV1pnhKykseLX/aaxM1vhUTUzCoPwrvJjg==
X-Received: by 2002:a05:622a:22aa:b0:4ec:ef20:ac52 with SMTP id d75a77b69052e-4edfc87511cmr159168241cf.79.1763399780286;
        Mon, 17 Nov 2025 09:16:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee1c21ea34sm32656311cf.30.2025.11.17.09.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 09:16:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vL2pv-000000005PX-0G4a;
	Mon, 17 Nov 2025 13:16:19 -0400
Date: Mon, 17 Nov 2025 13:16:19 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex@shazbot.org>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
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
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v7 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251117171619.GB17968@ziepe.ca>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251110134218.5e399b0f.alex@shazbot.org>
 <da399efa-ad5b-4bdc-964d-b6cc4a4fc55d@amd.com>
 <20251117083620.4660081a.alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251117083620.4660081a.alex@shazbot.org>

On Mon, Nov 17, 2025 at 08:36:20AM -0700, Alex Williamson wrote:
> On Tue, 11 Nov 2025 09:54:22 +0100
> Christian König <christian.koenig@amd.com> wrote:
> 
> > On 11/10/25 21:42, Alex Williamson wrote:
> > > On Thu,  6 Nov 2025 16:16:45 +0200
> > > Leon Romanovsky <leon@kernel.org> wrote:
> > >   
> > >> Changelog:
> > >> v7:
> > >>  * Dropped restore_revoke flag and added vfio_pci_dma_buf_move
> > >>    to reverse loop.
> > >>  * Fixed spelling errors in documentation patch.
> > >>  * Rebased on top of v6.18-rc3.
> > >>  * Added include to stddef.h to vfio.h, to keep uapi header file independent.  
> > > 
> > > I think we're winding down on review comments.  It'd be great to get
> > > p2pdma and dma-buf acks on this series.  Otherwise it's been posted
> > > enough that we'll assume no objections.  Thanks,  
> > 
> > Already have it on my TODO list to take a closer look, but no idea when that will be.
> > 
> > This patch set is on place 4 or 5 on a rather long list of stuff to review/finish.
> 
> Hi Christian,
> 
> Gentle nudge.  Leon posted v8[1] last week, which is not drawing any
> new comments.  Do you foresee having time for review that I should
> still hold off merging for v6.19 a bit longer?  Thanks,

I really want this merged this cycle, along with the iommufd part,
which means it needs to go into your tree by very early next week on a
shared branch so I can do the iommufd part on top.

It is the last blocking kernel piece to conclude the viommu support
roll out into qemu for iommufd which quite a lot of people have been
working on for years now.

IMHO there is nothing profound in the dmabuf patch, it was written by
the expert in the new DMA API operation, and doesn't form any
troublesome API contracts. It is also the same basic code as from the
v1 in July just moved into dmabuf .c files instead of vfio .c files at
Christoph's request.

My hope is DRM folks will pick up the baton and continue to improve
this to move other drivers away from dma_map_resource(). Simona told
me people have wanted DMA API improvements for ages, now we have them,
now is the time!

Any remarks after the fact can be addressed incrementally.

If there are no concrete technical remarks please take it. 6 months is
long enough to wait for feedback.

Thanks,
Jason

