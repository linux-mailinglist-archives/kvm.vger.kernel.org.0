Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9601B888
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbfEMOkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:40:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37302 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730447AbfEMOkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:02 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd3jQ193102;
        Mon, 13 May 2019 14:39:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=5Qtz3s/XQzDItLwgII6a7yqyolD8+y7jKItUNNZ5jHw=;
 b=bc0UAXJuEUDdxvyu9LwCdXHqD4qh6pNojWMqcM9jSLBAxGM6igASeeKPL3IWePb5ch0s
 fbCFf/kSYwqFzCOuWD0pbNuB78gAyLFK5Ed4veTVvUvCkVI2DR43VeRRk0g9ufQAr0sw
 e6QhuGNeEnywPiXsoWdU2luDBNsmNNUqdcfqgUJyVy51fsmTOMsXHwAuC4cslhey/L9A
 UYFWoKFzlhctdRm9y9d9iC7Djqvsf9+FCNhU/NbXFxMpjmDvfMOaaoR1Y5lpKRNKz4fW
 VMMMFGBaxysR4n+y/P893dNcj5PpeJwOEyHs1Tnsryx4DvPOgcmS7i7F6ug4vAd8pZZL 3A== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfkxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:24 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQG022780;
        Mon, 13 May 2019 14:39:16 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 13/27] kvm/isolation: add KVM page table entry set functions
Date:   Mon, 13 May 2019 16:38:21 +0200
Message-Id: <1557758315-12667-14-git-send-email-alexandre.chartre@oracle.com>
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

Add wrappers around the page table entry (pgd/p4d/pud/pmd) set function
to check that an existing entry is not being overwritten.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index 6ec86df..b681e4f 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -342,6 +342,113 @@ static inline void kvm_p4d_free(struct mm_struct *mm, p4d_t *p4d)
 	return p4d;
 }
 
+/*
+ * kvm_set_pXX() functions are equivalent to kernel set_pXX() functions
+ * but, in addition, they ensure that they are not overwriting an already
+ * existing reference in the page table. Otherwise an error is returned.
+ *
+ * Note that this is not used for PTE because a PTE entry points to page
+ * frames containing the actual user data, and not to another entry in the
+ * page table. However this is used for PGD.
+ */
+
+static int kvm_set_pmd(pmd_t *pmd, pmd_t pmd_value)
+{
+#ifdef DEBUG
+	/*
+	 * The pmd pointer should come from kvm_pmd_alloc() or kvm_pmd_offset()
+	 * both of which check if the pointer is in the KVM page table. So this
+	 * is a paranoid check to ensure the pointer is really in the KVM page
+	 * table.
+	 */
+	if (!kvm_valid_pgt_entry(pmd)) {
+		pr_err("PMD %px is not in KVM page table\n", pmd);
+		return -EINVAL;
+	}
+#endif
+	if (pmd_val(*pmd) == pmd_val(pmd_value))
+		return 0;
+
+	if (!pmd_none(*pmd)) {
+		pr_err("PMD %px: overwriting %lx with %lx\n",
+		    pmd, pmd_val(*pmd), pmd_val(pmd_value));
+		return -EBUSY;
+	}
+
+	set_pmd(pmd, pmd_value);
+
+	return 0;
+}
+
+static int kvm_set_pud(pud_t *pud, pud_t pud_value)
+{
+#ifdef DEBUG
+	/*
+	 * The pud pointer should come from kvm_pud_alloc() or kvm_pud_offset()
+	 * both of which check if the pointer is in the KVM page table. So this
+	 * is a paranoid check to ensure the pointer is really in the KVM page
+	 * table.
+	 */
+	if (!kvm_valid_pgt_entry(pud)) {
+		pr_err("PUD %px is not in KVM page table\n", pud);
+		return -EINVAL;
+	}
+#endif
+	if (pud_val(*pud) == pud_val(pud_value))
+		return 0;
+
+	if (!pud_none(*pud)) {
+		pr_err("PUD %px: overwriting %lx\n", pud, pud_val(*pud));
+		return -EBUSY;
+	}
+
+	set_pud(pud, pud_value);
+
+	return 0;
+}
+
+static int kvm_set_p4d(p4d_t *p4d, p4d_t p4d_value)
+{
+#ifdef DEBUG
+	/*
+	 * The p4d pointer should come from kvm_p4d_alloc() or kvm_p4d_offset()
+	 * both of which check if the pointer is in the KVM page table. So this
+	 * is a paranoid check to ensure the pointer is really in the KVM page
+	 * table.
+	 */
+	if (!kvm_valid_pgt_entry(p4d)) {
+		pr_err("P4D %px is not in KVM page table\n", p4d);
+		return -EINVAL;
+	}
+#endif
+	if (p4d_val(*p4d) == p4d_val(p4d_value))
+		return 0;
+
+	if (!p4d_none(*p4d)) {
+		pr_err("P4D %px: overwriting %lx\n", p4d, p4d_val(*p4d));
+		return -EBUSY;
+	}
+
+	set_p4d(p4d, p4d_value);
+
+	return 0;
+}
+
+static int kvm_set_pgd(pgd_t *pgd, pgd_t pgd_value)
+{
+	if (pgd_val(*pgd) == pgd_val(pgd_value))
+		return 0;
+
+	if (!pgd_none(*pgd)) {
+		pr_err("PGD %px: overwriting %lx\n", pgd, pgd_val(*pgd));
+		return -EBUSY;
+	}
+
+	set_pgd(pgd, pgd_value);
+
+	return 0;
+}
+
 
 static int kvm_isolation_init_mm(void)
 {
-- 
1.7.1

