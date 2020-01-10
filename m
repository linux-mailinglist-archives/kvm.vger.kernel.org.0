Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DAF1376A3
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 20:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgAJTGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 14:06:09 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53634 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728900AbgAJTGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 14:06:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ3Br1100944;
        Fri, 10 Jan 2020 19:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=lmAqIjgm7HVbSyXw06vW1C3Rvk9MKSm3/YBzLlEguL0=;
 b=AnMka1g154EpkiM9ty3oJyhJn5eWfNl5iaIKez8elA1e04Peo9Aeateeo2qtcXUoJqKc
 ZxPNkT/ypti5w79K0d/0fReEG/D5KXOdi5es5Lmd6MKy2mEmpMTZnJLE+CLzoaJJXZj+
 zz37gPKnTkH0pMZ9NJWSZS/cM1b2LJs/Hq1pviSEV9L/wdxQbHsjZRhlTE3A01NiWZEt
 wMjuLQhx+lkmMDA1Ue6GN/WswconK96BMLUfVc/vYO3TOUstM6vCaeqGUfsCoDmXOroU
 dK2wo1Vpn6XP6n261naL7aPuAAppyBiaP24Mf9Nv+06hJejovTX9lYKCAD3Iwv/ks8b+ WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xajnqm1aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:04:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00AJ49CZ069268;
        Fri, 10 Jan 2020 19:04:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xevfebtjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 19:04:43 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00AJ4gMM020986;
        Fri, 10 Jan 2020 19:04:42 GMT
Received: from paddy.uk.oracle.com (/10.175.192.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Jan 2020 11:04:41 -0800
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
Subject: [PATCH RFC 01/10] mm: Add pmd support for _PAGE_SPECIAL
Date:   Fri, 10 Jan 2020 19:03:04 +0000
Message-Id: <20200110190313.17144-2-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200110190313.17144-1-joao.m.martins@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9496 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100154
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently vmf_insert_pfn_pmd only works with devmap
and BUG_ON otherwise. Add support for handling
page special when pfn_t has it marked with PFN_SPECIAL.

Usage of page special aren't expected to do GUP
hence return no pages on gup_huge_pmd() much like how
it is done for ptes on gup_pte_range().

This allows a DAX driver to handle 2M hugepages without
struct pages.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 arch/x86/include/asm/pgtable.h | 16 +++++++++++++++-
 mm/gup.c                       |  3 +++
 mm/huge_memory.c               |  7 ++++---
 mm/memory.c                    |  3 ++-
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ad97dc155195..60351c0c15fe 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -255,7 +255,7 @@ static inline int pmd_large(pmd_t pte)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
-	return (pmd_val(pmd) & (_PAGE_PSE|_PAGE_DEVMAP)) == _PAGE_PSE;
+	return (pmd_val(pmd) & (_PAGE_PSE|_PAGE_DEVMAP|_PAGE_SPECIAL)) == _PAGE_PSE;
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
@@ -293,6 +293,15 @@ static inline int pgd_devmap(pgd_t pgd)
 {
 	return 0;
 }
+#endif
+
+#ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
+static inline int pmd_special(pmd_t pmd)
+{
+	return !!(pmd_flags(pmd) & _PAGE_SPECIAL);
+}
+#endif
+
 #endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -414,6 +423,11 @@ static inline pmd_t pmd_mkdevmap(pmd_t pmd)
 	return pmd_set_flags(pmd, _PAGE_DEVMAP);
 }
 
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SPECIAL);
+}
+
 static inline pmd_t pmd_mkhuge(pmd_t pmd)
 {
 	return pmd_set_flags(pmd, _PAGE_PSE);
diff --git a/mm/gup.c b/mm/gup.c
index 7646bf993b25..ba5f10535392 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2079,6 +2079,9 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 		return __gup_device_huge_pmd(orig, pmdp, addr, end, pages, nr);
 	}
 
+	if (pmd_special(orig))
+		return 0;
+
 	refs = 0;
 	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	do {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 41a0fbddc96b..06ad4d6f7477 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -791,6 +791,8 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
 	if (pfn_t_devmap(pfn))
 		entry = pmd_mkdevmap(entry);
+	else if (pfn_t_special(pfn))
+		entry = pmd_mkspecial(entry);
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
 		entry = maybe_pmd_mkwrite(entry, vma);
@@ -823,8 +825,7 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write)
 	 * but we need to be consistent with PTEs and architectures that
 	 * can't support a 'special' bit.
 	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) &&
-			!pfn_t_devmap(pfn));
+	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
@@ -2013,7 +2014,7 @@ spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
 	spinlock_t *ptl;
 	ptl = pmd_lock(vma->vm_mm, pmd);
 	if (likely(is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) ||
-			pmd_devmap(*pmd)))
+			pmd_devmap(*pmd) || pmd_special(*pmd)))
 		return ptl;
 	spin_unlock(ptl);
 	return NULL;
diff --git a/mm/memory.c b/mm/memory.c
index 45442d9a4f52..cfc3668bddeb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1165,7 +1165,8 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
+		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) ||
+		    pmd_devmap(*pmd) || pmd_special(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			else if (zap_huge_pmd(tlb, vma, pmd, addr))
-- 
2.17.1

