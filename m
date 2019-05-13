Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D975E1B8BB
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbfEMOlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:41:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33390 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729639AbfEMOlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:41:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd3QK194955;
        Mon, 13 May 2019 14:39:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=ivlXRYid08bCLk7EeeAFLog7R/4eiJfJ3h7LO8cUdeI=;
 b=z94gwv/h6a2eKxGWAbRUGkTU6KQJtXJ5d9W6ZAsILmq9BIFlV0LuM3OrSOh/UH7Pz5NG
 96qNkm9FPETMU1CK7gybTPwq+ay4+eI/5ZBk7+Q+y/kQOV/x7sjuvp8KNOiVPI3sWHJp
 aavXu55k8608Ik9cqQUYuPI190YDw9stqWSKV2ovjULIm12NLn2fEyPVAmeiTcuHgcon
 8059HBgFrgSpkKo1gDcIsSnBF1vNWz4rpcg52v7RzoR3yGYo4g+LLYhNJsd8LIgK7av1
 KVYEFQoIDdxdVwMIjw1yVhHummBBRuJpdrOk80g5n+iCI4jKYptxDL+3/5eTCqCqtgeN 4g== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7atx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:03 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQ8022780;
        Mon, 13 May 2019 14:38:53 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 05/27] KVM: x86: Add handler to exit kvm isolation
Date:   Mon, 13 May 2019 16:38:13 +0200
Message-Id: <1557758315-12667-6-git-send-email-alexandre.chartre@oracle.com>
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

From: Liran Alon <liran.alon@oracle.com>

Interrupt handlers will need this handler to switch from
the KVM address space back to the kernel address space
on their prelog.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/irq.h |    1 +
 arch/x86/kernel/irq.c      |   11 +++++++++++
 arch/x86/kvm/isolation.c   |   13 +++++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 8f95686..eb32abc 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -29,6 +29,7 @@ static inline int irq_canonicalize(int irq)
 extern __visible void smp_kvm_posted_intr_ipi(struct pt_regs *regs);
 extern __visible void smp_kvm_posted_intr_wakeup_ipi(struct pt_regs *regs);
 extern __visible void smp_kvm_posted_intr_nested_ipi(struct pt_regs *regs);
+extern void kvm_set_isolation_exit_handler(void (*handler)(void));
 #endif
 
 extern void (*x86_platform_ipi_callback)(void);
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 59b5f2e..e68483b 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -295,6 +295,17 @@ void kvm_set_posted_intr_wakeup_handler(void (*handler)(void))
 }
 EXPORT_SYMBOL_GPL(kvm_set_posted_intr_wakeup_handler);
 
+void (*kvm_isolation_exit_handler)(void) = dummy_handler;
+
+void kvm_set_isolation_exit_handler(void (*handler)(void))
+{
+	if (handler)
+		kvm_isolation_exit_handler = handler;
+	else
+		kvm_isolation_exit_handler = dummy_handler;
+}
+EXPORT_SYMBOL_GPL(kvm_set_isolation_exit_handler);
+
 /*
  * Handler for POSTED_INTERRUPT_VECTOR.
  */
diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index 35aa659..22ff9c2 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -5,6 +5,7 @@
  * KVM Address Space Isolation
  */
 
+#include <linux/kvm_host.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/printk.h>
@@ -95,6 +96,16 @@ static void kvm_isolation_uninit_mm(void)
 	free_pages((unsigned long)kvm_pgd, PGD_ALLOCATION_ORDER);
 }
 
+static void kvm_isolation_set_handlers(void)
+{
+	kvm_set_isolation_exit_handler(kvm_isolation_exit);
+}
+
+static void kvm_isolation_clear_handlers(void)
+{
+	kvm_set_isolation_exit_handler(NULL);
+}
+
 int kvm_isolation_init(void)
 {
 	int r;
@@ -106,6 +117,7 @@ int kvm_isolation_init(void)
 	if (r)
 		return r;
 
+	kvm_isolation_set_handlers();
 	pr_info("KVM: x86: Running with isolated address space\n");
 
 	return 0;
@@ -116,6 +128,7 @@ void kvm_isolation_uninit(void)
 	if (!address_space_isolation)
 		return;
 
+	kvm_isolation_clear_handlers();
 	kvm_isolation_uninit_mm();
 	pr_info("KVM: x86: End of isolated address space\n");
 }
-- 
1.7.1

