Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6F2638D08
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 16:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiKYPHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 10:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiKYPGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 10:06:53 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C09429B6
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 07:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669388811; x=1700924811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K6MLOac5x03nQbMI3Jm3nrQy7Pwz2Jj+yd6eNvVvvJY=;
  b=Eqb8D/d/dCKORuoXxyc401J1fDdMte7uCVKaJZ5UaYgDElLXN8akFGF9
   /2JaxRogKIcjS1otgyfDF6EAmrlWfDx/qFCydtVuyZThg+TnY91IdYSLX
   tMp2VIIFPrkFg/rsWDr/5VqxIuq2JTpQIUqZueAvBwF1ZkXBmnzIRWVbW
   n7PcpQojcIT9a7rBNYtSZ04Bf9x2rzEVIXbr/uFvU2OLTpIwL/ixovO3b
   h1PdBU9/SBcqdJ4uY8dNTJuDRss16i9jVH/8Wg2BjBqThBXjU0L2MCT24
   93gjNBMHorpWsFNefV9wLfg1XRCjxaLvj4JIdWIiqGlNV3XmkayD3F9pj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="294881066"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="294881066"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10542"; a="593240303"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="593240303"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 07:06:49 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        hang.yuan@intel.com, piotr.uminski@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 11/12] vDPA/ifcvf: retire ifcvf_private_to_vf
Date:   Fri, 25 Nov 2022 22:57:23 +0800
Message-Id: <20221125145724.1129962-12-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221125145724.1129962-1-lingshan.zhu@intel.com>
References: <20221125145724.1129962-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit retires ifcvf_private_to_vf, because
the vf is already a member of the adapter,
so it could be easily addressed by adapter->vf.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |  3 ---
 drivers/vdpa/ifcvf/ifcvf_main.c | 10 +++++-----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 25bd4e927b27..d41e255c581b 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -38,9 +38,6 @@
 #define IFCVF_DBG(pdev, fmt, ...)	dev_dbg(&pdev->dev, fmt, ##__VA_ARGS__)
 #define IFCVF_INFO(pdev, fmt, ...)	dev_info(&pdev->dev, fmt, ##__VA_ARGS__)
 
-#define ifcvf_private_to_vf(adapter) \
-	(((struct ifcvf_adapter *)adapter)->vf)
-
 /* all vqs and config interrupt has its own vector */
 #define MSIX_VECTOR_PER_VQ_AND_CONFIG		1
 /* all vqs share a vector, and config interrupt has a separate vector */
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 4450ddb53806..5fb3580594d5 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -346,9 +346,9 @@ static int ifcvf_request_irq(struct ifcvf_hw *vf)
 	return 0;
 }
 
-static int ifcvf_start_datapath(void *private)
+static int ifcvf_start_datapath(struct ifcvf_adapter *adapter)
 {
-	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
+	struct ifcvf_hw *vf = adapter->vf;
 	u8 status;
 	int ret;
 
@@ -362,9 +362,9 @@ static int ifcvf_start_datapath(void *private)
 	return ret;
 }
 
-static int ifcvf_stop_datapath(void *private)
+static int ifcvf_stop_datapath(struct ifcvf_adapter *adapter)
 {
-	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
+	struct ifcvf_hw *vf = adapter->vf;
 	int i;
 
 	for (i = 0; i < vf->nr_vring; i++)
@@ -377,7 +377,7 @@ static int ifcvf_stop_datapath(void *private)
 
 static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
 {
-	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
+	struct ifcvf_hw *vf = adapter->vf;
 	int i;
 
 	for (i = 0; i < vf->nr_vring; i++) {
-- 
2.31.1

