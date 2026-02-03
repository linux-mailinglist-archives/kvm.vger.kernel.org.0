Return-Path: <kvm+bounces-70100-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CMVyEJ9ygmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70100-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:11:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D89DF1C8
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:11:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8B6E630420AA
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF74E37E2F4;
	Tue,  3 Feb 2026 22:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qV5463o/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE1F37107B
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156604; cv=none; b=W73h5MBoONE19dwvVyO7Cz76HyGMfmqfn4PAI9pAq078JozMUJFAjSz5ueRPsnTfnvTR+2OXfVo5BgueE+YweO9a0ALN+CxHgvqFX9T2oonsMKwh+m3TurI9OFoLv5ili3B11GcxTfX7uHgltezHSd+3FKMHC2ghuwRTg83dvSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156604; c=relaxed/simple;
	bh=qPSLNvG5EvI+RYNmb6EVFUAJ74gpknCj2QGMG3t3XLU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t+Vyp0aGl/Oxd01cjb4g2R6rCr32+uN4XP1/luSKo5vcrH6DTR0nGcVX/xVtbKV8YGGglUMSkXlNfmbDbj8YyLFML3S0T80hyimW642m6L/1Pj1UnDEnbaQdvcrQN5YmSeMD+Muc/3wioYPIBVjwScqA9RuP2sRRBQRe14xLhPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qV5463o/; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0f47c0e60so33468365ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156602; x=1770761402; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=laeArOoHMmZZpQbmwN1GpGAXEElz6gu2HEz9aEbOa+M=;
        b=qV5463o/EF5ElAbpmg2OjciKn9xU3F2cSxfAE2emSGhKMBR/knegJgib142oyIDnCY
         BMQf6G5Dbdjls0/OvsRzZmvxLQbTnnYvu6mGrYdOQkwVNh6leJSn8uc03nIK1Md8InLp
         8IZS8rJaisEUggCPIPYw5gAUqVx2JigzO80UXyMrpARUPC+3r8vTG9UZeEqSNUjwk8iO
         wTN3hketVxLpEasgOEAVbkWVADnmLEsu5Rt5vlS//K0kYm8mGFoRvrBVZDTYHAFtqmtW
         fwaop70yKDSOzV+YN1sA65BxC6uufJENzs0Lw6148FM9KgENxYd4QL658MVoO1QJG5FT
         2Mfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156602; x=1770761402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=laeArOoHMmZZpQbmwN1GpGAXEElz6gu2HEz9aEbOa+M=;
        b=FU4Q8D4wQjjxLzkzamamnYuuv4aIALhIs5DBVsASXX8G+IS4EUlIHcvb2d43BPDfZE
         W2DWN+eiOg6R6OrberehIEYB8Fo1iSj2Nc3j5QingtiVvcU5nDEjVpPBtg0Rq765SKEE
         mCxjPUWftbtxYKwPG+hIZ1qyzXDXdTiNVsRw87+RYFTJtXuasHxi9F975tkfv+GYCv1Z
         +PN1VAI+MOmwS0SQl59R0+JiQP02zoH0RDV2LHQyfA+bljHFI1RsKpkqoHCoBRyMEwaO
         R/P95dUd7BkZBmrSCVV3V175SvrYKjrpo64HF7M3fa1Bu+MGxhnqkRhKlXBSMQ9mGVwr
         aGWg==
X-Forwarded-Encrypted: i=1; AJvYcCW6frZIq9L5lgzFPQuw4RVnj9ORtx9jzqiy3+WGm72nF25qAUBcY5ZDOP6nm/W/rexINWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYyoITCs0htf4UVqhqpKuqNjsEsj60C/Hn0f+RFXfd8zEgZiLa
	Syj/vmDXG5jbdlE6/cHVL0r8225smLD1DCyP72EqfAaAz9FQiK+tPJxYEqhbEBSaYmAsJuZBHYe
	qeyLDk3bAYA0rxA==
