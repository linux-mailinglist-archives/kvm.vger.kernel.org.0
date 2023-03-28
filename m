Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787C76CCC52
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 23:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjC1VyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 17:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjC1VyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 17:54:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B442D51;
        Tue, 28 Mar 2023 14:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680040433; x=1711576433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XbkcLI4n2teEQCC6ULXx558MPH5O1I8KLnT+xl6+hk8=;
  b=W4uAsz4jPYoKm+auyAmjhJYI4GgB9ZRjr43+zYdz8knzAWfxd4i/92Bg
   iPlS3kZ9+hYHqmBkwaL/WGk3BWsEdugAdb+S7Vg43v6sqygkhRHYUUo3A
   qSgLXhPOgLnNw+88DRWE87YalnWHoCoY/dJ9VJm/bQtTFW6ZnvjUYiZkY
   KHdTa/GNzYcoVxu2BA+Lf759tWW87N6KgOAJPXkjxeE1lmY8hrNOFuAQD
   KrUiszH7M8fzRhW7xLJav0ERLPk3Gu/30Qmy9BR0PpMo/TRLAnCaBRjhO
   MdUR1iIHi35TSxRmxq3+tDJz5KkkiiBWLE7dtziPKyAAmZMiNnOfUascz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="403316913"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403316913"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="748543765"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="748543765"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 14:53:49 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     tglx@linutronix.de, darwi@linutronix.de, kvm@vger.kernel.org,
        dave.jiang@intel.com, jing2.liu@intel.com, ashok.raj@intel.com,
        fenghua.yu@intel.com, tom.zanussi@linux.intel.com,
        reinette.chatre@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/8] vfio/pci: Consolidate irq cleanup on MSI/MSI-X disable
Date:   Tue, 28 Mar 2023 14:53:28 -0700
Message-Id: <4e1ac682c11a596a8b96ef5034674cda83eddbd2.1680038771.git.reinette.chatre@intel.com>
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

vfio_msi_disable() releases all previously allocated state
associated with each interrupt before disabling MSI/MSI-X.

vfio_msi_disable() iterates twice over the interrupt state:
first directly with a for loop to do virqfd cleanup, followed
by another for loop within vfio_msi_set_block() that releases
the interrupt and its state using vfio_msi_set_vector_signal().

Simplify interrupt cleanup by iterating over allocated interrupts
once.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
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

