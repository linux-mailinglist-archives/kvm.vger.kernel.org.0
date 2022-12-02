Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8606407FC
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 14:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiLBNyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 08:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbiLBNyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 08:54:12 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB8CC2D35;
        Fri,  2 Dec 2022 05:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669989251; x=1701525251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mZIn3iA9hB0ufQkshFC/gLDQ3B4MqgSSFSJ29jdd7vo=;
  b=C12KZkBgBKSG+FMvMsCF8V+JvJ8RrqD+SH4pJ3CoVotAT4UnP8Prc2Eo
   RgoTjrlAcv0HaPp0r1nlpoQZRzoQRdIAtu15q/82l3J0jmNwklv0Cp1TE
   JMksJBqiOrV98MR5A5/vOjwgNp/IWDyD6RHvmb5O0zyjhxjcoCRDu9dwg
   aZEgGJ8cKB8u9gXt5mBsGOsr95skBOFgywnLxFDhGaSfsHmQSUTmD/f8t
   zFkpff69DIWnVEuCi914lC1vWwVwN07e+cKEVwfXilw113cQJoU4L0zuo
   83Bd8crV3JKaNg7+HXDgswobOWarI6E/PvrK3P7cmgYzcEwDXHl1GmiSs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="315983412"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="315983412"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 05:54:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675834138"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="675834138"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2022 05:54:05 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, intel-gvt-dev@lists.freedesktop.org,
        linux-s390@vger.kernel.org, Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Subject: [[iommufd] PATCH v3 2/2] iommufd PATCH v2 2/2] vfio/ap: validate iova during dma_unmap and trigger irq disable
Date:   Fri,  2 Dec 2022 05:54:02 -0800
Message-Id: <20221202135402.756470-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221202135402.756470-1-yi.l.liu@intel.com>
References: <20221202135402.756470-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
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

