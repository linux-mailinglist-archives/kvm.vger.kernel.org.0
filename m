Return-Path: <kvm+bounces-45404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E511AA8CC0
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 09:05:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3E2116693E
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 07:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C199F1F418F;
	Mon,  5 May 2025 07:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqtM0p4g"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2951DDA39;
	Mon,  5 May 2025 07:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746428550; cv=none; b=o/uEx2zWxfOy5Vp96sRHQM9JCR/gHavY7hR4+N7HAH4KTVPN0X70LC6IPd9VeB2wqHu4imqNSE0orr9n7zcqr/klWbCx35nXrHFYTotXR3dtxeVDMzR22GSCGYCa2VtDR+djx9z1mKdt63mOoOZy2CMpV9BlQSUlJeKYKXp8OEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746428550; c=relaxed/simple;
	bh=zDzlqykv86nTBfYEytc8wm5wkFShzSQKAsrmEhNbBwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0iV4R31euIXK9aX566B9sTWpdlE0ANaZHCDeNAcNTowJS/chWyx9J3osbmtNcKadqtCeTCp5Eiz3mIqiQ8znNMqsvjVWwCtzX/+ea8DtnL8PPXvp6qfWJMHdp6Y2qJiyYtV+5hpJO+9QNiz7pA2MAW6Z6g4rtP+1X142stosjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqtM0p4g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824E5C4CEE4;
	Mon,  5 May 2025 07:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746428550;
	bh=zDzlqykv86nTBfYEytc8wm5wkFShzSQKAsrmEhNbBwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqtM0p4gWP9l89f4xe03WY9yh8S81jdJOy9cNmMjR+Mi9fNCGSmR3SKl9rQnAZ6HK
	 ifaZF9J3ukpYGHCWk8qbzAYHobwBSK6ZPE9c8zYYX98JeidbQ7xvgllEiqhKw0HOpM
	 dzM7fO8tAGhd7WaF/P3BocqEX/LTe/YP3sRfSN9JLTsTIeDn2vlwVi/rBP3xpLyLA0
	 Hfk7nonUdMRXWPDCOVNaRXYIZ29to9Zuf/kf5xo6D/n5im+HZTPVbVJ8h8oioMZnvc
	 WaFLtd5J2lafRtA3roO1fRn3KaNxX7b0rzVH9A9CgLTev2i9azW/8Bo4QESW8C3baq
	 DP06qo478a2iw==
From: Leon Romanovsky <leon@kernel.org>
To: 
Cc: Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
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
	Chaitanya Kulkarni <kch@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH v11 8/9] dma-mapping: add a dma_need_unmap helper
Date: Mon,  5 May 2025 10:01:45 +0300
Message-ID: <11ca5400460fa195692bd413387b06ac484e03b4.1746424934.git.leon@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746424934.git.leon@kernel.org>
References: <cover.1746424934.git.leon@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Add helper that allows a driver to skip calling dma_unmap_*
if the DMA layer can guarantee that they are no-nops.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/dma-mapping.h |  5 +++++
 kernel/dma/mapping.c        | 18 ++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index a71e110f1e9d..d2f358c5a25d 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -406,6 +406,7 @@ static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
 {
 	return dma_dev_need_sync(dev) ? __dma_need_sync(dev, dma_addr) : false;
 }
+bool dma_need_unmap(struct device *dev);
 #else /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
 static inline bool dma_dev_need_sync(const struct device *dev)
 {
@@ -431,6 +432,10 @@ static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
 {
 	return false;
 }
+static inline bool dma_need_unmap(struct device *dev)
+{
+	return false;
+}
 #endif /* !CONFIG_HAS_DMA || !CONFIG_DMA_NEED_SYNC */
 
 struct page *dma_alloc_pages(struct device *dev, size_t size,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index cda127027e48..3c3204ad2839 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -443,6 +443,24 @@ bool __dma_need_sync(struct device *dev, dma_addr_t dma_addr)
 }
 EXPORT_SYMBOL_GPL(__dma_need_sync);
 
+/**
+ * dma_need_unmap - does this device need dma_unmap_* operations
+ * @dev: device to check
+ *
+ * If this function returns %false, drivers can skip calling dma_unmap_* after
+ * finishing an I/O.  This function must be called after all mappings that might
+ * need to be unmapped have been performed.
+ */
+bool dma_need_unmap(struct device *dev)
+{
+	if (!dma_map_direct(dev, get_dma_ops(dev)))
+		return true;
+	if (!dev->dma_skip_sync)
+		return true;
+	return IS_ENABLED(CONFIG_DMA_API_DEBUG);
+}
+EXPORT_SYMBOL_GPL(dma_need_unmap);
+
 static void dma_setup_need_sync(struct device *dev)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
-- 
2.49.0


