Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93E16BBE4A
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 21:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbjCOU7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 16:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbjCOU7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 16:59:41 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC21D85A4F;
        Wed, 15 Mar 2023 13:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678913979; x=1710449979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qbu9sl+61RQBLYcvTOuWSLXfqQGA99BUZPMWL8q3o7A=;
  b=lARoTfPD6xxYDl6LO3fEqXvXoTLr8sH7fGhOmtELD+/tr0Oy+GuVPvB6
   dRqPrCtT4pvIdKxiS+v8wEvnfmK6KlW07Th/DDkvktzs9TVBAXB8a1PlI
   DtR6AmXk3iLs8ZKbpYhtqNfcQOu8fS+BbN97PCgBstdo9eNxRYwzHu4c8
   gWCac5inQEANNnj4vEbnZh8DR5u1MLdnF+89BGfJaDoib+FUfJrHGARcV
   qWULhASca8gevSzpfkHjASrfWfLoagZzaqhSO6dSRlh61KXmPePxs+Mj6
   7sKCHQ8p0XsdHYNbxol/Y1Yko6AH2cwHOh67MKH46FRVxUvfweyMPCwvm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="326176506"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326176506"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853747215"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853747215"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:38 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/8] vfio/pci: Remove negative check on unsigned vector
Date:   Wed, 15 Mar 2023 13:59:22 -0700
Message-Id: <97b2809a7d786583233a07b56c42e220d1d6e5a7.1678911529.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678911529.git.reinette.chatre@intel.com>
References: <cover.1678911529.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/vfio_pci_intrs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 6a9c6a143cc3..3f64ccdce69f 100644
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
+	int i, ret = 0;
+	unsigned int j;
 
 	if (start >= vdev->num_ctx || start + count > vdev->num_ctx)
 		return -EINVAL;
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

