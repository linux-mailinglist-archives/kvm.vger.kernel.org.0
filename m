Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07A57D9E8A
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346476AbjJ0RCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346337AbjJ0RBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD8BD6A;
        Fri, 27 Oct 2023 10:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426101; x=1729962101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rp7C9TZkUzJPsNhPFEIC2B+5Ox/xRqY6xhnZVuHn0yI=;
  b=FAjSJBjUqzICuPgU+fF0Nevl+H6P2gd9wl7xPd5BTTI57ruSJ3IOmQTY
   cBsyUiSfvx3hYWLUw2HtfMcO9bgVq/hH8CGvDX9ITfv7PmxBeURZwrzEW
   ClblfP5GMfQwGzhFzrB08rOfcnMGWjr0apPipmA3mei1Dk/6eNnQ7nsYJ
   PTFt7HMvFOR2VzngPtZL4iOvND+EweGBC/yo2s3AkaicJduX3k9oY1QAf
   /Z5YrF/LCClkeyEQdPQcHvTK1l0BouP1bSnEemvAa4siRDrbQp7UnI6Do
   As+S/1bW/gNUC399a4YU2QXSLlzWYk3v4yTCp9G7N7bb1cVWCy3TzOGja
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="612150"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="612150"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988252"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988252"
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
Subject: [RFC PATCH V3 26/26] vfio/pci: Support IMS cookie modification
Date:   Fri, 27 Oct 2023 10:00:58 -0700
Message-Id: <5a118965e4ae827c28c2b1de6fa791e9ebfd5958.1698422237.git.reinette.chatre@intel.com>
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

IMS supports an implementation specific cookie that is associated
with each interrupt. By default the IMS interrupt allocation backend
will assign a default cookie to a new interrupt instance.

Add support for a virtual device driver to set the interrupt instance
specific cookie. For example, the virtual device driver may intercept
the guest's MMIO write that configuresa a new PASID for a particular
interrupt. Calling vfio_pci_ims_set_cookie() with the new PASID value
as IMS cookie enables subsequent interrupts to be allocated with
accurate data.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
No changes since RFC V2.

 drivers/vfio/pci/vfio_pci_intrs.c | 53 +++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h     |  3 ++
 2 files changed, 56 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 32ebc8fec4c4..5dc22dd9390e 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -1188,6 +1188,59 @@ int vfio_pci_ims_hwirq(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_ims_hwirq);
 
+/*
+ * vfio_pci_ims_set_cookie() - Set unique cookie for vector.
+ * @intr_ctx:	Interrupt context.
+ * @vector:	Vector.
+ * @icookie:	New cookie for @vector.
+ *
+ * When new IMS interrupt is allocated for @vector it will be
+ * assigned @icookie.
+ */
+int vfio_pci_ims_set_cookie(struct vfio_pci_intr_ctx *intr_ctx,
+			    unsigned int vector,
+			    union msi_instance_cookie *icookie)
+{
+	struct vfio_pci_irq_ctx *ctx;
+	int ret = -EINVAL;
+
+	mutex_lock(&intr_ctx->igate);
+
+	if (!intr_ctx->ims_backed_irq)
+		goto out_unlock;
+
+	ctx = vfio_irq_ctx_get(intr_ctx, vector);
+	if (ctx) {
+		if (WARN_ON_ONCE(ctx->emulated)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+		ctx->icookie = *icookie;
+		ret = 0;
+		goto out_unlock;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	ctx->icookie = *icookie;
+	ret = xa_insert(&intr_ctx->ctx, vector, ctx, GFP_KERNEL_ACCOUNT);
+	if (ret) {
+		kfree(ctx);
+		goto out_unlock;
+	}
+
+	ret = 0;
+
+out_unlock:
+	mutex_unlock(&intr_ctx->igate);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_set_cookie);
+
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index dbc77839ef26..b989b533e852 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -181,6 +181,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 			    unsigned int index, unsigned int start,
 			    unsigned int count, void *data);
 int vfio_pci_ims_hwirq(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
+int vfio_pci_ims_set_cookie(struct vfio_pci_intr_ctx *intr_ctx,
+			    unsigned int vector,
+			    union msi_instance_cookie *icookie);
 void vfio_pci_send_signal(struct vfio_pci_intr_ctx *intr_ctx, unsigned int vector);
 int vfio_pci_set_emulated(struct vfio_pci_intr_ctx *intr_ctx,
 			  unsigned int start, unsigned int count);
-- 
2.34.1

