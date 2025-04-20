Return-Path: <kvm+bounces-43696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5471AA94703
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 09:15:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 796B617526F
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 07:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335DC1EF38A;
	Sun, 20 Apr 2025 07:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9hnRRtm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C171EEA49;
	Sun, 20 Apr 2025 07:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745133291; cv=none; b=L84JWn20ARDG4FCOXb3XYErDVUTXF3IqaSIVNFgccv2BTUaB8i3w0053HnPrRVz90N7+xYnv7McnrhcRwde3BRpXqH7QXdx5kaBmk0uS/tPsH6tNNLf3JwjRtZY6JTK4tSXbMG4tGSWdqF2G6nBAeAHbG9aRqIiAarqxGEFLaK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745133291; c=relaxed/simple;
	bh=SpNXshGC4uEadiZ9mic8rX/qeMHOKG3enirsdDCvXf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzNpRyd/M8rladr6YKym5WHYbrmN9JfulukOBBRk6uD7GxPPTj8yiPkM+Azk2gM1J7AvXyRneHaC0Nwluj3dPaFwx0+2VQTLHJ1TvvbS+/0VHp4enSEqzHxJltbFDYXecLBaO2nGxMvL3EJYy5TeeA8T6Kwf9bdFWkXqeGqgoW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N9hnRRtm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E37C4CEE2;
	Sun, 20 Apr 2025 07:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745133290;
	bh=SpNXshGC4uEadiZ9mic8rX/qeMHOKG3enirsdDCvXf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N9hnRRtmNHfnuM6gp/E+KrJvokqSb71oYMhBqMYRZgnnOGfewaBmv+VxsqSvw2mx7
	 2fUdjbY/H46G3VKGRBnVwSy+Gjl4Z6RSMWeY14FJU6YmfQyL7kYGD5MBt7GIedAPYf
	 WshWPr5dJTN9Wmr96QKS9Qodv+qsrhzEMuJXAU6Bd5tnDEQoGrprjYI9sbQ8XZCPzs
	 8+caVRnyAL4BM9TX5W2rx5tKmtonDo4tGbYQ3BgJlrPC3GoZ4wZDsnfOB4NIgP2BY7
	 tY3+8mvVofskwTyS6lS/IiWKwTGTcxkr24eh0/y5LbaD9SKuEGZVJwz5YEwht/9f63
	 yZpV0FW9cb2BA==
Date: Sun, 20 Apr 2025 10:14:46 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
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
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v8 00/24] Provide a new two step DMA mapping API
Message-ID: <20250420071446.GB10635@unreal>
References: <cover.1744825142.git.leon@kernel.org>
 <93ef8629-4040-4773-beac-03c62f848727@kernel.dk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93ef8629-4040-4773-beac-03c62f848727@kernel.dk>

On Fri, Apr 18, 2025 at 06:18:00AM -0600, Jens Axboe wrote:
> On 4/18/25 12:47 AM, Leon Romanovsky wrote:
> > Following recent on site LSF/MM 2025 [1] discussion, the overall
> > response was extremely positive with many people expressed their
> > desire to see this series merged, so they can base their work on it.
> > 
> > It includes, but not limited:
> >  * Luis's "nvme-pci: breaking the 512 KiB max IO boundary":
> >    https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
> >  * Chuck's NFS conversion to use one structure (bio_vec) for all types
> >    of RPC transports:
> >    https://lore.kernel.org/all/913df4b4-fc4a-409d-9007-088a3e2c8291@oracle.com
> >  * Matthew's vision for the world without struct page:
> >    https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
> >  * Confidential computing roadmap from Dan:
> >    https://lore.kernel.org/all/6801a8e3968da_71fe29411@dwillia2-xfh.jf.intel.com.notmuch
> > 
> > This series is combination of effort of many people who contributed ideas,
> > code and testing and I'm gratefully thankful for them.
> 
> Since I previously complained about performance regressions from this
> series, I re-tested the current code. I no longer see a performance
> regression on a AMD EPYC 9754 256 core box, nor on AMD EPYC 7763 128
> core box.
> 
> Tested-by: Jens Axboe <axboe@kernel.dk>

Thanks a lot.

> 
> -- 
> Jens Axboe
> 

