Return-Path: <kvm+bounces-53567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C539B14086
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 18:42:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 100773ACF8B
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 16:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831E12750ED;
	Mon, 28 Jul 2025 16:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+keFTh/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AED218ABD;
	Mon, 28 Jul 2025 16:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753720903; cv=none; b=IrOANAseTZ078tKj5fGWHYFH5lauqmIoNSsQKk0vLbcRCgSZBEyYr+WYN/tyGSxdgB9dFfcElDMZqqVhMLEQlseMD3aodittTyPFrLvmg34fzmDz9JSoeg3WuALLsO1T7YxqhucjErftKZjsAUU0+k9qW/TZ0knWicKnFpnwNLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753720903; c=relaxed/simple;
	bh=7x0ZgIgFMhmGblvNn1rp9l0J3jLs/NKo357QqFEU40c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dBOknKt0Tlyw0y72pRRvVlIzOqUJ9DSEwXjKByOC0FHLakpzUXRv+G2hj36n3Anep9plgnL5wufoFfMHOBQzqITVoB4Xiy5jGob0pPwnPbkS+Ml2K5p+S2S66AhnPiwpcUAVsi+IZmqhlhjMby7g+2k2oGD303Cu+BMA46qivKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+keFTh/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E4FC4CEE7;
	Mon, 28 Jul 2025 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753720902;
	bh=7x0ZgIgFMhmGblvNn1rp9l0J3jLs/NKo357QqFEU40c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B+keFTh/H3uyJm+2CRXywKicPx1XFBBkxeKmrZZbdSdo7TbhwSKWM+9PVaAkV/Ggd
	 rdbs8jBkHbT/8OTgeGMPL4gfUOW2ABlcD8WUcg8AnFQUJTXwNmVXpc6MVeqX+1gX/B
	 Hl4YyyFNqJKjrMehvwoAGQununhgEiDlRgPJ4pHhRsT2e9nnS0dUD7g029zGYqMvz0
	 +n1X/yXScSmTwLjOGstVCV5NVXNowOdBanEpgP5gJZIZzUwp2PqhdbrI1ndD1ANzQ6
	 U3SK+z5/iiu7H8t8oy3Nyrh+r+SHqvFdQXzv1CHbtq87l4SZmHe8/P8OoUYzv0vSLF
	 T/9RjFtCR33XQ==
Date: Mon, 28 Jul 2025 19:41:36 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250728164136.GD402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
 <20250727190514.GG7551@nvidia.com>
 <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>

On Mon, Jul 28, 2025 at 10:12:31AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2025-07-27 13:05, Jason Gunthorpe wrote:
> > On Fri, Jul 25, 2025 at 10:30:46AM -0600, Logan Gunthorpe wrote:
> >>
> >>
> >> On 2025-07-24 02:13, Leon Romanovsky wrote:
> >>> On Thu, Jul 24, 2025 at 10:03:13AM +0200, Christoph Hellwig wrote:
> >>>> On Wed, Jul 23, 2025 at 04:00:06PM +0300, Leon Romanovsky wrote:
> >>>>> From: Leon Romanovsky <leonro@nvidia.com>
> >>>>>
> >>>>> Export the pci_p2pdma_map_type() function to allow external modules
> >>>>> and subsystems to determine the appropriate mapping type for P2PDMA
> >>>>> transfers between a provider and target device.
> >>>>
> >>>> External modules have no business doing this.
> >>>
> >>> VFIO PCI code is built as module. There is no way to access PCI p2p code
> >>> without exporting functions in it.
> >>
> >> The solution that would make more sense to me would be for either
> >> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
> >> P2PDMA case.
> > 
> > This has nothing to do with dma-iommu.c, the decisions here still need
> > to be made even if dma-iommu.c is not compiled in.
> 
> Doesn't it though? Every single call in patch 10 to the newly exported
> PCI functions calls into the the dma-iommu functions. If there were
> non-iommu paths then I would expect the code would use the regular DMA
> api directly which would then call in to dma-iommu.

If p2p type is PCI_P2PDMA_MAP_BUS_ADDR, there will no dma-iommu and DMA
at all.

+static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
+				   struct dma_buf_attachment *attachment)
+{
+	struct vfio_pci_dma_buf *priv = dmabuf->priv;
+
+	if (!attachment->peer2peer)
+		return -EOPNOTSUPP;
+
+	if (priv->revoked)
+		return -ENODEV;
+
+	switch (pci_p2pdma_map_type(priv->vdev->provider, attachment->dev)) {
+	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
+		break;
+	case PCI_P2PDMA_MAP_BUS_ADDR:
+		/*
+		 * There is no need in IOVA at all for this flow.
+		 * We rely on attachment->priv == NULL as a marker
+		 * for this mode.
+		 */
+		return 0;
+	default:
+		return -EINVAL;
+	}
+
+	attachment->priv = kzalloc(sizeof(struct dma_iova_state), GFP_KERNEL);
+	if (!attachment->priv)
+		return -ENOMEM;
+
+	dma_iova_try_alloc(attachment->dev, attachment->priv, 0, priv->phys_vec.len);
+	return 0;
+}

