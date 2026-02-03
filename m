Return-Path: <kvm+bounces-70101-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +FNlMClzgmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70101-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:14:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF66DF22B
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E7D730F8BFE
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5687337F0FB;
	Tue,  3 Feb 2026 22:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TXZ0+F6o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ED737D11A
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156605; cv=none; b=QkSi3bG0HPh5c0CUTS/FZ0VKyqVrRWRoCQKibNf9b8phqY2Y0ZcgupQecMF+c99FxsIjyePLUGaluH69gZ5w/5F2mVQRYY+MaLFIWUrbmylebyqctvhunLVp4y7uT624YumHh6XPCas1BD40wA4qtuXW6JvMNmzxgvpbpSGMKcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156605; c=relaxed/simple;
	bh=Rz4XRn9dLnn8NMZc+hztQghLkCsGuHOtgIhEzdWTtVY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J1Zf1LDtYX10mDUedR5YSy2/i9A2+pR022mjMfmMOQiEJtQEUuD6F0ozvYu3P5gFY+c9gL63AGpw311E52hXcm8lk6oBYSuwBj+cBXkyBuFzQ7l1Nilqv4OOpAyd0j/QEFrfhpubnivO7uQuihSlTBg0ciKpsJLsBGPjVRysCh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TXZ0+F6o; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c551e6fe4b4so3904480a12.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156603; x=1770761403; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xjKGYOflzggluFVjGdAa7AEy+g4yCqhubL98cyjiky0=;
        b=TXZ0+F6oMMX7o6JP2Sbwc21vJ8tTsAigVLLmwDmTWGgqjh9G13OIRUs+IjJ3mrtuCC
         azyo4G7Vl1bHr7PER8aSWch8gR7PESevYH8npSt7r675vob5AKtyoIbVQv3Fh/Wu9HbN
         zSrPlsVJYvw41g+qqML1Xz7SXdD/M9Cnh8+UPAsjRodTgerazS0piyhFuq/AffLjH7Dk
         sOLvcSZSEK+v6d3ysKb6dkFdVspZRPxKbl48+rLItKkn/I/rwy3fMqM9ZIcxjCcr3+QR
         +f0MZxL+BB0xLym5LAfV2vHM4GeEAk56Nu64FHfpjete/5js9q7NqdV61sE/3aXXlV88
         OxVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156603; x=1770761403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xjKGYOflzggluFVjGdAa7AEy+g4yCqhubL98cyjiky0=;
        b=GErtiZnw9hOel7/DiDgMYdWdWrqkd/ExpYl4+gI2+ZwdHAmss0TRIT+sSEQRtkiXTt
         gqfyX9/Rc3YW8Dn1E0waQk4TJ8J9kFPOuexD5zVqqL5K5AJI/SRVMZ5roufgAtytasLv
         ip1C86wa7JI/n7Tv1s2w3IGzDhilYLreb49upT0SDEkdBz0DLuo/kGhHD6Hv50pW/1Gw
         FD303ZnmML/rVG8dpItnkEy920ynmBtTKqi2PQ6re9keZdifew8ua/zwxE8NkMNRVTI2
         YehFGjhN8IJLNFe7HmEX8lzz3skDYHnVlKOmv6Gxn6h8ViOjJW4AORiDrkWFe5sSDxLQ
         vskA==
X-Forwarded-Encrypted: i=1; AJvYcCUQIVupcaH/yo1VvjUa4ZepVSew152FtefCrmgEIpmdpiqysheTxxEkjc2/FIIXYtFlu+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgnO0M0uecITC8XJ+z4pKLkjLPEvxV9DeCBs0jZvZ7TNkmHxez
	qjhWcYk4OmaN7K12BDTHESG1pz7gm5GD20y+eal70Fwyg4gK2MK73JZf50yT5Yvo1y+5k+SoJP5
	qac4MAh5GoYhKMg==
