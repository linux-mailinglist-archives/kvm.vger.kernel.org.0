Return-Path: <kvm+bounces-70099-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SIAjGQBzgmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70099-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:13:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA69DF20E
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6AAE130F202A
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4A5372B2B;
	Tue,  3 Feb 2026 22:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KCiM12B/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECE5374160
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156603; cv=none; b=kkdFqnjrtIm+3Iiy1J2s78uzP97/Mu+yVZdvB7sZD/a31G48IrobV2lZ6gXx5pAA4RuUQm/I9KKmMNuPyXtwLujqIH6qQ7m6akpxhIguFpEhN7oaPl+1C/p9K1N8yKufJloF9UNPanZ2oZ01BSlatK4dkByjIBecfHlO6qBnFMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156603; c=relaxed/simple;
	bh=9LSa2PONwk7+FcHvoNLiH1UnVTuP4jXRhy/pPDerIH8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rrml25wTLfKbe964SNCzmwvFRQoT60We+/nXc2EtTlLh5XAHyCz+Ci2PeNwJBlxdDCE4/rYOQsKiLy96aQ7moA7ZoMAuJixsNBAa9iuO/u1yb5Nj9VWwMQF3vd8ipIbViHDz8/YeQBO4DxPhr1p3vSL35tO2d7N2LyO29vlV26s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KCiM12B/; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0f47c0e60so33467305ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156600; x=1770761400; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eGH1n4CmJ6QyV+GMAsNpvN02UPxRfAHS78Vd94dCot0=;
        b=KCiM12B/pFSG+zwSv4sSNXvSrDNEM3uem/8E6f9EkC6bjAuFZ6as5K86pO1cHCTaXk
         ECUX3VbBToPuXKQQyGatAs9WeFDcabJvqcRUJN9Fu/F+q+6hitVv1IqgBEYD4PYdE63T
         i3Hu3A++t5w+mKRIQw8sa+VL2GjpkREGLPzff+Azq4BI5x2JoF20FtykSZXGyr/hWW+O
         V3zMjovvv4hgnCdrJJW+JHwejxdOX1JjVkyfIA+m2BOXkQlTQff0uea32SVGrVTeOcLH
         M2WCdDc6b3mYvNCoXQZ7XUHTjk9TPJI4xxZgUhUgQS1qHMtnlkHNGXGIEPEYUvvYZQ1a
         vGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156600; x=1770761400;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGH1n4CmJ6QyV+GMAsNpvN02UPxRfAHS78Vd94dCot0=;
        b=EeYV/yIkGRUo59JqX8ygA8AQKZW4xCIqbcNWvdMxOZ+JxAut6l39jgsnbcVzA2gCFF
         7PxjRDGujW9lNIEH+P5YmwSF1MxisP6WceieCyEbulh2cZvt7Fa47yiixjWmO/ingY9d
         j/Kgn/6j5NElZYyKazC/xJ1C+Ph3OomZaaJiToDYJadmxmn/cFD5nxrCCfhXpgMzVSvk
         rElz+FgtXkCqbDSFV1poavDaURY7LduGveuWRGrTvdItOEcsCf9fmmhNwA4me/lp8n7/
         0El08WJROt3Ep7BjDvGC9A5j2K2K3ixOWCWQR5tdmDLlqmF2mC/MVsxXERXlCOjwWXY1
         /KZQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9/cO94nuISV7Eqoq2c562/21sNNdD1dc1CpCVrBa/xTx0J6Fju/Ofmkep4C9ghEtjL8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFMBkFSbjbbaiIcmDHpJ4YwAR4XBHIYWmPxgjfX5Lqqwh5C1+a
	UctVse4OfkQmrUfN91EX4CIxjq7x4/CB4q43299uXFECgWfGR7jne5XoWcQwOc2ZV1CN7ClbhH+
	Sxs3P1E12PH9o8g==
X-Received: from plbb8.prod.google.com ([2002:a17:903:c08:b0:2a7:cf29:aee1])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e94c:b0:2a7:fe78:a344 with SMTP id d9443c01a7336-2a933cdd07dmr7595525ad.6.1770156600054;
 Tue, 03 Feb 2026 14:10:00 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:40 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-7-skhawaja@google.com>
Subject: [PATCH 06/14] iommu/vt-d: Implement device and iommu
 preserve/unpreserve ops
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>, 
	YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70099-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DFA69DF20E
X-Rspamd-Action: no action

Add implementation of the device and iommu presevation in a separate
file. Also set the device and iommu preserve/unpreserve ops in the
struct iommu_ops.

During normal shutdown the iommu translation is disabled. Since the root
table is preserved during live update, it needs to be cleaned up and the
context entries of the unpreserved devices need to be cleared.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/intel/Makefile     |   1 +
 drivers/iommu/intel/iommu.c      |  47 ++++++++++-
 drivers/iommu/intel/iommu.h      |  27 +++++++
 drivers/iommu/intel/liveupdate.c | 134 +++++++++++++++++++++++++++++++
 4 files changed, 205 insertions(+), 4 deletions(-)
 create mode 100644 drivers/iommu/intel/liveupdate.c

