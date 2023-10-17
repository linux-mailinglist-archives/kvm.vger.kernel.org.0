Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6207CB92B
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbjJQDVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbjJQDVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:21:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2FDE6;
        Mon, 16 Oct 2023 20:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512881; x=1729048881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2IR/Jycn4fYLDKkd/59DW5lTr+45wMYcYu8xOLtatO8=;
  b=embETSsFjWCJ5YZj/fU8Ti4VBoWrpxLNdFqycs0oyggUZql4iwEcBA7R
   hfEWOLENkcicAeJW/8q1XNVVYgInROAznJy11lHFYpgMW+3yVNRsBExjt
   Y//37INEHFhbPb8g5yfMYshEa/RPjAUWUu0LEMtySEbs+L5H7oIkbgaE2
   wm8qMwda+/qUIvukiUOeYwSIE85XadE+Ml9f+60RH6+HQFZHOAE2uLKH9
   FE3fild3KYxnO0k1ZLZVnw2F1vCDZifyFHAWywAA7RwSS490k7ZPm0Cqw
   p9fgN9bv7V3Ek8+X+1nFIzF3n2lpz1yt/wwmrp2kFSs712DbBFeDlNpJr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560821"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560821"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826270040"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826270040"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:18 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 04/12] iommu/vt-d: Make dev_to_intel_iommu() helper global
Date:   Tue, 17 Oct 2023 11:20:37 +0800
Message-Id: <20231017032045.114868-6-tina.zhang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231017032045.114868-1-tina.zhang@intel.com>
References: <20231017032045.114868-1-tina.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make dev_to_intel_iommu() global so that it can be used by other files.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/iommu/intel/iommu.c | 7 -------
 drivers/iommu/intel/iommu.h | 6 ++++++
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 3685ba90ec88..eeb658d3bc6e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3609,13 +3609,6 @@ void intel_iommu_shutdown(void)
 	up_write(&dmar_global_lock);
 }
 
-static inline struct intel_iommu *dev_to_intel_iommu(struct device *dev)
-{
-	struct iommu_device *iommu_dev = dev_to_iommu_device(dev);
-
-	return container_of(iommu_dev, struct intel_iommu, iommu);
-}
-
 static ssize_t version_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 7dac94f62b4e..1e972e7edeca 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -842,6 +842,12 @@ void *alloc_pgtable_page(int node, gfp_t gfp);
 void free_pgtable_page(void *vaddr);
 void iommu_flush_write_buffer(struct intel_iommu *iommu);
 struct intel_iommu *device_to_iommu(struct device *dev, u8 *bus, u8 *devfn);
+static inline struct intel_iommu *dev_to_intel_iommu(struct device *dev)
+{
+	struct iommu_device *iommu_dev = dev_to_iommu_device(dev);
+
+	return container_of(iommu_dev, struct intel_iommu, iommu);
+}
 
 #ifdef CONFIG_INTEL_IOMMU_SVM
 void intel_svm_check(struct intel_iommu *iommu);
-- 
2.39.3

