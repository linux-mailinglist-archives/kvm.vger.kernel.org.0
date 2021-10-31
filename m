Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD12440E10
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 13:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhJaMNr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 08:13:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41778 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231717AbhJaMNo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 08:13:44 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19VAbnSn020472;
        Sun, 31 Oct 2021 12:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=mu20E30gfQj/TAwyB2kHXfDkgFtakY8jfYrriPLbSX0=;
 b=kdRVnpTnGjOBIYzztWGpROJa34BQ2ena8FTF+jhTNeK9JP4T/MVW/Z6LFppnnqOjwBzq
 X3X6sIUFI6EsHGY5/SwJ3Xxmo71shKpP4qUtKQC73RAOWzX6+tWGbxaLfKaU41DSRWZC
 ZkQJgNX07aotbphZe8c0hAZ2jy9vmARgKrsp6S/LVhF6duwbE2711wwU7I9jE3Stu77+
 U1ZYpBAl3JVjJ2xYzMUn1e9xlQELhNQlyGK1ZGAIP4J7VaLyi7N89Km57mz/aCcPynDY
 fo8v1U6921GsyAH6+vM5CUJllLagTUE3pPi9MweXRY+vRAL5kUb0rIDTzp3xAHCg0cKq pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1r0n24tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:12 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19VC9Cc9011416;
        Sun, 31 Oct 2021 12:11:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c1r0n24su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19VC9LcH006428;
        Sun, 31 Oct 2021 12:11:09 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3c0wp957ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 31 Oct 2021 12:11:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19VCB6V866584952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 31 Oct 2021 12:11:06 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22F62AE04D;
        Sun, 31 Oct 2021 12:11:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16683AE045;
        Sun, 31 Oct 2021 12:11:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 31 Oct 2021 12:11:06 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id C4A1BE056B; Sun, 31 Oct 2021 13:11:05 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 04/17] s390/mm: fix VMA and page table handling code in storage key handling functions
Date:   Sun, 31 Oct 2021 13:10:51 +0100
Message-Id: <20211031121104.14764-5-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vl3dHg4KJjkZyfp35SdWKu69L6QD9BKb
X-Proofpoint-ORIG-GUID: xAxFY9NuDzcckRECUmv6ng2dLWKSLgiB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-31_03,2021-10-29_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110310076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

There are multiple things broken about our storage key handling
functions:

1. We should not walk/touch page tables outside of VMA boundaries when
   holding only the mmap sem in read mode. Evil user space can modify the
   VMA layout just before this function runs and e.g., trigger races with
   page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
   with read mmap_sem in munmap"). gfn_to_hva() will only translate using
   KVM memory regions, but won't validate the VMA.

2. We should not allocate page tables outside of VMA boundaries: if
   evil user space decides to map hugetlbfs to these ranges, bad things
   will happen because we suddenly have PTE or PMD page tables where we
   shouldn't have them.

3. We don't handle large PUDs that might suddenly appeared inside our page
   table hierarchy.

Don't manually allocate page tables, properly validate that we have VMA and
bail out on pud_large().

All callers of page table handling functions, except
get_guest_storage_key(), call fixup_user_fault() in case they
receive an -EFAULT and retry; this will allocate the necessary page tables
if required.

To keep get_guest_storage_key() working as expected and not requiring
kvm_s390_get_skeys() to call fixup_user_fault() distinguish between
"there is simply no page table or huge page yet and the key is assumed
to be 0" and "this is a fault to be reported".

Although commit 637ff9efe5ea ("s390/mm: Add huge pmd storage key handling")
introduced most of the affected code, it was actually already broken
before when using get_locked_pte() without any VMA checks.

Note: Ever since commit 637ff9efe5ea ("s390/mm: Add huge pmd storage key
handling") we can no longer set a guest storage key (for example from
QEMU during VM live migration) without actually resolving a fault.
Although we would have created most page tables, we would choke on the
!pmd_present(), requiring a call to fixup_user_fault(). I would
have thought that this is problematic in combination with postcopy life
migration ... but nobody noticed and this patch doesn't change the
situation. So maybe it's just fine.

Fixes: 9fcf93b5de06 ("KVM: S390: Create helper function get_guest_storage_key")
Fixes: 24d5dd0208ed ("s390/kvm: Provide function for setting the guest storage key")
Fixes: a7e19ab55ffd ("KVM: s390: handle missing storage-key facility")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20210909162248.14969-5-david@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/mm/pgtable.c | 57 +++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 2717a406edeb..6ad634a27d5b 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -429,22 +429,36 @@ static inline pmd_t pmdp_flush_lazy(struct mm_struct *mm,
 }
 
 #ifdef CONFIG_PGSTE
-static pmd_t *pmd_alloc_map(struct mm_struct *mm, unsigned long addr)
+static int pmd_lookup(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 {
+	struct vm_area_struct *vma;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
-	pmd_t *pmd;
+
+	/* We need a valid VMA, otherwise this is clearly a fault. */
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		return -EFAULT;
 
 	pgd = pgd_offset(mm, addr);
-	p4d = p4d_alloc(mm, pgd, addr);
-	if (!p4d)
-		return NULL;
-	pud = pud_alloc(mm, p4d, addr);
-	if (!pud)
-		return NULL;
-	pmd = pmd_alloc(mm, pud, addr);
-	return pmd;
+	if (!pgd_present(*pgd))
+		return -ENOENT;
+
+	p4d = p4d_offset(pgd, addr);
+	if (!p4d_present(*p4d))
+		return -ENOENT;
+
+	pud = pud_offset(p4d, addr);
+	if (!pud_present(*pud))
+		return -ENOENT;
+
+	/* Large PUDs are not supported yet. */
+	if (pud_large(*pud))
+		return -EFAULT;
+
+	*pmdp = pmd_offset(pud, addr);
+	return 0;
 }
 #endif
 
@@ -778,8 +792,7 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	pmd_t *pmdp;
 	pte_t *ptep;
 
-	pmdp = pmd_alloc_map(mm, addr);
-	if (unlikely(!pmdp))
+	if (pmd_lookup(mm, addr, &pmdp))
 		return -EFAULT;
 
 	ptl = pmd_lock(mm, pmdp);
@@ -881,8 +894,7 @@ int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
 	pte_t *ptep;
 	int cc = 0;
 
-	pmdp = pmd_alloc_map(mm, addr);
-	if (unlikely(!pmdp))
+	if (pmd_lookup(mm, addr, &pmdp))
 		return -EFAULT;
 
 	ptl = pmd_lock(mm, pmdp);
@@ -935,15 +947,24 @@ int get_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	pmd_t *pmdp;
 	pte_t *ptep;
 
-	pmdp = pmd_alloc_map(mm, addr);
-	if (unlikely(!pmdp))
+	/*
+	 * If we don't have a PTE table and if there is no huge page mapped,
+	 * the storage key is 0.
+	 */
+	*key = 0;
+
+	switch (pmd_lookup(mm, addr, &pmdp)) {
+	case -ENOENT:
+		return 0;
+	case 0:
+		break;
+	default:
 		return -EFAULT;
+	}
 
 	ptl = pmd_lock(mm, pmdp);
 	if (!pmd_present(*pmdp)) {
-		/* Not yet mapped memory has a zero key */
 		spin_unlock(ptl);
-		*key = 0;
 		return 0;
 	}
 
-- 
2.31.1