diff --git a/drivers/iommu/intel/Makefile b/drivers/iommu/intel/Makefile
index ada651c4a01b..d38fc101bc35 100644
--- a/drivers/iommu/intel/Makefile
+++ b/drivers/iommu/intel/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_INTEL_IOMMU_DEBUGFS) += debugfs.o
 obj-$(CONFIG_INTEL_IOMMU_SVM) += svm.o
 obj-$(CONFIG_IRQ_REMAP) += irq_remapping.o
 obj-$(CONFIG_INTEL_IOMMU_PERF_EVENTS) += perfmon.o
+obj-$(CONFIG_IOMMU_LIVEUPDATE) += liveupdate.o
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 134302fbcd92..c95de93fb72f 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -16,6 +16,7 @@
 #include <linux/crash_dump.h>
 #include <linux/dma-direct.h>
 #include <linux/dmi.h>
+#include <linux/iommu-lu.h>
 #include <linux/memory.h>
 #include <linux/pci.h>
 #include <linux/pci-ats.h>
@@ -52,6 +53,8 @@ static int rwbf_quirk;
 
 #define rwbf_required(iommu)	(rwbf_quirk || cap_rwbf((iommu)->cap))
 
+static bool __maybe_clean_unpreserved_context_entries(struct intel_iommu *iommu);
+
 /*
  * set to 1 to panic kernel if can't successfully enable VT-d
  * (used when kernel is launched w/ TXT)
@@ -60,8 +63,6 @@ static int force_on = 0;
 static int intel_iommu_tboot_noforce;
 static int no_platform_optin;
 
-#define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
-
 /*
  * Take a root_entry and return the Lower Context Table Pointer (LCTP)
  * if marked present.
@@ -2378,8 +2379,10 @@ void intel_iommu_shutdown(void)
 		/* Disable PMRs explicitly here. */
 		iommu_disable_protect_mem_regions(iommu);
 
-		/* Make sure the IOMMUs are switched off */
-		iommu_disable_translation(iommu);
+		if (!__maybe_clean_unpreserved_context_entries(iommu)) {
+			/* Make sure the IOMMUs are switched off */
+			iommu_disable_translation(iommu);
+		}
 	}
 }
 
@@ -2902,6 +2905,38 @@ static const struct iommu_dirty_ops intel_second_stage_dirty_ops = {
 	.set_dirty_tracking = intel_iommu_set_dirty_tracking,
 };
 
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+static bool __maybe_clean_unpreserved_context_entries(struct intel_iommu *iommu)
+{
+	struct device_domain_info *info;
+	struct pci_dev *pdev = NULL;
+
+	if (!iommu->iommu.outgoing_preserved_state)
+		return false;
+
+	for_each_pci_dev(pdev) {
+		info = dev_iommu_priv_get(&pdev->dev);
+		if (!info)
+			continue;
+
+		if (info->iommu != iommu)
+			continue;
+
+		if (dev_iommu_preserved_state(&pdev->dev))
+			continue;
+
+		domain_context_clear(info);
+	}
+
+	return true;
+}
+#else
+static bool __maybe_clean_unpreserved_context_entries(struct intel_iommu *iommu)
+{
+	return false;
+}
+#endif
+
 static struct iommu_domain *
 intel_iommu_domain_alloc_second_stage(struct device *dev,
 				      struct intel_iommu *iommu, u32 flags)
@@ -3925,6 +3960,10 @@ const struct iommu_ops intel_iommu_ops = {
 	.is_attach_deferred	= intel_iommu_is_attach_deferred,
 	.def_domain_type	= device_def_domain_type,
 	.page_response		= intel_iommu_page_response,
+	.preserve_device	= intel_iommu_preserve_device,
+	.unpreserve_device	= intel_iommu_unpreserve_device,
+	.preserve		= intel_iommu_preserve,
+	.unpreserve		= intel_iommu_unpreserve,
 };
 
 static void quirk_iommu_igfx(struct pci_dev *dev)
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 25c5e22096d4..70032e86437d 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -557,6 +557,8 @@ struct root_entry {
 	u64     hi;
 };
 
