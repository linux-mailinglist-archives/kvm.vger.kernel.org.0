Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCA974E2FB
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 03:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjGKBI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 21:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjGKBIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 21:08:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD8AE4C;
        Mon, 10 Jul 2023 18:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689037728; x=1720573728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oKqphfPLpxwX/axdCJ/TL8Nqz/Tmz3XMJfkFpiYRxCo=;
  b=T8v2tepWHIHNYjA9mHSUUdyqAnymV/eV6uLuAKGf4hhftRy01LpX1uzG
   zFwaUd58zk20TU5ff2eKFDvPsQlNdEKbkTl02D2j7g8iN0AtqB+0UOVFn
   vLq42pMBjMyKmzmjwLfP3JrZ/5RjBnCzfnOG+YcVw/Tm+d4y3/fLXhg/C
   ACCvJTXMm7kpyWhYQt85HAfTAF/Aj/37J6w1LYMwLIF10BxCmrv456Ft2
   3KFd59xkOGrydmhbLBz1O9ikLpl3Wpaxdye8ozaxa89fig74VMCjFbI2v
   /lW4kvdhqC8MYvXqQfXaCYZ7F9Wd95KoGdvzanIXRd0qtWmSxwHlUC9zO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="344816083"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="344816083"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 18:08:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="810999840"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="810999840"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2023 18:08:44 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH 3/9] iommu: Add common code to handle IO page faults
Date:   Tue, 11 Jul 2023 09:06:36 +0800
Message-Id: <20230711010642.19707-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711010642.19707-1-baolu.lu@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The individual iommu drivers report iommu faults by calling
iommu_report_device_fault(), where a pre-registered device fault handler
is called to route the fault to another fault handler installed on the
corresponding iommu domain.

The pre-registered device fault handler is static and won't be dynamic
as the fault handler is eventually per iommu domain. Replace the device
fault handler with a static common code to avoid unnecessary code.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index da340f11c5f5..41328f03e8b4 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1278,6 +1278,28 @@ int iommu_unregister_device_fault_handler(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_unregister_device_fault_handler);
 
+static int iommu_handle_io_pgfault(struct device *dev,
+				   struct iommu_fault *fault)
+{
+	struct iommu_domain *domain;
+
+	if (fault->type != IOMMU_FAULT_PAGE_REQ)
+		return -EINVAL;
+
+	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
+		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
+	else
+		domain = iommu_get_domain_for_dev(dev);
+
+	if (!domain || !domain->iopf_handler)
+		return -ENODEV;
+
+	if (domain->iopf_handler == iommu_sva_handle_iopf)
+		return iommu_queue_iopf(fault, dev);
+
+	return domain->iopf_handler(fault, dev, domain->fault_data);
+}
+
 /**
  * iommu_report_device_fault() - Report fault event to device driver
  * @dev: the device
@@ -1320,7 +1342,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 		mutex_unlock(&fparam->lock);
 	}
 
-	ret = fparam->handler(&evt->fault, fparam->data);
+	ret = iommu_handle_io_pgfault(dev, &evt->fault);
 	if (ret && evt_pending) {
 		mutex_lock(&fparam->lock);
 		list_del(&evt_pending->list);
-- 
2.34.1

