Return-Path: <kvm+bounces-26988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C84F797A054
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 739AA1F2240B
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06BB215665D;
	Mon, 16 Sep 2024 11:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="aLsPqo0s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21541547C4;
	Mon, 16 Sep 2024 11:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486443; cv=none; b=JeUg548jyIdRl7jDhfPZN498FUpQZVBDfiZzunzuiRGCMXc+DtZfCxjM9Od1HS6qw5K9zJ5KHJDZS0/8UOZtLStMdOHnO6S9nyVEPqBS15PajrwXe8r8wvLvs3AZ4O3vyj63/abLipfuGxI7wAdpVPmt6M2hZq+4qTjXVoQnzRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486443; c=relaxed/simple;
	bh=qnq7WvFftCoeWcTSBoWunoZuNfa1NE67PLgl/LAceBM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ph9ON1e9gzVLQDuByruSOMTFOZlHjpnWJGKvDvth8IBuksb1Zh0Tad1O8dMidDGdC4Z/JMUiQ7yeHHOUhQ+tuzSnuPwv++hjUfMGI+xOvUIGJdciS4vtazaXF6bnYLogSvLXpSVj/4crGFJBBsal8fWMqFeiMbc+QscptboH96M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=aLsPqo0s; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486441; x=1758022441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=znWocKnBAQ/hYk1869lWadM7cB9SuIb60CkQR+dfh54=;
  b=aLsPqo0sk+v5tjA3Tbmhi/px0YeWE46JGcM9HGSTKp7U8a8SCC6kPTyz
   S7EiXJ185mOs0HlSf5db5vamicp96TdlCGHIUvYaWLoXu6BNlXHO910jV
   FVkYIIyYJjSVr5WT4n/gh1nNYUan8WlToSp+kWGJk0JIe3X8Nw0+Oaccr
   A=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="126593101"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:34:01 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:20132]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.3.169:2525] with esmtp (Farcaster)
 id 2782e688-9c8a-483f-87c2-fcf35b3201fd; Mon, 16 Sep 2024 11:34:00 +0000 (UTC)
X-Farcaster-Flow-ID: 2782e688-9c8a-483f-87c2-fcf35b3201fd
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:34:00 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:33:49 +0000
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
Subject: [RFC PATCH 08/13] intel-iommu: Add serialise and deserialise boilerplate
Date: Mon, 16 Sep 2024 13:30:57 +0200
Message-ID: <20240916113102.710522-9-jgowans@amazon.com>
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

Similar to how iommufd got serialise and deserialise hooks, now add this
to the platform iommu driver, in this case intel-iommu. Once again this
will be fleshed out in the next commits to actually serialise the struct
dmar_domain before kexec and restore them after kexec.
---
 drivers/iommu/intel/Makefile    |  1 +
 drivers/iommu/intel/iommu.c     | 18 +++++++++++++++
 drivers/iommu/intel/iommu.h     | 18 +++++++++++++++
 drivers/iommu/intel/serialise.c | 40 +++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+)
 create mode 100644 drivers/iommu/intel/serialise.c

diff --git a/drivers/iommu/intel/Makefile b/drivers/iommu/intel/Makefile
index c8beb0281559..ca9f73992620 100644
--- a/drivers/iommu/intel/Makefile
+++ b/drivers/iommu/intel/Makefile
@@ -9,3 +9,4 @@ ifdef CONFIG_INTEL_IOMMU
 obj-$(CONFIG_IRQ_REMAP) += irq_remapping.o
 endif
 obj-$(CONFIG_INTEL_IOMMU_PERF_EVENTS) += perfmon.o
+obj-$(CONFIG_KEXEC_KHO) += serialise.o
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f473a8c008a7..7e77b787148a 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -65,6 +65,7 @@ static int rwbf_quirk;
 static int force_on = 0;
 static int intel_iommu_tboot_noforce;
 static int no_platform_optin;
+DEFINE_XARRAY(persistent_domains);
 
 #define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
 
@@ -3393,6 +3394,10 @@ static __init int tboot_force_iommu(void)
 	return 1;
 }
 
