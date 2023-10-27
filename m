Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9057D9E7F
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346465AbjJ0RCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346289AbjJ0RBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1693ED5A;
        Fri, 27 Oct 2023 10:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426099; x=1729962099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aMCoAudS/OSl3PQsYt3+4hHw4XTo4wOWeFRNgKX6Zxk=;
  b=GRypearYxPV+atYqhqCh8AbR2GbLN2ZFBpb9WoRHjWKufGDISmkFTrSU
   q9ZNYHIiL+YEkaxJSul3tKz4E8lQ9l76NZwMt8F5PiOY83srOmZl/mMP3
   U7ylNCWeZusc02UEJi+YcKZLsAI2xB4UQmg9ddZLq4xwXIE1axeEAF2Sn
   J+8shuFV2RIvRtof5Lpe/41m4mV15+UKsu5TSM1KyXc5T6wOOyOKjvioC
   WF70MZPZXeoHEHZfNGqOQfD+u3Pldp8sbbTLw6hHh+QSoUPCKr5EjFKLv
   Pn87dmrdpGI/eIkFdYKKheZhfNqtUPGlsfyYS5jE7emfVEaYwMh7e9UWu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612113"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612113"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988230"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988230"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:20 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 22/26] vfio/pci: Introduce backend specific context initializer
Date:   Fri, 27 Oct 2023 10:00:54 -0700
Message-Id: <6b3f44ab66c4408b0b7d277b40ed6edac9e83708.1698422237.git.reinette.chatre@intel.com>
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

The per-interrupt context may contain backend specific data.

Call a backend provided initializer on per-interrupt context
creation.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- New patch

 drivers/vfio/pci/vfio_pci_intrs.c | 8 ++++++++
 include/linux/vfio_pci_core.h     | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 1e6376b048de..8c86f2d6229f 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -73,6 +73,14 @@ vfio_irq_ctx_alloc(struct vfio_pci_intr_ctx *intr_ctx, unsigned long index)
 	if (!ctx)
 		return NULL;
 
+	if (intr_ctx->ops->init_irq_ctx) {
+		ret = intr_ctx->ops->init_irq_ctx(intr_ctx, ctx);
+		if (ret < 0) {
+			kfree(ctx);
+			return NULL;
+		}
+	}
+
 	ret = xa_insert(&intr_ctx->ctx, index, ctx, GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		kfree(ctx);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f0951084a26f..d5140a732741 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -106,6 +106,8 @@ struct vfio_pci_intr_ops {
 				   unsigned int vector);
 	char *(*msi_device_name)(struct vfio_pci_intr_ctx *intr_ctx,
 				 unsigned int vector, unsigned int index);
+	int (*init_irq_ctx)(struct vfio_pci_intr_ctx *intr_ctx,
+			    struct vfio_pci_irq_ctx *ctx);
 };
 
 struct vfio_pci_core_device {
-- 
2.34.1

