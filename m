Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B611B8C4
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfEMOmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:42:36 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36808 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbfEMOji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DESwxh183032;
        Mon, 13 May 2019 14:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=1/A8dPg6N3BCp1dVVHZldE7IkiS+8kPsjdwBuin2g4s=;
 b=IIHbvoJP5+K/6hJmjo6mwDCr+XYe5WkcmTj/jZgsHQd++1A3nrRugabuYhfepHXTNKMa
 V+W5LQ4oABEgMC2/bRAoDFfs1URTJrv1FkjV3nZfJhEh3aTydJM7O9zVMLE+XCLnCNo0
 mgaCYQLJsGwxxqQvTsOBwgrZT+TlGys5Y+xXj8Q2b2tjQKrJs5qkBiGxQsdVfxbT4cvm
 AvsvkAn4MmTs1z4WmXxi/1KuzDaA9HLi5wH7yN5hYhVDuggPf0x5mUO+bX8AKL3WJ1Pd
 Vh+iMejI0gUwJY+npXZCvzmO6WQnPg//1CrX7b7e8J9CRrNauyV7gxxNmcg6wsYTegjc qw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfksf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:38:50 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQ4022780;
        Mon, 13 May 2019 14:38:42 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 01/27] kernel: Export memory-management symbols required for KVM address space isolation
Date:   Mon, 13 May 2019 16:38:09 +0200
Message-Id: <1557758315-12667-2-git-send-email-alexandre.chartre@oracle.com>
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

Export symbols needed to create, manage, populate and switch
a mm from a kernel module (kvm in this case).

This is a hacky way for now to start.
This should be changed to some suitable memory-management API.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kernel/ldt.c |    1 +
 arch/x86/mm/tlb.c     |    3 ++-
 mm/memory.c           |    5 +++++
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index b2463fc..19a86e0 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -401,6 +401,7 @@ void destroy_context_ldt(struct mm_struct *mm)
 	free_ldt_struct(mm->context.ldt);
 	mm->context.ldt = NULL;
 }
+EXPORT_SYMBOL_GPL(destroy_context_ldt);
 
 void ldt_arch_exit_mmap(struct mm_struct *mm)
 {
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 7f61431..a4db7f5 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -70,7 +70,7 @@ static void clear_asid_other(void)
 }
 
 atomic64_t last_mm_ctx_id = ATOMIC64_INIT(1);
-
+EXPORT_SYMBOL_GPL(last_mm_ctx_id);
 
 static void choose_new_asid(struct mm_struct *next, u64 next_tlb_gen,
 			    u16 *new_asid, bool *need_flush)
@@ -159,6 +159,7 @@ void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	switch_mm_irqs_off(prev, next, tsk);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(switch_mm);
 
 static void sync_current_stack_to_mm(struct mm_struct *mm)
 {
diff --git a/mm/memory.c b/mm/memory.c
index 36aac68..ede9335 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -434,6 +434,7 @@ int __pte_alloc(struct mm_struct *mm, pmd_t *pmd)
 		pte_free(mm, new);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__pte_alloc);
 
 int __pte_alloc_kernel(pmd_t *pmd)
 {
@@ -453,6 +454,7 @@ int __pte_alloc_kernel(pmd_t *pmd)
 		pte_free_kernel(&init_mm, new);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__pte_alloc_kernel);
 
 static inline void init_rss_vec(int *rss)
 {
@@ -4007,6 +4009,7 @@ int __p4d_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address)
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__p4d_alloc);
 #endif /* __PAGETABLE_P4D_FOLDED */
 
 #ifndef __PAGETABLE_PUD_FOLDED
@@ -4039,6 +4042,7 @@ int __pud_alloc(struct mm_struct *mm, p4d_t *p4d, unsigned long address)
 	spin_unlock(&mm->page_table_lock);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__pud_alloc);
 #endif /* __PAGETABLE_PUD_FOLDED */
 
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -4072,6 +4076,7 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 	spin_unlock(ptl);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__pmd_alloc);
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
-- 
1.7.1

