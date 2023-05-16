Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EFC7049BB
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 11:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjEPJzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 05:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjEPJzQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 05:55:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF1311C;
        Tue, 16 May 2023 02:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684230915; x=1715766915;
  h=from:to:cc:subject:date:message-id;
  bh=yvx6OAowd/7NW7S209apHRJ64Wqyi4a60sJdPM3jAuA=;
  b=POyKr2J56/MGd34nKfkJt0++dZ5Tt+vB4SYabp3yYU2MVFzJmhisKe6s
   CYzThhG+0/WI8E7RN/C9v6Y4WO3WyhtVRiDUn8NTsOMREDp7QBHBIWpLH
   yedfT3V1XaxP7FZubCDgwAZNTD1YetS0Gdn0Ra3KM77owb3RgcswBPyu9
   YlBpAaypuZ0Hr+42LeAnpT0WqF3u/EghdpI3a7JVvEWg7HEI6kpJ080q4
   w7DohvxPjlrRh6ADaPMnoTGykKPkBgQuPPGvbq/qz2gIvIY6uUDirdAVx
   Ryrvavp4RCYe+HjuMM2iDxG8OjBGGNFaQF2Y2TnbXWrsSSITIDlJI5gmM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="353715105"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="353715105"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 02:55:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="734210813"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="734210813"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 02:55:11 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] vfio/type1: check pfn valid before converting to struct page
Date:   Tue, 16 May 2023 17:30:07 +0800
Message-Id: <20230516093007.15234-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_pin_page_external() can return a phys_pfn for vma with VM_PFNMAP,
e.g. for MMIO PFNs.

It's necessary to check if it's a valid pfn before calling pfn_to_page().

Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 493c31de0edb..0620dbe5cca0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -860,6 +860,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 		if (ret)
 			goto pin_unwind;
 
+		if (!pfn_valid(phys_pfn)) {
+			ret = -EINVAL;
+			goto pin_unwind;
+		}
+
 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn);
 		if (ret) {
 			if (put_pfn(phys_pfn, dma->prot) && do_accounting)

base-commit: b3c98052d46948a8d65d2778c7f306ff38366aac
-- 
2.17.1

