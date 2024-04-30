Return-Path: <kvm+bounces-16271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 625448B811C
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 22:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 178C6289D99
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76666199EBC;
	Tue, 30 Apr 2024 20:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C1rm/uLJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F5E17B514;
	Tue, 30 Apr 2024 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714507589; cv=none; b=u9zQtwQa3mcEP/6ResuF8PoAFRmcE/jky3UFJlEzbjsd1t0BKLA+XLsKxjmhyYEEQVrUXvx5ifQ8DEDS9h0AeTR9oO7J+Bmi/Qqq76OtZBpgTMok/BYHarzrRY3y+WKzAdQpRFgpBnEa3+5wApsCCsQMTAqnooy7WvI2nVvwHLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714507589; c=relaxed/simple;
	bh=2lG/u4hIQbf19mKOdTjRLNfY8BXpsd5HcRnN4ASxL94=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UiMNN46WpnC50+9ylDN5QsNojJXESVXXxRocQeQJnMLChcCOAW9ppLlStXykb7wApGN8Rpkn3ck6f1asen3pzDgSZLzSXR3RELkcmweauB1WlQFqWyBV/rOZEwwNd9a/fg+9FrblFKxAbx+Ab65B1YodHegISXWAF5KBGNdaWrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C1rm/uLJ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UJjxv1024013;
	Tue, 30 Apr 2024 20:06:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=M1a6Ko95omNkvAXjrrH7BjRDv9/Py+Qe9vC3vFVQ6vU=;
 b=C1rm/uLJ4YRzstWkwNwLdimWq1t+0IjFaO3/wTMXyIpIOOXXt7x7g2G0+fCjWbjr7Quf
 HnmJzvxrJUzJbRRRL9evPT8cThiANuozt+gpDYyj5gjKgWv25Fvwhrgc5oZd1nFEzC0H
 Lie0H4kWje5F2fuUL4msbJe5NDtOR8UPnyeD0Al1JJ9PH6v58N0M3/fYr1TONqBb7b07
 jyIbOIfvmmut2DSplaGkJqOv/tP+lQnNH5X32RJiQFuukwOUJy9sHHzIJDjVhRPtNtYw
 ayjk5vPW327acc8xF8m0XGMhtMe+xzzdV8aNJjyQd4UtQx/lsdYeSt3PZfT/igvkJZYD rw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu655r62a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:01 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43UK17oD013824;
	Tue, 30 Apr 2024 20:06:00 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu655r625-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:06:00 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHc3lZ011769;
	Tue, 30 Apr 2024 20:05:59 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xsdwm6ngd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 20:05:59 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43UK5stt48365834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 20:05:56 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6324B2004F;
	Tue, 30 Apr 2024 20:05:54 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B28982004E;
	Tue, 30 Apr 2024 20:05:50 +0000 (GMT)
Received: from ltcd48-lp2.aus.stglabs.ibm.com (unknown [9.3.101.175])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Apr 2024 20:05:50 +0000 (GMT)
Subject: [RFC PATCH v2 1/6] powerpc/iommu: Move pSeries specific functions to
 pseries/iommu.c
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: mpe@ellerman.id.au, tpearson@raptorengineering.com,
        alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org, aik@amd.com
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
        naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sbhat@linux.ibm.com, aik@ozlabs.ru,
        jgg@ziepe.ca, ruscur@russell.cc, robh@kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au, kvm@vger.kernel.org,
        msuchanek@suse.de, oohall@gmail.com, mahesh@linux.ibm.com,
        jroedel@suse.de, vaibhav@linux.ibm.com, svaidy@linux.ibm.com
Date: Tue, 30 Apr 2024 15:05:50 -0500
Message-ID: <171450754445.10851.16637173386204659951.stgit@linux.ibm.com>
In-Reply-To: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>
References: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i5STicO4CSi1iUUalLJUsz4dz_p1XvlC
X-Proofpoint-GUID: peuzFnnKeZu5TLbb8tv3MVR9E74Koy27
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_12,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404300143

The PowerNV specific table_group_ops are defined in powernv/pci-ioda.c.
The pSeries specific table_group_ops are sitting in the generic powerpc
file. Move it to where it actually belong(pseries/iommu.c).

Only code movement, no functional changes intended.

Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
---
 arch/powerpc/include/asm/iommu.h       |    4 +
 arch/powerpc/kernel/iommu.c            |  149 --------------------------------
 arch/powerpc/platforms/pseries/iommu.c |  144 +++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+), 148 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 026695943550..744cc5fc22d3 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -156,6 +156,9 @@ extern int iommu_tce_table_put(struct iommu_table *tbl);
 extern struct iommu_table *iommu_init_table(struct iommu_table *tbl,
 		int nid, unsigned long res_start, unsigned long res_end);
 bool iommu_table_in_use(struct iommu_table *tbl);
