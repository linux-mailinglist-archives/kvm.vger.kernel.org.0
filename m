Return-Path: <kvm+bounces-31326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26EFA9C2695
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 21:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D51481F23ED4
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630981F26E6;
	Fri,  8 Nov 2024 20:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQxdbUUk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5923F1F26CB;
	Fri,  8 Nov 2024 20:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731097663; cv=none; b=Lgsrqhrw2PN88o2ZIUsYIGQVvI0qky8vAFRHPaX7U0iUr/ln6eVWNNmO8eKsdC9ggO6OUTgTF38RNK37rK6t5pQloxTMsyn1Hy/nXw3xOeGhuLtbj29Kb7TlnNL8Eyq2QQKHeiY21QgALZ7WpusbBJgjDKEnGlYfFhDZIc7Sy+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731097663; c=relaxed/simple;
	bh=fEkKlC8Hg48yKdWPTMBAlRN6pz1/ghsdZabweHXbhzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2/3QqU2uOu3GXe4y0bTALkt19yTJ3s0chikNIQh0ABLV6O8FFbJwwkqK5IEdPCcqSN0Yr1w64UzyK9fOyEzNVquH7zkkrRcX+y7tG7OMgo81A+cq7R4HSTMPVbeqI9F/YLT4F0ccyZPc0GFVq1fPgtaPkDKTDT6Ee9+KrTZkp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQxdbUUk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34E3C4CEEF;
	Fri,  8 Nov 2024 20:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731097662;
	bh=fEkKlC8Hg48yKdWPTMBAlRN6pz1/ghsdZabweHXbhzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kQxdbUUkl22MhYJ7DwatoeDKWjNx/F1CJZOuLcFdp7LQvaPdVdHti+/hn/sheWd1+
	 CgCPfKci9ZZtTsEivm1eh8hhse4OzQu82g9Eo+eLUOy0LlG3gmIHJFv6Czp1bMK3OQ
	 67ei1ypM2zP7JkXKKaBNvFhdvLTvyEXfpc2fQrzlvSNPP8INjRX4G++0yeANG1bnXI
	 vaDXlNFUIih+7l1wn1ZT8Zma+fi2I1SHUMIr3fOWOVKVI9GXzLI4dcX1J17510r/kq
	 Ynakuwz3YuW6CL+ZtvWHtcGl1MD/ZSDtjDLhq8q6xZLi9xuaOGnDyb6OWJu4ygrF/P
	 Z/t2NqXY6f9Pw==
Date: Fri, 8 Nov 2024 22:27:36 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
Message-ID: <20241108202736.GD189042@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
 <87ttchwmde.fsf@trenco.lwn.net>
 <20241108200355.GC189042@unreal>
 <87h68hwkk8.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h68hwkk8.fsf@trenco.lwn.net>

On Fri, Nov 08, 2024 at 01:13:27PM -0700, Jonathan Corbet wrote:
> Leon Romanovsky <leon@kernel.org> writes:
> 
> >> So, I see that you have nice kernel-doc comments for these; why not just
> >> pull them in here with a kernel-doc directive rather than duplicating
> >> the information?
> >
> > Can I you please point me to commit/lore link/documentation with example
> > of such directive and I will do it?
> 
> Documentation/doc-guide/kernel-doc.rst has all the information you need.
> It could be as simple as replacing your inline descriptions with:
> 
>   .. kernel-doc:: drivers/iommu/dma-iommu.c
>      :export:
> 
> That will pull in documentation for other, unrelated functions, though;
> assuming you don't want those, something like:
> 
>   .. kernel-doc:: drivers/iommu/dma-iommu.c
>      :identifiers: dma_iova_try_alloc dma_iova_free ...
> 
> Then do a docs build and see the nice results you get :)

Thanks for the explanation, will change it.

> 
> Thanks,
> 
> jon

