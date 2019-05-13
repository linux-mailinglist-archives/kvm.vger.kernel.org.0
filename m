Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBD51B8C2
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729695AbfEMOmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:42:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40302 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbfEMOmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:42:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd2cM193026;
        Mon, 13 May 2019 14:39:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=Dw7jnDOehrItQ8IBhhkiUXlVuHtLBnaP+UdwDVV0Wkc=;
 b=zSrYKyEoOAdq0QWpvZ0qd6kNFKnCiopVoHRqhqc1ZV4bi48RNUFvLgth3il0pLxTxJ2n
 CePloH/migBtqYtd6xbrITTyQDKGmELS+eGvp8q4r6EsdjFT9Aha0voKsbZbmYzkK/aH
 4zsWyBkbuScAy0o39X/qZ0peTs4L6A5vj+f8j0R0RpMOLecXpCbYiaN7tvdV6Zj7SkBb
 LqMBBHLoFSVmQtxPLbBms9KAeMYrLYP9+8QQeRm3CM/TahwAKsdeOMTJKAgWYkztBied
 FDur+uo2FG0gAOb5iBm4+gebU8igLetDFFzIk9XWaWLWwgf4BEpCgqcLaJ6fAkuU2QB3 PQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfm0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:47 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQQ022780;
        Mon, 13 May 2019 14:39:45 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 23/27] kvm/isolation: initialize the KVM page table with the vcpu tasks
Date:   Mon, 13 May 2019 16:38:31 +0200
Message-Id: <1557758315-12667-24-git-send-email-alexandre.chartre@oracle.com>
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

Tasks which are going to be running with the KVM address space have
to be mapped with their core data (stack, mm, pgd..) so that they
can (at least) switch back to the kernel address space.

For now, assume that these tasks are the ones running vcpu, and that
there's a 1:1 mapping between a task and vcpu. This should eventually
be improved to be independent of any task/vcpu mapping.

Also check that the task effectively entering the KVM address space
is mapped.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |  182 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/isolation.h |    2 +
 arch/x86/kvm/vmx/vmx.c   |    8 ++
 include/linux/sched.h    |    5 +
 4 files changed, 197 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index d3ac014..e7979b3 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -64,6 +64,20 @@ struct pgt_directory_group {
 	((typeof(entry))(((unsigned long)(entry)) & PAGE_MASK))
 
 /*
+ * Variables to keep track of tasks mapped into the KVM address space.
+ */
+struct kvm_task_mapping {
+	struct list_head list;
+	struct task_struct *task;
+	void *stack;
+	struct mm_struct *mm;
+	pgd_t *pgd;
+};
+
+static LIST_HEAD(kvm_task_mapping_list);
+static DEFINE_MUTEX(kvm_task_mapping_lock);
+
+/*
  * Variables to keep track of address ranges mapped into the KVM
  * address space.
  */
@@ -1027,6 +1041,160 @@ int kvm_copy_percpu_mapping(void *percpu_ptr, size_t size)
 }
 EXPORT_SYMBOL(kvm_copy_percpu_mapping);
 
