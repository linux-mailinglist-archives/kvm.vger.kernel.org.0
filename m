Return-Path: <kvm+bounces-58756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81157B9F8AD
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 15:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BC3B7BAEB1
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 13:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E74E283CB8;
	Thu, 25 Sep 2025 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifN8f/b7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5840C27A92E;
	Thu, 25 Sep 2025 13:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758806336; cv=none; b=ncSY9K52bgRjKMY7oHsCalMbB006WjQGpZFJR4NqVbkaHfAbvc/JkeNiyeAv7aeaUtH31E07f8Eoktkv/xKIglZNQZvurDoYZbjT4HOq+fPwbJWqC8fvwdbQpvfihFMnCQmty1xtkYp1rfuI9PEnrwgxMnxbDesCYp3Xj0g8xiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758806336; c=relaxed/simple;
	bh=KyvoIVO5yd9BSrcJftqBm+1vYzNbuC1mO8MyRdzIYcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHu8SOKPIZHrzFSkpg0i/Sf8n4ynGam2/TUZynV9NsgxpjnGjaK4byqAbAi0g0Q+vaPkwFyH7sMAIxcsIbDT6wVioFNhiD5Ykj251TlCSlC1mMCEBivnF1VyOOtCeYK035Ie7+sLLyrDNJpg0UYm8pPbz3AMVeyiixO/r35hGpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifN8f/b7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DBCC4CEF7;
	Thu, 25 Sep 2025 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806336;
	bh=KyvoIVO5yd9BSrcJftqBm+1vYzNbuC1mO8MyRdzIYcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifN8f/b7xNvXk4yklfFciNbhLhFDN2pkIXiduF42mX7McmhVOTROAIJh6sdHzyR7I
	 IgdkvMQHVN0FjSppxopIVWhetGWpoc7kqFpxnE+6X8JlNiiR4kNGHaBlnLHPqV+PPZ
	 LOWF7+YNsb2VWjaT9ndJ/3LA6FJNOMYmVy49i8vb0YVcC4GME3GFK294j6S/HWUFN5
	 kcpF1JjtOTynLslV5scuGLfXWpLz9sFkXFYp3MulpMtWLJRadTHqkH3RxVyANqRyKW
	 uoJCxqeEv5HGx32G2ndbHij44kNTxzyNHZzLt4Vc3ZrDCB3RgHP7gHcSs7FXaQlGdX
	 dl7ukQUm8QdXQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH v3 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Thu, 25 Sep 2025 16:14:36 +0300
Message-ID: <79ffd43cd22763a376a3abc75fc7f9ed89ec9a9d.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
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
 drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++++
 include/linux/vfio_pci_core.h    |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc9..356a0e2fd3780 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,6 +28,9 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#ifdef CONFIG_VFIO_PCI_DMABUF
+#include <linux/pci-p2pdma.h>
+#endif
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -2085,6 +2088,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int __maybe_unused i;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2094,6 +2098,13 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+#ifdef CONFIG_VFIO_PCI_DMABUF
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		vdev->provider[i] = pcim_p2pdma_provider(vdev->pdev, i);
+		if (IS_ERR(vdev->provider[i]))
+			return PTR_ERR(vdev->provider[i]);
+	}
+#endif
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2a..2184ba65348b8 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -94,6 +94,9 @@ struct vfio_pci_core_device {
 	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
+#ifdef CONFIG_VFIO_PCI_DMABUF
+	struct p2pdma_provider  *provider[PCI_STD_NUM_BARS];
+#endif
 };
 
 /* Will be exported for vfio pci drivers usage */
-- 
2.51.0


