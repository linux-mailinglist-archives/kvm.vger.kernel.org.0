Return-Path: <kvm+bounces-31269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CFF29C1D9E
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 14:08:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F28B71F219EB
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 13:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F2C11E909F;
	Fri,  8 Nov 2024 13:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aw3dFgnW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB511E6DE1
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 13:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731071274; cv=none; b=YhTwyaEvEHMNHZhfiqP2Wf70L5d+S9UP+wOpoESJKo3wOXLUUZtpLnn7vGmipkfMoOFh45Z/xHbyS9RhVsVaWfCOofnU/1ZXO1XryqrQqLK2RbZUddLPbHFA99EwYSnP+W8lihpV4z9anyCa9CElykVq+hLQNiWB1gbPPJjNxUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731071274; c=relaxed/simple;
	bh=CYH0PXwxfG8TxAVh3+79MgWgHVWV3jjOl4trZuJEiNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZxVYXFms+BF0gHTydx4c9GcaEP3pPQFK6To7u+yJY50gpTU2GC7uNB6LzMgz0HxXoSluIHA2tB7uWic9t0E+rOXUDX31SuNZ+4PzH9j1Yw69jYlHNga41GjzhHQv0sofKFOMy35B1KODwYGZWRN3GR+umH94Keu+i+nBtZzJ6z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aw3dFgnW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731071271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UBKmK8tEl4j/lViVvAFgYObQhSYvDrj2ltyuK7C2hYo=;
	b=aw3dFgnWkGwZpIZUjvorp10fb9DIkH+uP0TiBkHiBBy7FskUZi7uLD5veoikyuTxuqXi11
	pI2ast0PrL408VCsT6Nl8whKLOByjiTKloW5Ld4QMs1gbIubnmfwY8c04NnwjEFWkPHLbH
	yDPX/qtMpq/Xf3oej2lHhrJp7HAPfXc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-XCmSUF_aOQuC86HEG8PGIA-1; Fri,
 08 Nov 2024 08:07:45 -0500
X-MC-Unique: XCmSUF_aOQuC86HEG8PGIA-1
X-Mimecast-MFC-AGG-ID: XCmSUF_aOQuC86HEG8PGIA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D15919540EF;
	Fri,  8 Nov 2024 13:07:44 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A5757300019E;
	Fri,  8 Nov 2024 13:07:43 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.christie@oracle.com,
	Tejun Heo <tj@kernel.org>,
	Luca Boccassi <bluca@debian.org>
Subject: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
Date: Fri,  8 Nov 2024 08:07:37 -0500
Message-ID: <20241108130737.126567-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

kvm_vm_create_worker_thread() is meant to be used for kthreads that
can consume significant amounts of CPU time on behalf of a VM or in
response to how the VM behaves (for example how it accesses its memory).
Therefore it wants to charge the CPU time consumed by that work to
the VM's container.

However, because of these threads, cgroups which have kvm instances inside
never complete freezing.  This can be trivially reproduced:

  root@test ~# mkdir /sys/fs/cgroup/test
  root@test ~# echo $fish_pid > /sys/fs/cgroup/test/cgroup.procs
  root@test ~# qemu-system-x86_64 --nographic -enable-kvm

and in another terminal:

  root@test ~# echo 1 > /sys/fs/cgroup/test/cgroup.freeze
  root@test ~# cat /sys/fs/cgroup/test/cgroup.events
  populated 1
  frozen 0

The cgroup freezing happens in the signal delivery path but
kvm_vm_worker_thread() thread never call into the signal delivery path while
joining non-root cgroups, so they never get frozen. Because the cgroup
freezer determines whether a given cgroup is frozen by comparing the number
of frozen threads to the total number of threads in the cgroup, the cgroup
never becomes frozen and users waiting for the state transition may hang
indefinitely.

Since the worker kthread is tied to a user process, it's better if
it behaves similarly to user tasks as much as possible, including
being able to send SIGSTOP and SIGCONT.  In fact, vhost_task is all
that kvm_vm_create_worker_thread() wanted to be and more: not only it
inherits the userspace process's cgroups, it has other niceties like
being parented properly in the process tree.  Use it instead of the
homegrown alternative.

(Commit message based on emails from Tejun).

