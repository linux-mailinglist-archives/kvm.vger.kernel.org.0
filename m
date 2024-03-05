Return-Path: <kvm+bounces-11016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 979D787232C
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 16:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C7D0B2438C
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 15:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB2F128377;
	Tue,  5 Mar 2024 15:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBoFlOhl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0948662F;
	Tue,  5 Mar 2024 15:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709653922; cv=none; b=Mthlzg0+4sEfDk8YvFYgVamTSh7Q+pajWz7+v3qbRiei7XRrPe95K2Wji8socdQt1oj1mtq+AgDuTwoB8sCoqYDgsp2xuFZrYn/tqZ2nQPg3jxeAX9BtjK6GohBibOd87ZOy2JT8OKBku2BscLBe5dPwkiRylX+YJv8PYKHY3bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709653922; c=relaxed/simple;
	bh=pSqyVUiOhZxz9FIInEYMAmoXZWKPhnt0IQNLfQGtXOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyqkT9/OSIWgI6qYP/Z5nElVwgf3it2VvmtDIUUYDwUKrqSuy6rzQ/0f0r0dNVvNLYj8aomwtfMqROw93y+/JfdBbZ0yRpz1zMcUrBTzzNEkujCNbOidTHY8u6AVfTltr2a7guVcobezwQovA2Uv1tVHfryXDlNV1tCWmyQYfMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBoFlOhl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB4CC433C7;
	Tue,  5 Mar 2024 15:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709653921;
	bh=pSqyVUiOhZxz9FIInEYMAmoXZWKPhnt0IQNLfQGtXOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fBoFlOhlhaEkFpkwIhtzKscT84AMxoyIqH1ke1DoX3oTGvoYraBWWNLX9PB1wDsDX
	 8/jrkloUt7VxJU24ln5/zi811lztKw0pkpRiqC5TgWE3Z3l2yBlrPTsMwI7n+JTnPL
	 cIBn53riFq9sACKU+PDs51snnPNJif2TZriANWE8lPNacPlZ3ZEjjBSL+Ajm8tvqj0
	 Xh39F7UKx8jqNW9DJE3CBRQ781zgONKaHkjALazRttLlPWK1iLUFRVRnO9bb0lDH+E
	 AJgD1u7Xsepu7WvnlIDZLfAruLkrmiYG+GBGJiaH7MHjj517QXOLR7xfuwktrP6dWh
	 5IQc8QXtatQIw==
Date: Tue, 5 Mar 2024 08:51:56 -0700
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>, Yishai Hadas <yishaih@nvidia.com>,
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
	"jack@suse.com" <jack@suse.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [RFC RESEND 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
Message-ID: <Zec_nAQn1Ft_ZTHH@kbusch-mbp.dhcp.thefacebook.com>
References: <cover.1709635535.git.leon@kernel.org>
 <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org>

On Tue, Mar 05, 2024 at 01:18:47PM +0200, Leon Romanovsky wrote:
> @@ -236,7 +236,9 @@ struct nvme_iod {
>  	unsigned int dma_len;	/* length of single DMA segment mapping */
>  	dma_addr_t first_dma;
>  	dma_addr_t meta_dma;
> -	struct sg_table sgt;
> +	struct dma_iova_attrs iova;
> +	dma_addr_t dma_link_address[128];
> +	u16 nr_dma_link_address;
>  	union nvme_descriptor list[NVME_MAX_NR_ALLOCATIONS];
>  };

That's quite a lot of space to add to the iod. We preallocate one for
every request, and there could be millions of them. 

