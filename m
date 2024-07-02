Return-Path: <kvm+bounces-20840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1407A923981
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 11:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8AF32824D9
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 09:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456F0176FD2;
	Tue,  2 Jul 2024 09:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tmMV07HW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5C8176251;
	Tue,  2 Jul 2024 09:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719911466; cv=none; b=ZoBaY6UI1AcyWDd0zAbOFYN+pYHu/15iU2a60ePFqiDo+G7orM3qDr4D9w62AjrqCnSEfn9xH2bYiRIRsLJi8rbHFcVBR4vzrnFTVSzpPM+htFefaY1akLmdYLYdPMuQmOJBQLKaC5tKjg3CoQHh3xw6t1P1vq4ID1oxsz9qr7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719911466; c=relaxed/simple;
	bh=awqNz5OGdWfjQsJN8aSzpTwPuTxHlPEDhpz1xfEBgC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIF9GWMGywGFgrSfnW8pYPNq1p2rw5mvoMYa09ZPply7n748W1EJM+2OpbT2GzwW7G2tTeLvNoXTyffOcVRgQvBtYsRm6ZwtPoBylL//qBfHUpiP+KHOgwklax8mGMY2APqOvOnAQO5Zm1h+NHl0luxnnIuc7nR+ILzg9kjT7Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tmMV07HW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38628C116B1;
	Tue,  2 Jul 2024 09:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719911466;
	bh=awqNz5OGdWfjQsJN8aSzpTwPuTxHlPEDhpz1xfEBgC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmMV07HWOakUhLEx0CG5Sw8D1u/vJiFeT/1LOA4/MYdwbWSy8GvydRXDag+XzNQuF
	 8Mrby6JUZOtPEv8fs7zqbYmgnJ3vQ0E8UKqg2AiGbf2B4rjUPAo8OMiBBUtmXlUtED
	 I7lOY1LwtkVhj5RlocDgysGvTm0aU3G+jzWGhM9DlHlbRQ+NQwCweNkMi/QFwfNt5f
	 Zt/8qIdBUHskSlNSHY+lwUUXkwkAM2VZSfuGEizQOnbvlLYGPXRFfuO7ZnqRmHvzP3
	 sHQW3H4gZFNAN04PzGFcNOHwkG6/bvqhEaQ9QjvKDRliH9gVdc0oevJLqLUVJ+y2YD
	 4NmY108G1I3Ow==
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
Cc: Sagi Grimberg <sagi@grimberg.me>,
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
Subject: [RFC PATCH v1 17/18] block: export helper to get segment max size
Date: Tue,  2 Jul 2024 12:09:47 +0300
Message-ID: <3649c1dc673ea0a49a90f3e01b76ef91fb90f076.1719909395.git.leon@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1719909395.git.leon@kernel.org>
References: <cover.1719909395.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <kch@nvidia.com>

Export the get_max_segment_size() so driver can do use that to create
DMA mapping when it receives the request.

Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-merge.c      | 3 ++-
 include/linux/blk-mq.h | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8534c35e0497..0561e728ef95 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -190,7 +190,7 @@ static inline unsigned get_max_io_size(struct bio *bio,
  *
  * Returns the maximum number of bytes that can be added as a single segment.
  */
-static inline unsigned get_max_segment_size(const struct queue_limits *lim,
+inline unsigned get_max_segment_size(const struct queue_limits *lim,
 		struct page *start_page, unsigned long offset)
 {
 	unsigned long mask = lim->seg_boundary_mask;
@@ -203,6 +203,7 @@ static inline unsigned get_max_segment_size(const struct queue_limits *lim,
 	 */
 	return min(mask - offset, (unsigned long)lim->max_segment_size - 1) + 1;
 }
+EXPORT_SYMBOL_GPL(get_max_segment_size);
 
 /**
  * bvec_split_segs - verify whether or not a bvec should be split in the middle
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 89ba6b16fe8b..008c77c9b518 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1150,4 +1150,7 @@ static inline int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 }
 void blk_dump_rq_flags(struct request *, char *);
 
+unsigned get_max_segment_size(const struct queue_limits *lim,
+		struct page *start_page, unsigned long offset);
+
 #endif /* BLK_MQ_H */
-- 
2.45.2


