Return-Path: <kvm+bounces-7801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 16FDE84673B
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:59:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73171B216D2
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C85F179AE;
	Fri,  2 Feb 2024 04:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b17HEZKp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E901643E;
	Fri,  2 Feb 2024 04:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849853; cv=none; b=JcsLsY10AahD2sPIsHteSytZfREDzEd1N9doEPr6tpFcmzLFpNXa69Y3/3lwGbRiDGUHm+wn1RkZKGVcVP/T8CcBdfQtFEuiEEbkKEnXYFZ4XM0weUCriVAdzXaYY8bn+PHjWFk0iOEHiVXdU/sdGbk2cOjCIJZCiQcXZ5f5cpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849853; c=relaxed/simple;
	bh=Kxk7o9A62R7KtL/giSvWj2QXePnCiz/Qp5YtBYfbf9E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J5A/dqRO35Hgkqoa0RvraIpJg8r0xSSrD+iwpf71kqexISTVR60Zcid1U+kq30OP4D244YC8WzOLUeKSZNFk7rRWVVvusqi8P6ddBVLpaQUPnDNFaNrBt0BNiN5coYrSCEK4AR6jIoNF8VXc4snhAZ1y+a8tyE4ks2U+83BmP/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b17HEZKp; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849852; x=1738385852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kxk7o9A62R7KtL/giSvWj2QXePnCiz/Qp5YtBYfbf9E=;
  b=b17HEZKprk1chPeVsxf0dJpuHjnLK5y8AEqpnQcTfM6r/o2gqE8NAUB8
   mEOUR5C0xShwXwqYFveMUtajxdj5N6+JA2+n9kgi2+SWQ4BDmv0fn6o0S
   YFmR+B2Y9UtkP5rZxtZIBCFNbTihiJu0Zk+VFEDOIX0hicWrxMigDx829
   L9s5BtVq537tJ1U9wlGpSaeQ0LFsPW8l5ch3zN7d1gLet6RWbTDRp8L8m
   SqEICcPwLZc9AUQRBbXth6UdjNUiQs/rfw2gmQbFwd1QJI9kC3gHxWZJb
   0zpHdwZCniiWYgJZLwmP6PDJKiLwkhZIJOowyPO2Qx31ZKlbLLWVgt+YN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615818"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615818"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339774"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339774"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:24 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: jgg@nvidia.com,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	dave.jiang@intel.com,
	ashok.raj@intel.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 06/17] vfio/pci: Remove interrupt index interpretation from wrappers
Date: Thu,  1 Feb 2024 20:57:00 -0800
Message-Id: <ca249ad459c07a36cd64137ee1cc107dcd8b6f4c.1706849424.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1706849424.git.reinette.chatre@intel.com>
References: <cover.1706849424.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vfio_pci_set_intx_trigger() and vfio_pci_set_msi_trigger() have similar
enough flows that can be converged into one shared flow instead of
duplicated.

To share code between management of interrupt types it is necessary that
the type of the interrupt is only interpreted by the code specific to
the interrupt type being managed.

Remove interrupt type interpretation from what will eventually be
shared code (vfio_pci_set_msi_trigger(), vfio_msi_set_block()) by
pushing this interpretation to be within the interrupt
type specific code (vfio_msi_enable(),
(temporary) vfio_msi_set_vector_signal()).

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note to maintainers:
Originally formed part of the IMS submission below, but is not
specific to IMS.
https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com

 drivers/vfio/pci/vfio_pci_intrs.c | 38 +++++++++++++++++--------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 97a3bb22b186..31f73c70fcd2 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -346,16 +346,19 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msix)
+static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec,
+			   unsigned int index)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	unsigned int flag = msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
+	unsigned int flag;
 	int ret;
 	u16 cmd;
 
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
+	flag = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
+
 	/* return the number of supported vectors if we can't get all: */
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	ret = pci_alloc_irq_vectors(pdev, 1, nvec, flag);
@@ -367,10 +370,9 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 	}
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
 
-	vdev->irq_type = msix ? VFIO_PCI_MSIX_IRQ_INDEX :
-				VFIO_PCI_MSI_IRQ_INDEX;
+	vdev->irq_type = index;
 
-	if (!msix) {
+	if (index == VFIO_PCI_MSI_IRQ_INDEX) {
 		/*
 		 * Compute the virtual hardware field for max msi vectors -
 		 * it is the log base 2 of the number of vectors.
@@ -413,8 +415,10 @@ static int vfio_msi_alloc_irq(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
-				      unsigned int vector, int fd, bool msix)
+				      unsigned int vector, int fd,
+				      unsigned int index)
 {
+	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
 	struct eventfd_ctx *trigger;
@@ -505,25 +509,26 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
 			      unsigned int start, unsigned int count,
-			      int32_t *fds, bool msix)
+			      int32_t *fds, unsigned int index)
 {
 	unsigned int i, j;
 	int ret = 0;
 
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
 		int fd = fds ? fds[i] : -1;
-		ret = vfio_msi_set_vector_signal(vdev, j, fd, msix);
+		ret = vfio_msi_set_vector_signal(vdev, j, fd, index);
 	}
 
 	if (ret) {
 		for (i = start; i < j; i++)
-			vfio_msi_set_vector_signal(vdev, i, -1, msix);
+			vfio_msi_set_vector_signal(vdev, i, -1, index);
 	}
 
 	return ret;
 }
 
-static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
+static void vfio_msi_disable(struct vfio_pci_core_device *vdev,
+			     unsigned int index)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
@@ -533,7 +538,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	xa_for_each(&vdev->ctx, i, ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
-		vfio_msi_set_vector_signal(vdev, i, -1, msix);
+		vfio_msi_set_vector_signal(vdev, i, -1, index);
 	}
 
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -656,10 +661,9 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 {
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
-	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
 
 	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_msi_disable(vdev, msix);
+		vfio_msi_disable(vdev, index);
 		return 0;
 	}
 
@@ -672,15 +676,15 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 
 		if (vdev->irq_type == index)
 			return vfio_msi_set_block(vdev, start, count,
-						  fds, msix);
+						  fds, index);
 
-		ret = vfio_msi_enable(vdev, start + count, msix);
+		ret = vfio_msi_enable(vdev, start + count, index);
 		if (ret)
 			return ret;
 
-		ret = vfio_msi_set_block(vdev, start, count, fds, msix);
+		ret = vfio_msi_set_block(vdev, start, count, fds, index);
 		if (ret)
-			vfio_msi_disable(vdev, msix);
+			vfio_msi_disable(vdev, index);
 
 		return ret;
 	}
-- 
2.34.1


