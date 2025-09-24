Return-Path: <kvm+bounces-58631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F9BBB99CC9
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:17:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DAD87B2F8F
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 12:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A53830146E;
	Wed, 24 Sep 2025 12:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="imYnMDBn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E7D1B0439;
	Wed, 24 Sep 2025 12:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758716250; cv=none; b=hSyBpaxgOUBgfXQcUbdD/912ZhEnJOoZ/YkPSxHG4Lx1AC7kQr89NDeSpVkXJ/2oEnD+ZiNgC8VOiaNu/+BjU2Okm2m7fUl1SxkKjXup9UZ1sK87IpGmpr659tbpZ7f2q1t2bOlT1I7bM4fXPprJmS1YkkjEY6H2I7TZw2dK1tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758716250; c=relaxed/simple;
	bh=E8DaNOnNByueymcIX4XwX9mzwNxM7zLUbGKvimvTKzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dHnJFohEHX5c0oJqZ6cHkD2cOqcsi9lVhfEILmw9Y7zNAf1PSIBXlnn9c1bGQdoqVq85BRbXV6RA+/yOrw4MjfXo7zJvn8FOH2Ov98lH7cbfhgPt61ByE/YG7Ic5hSTV9E/Fhpr14zmebTNLOsFn+U+QtpeGIua2TrpJufQi/1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=imYnMDBn; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58O7bo8h019974;
	Wed, 24 Sep 2025 12:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=hK20oKkFCEzt2yPCutuTkv1OfguvnS7u+T3TWgw3M
	hs=; b=imYnMDBnUmFD+7WReyT3sr4YtjaJv/KaVtvRv7f09GwVc0++ryOZ90tc7
	WIkCal1+Ck56tOvl7PJu4IyZRtpPICOfM25iUYwtF9LWpPo0RwNCRI+C5QlGjOkq
	OQoryfZCjmI/+BXxhU7YX5JlulIIJTy8BdugLyjKZzI0LN3yBGmAmThBB7fnFqZ1
	VPbAvc7frSoj+p9cQs2njxVI3T0hh2kT5q59v2hTM2P8b/6sTWIb3Hh8sgM13GuB
	u/DJ/djP/4ks9qCxDubZZ3+e0d8XOm+40x3Ip2lT9nJP1toptp4Hf5GWQmCj8lLK
	+v1YlXunMbXhvMzTatY97Y7ZnfJ7A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499kwyphx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 12:17:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58O8xl9c008311;
	Wed, 24 Sep 2025 12:17:11 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49a6yy0mxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 12:17:11 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OCHAkA22479572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 12:17:10 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E12A5805A;
	Wed, 24 Sep 2025 12:17:10 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C61058054;
	Wed, 24 Sep 2025 12:17:08 +0000 (GMT)
Received: from m83lp56.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 12:17:08 +0000 (GMT)
From: Gautam Gala <ggala@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] KVM: s390: Fix to clear PTE when discarding a swapped page
Date: Wed, 24 Sep 2025 14:17:07 +0200
Message-ID: <20250924121707.145350-1-ggala@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=J5Cq7BnS c=1 sm=1 tr=0 ts=68d3e155 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=o9l_a8J5pJTIQegNmNkA:9
X-Proofpoint-GUID: cWWmgJ-XRJZBqeraonXQDg19S5aX1EiP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNSBTYWx0ZWRfX3D7sX6EBfj4J
 uCZ5uCSApr1wJ0+Nibfu9puEpSIu+kDUJogqhBqioLcEhu0CukerXBgFpY27aDBKRgw9wf562At
 iyX94mnEYzIVJmC8YfZPWXDThflnFyNQ1b3zpltl8VXZCysMB79GblmsMeDtZnp5QVYJBjadBkx
 RlEXGMExs+L0SXvVwKJWul75VfwznPLxZ+NsWCkN1K6XDrMgqca9XsTK75BNkCMkaDwAWxb6nTs
 Qs/dGjYu2JOdukwYJstJ+c9a6hYw/SPNhEvVsxrrfgvzP1rlhlydN910Qd7iEuirjAvAx268N2t
 NOInT7J6YrL5gaGjZF/Jjt9feXGJl7kzRpIueFos1GabnxhFSXUeidKRy89/0g6ngo65W3ITsw5
 NLEz3v+h
