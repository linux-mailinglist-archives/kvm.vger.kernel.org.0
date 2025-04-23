Return-Path: <kvm+bounces-43903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E727A98336
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBFD93BD972
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CD62900AC;
	Wed, 23 Apr 2025 08:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J12nDPRU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8732228F95F;
	Wed, 23 Apr 2025 08:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745396131; cv=none; b=DXUMPRZCdojAiYDSF4QPeh3bCTvN+HAOAwYArNHKW93wIEQTn7BfIzYxL2PWu1xS47REQ4HgrXSfUsz4G++tmnbIrRayh+a4jKFWBkGtgFFc40LkZ1tVf4T/4AI2m6OB8K6o0dHVz8krvbrE+6MrPUNOjZ+ib3UMmWij0i0+DlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745396131; c=relaxed/simple;
	bh=hJ7Ip9+BoZAGI5de25k6VVDZHayvfvf2mLK8emkWpDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAoFM8ojfffgHwKxDLfu12teThRYCcyM0C+/mRMvNYou3fBLzepTqkcfCaX3kt8T96EiJ98eL+6O7H5ueqHFc1gZh7FWuI54Y3/3LfK6HcL13GVkojv74mwCo1GhlVQ2slg2ymn8i0RC2O6oQUMDj8ZgyXADcig1MO1eWMFYK0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J12nDPRU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA44FC4CEE2;
	Wed, 23 Apr 2025 08:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745396130;
	bh=hJ7Ip9+BoZAGI5de25k6VVDZHayvfvf2mLK8emkWpDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J12nDPRU3cH7wA88Iu9BFVrY+PzsKtMJ7xncym3a/Q+sMbBCS7mLM3ryCPgfwbt4+
	 VfesgKcyGq1stn/1qMWS0rL0/jhFKx98nQP5G9WUIPyi6U66Kj1H2z5Cp+DRsrjzsp
	 2/XrS33uwHNvshj+OP+6nyD8KmO74H0MbhjK/6yY7scz7tsm8Jsap/FHPMQdW4g0Xu
	 T5CFKk5USJ5XElRY01pmoB94PGC10Pllk2VaLO/uxA0SClhTgNbPWpAKkOAyDN7459
	 8vRn1WHXTwkLPiavmersXQcNwP6Sz1WdbV+biC8HCQeqVCWW6Zf1OZLtauCglURDip
	 0i7XWKreZyV0w==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jake Edge <jake@lwn.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
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
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v9 24/24] nvme-pci: store aborted state in flags variable
Date: Wed, 23 Apr 2025 11:13:15 +0300
Message-ID: <9432af8b4b3b947ed6b280e722389c188d5c957e.1745394536.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1745394536.git.leon@kernel.org>
References: <cover.1745394536.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Instead of keeping dedicated "bool aborted" variable, let's reuse
newly introduced flags variable and save space.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/nvme/host/pci.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index eb60a486331c..f69f1eb4308e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -219,6 +219,7 @@ struct nvme_queue {
 enum {
 	IOD_LARGE_DESCRIPTORS = 1, /* uses the full page sized descriptor pool */
 	IOD_SINGLE_SEGMENT = 2, /* single segment dma mapping */
+	IOD_ABORTED = 3, /* abort timed out commands */
 };
 
 /*
@@ -227,7 +228,6 @@ enum {
 struct nvme_iod {
 	struct nvme_request req;
 	struct nvme_command cmd;
-	bool aborted;
 	u8 nr_descriptors;	/* # of PRP/SGL descriptors */
 	unsigned int flags;
 	unsigned int total_len; /* length of the entire transfer */
@@ -1029,7 +1029,6 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	blk_status_t ret;
 
-	iod->aborted = false;
 	iod->nr_descriptors = 0;
 	iod->flags = 0;
 	iod->total_len = 0;
@@ -1578,7 +1577,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 	 * returned to the driver, or if this is the admin queue.
 	 */
 	opcode = nvme_req(req)->cmd->common.opcode;
-	if (!nvmeq->qid || iod->aborted) {
+	if (!nvmeq->qid || (iod->flags & IOD_ABORTED)) {
 		dev_warn(dev->ctrl.device,
 			 "I/O tag %d (%04x) opcode %#x (%s) QID %d timeout, reset controller\n",
 			 req->tag, nvme_cid(req), opcode,
@@ -1591,7 +1590,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 		atomic_inc(&dev->ctrl.abort_limit);
 		return BLK_EH_RESET_TIMER;
 	}
-	iod->aborted = true;
+	iod->flags |= IOD_ABORTED;
 
 	cmd.abort.opcode = nvme_admin_abort_cmd;
 	cmd.abort.cid = nvme_cid(req);
-- 
2.49.0


