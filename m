Return-Path: <kvm+bounces-16597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F0A8BC086
	for <lists+kvm@lfdr.de>; Sun,  5 May 2024 15:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1E3EB2136D
	for <lists+kvm@lfdr.de>; Sun,  5 May 2024 13:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA9421364;
	Sun,  5 May 2024 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5GHCqgu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929D16FA8;
	Sun,  5 May 2024 13:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714915399; cv=none; b=IqkzMk1GcN7CqAFP/yp6062Bfe7z3tEdwxR4Mj8WmQCAYFIoZT0tmkhUCqVI8D/1nKRuqhnJRg8gv30+Pc/qi2ykxBaF+Dh/CyfI3KCCLyuAYIpB3UwDmO4XM/p67AzvAvEwbTvPlF0cRXYTF5/nLji00/5uEfnM/LjMIBfM83g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714915399; c=relaxed/simple;
	bh=jjLgkhsN4WjaKTyfGnNOYYnBmrIQeAxiqhWYRqvmHnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBO0L2ivwmNd/EFb4BmUz4MqAe7MQgGwQXE26if4JxzQrLXsRkUcpHRcSUv2zML6AUvZsBCGb5n0tqKcj8G64ms1nUs7xstn8sxio8+7WrkPRsM4icbwsobX4aISUHFVl/gwdCWeCtXGHAfJDd2uuAZALNtopQq8MEvUk605u54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5GHCqgu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5357AC113CC;
	Sun,  5 May 2024 13:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714915399;
	bh=jjLgkhsN4WjaKTyfGnNOYYnBmrIQeAxiqhWYRqvmHnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N5GHCqguzvr4zXSvt+GZwExP+D4+ViMFS5ymKVV8WJY+Di3qvsEp58G9bzM0BAvHF
	 stRLiuNs0tAjzhnbTK/8wL+10XQCHTZHBZmaoU+SwNNRsdc3zzqE5WaLVDQBWFhIvC
	 raDXBTYUnDUM4UtQUw45YXqktzY6vnT/akcSLM5mL4wzzUFTgqPDcpICsM95p6XfvX
	 O4u+h30wrlLfM0mEibSSqU02f0NAECeoPPcaFHr27oYznJKIN+ZSxxnHDgLyJZSjxm
	 mLLAI46IamcYUju5EL6BBITjFGKFCEyP7IgsxkDT4H6bFHDEu7oWOLwbNzfk28/Nrq
	 GrAQIMAtf2uAg==
Date: Sun, 5 May 2024 16:23:14 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
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
	"jack@suse.com" <jack@suse.com>
Subject: Re: [RFC RESEND 16/16] nvme-pci: use blk_rq_dma_map() for NVMe SGL
Message-ID: <20240505132314.GC68202@unreal>
References: <cover.1709635535.git.leon@kernel.org>
 <016fc02cbfa9be3c156a6f74df38def1e09c08f1.1709635535.git.leon@kernel.org>
 <c9f9e29e-c2e1-4f99-b359-db0babd41dec@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9f9e29e-c2e1-4f99-b359-db0babd41dec@linux.dev>

On Fri, May 03, 2024 at 04:41:21PM +0200, Zhu Yanjun wrote:
> On 05.03.24 12:18, Leon Romanovsky wrote:
> > From: Chaitanya Kulkarni <kch@nvidia.com>

<...>

> > This is an RFC to demonstrate the newly added DMA APIs can be used to
> > map/unmap bvecs without the use of sg list, hence I've modified the pci
> > code to only handle SGLs for now. Once we have some agreement on the
> > structure of new DMA API I'll add support for PRPs along with all the
> > optimization that I've removed from the code for this RFC for NVMe SGLs
> > and PRPs.
> > 

<...>

> > diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> > index e6267a6aa380..140939228409 100644
> > --- a/drivers/nvme/host/pci.c
> > +++ b/drivers/nvme/host/pci.c
> > @@ -236,7 +236,9 @@ struct nvme_iod {
> >   	unsigned int dma_len;	/* length of single DMA segment mapping */
> >   	dma_addr_t first_dma;
> >   	dma_addr_t meta_dma;
> > -	struct sg_table sgt;
> > +	struct dma_iova_attrs iova;
> > +	dma_addr_t dma_link_address[128];
> 
> Why the length of this array is 128? Can we increase this length of the
> array?

It is combination of two things:
 * Good enough value for this nvme RFC to pass simple test, which Chaitanya did.
 * Output of various NVME_CTRL_* defines

Thanks

