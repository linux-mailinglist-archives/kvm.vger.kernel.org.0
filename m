Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB701658BC
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbfGKO1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:27:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39270 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbfGKO1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOabr100891;
        Thu, 11 Jul 2019 14:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=Ccv45kVv21CrVP2UQjHtQ159yrdddBRkfeerFm1lQZs=;
 b=HGyms/pISRX5hcPdr6Z5qUYPoK8BQ52EIauuQPyhPhRre44rLyUHzvnoqOTRvXzrwhCv
 OTY05ptHcmicwwbGGPPXQN6m4TPthhy/xClxEZa4yF8uHSsKm7ZSH9u/tLfCQHG6hg1K
 +gEPReBvdFOuXQjB3QhAq8WvFQ4EtwdfdpRMWXWmCpj3REbSSnlT8iB9x+evcMVyxruc
 OTPrrYVoOXTGYADVN58b8Xu0sMhIRq/VtBIXKZS/5/ya9K9aD3oXpTX8QexDk1Ib94j1
 ij8M3PZb4/wsMYxdM8hN/VwLMvqwLeYU8gvZc6wjF0NGEF6IBAOdWQJA2MvUwBG0KojU 6Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2tjkkq0c8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:21 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcu4021444;
        Thu, 11 Jul 2019 14:26:18 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 11/26] mm/asi: Functions to clear ASI page-table entries for a VA range
Date:   Thu, 11 Jul 2019 16:25:23 +0200
Message-Id: <1562855138-19507-12-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=905 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide functions to clear page-table entries in the ASI page-table for
a specified VA range. Functions also check that the clearing effectively
happens in the ASI page-table and there is no crossing of the ASI
page-table boundary (through references to the kernel page table), so
that the kernel page table is not modified by mistake.

As information (address, size, page-table level) about VA ranges mapped
to the ASI page-table is tracked, clearing is done with just specifying
the start address of the range.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h  |    1 +
 arch/x86/mm/asi_pagetable.c |  134 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index be1c190..919129f 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -83,6 +83,7 @@ extern bool asi_fault(struct pt_regs *regs, unsigned long error_code,
 extern int asi_map_range(struct asi *asi, void *ptr, size_t size,
 			 enum page_table_level level);
 extern int asi_map(struct asi *asi, void *ptr, unsigned long size);
+extern void asi_unmap(struct asi *asi, void *ptr);
 
 /*
  * Copy the memory mapping for the current module. This is defined as a
diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index a09a22d..7aee236 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -670,3 +670,137 @@ int asi_map(struct asi *asi, void *ptr, unsigned long size)
 	return asi_map_range(asi, ptr, size, PGT_LEVEL_PTE);
 }
 EXPORT_SYMBOL(asi_map);
+
+static void asi_clear_pte_range(struct asi *asi, pmd_t *pmd,
+				unsigned long addr, unsigned long end)
+{
+	pte_t *pte;
+
+	pte = asi_pte_offset(asi, pmd, addr);
+	if (IS_ERR(pte))
+		return;
+
+	do {
+		pte_clear(NULL, addr, pte);
+	} while (pte++, addr += PAGE_SIZE, addr < end);
+}
+
+static void asi_clear_pmd_range(struct asi *asi, pud_t *pud,
+				unsigned long addr, unsigned long end,
+				enum page_table_level level)
+{
+	unsigned long next;
+	pmd_t *pmd;
+
+	pmd = asi_pmd_offset(asi, pud, addr);
+	if (IS_ERR(pmd))
+		return;
+
+	do {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none(*pmd) || pmd_present(*pmd))
+			continue;
+		if (level == PGT_LEVEL_PMD || pmd_trans_huge(*pmd) ||
+		    pmd_devmap(*pmd)) {
+			pmd_clear(pmd);
+			continue;
+		}
+		asi_clear_pte_range(asi, pmd, addr, next);
+	} while (pmd++, addr = next, addr < end);
+}
+
+static void asi_clear_pud_range(struct asi *asi, p4d_t *p4d,
+				unsigned long addr, unsigned long end,
+				enum page_table_level level)
+{
+	unsigned long next;
+	pud_t *pud;
+
+	pud = asi_pud_offset(asi, p4d, addr);
+	if (IS_ERR(pud))
+		return;
+
+	do {
+		next = pud_addr_end(addr, end);
+		if (pud_none(*pud))
+			continue;
+		if (level == PGT_LEVEL_PUD || pud_trans_huge(*pud) ||
+		    pud_devmap(*pud)) {
+			pud_clear(pud);
+			continue;
+		}
+		asi_clear_pmd_range(asi, pud, addr, next, level);
+	} while (pud++, addr = next, addr < end);
+}
+
+static void asi_clear_p4d_range(struct asi *asi, pgd_t *pgd,
+				unsigned long addr, unsigned long end,
+				enum page_table_level level)
+{
+	unsigned long next;
+	p4d_t *p4d;
+
+	p4d = asi_p4d_offset(asi, pgd, addr);
+	if (IS_ERR(p4d))
+		return;
+
+	do {
+		next = p4d_addr_end(addr, end);
+		if (p4d_none(*p4d))
+			continue;
+		if (level == PGT_LEVEL_P4D) {
+			p4d_clear(p4d);
+			continue;
+		}
+		asi_clear_pud_range(asi, p4d, addr, next, level);
+	} while (p4d++, addr = next, addr < end);
+}
+
+static void asi_clear_pgd_range(struct asi *asi, pgd_t *pagetable,
+				unsigned long addr, unsigned long end,
+				enum page_table_level level)
+{
+	unsigned long next;
+	pgd_t *pgd;
+
+	pgd = pgd_offset_pgd(pagetable, addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd_none(*pgd))
+			continue;
+		if (level == PGT_LEVEL_PGD) {
+			pgd_clear(pgd);
+			continue;
+		}
+		asi_clear_p4d_range(asi, pgd, addr, next, level);
+	} while (pgd++, addr = next, addr < end);
+}
+
+/*
+ * Clear page table entries in the specified ASI page-table.
+ */
+void asi_unmap(struct asi *asi, void *ptr)
+{
+	struct asi_range_mapping *range_mapping;
+	unsigned long addr, end;
+	unsigned long flags;
+
+	spin_lock_irqsave(&asi->lock, flags);
+
+	range_mapping = asi_get_range_mapping(asi, ptr);
+	if (!range_mapping) {
+		pr_debug("ASI %p: UNMAP %px - not mapped\n", asi, ptr);
+		goto done;
+	}
+
+	addr = (unsigned long)range_mapping->ptr;
+	end = addr + range_mapping->size;
+	pr_debug("ASI %p: UNMAP %px/%lx/%d\n", asi, ptr,
+		 range_mapping->size, range_mapping->level);
+	asi_clear_pgd_range(asi, asi->pgd, addr, end, range_mapping->level);
+	list_del(&range_mapping->list);
+	kfree(range_mapping);
+done:
+	spin_unlock_irqrestore(&asi->lock, flags);
+}
+EXPORT_SYMBOL(asi_unmap);
-- 
1.7.1

