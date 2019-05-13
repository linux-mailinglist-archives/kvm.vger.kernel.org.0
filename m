Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823861B8B4
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbfEMOjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:39:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbfEMOjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd84M195057;
        Mon, 13 May 2019 14:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=4cIDR6PZl2rutLAEYSA22jeItW1PJPdhgsRn6XGFWEA=;
 b=VC6jjd4Q/95/JOy5PgCZ8AdKsMFlE4fQCQOC2dyJBtX/9iwCN4mgh4f7m5XZlJT41CUT
 CWiyU1PZYsAhyoP4PcbGhS++vcss56Xjgewi7dXzHWILBy4ssid7xPlSLghegxyz3MzM
 lRsyU6oTrYGTNnLa5CF5DZEESUPecwfArax8wnk/8fA+g1/lxpeUfKmiNGTDKimHFL0k
 BUWpMG9d2DNNstgdU8bqlCEnHiwjnEh1BuYVAwNxdf4+s9KmtLq6O/FzAGHQaEbNfMUf
 6YUvBPOPUK+XTc5r2FauxEIQJUNK5TtoYUDMw6GnP5h/kShdnJWw0oXvReVp36peQCHR rw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7avk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:11 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQD022780;
        Mon, 13 May 2019 14:39:08 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 10/27] kvm/isolation: add KVM page table entry free functions
Date:   Mon, 13 May 2019 16:38:18 +0200
Message-Id: <1557758315-12667-11-git-send-email-alexandre.chartre@oracle.com>
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

These functions are wrappers around the p4d/pud/pmd/pte free function
which can be used with any pointer in the directory.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index 1efdab1..61df750 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -161,6 +161,32 @@ static bool kvm_valid_pgt_entry(void *ptr)
 
 }
 
+/*
+ * kvm_pXX_free() functions are equivalent to kernel pXX_free()
+ * functions but they can be used with any PXX pointer in the
+ * directory.
+ */
+
+static inline void kvm_pte_free(struct mm_struct *mm, pte_t *pte)
+{
+	pte_free_kernel(mm, PGTD_ALIGN(pte));
+}
+
+static inline void kvm_pmd_free(struct mm_struct *mm, pmd_t *pmd)
+{
+	pmd_free(mm, PGTD_ALIGN(pmd));
+}
+
+static inline void kvm_pud_free(struct mm_struct *mm, pud_t *pud)
+{
+	pud_free(mm, PGTD_ALIGN(pud));
+}
+
+static inline void kvm_p4d_free(struct mm_struct *mm, p4d_t *p4d)
+{
+	p4d_free(mm, PGTD_ALIGN(p4d));
+}
+
 
 static int kvm_isolation_init_mm(void)
 {
-- 
1.7.1

