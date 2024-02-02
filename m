Return-Path: <kvm+bounces-7812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43DD7846751
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 06:02:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 681801C22B63
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D090447F53;
	Fri,  2 Feb 2024 04:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iy8CILgn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F3A1B299;
	Fri,  2 Feb 2024 04:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849861; cv=none; b=cjYuL2NXN0qPIelN2C6Exxuk/ucP7aBFfjLnw608uYhCQTdWsz2ihTNQJi3y4CI7Un/6YndIW3ZtEBGsbdME+a8JziSIX9Xyd67Xs0v++a08/GWN2Zm3t9+fsgMji32F419Hn4w0V40+fTtwr9twngkt1q3gHpzoDYA86cnhqgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849861; c=relaxed/simple;
	bh=4QFGx+82iSOQD5Uy7w9iqIN8hz1HoOJM57vM7BEXPkc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oT/Ddg0Npb6DrhmZQqZVy/tuC3nvM9Sua9qjQxh9FiskNKVkhhf8vXqhcd7VjOVcXbnjwLThNmuklNM5s+3QdJBGE4+8wIvHmku/tlbJgo0KlJhPLjJFQoZMGdIfVXkPP8yze15lozziz1OIgFkKWKW2SpiH3XbHGXZmY2gaHG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iy8CILgn; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849859; x=1738385859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4QFGx+82iSOQD5Uy7w9iqIN8hz1HoOJM57vM7BEXPkc=;
  b=Iy8CILgnJZ1cQcQ52vjAEEuKGn3rwbhWJG2pc9idgTpLbkNBO9K29kZG
   4V89/Lf3zUJKw5XZMOLAdyWv1SsPOefjHKwt7Sz0RdatupE2N/eciA7Bz
   ktJqopQUd0HGNneZVM2fDOEhMCsIRlmnKoCRS74MA8VTfzwcgVPbCNnRu
   jYvZJZJSiYstvG0mkzrIr8k7WUXgmdUJTe0pl1qop3+P+rbnjJivsg+9E
   dWsZVne9+65x/PbTl/WZtIjt5u7yQog5Za4iwoIV4jNkb7aQ/7AVo+Chy
   KyZCDsa1+xx8T+elmMN0JOLxpnu/AZiMqAXNwzPbX1upNwaocDdSoCf7u
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615872"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615872"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339806"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339806"
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
Subject: [PATCH 17/17] vfio/pci: Remove duplicate interrupt management flow
Date: Thu,  1 Feb 2024 20:57:11 -0800
Message-Id: <6ec901daffab4170d9740c7d066becd079925d53.1706849424.git.reinette.chatre@intel.com>
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

vfio_pci_set_intx_trigger() and vfio_pci_set_trigger() have the
same flow that calls interrupt type (INTx, MSI, MSI-X) specific
functions.

Create callbacks for the interrupt type specific code that
can be called by the shared code so that only one of these functions
are needed. Rename the final generic function shared by all
interrupt types vfio_pci_set_trigger().

