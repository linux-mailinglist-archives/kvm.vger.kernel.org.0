Return-Path: <kvm+bounces-30150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 414599B75F9
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 09:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A51F2B239BA
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 08:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD54154BEB;
	Thu, 31 Oct 2024 07:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSE0qfi9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8248314D2BD;
	Thu, 31 Oct 2024 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730361574; cv=none; b=i7N6c3wlAu6Ko939RcrInEo/CXNNxvXvDyC/rrPZeZj2gQwJ0uJFagrSzR/YpozNJtd7tu76zZ3nERmRaBsazblCJbVJ4iyskMWj5myvbbcl1ItUkQ+F83wmj0icyfpc7dn9oo9rYr45eBtV1kX6iFEinnCyHGRATOTE3Eo8hDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730361574; c=relaxed/simple;
	bh=r4WvFfTJfMdRUmFzrlSoIGEf8BKQg/IhRD4qnokJQvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsnBx/V7/NQ5tIcul5WSbkatoRqNQMlug8lvecIHPIJ8ogC+GOg9YuGCC6JB0uzN1sdLUvN0Xk7YpsKIa9jeoOEBfhrOV6biQWi5vpQfR2S++TQcyQqlpsT5m1kf/fymy3cybNCLslirgt/Jptpa7Pm6wgWtp5Rae0L4hlL57GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSE0qfi9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A22C4CEC3;
	Thu, 31 Oct 2024 07:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730361574;
	bh=r4WvFfTJfMdRUmFzrlSoIGEf8BKQg/IhRD4qnokJQvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YSE0qfi9lLOBn1EH9BGdBYxYLpBIBHIK0QaNCb5Z2f/3ZU0SiPGduT5S8BZpZzVhE
	 QsE8znEvky7HGyINHWNHZtUimXc0OyWjetPBBGPw4IpeX6whHRZ0Squq75I9D2OXoh
	 Dj4A2PcDjtD53WxZ8CfoENNGNXS3uZ1vTjYJ05qe8rdIM0RAaKg01VZUsT2btH90gN
	 3IfJ20Y+iAFHW1y+lpY5HZMEPNs5tEjpoTUkB7qMwux7hxpqN1+o4tJ7RVpOBKxrIT
	 w9KRIYFGI2KFLA4w2wF7IkinK0w9y+ewKYwfXPBFWw7JG53t4IL192NVOKYAlQAK8j
	 0+j+mdz3I8PxQ==
Date: Thu, 31 Oct 2024 09:59:28 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
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
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
Message-ID: <20241031075928.GA7473@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
 <19cf7d58-4a28-4ce8-9524-8c99fdc79062@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19cf7d58-4a28-4ce8-9524-8c99fdc79062@infradead.org>

On Wed, Oct 30, 2024 at 06:41:21PM -0700, Randy Dunlap wrote:
> (nits)
> 
> On 10/30/24 8:12 AM, Leon Romanovsky wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Add an explanation of the newly added IOVA-based mapping API.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  Documentation/core-api/dma-api.rst | 70 ++++++++++++++++++++++++++++++
> >  1 file changed, 70 insertions(+)

<...>

> > +These APIs allow a very efficient mapping when using an IOMMU.  They are an
> > +optional path that requires extra code and are only recommended for drivers
> > +where DMA mapping performance, or the space usage for storing the DMA addresses
> > +matter.  All the consideration from the previous section apply here as well.
> 
>                     considerations

<...>

> > +is used to unmap a range previous mapped, and
> 
>                             previously

Thanks

