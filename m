Return-Path: <kvm+bounces-59916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4268EBD48B3
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 17:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A3DD403148
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 15:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEF1B314A8B;
	Mon, 13 Oct 2025 15:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XGXUL/n8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93C430DED8;
	Mon, 13 Oct 2025 15:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369215; cv=none; b=pNTKAajNQr+KjsJpy37m4u8sguDMwIaXtpoRgpB4nmaEg4LD72PBNGlD8HlycyIEtp9438INgKx10OjZYlOCFB4P563n0pbgPyTMW7kxaDZKdWMN8jHh2sivx8CiLUW+MwXd+x2+kAhDby+63Xz8APHMg6EYaertE2Kk4nlIUUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369215; c=relaxed/simple;
	bh=sWj2rZyT42J/OYfkx+qu79O+85llJ4XsbCx+y5qZzZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ng3RWqujI43NYrN0xEfWP8Hfm6taZ/qtaztp65fSZLGAI5gY3Oac0weF8gtBb9jLo2q2Hv/TdZjQJ9922B7OAvAKOqBCgchAQA+y0Sp0jRR8wKU6/YDw/LT+AFlhKE9pQMh8sMYu+TOsMgBa6wMeranC2olmKBzRUSqz63mzOjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XGXUL/n8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26A2C4CEE7;
	Mon, 13 Oct 2025 15:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369215;
	bh=sWj2rZyT42J/OYfkx+qu79O+85llJ4XsbCx+y5qZzZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGXUL/n8MebGFtbArYlkLWAwshlP7BxUyDbGFrxA7tRPbb+hqW7iPQf3vxeSnj6r2
	 qyMXiIj9C9BDcZ2F0nCo6bRuMbB008fDQprxf9k+4qs/28tmANmSNOnpCu/cxJGrb+
	 COka5HjkPCsWuwfgYVTAypLDEUbTY3kHhsnZpd3gQRea5XwLPJaHRqkEh3G7FaaNbI
	 ckYAcFzI41VXtx3lufS5D1zKrJ1bnuqUWNCR9gTdAgyY2tIgLBP5DHqOmKUy/rRpZu
	 dVHYyq/1RY2yPEja3+Lqr0G5FINVgnG7peq1zjmqJ9aem6yi9JJ+JJggSh0tyZTh4g
	 E6DP1eCMSd9Wg==
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
Subject: [PATCH v5 8/9] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Mon, 13 Oct 2025 18:26:10 +0300
Message-ID: <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
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
 drivers/vfio/pci/vfio_pci_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ca9a95716a85..fe247d0e2831 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,6 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 #include <linux/iommufd.h>
+#include <linux/pci-p2pdma.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -2081,6 +2082,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	int ret;
 
 	vdev->pdev = to_pci_dev(core_vdev->dev);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
@@ -2090,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
 	INIT_LIST_HEAD(&vdev->dummy_resources_list);
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+	ret = pcim_p2pdma_init(vdev->pdev);
+	if (ret != -EOPNOTSUPP)
+		return ret;
 	init_rwsem(&vdev->memory_lock);
 	xa_init(&vdev->ctx);
 
-- 
2.51.0


