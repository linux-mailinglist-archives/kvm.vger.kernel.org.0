Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE52F47D7
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 10:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbhAMJmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 04:42:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727398AbhAMJm1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 04:42:27 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10D9Xa0Q135311;
        Wed, 13 Jan 2021 04:41:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Ao8nVR9oGbWjpWhpl+WELlhVaSBXRHDEfqo58IshcAQ=;
 b=IaEXcqWYhCeSwgdQ+lt59lNYkN0wXcmFgYRkuPNn8kYy32zRm4V8HZPDvthOGISA57ol
 k71CLkFheBMMAN/IIshQ5vPBWsANykXOpxdt1S8j7Z0f5lLms+9Y1J+PLaj9+/EEj5S1
 cprX9wjF+nHM0v1h+G1/TLa9idYnDXoBatIBdjjDD5orD82gdCqjEI8Non/uNZwrpIh8
 h+emX0ffetUm2ZldkcdAvWJv1tgW96nhIltCijBI8Kvn3e/oqULWAPp6Uua06Tn9Ls8q
 huCtbr+cBwpHUrLXq3sGLLCn2mEcGRUUJN3Uda3+MN0kZ28esktIUKXm7pRaB6ZgefyN zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361uq2vjar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:44 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10D9Y8MM138191;
        Wed, 13 Jan 2021 04:41:44 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361uq2vj9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 04:41:43 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10D9SLhv001193;
        Wed, 13 Jan 2021 09:41:41 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448cuys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 09:41:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10D9fceh48365936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 09:41:38 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FE5AA4053;
        Wed, 13 Jan 2021 09:41:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3852A4059;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 09:41:37 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [PATCH 11/14] s390/mm: Add gmap shadowing for large pmds
Date:   Wed, 13 Jan 2021 09:41:10 +0000
Message-Id: <20210113094113.133668-12-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113094113.133668-1-frankja@linux.ibm.com>
References: <20210113094113.133668-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_03:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Up to now we could only shadow large pmds when the parent's mapping
was done with normal sized pmds. This is done by introducing fake page
tables and effectively running the level 3 guest with a standard
memory backing instead of the large one.

With this patch we add shadowing when the host is large page
backed. This allows us to run normal and large backed VMs inside a
large backed host.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |   9 +-
 arch/s390/kvm/gaccess.c      |  52 +++++-
 arch/s390/mm/gmap.c          | 328 ++++++++++++++++++++++++++++-------
 3 files changed, 317 insertions(+), 72 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index a5711c189018..4133d09597a5 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -19,11 +19,12 @@
 /* Status bits only for huge segment entries */
 #define _SEGMENT_ENTRY_GMAP_IN		0x8000	/* invalidation notify bit */
 #define _SEGMENT_ENTRY_GMAP_UC		0x4000	/* dirty (migration) */
+#define _SEGMENT_ENTRY_GMAP_VSIE	0x2000	/* vsie bit */
 /* Status bits in the gmap segment entry. */
 #define _SEGMENT_ENTRY_GMAP_SPLIT	0x0001  /* split huge pmd */
 
 #define GMAP_SEGMENT_STATUS_BITS (_SEGMENT_ENTRY_GMAP_UC | _SEGMENT_ENTRY_GMAP_SPLIT)
-#define GMAP_SEGMENT_NOTIFY_BITS _SEGMENT_ENTRY_GMAP_IN
+#define GMAP_SEGMENT_NOTIFY_BITS (_SEGMENT_ENTRY_GMAP_IN | _SEGMENT_ENTRY_GMAP_VSIE)
 
 /**
  * struct gmap_struct - guest address space
@@ -152,9 +153,11 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 		    int fake);
 int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 		    int fake);
-int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr,
-			   unsigned long *pgt, int *dat_protection, int *fake);
+int gmap_shadow_sgt_lookup(struct gmap *sg, unsigned long saddr,
+			   unsigned long *pgt, int *dat_protection,
+			   int *fake, int *lvl);
 int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte);
+int gmap_shadow_segment(struct gmap *sg, unsigned long saddr, pmd_t pmd);
 
 void gmap_register_pte_notifier(struct gmap_notifier *);
 void gmap_unregister_pte_notifier(struct gmap_notifier *);
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 6d6b57059493..d5f6b5c2c8de 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -981,7 +981,7 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra)
  */
 static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 				  unsigned long *pgt, int *dat_protection,
