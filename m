Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1B526BA52
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 04:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIPCsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 22:48:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:2896 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgIPCsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 22:48:33 -0400
IronPort-SDR: zWFSai//FLqwvbK4zcnyHX3bMikozgDLxaYtsl3t//4c1GGnYs+MslK7Daqh7kUaawx4KPX1zU
 O+sv2HVTU/ew==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="147080375"
X-IronPort-AV: E=Sophos;i="5.76,431,1592895600"; 
   d="scan'208";a="147080375"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 19:48:32 -0700
IronPort-SDR: uBOb0byliZpJTD2s+egSk+nmACoZs5vHfD96uvAiu9R+FRNjVUSvmt8O5+ceRifFEPlcapu0Wt
 k7Cb3pRXwM4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,431,1592895600"; 
   d="scan'208";a="335876270"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 15 Sep 2020 19:48:31 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2] vfio: fix a missed vfio group put in vfio_pin_pages
Date:   Wed, 16 Sep 2020 10:29:27 +0800
Message-Id: <20200916022927.26359-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

when error occurs, need to put vfio group after a successful get.

Fixes: 95fc87b44104 ("vfio: Selective dirty page tracking if IOMMU backed device pins pages")

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>

---
v2: updated the format of the Fixes: line. (Cornelia)
---
 drivers/vfio/vfio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 262ab0efd06c..5e6e0511b5aa 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1949,8 +1949,10 @@ int vfio_pin_pages(struct device *dev, unsigned long *user_pfn, int npage,
 	if (!group)
 		return -ENODEV;
 
-	if (group->dev_counter > 1)
-		return -EINVAL;
+	if (group->dev_counter > 1) {
+		ret = -EINVAL;
+		goto err_pin_pages;
+	}
 
 	ret = vfio_group_add_container_user(group);
 	if (ret)
-- 
2.17.1

