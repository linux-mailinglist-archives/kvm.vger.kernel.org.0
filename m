Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15C56AA12C
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbjCCV3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjCCV3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:29:53 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9D6113F3
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:29:51 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 17FE337E2A821E
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:29:51 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 2FLOo3eQT2Iq for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:29:49 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id D994537E2A821B
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:29:49 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com D994537E2A821B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1677878989; bh=TuhuXV4cpegARyfjj/hNkyaXOGz5JAf1MlYNPlIMjeA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=tWPRL1CyFUH0dmJQBwt1+zM4m7wg9Wtmxna1YuUFfDry+Hr7jnuLhfkp2ManswufR
         3eQis16xP1A2Eg6j8ZiPswfeXs0rthLmUJQBuMXCw9gFtFeHIv8CYt5igjV8BXZSGH
         GpdnzG6LBVbFF5einm19dV3O08uD7cuOFVk7SOwE=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id c5Z5z_7_ftZF for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:29:49 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id B9D9837E2A8218
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:29:49 -0600 (CST)
Date:   Fri, 3 Mar 2023 15:29:49 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm <kvm@vger.kernel.org>
Message-ID: <1260851193.16280464.1677878989708.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH 2/5] powerpc/iommu: Add "borrowing" iommu_table_group_ops
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Index: Emn+7I3KHAhs0LhcbT3BgYHFyK7Z3g==
Thread-Topic: powerpc/iommu: Add "borrowing" iommu_table_group_ops
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From cf6032f821006cee30affb74c2131f6c89a76c24 Mon Sep 17 00:00:00 2001
From: Alexey Kardashevskiy <aik@ozlabs.ru>
Date: Wed, 13 Jul 2022 13:52:09 +1000
Subject: [PATCH 2/5] powerpc/iommu: Add "borrowing" iommu_table_group_ops

PPC64 IOMMU API defines iommu_table_group_ops which handles DMA windows
for PEs: control the ownership, create/set/unset a table the hardware
for dynamic DMA windows (DDW). VFIO uses the API to implement support
on POWER.

So far only PowerNV IODA2 (POWER8 and newer machines) implemented this and other cases (POWER7 or nested KVM) did not and instead reused
existing iommu_table structs. This means 1) no DDW 2) ownership transfer
is done directly in the VFIO SPAPR TCE driver.

Soon POWER is going to get its own iommu_ops and ownership control is
going to move there. This implements spapr_tce_table_group_ops which
borrows iommu_table tables. The upside is that VFIO needs to know less
about POWER.

The new ops returns the existing table from create_table() and
only checks if the same window is already set. This is only going to work
if the default DMA window starts table_group.tce32_start and as big as
pe->table_group.tce32_size (not the case for IODA2+ PowerNV).

This changes iommu_table_group_ops::take_ownership() to return an error
if borrowing a table failed.

This should not cause any visible change in behavior for PowerNV.
pSeries was not that well tested/supported anyway.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
---
 arch/powerpc/include/asm/iommu.h          |  6 +-
 arch/powerpc/kernel/iommu.c               | 98 ++++++++++++++++++++++-
 arch/powerpc/platforms/powernv/pci-ioda.c |  6 +-
 arch/powerpc/platforms/pseries/iommu.c    |  3 +
 drivers/vfio/vfio_iommu_spapr_tce.c       | 94 ++++------------------
 5 files changed, 121 insertions(+), 86 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 7e29c73e3dd4..678b5bdc79b1 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -175,7 +175,7 @@ struct iommu_table_group_ops {
 	long (*unset_window)(struct iommu_table_group *table_group,
 			int num);
 	/* Switch ownership from platform code to external user (e.g. VFIO) */
-	void (*take_ownership)(struct iommu_table_group *table_group);
+	long (*take_ownership)(struct iommu_table_group *table_group);
 	/* Switch ownership from external user (e.g. VFIO) back to core */
 	void (*release_ownership)(struct iommu_table_group *table_group);
 };
@@ -215,6 +215,8 @@ extern long iommu_tce_xchg_no_kill(struct mm_struct *mm,
 		enum dma_data_direction *direction);
 extern void iommu_tce_kill(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages);
