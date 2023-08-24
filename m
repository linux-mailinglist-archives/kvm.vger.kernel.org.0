Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5B8787510
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 18:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242453AbjHXQRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 12:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242485AbjHXQRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 12:17:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189301BCE;
        Thu, 24 Aug 2023 09:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692893819; x=1724429819;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yvzC8rOAEf+j2WN5Y5D6UuaWb8/TjFD02ROTEAzmBo8=;
  b=DTp5pCxGgZ9Blo4bguNZDXe3IPBDd3swZpSadbOC3xfF2W14vRSD3vCb
   GonGKVEwgCWX0tTjXrRnStH0zAGrpFxTChut8Sl6oESLs1qecXqNjJaX+
   zYWij+CWt7DijgrOkg+gdTzlKZhecZRdOBT1BULVQSyZY5LXmQ1fzDEmv
   0G8tFjpavTEq17lsrX6HaDv9l58xxmctESK5RTU0L1QpETWsGegrinj18
   mrgOdRt6h1Uy5lD0H1MHrnrRZvSLfDmvSebVZ4tnIVwGTPbmbPtMNqGUA
   W0thjo1DVZ3PY0Dpn9MpCNsUVlDELw33CZ7KRIdhrnWxyBCvLkcU8psAL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="364679268"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="364679268"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 09:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="686970911"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="686970911"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 09:15:38 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] vfio/ims: Add helper that returns IMS index
Date:   Thu, 24 Aug 2023 09:15:22 -0700
Message-Id: <2e293a866f071d6a116cad8c9b725298b8217f43.1692892275.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1692892275.git.reinette.chatre@intel.com>
References: <cover.1692892275.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
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

Introduce vfio_pci_ims_hwirq() to VFIO PCI IMS as a helper that
returns the IMS interrupt index backing a provided MSI-X
interrupt index belonging to a guest.

Originally-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_ims.c | 21 +++++++++++++++++++++
 include/linux/vfio.h            |  7 +++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_ims.c b/drivers/vfio/pci/vfio_pci_ims.c
index fe5b3484ad34..27711bc7a6c2 100644
--- a/drivers/vfio/pci/vfio_pci_ims.c
+++ b/drivers/vfio/pci/vfio_pci_ims.c
@@ -37,6 +37,27 @@ struct vfio_pci_ims_ctx {
 	union msi_instance_cookie	icookie;
 };
 
+/*
+ * Return IMS index of IMS interrupt backing MSI-X interrupt @vector
+ */
+int vfio_pci_ims_hwirq(struct vfio_device *vdev, unsigned int vector)
+{
+	struct vfio_pci_ims *ims = &vdev->ims;
+	struct vfio_pci_ims_ctx *ctx;
+	int id;
+
+	mutex_lock(&ims->ctx_mutex);
+	ctx = xa_load(&ims->ctx, vector);
+	if (!ctx || ctx->emulated)
+		id = -EINVAL;
+	else
+		id = ctx->ims_id;
+	mutex_unlock(&ims->ctx_mutex);
+
+	return id;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_ims_hwirq);
+
 /*
  * Send signal to the eventfd.
  * @vdev:	VFIO device
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 906220002ff4..1c0e1bddd95b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -339,6 +339,7 @@ int vfio_pci_ims_set_emulated(struct vfio_device *vdev, unsigned int start,
 void vfio_pci_ims_send_signal(struct vfio_device *vdev, unsigned int vector);
 int vfio_pci_ims_set_cookie(struct vfio_device *vdev, unsigned int vector,
 			    union msi_instance_cookie *icookie);
+int vfio_pci_ims_hwirq(struct vfio_device *vdev, unsigned int vector);
 #else
 static inline int vfio_pci_set_ims_trigger(struct vfio_device *vdev,
 					   unsigned int index,
@@ -374,6 +375,12 @@ static inline int vfio_pci_ims_set_cookie(struct vfio_device *vdev,
 	return -EOPNOTSUPP;
 }
 
+static inline int vfio_pci_ims_hwirq(struct vfio_device *vdev,
+				     unsigned int index)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_VFIO_PCI_IMS */
 
 #endif /* VFIO_H */
-- 
2.34.1

