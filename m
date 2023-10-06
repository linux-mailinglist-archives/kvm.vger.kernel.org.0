Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D7B7BBD08
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbjJFQmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjJFQll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA9B11C;
        Fri,  6 Oct 2023 09:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610497; x=1728146497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z0Mc5dvLT5KGnD3D7yCcZmtKbAh89mWjRJrUM/fYnfc=;
  b=NpxYI/YFO7xjJqkmdVimYk0Cxa9vt2SCLE/5CVV9wcEEWlIMhLsPGfoa
   8msuw+s9rFP+fGkMLssaxeya0lXMumerzdwye+OLG/amX/LVED6IoNqGR
   Gl4XeL+Oi+XNC0JK1zFyeAtJdLp5A53QuU7d/KbPgLL65r/rN4mdRtNKf
   JpQIi+S3yzkua0GkA5K9unz4IX2eR05e5FF2UNYyL0HkFMLCwdYUYOVPk
   hMa2HB4qHv2lPiL/mH66Q+Azrq7XRH3HofnvEZ69DqGnC2tmwkk188Rrc
   b53gQEgjXlo9b2DhS3fImtLws0wEZdfAtGMINySIfQsot+Fg5kIoXn3mX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063244"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063244"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892899"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892899"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:28 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 17/18] vfio/pci: Add accessor for IMS index
Date:   Fri,  6 Oct 2023 09:41:12 -0700
Message-Id: <1603f5122e63dd53c7d2f94bd5127fd1cf6aff65.1696609476.git.reinette.chatre@intel.com>
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

A virtual device driver needs to facilitate translation between
the guest's MSI-X interrupt and the backing IMS interrupt with
which the physical device is programmed. For example, the
guest may need to obtain the IMS index from the virtual device driver
that it needs to program into descriptors submitted to the device
to ensure that the completion interrupts are generated correctly.

Introduce vfio_pci_ims_hwirq() to the IMS backend as a helper
that returns the IMS interrupt index backing a provided MSI-X
interrupt index belonging to a guest.

Originally-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 25 +++++++++++++++++++++++++
 include/linux/vfio_pci_core.h     |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index f96d7481094a..df458aed2175 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -1203,6 +1203,31 @@ int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_set_emulated);
 
+/*
+ * Return IMS index of IMS interrupt backing MSI-X interrupt @vector
+ */
+int vfio_pci_ims_hwirq(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	int id = -EINVAL;
+
+	mutex_lock(&intr_ctx->igate);
+
+	if (!intr_ctx->ims_backed_irq)
+		goto out_unlock;
+
+	ctx = vfio_irq_ctx_get(intr_ctx, vector);
+	if (!ctx || ctx->emulated)
+		goto out_unlock;
+
+	id = ctx->ims_id;
+
+out_unlock:
+	mutex_unlock(&intr_ctx->igate);
+	return id;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_hwirq);
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 3c5df1d13e5d..c6e399b39e90 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -167,6 +167,7 @@ int vfio_pci_ims_init_intr_ctx(struct vfio_device *vdev,
 			       struct vfio_pci_intr_ctx *intr_ctx,
 			       struct pci_dev *pdev,
 			       union msi_instance_cookie *default_cookie);
+int vfio_pci_ims_hwirq(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
 void vfio_pci_ims_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx);
 void vfio_pci_send_signal(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
 int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
-- 
2.34.1

