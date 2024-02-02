Return-Path: <kvm+bounces-7797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C49CB846732
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 05:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 350E21F26F45
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E99F156E4;
	Fri,  2 Feb 2024 04:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X06nBpSC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3C5F9C2;
	Fri,  2 Feb 2024 04:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706849850; cv=none; b=Z86BOmk7lpup2uSX5wPL8LBSC4bxbJCyo5FqkahwnouEbqThfS8OGn5V9E9bkWIcMwQtuElOQ9EH9YOLnpptMNh+2HOnKoOM4/XWo7XriFdIJlqiJ9+fpWAiVD9tdEt7tmsa1HQXip+Sleoix0dzRmfquTaWapLkNuyOYdz4TWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706849850; c=relaxed/simple;
	bh=5y4NGXUar57YI25p8xEfMr33IxH4G1iGgFkp7ARQYPM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=duFzRpA0gV3GcRdLKxkPZRlrY6Eh1BfA963R0fIY1O5HI7GLQfoKgFFhzd9IGeWDoBxCuETJ0Z8FrsKDoPzX8qbc4YO8SgtF4b3vr06VhzjZ7UZK+jfWnpn/NIhN1v1eR6dk8xhRiBzfNR1pDpj0uvvf0pjr6clRczUgKj4n8Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X06nBpSC; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706849847; x=1738385847;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5y4NGXUar57YI25p8xEfMr33IxH4G1iGgFkp7ARQYPM=;
  b=X06nBpSCcFJa/ccHO+TvH10Yy0jQjTtonVm1Fml/qBWPNDz5EdLqlzGL
   bEEdf7vgqBZATalA4T466LR0WiyDQYDxGZERujWoWih+ZndAL58QM0HFr
   JHEA8itFJVAJPNgwbJl2ZPMAdte4dLYu8ZRh64ORySZ/kNCULm8pW9pGu
   2QqEZP5av4atOEKfyuEMffnnV6veA4H+tgmHncsnfwE7haAbhopbPmKmd
   8hHQR3rRygpKupnCOGVpCA6RIIz7RyWsr1l/2zuKG0mOgnEhVkuYGMrul
   dSaS7ZJ3j+1nWtH9U+1Gys8CwxiYwmsM+xa+3J69KjZ5p13eqRmHeaEEu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="17615791"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="17615791"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 20:57:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="912339759"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="912339759"
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
Subject: [PATCH 01/17] vfio/pci: Use unsigned int instead of unsigned
Date: Thu,  1 Feb 2024 20:56:55 -0800
Message-Id: <81103b9a7f0448bbd8740389fbb77f78c150620d.1706849424.git.reinette.chatre@intel.com>
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

checkpatch.pl warns about usage of bare unsigned.

Change unsigned to unsigned int to eliminate checkpatch.pl
warnings about existing code that are encountered by changes to the
interrupt management code at or near lines using bare unsigned.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Note to maintainers:
Originally formed part of the IMS submission below, but is not
specific to IMS.
https://lore.kernel.org/lkml/cover.1696609476.git.reinette.chatre@intel.com

 drivers/vfio/pci/vfio_pci_intrs.c | 42 ++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 237beac83809..f9280e32972a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -503,8 +503,9 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
-static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
-			      unsigned count, int32_t *fds, bool msix)
+static int vfio_msi_set_block(struct vfio_pci_core_device *vdev,
+			      unsigned int start, unsigned int count,
+			      int32_t *fds, bool msix)
 {
 	unsigned int i, j;
 	int ret = 0;
@@ -553,8 +554,9 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
  * IOCTL support
  */
 static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -584,8 +586,8 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
-				  unsigned index, unsigned start,
-				  unsigned count, uint32_t flags, void *data)
+				  unsigned int index, unsigned int start,
+				  unsigned int count, uint32_t flags, void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -604,8 +606,9 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
-				     unsigned index, unsigned start,
-				     unsigned count, uint32_t flags, void *data)
+				     unsigned int index, unsigned int start,
+				     unsigned int count, uint32_t flags,
+				     void *data)
 {
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_intx_disable(vdev);
@@ -647,8 +650,9 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned int i;
@@ -755,8 +759,9 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 }
 
 static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
@@ -766,8 +771,9 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 }
 
 static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
@@ -777,11 +783,11 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 }
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
-			    unsigned index, unsigned start, unsigned count,
-			    void *data)
+			    unsigned int index, unsigned int start,
+			    unsigned int count, void *data)
 {
-	int (*func)(struct vfio_pci_core_device *vdev, unsigned index,
-		    unsigned start, unsigned count, uint32_t flags,
+	int (*func)(struct vfio_pci_core_device *vdev, unsigned int index,
+		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
 
 	switch (index) {
-- 
2.34.1