X-Proofpoint-ORIG-GUID: cWWmgJ-XRJZBqeraonXQDg19S5aX1EiP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_03,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1011 adultscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200015

KVM run fails when guests with 'cmm' cpu feature and host are
under memory pressure and use swap heavily. This is because
npages becomes ENOMEN (out of memory) in hva_to_pfn_slow()
which inturn propagates as EFAULT to qemu. Clearing the page
table entry when discarding an address that maps to a swap
entry resolves the issue.

Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Gautam Gala <ggala@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 22 ++++++++++++++++++++++
 arch/s390/mm/gmap_helpers.c     | 12 +++++++++++-
 arch/s390/mm/pgtable.c          | 23 +----------------------
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index c1a7a92f0575..b7100c6a4054 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -2055,4 +2055,26 @@ static inline unsigned long gmap_pgste_get_pgt_addr(unsigned long *pgt)
 	return res;
 }
 
+static inline pgste_t pgste_get_lock(pte_t *ptep)
+{
+	unsigned long value = 0;
+#ifdef CONFIG_PGSTE
+	unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
+
+	do {
+		value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
+	} while (value & PGSTE_PCL_BIT);
+	value |= PGSTE_PCL_BIT;
+#endif
+	return __pgste(value);
+}
+
+static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
+{
+#ifdef CONFIG_PGSTE
+	barrier();
+	WRITE_ONCE(*(unsigned long *)(ptep + PTRS_PER_PTE), pgste_val(pgste) & ~PGSTE_PCL_BIT);
+#endif
+}
+
 #endif /* _S390_PAGE_H */
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index b63f427e7289..d4c3c36855e2 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -15,6 +15,7 @@
 #include <linux/pagewalk.h>
 #include <linux/ksm.h>
 #include <asm/gmap_helpers.h>
+#include <asm/pgtable.h>
 
 /**
  * ptep_zap_swap_entry() - discard a swap entry.
@@ -47,6 +48,7 @@ void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
 {
 	struct vm_area_struct *vma;
 	spinlock_t *ptl;
+	pgste_t pgste;
 	pte_t *ptep;
 
 	mmap_assert_locked(mm);
@@ -60,8 +62,16 @@ void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
 	ptep = get_locked_pte(mm, vmaddr, &ptl);
 	if (unlikely(!ptep))
 		return;
-	if (pte_swap(*ptep))
+	if (pte_swap(*ptep)) {
+		preempt_disable();
+		pgste = pgste_get_lock(ptep);
+
 		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
+		pte_clear(mm, vmaddr, ptep);
+
+		pgste_set_unlock(ptep, pgste);
+		preempt_enable();
+	}
 	pte_unmap_unlock(ptep, ptl);
 }
 EXPORT_SYMBOL_GPL(gmap_helper_zap_one_page);
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 60688be4e876..879f39366e6c 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -24,6 +24,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/page-states.h>
+#include <asm/pgtable.h>
 #include <asm/machine.h>
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
@@ -115,28 +116,6 @@ static inline pte_t ptep_flush_lazy(struct mm_struct *mm,
 	return old;
 }
 
-static inline pgste_t pgste_get_lock(pte_t *ptep)
-{
-	unsigned long value = 0;
-#ifdef CONFIG_PGSTE
-	unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
-
-	do {
-		value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
-	} while (value & PGSTE_PCL_BIT);
-	value |= PGSTE_PCL_BIT;
-#endif
-	return __pgste(value);
-}
-
-static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
-{
-#ifdef CONFIG_PGSTE
-	barrier();
-	WRITE_ONCE(*(unsigned long *)(ptep + PTRS_PER_PTE), pgste_val(pgste) & ~PGSTE_PCL_BIT);
-#endif
-}
-
 static inline pgste_t pgste_get(pte_t *ptep)
 {
 	unsigned long pgste = 0;
-- 
2.51.0


