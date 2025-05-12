Return-Path: <kvm+bounces-46163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30DF3AB348D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 12:08:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50414189BE98
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 10:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 533822609D2;
	Mon, 12 May 2025 10:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BeyENDX1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2773D6F;
	Mon, 12 May 2025 10:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747044463; cv=none; b=EIID5DfV8PNatCUB+rMg0sb9D9KerywosRGw+AnyFoSCbs3K3YkD6mKchuULXn5imEAKVC5kp9SFg28/1jN5wW+4g51ItQKPq5ScgPXMMaRu5OEpFMjlCJ20c+BQYOFN9iJ7GVs1hC9QUUVBMmoXaFy6M70olO7MTTRXSVIgBDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747044463; c=relaxed/simple;
	bh=XALDZKGpGWCIJWhewU5QYMsRfS47+UV8sY1D37V1fag=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Nybdvx2ZdWNu7OS0ZnQ31Q/9BpbkoRtGx6qGfcRuYn1nMRjK8GzSRzY/ElKPzlHW64Mv2ju+WMaqA/DM3y0kgkEWY9CWyWjTaPiXGxllsQlqTKzOb4QVUIsjv9A3uJbLabhie1iBdiy0WLGAPEg9Xwu/bKT1FSextRn8qZkFG6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BeyENDX1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8BFC4CEE7;
	Mon, 12 May 2025 10:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747044463;
	bh=XALDZKGpGWCIJWhewU5QYMsRfS47+UV8sY1D37V1fag=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=BeyENDX1we8D7zgGY2YFHTUWMiCzVu93YRbpelQHdSlaheD+E4xFo6XlsqdFYu1rO
	 OMUWFCIMYeOEhF2Ftyv4XUS1LDLbcA4j0JvDm6EA4JEImJAttTKP06IJLp9A9u8CcM
	 uxHLrn5uu2FDZi4XcTsRIeS+I3RpwrtIoaOTAJOTLAoAe2x2x7Ef8nX7qtsKut4UPg
	 qDKP6aXKb5r2IAdBjjX9qriiZB5CWNeYA1nNkpKxYMGnIpwSPLaeliNgTHIZMNYimK
	 3RmL7XRyHrqgqC6XnDz3TtwoBF9SKm0u/B0OaEK3EK7c3aduRxwL5VSsLJ1/v4a8x6
	 2MRGp9GSeJgrA==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>, 
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
 Keith Busch <kbusch@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc: Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, 
 Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
 Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, 
 kvm@vger.kernel.org, linux-mm@kvack.org, 
 Niklas Schnelle <schnelle@linux.ibm.com>, 
 Chuck Lever <chuck.lever@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Kanchan Joshi <joshi.k@samsung.com>, Chaitanya Kulkarni <kch@nvidia.com>
In-Reply-To: <cover.1745831017.git.leon@kernel.org>
References: <cover.1745831017.git.leon@kernel.org>
Subject: Re: (subset) [PATCH v10 00/24] Provide a new two step DMA mapping
 API
Message-Id: <174704445979.583981.12854692160586160920.b4-ty@kernel.org>
Date: Mon, 12 May 2025 06:07:39 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-37811


On Mon, 28 Apr 2025 12:22:06 +0300, Leon Romanovsky wrote:
> Following recent on site LSF/MM 2025 [1] discussion, the overall
> response was extremely positive with many people expressed their
> desire to see this series merged, so they can base their work on it.
> 
> It includes, but not limited:
>  * Luis's "nvme-pci: breaking the 512 KiB max IO boundary":
>    https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
>  * Chuck's NFS conversion to use one structure (bio_vec) for all types
>    of RPC transports:
>    https://lore.kernel.org/all/913df4b4-fc4a-409d-9007-088a3e2c8291@oracle.com
>  * Matthew's vision for the world without struct page:
>    https://lore.kernel.org/all/20250320111328.2841690-1-mcgrof@kernel.org/
>  * Confidential computing roadmap from Dan:
>    https://lore.kernel.org/all/6801a8e3968da_71fe29411@dwillia2-xfh.jf.intel.com.notmuch
> 
> [...]

Applied, thanks!

[10/24] mm/hmm: let users to tag specific PFN with DMA mapped bit
        https://git.kernel.org/rdma/rdma/c/285e871884ff3d
[11/24] mm/hmm: provide generic DMA managing logic
        https://git.kernel.org/rdma/rdma/c/8cad4713056612
[12/24] RDMA/umem: Store ODP access mask information in PFN
        https://git.kernel.org/rdma/rdma/c/eedd5b1276e76d
[13/24] RDMA/core: Convert UMEM ODP DMA mapping to caching IOVA and page linkage
        https://git.kernel.org/rdma/rdma/c/1efe8c0670d6a6
[14/24] RDMA/umem: Separate implicit ODP initialization from explicit ODP
        https://git.kernel.org/rdma/rdma/c/15a9f67e286b37

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


