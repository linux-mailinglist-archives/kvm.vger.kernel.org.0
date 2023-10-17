Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497B87CB930
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 05:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbjJQDWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 23:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbjJQDV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 23:21:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13C5FA;
        Mon, 16 Oct 2023 20:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697512891; x=1729048891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eeNu3y8SXJumM23k/uvzSE3Awv78NT0gn/ik52xN7s4=;
  b=e70Fli14SDQBSVpDVJpLaYdYQmHn6tSsd1GXiSFvc/kBVgAMKkB3SYFL
   rRbO3mFjR6MtWSTE2aTcRQc/wL1AB7S9faKI7FfpvCYts0heOnyy2dGOl
   1SAq+sL0JgviV88KrICP+h80Ww1pKdrmTUIdTXUPyV03ncqY7Ef/In+Br
   +8GL6k9HEhPgpB29/ZKE5jR3gBplvaj8DpuEY2hQZgA1P5pb0kToKG8Zf
   DZ3nYc+0WRW9pqiqG1T3honPTaJQbMy22TOGe5k+i+ghS+OcEwoOGK6xW
   zgdR3J465vOrq1HynhkhjwzjjbSagVcA/u02QKPvC5QN8N7eeDdeXgMyD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="389560870"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="389560870"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 20:21:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826270075"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="826270075"
Received: from sqa-gate.sh.intel.com (HELO spr-2s5.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 16 Oct 2023 20:21:28 -0700
From:   Tina Zhang <tina.zhang@intel.com>
To:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Tina Zhang <tina.zhang@intel.com>
Subject: [RFC PATCH 08/12] iommu/vt-d: Use RCU for dev_pasids list updates in set/remove_dev_pasid()
Date:   Tue, 17 Oct 2023 11:20:41 +0800
Message-Id: <20231017032045.114868-10-tina.zhang@intel.com>
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

Extend intel_iommu_remove_dev_pasid() and intel_iommu_set_dev_pasid() to
support updating dev_pasids list concurrently with readers.

For default domain operations, the dev_pasids list accesses are protected
by domain->lock and therefore all read/write accesses of default domain
operations to dev_pasids list are performed sequentially. To extend
intel_iommu_set/remove_dev_pasid() to have the ability to update the
dev_pasids list concurrently with multiple readers (which is required by
sva domain), RCU mechanism is being used here.

Signed-off-by: Tina Zhang <tina.zhang@intel.com>
---
 drivers/iommu/intel/iommu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index eeb658d3bc6e..fe063e1250fa 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4694,7 +4694,7 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	spin_lock_irqsave(&dmar_domain->lock, flags);
 	list_for_each_entry(curr, &dmar_domain->dev_pasids, link_domain) {
 		if (curr->dev == dev && curr->pasid == pasid) {
-			list_del(&curr->link_domain);
+			list_del_rcu(&curr->link_domain);
 			dev_pasid = curr;
 			break;
 		}
@@ -4703,7 +4703,7 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 	spin_unlock_irqrestore(&dmar_domain->lock, flags);
 
 	domain_detach_iommu(dmar_domain, iommu);
-	kfree(dev_pasid);
+	kfree_rcu(dev_pasid, rcu);
 out_tear_down:
 	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
 	intel_drain_pasid_prq(dev, pasid);
@@ -4751,8 +4751,14 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain *domain,
 
 	dev_pasid->dev = dev;
 	dev_pasid->pasid = pasid;
+
+	/*
+	 * Spin lock protects dev_pasids list from being updated concurrently with
+	 * multiple updaters, while rcu ensures concurrency between one updater
+	 * and multiple readers
+	 */
 	spin_lock_irqsave(&dmar_domain->lock, flags);
-	list_add(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
+	list_add_rcu(&dev_pasid->link_domain, &dmar_domain->dev_pasids);
 	spin_unlock_irqrestore(&dmar_domain->lock, flags);
 
 	return 0;
-- 
2.39.3

