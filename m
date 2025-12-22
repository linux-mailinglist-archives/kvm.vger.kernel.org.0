Return-Path: <kvm+bounces-66483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A95ECD6B63
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:50:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A6B0D3013713
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 16:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37073332919;
	Mon, 22 Dec 2025 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rNfFLqs9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974E8331A40;
	Mon, 22 Dec 2025 16:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422245; cv=none; b=Uhv2nfPkkdyPln3MS3zKlL8+tPTqqEb9Don3mD3wbcCwaSMGJ0n2EPVw4W4sJ0L4fNcRtjMCMDXApFL3+7JFsX690g4as/gTLD3i1D/8nzXEQ795YSD0hFrt8Y5bv4k0wg2OzDcCOBwDP0uhitxQEqwoUnd/SKKk4O21p2ER184=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422245; c=relaxed/simple;
	bh=Frn6hltIyV5WJ2d6pPnm0V60inoBt8b4iK5mJVeSKiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gn8EfCinTnuUNQLCuhFJW96LKRw0dIH3SwejzDf96wqSgBTaf1Supwvmaks2R4NIkdwqwCZxelr+B2qFs8Yi00rm+A9oRAgPVFWvgsyf/+mmg9KQV1lRzvIPEJxYdMu8iO/B/+32+0qDca4C3Ki5rl0MArGXQN+nj7rIosbxoNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rNfFLqs9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BM9TqQF006558;
	Mon, 22 Dec 2025 16:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=rv39S/P+MdKrw6xwW
	OVNfixy/froEIPZnW3Fr4nBnwA=; b=rNfFLqs9DsZC53L/ueo7Xm7b0+LmNY07+
	I7dw1uKK8wgJq5r+heWJB3eGIhwaRpiB1bNtuBkGNHTHfJ1Iz5fGV8zAFN4xtAcv
	cY4Rix7FNXAOrc5Y2lAOVwsGB73kM0dGkQEd22RX7qiQBCSWsHcGroI3uWHgk9jB
	BgbLI5FPFqngGmuynrdjiB8uZZ0fJZlHXGHqvCApLdpntW6GyQAT+jJKshA8gUdb
	Y4AXPxbb2DscigjYLzxgB/ICMm29NqxRrlh+zuOUSzPY4CCv0Lu3wlyi0Y4d+4WO
	sNbLCeUUP+kQw2sN35FjDwkQ4n+/029qKSYrJHpIVoUVRLoBcqPuQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5j7e10xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:41 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGOJsj004192;
	Mon, 22 Dec 2025 16:50:40 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b674mq57v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGoa5a25428248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:36 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F45620043;
	Mon, 22 Dec 2025 16:50:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0CCF20040;
	Mon, 22 Dec 2025 16:50:34 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:34 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 01/28] KVM: s390: Refactor pgste lock and unlock functions
Date: Mon, 22 Dec 2025 17:50:06 +0100
Message-ID: <20251222165033.162329-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251222165033.162329-1-imbrenda@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=G8YR0tk5 c=1 sm=1 tr=0 ts=694976e1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=gw90SDbXj9Ny8T8iXsQA:9
X-Proofpoint-ORIG-GUID: EHJiBH7nGbZkwtaw8iEipERcpS_Dchul
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX0q19DCMiohw6
 KIaJQ0gnsQ4JyCf1YmYU+psEY/y8/XFQlFJqyT7VEZi5+FJNLcm9OSIehIDxEeRV4GkRuOvTHIJ
 dEl5HXx+Szdrgy41UDwdCg2qYT+NCQ9M7nzxkvvHv8C23ECJ0XozZLO9tOUhMFex1lxPW+23k1/
 vPJ18eQkpT1zdjreC5GKZy3BOeNIC2KTBuTMYkm8gLJeRLk4Aec5O2+oiVEhZEJTEuJp4elA6Mt
 P+OvOz6CfIAKbf46xJqlSzNZ4rptaPOEsPy0nv2YuWtMWxVUya4sUUtOPY4SuhqG2HpCtvAVu0x
 Bvb9r4G2BJDu0iSlN2dUjspoMKnAU2JXQjqFVy76vvjLguL75hPF7TkIvam7I16qiMkUWr39t1y
 KEXg2kYw6xi2cZZeFWG1mqRs6YE9zbAJR1oNpIPqwALVh0RHccAi7vrh0KBFA/FmXEHrbupp/YF
 w3ppaF1j9EIeX7n6MFw==
X-Proofpoint-GUID: EHJiBH7nGbZkwtaw8iEipERcpS_Dchul
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

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
index bca9b29778c3..8194a2b12ecf 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -2040,26 +2040,4 @@ static inline unsigned long gmap_pgste_get_pgt_addr(unsigned long *pgt)
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
index d41b19925a5a..4fba13675950 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -15,7 +15,6 @@
 #include <linux/pagewalk.h>
 #include <linux/ksm.h>
 #include <asm/gmap_helpers.h>
-#include <asm/pgtable.h>
 
 /**
  * ptep_zap_softleaf_entry() - discard a software leaf entry.
@@ -35,6 +34,28 @@ static void ptep_zap_softleaf_entry(struct mm_struct *mm, softleaf_t entry)
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
index 666adcd681ab..08743c1dac2f 100644
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
2.52.0


