Return-Path: <kvm+bounces-34819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32F86A06420
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DFDE3A5FF4
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D353E203711;
	Wed,  8 Jan 2025 18:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V7DajsgZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61A7202C33;
	Wed,  8 Jan 2025 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360107; cv=none; b=nohYY+QbKmzn/zc5T5P3eRYOqqPFUK+ysZVAElOp+I4H3/DQeg2cZUtKeaDg7dIsCsErFQeENo6MUvY9lZLEFlQbUI5h14WAldRj38yU52XUI/A+ME7YQmnHWbG/0nxIgJ/581DhSC+lT+CeqF3xR9gH+NB9ZJ+HA7xMi8+FLeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360107; c=relaxed/simple;
	bh=8uAxC+IWfha1zkQdmJMJlP1VgLr3LDSyWsCBtwzL05g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIpipny4jrYYC0OklF9VlvZvwgxcIfaLqDku0yVxHNGQiMJrzFFTNEwMACmCuh5LhmO/nnC5JLO7zoueA7TRm9So2iustET+rcAMIViwx6iSzIrQUPvIgSLApNnx9lhq+LGTTj9Z6nb5bAeqN6O6acDU/lQ1Na23CHU8twXyYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V7DajsgZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508F4cnI006976;
	Wed, 8 Jan 2025 18:15:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=o7bvtfdUJEgDCRkYi
	EvzayvhxCgVBQkPrJmj01CJSWQ=; b=V7DajsgZKNBXlF5ekBKLZaV7wJQ7xjOvd
	dMwjvnyk6m4NHlGIyiFWDxhET7/J4HbCd8QnRrbrVMQr9zaUN22PkyL9E6UD6Tbc
	8NdCX9/PqVrxdmPTSyRUK/edzhILInXnoEZe7c+B4Bb/08nUfkvQJLm7S/Zt65d3
	mYkzRqQDWccr9yuNbUqohfgYEn9NdAP26lQ7qFaExkeDy2Za/uD1MObhpIvUSBXJ
	2lZVeFhsCgVILFKaOlJXp4yoGcSCFKa9W5uddkcVX/UxAYFkcZ5SSJ5MYapAzQUi
	xIVMGoD/dGYwIvym+Gj/HSQpAO5m6diU6PPKeCk6rfN+kP3x5QAlg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441huputx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508HCb7e015809;
	Wed, 8 Jan 2025 18:14:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygtm106x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:14:58 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508IEtp557082184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:14:55 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5B972004D;
	Wed,  8 Jan 2025 18:14:54 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0C9D2004B;
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
Subject: [PATCH v1 13/13] KVM: s390: remove the last user of page->index
Date: Wed,  8 Jan 2025 19:14:51 +0100
Message-ID: <20250108181451.74383-14-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: jJvNZxWyCGTqoHQBYv-uYiFIxqHKzepp
X-Proofpoint-GUID: jJvNZxWyCGTqoHQBYv-uYiFIxqHKzepp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=984
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080148

Shadow page tables use page->index to keep the g2 address of the guest
page table being shadowed.

Instead of keeping the information in page->index, split the address
and smear it over the 16-bit softbits areas of 4 PGSTEs.

