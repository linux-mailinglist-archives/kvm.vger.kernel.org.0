Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD44269AAA
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 02:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgIOAto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 20:49:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:10400 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbgIOAtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 20:49:43 -0400
IronPort-SDR: FgxZiRVI0Oq4RloF2GSFUVi7G7oUjbjf9k03uRElGor7x8v/FTOa1Zl2Sqyeq11laBx1gmMV13
 2rZS4O+PpOwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="177247509"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="177247509"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 17:49:43 -0700
IronPort-SDR: /fkne7Pfn08NMotXs+5OLleNTbxIsHOEIAl1ai4D+qVgvt1HhV17ywU2d7E8QUJHp//QZb+KHr
 Rb5UjavQTjTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="335469854"
Received: from joy-optiplex-7040.sh.intel.com ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 14 Sep 2020 17:49:41 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] vfio: fix a missed vfio group put in vfio_pin_pages
Date:   Tue, 15 Sep 2020 08:28:35 +0800
Message-Id: <20200915002835.14213-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

when error occurs, need to put vfio group after a successful get.

Fixes: 95fc87b44104 (vfio: Selective dirty page tracking if IOMMU backed
device pins pages)

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
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