X-Received: from plbmh14.prod.google.com ([2002:a17:903:9ce:b0:2a0:a0e0:a9c3])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2448:b0:2a8:2c4a:3570 with SMTP id d9443c01a7336-2a933febfb8mr7195225ad.49.1770156601503;
 Tue, 03 Feb 2026 14:10:01 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:41 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-8-skhawaja@google.com>
Subject: [PATCH 07/14] iommu/vt-d: Restore IOMMU state and reclaimed domain ids
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70100-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E4D89DF1C8
X-Rspamd-Action: no action

During boot fetch the preserved state of IOMMU unit and if found then
restore the state.

- Reuse the root_table that was preserved in the previous kernel.
- Reclaim the domain ids of the preserved domains for each preserved
  devices so these are not acquired by another domain.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/intel/iommu.c      | 26 +++++++++++++++------
 drivers/iommu/intel/iommu.h      |  7 ++++++
 drivers/iommu/intel/liveupdate.c | 40 ++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index c95de93fb72f..8acb7f8a7627 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -222,12 +222,12 @@ static void clear_translation_pre_enabled(struct intel_iommu *iommu)
 	iommu->flags &= ~VTD_FLAG_TRANS_PRE_ENABLED;
 }
 
-static void init_translation_status(struct intel_iommu *iommu)
+static void init_translation_status(struct intel_iommu *iommu, bool restoring)
 {
 	u32 gsts;
 
 	gsts = readl(iommu->reg + DMAR_GSTS_REG);
-	if (gsts & DMA_GSTS_TES)
+	if (!restoring && (gsts & DMA_GSTS_TES))
 		iommu->flags |= VTD_FLAG_TRANS_PRE_ENABLED;
 }
 
