Return-Path: <kvm+bounces-30161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60AB89B77B2
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 10:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D3F5282F5E
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D23198838;
	Thu, 31 Oct 2024 09:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTQP7PS+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A7D18DF6B;
	Thu, 31 Oct 2024 09:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730367471; cv=none; b=gnx3mAItE3349SQP3Nbx1fRxBv1HoyZZGYcG9npJiiHawN/o0qrNGeKQvxJ9rAXkGwt2WzzTO9Ng5wD15yaMTyq0sx0sbHMiI5ptaPAKV/LMysD+g48kXBGD9XFbmzi1lyAEmBPGI3nbfgj1DFvxIfiTrqHkZ3mV74UaC2TQJpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730367471; c=relaxed/simple;
	bh=tqzJLh5GYRL2KEmKB06uhDKvLABRYtBWXtB3Y8bMEKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COhqTqf8iZbulguVzzjipvG112iSLyNCP7lYG/JfS/7MRWKU/0UTMrG94RvabryQB35LcklOkAPHfyhh93N5qV9Zi2SUdYT+a/cyf5QCGW4PFDaZ2vAK5t47+NsiG6Y6+485Fh/79wbseMnto1my9VEsHMGxDVQATasWRJ9H2bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTQP7PS+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04050C4CEC3;
	Thu, 31 Oct 2024 09:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730367470;
	bh=tqzJLh5GYRL2KEmKB06uhDKvLABRYtBWXtB3Y8bMEKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dTQP7PS+/MTyTtUMPwFCdUdEd1qWr3BPPQ8pvyYPVrtbourx/L8sdNPTr9lPj1QPB
	 g933lrXQqvAJxMV1kQiG2xyG7NF8LnS9wKQBA9lsBXrn5RHD1+siwDoEBnl+zfB8NV
	 DrhOyVxwnAVdg5G2IeaEo3cxX9HtNdkNEj0b51HcYMeCY5S9sSDgNsPLzN1l7uwEAl
	 8UAGh7dlC4XLOOvyRno1rlDrgXdZkQFymJIkdmkKL/RzKkO8mH98WS4qTpitL+TrzB
	 j4UfpaLbeZXfuUbC0SIp4WAe0T7KDxaEbIsTC03s3SAkoAGz9+Sya4ZfdJPQPVNS6T
	 b1awtly2cL7Qw==
Date: Thu, 31 Oct 2024 11:37:46 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <20241031093746.GA88858@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <3144b6e7-5c80-46d2-8ddc-a71af3c23072@kernel.dk>
 <20241031083450.GA30625@lst.de>
 <20241031090530.GC7473@unreal>
 <20241031092113.GA1791@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031092113.GA1791@lst.de>

On Thu, Oct 31, 2024 at 10:21:13AM +0100, Christoph Hellwig wrote:
> On Thu, Oct 31, 2024 at 11:05:30AM +0200, Leon Romanovsky wrote:
> > This series is a subset of the series you tested and doesn't include the
> > block layer changes which most likely were the cause of the performance
> > regression.
> > 
> > This is why I separated the block layer changes from the rest of the series
> > and marked them as RFC.
> > 
> > The current patch set is viable for HMM and VFIO. Can you please retest
> > only this series and leave the block layer changes for later till Christoph
> > finds the answer for the performance regression?
> 
> As the subset doesn't touch block code or code called by block I don't
> think we need Jens to benchmark it, unless he really wants to.

He wrote this sentence in his email, while responding on subset which doesn't change
anything in block layer: "just want to make sure something like this doesn't get merged
until that is both fully understood and sorted out."

This series works like a charm for RDMA (HMM) and VFIO.

Thanks

