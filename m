Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F74B38D256
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 02:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhEVAVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 20:21:02 -0400
Received: from mga05.intel.com ([192.55.52.43]:23956 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhEVAU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 20:20:56 -0400
IronPort-SDR: GMHoDOlXvgbWADaMrHO0t6GA7zxQMh2NfyyRV5p6TVmBOdui6iXJVzE10GYwLNikAXdPGhqvyo
 eHtIDpGYPOBQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="287141588"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="287141588"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:32 -0700
IronPort-SDR: esG7x3geBjjEJwpaWiErkd74HLovIDMST2CdV6mmZKEub9WlCvtfgIUhggS+y3oTR+f5hRdHj4
 Ygc5vhS9k3Iw==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="406873535"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 17:19:30 -0700
Subject: [PATCH v6 04/20] dmaengine: idxd: add portal offset for IMS portals
From:   Dave Jiang <dave.jiang@intel.com>
To:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, jgg@mellanox.com
Cc:     megha.dey@intel.com, jacob.jun.pan@intel.com, ashok.raj@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Fri, 21 May 2021 17:19:30 -0700
Message-ID: <162164277035.261970.14322823489384216890.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/0.23-29-ga622f1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Device portal offsets are 4k apart laid out in the order of unlimited
MSIX portal, limited MSIX portal, unlimited IMS portal, limited IMS
portal. Add an additional parameter to calculate the IMS portal
offsets.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/idxd/cdev.c   |    4 ++--
 drivers/dma/idxd/device.c |    2 +-
 drivers/dma/idxd/idxd.h   |   11 +++--------
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index e3d29244f752..62a53123fd58 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -202,8 +202,8 @@ static int idxd_cdev_mmap(struct file *filp, struct vm_area_struct *vma)
 		return rc;
 
 	vma->vm_flags |= VM_DONTCOPY;
-	pfn = (base + idxd_get_wq_portal_full_offset(wq->id,
-				IDXD_PORTAL_LIMITED)) >> PAGE_SHIFT;
+	pfn = (base + idxd_get_wq_portal_offset(wq->id, IDXD_PORTAL_LIMITED,
+						IDXD_IRQ_MSIX)) >> PAGE_SHIFT;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vma->vm_private_data = ctx;
 
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 3549a73fc7db..02e9a050b5bb 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -300,7 +300,7 @@ int idxd_wq_map_portal(struct idxd_wq *wq)
 	resource_size_t start;
 
 	start = pci_resource_start(pdev, IDXD_WQ_BAR);
-	start += idxd_get_wq_portal_full_offset(wq->id, IDXD_PORTAL_LIMITED);
+	start += idxd_get_wq_portal_offset(wq->id, IDXD_PORTAL_LIMITED, IDXD_IRQ_MSIX);
 
 	wq->portal = devm_ioremap(dev, start, IDXD_PORTAL_SIZE);
 	if (!wq->portal)
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 288e3fe15b3e..e5b90e6970aa 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -459,15 +459,10 @@ enum idxd_interrupt_type {
 	IDXD_IRQ_IMS,
 };
 
-static inline int idxd_get_wq_portal_offset(enum idxd_portal_prot prot)
+static inline int idxd_get_wq_portal_offset(int wq_id, enum idxd_portal_prot prot,
+					    enum idxd_interrupt_type irq_type)
 {
-	return prot * 0x1000;
-}
-
-static inline int idxd_get_wq_portal_full_offset(int wq_id,
-						 enum idxd_portal_prot prot)
-{
-	return ((wq_id * 4) << PAGE_SHIFT) + idxd_get_wq_portal_offset(prot);
+	return ((wq_id * 4) << PAGE_SHIFT) + prot * 0x1000 + irq_type * 0x2000;
 }
 
 static inline void idxd_wq_get(struct idxd_wq *wq)


