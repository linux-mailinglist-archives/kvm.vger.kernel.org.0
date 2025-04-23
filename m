Return-Path: <kvm+bounces-43947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DADEA99062
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7223E1B87CDC
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250E428D83F;
	Wed, 23 Apr 2025 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFJx/822"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A6D269B07;
	Wed, 23 Apr 2025 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420753; cv=none; b=ELJSRVoqs6mUrxRLtJbYjie9Bkw29bgmOCNV8i/T7VJD8xe345Y1iOhGwmdrN04csahAlWGd+mpnozo2Qwr3Pdm9hIQAp6dRnx+2Zy2YQ5JT07OlPnKUt+OIA+gYrSqkRyVKh9KJ6N6Y7p4E8WKBP8CdYXR5xJeAlh8s1L0yJ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420753; c=relaxed/simple;
	bh=+pgwEq/v7P8f/AIzuDnfFPRQJNNWeIXj7j55MF1ARFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYKsmoLF1IX2WZMtgUJKcxDPYHH85sedbtne76t45j1KEuqAombzUP1SIpuOIBCf8Xn4FRmG0r2eKT8SdgP4Tz3FTs5+/qhtmbNxtmHdKikJKGbOc3oZvbzNs6gREJdiMtYwx7qwyMKPlPnZ8xi7e/eAoui4mXpPEYcNxhJ1ZjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFJx/822; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901EFC4CEE3;
	Wed, 23 Apr 2025 15:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745420752;
	bh=+pgwEq/v7P8f/AIzuDnfFPRQJNNWeIXj7j55MF1ARFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dFJx/822j4GTOfsd2flNm5Ey/TaUnXvZT5qb1IFKN8MDVYAFjFrSYj2QuqzBXOI34
	 cCL2AjpTOhK3gqFdVzm60QZZvEA+ZIjYjEMhAIT2Om4kk9CpVlY+UMwZFizRz2A4FV
	 x2Kc0vTLaMJFho4pwEjsYBGAdyZMrqxDedEJqMD9wYE2ukoG/n7seIhucFhuW31zDW
	 UmvL8uviiKFbeGy65gClBxfYw6dpkBtsqH4du4EF8WICj2EuxnuXGLSAWwcwRzUmrc
	 x84yDhW8Ij5YIQpP/JKhV3PMooMVAUA5y9/B5QkJayW+yclq7f2CrbG5CDNIkG4bD0
	 7IzL5VKJcHazg==
Date: Wed, 23 Apr 2025 09:05:48 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v9 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <aAkBzDgjiWkbeP8P@kbusch-mbp.dhcp.thefacebook.com>
References: <cover.1745394536.git.leon@kernel.org>
 <7c5c5267cba2c03f6650444d4879ba0d13004584.1745394536.git.leon@kernel.org>
 <20250423092437.GA1895@lst.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423092437.GA1895@lst.de>

On Wed, Apr 23, 2025 at 11:24:37AM +0200, Christoph Hellwig wrote:
> Right now I don't have a test setup for metasgl, though.  Keith,
> do you have a good qemu config for that?  Or anyone else?

QEMU does support it, and reports support for it by default (you may
need to upgrade qemu if yours is more than a year old). You just need to
format your namespace with metadata then you can send commands with
either SGL or MPTR.

QEMU supports 0, 8, 16, and 64 metadata bytes on either 512b or 4k block
sizes.

If you want 8 bytes for metadata on start up, attach parameter "ms=8" to
the '-device nvme-ns' qemu setup.

Alternatively, you can use the 'nvme format' command after booting to
change it whenever you want.

