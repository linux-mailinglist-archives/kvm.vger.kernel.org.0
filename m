Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56B5B658E1
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfGKO21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37906 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728969AbfGKO2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOMPI001606;
        Thu, 11 Jul 2019 14:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=y9IAz60J7qXRlFN2NRsHUzd+qvZ9ZunbWoLTMdcwAx8=;
 b=SmfOq+K7kq1i3rKVZwlHKx3Hxs01appLJg4uPnU/ZriVoOVHCERIDHALooM0c4fIGSBJ
 6sJUwYFar/i1eRJ0bDwA5eXmBBC3pkJst2pWeRiO5XvbO/TYtBqcsljdxwFDY+ygijHk
 H0MYZu44ra2JBIbub0jXMvwYLNtqfrcVe7JBvlbVaiEu0d5hM3uanYLNWIvfENEj46Wm
 gz3Qt8PeZrmim/eo4JN+pfX8fKIq4/XNikWq8u1EuUds0UNZgKC6NbZKX2Q0LuHEumqL
 b5/SpV0/Ww9/ELn0rWmcvfcCc+XgXWqEmOxEsU2TT2yDZ4Zr37YzZrqonMAsPGVng5cD rQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0dx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:12 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcu1021444;
        Thu, 11 Jul 2019 14:26:09 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 08/26] mm/asi: Functions to populate an ASI page-table from a VA range
