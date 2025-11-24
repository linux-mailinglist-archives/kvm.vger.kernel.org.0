Return-Path: <kvm+bounces-64354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE05C804AB
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:56:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 731ED3A7F8F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539862FFFAC;
	Mon, 24 Nov 2025 11:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bfrIWZwb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6522FF642;
	Mon, 24 Nov 2025 11:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985370; cv=none; b=WeY21Vgfqt4Jb4HFtaZHLPFO+fQnTmFS30aRF+/MhSAWL+szxQbO0caUDADlK8c0bCz841KttoS6qgvyL2TZv/t4MFQ1WH/KIa+7h4yzIPhe/BAc1fopQ7Q22IWbo+4f+5wTQjQWht06N0UgCHYUJTVnDbGyQdMuM7OFUke41ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985370; c=relaxed/simple;
	bh=VoaFOXEL6pENAFpQf75H1ApTLhVD17/K6ByfpKPt/DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjmSqjUAj0tZZ+lCQFOxY4TmRbIlAagW/VY6kR7sKnjIGigpRJW39GmVCZ5Ugavcgi/rFIFKmBgJIVPo3l8rDGw/xd8KljISCnR1BV79FVcPzemMtrrtsmHnK1BmT23wNPlyG3Yz7JlS/KWgWtT3seSnQk8XECrIWtvqzFKwsvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bfrIWZwb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOAnCeX013901;
	Mon, 24 Nov 2025 11:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xaKxzY/IbWopyZNo1
	Xb8G5vz3W+JIoGpAx17XJ8anWQ=; b=bfrIWZwbSlWwXdQb1gHV9GQ7D27kBJvjB
	AmOto+7ajWY22SikCUP91Hks16tUFKTXZDErdLy+H/bBgsR7NVcpqdwGHVwBYt/g
	gS/6obTtMO1on3azKfGEbbIQqMzB/CpFUoJK6rzE4riuJ2wYxn56rdzv2BQGCiPB
	t682z25nekiM3GKokr6kVm22T+ina16NWizj9abx3efmhuAsIgCSJWfXXGu819h0
	EgStceb3/HvHffNxccTJi3gfDgKb43rOTwE+k7BzO8uk2Al6oYkCFwRIz63WU0zV
	nk7xGHrPeaOG/andddxwLoEJg4TFDRUIJKPupMHZRut42v326Uh8w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4phqxnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOA8QUt000831;
	Mon, 24 Nov 2025 11:56:03 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akqvxnun8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBtxlm50463024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:55:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 502BC20040;
	Mon, 24 Nov 2025 11:55:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FE902004E;
	Mon, 24 Nov 2025 11:55:57 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:55:57 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 01/23] KVM: s390: Refactor pgste lock and unlock functions
Date: Mon, 24 Nov 2025 12:55:32 +0100
Message-ID: <20251124115554.27049-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124115554.27049-1-imbrenda@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAxNiBTYWx0ZWRfX93hEN4e8tUiq
 Gtu0WesnrhXMcYiBJRI70rgA7f0pNZmmbZd0WfKz/OTjtiEgiHX0Cknk3XnEdrhAYcc7Q9CymyT
 bVSGTvUh41QBe6clOk2s1WpQtO1H5swVwzX0i+aiT39yHyFPFiucqUQwXcCZ4p6KhMsQpwpZgc2
 Fj4ojd/rCfJHNsreIscy2W7FTOWNqumdxAFOLG43E3z1SKQg45EvliHv5xi9dODXpejKS/MyG3l
 JTMFb7+uhCkap/2tlhQoMUn3mo8MYzBHJn0LpKw2kJS9Km9HY1iEzYByHu3BJVuBnwskkWYc6DB
 dbO5EeOvilOdN213Re3hRuGMg46tRf5zMAzzZUGVQG5ecZaQBSsZCfIbPc+1+tJHU4qy0VbHMuU
 +Xz/y1sotzW8U+sMT2NAFTTN8u8UHw==
X-Proofpoint-ORIG-GUID: kupOx993h1mpYkqsQoCK4wS8F2hDmW1S
X-Authority-Analysis: v=2.4 cv=CcYFJbrl c=1 sm=1 tr=0 ts=692447d4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=gw90SDbXj9Ny8T8iXsQA:9
X-Proofpoint-GUID: kupOx993h1mpYkqsQoCK4wS8F2hDmW1S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220016

Move the pgste lock and unlock functions back into mm/pgtable.c and
duplicate them in mm/gmap_helpers.c to avoid function name collisions
later on.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/pgtable.h | 22 ----------------------
 arch/s390/mm/gmap_helpers.c     | 23 ++++++++++++++++++++++-
 arch/s390/mm/pgtable.c          | 23 ++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 6663f1619abb..528ce3611e53 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -2053,26 +2053,4 @@ static inline unsigned long gmap_pgste_get_pgt_addr(unsigned long *pgt)
 	return res;
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
 #endif /* _S390_PAGE_H */
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index d4c3c36855e2..e14a63119e30 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -15,7 +15,6 @@
 #include <linux/pagewalk.h>
 #include <linux/ksm.h>
 #include <asm/gmap_helpers.h>
-#include <asm/pgtable.h>
 
 /**
  * ptep_zap_swap_entry() - discard a swap entry.
@@ -35,6 +34,28 @@ static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
 	free_swap_and_cache(entry);
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
 /**
  * gmap_helper_zap_one_page() - discard a page if it was swapped.
  * @mm: the mm
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 05974304d622..d0e8579d2669 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -24,7 +24,6 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/page-states.h>
-#include <asm/pgtable.h>
 #include <asm/machine.h>
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
@@ -116,6 +115,28 @@ static inline pte_t ptep_flush_lazy(struct mm_struct *mm,
 	return old;
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
 static inline pgste_t pgste_get(pte_t *ptep)
 {
 	unsigned long pgste = 0;
-- 
2.51.1


