Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1924E6FF648
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 17:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbjEKPo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 11:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238271AbjEKPo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 11:44:56 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF35FD;
        Thu, 11 May 2023 08:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683819895; x=1715355895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fq4IZslUIdBYDjhjcyUMZGxjA/O2iCEOTMmu+hT1ySk=;
  b=a0Vid4qNj2UKxwcYuMwMlpJI3Vrp3N/glvg4MaopCGalwWKVwdAUeChr
   nl3jJOF4/h6hCn838pKLkNxcFTaIFD68dfkySrt5At4XhzLOlZnhlJvOd
   mk6sl/zRpSbGy1L5LCNCfM7GKlWdY9pkVL9xeI3utwpmgXvh4V+qoXJ8/
   HgPyFOqIdMRO2l8CN1+9IKt2spleVGGGlqoqQnSIpsSDUHvBaQyV+5n09
   EU18v7Nb7yjhd6oZL6pT6HAAPe1vAOc9yGAPG3K6ca1t8KrXrrkl1eMJ4
   XrIlJ65aab+l/klTwy+vMv8PCHOlCbgeUogzg1ZcOh5+WALKuS/IlJhCl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335046649"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335046649"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:44:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699776220"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699776220"
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
Subject: [PATCH V5 01/11] vfio/pci: Consolidate irq cleanup on MSI/MSI-X disable
Date:   Thu, 11 May 2023 08:44:28 -0700
Message-Id: <837acb8cbe86a258a50da05e56a1f17c1a19abbe.1683740667.git.reinette.chatre@intel.com>
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
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
Changes since V4:
- Add Kevin's Reviewed-by tag.

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

