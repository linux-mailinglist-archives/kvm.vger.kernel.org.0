Return-Path: <kvm+bounces-30540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E9D9BB5F4
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:26:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E724BB229FD
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518361442F6;
	Mon,  4 Nov 2024 13:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d+olCJhZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7F77081D
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726725; cv=none; b=f6MoUzNhgOZl75HHn6hpVCHuinwMdyueGbouOXfai5TF71N+HFj+hVHXA/X3PCiD0p5ntWyk+1f18QdBbbtEwXZdKTohHDUjg0ZQU8qeCrMFcGJ8Zh24D+knynGYhjg5lCFp2qBtY8Fr6q4j5KhHnYyJumuX+6OIZn5wD06uiHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726725; c=relaxed/simple;
	bh=g0Ysgn1nswOGdstgIKKcp7xxlCOmmcJ+2WoWciak9uw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FCewavwORNnbe3VpfuJyEoOuriIaCe4diAEYq9VfgLC5nmABj8S7hJU/rYbluZ06vJfIc+A5wb+CLWtPsbcVHKm+qsBWsr3behfulv4UrQbXcx9wGqP9GdbFPCyQgFfiU2duGI5EV5QZ/oedAXsK0cmCf+1X8xZydSV7DKkJo2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d+olCJhZ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726724; x=1762262724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g0Ysgn1nswOGdstgIKKcp7xxlCOmmcJ+2WoWciak9uw=;
  b=d+olCJhZqoaeg9OS6I+VPh7yJJ+DmJr42923H7/UwxVZ0C1GPQvbTe1I
   /wQbFP+pkxlxn7HO6244LZ4TKqF9qI/I5dzbKqxgsFpDYMGJzOZsoxvrt
   LXOeuaUiEgRvS9LNeZ5MdS9Z0A6WPqgx3T0gJq80pdyIV2pBTNvMo9lyH
   gggJCUmrRRVeGF2M32rS0Wts+Kb72HSTtwJsr1Y9nDsqjG8zesnQhmLV4
   yGHGJI6/d2UZllE9XprEhUCv//lW8SazpssFzVxS8gQc8QNTxWp2EAODt
   Moyvx2fHVF54rNYFMzDi4eJZi4bBieTuWDNz05NvC6nRR/s+R0cqTjaFr
   g==;
X-CSE-ConnectionGUID: /GLS2N+VSvyJM1Jk5AEwUw==
X-CSE-MsgGUID: cbEVin9XSzav38G6m0MZhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47884076"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47884076"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:25:22 -0800
X-CSE-ConnectionGUID: EfufEWCpShKLgI1aBH4eMQ==
X-CSE-MsgGUID: T1ZxzTKLTtG1iYX7K6DAjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84100469"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:25:20 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: joro@8bytes.org,
	jgg@nvidia.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com
Cc: alex.williamson@redhat.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	zhenzhong.duan@intel.com,
	vasant.hegde@amd.com
Subject: [PATCH v5 09/12] iommufd/selftest: Add set_dev_pasid in mock iommu
Date: Mon,  4 Nov 2024 05:25:10 -0800
Message-Id: <20241104132513.15890-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132513.15890-1-yi.l.liu@intel.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The callback is needed to make pasid_attach/detach path complete for mock
device. A nop is enough for set_dev_pasid.

