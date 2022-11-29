Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EE663BE60
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 11:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiK2K6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 05:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiK2K6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 05:58:37 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EE0429B7;
        Tue, 29 Nov 2022 02:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669719515; x=1701255515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OvmWDaDi9uGrTzrbe0C8LLppSyam4Q1qg1lvl10sHdc=;
  b=LU3i2laF5nepQFGFS5WiYrPWNtmOcOCO7KQSDnXHgeUMvMC+Yut/CgSg
   22IhLBvQ7gZMgVi+BYeU6QvaQAMAZ2li54KfR0qaQcUwSdH0R/PPRrFzv
   nO3pN0r1ChZ/TTu93GR1anl7ZAowCOpsn5QpacfOE6q23FmDeSXv1gXmP
   LmGj5Q6OM2uMYow6jP3Oint2/ER3ww8eQIOKzniwtSXZRCku+RybT9PZQ
   byuPdVbfEIVDtMTCqes+r6YZguiQf1WnwshqBLSZ5ab2dIbzyw0lO+0+v
   QUZb/U0OYdI6eoW7sxJsLVvNhPmgBnsLTUk4gN3SNhnVkaBulB1jEHCl9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="295457260"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="295457260"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 02:58:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="621411025"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="621411025"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 29 Nov 2022 02:58:35 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, intel-gvt-dev@lists.freedesktop.org,
        linux-s390@vger.kernel.org, Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Subject: [[RESEND] iommufd PATCH v2 2/2] vfio/ap: validate iova during dma_unmap and trigger irq disable
Date:   Tue, 29 Nov 2022 02:58:31 -0800
Message-Id: <20221129105831.466954-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129105831.466954-1-yi.l.liu@intel.com>
References: <20221129105831.466954-1-yi.l.liu@intel.com>
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

From: Matthew Rosato <mjrosato@linux.ibm.com>

Currently, each mapped iova is stashed in its associated vfio_ap_queue;
when we get an unmap request, validate that it matches with one or more
of these stashed values before attempting unpins.

Each stashed iova represents IRQ that was enabled for a queue.  Therefore,
if a match is found, trigger IRQ disable for this queue to ensure that
underlying firmware will no longer try to use the associated pfn after
the page is unpinned. IRQ disable will also handle the associated unpin.

Cc: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Jason Herne <jjherne@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 0b4cc8c597ae..8bf353d46820 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1535,13 +1535,29 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+static void unmap_iova(struct ap_matrix_mdev *matrix_mdev, u64 iova, u64 length)
+{
+	struct ap_queue_table *qtable = &matrix_mdev->qtable;
+	struct vfio_ap_queue *q;
+	int loop_cursor;
+
+	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
+		if (q->saved_iova >= iova && q->saved_iova < iova + length)
+			vfio_ap_irq_disable(q);
+	}
+}
+
 static void vfio_ap_mdev_dma_unmap(struct vfio_device *vdev, u64 iova,
 				   u64 length)
 {
 	struct ap_matrix_mdev *matrix_mdev =
 		container_of(vdev, struct ap_matrix_mdev, vdev);
 
-	vfio_unpin_pages(&matrix_mdev->vdev, iova, 1);
+	mutex_lock(&matrix_dev->mdevs_lock);
+
+	unmap_iova(matrix_mdev, iova, length);
+
+	mutex_unlock(&matrix_dev->mdevs_lock);
 }
 
 /**
-- 
2.34.1