Reported-by: Tejun Heo <tj@kernel.org>
Reported-by: Luca Boccassi <bluca@debian.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/Kconfig            |   1 +
 arch/x86/kvm/mmu/mmu.c          |  67 +++++++++++----------
 include/linux/kvm_host.h        |   6 --
 virt/kvm/kvm_main.c             | 103 --------------------------------
 5 files changed, 39 insertions(+), 142 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6d9f763a7bb9..d6657cc0fe6b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <linux/irqbypass.h>
 #include <linux/hyperv.h>
 #include <linux/kfifo.h>
+#include <linux/sched/vhost_task.h>
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
@@ -1443,7 +1444,8 @@ struct kvm_arch {
 	bool sgx_provisioning_allowed;
 
 	struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;
-	struct task_struct *nx_huge_page_recovery_thread;
+	struct vhost_task *nx_huge_page_recovery_thread;
+	u64 nx_huge_page_next;
 
 #ifdef CONFIG_X86_64
 	/* The number of TDP MMU pages across all roots. */
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f09f13c01c6b..b387d61af44f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -29,6 +29,7 @@ config KVM_X86
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_READONLY_MEM
+	select VHOST_TASK
 	select KVM_ASYNC_PF
 	select USER_RETURN_NOTIFIER
 	select KVM_MMIO
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e853a5fc867..d5af4f8c5a6a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7281,7 +7281,7 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
-			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
+			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
 		}
 		mutex_unlock(&kvm_lock);
 	}
@@ -7427,7 +7427,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list)
-			wake_up_process(kvm->arch.nx_huge_page_recovery_thread);
+			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
 
 		mutex_unlock(&kvm_lock);
 	}
@@ -7530,62 +7530,65 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
-static long get_nx_huge_page_recovery_timeout(u64 start_time)
+#define NX_HUGE_PAGE_DISABLED (-1)
+
+static u64 get_nx_huge_page_recovery_next(void)
 {
 	bool enabled;
 	uint period;
 
 	enabled = calc_nx_huge_pages_recovery_period(&period);
 
-	return enabled ? start_time + msecs_to_jiffies(period) - get_jiffies_64()
-		       : MAX_SCHEDULE_TIMEOUT;
+	return enabled ? get_jiffies_64() + msecs_to_jiffies(period)
+		: NX_HUGE_PAGE_DISABLED;
 }
 
-static int kvm_nx_huge_page_recovery_worker(struct kvm *kvm, uintptr_t data)
+static void kvm_nx_huge_page_recovery_worker_kill(void *data)
 {
-	u64 start_time;
+}
+
+static bool kvm_nx_huge_page_recovery_worker(void *data)
+{
+	struct kvm *kvm = data;
 	long remaining_time;
 
-	while (true) {
-		start_time = get_jiffies_64();
-		remaining_time = get_nx_huge_page_recovery_timeout(start_time);
+	if (kvm->arch.nx_huge_page_next == NX_HUGE_PAGE_DISABLED)
+		return false;
 
-		set_current_state(TASK_INTERRUPTIBLE);
-		while (!kthread_should_stop() && remaining_time > 0) {
-			schedule_timeout(remaining_time);
-			remaining_time = get_nx_huge_page_recovery_timeout(start_time);
-			set_current_state(TASK_INTERRUPTIBLE);
-		}
-
-		set_current_state(TASK_RUNNING);
-
-		if (kthread_should_stop())
-			return 0;
-
-		kvm_recover_nx_huge_pages(kvm);
+	remaining_time = kvm->arch.nx_huge_page_next - get_jiffies_64();
+	if (remaining_time > 0) {
+		schedule_timeout(remaining_time);
+		/* check for signals and come back */
+		return true;
 	}
+
+	__set_current_state(TASK_RUNNING);
+	kvm_recover_nx_huge_pages(kvm);
+	kvm->arch.nx_huge_page_next = get_nx_huge_page_recovery_next();
+	return true;
 }
 
 int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
-	int err;
-
 	if (nx_hugepage_mitigation_hard_disabled)
 		return 0;
 
-	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
-					  "kvm-nx-lpage-recovery",
-					  &kvm->arch.nx_huge_page_recovery_thread);
-	if (!err)
-		kthread_unpark(kvm->arch.nx_huge_page_recovery_thread);
+	kvm->arch.nx_huge_page_next = get_nx_huge_page_recovery_next();
+	kvm->arch.nx_huge_page_recovery_thread = vhost_task_create(
+		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kill,
+		kvm, "kvm-nx-lpage-recovery");
+	
+	if (!kvm->arch.nx_huge_page_recovery_thread)
+		return -ENOMEM;
 