Date:   Thu, 11 Jul 2019 16:25:20 +0200
Message-Id: <1562855138-19507-9-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=917 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide functions to copy page-table entries from the kernel page-table
to an ASI page-table for a specified VA range. These functions are based
on the copy_pxx_range() functions defined in mm/memory.c. A difference
is that a level parameter can be specified to indicate the page-table
level (PGD, P4D, PUD PMD, PTE) at which the copy should be done. Also
functions don't rely on mm or vma, and they don't alter the source
page-table even if an entry is bad. Also the VA range start and size
don't need to be page-aligned.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h  |    4 +
 arch/x86/mm/asi_pagetable.c |  205 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 209 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 3d965e6..19656aa 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -76,6 +76,10 @@ struct asi_session {
 extern bool asi_fault(struct pt_regs *regs, unsigned long error_code,
 		      unsigned long address);
 
+extern int asi_map_range(struct asi *asi, void *ptr, size_t size,
+			 enum page_table_level level);
+extern int asi_map(struct asi *asi, void *ptr, unsigned long size);
+
 /*
  * Function to exit the current isolation. This is used to abort isolation
  * when a task using isolation is scheduled out.
diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index e17af9e..0169395 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -394,3 +394,208 @@ static int asi_set_pgd(struct asi *asi, pgd_t *pgd, pgd_t pgd_value)
 
 	return 0;
 }
+
+static int asi_copy_pte_range(struct asi *asi, pmd_t *dst_pmd, pmd_t *src_pmd,
+			      unsigned long addr, unsigned long end)
+{
+	pte_t *src_pte, *dst_pte;
+
+	dst_pte = asi_pte_alloc(asi, dst_pmd, addr);
+	if (IS_ERR(dst_pte))
+		return PTR_ERR(dst_pte);
+
+	addr &= PAGE_MASK;
+	src_pte = pte_offset_map(src_pmd, addr);
+
+	do {
+		asi_set_pte(asi, dst_pte, *src_pte);
+
+	} while (dst_pte++, src_pte++, addr += PAGE_SIZE, addr < end);
+
+	return 0;
+}
+
+static int asi_copy_pmd_range(struct asi *asi, pud_t *dst_pud, pud_t *src_pud,
+			      unsigned long addr, unsigned long end,
+			      enum page_table_level level)
+{
+	pmd_t *src_pmd, *dst_pmd;
+	unsigned long next;
+	int err;
+
+	dst_pmd = asi_pmd_alloc(asi, dst_pud, addr);
+	if (IS_ERR(dst_pmd))
+		return PTR_ERR(dst_pmd);
+
+	src_pmd = pmd_offset(src_pud, addr);
+
+	do {
+		next = pmd_addr_end(addr, end);
+		if (level == PGT_LEVEL_PMD || pmd_none(*src_pmd) ||
+		    pmd_trans_huge(*src_pmd) || pmd_devmap(*src_pmd)) {
+			err = asi_set_pmd(asi, dst_pmd, *src_pmd);
+			if (err)
+				return err;
+			continue;
+		}
+
+		if (!pmd_present(*src_pmd)) {
+			pr_warn("ASI %p: PMD not present for [%lx,%lx]\n",
+				asi, addr, next - 1);
+			pmd_clear(dst_pmd);
+			continue;
+		}
+
+		err = asi_copy_pte_range(asi, dst_pmd, src_pmd, addr, next);
+		if (err) {
+			pr_err("ASI %p: PMD error copying PTE addr=%lx next=%lx\n",
+			       asi, addr, next);
+			return err;
+		}
+
+	} while (dst_pmd++, src_pmd++, addr = next, addr < end);
+
+	return 0;
+}
+
+static int asi_copy_pud_range(struct asi *asi, p4d_t *dst_p4d, p4d_t *src_p4d,
+			      unsigned long addr, unsigned long end,
+			      enum page_table_level level)
+{
+	pud_t *src_pud, *dst_pud;
+	unsigned long next;
+	int err;
+
+	dst_pud = asi_pud_alloc(asi, dst_p4d, addr);
+	if (IS_ERR(dst_pud))
+		return PTR_ERR(dst_pud);
+
+	src_pud = pud_offset(src_p4d, addr);
+
+	do {
+		next = pud_addr_end(addr, end);
+		if (level == PGT_LEVEL_PUD || pud_none(*src_pud) ||
+		    pud_trans_huge(*src_pud) || pud_devmap(*src_pud)) {
+			err = asi_set_pud(asi, dst_pud, *src_pud);
+			if (err)
+				return err;
+			continue;
+		}
+
+		err = asi_copy_pmd_range(asi, dst_pud, src_pud, addr, next,
+					 level);
+		if (err) {
+			pr_err("ASI %p: PUD error copying PMD addr=%lx next=%lx\n",
+			       asi, addr, next);
+			return err;
+		}
+
+	} while (dst_pud++, src_pud++, addr = next, addr < end);
+
+	return 0;
+}
+
+static int asi_copy_p4d_range(struct asi *asi, pgd_t *dst_pgd, pgd_t *src_pgd,
+			      unsigned long addr, unsigned long end,
+			      enum page_table_level level)
+{
+	p4d_t *src_p4d, *dst_p4d;
+	unsigned long next;
+	int err;
+
+	dst_p4d = asi_p4d_alloc(asi, dst_pgd, addr);
+	if (IS_ERR(dst_p4d))
+		return PTR_ERR(dst_p4d);
+
+	src_p4d = p4d_offset(src_pgd, addr);
+
+	do {
+		next = p4d_addr_end(addr, end);
+		if (level == PGT_LEVEL_P4D || p4d_none(*src_p4d)) {
+			err = asi_set_p4d(asi, dst_p4d, *src_p4d);
+			if (err)
+				return err;
+			continue;
+		}
+
+		err = asi_copy_pud_range(asi, dst_p4d, src_p4d, addr, next,
+					 level);
+		if (err) {
+			pr_err("ASI %p: P4D error copying PUD addr=%lx next=%lx\n",
+			       asi, addr, next);
+			return err;
+		}
+
+	} while (dst_p4d++, src_p4d++, addr = next, addr < end);
+
+	return 0;
+}
+
+static int asi_copy_pgd_range(struct asi *asi,
+			      pgd_t *dst_pagetable, pgd_t *src_pagetable,
+			      unsigned long addr, unsigned long end,
+			      enum page_table_level level)
+{
+	pgd_t *src_pgd, *dst_pgd;
+	unsigned long next;
+	int err;
+
+	dst_pgd = pgd_offset_pgd(dst_pagetable, addr);
+	src_pgd = pgd_offset_pgd(src_pagetable, addr);
+
+	do {
+		next = pgd_addr_end(addr, end);
+		if (level == PGT_LEVEL_PGD || pgd_none(*src_pgd)) {
+			err = asi_set_pgd(asi, dst_pgd, *src_pgd);
+			if (err)
+				return err;
+			continue;
+		}
+
+		err = asi_copy_p4d_range(asi, dst_pgd, src_pgd, addr, next,
+					 level);
+		if (err) {
+			pr_err("ASI %p: PGD error copying P4D addr=%lx next=%lx\n",
+			       asi, addr, next);
+			return err;
+		}
+
+	} while (dst_pgd++, src_pgd++, addr = next, addr < end);
+
+	return 0;
+}
+
+/*
+ * Copy page table entries from the current page table (i.e. from the
+ * kernel page table) to the specified ASI page-table. The level
+ * parameter specifies the page-table level (PGD, P4D, PUD PMD, PTE)
+ * at which the copy should be done.
+ */
+int asi_map_range(struct asi *asi, void *ptr, size_t size,
+		  enum page_table_level level)
+{
+	unsigned long addr = (unsigned long)ptr;
+	unsigned long end = addr + ((unsigned long)size);
+	unsigned long flags;
+	int err;
+
+	pr_debug("ASI %p: MAP %px/%lx/%d\n", asi, ptr, size, level);
+
+	spin_lock_irqsave(&asi->lock, flags);
+	err = asi_copy_pgd_range(asi, asi->pgd, current->mm->pgd,
+				 addr, end, level);
+	spin_unlock_irqrestore(&asi->lock, flags);
+
+	return err;
+}
+EXPORT_SYMBOL(asi_map_range);
+
+/*
+ * Copy page-table PTE entries from the current page-table to the
+ * specified ASI page-table.
+ */
+int asi_map(struct asi *asi, void *ptr, unsigned long size)
+{
+	return asi_map_range(asi, ptr, size, PGT_LEVEL_PTE);
+}
+EXPORT_SYMBOL(asi_map);
-- 
1.7.1

