Return-Path: <kvm+bounces-26990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB5F97A059
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92DAD1C21CB8
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6E59156228;
	Mon, 16 Sep 2024 11:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="XVPRMUGK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF9E14F9D5;
	Mon, 16 Sep 2024 11:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486499; cv=none; b=cJw9SWN/hW9MS6P0g/E8lV9zCvmhzye/WZNc9qKcWKe12jasZ0d5zzPwd4DsJT71NoKrOkjEOdAhlXafkczAEwyCXxM5GsMKtbert1N/+CyCznEVUG9kmCsMkaNpS61nhTtoQrB1qElcsGPaiqU2NKEp9AvlZeFXMD5AhL5EUqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486499; c=relaxed/simple;
	bh=qgAWrKAqTmQwyd4blG1RANeLvbuBYnyiRPo7Iag+Qgg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LHxCAsBZiO7GV5TdiGqLjEf7g/5NFjlhO+tASGLrJKKyR82+uVCZBNy0BV1uOmrSaBcAyXpfvZqsSYb1eHeJJVrLdhfhnsvbKybb8HCA65941AIpQkvAy1obvZ/GzqxRQ3wNZJmO3+ECDZvtrPCGbPb6tUQRLA890Oe6JatbItw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=XVPRMUGK; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486498; x=1758022498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UHPN1sMG5/6h+BnEt3zqjnOKfZMJcCvehN1igJFWOWk=;
  b=XVPRMUGKTiliDAX5fflXEN6DjEFbJkGitMSIoDGNdsrmP4WbBxd+twCY
   nrwo349wnd/DvpsamEBChTN8AvJ/fRDn2YoAupEtAOq7Ml5N05ml32/Oh
   k2A7S2OPTGyaLXS9sg8QhUBdvlgbihMupVW6LEedmvVqTO773yBpAM3AZ
   c=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="232155512"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:34:55 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:61744]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.15:2525] with esmtp (Farcaster)
 id be110ece-689d-4c7e-83b2-236c50a7aaba; Mon, 16 Sep 2024 11:34:54 +0000 (UTC)
X-Farcaster-Flow-ID: be110ece-689d-4c7e-83b2-236c50a7aaba
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:34:54 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:34:43 +0000
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
Subject: [RFC PATCH 10/13] intel-iommu: Re-hydrate persistent domains after kexec
Date: Mon, 16 Sep 2024 13:30:59 +0200
Message-ID: <20240916113102.710522-11-jgowans@amazon.com>
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

Go through the domain data persisted in KHO, allocate fresh dmar_domain
structs and populate the structs with the persisted data.
Persisted page table pages in the "mem" field are also claimed to
transfer ownership of the pages from KHO back to the intel-iommu driver.

Once re-hydrated the struct iommu_domain pointers are inserted into the
persisted_domains xarray so that they can be fetched later when they
need to be restored by iommufd. This will be done in the next commit.
---
 drivers/iommu/intel/iommu.c     |  9 ++++++-
 drivers/iommu/intel/iommu.h     |  1 +
 drivers/iommu/intel/serialise.c | 44 +++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 0a2118a3b7c4..8e0ed033b03f 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1505,7 +1505,7 @@ static bool first_level_by_default(unsigned int type)
 	return type != IOMMU_DOMAIN_UNMANAGED;
 }
 
-static struct dmar_domain *alloc_domain(unsigned int type)
+struct dmar_domain *alloc_domain(unsigned int type)
 {
 	struct dmar_domain *domain;
 
@@ -3468,6 +3468,7 @@ int __init intel_iommu_init(void)
 
 	init_no_remapping_devices();
 
+	intel_iommu_deserialise_kho();
 	ret = init_dmars();
 	if (ret) {
 		if (force_on)
@@ -4127,6 +4128,12 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
 	}
 
 	dev_iommu_priv_set(dev, info);
+
+	/*
+	 * TODO: around here the device should be added to the persistent
+	 * domain if it is a persistent device.
+	 */
+
 	if (pdev && pci_ats_supported(pdev)) {
 		ret = device_rbtree_insert(iommu, info);
 		if (ret)
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index cd932a97a9bc..7ee050ebfaca 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1118,6 +1118,7 @@ int qi_submit_sync(struct intel_iommu *iommu, struct qi_desc *desc,
  */
 #define QI_OPT_WAIT_DRAIN		BIT(0)
 
+struct dmar_domain *alloc_domain(unsigned int type);
 void domain_update_iotlb(struct dmar_domain *domain);
 int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
 void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
diff --git a/drivers/iommu/intel/serialise.c b/drivers/iommu/intel/serialise.c
index bc755e51732b..20f42b84d490 100644
--- a/drivers/iommu/intel/serialise.c
+++ b/drivers/iommu/intel/serialise.c
@@ -124,7 +124,51 @@ int intel_iommu_serialise_kho(struct notifier_block *self, unsigned long cmd,
 	}
 }
 
+static void deserialise_domains(const void *fdt, int root_off)
+{
+	int off;
+	struct dmar_domain *dmar_domain;
+
+	fdt_for_each_subnode(off, fdt, root_off) {
+		const struct kho_mem *kho_mems;
+		int len, idx;
+		const unsigned long *pgd_phys;
+		const int *agaw;
+		const unsigned long *persistent_id;
+		int rc;
+
+		dmar_domain = alloc_domain(IOMMU_DOMAIN_UNMANAGED);
+
+		kho_mems = fdt_getprop(fdt, off, "mem", &len);
+		for (idx = 0; idx * sizeof(struct kho_mem) < len; ++idx)
+			kho_claim_mem(&kho_mems[idx]);
+
+		pgd_phys = fdt_getprop(fdt, off, "pgd", &len);
+		dmar_domain->pgd = phys_to_virt(*pgd_phys);
+		agaw = fdt_getprop(fdt, off, "agaw", &len);
+		dmar_domain->agaw = *agaw;
+		persistent_id = fdt_getprop(fdt, off, "persistent_id", &len);
+		dmar_domain->domain.persistent_id = *persistent_id;
+
+		rc = xa_insert(&persistent_domains, *persistent_id,
+				&dmar_domain->domain, GFP_KERNEL);
+		if (rc)
+			pr_warn("Unable to re-insert persistent domain %lu\n", *persistent_id);
+	}
+}
+
 int __init intel_iommu_deserialise_kho(void)
 {
+	const void *fdt = kho_get_fdt();
+	int off;
+
+	if (!fdt)
+		return 0;
+
+	off = fdt_path_offset(fdt, "/intel-iommu");
+	if (off <= 0)
+		return 0; /* No data in KHO */
+
+	deserialise_domains(fdt, fdt_subnode_offset(fdt, off, "domains"));
 	return 0;
 }
-- 
2.34.1


