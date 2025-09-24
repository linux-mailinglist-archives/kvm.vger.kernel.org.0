Return-Path: <kvm+bounces-58648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 749E3B9A2D6
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 16:11:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A61D19C5C78
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E807305949;
	Wed, 24 Sep 2025 14:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="YROiuv8t"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381563054C1;
	Wed, 24 Sep 2025 14:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.156.205.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723102; cv=none; b=tLeyyk2hrFn+lcaNE77XOF74qB72p36eHjMdre016P/HCLyAqC9Zw2fFGCrUKXilcul3NW5NLKzkVQf8aspIyyT0xtBqNGMlt9+O+m6/7EXxLJIPs9WcNON8t2ymS0ztByEEmLd7v20LHlxXMCmFo0v4nMi+9fP2KHZIZVAlnUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723102; c=relaxed/simple;
	bh=+G+nhgMDkUB3krElw/Y5fjO5ixQTrXyQMbOi3Ishsuo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q53WHyXMEuujsU2dmDhYQeFBCyEH0hddQtTZeSW34dFOw0hn05y3cwaF3LdgxMBVHA+6BHEqo5pyCFz0PyXt0K9BMlr8MnftZ2ZhW/8O1LyL68bnvMJb/R1opAXb3E79oI2fe04ArUqROieKLdLoitSFuoNEOeJndI6cMU5hjL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=YROiuv8t; arc=none smtp.client-ip=18.156.205.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1758723100; x=1790259100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=44sLeJ/g4ccVdWLHAH06fHNbcre1IP6QJSrawkrRk9A=;
  b=YROiuv8tSlTV9fn0zWA9KWX8s43RZMVVrQOYx1snDc3SxEdL6TIRpwjT
   4QeIzlUIaS1f2yq1LUOgqWWXZv6B5e1/TYNsQQ1M+W2lQf3Fs3biULtD8
   icUCx6JbeLX4KysEN1H5u2SW8qFLnplCooa57iK6Aw3DJxe3fSSGOTzuX
   spD4ujWwWruvZA2P7R3PQqY10dBDV0Ey6I/xbuxrI9spZHmH3xh6KU7tv
   Web5HNPPzrvO9OCVeUZveWlu2zvdGbCMLJszakujVc1zZYU4MY0sAGEPv
   ygXzjuUh/GI/TO3W6S5CeYG71YWHfgLBKMLfDNazhDla1emczhu2c+icN
   Q==;
X-CSE-ConnectionGUID: BxIec1HyS62Lm99Tp+7DFw==
X-CSE-MsgGUID: ACRxUN5BTo2YzKTXLD+d/A==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2613010"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 14:11:29 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:5949]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.38.97:2525] with esmtp (Farcaster)
 id 67400613-76e3-4aa3-82f3-8f3a059ec344; Wed, 24 Sep 2025 14:11:29 +0000 (UTC)
X-Farcaster-Flow-ID: 67400613-76e3-4aa3-82f3-8f3a059ec344
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 14:11:29 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 14:11:26 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <kbusch@kernel.org>,
	<benh@kernel.crashing.org>, David Woodhouse <dwmw@amazon.co.uk>,
	<pravkmr@amazon.de>, <nagy@khwaternagy.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/7] vfio_pci_core: split krealloc to allow use RCU & return index
Date: Wed, 24 Sep 2025 16:09:53 +0200
Message-ID: <20250924141018.80202-3-mngyadam@amazon.de>
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

Unwrap the allocation, copying, assignation & freeing part of the
krealloc. This enables using RCU for picking the reference in the
following patches, and synchronize before writing back to region.

Use the return value for returning the region index that was
created. This is helpful for the caller to know the index of the
region that was created.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
 drivers/vfio/pci/vfio_pci_core.c | 34 ++++++++++++++++++++------------
 drivers/vfio/pci/vfio_pci_igd.c  |  6 +++---
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ea04c1291af68..6629490c0e46f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -881,30 +881,38 @@ static int msix_mmappable_cap(struct vfio_pci_core_device *vdev,
 	return vfio_info_add_capability(caps, &header, sizeof(header));
 }
 
+/*
+ * Registers a new region to vfio_pci_core_device.
+ * Returns region index on success or a negative errno.
+ */
 int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 				      unsigned int type, unsigned int subtype,
 				      const struct vfio_pci_regops *ops,
 				      size_t size, u32 flags, void *data)
 {
-	struct vfio_pci_region *region;
+	int num_regions = vdev->num_regions;
+	struct vfio_pci_region *region, *old_region;
 
-	region = krealloc(vdev->region,
-			  (vdev->num_regions + 1) * sizeof(*region),
-			  GFP_KERNEL_ACCOUNT);
+	region = kmalloc((num_regions + 1) * sizeof(*region),
+			 GFP_KERNEL_ACCOUNT);
 	if (!region)
 		return -ENOMEM;
 
-	vdev->region = region;
-	vdev->region[vdev->num_regions].type = type;
-	vdev->region[vdev->num_regions].subtype = subtype;
-	vdev->region[vdev->num_regions].ops = ops;
-	vdev->region[vdev->num_regions].size = size;
-	vdev->region[vdev->num_regions].flags = flags;
-	vdev->region[vdev->num_regions].data = data;
+	old_region = vdev->region;
+	if (old_region)
+		memcpy(region, old_region, num_regions * sizeof(*region));
 
-	vdev->num_regions++;
+	region[num_regions].type = type;
+	region[num_regions].subtype = subtype;
+	region[num_regions].ops = ops;
+	region[num_regions].size = size;
+	region[num_regions].flags = flags;
+	region[num_regions].data = data;
 
-	return 0;
+	vdev->region = region;
+	vdev->num_regions++;
+	kfree(old_region);
+	return num_regions;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
 
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index ac0921fdc62da..93ddef48e4e4c 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -265,7 +265,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_core_device *vdev)
 		PCI_VENDOR_ID_INTEL | VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
 		VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION, &vfio_pci_igd_regops,
 		size, VFIO_REGION_INFO_FLAG_READ, opregionvbt);
-	if (ret) {
+	if (ret < 0) {
 		if (opregionvbt->vbt_ex)
 			memunmap(opregionvbt->vbt_ex);
 
@@ -415,7 +415,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
 		VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG,
 		&vfio_pci_igd_cfg_regops, host_bridge->cfg_size,
 		VFIO_REGION_INFO_FLAG_READ, host_bridge);
-	if (ret) {
+	if (ret < 0) {
 		pci_dev_put(host_bridge);
 		return ret;
 	}
@@ -435,7 +435,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
 		VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG,
 		&vfio_pci_igd_cfg_regops, lpc_bridge->cfg_size,
 		VFIO_REGION_INFO_FLAG_READ, lpc_bridge);
-	if (ret) {
+	if (ret < 0) {
 		pci_dev_put(lpc_bridge);
 		return ret;
 	}
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


