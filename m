Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA921B893
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbfEMOk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:40:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37798 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730623AbfEMOk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEdHlv193231;
        Mon, 13 May 2019 14:39:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=LfHNGKdGVZ8SXafCfcR3Zof+WadTo/bKWh5zIaesw/M=;
 b=m2arcl/OoSz25ufQlPkSDyXa5f1frMRq2QeB0JzA4PV/uhaSpAPsJfmP6YeH0R+Y7+PC
 50HJ+Yx7Z8gUn3m69WqI9tJvyt5ZPxzpbW+60gErtelRwYfFJw+X3V78E3pi6uU708Zl
 uEVUq4MhUxXUf1DFx84dYgGV/93RXZwfztVCXTVvknZhM6YZw2KSvN8qBdHsbd2ELVmx
 /7qs4qjDnvxh+fcskoo9PGQvTX2vY0RinWTrcvKjzeXlWoP9/wWiom7xFgGIssxbulhP
 IvPfd4bMncK92V8msleNSWffh5EcxE1AX3Pw6AsvfuevV3vA7E7XlcOF1Gt+oJHTRqAq Ww== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfm13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:53 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQS022780;
        Mon, 13 May 2019 14:39:50 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 25/27] kvm/isolation: implement actual KVM isolation enter/exit
Date:   Mon, 13 May 2019 16:38:33 +0200
Message-Id: <1557758315-12667-26-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

KVM isolation enter/exit is done by switching between the KVM address
space and the kernel address space.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   30 ++++++++++++++++++++++++------
 arch/x86/mm/tlb.c        |    1 +
 include/linux/sched.h    |    1 +
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index db0a7ce..b0c789f 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -1383,11 +1383,13 @@ static bool kvm_page_fault(struct pt_regs *regs, unsigned long error_code,
 	printk(KERN_DEFAULT "KVM isolation: page fault %ld at %pS on %lx (%pS) while switching mm\n"
 	       "  cr3=%lx\n"
 	       "  kvm_mm=%px pgd=%px\n"
-	       "  active_mm=%px pgd=%px\n",
+	       "  active_mm=%px pgd=%px\n"
+	       "  kvm_prev_mm=%px pgd=%px\n",
 	       error_code, (void *)regs->ip, address, (void *)address,
 	       cr3,
 	       &kvm_mm, kvm_mm.pgd,
-	       active_mm, active_mm->pgd);
+	       active_mm, active_mm->pgd,
+	       current->kvm_prev_mm, current->kvm_prev_mm->pgd);
 	dump_stack();
 
 	return false;
@@ -1649,11 +1651,27 @@ void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu)
 	kvm_isolation_exit();
 }
 
+static void kvm_switch_mm(struct mm_struct *mm)
+{
+	unsigned long flags;
+
+	/*
+	 * Disable interrupt before updating active_mm, otherwise if an
+	 * interrupt occurs during the switch then the interrupt handler
+	 * can be mislead about the mm effectively in use.
+	 */
+	local_irq_save(flags);
+	current->kvm_prev_mm = current->active_mm;
+	current->active_mm = mm;
+	switch_mm_irqs_off(current->kvm_prev_mm, mm, NULL);
+	local_irq_restore(flags);
+}
+
 void kvm_isolation_enter(void)
 {
 	int err;
 
-	if (kvm_isolation()) {
+	if (kvm_isolation() && current->active_mm != &kvm_mm) {
 		/*
 		 * Switches to kvm_mm should happen from vCPU thread,
 		 * which should not be a kernel thread with no mm
@@ -1666,14 +1684,14 @@ void kvm_isolation_enter(void)
 			       current);
 			return;
 		}
-		/* TODO: switch to kvm_mm */
+		kvm_switch_mm(&kvm_mm);
 	}
 }
 
 void kvm_isolation_exit(void)
 {
-	if (kvm_isolation()) {
+	if (kvm_isolation() && current->active_mm == &kvm_mm) {
 		/* TODO: Kick sibling hyperthread before switch to host mm */
-		/* TODO: switch back to original mm */
+		kvm_switch_mm(current->kvm_prev_mm);
 	}
 }
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index a4db7f5..7ad5ad1 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -444,6 +444,7 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 		switch_ldt(real_prev, next);
 	}
 }
+EXPORT_SYMBOL_GPL(switch_mm_irqs_off);
 
 /*
  * Please ignore the name of this function.  It should be called
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 80e1d75..b03680d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1202,6 +1202,7 @@ struct task_struct {
 #ifdef CONFIG_HAVE_KVM
 	/* Is the task mapped into the KVM address space? */
 	bool				kvm_mapped;
+	struct mm_struct		*kvm_prev_mm;
 #endif
 
 	/*
-- 
1.7.1

