Return-Path: <kvm+bounces-26989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE1A97A057
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3DB8B220FC
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE181509B3;
	Mon, 16 Sep 2024 11:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="caQYpc8V"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8E1154429;
	Mon, 16 Sep 2024 11:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486491; cv=none; b=Er1sY23pbg7CnoSqyHYdTkRB1tigzqlbe3ooDcqI+JB3W8DX7EJqtyoXdpHdq2S0n2oIvZ9a62f3Rsmc37ZOdrVdbWfjqTHyurW6oB6M01ul96NlJQNL+aJMBPe50eWYr5bJMlCzHO1P4txaQ7Zgrqq3gecjbg+nyty0Juz2sXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486491; c=relaxed/simple;
	bh=2Z+qKyzqOqbutmfC3zXpXkioDGSuvF+lOnNL+tKeDWY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bh5Pb21gb441yL6l+sBjBr0NPzWWMdfghmvg+ZLU/q7phQWPEaej40fYS+fy2RPK1+epjIbjscVFfCa7bHpctDlInh45jrsnP9zhISCIaTPssVZ85MF4X/hK8dYkoQh8IRq7hVgJjcTld0xi4GvhFVAv/PU2cOhS1JuRLAAesxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=caQYpc8V; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486490; x=1758022490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d7SA1xd31CQwM5KfV5meLxmO5eWfDrrSDBGteh7IWAY=;
  b=caQYpc8V/YMvfAic+xKc3k5DqmY7+aRb4xQ/S1/GELaK8wox/PHO3hHY
   jZ6X3ep9CD0mMR4on5/5av56AuXp91EyQS+RCY024uMnuh03WhLuYqjTo
   7eKp/bhycYLd3xFBB6oZ+Nb1cr9NOKzAEboFnzt+gPKjT0lZHVMQZCiuJ
   4=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="232155494"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:34:49 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:46245]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.43.112:2525] with esmtp (Farcaster)
 id 86fb6cac-b9f4-49c1-bff6-bddf8af55ee2; Mon, 16 Sep 2024 11:34:47 +0000 (UTC)
X-Farcaster-Flow-ID: 86fb6cac-b9f4-49c1-bff6-bddf8af55ee2
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:34:43 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:34:32 +0000
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
Subject: [RFC PATCH 09/13] intel-iommu: Serialise dmar_domain on KHO activaet
Date: Mon, 16 Sep 2024 13:30:58 +0200
Message-ID: <20240916113102.710522-10-jgowans@amazon.com>
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

Add logic to iterate through persistent domains, add the page table
pages to KHO persistent memory pages. Also serialise some metadata about
the domains and attached PCI devices.

By adding the page table pages to the `mem` attribute on the KHO object
these pages will be carved out of system memory early in boot by KHO,
guaranteeing that they will not be used for any other purpose by the new
kernel. This persists the page tables across kexec.
---
 drivers/iommu/intel/iommu.c     |  9 ----
 drivers/iommu/intel/iommu.h     | 10 ++++
 drivers/iommu/intel/serialise.c | 92 ++++++++++++++++++++++++++++++++-
 3 files changed, 101 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 7e77b787148a..0a2118a3b7c4 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -46,15 +46,6 @@
 
 #define DEFAULT_DOMAIN_ADDRESS_WIDTH 57
 
-#define __DOMAIN_MAX_PFN(gaw)  ((((uint64_t)1) << ((gaw) - VTD_PAGE_SHIFT)) - 1)
-#define __DOMAIN_MAX_ADDR(gaw) ((((uint64_t)1) << (gaw)) - 1)
-
-/* We limit DOMAIN_MAX_PFN to fit in an unsigned long, and DOMAIN_MAX_ADDR
-   to match. That way, we can use 'unsigned long' for PFNs with impunity. */
-#define DOMAIN_MAX_PFN(gaw)	((unsigned long) min_t(uint64_t, \
-				__DOMAIN_MAX_PFN(gaw), (unsigned long)-1))
-#define DOMAIN_MAX_ADDR(gaw)	(((uint64_t)__DOMAIN_MAX_PFN(gaw)) << VTD_PAGE_SHIFT)
-
 static void __init check_tylersburg_isoch(void);
 static int rwbf_quirk;
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 7866342f0909..cd932a97a9bc 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -38,6 +38,16 @@
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
 