-				  int *fake)
+				  int *fake, int *lvl)
 {
 	struct gmap *parent;
 	union asce asce;
@@ -1133,14 +1133,25 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 		if (ste.cs && asce.p)
 			return PGM_TRANSLATION_SPEC;
 		*dat_protection |= ste.fc0.p;
+
+		/* Guest is huge page mapped */
 		if (ste.fc && sg->edat_level >= 1) {
-			*fake = 1;
-			ptr = ste.fc1.sfaa * _SEGMENT_SIZE;
-			ste.val = ptr;
-			goto shadow_pgt;
+			/* 4k to 1m, we absolutely need fake shadow tables. */
+			if (!parent->mm->context.allow_gmap_hpage_1m) {
+				*fake = 1;
+				ptr = ste.fc1.sfaa * _SEGMENT_SIZE;
+				ste.val = ptr;
+				goto shadow_pgt;
+			} else {
+				*lvl = 1;
+				*pgt = ptr;
+				return 0;
+
+			}
 		}
 		ptr = ste.fc0.pto * (PAGE_SIZE / 2);
 shadow_pgt:
+		*lvl = 0;
 		ste.fc0.p |= *dat_protection;
 		rc = gmap_shadow_pgt(sg, saddr, ste.val, *fake);
 		if (rc)
@@ -1169,8 +1180,9 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 {
 	union vaddress vaddr;
 	union page_table_entry pte;
+	union segment_table_entry ste;
 	unsigned long pgt;
-	int dat_protection, fake;
+	int dat_protection, fake, lvl = 0;
 	int rc;
 
 	mmap_read_lock(sg->mm);
@@ -1181,12 +1193,35 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	 */
 	ipte_lock(vcpu);
 
-	rc = gmap_shadow_pgt_lookup(sg, saddr, &pgt, &dat_protection, &fake);
+	rc = gmap_shadow_sgt_lookup(sg, saddr, &pgt, &dat_protection, &fake, &lvl);
 	if (rc)
 		rc = kvm_s390_shadow_tables(sg, saddr, &pgt, &dat_protection,
-					    &fake);
+					    &fake, &lvl);
 
 	vaddr.addr = saddr;
+
+	/* Shadow stopped at segment level, we map pmd to pmd */
+	if (!rc && lvl) {
+		rc = gmap_read_table(sg->parent, pgt + vaddr.sx * 8, &ste.val);
+		if (!rc && ste.i)
+			rc = PGM_PAGE_TRANSLATION;
+		ste.fc1.p |= dat_protection;
+		if (!rc)
+			rc = gmap_shadow_segment(sg, saddr, __pmd(ste.val));
+		if (rc == -EISDIR) {
+			/* Hit a split pmd, we need to setup a fake page table */
+			fake = 1;
+			pgt = ste.fc1.sfaa * _SEGMENT_SIZE;
+			ste.val = pgt;
+			rc = gmap_shadow_pgt(sg, saddr, ste.val, fake);
+			if (rc)
+				goto out;
+		} else {
+			/* We're done */
+			goto out;
+		}
+	}
+
 	if (fake) {
 		pte.val = pgt + vaddr.px * PAGE_SIZE;
 		goto shadow_page;
@@ -1201,6 +1236,7 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
 	pte.p |= dat_protection;
 	if (!rc)
 		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
+out:
 	ipte_unlock(vcpu);
 	mmap_read_unlock(sg->mm);
 	return rc;
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index f20aa49c2791..50dd95946d32 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -883,28 +883,6 @@ static inline unsigned long *gmap_table_walk(struct gmap *gmap,
 	return table;
 }
 
-/**
- * gmap_pte_op_walk - walk the gmap page table, get the page table lock
- *		      and return the pte pointer
- * @gmap: pointer to guest mapping meta data structure
- * @gaddr: virtual address in the guest address space
- * @ptl: pointer to the spinlock pointer
- *
- * Returns a pointer to the locked pte for a guest address, or NULL
- */
-static pte_t *gmap_pte_op_walk(struct gmap *gmap, unsigned long gaddr,
-			       spinlock_t **ptl)
-{
-	unsigned long *table;
-
-	BUG_ON(gmap_is_shadow(gmap));
-	/* Walk the gmap page table, lock and get pte pointer */
-	table = gmap_table_walk(gmap, gaddr, 1); /* get segment pointer */
-	if (!table || *table & _SEGMENT_ENTRY_INVALID)
-		return NULL;
-	return pte_alloc_map_lock(gmap->mm, (pmd_t *) table, gaddr, ptl);
-}
-
 /**
  * gmap_fixup - force memory in and connect the gmap table entry
  * @gmap: pointer to guest mapping meta data structure
@@ -1468,6 +1446,7 @@ static int gmap_protect_rmap(struct gmap *sg, unsigned long raddr,
 }
 
 #define _SHADOW_RMAP_MASK	0x7
+#define _SHADOW_RMAP_SEGMENT_LP	0x6
 #define _SHADOW_RMAP_REGION1	0x5
 #define _SHADOW_RMAP_REGION2	0x4
 #define _SHADOW_RMAP_REGION3	0x3
@@ -1573,15 +1552,18 @@ static void __gmap_unshadow_sgt(struct gmap *sg, unsigned long raddr,
 
 	BUG_ON(!gmap_is_shadow(sg));
 	for (i = 0; i < _CRST_ENTRIES; i++, raddr += _SEGMENT_SIZE) {
-		if (!(sgt[i] & _SEGMENT_ENTRY_ORIGIN))
+		if (sgt[i] ==  _SEGMENT_ENTRY_EMPTY)
 			continue;
-		pgt = (unsigned long *)(sgt[i] & _REGION_ENTRY_ORIGIN);
+
+		if (!(sgt[i] & _SEGMENT_ENTRY_LARGE)) {
+			pgt = (unsigned long *)(sgt[i] & _SEGMENT_ENTRY_ORIGIN);
+			__gmap_unshadow_pgt(sg, raddr, pgt);
+			/* Free page table */
+			page = pfn_to_page(__pa(pgt) >> PAGE_SHIFT);
+			list_del(&page->lru);
+			page_table_free_pgste(page);
+		}
 		sgt[i] = _SEGMENT_ENTRY_EMPTY;
-		__gmap_unshadow_pgt(sg, raddr, pgt);
-		/* Free page table */
-		page = pfn_to_page(__pa(pgt) >> PAGE_SHIFT);
-		list_del(&page->lru);
-		page_table_free_pgste(page);
 	}
 }
 
