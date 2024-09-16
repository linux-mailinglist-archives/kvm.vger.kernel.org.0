Return-Path: <kvm+bounces-26991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A0B997A05B
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A962B21EB4
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24EE4155C98;
	Mon, 16 Sep 2024 11:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="rtexy970"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4BD155336;
	Mon, 16 Sep 2024 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486514; cv=none; b=gUFAqoTT1gsaIQH//qEWTHc23GDvrXCElKlLmK2oknK7yrCx6qgDLXVert7A3lf1DrI203HbyhMXVbgC17PV6nebb4eKbbv4dNltT8wz7dIjAly+LLYKnQtjZnDq1rvljjp9VcpECONo2wA0Yb0HoB28PFQjG6sUojcJlziq5H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486514; c=relaxed/simple;
	bh=kA7sCJq83w/U5a6+MV6UIyor1R8tN22DopzPIXKiz28=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=orCZwiZrEwSWCANFf9j+x+lBKIdlkbyAsHtTtjTecirwqFJolR0Tja3wK4AK5pa1BSa8WH8UURbCoU1bD0lRoweTpIE5Ky3c+YzpxskFCLHTdmxcSs9rJsRmBjoRfjiBU9RzAY7RrZigl90ljxFgQe5g9sk4tZRVDKfCN5DbRiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=rtexy970; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486513; x=1758022513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ddSVhaYeFUjlU8dhdd/QQglr933C97nK5BrvKFB/qRU=;
  b=rtexy9702sA+r1nbyRmGYR3uxCTQyS/UY6UFzJebofLGcIbPDglYBTUE
   9wGqwGKOShrV9CjxP6EjUlhzVmzck1Mq9sSjgRp4gp0ZiR419C9D8p3zi
   Dl5S9Aywc+lpRZ3P1I9Y9jkyZpvCwVlRNmchCjHrO7FjoCrDenEBeCa6g
   M=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="454426971"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:35:06 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:46964]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.35.229:2525] with esmtp (Farcaster)
 id 9197f70c-cad3-4f56-b798-def27e3f2a65; Mon, 16 Sep 2024 11:35:04 +0000 (UTC)
X-Farcaster-Flow-ID: 9197f70c-cad3-4f56-b798-def27e3f2a65
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:35:04 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:34:54 +0000
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
Subject: [RFC PATCH 11/13] iommu: Add callback to restore persisted iommu_domain
Date: Mon, 16 Sep 2024 13:31:00 +0200
Message-ID: <20240916113102.710522-12-jgowans@amazon.com>
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
X-ClientProxiedBy: EX19D046UWB003.ant.amazon.com (10.13.139.174) To
 EX19D014EUC004.ant.amazon.com (10.252.51.182)

The previous commits re-hydrated the struct iommu_domain and added them
to the persisted_domains xarray. Now provide a callback to get the
domain so that iommufd can restore a link to it.

Roughly where the restore would happen is called out in a comment, but
some more head scratching is needed to figure out how to actually do
this.
---
 drivers/iommu/intel/iommu.c       | 12 ++++++++++++
 drivers/iommu/iommufd/serialise.c |  9 ++++++++-
 include/linux/iommu.h             |  5 +++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 8e0ed033b03f..000ddfe5b6de 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4690,6 +4690,17 @@ static int intel_iommu_read_and_clear_dirty(struct iommu_domain *domain,
 	return 0;
 }
 
+static struct iommu_domain *intel_domain_restore(struct device *dev,
+		unsigned long persistent_id)
+{
+	struct iommu_domain *domain;
+
+	domain = xa_load(&persistent_domains, persistent_id);
+	if (!domain)
+		pr_warn("No such persisted domain id %lu\n", persistent_id);
+	return domain;
+}
+
 static const struct iommu_dirty_ops intel_dirty_ops = {
 	.set_dirty_tracking = intel_iommu_set_dirty_tracking,
 	.read_and_clear_dirty = intel_iommu_read_and_clear_dirty,
@@ -4703,6 +4714,7 @@ const struct iommu_ops intel_iommu_ops = {
 	.domain_alloc		= intel_iommu_domain_alloc,
 	.domain_alloc_user	= intel_iommu_domain_alloc_user,
 	.domain_alloc_sva	= intel_svm_domain_alloc,
+	.domain_restore 	= intel_domain_restore,
 	.probe_device		= intel_iommu_probe_device,
 	.release_device		= intel_iommu_release_device,
 	.get_resv_regions	= intel_iommu_get_resv_regions,
diff --git a/drivers/iommu/iommufd/serialise.c b/drivers/iommu/iommufd/serialise.c
index 9519969bd201..baac7d6150cb 100644
--- a/drivers/iommu/iommufd/serialise.c
+++ b/drivers/iommu/iommufd/serialise.c
@@ -139,7 +139,14 @@ static int rehydrate_iommufd(char *iommufd_name)
 		    area->node.last = *iova_start + *iova_len - 1;
 		    interval_tree_insert(&area->node, &ioas->iopt.area_itree);
 	    }
-	    /* TODO: restore link from ioas to hwpt. */
+	    /*
+	     * Here we should do something to associate struct iommufd_device with the
+	     * ictx, then get the iommu_ops via dev_iommu_ops(), and call the new
+	     * .domain_restore callback to get the struct iommu_domain.
+	     * Something like:
+	     * hwpt->domain = ops->domain_restore(dev, persistent_id);
+	     * Hand wavy - the details allude me at the moment...
+	     */
 	}
 
 	return fd;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a616e8702a1c..0dc97d494fd9 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -529,6 +529,8 @@ static inline int __iommu_copy_struct_from_user_array(
  * @domain_alloc_paging: Allocate an iommu_domain that can be used for
  *                       UNMANAGED, DMA, and DMA_FQ domain types.
  * @domain_alloc_sva: Allocate an iommu_domain for Shared Virtual Addressing.
+ * @domain_restore: After kexec, give the same persistent_id which was originally
+ *                  used to allocate the domain, and the domain will be restored.
  * @probe_device: Add device to iommu driver handling
  * @release_device: Remove device from iommu driver handling
  * @probe_finalize: Do final setup work after the device is added to an IOMMU
@@ -576,6 +578,9 @@ struct iommu_ops {
 	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
 						 struct mm_struct *mm);
 
+	struct iommu_domain *(*domain_restore)(struct device *dev,
+			unsigned long persistent_id);
+
 	struct iommu_device *(*probe_device)(struct device *dev);
 	void (*release_device)(struct device *dev);
 	void (*probe_finalize)(struct device *dev);
-- 
2.34.1


