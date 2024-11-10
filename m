Return-Path: <kvm+bounces-31386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B10FE9C3310
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 16:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75FA0281254
	for <lists+kvm@lfdr.de>; Sun, 10 Nov 2024 15:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC8578C76;
	Sun, 10 Nov 2024 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OEubWIUH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B447A923;
	Sun, 10 Nov 2024 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731251986; cv=none; b=JlJHOQZzPaqz97k/7G16iE6e3DEHlBTIC5rykeXi2+VvAaLMY3jlCSwM7EioBFkoXRl8ydKVPPwf0pqSqmBhXtM3zYubpD6PLC51GxawBgTL8WacDTKhcr6fRS9e0ES5cfk2ALAkCnyvbfacSUxNSqG8BsswV1F4gIOL+MM2oRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731251986; c=relaxed/simple;
	bh=+nLpqVqlmI0rwfYB+x9XOLb4b4JCkJV7DCNS7yvGo5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qiu88qptzU25hzLt53cHTVpw29eHSU7qMsHB2NhPUbBwx4ou3k1arH5Yv0zmrgxvXgAjZ9IS/UiJpRGtjhb0X/GDmojNbbckWoDDjt7MjzrrNz+ryI/NwDl/4ZjiPo/Pf/YtVapXxkmWjcILhBxvP10DjL6HhWEPqM9FPcZYw/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OEubWIUH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533D2C4CECD;
	Sun, 10 Nov 2024 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731251985;
	bh=+nLpqVqlmI0rwfYB+x9XOLb4b4JCkJV7DCNS7yvGo5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OEubWIUHaUCtjGJxYJ5nWYcTl4O7jXvmZxRC78OdoHXOSPdpN7Yve6E8unqrE3xw7
	 noGkSTSEj5WPLytJfdaJwps42VXBFU7yRdOMwjAgfBjhgBg0Dd/EC2D8tewNsUak80
	 h12aWQlWql/HCLFHYJOCSy2Bgc3Sbx2TdUGdPaz5txbu3gg84O+qg0yKH/aU32e81v
	 7eKJu7lxrjbuPwLHgJwoib4PK0Ffn2owR8TwOlpUaUruiqAVwpjo6Q1dbyJlxpXA3X
	 03rsXv5Mmeha22biNs41oOfjNv3RZB8IxRhyqfLwzMScjSb64oiAJc2mVMc/sMWUE8
	 X3YK8Swfv+C7Q==
Date: Sun, 10 Nov 2024 17:19:38 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
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
Subject: Re: [PATCH v1 04/17] dma-mapping: Add check if IOVA can be used
Message-ID: <20241110151938.GA71181@unreal>
References: <cover.1730298502.git.leon@kernel.org>
 <9515f330b9615de92a1864ab46acbd95e32634b6.1730298502.git.leon@kernel.org>
 <5ea594b3-7451-4553-92c1-2590c8baef20@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ea594b3-7451-4553-92c1-2590c8baef20@linux.dev>

On Sun, Nov 10, 2024 at 04:09:11PM +0100, Zhu Yanjun wrote:
> 在 2024/10/30 16:12, Leon Romanovsky 写道:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > This patch adds a check if IOVA can be used for the specific
> > transaction.
> > 
> > In the new API a DMA mapping transaction is identified by a
> > struct dma_iova_state, which holds some recomputed information
> > for the transaction which does not change for each page being
> > mapped.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   include/linux/dma-mapping.h | 33 +++++++++++++++++++++++++++++++++
> >   1 file changed, 33 insertions(+)
> > 
> > diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> > index 1524da363734..6075e0708deb 100644
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -76,6 +76,20 @@
> >   #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
> > +struct dma_iova_state {
> > +	size_t __size;
> > +};
> > +
> > +/*
> > + * Use the high bit to mark if we used swiotlb for one or more ranges.
> > + */
> > +#define DMA_IOVA_USE_SWIOTLB		(1ULL << 63)
> 
> A trivial problem.
> In the above macro, using BIT_ULL(63) is better?

You already asked same question and the answer is also the same.
https://lore.kernel.org/all/20241103151946.GA99170@unreal/

> 
> Zhu Yanjun

