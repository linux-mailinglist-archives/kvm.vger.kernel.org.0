Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A805A6FF64E
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 17:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbjEKPpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 11:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238660AbjEKPo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 11:44:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E826FD;
        Thu, 11 May 2023 08:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683819896; x=1715355896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8S7nmNRsfN3F7l+vsdYbyvmv0P60T0hUfIF0wQ0EMhs=;
  b=BShJ9Querevh4ei01lDrbXOa+Q1HsrtF9qhkdyxoOB7OvqhAMq+sai7i
   Lqg20VxcJetVkXD3YNxqB9ZDaPc7JdvcraXNAfpkasbCoHJRneIrzKBrY
   zTwDjkfSSnBzDbbcMN+rxAZbiyYTkkEvUCYo6FepfgNLgC8G8mfRu2Cy9
   LZ3XB+cNQ47+ct1MRDQNdMBUp8xFalpW0wZbsnoA86wjBlG6T10X+68Ue
   WEqQTanWyJgcjCSEAunNKL/cCYUvwtrpjx+Ao3FWsVAuXlLr219fq3S/N
   cSB24lz+Vp0TPOEAA4OatbG5Lre2j7EnOYycKKIxQTdu1Y8V7A5wkq95r
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335046665"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335046665"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699776230"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699776230"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:48 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V5 04/11] vfio/pci: Move to single error path
Date:   Thu, 11 May 2023 08:44:31 -0700
Message-Id: <72dddae8aa710ce522a74130120733af61cffe4d.1683740667.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1683740667.git.reinette.chatre@intel.com>
References: <cover.1683740667.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
Changes since V4:
- Add Kevin's Reviewed-by tag. (Kevin)

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
index 6094679349d9..96396e1ad085 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -427,8 +427,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
 	trigger = eventfd_ctx_fdget(fd);
 	if (IS_ERR(trigger)) {
-		kfree(ctx->name);
-		return PTR_ERR(trigger);
+		ret = PTR_ERR(trigger);
+		goto out_free_name;
 	}
 
 	/*
@@ -448,11 +448,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 
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
@@ -467,6 +464,12 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
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