@@ -2188,7 +2170,7 @@ EXPORT_SYMBOL_GPL(gmap_shadow_sgt);
 /**
  * gmap_shadow_lookup_pgtable - find a shadow page table
  * @sg: pointer to the shadow guest address space structure
- * @saddr: the address in the shadow aguest address space
+ * @saddr: the address in the shadow guest address space
  * @pgt: parent gmap address of the page table to get shadowed
  * @dat_protection: if the pgtable is marked as protected by dat
  * @fake: pgt references contiguous guest memory block, not a pgtable
@@ -2198,32 +2180,64 @@ EXPORT_SYMBOL_GPL(gmap_shadow_sgt);
  *
  * Called with sg->mm->mmap_lock in read.
  */
-int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr,
-			   unsigned long *pgt, int *dat_protection,
-			   int *fake)
+void gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long *sge,
+			    unsigned long saddr, unsigned long *pgt,
+			    int *dat_protection, int *fake)
 {
-	unsigned long *table;
 	struct page *page;
-	int rc;
+
+	/* Shadow page tables are full pages (pte+pgste) */
+	page = pfn_to_page(*sge >> PAGE_SHIFT);
+	*pgt = page->index & ~GMAP_SHADOW_FAKE_TABLE;
+	*dat_protection = !!(*sge & _SEGMENT_ENTRY_PROTECT);
+	*fake = !!(page->index & GMAP_SHADOW_FAKE_TABLE);
+}
+EXPORT_SYMBOL_GPL(gmap_shadow_pgt_lookup);
+
+int gmap_shadow_sgt_lookup(struct gmap *sg, unsigned long saddr,
+			   unsigned long *pgt, int *dat_protection,
+			   int *fake, int *lvl)
+{
+	unsigned long *sge, *r3e = NULL;
+	struct page *page;
+	int rc = -EAGAIN;
 
 	BUG_ON(!gmap_is_shadow(sg));
 	spin_lock(&sg->guest_table_lock);
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
+	if (sg->asce & _ASCE_TYPE_MASK) {
+		/* >2 GB guest */
+		r3e = (unsigned long *) gmap_table_walk(sg, saddr, 2);
+		if (!r3e || (*r3e & _REGION_ENTRY_INVALID))
+			goto out;
+		sge = (unsigned long *)(*r3e & _REGION_ENTRY_ORIGIN) + ((saddr & _SEGMENT_INDEX) >> _SEGMENT_SHIFT);
+	} else {
+		sge = (unsigned long *)(sg->asce & PAGE_MASK) + ((saddr & _SEGMENT_INDEX) >> _SEGMENT_SHIFT);
 	}
+	if (*sge & _SEGMENT_ENTRY_INVALID)
+		goto out;
+	rc = 0;
+	if (*sge & _SEGMENT_ENTRY_LARGE) {
+		if (r3e) {
+			page = pfn_to_page(*r3e >> PAGE_SHIFT);
+			*pgt = page->index & ~GMAP_SHADOW_FAKE_TABLE;
+			*dat_protection = !!(*r3e & _SEGMENT_ENTRY_PROTECT);
+			*fake = !!(page->index & GMAP_SHADOW_FAKE_TABLE);
+		} else {
+			*pgt = sg->orig_asce & PAGE_MASK;
+			*dat_protection = 0;
+			*fake = 0;
+		}
+		*lvl = 1;
+	} else {
+		gmap_shadow_pgt_lookup(sg, sge, saddr, pgt,
+				       dat_protection, fake);
+		*lvl = 0;
+	}
+out:
 	spin_unlock(&sg->guest_table_lock);
 	return rc;
-
 }
