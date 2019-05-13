Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8002D1B885
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbfEMOjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:39:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59466 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730320AbfEMOjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd4lg195008;
        Mon, 13 May 2019 14:39:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=gIeFN0ziPc52a8KLvMF4BYUuKgdMORhtc90dfJFFcK8=;
 b=hG+EotkwfW0afgyQ6GQFcjNoUZvzVSUEOYaoXlfVoV2cUsog6OXPvWLhJn7Oel/wqLNU
 q93k3vhzcUlchxQbCpQ1datYttq5bU2CVnCcfgAzotf47Y8hQH+8rBgoN2OmMBnGwcKO
 LEQEsJMpMtvD5hREw/USDtI1pRBmvG/plElU+Xrot/aCMJUcLyH6vUNMyX9iYSD4MPrI
 Y0R0Lk4RBx9aTbJnKTE11caIJKBYXFjCKw9NZy0zBsZERP6ZtLnDVZy0YizHnM93iBtI
 eV66j3vQdt+zdewHBfSeob4gdmSsVVx7BhZaz3q+MBojcv1hUk06rRc6rPcuwhVdDGFV rg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7avt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:14 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQE022780;
        Mon, 13 May 2019 14:39:11 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 11/27] kvm/isolation: add KVM page table entry offset functions
Date:   Mon, 13 May 2019 16:38:19 +0200
Message-Id: <1557758315-12667-12-git-send-email-alexandre.chartre@oracle.com>
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

These functions are wrappers are the p4d/pud/pmd/pte offset functions
which ensure that page table pointers are in the KVM page table.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index 61df750..b29a09b 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -162,6 +162,67 @@ static bool kvm_valid_pgt_entry(void *ptr)
 }
 
 /*
+ * kvm_pXX_offset() functions are equivalent to kernel pXX_offset()
+ * functions but, in addition, they ensure that page table pointers
+ * are in the KVM page table. Otherwise an error is returned.
+ */
+
+static pte_t *kvm_pte_offset(pmd_t *pmd, unsigned long addr)
+{
+	pte_t *pte;
+
+	pte = pte_offset_map(pmd, addr);
+	if (!kvm_valid_pgt_entry(pte)) {
+		pr_err("PTE %px is not in KVM page table\n", pte);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return pte;
+}
+
+static pmd_t *kvm_pmd_offset(pud_t *pud, unsigned long addr)
+{
+	pmd_t *pmd;
+
+	pmd = pmd_offset(pud, addr);
+	if (!kvm_valid_pgt_entry(pmd)) {
+		pr_err("PMD %px is not in KVM page table\n", pmd);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return pmd;
+}
+
+static pud_t *kvm_pud_offset(p4d_t *p4d, unsigned long addr)
+{
+	pud_t *pud;
+
+	pud = pud_offset(p4d, addr);
+	if (!kvm_valid_pgt_entry(pud)) {
+		pr_err("PUD %px is not in KVM page table\n", pud);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return pud;
+}
+
+static p4d_t *kvm_p4d_offset(pgd_t *pgd, unsigned long addr)
+{
+	p4d_t *p4d;
+
+	p4d = p4d_offset(pgd, addr);
+	/*
+	 * p4d is the same has pgd if we don't have a 5-level page table.
+	 */
+	if ((p4d != (p4d_t *)pgd) && !kvm_valid_pgt_entry(p4d)) {
+		pr_err("P4D %px is not in KVM page table\n", p4d);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return p4d;
+}
+
+/*
  * kvm_pXX_free() functions are equivalent to kernel pXX_free()
  * functions but they can be used with any PXX pointer in the
  * directory.
-- 
1.7.1