A MOCK_FLAGS_DEVICE_PASID is added to indicate a pasid-capable mock device
for the pasid test cases. Other test cases will still create a non-pasid
mock device. While the mock iommu always pretends to be pasid-capable.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/iommufd/iommufd_test.h |  1 +
 drivers/iommu/iommufd/selftest.c     | 39 +++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index f4bc23a92f9a..6d532e25b78e 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -47,6 +47,7 @@ enum {
 enum {
 	MOCK_FLAGS_DEVICE_NO_DIRTY = 1 << 0,
 	MOCK_FLAGS_DEVICE_HUGE_IOVA = 1 << 1,
+	MOCK_FLAGS_DEVICE_PASID = 1 << 2,
 };
 
 enum {
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 540437be168a..635d8246691d 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -166,8 +166,16 @@ static int mock_domain_nop_attach(struct iommu_domain *domain,
 	return 0;
 }
 
+static int mock_domain_set_dev_pasid_nop(struct iommu_domain *domain,
+					 struct device *dev, ioasid_t pasid,
+					 struct iommu_domain *old)
+{
+	return 0;
+}
+
 static const struct iommu_domain_ops mock_blocking_ops = {
 	.attach_dev = mock_domain_nop_attach,
+	.set_dev_pasid = mock_domain_set_dev_pasid_nop
 };
 
 static struct iommu_domain mock_blocking_domain = {
@@ -321,19 +329,25 @@ mock_domain_alloc_user(struct device *dev, u32 flags,
 		       struct iommu_domain *parent,
 		       const struct iommu_user_data *user_data)
 {
+	struct mock_dev *mdev = container_of(dev, struct mock_dev, dev);
 	struct mock_iommu_domain *mock_parent;
 	struct iommu_hwpt_selftest user_cfg;
 	int rc;
 
+	if ((flags & IOMMU_HWPT_ALLOC_PASID) &&
+	    (!(mdev->flags & MOCK_FLAGS_DEVICE_PASID) ||
+	     !dev->iommu->iommu_dev->max_pasids))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/* must be mock_domain */
 	if (!parent) {
-		struct mock_dev *mdev = container_of(dev, struct mock_dev, dev);
 		bool has_dirty_flag = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 		bool no_dirty_ops = mdev->flags & MOCK_FLAGS_DEVICE_NO_DIRTY;
 		struct iommu_domain *domain;
 
 		if (flags & (~(IOMMU_HWPT_ALLOC_NEST_PARENT |
-			       IOMMU_HWPT_ALLOC_DIRTY_TRACKING)))
+			       IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
+			       IOMMU_HWPT_ALLOC_PASID)))
 			return ERR_PTR(-EOPNOTSUPP);
 		if (user_data || (has_dirty_flag && no_dirty_ops))
 			return ERR_PTR(-EOPNOTSUPP);
@@ -347,7 +361,8 @@ mock_domain_alloc_user(struct device *dev, u32 flags,
 	}
 
 	/* must be mock_domain_nested */
-	if (user_data->type != IOMMU_HWPT_DATA_SELFTEST || flags)
+	if (user_data->type != IOMMU_HWPT_DATA_SELFTEST ||
+	    flags & ~IOMMU_HWPT_ALLOC_PASID)
 		return ERR_PTR(-EOPNOTSUPP);
 	if (!parent || parent->ops != mock_ops.default_domain_ops)
 		return ERR_PTR(-EINVAL);
@@ -566,6 +581,7 @@ static const struct iommu_ops mock_ops = {
 			.map_pages = mock_domain_map_pages,
 			.unmap_pages = mock_domain_unmap_pages,
 			.iova_to_phys = mock_domain_iova_to_phys,
+			.set_dev_pasid = mock_domain_set_dev_pasid_nop,
 		},
 };
 
@@ -630,6 +646,7 @@ static struct iommu_domain_ops domain_nested_ops = {
 	.free = mock_domain_free_nested,
 	.attach_dev = mock_domain_nop_attach,
 	.cache_invalidate_user = mock_domain_cache_invalidate_user,
+	.set_dev_pasid = mock_domain_set_dev_pasid_nop,
 };
 
 static inline struct iommufd_hw_pagetable *
@@ -690,11 +707,16 @@ static void mock_dev_release(struct device *dev)
 
 static struct mock_dev *mock_dev_create(unsigned long dev_flags)
 {
+	struct property_entry prop[] = {
+		PROPERTY_ENTRY_U32("pasid-num-bits", 20),
+		{},
+	};
 	struct mock_dev *mdev;
 	int rc;
 
 	if (dev_flags &
-	    ~(MOCK_FLAGS_DEVICE_NO_DIRTY | MOCK_FLAGS_DEVICE_HUGE_IOVA))
+	    ~(MOCK_FLAGS_DEVICE_NO_DIRTY |
+		    MOCK_FLAGS_DEVICE_HUGE_IOVA | MOCK_FLAGS_DEVICE_PASID))
 		return ERR_PTR(-EINVAL);
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
@@ -715,6 +737,14 @@ static struct mock_dev *mock_dev_create(unsigned long dev_flags)
 	if (rc)
 		goto err_put;
 
+	if (dev_flags & MOCK_FLAGS_DEVICE_PASID) {
+		rc = device_create_managed_software_node(&mdev->dev, prop, NULL);
+		if (rc) {
+			dev_err(&mdev->dev, "add pasid-num-bits property failed, rc: %d", rc);
+			goto err_put;
+		}
+	}
+
 	rc = device_add(&mdev->dev);
 	if (rc)
 		goto err_put;
@@ -1549,6 +1579,7 @@ int __init iommufd_test_init(void)
 		goto err_sysfs;
 
 	mock_iommu_iopf_queue = iopf_queue_alloc("mock-iopfq");
+	mock_iommu_device.max_pasids = (1 << 20);
 
 	return 0;
 
-- 
2.34.1


