Return-Path: <kvm+bounces-43748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC66A95E2A
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0710189942F
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 06:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077AE221FA2;
	Tue, 22 Apr 2025 06:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QW0rpbca"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5FB4778E;
	Tue, 22 Apr 2025 06:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745303278; cv=none; b=u52VX5lk+4WANkpkwZt2Tkek08rT/8uYSvCCDx9lfFVJp8k/NSxiINOzzXC0trNTcNt/iJ2L7Dgd2Eazl+lq6eutQ68ciwhwgRnRPLCalVCnmQvzlKBiTqkXqFDj2xx+nHAJVeDHMfuqq+0k+ITaJL2cTg8vK7A0/3pvLXygfTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745303278; c=relaxed/simple;
	bh=K/UAYNGW+EGbI1H04eX8UxOvRa4n5wUxixuO/0uoGJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUFvRXDdecCKxXPNQcciMM1owhRX9FxhSiBmf/RRvHtxkheVxtcsSGl+KFW22KR5lT81b9g6FSlrvHNcqhVdfEZaH5wvg0JsiAtp2iD3zQoUhxAtodUZ2CdyZf+PMtO8pGs682G6t2cCncQC490zaR7b4k9JADyRwi24KVPGUEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QW0rpbca; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B52C4CEED;
	Tue, 22 Apr 2025 06:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745303277;
	bh=K/UAYNGW+EGbI1H04eX8UxOvRa4n5wUxixuO/0uoGJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QW0rpbcaMDKlHGvmZFs7EWfVYZTF2SFlCR50sPjI+BZbZ+rHRKg33QAuRqAlmeKwl
	 hw7/8EB+Yc0MAW3Qcc2No4o//tS1EIta9xnfM9gwive45sVzdc1MfufZEM0Je7cU3m
	 aXN/RYcmHmsTtDrU6rhjAoII86M7gR1jEbLMKaR9rTZKG93G7wFS8Bjt72MK3PgKrb
	 X182oDyajkgEYMC5steH0iQSzN8PjLNC22mBrm580ovmf0wwFTcBd93ktJ5YL0a7IO
	 bXn39Vspt4zw+2SnWqR9Y2E16qv8ASf3RlJw/1bovKeC3C1ijPotmMOhEnBsDMenV+
	 mMzYy0qavmPEA==
Date: Tue, 22 Apr 2025 09:27:52 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
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
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v8 04/24] iommu: add kernel-doc for iommu_unmap and
 iommu_unmap_fast
Message-ID: <20250422062752.GA48485@unreal>
References: <cover.1744825142.git.leon@kernel.org>
 <d3ad1e84d896aea97ebbd01c414fb1f07dc791d3.1744825142.git.leon@kernel.org>
 <20250422042330.GA27723@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422042330.GA27723@lst.de>

On Tue, Apr 22, 2025 at 06:23:30AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 18, 2025 at 09:47:34AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Add kernel-doc section for iommu_unmap and iommu_unmap_fast to document
> > existing limitation of underlying functions which can't split individual
> > ranges.
> 
> This actually only adds kerneldoc to iommu_unmap_fast.

Thanks, Jason documented iommu_unmap in this patch.
https://lore.kernel.org/r/3-v3-b3a5b5937f56+7bb-arm_no_split_jgg@nvidia.com

I'll update the commit message.

