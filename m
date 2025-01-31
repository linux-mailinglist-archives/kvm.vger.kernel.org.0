Return-Path: <kvm+bounces-36995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE38DA23D1F
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:30:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CE8E16AD5F
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3575C1F3D5C;
	Fri, 31 Jan 2025 11:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gCsXbv0P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A857B1C3BF1;
	Fri, 31 Jan 2025 11:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738322747; cv=none; b=puSWk6VlZ9zKkQhOfM3OpRVvzuVlkHgG48dTJ8sEbN8j/SkFom2GfsKf9EqUYuYq4qymCwdOK9WO/ZsIVAl8cxXgCOp2Rcc8wKGni/boaez/UIa88mtpQjgc32ORS5eez6ey4Doda7L0t/wMoo+NIkngoZSHPsN8MA0fxRXadHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738322747; c=relaxed/simple;
	bh=MBQEQaWeH7C1pqaTJr+k0+9U74+YzgaJuVRn7oyzWxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btVzj2c9/nz6DPgKklOs9oOgLAU8g5BQ+hVVGpbOBElvBoX/5Y7Z3HITjtxeS1ECRTpdWLXqJ0UFf+8wBJPjMaLmIYZODe0XCNpdvq6zyXspU7uSW52BltwlL7CIVOS9FMhnOL/Ai+uTezhmR0NFKe8YyTN7v/ev/ceOt1n9/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gCsXbv0P; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2PwRK019039;
	Fri, 31 Jan 2025 11:25:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/sR7YHFZRiFoe9C3x
	5uGZZjwTUE6gjAOs2HdX5td2t0=; b=gCsXbv0PNH0RjDt1hhMIQRnavpGTkSMIy
	F2pIJhPLlUTRGbFNeY1s0+HzQLcG8UANGfDLvub5bud/Qsu3x5k8v5ZyLboJ5/V4
	dAtHXg+Ek++c6lesLQxfrRRZ9FWbfAZN7kafv3q/gkXeApLOQDxU6pYV3IfHnMUu
	BsAyq10vfZvsRCoCgKF72DbEMxrTQFzTf8fho8MZ6I6VB2HDAQmf27MXIArwpwuO
	4j2bivmaj2pj7gxcwxoH7pXEWxYgD0Oq/+rl7b+/JidzJrcfz5NCbjVu+2E2/jC1
	ZnmJIQV8sIoS6ne9ZzEWmH3EYXw4YBLVgZxQJboKHlW/CnMRpv1/w==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gmk9247y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:43 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V88KOX024543;
	Fri, 31 Jan 2025 11:25:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gf9139st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:25:41 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBPbLL19530028
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:25:37 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6A5E20139;
	Fri, 31 Jan 2025 11:25:37 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 55FC32012D;
	Fri, 31 Jan 2025 11:25:37 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.171.25.38])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:25:37 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v2 19/20] KVM: s390: remove the last user of page->index
Date: Fri, 31 Jan 2025 12:25:09 +0100
Message-ID: <20250131112510.48531-20-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: FBp3l_V7BiGU4VS_CYwEMEUi02Pixg3k
X-Proofpoint-ORIG-GUID: FBp3l_V7BiGU4VS_CYwEMEUi02Pixg3k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 bulkscore=0 clxscore=1015
 adultscore=0 spamscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2501310083

Shadow page tables use page->index to keep the g2 address of the guest
page table being shadowed.

Instead of keeping the information in page->index, split the address
and smear it over the 16-bit softbits areas of 4 PGSTEs.

This removes the last s390 user of page->index.

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20250123144627.312456-16-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20250123144627.312456-16-imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 15 +++++++++++++++
 arch/s390/kvm/gaccess.c         |  6 ++++--
 arch/s390/mm/gmap.c             | 22 ++++++++++++++++++++--
 3 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index a96bde2e5f18..3ca5af4cfe43 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -420,6 +420,7 @@ void setup_protection_map(void);
 #define PGSTE_HC_BIT	0x0020000000000000UL
 #define PGSTE_GR_BIT	0x0004000000000000UL
 #define PGSTE_GC_BIT	0x0002000000000000UL
+#define PGSTE_ST2_MASK	0x0000ffff00000000UL
 #define PGSTE_UC_BIT	0x0000000000008000UL	/* user dirty (migration) */
 #define PGSTE_IN_BIT	0x0000000000004000UL	/* IPTE notify bit */
 #define PGSTE_VSIE_BIT	0x0000000000002000UL	/* ref'd in a shadow table */
@@ -2007,4 +2008,18 @@ extern void s390_reset_cmma(struct mm_struct *mm);
 #define pmd_pgtable(pmd) \
 	((pgtable_t)__va(pmd_val(pmd) & -sizeof(pte_t)*PTRS_PER_PTE))
 
+static inline unsigned long gmap_pgste_get_pgt_addr(unsigned long *pgt)
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
index bb1340389369..f6fded15633a 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -1409,6 +1409,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 static int shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned long *pgt,
 			     int *dat_protection, int *fake)
 {
+	unsigned long pt_index;
 	unsigned long *table;
 	struct page *page;
 	int rc;
@@ -1418,9 +1419,10 @@ static int shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned long
 	if (table && !(*table & _SEGMENT_ENTRY_INVALID)) {
 		/* Shadow page tables are full pages (pte+pgste) */
 		page = pfn_to_page(*table >> PAGE_SHIFT);
-		*pgt = page->index & ~GMAP_SHADOW_FAKE_TABLE;
+		pt_index = gmap_pgste_get_pgt_addr(page_to_virt(page));
+		*pgt = pt_index & ~GMAP_SHADOW_FAKE_TABLE;
 		*dat_protection = !!(*table & _SEGMENT_ENTRY_PROTECT);
-		*fake = !!(page->index & GMAP_SHADOW_FAKE_TABLE);
+		*fake = !!(pt_index & GMAP_SHADOW_FAKE_TABLE);
 		rc = 0;
 	} else  {
 		rc = -EAGAIN;
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 38f044321704..94d927785800 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1733,6 +1733,23 @@ int gmap_shadow_sgt(struct gmap *sg, unsigned long saddr, unsigned long sgt,
 }
 EXPORT_SYMBOL_GPL(gmap_shadow_sgt);
 
+static void gmap_pgste_set_pgt_addr(struct ptdesc *ptdesc, unsigned long pgt_addr)
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
+	gmap_pgste_set_pgt_addr(ptdesc, origin);
 	s_pgt = page_to_phys(ptdesc_page(ptdesc));
 	/* Install shadow page table */
 	spin_lock(&sg->guest_table_lock);
-- 
2.48.1


