Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F557D9E6F
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346341AbjJ0RBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346109AbjJ0RBi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:01:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D211A5;
        Fri, 27 Oct 2023 10:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698426091; x=1729962091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oEdS6qGPsqVzRnAM51x5uz01SKSS8bbH3iIPSR6hDZw=;
  b=k8RiUUwGGJEaQLlIbDAB1w4DFegYeabb3obNF8pY3LlILE8JN4zCvmLy
   PyRCD5Lq99NbeqZREGmoIOOJKZwPfs46coN1Y46BWGR40dpYtzdmvKfxz
   gHUUAIeqZT7T0v8nXX+/ltKwOi0wNtgd66g7nDVT2JIBQ2xABKsvBYePT
   KYStpHS0Zzx9I8LWZLEXH8A9V4uluur+gHOejGF0epsWO1BnJFFsiYgY9
   IDEYKMl/FdHYV2Zb/5PGvWaWMNldvFZN9UJldOBUjw9mKjjLlJsujLJg2
   SO8hIgvReHM6pxiZxDNxpfvacGvhoDo5Oyi64g52X/T3He8KjHdSEp8/c
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="611899"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="611899"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10876"; a="1090988174"
X-IronPort-AV: E=Sophos;i="6.03,256,1694761200"; 
   d="scan'208";a="1090988174"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2023 10:01:15 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V3 08/26] vfio/pci: Move mutex acquisition into function
Date:   Fri, 27 Oct 2023 10:00:40 -0700
Message-Id: <c960f7f8d0d07a613d37d61288f1b7f91e4c0da1.1698422237.git.reinette.chatre@intel.com>
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

vfio_pci_set_irqs_ioctl() is the entrypoint for interrupt management
via the VFIO_DEVICE_SET_IRQS ioctl(). vfio_pci_set_irqs_ioctl() can
be called from a virtual device driver after its callbacks have been
configured to support the needed interrupt management.

The igate mutex is obtained before vfio_pci_set_irqs_ioctl() to protect
against concurrent changes to interrupt context. It should not be
necessary for all users of vfio_pci_set_irqs_ioctl() to remember to
take the mutex.

Acquire and release the mutex within vfio_pci_set_irqs_ioctl().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V2:
- Improve changelog.

 drivers/vfio/pci/vfio_pci_core.c  |  2 --
 drivers/vfio/pci/vfio_pci_intrs.c | 10 ++++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 5c9bd5d2db53..bf4de137ad2f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1214,12 +1214,10 @@ static int vfio_pci_ioctl_set_irqs(struct vfio_pci_core_device *vdev,
 			return PTR_ERR(data);
 	}
 
-	mutex_lock(&vdev->intr_ctx.igate);
 
 	ret = vfio_pci_set_irqs_ioctl(&vdev->intr_ctx, hdr.flags, hdr.index,
 				      hdr.start, hdr.count, data);
 
-	mutex_unlock(&vdev->intr_ctx.igate);
 	kfree(data);
 
 	return ret;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index a4c8b589c87b..5d600548b5d7 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -826,7 +826,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 	int (*func)(struct vfio_pci_intr_ctx *intr_ctx, unsigned int index,
 		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
+	int ret = -ENOTTY;
 
+	mutex_lock(&intr_ctx->igate);
 	switch (index) {
 	case VFIO_PCI_INTX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
@@ -887,7 +889,11 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 	}
 
 	if (!func)
-		return -ENOTTY;
+		goto out_unlock;
+
+	ret = func(intr_ctx, index, start, count, flags, data);
 
-	return func(intr_ctx, index, start, count, flags, data);
+out_unlock:
+	mutex_unlock(&intr_ctx->igate);
+	return ret;
 }
-- 
2.34.1