X-Received: from pfbhk1.prod.google.com ([2002:a05:6a00:8781:b0:7e5:49a7:f55f])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3905:b0:7a2:7458:7fc8 with SMTP id d2e1a72fcca58-8241c1ad253mr831868b3a.13.1770156603016;
 Tue, 03 Feb 2026 14:10:03 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:42 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-9-skhawaja@google.com>
Subject: [PATCH 08/14] iommu: Restore and reattach preserved domains to devices
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
	TAGGED_FROM(0.00)[bounces-70101-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 3FF66DF22B
X-Rspamd-Action: no action

Restore the preserved domains by restoring the page tables using restore
IOMMU domain op. Reattach the preserved domain to the device during
default domain setup. While attaching, reuse the domain ID that was used
in the previous kernel. The context entry setup is not needed as that is
preserved during liveupdate.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/intel/iommu.c  | 40 ++++++++++++++++++------------
 drivers/iommu/intel/iommu.h  |  3 ++-
 drivers/iommu/intel/nested.c |  2 +-
 drivers/iommu/iommu.c        | 47 ++++++++++++++++++++++++++++++++++--
 drivers/iommu/liveupdate.c   | 31 ++++++++++++++++++++++++
 include/linux/iommu-lu.h     |  8 ++++++
 6 files changed, 112 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 8acb7f8a7627..83faad53f247 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1029,7 +1029,8 @@ static bool first_level_by_default(struct intel_iommu *iommu)
 	return true;
 }
 
-int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
+int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu,
+			int restore_did)
 {
 	struct iommu_domain_info *info, *curr;
 	int num, ret = -ENOSPC;
@@ -1049,8 +1050,11 @@ int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 		return 0;
 	}
 
