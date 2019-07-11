Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87AE658C3
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfGKO14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:27:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39610 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728807AbfGKO1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO7Xi100417;
        Thu, 11 Jul 2019 14:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=lCtyGi9lNXZNoOqW5lwUfawQTHm8Gs8rgqwuOoYVSXg=;
 b=lJAKdulhKeHbnYjRsyD5nMQD+gRQsuPOeXQdtSSCbufwUKXgsEfUN2Rz5GYHTyi0V/o7
 /7wfZKsgL4wiSMWTnhXm2xWq6UxcJMo9Wcw35HV4xUxxM34clQuAg7xvJmhbR4yOZmCW
 HtxhTH15oHUeFU7K6yML/HzF46ooAQ0oDiETifZF8/K0Eb+1V8sYTyAXh2PY56Cglqe0
 4to8Zt1JMHQxjc6IQGJB++dychz0/PvHCxVVbx1+c6+qGz1P2iNzE3+TWmWcb+jtnmaE
 8hDeydy1NGeaojoYQskyTsqpWzZDVRocAyhp4SKVywbNL71DbkjE7rT5ZK2hAsuvr/wq nA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2tjkkq0c74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:11 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPctx021444;
        Thu, 11 Jul 2019 14:26:02 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 06/26] mm/asi: Add ASI page-table entry allocation functions
Date:   Thu, 11 Jul 2019 16:25:18 +0200
Message-Id: <1562855138-19507-7-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add functions to allocate p4d/pud/pmd/pte pages for an ASI page-table
and keep track of them.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/mm/asi_pagetable.c |  111 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index a89e02e..0fc6d59 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -4,6 +4,8 @@
  *
  */
 
+#include <linux/mm.h>
+
 #include <asm/asi.h>
 
 /*
@@ -159,3 +161,112 @@ static bool asi_valid_offset(struct asi *asi, void *offset)
 
 	return p4d;
 }
+
+/*
+ * asi_pXX_alloc() functions are equivalent to kernel pXX_alloc() functions
+ * but, in addition, they keep track of new pages allocated for the specified
+ * ASI.
+ */
+
+static pte_t *asi_pte_alloc(struct asi *asi, pmd_t *pmd, unsigned long addr)
+{
+	struct page *page;
+	pte_t *pte;
+	int err;
+
+	if (pmd_none(*pmd)) {
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return ERR_PTR(-ENOMEM);
+		pte = (pte_t *)page_address(page);
+		err = asi_add_backend_page(asi, pte, PGT_LEVEL_PTE);
+		if (err) {
+			free_page((unsigned long)pte);
+			return ERR_PTR(err);
+		}
+		set_pmd_safe(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
+		pte = pte_offset_map(pmd, addr);
+	} else {
+		pte = asi_pte_offset(asi, pmd,  addr);
+	}
+
+	return pte;
+}
+
+static pmd_t *asi_pmd_alloc(struct asi *asi, pud_t *pud, unsigned long addr)
+{
+	struct page *page;
+	pmd_t *pmd;
+	int err;
+
+	if (pud_none(*pud)) {
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return ERR_PTR(-ENOMEM);
+		pmd = (pmd_t *)page_address(page);
+		err = asi_add_backend_page(asi, pmd, PGT_LEVEL_PMD);
+		if (err) {
+			free_page((unsigned long)pmd);
+			return ERR_PTR(err);
+		}
+		set_pud_safe(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+		pmd = pmd_offset(pud, addr);
+	} else {
+		pmd = asi_pmd_offset(asi, pud, addr);
+	}
+
+	return pmd;
+}
+
+static pud_t *asi_pud_alloc(struct asi *asi, p4d_t *p4d, unsigned long addr)
+{
+	struct page *page;
+	pud_t *pud;
+	int err;
+
+	if (p4d_none(*p4d)) {
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return ERR_PTR(-ENOMEM);
+		pud = (pud_t *)page_address(page);
+		err = asi_add_backend_page(asi, pud, PGT_LEVEL_PUD);
+		if (err) {
+			free_page((unsigned long)pud);
+			return ERR_PTR(err);
+		}
+		set_p4d_safe(p4d, __p4d(__pa(pud) | _KERNPG_TABLE));
+		pud = pud_offset(p4d, addr);
+	} else {
+		pud = asi_pud_offset(asi, p4d, addr);
+	}
+
+	return pud;
+}
+
+static p4d_t *asi_p4d_alloc(struct asi *asi, pgd_t *pgd, unsigned long addr)
+{
+	struct page *page;
+	p4d_t *p4d;
+	int err;
+
+	if (!pgtable_l5_enabled())
+		return (p4d_t *)pgd;
+
+	if (pgd_none(*pgd)) {
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return ERR_PTR(-ENOMEM);
+		p4d = (p4d_t *)page_address(page);
+		err = asi_add_backend_page(asi, p4d, PGT_LEVEL_P4D);
+		if (err) {
+			free_page((unsigned long)p4d);
+			return ERR_PTR(err);
+		}
+		set_pgd_safe(pgd, __pgd(__pa(p4d) | _KERNPG_TABLE));
+		p4d = p4d_offset(pgd, addr);
+	} else {
+		p4d = asi_p4d_offset(asi, pgd, addr);
+	}
+
+	return p4d;
+}
-- 
1.7.1

