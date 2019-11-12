Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36597F9BF7
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 22:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfKLVVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 16:21:55 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37112 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfKLVVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 16:21:50 -0500
Received: by mail-wm1-f66.google.com with SMTP id b17so4528193wmj.2;
        Tue, 12 Nov 2019 13:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id:in-reply-to:references;
        bh=9M0fq0aYmniC9Pe7qGsRqdKSERKFCy30TwBPB239Tuo=;
        b=tD+5WCkdBtrlSG4vfBnEOk+3i3RIuhPEtPgqMJHuC1RSdq/uKEgjmqxyEoDQsTT4JG
         jJrNP/DPGxG8mZ9KqsrKoP0UEE4rAEovxE9Pcvf2+FZNv63AmDhgPP1ebdPj7ESu2v3i
         EAtpOMgoLyfVE2GjVQIebC88nd99WCFjy4gdJEpHBG8YTrDabAcewH2lYI9GSEK7J82D
         wcuKX6I67HwkhN2IUpXeiSKk81xPNFsR1dwQO9ba1ZdtzcxHKKi8RW1hh3UAIV+u2Ycy
         SN7FXxMmFb8DuwIth8OJa4QpVpWDDfkKBJ3ZEV6oUIObFoezzhc+Lt7HFR29MX9yD+Ff
         tCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references;
        bh=9M0fq0aYmniC9Pe7qGsRqdKSERKFCy30TwBPB239Tuo=;
        b=LcEeleOjzX8xJzaF5Ddl9i0z6CKBcm5WDawxGCt6z8zxrMNsohPvcAuXvkMTJJcJxh
         UHPCpp1lA9Ho4aiDNshUxKcbR0XWMAdfYVc50gYy9Z0LIhoR1nTnorm+x+ERZXzkXWX9
         +Z++ZnZcW3SqngdjrbHd7o1reEespQmpEoiXvNmABF3JQBuH9H8nNclxlUWXxJb1USKK
         R5QLyt/LM7HGx2DRQpXTlu+qrZxJUnxQ/TcCGLgvMUzfESC6h9PdHV6sGcQE3QjmJrch
         J+sqa1V1Xj7ECiNjjTWjWCCyGgyBWaCyWZbYzECDullmcZ2KOR2e06hxYpWkwpjZMmnu
         TxoA==
X-Gm-Message-State: APjAAAVWXiJjgdgv0p5D2MUN4/WNFRl6ueifnriy/bDAnK+a0enxVD5Y
        NgV338M6I/RwJIbKuc82vgOzv0CC
X-Google-Smtp-Source: APXvYqzpwRFAmkfiVGvX5ZhQ+MwoHiscJjOOfUW2fz398mQ7bAFNcxBuPGVVhZti7Az+/PGL+ZouvQ==
X-Received: by 2002:a1c:16:: with SMTP id 22mr6344502wma.0.1573593706100;
        Tue, 12 Nov 2019 13:21:46 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id q25sm198664wra.3.2019.11.12.13.21.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 13:21:45 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 6/7] kvm: x86: mmu: Recovery of shattered NX large pages
Date:   Tue, 12 Nov 2019 22:21:36 +0100
Message-Id: <1573593697-25061-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
References: <1573593697-25061-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Junaid Shahid <junaids@google.com>

The page table pages corresponding to broken down large pages are zapped in
FIFO order, so that the large page can potentially be recovered, if it is
not longer being used for execution.  This removes the performance penalty
for walking deeper EPT page tables.

By default, one large page will last about one hour once the guest
reaches a steady state.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/admin-guide/kernel-parameters.txt |   6 ++
 arch/x86/include/asm/kvm_host.h                 |   4 +
 arch/x86/kvm/mmu.c                              | 129 ++++++++++++++++++++++++
 arch/x86/kvm/mmu.h                              |   4 +
 arch/x86/kvm/x86.c                              |  11 ++
 virt/kvm/kvm_main.c                             |  28 +++++
 6 files changed, 182 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9d5f123cc218..8dee8f68fe15 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2068,6 +2068,12 @@
 			If the software workaround is enabled for the host,
 			guests do need not to enable it for nested guests.
 
