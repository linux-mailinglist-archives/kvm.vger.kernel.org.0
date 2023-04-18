Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C02C6E6B0A
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 19:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjDRR34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 13:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjDRR3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 13:29:50 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA61BAF12;
        Tue, 18 Apr 2023 10:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681838988; x=1713374988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w7/Wvfls9T+9v41w24j+JaGq3vtI51OxqopK2676JN0=;
  b=Yjc98/q0+xRq1g1PvlEMN6gTQlZY3ERZogZKgIzVErAwtT/p6C0ke0L2
   vyOh/IEHMoU+a385UCM5xxYPE0UBiVyjNFYZL6H0fztHbAZmfQUzL3Ttj
   099qURM/2+hmgHc0DfBwPI/hwTvW0TQfE2py0paA6mbZabBRmc3B0vRC2
   RHKT96kNQbsUkZ+wgC/mvKY6L8y7V8KzUVBfn5vJD0beG1SYGrzbBSLpo
   E/LSOcLOOUa9V/OxYMg7HzI/7pbM/INLioVCdBHZCogFwjAffFD9Yuzqr
   5fPV8cE+t8KPAJna2jzFem40pq9niINAg+rlChEnUFjYMJNiHstolhCN/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="410466462"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="410466462"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10684"; a="865503479"
X-IronPort-AV: E=Sophos;i="5.99,207,1677571200"; 
   d="scan'208";a="865503479"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 10:29:42 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V3 04/10] vfio/pci: Move to single error path
Date:   Tue, 18 Apr 2023 10:29:15 -0700
Message-Id: <521fd5184ef052ff768a90bbe670cfc4e375eff9.1681837892.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1681837892.git.reinette.chatre@intel.com>
References: <cover.1681837892.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