Relocate the "IOCTL support" marker to correctly mark the
now generic code.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 104 ++++++++++--------------------
 1 file changed, 35 insertions(+), 69 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index daa84a317f40..a5b337cfae60 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -32,6 +32,12 @@ struct vfio_pci_irq_ctx {
 };
 
 struct vfio_pci_intr_ops {
+	int (*enable)(struct vfio_pci_core_device *vdev, unsigned int start,
+		      unsigned int count, unsigned int index);
+	void (*disable)(struct vfio_pci_core_device *vdev,
+			unsigned int index);
+	void (*send_eventfd)(struct vfio_pci_core_device *vdev,
+			     struct vfio_pci_irq_ctx *ctx);
 	int (*request_interrupt)(struct vfio_pci_core_device *vdev,
 				 struct vfio_pci_irq_ctx *ctx,
 				 unsigned int vector, unsigned int index);
@@ -356,6 +362,12 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev,
 /*
  * MSI/MSI-X
  */
+static void vfio_send_msi_eventfd(struct vfio_pci_core_device *vdev,
+				  struct vfio_pci_irq_ctx *ctx)
+{
+	eventfd_signal(ctx->trigger);
+}
+
 static irqreturn_t vfio_msihandler(int irq, void *arg)
 {
 	struct eventfd_ctx *trigger = arg;
@@ -544,13 +556,22 @@ static void vfio_msi_unregister_producer(struct vfio_pci_irq_ctx *ctx)
 	irq_bypass_unregister_producer(&ctx->producer);
 }
 
+/*
+ * IOCTL support
+ */
 static struct vfio_pci_intr_ops intr_ops[] = {
 	[VFIO_PCI_INTX_IRQ_INDEX] = {
+		.enable = vfio_intx_enable,
+		.disable = vfio_intx_disable,
+		.send_eventfd = vfio_send_intx_eventfd_ctx,
 		.request_interrupt = vfio_intx_request_interrupt,
 		.free_interrupt = vfio_intx_free_interrupt,
 		.device_name = vfio_intx_device_name,
 	},
 	[VFIO_PCI_MSI_IRQ_INDEX] = {
+		.enable = vfio_msi_enable,
+		.disable = vfio_msi_disable,
+		.send_eventfd = vfio_send_msi_eventfd,
 		.request_interrupt = vfio_msi_request_interrupt,
 		.free_interrupt = vfio_msi_free_interrupt,
 		.device_name = vfio_msi_device_name,
@@ -558,6 +579,9 @@ static struct vfio_pci_intr_ops intr_ops[] = {
 		.unregister_producer = vfio_msi_unregister_producer,
 	},
 	[VFIO_PCI_MSIX_IRQ_INDEX] = {
+		.enable = vfio_msi_enable,
+		.disable = vfio_msi_disable,
+		.send_eventfd = vfio_send_msi_eventfd,
 		.request_interrupt = vfio_msi_request_interrupt,
 		.free_interrupt = vfio_msi_free_interrupt,
 		.device_name = vfio_msi_device_name,
@@ -646,9 +670,6 @@ static int vfio_irq_set_block(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-/*
- * IOCTL support
- */
 static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 				    unsigned int index, unsigned int start,
 				    unsigned int count, uint32_t flags,
@@ -701,71 +722,16 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
-				     unsigned int index, unsigned int start,
-				     unsigned int count, uint32_t flags,
-				     void *data)
-{
-	struct vfio_pci_irq_ctx *ctx;
-	unsigned int i;
-
-	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_intx_disable(vdev, index);
-		return 0;
-	}
-
-	if (!(is_intx(vdev) || is_irq_none(vdev)))
-		return -EINVAL;
-
-	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
-		int32_t *fds = data;
-		int ret;
-
-		if (is_intx(vdev))
-			return vfio_irq_set_block(vdev, start, count, fds, index);
-
-		ret = vfio_intx_enable(vdev, start, count, index);
-		if (ret)
-			return ret;
-
-		ret = vfio_irq_set_block(vdev, start, count, fds, index);
-		if (ret)
-			vfio_intx_disable(vdev, index);
-
-		return ret;
-	}
-
-	if (!is_intx(vdev))
-		return -EINVAL;
-
-	/* temporary */
-	for (i = start; i < start + count; i++) {
-		ctx = vfio_irq_ctx_get(vdev, i);
-		if (!ctx || !ctx->trigger)
-			continue;
-		if (flags & VFIO_IRQ_SET_DATA_NONE) {
-			vfio_send_intx_eventfd_ctx(vdev, ctx);
-		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
-			uint8_t *bools = data;
-
-			if (bools[i - start])
-				vfio_send_intx_eventfd_ctx(vdev, ctx);
-		}
-	}
-
-	return 0;
-}
-
-static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned int index, unsigned int start,
-				    unsigned int count, uint32_t flags,
-				    void *data)
+static int vfio_pci_set_trigger(struct vfio_pci_core_device *vdev,
+				unsigned int index, unsigned int start,
+				unsigned int count, uint32_t flags,
+				void *data)
 {
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
 
 	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_msi_disable(vdev, index);
+		intr_ops[index].disable(vdev, index);
 		return 0;
 	}
 
@@ -780,13 +746,13 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 			return vfio_irq_set_block(vdev, start, count,
 						  fds, index);
 
-		ret = vfio_msi_enable(vdev, start, count, index);
+		ret = intr_ops[index].enable(vdev, start, count, index);
 		if (ret)
 			return ret;
 
 		ret = vfio_irq_set_block(vdev, start, count, fds, index);
 		if (ret)
-			vfio_msi_disable(vdev, index);
+			intr_ops[index].disable(vdev, index);
 
 		return ret;
 	}
@@ -799,11 +765,11 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 		if (!ctx || !ctx->trigger)
 			continue;
 		if (flags & VFIO_IRQ_SET_DATA_NONE) {
-			eventfd_signal(ctx->trigger);
+			intr_ops[index].send_eventfd(vdev, ctx);
 		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 			uint8_t *bools = data;
 			if (bools[i - start])
-				eventfd_signal(ctx->trigger);
+				intr_ops[index].send_eventfd(vdev, ctx);
 		}
 	}
 	return 0;
@@ -912,7 +878,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			func = vfio_pci_set_intx_unmask;
 			break;
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			func = vfio_pci_set_intx_trigger;
+			func = vfio_pci_set_trigger;
 			break;
 		}
 		break;
@@ -924,7 +890,7 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			/* XXX Need masking support exported */
 			break;
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			func = vfio_pci_set_msi_trigger;
+			func = vfio_pci_set_trigger;
 			break;
 		}
 		break;
-- 
2.34.1


