Return-Path: <kvm+bounces-26985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E2D97A04D
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:33:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13A3BB22703
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A472F155336;
	Mon, 16 Sep 2024 11:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="hromEiUv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5001534EC;
	Mon, 16 Sep 2024 11:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486383; cv=none; b=InD0lAcrKfKuS877iHhUifsDufEB5a0q5HTKsEeYV59VJ9OVlXLu5C0Q6iBvxIEjLExJ9XmsieHTpWVeIo9fqzSt61HOP5o4p+1WiPIpAc7g68OM26HIn3uow5dg4DzdSaK4r8hx5mWSUPiHT2FEc+/RwbeuJEGC1Qe4tFCKt3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486383; c=relaxed/simple;
	bh=FsUWElab6zr300JppAticloJLvPgUVkfWRFKCIZtgQg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PBN9uhWP+eO8ggKxDmKlWFUyuyM18loil/B2vo2UUTgpmcALY/fbaY8twMLnR0bE8+lqMZR0k/9FruVBJAUPWlUNp/Gkx1h9Xqp8i/SiZDhbHB0piqbwuY01a4f65WPXh3htUMX6zB2gowosLa3ENqSjGfj5kbLspklkKLCu3L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=hromEiUv; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486382; x=1758022382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U/ULYcUe9jT7ezhYmtE5t4Iepfj5AYWdglXy5q3aDlM=;
  b=hromEiUvxORSRUPX+Y8YO3nMKzsT1gXXgg4KZYuo9sxFPiY7JcQfdpke
   Q90hMxmqtJzBeVV3PkVoK0Pct+j1l37cLDPDXwBjQglsBnX19k4Vuck6L
   OQo61SwLZbFkO/JniIIikShn4kx7r1CZEQaXitCYP8zTQXNyA2zMhMQ0f
   g=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="232155180"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:32:59 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.17.79:32997]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.1.23:2525] with esmtp (Farcaster)
 id 314ad269-748a-4395-b54d-92a65f8e6174; Mon, 16 Sep 2024 11:32:57 +0000 (UTC)
X-Farcaster-Flow-ID: 314ad269-748a-4395-b54d-92a65f8e6174
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:32:55 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:32:45 +0000
From: James Gowans <jgowans@amazon.com>
To: <linux-kernel@vger.kernel.org>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Joerg
 Roedel" <joro@8bytes.org>, =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?=
	<kw@linux.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Mike Rapoport <rppt@kernel.org>, "Madhavan T.
 Venkataraman" <madvenka@linux.microsoft.com>, <iommu@lists.linux.dev>, "Sean
 Christopherson" <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Lu Baolu
	<baolu.lu@linux.intel.com>, Alexander Graf <graf@amazon.de>,
	<anthony.yznaga@oracle.com>, <steven.sistare@oracle.com>,
	<nh-open-source@amazon.com>, "Saenz Julienne, Nicolas" <nsaenz@amazon.es>
Subject: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Date: Mon, 16 Sep 2024 13:30:54 +0200
Message-ID: <20240916113102.710522-6-jgowans@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240916113102.710522-1-jgowans@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWB004.ant.amazon.com (10.13.139.134) To
 EX19D014EUC004.ant.amazon.com (10.252.51.182)

Now actually implementing the serialise callback for iommufd.
On KHO activate, iterate through all persisted domains and write their
metadata to the device tree format. For now just a few fields are
serialised to demonstrate the concept. To actually make this useful a
lot more field and related objects will need to be serialised too.
---
 drivers/iommu/iommufd/iommufd_private.h |  2 +
 drivers/iommu/iommufd/main.c            |  2 +-
 drivers/iommu/iommufd/serialise.c       | 81 ++++++++++++++++++++++++-
 3 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index a26728646a22..ad8d180269bd 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -18,6 +18,8 @@ struct iommu_group;
 struct iommu_option;
 struct iommufd_device;
 
