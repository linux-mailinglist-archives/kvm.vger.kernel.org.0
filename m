Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3E87D9E71
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346111AbjJ0RBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345955AbjJ0RBb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564BD128;
        Fri, 27 Oct 2023 10:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426090; x=1729962090;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g0joQn3WaEtVm0P8mwhR6h/BllZzb35jHWARL4FWxWs=;
  b=O5atHFpstQ4Edi5/Qt2tAp8YeY+h6nHUsRvsNJ9p/1p0x/HSsoX5oGXR
   wyNog9G+FcCB4SlqUvvD80a0C0Bv9f5sCb/vstK9hA3nA4PCHfSfEPa3g
   cbwWX1pcWtddUFqZQaZX3bi1C848qCZzRUWUzcVZwKg6fRf0lpHqEYwCT
   8S8e5gMdkdWC2OfG3Vu67l8QBYkaSxXjUpqnlRXICz3r6ndFpZNzbfVbG
   I0dIY5C0rzVFKEViRIiPp+0R8BLK1+wifKgzwa0i/AXy91Ey91emBtP3W
   2RgoqRedMJB8zUf8/Nfdyt8vvfBogGeJuU5nGPdjUho/HQbxa28m9nunU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611878"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611878"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988166"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988166"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:15 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 06/26] vfio/pci: Separate MSI and MSI-X handling
Date:   Fri, 27 Oct 2023 10:00:38 -0700
Message-Id: <397accb1341ac18273e6bc3e39361693a5411b4f.1698422237.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1698422237.git.reinette.chatre@intel.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
No changes since RFC V2.

 drivers/vfio/pci/vfio_pci_intrs.c | 14 +++++++++++++-
 include/linux/vfio_pci_core.h     |  3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 96587acfebf0..7de906363402 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -801,6 +801,7 @@ static struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 	.set_intx_unmask = vfio_pci_set_intx_unmask,
 	.set_intx_trigger = vfio_pci_set_intx_trigger,
 	.set_msi_trigger = vfio_pci_set_msi_trigger,
+	.set_msix_trigger = vfio_pci_set_msi_trigger,
 	.set_err_trigger = vfio_pci_set_err_trigger,
 	.set_req_trigger = vfio_pci_set_req_trigger,
 };
@@ -839,7 +840,6 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 		}
 		break;
 	case VFIO_PCI_MSI_IRQ_INDEX:
-	case VFIO_PCI_MSIX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_MASK:
 		case VFIO_IRQ_SET_ACTION_UNMASK:
@@ -851,6 +851,18 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
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
index d3fa0e49a1a8..db7ee9517d94 100644
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

