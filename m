Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647A86FF649
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 17:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbjEKPpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 11:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbjEKPo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 11:44:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B271A4;
        Thu, 11 May 2023 08:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683819896; x=1715355896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g6JZYSL71CEjogYzaYYuX7rOxxJ3pXQABRSAZrbyMBo=;
  b=P2yirWpMbjdeimCXGZl13VVeB1SKXxwd7+Cs5CVe05oPQWilFlku70IA
   8D8tGew/EqZHY3XYG19esGR2Ltmt6yX94mahtFuZ3ETobcqnnRIwl3MFp
   VdB0tYQJyImnhIk3fSib+UUWmr/GyT+wFsQC4ifuttLs52J0qauFSN8vl
   XsfDS49fegSkQG9eLu6Uq049KbSMZqMTM8hYAvqI9VKchWKKQkzgv0um4
   VPHkY+Nww7OfFwbt9sE31N8Wbor4N+ev4ZIv+WUjh78ABTjqtgTL9qHUq
   vfBvdeHMxUdITWRLXnP3XGRlHfITEXbgvOlWU6h3gMJNU6fsOnmpJ917E
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335046654"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335046654"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699776224"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699776224"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:48 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V5 02/11] vfio/pci: Remove negative check on unsigned vector
Date:   Thu, 11 May 2023 08:44:29 -0700
Message-Id: <28521e1b0b091849952b0ecb8c118729fc8cdc4f.1683740667.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1683740667.git.reinette.chatre@intel.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
Changes since V4:
- Add Kevin's Reviewed-by tag. (Kevin)

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