-EXPORT_SYMBOL_GPL(gmap_shadow_pgt_lookup);
+EXPORT_SYMBOL_GPL(gmap_shadow_sgt_lookup);
 
 /**
  * gmap_shadow_pgt - instantiate a shadow page table
@@ -2305,6 +2319,95 @@ int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 }
 EXPORT_SYMBOL_GPL(gmap_shadow_pgt);
 
+int gmap_shadow_segment(struct gmap *sg, unsigned long saddr, pmd_t pmd)
+{
+	struct gmap *parent;
+	struct gmap_rmap *rmap;
+	unsigned long vmaddr, paddr;
+	spinlock_t *ptl = NULL;
+	pmd_t spmd, tpmd, *spmdp = NULL, *tpmdp;
+	int prot;
+	int rc;
+
+	BUG_ON(!gmap_is_shadow(sg));
+	parent = sg->parent;
+
+	prot = (pmd_val(pmd) & _SEGMENT_ENTRY_PROTECT) ? PROT_READ : PROT_WRITE;
+	rmap = kzalloc(sizeof(*rmap), GFP_KERNEL);
+	if (!rmap)
+		return -ENOMEM;
+	rmap->raddr = (saddr & HPAGE_MASK) | _SHADOW_RMAP_SEGMENT_LP;
+
+	while (1) {
+		paddr = pmd_val(pmd) & HPAGE_MASK;
+		vmaddr = __gmap_translate(parent, paddr);
+		if (IS_ERR_VALUE(vmaddr)) {
+			rc = vmaddr;
+			break;
+		}
+		rc = radix_tree_preload(GFP_KERNEL);
+		if (rc)
+			break;
+		rc = -EAGAIN;
+
+		/* Let's look up the parent's mapping */
+		spmdp = gmap_pmd_op_walk(parent, paddr, vmaddr, &ptl);
+		if (spmdp) {
+			if (gmap_pmd_is_split(spmdp)) {
+				gmap_pmd_op_end(ptl);
+				radix_tree_preload_end();
+				rc = -EISDIR;
+				break;
+			}
+			spin_lock(&sg->guest_table_lock);
+			/* Get shadow segment table pointer */
+			tpmdp = (pmd_t *) gmap_table_walk(sg, saddr, 1);
+			if (!tpmdp) {
+				spin_unlock(&sg->guest_table_lock);
+				gmap_pmd_op_end(ptl);
+				radix_tree_preload_end();
+				break;
+			}
+			/* Shadowing magic happens here. */
+			if (!(pmd_val(*tpmdp) & _SEGMENT_ENTRY_INVALID)) {
+				rc = 0;	/* already shadowed */
+				spin_unlock(&sg->guest_table_lock);
+				gmap_pmd_op_end(ptl);
+				radix_tree_preload_end();
+				kfree(rmap);
+				break;
+			}
+			spmd = *spmdp;
+			if (!(pmd_val(spmd) & _SEGMENT_ENTRY_INVALID) &&
+			    !((pmd_val(spmd) & _SEGMENT_ENTRY_PROTECT) &&
+			      !(pmd_val(pmd) & _SEGMENT_ENTRY_PROTECT))) {
+
+				pmd_val(*spmdp) |= _SEGMENT_ENTRY_GMAP_VSIE;
+
+				/* Insert shadow ste */
+				pmd_val(tpmd) = ((pmd_val(spmd) &
+						  _SEGMENT_ENTRY_HARDWARE_BITS_LARGE) |
+						 (pmd_val(pmd) & _SEGMENT_ENTRY_PROTECT));
+				*tpmdp = tpmd;
+				gmap_insert_rmap(sg, vmaddr, rmap);
+				rc = 0;
+			}
+			spin_unlock(&sg->guest_table_lock);
+			gmap_pmd_op_end(ptl);
+		}
+		radix_tree_preload_end();
+		if (!rc)
+			break;
+		rc = gmap_fixup(parent, paddr, vmaddr, prot);
+		if (rc)
+			break;
+	}
+	if (rc)
+		kfree(rmap);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(gmap_shadow_segment);
+
 /**
  * gmap_shadow_page - create a shadow page mapping
  * @sg: pointer to the shadow guest address space structure
@@ -2322,7 +2425,8 @@ int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte)
 	struct gmap *parent;
 	struct gmap_rmap *rmap;
 	unsigned long vmaddr, paddr;
-	spinlock_t *ptl;
+	spinlock_t *ptl_pmd = NULL, *ptl_pte = NULL;
+	pmd_t *spmdp;
 	pte_t *sptep, *tptep;
 	int prot;
 	int rc;
@@ -2347,26 +2451,46 @@ int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte)
 		if (rc)
 			break;
 		rc = -EAGAIN;
-		sptep = gmap_pte_op_walk(parent, paddr, &ptl);
-		if (sptep) {
-			spin_lock(&sg->guest_table_lock);
+		spmdp = gmap_pmd_op_walk(parent, paddr, vmaddr, &ptl_pmd);
+		if (spmdp && !(pmd_val(*spmdp) & _SEGMENT_ENTRY_INVALID)) {
 			/* Get page table pointer */
 			tptep = (pte_t *) gmap_table_walk(sg, saddr, 0);
 			if (!tptep) {
-				spin_unlock(&sg->guest_table_lock);
-				gmap_pte_op_end(ptl);
 				radix_tree_preload_end();
+				gmap_pmd_op_end(ptl_pmd);
 				break;
 			}
