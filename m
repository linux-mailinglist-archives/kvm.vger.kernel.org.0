Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9747E7BBD05
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjJFQl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbjJFQll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639DB106;
        Fri,  6 Oct 2023 09:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610494; x=1728146494;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=44H3e8OIAR4AdEwORIgxqPqp8eHloccs4kRdOQa424c=;
  b=bDOo5YypGACUWOVO8OPCjmW4ObWha1jG9NI7MSYZuiEmYizb7dyxz6Uc
   FN1FsLOrLqWbWqerD/bpLoFKL86VCec87mVSv9CNt3BX3oDYRfhIQXtBr
   uFw+R4dsVxeDG3zM9i60rRVgTs0UmKtqZKBkEJ9GOean1P8ecn2vncxMl
   ++0Z3YGbYQqFkR7ZZ4CMrb8lujyDJ5XgrasHX+Oa7saLO+VUcwQ++N0ZR
   abdJIOYRk0IYhqs5VH+d5JV6is5eBuL92WawtvNwHhLMFJoqvJ/weTI9G
   l4wYX4TvhlqOEithnreI9LQRVhZHGp3Jk79XRmfA+v4Mu3mDDoSicCiBC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063238"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063238"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892893"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892893"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:27 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 16/18] vfio/pci: Support emulated interrupts in IMS backend
Date:   Fri,  6 Oct 2023 09:41:11 -0700
Message-Id: <ad5d28f37b96f1f8c9da27749de429a98c96ba4a.1696609476.git.reinette.chatre@intel.com>
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

An emulated interrupt has an associated eventfd but is
not backed by a hardware interrupt.

Add support for emulated interrupts to the IMS backend
that generally involves avoiding the actions involving
hardware configuration.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index c6b213d52beb..f96d7481094a 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -863,8 +863,8 @@ EXPORT_SYMBOL_GPL(vfio_pci_release_intr_ctx);
 /*
  * Free the IMS interrupt associated with @ctx.
  *
- * For an IMS interrupt the interrupt is freed from the underlying
- * PCI device's IMS domain.
+ * For an emulated interrupt there is nothing to do. For an IMS interrupt
+ * the interrupt is freed from the underlying PCI device's IMS domain.
  */
 static void vfio_pci_ims_irq_free(struct vfio_pci_intr_ctx *intr_ctx,
 				  struct vfio_pci_irq_ctx *ctx)
@@ -872,6 +872,9 @@ static void vfio_pci_ims_irq_free(struct vfio_pci_intr_ctx *intr_ctx,
 	struct vfio_pci_ims *ims = intr_ctx->priv;
 	struct msi_map irq_map = {};
 
+	if (ctx->emulated)
+		return;
+
 	irq_map.index = ctx->ims_id;
 	irq_map.virq = ctx->virq;
 	pci_ims_free_irq(ims->pdev, irq_map);
@@ -882,8 +885,8 @@ static void vfio_pci_ims_irq_free(struct vfio_pci_intr_ctx *intr_ctx,
 /*
  * Allocate a host IMS interrupt for @ctx.
  *
- * For an IMS interrupt the interrupt is allocated from the underlying
- * PCI device's IMS domain.
+ * For an emulated interrupt there is nothing to do. For an IMS interrupt
+ * the interrupt is allocated from the underlying PCI device's IMS domain.
  */
 static int vfio_pci_ims_irq_alloc(struct vfio_pci_intr_ctx *intr_ctx,
 				  struct vfio_pci_irq_ctx *ctx)
@@ -891,6 +894,9 @@ static int vfio_pci_ims_irq_alloc(struct vfio_pci_intr_ctx *intr_ctx,
 	struct vfio_pci_ims *ims = intr_ctx->priv;
 	struct msi_map irq_map = {};
 
+	if (ctx->emulated)
+		return -EINVAL;
+
 	irq_map = pci_ims_alloc_irq(ims->pdev, &ctx->icookie, NULL);
 	if (irq_map.index < 0)
 		return irq_map.index;
@@ -913,9 +919,11 @@ static int vfio_pci_ims_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 	ctx = vfio_irq_ctx_get(intr_ctx, vector);
 
 	if (ctx && ctx->trigger) {
-		irq_bypass_unregister_producer(&ctx->producer);
-		free_irq(ctx->virq, ctx->trigger);
-		vfio_pci_ims_irq_free(intr_ctx, ctx);
+		if (!ctx->emulated) {
+			irq_bypass_unregister_producer(&ctx->producer);
+			free_irq(ctx->virq, ctx->trigger);
+			vfio_pci_ims_irq_free(intr_ctx, ctx);
+		}
 		kfree(ctx->name);
 		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
@@ -945,6 +953,9 @@ static int vfio_pci_ims_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 
 	ctx->trigger = trigger;
 
+	if (ctx->emulated)
+		return 0;
+
 	ret = vfio_pci_ims_irq_alloc(intr_ctx, ctx);
 	if (ret < 0)
 		goto out_put_eventfd_ctx;
@@ -1078,7 +1089,7 @@ int vfio_pci_ims_init_intr_ctx(struct vfio_device *vdev,
 
 	intr_ctx->ops = &vfio_pci_ims_intr_ops;
 	intr_ctx->priv = ims;
-	intr_ctx->supports_emulated = false;
+	intr_ctx->supports_emulated = true;
 	intr_ctx->ims_backed_irq = true;
 
 	return 0;
-- 
2.34.1

