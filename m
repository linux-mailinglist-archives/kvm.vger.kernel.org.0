Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587846F0AEF
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244392AbjD0Rgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244423AbjD0RgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:36:25 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B3E3A82;
        Thu, 27 Apr 2023 10:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682616984; x=1714152984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1ZvtNhskQo1n54fwtOBEZ3264EZTpF7b30t34MsMeZM=;
  b=OjmGPtE94Pq78FToZkKDeMmKsaJloN5N5r5QUF1+MMPengZ8DXkGufQI
   mNts4AfJTHvymMtsxaKF6YBknAKldp/yzdw8GEe3K5DOvTyvk+G/bC1/3
   XKUF50nLWePAH37jbaEGLjf4LQZTJddUY+zoBjgBxtoNx0I8bZU7KVvW7
   p5u1e4PsXaaSNEXNyQ3d5Djr3pJi2A+TlsASXIbUWIxr10oLKm8yrjMVA
   97AnwSDx4oFl34vzx1PSgNX9/fUnZHl+YNjLwNscJl28BbL7zax9JAg15
   1nE7ms3kVF3ciD1B+VHLGSz/lTP6O2H3yG8awniR4oM97excSpie+ipfR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349496895"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="349496895"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697172973"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="697172973"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:20 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V4 04/11] vfio/pci: Move to single error path
Date:   Thu, 27 Apr 2023 10:36:01 -0700
Message-Id: <521fd5184ef052ff768a90bbe670cfc4e375eff9.1682615447.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1682615447.git.reinette.chatre@intel.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enabling and disabling of an interrupt involves several steps
that can fail. Cleanup after failure is done when the error
is encountered, resulting in some repetitive code.

Support for dynamic contexts will introduce more steps during
interrupt enabling and disabling.

Transition to centralized exit path in preparation for dynamic
contexts to eliminate duplicate error handling code.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
No changes since V3.

Changes since V2:
- Move patch to earlier in series in support of the change to
  dynamic context management.
- Do not add the "ctx->name = NULL" in error path. It is not done
  in baseline and will not be needed when transitioning to
  dynamic context management.
- Update changelog to not make this change specific to dynamic
  MSI-X.

Changes since RFC V1:
- Improve changelog.

 drivers/vfio/pci/vfio_pci_intrs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index b664fbb6d2f2..9e17e59a4d60 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -418,8 +418,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
-		kfree(ctx->name);
-		return PTR_ERR(trigger);
+		ret = PTR_ERR(trigger);
+		goto out_free_name;
 	}
 
 	/*
@@ -439,11 +439,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
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
@@ -458,6 +455,12 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 	ctx->trigger = trigger;
 
 	return 0;
+
+out_put_eventfd_ctx:
+	eventfd_ctx_put(trigger);
+out_free_name:
+	kfree(ctx->name);
+	return ret;
 }
 
 static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
-- 
2.34.1

