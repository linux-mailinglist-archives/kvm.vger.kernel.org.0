Return-Path: <kvm+bounces-30529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 019829BB5CB
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADE2A1F22029
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B679570839;
	Mon,  4 Nov 2024 13:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MFZRDnsn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D9E2E40B
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730726443; cv=none; b=Wthy8oNfVkMYSNo7KfPvqjvZ96EvhmKKkoE8Gc6niImINfvsCcdKsZ9O8/4ECWUkaglOCG3tPnlHINDzlhfeEohUM72vYoBkyFZF3s3zGfTuLViA68ezleDF2Rn6SbkreCqnw7nAlDqRTRUU1cWvI+y188HBsnSBBG4a805t3Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730726443; c=relaxed/simple;
	bh=RCfVewssPKXS9OocasbX7CMeEPDsOqBtEh7aEvDUkbQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S5M7acUM6TbzETjTt4oryxBA8ywvldedSIu4QpdCMRAJ1W/zSgqTaaoTtqzhFaIq5mHbsGYQeFql59IzMmv9t6ETPUYxA5hpImrZF1Nq7S6bEOMAqooGtU3+uBPpJxZpM2sNWm5suIy3JFDAPVi72YsPoIiRt7Al1feg/hrk50k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MFZRDnsn; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730726443; x=1762262443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RCfVewssPKXS9OocasbX7CMeEPDsOqBtEh7aEvDUkbQ=;
  b=MFZRDnsnQRnmX5Wq0vGSLW5V4ZIgG4kbXkd4yBqLthd6JaST7wa8GPI9
   o7zwEB36DhLFVSHvyerfxa/+8kVUNOqxi/c5pqfKEIUjtWrx1ya16OmuC
   26cjWuOgSt/p/DbrRZVLjVCbmoIIP9trQUPXXpxRgSfXwoDAXxhGUSj6B
   ktLkO7KZyIx6rTZ1J+Ivj/C5VKrU7mblGUaykztBXA2P7EWDa3cV1HLjM
   kuCECxge6Ab1yXJJs/q07n1YNXNHRy7EjM0x1nx1pGIKzE1kXHut+Wmwz
   5K+frH1hviOgCI6cBtM1khKJImN778Llc4YLYR/8wLjTaiETlGF8UqK9L
   A==;
X-CSE-ConnectionGUID: 0fK7KUEhTZS/lHprsZT2OQ==
X-CSE-MsgGUID: RCOPoDBoSdG2DXfx6eR+Qg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="47883301"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="47883301"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:20:42 -0800
X-CSE-ConnectionGUID: Ao/UYGv/TVWB9ZKikg9Aww==
X-CSE-MsgGUID: 4mziJiPHQaKEjf5YuQJduA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="84099746"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa007.jf.intel.com with ESMTP; 04 Nov 2024 05:20:42 -0800
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
	vasant.hegde@amd.com,
	will@kernel.org
Subject: [PATCH v3 6/7] iommu/amd: Make the blocked domain support PASID
Date: Mon,  4 Nov 2024 05:20:32 -0800
Message-Id: <20241104132033.14027-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241104132033.14027-1-yi.l.liu@intel.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The blocked domain can be extended to park PASID of a device to be the
DMA blocking state. By this the remove_dev_pasid() op is dropped.

Remove PASID from old domain and device GCR3 table. No need to attach
PASID to the blocked domain as clearing PASID from GCR3 table will make
sure all DMAs for that PASID are blocked.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/iommu/amd/iommu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 477aaf76b7ad..e513ced1ab53 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2472,10 +2472,19 @@ static int blocked_domain_attach_device(struct iommu_domain *domain,
 	return 0;
 }
 
+static int blocked_domain_set_dev_pasid(struct iommu_domain *domain,
+					struct device *dev, ioasid_t pasid,
+					struct iommu_domain *old)
+{
+	amd_iommu_remove_dev_pasid(dev, pasid, old);
+	return 0;
+}
+
 static struct iommu_domain blocked_domain = {
 	.type = IOMMU_DOMAIN_BLOCKED,
 	.ops = &(const struct iommu_domain_ops) {
 		.attach_dev     = blocked_domain_attach_device,
+		.set_dev_pasid  = blocked_domain_set_dev_pasid,
 	}
 };
 
@@ -2908,7 +2917,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.def_domain_type = amd_iommu_def_domain_type,
 	.dev_enable_feat = amd_iommu_dev_enable_feature,
 	.dev_disable_feat = amd_iommu_dev_disable_feature,
-	.remove_dev_pasid = amd_iommu_remove_dev_pasid,
 	.page_response = amd_iommu_page_response,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= amd_iommu_attach_device,
-- 
2.34.1


