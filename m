Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9065C7D9E8F
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346366AbjJ0RCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbjJ0RBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CD2D48;
        Fri, 27 Oct 2023 10:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426097; x=1729962097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jAVKFX+vaV6MZ7MbRQwvQO7Qe37BB/mxkHKB6ZjkpCk=;
  b=MvTqs5TSbsZ394BMBLoEgBhlqlrW/3EW+C2mUtjddyVDqBlSc1jRxnJG
   jp8Ajk/ROAcoG13iPoGWfHdNvkkFQHnR8wzVteDqXuNi0++GPnzWUbv6C
   XqlVqnwdw+D3hUwHaWh4fyTlw/NXz2RJOCqQZl7CVu5+sCOHoxtdSm2I7
   bA+RnvQiD3wDQphzB8RqXbE9ZDYzz092utHk8RvA21QhLRAR/lyzVdDWX
   g5+9miz/2o5NZZuWbi6nANUM7V6+P6rbHZtCzJOkqFYp2l01BJqm2tXKa
   O7FdxJ1eqebLzIi71eZpSwmuWTmZVamnoziLquU3dLltEfnJ0x5nX7BMH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612078"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612078"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988220"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988220"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:19 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 19/26] vfio/pci: Store Linux IRQ number in per-interrupt context
Date:   Fri, 27 Oct 2023 10:00:51 -0700
Message-Id: <fe821ea81644a358e664438e8a4af5adbac02b84.1698422237.git.reinette.chatre@intel.com>
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

The Linux IRQ number is a property shared among all interrupt
backends but not all interrupt management backends have a simple
query for it. pci_irq_vector() can be used to obtain the Linux
IRQ number of a MSI-X interrupt but there is no such
query for IMS interrupts.

The Linux IRQ number is needed during interrupt free as well
as during register of IRQ bypass producer. It is unnecessary to
query the Linux IRQ number at each stage, the number can be
stored at the time the interrupt is allocated and obtained
from its per-interrupt context when needed.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8d84e7d62594..fd0713dc9f81 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -29,6 +29,7 @@ struct vfio_pci_irq_ctx {
 	char			*name;
 	bool			masked;
 	struct irq_bypass_producer	producer;
+	int			virq;
 };
 
 static bool irq_is(struct vfio_pci_intr_ctx *intr_ctx, int type)
@@ -431,10 +432,11 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 
 	if (ctx && ctx->trigger) {
 		irq_bypass_unregister_producer(&ctx->producer);
-		irq = pci_irq_vector(pdev, vector);
+		irq = ctx->virq;
 		cmd = vfio_pci_memory_lock_and_enable(vdev);
-		free_irq(irq, ctx->trigger);
+		free_irq(ctx->virq, ctx->trigger);
 		vfio_pci_memory_unlock_and_restore(vdev, cmd);
+		ctx->virq = 0;
 		/* Interrupt stays allocated, will be freed at MSI-X disable. */
 		kfree(ctx->name);
 		ctx->name = NULL;
@@ -488,8 +490,10 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 	if (ret)
 		goto out_put_eventfd_ctx;
 
+	ctx->virq = irq;
+
 	ctx->producer.token = trigger;
-	ctx->producer.irq = irq;
+	ctx->producer.irq = ctx->virq;
 	ret = irq_bypass_register_producer(&ctx->producer);
 	if (unlikely(ret)) {
 		dev_info(&pdev->dev,
-- 
2.34.1