-			rc = ptep_shadow_pte(sg->mm, saddr, sptep, tptep, pte);
-			if (rc > 0) {
-				/* Success and a new mapping */
-				gmap_insert_rmap(sg, vmaddr, rmap);
-				rmap = NULL;
-				rc = 0;
+
+			if (pmd_large(*spmdp)) {
+				pte_t spte;
+				if (!(pmd_val(*spmdp) & _SEGMENT_ENTRY_PROTECT)) {
+					spin_lock(&sg->guest_table_lock);
+					spte = __pte((pmd_val(*spmdp) &
+						      _SEGMENT_ENTRY_ORIGIN_LARGE)
+						     + (pte_index(paddr) << 12));
+					ptep_shadow_set(spte, tptep, pte);
+					pmd_val(*spmdp) |= _SEGMENT_ENTRY_GMAP_VSIE;
+					gmap_insert_rmap(sg, vmaddr, rmap);
+					rmap = NULL;
+					rc = 0;
+					spin_unlock(&sg->guest_table_lock);
+				}
+			} else {
+				sptep = gmap_pte_from_pmd(parent, spmdp, paddr, &ptl_pte);
+				spin_lock(&sg->guest_table_lock);
+				if (sptep) {
+					rc = ptep_shadow_pte(sg->mm, saddr, sptep, tptep, pte);
+					if (rc > 0) {
+						/* Success and a new mapping */
+						gmap_insert_rmap(sg, vmaddr, rmap);
+						rmap = NULL;
+						rc = 0;
+					}
+					spin_unlock(&sg->guest_table_lock);
+					gmap_pte_op_end(ptl_pte);
+				}
 			}
-			gmap_pte_op_end(ptl);
-			spin_unlock(&sg->guest_table_lock);
+			gmap_pmd_op_end(ptl_pmd);
 		}
 		radix_tree_preload_end();
 		if (!rc)
@@ -2380,6 +2504,75 @@ int gmap_shadow_page(struct gmap *sg, unsigned long saddr, pte_t pte)
 }
 EXPORT_SYMBOL_GPL(gmap_shadow_page);
 
