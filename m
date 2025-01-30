Return-Path: <kvm+bounces-36910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B07A22AD3
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:53:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41527162057
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97931B6D18;
	Thu, 30 Jan 2025 09:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QkRSkaeD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C810A1B87DF;
	Thu, 30 Jan 2025 09:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230692; cv=none; b=YUEp1MnOmnznqCtTb/ycuxW/KRoUrvHV28Gn6xsWuA5RdzQ66fXko6QU5RjnOZYkmaAfOyGz2WOEbPfbD3gp3vCHLN1o2aFmGJXvJh18GTCIibgQLnZQ/OoC5oPjfN+vK35JEE8ZhGtKof+U5OWpiiLOfytTsDdV+nZzTe4s9kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230692; c=relaxed/simple;
	bh=cyVMUtp3GpPzOsCkywjLHASKbduzHwmFtg5tnLO/08k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqD9V7XxGLszaLbW+j0NMRNkLerJP2mqSPfQg+s//aAUcDfRzOKf5nfQ3+yNiYrIHXyx0klsCJBbrSokc98scD5OYVIbyWEIcG0LSb6KgelRuvBboFC8QoJa4H+EIMQ+0HH1T0Rl1ujKSvVQHLq48ca01KwKF1cAvByj6SpTugY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QkRSkaeD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U7Xi2e000449;
	Thu, 30 Jan 2025 09:51:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Vv2mYr1QE6orof4Hh
	98hGfnOQyL2V/jX5nEARk+vQ1U=; b=QkRSkaeDjgTI9+znHoPhcXZNX0HDVdBdz
	PRPNY5xtQg+Zrk4bsKqxK7ltZ/Ia5wWDb00kzqOs+78NuqOEPMOgEk0YR1pXxOWh
	vgONHmjXOs8ma/BtGWsdthM70ULMBqFTdBJaCvEDIxrF5G5/CnRaJFQE3ZIzIx46
	dYeKVZkmQStZZ7qAglXsd9CqxZbp+k/MqwP70O3p7RkjgvKX7vJGtHQKv/zDNgQT
	zRlLyY00rVGqRYpcPaH/hNNHPi9dXJs8J6kJTVZnbvKuqDSsG7tRJOY+5KnIfm8M
	PUagXfE7i6eoYharESkCucGZAR63qtJtGhilDm8zjhPXWmotJqq1g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44g54nrjdd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:27 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U8SJKX019265;
	Thu, 30 Jan 2025 09:51:26 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44db9n5fkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:26 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pMWM19857754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 724C02013D;
	Thu, 30 Jan 2025 09:51:22 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5097720142;
	Thu, 30 Jan 2025 09:51:22 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:22 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 16/20] KVM: s390: move gmap_shadow_pgt_lookup() into kvm
Date: Thu, 30 Jan 2025 10:51:09 +0100
Message-ID: <20250130095113.166876-17-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130095113.166876-1-imbrenda@linux.ibm.com>
References: <20250130095113.166876-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Wc6WK2RKOrEeVKHYHTI3cAqEwfNULVVo
X-Proofpoint-ORIG-GUID: Wc6WK2RKOrEeVKHYHTI3cAqEwfNULVVo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501300073

Move gmap_shadow_pgt_lookup() from mm/gmap.c into kvm/gaccess.c .

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20250123144627.312456-13-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-13-imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  3 +--
 arch/s390/kvm/gaccess.c      | 42 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/gmap.h         |  2 ++
 arch/s390/mm/gmap.c          | 46 ++----------------------------------
 4 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index b489c4589618..4e73ef46d4b2 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -125,8 +125,6 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		    int fake);
 int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 		    int fake);
-int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr,
-			   unsigned long *pgt, int *dat_protection, int *fake);
 int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte);
 
 void gmap_register_pte_notifier(struct gmap_notifier *);
@@ -142,6 +140,7 @@ void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
 			    unsigned long end, bool interruptible);
 int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
+unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
 
 /**
  * s390_uv_destroy_range - Destroy a range of pages in the given mm.
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 9816b0060fbe..bb1340389369 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -16,6 +16,7 @@
 #include <asm/gmap.h>
 #include <asm/dat-bits.h>
 #include "kvm-s390.h"
+#include "gmap.h"
 #include "gaccess.h"
 
 /*
@@ -1392,6 +1393,42 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 	return 0;
 }
 
+/**
+ * shadow_pgt_lookup() - find a shadow page table
+ * @sg: pointer to the shadow guest address space structure
+ * @saddr: the address in the shadow aguest address space
+ * @pgt: parent gmap address of the page table to get shadowed
+ * @dat_protection: if the pgtable is marked as protected by dat
+ * @fake: pgt references contiguous guest memory block, not a pgtable
+ *
+ * Returns 0 if the shadow page table was found and -EAGAIN if the page
+ * table was not found.
+ *
+ * Called with sg->mm->mmap_lock in read.
+ */
+static int shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned long *pgt,
+			     int *dat_protection, int *fake)
+{
+	unsigned long *table;
+	struct page *page;
+	int rc;
+
+	spin_lock(&sg->guest_table_lock);
+	table = gmap_table_walk(sg, saddr, 1); /* get segment pointer */
+	if (table && !(*table & _SEGMENT_ENTRY_INVALID)) {
+		/* Shadow page tables are full pages (pte+pgste) */
+		page = pfn_to_page(*table >> PAGE_SHIFT);
+		*pgt = page->index & ~GMAP_SHADOW_FAKE_TABLE;
+		*dat_protection = !!(*table & _SEGMENT_ENTRY_PROTECT);
+		*fake = !!(page->index & GMAP_SHADOW_FAKE_TABLE);
+		rc = 0;
+	} else  {
+		rc = -EAGAIN;
+	}
+	spin_unlock(&sg->guest_table_lock);
+	return rc;
+}
+
 /**
  * kvm_s390_shadow_fault - handle fault on a shadow page table
  * @vcpu: virtual cpu
@@ -1415,6 +1452,9 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	int dat_protection, fake;
 	int rc;
 
+	if (KVM_BUG_ON(!gmap_is_shadow(sg), vcpu->kvm))
+		return -EFAULT;
+
 	mmap_read_lock(sg->mm);
 	/*
 	 * We don't want any guest-2 tables to change - so the parent
@@ -1423,7 +1463,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	 */
 	ipte_lock(vcpu->kvm);
 
-	rc = gmap_shadow_pgt_lookup(sg, saddr, &pgt, &dat_protection, &fake);
+	rc = shadow_pgt_lookup(sg, saddr, &pgt, &dat_protection, &fake);
 	if (rc)
 		rc = kvm_s390_shadow_tables(sg, saddr, &pgt, &dat_protection,
 					    &fake);
diff --git a/arch/s390/kvm/gmap.h b/arch/s390/kvm/gmap.h
index 978f541059f0..c8f031c9ea5f 100644
--- a/arch/s390/kvm/gmap.h
+++ b/arch/s390/kvm/gmap.h
@@ -10,6 +10,8 @@
 #ifndef ARCH_KVM_S390_GMAP_H
 #define ARCH_KVM_S390_GMAP_H
 
+#define GMAP_SHADOW_FAKE_TABLE 1ULL
+
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
 int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 07df1a7b5ebe..918ea14515a1 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -36,8 +36,6 @@
 
 #define GMAP_SHADOW_FAKE_TABLE 1ULL
 
-static inline unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
-
 static struct page *gmap_alloc_crst(void)
 {
 	struct page *page;
@@ -738,8 +736,7 @@ static void gmap_call_notifier(struct gmap *gmap, unsigned long start,
  *
  * Note: Can also be called for shadow gmaps.
  */
-static inline unsigned long *gmap_table_walk(struct gmap *gmap,
-					     unsigned long gaddr, int level)
+unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level)
 {
 	const int asce_type = gmap->asce & _ASCE_TYPE_MASK;
 	unsigned long *table = gmap->table;
@@ -790,6 +787,7 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 	}
 	return table;
 }
+EXPORT_SYMBOL(gmap_table_walk);
 
 /**
  * gmap_pte_op_walk - walk the gmap page table, get the page table lock
@@ -1744,46 +1742,6 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 }
 EXPORT_SYMBOL_GPL(gmap_shadow_sgt);
 
-/**
- * gmap_shadow_pgt_lookup - find a shadow page table
- * @sg: pointer to the shadow guest address space structure
- * @saddr: the address in the shadow aguest address space
- * @pgt: parent gmap address of the page table to get shadowed
- * @dat_protection: if the pgtable is marked as protected by dat
- * @fake: pgt references contiguous guest memory block, not a pgtable
- *
- * Returns 0 if the shadow page table was found and -EAGAIN if the page
- * table was not found.
- *
- * Called with sg->mm->mmap_lock in read.
- */
-int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr,
-			   unsigned long *pgt, int *dat_protection,
-			   int *fake)
-{
-	unsigned long *table;
-	struct page *page;
-	int rc;
-
-	BUG_ON(!gmap_is_shadow(sg));
-	spin_lock(&sg->guest_table_lock);
-	table = gmap_table_walk(sg, saddr, 1); /* get segment pointer */
-	if (table && !(*table & _SEGMENT_ENTRY_INVALID)) {
-		/* Shadow page tables are full pages (pte+pgste) */
-		page = pfn_to_page(*table >> PAGE_SHIFT);
-		*pgt = page->index & ~GMAP_SHADOW_FAKE_TABLE;
-		*dat_protection = !!(*table & _SEGMENT_ENTRY_PROTECT);
-		*fake = !!(page->index & GMAP_SHADOW_FAKE_TABLE);
-		rc = 0;
-	} else  {
-		rc = -EAGAIN;
-	}
-	spin_unlock(&sg->guest_table_lock);
-	return rc;
-
-}
-EXPORT_SYMBOL_GPL(gmap_shadow_pgt_lookup);
-
 /**
  * gmap_shadow_pgt - instantiate a shadow page table
  * @sg: pointer to the shadow guest address space structure
-- 
2.48.1


