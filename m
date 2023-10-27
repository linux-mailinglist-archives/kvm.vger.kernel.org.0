Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9CE7D9E7E
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346370AbjJ0RCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346205AbjJ0RBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AB2D42;
        Fri, 27 Oct 2023 10:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426095; x=1729962095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4LhbS49tlQOs/14GbzRw202WRPZQBhJkwr2CrMC/ZaY=;
  b=kcXIbjiEKNGKI8v2mnKTODYnLTJJnHS7n7KO/at3i9BQkoYvmho0KaeS
   5qzUMOZELRGLGoZRPgSD+NanqI1wNycY/3wcT4uDx2JnprxVj6QYyFva7
   boUc/NcEU6EWQ25Dn1maNTdYYMHnDnH+8x+ArwDd6z5W25+fQMHuGjhZY
   xIoxUoGVgqo0p2T7/CrdpIuPB3e/EPm7i0KtPcgAsjc2CU87dOkVxzAqW
   QXZUZESLFd2BBuwhPrNl72HcNUM4RBHm2gIffccDb1XluPnNlfC0Iwb7z
   4BSpGCwqipUqC1KwinkFMgcMQlX+IdZ03A+KcmuEcYPWtMaq6ZTGRIeVN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611999"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611999"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988208"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988208"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:18 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 16/26] vfio/pci: Split interrupt context initialization
Date:   Fri, 27 Oct 2023 10:00:48 -0700
Message-Id: <1f65808ba9e7c54c5ea1590dadfeb1e10ac5c276.1698422237.git.reinette.chatre@intel.com>
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

struct vfio_pci_intr_ctx is the context associated with interrupts
of a virtual device. The interrupt context is initialized with
backend specific data required by the particular interrupt management
backend as well as common initialization required by all interrupt
management backends.

Split interrupt context initialization into common and interrupt
management backend specific calls. The entrypoint will be the
initialization of a particular interrupt management backend which
in turn calls the common initialization.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
No changes since RFC V2.

 drivers/vfio/pci/vfio_pci_intrs.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index adad93c31ac6..14131d5288e3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -801,6 +801,18 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_intr_ctx *intr_ctx,
 					       count, flags, data);
 }
 
+static void _vfio_pci_init_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
+{
+	intr_ctx->irq_type = VFIO_PCI_NUM_IRQS;
+	mutex_init(&intr_ctx->igate);
+	xa_init(&intr_ctx->ctx);
+}
+
+static void _vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
+{
+	mutex_destroy(&intr_ctx->igate);
+}
+
 static struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 	.set_intx_mask = vfio_pci_set_intx_mask,
 	.set_intx_unmask = vfio_pci_set_intx_unmask,
@@ -814,17 +826,15 @@ static struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 void vfio_pci_init_intr_ctx(struct vfio_pci_core_device *vdev,
 			    struct vfio_pci_intr_ctx *intr_ctx)
 {
-	intr_ctx->irq_type = VFIO_PCI_NUM_IRQS;
+	_vfio_pci_init_intr_ctx(intr_ctx);
 	intr_ctx->ops = &vfio_pci_intr_ops;
 	intr_ctx->priv = vdev;
-	mutex_init(&intr_ctx->igate);
-	xa_init(&intr_ctx->ctx);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_init_intr_ctx);
 
 void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
 {
-	mutex_destroy(&intr_ctx->igate);
+	_vfio_pci_release_intr_ctx(intr_ctx);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_release_intr_ctx);
 
-- 
2.34.1

