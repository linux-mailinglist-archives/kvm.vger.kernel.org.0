Return-Path: <kvm+bounces-7803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6812F84673E
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:59:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99F121C25353
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E70617C72;
	Fri,  2 Feb 2024 04:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jFZ7ofY3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8B1171BB;
	Fri,  2 Feb 2024 04:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849854; cv=none; b=syFgmW23vMRWb1xYVVdBC0PFnyHSjNHhqRBDaQTck0Rb0IAIVubMND1Wahu32ZMmrg5QovuU3tpa0BlTZEhkMFZUNhAzY4aw1FPx1eybKnt4g1If611f3v8Y92pLts6A6VrW65jisri0umEoIvw98lAyRMe/jL4MWUew39e6DT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849854; c=relaxed/simple;
	bh=JgRfCrK7Y34Oc8Goi+1GvDvltDbKKC8kZ84KFNDHKXM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eOo035wwKnfEXt2FlpExUTYgkn9HrzRdgwGTX8Jaxt972JML7411UuZ5XjY82PA1voDYUO1BfRXBSPP2pIUhf36jQDdo/Ytp0UJk4O59JSUtbqqS3N0ACOwYkqv92p4dnniWvxIF37VrTGlpS95TOI7zIsaUCBRty5JJXYGO9LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jFZ7ofY3; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849852; x=1738385852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JgRfCrK7Y34Oc8Goi+1GvDvltDbKKC8kZ84KFNDHKXM=;
  b=jFZ7ofY3rBygnljUqyFOkJzq526CJJ/nxKV/1nxuu5nohx55IcTAe08K
   sWuSQKPeS0fanu3/a0HwdFMGCoec66NQbOlmoAimFjFCo3Vp7VIMZ7dBL
   fCwCS+iuT5OwD8HJ4k5P1cla+1FYfYr+9ZWm01/+bubXtrsmeZvNduptx
   terVCoMDWfhOIwyw08dF00WK/rjxJ2zMLxKiqEfqjmwJudswOANaPsyh2
   8ujoXArVthdljtki8DxiNztTpXMN93kWUlF8pDQ7kDLl22+6OHahTtDYr
   FaPTg9rue0cLz9tcJsmXo8I+oiygsfi8QGU0udKYGRCVNGeSXbjQUHprL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615828"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615828"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339783"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339783"
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
Subject: [PATCH 09/17] vfio/pci: Converge similar code flows
Date: Thu,  1 Feb 2024 20:57:03 -0800
Message-Id: <250808eb11a206075c0b92f2dae23a924f73c390.1706849424.git.reinette.chatre@intel.com>
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

vfio_intx_set_signal() and vfio_msi_set_vector_signal() have similar
code flows that can be shared.

Modify vfio_intx_set_signal()'s signature to resemble that of
vfio_msi_set_vector_signal() by also providing the vector and interrupt
type as parameters. For vfio_intx_set_signal() these two additional
parameters are redundant and unused since the vector is always 0 and
the interrupt type is always INTx. Adding these parameters make it
possible to refactor vfio_intx_set_signal() to call INTx specific
functions with the same signature as the MSI/MSI-X specific functions
in preparation for these interrupt type specific functions to be called
by shared code.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 70f2382c9c0c..98b099f58b2b 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -260,7 +260,9 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 	return 0;
 }
 
-static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
+static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev,
+				unsigned int vector, int fd,
+				unsigned int index)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long irqflags = IRQF_SHARED;
@@ -330,7 +332,7 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 	}
-	vfio_intx_set_signal(vdev, -1);
+	vfio_intx_set_signal(vdev, 0, -1, VFIO_PCI_INTX_IRQ_INDEX);
 	vdev->irq_type = VFIO_PCI_NUM_IRQS;
 	vfio_irq_ctx_free(vdev, ctx, 0);
 }
@@ -674,13 +676,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 		int ret;
 
 		if (is_intx(vdev))
-			return vfio_intx_set_signal(vdev, fd);
+			return vfio_intx_set_signal(vdev, start, fd, index);
 
 		ret = vfio_intx_enable(vdev);
 		if (ret)
 			return ret;
 
-		ret = vfio_intx_set_signal(vdev, fd);
+		ret = vfio_intx_set_signal(vdev, start, fd, index);
 		if (ret)
 			vfio_intx_disable(vdev);
 
-- 
2.34.1


