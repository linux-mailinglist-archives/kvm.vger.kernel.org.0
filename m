Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A9F1B8A7
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbfEMOkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:40:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37252 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730420AbfEMOkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd28F193025;
        Mon, 13 May 2019 14:39:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=3oQZsnmQ7NshrUK5gBFOiQdwJCmvyMk7rTDgLZ4eiR8=;
 b=cackC5e/rN14Atf5QlnsuYve24xrmHKk5OAv4LozaAp9vhiUL7E7xPH3kbnOM8VYLH+M
 qQZDMDajYAWzXDX4pYfxSi/cFR9+miTzGtpQvwsGANTuO936Hac7155wikox7cO9zHM6
 D6VSW0wFlH4kS9hhjEHDuhBzZL61Y1YPaaQ9QapuqevDj5phnii9KR4rMc6oFyvj+0cK
 chnwMcSACXVNjOAa1xqmZO14HcVVu9E4v0xi+ZQhdjbaq/Q1oelYLJg/hz12bN7CBmtg
 1H1C0ZDiqvGmCSUtMdjVlrxOudApkaffggciBhogmTfWK5aks2i24a2IdgYkJ3LSxlPk OA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfkwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:16 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQF022780;
        Mon, 13 May 2019 14:39:13 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 12/27] kvm/isolation: add KVM page table entry allocation functions
Date:   Mon, 13 May 2019 16:38:20 +0200
Message-Id: <1557758315-12667-13-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These functions allocate p4d/pud/pmd/pte pages and ensure that
pages are in the KVM page table.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index b29a09b..6ec86df 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -248,6 +248,100 @@ static inline void kvm_p4d_free(struct mm_struct *mm, p4d_t *p4d)
 	p4d_free(mm, PGTD_ALIGN(p4d));
 }
 
+/*
+ * kvm_pXX_alloc() functions are equivalent to kernel pXX_alloc()
+ * functions but, in addition, they ensure that page table pointers
+ * are in the KVM page table. Otherwise an error is returned.
+ */
+
+static pte_t *kvm_pte_alloc(struct mm_struct *mm, pmd_t *pmd,
+			    unsigned long addr)
+{
+	pte_t *pte;
+
+	if (pmd_none(*pmd)) {
+		pte = pte_alloc_kernel(pmd, addr);
+		if (!pte) {
+			pr_debug("PTE: ERR ALLOC\n");
+			return ERR_PTR(-ENOMEM);
+		}
+		if (!kvm_add_pgt_directory(pte, PGT_LEVEL_PTE)) {
+			kvm_pte_free(mm, pte);
+			return ERR_PTR(-EINVAL);
+		}
+	} else {
+		pte = kvm_pte_offset(pmd, addr);
+	}
+
+	return pte;
+}
+
+static pmd_t *kvm_pmd_alloc(struct mm_struct *mm, pud_t *pud,
+			    unsigned long addr)
+{
+	pmd_t *pmd;
+
+	if (pud_none(*pud)) {
+		pmd = pmd_alloc(mm, pud, addr);
+		if (!pmd) {
+			pr_debug("PMD: ERR ALLOC\n");
+			return ERR_PTR(-ENOMEM);
+		}
+		if (!kvm_add_pgt_directory(pmd, PGT_LEVEL_PMD)) {
+			kvm_pmd_free(mm, pmd);
+			return ERR_PTR(-EINVAL);
+		}
+	} else {
+		pmd = kvm_pmd_offset(pud, addr);
+	}
+
+	return pmd;
+}
+
+static pud_t *kvm_pud_alloc(struct mm_struct *mm, p4d_t *p4d,
+			    unsigned long addr)
+{
+	pud_t *pud;
+
+	if (p4d_none(*p4d)) {
+		pud = pud_alloc(mm, p4d, addr);
+		if (!pud) {
+			pr_debug("PUD: ERR ALLOC\n");
+			return ERR_PTR(-ENOMEM);
+		}
+		if (!kvm_add_pgt_directory(pud, PGT_LEVEL_PUD)) {
+			kvm_pud_free(mm, pud);
+			return ERR_PTR(-EINVAL);
+		}
+	} else {
+		pud = kvm_pud_offset(p4d, addr);
+	}
+
+	return pud;
+}
+
+static p4d_t *kvm_p4d_alloc(struct mm_struct *mm, pgd_t *pgd,
+			    unsigned long addr)
+{
+	p4d_t *p4d;
+
+	if (pgd_none(*pgd)) {
+		p4d = p4d_alloc(mm, pgd, addr);
+		if (!p4d) {
+			pr_debug("P4D: ERR ALLOC\n");
+			return ERR_PTR(-ENOMEM);
+		}
+		if (!kvm_add_pgt_directory(p4d, PGT_LEVEL_P4D)) {
+			kvm_p4d_free(mm, p4d);
+			return ERR_PTR(-EINVAL);
+		}
+	} else {
+		p4d = kvm_p4d_offset(pgd, addr);
+	}
+
+	return p4d;
+}
+
 
 static int kvm_isolation_init_mm(void)
 {
-- 
1.7.1