+#define __DOMAIN_MAX_PFN(gaw)  ((((uint64_t)1) << ((gaw) - VTD_PAGE_SHIFT)) - 1)
+#define __DOMAIN_MAX_ADDR(gaw) ((((uint64_t)1) << (gaw)) - 1)
+
+/* We limit DOMAIN_MAX_PFN to fit in an unsigned long, and DOMAIN_MAX_ADDR
+   to match. That way, we can use 'unsigned long' for PFNs with impunity. */
+#define DOMAIN_MAX_PFN(gaw)	((unsigned long) min_t(uint64_t, \
+				__DOMAIN_MAX_PFN(gaw), (unsigned long)-1))
+#define DOMAIN_MAX_ADDR(gaw)	(((uint64_t)__DOMAIN_MAX_PFN(gaw)) << VTD_PAGE_SHIFT)
+
+
 #define VTD_STRIDE_SHIFT        (9)
 #define VTD_STRIDE_MASK         (((u64)-1) << VTD_STRIDE_SHIFT)
 
diff --git a/drivers/iommu/intel/serialise.c b/drivers/iommu/intel/serialise.c
index 08a548b33703..bc755e51732b 100644
--- a/drivers/iommu/intel/serialise.c
+++ b/drivers/iommu/intel/serialise.c
@@ -2,9 +2,99 @@
 
 #include "iommu.h"
 
+/*
+ * Serialised format:
+ * /intel-iommu
+ *     compatible = str
+ *     domains = {
+ *         persistent-id = {
+ *             mem = [ ... ] // page table pages
+ *             agaw = i32
+ *             pgd = u64
+ *             devices = {
+ *                 id = {
+ *                     u8 bus;
+ *                     u8 devfn
+ *                 },
+ *                 ...
+ *             }
+ *         }
+ *      }
+ */
+
+/*
+ * Adds all present PFNs on the PTE page to the kho_mem pointer and advances
+ * the pointer.
+ * Stolen from dma_pte_list_pagetables() */
+static void save_pte_pages(struct dmar_domain *domain, int level,
+			   struct dma_pte *pte, struct kho_mem **kho_mem)
+{
+	struct page *pg;
+
+	pg = pfn_to_page(dma_pte_addr(pte) >> PAGE_SHIFT);
+	
+	if (level == 1)
+		return;
+
+	pte = page_address(pg);
+	do {
+		if (dma_pte_present(pte)) {
+			(*kho_mem)->addr = dma_pte_addr(pte);
+			(*kho_mem)->len = PAGE_SIZE;
+			(*kho_mem)++;
+			if (!dma_pte_superpage(pte))
+				save_pte_pages(domain, level - 1, pte, kho_mem);
+		}
+		pte++;
+	} while (!first_pte_in_page(pte));
+}
+		
 static int serialise_domain(void *fdt, struct iommu_domain *domain)
 {
-	return 0;
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
+	/*
+	 * kho_mems_start points to the original allocated array; kho_mems
+	 * is incremented by the callee. Keep both to know how many were added.
+	 */
+	struct kho_mem *kho_mems, *kho_mems_start;
+	struct device_domain_info *info;
+	int err = 0;
+	char name[24];
+	int device_idx = 0;
+	phys_addr_t pgd;
+
+	/*
+	 * Assume just one page worth of kho_mem objects is enough.
+	 * Better would be to keep track of number of allocated pages in the domain.
+	 * */
+	kho_mems_start = kho_mems = kzalloc(PAGE_SIZE, GFP_KERNEL);
+
+	save_pte_pages(dmar_domain, agaw_to_level(dmar_domain->agaw),
+		       dmar_domain->pgd, &kho_mems);
+
+	snprintf(name, sizeof(name), "%lu", domain->persistent_id);
+	err |= fdt_begin_node(fdt, name);
+	err |= fdt_property(fdt, "mem", kho_mems_start,
+			sizeof(struct kho_mem) * (kho_mems - kho_mems_start));
+	err |= fdt_property(fdt, "persistent_id", &domain->persistent_id,
+			sizeof(domain->persistent_id));
+	pgd = virt_to_phys(dmar_domain->pgd);
+	err |= fdt_property(fdt, "pgd", &pgd, sizeof(pgd));
+	err |= fdt_property(fdt, "agaw", &dmar_domain->agaw,
+			sizeof(dmar_domain->agaw));
+
+	err |= fdt_begin_node(fdt, "devices");
+	list_for_each_entry(info, &dmar_domain->devices, link) {
+		snprintf(name, sizeof(name), "%i", device_idx++);
+		err |= fdt_begin_node(fdt, name);
+		err |= fdt_property(fdt, "bus", &info->bus, sizeof(info->bus));
+		err |= fdt_property(fdt, "devfn", &info->devfn, sizeof(info->devfn));
+		err |= fdt_end_node(fdt); /* device_idx */
+	}
+	err |= fdt_end_node(fdt); /* devices */
+	err |= fdt_end_node(fdt); /* domain->persistent_id */
+
+	return err;
 }
 
 int intel_iommu_serialise_kho(struct notifier_block *self, unsigned long cmd,
-- 
2.34.1


