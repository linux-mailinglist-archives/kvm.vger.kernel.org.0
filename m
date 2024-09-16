Return-Path: <kvm+bounces-26983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 879FA97A049
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 13:32:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F9EB283A54
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 11:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167C7154435;
	Mon, 16 Sep 2024 11:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="hk7ysDl6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E0361FD8;
	Mon, 16 Sep 2024 11:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726486357; cv=none; b=XFDJADcxmlpvQgNM1YTRUPx7wWQffnhT54bQ3JToauDJH16hQZytH6HK0ekJW5TiOXemh7UCGxMZgiyaAt9dINUXddhOtB/O7w89DXwLHy4nLx36IWzJwsn7jHLSTjMPipW1DF+QGfwzHjqA5VzaUHWNjQ3S39wnLTIuLsPEMgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726486357; c=relaxed/simple;
	bh=ks1Z6Zt5tZ7f32h9uedMQeu3E//CwrI54ZII4uARJM0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TZ5IYIo1l/WY4k4T1ZShLzAYrcMX8nppSR5gFcedsdzoW22d2uZPcD0X7RQqI+hW80GjeKueG0sSjwy10boYjfR1ym8slgtfc2iKGKenMn5CtQDK8Ktu7n5qHmYfYDjddY9ZrlB4qyJdp4+Bo4jBU4IoPTSQMcjmbu78h0hzdUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=hk7ysDl6; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726486356; x=1758022356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cMe1v1ZokVNMH0b3UoTmzNhpYQFLD8f+J2f2juiv+X4=;
  b=hk7ysDl6yZ7tAMPvkReG+Wb9XkKXSgImgAqiWh1AK38nFLmRKTm+Dtc7
   PX1r4yW0lNEYSdYM72S4pYr0f5fOzssTBDF4s5seoFU3dUDJXDqaomBWi
   5nz2YaGf5/uZ/+dx+VuriQ41tD+inkDUHtW34v03TNWYuln+/R+nDdxth
   U=;
X-IronPort-AV: E=Sophos;i="6.10,233,1719878400"; 
   d="scan'208";a="331432668"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2024 11:32:35 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:3128]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.42.185:2525] with esmtp (Farcaster)
 id 4e097c01-0ec2-475e-bf7b-c130f572e46b; Mon, 16 Sep 2024 11:32:34 +0000 (UTC)
X-Farcaster-Flow-ID: 4e097c01-0ec2-475e-bf7b-c130f572e46b
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:32:34 +0000
Received: from u5d18b891348c5b.ant.amazon.com (10.146.13.221) by
 EX19D014EUC004.ant.amazon.com (10.252.51.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 16 Sep 2024 11:32:23 +0000
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
Subject: [RFC PATCH 03/13] iommu/intel: zap context table entries on kexec
Date: Mon, 16 Sep 2024 13:30:52 +0200
Message-ID: <20240916113102.710522-4-jgowans@amazon.com>
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

Instead of fully shutting down the IOMMU on kexec, rather zap context
table entries for devices. This is the initial step to be able to
persist some domains. Once a struct iommu_domain can be marked
persistent then those persistent domains will be skipped when doing the
IOMMU shut down.
---
 drivers/iommu/intel/dmar.c  |  1 +
 drivers/iommu/intel/iommu.c | 34 ++++++++++++++++++++++++++++++----
 drivers/iommu/intel/iommu.h |  2 ++
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 1c8d3141cb55..f79aba382e77 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1099,6 +1099,7 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 	spin_lock_init(&iommu->device_rbtree_lock);
 	mutex_init(&iommu->iopf_lock);
 	iommu->node = NUMA_NO_NODE;
+	INIT_LIST_HEAD(&iommu->domains);
 
 	ver = readl(iommu->reg + DMAR_VER_REG);
 	pr_info("%s: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 9ff8b83c19a3..2297cbb0253f 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1575,6 +1575,7 @@ int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 		goto err_clear;
 	}
 	domain_update_iommu_cap(domain);
+	list_add(&domain->domains, &iommu->domains);
 
 	spin_unlock(&iommu->lock);
 	return 0;
@@ -3185,6 +3186,33 @@ static void intel_disable_iommus(void)
 		iommu_disable_translation(iommu);
 }
 
+static void zap_context_table_entries(struct intel_iommu *iommu)
+{
+	struct context_entry *context;
+	struct dmar_domain *domain;
+	struct device_domain_info *device;
+	int bus, devfn;
+	u16 did_old;
+
+	list_for_each_entry(domain, &iommu->domains, domains) {
+		list_for_each_entry(device, &domain->devices, link) {
+			context = iommu_context_addr(iommu, device->bus, device->devfn, 0);
+			if (!context || !context_present(context))
+				continue;
+			context_domain_id(context);
+			context_clear_entry(context);
+			__iommu_flush_cache(iommu, context, sizeof(*context));
+			iommu->flush.flush_context(iommu,
+						   did_old,
+						   (((u16)bus) << 8) | devfn,
+						   DMA_CCMD_MASK_NOBIT,
+						   DMA_CCMD_DEVICE_INVL);
+			iommu->flush.flush_iotlb(iommu,	did_old, 0, 0,
+						 DMA_TLB_DSI_FLUSH);
+		}
+	}
+}
+
 void intel_iommu_shutdown(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -3197,10 +3225,8 @@ void intel_iommu_shutdown(void)
 
 	/* Disable PMRs explicitly here. */
 	for_each_iommu(iommu, drhd)
-		iommu_disable_protect_mem_regions(iommu);
-
-	/* Make sure the IOMMUs are switched off */
-	intel_disable_iommus();
+		zap_context_table_entries(iommu);
+	return
 
 	up_write(&dmar_global_lock);
 }
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index b67c14da1240..cfd006588824 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -606,6 +606,7 @@ struct dmar_domain {
 	spinlock_t lock;		/* Protect device tracking lists */
 	struct list_head devices;	/* all devices' list */
 	struct list_head dev_pasids;	/* all attached pasids */
+	struct list_head domains;	/* all struct dmar_domains on this IOMMU */
 
 	spinlock_t cache_lock;		/* Protect the cache tag list */
 	struct list_head cache_tags;	/* Cache tag list */
@@ -749,6 +750,7 @@ struct intel_iommu {
 	void *perf_statistic;
 
 	struct iommu_pmu *pmu;
+	struct list_head domains;	/* all struct dmar_domains on this IOMMU */
 };
 
 /* PCI domain-device relationship */
-- 
2.34.1


