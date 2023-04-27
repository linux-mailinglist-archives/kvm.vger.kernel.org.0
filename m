Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896DE6F0AED
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbjD0Rgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244420AbjD0RgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:36:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF113C39;
        Thu, 27 Apr 2023 10:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682616982; x=1714152982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FPa5Zz9lQ8mt2gPp5QecV+WcSW7u6oYI/fcqZRu8FDI=;
  b=gS3DBvMMQKoyIY9awQDkhPrmaXDSt4aQzTk6fzGt5WUPcohBZda++swy
   O8TZzK9zcKgbpzgMzuhhfwPtk9Wris68B5R/IWeFuVP/qO1NGroAWbEYq
   BJzrYW0SD7RQhCpUgJV+eBgO4BDvj1uHf0flqSxRE52tPd7Tnp+ourEf/
   HMVbuislvLEUOsHHduHUBd4ElzsbTQDYKsVgz/s3xrlO19t6pjUssT1xK
   jJnPTVKe3yosdI0SXdS7+C/HeOzBX9KMinuXKl3WUV7/27WvsLWmO2iS3
   W9Gr6CwzqrsB6LZfWM2fZA+NXBAwmkj+ybbMAvFc8lv1x2zA6aeX/qd36
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349496878"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="349496878"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697172966"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="697172966"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:20 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V4 02/11] vfio/pci: Remove negative check on unsigned vector
Date:   Thu, 27 Apr 2023 10:35:59 -0700
Message-Id: <5add301d11d4a566c29c487a78b4227ae383f11d.1682615447.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1682615447.git.reinette.chatre@intel.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

User space provides the vector as an unsigned int that is checked
early for validity (vfio_set_irqs_validate_and_prepare()).

A later negative check of the provided vector is not necessary.

Remove the negative check and ensure the type used
for the vector is consistent as an unsigned int.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
No changes since V3.

Changes since V2:
- Rework unwind loop within vfio_msi_set_block() that required j
  to be an int. Rework results in both i and j used for vector, both
  moved to be unsigned int. (Alex)

 drivers/vfio/pci/vfio_pci_intrs.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6a9c6a143cc3..258de57ef956 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -317,14 +317,14 @@ static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msi
 }
 
 static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
-				      int vector, int fd, bool msix)
+				      unsigned int vector, int fd, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct eventfd_ctx *trigger;
 	int irq, ret;
 	u16 cmd;
 
-	if (vector < 0 || vector >= vdev->num_ctx)
+	if (vector >= vdev->num_ctx)
 		return -EINVAL;
 
 	irq = pci_irq_vector(pdev, vector);
@@ -399,7 +399,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 			      unsigned count, int32_t *fds, bool msix)
 {
-	int i, j, ret = 0;
+	unsigned int i, j;
+	int ret = 0;
 
 	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
 		return -EINVAL;
@@ -410,8 +411,8 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 	}
 
 	if (ret) {
-		for (--j; j >= (int)start; j--)
-			vfio_msi_set_vector_signal(vdev, j, -1, msix);
+		for (i = start; i < j; i++)
+			vfio_msi_set_vector_signal(vdev, i, -1, msix);
 	}
 
 	return ret;
@@ -420,7 +421,7 @@ static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
-	int i;
+	unsigned int i;
 	u16 cmd;
 
 	for (i = 0; i < vdev->num_ctx; i++) {
@@ -542,7 +543,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
-	int i;
+	unsigned int i;
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
 
 	if (irq_is(vdev, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-- 
2.34.1

