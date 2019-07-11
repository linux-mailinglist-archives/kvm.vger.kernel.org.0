Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454AD658FA
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfGKO1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:27:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41778 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbfGKO1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO7tr013226;
        Thu, 11 Jul 2019 14:26:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=385wpu4NDusZzlrvO4wdMoGEKubdnUYw4N6zqr4muDU=;
 b=j/8IHCr9S0gUaWnFi3Upjzuz55gy9Ljh6nfaWePnOoytFJ9B7SnJKULz74C3ywY6RXqi
 e2nlqVa9W7MNYSdP2Vf2C/oYboYtNcwS8EW9VbU8cIsaN6Fl9HN5Irx/xBWUPbwuO3Rb
 pA8nC/jt3qZSlX5P9mWE6i1BavyZZ35GVGnmvivmjOvqS8a8/Z0v3tfm2TkPowKHagRD
 jG7N8dpzCgLK0VRzFa0NpGxGayMyo+vj0XV5/GWaoX6BlSffhi7TdWAzW0NBMvhvqMgW
 Mi7BkTLlSEZlEqWrGTNR/OK6j6uUWeCyQ/O4mFUX/8vA2YAylUPyhsIeKxT9HDn0UNu4 +A== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2tjm9r0bn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:09 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcu0021444;
        Thu, 11 Jul 2019 14:26:06 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 07/26] mm/asi: Add ASI page-table entry set functions
Date:   Thu, 11 Jul 2019 16:25:19 +0200
Message-Id: <1562855138-19507-8-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add wrappers around the page table entry (pgd/p4d/pud/pmd) set
functions which check that an existing entry is not being
overwritten.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/mm/asi_pagetable.c |  124 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index 0fc6d59..e17af9e 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -270,3 +270,127 @@ static bool asi_valid_offset(struct asi *asi, void *offset)
 
 	return p4d;
 }
+
+/*
+ * asi_set_pXX() functions are equivalent to kernel set_pXX() functions
+ * but, in addition, they ensure that they are not overwriting an already
+ * existing reference in the page table. Otherwise an error is returned.
+ */
+static int asi_set_pte(struct asi *asi, pte_t *pte, pte_t pte_value)
+{
+#ifdef DEBUG
+	/*
+	 * The pte pointer should come from asi_pte_alloc() or asi_pte_offset()
+	 * both of which check if the pointer is in the kernel isolation page
+	 * table. So this is a paranoid check to ensure the pointer is really
+	 * in the kernel page table.
+	 */
+	if (!asi_valid_offset(asi, pte)) {
+		pr_err("ASI %p: PTE %px not found\n", asi, pte);
+		return -EINVAL;
+	}
+#endif
+	set_pte(pte, pte_value);
+
+	return 0;
+}
+
+static int asi_set_pmd(struct asi *asi, pmd_t *pmd, pmd_t pmd_value)
+{
+#ifdef DEBUG
+	/*
+	 * The pmd pointer should come from asi_pmd_alloc() or asi_pmd_offset()
+	 * both of which check if the pointer is in the kernel isolation page
+	 * table. So this is a paranoid check to ensure the pointer is really
+	 * in the kernel page table.
+	 */
+	if (!asi_valid_offset(asi, pmd)) {
+		pr_err("ASI %p: PMD %px not found\n", asi, pmd);
+		return -EINVAL;
+	}
+#endif
+	if (pmd_val(*pmd) == pmd_val(pmd_value))
+		return 0;
+
+	if (!pmd_none(*pmd)) {
+		pr_err("ASI %p: PMD %px overwriting %lx with %lx\n",
+		       asi, pmd, pmd_val(*pmd), pmd_val(pmd_value));
+		return -EBUSY;
+	}
+
+	set_pmd(pmd, pmd_value);
+
+	return 0;
+}
+
+static int asi_set_pud(struct asi *asi, pud_t *pud, pud_t pud_value)
+{
+#ifdef DEBUG
+	/*
+	 * The pud pointer should come from asi_pud_alloc() or asi_pud_offset()
+	 * both of which check if the pointer is in the kernel isolation page
+	 * table. So this is a paranoid check to ensure the pointer is really
+	 * in the kernel page table.
+	 */
+	if (!asi_valid_offset(asi, pud)) {
+		pr_err("ASI %p: PUD %px not found\n", asi, pud);
+		return -EINVAL;
+	}
+#endif
+	if (pud_val(*pud) == pud_val(pud_value))
+		return 0;
+
+	if (!pud_none(*pud)) {
+		pr_err("ASI %p: PUD %px overwriting %lx with %lx\n",
+		       asi, pud, pud_val(*pud), pud_val(pud_value));
+		return -EBUSY;
+	}
+
+	set_pud(pud, pud_value);
+
+	return 0;
+}
+
+static int asi_set_p4d(struct asi *asi, p4d_t *p4d, p4d_t p4d_value)
+{
+#ifdef DEBUG
+	/*
+	 * The p4d pointer should come from asi_p4d_alloc() or asi_p4d_offset()
+	 * both of which check if the pointer is in the kernel isolation page
+	 * table. So this is a paranoid check to ensure the pointer is really
+	 * in the kernel page table.
+	 */
+	if (!asi_valid_offset(asi, p4d)) {
+		pr_err("ASI %p: P4D %px not found\n", asi, p4d);
+		return -EINVAL;
+	}
+#endif
+	if (p4d_val(*p4d) == p4d_val(p4d_value))
+		return 0;
+
+	if (!p4d_none(*p4d)) {
+		pr_err("ASI %p: P4D %px overwriting %lx with %lx\n",
+		       asi, p4d, p4d_val(*p4d), p4d_val(p4d_value));
+		return -EBUSY;
+	}
+
+	set_p4d(p4d, p4d_value);
+
+	return 0;
+}
+
+static int asi_set_pgd(struct asi *asi, pgd_t *pgd, pgd_t pgd_value)
+{
+	if (pgd_val(*pgd) == pgd_val(pgd_value))
+		return 0;
+
+	if (!pgd_none(*pgd)) {
+		pr_err("ASI %p: PGD %px overwriting %lx with %lx\n",
+		       asi, pgd, pgd_val(*pgd), pgd_val(pgd_value));
+		return -EBUSY;
+	}
+
+	set_pgd(pgd, pgd_value);
+
+	return 0;
+}
-- 
1.7.1

