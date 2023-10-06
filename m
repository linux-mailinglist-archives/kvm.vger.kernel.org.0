Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08517BBCFF
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjJFQlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbjJFQle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE88CA;
        Fri,  6 Oct 2023 09:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610490; x=1728146490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7lg4ugaNhVT8RBGTE4Cyh9T0xB/RfOce2ILlwe3gFk=;
  b=Vif2RSIVDFIIJuYClDM1+8LlbrFJ5NLUq3DTxdLEEtgAntQVeOcfrHby
   8gU0BPGABuEU9PopOFKbw435BjJxwX0drIuyJs54cSOH+vvxZq7KaQaTf
   PVXo06tPDRcpo3+udwxQ7ks730KtPUqt5ENuVvcADl6iklaCGXUQ46d/8
   OFroEI6ODXscttxMA6MO6fpz+20tplIZSIWHY57Vv6Y6P2hSWk75f9KLy
   soznryD7o5nVAaKZXdTveC0uuhNww292hxUQ19s/49HSADKW1d6993L05
   QVVLWpH5eLOu12KFdFgrXTr9L7/sNSANEuG0SLq1fWDcKpQbr5t00k03E
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063209"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063209"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892871"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892871"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:26 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 11/18] vfio/pci: Split interrupt context initialization
Date:   Fri,  6 Oct 2023 09:41:06 -0700
Message-Id: <e43c64a0862960422b4e768a0336886276c7c137.1696609476.git.reinette.chatre@intel.com>
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
 drivers/vfio/pci/vfio_pci_intrs.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index eb718787470f..8c9d44e99e7b 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -793,6 +793,18 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_intr_ctx *intr_ctx,
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
 struct vfio_pci_intr_ops vfio_pci_intr_ops = {
 	.set_intx_mask = vfio_pci_set_intx_mask,
 	.set_intx_unmask = vfio_pci_set_intx_unmask,
@@ -806,17 +818,15 @@ struct vfio_pci_intr_ops vfio_pci_intr_ops = {
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

