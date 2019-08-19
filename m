Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9CF91AE8
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 03:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfHSB66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Aug 2019 21:58:58 -0400
Received: from ozlabs.ru ([107.173.13.209]:58636 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbfHSB66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Aug 2019 21:58:58 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Aug 2019 21:58:57 EDT
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 0CA6BAE8001C;
        Sun, 18 Aug 2019 21:51:00 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Jose Ricardo Ziviani <joserz@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH kernel] vfio/spapr_tce: Fix incorrect tce_iommu_group memory free
Date:   Mon, 19 Aug 2019 11:51:17 +1000
Message-Id: <20190819015117.94878-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The @tcegrp variable is used in 1) a loop over attached groups
2) it stores a pointer to a newly allocated tce_iommu_group if 1) found
nothing. However the error handler does not distinguish how we got there
and incorrectly releases memory for a found+incompatible group.

This fixes it by adding another error handling case.

Fixes: 0bd971676e68 ("powerpc/powernv/npu: Add compound IOMMU groups")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

The bug is there since 2157e7b82f3b but it would not appear in practice
before 0bd971676e68, hence that "Fixes". Or it still should be
157e7b82f3b ("vfio: powerpc/spapr: Register memory and define IOMMU v2")
?

Found it when tried adding a "compound PE" (GPU + NPUs) to a container
with a passed through xHCI host. The compatibility test (->create_table
should be equal) treats them as incompatible which might a bug (or
we are just suboptimal here) on its own.

---
 drivers/vfio/vfio_iommu_spapr_tce.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 8ce9ad21129f..babef8b00daf 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -1234,7 +1234,7 @@ static long tce_iommu_take_ownership_ddw(struct tce_container *container,
 static int tce_iommu_attach_group(void *iommu_data,
 		struct iommu_group *iommu_group)
 {
-	int ret;
+	int ret = 0;
 	struct tce_container *container = iommu_data;
 	struct iommu_table_group *table_group;
 	struct tce_iommu_group *tcegrp = NULL;
@@ -1287,13 +1287,13 @@ static int tce_iommu_attach_group(void *iommu_data,
 			!table_group->ops->release_ownership) {
 		if (container->v2) {
 			ret = -EPERM;
-			goto unlock_exit;
+			goto free_exit;
 		}
 		ret = tce_iommu_take_ownership(container, table_group);
 	} else {
 		if (!container->v2) {
 			ret = -EPERM;
-			goto unlock_exit;
+			goto free_exit;
 		}
 		ret = tce_iommu_take_ownership_ddw(container, table_group);
 		if (!tce_groups_attached(container) && !container->tables[0])
@@ -1305,10 +1305,11 @@ static int tce_iommu_attach_group(void *iommu_data,
 		list_add(&tcegrp->next, &container->group_list);
 	}
 
-unlock_exit:
+free_exit:
 	if (ret && tcegrp)
 		kfree(tcegrp);
 
+unlock_exit:
 	mutex_unlock(&container->lock);
 
 	return ret;
-- 
2.17.1

