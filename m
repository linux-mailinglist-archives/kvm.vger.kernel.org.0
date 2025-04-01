Return-Path: <kvm+bounces-42282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3172DA7723A
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 03:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68B511886D2F
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 01:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9C4415B135;
	Tue,  1 Apr 2025 01:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ce0nhRfs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23FD3595D;
	Tue,  1 Apr 2025 01:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743469771; cv=none; b=uK4+O16uJDGrjLCVE4zwPpu1nSVSSs8vP+vAI/wDg7G0lnSzXJXHo+6wxBMhcIU7E+fn7aFmbRitH6Tl0b6rpO56GG8t9LoQE1RD3aTsw7b5i6xdnNYfonZVkbJjoQD5EK/tNsBYnAdYEucrG8pYG3HMHl2j+5J740VswEIE0s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743469771; c=relaxed/simple;
	bh=xnDKz4hdm/kkZqcWSzvYO96l5CqeHbCretys4W9iu2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGihU/Z7m0/tO7rJ8ZFFvjo3RML6cRJoR/drLSBkZ6Jj2bq1t8exDUHY17iPyUswYt/u8kgmRo/Ikz76bOzsa7uarfjfNTDHyFGUnom8Li/N3u3FBEi4HQ2jg15tLIyy2wyCskXJxQiU2axPpwOBctliM38vveLhxG5RieF/WNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ce0nhRfs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978F4C4CEE3;
	Tue,  1 Apr 2025 01:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743469769;
	bh=xnDKz4hdm/kkZqcWSzvYO96l5CqeHbCretys4W9iu2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ce0nhRfsh4foP8kliSiSC0eCyy1P530wNZv1yXlz0fhnntdzc2pHj8ehJ73sKloVM
	 C0cw7cUj+BIc9kmwIU3OVnx2X/5KZolUkXS2nrcBmOD80XEOnwWEu+qaNld4IC1Lbz
	 ktTwM4BKKx5FIv7O9NfsPq2v7mz23KDqI6mFjPh6003pPohStRGfOcfyHzqdAMOVmD
	 1gOusmiwUbvZzBP/fZDRftY7IT+SckUkPyIVGM5JFjlw/2fk+9/Ns880REt1nFz5Or
	 pRuSFvVxXKUnth/AX3auD+qu9VK2N7OyoDzrtCOl5aOlD0WNxZyXTU1dmfK4K2DInq
	 5BLO5MT41pJgw==
Date: Mon, 31 Mar 2025 18:09:27 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Leon Romanovsky <leon@kernel.org>, Daniel Gomez <da.gomez@samsung.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
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
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
Message-ID: <Z-s8x_YyGEYTz8BJ@bombadil.infradead.org>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
 <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
 <20250302085717.GO53094@unreal>
 <e024fe3d-bddf-4006-8535-656fd0a3fada@arm.com>
 <Z+KjVVpPttE3Ci62@ziepe.ca>
 <20250325144158.GA4558@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250325144158.GA4558@unreal>

On Tue, Mar 25, 2025 at 04:41:58PM +0200, Leon Romanovsky wrote:
> On Tue, Mar 25, 2025 at 09:36:37AM -0300, Jason Gunthorpe wrote:
> > On Fri, Mar 21, 2025 at 04:05:22PM +0000, Robin Murphy wrote:
> 
> <...>
> 
> > > So what is it now, a layering violation in a hat with still no clear path to
> > > support SWIOTLB?
> > 
> > I was under the impression Leon had been testing SWIOTLB?
> 
> Yes, SWIOTLB works

We will double check too.

> and Christoph said it more than once that he tested
> NVMe conversion patches and they worked.

We've taken this entire series and the NVMe patches and have built on
top of them. The nvme-pci driver does not have scatter list chaining
support, and we don't want to support that because it is backwards.
Instead, the two step DMA API lets us actually remove all that scatter
list cruft and provide a single solution for direct IO and io-uring
command passthrough to support large IOs [0] [1] and logical block sizes
up to 2 MiB.

We continue to plan to work on this and are happy to test this further.

Clearly, we don't want any regressions on NVMe.

[0] https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
[1] https://lore.kernel.org/all/Z9v-1xjl7dD7Tr-H@bombadil.infradead.org/

  Luis

