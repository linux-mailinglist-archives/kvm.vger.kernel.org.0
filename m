Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444087BBCF2
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 18:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbjJFQl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Oct 2023 12:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbjJFQl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Oct 2023 12:41:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4F4C2;
        Fri,  6 Oct 2023 09:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696610484; x=1728146484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H7rB4UXlIoifbzKjPRXCo7m3ZB60xwMBxraebUPDiI4=;
  b=No6Ot1L4cl5Sr5WjAoM8sJFMVzhwbp+6ofHw8yUMtXZkGloVtPwRoMVM
   e9MhE4faX59ncHJgtXS/YCtaY3rwf2MDPpd/F4VSjmE041zNy6f7a2ytL
   oJeQmPDKu9gGADD1IGCDSSHa8Tcu7+b9b2K1xiKaQPnzjF09kdEOdB1aq
   /oWvROZdKncPtCB4BRSripl0Rv2QGOO6yJFp0rEeXPsbdv5WWSxZyuQqP
   o0wrI9OtrjDLEr3+u1nTYBpbLBwRpO9FfVGIi/C5M1UUyGxPcGK3eB6O6
   B6x1U+EG1KjvcR0Mu64INM8dOHWf1Z/wPWP0ZfOLNqaqY97j2ZBJfSwrj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="364063151"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="364063151"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10855"; a="842892838"
X-IronPort-AV: E=Sophos;i="6.03,204,1694761200"; 
   d="scan'208";a="842892838"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2023 09:41:23 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, dave.jiang@intel.com, jing2.liu@intel.com,
        ashok.raj@intel.com, fenghua.yu@intel.com,
        tom.zanussi@linux.intel.com, reinette.chatre@intel.com,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [RFC PATCH V2 01/18] PCI/MSI: Provide stubs for IMS functions
Date:   Fri,  6 Oct 2023 09:40:56 -0700
Message-Id: <c79c7626df384bc1739a8a6093917ef065ee3b9e.1696609476.git.reinette.chatre@intel.com>
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

The IMS related functions (pci_create_ims_domain(),
pci_ims_alloc_irq(), and pci_ims_free_irq()) are not declared
when CONFIG_PCI_MSI is disabled.

Provide definitions of these functions that can be used
when callers need to compile when CONFIG_PCI_MSI is disabled.

This is a preparatory patch for the first caller of these
functions (VFIO).

Fixes: 0194425af0c8 ("PCI/MSI: Provide IMS (Interrupt Message Store) support")
Fixes: c9e5bea27383 ("PCI/MSI: Provide pci_ims_alloc/free_irq()")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org      # v6.2+
---
I plan to send this patch separately to PCI folks, pending the
outcome of this work.

 include/linux/pci.h | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8c7c2c3c6c65..68a52bc01864 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1624,6 +1624,8 @@ struct msix_entry {
 	u16	entry;	/* Driver uses to specify entry, OS writes */
 };
 
+struct msi_domain_template;
+
 #ifdef CONFIG_PCI_MSI
 int pci_msi_vec_count(struct pci_dev *dev);
 void pci_disable_msi(struct pci_dev *dev);
@@ -1656,6 +1658,11 @@ void pci_msix_free_irq(struct pci_dev *pdev, struct msi_map map);
 void pci_free_irq_vectors(struct pci_dev *dev);
 int pci_irq_vector(struct pci_dev *dev, unsigned int nr);
 const struct cpumask *pci_irq_get_affinity(struct pci_dev *pdev, int vec);
+bool pci_create_ims_domain(struct pci_dev *pdev, const struct msi_domain_template *template,
+			   unsigned int hwsize, void *data);
+struct msi_map pci_ims_alloc_irq(struct pci_dev *pdev, union msi_instance_cookie *icookie,
+				 const struct irq_affinity_desc *affdesc);
+void pci_ims_free_irq(struct pci_dev *pdev, struct msi_map map);
 
 #else
 static inline int pci_msi_vec_count(struct pci_dev *dev) { return -ENOSYS; }
@@ -1719,6 +1726,22 @@ static inline const struct cpumask *pci_irq_get_affinity(struct pci_dev *pdev,
 {
 	return cpu_possible_mask;
 }
+static inline bool pci_create_ims_domain(struct pci_dev *pdev,
+					 const struct msi_domain_template *template,
+					 unsigned int hwsize, void *data)
+{ return false; }
+static inline struct msi_map pci_ims_alloc_irq(struct pci_dev *pdev,
+					       union msi_instance_cookie *icookie,
+					       const struct irq_affinity_desc *affdesc)
+{
+	struct msi_map map = { .index = -ENOSYS, };
+
+	return map;
+}
+static inline void pci_ims_free_irq(struct pci_dev *pdev, struct msi_map map)
+{
+}
+
 #endif
 
 /**
@@ -2616,14 +2639,6 @@ static inline bool pci_is_thunderbolt_attached(struct pci_dev *pdev)
 void pci_uevent_ers(struct pci_dev *pdev, enum  pci_ers_result err_type);
 #endif
 
-struct msi_domain_template;
-
-bool pci_create_ims_domain(struct pci_dev *pdev, const struct msi_domain_template *template,
-			   unsigned int hwsize, void *data);
-struct msi_map pci_ims_alloc_irq(struct pci_dev *pdev, union msi_instance_cookie *icookie,
-				 const struct irq_affinity_desc *affdesc);
-void pci_ims_free_irq(struct pci_dev *pdev, struct msi_map map);
-
 #include <linux/dma-mapping.h>
 
 #define pci_printk(level, pdev, fmt, arg...) \
-- 
2.34.1

