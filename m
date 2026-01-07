Return-Path: <kvm+bounces-67265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A687ACFFF4B
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 21:18:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AE0523007C35
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B89333893A;
	Wed,  7 Jan 2026 20:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="olMo5wlg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAAF331A4C
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817086; cv=none; b=UfLR3s23jsrx+x6QxffbLFf9fIMjgsKr9ZRWaYz2uk/TRCcoizRYR9UgUSXSnmKgb9MmRKdoJhLBSpew3XV1YBHf9iDtnRsKMLvNX5RpSmdD//3iZTDYnJYhdkgNIbFcu5f32ogj55kDiwlWfSrGtA8TJCHd0SkH7ffLnfwsL48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817086; c=relaxed/simple;
	bh=98LSmDyrncFN4yAfUmC/lF2S2QLQXjk1Mnqe7MNMAYA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TgUE/nwdaHbtfc9AAPApcgeLdiRV2FIvHuFyyEkeLR0mG2OJv9AW09mWCaTT4jVrXfSscnp+RNcYAV3a1X3Hf3lu5f6MESoDLavU9MtUlIuHk6ZDxDXSGIqOpf4mm8IkZWruAcimIhDYF0IFNV/TP8SbZhTUfkBGIknvGOhcigQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=olMo5wlg; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso4664053a91.0
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767817084; x=1768421884; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=igY4dYldp2fGVYjzSgtn3dTLLodbnD38eUgrWzBU1Xo=;
        b=olMo5wlgg3uUQeWFscH3hdCYprnUJbboyvc1+zaIQHbu9jw3samGNMdfuzWOtXiCBi
         J/6BxMLoNFVTqNv+bXrKTOvTIjfja23InlyF0lnbtlZvhY9YmwAADMx3sy28epU6vH61
         pwranRAMrh6kFjuN6RjL995lvVBOy5MFypQDAHT/DPKG6uDGRzLl1EaSK6qwQkNoY2Lr
         9I3veejyM68IzSuDDHuHSkSNMB/RX/yDptSfwzH42M1vhlKagCLjxFophuLq2bwc2+oF
         bAKmNvEBxdguZYxUQHLta3TV0jZYPT3AedhH0aV2qX+M5rxytyaG2Ri8BAzZxVXG6MLb
         PPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817084; x=1768421884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=igY4dYldp2fGVYjzSgtn3dTLLodbnD38eUgrWzBU1Xo=;
        b=chhVmDQhre3N3lLZowM2x+pdxnzKTOTj54EW8XnCH2AbTNrTb2vKp1Nne8wf0+ty3y
         dW6A7xMyb7BrXeVanXpcq1auUhco3Vj/vmofqaS+PkW/A1xzBY+KGotggGpzGEuaIPnR
         ASr6iC6B1Z+hHOasr5NF8oW07tgNYJDoGxi7XcNja15Z6Syh7/5ZzesThVbcYuMDFd/W
         hGUnpNKBay5JJpaap/mj8ZURrIWGnQMeyDeQnudRjOA2Wfhg66Icz15qqBD1T0AR3VDS
         cvfGJ8VzZwaY7cd3dUFnxiBNq4sp5MYyh1Q+jBg5ugaxTDzDhMtVkZvbm3VPBh8TKikA
         RIEw==
X-Forwarded-Encrypted: i=1; AJvYcCWceiOTYVNeo5Obgg1ZsEHTOzfEvaAIXOraVBuAqoPj5rMcmNntfaKUlQiKTdUshYOev7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXEEV9OXdys/5z8I+VFtKbtpPL/mdHEDbmpuf2ePlayPe0StCR
	MQAgXkvpzeoUDOlgg9aS0hHQIbl8mqJy09zaPpb+P07LYP1EA3jua/sOnNbvHdtmGOth4SlFNg9
	M2Hx46pcnIVZmGQ==
X-Google-Smtp-Source: AGHT+IHfXVop97/Vz192HqH+eaT1EXDIWQ0CMkd2UMbL7Q1pQUtgV9kwq04SG9DCOLRooq67paZ2vlfZ5GXHcw==
X-Received: from pjcc11.prod.google.com ([2002:a17:90b:574b:b0:34c:c510:f186])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:544f:b0:343:7714:4ca8 with SMTP id 98e67ed59e1d1-34f68c94494mr3403970a91.15.1767817084253;
 Wed, 07 Jan 2026 12:18:04 -0800 (PST)
