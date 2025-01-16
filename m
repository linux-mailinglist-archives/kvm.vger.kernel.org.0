Return-Path: <kvm+bounces-35657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53699A1392B
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63C3D1689CF
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 11:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98EB31DF265;
	Thu, 16 Jan 2025 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dE5CM/bn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523E51DE3DE;
	Thu, 16 Jan 2025 11:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737027256; cv=none; b=RTNNNY9yz5ZnA2So2bv0G/ToTsA0FEtZ/b2iJoMpQvSdP14kiuQ63hAtw4ALw4d/MLGNDPNaXr0VUVu8c0CU69TqbanKp2z8RgGLH5ak22A3YPgEGcu1RKVWR2Asl8uVOBS2cIkVHUPIJcj2kqnI/AJg50nQ5GZ3j92KjJtMvQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737027256; c=relaxed/simple;
	bh=4Ty7gcH3NBjR6fVP3+gO29w66PHsTmuI4fG3/afhrnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2LePZk3VdwIJgFIImW9hlaz+SNiYuHxGjPXGh/JbB5ShYv/dsYrgJvgxeqA/E4BjgNy4OcO9tLhbwDb9hJWDfr8INrSOLeQak6hzZGRhqhwlOI03vaCHglDxRXJIo589xvj1HyCvnjkmriOIpiGB/COBoeDES7GfvhWQKpID8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dE5CM/bn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GAgMKC029663;
	Thu, 16 Jan 2025 11:34:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zzu7flshM0aJEe20r
	X0iDGaQTg63rL1IkW8unnNJu0o=; b=dE5CM/bnTGAPuCotcvwLEg1JC4TjjHve0
	mMraHEqC+r17tbRgg1arvaavkT3h447olZ22APF3ba/lcDyitWS6d81646RahuBo
	as0ko0+QNF6KjgA+RNNQyOqxZWpSmW5zATlg17IzUyB5+N9bZAFFT90A/+EpXtiT
	CTtNhMsUq0NIIpO23Max0Z3kAGOJyKpsW2Rc64lDro5HHcjLzhVeilz7hPg4ovgr
	WcnX/KLbHlRJmYyXd/gGb9nszwrz20CbnzvYeTOMvB2OIf4tUu8BXgZgvm4XNRnp
	npTeHcc6LkLDfLjnxX9ybRYZKBUsjiLIxZq90W5QoYw2cdNOY5YRQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446q5htrew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:05 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GBRJKW027702;
	Thu, 16 Jan 2025 11:34:05 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446q5htreq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50G8xW8X004526;
	Thu, 16 Jan 2025 11:34:04 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4442yswrub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 11:34:04 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GBY0mM56492528
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 11:34:00 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB62520040;
	Thu, 16 Jan 2025 11:34:00 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DB5E2004E;
	Thu, 16 Jan 2025 11:34:00 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 11:34:00 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        schlameuss@linux.ibm.com, david@redhat.com, willy@infradead.org,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        seanjc@google.com, seiden@linux.ibm.com
Subject: [PATCH v2 15/15] KVM: s390: remove the last user of page->index
Date: Thu, 16 Jan 2025 12:33:55 +0100
Message-ID: <20250116113355.32184-16-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: vYqhUbpzIZ2XjYhGhlXR3Hhat13sHYLA
X-Proofpoint-GUID: As1OKN5GpdUuneRoDyCbTZMrfPforGHe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501160086

Shadow page tables use page->index to keep the g2 address of the guest
page table being shadowed.

Instead of keeping the information in page->index, split the address
and smear it over the 16-bit softbits areas of 4 PGSTEs.

This removes the last s390 user of page->index.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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
index 80674bbf0f7b..dd06dbecc0a0 100644
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


