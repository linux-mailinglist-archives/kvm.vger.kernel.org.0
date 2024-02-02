Return-Path: <kvm+bounces-7800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24203846738
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:58:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90E70B21E9B
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A0717561;
	Fri,  2 Feb 2024 04:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G33JQGfS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFD5F9D3;
	Fri,  2 Feb 2024 04:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849852; cv=none; b=JxwZGNAoVRJhItTuBv7cDAsS79WbwDA4t5oHg/cOwTId0q7KuY4XEOwgy3nDmDuKBoF+8BramyhicS2YQL0cLmWpZ8vW9NeeFGy17tT7c+G4j41iOz/FN4Fr6pDNzeAHektWgK9EbuoO/ha1/sq0Dy8JwkNv4beIWN5HzVcbZu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849852; c=relaxed/simple;
	bh=JWucdCztDGT+G4ZMaH9FIiM5mhLJXuyhplUEEPj9ZAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XwWFMUW6MUCTqWsUJQJXSgEW+NdtNWlvuOCvci3ZpHJoPaLrcZtIQDdBAmpgRK7AoijATCSkfuwhY1vLtgye44OlcEJ3JkOwuWgsldLpL/tYbjGT2u4smd0wAZeTtYou8hWBrZypuTsh85EKcDd4mofXdXDrqrjX5nb/yI0IMgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G33JQGfS; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849849; x=1738385849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JWucdCztDGT+G4ZMaH9FIiM5mhLJXuyhplUEEPj9ZAU=;
  b=G33JQGfSAFNAwEemVxQvWRWYBcXBnJJLkOwEseI2KZD9lBjS16Z/+AGe
   BWRleeN8X7Q8juOMluJBTzAHRtioGCVfMT3HSO+C+PfiWZNvkOXqJddHB
   fHG2dyMZDmThLfSjhAe9oQwkNr2jUfo3LxCi4au5AQYxva1qEL1ye8NrI
   dXPfduk/fKDFEs1zVEiI1ZvIbhQGH6+v+Yb5khw71jX4vGKvrRU/mjHM+
   cjVaHA8aLuY9QP9AHin2HkLvxgrZIFNsSnjA5pWs9ACLahZHy9ejak/ii
   eBXmdiF3pOSgygadSLVNm2pU4ZvBiYmcMNDP+U5VQyZlpw91t22hj1PSo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615802"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615802"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339765"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339765"
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
Subject: [PATCH 03/17] vfio/pci: Consistently acquire mutex for interrupt management
Date: Thu,  1 Feb 2024 20:56:57 -0800
Message-Id: <e7d35d7730f3f83417e757bc264a470f8c2671ed.1706849424.git.reinette.chatre@intel.com>
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

vfio_pci_set_irqs_ioctl() is the entrypoint for interrupt management
via the VFIO_DEVICE_SET_IRQS ioctl(). The igate mutex is obtained
before calling vfio_pci_set_irqs_ioctl() for management of all interrupt
types to protect against concurrent changes to the eventfds associated
with device request notification and error interrupts.

The igate mutex is not acquired consistently. The mutex is always
(for all interrupt types) acquired from within vfio_pci_ioctl_set_irqs()
before calling vfio_pci_set_irqs_ioctl(), but vfio_pci_set_irqs_ioctl() is
called via vfio_pci_core_disable() without the mutex held. The latter
is expected to be correct if the code flow can be guaranteed that
the provided interrupt type is not a device request notification or error
interrupt.

Move igate mutex acquire and release into vfio_pci_set_irqs_ioctl()
to make the locking consistent irrespective of interrupt type.
This is one step closer to contain the interrupt management locking
internals within the interrupt management code so that the VFIO PCI
core can trigger management of the eventfds associated with device
request notification and error interrupts without needing to access
and manipulate VFIO interrupt management locks and data.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note to maintainers:
Originally formed part of the IMS submission below, but is not
specific to IMS.
https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com

 drivers/vfio/pci/vfio_pci_core.c  |  3 ---
 drivers/vfio/pci/vfio_pci_intrs.c | 10 ++++++++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 1cbc990d42e0..d2847ca2f0cb 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1214,12 +1214,9 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 			return PTR_ERR(data);
 	}
 
-	mutex_lock(&vdev->igate);
-
 	ret = vfio_pci_set_irqs_ioctl(vdev, hdr.flags, hdr.index, hdr.start,
 				      hdr.count, data);
 
-	mutex_unlock(&vdev->igate);
 	kfree(data);
 
 	return ret;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 69ab11863282..97a3bb22b186 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -793,7 +793,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 	int (*func)(struct vfio_pci_core_device *vdev, unsigned int index,
 		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
+	int ret = -ENOTTY;
 
+	mutex_lock(&vdev->igate);
 	switch (index) {
 	case VFIO_PCI_INTX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
@@ -838,7 +840,11 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 	}
 
 	if (!func)
-		return -ENOTTY;
+		goto out_unlock;
+
+	ret = func(vdev, index, start, count, flags, data);
+out_unlock:
+	mutex_unlock(&vdev->igate);
+	return ret;
 
-	return func(vdev, index, start, count, flags, data);
 }
-- 
2.34.1


