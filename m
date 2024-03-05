Return-Path: <kvm+bounces-10931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 87583871B90
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB0EE1C22166
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB0E72931;
	Tue,  5 Mar 2024 10:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBK5tOW/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF365F464;
	Tue,  5 Mar 2024 10:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709634171; cv=none; b=fK6Pnq4/iViE39To/d/krBBppZTbrRacmIfqPI5aGmFjxMm/4IcDLYltCd3yjNvYu363uW+ZLBNRu/mDEY6nsu95wsBuAaW5gTFP+g3bhRAYLCmicvupwWEsK0bCSZ9C/VseksB0VrbwvuHJ0cYL8x+RHyOnXrU1WE7Z+PW3mPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709634171; c=relaxed/simple;
	bh=buI8QIvB9qQbf6UKyQhoBlduuXAN0B68Jk0a66fCfeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvynUcnjo8Xu2TAexY2kvqwMXSrk7AFifqwB7il3Qnf3y9qthd+VlssGed0OpUpvLM5nE8XzcA3L/zn5svT6b84PlgNF9mNVoEPvltbalK/gH+yvimLHuEnJ+kACSYqAOakewcc5ulnZaBX/N6yG9U2jEWzsVtG9y8GrwknIlnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBK5tOW/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7864AC433F1;
	Tue,  5 Mar 2024 10:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709634171;
	bh=buI8QIvB9qQbf6UKyQhoBlduuXAN0B68Jk0a66fCfeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBK5tOW//u1gKjQCxlzqGUPpXaFkL348QNPbjQ/+tOzrARfC/uLos7xOydQJcynd5
	 lX86pLtUcuF5jc6LcRJ8OWZVn6oU2R7S3dQkTUA0si3K2laMD3Ys02IWRc9D2y1XNy
	 ZZqvMacuHdCR4k2kN05WiXItBNjyqySXCtOsLJinhqehAaQ9mwbdCctrJqVcl/DE0F
	 9li7kyfa6BIA6dEyQqn5dPJYDuylGhoLW5mKqKiGXNE8+ch9l3l7KM2l4tGDu1XdE0
	 Hs2rNV+xmnL14oMRh++xYrHm5zqZt96skJuWjnQnsvbdRlfvkAjgZxO2dEsPWI8wne
	 fTwQ5RP714BUg==
From: Leon Romanovsky <leon@kernel.org>
To: Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Amir Goldstein <amir73il@gmail.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"jack@suse.com" <jack@suse.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [RFC 06/16] iommu/dma: Implement link/unlink page callbacks
Date: Tue,  5 Mar 2024 12:22:07 +0200
Message-ID: <1d3d26afcdbf95b053a3a44ceff34a4fa5334582.1709631413.git.leon@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1709631800.git.leon@kernel.org>
References: <cover.1709631800.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Add an implementation of link/unlink interface to perform in map/unmap
pages in fast patch for pre-allocated IOVA.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index dbdd373a609a..b683c4a4e9f8 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1752,6 +1752,21 @@ static void iommu_dma_free_iova(struct device *dev, dma_addr_t iova,
 	__iommu_dma_free_iova(cookie, iova, size, &iotlb_gather);
 }
 
+static dma_addr_t iommu_dma_link_range(struct device *dev, struct page *page,
+				       unsigned long offset, dma_addr_t iova,
+				       size_t size, enum dma_data_direction dir,
+				       unsigned long attrs)
+{
+	return __iommu_dma_map_pages(dev, page, offset, iova, size, dir, attrs);
+}
+
+static void iommu_dma_unlink_range(struct device *dev, dma_addr_t addr,
+				   size_t size, enum dma_data_direction dir,
+				   unsigned long attrs)
+{
+	__iommu_dma_unmap_pages(dev, addr, size, dir, attrs, false);
+}
+
 static const struct dma_map_ops iommu_dma_ops = {
 	.flags			= DMA_F_PCI_P2PDMA_SUPPORTED,
 	.alloc			= iommu_dma_alloc,
@@ -1776,6 +1791,8 @@ static const struct dma_map_ops iommu_dma_ops = {
 	.opt_mapping_size	= iommu_dma_opt_mapping_size,
 	.alloc_iova		= iommu_dma_alloc_iova,
 	.free_iova		= iommu_dma_free_iova,
+	.link_range		= iommu_dma_link_range,
+	.unlink_range		= iommu_dma_unlink_range,
 };
 
 /*
-- 
2.44.0


