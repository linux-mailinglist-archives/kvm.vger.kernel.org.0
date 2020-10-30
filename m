Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2BDD29FCE7
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 06:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgJ3FFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 01:05:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:5284 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgJ3FFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 01:05:09 -0400
IronPort-SDR: HRKAOCkQB0XhU9b6UnZOVSYS/rFK62PwaV5U0QV1Cf8ugPYUm61jebuHELgWraSBfIDzCxYVUd
 xVfq+yHElVcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="230196547"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="230196547"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 22:05:08 -0700
IronPort-SDR: DBvYloqtZm7ZhjV0oDjwAGVxl8PMUs3l2Umcf5zMlwrfkQTu6eWd9tYUYj/E9GzsYU7VVH7G8V
 uo/wGP6DpSDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="425261534"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2020 22:05:04 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 1/5] vfio/mdev: Register mdev bus earlier during boot
Date:   Fri, 30 Oct 2020 12:58:05 +0800
Message-Id: <20201030045809.957927-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030045809.957927-1-baolu.lu@linux.intel.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move mdev bus registration earlier than IOMMU probe processing so that
the IOMMU drivers could be able to set iommu_ops for the mdev bus. This
only applies when vfio-mdev module is setected to be built-in.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/vfio/mdev/mdev_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b558d4cfd082..6b9ab71f89e7 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -417,8 +417,12 @@ static void __exit mdev_exit(void)
 	mdev_bus_unregister();
 }
 
+#if IS_BUILTIN(CONFIG_VFIO_MDEV)
+postcore_initcall(mdev_init)
+#else
 module_init(mdev_init)
 module_exit(mdev_exit)
+#endif /* IS_BUILTIN(CONFIG_VFIO_MDEV) */
 
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
-- 
2.25.1

