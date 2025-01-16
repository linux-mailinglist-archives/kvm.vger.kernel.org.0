Return-Path: <kvm+bounces-35649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CE5A1391F
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:34:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3EEA16898B
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96CC1DED63;
	Thu, 16 Jan 2025 11:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pTJDMFUx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6871DE4C9;
	Thu, 16 Jan 2025 11:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027251; cv=none; b=GIAIjvIpyVs5vdDfBNCYDrA20V7SbHbQJL9Q93uNWAYzHxy/xj8V1Zr0EFuUwXWVbfwal+IUFzql0l087QZ77wG4mgiBEQmmgTHUR6acTCNkLlrkGXHdtYif9sNofvKHG6uZX1m3YXbOV0gObPxd+GcbghZ57L6zsw0Yy5bvGG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027251; c=relaxed/simple;
	bh=7fdrQfy6UaVm36+4YmAD0l1PfWDlBEyPzoINIZ23c9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=At/534r7ALwapMmRzxjompnkymQKIt5CxCR821jDEoJZCGjbgVVsH1hI9wsNk2k6KuqTa3G5cQ1pWOx8xeI9n4x1OZk1jqwGzgX9avTys2ezZgxPxbRkEP6MSNz/h6T2LERM9/JwnxOinptih7ikS/4Y175Kjjwn3tENQFN2aOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pTJDMFUx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G3qer9005821;
	Thu, 16 Jan 2025 11:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=edeRWoW03dbKppCmQ
	rmyude+02vwm0NK92qSAZzfFks=; b=pTJDMFUxGpBLLCfuLNtrwyHH/wRjMW6eV
	CHwtPfM39XBdPzHwAEX1dQaB80C5ueSFD7IQ3YSqnF21v/JO/Sayg0aAGcrY6u9f
	RdJQT1J11JLvwmH5Vz1WmkJC84okDhBuYpPlw9i37PucrEN0CEuss4xQ/Fqhs9v+
	5rclTAOSKrj726hCt87fWBqiWTUNKZ9FpWmIMSHhlOmiWh9tpeFjyxAzTiEn861G
	k53r3vwrELa8nHlh+Fcilz4iJGQSneGN5slXRwbOCwFNYp10vNmH1zg3RwwiTt8l
	lFx0J7x4TTTJsBmBY2LD8VODI8z5SPihRY6S7shOpH38IywFvqC5g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkcj0k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:04 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBY4ZT028809;
	Thu, 16 Jan 2025 11:34:04 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkcj0jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GBQOMt016498;
	Thu, 16 Jan 2025 11:34:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p1w7ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:03 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBXxjF65143232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:34:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5C7220040;
	Thu, 16 Jan 2025 11:33:59 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87C1820049;
	Thu, 16 Jan 2025 11:33:59 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:33:59 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 12/15] KVM: s390: move gmap_shadow_pgt_lookup() into kvm
Date: Thu, 16 Jan 2025 12:33:52 +0100
Message-ID: <20250116113355.32184-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250116113355.32184-1-imbrenda@linux.ibm.com>
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: et4ykUCsPTCweYf2jGDhv078HtBoWrRi
X-Proofpoint-GUID: MXq3NRJfk6dbeEjyocHd-sCGdyJmbIN6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=935 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501160086

Move gmap_shadow_pgt_lookup() from mm/gmap.c into kvm/gaccess.c .

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  3 +--
 arch/s390/kvm/gaccess.c      | 40 +++++++++++++++++++++++++++++++
 arch/s390/kvm/gmap.h         |  2 ++
 arch/s390/mm/gmap.c          | 46 ++----------------------------------
 4 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 99ded56c914b..ec07f99fcc7d 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -127,8 +127,6 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		    int fake);
 int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 		    int fake);
-int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr,
-			   unsigned long *pgt, int *dat_protection, int *fake);
 int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte);
 
 void gmap_register_pte_notifier(struct gmap_notifier *);
@@ -143,6 +141,7 @@ int s390_replace_asce(struct gmap *gmap);
 void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
 			    unsigned long end, bool interruptible);
+unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
 
 /**
  * s390_uv_destroy_range - Destroy a range of pages in the given mm.
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 9816b0060fbe..560b5677929b 100644
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
+ * gmap_shadow_pgt_lookup - find a shadow page table
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
+static int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned long *pgt,
+				  int *dat_protection, int *fake)
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
index a5c3ae18bc6f..9d4a62628e51 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -27,8 +27,6 @@
 #define GADDR_VALID(gaddr) ((gaddr) & 1)
 #define GMAP_SHADOW_FAKE_TABLE 1ULL
 
-static inline unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level);
-
 static struct page *gmap_alloc_crst(void)
 {
 	struct page *page;
@@ -729,8 +727,7 @@ static void gmap_call_notifier(struct gmap *gmap, unsigned long start,
  *
  * Note: Can also be called for shadow gmaps.
  */
-static inline unsigned long *gmap_table_walk(struct gmap *gmap,
-					     unsigned long gaddr, int level)
+unsigned long *gmap_table_walk(struct gmap *gmap, unsigned long gaddr, int level)
 {
 	const int asce_type = gmap->asce & _ASCE_TYPE_MASK;
 	unsigned long *table = gmap->table;
@@ -781,6 +778,7 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 	}
 	return table;
 }
+EXPORT_SYMBOL(gmap_table_walk);
 
 /**
  * gmap_pte_op_walk - walk the gmap page table, get the page table lock
@@ -1731,46 +1729,6 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
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
2.47.1


