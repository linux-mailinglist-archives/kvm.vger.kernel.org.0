Return-Path: <kvm+bounces-21067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 031C8929742
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 11:16:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD0EF281AF4
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 09:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1FA17BAA;
	Sun,  7 Jul 2024 09:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrzWOY/i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB448F9E8;
	Sun,  7 Jul 2024 09:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720343790; cv=none; b=MMjHHxnTYEWu+AbFMm1i/H9FAUuAVIQgo7du67r5PLEeZmXCdbvxVXFm+MiR2nnaGtACutkRbJ9Dc1Bz5zlA6zp/QVd/QA9cMVWYqhiK9D4/VystGNrn4ui5CzbQ4OIwT1Kf2Zz0NdnoqJckYzKcEEEVKrUWnwZaK3kknQO09ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720343790; c=relaxed/simple;
	bh=izDf2P+sHbjiti59EE/8GV6nvVep7QKF5KGW0AiU1Mc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9reP2PqMclml2dOmO2JWWxuGowhCQMaZOZcCC5T31r39cban/wyZfzz6HyWhedoTRGM6Vjsc0b5wJ2jzldPmXzzCRbnpbWAuP7hieku8CFXC9d4qspt50Ju8o4sFrj7Bkvj53ICRkqWoj3OGg9N9SWyra8MvNCTv2xitPgK+fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrzWOY/i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E6FC3277B;
	Sun,  7 Jul 2024 09:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720343790;
	bh=izDf2P+sHbjiti59EE/8GV6nvVep7QKF5KGW0AiU1Mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CrzWOY/iDzSJOaiIMaP3xE97eiLSDi4CB0wI1+TEQAHNCz2g05KYsFt/aL1GPMP5r
	 HBnYK2RTylUHc0Vx3NyVD3bOosNt0zckrQesG42uJ6MRet5D6FmAW0PeAe7m5PvfaN
	 iwrSjlS4jkggMxmOqgmohWVRswxNEnNV8RBiej41b/zEaRlr+A3diLegBHOwF8ZWa6
	 9dtd/aY/wBeNy4rWL2+0ucK1I0ZgukePTbNlgwltGYYIXxXU7unResX6O/FNT5nk51
	 W41NViVj5N3M41fW4A1fLX7G15TRIE214CPnx2WARzr2ky472lBfuc0iEJOgY0DDB3
	 Pn2He452QkIyw==
Date: Sun, 7 Jul 2024 12:16:26 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Keith Busch <kbusch@kernel.org>,
	"Zeng, Oak" <oak.zeng@intel.com>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240707091626.GH6695@unreal>
References: <cover.1719909395.git.leon@kernel.org>
 <20240703054238.GA25366@lst.de>
 <20240703105253.GA95824@unreal>
 <20240703143530.GA30857@lst.de>
 <a7f1c69a-bbaf-4263-b2c2-3c92d65522c2@nvidia.com>
 <20240706062604.GA13874@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240706062604.GA13874@lst.de>

On Sat, Jul 06, 2024 at 08:26:04AM +0200, Christoph Hellwig wrote:
> On Fri, Jul 05, 2024 at 10:53:06PM +0000, Chaitanya Kulkarni wrote:
> > I tried to reproduce this issue somehow it is not reproducible.
> > 
> > I'll try again on Leon's setup on my Saturday night, to fix that
> > case.
> 
> It is passthrough I/O from userspace.  The address is not page aligned
> as seen in the printk.  Forcing bounce buffering of all passthrough
> I/O makes it go away.
> 
> The problem is the first mapped segment does not have to be aligned
> and we're missing the code to places it at the aligned offset into
> the IOVA space.

Thanks for the explanation.

