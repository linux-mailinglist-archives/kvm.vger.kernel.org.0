Return-Path: <kvm+bounces-58943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06AACBA7277
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 16:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 726FD1893491
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 14:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD622DE717;
	Sun, 28 Sep 2025 14:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXWBemys"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531C42DA742;
	Sun, 28 Sep 2025 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759071090; cv=none; b=ZJj5xxg3B5o85MWZ62IBhUCL2+QLBNDkT/m4iOy/I4xUtVnQqplr5ewjLAPqanJlML+QxqkFLmIbswgkGxo6UUYoZ3Gu96BbnRjtu1AQAKbHxCQAPthk8htbCSijuNWI9jjms0lg/mDv5zNpTkoXPixhWMFi4vgXzrd6VzcHEfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759071090; c=relaxed/simple;
	bh=eDZRe+uiWG1FtMFnPzVJnvcS6Jw2rXL9T58ek6nzrEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6LOA4MnJZ9ys/tIA4q1c+PZrk0tg/hKh7h9Sb6zXZl0ewx9ZUYDFz+2HncLoSYIe9N46h1HhDxzGM2wmtvtv8d0nr8Oo8hHFh9hPK6k58yIH1NEV9DY/i+NESVRHfnhwuPfBV8s5pTb1Qx5yWR1n5bp42Xzx0nGzE9ryvbMuSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXWBemys; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE71C4CEF0;
	Sun, 28 Sep 2025 14:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071090;
	bh=eDZRe+uiWG1FtMFnPzVJnvcS6Jw2rXL9T58ek6nzrEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXWBemyst2DNL4Nx0TAlj+1GLFiWX9QtAuizKw6bPWVd+d1GjMbABZgdikCVqKrNB
	 k+ekJUujdc+dXJX/TQGz6h7B/KkC2ygc3ieVxnnAdlZflRhVo0EUuZojYmcH0lKr3r
	 NgFC0Xd24eGucNH1bDepZ10SkBSL4/4HS1VWSmKckK8PjHAU/cq6pIkwCyjCLl2vU/
	 uVzKxC18j3BNJHGLIpsM/zz7pFrvfWFIJxSMT9bPpnUo9KwegpIbpNCY+YyYxSaXQz
	 yJDhBxW2XHOS3xz779v9FPbbO+dCOxaMQrwRKja2yAPZOzMVPs+BFtKnIawYwXFApC
	 PappgcsvPHiOQ==
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
Subject: [PATCH v4 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Sun, 28 Sep 2025 17:50:18 +0300
Message-ID: <ac8c6ccd792e79f9424217d4bca23edd249916ca.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
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
 drivers/vfio/pci/vfio_pci_core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..608af135308e 100644
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
+	int __maybe_unused ret;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2094,6 +2098,11 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+#ifdef CONFIG_VFIO_PCI_DMABUF
+	ret = pcim_p2pdma_init(vdev->pdev);
+	if (ret)
+		return ret;
+#endif
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
-- 
2.51.0