+	kvm.nx_huge_pages_recovery_ratio=
+			[KVM] Controls how many 4KiB pages are periodically zapped
+			back to huge pages.  0 disables the recovery, otherwise if
+			the value is N KVM will zap 1/Nth of the 4KiB pages every
+			minute.  The default is 60.
+
 	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
 			Default is 1 (enabled)
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a37b03483b66..4fc61483919a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -312,6 +312,8 @@ struct kvm_rmap_head {
 struct kvm_mmu_page {
 	struct list_head link;
 	struct hlist_node hash_link;
+	struct list_head lpage_disallowed_link;
+
 	bool unsync;
 	u8 mmu_valid_gen;
 	bool mmio_cached;
@@ -860,6 +862,7 @@ struct kvm_arch {
 	 */
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
+	struct list_head lpage_disallowed_mmu_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
 	struct kvm_page_track_notifier_head track_notifier_head;
 
@@ -934,6 +937,7 @@ struct kvm_arch {
 	bool exception_payload_enabled;
 
 	struct kvm_pmu_event_filter *pmu_event_filter;
+	struct task_struct *nx_lpage_recovery_thread;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bedf6864b092..529589a42afb 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -37,6 +37,7 @@
 #include <linux/uaccess.h>
 #include <linux/hash.h>
 #include <linux/kern_levels.h>
+#include <linux/kthread.h>
 
 #include <asm/page.h>
 #include <asm/pat.h>
@@ -50,16 +51,26 @@
 extern bool itlb_multihit_kvm_mitigation;
 
 static int __read_mostly nx_huge_pages = -1;
+static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
 
 static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
+static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp);
 
 static struct kernel_param_ops nx_huge_pages_ops = {
 	.set = set_nx_huge_pages,
 	.get = param_get_bool,
 };
 
+static struct kernel_param_ops nx_huge_pages_recovery_ratio_ops = {
+	.set = set_nx_huge_pages_recovery_ratio,
+	.get = param_get_uint,
+};
+
 module_param_cb(nx_huge_pages, &nx_huge_pages_ops, &nx_huge_pages, 0644);
 __MODULE_PARM_TYPE(nx_huge_pages, "bool");
+module_param_cb(nx_huge_pages_recovery_ratio, &nx_huge_pages_recovery_ratio_ops,
+		&nx_huge_pages_recovery_ratio, 0644);
+__MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
 
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
@@ -1215,6 +1226,8 @@ static void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return;
 
 	++kvm->stat.nx_lpage_splits;
+	list_add_tail(&sp->lpage_disallowed_link,
+		      &kvm->arch.lpage_disallowed_mmu_pages);
 	sp->lpage_disallowed = true;
 }
 
@@ -1239,6 +1252,7 @@ static void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	--kvm->stat.nx_lpage_splits;
 	sp->lpage_disallowed = false;
+	list_del(&sp->lpage_disallowed_link);
 }
 
 static bool __mmu_gfn_lpage_is_disallowed(gfn_t gfn, int level,
@@ -6274,6 +6288,8 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 			idx = srcu_read_lock(&kvm->srcu);
 			kvm_mmu_zap_all_fast(kvm);
 			srcu_read_unlock(&kvm->srcu, idx);
+
+			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -6367,3 +6383,116 @@ void kvm_mmu_module_exit(void)
 	unregister_shrinker(&mmu_shrinker);
 	mmu_audit_disable();
 }
+
+static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel_param *kp)
+{
+	unsigned int old_val;
+	int err;
+
+	old_val = nx_huge_pages_recovery_ratio;
+	err = param_set_uint(val, kp);
+	if (err)
+		return err;
+
+	if (READ_ONCE(nx_huge_pages) &&
+	    !old_val && nx_huge_pages_recovery_ratio) {
+		struct kvm *kvm;
+
+		mutex_lock(&kvm_lock);
+
+		list_for_each_entry(kvm, &vm_list, vm_list)
+			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
+
+		mutex_unlock(&kvm_lock);
+	}
+
+	return err;
+}
+
+static void kvm_recover_nx_lpages(struct kvm *kvm)
+{
+	int rcu_idx;
+	struct kvm_mmu_page *sp;
+	unsigned int ratio;
+	LIST_HEAD(invalid_list);
+	ulong to_zap;
+
+	rcu_idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+
+	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
+	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
+	while (to_zap && !list_empty(&kvm->arch.lpage_disallowed_mmu_pages)) {
+		/*
+		 * We use a separate list instead of just using active_mmu_pages
+		 * because the number of lpage_disallowed pages is expected to
+		 * be relatively small compared to the total.
+		 */
+		sp = list_first_entry(&kvm->arch.lpage_disallowed_mmu_pages,
+				      struct kvm_mmu_page,
+				      lpage_disallowed_link);
+		WARN_ON_ONCE(!sp->lpage_disallowed);
+		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+		WARN_ON_ONCE(sp->lpage_disallowed);
+
+		if (!--to_zap || need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			if (to_zap)
+				cond_resched_lock(&kvm->mmu_lock);
+		}
+	}
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, rcu_idx);
+}
+
+static long get_nx_lpage_recovery_timeout(u64 start_time)
+{
+	return READ_ONCE(nx_huge_pages) && READ_ONCE(nx_huge_pages_recovery_ratio)
+		? start_time + 60 * HZ - get_jiffies_64()
+		: MAX_SCHEDULE_TIMEOUT;
+}
+
+static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
+{
+	u64 start_time;
+	long remaining_time;
+
+	while (true) {
+		start_time = get_jiffies_64();
+		remaining_time = get_nx_lpage_recovery_timeout(start_time);
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		while (!kthread_should_stop() && remaining_time > 0) {
+			schedule_timeout(remaining_time);
+			remaining_time = get_nx_lpage_recovery_timeout(start_time);
+			set_current_state(TASK_INTERRUPTIBLE);
+		}
+
+		set_current_state(TASK_RUNNING);
+
+		if (kthread_should_stop())
+			return 0;
+
+		kvm_recover_nx_lpages(kvm);
+	}
+}
+
+int kvm_mmu_post_init_vm(struct kvm *kvm)
+{
+	int err;
+
+	err = kvm_vm_create_worker_thread(kvm, kvm_nx_lpage_recovery_worker, 0,
+					  "kvm-nx-lpage-recovery",
+					  &kvm->arch.nx_lpage_recovery_thread);
+	if (!err)
+		kthread_unpark(kvm->arch.nx_lpage_recovery_thread);
+
+	return err;
+}
+
+void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
+{
+	if (kvm->arch.nx_lpage_recovery_thread)
+		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
+}
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 11f8ec89433b..d55674f44a18 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -210,4 +210,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
+
+int kvm_mmu_post_init_vm(struct kvm *kvm);
+void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b087d178a774..a30e9962a6ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9456,6 +9456,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	INIT_HLIST_HEAD(&kvm->arch.mask_notifier_list);
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
+	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 	atomic_set(&kvm->arch.noncoherent_dma_count, 0);
 
