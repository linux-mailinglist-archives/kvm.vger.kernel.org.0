Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364BD129E98
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 08:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLXHqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 02:46:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:49687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbfLXHq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 02:46:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 23:46:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="223177100"
Received: from allen-box.sh.intel.com ([10.239.159.136])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2019 23:46:26 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     ashok.raj@intel.com, sanjay.k.kumar@intel.com,
        jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com,
        Peter Xu <peterx@redhat.com>, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 8/9] iommu/vt-d: Use iova over first level
Date:   Tue, 24 Dec 2019 15:45:01 +0800
Message-Id: <20191224074502.5545-9-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191224074502.5545-1-baolu.lu@linux.intel.com>
References: <20191224074502.5545-1-baolu.lu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After we make all map/unmap paths support first level page table.
Let's turn it on if hardware supports scalable mode.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/intel-iommu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 34e619318f64..51d60bad0b1d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1770,15 +1770,13 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
 
 /*
  * Check and return whether first level is used by default for
- * DMA translation. Currently, we make it off by setting
- * first_level_support = 0, and will change it to -1 after all
- * map/unmap paths support first level page table.
+ * DMA translation.
  */
 static bool first_level_by_default(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
-	static int first_level_support = 0;
+	static int first_level_support = -1;
 
 	if (likely(first_level_support != -1))
 		return first_level_support;
-- 
2.17.1

