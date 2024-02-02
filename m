Return-Path: <kvm+bounces-7799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04AE0846737
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:58:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A539428E923
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA641754D;
	Fri,  2 Feb 2024 04:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hWDHKiky"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC91101EC;
	Fri,  2 Feb 2024 04:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849851; cv=none; b=frFarHnJmAT9RLRerrCWX/GYRDf611wcwST3EnGFPZjUJrIqc33/100eXSks3mof5qX56M1cYpjZxKSMlSP+JVWovtADfyasKmb9no5YX9LmJT6Uj6actaOGngsAUm3qP7M5Fy4eVNET3XnMnuMWH+z5gogeVsNPrXMz21TVN9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849851; c=relaxed/simple;
	bh=wjShxdkTqGwADOgBt3EJHJs5FYJXIg/tseoEaV8uAgM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h+LiooV3yfqwWDWfXPczHc26MoycSQt5xqEigxgDQQZE/fdWD0WPa7xWrDOwfCgEzplFDh1vnC0svFqHLAM/DkElpeJV1j0hFg8mduk0CICx46MyhU/2/Liwp7eCUaOQCqQtD89uZmHTzIft/fB+L9P0GT/B1i17nbPe41NzHBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hWDHKiky; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849850; x=1738385850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wjShxdkTqGwADOgBt3EJHJs5FYJXIg/tseoEaV8uAgM=;
  b=hWDHKikybu6AUycg4O0oPYwBVNvSHN0JWa0LTlEpkXFJFC2UwlIWk7B4
   4CJYR0u7q4+d4dN8UITwRaahaSVNtbEDldb9m44QCv/9miCWlwiAtlI6Y
   lPPaqACjaFOGPavV4f4X3XU0DjGY8W0KxwJFm70kWiE5a5vcAnZM3vRDh
   I0rLwf/Qf6DpPUJ/Lbb8NocBUS3DvgCUhDg2OJeoZm+3l0YyY5033mZbR
   4/6izxhOJGiJ4JR+V7znizMzu/+y5K11OuJMufKsJuZ2tlnyaGsiwyZZi
   5YIDviDDO0EOTgwlFTaUf3o5kDBkc+Pc3qiQyglmNeztWiF4qG4jpivTs
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615813"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615813"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339771"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339771"
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
Subject: [PATCH 05/17] vfio/pci: Limit eventfd signaling to interrupt management code
Date: Thu,  1 Feb 2024 20:56:59 -0800
Message-Id: <54ba34d884de30f479bbe3844c4a342980760d79.1706849424.git.reinette.chatre@intel.com>
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

VFIO PCI interrupt management has full support for configuring,
signaling, and clearing the eventfds associated with device request
notification and error interrupts.

Core VFIO PCI duplicates eventfd signaling while also accessing
data that should be contained within the interrupt management code.

Remove the duplicate eventfd signaling from core VFIO PCI
and rely on VFIO PCI interrupt management for eventfd signaling.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index de097174e455..a8235b9c1a81 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1868,21 +1868,20 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
+	int ret;
 
-	mutex_lock(&vdev->igate);
+	ret = vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
+				      VFIO_IRQ_SET_ACTION_TRIGGER,
+				      VFIO_PCI_REQ_IRQ_INDEX, 0, 1, NULL);
 
-	if (vdev->req_trigger) {
-		if (!(count % 10))
-			pci_notice_ratelimited(pdev,
-				"Relaying device request to user (#%u)\n",
-				count);
-		eventfd_signal(vdev->req_trigger);
-	} else if (count == 0) {
+	if (!ret && !(count % 10)) {
+		pci_notice_ratelimited(pdev,
+				       "Relaying device request to user (#%u)\n",
+				       count);
+	} else if (ret && count == 0) {
 		pci_warn(pdev,
-			"No device request channel registered, blocked until released by user\n");
+			 "No device request channel registered, blocked until released by user\n");
 	}
-
-	mutex_unlock(&vdev->igate);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_request);
 
@@ -2292,12 +2291,9 @@ pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 {
 	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
 
-	mutex_lock(&vdev->igate);
-
-	if (vdev->err_trigger)
-		eventfd_signal(vdev->err_trigger);
-
-	mutex_unlock(&vdev->igate);
+	vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
+				VFIO_IRQ_SET_ACTION_TRIGGER,
+				VFIO_PCI_ERR_IRQ_INDEX, 0, 1, NULL);
 
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
-- 
2.34.1


