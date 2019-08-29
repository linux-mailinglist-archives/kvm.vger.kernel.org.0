Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909BFA142A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 10:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfH2IxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 04:53:03 -0400
Received: from ozlabs.ru ([107.173.13.209]:49810 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbfH2IxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 04:53:03 -0400
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 318D5AE80382;
        Thu, 29 Aug 2019 04:52:39 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel v3 3/5] vfio/spapr_tce: Invalidate multiple TCEs at once
Date:   Thu, 29 Aug 2019 18:52:50 +1000
Message-Id: <20190829085252.72370-4-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829085252.72370-1-aik@ozlabs.ru>
References: <20190829085252.72370-1-aik@ozlabs.ru>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invalidating a TCE cache entry for each updated TCE is quite expensive.
This makes use of the new iommu_table_ops::xchg_no_kill()/tce_kill()
callbacks to bring down the time spent in mapping a huge guest DMA window.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index babef8b00daf..3b18fa4d090a 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -435,7 +435,7 @@ static int tce_iommu_clear(struct tce_container *container,
 	unsigned long oldhpa;
 	long ret;
 	enum dma_data_direction direction;
-	unsigned long lastentry = entry + pages;
+	unsigned long lastentry = entry + pages, firstentry = entry;
 
 	for ( ; entry < lastentry; ++entry) {
 		if (tbl->it_indirect_levels && tbl->it_userspace) {
@@ -460,7 +460,7 @@ static int tce_iommu_clear(struct tce_container *container,
 
 		direction = DMA_NONE;
 		oldhpa = 0;
-		ret = iommu_tce_xchg(container->mm, tbl, entry, &oldhpa,
+		ret = iommu_tce_xchg_no_kill(container->mm, tbl, entry, &oldhpa,
 				&direction);
 		if (ret)
 			continue;
@@ -476,6 +476,8 @@ static int tce_iommu_clear(struct tce_container *container,
 		tce_iommu_unuse_page(container, oldhpa);
 	}
 
+	iommu_tce_kill(tbl, firstentry, pages);
+
 	return 0;
 }
 
@@ -518,8 +520,8 @@ static long tce_iommu_build(struct tce_container *container,
 
 		hpa |= offset;
 		dirtmp = direction;
-		ret = iommu_tce_xchg(container->mm, tbl, entry + i, &hpa,
-				&dirtmp);
+		ret = iommu_tce_xchg_no_kill(container->mm, tbl, entry + i,
+				&hpa, &dirtmp);
 		if (ret) {
 			tce_iommu_unuse_page(container, hpa);
 			pr_err("iommu_tce: %s failed ioba=%lx, tce=%lx, ret=%ld\n",
@@ -536,6 +538,8 @@ static long tce_iommu_build(struct tce_container *container,
 
 	if (ret)
 		tce_iommu_clear(container, tbl, entry, i);
+	else
+		iommu_tce_kill(tbl, entry, pages);
 
 	return ret;
 }
@@ -572,8 +576,8 @@ static long tce_iommu_build_v2(struct tce_container *container,
 		if (mm_iommu_mapped_inc(mem))
 			break;
 
-		ret = iommu_tce_xchg(container->mm, tbl, entry + i, &hpa,
-				&dirtmp);
+		ret = iommu_tce_xchg_no_kill(container->mm, tbl, entry + i,
+				&hpa, &dirtmp);
 		if (ret) {
 			/* dirtmp cannot be DMA_NONE here */
 			tce_iommu_unuse_page_v2(container, tbl, entry + i);
@@ -593,6 +597,8 @@ static long tce_iommu_build_v2(struct tce_container *container,
 
 	if (ret)
 		tce_iommu_clear(container, tbl, entry, i);
+	else
+		iommu_tce_kill(tbl, entry, pages);
 
 	return ret;
 }
-- 
2.17.1