+/**
+ * gmap_unshadow_segment - remove a huge segment from a shadow segment table
+ * @sg: pointer to the shadow guest address space structure
+ * @raddr: rmap address in the shadow guest address space
+ *
+ * Called with the sg->guest_table_lock
+ */
+static void gmap_unshadow_segment(struct gmap *sg, unsigned long raddr)
+{
+	unsigned long *table;
+
+	BUG_ON(!gmap_is_shadow(sg));
+	/* We already have the lock */
+	table = gmap_table_walk(sg, raddr, 1); /* get segment table pointer */
+	if (!table || *table & _SEGMENT_ENTRY_INVALID ||
+	    !(*table & _SEGMENT_ENTRY_LARGE))
+		return;
+	gmap_call_notifier(sg, raddr, raddr + HPAGE_SIZE - 1);
+	gmap_idte_global(sg->asce, (pmd_t *)table, raddr);
+	*table = _SEGMENT_ENTRY_EMPTY;
+}
+
+static void gmap_shadow_notify_pmd(struct gmap *sg, unsigned long vmaddr,
+				   unsigned long gaddr)
+{
+	struct gmap_rmap *rmap, *rnext, *head;
+	unsigned long start, end, bits, raddr;
+
+
+	BUG_ON(!gmap_is_shadow(sg));
+
+	spin_lock(&sg->guest_table_lock);
+	if (sg->removed) {
+		spin_unlock(&sg->guest_table_lock);
+		return;
+	}
+	/* Check for top level table */
+	start = sg->orig_asce & _ASCE_ORIGIN;
+	end = start + ((sg->orig_asce & _ASCE_TABLE_LENGTH) + 1) * PAGE_SIZE;
+	if (!(sg->orig_asce & _ASCE_REAL_SPACE) && gaddr >= start &&
+	    gaddr < ((end & HPAGE_MASK) + HPAGE_SIZE - 1)) {
+		/* The complete shadow table has to go */
+		gmap_unshadow(sg);
+		spin_unlock(&sg->guest_table_lock);
+		list_del(&sg->list);
+		gmap_put(sg);
+		return;
+	}
+	/* Remove the page table tree from on specific entry */
+	head = radix_tree_delete(&sg->host_to_rmap, (vmaddr & HPAGE_MASK) >> PAGE_SHIFT);
+	gmap_for_each_rmap_safe(rmap, rnext, head) {
+		bits = rmap->raddr & _SHADOW_RMAP_MASK;
+		raddr = rmap->raddr ^ bits;
+		switch (bits) {
+		case _SHADOW_RMAP_SEGMENT_LP:
+			gmap_unshadow_segment(sg, raddr);
+			break;
+		case _SHADOW_RMAP_PGTABLE:
+			gmap_unshadow_page(sg, raddr);
+			break;
+		default:
+			BUG();
+		}
+		kfree(rmap);
+	}
+	spin_unlock(&sg->guest_table_lock);
+}
+
+
 /**
  * gmap_shadow_notify - handle notifications for shadow gmap
  *
@@ -2431,6 +2624,8 @@ static void gmap_shadow_notify(struct gmap *sg, unsigned long vmaddr,
 		case _SHADOW_RMAP_PGTABLE:
 			gmap_unshadow_page(sg, raddr);
 			break;
+		default:
+			BUG();
 		}
 		kfree(rmap);
 	}
@@ -2514,10 +2709,21 @@ static inline void pmdp_notify_split(struct gmap *gmap, pmd_t *pmdp,
 static void pmdp_notify_gmap(struct gmap *gmap, pmd_t *pmdp,
 			     unsigned long gaddr, unsigned long vmaddr)
 {
+	struct gmap *sg, *next;
+
 	BUG_ON((gaddr & ~HPAGE_MASK) || (vmaddr & ~HPAGE_MASK));
 	if (gmap_pmd_is_split(pmdp))
 		return pmdp_notify_split(gmap, pmdp, gaddr, vmaddr);
 
+	if (!list_empty(&gmap->children) &&
+	    (pmd_val(*pmdp) & _SEGMENT_ENTRY_GMAP_VSIE)) {
+		spin_lock(&gmap->shadow_lock);
+		list_for_each_entry_safe(sg, next, &gmap->children, list)
+			gmap_shadow_notify_pmd(sg, vmaddr, gaddr);
+		spin_unlock(&gmap->shadow_lock);
+	}
+	pmd_val(*pmdp) &= ~_SEGMENT_ENTRY_GMAP_VSIE;
+
 	if (!(pmd_val(*pmdp) & _SEGMENT_ENTRY_GMAP_IN))
 		return;
 	pmd_val(*pmdp) &= ~_SEGMENT_ENTRY_GMAP_IN;
-- 
2.27.0

