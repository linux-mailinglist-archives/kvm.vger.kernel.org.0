Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2616BBE53
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 22:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjCOVAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 17:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjCOU7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 16:59:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7F685690;
        Wed, 15 Mar 2023 13:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678913983; x=1710449983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DMhH90UWDLh3tQDufZrmB4QPEnhvo2J9/K2HdYM+u74=;
  b=T2t6R0SgUdVaON7L7HUcwc+gdLWWVQEvw3K+//D1Omqh2PtV7U7bM2xV
   MUTs1j9wrOsXuNc117q0+dn34PEZFX+o+UwCR3KOe5ga+jrUMD+XALWyy
   tw4TpvKrvrKuBwK3lpOBP/z8AvX/0K4b4iwXHJuW6PnN6i5HA25HwLqr1
   DvBO6YH7/hjBdosH9rg4vuOjYJXL+3Rn62Oj8yCfBAJCuAghqwxXumRaj
   3OtxjnFypHxFeTAG26a5KE2bBYxk9YMWdNWvIF57zWV6SO+25zFRUTREk
   PhRsQ54ouPxmv3D4mwOMnUz19P2pG3swuqGYfPPskFfrPW2OkOC9fUHhW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="326176529"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326176529"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="853747228"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="853747228"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 13:59:39 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 6/8] vfio/pci: Move to single error path
Date:   Wed, 15 Mar 2023 13:59:26 -0700
Message-Id: <2589209ff98360947bcbbbc000028bb6adc639ef.1678911529.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678911529.git.reinette.chatre@intel.com>
References: <cover.1678911529.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The creation and release of interrupt context involves several
steps that can fail. Cleanup after failure is done when the error
is encountered, resulting in some repetitive code.

Support for dynamic MSI-X will introduce more steps during
interrupt context creation and release.

Transition to centralized exit path in preparation for dynamic
MSI-X to eliminate duplicate error handling code. Ensure
no remaining state refers to freed memory.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 187a1ba34a16..b375a12885ba 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -460,8 +460,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
-		kfree(ctx->name);
-		return PTR_ERR(trigger);
+		ret = PTR_ERR(trigger);
+		goto out_free_name;
 	}
 
 	/*
@@ -481,11 +481,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 	ret = request_irq(irq, vfio_msihandler, 0, ctx->name, trigger);
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
-	if (ret) {
-		kfree(ctx->name);
-		eventfd_ctx_put(trigger);
-		return ret;
-	}
+	if (ret)
+		goto out_put_eventfd_ctx;
 
 	ctx->producer.token = trigger;
 	ctx->producer.irq = irq;
@@ -500,6 +497,13 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	ctx->trigger = trigger;
 
 	return 0;
+
+out_put_eventfd_ctx:
+	eventfd_ctx_put(trigger);
+out_free_name:
+	kfree(ctx->name);
+	ctx->name = NULL;
+	return ret;
 }
 
 static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
-- 
2.34.1

