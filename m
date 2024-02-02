Return-Path: <kvm+bounces-7811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ECF1846750
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 06:02:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91D861C20FF0
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1790640C1B;
	Fri,  2 Feb 2024 04:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HnSP4nyM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5955B1758D;
	Fri,  2 Feb 2024 04:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849860; cv=none; b=A+B8Vf44CAXbSdUt3VBr39Z09IUQc2BdaHpfU7ub+C/b6phDdUKvyXLCu2c2vK5L1aRJjOJuIuRZny5bJ2MFX7kB8CuhhrfgRcT5zuy1DBQGGU7FZPlBKaJ3GSGU0XHqVzsXfoixs/k1A6+Jl4pWhsnQYRyNsTCQzAyR99FdWpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849860; c=relaxed/simple;
	bh=hJ099FlQtbdXqo2+oz8/ORBdCodnOxTdeN2C2GWn1FE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iKHYw9W3VxZuTzp4A1xbwL5aHx7rahnUgsgx+RzVtZhdKmv45EWMRm1sRB3few4mi+HElVv5iBoL6OOkkK8AFVp+tpHnU2k0NH1C1mFfMFdJs3m9OFBkIDP3qS7X0zlCS6YR3GgGIOM1KYnVy6o+oRqcXOhmC/DvlMA/0Lfed8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HnSP4nyM; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849858; x=1738385858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hJ099FlQtbdXqo2+oz8/ORBdCodnOxTdeN2C2GWn1FE=;
  b=HnSP4nyMS6sVrE6l4bOm1KcNKXsfD73JTXxRMl8U7y2wtC7H2mSCFekR
   ecLLfq3bIGDMzVI19nt8Xm/AlA9lOgpRICNLEupxfKhxb1TUBxGXg+UA7
   E6XZTpd3AdF01CW8yp+Q56k6PnyA5jkyUjjvOH2Wv2qU6eHMJ3lb7HO+z
   N/P7YXQ5Hb1Iuornjr2w/sYS3uZ5ECblSnZpo0tPnXune1EYPs75HOfXv
   UgL+2zG31Wt+cDyxWt9RVKaJ7ujZB5A0XXvY5UXheoO+wxRrA6MLc+EHN
   SLe1f58gkA5PdF6YNjHM1Dzv6YDiciwbQSp1P/hETtcFRhqLYENp7NnLI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615870"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615870"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339803"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339803"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:25 -0800
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
Subject: [PATCH 16/17] vfio/pci: Move vfio_msi_disable() to be with other MSI/MSI-X management code
Date: Thu,  1 Feb 2024 20:57:10 -0800
Message-Id: <e533f5767ac4caeef5ccef9fff0aa2428654f22e.1706849424.git.reinette.chatre@intel.com>
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

The interrupt management code is mostly organized in four sections:
shared code (interrupt type checking and interrupt context management),
INTx management code, MSI/MSI-X management code, and IOCTL support.

vfio_msi_disable() is separate from the other MSI/MSI-X code. This may
have been required because vfio_msi_disable() relies on
vfio_irq_set_vector_signal() within the IOCTL support.

Since vfio_irq_set_vector_signal() is declared earlier it is not
required for MSI/MSI-X management code to be mixed with the IOCTL
support.

Move vfio_msi_disable() to be located with all the other MSI/MSI-X
management code.

This move makes it simpler to initialize the interrupt management
callbacks with vfio_msi_disable() so that it can be provided to the
IOCTL support code.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 58 +++++++++++++++----------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 9217fea3f636..daa84a317f40 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -404,6 +404,35 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
+static void vfio_msi_disable(struct vfio_pci_core_device *vdev,
+			     unsigned int index)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_irq_ctx *ctx;
+	unsigned long i;
+	u16 cmd;
+
+	xa_for_each(&vdev->ctx, i, ctx) {
+		vfio_virqfd_disable(&ctx->unmask);
+		vfio_virqfd_disable(&ctx->mask);
+		vfio_irq_set_vector_signal(vdev, i, -1, index);
+		vfio_irq_ctx_free(vdev, ctx, i);
+	}
+
+	cmd = vfio_pci_memory_lock_and_enable(vdev);
+	pci_free_irq_vectors(pdev);
+	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+
+	/*
+	 * Both disable paths above use pci_intx_for_msi() to clear DisINTx
+	 * via their shutdown paths.  Restore for NoINTx devices.
+	 */
+	if (vdev->nointx)
+		pci_intx(pdev, 0);
+
+	vdev->irq_type = VFIO_PCI_NUM_IRQS;
+}
+
 /*
  * vfio_msi_alloc_irq() returns the Linux IRQ number of an MSI or MSI-X device
  * interrupt vector. If a Linux IRQ number is not available then a new
@@ -617,35 +646,6 @@ static int vfio_irq_set_block(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-static void vfio_msi_disable(struct vfio_pci_core_device *vdev,
-			     unsigned int index)
-{
-	struct pci_dev *pdev = vdev->pdev;
-	struct vfio_pci_irq_ctx *ctx;
-	unsigned long i;
-	u16 cmd;
-
-	xa_for_each(&vdev->ctx, i, ctx) {
-		vfio_virqfd_disable(&ctx->unmask);
-		vfio_virqfd_disable(&ctx->mask);
-		vfio_irq_set_vector_signal(vdev, i, -1, index);
-		vfio_irq_ctx_free(vdev, ctx, i);
-	}
-
-	cmd = vfio_pci_memory_lock_and_enable(vdev);
-	pci_free_irq_vectors(pdev);
-	vfio_pci_memory_unlock_and_restore(vdev, cmd);
-
-	/*
-	 * Both disable paths above use pci_intx_for_msi() to clear DisINTx
-	 * via their shutdown paths.  Restore for NoINTx devices.
-	 */
-	if (vdev->nointx)
-		pci_intx(pdev, 0);
-
-	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-}
-
 /*
  * IOCTL support
  */
-- 
2.34.1


