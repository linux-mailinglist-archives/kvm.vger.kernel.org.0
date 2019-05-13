Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CAC1B87C
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbfEMOj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:39:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbfEMOj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DESuQq184844;
        Mon, 13 May 2019 14:38:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=N+bhv6OONCtHadzhgbU1e3MAiku0pVi0en6iW2c0TrE=;
 b=P2E6fPrVnhroaq8muel0nn2IGVthj4KsZusNGeNWJzt9GowNKpeWiTFc/b69anfJ0Jmu
 oveuhNt89Ikw71ZvGW5vaL++kydq+j4PLd4quL0ofYa2FFOqRahZ4/VLfHaGhpQ4vHLA
 m5ceIwPWsPji5If/gseVw1NXQQCm7CUpEO9gRgNKuigMbubyHEiBRLZ2oXHfdXvE5+yg
 4Vxc4Q0CWq9Ih+MZt7QCjMIpS8BEJfgPaEsyU1ULUJzIGUT76jHo7eJhX4dTAjgX0kjG
 sJYESl+2wGBWqLkwymFi6MuDOCTCpC/bVqNxgtfnEiuBaKSkXU7jAwqSWP/dnuQqoRnn 9A== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7as5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:38:56 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQ6022780;
        Mon, 13 May 2019 14:38:47 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 03/27] KVM: x86: Introduce KVM separate virtual address space
Date:   Mon, 13 May 2019 16:38:11 +0200
Message-Id: <1557758315-12667-4-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

Create a separate mm for KVM that will be active when KVM #VMExit
handlers run. Up until the point which we architectully need to
access host (or other VM) sensitive data.

This patch just create kvm_mm but never makes it active yet.
This will be done by next commits.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   95 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/isolation.h |    8 ++++
 arch/x86/kvm/x86.c       |   10 ++++-
 3 files changed, 112 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kvm/isolation.h

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index e25f663..74bc0cd 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -7,6 +7,21 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/printk.h>
+
+#include <asm/mmu_context.h>
+#include <asm/pgalloc.h>
+
+#include "isolation.h"
+
+struct mm_struct kvm_mm = {
+	.mm_rb			= RB_ROOT,
+	.mm_users		= ATOMIC_INIT(2),
+	.mm_count		= ATOMIC_INIT(1),
+	.mmap_sem		= __RWSEM_INITIALIZER(kvm_mm.mmap_sem),
+	.page_table_lock	= __SPIN_LOCK_UNLOCKED(kvm_mm.page_table_lock),
+	.mmlist			= LIST_HEAD_INIT(kvm_mm.mmlist),
+};
 
 /*
  * When set to true, KVM #VMExit handlers run in isolated address space
@@ -24,3 +39,83 @@
  */
 static bool __read_mostly address_space_isolation;
 module_param(address_space_isolation, bool, 0444);
+
+static int kvm_isolation_init_mm(void)
+{
+	pgd_t *kvm_pgd;
+	gfp_t gfp_mask;
+
+	gfp_mask = GFP_KERNEL | __GFP_ZERO;
+	kvm_pgd = (pgd_t *)__get_free_pages(gfp_mask, PGD_ALLOCATION_ORDER);
+	if (!kvm_pgd)
+		return -ENOMEM;
+
+#ifdef CONFIG_PAGE_TABLE_ISOLATION
+	/*
+	 * With PTI, we have two PGDs: one the kernel page table, and one
+	 * for the user page table. The PGD with the kernel page table has
+	 * to be the entire kernel address space because paranoid faults
+	 * will unconditionally use it. So we define the KVM address space
+	 * in the user table space, although it will be used in the kernel.
+	 */
+
+	/* initialize the kernel page table */
+	memcpy(kvm_pgd, current->active_mm->pgd, sizeof(pgd_t) * PTRS_PER_PGD);
+
+	/* define kvm_mm with the user page table */
+	kvm_mm.pgd = kernel_to_user_pgdp(kvm_pgd);
+#else /* CONFIG_PAGE_TABLE_ISOLATION */
+	kvm_mm.pgd = kvm_pgd;
+#endif /* CONFIG_PAGE_TABLE_ISOLATION */
+	mm_init_cpumask(&kvm_mm);
+	init_new_context(NULL, &kvm_mm);
+
+	return 0;
+}
+
+static void kvm_isolation_uninit_mm(void)
+{
+	pgd_t *kvm_pgd;
+
+	BUG_ON(current->active_mm == &kvm_mm);
+
+	destroy_context(&kvm_mm);
+
+#ifdef CONFIG_PAGE_TABLE_ISOLATION
+	/*
+	 * With PTI, the KVM address space is defined in the user
+	 * page table space, but the full PGD starts with the kernel
+	 * page table space.
+	 */
+	kvm_pgd = user_to_kernel_pgdp(kvm_pgd);
+#else /* CONFIG_PAGE_TABLE_ISOLATION */
+	kvm_pgd = kvm_mm.pgd;
+#endif /* CONFIG_PAGE_TABLE_ISOLATION */
+	kvm_mm.pgd = NULL;
+	free_pages((unsigned long)kvm_pgd, PGD_ALLOCATION_ORDER);
+}
+
+int kvm_isolation_init(void)
+{
+	int r;
+
+	if (!address_space_isolation)
+		return 0;
+
+	r = kvm_isolation_init_mm();
+	if (r)
+		return r;
+
+	pr_info("KVM: x86: Running with isolated address space\n");
+
+	return 0;
+}
+
+void kvm_isolation_uninit(void)
+{
+	if (!address_space_isolation)
+		return;
+
+	kvm_isolation_uninit_mm();
+	pr_info("KVM: x86: End of isolated address space\n");
+}
diff --git a/arch/x86/kvm/isolation.h b/arch/x86/kvm/isolation.h
new file mode 100644
index 0000000..cf8c7d4
--- /dev/null
+++ b/arch/x86/kvm/isolation.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef ARCH_X86_KVM_ISOLATION_H
+#define ARCH_X86_KVM_ISOLATION_H
+
+extern int kvm_isolation_init(void);
+extern void kvm_isolation_uninit(void);
+
+#endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b5edc8e..4b7cec2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -29,6 +29,7 @@
 #include "cpuid.h"
 #include "pmu.h"
 #include "hyperv.h"
+#include "isolation.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -6972,10 +6973,14 @@ int kvm_arch_init(void *opaque)
 		goto out_free_x86_fpu_cache;
 	}
 
-	r = kvm_mmu_module_init();
+	r = kvm_isolation_init();
 	if (r)
 		goto out_free_percpu;
 
+	r = kvm_mmu_module_init();
+	if (r)
+		goto out_uninit_isolation;
+
 	kvm_set_mmio_spte_mask();
 
 	kvm_x86_ops = ops;
@@ -7000,6 +7005,8 @@ int kvm_arch_init(void *opaque)
 
 	return 0;
 
+out_uninit_isolation:
+	kvm_isolation_uninit();
 out_free_percpu:
 	free_percpu(shared_msrs);
 out_free_x86_fpu_cache:
@@ -7024,6 +7031,7 @@ void kvm_arch_exit(void)
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
 #endif
+	kvm_isolation_uninit();
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
 	free_percpu(shared_msrs);
-- 
1.7.1

