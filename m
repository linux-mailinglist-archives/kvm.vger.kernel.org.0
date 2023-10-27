Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF597D9E8C
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346489AbjJ0RCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346313AbjJ0RBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66646D64;
        Fri, 27 Oct 2023 10:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426101; x=1729962101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tbz3SXJJY7i1djigYQYirkmt+YTKLECJsMGiiTtlipg=;
  b=mhzsi8qRl9dKKufxxHLRj/zfPp/MuUkphL2MYY6oWbd0wFJOhINfyfx8
   RtwWkSIn9nAC0XY1bu5RplNbIUTEtvkiH0vkfPXeV6j4ynGQPtRG2Vk2j
   jSjQ75LFEJVtSw16ly3TDeTPLlMhmbbzmXuhluRc8b5Bv16D4Pre1nYuS
   ODZ5A+A3545OQ9NRIp5/twiMpSjIoXnX8ekYA1al6ee38h971iefcbsLH
   pFhgqODQXbXFU6ENUN8iXsXUeggZ0rYUpioF7QyrZ64VUDoCTWGRuqKNe
   odbXhk+jA2kxY9R9YE3Gj9MVm7j+tCpIoKyjEH8cgvv/ZNiMzQDHwaQIJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612148"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612148"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988246"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988246"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:21 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 25/26] vfio/pci: Add accessor for IMS index
Date:   Fri, 27 Oct 2023 10:00:57 -0700
Message-Id: <f76998db7e1cc5445069ff42ceaf3179667cd932.1698422237.git.reinette.chatre@intel.com>
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
No changes since RFC V2.

 drivers/vfio/pci/vfio_pci_intrs.c | 25 +++++++++++++++++++++++++
 include/linux/vfio_pci_core.h     |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b318a3f671e8..32ebc8fec4c4 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -1163,6 +1163,31 @@ void vfio_pci_ims_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_ims_release_intr_ctx);
 
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
index a3161af791f8..dbc77839ef26 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -180,6 +180,7 @@ void vfio_pci_release_intr_ctx(struct vfio_pci_intr_ctx *intr_ctx);
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data);
+int vfio_pci_ims_hwirq(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
 void vfio_pci_send_signal(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
 int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
 			  unsigned int start, unsigned int count);
-- 
2.34.1

