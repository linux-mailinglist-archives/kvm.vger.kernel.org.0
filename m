Return-Path: <kvm+bounces-26703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D29F9767C7
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4036A1C20E51
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBEE31BF803;
	Thu, 12 Sep 2024 11:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMt/9VHS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2361BF335;
	Thu, 12 Sep 2024 11:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139846; cv=none; b=Myxsxv3MpNYmtflcuFPcSr61wxn0mfEuY8ZlfZ3x8URBuTGHwZeD2s5j6EewBf4rYVNo0JcBbGC8QkSsIQo6yrfO9C4yY4BfykyWycvzBMxzrQwa8+ftAY68AV8xsC4Wcd4RN44BJgu2PvVktqdnhmdXqZvcik3Vb5X15tbVMgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139846; c=relaxed/simple;
	bh=HzFyylaMePR5bS7VyKQApbkFy4MWvNmh8/Ifgo8KsU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3k83cql+lGRLfEG2mznFjbvqmxe2GBmSacn8UrcLCoAa81N0pdiByeY+QUZOZl8GOoBQa1ewTZFSbWl7UtD3OyVfnaClBhtJdQ7DwRx+MfCR5z2s5ODNeB0B4/I01s6n9RIPLDKTqlcr6e8kG0iZw+Vmui3SzpDEhPnFc/A5Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMt/9VHS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE14C4CEC5;
	Thu, 12 Sep 2024 11:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139845;
	bh=HzFyylaMePR5bS7VyKQApbkFy4MWvNmh8/Ifgo8KsU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMt/9VHSYIlDpVGdX26n1N0CdVrTRm10It8Sa8NMHcf+17B/DEKPd5jcRIQstDF5l
	 y/zknkTz0QWWnnaDNoU/w5MrYILx1JHP+V4tz9u84Cewb0+/xN0X7Xobu9RYdt4sE3
	 8QSp8DqCuKUgnnC5JLgioLFGolGO2jWjErhnFWAI64U90eRPEY/a80PM1URWvna2tv
	 EjnP1bBa2i6W+ZV7YFLYJDEIpcKOoFD0i83H5rqEd6sFjATC3qHX2bD88Wi/OivMQx
	 jvCqxXIec8J/zMqtF5Uhjik7uSRXJU4fi3neuttBSeo6DVEN/1c89HG77KYw9oQArh
	 FWiOq1isCI2iQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Zeng, Oak" <oak.zeng@intel.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 21/21] nvme-pci: don't allow mapping of bvecs with offset
Date: Thu, 12 Sep 2024 14:15:56 +0300
Message-ID: <63cdbb87e1b08464705fa343b65e561eb3abd5f9.1726138681.git.leon@kernel.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1726138681.git.leon@kernel.org>
References: <cover.1726138681.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

It is a hack, but direct DMA works now.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 881cbf2c0cac..1872fa91ac76 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -791,6 +791,9 @@ static blk_status_t nvme_map_data(struct nvme_dev *dev, struct request *req,
 			return BLK_STS_RESOURCE;
 
 		rq_for_each_bvec(bv, req, iter) {
+			if (bv.bv_offset != 0)
+				goto out_free;
+
 			dma_addr = dma_map_bvec(dev->dev, &bv, rq_dma_dir(req), 0);
 			if (dma_mapping_error(dev->dev, dma_addr))
 				goto out_free;
-- 
2.46.0


