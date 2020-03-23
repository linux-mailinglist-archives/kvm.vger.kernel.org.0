Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B23B18F088
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 09:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgCWIBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 04:01:02 -0400
Received: from 107-174-27-60-host.colocrossing.com ([107.174.27.60]:50650 "EHLO
        ozlabs.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727507AbgCWIBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 04:01:01 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2020 04:01:00 EDT
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 721DCAE807E6;
        Mon, 23 Mar 2020 03:52:30 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v2 5/7] powerpc/iommu: Add a window number to iommu_table_group_ops::get_table_size
Date:   Mon, 23 Mar 2020 18:53:52 +1100
Message-Id: <20200323075354.93825-6-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323075354.93825-1-aik@ozlabs.ru>
References: <20200323075354.93825-1-aik@ozlabs.ru>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are about to add an additional offset within a TCE table which is
going to increase the size of the window, prepare for this.

This should cause no behavioral change.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/include/asm/iommu.h          | 1 +
 arch/powerpc/platforms/powernv/pci.h      | 2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c | 4 ++--
 drivers/vfio/vfio_iommu_spapr_tce.c       | 4 ++--
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 479439ef003e..acf64a73ead1 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -161,6 +161,7 @@ struct iommu_table_group;
 
 struct iommu_table_group_ops {
 	unsigned long (*get_table_size)(
+			int num,
 			__u32 page_shift,
 			__u64 window_size,
 			__u32 levels);
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index ce00278185b0..d8fa2f65517e 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -192,7 +192,7 @@ extern int pnv_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type);
 extern void pnv_teardown_msi_irqs(struct pci_dev *pdev);
 extern struct pnv_ioda_pe *pnv_ioda_get_pe(struct pci_dev *dev);
 extern void pnv_set_msi_irq_chip(struct pnv_phb *phb, unsigned int virq);
-extern unsigned long pnv_pci_ioda2_get_table_size(__u32 page_shift,
+extern unsigned long pnv_pci_ioda2_get_table_size(int num, __u32 page_shift,
 		__u64 window_size, __u32 levels);
 extern int pnv_eeh_post_init(void);
 
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 9928a1618a8b..27a505a5edb4 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2597,7 +2597,7 @@ static long pnv_pci_ioda2_unset_window(struct iommu_table_group *table_group,
 #endif
 
 #ifdef CONFIG_IOMMU_API
-unsigned long pnv_pci_ioda2_get_table_size(__u32 page_shift,
+unsigned long pnv_pci_ioda2_get_table_size(int num, __u32 page_shift,
 		__u64 window_size, __u32 levels)
 {
 	unsigned long bytes = 0;
@@ -2644,7 +2644,7 @@ static long pnv_pci_ioda2_create_table_userspace(
 
 	if (!ret)
 		(*ptbl)->it_allocated_size = pnv_pci_ioda2_get_table_size(
-				page_shift, window_size, levels);
+				num, page_shift, window_size, levels);
 	return ret;
 }
 
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 16b3adc508db..750a0676e9b7 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -613,8 +613,8 @@ static long tce_iommu_create_table(struct tce_container *container,
 {
 	long ret, table_size;
 
-	table_size = table_group->ops->get_table_size(page_shift, window_size,
-			levels);
+	table_size = table_group->ops->get_table_size(num, page_shift,
+			window_size, levels);
 	if (!table_size)
 		return -EINVAL;
 
-- 
2.17.1

