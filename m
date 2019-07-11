Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2ED3658B8
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfGKO1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:27:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbfGKO1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOAv6001518;
        Thu, 11 Jul 2019 14:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=gEB6qC/xqft/fsE7GBzDnr3O7NBTUOw27/wZk4edBIk=;
 b=2lbqLqqQMw9uxcd2J0e8Od2Fbg4RGmN4xuVesYNv7Y1WX2picK7zuP05DlYEdlTfaf8/
 /r7nj8HLahdOMoTA2qZgo+/gfuMNT7Tq+4PK/S1hx7st0ER2GrN8SVMswbugTm+RisIK
 EY8L1gj7I42ax3Fxdef1h3ib61twTnbM35uhbRL7AAUoZFNDkEIoKv7I4NP1KhgZcU/R
 jZEVCuE/tyUKHROCoRyc1hZZuUr29PCD1HGeFsTbcm2+VPtYBpOACfriqJHm7UaHZUcG
 iSP2iP8CAbWrB5YbqwtuxyxbjJXj06/ciMakhxZ1tr5dVf0YbXkVnIwILeJB0axX/ioc dQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0dwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:08 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPctw021444;
        Thu, 11 Jul 2019 14:25:59 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 05/26] mm/asi: Add ASI page-table entry offset functions
Date:   Thu, 11 Jul 2019 16:25:17 +0200
Message-Id: <1562855138-19507-6-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add wrappers around the p4d/pud/pmd/pte offset kernel functions which
ensure that page-table pointers are in the specified ASI page-table.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/mm/asi_pagetable.c |   62 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index 7a8f791..a89e02e 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -97,3 +97,65 @@ static bool asi_valid_offset(struct asi *asi, void *offset)
 
 	return valid;
 }
+
+/*
+ * asi_pXX_offset() functions are equivalent to kernel pXX_offset()
+ * functions but, in addition, they ensure that page table pointers
+ * are in the kernel isolation page table. Otherwise an error is
+ * returned.
+ */
+
+static pte_t *asi_pte_offset(struct asi *asi, pmd_t *pmd, unsigned long addr)
+{
+	pte_t *pte;
+
+	pte = pte_offset_map(pmd, addr);
+	if (!asi_valid_offset(asi, pte)) {
+		pr_err("ASI %p: PTE %px not found\n", asi, pte);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return pte;
+}
+
+static pmd_t *asi_pmd_offset(struct asi *asi, pud_t *pud, unsigned long addr)
+{
+	pmd_t *pmd;
+
+	pmd = pmd_offset(pud, addr);
+	if (!asi_valid_offset(asi, pmd)) {
+		pr_err("ASI %p: PMD %px not found\n", asi, pmd);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return pmd;
+}
+
+static pud_t *asi_pud_offset(struct asi *asi, p4d_t *p4d, unsigned long addr)
+{
+	pud_t *pud;
+
+	pud = pud_offset(p4d, addr);
+	if (!asi_valid_offset(asi, pud)) {
+		pr_err("ASI %p: PUD %px not found\n", asi, pud);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return pud;
+}
+
+static p4d_t *asi_p4d_offset(struct asi *asi, pgd_t *pgd, unsigned long addr)
+{
+	p4d_t *p4d;
+
+	p4d = p4d_offset(pgd, addr);
+	/*
+	 * p4d is the same has pgd if we don't have a 5-level page table.
+	 */
+	if ((p4d != (p4d_t *)pgd) && !asi_valid_offset(asi, p4d)) {
+		pr_err("ASI %p: P4D %px not found\n", asi, p4d);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return p4d;
+}
-- 
1.7.1

