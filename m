Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC2363608C
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiKWNy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237676AbiKWNyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:54:33 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE5B7D528
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669211318; x=1700747318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vFuQjLLkuzb4mFfpRJMXUNfnSiPLk99bPY8GXndbOis=;
  b=nz7KmezJdWLmpq8dnLJc3X41Ze7bDdjpP/YalWDxUGk0tE1/L0QIxMSE
   bwM/RXZtyVChZisk0KtWa7i+eYQtbvOxcMY+YIcvETYnzxDB/GJR53abC
   vF+6hoMsp4CySdLt5iC3gW5gl9gAxXgDLoj5qUt9J96oeBqk7EkuGOCNj
   btXEknHpQ8fafMqiq3q+FHf6noHjA8R9SSxwY+WevGNMC0mtSDCYpeFvR
   mKMbL5IDKrxrpT4W8l5yn/KGmuWjpxp+8mB+DJDMM6ocEWZC3VRX5Bwb8
   /UQhwMcfLRoDzcusPbuJIHBvbQZa/dXmd8903U82HtIpwxGsnqSVkBIz6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293776014"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293776014"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 05:48:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619619649"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619619649"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 23 Nov 2022 05:48:37 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, chao.p.peng@linux.intel.com,
        kvm@vger.kernel.org, yi.y.sun@linux.intel.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Subject: [iommufd 2/2] vfio/ap: validate iova during dma_unmap and trigger irq disable
Date:   Wed, 23 Nov 2022 05:48:32 -0800
Message-Id: <20221123134832.429589-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123134832.429589-1-yi.l.liu@intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

vfio_iommufd_bind() creates an access which has an unmap callback, which
can be called immediately. So dma_unmap() callback should tolerate the
unmaps that come before the emulated device is opened.

To achieve above, vfio_ap_mdev_dma_unmap() needs to validate that unmap
request matches with one or more of these stashed values before
attempting unpins.

Currently, each mapped iova is stashed in its associated vfio_ap_queue;
Each stashed iova represents IRQ that was enabled for a queue. Therefore,
if a match is found, trigger IRQ disable for this queue to ensure that
underlying firmware will no longer try to use the associated pfn after
the page is unpinned. IRQ disable will also handle the associated unpin.

Cc: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Jason Herne <jjherne@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index bb7776d20792..62bfca2bbe6d 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1535,13 +1535,35 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
 	return 0;
 }
 
+static void unmap_iova(struct ap_matrix_mdev *matrix_mdev, u64 iova, u64 length)
+{
+	struct ap_queue_table *qtable = &matrix_mdev->qtable;
+	u64 iova_pfn_end = (iova + length - 1) >> PAGE_SHIFT;
+	u64 iova_pfn_start = iova >> PAGE_SHIFT;
+	struct vfio_ap_queue *q;
+	int loop_cursor;
+	u64 pfn;
+
+	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
+		pfn = q->saved_iova >> PAGE_SHIFT;
+		if (pfn >= iova_pfn_start && pfn <= iova_pfn_end) {
+			vfio_ap_irq_disable(q);
+			break;
+		}
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