-	num = ida_alloc_range(&iommu->domain_ida, IDA_START_DID,
-			      cap_ndoms(iommu->cap) - 1, GFP_KERNEL);
+	if (restore_did >= 0)
+		num = restore_did;
+	else
+		num = ida_alloc_range(&iommu->domain_ida, IDA_START_DID,
+				      cap_ndoms(iommu->cap) - 1, GFP_KERNEL);
 	if (num < 0) {
 		pr_err("%s: No free domain ids\n", iommu->name);
 		goto err_unlock;
@@ -1321,10 +1325,14 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 {
 	struct device_domain_info *info = dev_iommu_priv_get(dev);
 	struct intel_iommu *iommu = info->iommu;
+	struct device_ser *device_ser = NULL;
 	unsigned long flags;
 	int ret;
 
-	ret = domain_attach_iommu(domain, iommu);
+	device_ser = dev_iommu_restored_state(dev);
+
+	ret = domain_attach_iommu(domain, iommu,
+				  dev_iommu_restore_did(dev, &domain->domain));
 	if (ret)
 		return ret;
 
@@ -1337,16 +1345,18 @@ static int dmar_domain_attach_device(struct dmar_domain *domain,
 	if (dev_is_real_dma_subdevice(dev))
 		return 0;
 
-	if (!sm_supported(iommu))
-		ret = domain_context_mapping(domain, dev);
-	else if (intel_domain_is_fs_paging(domain))
-		ret = domain_setup_first_level(iommu, domain, dev,
-					       IOMMU_NO_PASID, NULL);
-	else if (intel_domain_is_ss_paging(domain))
-		ret = domain_setup_second_level(iommu, domain, dev,
-						IOMMU_NO_PASID, NULL);
-	else if (WARN_ON(true))
-		ret = -EINVAL;
+	if (!device_ser) {
+		if (!sm_supported(iommu))
+			ret = domain_context_mapping(domain, dev);
+		else if (intel_domain_is_fs_paging(domain))
+			ret = domain_setup_first_level(iommu, domain, dev,
+						       IOMMU_NO_PASID, NULL);
+		else if (intel_domain_is_ss_paging(domain))
+			ret = domain_setup_second_level(iommu, domain, dev,
+							IOMMU_NO_PASID, NULL);
+		else if (WARN_ON(true))
+			ret = -EINVAL;
+	}
 
 	if (ret)
 		goto out_block_translation;
@@ -3630,7 +3640,7 @@ domain_add_dev_pasid(struct iommu_domain *domain,
 	if (!dev_pasid)
 		return ERR_PTR(-ENOMEM);
 
-	ret = domain_attach_iommu(dmar_domain, iommu);
+	ret = domain_attach_iommu(dmar_domain, iommu, -1);
 	if (ret)
 		goto out_free;
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index d7bf63aff17d..057bd6035d85 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1174,7 +1174,8 @@ void __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
  */
 #define QI_OPT_WAIT_DRAIN		BIT(0)
 
-int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
+int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu,
+			int restore_did);
 void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
 void device_block_translation(struct device *dev);
 int paging_domain_compatible(struct iommu_domain *domain, struct device *dev);
diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
index a3fb8c193ca6..4fed9f5981e5 100644
--- a/drivers/iommu/intel/nested.c
+++ b/drivers/iommu/intel/nested.c
@@ -40,7 +40,7 @@ static int intel_nested_attach_dev(struct iommu_domain *domain,
 		return ret;
 	}
 
-	ret = domain_attach_iommu(dmar_domain, iommu);
+	ret = domain_attach_iommu(dmar_domain, iommu, -1);
 	if (ret) {
 		dev_err_ratelimited(dev, "Failed to attach domain to iommu\n");
 		return ret;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index c0632cb5b570..8103b5372364 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/host1x_context_bus.h>
 #include <linux/iommu.h>
+#include <linux/iommu-lu.h>
 #include <linux/iommufd.h>
 #include <linux/idr.h>
 #include <linux/err.h>
@@ -489,6 +490,10 @@ static int iommu_init_device(struct device *dev)
 		goto err_free;
 	}
 
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+	dev->iommu->device_ser = iommu_get_device_preserved_data(dev);
+#endif
+
 	iommu_dev = ops->probe_device(dev);
 	if (IS_ERR(iommu_dev)) {
 		ret = PTR_ERR(iommu_dev);
@@ -2149,6 +2154,13 @@ static int __iommu_attach_device(struct iommu_domain *domain,
 	ret = domain->ops->attach_dev(domain, dev, old);
 	if (ret)
 		return ret;
+
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+	/* The associated state can be unset once restored. */
+	if (dev_iommu_restored_state(dev))
+		WRITE_ONCE(dev->iommu->device_ser, NULL);
+#endif
+
 	dev->iommu->attach_deferred = 0;
 	trace_attach_device_to_domain(dev);
 	return 0;
@@ -3061,6 +3073,34 @@ int iommu_fwspec_add_ids(struct device *dev, const u32 *ids, int num_ids)
 }
 EXPORT_SYMBOL_GPL(iommu_fwspec_add_ids);
 
+static struct iommu_domain *__iommu_group_maybe_restore_domain(struct iommu_group *group)
+{
+	struct device_ser *device_ser;
+	struct iommu_domain *domain;
+	struct device *dev;
+
+	dev = iommu_group_first_dev(group);
+	if (!dev_is_pci(dev))
+		return NULL;
+
+	device_ser = dev_iommu_restored_state(dev);
+	if (!device_ser)
+		return NULL;
+
+	domain = iommu_restore_domain(dev, device_ser);
+	if (WARN_ON(IS_ERR(domain)))
+		return NULL;
+
+	/*
+	 * The group is owned by the entity (a preserved iommufd) that provided
+	 * this token in the previous kernel. It will be used to reclaim it
+	 * later.
+	 */
+	group->owner = (void *)device_ser->token;
+	group->owner_cnt = 1;
+	return domain;
+}
+
 /**
  * iommu_setup_default_domain - Set the default_domain for the group
  * @group: Group to change
@@ -3075,8 +3115,8 @@ static int iommu_setup_default_domain(struct iommu_group *group,
 				      int target_type)
 {
 	struct iommu_domain *old_dom = group->default_domain;
+	struct iommu_domain *dom, *restored_domain;
 	struct group_device *gdev;
-	struct iommu_domain *dom;
 	bool direct_failed;
 	int req_type;
 	int ret;
@@ -3120,6 +3160,9 @@ static int iommu_setup_default_domain(struct iommu_group *group,
 	/* We must set default_domain early for __iommu_device_set_domain */
 	group->default_domain = dom;
 	if (!group->domain) {
+		restored_domain = __iommu_group_maybe_restore_domain(group);
+		if (!restored_domain)
+			restored_domain = dom;
 		/*
 		 * Drivers are not allowed to fail the first domain attach.
 		 * The only way to recover from this is to fail attaching the
@@ -3127,7 +3170,7 @@ static int iommu_setup_default_domain(struct iommu_group *group,
 		 * in group->default_domain so it is freed after.
 		 */
 		ret = __iommu_group_set_domain_internal(
-			group, dom, IOMMU_SET_DOMAIN_MUST_SUCCEED);
+			group, restored_domain, IOMMU_SET_DOMAIN_MUST_SUCCEED);
 		if (WARN_ON(ret))
 			goto out_free_old;
 	} else {
diff --git a/drivers/iommu/liveupdate.c b/drivers/iommu/liveupdate.c
index 83eb609b3fd7..6b211436ad25 100644
--- a/drivers/iommu/liveupdate.c
+++ b/drivers/iommu/liveupdate.c
@@ -501,3 +501,34 @@ void iommu_unpreserve_device(struct iommu_domain *domain, struct device *dev)
 
 	iommu_unpreserve_locked(iommu->iommu_dev);
 }
+
+struct iommu_domain *iommu_restore_domain(struct device *dev, struct device_ser *ser)
+{
+	struct iommu_domain_ser *domain_ser;
+	struct iommu_lu_flb_obj *flb_obj;
+	struct iommu_domain *domain;
+	int ret;
+
+	domain_ser = __va(ser->domain_iommu_ser.domain_phys);
+
+	ret = liveupdate_flb_get_incoming(&iommu_flb, (void **)&flb_obj);
+	if (ret)
+		return ERR_PTR(ret);
+
+	guard(mutex)(&flb_obj->lock);
+	if (domain_ser->restored_domain)
+		return domain_ser->restored_domain;
+
+	domain_ser->obj.incoming =  true;
+	domain = iommu_paging_domain_alloc(dev);
+	if (IS_ERR(domain))
+		return domain;
+
+	ret = domain->ops->restore(domain, domain_ser);
+	if (ret)
+		return ERR_PTR(ret);
+
+	domain->preserved_state = domain_ser;
+	domain_ser->restored_domain = domain;
+	return domain;
+}
diff --git a/include/linux/iommu-lu.h b/include/linux/iommu-lu.h
index 48c07514a776..4879abaf83d3 100644
--- a/include/linux/iommu-lu.h
+++ b/include/linux/iommu-lu.h
@@ -65,6 +65,8 @@ static inline int dev_iommu_restore_did(struct device *dev, struct iommu_domain
 	return -1;
 }
 
+struct iommu_domain *iommu_restore_domain(struct device *dev,
+					  struct device_ser *ser);
 int iommu_for_each_preserved_device(iommu_preserved_device_iter_fn fn,
 				    void *arg);
 struct device_ser *iommu_get_device_preserved_data(struct device *dev);
@@ -95,6 +97,12 @@ static inline void *iommu_domain_restored_state(struct iommu_domain *domain)
 	return NULL;
 }
 
+static inline struct iommu_domain *iommu_restore_domain(struct device *dev,
+							struct device_ser *ser)
+{
+	return NULL;
+}
+
 static inline int iommu_for_each_preserved_device(iommu_preserved_device_iter_fn fn, void *arg)
 {
 	return -EOPNOTSUPP;
-- 
2.53.0.rc2.204.g2597b5adb4-goog


