Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E4A6CCC5D
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 23:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjC1Vy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 17:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjC1Vyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 17:54:43 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669F73591;
        Tue, 28 Mar 2023 14:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680040463; x=1711576463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZFMnAYWkb7URHJwpoaNsszFowQGtPXU9f9P8ZuKBdU4=;
  b=Byp15McsPG8nMDQugS83bOLsuNJshXHpSeF8Ir+eTBT3uEx0EodIhJzk
   tUy9kPrgWFv2ktLXxHC5PwBuxEOfqk1g+CJzqW4upiQom3TnUBkUuC6bT
   fIXVIuUQ50BJhFgUtRdI19T26G3ZpiyHI1I8HhcFdXHPUmJniyu23VC4W
   dRAv6VI2qHTC9/W+Y4uKU55X9F8ZLICbSLFqkPgdFvmO6XD5qETuhcBCG
   vnRKyhJ1tXdSeMYbrikI8GigHL9MkSIFOCtyVw0wsultI5Sk8N4AWW2tl
   UI3CqHsL6J9wJg/BPuh0Zja1c8PaWpQqiurmxOsRZtHXPVODWs1Jffcli
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403316942"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403316942"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="748543785"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="748543785"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:51 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V2 6/8] vfio/pci: Move to single error path
Date:   Tue, 28 Mar 2023 14:53:33 -0700
Message-Id: <eb92b17e38d50cf134434cb6c859397bff50af12.1680038771.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1680038771.git.reinette.chatre@intel.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enabling and disabling of an interrupt involves several steps
that can fail. Cleanup after failure is done when the error
is encountered, resulting in some repetitive code.

Support for dynamic MSI-X will introduce more steps during
interrupt enabling and disabling.

Transition to centralized exit path in preparation for dynamic
MSI-X to eliminate duplicate error handling code. Ensure
no remaining state refers to freed memory.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since RFC V1:
- Improve changelog.

 drivers/vfio/pci/vfio_pci_intrs.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b86dce0f384f..b3a258e58625 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -439,8 +439,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
-		kfree(ctx->name);
-		return PTR_ERR(trigger);
+		ret = PTR_ERR(trigger);
+		goto out_free_name;
 	}
 
 	/*
@@ -460,11 +460,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
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
@@ -479,6 +476,13 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
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

