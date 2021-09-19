Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55E3410A68
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239135AbhISGpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:45:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:46248 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239130AbhISGpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:45:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="245397386"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="245397386"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:43:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510702188"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:43:32 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 19/20] iommu/vt-d: Implement device_info iommu_ops callback
Date:   Sun, 19 Sep 2021 14:38:47 +0800
Message-Id: <20210919063848.1476776-20-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

Expose per-device IOMMU attributes to the upper layers.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel/iommu.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index dd22fc7d5176..d531ea44f418 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5583,6 +5583,40 @@ static void intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
 	}
 }
 
+static int
+intel_iommu_device_info(struct device *dev, enum iommu_devattr type, void *data)
+{
+	struct intel_iommu *iommu = device_to_iommu(dev, NULL, NULL);
+	int ret = 0;
+
+	if (!iommu)
+		return -ENODEV;
+
+	switch (type) {
+	case IOMMU_DEV_INFO_PAGE_SIZE:
+		*(u64 *)data = SZ_4K |
+			(cap_super_page_val(iommu->cap) & BIT(0) ? SZ_2M : 0) |
+			(cap_super_page_val(iommu->cap) & BIT(1) ? SZ_1G : 0);
+		break;
+	case IOMMU_DEV_INFO_FORCE_SNOOP:
+		/*
+		 * Force snoop is always supported in the scalable mode. For the legacy
+		 * mode, check the capability register.
+		 */
+		*(bool *)data = sm_supported(iommu) || ecap_sc_support(iommu->ecap);
+		break;
+	case IOMMU_DEV_INFO_ADDR_WIDTH:
+		*(u32 *)data = min_t(u32, agaw_to_width(iommu->agaw),
+				     cap_mgaw(iommu->cap));
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 const struct iommu_ops intel_iommu_ops = {
 	.capable		= intel_iommu_capable,
 	.domain_alloc		= intel_iommu_domain_alloc,
@@ -5621,6 +5655,7 @@ const struct iommu_ops intel_iommu_ops = {
 	.sva_get_pasid		= intel_svm_get_pasid,
 	.page_response		= intel_svm_page_response,
 #endif
+	.device_info		= intel_iommu_device_info,
 };
 
 static void quirk_iommu_igfx(struct pci_dev *dev)
-- 
2.25.1

