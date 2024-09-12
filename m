Return-Path: <kvm+bounces-26704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D9D29767CC
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BAD9B230FE
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329A81BFDE7;
	Thu, 12 Sep 2024 11:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rjQEVR0W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0101BBBCB;
	Thu, 12 Sep 2024 11:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726139850; cv=none; b=sHfOuN4fR0Oq+D3V6FWCudeKmNoS3KZ5lmwPp3nEVhBhBvducIBr/lD517gFsPv56y3Pz6xKWzpNHFIBFmA8ojK/RQpOOiFQxJAhyHsJ9nq0EGUtahCqUaXVy6U3hATeRwsVBTtf/YE/7TEwzfT/7jxJ1lY296mX4zs42s85CY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726139850; c=relaxed/simple;
	bh=Ch307cuLMtu9IkxYPq9fEPmV/1GlNElaatF0p6+K/3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpym9wnWzy48ngUNVe2+2Mazkp9ae4Lh6KSykxQtPULo2+U5AZmWTPXkXMwbmez3p9ZH5pKWECs/VP89Bx9z4R0PAWfAVmSU2LeN3npFFFxFWc1eSBnP4esgrmy01GwZA3UYrtrx5M3kQ61VUPQ+2B+tvKDds7o9gykfrSW4/sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rjQEVR0W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B911C4CECE;
	Thu, 12 Sep 2024 11:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726139849;
	bh=Ch307cuLMtu9IkxYPq9fEPmV/1GlNElaatF0p6+K/3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjQEVR0WNIDFIumqiRWFBZ/LeaRIQrWt7cRNRpwd5Qr3Ery2891OThDNpX5O70OkA
	 3u+K7SybOwx4RJVpNWxWVcp9dPJOARjRDtQ5bfDWc6ZBdwjeLjroi/LGRBt7k8iEnk
	 rrKGRP00PzsLM6BQjTbD0bOTaSYxwnYo6ipA4GhON7Q3sfr8WoiFk8o1QO2Fv+ILhF
	 /xfjffj8UsYtxpX9Wuzy0IcN8Uxvpj7UQIuJSgTBOPVfFQgt+1eyO4AqZDO/l5tLYd
	 5CdaCvA6GAmBErDw8MkhJzDPoXCGNeg9rN3Ks4+pahOUrr4xwY6R/1BbLfmuF5yF5c
	 mxeUvTEss0paA==
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
Subject: [RFC v2 19/21] nvme-pci: precalculate number of DMA entries for each command
Date: Thu, 12 Sep 2024 14:15:54 +0300
Message-ID: <8c5b0e5ab1716166fc93e76cb2d3e01ca9cf8769.1726138681.git.leon@kernel.org>
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

Calculate the number of DMA entries for each command in the request in
advance.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a9a66f184138..2b236b1d209e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -231,6 +231,7 @@ struct nvme_iod {
 	struct nvme_request req;
 	struct nvme_command cmd;
 	bool aborted;
+	u8 nr_dmas;
 	s8 nr_allocations;	/* PRP list pool allocations. 0 means small
 				   pool in use */
 	dma_addr_t first_dma;
@@ -766,6 +767,23 @@ static blk_status_t nvme_map_metadata(struct nvme_dev *dev, struct request *req,
 	return BLK_STS_OK;
 }
 
+static u8 nvme_calc_num_dmas(struct request *req)
+{
+	struct bio_vec bv;
+	u8 nr_dmas;
+
+	if (blk_rq_nr_phys_segments(req) == 0)
+		return 0;
+
+	nr_dmas = DIV_ROUND_UP(blk_rq_payload_bytes(req), NVME_CTRL_PAGE_SIZE);
+	bv = req_bvec(req);
+	if (bv.bv_offset && (bv.bv_offset + bv.bv_len) >= NVME_CTRL_PAGE_SIZE)
+		/* Accommodate for unaligned first page */
+		nr_dmas++;
+
+	return nr_dmas;
+}
+
 static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
@@ -779,6 +797,8 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	if (ret)
 		return ret;
 
+	iod->nr_dmas = nvme_calc_num_dmas(req);
+
 	if (blk_rq_nr_phys_segments(req)) {
 		ret = nvme_map_data(dev, req, &iod->cmd);
 		if (ret)
-- 
2.46.0


