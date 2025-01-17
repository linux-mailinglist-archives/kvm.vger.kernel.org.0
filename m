Return-Path: <kvm+bounces-35866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 615E9A157F1
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:11:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60F293A90AD
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DAE1DE3C2;
	Fri, 17 Jan 2025 19:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gN9vZKC6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A451A840E;
	Fri, 17 Jan 2025 19:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737141000; cv=none; b=BWwgtQdOvh6eGw96yHG/QRLDujBl3OEfEc2rFomWTyTpwaQqpUjbiuNLBQajgN4QSvLdh5GCiWN8r20tk5pnkMOvCKDDLPvshwSy95b48Wf3TMjUce92vR6i5rmdRh8behDb16EIqTsd1GGdFenB9RQwLbfBKNxcpl1sm05xXCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737141000; c=relaxed/simple;
	bh=jePIztGT6lKYVGBNLojQFQaReB/TgbPnYtjQapJuGgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BflE2p2ymlqc9NNTrTyGQbUnB03SdUROryuXfH/T1pOm0L/U5CqBA9QvYS+nt9d9dDpub3bCYJgUe0+mLmLTxiATNhyPB0hjOBc2rsa054uuafDw3WLo8hPHi2k3vt4gtOv4gEMirz1iqMx6GWGfBCkJfbYSpH3cIVBoD2gIUXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gN9vZKC6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HCNbpl010206;
	Fri, 17 Jan 2025 19:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=vsd0AqYdGEAVwFCBQ
	J7d9iGVNhCwD/wXVC4+XXqQuUo=; b=gN9vZKC6ea1p63GR+qoeNsLz9W0PmJ431
	V9OD45hLnZjxAtrdbc7GdehgrjEuxFeT6PnvK68y025fUcy4uOPdIIauE1+2mhAX
	qj/Ab2TDgbTQfwYu1/zjW7BN336rgNwXL0EEtPaYlqHMm9R3pzWb8nwutHsc/caR
	Tib/BamZ3+f43T5IPQ5O2YyVBikLP4zqkPOhZUuJeTEHajIZx8x7nU/EJxyT1siQ
	/xxXRUiOYdryUF2JkJHLS2klp4rqvfBM4sj+8KHUKrP7WsQ6K7WWF6hKju5DeUhH
	nJjBbNMiQuLqKhydmwYM0yKXVJAt+4fgBeiRmHKhWjIVdzO7H/3vw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447c8jcrws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:47 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HJ9CaD016763;
	Fri, 17 Jan 2025 19:09:47 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447c8jcrwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIh11h007519;
	Fri, 17 Jan 2025 19:09:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443ynmbnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9gZZ19202420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30C1420040;
	Fri, 17 Jan 2025 19:09:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F13252004B;
	Fri, 17 Jan 2025 19:09:41 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 19:09:41 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v3 12/15] KVM: s390: move gmap_shadow_pgt_lookup() into kvm
Date: Fri, 17 Jan 2025 20:09:35 +0100
Message-ID: <20250117190938.93793-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250117190938.93793-1-imbrenda@linux.ibm.com>
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QPJnyXamTIMHJKbdQWldKX_mSJ7ZfRha
X-Proofpoint-ORIG-GUID: G5W3d549idXHcdm0fcExcDz5TXnzCanw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501170149

Move gmap_shadow_pgt_lookup() from mm/gmap.c into kvm/gaccess.c .

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  3 +--
 arch/s390/kvm/gaccess.c      | 40 +++++++++++++++++++++++++++++++
 arch/s390/kvm/gmap.h         |  2 ++
 arch/s390/mm/gmap.c          | 46 ++----------------------------------
 4 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 904d97f0bc5e..bc264c1469f3 100644
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
@@ -144,6 +142,7 @@ void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
 			    unsigned long end, bool interruptible);
 int kvm_s390_wiggle_split_folio(struct mm_struct *mm, struct folio *folio, bool split);
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