+extern void iommu_table_reserve_pages(struct iommu_table *tbl,
+		unsigned long res_start, unsigned long res_end);
+extern void iommu_table_clear(struct iommu_table *tbl);
 
 #define IOMMU_TABLE_GROUP_MAX_TABLES	2
 
@@ -218,7 +221,6 @@ extern long iommu_tce_xchg_no_kill(struct mm_struct *mm,
 extern void iommu_tce_kill(struct iommu_table *tbl,
 		unsigned long entry, unsigned long pages);
 
-extern struct iommu_table_group_ops spapr_tce_table_group_ops;
 #else
 static inline void iommu_register_group(struct iommu_table_group *table_group,
 					int pci_domain_number,
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 29a8c8e18585..bc4584e73061 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -642,7 +642,7 @@ void ppc_iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 		tbl->it_ops->flush(tbl);
 }
 
-static void iommu_table_clear(struct iommu_table *tbl)
+void iommu_table_clear(struct iommu_table *tbl)
 {
 	/*
 	 * In case of firmware assisted dump system goes through clean
@@ -683,7 +683,7 @@ static void iommu_table_clear(struct iommu_table *tbl)
 #endif
 }
 
-static void iommu_table_reserve_pages(struct iommu_table *tbl,
+void iommu_table_reserve_pages(struct iommu_table *tbl,
 		unsigned long res_start, unsigned long res_end)
 {
 	int i;
@@ -1101,59 +1101,6 @@ void iommu_tce_kill(struct iommu_table *tbl,
 }
 EXPORT_SYMBOL_GPL(iommu_tce_kill);
 
-#if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_PPC_POWERNV)
-static int iommu_take_ownership(struct iommu_table *tbl)
-{
-	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
-	int ret = 0;
-
-	/*
-	 * VFIO does not control TCE entries allocation and the guest
-	 * can write new TCEs on top of existing ones so iommu_tce_build()
-	 * must be able to release old pages. This functionality
-	 * requires exchange() callback defined so if it is not
-	 * implemented, we disallow taking ownership over the table.
-	 */
-	if (!tbl->it_ops->xchg_no_kill)
-		return -EINVAL;
-
-	spin_lock_irqsave(&tbl->large_pool.lock, flags);
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
-
-	if (iommu_table_in_use(tbl)) {
-		pr_err("iommu_tce: it_map is not empty");
-		ret = -EBUSY;
-	} else {
-		memset(tbl->it_map, 0xff, sz);
-	}
-
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_unlock(&tbl->pools[i].lock);
-	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
-
-	return ret;
-}
-
-static void iommu_release_ownership(struct iommu_table *tbl)
-{
-	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
-
-	spin_lock_irqsave(&tbl->large_pool.lock, flags);
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
-
-	memset(tbl->it_map, 0, sz);
-
-	iommu_table_reserve_pages(tbl, tbl->it_reserved_start,
-			tbl->it_reserved_end);
-
-	for (i = 0; i < tbl->nr_pools; i++)
-		spin_unlock(&tbl->pools[i].lock);
-	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
-}
-#endif
-
 int iommu_add_device(struct iommu_table_group *table_group, struct device *dev)
 {
 	/*
@@ -1185,98 +1132,6 @@ int iommu_add_device(struct iommu_table_group *table_group, struct device *dev)
 EXPORT_SYMBOL_GPL(iommu_add_device);
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_PPC_POWERNV)
-/*
- * A simple iommu_table_group_ops which only allows reusing the existing
- * iommu_table. This handles VFIO for POWER7 or the nested KVM.
- * The ops does not allow creating windows and only allows reusing the existing
- * one if it matches table_group->tce32_start/tce32_size/page_shift.
- */
-static unsigned long spapr_tce_get_table_size(__u32 page_shift,
-					      __u64 window_size, __u32 levels)
-{
-	unsigned long size;
-
-	if (levels > 1)
-		return ~0U;
-	size = window_size >> (page_shift - 3);
-	return size;
-}
-
-static long spapr_tce_create_table(struct iommu_table_group *table_group, int num,
-				   __u32 page_shift, __u64 window_size, __u32 levels,
-				   struct iommu_table **ptbl)
-{
-	struct iommu_table *tbl = table_group->tables[0];
-
-	if (num > 0)
-		return -EPERM;
-
-	if (tbl->it_page_shift != page_shift ||
-	    tbl->it_size != (window_size >> page_shift) ||
-	    tbl->it_indirect_levels != levels - 1)
-		return -EINVAL;
-
-	*ptbl = iommu_tce_table_get(tbl);
-	return 0;
-}
-
-static long spapr_tce_set_window(struct iommu_table_group *table_group,
-				 int num, struct iommu_table *tbl)
-{
-	return tbl == table_group->tables[num] ? 0 : -EPERM;
-}
-
-static long spapr_tce_unset_window(struct iommu_table_group *table_group, int num)
-{
-	return 0;
-}
-
-static long spapr_tce_take_ownership(struct iommu_table_group *table_group)
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
-		if (!rc)
-			continue;
-
-		for (j = 0; j < i; ++j)
-			iommu_release_ownership(table_group->tables[j]);
-		return rc;
-	}
-	return 0;
-}
-
-static void spapr_tce_release_ownership(struct iommu_table_group *table_group)
-{
-	int i;
-
-	for (i = 0; i < IOMMU_TABLE_GROUP_MAX_TABLES; ++i) {
-		struct iommu_table *tbl = table_group->tables[i];
-
-		if (!tbl)
-			continue;
-
-		iommu_table_clear(tbl);
-		if (tbl->it_map)
-			iommu_release_ownership(tbl);
-	}
-}
-
-struct iommu_table_group_ops spapr_tce_table_group_ops = {
-	.get_table_size = spapr_tce_get_table_size,
-	.create_table = spapr_tce_create_table,
-	.set_window = spapr_tce_set_window,
-	.unset_window = spapr_tce_unset_window,
-	.take_ownership = spapr_tce_take_ownership,
-	.release_ownership = spapr_tce_release_ownership,
-};
-
 /*
  * A simple iommu_ops to allow less cruft in generic VFIO code.
  */
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index e8c4129697b1..c6850ec1919a 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -54,6 +54,57 @@ enum {
 	DDW_EXT_QUERY_OUT_SIZE = 2
 };
 
