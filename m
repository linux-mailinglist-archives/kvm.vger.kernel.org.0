Return-Path: <kvm+bounces-43649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8EFA93663
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 13:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 224788A84BA
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 11:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C03822749D7;
	Fri, 18 Apr 2025 11:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQ/C0ZYE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5AAFBF6;
	Fri, 18 Apr 2025 11:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744975003; cv=none; b=rmKS1kt8eK8wFfK4A7NUeeCIvGvM1gQ7T9v2JzMB7fgRGrrXYkR/r1M6AoT2JA22U0OUSNDpmQrdAGHNjlD1pcWxrkExCQOAg20bw4IFTJE0/4Xq1W34wkvKE8WXP6LeJLtZDhpWtifrBlvPIaEp7gGdLsuuUy2bHYgLM/kKB24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744975003; c=relaxed/simple;
	bh=dvINVulNQm/q8ensffkaywCQHGoNQIxMaLroxrA224U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/5vpN6LpKLsC7yWUFgdUXOSTE5lsE+Ul0a2+NQHxGOnwuqv4iOeC9pUbSoD8qM9LwNITTl25bsrrlzWc+aRKRVvUOur0T8JUEXaPJJ/4uMn+aHMdj68BW3L113543BpnYya668P4ccOMq0It+Y325Iz3tQ+nNnDT/H6sS4DFfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQ/C0ZYE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900E0C4CEE2;
	Fri, 18 Apr 2025 11:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744975003;
	bh=dvINVulNQm/q8ensffkaywCQHGoNQIxMaLroxrA224U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WQ/C0ZYEmhZxfgAy6oSrCwtec97rYq+IQy72i0QXVT4Nic+OEanmNLKKsvIIV8Ekj
	 1x7gsGqeeh1osAlFFL0KDLYmWqa0wjQIuod7vLi1OTJlGC5z4qe7QRZ5wj4SS2nqE7
	 +SH+NS44ZZFAhuBE2ycaahgJLhmerUsAv+G4MIEsX1IMHt8ijPEtQJjO7xQyt6BtQo
	 tyiaXeqr34eQH5l7zL728IAWC+FUE2oBIwfQLJxm+CM1SCDOXGLW0mSvG5V+8GFATT
	 SZvt1I0LYqXvIMwiZgIyzpqRSI5Z5otseG0yxNbcvWknZp/i/ZkFcDocEdXEtgjD/p
	 CTvTVJqZ7YpdQ==
Date: Fri, 18 Apr 2025 14:16:39 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
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
Message-ID: <20250418111639.GB199604@unreal>
References: <cover.1744825142.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1744825142.git.leon@kernel.org>

On Fri, Apr 18, 2025 at 09:47:30AM +0300, Leon Romanovsky wrote:
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

The link here should be https://lore.kernel.org/all/Z-WRQOYEvOWlI34w@casper.infradead.org/

>  * Confidential computing roadmap from Dan:
>    https://lore.kernel.org/all/6801a8e3968da_71fe29411@dwillia2-xfh.jf.intel.com.notmuch

Thanks

