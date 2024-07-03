Return-Path: <kvm+bounces-20898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C76B926383
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 16:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 108501F23637
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 14:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FAA17C22D;
	Wed,  3 Jul 2024 14:35:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605251791EF;
	Wed,  3 Jul 2024 14:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720017342; cv=none; b=V9lUQLrQi7kCpzCzhICdxawP6BfZFJSHaOYzM9+60otS0mVL32hxXIb+lmU70q04moAxeceYHWc7QO3xzEE2pag2rCz9PRBqaW7KxY8eviVh8dNCLMTrmb9wEwa5BvAbI40flnUeyG6BRR8RbOs+0+eDzQNcbeyZPx4Aj9ypya8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720017342; c=relaxed/simple;
	bh=fG/bQbz4zGDzjdtmGG4BM/JphqsFn64XCAczIMZFNZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7LjuSEBzTdyPb8CBvlmxKn3yxR4lLUXcpzd4CuPcBHt97C2SV1+k1RKPgoeBCkhnoGLz1Zos+0CHV8FctdgGBx8VC8lpkmHQNO7C5jjZmPQUgaGcyDBafYUbadJBjiODn2/R29jyxzNo6ERsOqpDiDyZJwhLVtwG0TQHDahIiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D1D0E68AFE; Wed,  3 Jul 2024 16:35:30 +0200 (CEST)
Date: Wed, 3 Jul 2024 16:35:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>, "Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240703143530.GA30857@lst.de>
References: <cover.1719909395.git.leon@kernel.org> <20240703054238.GA25366@lst.de> <20240703105253.GA95824@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703105253.GA95824@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 03, 2024 at 01:52:53PM +0300, Leon Romanovsky wrote:
> On Wed, Jul 03, 2024 at 07:42:38AM +0200, Christoph Hellwig wrote:
> > I just tried to boot this on my usual qemu test setup with emulated
> > nvme devices, and it dead-loops with messages like this fairly late
> > in the boot cycle:
> > 
> > [   43.826627] iommu: unaligned: iova 0xfff7e000 pa 0x000000010be33650 size 0x1000 min_pagesz 0x1000
> > [   43.826982] dma_mapping_error -12
> > 
> > passing intel_iommu=off instead of intel_iommu=on (expectedly) makes
> > it go away.
> 
> Can you please share your kernel command line and qemu?
> On my and Chaitanya setups it works fine.

qemu-system-x86_64 \
        -nographic \
	-enable-kvm \
	-m 6g \
	-smp 4 \
	-cpu host \
	-M q35,kernel-irqchip=split \
	-kernel arch/x86/boot/bzImage \
	-append "root=/dev/vda console=ttyS0,115200n8 intel_iommu=on" \
        -device intel-iommu,intremap=on \
	-device ioh3420,multifunction=on,bus=pcie.0,id=port9-0,addr=9.0,chassis=0 \	
        -blockdev driver=file,cache.direct=on,node-name=root,filename=/home/hch/images/bookworm.img \
	-blockdev driver=host_device,cache.direct=on,node-name=test,filename=/dev/nvme0n1p4 \
	-device virtio-blk,drive=root \
	-device nvme,drive=test,serial=1234


