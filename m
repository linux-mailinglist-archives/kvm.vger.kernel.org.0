Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F9A7BBCFE
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbjJFQli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbjJFQl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C60CA;
        Fri,  6 Oct 2023 09:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610488; x=1728146488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V6qcjxSKPG49QsbYWnxrQpo18nDRlu23V1OPPdVp934=;
  b=COHSEGtFyrdTitKWRnJnJiNorSdt0i/qZgogKj9eT4MKcRYjXs8HFvDm
   uTpH/+KN271R3yVr86KLTrBqz7Mr1qVzYylzaaHPfTSpKsSD5fkM7GCYH
   OPbJHBiMpiwDCP/rrnHptAR5YGx9igi/V8Bt/BogUiyHDGHVMc9l5GqeH
   1Pc+C046k1ejmYoxjFPKbHM8TWYmVXSM2rEvaS/YrBhaboIU3m63+uSy0
   CJ2/iJxQluj43pQiEV8Ly7jd1+zQZOkkYfM/+yBaqvP43n0LrGnI2Iz6n
   96b5ku2OKuwSC7vTwAT1i/XMERiEQ+De/GJRqickdzsaddgHYZOesh7Sd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063190"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063190"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892862"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892862"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:25 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 08/18] vfio/pci: Move mutex acquisition into function
Date:   Fri,  6 Oct 2023 09:41:03 -0700
Message-Id: <51426f0278e0810530573827b6f4f45427215a17.1696609476.git.reinette.chatre@intel.com>
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

vfio_pci_set_irqs_ioctl() is the entrypoint for interrupt
management via the VFIO_DEVICE_SET_IRQS ioctl().
vfio_pci_set_irqs_ioctl() can be called from a virtual
device driver after its callbacks have been configured to
support the needed interrupt management.

The igate mutex is obtained before vfio_pci_set_irqs_ioctl()
to protect changes to interrupt context. It should not be
necessary for all users of vfio_pci_set_irqs_ioctl() to
remember to take the mutex - the mutex can be
acquired and released within vfio_pci_set_irqs_ioctl().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
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
index b9c92ede3b6f..9fc0a568d392 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -825,7 +825,9 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
 	int (*func)(struct vfio_pci_intr_ctx *intr_ctx, unsigned int index,
 		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
+	int ret = -ENOTTY;
 
+	mutex_lock(&intr_ctx->igate);
 	switch (index) {
 	case VFIO_PCI_INTX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
@@ -886,7 +888,11 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_intr_ctx *intr_ctx, uint32_t flags,
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