@@ -670,10 +670,16 @@ void dmar_fault_dump_ptes(struct intel_iommu *iommu, u16 source_id,
 #endif
 
 /* iommu handling */
-static int iommu_alloc_root_entry(struct intel_iommu *iommu)
+static int iommu_alloc_root_entry(struct intel_iommu *iommu, struct iommu_ser *restored_state)
 {
 	struct root_entry *root;
 
+	if (restored_state) {
+		intel_iommu_liveupdate_restore_root_table(iommu, restored_state);
+		__iommu_flush_cache(iommu, iommu->root_entry, ROOT_SIZE);
+		return 0;
+	}
+
 	root = iommu_alloc_pages_node_sz(iommu->node, GFP_ATOMIC, SZ_4K);
 	if (!root) {
 		pr_err("Allocating root entry for %s failed\n",
@@ -1614,6 +1620,7 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 
 static int __init init_dmars(void)
 {
+	struct iommu_ser *iommu_ser = NULL;
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
 	int ret;
@@ -1636,8 +1643,10 @@ static int __init init_dmars(void)
 						   intel_pasid_max_id);
 		}
 
+		iommu_ser = iommu_get_preserved_data(iommu->reg_phys, IOMMU_INTEL);
+
 		intel_iommu_init_qi(iommu);
-		init_translation_status(iommu);
+		init_translation_status(iommu, !!iommu_ser);
 
 		if (translation_pre_enabled(iommu) && !is_kdump_kernel()) {
 			iommu_disable_translation(iommu);
@@ -1651,7 +1660,7 @@ static int __init init_dmars(void)
 		 * we could share the same root & context tables
 		 * among all IOMMU's. Need to Split it later.
 		 */
-		ret = iommu_alloc_root_entry(iommu);
+		ret = iommu_alloc_root_entry(iommu, iommu_ser);
 		if (ret)
 			goto free_iommu;
 
@@ -2110,15 +2119,18 @@ int dmar_parse_one_satc(struct acpi_dmar_header *hdr, void *arg)
 static int intel_iommu_add(struct dmar_drhd_unit *dmaru)
 {
 	struct intel_iommu *iommu = dmaru->iommu;
+	struct iommu_ser *iommu_ser = NULL;
 	int ret;
 
+	iommu_ser = iommu_get_preserved_data(iommu->reg_phys, IOMMU_INTEL);
+
 	/*
 	 * Disable translation if already enabled prior to OS handover.
 	 */
-	if (iommu->gcmd & DMA_GCMD_TE)
+	if (!iommu_ser && iommu->gcmd & DMA_GCMD_TE)
 		iommu_disable_translation(iommu);
 
-	ret = iommu_alloc_root_entry(iommu);
+	ret = iommu_alloc_root_entry(iommu, iommu_ser);
 	if (ret)
 		goto out;
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 70032e86437d..d7bf63aff17d 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1283,6 +1283,8 @@ int intel_iommu_preserve_device(struct device *dev, struct device_ser *device_se
 void intel_iommu_unpreserve_device(struct device *dev, struct device_ser *device_ser);
 int intel_iommu_preserve(struct iommu_device *iommu, struct iommu_ser *iommu_ser);
 void intel_iommu_unpreserve(struct iommu_device *iommu, struct iommu_ser *iommu_ser);
+void intel_iommu_liveupdate_restore_root_table(struct intel_iommu *iommu,
+					       struct iommu_ser *iommu_ser);
 #else
 static inline int intel_iommu_preserve_device(struct device *dev, struct device_ser *device_ser)
 {
@@ -1301,6 +1303,11 @@ static inline int intel_iommu_preserve(struct iommu_device *iommu, struct iommu_
 static inline void intel_iommu_unpreserve(struct iommu_device *iommu, struct iommu_ser *iommu_ser)
 {
 }
+
+static inline void intel_iommu_liveupdate_restore_root_table(struct intel_iommu *iommu,
+							     struct iommu_ser *iommu_ser)
+{
+}
 #endif
 
 #ifdef CONFIG_INTEL_IOMMU_SVM
diff --git a/drivers/iommu/intel/liveupdate.c b/drivers/iommu/intel/liveupdate.c
index 82ba1daf1711..6dcb5783d1db 100644
--- a/drivers/iommu/intel/liveupdate.c
+++ b/drivers/iommu/intel/liveupdate.c
@@ -73,6 +73,46 @@ static int preserve_iommu_context(struct intel_iommu *iommu)
 	return ret;
 }
 
+static void restore_iommu_context(struct intel_iommu *iommu)
+{
+	struct context_entry *context;
+	int i;
+
+	for (i = 0; i < ROOT_ENTRY_NR; i++) {
+		context = iommu_context_addr(iommu, i, 0, 0);
+		if (context)
+			BUG_ON(!kho_restore_folio(virt_to_phys(context)));
+
+		if (!sm_supported(iommu))
+			continue;
+
+		context = iommu_context_addr(iommu, i, 0x80, 0);
+		if (context)
+			BUG_ON(!kho_restore_folio(virt_to_phys(context)));
+	}
+}
+
+static int __restore_used_domain_ids(struct device_ser *ser, void *arg)
+{
+	int id = ser->domain_iommu_ser.did;
+	struct intel_iommu *iommu = arg;
+
+	ida_alloc_range(&iommu->domain_ida, id, id, GFP_ATOMIC);
+	return 0;
+}
+
+void intel_iommu_liveupdate_restore_root_table(struct intel_iommu *iommu,
+					       struct iommu_ser *iommu_ser)
+{
+	BUG_ON(!kho_restore_folio(iommu_ser->intel.root_table));
+	iommu->root_entry = __va(iommu_ser->intel.root_table);
+
+	restore_iommu_context(iommu);
+	iommu_for_each_preserved_device(__restore_used_domain_ids, iommu);
+	pr_info("Restored IOMMU[0x%llx] Root Table at: 0x%llx\n",
+		iommu->reg_phys, iommu_ser->intel.root_table);
+}
+
 int intel_iommu_preserve_device(struct device *dev, struct device_ser *device_ser)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


