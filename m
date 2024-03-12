Return-Path: <kvm+bounces-11696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA37879D80
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 22:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CF061C218C3
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 21:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039E7143C6A;
	Tue, 12 Mar 2024 21:28:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E425143736;
	Tue, 12 Mar 2024 21:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710278934; cv=none; b=c1Z2b7pizgN/32qSGZrAdtmKt4c9NG7AxCxsS2J3a4LEvV5pVQj8AjOm/119arXvRx0ilEdmAWWU+ZjVyHpKJWcuGnT9RJVrS2PXo2mcZ2+6E1fg/TsGVOhZKJO9hgEjOztRAwMkq+kCyUfQ+UUbGH0r8vdmMSFpIXgJVMcMJZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710278934; c=relaxed/simple;
	bh=BRQTLaIPx6C1TH1fJOMUn+wWNHenNMsiGQ36m5L9rtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUaSLr3fMhCWL6/cnQGL7z8+tAZuUBAwPU0MfKC8Stmo5L2Unp0zoRK7urt13mG/M/+rJP0+qpcMy1xOKQ3ggtNf0ZrvVrO9sGDoGYOCbixIBbmWd6eXJrNoT/3vAOLO4l7kaXXlBW/yKU6W1FEtRkkdZOQdSTXygpuhT/saT1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 514BE68BFE; Tue, 12 Mar 2024 22:28:45 +0100 (CET)
Date: Tue, 12 Mar 2024 22:28:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>, Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two
 steps
Message-ID: <20240312212844.GA3018@lst.de>
References: <20240306162022.GB28427@lst.de> <20240306174456.GO9225@ziepe.ca> <20240306221400.GA8663@lst.de> <20240307000036.GP9225@ziepe.ca> <20240307150505.GA28978@lst.de> <20240307210116.GQ9225@ziepe.ca> <20240308164920.GA17991@lst.de> <20240308202342.GZ9225@ziepe.ca> <20240309161418.GA27113@lst.de> <20240310093513.GB12921@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240310093513.GB12921@unreal>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Mar 10, 2024 at 11:35:13AM +0200, Leon Romanovsky wrote:
> And you will need to have a way to instruct that pin_user_pages() variant
> to continue anyway, because you asked for FOLL_PCI_P2PDMA. Without that
> force, you will have !FOLL_PCI_P2PDMA behaviour.

I don't understand what you mean.

> When you say "simplify the overall interface", which interface do you mean?

Primarily the dma mapping interface.  Secondarily also everything around
it.