-	return err;
+	vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
+	return 0;
 }
 
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 {
 	if (kvm->arch.nx_huge_page_recovery_thread)
-		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
+		vhost_task_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
 
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 45be36e5285f..85fe9d0ebb91 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2382,12 +2382,6 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE */
 
-typedef int (*kvm_vm_thread_fn_t)(struct kvm *kvm, uintptr_t data);
-
-int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
-				uintptr_t data, const char *name,
-				struct task_struct **thread_ptr);
-
 #ifdef CONFIG_KVM_XFER_TO_GUEST_WORK
 static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6ca7a1045bbb..279e03029ce1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6561,106 +6561,3 @@ void kvm_exit(void)
 	kvm_irqfd_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
-
-struct kvm_vm_worker_thread_context {
-	struct kvm *kvm;
-	struct task_struct *parent;
-	struct completion init_done;
-	kvm_vm_thread_fn_t thread_fn;
-	uintptr_t data;
-	int err;
-};
-
-static int kvm_vm_worker_thread(void *context)
-{
-	/*
-	 * The init_context is allocated on the stack of the parent thread, so
-	 * we have to locally copy anything that is needed beyond initialization
-	 */
-	struct kvm_vm_worker_thread_context *init_context = context;
-	struct task_struct *parent;
-	struct kvm *kvm = init_context->kvm;
-	kvm_vm_thread_fn_t thread_fn = init_context->thread_fn;
-	uintptr_t data = init_context->data;
-	int err;
-
-	err = kthread_park(current);
-	/* kthread_park(current) is never supposed to return an error */
-	WARN_ON(err != 0);
-	if (err)
-		goto init_complete;
-
-	err = cgroup_attach_task_all(init_context->parent, current);
-	if (err) {
-		kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
-			__func__, err);
-		goto init_complete;
-	}
-
-	set_user_nice(current, task_nice(init_context->parent));
-
-init_complete:
-	init_context->err = err;
-	complete(&init_context->init_done);
-	init_context = NULL;
-
-	if (err)
-		goto out;
-
-	/* Wait to be woken up by the spawner before proceeding. */
-	kthread_parkme();
-
-	if (!kthread_should_stop())
-		err = thread_fn(kvm, data);
-
-out:
-	/*
-	 * Move kthread back to its original cgroup to prevent it lingering in
-	 * the cgroup of the VM process, after the latter finishes its
-	 * execution.
-	 *
-	 * kthread_stop() waits on the 'exited' completion condition which is
-	 * set in exit_mm(), via mm_release(), in do_exit(). However, the
-	 * kthread is removed from the cgroup in the cgroup_exit() which is
-	 * called after the exit_mm(). This causes the kthread_stop() to return
-	 * before the kthread actually quits the cgroup.
-	 */
-	rcu_read_lock();
-	parent = rcu_dereference(current->real_parent);
-	get_task_struct(parent);
-	rcu_read_unlock();
-	cgroup_attach_task_all(parent, current);
-	put_task_struct(parent);
-
-	return err;
-}
-
-int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
-				uintptr_t data, const char *name,
-				struct task_struct **thread_ptr)
-{
-	struct kvm_vm_worker_thread_context init_context = {};
-	struct task_struct *thread;
-
-	*thread_ptr = NULL;
-	init_context.kvm = kvm;
-	init_context.parent = current;
-	init_context.thread_fn = thread_fn;
-	init_context.data = data;
-	init_completion(&init_context.init_done);
-
-	thread = kthread_run(kvm_vm_worker_thread, &init_context,
-			     "%s-%d", name, task_pid_nr(current));
-	if (IS_ERR(thread))
-		return PTR_ERR(thread);
-
-	/* kthread_run is never supposed to return NULL */
-	WARN_ON(thread == NULL);
-
-	wait_for_completion(&init_context.init_done);
-
-	if (!init_context.err)
-		*thread_ptr = thread;
-
-	return init_context.err;
-}
-- 
2.43.5


