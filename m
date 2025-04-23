Return-Path: <kvm+bounces-43909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16682A98563
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D3CC440EBA
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 09:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9574025524B;
	Wed, 23 Apr 2025 09:24:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFC225C827;
	Wed, 23 Apr 2025 09:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745400290; cv=none; b=V9Bsuetd0Oy5dSVV/ZC8b/EX4LA4hv2XGIJENhE8L2XXnC/bHFcz8cKJ2A2CPiHdFI/EYeXZX4Bx4MRpyvJyX4bb3uTMLdjzplk9FN2P6o9gUTUdao+H/MQzoipFy6xRLhJ4nzULqg6YWK8knzkrV0/2ocw1txh/dkU4yRKS09M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745400290; c=relaxed/simple;
	bh=9qj0pay5ZmjZRZZ7HXJ8BmXLMpn26cC+yQmeKmbVZkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ey/5or73uZIpdjqqJPoP+eIYmfVdqyhlUHKqgQ6mOwZk5g05nLrDVNg0fGhzN6tP11aO0uL4BSqjLWkLtD/D24IVLSHWYxNNHorUMU5vL9iO9bu1cqMXX/56N2GV1+xLAyIFwewemmvjm6wccQoo9LxB9sTldTfsaco2ZvAivxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E67E268AFE; Wed, 23 Apr 2025 11:24:37 +0200 (CEST)
Date: Wed, 23 Apr 2025 11:24:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Leon Romanovsky <leon@kernel.org>, Keith Busch <kbusch@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
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
	Chaitanya Kulkarni <kch@nvidia.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v9 23/24] nvme-pci: convert to blk_rq_dma_map
Message-ID: <20250423092437.GA1895@lst.de>
References: <cover.1745394536.git.leon@kernel.org> <7c5c5267cba2c03f6650444d4879ba0d13004584.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c5c5267cba2c03f6650444d4879ba0d13004584.1745394536.git.leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

I don't think the meta SGL handling is quite right yet, and the
single segment data handling also regressed.  Totally untested
patch below, I'll try to allocate some testing time later today.

Right now I don't have a test setup for metasgl, though.  Keith,
do you have a good qemu config for that?  Or anyone else?

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f69f1eb4308e..80c21082b0c6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -634,7 +634,11 @@ static void nvme_unmap_data(struct nvme_dev *dev, struct request *req)
 	dma_addr_t dma_addr;
 
 	if (iod->flags & IOD_SINGLE_SEGMENT) {
-		dma_addr = le64_to_cpu(iod->cmd.common.dptr.prp1);
+		if (iod->cmd.common.flags &
+		    (NVME_CMD_SGL_METABUF | NVME_CMD_SGL_METASEG))
+			dma_addr = le64_to_cpu(iod->cmd.common.dptr.sgl.addr);
+		else
+			dma_addr = le64_to_cpu(iod->cmd.common.dptr.prp1);
 		dma_unmap_page(dev->dev, dma_addr, iod->total_len,
 				rq_dma_dir(req));
 		return;
@@ -922,35 +926,37 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req)
 	return nvme_pci_setup_prps(dev, req);
 }
 
-static __always_inline void nvme_unmap_metadata(struct nvme_dev *dev,
-						struct request *req)
+static void nvme_unmap_metadata(struct nvme_dev *dev, struct request *req)
 {
 	unsigned int entries = req->nr_integrity_segments;
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	struct nvme_sgl_desc *sg_list = iod->meta_list;
 	enum dma_data_direction dir = rq_dma_dir(req);
-	dma_addr_t dma_addr;
 
-	if (iod->flags & IOD_SINGLE_SEGMENT) {
-		dma_addr = le64_to_cpu(iod->cmd.common.dptr.sgl.addr);
-		dma_unmap_page(dev->dev, dma_addr, iod->total_len, rq_dma_dir(req));
+	/*
+	 * If the NVME_CMD_SGL_METASEG flag is not set and we're using the
+	 * non-SGL linear meta buffer we know that we have a single input
+	 * segment as well.
+	 *
+	 * Note that it would be nice to always use the linear buffer when
+	 * using IOVA mappings and kernel buffers to avoid the SGL
+	 * indirection, but that's left for a future optimization.
+	 */
+	if (!(iod->cmd.common.flags & NVME_CMD_SGL_METASEG)) {
+		dma_unmap_page(dev->dev,
+			le64_to_cpu(iod->cmd.common.dptr.prp1),
+			iod->total_len, rq_dma_dir(req));
 		return;
 	}
 
 	if (!blk_rq_dma_unmap(req, dev->dev, &iod->dma_meta_state,
 			      iod->total_meta_len)) {
-		if (iod->cmd.common.flags & NVME_CMD_SGL_METASEG) {
-			unsigned int i;
+		unsigned int i;
 
-			for (i = 0; i < entries; i++)
-				dma_unmap_page(dev->dev,
-				       le64_to_cpu(sg_list[i].addr),
-				       le32_to_cpu(sg_list[i].length), dir);
-		} else {
-			dma_unmap_page(dev->dev, iod->meta_dma,
-				       rq_integrity_vec(req).bv_len, dir);
-			return;
-		}
+		for (i = 0; i < entries; i++)
+			dma_unmap_page(dev->dev,
+			       le64_to_cpu(sg_list[i].addr),
+			       le32_to_cpu(sg_list[i].length), dir);
 	}
 
 	dma_pool_free(dev->prp_small_pool, iod->meta_list, iod->meta_dma);

