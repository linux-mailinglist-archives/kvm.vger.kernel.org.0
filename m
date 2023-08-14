Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAD577AF2A
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 03:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbjHNBVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Aug 2023 21:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjHNBUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Aug 2023 21:20:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAF2E6E;
        Sun, 13 Aug 2023 18:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691976032; x=1723512032;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1VKEBWyIoCdoQh4ifxDFIHU7H3LnyvQp0GU6ahA/QQE=;
  b=Qrv0sR5eRASz2+cnddIJc2aipVni2jlP8zyLSrTa2yiEXlIPkSy2f3kq
   5hbFOFk4l84ZpIq7ncNPOGwAH6DOSayKba1Dx6PGj2LYfmGmQAPUdsVIm
   75khmaGbGL3fkKqb8grqrLWCxYI1zVhcFcRGhm5OaOiJlDxMoX/DkyCFD
   foyKxGLpTPwOvpmmDFU8pCyal3+EAwvk1AsMi7BDyPzHJvC7RBJi1RNdW
   lzicgRlKgmLhUI76WDmzm1BWFxHeHIwMaqcStcbaXm2bEoeed+0tdkzBy
   D8De356fcbE5gime2X5E6yP7GqKvSgSe3EcHShadsDCKiaDf4xrdXclQ5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="375645305"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="375645305"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 18:20:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="726842292"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="726842292"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by orsmga007.jf.intel.com with ESMTP; 13 Aug 2023 18:20:28 -0700
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
Subject: [PATCH v2 1/3] iommu: Make single-device group for PASID explicit
Date:   Mon, 14 Aug 2023 09:17:57 +0800
Message-Id: <20230814011759.102089-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230814011759.102089-1-baolu.lu@linux.intel.com>
References: <20230814011759.102089-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PASID interfaces have always supported only single-device groups.
This was first introduced in commit 26b25a2b98e45 ("iommu: Bind process
address spaces to devices"), and has been kept consistent in subsequent
commits.

However, the core code doesn't explicitly check for this requirement
after commit 201007ef707a8 ("PCI: Enable PASID only when ACS RR & UF
enabled on upstream path"), which made this requirement implicit.

Restore the check to make it explicit that the PASID interfaces only
support devices belonging to single-device groups.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 71b9c41f2a9e..f1eba60e573f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3408,6 +3408,11 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 		return -ENODEV;
 
 	mutex_lock(&group->mutex);
+	if (list_count_nodes(&group->devices) != 1) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL, domain, GFP_KERNEL);
 	if (curr) {
 		ret = xa_err(curr) ? : -EBUSY;
-- 
2.34.1

