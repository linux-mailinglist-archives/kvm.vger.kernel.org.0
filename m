Return-Path: <kvm+bounces-19337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6849A904039
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:39:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EC9E1C20C5B
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3970638FAD;
	Tue, 11 Jun 2024 15:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WeVRuVmZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415D036AF5;
	Tue, 11 Jun 2024 15:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718120351; cv=none; b=UgnFzsbLh6ugygmjskKiue+KqsmMpLIY1WmeW41Wo/ITTzLzNO15mKJggt9hk6RJ0O/n3Hbpr/hFOkP1nAJ//CH1XKojVYmapdaHMGthFA/stVmmZH9a8o4AO1KYrce7LmJnO+89x0YpaXMPb6p70Q1P4VVlkeqUyOmJl0hHGQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718120351; c=relaxed/simple;
	bh=bbs0nZfYQResOgy6lgmjK0ssfkYQtU/jorgr5vVQcy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BthZYYjlrwo4QQQsDvdsL/QNQobqBq6bpdNOzgCqi47/N1utTSezulcJCkLxRZVJoHQuImWmsbLBhhc6cR4bjIHpdm1J71hw9CqYPswfJMGpiZozK7uJ49msz/+YRR5rEfJ7orUwFSEO5lbH663tUGuEXY7yGStDvsoZHbPefvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WeVRuVmZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1846C4AF50;
	Tue, 11 Jun 2024 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718120350;
	bh=bbs0nZfYQResOgy6lgmjK0ssfkYQtU/jorgr5vVQcy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WeVRuVmZNJeBvFynafLllgaQ1sTe/TVDnO5VctQIcUSYQOEU6L/J/vJOIjwNzo3A7
	 3Dtzy1al9A2/Tr6AlxBQt4JBTgsYowYoL2Bv6Z/KtfTMP8dSDRFtWh0392Fmf3JF2k
	 fKMz6OPHX2kvVcFojWdEXOXyw1HagFioPBsKsg65MLpyRx/2GOiSJx0A+nqbPJbV3u
	 A95bFHYsXOdOXRQyF3QNS9yP76xBy7lpFSCBIR/2jJ1QAeLiUXqF71va2CbrHX8VKl
	 uDjBRTCBn4VAxYQHsvExW6kvFQKq+NKp70xE3plLwPZSkFgB4mIj/paMAwzoxmxS3u
	 c+uVU5d1JvTpg==
Date: Tue, 11 Jun 2024 18:39:05 +0300
From: Leon Romanovsky <leon@kernel.org>
To: "Zeng, Oak" <oak.zeng@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"Brost, Matthew" <matthew.brost@intel.com>,
	"Hellstrom, Thomas" <thomas.hellstrom@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>,
	"Bommu, Krishnaiah" <krishnaiah.bommu@intel.com>,
	"Ghimiray, Himal Prasad" <himal.prasad.ghimiray@intel.com>
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
Message-ID: <20240611153905.GB4966@unreal>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
 <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
 <20240610161826.GA4966@unreal>
 <PH7PR11MB7004A071F27B4CF45740B87E92C62@PH7PR11MB7004.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH7PR11MB7004A071F27B4CF45740B87E92C62@PH7PR11MB7004.namprd11.prod.outlook.com>

On Mon, Jun 10, 2024 at 04:40:19PM +0000, Zeng, Oak wrote:
> Thanks Leon and Yanjun for the reply!
> 
> Based on the reply, we will continue use the current version for test (as it is tested for vfio and rdma). We will switch to v1 once it is fully tested/reviewed.

Sounds good, if v0 fits your need, the v1 will fit it too.

From HMM perspective, the change is minimal between them.
In v0, I called to dma_link_page() here and now it is called
dma_hmm_link_page().

https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/diff/drivers/infiniband/hw/mlx5/odp.c?h=dma-split-v1&id=a0d719a406133cdc3ef2328dda3ef082a034c45e


