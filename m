Return-Path: <kvm+bounces-53917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49DDBB1A2BD
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 15:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADD7B3AEDA2
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 13:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100CA274B54;
	Mon,  4 Aug 2025 13:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oV6re8fi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E412749E2;
	Mon,  4 Aug 2025 13:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754312502; cv=none; b=rYAled3tgRcrSwssIq/qAStoFIaUj+H6k7qrBfKxI4Zz312RouGOlYvAf/PyMclHpQxIQG6JA0d65ppYGtRCdMRGOjD1lc4FzNiGP2s1QA2GEHuMFjXFJA/nTUhgLppqVR//yRcoZZ+UaZ4HJ335uv13EKXutwrk3EekBCf5agI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754312502; c=relaxed/simple;
	bh=MSxBGzEUPE37zYCyYE4jEXpC4IceAGVrySCuVXBUCzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3bptb72X7thf0KRRkJiqrqDwfNv6uHnTDKAolYMLfCmr6wWP0gkOH/LaWgrQSHe2+tiuMyB9ROg7dYsx33d2s2rbRfKok8YE4wgtpUsn4cmGKnDNKhe3G/non6B1NXg1bFTUh+HMvKW6gi4mNvt5VangUrmUOhSIjhjHqzB26g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oV6re8fi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796FFC4CEF8;
	Mon,  4 Aug 2025 13:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754312501;
	bh=MSxBGzEUPE37zYCyYE4jEXpC4IceAGVrySCuVXBUCzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV6re8fiGNwYDZzCzdRzp9XpjScFB7jHhr0bUqrsSd/RU8VD1+cDyB4db1ivcuz67
	 ZbqOoy4QDgWahTEBLZIkeuGoLDtCxufGY1mXb4uUNEIIogWWDZKxvNPNgmGAOQfthR
	 M88oaFlWV16G0mYbetwlnMeQOqlSTPkZtmJgNfx1DBxt8qHsi8vzBGtgUSwzfG/EF/
	 +feKrcxhDRe2w3XUDGmoRDhE/Z6LPttQLNSWEXlBJ9NMAhEVqOVOLoQfSfWwEFlJa9
	 t+8VS5mhktJavv7v+cSijhYGtO53nybwj4RxWUn/B2l2HWenabrQ2aR3U+cNT0+v2t
	 iMQ+fAg6U3ZtQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>,
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
Subject: [PATCH v1 08/10] vfio/pci: Enable peer-to-peer DMA transactions by default
Date: Mon,  4 Aug 2025 16:00:43 +0300
Message-ID: <edb2ec654fc27ba8f73695382ab0a029f18422b5.1754311439.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
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
index 31bdb9110cc0f..df9a32d3deac9 100644
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
@@ -2088,6 +2089,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
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


