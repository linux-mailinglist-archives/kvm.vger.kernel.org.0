Return-Path: <kvm+bounces-14397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B56E8A28FB
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E5B81C22164
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96229502AB;
	Fri, 12 Apr 2024 08:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b8KiedL/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5014B50279
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712909724; cv=none; b=eM/fZZyL+oxKEmke03vWzIt5qf8m6mHn1tM0bh0qX2GmJsgByiaa2N/BUFWUg1j/7oCZX9hUOWdKOLKOS6OeQmOIZ2aaRFrhfndxfea7sAYQKkymOwYbcVAlxwxKVMTczxZwrht6K+2sh0oqdIvawacyZlk+j0ecva+qXnAISpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712909724; c=relaxed/simple;
	bh=aYYQQq2hSnK4fvPIGonGJcOfD68/B6uLV2j4kUlorE4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hGGaYdF8RLge7XT0TLSMwAA9ke0+KMxsbmhKF2EkjYuq8o8brhplpC0++GE0NFVR3YC98v+wynKAT7z789y0Qc3+xn7cqAQbU6EhZvixIcNnEzvssg7iO3DM3dx+G1VHPIFjpHxgz7ZwHdVp+3fB4HrO1TUvL0mCiNeQrWQ9EOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b8KiedL/; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712909724; x=1744445724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aYYQQq2hSnK4fvPIGonGJcOfD68/B6uLV2j4kUlorE4=;
  b=b8KiedL/rvpEmykNE/rwDC0d0Gu+zYOk+ZHG8E4V9blHtNfSSbQ1BPF0
   9UPaVkDqG/9sD5jAXN83EkwhICcuHT/iT5YU6IDEaaNW7oOun8T0PO58y
   baNhmPWqzDhTqH3o4V5xCGctKcE3wM3L6qoxIuue2nmg31G7QIF0oRMey
   TSUeUrQh3d7N4KWd/3zMuHtvKKm/hNv35PNUurU/enZSSxA7SI+eh/SPP
   9Zc+VX7zDUka5x1hJogPM+LimzP31kUdXm2xGhE2MBfCwncaTMCAdQ135
   503vAeAhhsSA8Q8DDURPU7raxW80UiajeL8l/P46Wn18BbEHlEvflH0HQ
   w==;
X-CSE-ConnectionGUID: cWCBnykXRIGwp8QOz5/CaA==
X-CSE-MsgGUID: e7+RKpz7Rbucc8Du9BO89Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8465048"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8465048"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:15:24 -0700
X-CSE-ConnectionGUID: pLHnWCAXSSOIZ6loBWFsqg==
X-CSE-MsgGUID: 8YqasCllQ5Cr3kJrPulyGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="52137795"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa002.jf.intel.com with ESMTP; 12 Apr 2024 01:15:23 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com
Subject: [PATCH v2 03/12] iommufd: replace attach_fn with a structure
Date: Fri, 12 Apr 2024 01:15:07 -0700
Message-Id: <20240412081516.31168-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412081516.31168-1-yi.l.liu@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Most of the core logic before conducting the actual device attach/
replace operation can be shared with pasid attach/replace. Create
a new structure so more information (e.g. pasid) can be later added
along with the attach_fn.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/device.c          | 33 ++++++++++++++++---------
 drivers/iommu/iommufd/iommufd_private.h |  8 ++++++
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 873630c111c1..56e4b8e776c9 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -531,8 +531,11 @@ iommufd_device_do_replace(struct iommufd_device *idev,
 	return ERR_PTR(rc);
 }
 
-typedef struct iommufd_hw_pagetable *(*attach_fn)(
-	struct iommufd_device *idev, struct iommufd_hw_pagetable *hwpt);
+static struct iommufd_hw_pagetable *do_attach(struct iommufd_device *idev,
+		struct iommufd_hw_pagetable *hwpt, struct attach_data *data)
+{
+	return data->attach_fn(idev, hwpt);
+}
 
 /*
  * When automatically managing the domains we search for a compatible domain in
@@ -542,7 +545,7 @@ typedef struct iommufd_hw_pagetable *(*attach_fn)(
 static struct iommufd_hw_pagetable *
 iommufd_device_auto_get_domain(struct iommufd_device *idev,
 			       struct iommufd_ioas *ioas, u32 *pt_id,
-			       attach_fn do_attach)
+			       struct attach_data *data)
 {
 	/*
 	 * iommufd_hw_pagetable_attach() is called by
@@ -551,7 +554,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 	 * to use the immediate_attach path as it supports drivers that can't
 	 * directly allocate a domain.
 	 */
