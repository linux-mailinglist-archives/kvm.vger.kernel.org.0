Return-Path: <kvm+bounces-34732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C374A050C9
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 03:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0214A188963C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94DDB1A706F;
	Wed,  8 Jan 2025 02:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GwRjz4eI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1773E1A3056;
	Wed,  8 Jan 2025 02:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736303356; cv=none; b=cOnCehkpSseAtnfBnf4IUyipDzcz6OfwyHEcZkW4En8u0Y4JMzdytzyeqSwDBEZFtgxV5JQKREaUzMjA47k/WO6f50rEfJM7vGPVbAD/3ueiKir8g2Ga+oJY60Zk5UIEQrmn0sEVSUj6BdbQ0QVXyJVHG/bXnqW9T3yJ4t6XgsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736303356; c=relaxed/simple;
	bh=OdYvqy9SZiyGRa0z3UebND5Dabkm8gIYOojEDkxguSw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k/Tj5oRKK/YemCYeElnmLbd5U7UJEve3/bAhROcntORZmL5LKT4c0emnBqSAeoyLiRi2efTyURR26gIZxQKtAR/pxKsgO+s6tk/zEnyaumi1ILgFVXyz1lcLpbvMEjd6/og7tNSbndBEvzsY7CmU05xn5AsDdbXzscmOJ6hCU5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GwRjz4eI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736303355; x=1767839355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdYvqy9SZiyGRa0z3UebND5Dabkm8gIYOojEDkxguSw=;
  b=GwRjz4eIweKY2zGzQ4oCw5B1aP6zFyNSpxcITvrArbTgix8l7F4zf9n0
   YlKps6VM5vhbQaKbdnqvpbNqVWQmmyXZftBsFo1pGMaTwryx1PPFJHiAf
   tl4sa44v2kj1FUcSmZ4+GEuydM3MKm3/UuCR55kFtTj2pRQAmjXfbVmMj
   WWyoKw2yskdfXKAaNxV660ehbhRYn1J6axEY/SGf8dMpZkaWOtZ48P4nf
   gT8S7Fd+TE4nQX/n285al2yYH9ZjSoXka5u54AtFm8S5haHt892uk5Nkk
   4M+NypF6Ene1KU6776462zO7HzXb2yf7aRgRtInN2YW+LY0/ts+C9lv0m
   w==;
X-CSE-ConnectionGUID: aOcBgEMlQZKF1q2K/AIdTQ==
X-CSE-MsgGUID: kbShPKG/ShWXVFr02mMsxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47010580"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="47010580"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 18:29:14 -0800
X-CSE-ConnectionGUID: f/1pbW8GShW+Cp7ykLs29Q==
X-CSE-MsgGUID: 60HgkxdjTqiSz/RcjwfLHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103793792"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 07 Jan 2025 18:29:09 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	vivek.kasireddy@intel.com,
	dan.j.williams@intel.com,
	aik@amd.com
Cc: yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: [RFC PATCH 09/12] vfio/pci: Export vfio dma-buf specific info for importers
Date: Tue,  7 Jan 2025 22:27:16 +0800
Message-Id: <20250107142719.179636-10-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250107142719.179636-1-yilun.xu@linux.intel.com>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

VFIO dma-buf supports exporting host unaccessible MMIO regions for
private assignment. Export this info by attaching VFIO specific
dma-buf data in struct dma_buf::priv. Provide a helper
vfio_dma_buf_get_data() for importers to fetch these data.

The exported host unaccessible info are for importers to decide if the
dma-buf is good to use. KVM only allows host unaccessible MMIO regions
for private MMIO slot. But it is expected other importers (e.g. RDMA
driver, IOMMUFD) may also use the dma-buf machanism for P2P in native
or non-CoCo VM, in which cases host unaccessible is not required.

Also export struct kvm * handler attached to the vfio device. This
allows KVM to do another sanity check. MMIO should only be assigned to
a CoCo VM if its owner device is already assigned to the same VM.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 drivers/vfio/pci/dma_buf.c | 24 ++++++++++++++++++++++++
 include/linux/vfio.h       | 19 +++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/vfio/pci/dma_buf.c b/drivers/vfio/pci/dma_buf.c
index ad12cfb85099..ad984f2c22fc 100644
--- a/drivers/vfio/pci/dma_buf.c
+++ b/drivers/vfio/pci/dma_buf.c
@@ -9,6 +9,8 @@
 MODULE_IMPORT_NS("DMA_BUF");
 
 struct vfio_pci_dma_buf {
+	struct vfio_dma_buf_data export_data;
+
 	struct dma_buf *dmabuf;
 	struct vfio_pci_core_device *vdev;
 	struct list_head dmabufs_elm;
@@ -156,6 +158,14 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 	priv->vdev = vdev;
 	priv->nr_ranges = get_dma_buf.nr_ranges;
 	priv->dma_ranges = dma_ranges;
+	/*
+	 * KVM expects private dma_buf. An private dma_buf must not
+	 * support dma_buf_ops.map_dma_buf/mmap/vmap(). The exporter must also
+	 * ensure no side channel access for the backend resource, e.g.
+	 * vfio_device_ops.mmap() should not be supported.
+	 */
+	priv->export_data.is_private = vdev->vdev.is_private;
+	priv->export_data.kvm = vdev->vdev.kvm;
 
 	ret = check_dma_ranges(priv, &dmabuf_size);
 	if (ret)
@@ -247,3 +257,17 @@ void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
 	}
 	up_write(&vdev->memory_lock);
 }
+
+/*
+ * Only vfio/pci implements this, so put the helper here for now.
+ */
+struct vfio_dma_buf_data *vfio_dma_buf_get_data(struct dma_buf *dmabuf)
+{
+	struct vfio_pci_dma_buf *priv = dmabuf->priv;
+
+	if (dmabuf->ops != &vfio_pci_dmabuf_ops)
+		return ERR_PTR(-EINVAL);
+
+	return &priv->export_data;
+}
+EXPORT_SYMBOL_GPL(vfio_dma_buf_get_data);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e99d856c6cd8..fd7669e5b276 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -9,6 +9,7 @@
 #define VFIO_H
 
 
+#include <linux/dma-buf.h>
 #include <linux/iommu.h>
 #include <linux/mm.h>
 #include <linux/workqueue.h>
@@ -370,4 +371,22 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
 void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
+/*
+ * DMA-buf - generic
+ */
+struct vfio_dma_buf_data {
+	bool is_private;
+	struct kvm *kvm;
+};
+
+#if IS_ENABLED(CONFIG_DMA_SHARED_BUFFER) && IS_ENABLED(CONFIG_VFIO_PCI_CORE)
+struct vfio_dma_buf_data *vfio_dma_buf_get_data(struct dma_buf *dmabuf);
+#else
+static inline
+struct vfio_dma_buf_data *vfio_dma_buf_get_data(struct dma_buf *dmabuf)
+{
+	return NULL;
+}
+#endif
+
 #endif /* VFIO_H */
-- 
2.25.1