+
+extern struct iommu_table_group_ops spapr_tce_table_group_ops;
 #else
 static inline void iommu_register_group(struct iommu_table_group *table_group,
 					int pci_domain_number,
@@ -303,8 +305,6 @@ extern int iommu_tce_check_gpa(unsigned long page_shift,
 		iommu_tce_check_gpa((tbl)->it_page_shift, (gpa)))
 
 extern void iommu_flush_tce(struct iommu_table *tbl);
-extern int iommu_take_ownership(struct iommu_table *tbl);
-extern void iommu_release_ownership(struct iommu_table *tbl);
 
 extern enum dma_data_direction iommu_tce_direction(unsigned long tce);
 extern unsigned long iommu_direction_to_tce_perm(enum dma_data_direction dir);
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index caebe1431596..d873c123ab49 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -1088,7 +1088,7 @@ void iommu_tce_kill(struct iommu_table *tbl,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_kill);
 
-int iommu_take_ownership(struct iommu_table *tbl)
+static int iommu_take_ownership(struct iommu_table *tbl)
 {
 	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
 	int ret = 0;
@@ -1120,9 +1120,8 @@ int iommu_take_ownership(struct iommu_table *tbl)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(iommu_take_ownership);
 
-void iommu_release_ownership(struct iommu_table *tbl)
+static void iommu_release_ownership(struct iommu_table *tbl)
 {
 	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
 
@@ -1139,7 +1138,6 @@ void iommu_release_ownership(struct iommu_table *tbl)
 		spin_unlock(&tbl->pools[i].lock);
 	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
 }
-EXPORT_SYMBOL_GPL(iommu_release_ownership);
 
 int iommu_add_device(struct iommu_table_group *table_group, struct device *dev)
 {
@@ -1181,4 +1179,96 @@ void iommu_del_device(struct device *dev)
 	iommu_group_remove_device(dev);
 }
 EXPORT_SYMBOL_GPL(iommu_del_device);
+
+/*
+ * A simple iommu_table_group_ops which only allows reusing the existing
+ * iommu_table. This handles VFIO for POWER7 or the nested KVM.
+ * The ops does not allow creating windows and only allows reusing the existing
+ * one if it matches table_group->tce32_start/tce32_size/page_shift.
+ */
+static unsigned long spapr_tce_get_table_size(__u32 page_shift,
+					      __u64 window_size, __u32 levels)
+{
+	unsigned long size;
+
+	if (levels > 1)
+		return ~0U;
+	size = window_size >> (page_shift - 3);
+	return size;
+}
+
+static long spapr_tce_create_table(struct iommu_table_group *table_group,
+		int num, __u32 page_shift, __u64 window_size, __u32 levels,
+		struct iommu_table **ptbl)
+{
+	struct iommu_table *tbl = table_group->tables[0];
+
+	if (num > 0)
+		return -EPERM;
+
+	if (tbl->it_page_shift != page_shift ||
+	    tbl->it_size != (window_size >> page_shift) ||
+	    tbl->it_indirect_levels != levels - 1)
+		return -EINVAL;
+
+	*ptbl = iommu_tce_table_get(tbl);
+	return 0;
+}
+
+static long spapr_tce_set_window(struct iommu_table_group *table_group,
+			       int num, struct iommu_table *tbl)
+{
+	return tbl == table_group->tables[num] ? 0 : -EPERM;
+}
+
+static long spapr_tce_unset_window(struct iommu_table_group *table_group, int num)
+{
+	return 0;
+}
+
+static long spapr_tce_take_ownership(struct iommu_table_group *table_group)
+{
+	int i, j, rc = 0;
+
+	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
+		struct iommu_table *tbl = table_group->tables[i];
+
+		if (!tbl || !tbl->it_map)
+			continue;
+
+		rc = iommu_take_ownership(tbl);
+		if (!rc)
+			continue;
+		for (j = 0; j < i; ++j)
+			iommu_release_ownership(table_group->tables[j]);
+		return rc;
+	}
+	return 0;
+}
+
+static void spapr_tce_release_ownership(struct iommu_table_group *table_group)
+{
+	int i;
+
+	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
+		struct iommu_table *tbl = table_group->tables[i];
+
+		if (!tbl)
+			continue;
+
+		iommu_table_clear(tbl);
+		if (tbl->it_map)
+			iommu_release_ownership(tbl);
+	}
+}
+
+struct iommu_table_group_ops spapr_tce_table_group_ops = {
+	.get_table_size = spapr_tce_get_table_size,
+	.create_table = spapr_tce_create_table,
+	.set_window = spapr_tce_set_window,
+	.unset_window = spapr_tce_unset_window,
+	.take_ownership = spapr_tce_take_ownership,
+	.release_ownership = spapr_tce_release_ownership,
+};
+
 #endif /* CONFIG_IOMMU_API */
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 5c144c05cbfd..7b371322f1ae 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1554,6 +1554,8 @@ static void pnv_pci_ioda1_setup_dma_pe(struct pnv_phb *phb,
 	if (WARN_ON(!tbl))
 		return;
 
+	pe->table_group.ops = &spapr_tce_table_group_ops;
+	pe->table_group.pgsizes = SZ_4K;
 	iommu_register_group(&pe->table_group, phb->hose->global_number,
 			pe->pe_number);
 	pnv_pci_link_table_and_group(phb->hose->node, 0, tbl, &pe->table_group);
@@ -1888,7 +1890,7 @@ static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe, struct pci_bus *bus)
 	}
 }
 
-static void pnv_ioda2_take_ownership(struct iommu_table_group *table_group)
+static long pnv_ioda2_take_ownership(struct iommu_table_group *table_group)
 {
 	struct pnv_ioda_pe *pe = container_of(table_group, struct pnv_ioda_pe,
 						table_group);
@@ -1902,6 +1904,8 @@ static void pnv_ioda2_take_ownership(struct iommu_table_group *table_group)
 	else if (pe->pdev)
 		set_iommu_table_base(&pe->pdev->dev, NULL);
 	iommu_tce_table_put(tbl);
+
+	return 0;
 }
 
 static void pnv_ioda2_release_ownership(struct iommu_table_group *table_group)
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index c74b71d4733d..6769d2c55187 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -74,6 +74,9 @@ static struct iommu_table_group *iommu_pseries_alloc_group(int node)
 	if (!table_group)
 		return NULL;
 
