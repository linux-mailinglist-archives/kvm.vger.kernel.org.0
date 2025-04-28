Return-Path: <kvm+bounces-44562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3492A9EC78
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 11:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE3D47AD981
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495272641F9;
	Mon, 28 Apr 2025 09:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyqXQ6VB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E460263F5B;
	Mon, 28 Apr 2025 09:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832261; cv=none; b=SbuMfK4cuBLLMFvJXVUEdxf/SS3ZR3KTIVaKlyIiWwSkxavAomECMr0nhKQZN1LrymyX1wsfhjq4OFyj3Z/dV4l5VvQH7OrxH/uAogznHZdI2kv3KTLPZEj1PWgmNdbm+6CoKYDPwWkJSytj1yFrHsuYjG/L7LGIB7IAW3nRb7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832261; c=relaxed/simple;
	bh=JltzEs94lpehyHx6nl6wHRaPQKIRgU/HyWicrIFjUro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8mbF1sFmXl/wShn023sj+q8DSPUPUqTZFh2MVY76MzhYChzQFbhXXuHHbW9mOI4krua6MxY2p5sHGOxjRm+c1RIloccEAHExXMxgEz/i9D3zJVuBq0bgRkzXoECHhj99A5NrFlH1nWiRtX5OJjhmh6gwdls6GqekVyivY6I2KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DyqXQ6VB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C09AC4CEE4;
	Mon, 28 Apr 2025 09:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745832260;
	bh=JltzEs94lpehyHx6nl6wHRaPQKIRgU/HyWicrIFjUro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyqXQ6VBPGUV60WqF+uTbZzXAsUAIJ9C1BCb2KV9m8F42ozYCzXInlnKQFxIS2b36
	 s+SctZer4F7Q5NkzQQld7WJZo9qsmkj9svarVHnHcf2ojzaBTAeBo4/HXSAAYmAED9
	 0xAI51RXFcaNAViqGFTvgw71I5NRyjdQoBDcESxnGQBEZOfbe7wMnLan2Z1+J+qRj+
	 8OEN5Dl/+rgO5hpebjkaj1SMCY1/3eRJ/TzmFUnFCx9NWXXoE71dQT6bHrYlzaqCDj
	 cQfDk5LtjtwfeRrBMl5iLWmlcl+SqiMKCEXYnYeUEY8YsO01MnQzVcNjFdveNAbkls
	 vBmDT0QLSZCQA==
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
Subject: [PATCH v10 24/24] nvme-pci: store aborted state in flags variable
Date: Mon, 28 Apr 2025 12:22:30 +0300
Message-ID: <ef01afea04a2aca3217ce1b52ec99bcd80e99f00.1745831017.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1745831017.git.leon@kernel.org>
References: <cover.1745831017.git.leon@kernel.org>
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
index eb835425b496..9f3e2d8cbd04 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -219,6 +219,7 @@ struct nvme_queue {
 enum {
 	IOD_LARGE_DESCRIPTORS = 1 << 0, /* uses the full page sized descriptor pool */
 	IOD_SINGLE_SEGMENT = 1 << 1, /* single segment dma mapping */
+	IOD_ABORTED = 1 << 2, /* abort timed out commands */
 };
 
 /*
@@ -227,7 +228,6 @@ enum {
 struct nvme_iod {
 	struct nvme_request req;
 	struct nvme_command cmd;
-	bool aborted;
 	u8 nr_descriptors;	/* # of PRP/SGL descriptors */
 	u8 flags;
 	unsigned int total_len; /* length of the entire transfer */
@@ -1027,7 +1027,6 @@ static blk_status_t nvme_prep_rq(struct nvme_dev *dev, struct request *req)
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 	blk_status_t ret;
 
-	iod->aborted = false;
 	iod->nr_descriptors = 0;
 	iod->flags = 0;
 	iod->total_len = 0;
@@ -1576,7 +1575,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 	 * returned to the driver, or if this is the admin queue.
 	 */
 	opcode = nvme_req(req)->cmd->common.opcode;
-	if (!nvmeq->qid || iod->aborted) {
+	if (!nvmeq->qid || (iod->flags & IOD_ABORTED)) {
 		dev_warn(dev->ctrl.device,
 			 "I/O tag %d (%04x) opcode %#x (%s) QID %d timeout, reset controller\n",
 			 req->tag, nvme_cid(req), opcode,
@@ -1589,7 +1588,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req)
 		atomic_inc(&dev->ctrl.abort_limit);
 		return BLK_EH_RESET_TIMER;
 	}
-	iod->aborted = true;
+	iod->flags |= IOD_ABORTED;
 
 	cmd.abort.opcode = nvme_admin_abort_cmd;
 	cmd.abort.cid = nvme_cid(req);
-- 
2.49.0


