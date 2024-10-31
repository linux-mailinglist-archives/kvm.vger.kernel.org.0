Return-Path: <kvm+bounces-30153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9399B770F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:05:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CB6AB23C52
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334D91946CA;
	Thu, 31 Oct 2024 09:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmlWshUd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3BE1BD9ED;
	Thu, 31 Oct 2024 09:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730365536; cv=none; b=jRLFUHaDhawOOosw6jwRBzwt5fS8zFezPukS0atGK0S42PyfSRRdJQh11Nfiy/YiLnpuZ+l2Ho3dy6KrwOfC8BwEiw2iYK1HEn9yPixKjAEWTrkCmnDTxWJ8j14+jbkH1kKDs9bW0G4KNkjvoLoCkFsGmKuFJiNfzc90Q6GS5M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730365536; c=relaxed/simple;
	bh=GG1JVJs4dR1AOjE1AJ7ilFPgtAWW0eecmwqTp/vt+xo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JL4tYAR5kRcDvdtnAsHyh0rE+tlwPiEGJmicXcf1WZbwYu19Wuo6qD54KAXfllD83qohOO84Y3TImntX5oYPtHLMqoCRyYw9Ghduf33ADU9ivkGJQ0JlE4J9BWHYTid3RblvUAGNLjMdQvMeNxVLEBjOA9nvesucvGgkw6/C5kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmlWshUd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46ACC4CEC3;
	Thu, 31 Oct 2024 09:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730365535;
	bh=GG1JVJs4dR1AOjE1AJ7ilFPgtAWW0eecmwqTp/vt+xo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QmlWshUdBNcB1FWxXRPNndrpzxX3aAqhzeAeIGagnyn4fy5f45tGBkaDIMtVIOMSH
	 f2449uvXl29R43CYnG1NWyJNJFs8AcYS+J3/4AoaP+t4DGqAhmFlaAi0DonSP1IJXs
	 nqTFKGmBX62BU7Kq02whoNjJqhZNJXu4xTMAUf5TA9MsBWXeKgqU/7OfPHX4JQdM6Q
	 cYeO/+jCF2CQ7VRPVWNfb4dd0leBLAU/Wm+kzEVcI2myW0Ik/rO07OwQb1Z9w7wpM9
	 cbflE1vTPSMudvnmxNiKBwpQsf9zOOlAijHfeIWAa1xqN0InkTRlZPm0qFA7PRteHE
	 VKaKdM1Y44eGA==
Date: Thu, 31 Oct 2024 11:05:30 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
Message-ID: <20241031090530.GC7473@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <3144b6e7-5c80-46d2-8ddc-a71af3c23072@kernel.dk>
 <20241031083450.GA30625@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031083450.GA30625@lst.de>

On Thu, Oct 31, 2024 at 09:34:50AM +0100, Christoph Hellwig wrote:
> On Wed, Oct 30, 2024 at 07:44:13PM -0600, Jens Axboe wrote:
> > On Christoph's request, I tested this series last week and saw some
> > pretty significant performance regressions on my box. I don't know what
> > the status is in terms of that, just want to make sure something like
> > this doesn't get merged until that is both fully understood and sorted
> > out.

This series is a subset of the series you tested and doesn't include the
block layer changes which most likely were the cause of the performance
regression.

This is why I separated the block layer changes from the rest of the series
and marked them as RFC.

The current patch set is viable for HMM and VFIO. Can you please retest
only this series and leave the block layer changes for later till Christoph
finds the answer for the performance regression?

Thanks

> 
> Working on it, but I have way too many things going on at once.  Note
> that the weird thing about your setup was that we apparently dropped into
> the slow path, which still puzzles me.  But I should probably also look
> into making that path a little less slow.
> 
> 

