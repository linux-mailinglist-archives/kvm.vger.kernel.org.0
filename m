Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF46C264474
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 12:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgIJKo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 06:44:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:21915 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728617AbgIJKoI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 06:44:08 -0400
IronPort-SDR: Umw1Oicf9UAuqzHkle6nLeSLM2GrtZhxfZ928RHl9nWa4DxBkG0LY8Atush2CEDzkM4ruYt7XQ
 rD74tx3L6yCg==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="220066284"
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208,223";a="220066284"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 03:43:34 -0700
IronPort-SDR: cwcjXVuctSDFhUO3ZxpPQ+Hn7DP3+DxhKWy/5vEWrqncx9yfxYGz1YWU+u5d7tNxTrhQYKpqpL
 lvq2eNg6bjiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,412,1592895600"; 
   d="scan'208,223";a="334137192"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 10 Sep 2020 03:43:34 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH v7 05/16] iommu/vt-d: Support setting ioasid set to domain
Date:   Thu, 10 Sep 2020 03:45:22 -0700
Message-Id: <1599734733-6431-6-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From IOMMU p.o.v., PASIDs allocated and managed by external components
(e.g. VFIO) will be passed in for gpasid_bind/unbind operation. IOMMU
needs some knowledge to check the PASID ownership, hence add an interface
for those components to tell the PASID owner.

In latest kernel design, PASID ownership is managed by IOASID set where
the PASID is allocated from. This patch adds support for setting ioasid
set ID to the domains used for nesting/vSVA. Subsequent SVA operations
will check the PASID against its IOASID set for proper ownership.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
v6 -> v7:
*) add a helper function __domain_config_ioasid_set() per Eric's comment.
*) rename @ioasid_sid field of struct dmar_domain to be @pasid_set.
*) Eric gave r-b against v6, but since there is change, so will seek for his
   r-b again on this version.

v5 -> v6:
*) address comments against v5 from Eric Auger.

v4 -> v5:
*) address comments from Eric Auger.
---
 drivers/iommu/intel/iommu.c | 26 ++++++++++++++++++++++++++
 include/linux/intel-iommu.h |  4 ++++
 include/linux/iommu.h       |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5813eea..d1c77fc 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1806,6 +1806,7 @@ static struct dmar_domain *alloc_domain(int flags)
 	if (first_level_by_default())
 		domain->flags |= DOMAIN_FLAG_USE_FIRST_LEVEL;
 	domain->has_iotlb_device = false;
+	domain->pasid_set = host_pasid_set;
 	INIT_LIST_HEAD(&domain->devices);
 
 	return domain;
@@ -6007,6 +6008,22 @@ static bool intel_iommu_is_attach_deferred(struct iommu_domain *domain,
 	return attach_deferred(dev);
 }
 
+static int __domain_config_ioasid_set(struct dmar_domain *domain,
+				      struct ioasid_set *set)
+{
+	if (!(domain->flags & DOMAIN_FLAG_NESTING_MODE))
+		return -ENODEV;
+
+	if (domain->pasid_set != host_pasid_set &&
+	    domain->pasid_set != set) {
+		pr_warn_ratelimited("multi ioasid_set setting to domain");
+		return -EBUSY;
+	}
+
+	domain->pasid_set = set;
+	return 0;
+}
+
 static int
 intel_iommu_domain_set_attr(struct iommu_domain *domain,
 			    enum iommu_attr attr, void *data)
@@ -6030,6 +6047,15 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
 		}
 		spin_unlock_irqrestore(&device_domain_lock, flags);
 		break;
+	case DOMAIN_ATTR_IOASID_SET:
+	{
+		struct ioasid_set *set = (struct ioasid_set *)data;
+
+		spin_lock_irqsave(&device_domain_lock, flags);
+		ret = __domain_config_ioasid_set(dmar_domain, set);
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index d36038e..3345391 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -549,6 +549,10 @@ struct dmar_domain {
 					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
 	u64		max_addr;	/* maximum mapped address */
 
+	struct ioasid_set *pasid_set;	/*
+					 * the ioasid set which tracks all
+					 * PASIDs used by the domain.
+					 */
 	int		default_pasid;	/*
 					 * The default pasid used for non-SVM
 					 * traffic on mediated devices.
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index c364b1c..5b9f630 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -118,6 +118,7 @@ enum iommu_attr {
 	DOMAIN_ATTR_FSL_PAMUV1,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
+	DOMAIN_ATTR_IOASID_SET,
 	DOMAIN_ATTR_MAX,
 };
 
-- 
2.7.4

