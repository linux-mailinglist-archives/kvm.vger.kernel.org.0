Return-Path: <kvm+bounces-57305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7263B530BA
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 13:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94586A812F6
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 11:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 722CA322A3A;
	Thu, 11 Sep 2025 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ad2yV5YN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE3D31C573;
	Thu, 11 Sep 2025 11:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757590453; cv=none; b=hfTkEU5B/Xiaeze7xNZ64D9k9Gzv9zz17WUb2fQR4wAZJczx4BkrAHJzmF4ovRFx/Cag0Eq59hjVQsOlYS3h+SxYfnet0PZdPAUo43yv7i3o/D4HLc7bemsQF05EAZtWH7HZQGlKyQQOziorSiwek8bko6WerYIop+kZCoVlKwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757590453; c=relaxed/simple;
	bh=mSqO5z/pzcDb//9yVcXdFaM2PL2BJKuKbGZo2SMKi0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHw+xX6sRCCTCuGKeszi38GTJH2GnPAhsOsz3PIu+SsFLi6raPKVVeADvv+c1pmS1WtGeVtojFWUi9pVpw1EurrceIaGC0xL3vDgQ/p9OFZCBTWwD7VIsynyzO/4a8vy1LsH/515CpQrLFoImyZ2jaR1z8OLHs//cpkA73+sLTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ad2yV5YN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F21C4CEFA;
	Thu, 11 Sep 2025 11:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757590453;
	bh=mSqO5z/pzcDb//9yVcXdFaM2PL2BJKuKbGZo2SMKi0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ad2yV5YNeoJ9zzsdaHBjO699sFgtNfEpNes8sd89X4omIZJ0YEBy1O3hp6lny0yrZ
	 ILWO5eA0XWuT9RzwLMcDuv6Ntp704U58ULZdRrvE0BRzdadauWkHDNUhlIy8diW1Sr
	 y2192xF79yqliPNZoabgcXQVuZLHO4PMDutNKFhydmoevRH0wase5xQGcjIK3FY0MF
	 X68jQ0rwPyOETqlGGi+u4y12ceGmY4P7LGDzXxyCxL6+cmnuL8MODVCaf7moeka6WD
	 3HKhRHP7rRXVx3CpCriHEXbkddLjKiLXtEypIBzfxSe7hBKwxGoElFYScXxEcY8u6u
	 LdzxlHXBI2jCg==
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
Subject: [PATCH v2 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Thu, 11 Sep 2025 14:33:12 +0300
Message-ID: <536369328cdeda87ae37b37c63f800d38186034d.1757589589.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757589589.git.leon@kernel.org>
References: <cover.1757589589.git.leon@kernel.org>
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
index 7dcf5439dedc9..b02dda8c96341 100644
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
+	int i;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2094,6 +2098,13 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+#ifdef CONFIG_VFIO_PCI_DMABUF
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		vdev->provider[i] = pcim_p2pdma_enable(vdev->pdev, i);
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


