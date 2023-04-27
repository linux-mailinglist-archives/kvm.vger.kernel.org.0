Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E576F0AFC
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 19:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244544AbjD0Rg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 13:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244416AbjD0RgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 13:36:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022CD3C15;
        Thu, 27 Apr 2023 10:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682616982; x=1714152982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dECZEsHgNKDAg2NJhsGmsEPmmLEkwgLOFPBHSm8iUiM=;
  b=D2JMoQQ1r7w/LhPl6fC9iexEYTO0RSC1iJy5E2BL1FviDlTVtchgUTdB
   FNSP18bLuphvVg4Sf1fDh61USLB2xyiQqjIrYI1wAtsKqrUhqoI0lmduO
   LC6sncdr7SouXoE0pj7O8mUuJ202OAuQx3u3TNTmKfMOrdcNUcSvw4pCV
   OmnTdw9kmKce/AfV/l/Tl4v3U23vkJFFeF73XzG3wET9AsOonKTDZr8K2
   2UHQzZkV8/MlbnPeHOxsPFoKKQRrwivrerT4KinL4F2gdI7RviMrqqg2+
   A1YaAT6nSbaFMJVtnB3V8bOyxbwgro4ABkHeSlWN5AMZzmtqgVdJNIRix
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="349496871"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="349496871"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="697172962"
X-IronPort-AV: E=Sophos;i="5.99,232,1677571200"; 
   d="scan'208";a="697172962"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 10:36:19 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V4 01/11] vfio/pci: Consolidate irq cleanup on MSI/MSI-X disable
Date:   Thu, 27 Apr 2023 10:35:58 -0700
Message-Id: <aef2b60d9a3c5a2984b39919561ade5ca9786b27.1682615447.git.reinette.chatre@intel.com>
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

vfio_msi_disable() releases all previously allocated state
associated with each interrupt before disabling MSI/MSI-X.

vfio_msi_disable() iterates twice over the interrupt state:
first directly with a for loop to do virqfd cleanup, followed
by another for loop within vfio_msi_set_block() that removes
the interrupt handler and its associated state using
vfio_msi_set_vector_signal().

Simplify interrupt cleanup by iterating over allocated interrupts
once.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
No changes since V3.

Changes since V2:
- Improve accuracy of changelog.

 drivers/vfio/pci/vfio_pci_intrs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index bffb0741518b..6a9c6a143cc3 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -426,10 +426,9 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	for (i = 0; i < vdev->num_ctx; i++) {
 		vfio_virqfd_disable(&vdev->ctx[i].unmask);
 		vfio_virqfd_disable(&vdev->ctx[i].mask);
+		vfio_msi_set_vector_signal(vdev, i, -1, msix);
 	}
 
-	vfio_msi_set_block(vdev, 0, vdev->num_ctx, NULL, msix);
-
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	pci_free_irq_vectors(pdev);
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
-- 
2.34.1