+extern struct xarray persistent_iommufds;
+
 struct iommufd_ctx {
 	struct file *file;
 	struct xarray objects;
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index fa4f0fe336ad..21a7e1ad40d1 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -30,7 +30,7 @@ struct iommufd_object_ops {
 static const struct iommufd_object_ops iommufd_object_ops[];
 static struct miscdevice vfio_misc_dev;
 
-static DEFINE_XARRAY_ALLOC(persistent_iommufds);
+DEFINE_XARRAY_ALLOC(persistent_iommufds);
 
 struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 					     size_t size,
diff --git a/drivers/iommu/iommufd/serialise.c b/drivers/iommu/iommufd/serialise.c
index 6e8bcc384771..6b4c306dce40 100644
--- a/drivers/iommu/iommufd/serialise.c
+++ b/drivers/iommu/iommufd/serialise.c
@@ -1,19 +1,94 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/kexec.h>
+#include <linux/libfdt.h>
 #include "iommufd_private.h"
+#include "io_pagetable.h"
+
+/**
+ * Serialised format:
+ * /iommufd
+ *   compatible = "iommufd-v0",
+ *   iommufds = [
+ *     persistent_id = {
+ *       account_mode = u8
+ *       ioases = [
+ *         {
+ *           areas = [
+ *           ]
+ *         }
+ *       ]
+ *     }
+ *   ]
+ */
+static int serialise_iommufd(void *fdt, struct iommufd_ctx *ictx)
+{
+	int err = 0;
+	char name[24];
+	struct iommufd_object *obj;
+	unsigned long obj_idx;
+
+	snprintf(name, sizeof(name), "%lu", ictx->persistent_id);
+	err |= fdt_begin_node(fdt, name);
+	err |= fdt_begin_node(fdt, "ioases");
+	xa_for_each(&ictx->objects, obj_idx, obj) {
+		struct iommufd_ioas *ioas;
+		struct iopt_area *area;
+		int area_idx = 0;
+
+		if (obj->type != IOMMUFD_OBJ_IOAS)
+			continue;
+
+		ioas = (struct iommufd_ioas *) obj;
+		snprintf(name, sizeof(name), "%lu", obj_idx);
+		err |= fdt_begin_node(fdt, name);
+
+		for (area = iopt_area_iter_first(&ioas->iopt, 0, ULONG_MAX); area;
+				area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
+			unsigned long iova_start, iova_len;
+
+			snprintf(name, sizeof(name), "%i", area_idx);
+			err |= fdt_begin_node(fdt, name);
+			iova_start = iopt_area_iova(area);
+			iova_len = iopt_area_length(area);
+			err |= fdt_property(fdt, "iova-start",
+					&iova_start, sizeof(iova_start));
+			err |= fdt_property(fdt, "iova-len",
+					&iova_len, sizeof(iova_len));
+			err |= fdt_property(fdt, "iommu-prot",
+					&area->iommu_prot, sizeof(area->iommu_prot));
+			err |= fdt_end_node(fdt); /* area_idx */
+			++area_idx;
+		}
+		err |= fdt_end_node(fdt); /* ioas obj_idx */
+	}
+	err |= fdt_end_node(fdt); /* ioases*/
+	err |= fdt_end_node(fdt); /* ictx->persistent_id */
+	return 0;
+}
 
 int iommufd_serialise_kho(struct notifier_block *self, unsigned long cmd,
 			  void *fdt)
 {
-	pr_info("would serialise here\n");
+	static const char compatible[] = "iommufd-v0";
+	struct iommufd_ctx *ictx;
+	unsigned long xa_idx;
+	int err = 0;
+
 	switch (cmd) {
 	case KEXEC_KHO_ABORT:
 		/* Would do serialise rollback here. */
 		return NOTIFY_DONE;
 	case KEXEC_KHO_DUMP:
-		/* Would do serialise here. */
-		return NOTIFY_DONE;
+		err |= fdt_begin_node(fdt, "iommufd");
+		fdt_property(fdt, "compatible", compatible, sizeof(compatible));
+		err |= fdt_begin_node(fdt, "iommufds");
+		xa_for_each(&persistent_iommufds, xa_idx, ictx) {
+			err |= serialise_iommufd(fdt, ictx);
+		}
+		err |= fdt_end_node(fdt); /* iommufds */
+		err |= fdt_end_node(fdt); /* iommufd */
+		return err? NOTIFY_BAD : NOTIFY_DONE;
 	default:
 		return NOTIFY_BAD;
 	}
-- 
2.34.1


