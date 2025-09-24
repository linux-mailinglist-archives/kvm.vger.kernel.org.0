Return-Path: <kvm+bounces-58647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A87B9A2C7
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55ABB32349C
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED22A3054F6;
	Wed, 24 Sep 2025 14:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="NeyjzZQf"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FE5305068;
	Wed, 24 Sep 2025 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.158.23.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723072; cv=none; b=o/RriMJMo6rDTOHizx/Nvblwl+qL3mmF0GNnFfPSMX0By0wQ1ZcRO6PBlfLiBdJEQax8MeuYyyTKbEmKsgOQ8Iz45RfSnZexUOYQoa3O4dMbnlhskhJnmrGEJxVutsz7YfoHJ6UM2OGss3dQhSZJ2yryanDo+N/uifkDcFlHUoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723072; c=relaxed/simple;
	bh=gAuRNltqJzgZyWEIHLg7Fofa8CPfuqAb71v/VsiS5HA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zc5pcnAA4pcy2T0/qJGYjHHr3JJ4VpWl0I0IzjlExZxgfwsedRMpWiqfus5Z4B+iSqwyDjFW8BgaHjc1R/zk8fqYEkFp5rkS0kocuF/gXYnNlUw9iJoHUZr4QPr3uYO0CI0F3BJnv4xstWOKZ2jn7lyHqcEYRCZbUYcDgfA++ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=NeyjzZQf; arc=none smtp.client-ip=35.158.23.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1758723070; x=1790259070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vlSsIuF9Wb2Tm0znC1D8CWXPAsIXTh2j5+LYsrwoARM=;
  b=NeyjzZQfBF4kyF/qXp4EW/CAmAtTM9MIw4OENqhEJyBbVu+my4tkspFh
   mwd2Ln35SfuKYvq4frHaALoPkTE2SUr6e/JBnG095VSRQMH64TebuOEiC
   ZZHbCu9Zwj40hH5Lf+t5HrToso/lzTvEZFxlymqc1nak7E1duZBH6Ymro
   OI/H0d7e1UFr4XjxiTo922MEQKmCOKngugkHFdPViVjlBS5nIXNv7lSl9
   kq1u1WI0GW3tbqIzFV1B69LSqqoQFXNRvTDYz12+Zt03vDbM8Pp2c0X/4
   Ywl6O7N/iTsjQAmJliYSEXat4PPjFEOQkpY7jajAqIUODIPy0HyXvHb98
   g==;
X-CSE-ConnectionGUID: szoMElyQSp2nxSwMGktZ/A==
X-CSE-MsgGUID: fG7VMdPLSQCL3XgcMEZCNA==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2614478"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:11:08 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:4694]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.230:2525] with esmtp (Farcaster)
 id 8cab9ff5-ed74-4e0c-9e31-d48fcbaebf4d; Wed, 24 Sep 2025 14:11:07 +0000 (UTC)
X-Farcaster-Flow-ID: 8cab9ff5-ed74-4e0c-9e31-d48fcbaebf4d
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 14:11:07 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 14:11:04 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 1/7] vfio/pci: refactor region dereferences for RCU.
Date: Wed, 24 Sep 2025 16:09:52 +0200
Message-ID: <20250924141018.80202-2-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924141018.80202-1-mngyadam@amazon.de>
References: <20250924141018.80202-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D040UWA004.ant.amazon.com (10.13.139.93) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

No functional changes. These refactors multiple region array accessing
into one place. This prepares for the RCU locking in the following
patches.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci_core.c | 21 ++++++++++++---------
 drivers/vfio/pci/vfio_pci_igd.c  | 20 ++++++++++++++------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc9..ea04c1291af68 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1003,6 +1003,7 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_region_info info;
 	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+	struct vfio_pci_region *region;
 	int i, ret;
 
 	if (copy_from_user(&info, arg, minsz))
@@ -1091,22 +1092,23 @@ static int vfio_pci_ioctl_get_region_info(struct vfio_pci_core_device *vdev,
 			info.index, VFIO_PCI_NUM_REGIONS + vdev->num_regions);
 
 		i = info.index - VFIO_PCI_NUM_REGIONS;
+		region = &vdev->region[i];
 
 		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
-		info.size = vdev->region[i].size;
-		info.flags = vdev->region[i].flags;
+		info.size = region->size;
+		info.flags = region->flags;
 
-		cap_type.type = vdev->region[i].type;
-		cap_type.subtype = vdev->region[i].subtype;
+		cap_type.type = region->type;
+		cap_type.subtype = region->subtype;
 
 		ret = vfio_info_add_capability(&caps, &cap_type.header,
 					       sizeof(cap_type));
 		if (ret)
 			return ret;
 
-		if (vdev->region[i].ops->add_capability) {
-			ret = vdev->region[i].ops->add_capability(
-				vdev, &vdev->region[i], &caps);
+		if (region->ops->add_capability) {
+			ret = region->ops->add_capability(
+				vdev, region, &caps);
 			if (ret)
 				return ret;
 		}
@@ -1726,10 +1728,11 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
 		int regnum = index - VFIO_PCI_NUM_REGIONS;
 		struct vfio_pci_region *region = vdev->region + regnum;
 
+		ret = -EINVAL;
 		if (region->ops && region->ops->mmap &&
 		    (region->flags & VFIO_REGION_INFO_FLAG_MMAP))
-			return region->ops->mmap(vdev, region, vma);
-		return -EINVAL;
+			ret = region->ops->mmap(vdev, region, vma);
+		return ret;
 	}
 	if (index >= VFIO_PCI_ROM_REGION_INDEX)
 		return -EINVAL;
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 988b6919c2c31..ac0921fdc62da 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -66,14 +66,18 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
 			       bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
-	struct igd_opregion_vbt *opregionvbt = vdev->region[i].data;
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK, off = 0;
 	size_t remaining;
+	struct vfio_pci_region *region;
+	struct igd_opregion_vbt *opregionvbt;
+
+	region = &vdev->region[i];
+	opregionvbt = region->data;
 
-	if (pos >= vdev->region[i].size || iswrite)
+	if (pos >= region->size || iswrite)
 		return -EINVAL;
 
-	count = min_t(size_t, count, vdev->region[i].size - pos);
+	count = min_t(size_t, count, region->size - pos);
 	remaining = count;
 
 	/* Copy until OpRegion version */
@@ -283,15 +287,19 @@ static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
 				   bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
-	struct pci_dev *pdev = vdev->region[i].data;
 	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
 	size_t size;
 	int ret;
+	struct vfio_pci_region *region;
+	struct pci_dev *pdev;
+
+	region = &vdev->region[i];
+	pdev = region->data;
 
-	if (pos >= vdev->region[i].size || iswrite)
+	if (pos >= region->size || iswrite)
 		return -EINVAL;
 
-	size = count = min(count, (size_t)(vdev->region[i].size - pos));
+	size = count = min(count, (size_t)(region->size - pos));
 
 	if ((pos & 1) && size) {
 		u8 val;
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


