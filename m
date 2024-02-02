Return-Path: <kvm+bounces-7802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3D984673C
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:59:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78996B211BF
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF24217BDA;
	Fri,  2 Feb 2024 04:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WC4Zj/1A"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E682F168DF;
	Fri,  2 Feb 2024 04:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849853; cv=none; b=CUbSfhFaD4jPfU9GFpLNbxUwazdczBoXSOXw5yZRNoDBDnQF+6qUHygWALO4PAPOenaTtw8zMHQWjHRJxUtdHaq1AZoQKvwh09n0+EbwAavE7AHF9pG5rrWUJ1NN1kmiJfIrnG6MAtzuU62HoZQ2UUcoZJtzHJfvlFDXZ1uHRFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849853; c=relaxed/simple;
	bh=Y8mGWLOXkQHarvJTOtXDGSt3QFUWy8OXLPs0vhIlLNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZCUP3myB891NUQXLHdQcT4ubcJcRJsT9/pY++GgCz801GP9SDVC0cLBVyA/hXZ7eWuHMPbeAavta4V3R/9A41Ay8tX8fYBDS45brrYTK0Zf4JoZokzecEvTAmSt5C8SurvBqddkNgAbziOsTJ73fracdCOmHhyvZKYczMvuC1LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WC4Zj/1A; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849852; x=1738385852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y8mGWLOXkQHarvJTOtXDGSt3QFUWy8OXLPs0vhIlLNk=;
  b=WC4Zj/1A+LpV9zvH+RjiNYlbHjnJMsGLoNT1EWi6IewmvNpGg/I1K9W+
   lDC5Gqsfr34JsDMMLjvxwhvWxnNpuGMZHCyI8EXCiY1uZN3tuFsGtvp9s
   D0GDKb6LDMrFrZpm52UeUcPIFIqBF+98wKdC/1YI+oiDX85TTvu2Yg2qY
   OrMp8Hp6TtwyDk0bq4ZtWGVw80g4B2Baoo0pmyoXQBlb8YB7ybvjhauIX
   05eyUsFIpxGJx+4upiP242AZtqbb11vn1f6mtjzi8xGNnlXLaL104gzOa
   3td5kmIvqP0h3+TEEpZHzeQvpVNsFAKtmsKrpqqMqWDfHzOdwAzbu/EX+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615823"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615823"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339776"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339776"
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
Subject: [PATCH 07/17] vfio/pci: Preserve per-interrupt contexts
Date: Thu,  1 Feb 2024 20:57:01 -0800
Message-Id: <d6e32e0e7adaf61da39fb6cd2863298b15a2663e.1706849424.git.reinette.chatre@intel.com>
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

MSI and MSI-X interrupt management for PCI passthrough devices create
a new per-interrupt context every time an interrupt is allocated,
freeing it when the interrupt is freed.

The per-interrupt context contains the properties of a particular
interrupt. Without a property that persists across interrupt allocation
and free it is acceptable to always create a new per-interrupt context.

INTx interrupt context has a "masked" property that persists across
allocation and free and thus preserves its interrupt context
across interrupt allocation and free calls.

MSI and MSI-X interrupts already remain allocated across interrupt
allocation and free requests, additionally maintaining the
individual interrupt context is a reflection of this existing
behavior and matches INTx behavior so that more code can be shared.

An additional benefit is that maintaining interrupt context supports
a potential future use case of emulated interrupts, where the
"is this interrupt emulated" is a property that needs to persist
across allocation and free requests.

Persistent interrupt contexts means that existence of per-interrupt
context no longer implies a valid trigger, pointers to freed memory
should be cleared, and a new per-interrupt context cannot be assumed
needing allocation when an interrupt is allocated.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note to maintainers:
This addition originally formed part of the IMS work below that mostly
ignored INTx. This work focuses on INTx, MSI, MSI-X where this addition
is relevant.
https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com

 drivers/vfio/pci/vfio_pci_intrs.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 31f73c70fcd2..7ca2b983b66e 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -427,7 +427,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 	ctx = vfio_irq_ctx_get(vdev, vector);
 
-	if (ctx) {
+	if (ctx && ctx->trigger) {
 		irq_bypass_unregister_producer(&ctx->producer);
 		irq = pci_irq_vector(pdev, vector);
 		cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -435,8 +435,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
 		/* Interrupt stays allocated, will be freed at MSI-X disable. */
 		kfree(ctx->name);
+		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
-		vfio_irq_ctx_free(vdev, ctx, vector);
+		ctx->trigger = NULL;
 	}
 
 	if (fd < 0)
@@ -449,16 +450,17 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 			return irq;
 	}
 
-	ctx = vfio_irq_ctx_alloc(vdev, vector);
-	if (!ctx)
-		return -ENOMEM;
+	/* Per-interrupt context remain allocated. */
+	if (!ctx) {
+		ctx = vfio_irq_ctx_alloc(vdev, vector);
+		if (!ctx)
+			return -ENOMEM;
+	}
 
 	ctx->name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-msi%s[%d](%s)",
 			      msix ? "x" : "", vector, pci_name(pdev));
-	if (!ctx->name) {
-		ret = -ENOMEM;
-		goto out_free_ctx;
-	}
+	if (!ctx->name)
+		return -ENOMEM;
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
@@ -502,8 +504,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	eventfd_ctx_put(trigger);
 out_free_name:
 	kfree(ctx->name);
-out_free_ctx:
-	vfio_irq_ctx_free(vdev, ctx, vector);
+	ctx->name = NULL;
 	return ret;
 }
 
@@ -539,6 +540,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev,
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 		vfio_msi_set_vector_signal(vdev, i, -1, index);
+		vfio_irq_ctx_free(vdev, ctx, i);
 	}
 
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
@@ -694,7 +696,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 
 	for (i = start; i < start + count; i++) {
 		ctx = vfio_irq_ctx_get(vdev, i);
-		if (!ctx)
+		if (!ctx || !ctx->trigger)
 			continue;
 		if (flags & VFIO_IRQ_SET_DATA_NONE) {
 			eventfd_signal(ctx->trigger);
-- 
2.34.1