+static void kvm_clear_task_mapping(struct kvm_task_mapping *task_mapping)
+{
+	if (task_mapping->task) {
+		kvm_clear_range_mapping(task_mapping->task);
+		task_mapping->task = NULL;
+	}
+	if (task_mapping->stack) {
+		kvm_clear_range_mapping(task_mapping->stack);
+		task_mapping->stack = NULL;
+	}
+	if (task_mapping->mm) {
+		kvm_clear_range_mapping(task_mapping->mm);
+		task_mapping->mm = NULL;
+	}
+	if (task_mapping->pgd) {
+		kvm_clear_range_mapping(task_mapping->pgd);
+		task_mapping->pgd = NULL;
+	}
+}
+
+static int kvm_copy_task_mapping(struct task_struct *tsk,
+				 struct kvm_task_mapping *task_mapping)
+{
+	int err;
+
+	err = kvm_copy_ptes(tsk, sizeof(struct task_struct));
+	if (err)
+		goto out_clear_task_mapping;
+	task_mapping->task = tsk;
+
+	err = kvm_copy_ptes(tsk->stack, THREAD_SIZE);
+	if (err)
+		goto out_clear_task_mapping;
+	task_mapping->stack = tsk->stack;
+
+	err = kvm_copy_ptes(tsk->active_mm, sizeof(struct mm_struct));
+	if (err)
+		goto out_clear_task_mapping;
+	task_mapping->mm = tsk->active_mm;
+
+	err = kvm_copy_ptes(tsk->active_mm->pgd,
+			   PAGE_SIZE << PGD_ALLOCATION_ORDER);
+	if (err)
+		goto out_clear_task_mapping;
+	task_mapping->pgd = tsk->active_mm->pgd;
+
+	return 0;
+
+out_clear_task_mapping:
+	kvm_clear_task_mapping(task_mapping);
+	return err;
+}
+
+int kvm_add_task_mapping(struct task_struct *tsk)
+{
+	struct kvm_task_mapping *task_mapping;
+	int err;
+
+	mutex_lock(&kvm_task_mapping_lock);
+
+	if (tsk->kvm_mapped) {
+		mutex_unlock(&kvm_task_mapping_lock);
+		return 0;
+	}
+
+	task_mapping = kzalloc(sizeof(struct kvm_task_mapping), GFP_KERNEL);
+	if (!task_mapping) {
+		mutex_unlock(&kvm_task_mapping_lock);
+		return -ENOMEM;
+	}
+	INIT_LIST_HEAD(&task_mapping->list);
+
+	/*
+	 * Ensure that the task and its stack are mapped into the KVM
+	 * address space. Also map the task mm to be able to switch back
+	 * to the original mm, and its PGD directory.
+	 */
+	pr_debug("mapping task %px\n", tsk);
+	err = kvm_copy_task_mapping(tsk, task_mapping);
+	if (err) {
+		kfree(task_mapping);
+		mutex_unlock(&kvm_task_mapping_lock);
+		return err;
+	}
+
+	get_task_struct(tsk);
+	list_add(&task_mapping->list, &kvm_task_mapping_list);
+	tsk->kvm_mapped = true;
+
+	mutex_unlock(&kvm_task_mapping_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(kvm_add_task_mapping);
+
+static struct kvm_task_mapping *kvm_find_task_mapping(struct task_struct *tsk)
+{
+	struct kvm_task_mapping *task_mapping;
+
+	list_for_each_entry(task_mapping, &kvm_task_mapping_list, list) {
+		if (task_mapping->task == tsk)
+			return task_mapping;
+	}
+	return NULL;
+}
+
+void kvm_cleanup_task_mapping(struct task_struct *tsk)
+{
+	struct kvm_task_mapping *task_mapping;
+
+	if (!tsk->kvm_mapped)
+		return;
+
+	task_mapping = kvm_find_task_mapping(tsk);
+	if (!task_mapping) {
+		pr_debug("KVM isolation: mapping not found for mapped task %px\n",
+			 tsk);
+		tsk->kvm_mapped = false;
+		mutex_unlock(&kvm_task_mapping_lock);
+		return;
+	}
+
+	pr_debug("unmapping task %px\n", tsk);
+
+	list_del(&task_mapping->list);
+	kvm_clear_task_mapping(task_mapping);
+	kfree(task_mapping);
+	tsk->kvm_mapped = false;
+	put_task_struct(tsk);
+	mutex_unlock(&kvm_task_mapping_lock);
+}
+EXPORT_SYMBOL(kvm_cleanup_task_mapping);
+
+/*
+ * Mark all tasks which have being mapped into the KVM address space
+ * as not mapped. This only clears the mapping attribute in the task
+ * structure, but page table mappings remain in the KVM page table.
+ * They will be effectively removed when deleting the KVM page table.
+ */
+static void kvm_reset_all_task_mapping(void)
+{
+	struct kvm_task_mapping *task_mapping;
+	struct task_struct *tsk;
+
+	mutex_lock(&kvm_task_mapping_lock);
+	list_for_each_entry(task_mapping, &kvm_task_mapping_list, list) {
+		tsk = task_mapping->task;
+		pr_debug("clear mapping for task %px\n", tsk);
+		tsk->kvm_mapped = false;
+		put_task_struct(tsk);
+	}
+	mutex_unlock(&kvm_task_mapping_lock);
+}
+
 
 static int kvm_isolation_init_page_table(void)
 {
@@ -1195,6 +1363,7 @@ static void kvm_isolation_uninit_mm(void)
 
 	destroy_context(&kvm_mm);
 
+	kvm_reset_all_task_mapping();
 	kvm_isolation_uninit_page_table();
 	kvm_free_all_range_mapping();
 
@@ -1227,6 +1396,8 @@ int kvm_isolation_init_vm(struct kvm *kvm)
 	if (!kvm_isolation())
 		return 0;
 
+	pr_debug("mapping kvm srcu sda\n");
+
 	return (kvm_copy_percpu_mapping(kvm->srcu.sda,
 		sizeof(struct srcu_data)));
 }
@@ -1236,6 +1407,8 @@ void kvm_isolation_destroy_vm(struct kvm *kvm)
 	if (!kvm_isolation())
 		return;
 
+	pr_debug("unmapping kvm srcu sda\n");
+
 	kvm_clear_percpu_mapping(kvm->srcu.sda);
 }
 
@@ -1276,12 +1449,21 @@ void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu)
 
 void kvm_isolation_enter(void)
 {
+	int err;
+
 	if (kvm_isolation()) {
 		/*
 		 * Switches to kvm_mm should happen from vCPU thread,
 		 * which should not be a kernel thread with no mm
 		 */
 		BUG_ON(current->active_mm == NULL);
+
+		err = kvm_add_task_mapping(current);
+		if (err) {
+			pr_err("KVM isolation cancelled (failed to map task %px)",
+			       current);
+			return;
+		}
 		/* TODO: switch to kvm_mm */
 	}
 }