Date: Wed,  7 Jan 2026 20:17:58 +0000
In-Reply-To: <20260107201800.2486137-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260107201800.2486137-1-skhawaja@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260107201800.2486137-2-skhawaja@google.com>
Subject: [PATCH 1/3] iommu/vt-d: Allow replacing no_pasid iommu_domain
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	David Matlack <dmatlack@google.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

Intel IOMMU driver already supports replacing IOMMU domains attachments
with PASIDs. Add support for replacing a domain attached with no_pasid.
This includes replacing domains in legacy mode.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/intel/iommu.c | 107 ++++++++++++++++++++++++++----------
 1 file changed, 77 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 134302fbcd92..c0e359fd3ee1 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1140,6 +1140,7 @@ static void context_present_cache_flush(struct intel_iommu *iommu, u16 did,
 }
 
 static int domain_context_mapping_one(struct dmar_domain *domain,
+				      struct dmar_domain *old_domain,
 				      struct intel_iommu *iommu,
 				      u8 bus, u8 devfn)
 {
@@ -1148,7 +1149,8 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	u16 did = domain_id_iommu(domain, iommu);
 	int translation = CONTEXT_TT_MULTI_LEVEL;
 	struct pt_iommu_vtdss_hw_info pt_info;
-	struct context_entry *context;
+	struct context_entry *context, new_context;
+	u16 did_old;
 	int ret;
 
 	if (WARN_ON(!intel_domain_is_ss_paging(domain)))
@@ -1166,26 +1168,44 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 		goto out_unlock;
 
 	ret = 0;
-	if (context_present(context) && !context_copied(iommu, bus, devfn))
+	if (!old_domain && (context_present(context) && !context_copied(iommu, bus, devfn)))
 		goto out_unlock;
 
+	if (old_domain) {
+		did_old = context_domain_id(context);
+		WARN_ON(did_old != domain_id_iommu(old_domain, iommu));
+	}
+
 	copied_context_tear_down(iommu, context, bus, devfn);
-	context_clear_entry(context);
-	context_set_domain_id(context, did);
+	context_set_domain_id(&new_context, did);
 
 	if (info && info->ats_supported)
 		translation = CONTEXT_TT_DEV_IOTLB;
 	else
 		translation = CONTEXT_TT_MULTI_LEVEL;
 
-	context_set_address_root(context, pt_info.ssptptr);
-	context_set_address_width(context, pt_info.aw);
-	context_set_translation_type(context, translation);
-	context_set_fault_enable(context);
-	context_set_present(context);
+	context_set_address_root(&new_context, pt_info.ssptptr);
+	context_set_address_width(&new_context, pt_info.aw);
+	context_set_translation_type(&new_context, translation);
+	context_set_fault_enable(&new_context);
+	context_set_present(&new_context);
+
+	*context = new_context;
 	if (!ecap_coherent(iommu->ecap))
 		clflush_cache_range(context, sizeof(*context));
-	context_present_cache_flush(iommu, did, bus, devfn);
+
+	/*
+	 * Spec 6.5.3.3, changing a present context entry requires,
+	 * - IOTLB invalidation for each effected Domain.
+	 * - Issue Device IOTLB invalidation for function.
+	 */
+	if (old_domain) {
+		intel_context_flush_no_pasid(info, context, did);
+		intel_context_flush_no_pasid(info, context, did_old);
+	} else {
+		context_present_cache_flush(iommu, did, bus, devfn);
+	}
+
 	ret = 0;
 
 out_unlock:
@@ -1194,30 +1214,39 @@ static int domain_context_mapping_one(struct dmar_domain *domain,
 	return ret;
 }
 
+struct domain_context_mapping_data {
+	struct dmar_domain *domain;
+	struct dmar_domain *old_domain;
+};
+
 static int domain_context_mapping_cb(struct pci_dev *pdev,
 				     u16 alias, void *opaque)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(&pdev->dev);
 	struct intel_iommu *iommu = info->iommu;
-	struct dmar_domain *domain = opaque;
+	struct domain_context_mapping_data *data = opaque;
 
-	return domain_context_mapping_one(domain, iommu,
+	return domain_context_mapping_one(data->domain, data->old_domain, iommu,
 					  PCI_BUS_NUM(alias), alias & 0xff);
 }
 
 static int
-domain_context_mapping(struct dmar_domain *domain, struct device *dev)
+domain_context_mapping(struct dmar_domain *domain,
+		       struct dmar_domain *old_domain, struct device *dev)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
 	u8 bus = info->bus, devfn = info->devfn;
+	struct domain_context_mapping_data data;
 	int ret;
 
 	if (!dev_is_pci(dev))
-		return domain_context_mapping_one(domain, iommu, bus, devfn);
+		return domain_context_mapping_one(domain, old_domain, iommu, bus, devfn);
 
+	data.domain = domain;
+	data.old_domain = old_domain;
 	ret = pci_for_each_dma_alias(to_pci_dev(dev),
-				     domain_context_mapping_cb, domain);
+				     domain_context_mapping_cb, &data);
 	if (ret)
 		return ret;
 
