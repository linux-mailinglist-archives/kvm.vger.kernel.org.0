Return-Path: <kvm+bounces-29926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 318679B4375
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 08:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A2FA2B214BA
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 07:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ACA92036FE;
	Tue, 29 Oct 2024 07:46:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9625B1DE3C5;
	Tue, 29 Oct 2024 07:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730187999; cv=none; b=OGnJl3u1h0EqrhlZb3yW+xNWx/3dRKcdiP9MEH/UfTWrL/QSNRgXsYXxXVvJDtFRi6Y0jbsjJ9ISxDxqaN09ps2qjes12jKJ1XkACEKvbqRUjpdBCDRamiLEeoY5S8AIi+qm5w6VbbwH9bpilnxPog3p2MLAx/8EbeonQlJ5bTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730187999; c=relaxed/simple;
	bh=ey/h1UWH4PsNFprB/VIDBkwWQ4/GYp79V4On9mrOAm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XOykepanynGTbRTeCcIvfAuXWq3x/eThjVkc8cGGaDXpQ+BkEp+Bxh93LioKhR8D2q9AtF2yWD/9OUgytTxVwVeN/jOAC4IaKbYUYrFSwRqFoC8FSWEDeK2l/nlVzzOw71gC+7dm54yJSltCNXcJ18gDC/wI2VaSzv8lTbBpzM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E1051227A88; Tue, 29 Oct 2024 08:46:31 +0100 (CET)
Date: Tue, 29 Oct 2024 08:46:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/18] dma: Provide an interface to allow allocate IOVA
Message-ID: <20241029074631.GD22316@lst.de>
References: <cover.1730037276.git.leon@kernel.org> <844f3dcf9c341b8178bfbc90909ef13d11dd2193.1730037276.git.leon@kernel.org> <25c32551-32e2-4a44-b0ae-30ad08e06799@linux.intel.com> <20241028063740.GD1615717@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028063740.GD1615717@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 28, 2024 at 08:37:40AM +0200, Leon Romanovsky wrote:
> In this specific case, the physical address is used to calculate
> IOVA offset, see "size_t iova_off = iova_offset(iovad, phys);" line,
> which is needed for NVMe PCI/block layer, as they can have first
> address to be unaligned and IOVA allocation will need an offset to
> properly calculate size.

And that is also very explicitly spelled out in the kerneldoc comments,
including the note that the physical address is optional if the
transfer is granule aligned (actually it says PAGE_SIZE which should
be fixed).

Any suggestions to further improve it are welcome of course.


