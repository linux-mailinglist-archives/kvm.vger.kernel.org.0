Return-Path: <kvm+bounces-7807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EC0C846747
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 06:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 800841C211F7
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3B501A28C;
	Fri,  2 Feb 2024 04:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RCFKid6y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9195418041;
	Fri,  2 Feb 2024 04:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849857; cv=none; b=rcz6hQj7h8OM7DbcHTx+sjC5XFGN3nwCYeOgBLiL99b/1pEbB2pdnYOE1nYQirfYGcFZSAFRdaqvwtRX5yH7IOM5pvAeH2ljhWK+ZR5LDv8OZkvUJrDJQruYN8CcGcACoUyEtqADoONbSxTPtQhkUZyCIVlObwjnw+w7bssfmp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849857; c=relaxed/simple;
	bh=BJ/iiqpnrpLGQqepNldAyRvzSYt7cnd2BvmP/2lcET0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fixUsKsK5oQV6mr5/DwOUb1ynkkz9TGw6b95j2wpFzGigIVq8xpPQ5gRvYS+fEF/Zp2ORnuArN5lgiN+2okn8MXY5V7rBrgyGMd00ECApnNPwkEeka9OQllcjCK/uZtjmA7d1uTILYghM8J8aj+vzGl9c6nYND/KtGgF9AdJKkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RCFKid6y; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849856; x=1738385856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BJ/iiqpnrpLGQqepNldAyRvzSYt7cnd2BvmP/2lcET0=;
  b=RCFKid6yYwTVoGcBw1kh22Wld3UKLnA7bJB62o1/ztSGHhf9W9Pxe3f1
   kuVQhL+OSwKOO4JDCo1R6VhD+zwu1fQWhSd9nxveurjDcaE4VEl5KVuKT
   CLP9W3nK4R83+v713bkXtvJVG5Tg0MrAw/ZvJCvxulzoufLclloSetw19
   f9HgWT+7VAa8YknDDaxMXY6dRR0l5W6HTuAjNEDAHJCAuW2C9M7/vD388
   m5xUnfSogPI/QRDKGtG9LZgUD9eeMqAxyjWdF+g4r8KyriY+f8zsuqaH2
   bSVKfNR1ljh6T6YuMz7dk09vFsEbEiLwAFwXBIrN5rm40vJmCNSnDg//u
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615850"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615850"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339792"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339792"
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
Subject: [PATCH 12/17] vfio/pci: Remove msi term from generic code
Date: Thu,  1 Feb 2024 20:57:06 -0800
Message-Id: <0550572e64505df6ecff0b08f1eca869a79f6acf.1706849424.git.reinette.chatre@intel.com>
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

vfio_msi_set_vector_signal() and by extension vfio_msi_set_block()
are no longer specific to MSI and MSI-X interrupts.

Change the name of these functions in preparation for them
to be used for management of INTx interrupts.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 07dc388c4513..7f9dc81cb97f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -557,7 +557,7 @@ static struct vfio_pci_intr_ops intr_ops[] = {
 	},
 };
 
-static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
+static int vfio_irq_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      unsigned int vector, int fd,
 				      unsigned int index)
 {
@@ -617,7 +617,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
+static int vfio_irq_set_block(struct vfio_pci_core_device *vdev,
 			      unsigned int start, unsigned int count,
 			      int32_t *fds, unsigned int index)
 {
@@ -626,12 +626,12 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
 
 	for (i = 0, j = start; i < count && !ret; i++, j++) {
 		int fd = fds ? fds[i] : -1;
-		ret = vfio_msi_set_vector_signal(vdev, j, fd, index);
+		ret = vfio_irq_set_vector_signal(vdev, j, fd, index);
 	}
 
 	if (ret) {
 		for (i = start; i < j; i++)
-			vfio_msi_set_vector_signal(vdev, i, -1, index);
+			vfio_irq_set_vector_signal(vdev, i, -1, index);
 	}
 
 	return ret;
@@ -648,7 +648,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev,
 	xa_for_each(&vdev->ctx, i, ctx) {
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
-		vfio_msi_set_vector_signal(vdev, i, -1, index);
+		vfio_irq_set_vector_signal(vdev, i, -1, index);
 		vfio_irq_ctx_free(vdev, ctx, i);
 	}
 
@@ -786,14 +786,14 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 		int ret;
 
 		if (vdev->irq_type == index)
-			return vfio_msi_set_block(vdev, start, count,
+			return vfio_irq_set_block(vdev, start, count,
 						  fds, index);
 
 		ret = vfio_msi_enable(vdev, start + count, index);
 		if (ret)
 			return ret;
 
-		ret = vfio_msi_set_block(vdev, start, count, fds, index);
+		ret = vfio_irq_set_block(vdev, start, count, fds, index);
 		if (ret)
 			vfio_msi_disable(vdev, index);
 
-- 
2.34.1


