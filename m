Return-Path: <kvm+bounces-44542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA807A9EC02
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 11:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F134E17CDAF
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F89426A0AD;
	Mon, 28 Apr 2025 09:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1d90qh8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB1D269B11;
	Mon, 28 Apr 2025 09:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832213; cv=none; b=Ufle+eFLTeqLEDKkze2EBBqHNT7mX+F40gSHbd7FA7mPm4oquJUQaiHhlCfL5NF7v3Iyca7vlD4bCcZWNNBPV9dNoIlaJ7jHGgTYxVn1bw8eCfXVKH+BIaanp3Jse4zcaeDbPjvUo3dlAArZtWODr4f6h7khwJKD/2XwJdOCBAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832213; c=relaxed/simple;
	bh=zDzlqykv86nTBfYEytc8wm5wkFShzSQKAsrmEhNbBwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raiyYjIHc+7gNG19YhNWOr3swRrJhU0/mNkEDe7rnRQ6FFH/4A37C0pmSR5DKUYWcC5gf2OBta1AGmZx8ndyf/nMjwV/6hzAjvj7Jw2/dbv/+EiY0WR3PbWyKACJ4FUs+CXCzirrVddc1AJHGv6IA7wtkwWV2cahgJiSf1C+2Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1d90qh8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E69C4CEE9;
	Mon, 28 Apr 2025 09:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745832212;
	bh=zDzlqykv86nTBfYEytc8wm5wkFShzSQKAsrmEhNbBwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1d90qh8CUE1R68AnclyKFgyc3M3PH8lRc6WjFsjygRgtWsAEkSuXRwZyPk5H2mWM
	 yCIjmPjwBIzNqNOH29THOBXxLDDuAZw5RIzE+DbuJITHoomDA8eEEMQ24PeQgAyr9A
	 zmhitSbQdvMeIgR+oZ5F+ZZ8YiqyBnwmEK2fSCJajwUgYutk+OX5i7mjlkL88cgAmv
	 AYmthdpUSXspJkugyHwrF2tpdEh2aUssZitwTMgxeS9uC/9y7HeLUu/Ov6P8e9WkBZ
	 RDhA7gkiFAOg5KHkp69Haf5Or2OAtnLQpJilA1Vti+fDK5ZkFfVMcaWVVXQOIyx3E/
	 fi+Uw3fAUJHUg==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>,
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
Subject: [PATCH v10 08/24] dma-mapping: add a dma_need_unmap helper
Date: Mon, 28 Apr 2025 12:22:14 +0300
Message-ID: <448112d7b47869724d99b00de052127fc9d81612.1745831017.git.leon@kernel.org>
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


