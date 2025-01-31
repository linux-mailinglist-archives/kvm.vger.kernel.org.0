Return-Path: <kvm+bounces-36991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51A07A23D1A
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEF857A4A12
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647AE1C3F30;
	Fri, 31 Jan 2025 11:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dWgk4IY/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8991C3C04;
	Fri, 31 Jan 2025 11:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322745; cv=none; b=fdnZTT/FEMkLgGBNnXe73CrLDZCtzvy1AcDEeBC0cXp22h5uhgqn3t6NGld9SG43rPxPDR1XXZ/3gePkkT746eu8cKkGR2giUo5wc/TJNJi2NverByUzoqtAg/PJdLHVRa8LM6RV9yoLePr1v0Dr93R1DnzUfL3w0mO3heO75mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322745; c=relaxed/simple;
	bh=cyVMUtp3GpPzOsCkywjLHASKbduzHwmFtg5tnLO/08k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWeEHZAz3OKxOsbHNL3VYemQxZplQvCzFIMe6V5P1/Q39mdEkX+XB3Lsaxstljlj6YvgYuQsIMoKLP50OeLNJ7PCChRxZROA89Gmt+5FUQnen2PlIBXcBI1uJtMDR+At9AM22DekKQEkpIu9Rw7NT4T/SWCy2hB/g4wJEAREah8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dWgk4IY/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V7Wlmr009615;
	Fri, 31 Jan 2025 11:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Vv2mYr1QE6orof4Hh
	98hGfnOQyL2V/jX5nEARk+vQ1U=; b=dWgk4IY/wB7BZIWeHfOneUAjJhvjQB8KC
	tS77pO+ub0ZuppK92l8yDSb1wZpx4aoh3xkEt3k7urT5ZkDiOdDHBMS/qbt9jRue
	AWUO7oN1JB3MCks+Y2I8eVfVcyOPcMoES3dLa4CFhFlGAnTmNMEqaL/yJ4TYbuZ8
	h/6aasfY9Jz3bMo79uwEP1WwLZRK9GP2r5IYecJgmazBzlNAkFs5He/MvF/DQfve
	pD3W6lJ0W/enzZ/tL4lehpLXUSwr4vmb5WJdg0MVackrVHM8pY16wuRdnFRSsJvI
	Rixm3vUajNnFV0imZvC3bLLKAHrZbADrG8m68VbqW3vwB7kvVLqEA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gt7n8v48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V8Cjr9017137;
	Fri, 31 Jan 2025 11:25:41 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gfaxb8mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:40 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPaBQ52494712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:36 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EC7D20138;
	Fri, 31 Jan 2025 11:25:36 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55D9E2012D;
	Fri, 31 Jan 2025 11:25:27 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:27 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 16/20] KVM: s390: move gmap_shadow_pgt_lookup() into kvm
Date: Fri, 31 Jan 2025 12:25:06 +0100
Message-ID: <20250131112510.48531-17-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250131112510.48531-1-imbrenda@linux.ibm.com>
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FTgLhbU2RxdjAGhhzvpGK0ht7dH233vu
X-Proofpoint-ORIG-GUID: FTgLhbU2RxdjAGhhzvpGK0ht7dH233vu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

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


