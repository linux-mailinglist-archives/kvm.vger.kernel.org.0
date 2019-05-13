Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70A561B8B8
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbfEMOld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:41:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730424AbfEMOkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd2pd194892;
        Mon, 13 May 2019 14:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=HIfaAaJqDpQgZqOlqv93OYEN222yx/NWgo2RgdnE7Ys=;
 b=rJqFVfy/BraQo2VV+vTf4vEU8uKTxNMJYqNUMPJntKe3SPbYIqJswWfe8FSX9DOUDUvq
 NMeBPV/EFppUnPmGQYbDoMnmg/dC+wvoFJX/MAxWhRp9eR7c70Ir05eJ9ObgYhuTZIN0
 D6O2EwvBsR4WuKaiukLz+63YyUEe8qIjPm7QE5ehY3t9v0MmShxoS6X2fFxg5nPXKcjD
 5e42nLFl9jyGEOT3WQUgTW0ZEa0BSwnYUeiOjo0jQFfif/6jx2982K9zu7DiWOea0CSj
 W4Xl7iGJz5g3uHt6WP7akNTkktkKiod+MAJFVIj50sV+mpTRrNCEYkdwKX02CtXlEBbR ag== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7aws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:23 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQH022780;
        Mon, 13 May 2019 14:39:19 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 14/27] kvm/isolation: functions to copy page table entries for a VA range
Date:   Mon, 13 May 2019 16:38:22 +0200
Message-Id: <1557758315-12667-15-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These functions are based on the copy_pxx_range() functions defined in
mm/memory.c. The main difference is that a level parameter is specified
to indicate the page table level (PGD, P4D, PUD PMD, PTE) at which the
copy should be done. Also functions don't use a vma parameter, and
don't alter the source page table even if an entry is bad.

Also kvm_copy_pte_range() can be called with a non page-aligned buffer,
so the buffer should be aligned with the page start so that the entire
buffer is mapped if the end of buffer crosses a page.

These functions will be used to populate the KVM page table.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |  229 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/isolation.h |    1 +
 2 files changed, 230 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index b681e4f..4f1b511 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -450,6 +450,235 @@ static int kvm_set_pgd(pgd_t *pgd, pgd_t pgd_value)
 }
 
 
