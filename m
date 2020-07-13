Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEAE21C8E2
	for <lists+kvm@lfdr.de>; Sun, 12 Jul 2020 13:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgGLLQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 07:16:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:45847 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbgGLLOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jul 2020 07:14:34 -0400
IronPort-SDR: H83biB2vXbIgO2qThiBUJVl1FEBx11szPbSWa1HDY3p2uKxptJLHgclPDl30UVMRPDlsxYC1Am
 9CxFhiOGwtEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9679"; a="149952689"
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208,223";a="149952689"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 04:14:30 -0700
IronPort-SDR: uEe4diWufHvv5+6SULMrVqLb8J5rYYJuIYfJfiBzLgv59C03BuR2kQ/qG3cg90KvP2OIVEs86q
 D6H2H9MUVLaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208,223";a="315788566"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 12 Jul 2020 04:14:29 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 06/15] iommu/vt-d: Support setting ioasid set to domain
Date:   Sun, 12 Jul 2020 04:21:01 -0700
Message-Id: <1594552870-55687-7-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
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
on the PASID will be checked against its IOASID set for proper ownership.

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
v4 -> v5:
*) address comments from Eric Auger.
---
 drivers/iommu/intel/iommu.c | 22 ++++++++++++++++++++++
 include/linux/intel-iommu.h |  4 ++++
 include/linux/iommu.h       |  1 +
 3 files changed, 27 insertions(+)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 72ae6a2..4d54198 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1793,6 +1793,7 @@ static struct dmar_domain *alloc_domain(int flags)
 	if (first_level_by_default())
 		domain->flags |= DOMAIN_FLAG_USE_FIRST_LEVEL;
 	domain->has_iotlb_device = false;
+	domain->ioasid_sid = INVALID_IOASID_SET;
 	INIT_LIST_HEAD(&domain->devices);
 
 	return domain;
@@ -6039,6 +6040,27 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
 		}
 		spin_unlock_irqrestore(&device_domain_lock, flags);
 		break;
+	case DOMAIN_ATTR_IOASID_SID:
+	{
+		int sid = *(int *)data;
+
+		if (!(dmar_domain->flags & DOMAIN_FLAG_NESTING_MODE)) {
+			ret = -ENODEV;
+			break;
+		}
+		spin_lock_irqsave(&device_domain_lock, flags);
+		if (dmar_domain->ioasid_sid != INVALID_IOASID_SET &&
+		    dmar_domain->ioasid_sid != sid) {
+			pr_warn_ratelimited("multi ioasid_set (%d:%d) setting",
+					    dmar_domain->ioasid_sid, sid);
+			ret = -EBUSY;
+			spin_unlock_irqrestore(&device_domain_lock, flags);
+			break;
+		}
+		dmar_domain->ioasid_sid = sid;
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 3f23c26..0d0ab32 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -549,6 +549,10 @@ struct dmar_domain {
 					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
 	u64		max_addr;	/* maximum mapped address */
 
+	int		ioasid_sid;	/*
+					 * the ioasid set which tracks all
+					 * PASIDs used by the domain.
+					 */
 	int		default_pasid;	/*
 					 * The default pasid used for non-SVM
 					 * traffic on mediated devices.
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 7ca9d48..e84a1d5 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -124,6 +124,7 @@ enum iommu_attr {
 	DOMAIN_ATTR_FSL_PAMUV1,
 	DOMAIN_ATTR_NESTING,	/* two stages of translation */
 	DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE,
+	DOMAIN_ATTR_IOASID_SID,
 	DOMAIN_ATTR_MAX,
 };
 
-- 
2.7.4

