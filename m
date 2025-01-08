Return-Path: <kvm+bounces-34820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A6DA06421
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C988E3A6247
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35DC203712;
	Wed,  8 Jan 2025 18:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ffov51Jv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D612D202C2E;
	Wed,  8 Jan 2025 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360107; cv=none; b=shEJoJGv5Eg+SIeJz2sUv2XZXToay0ef45TlIjg9dvzwmXY91SdQwBLtIJ4/RYAbWQBWE/xs2wXMFx705reaoJmJBr5c19jjd/mZgtwvuA/wP1dK+R9XiecnYQaHNF0I2NufsQRx5iM5tC2FRbHNCA3OdvnbuCWYi+WL5k6qUHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360107; c=relaxed/simple;
	bh=rhCIAmObF4/umlX26k8v40hUZcBcu2BVgP285oRk9ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIBBqffy9It+7BQHu6NfpvQo1EhFKjN/cwztTWyCMQeANS1vYuTCKu7G65/UFsVlf7b9YUjbTk9g8EhFLJxiHi0oBZuZKEBp0Evv57XgdGdl+o+mVYWwqVWvRf7QsvADqH5mhCyFD4IfnoFNlsyPMVO2u4+5UOYfuuwg/GSJMGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ffov51Jv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508EkhWj007978;
	Wed, 8 Jan 2025 18:15:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=p5Z+d5L6mZWDkWQLC
	FSXNJZg64A5WrQYIfWoZXL/SFI=; b=Ffov51JvkmxSb4riEPFRIFrGrlif4j8h1
	SY+FpoPYmid/3Kwo91wizmutnQo+otE+Dc4GqQlUP33uSCWsJ74aCI3Xz09GJ+3V
	7AfFKp2wz9bJUhzK/GM1/j6ozHo0vCt6i9WIMvRZieYuPu1hELPcgk9+6IkCp5DL
	1qhds5lF6DzZ5XrHqJ2uO6jM+1dWsMS4odRDzA5PmkprTIFHDeU6wvraeZLKvKMv
	xV2NEvNRc1MkMLQCCOrKCn4phUK9XeWc8f6x2iNZSWMm1wodpSxvo/xP7YOvMzzC
	JW4lxd5p35jlWfhtgjaTyKCnsg3q29fk2box8utdPO3GQcs27WOIA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441huputwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508GVGgd008861;
	Wed, 8 Jan 2025 18:14:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfq01817-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IEsY538338888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:54 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6056A2004D;
	Wed,  8 Jan 2025 18:14:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3BA792004B;
	Wed,  8 Jan 2025 18:14:54 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:14:54 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: [PATCH v1 10/13] KVM: s390: move gmap_shadow_pgt_lookup() into kvm
Date: Wed,  8 Jan 2025 19:14:48 +0100
Message-ID: <20250108181451.74383-11-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108181451.74383-1-imbrenda@linux.ibm.com>
References: <20250108181451.74383-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HmYGUOow9u6-KuMOf7wh0IFaS_altXas
X-Proofpoint-GUID: HmYGUOow9u6-KuMOf7wh0IFaS_altXas
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=897
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080148

Move gmap_shadow_pgt_lookup() from mm/gmap.c into kvm/gaccess.c .

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  3 +--
 arch/s390/kvm/gaccess.c      | 40 +++++++++++++++++++++++++++++++
 arch/s390/kvm/gmap.h         |  2 ++
 arch/s390/mm/gmap.c          | 46 ++----------------------------------
 4 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 65d3565b1e86..5ebc65ac78cc 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -129,8 +129,6 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		    int fake);
 int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 		    int fake);
-int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr,
-			   unsigned long *pgt, int *dat_protection, int *fake);
 int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte);
 
 void gmap_register_pte_notifier(struct gmap_notifier *);
@@ -145,6 +143,7 @@ int s390_replace_asce(struct gmap *gmap);
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
index f2b52ce29be3..14431ce978da 100644
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
index 57a1ee47af73..815bcb996ec4 100644
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