+#define ROOT_ENTRY_NR (VTD_PAGE_SIZE / sizeof(struct root_entry))
+
 /*
  * low 64 bits:
  * 0: present
@@ -1276,6 +1278,31 @@ static inline int iopf_for_domain_replace(struct iommu_domain *new,
 	return 0;
 }
 
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+int intel_iommu_preserve_device(struct device *dev, struct device_ser *device_ser);
+void intel_iommu_unpreserve_device(struct device *dev, struct device_ser *device_ser);
+int intel_iommu_preserve(struct iommu_device *iommu, struct iommu_ser *iommu_ser);
+void intel_iommu_unpreserve(struct iommu_device *iommu, struct iommu_ser *iommu_ser);
+#else
+static inline int intel_iommu_preserve_device(struct device *dev, struct device_ser *device_ser)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void intel_iommu_unpreserve_device(struct device *dev, struct device_ser *device_ser)
+{
+}
+
+static inline int intel_iommu_preserve(struct iommu_device *iommu, struct iommu_ser *iommu_ser)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void intel_iommu_unpreserve(struct iommu_device *iommu, struct iommu_ser *iommu_ser)
+{
+}
+#endif
+
 #ifdef CONFIG_INTEL_IOMMU_SVM
 void intel_svm_check(struct intel_iommu *iommu);
 struct iommu_domain *intel_svm_domain_alloc(struct device *dev,
diff --git a/drivers/iommu/intel/liveupdate.c b/drivers/iommu/intel/liveupdate.c
new file mode 100644
index 000000000000..82ba1daf1711
--- /dev/null
+++ b/drivers/iommu/intel/liveupdate.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (C) 2025, Google LLC
+ * Author: Samiullah Khawaja <skhawaja@google.com>
+ */
+
+#define pr_fmt(fmt)    "iommu: liveupdate: " fmt
+
+#include <linux/kexec_handover.h>
+#include <linux/liveupdate.h>
+#include <linux/iommu-lu.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "iommu.h"
+#include "../iommu-pages.h"
+
+static void unpreserve_iommu_context(struct intel_iommu *iommu, int end)
+{
+	struct context_entry *context;
+	int i;
+
+	if (end < 0)
+		end = ROOT_ENTRY_NR;
+
+	for (i = 0; i < end; i++) {
+		context = iommu_context_addr(iommu, i, 0, 0);
+		if (context)
+			iommu_unpreserve_page(context);
+
+		if (!sm_supported(iommu))
+			continue;
+
+		context = iommu_context_addr(iommu, i, 0x80, 0);
+		if (context)
+			iommu_unpreserve_page(context);
+	}
+}
+
+static int preserve_iommu_context(struct intel_iommu *iommu)
+{
+	struct context_entry *context;
+	int ret;
+	int i;
+
+	for (i = 0; i < ROOT_ENTRY_NR; i++) {
+		context = iommu_context_addr(iommu, i, 0, 0);
+		if (context) {
+			ret = iommu_preserve_page(context);
+			if (ret)
+				goto error;
+		}
+
+		if (!sm_supported(iommu))
+			continue;
+
+		context = iommu_context_addr(iommu, i, 0x80, 0);
+		if (context) {
+			ret = iommu_preserve_page(context);
+			if (ret)
+				goto error_sm;
+		}
+	}
+
+	return 0;
+
+error_sm:
+	context = iommu_context_addr(iommu, i, 0, 0);
+	iommu_unpreserve_page(context);
+error:
+	unpreserve_iommu_context(iommu, i);
+	return ret;
+}
+
+int intel_iommu_preserve_device(struct device *dev, struct device_ser *device_ser)
+{
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
+
+	if (!dev_is_pci(dev))
+		return -EOPNOTSUPP;
+
+	if (!info)
+		return -EINVAL;
+
+	device_ser->domain_iommu_ser.did = domain_id_iommu(info->domain, info->iommu);
+	return 0;
+}
+
+void intel_iommu_unpreserve_device(struct device *dev, struct device_ser *device_ser)
+{
+}
+
+int intel_iommu_preserve(struct iommu_device *iommu_dev, struct iommu_ser *ser)
+{
+	struct intel_iommu *iommu;
+	int ret;
+
+	iommu = container_of(iommu_dev, struct intel_iommu, iommu);
+
+	spin_lock(&iommu->lock);
+	ret = preserve_iommu_context(iommu);
+	if (ret)
+		goto err;
+
+	ret = iommu_preserve_page(iommu->root_entry);
+	if (ret) {
+		unpreserve_iommu_context(iommu, -1);
+		goto err;
+	}
+
+	ser->intel.phys_addr = iommu->reg_phys;
+	ser->intel.root_table = __pa(iommu->root_entry);
+	ser->type = IOMMU_INTEL;
+	ser->token = ser->intel.phys_addr;
+	spin_unlock(&iommu->lock);
+
+	return 0;
+err:
+	spin_unlock(&iommu->lock);
+	return ret;
+}
+
+void intel_iommu_unpreserve(struct iommu_device *iommu_dev, struct iommu_ser *iommu_ser)
+{
+	struct intel_iommu *iommu;
+
+	iommu = container_of(iommu_dev, struct intel_iommu, iommu);
+
+	spin_lock(&iommu->lock);
+	unpreserve_iommu_context(iommu, -1);
+	iommu_unpreserve_page(iommu->root_entry);
+	spin_unlock(&iommu->lock);
+}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