+	table_group->ops = &spapr_tce_table_group_ops;
+	table_group->pgsizes = SZ_4K;
+
 	table_group->tables[0] = iommu_pseries_alloc_table(node);
 	if (table_group->tables[0])
 		return table_group;
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 60a50ce8701e..c3f8ae102ece 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -1189,52 +1189,6 @@ static long tce_iommu_ioctl(void *iommu_data,
 
 static void tce_iommu_release_ownership(struct tce_container *container,
 		struct iommu_table_group *table_group)
-{
-	int i;
-
-	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
-		struct iommu_table *tbl = container->tables[i];
-
-		if (!tbl)
-			continue;
-
-		tce_iommu_clear(container, tbl, tbl->it_offset, tbl->it_size);
-		if (tbl->it_map)
-			iommu_release_ownership(tbl);
-
-		container->tables[i] = NULL;
-	}
-}
-
-static int tce_iommu_take_ownership(struct tce_container *container,
-		struct iommu_table_group *table_group)
-{
-	int i, j, rc = 0;
-
-	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
-		struct iommu_table *tbl = table_group->tables[i];
-
-		if (!tbl || !tbl->it_map)
-			continue;
-
-		rc = iommu_take_ownership(tbl);
-		if (rc) {
-			for (j = 0; j < i; ++j)
-				iommu_release_ownership(
-						table_group->tables[j]);
-
-			return rc;
-		}
-	}
-
-	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i)
-		container->tables[i] = table_group->tables[i];
-
-	return 0;
-}
-
-static void tce_iommu_release_ownership_ddw(struct tce_container *container,
-		struct iommu_table_group *table_group)
 {
 	long i;
 
@@ -1250,18 +1204,14 @@ static void tce_iommu_release_ownership_ddw(struct tce_container *container,
 	table_group->ops->release_ownership(table_group);
 }
 
-static long tce_iommu_take_ownership_ddw(struct tce_container *container,
+static long tce_iommu_take_ownership(struct tce_container *container,
 		struct iommu_table_group *table_group)
 {
 	long i, ret = 0;
 
-	if (!table_group->ops->create_table || !table_group->ops->set_window ||
-			!table_group->ops->release_ownership) {
-		WARN_ON_ONCE(1);
-		return -EFAULT;
-	}
-
-	table_group->ops->take_ownership(table_group);
+	ret = table_group->ops->take_ownership(table_group);
+	if (ret)
+		return ret;
 
 	/* Set all windows to the new group */
 	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
@@ -1307,9 +1257,14 @@ static int tce_iommu_attach_group(void *iommu_data,
 		goto unlock_exit;
 	}
 
-	if (tce_groups_attached(container) && (!table_group->ops ||
-			!table_group->ops->take_ownership ||
-			!table_group->ops->release_ownership)) {
+	/* v2 requires full support of dynamic DMA windows */
+	if (container->v2 && table_group->max_dynamic_windows_supported == 0) {
+		ret = -EINVAL;
+		goto unlock_exit;
+	}
+
+	/* v1 reuses TCE tables and does not share them among PEs */
+	if (!container->v2 && tce_groups_attached(container)) {
 		ret = -EBUSY;
 		goto unlock_exit;
 	}
@@ -1344,29 +1299,15 @@ static int tce_iommu_attach_group(void *iommu_data,
 		goto unlock_exit;
 	}
 
-	if (!table_group->ops || !table_group->ops->take_ownership ||
-			!table_group->ops->release_ownership) {
-		if (container->v2) {
-			ret = -EPERM;
-			goto free_exit;
-		}
-		ret = tce_iommu_take_ownership(container, table_group);
-	} else {
-		if (!container->v2) {
-			ret = -EPERM;
-			goto free_exit;
-		}
-		ret = tce_iommu_take_ownership_ddw(container, table_group);
-		if (!tce_groups_attached(container) && !container->tables[0])
-			container->def_window_pending = true;
-	}
+	ret = tce_iommu_take_ownership(container, table_group);
+	if (!tce_groups_attached(container) && !container->tables[0])
+		container->def_window_pending = true;
 
 	if (!ret) {
 		tcegrp->grp = iommu_group;
 		list_add(&tcegrp->next, &container->group_list);
 	}
 
-free_exit:
 	if (ret && tcegrp)
 		kfree(tcegrp);
 
@@ -1405,10 +1346,7 @@ static void tce_iommu_detach_group(void *iommu_data,
 	table_group = iommu_group_get_iommudata(iommu_group);
 	BUG_ON(!table_group);
 
-	if (!table_group->ops || !table_group->ops->release_ownership)
-		tce_iommu_release_ownership(container, table_group);
-	else
-		tce_iommu_release_ownership_ddw(container, table_group);
+	tce_iommu_release_ownership(container, table_group);
 
 unlock_exit:
 	mutex_unlock(&container->lock);
-- 
2.30.2

