Return-Path: <kvm+bounces-21074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 594499297DC
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 14:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0689281664
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 12:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938F4208BC;
	Sun,  7 Jul 2024 12:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B5f9eRBl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9681EAF9;
	Sun,  7 Jul 2024 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720356323; cv=none; b=mPulzdV9YhvNLA+1hVy0UQm33ot5PinUgj2D6fXc7h+WvIldiFNo3WDOBOXx6KtWYK1C/0a5bZB7xo5mO1JxSrArRU9x17Gj6KNFVm/FzXLMk7GSvtbx+VeLezYbGnLfuYeg48B4r/3b2QDvwRWr4irQ3/RyouR5hxdF+epVgZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720356323; c=relaxed/simple;
	bh=czFFfEBbR8ok8jHwfrliPjw/AEnBBl1bqvsRaPlne1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSkynVuS+ple05tzEIYqEJ1XD+HQwjFWmUSl4gCqnaWvys0mbtzzistAhqVuQ1UramXiKl6DwGwEurjP2Bbf600lSYkMdu2SQrtsUujh0N3FL81tWdS5LDELqNtRvmWwX21fCvJJ43yc+xGKxTVBX7R1cgAxAxJru3GX++UtPkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B5f9eRBl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4BFC3277B;
	Sun,  7 Jul 2024 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720356323;
	bh=czFFfEBbR8ok8jHwfrliPjw/AEnBBl1bqvsRaPlne1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B5f9eRBl+KGgWT936EUGd6T+cWk+xRkiMuBWJ5KKIla4grwmOiaeeJlF3DZ+c3QZ1
	 tSTM7ND1gap34VnoYGF3pUZy6KttEu3a65c+wDFCySSopNt+JmgXnwEvrTb4r+G2TO
	 lLHSwl+otE7ipDb/K+1cBYw15NLZqlbxcA7JGZ8BdqyX9fOMxjVqh6eczfvqUO6ZFB
	 LsNV5y8I3AOqlFDmbuJQUcvxTH7HQvHKUXwJ9XePUW3qHZs3Y3iB6BMDK09x4Z1vXW
	 5t6O8jgD1hQCw70V39qXX5shMuw4oTYi+YCcq8o2BfTnfZAzxa3MG9D4jIC/OQYcEU
	 LchGoei8yUjUQ==
Date: Sun, 7 Jul 2024 15:45:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>, "Zeng, Oak" <oak.zeng@intel.com>,
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
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Message-ID: <20240707124518.GK6695@unreal>
References: <cover.1719909395.git.leon@kernel.org>
 <20240703054238.GA25366@lst.de>
 <20240703105253.GA95824@unreal>
 <20240703143530.GA30857@lst.de>
 <a7f1c69a-bbaf-4263-b2c2-3c92d65522c2@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7f1c69a-bbaf-4263-b2c2-3c92d65522c2@nvidia.com>

On Fri, Jul 05, 2024 at 10:53:06PM +0000, Chaitanya Kulkarni wrote:
> On 7/3/24 07:35, Christoph Hellwig wrote:
> > On Wed, Jul 03, 2024 at 01:52:53PM +0300, Leon Romanovsky wrote:
> >> On Wed, Jul 03, 2024 at 07:42:38AM +0200, Christoph Hellwig wrote:
> >>> I just tried to boot this on my usual qemu test setup with emulated
> >>> nvme devices, and it dead-loops with messages like this fairly late
> >>> in the boot cycle:
> >>>
> >>> [   43.826627] iommu: unaligned: iova 0xfff7e000 pa 0x000000010be33650 size 0x1000 min_pagesz 0x1000
> >>> [   43.826982] dma_mapping_error -12
> >>>
> >>> passing intel_iommu=off instead of intel_iommu=on (expectedly) makes
> >>> it go away.
> >> Can you please share your kernel command line and qemu?
> >> On my and Chaitanya setups it works fine.
> > qemu-system-x86_64 \
> >          -nographic \
> > 	-enable-kvm \
> > 	-m 6g \
> > 	-smp 4 \
> > 	-cpu host \
> > 	-M q35,kernel-irqchip=split \
> > 	-kernel arch/x86/boot/bzImage \
> > 	-append "root=/dev/vda console=ttyS0,115200n8 intel_iommu=on" \
> >          -device intel-iommu,intremap=on \
> > 	-device ioh3420,multifunction=on,bus=pcie.0,id=port9-0,addr=9.0,chassis=0 \	
> >          -blockdev driver=file,cache.direct=on,node-name=root,filename=/home/hch/images/bookworm.img \
> > 	-blockdev driver=host_device,cache.direct=on,node-name=test,filename=/dev/nvme0n1p4 \
> > 	-device virtio-blk,drive=root \
> > 	-device nvme,drive=test,serial=1234
> >
> 
> I tried to reproduce this issue somehow it is not reproducible.
> 
> I'll try again on Leon's setup on my Saturday night, to fix that
> case.

Chaitanya,

I added "mem_align=120" line to fio configuration file and the issue reproduced.

Thanks

> 
> -ck
> 
> 
> 

