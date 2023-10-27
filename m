Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461997D9E7D
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346470AbjJ0RCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346274AbjJ0RBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E986129;
        Fri, 27 Oct 2023 10:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426099; x=1729962099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q5E2bhYf2dMQUdkDHlF7uY8ToTzJMpiMxWpjZP6f9Y8=;
  b=b1vR/AhPxpJVSQ3hu6CVYE2YjPv8SCJ7M+bya/slVET+dTGcbD5y1T8e
   egS99gGDlQuGa6NqBwS3CDznDIZYT3P+19CIcLWDF1Ho4i07wj7ZmF25R
   pH3DvE4Z0NKhvPTZOB8NrCrliNhgvtoOsdEatFPY+POPhSOBbrEDw0NPb
   2qY3IzIMczBDpIHkZY5NWeo9mRT4sUJXHPHorcge8X9PDQ+CeRpDMrMMq
   phRZ5qT9blhnUKO8QOH9B5j3Q3ySmt6UKdLHAvC5DoAFouGEe9m1nrjnk
   ZAm4+kmf3zczJoYGBymk7xF1KwZiJpDpImlC8f4t0g+bI0thD6kykpDis
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612103"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612103"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988226"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988226"
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
Subject: [RFC PATCH V3 21/26] vfio/pci: Replace backend specific calls with callbacks
Date:   Fri, 27 Oct 2023 10:00:53 -0700
Message-Id: <ac8c3b0bffc6680e9039ac04b3c33efe9195073e.1698422237.git.reinette.chatre@intel.com>
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

The backend specific code needed to manage the interrupts are
isolated into separate functions. With the backend specific
code isolated into functions, these functions
can be turned into callbacks for other backends to use.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 17 +++++++++++------
 include/linux/vfio_pci_core.h     | 15 +++++++++++++++
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index c1f65b8adfe2..1e6376b048de 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -490,7 +490,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 
 	if (ctx && ctx->trigger) {
 		irq_bypass_unregister_producer(&ctx->producer);
-		vfio_msi_free_interrupt(intr_ctx, ctx, vector);
+		intr_ctx->ops->msi_free_interrupt(intr_ctx, ctx, vector);
 		kfree(ctx->name);
 		ctx->name = NULL;
 		eventfd_ctx_put(ctx->trigger);
@@ -507,7 +507,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 			return -ENOMEM;
 	}
 
-	ctx->name = vfio_msi_device_name(intr_ctx, vector, index);
+	ctx->name = intr_ctx->ops->msi_device_name(intr_ctx, vector, index);
 	if (!ctx->name)
 		return -ENOMEM;
 
@@ -519,7 +519,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_intr_ctx *intr_ctx,
 
 	ctx->trigger = trigger;
 
-	ret = vfio_msi_request_interrupt(intr_ctx, ctx, vector, index);
+	ret = intr_ctx->ops->msi_request_interrupt(intr_ctx, ctx, vector, index);
 	if (ret)
 		goto out_put_eventfd_ctx;
 
@@ -708,7 +708,7 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 	unsigned int i;
 
 	if (irq_is(intr_ctx, index) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
-		vfio_msi_disable(intr_ctx, index);
+		intr_ctx->ops->msi_disable(intr_ctx, index);
 		return 0;
 	}
 
@@ -723,13 +723,13 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 			return vfio_msi_set_block(intr_ctx, start, count,
 						  fds, index);
 
-		ret = vfio_msi_enable(intr_ctx, start + count, index);
+		ret = intr_ctx->ops->msi_enable(intr_ctx, start + count, index);
 		if (ret)
 			return ret;
 
 		ret = vfio_msi_set_block(intr_ctx, start, count, fds, index);
 		if (ret)
-			vfio_msi_disable(intr_ctx, index);
+			intr_ctx->ops->msi_disable(intr_ctx, index);
 
 		return ret;
 	}
@@ -872,6 +872,11 @@ static struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 	.set_msix_trigger = vfio_pci_set_msi_trigger,
 	.set_err_trigger = vfio_pci_set_err_trigger,
 	.set_req_trigger = vfio_pci_set_req_trigger,
+	.msi_enable = vfio_msi_enable,
+	.msi_disable = vfio_msi_disable,
+	.msi_request_interrupt = vfio_msi_request_interrupt,
+	.msi_free_interrupt = vfio_msi_free_interrupt,
+	.msi_device_name = vfio_msi_device_name,
 };
 
 void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 8d2fb51a2dcc..f0951084a26f 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -69,6 +69,8 @@ struct vfio_pci_intr_ctx {
 	int				irq_type;
 };
 
+struct vfio_pci_irq_ctx;
+
 struct vfio_pci_intr_ops {
 	int (*set_intx_mask)(struct vfio_pci_intr_ctx *intr_ctx,
 			     unsigned int index, unsigned int start,
@@ -91,6 +93,19 @@ struct vfio_pci_intr_ops {
 	int (*set_req_trigger)(struct vfio_pci_intr_ctx *intr_ctx,
 			       unsigned int index, unsigned int start,
 			       unsigned int count, uint32_t flags, void *data);
+	int (*msi_enable)(struct vfio_pci_intr_ctx *intr_ctx, int nvec,
+			  unsigned int index);
+	void (*msi_disable)(struct vfio_pci_intr_ctx *intr_ctx,
+			    unsigned int index);
+	int (*msi_request_interrupt)(struct vfio_pci_intr_ctx *intr_ctx,
+				     struct vfio_pci_irq_ctx *ctx,
+				     unsigned int vector,
+				     unsigned int index);
+	void (*msi_free_interrupt)(struct vfio_pci_intr_ctx *intr_ctx,
+				   struct vfio_pci_irq_ctx *ctx,
+				   unsigned int vector);
+	char *(*msi_device_name)(struct vfio_pci_intr_ctx *intr_ctx,
+				 unsigned int vector, unsigned int index);
 };
 
 struct vfio_pci_core_device {
-- 
2.34.1

