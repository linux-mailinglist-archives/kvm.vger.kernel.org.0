Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107AB76463C
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 07:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjG0FwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 01:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbjG0Fvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 01:51:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C2F30E8;
        Wed, 26 Jul 2023 22:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690437085; x=1721973085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xPrIhMzrO/1WIuBZJMjoXCye3jUvuQy6Gz0x3Y15rzk=;
  b=P9bu8PRcSVMkEQMi65Es9Wn20sI6iLOGBEtJx03dha2DFbQ60MH13oGx
   KdazJ9T0KGZIG7raxdNt1VyA3W+GBAXYjiRBI23Dz5A4e4rlct6PG5J7T
   m8WvspjQCdQscR0TQR/kRkWiAfU7fFDYMyJB3ZwVa7FNu84NWo+lTNz4s
   /PindQKQt9O9xSE0pr3HxM861a+oadBcx95X9i+fGkTdVHfkVDab6Lvh2
   tlJbFBNGzTLkdhHbYqiL3il9s6wj4jpXJcny40wfe1UHnRIE+GJtr8KX1
   T3iJoAag0X3Vr5Ivsk279tA2qhSOSN8FDxdo+HjtgCi4rh1bpVjhDZzDu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="399152516"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="399152516"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2023 22:51:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10783"; a="840585282"
X-IronPort-AV: E=Sophos;i="6.01,234,1684825200"; 
   d="scan'208";a="840585282"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jul 2023 22:50:59 -0700
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
Subject: [PATCH v2 04/12] iommu: Replace device fault handler with iommu_queue_iopf()
Date:   Thu, 27 Jul 2023 13:48:29 +0800
Message-Id: <20230727054837.147050-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230727054837.147050-1-baolu.lu@linux.intel.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
as the fault handler is eventually per iommu domain. Replace calling
device fault handler with iommu_queue_iopf().

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 4352a149a935..00309f66153b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1381,7 +1381,7 @@ int iommu_report_device_fault(struct device *dev, struct iommu_fault_event *evt)
 		mutex_unlock(&fparam->lock);
 	}
 
-	ret = fparam->handler(&evt->fault, fparam->data);
+	ret = iommu_queue_iopf(&evt->fault, dev);
 	if (ret && evt_pending) {
 		mutex_lock(&fparam->lock);
 		list_del(&evt_pending->list);
-- 
2.34.1