diff --git a/arch/x86/kvm/isolation.h b/arch/x86/kvm/isolation.h
index 33e9a87..2d7d016 100644
--- a/arch/x86/kvm/isolation.h
+++ b/arch/x86/kvm/isolation.h
@@ -32,5 +32,7 @@ static inline bool kvm_isolation(void)
 extern void kvm_clear_range_mapping(void *ptr);
 extern int kvm_copy_percpu_mapping(void *percpu_ptr, size_t size);
 extern void kvm_clear_percpu_mapping(void *percpu_ptr);
+extern int kvm_add_task_mapping(struct task_struct *tsk);
+extern void kvm_cleanup_task_mapping(struct task_struct *tsk);
 
 #endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cbbaf58..9ed31c2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6576,6 +6576,9 @@ static void vmx_unmap_vcpu(struct vcpu_vmx *vmx)
 	kvm_clear_range_mapping(vmx->vmcs01.msr_bitmap);
 	kvm_clear_range_mapping(vmx->vcpu.arch.pio_data);
 	kvm_clear_range_mapping(vmx->vcpu.arch.apic);
+
+	/* XXX assume there's a 1:1 mapping between a task and a vcpu */
+	kvm_cleanup_task_mapping(current);
 }
 
 static int vmx_map_vcpu(struct vcpu_vmx *vmx)
@@ -6614,6 +6617,11 @@ static int vmx_map_vcpu(struct vcpu_vmx *vmx)
 	if (rv)
 		goto out_unmap_vcpu;
 
+	/* XXX assume there's a 1:1 mapping between a task and a vcpu */
+	rv = kvm_add_task_mapping(current);
+	if (rv)
+		goto out_unmap_vcpu;
+
 	return 0;
 
 out_unmap_vcpu:
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 50606a6..80e1d75 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1199,6 +1199,11 @@ struct task_struct {
 	unsigned long			prev_lowest_stack;
 #endif
 
+#ifdef CONFIG_HAVE_KVM
+	/* Is the task mapped into the KVM address space? */
+	bool				kvm_mapped;
+#endif
+
 	/*
 	 * New fields for task_struct should be added above here, so that
 	 * they are included in the randomized portion of task_struct.
-- 
1.7.1

