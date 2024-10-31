Return-Path: <kvm+bounces-30248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A53359B848B
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3413BB25421
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F3C1CCEE2;
	Thu, 31 Oct 2024 20:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lr7kPUgI"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4484149C55;
	Thu, 31 Oct 2024 20:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730407391; cv=none; b=NKI2eZTcXD4gGnQ966LEFxyxOQQE1uOmDpmih0aXhFnqDXs0qXpT/tqnr1ja1sYM9NqKu6O64NDv4bjvrq8Y/VGpEjABgGODWS1RZZxideCeTM4372rZLGT22XLmIEMQQ3h7ssAThUqauzBbEO3+lbw1i/PKmLI5grqyAKF8K8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730407391; c=relaxed/simple;
	bh=H9TYKTBvHoQ5rvWOlZrf5R8cp5gm744S0WtiOVj2YhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQ6vyye8Y2R4V3qRUCATesG+f7RmUzE2M+Is2l+G1NUeK/6fHM7Qd/ZKl2NlNiRAbO8XyZNvOTYFegqzhiXJPT8kXgN87d7JSrcOjY6tw7PvylqA2DSCMULKkfWZnjov8kxP7DF5OGoAadJoji7wnuGIXVUbKiC3I+Kh7wTH9sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lr7kPUgI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7011FC4CEC3;
	Thu, 31 Oct 2024 20:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730407391;
	bh=H9TYKTBvHoQ5rvWOlZrf5R8cp5gm744S0WtiOVj2YhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lr7kPUgI/7iVNgICJResGJ30FaV5ODcyHJ9WGRkVobW4I+2qmOuISPyR7TgVvtOL0
	 SmzSJOoShZhbOMucGyUH2uuWA6uV+MEqkVpWqucL5pewOQIRjkLlpdRuvDl1QVDfWX
	 j1897yIh4R6d4BkCIdg8zDSKqwvM5/ucAQVUt6ez1WZ9F859wkA3oJfZDIz3/BvZ9Q
	 CFmDxviw5iM6FMEQKmQ/YcUbuNijZ7G5KlXaJgFBJfCLtyj90f3jtiAtedA93PWWwn
	 Aojx0RCSHe5LU/8+xXjxLd+N9OOoZAjQdgre/g+5QavM+S81ng8FOAv7tC01+C4SFj
	 e0eXzNVUyHdgQ==
Date: Thu, 31 Oct 2024 22:43:06 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
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
Subject: Re: [PATCH v1 00/17] Provide a new two step DMA mapping API
Message-ID: <20241031204306.GB88858@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <3144b6e7-5c80-46d2-8ddc-a71af3c23072@kernel.dk>
 <20241031083450.GA30625@lst.de>
 <20241031090530.GC7473@unreal>
 <20241031092113.GA1791@lst.de>
 <20241031093746.GA88858@unreal>
 <8b4500da-4ed8-4cd2-ba3b-0c2d0b5b4551@kernel.dk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b4500da-4ed8-4cd2-ba3b-0c2d0b5b4551@kernel.dk>

On Thu, Oct 31, 2024 at 11:43:50AM -0600, Jens Axboe wrote:
> On 10/31/24 3:37 AM, Leon Romanovsky wrote:
> > On Thu, Oct 31, 2024 at 10:21:13AM +0100, Christoph Hellwig wrote:
> >> On Thu, Oct 31, 2024 at 11:05:30AM +0200, Leon Romanovsky wrote:
> >>> This series is a subset of the series you tested and doesn't include the
> >>> block layer changes which most likely were the cause of the performance
> >>> regression.
> >>>
> >>> This is why I separated the block layer changes from the rest of the series
> >>> and marked them as RFC.
> >>>
> >>> The current patch set is viable for HMM and VFIO. Can you please retest
> >>> only this series and leave the block layer changes for later till Christoph
> >>> finds the answer for the performance regression?
> >>
> >> As the subset doesn't touch block code or code called by block I don't
> >> think we need Jens to benchmark it, unless he really wants to.
> > 
> > He wrote this sentence in his email, while responding on subset which
> > doesn't change anything in block layer: "just want to make sure
> > something like this doesn't get merged until that is both fully
> > understood and sorted out."
> > 
> > This series works like a charm for RDMA (HMM) and VFIO.
> 
> I don't care about rdma/vfio, nor do I test it, so you guys can do
> whatever you want there, as long as it doesn't regress the iommu side.
> The block series is separate, so we'll deal with that when we get there.
> 
> I don't know why you CC'ed linux-block on the series.

Because of the second part, which is marked as RFC and based on this
one. I think that it is better to present whole picture to everyone
interested in the discussion.

Thanks

> 
> -- 
> Jens Axboe
> 

