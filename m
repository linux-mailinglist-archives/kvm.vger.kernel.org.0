Return-Path: <kvm+bounces-53234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8EEEB0F305
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67A831AA7F0A
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154CE2EB5DB;
	Wed, 23 Jul 2025 13:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="to57+Gtb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B872EB5AD;
	Wed, 23 Jul 2025 13:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753275745; cv=none; b=j1WEPFuPCPbpqBxhgPPDExPDomcekNgODhYmOP0/Xzki6VzXXqvXZO6NXXdfbCckEdPqxqCVvKfFggBlQehpxvztqMMWkPjXES2huMgv22PKq0YO4wBwM4uif2leyfx9Tm51/+egO8NMVFWB6oJkz9jGOSiiUUZPoCLLXShQEzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753275745; c=relaxed/simple;
	bh=6nRA10ywpK7SSRO/jFMyVT/cEz8hEByS2jaY5xZiXc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIORRtyR6agCy8LYRDXIzmDJYuNC/w3SQkxqjNmFRnx+QC5mYbkHlKgIch1BmHzHEzdaBAsxG0K7k8C7XBr8PeMKPFqSC1JwfRMLuf/65y0PA8NlTznYaf3zpVLRZcmAAgOVaPEd1Tq5LBoWOMOKwTUGitDvFIivgC8IqlOhGiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=to57+Gtb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC426C4CEE7;
	Wed, 23 Jul 2025 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753275744;
	bh=6nRA10ywpK7SSRO/jFMyVT/cEz8hEByS2jaY5xZiXc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=to57+Gtb/kqx61u9wLvouYUY2r3rfu/wxYrNo5FftZKZzUMaadwbeJO7Fvzil43/3
	 AWa8IK+h1CT0qK5BjiHdWXKAbRXPY8yBWh2yelV64TCR8e7XICKlREhYh5x5HhCzTD
	 yv7uitdjloEM0UjQRFtyMTUY2BnLpDGa+mOPdgvSC8gki/HU0WdgMJN+OjLqJWiNa1
	 dfLitFrC/BRt3xcJ+C0G7LPmMwJbLTQUGj/ysphAitQuFV/pKbp8GK9fi3A47SLxl6
	 perEVWMTCR66ZhAhr2ZD35eqO0aHF3fNBcZl74gC3Yw/qyyElwragyVKfbzDkkcr6N
	 yZWP5Z2A8oaMQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Wed, 23 Jul 2025 16:00:09 +0300
Message-ID: <a55d0868fbf7e9000ed46c6d45928e5b9a5cae1f.1753274085.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Make sure that all VFIO PCI devices have peer-to-peer capabilities
enables, so we would be able to export their MMIO memory through DMABUF,

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 4 ++++
 include/linux/vfio_pci_core.h    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6328c3a05bcdd..1e675daab5753 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -29,6 +29,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#include <linux/pci-p2pdma.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -2091,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+	vdev->provider = pci_p2pdma_enable(vdev->pdev);
+	if (IS_ERR(vdev->provider))
+		return PTR_ERR(vdev->provider);
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index fbb472dd99b36..b017fae251811 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -94,6 +94,7 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+	struct p2pdma_provider  *provider;
 };
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.50.1


