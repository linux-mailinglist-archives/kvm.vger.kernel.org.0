Return-Path: <kvm+bounces-35862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE9FDA157EB
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 20:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D73E188B726
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A611DD0DC;
	Fri, 17 Jan 2025 19:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JKwAh2Pq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FC91AC891;
	Fri, 17 Jan 2025 19:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140994; cv=none; b=KsvV4besW5e9u6+ELbpyKiCy6whsruKC+k3fXFwcLN/GXeNk7bhjSnJJXJ5HkSSFmXd+QD4eoB5ZcoLkK0nyhSJi84xBsbcBt31IMTcbJt4w3D+xJ2yXBfNvrqmR4LIYSQWYSXXdAaJAv3xcoFoKp6BXFu/Km8alU2HTJaUAUsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140994; c=relaxed/simple;
	bh=M1+2Gdr6ZfIHk7HL4Ms8+Bn7JrH//G9mXMn7bmEgCb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnQTrYzNZRrR3dyE7SvJtt8AIIVcjKUfi9jbMha1h97RAs28NBVMPMcFL75G1KWT4tViHRvM4jt0Prh6sz1OaOdMSKQ1YqFPLw+XP/1RLHQR3W9F1TogPzRWNvejeLdRGqI/duG+wj4JLtiH5/UqYvHhhIWDIHeSrUS1xoeKDg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JKwAh2Pq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HE6H9F021079;
	Fri, 17 Jan 2025 19:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PANzgD+7+9K9R9hwI
	gHbnoTibClpGRmCkQuwfoE5VNQ=; b=JKwAh2Pq5r+RuQPgNQHF/k8KKJ6hGNZnk
	V8ZVoHJMbs8fBsbbxAj7vzeUTVbWG2ACgTDiH/u6249HTAsXRwckdeLZfUjEsIXA
	CUWmKqBHDZtrUi33+0eTvHK3K1UeaWTSxVvQD/iJgxg7Wya5mhBq5TQ1/LjbnPnc
	lj+G6HSkq8CLo5QbNDiey/xIKE8HnGWBv9A8Y9yEY7ebjYN8t46V8/swb7d8b7ap
	6puaafp7Z/x/AUQiLfx5y4nzUstvDaZmhLHzuVUgVSdKRARp3jex9sFYJGxSRvGJ
	6a+5dYdj7A2E4kgT4rh84LgSJYCdA7kQBRYaW8XvoeqR8oshaN8Aw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447rp59fkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:47 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50HItRKs004907;
	Fri, 17 Jan 2025 19:09:47 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 447rp59fkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50HIXXYC017359;
	Fri, 17 Jan 2025 19:09:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4444fkma8p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jan 2025 19:09:46 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50HJ9hRk65536318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 19:09:43 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E892820040;
	Fri, 17 Jan 2025 19:09:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4E3C20043;
	Fri, 17 Jan 2025 19:09:42 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Jan 2025 19:09:42 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v3 15/15] KVM: s390: remove the last user of page->index
Date: Fri, 17 Jan 2025 20:09:38 +0100
Message-ID: <20250117190938.93793-16-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: yl0OkPrl59Fb6XDkz57mKBAYSlQEQNaP
X-Proofpoint-ORIG-GUID: CaBMUrGmtRBE9MOIql-lrgL9RL0UOfug
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501170149

Shadow page tables use page->index to keep the g2 address of the guest
page table being shadowed.

Instead of keeping the information in page->index, split the address
and smear it over the 16-bit softbits areas of 4 PGSTEs.

This removes the last s390 user of page->index.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 15 +++++++++++++++
 arch/s390/kvm/gaccess.c         |  6 ++++--
 arch/s390/mm/gmap.c             | 22 ++++++++++++++++++++--
 3 files changed, 39 insertions(+), 4 deletions(-)

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
index 38f044321704..d678b3fa331d 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1733,6 +1733,23 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
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
@@ -1760,9 +1777,10 @@ int gmap_shadow_pgt(struct gmap *sg, unsigned long saddr, unsigned long pgt,
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
2.48.1


