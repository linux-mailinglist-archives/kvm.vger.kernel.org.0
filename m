Return-Path: <kvm+bounces-59180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD65BBAE0E7
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43BDD19442B8
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 16:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D422512D7;
	Tue, 30 Sep 2025 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fE4kFnb/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D8434BA28;
	Tue, 30 Sep 2025 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759250040; cv=none; b=u7sMYYZXgt/D+AJ/OaS9fpRrINMLmqp5SCHj7wrKj2+jejJONiLBrzf4Xbj1ztbdGtzVdMqHgtzLSu5bnzPgCRxkQqZpc7Mm3oyqrLW94bsd6TB3Rhocp4vLhk3G2gtMxBrB/53yMuqwvlrGhRIadl3FKdG8ZifjXXrYX5gx09Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759250040; c=relaxed/simple;
	bh=AEPMdml46ULUtTOKqF5X8r3wP3pKhY5Ejtc1s+85IJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTQHu4gdi77KeskWuQr/ZXsmmg8Gz/s9hSDxhfXKJ2tMtRxh9W/pqCFG4+5O/Tn7CmqLSQ/z4L29lPVZlY/dGowtk917OvaniIdYODha9kKl8J+VOZs9PAGpQjev7uD9/zV+JV9OOqkp87/dJ0HEH4yWVcdL0N5qkxDVnQ7br/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fE4kFnb/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U9Sn3F026191;
	Tue, 30 Sep 2025 16:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jR3v6SSaULZd3rObz
	M7pdTAJnQxNk3urHNrPSmK9tys=; b=fE4kFnb/83jg8QteEcWEJZh8iueGKxdCk
	5/zusVGaRp+yB20X9Yf0FtHHyN9vGLNYPZjyCfBGat8Kaq+Op6CR7ilCCrIiIyiR
	e+YYK4RttEpwaKto40w1MOQDole/6IrUYJTK94qgRwC7NIlqTPv7OaNt5KM9Abeq
	9MaIAydDnNrjhQyB9jkcXYAv/S9fzFPt3UBqEhbsSo5bGV1sSE5rlwM8Ge7lHUXc
	wTBOXp1zNYG9+Xj0uIFk35bvkVmyUlGSTQ4RwouroHRPMNo8BLDuBy/MMSeI2Whu
	RbM8VFd1wsSrVUyDAhZ12FarkHlruCUX09SmEIzd3Kjdnyvu0wo0w==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e6bhhw7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 16:33:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58UGXhPq026752;
	Tue, 30 Sep 2025 16:33:55 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49eu8mvctg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Sep 2025 16:33:54 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58UGXo4A49414462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 16:33:51 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DECDC2004B;
	Tue, 30 Sep 2025 16:33:50 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C100B20043;
	Tue, 30 Sep 2025 16:33:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Sep 2025 16:33:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 2/2] KVM: s390: Fix to clear PTE when discarding a swapped page
Date: Tue, 30 Sep 2025 18:33:50 +0200
Message-ID: <20250930163350.83377-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930163350.83377-1-imbrenda@linux.ibm.com>
References: <20250930163350.83377-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Se/6t/Ru c=1 sm=1 tr=0 ts=68dc0673 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=o9l_a8J5pJTIQegNmNkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAxMCBTYWx0ZWRfXziRO5KWpw7Yu
 2dhD3Vzk0drr4UdN81PwJDVWwOGGmcoStzEATpao/Pspg5GBC5aC19OGDl0lCOa1sEDzg0VeCJO
 Ml3WYYK5SoyTZAUy3MtMXYRj2HU9HXB6/FoCWqFBgfp3VGjdU0Rhgzwij3n15dxyX14ck7DSREj
 3+0+LokHi9FbXdbokIxAh3Wdj34N1N85dtyg6z3y/bo/Of6EdKqbNIVBqezMIowpDWPaV4oVLAs
 5mPrP+qyx5R0T5XOYns94/XNC9/MdsKR3pJ42fQmJC04OgNVTuMy35ttmQZlnzzxPjTxpdjsdtd
 OloH0J1xzqo7SGxGhXcLaInzkRVSGWhdWhzD31mPn5//A16fdekE4wI7OUdaRAjIfPV7Nqs0V+S
 WISJsrvK2xjWXmL1eZwH7ZJSLtu1iA==
X-Proofpoint-GUID: 3GsrbdsNaAM0LZsFauFLuDZhXTV7WBtC
X-Proofpoint-ORIG-GUID: 3GsrbdsNaAM0LZsFauFLuDZhXTV7WBtC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270010

From: Gautam Gala <ggala@linux.ibm.com>

KVM run fails when guests with 'cmm' cpu feature and host are
under memory pressure and use swap heavily. This is because
npages becomes ENOMEN (out of memory) in hva_to_pfn_slow()
which inturn propagates as EFAULT to qemu. Clearing the page
table entry when discarding an address that maps to a swap
entry resolves the issue.

Fixes: 200197908dc4 ("KVM: s390: Refactor and split some gmap helpers")
Cc: stable@vger.kernel.org
Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Gautam Gala <ggala@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 22 ++++++++++++++++++++++
 arch/s390/mm/gmap_helpers.c     | 12 +++++++++++-
 arch/s390/mm/pgtable.c          | 23 +----------------------
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 6d8bc27a366e..324f96485604 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -2010,4 +2010,26 @@ static inline unsigned long gmap_pgste_get_pgt_addr(unsigned long *pgt)
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
index a45d417ad951..c382005577bd 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -13,6 +13,7 @@
 #include <linux/pagewalk.h>
 #include <linux/ksm.h>
 #include <asm/gmap_helpers.h>
+#include <asm/pgtable.h>
 
 /**
  * ptep_zap_swap_entry() - discard a swap entry.
@@ -45,6 +46,7 @@ void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
 {
 	struct vm_area_struct *vma;
 	spinlock_t *ptl;
+	pgste_t pgste;
 	pte_t *ptep;
 
 	mmap_assert_locked(mm);
@@ -58,8 +60,16 @@ void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
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
index 7df70cd8f739..6b92c348b56f 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -23,6 +23,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/page-states.h>
+#include <asm/pgtable.h>
 #include <asm/machine.h>
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
@@ -114,28 +115,6 @@ static inline pte_t ptep_flush_lazy(struct mm_struct *mm,
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


