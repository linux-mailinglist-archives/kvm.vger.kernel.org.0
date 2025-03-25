Return-Path: <kvm+bounces-41974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA340A7040D
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 15:43:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 721E1189A381
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 14:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057672566DE;
	Tue, 25 Mar 2025 14:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngMssWMX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C488255E3E;
	Tue, 25 Mar 2025 14:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742913720; cv=none; b=gNCdmFBXFVsl8OZonK2wuS6RgRsxa6vAx7FdyOTHhVxMssmNV7EMGCob6CEfrH+tHxs2vX29HI8Ft0RM9bs9HZVxDUyAJSJFhkI9dV5Az24XcuaUHI8J2Hl3lfsFKG0YkwuVgPz8a07ADh0n1lNjqB00/8sQW4lfb1IYLH2VB3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742913720; c=relaxed/simple;
	bh=oJti1ermRV1uUgJ8pfTRGamayM8FuQAkNzrsrS5yAe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtX2ageJq/CIzSSHFqI49j3MngkvaXPlGdGnBk6Vitsem0gtLW1fFsun7ikSHz+z5fLu0AflJgkLTjnOeS1FdKFWmc1yj4w1I0lkB52nMoeZsmrgJO1b9QdhDTHUC3A4s52PDh/AOUX5C07dIEJh4+YCAoQECGjFUevCZvaBUpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngMssWMX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4707DC4CEE4;
	Tue, 25 Mar 2025 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742913719;
	bh=oJti1ermRV1uUgJ8pfTRGamayM8FuQAkNzrsrS5yAe8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ngMssWMXx+k8rjAGS+vZ41iCzKScU7HoG1cd+9tapyfHg4Qil/6pMj9dymbkVElx5
	 TfHngtwSqwgeCOEiqbXqQ4/7oBQ6SpuELO5d0Z0v98cKHmN60spAJqrYnwqcgIJW1+
	 UtswMpNtmAeS8qCW2H67yx2jhZcTg572DF8E9cBIAxzdFzZ3+mVBzlyHDnnNJBcFCL
	 gNTmqwJCFUNMIOFG6/sUjHCBzGjZJBgpvg5a0VChAjAUm9ScR+R+ztSQpZuWPxEtVj
	 O6j5iJZbrcFhxtdioLYqFkmCn9tQL1ros4DiQlqru1txpE0J4bVQ7RUSEc9TwwB944
	 SJiTsVHoVSSgg==
Date: Tue, 25 Mar 2025 16:41:58 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
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
	kvm@vger.kernel.org, linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
Message-ID: <20250325144158.GA4558@unreal>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
 <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
 <20250302085717.GO53094@unreal>
 <e024fe3d-bddf-4006-8535-656fd0a3fada@arm.com>
 <Z+KjVVpPttE3Ci62@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z+KjVVpPttE3Ci62@ziepe.ca>

On Tue, Mar 25, 2025 at 09:36:37AM -0300, Jason Gunthorpe wrote:
> On Fri, Mar 21, 2025 at 04:05:22PM +0000, Robin Murphy wrote:

<...>

> > So what is it now, a layering violation in a hat with still no clear path to
> > support SWIOTLB?
> 
> I was under the impression Leon had been testing SWIOTLB?

Yes, SWIOTLB works and Christoph said it more than once that he tested
NVMe conversion patches and they worked.

Thanks