This removes the last s390 user of page->index.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h    |  1 +
 arch/s390/include/asm/pgtable.h | 15 +++++++++++++++
 arch/s390/kvm/gaccess.c         |  6 ++++--
 arch/s390/mm/gmap.c             | 22 ++++++++++++++++++++--
 4 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 5ebc65ac78cc..28c5bf097268 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -177,4 +177,5 @@ static inline int s390_uv_destroy_range_interruptible(struct mm_struct *mm, unsi
 {
 	return __s390_uv_destroy_range(mm, start, end, true);
 }
+
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 151488bb9ed7..948100a8fa7e 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -419,6 +419,7 @@ static inline int is_module_addr(void *addr)
 #define PGSTE_HC_BIT	0x0020000000000000UL
 #define PGSTE_GR_BIT	0x0004000000000000UL
 #define PGSTE_GC_BIT	0x0002000000000000UL
+#define PGSTE_ST2_MASK	0x0000ffff00000000UL
 #define PGSTE_UC_BIT	0x0000000000008000UL	/* user dirty (migration) */
 #define PGSTE_IN_BIT	0x0000000000004000UL	/* IPTE notify bit */
 #define PGSTE_VSIE_BIT	0x0000000000002000UL	/* ref'd in a shadow table */
@@ -2001,4 +2002,18 @@ extern void s390_reset_cmma(struct mm_struct *mm);
 #define pmd_pgtable(pmd) \
 	((pgtable_t)__va(pmd_val(pmd) & -sizeof(pte_t)*PTRS_PER_PTE))
 
+static inline unsigned long gmap_pgste_get_index(unsigned long *pgt)
+{
+	unsigned long *pgstes, res;
+
+	pgstes = pgt + _PAGE_ENTRIES;
+
+	res = (pgstes[0] & PGSTE_ST2_MASK) << 16;
+	res |= pgstes[1] & PGSTE_ST2_MASK;
+	res |= (pgstes[2] & PGSTE_ST2_MASK) >> 16;
+	res |= (pgstes[3] & PGSTE_ST2_MASK) >> 32;
+
+	return res;
+}
+
 #endif /* _S390_PAGE_H */
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 560b5677929b..3bf3a80942de 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1409,6 +1409,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 static int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned long *pgt,
 				  int *dat_protection, int *fake)
 {
+	unsigned long pt_index;
 	unsigned long *table;
 	struct page *page;
 	int rc;
@@ -1418,9 +1419,10 @@ static int gmap_shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned
 	if (table && !(*table & _SEGMENT_ENTRY_INVALID)) {
 		/* Shadow page tables are full pages (pte+pgste) */
 		page = pfn_to_page(*table >> PAGE_SHIFT);
-		*pgt = page->index & ~GMAP_SHADOW_FAKE_TABLE;
+		pt_index = gmap_pgste_get_index(page_to_virt(page));
+		*pgt = pt_index & ~GMAP_SHADOW_FAKE_TABLE;
 		*dat_protection = !!(*table & _SEGMENT_ENTRY_PROTECT);
-		*fake = !!(page->index & GMAP_SHADOW_FAKE_TABLE);
+		*fake = !!(pt_index & GMAP_SHADOW_FAKE_TABLE);
 		rc = 0;
 	} else  {
 		rc = -EAGAIN;
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 3276437725b8..d4f87ee67c7d 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1720,6 +1720,23 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 }
 EXPORT_SYMBOL_GPL(gmap_shadow_sgt);
 
+static void gmap_pgste_set_index(struct ptdesc *ptdesc, unsigned long pgt_addr)
+{
+	unsigned long *pgstes = page_to_virt(ptdesc_page(ptdesc));
+
+	pgstes += _PAGE_ENTRIES;
+
+	pgstes[0] &= ~PGSTE_ST2_MASK;
+	pgstes[1] &= ~PGSTE_ST2_MASK;
+	pgstes[2] &= ~PGSTE_ST2_MASK;
+	pgstes[3] &= ~PGSTE_ST2_MASK;
+
+	pgstes[0] |= (pgt_addr >> 16) & PGSTE_ST2_MASK;
+	pgstes[1] |= pgt_addr & PGSTE_ST2_MASK;
+	pgstes[2] |= (pgt_addr << 16) & PGSTE_ST2_MASK;
+	pgstes[3] |= (pgt_addr << 32) & PGSTE_ST2_MASK;
+}
+
 /**
  * gmap_shadow_pgt - instantiate a shadow page table
  * @sg: pointer to the shadow guest address space structure
@@ -1747,9 +1764,10 @@ int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
 	ptdesc = page_table_alloc_pgste(sg->mm);
 	if (!ptdesc)
 		return -ENOMEM;
-	ptdesc->pt_index = pgt & _SEGMENT_ENTRY_ORIGIN;
+	origin = pgt & _SEGMENT_ENTRY_ORIGIN;
 	if (fake)
-		ptdesc->pt_index |= GMAP_SHADOW_FAKE_TABLE;
+		origin |= GMAP_SHADOW_FAKE_TABLE;
+	gmap_pgste_set_index(ptdesc, origin);
 	s_pgt = page_to_phys(ptdesc_page(ptdesc));
 	/* Install shadow page table */
 	spin_lock(&sg->guest_table_lock);
-- 
2.47.1