@@ -9484,6 +9485,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return kvm_x86_ops->vm_init(kvm);
 }
 
+int kvm_arch_post_init_vm(struct kvm *kvm)
+{
+	return kvm_mmu_post_init_vm(kvm);
+}
+
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
@@ -9585,6 +9591,11 @@ int x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 }
 EXPORT_SYMBOL_GPL(x86_set_memory_region);
 
+void kvm_arch_pre_destroy_vm(struct kvm *kvm)
+{
+	kvm_mmu_pre_destroy_vm(kvm);
+}
+
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	if (current->mm == kvm->mm) {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8aed32b604d9..4aab3547a165 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -626,6 +626,23 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 	return 0;
 }
 
+/*
+ * Called after the VM is otherwise initialized, but just before adding it to
+ * the vm_list.
+ */
+int __weak kvm_arch_post_init_vm(struct kvm *kvm)
+{
+	return 0;
+}
+
+/*
+ * Called just after removing the VM from the vm_list, but before doing any
+ * other destruction.
+ */
+void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
+{
+}
+
 static struct kvm *kvm_create_vm(unsigned long type)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
@@ -683,6 +700,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	r = kvm_init_mmu_notifier(kvm);
 	if (r)
+		goto out_err_no_mmu_notifier;
+
+	r = kvm_arch_post_init_vm(kvm);
+	if (r)
 		goto out_err;
 
 	mutex_lock(&kvm_lock);
@@ -694,6 +715,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	return kvm;
 
 out_err:
+#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
+	if (kvm->mmu_notifier.ops)
+		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
+#endif
+out_err_no_mmu_notifier:
 	cleanup_srcu_struct(&kvm->irq_srcu);
 out_err_no_irq_srcu:
 	cleanup_srcu_struct(&kvm->srcu);
@@ -738,6 +764,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	mutex_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	mutex_unlock(&kvm_lock);
+	kvm_arch_pre_destroy_vm(kvm);
+
 	kvm_free_irq_routing(kvm);
 	for (i = 0; i < KVM_NR_BUSES; i++) {
 		struct kvm_io_bus *bus = kvm_get_bus(kvm, i);
-- 
1.8.3.1