@@ -1309,18 +1338,28 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
 					  pt_info.gcr3_pt, flags, old);
 }
 
-static int dmar_domain_attach_device(struct dmar_domain *domain,
-				     struct device *dev)
+static int device_replace_dmar_domain(struct dmar_domain *domain,
+				      struct dmar_domain *old_domain,
+				      struct device *dev)
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
 	unsigned long flags;
 	int ret;
 
+	if (old_domain && dev_is_real_dma_subdevice(dev))
+		return -EOPNOTSUPP;
+
 	ret = domain_attach_iommu(domain, iommu);
 	if (ret)
 		return ret;
 
+	if (old_domain) {
+		spin_lock_irqsave(&info->domain->lock, flags);
+		list_del(&info->link);
+		spin_unlock_irqrestore(&info->domain->lock, flags);
+	}
+
 	info->domain = domain;
 	info->domain_attached = true;
 	spin_lock_irqsave(&domain->lock, flags);
@@ -1331,27 +1370,27 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 		return 0;
 
 	if (!sm_supported(iommu))
-		ret = domain_context_mapping(domain, dev);
+		ret = domain_context_mapping(domain, old_domain, dev);
 	else if (intel_domain_is_fs_paging(domain))
 		ret = domain_setup_first_level(iommu, domain, dev,
-					       IOMMU_NO_PASID, NULL);
+					       IOMMU_NO_PASID, &old_domain->domain);
 	else if (intel_domain_is_ss_paging(domain))
 		ret = domain_setup_second_level(iommu, domain, dev,
-						IOMMU_NO_PASID, NULL);
+						IOMMU_NO_PASID, &old_domain->domain);
 	else if (WARN_ON(true))
 		ret = -EINVAL;
 
-	if (ret)
-		goto out_block_translation;
+	if (!ret)
+		ret = cache_tag_assign_domain(domain, dev, IOMMU_NO_PASID);
 
-	ret = cache_tag_assign_domain(domain, dev, IOMMU_NO_PASID);
 	if (ret)
-		goto out_block_translation;
+		device_block_translation(dev);
 
-	return 0;
+	if (old_domain) {
+		cache_tag_unassign_domain(old_domain, dev, IOMMU_NO_PASID);
+		domain_detach_iommu(old_domain, iommu);
+	}
 
-out_block_translation:
-	device_block_translation(dev);
 	return ret;
 }
 
@@ -3127,19 +3166,27 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 				     struct device *dev,
 				     struct iommu_domain *old)
 {
+	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	int ret;
 
-	device_block_translation(dev);
+	if (dev_is_real_dma_subdevice(dev) ||
+	    domain->type != __IOMMU_DOMAIN_PAGING ||
+	    !info->domain || &info->domain->domain != old)
+		old = NULL;
+
+	if (!old)
+		device_block_translation(dev);
 
 	ret = paging_domain_compatible(domain, dev);
 	if (ret)
 		return ret;
 
-	ret = iopf_for_domain_set(domain, dev);
+	ret = iopf_for_domain_replace(domain, old, dev);
 	if (ret)
 		return ret;
 
-	ret = dmar_domain_attach_device(to_dmar_domain(domain), dev);
+	ret = device_replace_dmar_domain(to_dmar_domain(domain),
+					 old ? to_dmar_domain(old) : NULL, dev);
 	if (ret)
 		iopf_for_domain_remove(domain, dev);
 
-- 
2.52.0.351.gbe84eed79e-goog


