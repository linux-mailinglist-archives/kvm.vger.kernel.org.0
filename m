Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0098E7BBCF7
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbjJFQlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjJFQl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A6BC2;
        Fri,  6 Oct 2023 09:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610488; x=1728146488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sqlUd/J5XBudJ04yCoAuAKyPY6TW044eZAMIMwmxPNU=;
  b=jdY/YNXGEnaDDjMw6cFGFg6EHLRxTB73uoUvshd13KolzsDTEaT/texf
   yW8MQruF+elODGU9GJJ+ytSQZ4/nyFbvwADTDW9oaQfOqwRMniZJH9GyR
   yWHf6DkCJmxtuMA0YspCw4Nfsxjv97QqD/WYWzoG7AbEjldVIb1GNbYs8
   3J9fWmqCQbRw5bcGury98B3gX5UXB0swGUqxIyLNn0U9MIwdnFgXalG3s
   +/z8hXbXMNpjYic0GkX8poJdDZMZLKnjs2QzUOQ43TPzW9rVodjwdcymz
   dlvPsiiju+ZkaTiIMTVhXsxJGJBxx/3Y8EI5Xs/mghKI2DWFL0Lye1Evq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063179"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063179"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892855"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892855"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:24 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 06/18] vfio/pci: Separate MSI and MSI-X handling
Date:   Fri,  6 Oct 2023 09:41:01 -0700
Message-Id: <3fcc1552648614e2d37fa2dc997f59184efad838.1696609476.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1696609476.git.reinette.chatre@intel.com>
References: <cover.1696609476.git.reinette.chatre@intel.com>
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

VFIO PCI interrupt management uses a single entry for both
MSI and MSI-X management with the called functions using a boolean
when necessary to distinguish between MSI and MSI-X. This remains
unchanged.

Virtual device interrupt management should not be required to
use the same callback for both MSI and MSI-X. It may be possible
for a virtual device to not support MSI at all and only
provide MSI-X interrupt management.

Separate the MSI and MSI-X interrupt management by allowing
different callbacks for each interrupt type. For PCI devices
the callback remains the same.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 14 +++++++++++++-
 include/linux/vfio_pci_core.h     |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index e2d39b7561b8..76ec5af3681a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -800,6 +800,7 @@ struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 	.set_intx_unmask = vfio_pci_set_intx_unmask,
 	.set_intx_trigger = vfio_pci_set_intx_trigger,
 	.set_msi_trigger = vfio_pci_set_msi_trigger,
+	.set_msix_trigger = vfio_pci_set_msi_trigger,
 	.set_err_trigger = vfio_pci_set_err_trigger,
 	.set_req_trigger = vfio_pci_set_req_trigger,
 };
@@ -838,7 +839,6 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 		}
 		break;
 	case VFIO_PCI_MSI_IRQ_INDEX:
-	case VFIO_PCI_MSIX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_MASK:
 		case VFIO_IRQ_SET_ACTION_UNMASK:
@@ -850,6 +850,18 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			break;
 		}
 		break;
+	case VFIO_PCI_MSIX_IRQ_INDEX:
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			/* XXX Need masking support exported */
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			if (intr_ctx->ops->set_msix_trigger)
+				func = intr_ctx->ops->set_msix_trigger;
+			break;
+		}
+		break;
 	case VFIO_PCI_ERR_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index aba69669ec25..e9bfca9a0c0a 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -72,6 +72,9 @@ struct vfio_pci_intr_ops {
 	int (*set_msi_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
 			       unsigned int index, unsigned int start,
 			       unsigned int count, uint32_t flags, void *data);
+	int (*set_msix_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
+				unsigned int index, unsigned int start,
+				unsigned int count, uint32_t flags, void *data);
 	int (*set_err_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
 			       unsigned int index, unsigned int start,
 			       unsigned int count, uint32_t flags, void *data);
-- 
2.34.1