+static int kvm_copy_pte_range(struct mm_struct *dst_mm,
+			      struct mm_struct *src_mm, pmd_t *dst_pmd,
+			      pmd_t *src_pmd, unsigned long addr,
+			      unsigned long end)
+{
+	pte_t *src_pte, *dst_pte;
+
+	dst_pte = kvm_pte_alloc(dst_mm, dst_pmd, addr);
+	if (IS_ERR(dst_pte))
+		return PTR_ERR(dst_pte);
+
+	addr &= PAGE_MASK;
+	src_pte = pte_offset_map(src_pmd, addr);
+
+	do {
+		pr_debug("PTE: %lx/%lx set[%lx] = %lx\n",
+		    addr, addr + PAGE_SIZE, (long)dst_pte, pte_val(*src_pte));
+		set_pte_at(dst_mm, addr, dst_pte, *src_pte);
+
+	} while (dst_pte++, src_pte++, addr += PAGE_SIZE, addr < end);
+
+	return 0;
+}
+
+static int kvm_copy_pmd_range(struct mm_struct *dst_mm,
+			      struct mm_struct *src_mm,
+			      pud_t *dst_pud, pud_t *src_pud,
+			      unsigned long addr, unsigned long end,
+			      enum page_table_level level)
+{
+	pmd_t *src_pmd, *dst_pmd;
+	unsigned long next;
+	int err;
+
+	dst_pmd = kvm_pmd_alloc(dst_mm, dst_pud, addr);
+	if (IS_ERR(dst_pmd))
+		return PTR_ERR(dst_pmd);
+
+	src_pmd = pmd_offset(src_pud, addr);
+
+	do {
+		next = pmd_addr_end(addr, end);
+		if (level == PGT_LEVEL_PMD || pmd_none(*src_pmd)) {
+			pr_debug("PMD: %lx/%lx set[%lx] = %lx\n",
+			    addr, next, (long)dst_pmd, pmd_val(*src_pmd));
+			err = kvm_set_pmd(dst_pmd, *src_pmd);
+			if (err)
+				return err;
+			continue;
+		}
+
+		if (!pmd_present(*src_pmd)) {
+			pr_warn("PMD: not present for [%lx,%lx]\n",
+			    addr, next - 1);
+			pmd_clear(dst_pmd);
+			continue;
+		}
+
+		if (pmd_trans_huge(*src_pmd) || pmd_devmap(*src_pmd)) {
+			pr_debug("PMD: %lx/%lx set[%lx] = %lx (huge/devmap)\n",
+			    addr, next, (long)dst_pmd, pmd_val(*src_pmd));
+			err = kvm_set_pmd(dst_pmd, *src_pmd);
+			if  (err)
+				return err;
+			continue;
+		}
+
+		err = kvm_copy_pte_range(dst_mm, src_mm, dst_pmd, src_pmd,
+					addr, next);
+		if (err) {
+			pr_err("PMD: ERR PTE addr=%lx next=%lx\n", addr, next);
+			return err;
+		}
+
+	} while (dst_pmd++, src_pmd++, addr = next, addr < end);
+
+	return 0;
+}
+
+static int kvm_copy_pud_range(struct mm_struct *dst_mm,
+			      struct mm_struct *src_mm,
+			      p4d_t *dst_p4d, p4d_t *src_p4d,
+			      unsigned long addr, unsigned long end,
+			      enum page_table_level level)
+{
+	pud_t *src_pud, *dst_pud;
+	unsigned long next;
+	int err;
+
+	dst_pud = kvm_pud_alloc(dst_mm, dst_p4d, addr);
+	if (IS_ERR(dst_pud))
+		return PTR_ERR(dst_pud);
+
+	src_pud = pud_offset(src_p4d, addr);
+
+	do {
+		next = pud_addr_end(addr, end);
+		if (level == PGT_LEVEL_PUD || pud_none(*src_pud)) {
+			pr_debug("PUD: %lx/%lx set[%lx] = %lx\n",
+			    addr, next, (long)dst_pud, pud_val(*src_pud));
+			err = kvm_set_pud(dst_pud, *src_pud);
+			if (err)
+				return err;
+			continue;
+		}
+
+		if (pud_trans_huge(*src_pud) || pud_devmap(*src_pud)) {
+			pr_debug("PUD: %lx/%lx set[%lx] = %lx (huge/devmap)\n",
+			    addr, next, (long)dst_pud, pud_val(*src_pud));
+			err = kvm_set_pud(dst_pud, *src_pud);
+			if (err)
+				return err;
+			continue;
+		}
+
+		err = kvm_copy_pmd_range(dst_mm, src_mm, dst_pud, src_pud,
+					addr, next, level);
+		if (err) {
+			pr_err("PUD: ERR PMD addr=%lx next=%lx\n", addr, next);
+			return err;
+		}
+
+	} while (dst_pud++, src_pud++, addr = next, addr < end);
+
+	return 0;
+}
+
+static int kvm_copy_p4d_range(struct mm_struct *dst_mm,
+				struct mm_struct *src_mm,
+				pgd_t *dst_pgd, pgd_t *src_pgd,
+				unsigned long addr, unsigned long end,
+				enum page_table_level level)
+{
+	p4d_t *src_p4d, *dst_p4d;
+	unsigned long next;
+	int err;
+
+	dst_p4d = kvm_p4d_alloc(dst_mm, dst_pgd, addr);
+	if (IS_ERR(dst_p4d))
+		return PTR_ERR(dst_p4d);
+
+	src_p4d = p4d_offset(src_pgd, addr);
+
+	do {
+		next = p4d_addr_end(addr, end);
+		if (level == PGT_LEVEL_P4D || p4d_none(*src_p4d)) {
+			pr_debug("P4D: %lx/%lx set[%lx] = %lx\n",
+			    addr, next, (long)dst_p4d, p4d_val(*src_p4d));
+
+			err = kvm_set_p4d(dst_p4d, *src_p4d);
+			if (err)
+				return err;
+			continue;
+		}
+
+		err = kvm_copy_pud_range(dst_mm, src_mm, dst_p4d, src_p4d,
+					addr, next, level);
+		if (err) {
+			pr_err("P4D: ERR PUD addr=%lx next=%lx\n", addr, next);
+			return err;
+		}
+
+	} while (dst_p4d++, src_p4d++, addr = next, addr < end);
+
+	return 0;
+}
+
+static int kvm_copy_pgd_range(struct mm_struct *dst_mm,
+				struct mm_struct *src_mm, unsigned long addr,
+				unsigned long end, enum page_table_level level)
+{
+	pgd_t *src_pgd, *dst_pgd;
+	unsigned long next;
+	int err;
+
+	dst_pgd = pgd_offset(dst_mm, addr);
+	src_pgd = pgd_offset(src_mm, addr);
+
+	do {
+		next = pgd_addr_end(addr, end);
+		if (level == PGT_LEVEL_PGD || pgd_none(*src_pgd)) {
+			pr_debug("PGD: %lx/%lx set[%lx] = %lx\n",
+			    addr, next, (long)dst_pgd, pgd_val(*src_pgd));
+			err = kvm_set_pgd(dst_pgd, *src_pgd);
+			if (err)
+				return err;
+			continue;
+		}
+
+		err = kvm_copy_p4d_range(dst_mm, src_mm, dst_pgd, src_pgd,
+					addr, next, level);
+		if (err) {
+			pr_err("PGD: ERR P4D addr=%lx next=%lx\n", addr, next);
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
+ * kernel page table) to the KVM page table. The level parameter specifies
+ * the page table level (PGD, P4D, PUD PMD, PTE) at which the copy should
+ * be done.
+ */
+static int kvm_copy_mapping(void *ptr, size_t size, enum page_table_level level)
+{
+	unsigned long addr = (unsigned long)ptr;
+	unsigned long end = addr + ((unsigned long)size);
+
+	BUG_ON(current->mm == &kvm_mm);
+	pr_debug("KERNMAP COPY addr=%px size=%lx\n", ptr, size);
+	return kvm_copy_pgd_range(&kvm_mm, current->mm, addr, end, level);
+}
+
+
+/*
+ * Copy page table PTE entries from the current page table to the KVM
+ * page table.
+ */
+int kvm_copy_ptes(void *ptr, unsigned long size)
+{
+	return kvm_copy_mapping(ptr, size, PGT_LEVEL_PTE);
+}
+EXPORT_SYMBOL(kvm_copy_ptes);
+
+
 static int kvm_isolation_init_mm(void)
 {
 	pgd_t *kvm_pgd;
diff --git a/arch/x86/kvm/isolation.h b/arch/x86/kvm/isolation.h
index aa5e979..e8c018a 100644
--- a/arch/x86/kvm/isolation.h
+++ b/arch/x86/kvm/isolation.h
@@ -16,5 +16,6 @@ static inline bool kvm_isolation(void)
 extern void kvm_isolation_enter(void);
 extern void kvm_isolation_exit(void);
 extern void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu);
+extern int kvm_copy_ptes(void *ptr, unsigned long size);
 
 #endif
-- 
1.7.1