+static int iommu_take_ownership(struct iommu_table *tbl)
+{
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
+	int ret = 0;
+
+	/*
+	 * VFIO does not control TCE entries allocation and the guest
+	 * can write new TCEs on top of existing ones so iommu_tce_build()
+	 * must be able to release old pages. This functionality
+	 * requires exchange() callback defined so if it is not
+	 * implemented, we disallow taking ownership over the table.
+	 */
+	if (!tbl->it_ops->xchg_no_kill)
+		return -EINVAL;
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
+
+	if (iommu_table_in_use(tbl)) {
+		pr_err("iommu_tce: it_map is not empty");
+		ret = -EBUSY;
+	} else {
+		memset(tbl->it_map, 0xff, sz);
+	}
+
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
+
+	return ret;
+}
+
+static void iommu_release_ownership(struct iommu_table *tbl)
+{
+	unsigned long flags, i, sz = (tbl->it_size + 7) >> 3;
+
+	spin_lock_irqsave(&tbl->large_pool.lock, flags);
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_lock_nest_lock(&tbl->pools[i].lock, &tbl->large_pool.lock);
+
+	memset(tbl->it_map, 0, sz);
+
+	iommu_table_reserve_pages(tbl, tbl->it_reserved_start,
+			tbl->it_reserved_end);
+
+	for (i = 0; i < tbl->nr_pools; i++)
+		spin_unlock(&tbl->pools[i].lock);
+	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
+}
+
 static struct iommu_table *iommu_pseries_alloc_table(int node)
 {
 	struct iommu_table *tbl;
@@ -67,6 +118,8 @@ static struct iommu_table *iommu_pseries_alloc_table(int node)
 	return tbl;
 }
 
+struct iommu_table_group_ops spapr_tce_table_group_ops;
+
 static struct iommu_table_group *iommu_pseries_alloc_group(int node)
 {
 	struct iommu_table_group *table_group;
@@ -1643,6 +1696,97 @@ static bool iommu_bypass_supported_pSeriesLP(struct pci_dev *pdev, u64 dma_mask)
 	return false;
 }
 
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
+static long spapr_tce_create_table(struct iommu_table_group *table_group, int num,
+				   __u32 page_shift, __u64 window_size, __u32 levels,
+				   struct iommu_table **ptbl)
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
+				 int num, struct iommu_table *tbl)
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
+
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
 static int iommu_mem_notifier(struct notifier_block *nb, unsigned long action,
 		void *data)
 {