-	bool immediate_attach = do_attach == iommufd_device_do_attach;
+	bool immediate_attach = data->attach_fn == iommufd_device_do_attach;
 	struct iommufd_hw_pagetable *destroy_hwpt;
 	struct iommufd_hwpt_paging *hwpt_paging;
 	struct iommufd_hw_pagetable *hwpt;
@@ -569,7 +572,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 		hwpt = &hwpt_paging->common;
 		if (!iommufd_lock_obj(&hwpt->obj))
 			continue;
-		destroy_hwpt = (*do_attach)(idev, hwpt);
+		destroy_hwpt = do_attach(idev, hwpt, data);
 		if (IS_ERR(destroy_hwpt)) {
 			iommufd_put_object(idev->ictx, &hwpt->obj);
 			/*
@@ -596,7 +599,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 	hwpt = &hwpt_paging->common;
 
 	if (!immediate_attach) {
-		destroy_hwpt = (*do_attach)(idev, hwpt);
+		destroy_hwpt = do_attach(idev, hwpt, data);
 		if (IS_ERR(destroy_hwpt))
 			goto out_abort;
 	} else {
@@ -618,7 +621,7 @@ iommufd_device_auto_get_domain(struct iommufd_device *idev,
 }
 
 static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
-				    attach_fn do_attach)
+				    struct attach_data *data)
 {
 	struct iommufd_hw_pagetable *destroy_hwpt;
 	struct iommufd_object *pt_obj;
@@ -633,7 +636,7 @@ static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 		struct iommufd_hw_pagetable *hwpt =
 			container_of(pt_obj, struct iommufd_hw_pagetable, obj);
 
-		destroy_hwpt = (*do_attach)(idev, hwpt);
+		destroy_hwpt = do_attach(idev, hwpt, data);
 		if (IS_ERR(destroy_hwpt))
 			goto out_put_pt_obj;
 		break;
@@ -643,7 +646,7 @@ static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 			container_of(pt_obj, struct iommufd_ioas, obj);
 
 		destroy_hwpt = iommufd_device_auto_get_domain(idev, ioas, pt_id,
-							      do_attach);
+							      data);
 		if (IS_ERR(destroy_hwpt))
 			goto out_put_pt_obj;
 		break;
@@ -679,8 +682,11 @@ static int iommufd_device_change_pt(struct iommufd_device *idev, u32 *pt_id,
 int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id)
 {
 	int rc;
+	struct attach_data data = {
+		.attach_fn = &iommufd_device_do_attach,
+	};
 
-	rc = iommufd_device_change_pt(idev, pt_id, &iommufd_device_do_attach);
+	rc = iommufd_device_change_pt(idev, pt_id, &data);
 	if (rc)
 		return rc;
 
@@ -710,8 +716,11 @@ EXPORT_SYMBOL_NS_GPL(iommufd_device_attach, IOMMUFD);
  */
 int iommufd_device_replace(struct iommufd_device *idev, u32 *pt_id)
 {
-	return iommufd_device_change_pt(idev, pt_id,
-					&iommufd_device_do_replace);
+	struct attach_data data = {
+		.attach_fn = &iommufd_device_do_replace,
+	};
+
+	return iommufd_device_change_pt(idev, pt_id, &data);
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_replace, IOMMUFD);
 
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 991f864d1f9b..22f0b9a3df36 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -408,6 +408,14 @@ iommufd_get_device(struct iommufd_ucmd *ucmd, u32 id)
 void iommufd_device_destroy(struct iommufd_object *obj);
 int iommufd_get_hw_info(struct iommufd_ucmd *ucmd);
 
+struct attach_data {
+	union {
+		struct iommufd_hw_pagetable *(*attach_fn)(
+				struct iommufd_device *idev,
+				struct iommufd_hw_pagetable *hwpt);
+	};
+};
+
 struct iommufd_access {
 	struct iommufd_object obj;
 	struct iommufd_ctx *ictx;
-- 
2.34.1