+static struct notifier_block serialise_kho_nb = {
+	.notifier_call = intel_iommu_serialise_kho,
+};
+
 int __init intel_iommu_init(void)
 {
 	int ret = -ENODEV;
@@ -3432,6 +3437,12 @@ int __init intel_iommu_init(void)
 	if (!no_iommu)
 		intel_iommu_debugfs_init();
 
+	if (IS_ENABLED(CONFIG_KEXEC_KHO)) {
+		ret = register_kho_notifier(&serialise_kho_nb);
+		if (ret)
+			goto out_free_dmar;
+	}
+
 	if (no_iommu || dmar_disabled) {
 		/*
 		 * We exit the function here to ensure IOMMU's remapping and
@@ -3738,6 +3749,7 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 	struct intel_iommu *iommu = info->iommu;
 	struct dmar_domain *dmar_domain;
 	struct iommu_domain *domain;
+	int rc;
 
 	/* Must be NESTING domain */
 	if (parent) {
@@ -3778,6 +3790,12 @@ intel_iommu_domain_alloc_user(struct device *dev, u32 flags,
 		domain->dirty_ops = &intel_dirty_ops;
 	}
 
+	if (persistent_id) {
+		rc = xa_insert(&persistent_domains, persistent_id, domain, GFP_KERNEL_ACCOUNT);
+		if (rc)
+			pr_warn("Unable to track persistent domain %lu\n", persistent_id);
+	}
+
 	return domain;
 }
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index cfd006588824..7866342f0909 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -11,6 +11,7 @@
 #define _INTEL_IOMMU_H_
 
 #include <linux/types.h>
+#include <linux/kexec.h>
 #include <linux/iova.h>
 #include <linux/io.h>
 #include <linux/idr.h>
@@ -496,6 +497,7 @@ struct q_inval {
 #define PRQ_DEPTH	((0x1000 << PRQ_ORDER) >> 5)
 
 struct dmar_pci_notify_info;
+extern struct xarray persistent_domains;
 
 #ifdef CONFIG_IRQ_REMAP
 /* 1MB - maximum possible interrupt remapping table size */
@@ -1225,6 +1227,22 @@ static inline int iommu_calculate_max_sagaw(struct intel_iommu *iommu)
 #define intel_iommu_sm (0)
 #endif
 
+#ifdef CONFIG_KEXEC_KHO
+int intel_iommu_serialise_kho(struct notifier_block *self, unsigned long cmd,
+			  void *fdt);
+int __init intel_iommu_deserialise_kho(void);
+#else
+int intel_iommu_serialise_kho(struct notifier_block *self, unsigned long cmd,
+			  void *fdt)
+{
+	return 0;
+}
+int __init intel_iommu_deserialise_kho(void)
+{
+	return 0;
+}
+#endif /* CONFIG_KEXEC_KHO */
+
 static inline const char *decode_prq_descriptor(char *str, size_t size,
 		u64 dw0, u64 dw1, u64 dw2, u64 dw3)
 {
diff --git a/drivers/iommu/intel/serialise.c b/drivers/iommu/intel/serialise.c
new file mode 100644
index 000000000000..08a548b33703
--- /dev/null
+++ b/drivers/iommu/intel/serialise.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "iommu.h"
+
+static int serialise_domain(void *fdt, struct iommu_domain *domain)
+{
+	return 0;
+}
+
+int intel_iommu_serialise_kho(struct notifier_block *self, unsigned long cmd,
+			  void *fdt)
+{
+	static const char compatible[] = "intel-iommu-v0";
+	struct iommu_domain *domain;
+	unsigned long xa_idx;
+	int err = 0;
+
+	switch (cmd) {
+	case KEXEC_KHO_ABORT:
+		/* Would do serialise rollback here. */
+		return NOTIFY_DONE;
+	case KEXEC_KHO_DUMP:
+		err |= fdt_begin_node(fdt, "intel-iommu");
+		fdt_property(fdt, "compatible", compatible, sizeof(compatible));
+		err |= fdt_begin_node(fdt, "domains");
+		xa_for_each(&persistent_domains, xa_idx, domain) {
+			err |= serialise_domain(fdt, domain);
+		}
+		err |= fdt_end_node(fdt); /* domains */
+		err |= fdt_end_node(fdt); /* intel-iommu*/
+		return err? NOTIFY_BAD : NOTIFY_DONE;
+	default:
+		return NOTIFY_BAD;
+	}
+}
+
+int __init intel_iommu_deserialise_kho(void)
+{
+	return 0;
+}
-- 
2.34.1


