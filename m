Return-Path: <kvm+bounces-7810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 67AFE84674E
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 06:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3B9E1F2276A
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2473FE44;
	Fri,  2 Feb 2024 04:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T0w3GHBm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1081199C7;
	Fri,  2 Feb 2024 04:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849859; cv=none; b=Txy4UqsYPqzjUiTTEoNnm+YFJy2tvB+YdUOEcvg0UUDZnhEDHDQfnQOjoUeqereswXbqA6MYzZK7CwiUJ5qMw7wfOvRZlbLITI4IZqrHrIzoVrMA3XKGKMrtq+l3CgVYAEK+NpoAI9grxkWzT9D+wPySujsU6xapQPYM9D44xvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849859; c=relaxed/simple;
	bh=UPkU4CgiMaVZ/F/r+r3Za8ed6ay66IJYSHKlYHufPks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j2iomrYfDzplSmc79ibCkHiw1dfjY9QyEp1YpIJG6Jjuyiu6FqYzKUWqwYxEyPYpo/r7F7dGrpWhQ41inZB4owRF2ODBwHUMFg3u4NxjBTSsLcs2MxNVYsqHPg7imCMgs26GK6yMvTP/4umfZAOnjY7e7hDHWjJ2Ov8MkukaOl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T0w3GHBm; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849858; x=1738385858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UPkU4CgiMaVZ/F/r+r3Za8ed6ay66IJYSHKlYHufPks=;
  b=T0w3GHBm46+6MvQbdSXdnZ7OTOnlxg64zn0FSGiOt7m67z5m4fO3tKGI
   E2xD9Os5j2oFs7n6yCQmqyqdtUETeIg3gySlphB8eN5PW8u7bK9rMqFvt
   NSeUKzcd8Nk+kDVjFUYEJ/f1I13tkMECHftAcII/6kVwa08dR4t0A7T9/
   BovkDpAW3t4yyHLEnthfAmhj2GDSWgsWo6NWq/xFaXv7nOIxzSgoENc8v
   OyZErmmUuux8BSqbgxvaqlDAEFFTD4LXvNf3hMjDShpAbOWytnIlSDEPN
   9qINJYIK+PZi0H63NNZF7igfNkMZ6Lu7SIkWjTk1xRqgXEm0bTZrvm22a
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615868"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615868"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339801"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339801"
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
Subject: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt types use same signature
Date: Thu,  1 Feb 2024 20:57:09 -0800
Message-Id: <bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
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

vfio_pci_set_intx_trigger() and vfio_pci_set_msi_trigger() have
flows that can be shared.

For INTx, MSI, and MSI-X interrupt management to share the
same enable/disable flow the interrupt specific enable and
disable functions should have the same signatures.

Let vfio_intx_enable() and vfio_msi_enable() use the same
parameters by passing "start" and "count" to these functions
instead of letting the (what will eventually be) common code
interpret these values.

Providing "start" and "count" to vfio_intx_enable()
enables the INTx specific check of these parameters to move into
the INTx specific vfio_intx_enable(). Similarly, providing "start"
and "count" to vfio_msi_enable() enables the MSI/MSI-X specific
code to initialize number of vectors needed.

The shared MSI/MSI-X code needs the interrupt index. Provide
the interrupt index (clearly marked as unused) to the INTx code
to use the same signatures.

With interrupt type specific code using the same parameters it
is possible to have common code that calls the enable/disable
code for different interrupt types.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 37065623d286..9217fea3f636 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -257,13 +257,18 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 	return ret;
 }
 
-static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
+static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
+			    unsigned int start, unsigned int count,
+			    unsigned int __always_unused index)
 {
 	struct vfio_pci_irq_ctx *ctx;
 
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
+	if (start != 0 || count != 1)
+		return -EINVAL;
+
 	if (!vdev->pdev->irq)
 		return -ENODEV;
 
@@ -332,7 +337,8 @@ static char *vfio_intx_device_name(struct vfio_pci_core_device *vdev,
 	return kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
 }
 
-static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
+static void vfio_intx_disable(struct vfio_pci_core_device *vdev,
+			      unsigned int __always_unused index)
 {
 	struct vfio_pci_irq_ctx *ctx;
 
@@ -358,17 +364,20 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec,
+static int vfio_msi_enable(struct vfio_pci_core_device *vdev,
+			   unsigned int start, unsigned int count,
 			   unsigned int index)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int flag;
-	int ret;
+	int ret, nvec;
 	u16 cmd;
 
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
+	nvec = start + count;
+
 	flag = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
 
 	/* return the number of supported vectors if we can't get all: */
@@ -701,11 +710,11 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 	unsigned int i;
 
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_intx_disable(vdev);
+		vfio_intx_disable(vdev, index);
 		return 0;
 	}
 
-	if (!(is_intx(vdev) || is_irq_none(vdev)) || start != 0 || count != 1)
+	if (!(is_intx(vdev) || is_irq_none(vdev)))
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
@@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 		if (is_intx(vdev))
 			return vfio_irq_set_block(vdev, start, count, fds, index);
 
-		ret = vfio_intx_enable(vdev);
+		ret = vfio_intx_enable(vdev, start, count, index);
 		if (ret)
 			return ret;
 
 		ret = vfio_irq_set_block(vdev, start, count, fds, index);
 		if (ret)
-			vfio_intx_disable(vdev);
+			vfio_intx_disable(vdev, index);
 
 		return ret;
 	}
@@ -771,7 +780,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 			return vfio_irq_set_block(vdev, start, count,
 						  fds, index);
 
-		ret = vfio_msi_enable(vdev, start + count, index);
+		ret = vfio_msi_enable(vdev, start, count, index);
 		if (ret)
 			return ret;
 
-- 
2.34.1


