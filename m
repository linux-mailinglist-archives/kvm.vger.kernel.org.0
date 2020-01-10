Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36EAE1376AB
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 20:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgAJTHV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 14:07:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbgAJTHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 14:07:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3Bm3100946;
        Fri, 10 Jan 2020 19:06:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=dGWzVklUrNGEX2eNLYyNdTm24qlx6OFYrDxE//3Gt2k=;
 b=aqdMe1SWRIRZOfYC9ETTz7SqH3W7zzBFov3yJ3G88orfapiXzOduqU9XCgT/5IfVusy+
 b1siD5J2KDhVXBP20WyHbz6gHA+Ep7fpyWDLdYnFEV04bgj55idOwuWUtB/1l+h97KbE
 DKeq4mOS3skV+wNAqu5KkyM08710bSA1yEUTwfnRFqluW3dxNxlQBJpGi9c4UM2azVjW
 NiIEe2JhlpuDIGkos/0/o+RqEgg3Qv9ao7SWVGv5hQsjIgOIZp/wM39Z2RCpNFrSJnd+
 nSFHLnpj0qSxO9mcvipKBIe1w5DwDIG6LRyjMnRb0g6PA51RK3OJA2M3KsqCH9JzJFWe ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xajnqm1nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:06:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3tmw183684;
        Fri, 10 Jan 2020 19:04:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xedhypu7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:04:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00AJ4v7K021342;
        Fri, 10 Jan 2020 19:04:57 GMT
Received: from paddy.uk.oracle.com (/10.175.192.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jan 2020 11:04:57 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
To:     linux-nvdimm@lists.01.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 04/10] mm: Handle pud entries in follow_pfn()
Date:   Fri, 10 Jan 2020 19:03:07 +0000
Message-Id: <20200110190313.17144-5-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200110190313.17144-1-joao.m.martins@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=711
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=767 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When follow_pfn hits a pud_huge() it won't return a valid PFN
for a PUD. Fix it by adding @pudp and thus allow callers to
get the pud pointer. If we encounter such a huge page, we
calculate the offset to the PUD accordingly.

This allows KVM to handle 1G hugepage pfns on VM_PFNMAP vmas.

Co-developed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 mm/memory.c | 58 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 109643219e1b..f46646630497 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4261,9 +4261,10 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+static int __follow_pte_pud(struct mm_struct *mm, unsigned long address,
 			    struct mmu_notifier_range *range,
-			    pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
+			    pte_t **ptepp, pmd_t **pmdpp, pud_t **pudpp,
+			    spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -4280,6 +4281,28 @@ static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 		goto out;
 
 	pud = pud_offset(p4d, address);
+	VM_BUG_ON(pud_trans_huge(*pud));
+
+	if (pud_huge(*pud)) {
+		if (!pudpp)
+			goto out;
+
+		if (range) {
+			mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0,
+						NULL, mm, address & PUD_MASK,
+						(address & PUD_MASK) + PUD_SIZE);
+			mmu_notifier_invalidate_range_start(range);
+		}
+		*ptlp = pud_lock(mm, pud);
+		if (pud_huge(*pud)) {
+			*pudpp = pud;
+			return 0;
+		}
+		spin_unlock(*ptlp);
+		if (range)
+			mmu_notifier_invalidate_range_end(range);
+	}
+
 	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
 		goto out;
 
@@ -4335,8 +4358,8 @@ static inline int follow_pte(struct mm_struct *mm, unsigned long address,
 
 	/* (void) is needed to make gcc happy */
 	(void) __cond_lock(*ptlp,
-			   !(res = __follow_pte_pmd(mm, address, NULL,
-						    ptepp, NULL, ptlp)));
+			   !(res = __follow_pte_pud(mm, address, NULL,
+						    ptepp, NULL, NULL, ptlp)));
 	return res;
 }
 
@@ -4348,12 +4371,26 @@ int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 
 	/* (void) is needed to make gcc happy */
 	(void) __cond_lock(*ptlp,
-			   !(res = __follow_pte_pmd(mm, address, range,
-						    ptepp, pmdpp, ptlp)));
+			   !(res = __follow_pte_pud(mm, address, range,
+						    ptepp, pmdpp, NULL, ptlp)));
 	return res;
 }
 EXPORT_SYMBOL(follow_pte_pmd);
 
+static int follow_pte_pud(struct mm_struct *mm, unsigned long address,
+			  struct mmu_notifier_range *range,
+			  pte_t **ptepp, pmd_t **pmdpp, pud_t **pudpp,
+			  spinlock_t **ptlp)
+{
+	int res;
+
+	/* (void) is needed to make gcc happy */
+	(void) __cond_lock(*ptlp,
+			   !(res = __follow_pte_pud(mm, address, range,
+						    ptepp, pmdpp, pudpp, ptlp)));
+	return res;
+}
+
 /**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping
@@ -4368,6 +4405,7 @@ int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn)
 {
 	pmd_t *pmdpp = NULL;
+	pud_t *pudpp = NULL;
 	int ret = -EINVAL;
 	spinlock_t *ptl;
 	pte_t *ptep;
@@ -4375,11 +4413,13 @@ int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		return ret;
 
-	ret = follow_pte_pmd(vma->vm_mm, address, NULL,
-			     &ptep, &pmdpp, &ptl);
+	ret = follow_pte_pud(vma->vm_mm, address, NULL,
+			     &ptep, &pmdpp, &pudpp, &ptl);
 	if (ret)
 		return ret;
-	if (pmdpp)
+	if (pudpp)
+		*pfn = pud_pfn(*pudpp) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
+	else if (pmdpp)
 		*pfn = pmd_pfn(*pmdpp) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
 	else
 		*pfn = pte_pfn(*ptep);
-- 
2.17.1