> 
> Thanks,
> Oak
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Monday, June 10, 2024 12:18 PM
> > To: Zeng, Oak <oak.zeng@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Christoph Hellwig <hch@lst.de>; Robin
> > Murphy <robin.murphy@arm.com>; Marek Szyprowski
> > <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> > Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
> > Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
> > <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>; Jens
> > Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
> > Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
> > Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian, Kevin
> > <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> > Jérôme Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> > foundation.org>; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> > iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> > kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> > <bvanassche@acm.org>; Damien Le Moal
> > <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> > <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> > <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
> > <dan.j.williams@intel.com>; jack@suse.com; Zhu Yanjun
> > <zyjzyj2000@gmail.com>; Bommu, Krishnaiah
> > <krishnaiah.bommu@intel.com>; Ghimiray, Himal Prasad
> > <himal.prasad.ghimiray@intel.com>
> > Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> > two steps
> > 
> > On Mon, Jun 10, 2024 at 03:12:25PM +0000, Zeng, Oak wrote:
> > > Hi Jason, Leon,
> > >
> > > I come back to this thread to ask a question. Per the discussion in another
> > thread, I have integrated the new dma-mapping API (the first 6 patches of
> > this series) to DRM subsystem. The new API seems fit pretty good to our
> > purpose, better than scatter-gather dma-mapping. So we want to continue
> > work with you to adopt this new API.
> > 
> > Sounds great, thanks for the feedback.
> > 
> > >
> > > Did you test the new API in RDMA subsystem?
> > 
> > This version was tested in our regression tests, but there is a chance
> > that you are hitting flows that were not relevant for RDMA case.
> > 
> > > Or this RFC series was just some untested codes sending out to get
> > people's design feedback?
> > 
> > RFC was fully tested in VFIO and RDMA paths, but not NVMe patch.
> > 
> > > Do you have refined version for us to try? I ask because we are seeing
> > some issues but not sure whether it is caused by the new API. We are
> > debugging but it would be good to also ask at the same time.
> > 
> > Yes, as an outcome of the feedback in this thread, I implemented a new
> > version. Unfortunately, there are some personal matters that are preventing
> > from me to send it right away.
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-
> > rdma.git/log/?h=dma-split-v1
> > 
> > There are some differences in the API, but the main idea is the same.
> > This version is not fully tested yet.
> > 
> > Thanks
> > 
> > >
> > > Cc Himal/Krishna who are also working/testing the new API.
> > >
> > > Thanks,
> > > Oak
> > >
> > > > -----Original Message-----
> > > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Sent: Friday, May 3, 2024 12:43 PM
> > > > To: Zeng, Oak <oak.zeng@intel.com>
> > > > Cc: leon@kernel.org; Christoph Hellwig <hch@lst.de>; Robin Murphy
> > > > <robin.murphy@arm.com>; Marek Szyprowski
> > > > <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
> > > > Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
> > > > Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
> > > > <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>;
> > Jens
> > > > Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
> > > > Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
> > > > Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian,
> > Kevin
> > > > <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
> > > > Jérôme Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
> > > > foundation.org>; linux-doc@vger.kernel.org; linux-
> > kernel@vger.kernel.org;
> > > > linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
> > > > iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
> > > > kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
> > > > <bvanassche@acm.org>; Damien Le Moal
> > > > <damien.lemoal@opensource.wdc.com>; Amir Goldstein
> > > > <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
> > > > <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
> > > > <dan.j.williams@intel.com>; jack@suse.com; Leon Romanovsky
> > > > <leonro@nvidia.com>; Zhu Yanjun <zyjzyj2000@gmail.com>
> > > > Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
> > > > two steps
> > > >
> > > > On Thu, May 02, 2024 at 11:32:55PM +0000, Zeng, Oak wrote:
> > > >
> > > > > > Instead of teaching DMA to know these specific datatypes, let's
> > separate
> > > > > > existing DMA mapping routine to two steps and give an option to
> > > > advanced
> > > > > > callers (subsystems) perform all calculations internally in advance and
> > > > > > map pages later when it is needed.
> > > > >
> > > > > I looked into how this scheme can be applied to DRM subsystem and
> > GPU
> > > > drivers.
> > > > >
> > > > > I figured RDMA can apply this scheme because RDMA can calculate the
> > > > > iova size. Per my limited knowledge of rdma, user can register a
> > > > > memory region (the reg_user_mr vfunc) and memory region's sized is
> > > > > used to pre-allocate iova space. And in the RDMA use case, it seems
> > > > > the user registered region can be very big, e.g., 512MiB or even GiB
> > > >
> > > > In RDMA the iova would be linked to the SVA granual we discussed
> > > > previously.
> > > >
> > > > > In GPU driver, we have a few use cases where we need dma-mapping.
> > Just
> > > > name two:
> > > > >
> > > > > 1) userptr: it is user malloc'ed/mmap'ed memory and registers to gpu
> > > > > (in Intel's driver it is through a vm_bind api, similar to mmap). A
> > > > > userptr can be of any random size, depending on user malloc
> > > > > size. Today we use dma-map-sg for this use case. The down side of
> > > > > our approach is, during userptr invalidation, even if user only
> > > > > munmap partially of an userptr, we invalidate the whole userptr from
> > > > > gpu page table, because there is no way for us to partially
> > > > > dma-unmap the whole sg list. I think we can try your new API in this
> > > > > case. The main benefit of the new approach is the partial munmap
> > > > > case.
> > > >
> > > > Yes, this is one of the main things it will improve.
> > > >
> > > > > We will have to pre-allocate iova for each userptr, and we have many
> > > > > userptrs of random size... So we might be not as efficient as RDMA
> > > > > case where I assume user register a few big memory regions.
> > > >
> > > > You are already doing this. dma_map_sg() does exactly the same IOVA
> > > > allocation under the covers.
> > > >
> > > > > 2) system allocator: it is malloc'ed/mmap'ed memory be used for GPU
> > > > > program directly, without any other extra driver API call. We call
> > > > > this use case system allocator.
> > > >
> > > > > For system allocator, driver have no knowledge of which virtual
> > > > > address range is valid in advance. So when GPU access a
> > > > > malloc'ed/mmap'ed address, we have a page fault. We then look up a
> > > > > CPU vma which contains the fault address. I guess we can use the CPU
> > > > > vma size to allocate the iova space of the same size?
> > > >
> > > > No. You'd follow what we discussed in the other thread.
> > > >
> > > > If you do a full SVA then you'd split your MM space into granuals and
> > > > when a fault hits a granual you'd allocate the IOVA for the whole
> > > > granual. RDMA ODP is using a 512M granual currently.
> > > >
> > > > If you are doing sub ranges then you'd probably allocate the IOVA for
> > > > the well defined sub range (assuming the typical use case isn't huge)
> > > >
> > > > > But there will be a true difficulty to apply your scheme to this use
> > > > > case. It is related to the STICKY flag. As I understand it, the
> > > > > sticky flag is designed for driver to mark "this page/pfn has been
> > > > > populated, no need to re-populate again", roughly...Unlike userptr
> > > > > and RDMA use cases where the backing store of a buffer is always in
> > > > > system memory, in the system allocator use case, the backing store
> > > > > can be changing b/t system memory and GPU's device private
> > > > > memory. Even worse, we have to assume the data migration b/t
> > system
> > > > > and GPU is dynamic. When data is migrated to GPU, we don't need
> > > > > dma-map. And when migration happens to a pfn with STICKY flag, we
> > > > > still need to repopulate this pfn. So you can see, it is not easy to
> > > > > apply this scheme to this use case. At least I can't see an obvious
> > > > > way.
> > > >
> > > > You are already doing this today, you are keeping the sg list around
> > > > until you unmap it.
> > > >
> > > > Instead of keeping the sg list you'd keep a much smaller datastructure
> > > > per-granual. The sticky bit is simply a convient way for ODP to manage
> > > > the smaller data structure, you don't have to use it.
> > > >
> > > > But you do need to keep track of what pages in the granual have been
> > > > DMA mapped - sg list was doing this before. This could be a simple
> > > > bitmap array matching the granual size.
> > > >
> > > > Looking (far) forward we may be able to have a "replace" API that
> > > > allows installing a new page unconditionally regardless of what is
> > > > already there.
> > > >
> > > > Jason

