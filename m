Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E8C59AB94
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245143AbiHTGBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244366AbiHTGAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B04EA223E;
        Fri, 19 Aug 2022 23:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975251; x=1692511251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xYGzaGJr0EP3zeyzmub13+Yw5366HEl9Zu7TH0xvoIw=;
  b=GyHv9vRzZeKZNobw3RWw6GgxSaubgleLTiI8P7t1aKB0iyHoc4P25y50
   Rg9+lCH9FhI4fPbC5NgOyNTYuxe2DmXeUlwrsf3Zgf5U+gjOvW4C7oUjV
   oSqm8NsTdxCv65YhQeVsNh7zsOTnitlavg6GG+/vqDuYj2/JuJT6Uv9xt
   mlUeP1S7gT6aZLBG+WPUtdl1oKvUPIKRli3hYBF3LOm1xa6sVnt1ijN5d
   EIZHqbJEU4sAGMIE2FE/mUc0Y0RUT9MjaYBn2Eld1aG+jIl8cVbOe3O5w
   T8o6G9+FBvwkjDdEcOplGMy03ybWhIfoqGdPMXSrsQNINPuXbAe8YFoGV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448973"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448973"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857530"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 07/18] KVM: Move out KVM arch PM hooks and hardware enable/disable logic
Date:   Fri, 19 Aug 2022 23:00:13 -0700
Message-Id: <b46f563faf81713f37980df974fa71bb977645be.1660974106.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660974106.git.isaku.yamahata@intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

To make clear that those files are default implementation that KVM/x86 (and
other KVM arch in future) will override them, split out those into a single
file. Once conversions for all kvm archs are done, the file will be
deleted.  kvm_arch_pre_hardware_unsetup() is introduced to avoid cross-arch
code churn for now.  Once it's settled down,
kvm_arch_pre_hardware_unsetup() can be merged into
kvm_arch_hardware_unsetup() in each arch code.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |   1 +
 virt/kvm/kvm_arch.c      |  75 ++++++++++++++++++++++++-
 virt/kvm/kvm_main.c      | 115 ++++-----------------------------------
 3 files changed, 85 insertions(+), 106 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5ae66062620c..fdde9c59756d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1437,6 +1437,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
+void kvm_arch_pre_hardware_unsetup(void);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void *opaque);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 0eac996f4981..d593610edb0a 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -6,49 +6,122 @@
  * Author:
  *   Isaku Yamahata <isaku.yamahata@intel.com>
  *                  <isaku.yamahata@gmail.com>
+ *
+ * TODO: Delete this file once the conversion of all KVM arch is done.
  */
 
 #include <linux/kvm_host.h>
 
+static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
+static atomic_t hardware_enable_failed;
+
 __weak int kvm_arch_post_init_vm(struct kvm *kvm)
 {
 	return 0;
 }
 
+static void hardware_enable_nolock(void *junk)
+{
+	int cpu = raw_smp_processor_id();
+	int r;
+
+	WARN_ON_ONCE(preemptible());
+
+	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
+		return;
+
+	cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+
+	r = kvm_arch_hardware_enable();
+
+	if (r) {
+		cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
+		atomic_inc(&hardware_enable_failed);
+		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
+	}
+}
+
+static void hardware_disable_nolock(void *junk)
+{
+	int cpu = raw_smp_processor_id();
+
+	WARN_ON_ONCE(preemptible());
+
+	if (!cpumask_test_cpu(cpu, &cpus_hardware_enabled))
+		return;
+	cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
+	kvm_arch_hardware_disable();
+}
+
+__weak void kvm_arch_pre_hardware_unsetup(void)
+{
+	on_each_cpu(hardware_disable_nolock, NULL, 1);
+}
+
 /*
  * Called after the VM is otherwise initialized, but just before adding it to
  * the vm_list.
  */
 __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 {
-	return kvm_arch_post_init_vm(kvm);
+	int r = 0;
+
+	if (usage_count != 1)
+		return 0;
+
+	atomic_set(&hardware_enable_failed, 0);
+	on_each_cpu(hardware_enable_nolock, NULL, 1);
+
+	if (atomic_read(&hardware_enable_failed)) {
+		r = -EBUSY;
+		goto err;
+	}
+
+	r = kvm_arch_post_init_vm(kvm);
+err:
+	if (r)
+		on_each_cpu(hardware_disable_nolock, NULL, 1);
+	return r;
 }
 
 __weak int kvm_arch_del_vm(int usage_count)
 {
+	if (usage_count)
+		return 0;
+
+	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	return 0;
 }
 
 __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
+	if (usage_count)
+		hardware_enable_nolock(NULL);
 	return 0;
 }
 
 __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
 {
+	if (usage_count)
+		hardware_disable_nolock(NULL);
 	return 0;
 }
 
 __weak int kvm_arch_reboot(int val)
 {
+	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	return NOTIFY_OK;
 }
 
 __weak int kvm_arch_suspend(int usage_count)
 {
+	if (usage_count)
+		hardware_disable_nolock(NULL);
 	return 0;
 }
 
 __weak void kvm_arch_resume(int usage_count)
 {
+	if (usage_count)
+		hardware_enable_nolock(NULL);
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0ba370acff8d..5b8e8addd1e5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,9 +102,7 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 DEFINE_MUTEX(kvm_lock);
 LIST_HEAD(vm_list);
 
-static cpumask_var_t cpus_hardware_enabled;
 static int kvm_usage_count;
-static atomic_t hardware_enable_failed;
 
 static struct kmem_cache *kvm_vcpu_cache;
 
@@ -142,8 +140,6 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
 static void kvm_del_vm(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
@@ -1190,10 +1186,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
-	r = hardware_enable_all();
-	if (r)
-		goto out_err_no_disable;
-
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
@@ -1202,14 +1194,18 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_mmu_notifier;
 
+	cpus_read_lock();
 	mutex_lock(&kvm_lock);
+	kvm_usage_count++;
 	r = kvm_arch_add_vm(kvm, kvm_usage_count);
 	if (r) {
+		/* the following kvm_del_vm() decrements kvm_usage_count. */
 		mutex_unlock(&kvm_lock);
 		goto out_err_mmu_notifier;
 	}
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
 
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
@@ -1238,9 +1234,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	hardware_disable_all();
 	kvm_del_vm();
-out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
 	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
@@ -1318,7 +1312,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	cleanup_srcu_struct(&kvm->srcu);
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
-	hardware_disable_all();
 	kvm_del_vm();
 	mmdrop(mm);
 	module_put(kvm_chardev_ops.owner);
@@ -4988,110 +4981,33 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-static void hardware_enable_nolock(void *junk)
-{
-	int cpu = raw_smp_processor_id();
-	int r;
-
-	WARN_ON_ONCE(preemptible());
-
-	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
-		return;
-
-	cpumask_set_cpu(cpu, cpus_hardware_enabled);
-
-	r = kvm_arch_hardware_enable();
-
-	if (r) {
-		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
-		atomic_inc(&hardware_enable_failed);
-		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
-	}
-}
-
 static int kvm_starting_cpu(unsigned int cpu)
 {
 	mutex_lock(&kvm_lock);
-	if (kvm_usage_count)
-		hardware_enable_nolock(NULL);
 	(void)kvm_arch_online_cpu(cpu, kvm_usage_count);
 	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
-static void hardware_disable_nolock(void *junk)
-{
-	int cpu = raw_smp_processor_id();
-
-	WARN_ON_ONCE(preemptible());
-
-	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
-		return;
-	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
-	kvm_arch_hardware_disable();
-}
-
 static int kvm_dying_cpu(unsigned int cpu)
 {
 	mutex_lock(&kvm_lock);
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
 	(void)kvm_arch_offline_cpu(cpu, kvm_usage_count);
 	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
-static void hardware_disable_all_nolock(void)
-{
-	BUG_ON(!kvm_usage_count);
-
-	kvm_usage_count--;
-	if (!kvm_usage_count)
-		on_each_cpu(hardware_disable_nolock, NULL, 1);
-}
-
-static void hardware_disable_all(void)
-{
-	cpus_read_lock();
-	mutex_lock(&kvm_lock);
-	hardware_disable_all_nolock();
-	mutex_unlock(&kvm_lock);
-	cpus_read_unlock();
-}
-
 static void kvm_del_vm(void)
 {
 	cpus_read_lock();
 	mutex_lock(&kvm_lock);
+	WARN_ON_ONCE(!kvm_usage_count);
+	kvm_usage_count--;
 	kvm_arch_del_vm(kvm_usage_count);
 	mutex_unlock(&kvm_lock);
 	cpus_read_unlock();
 }
 
-static int hardware_enable_all(void)
-{
-	int r = 0;
-
-	cpus_read_lock();
-	mutex_lock(&kvm_lock);
-
-	kvm_usage_count++;
-	if (kvm_usage_count == 1) {
-		atomic_set(&hardware_enable_failed, 0);
-		on_each_cpu(hardware_enable_nolock, NULL, 1);
-
-		if (atomic_read(&hardware_enable_failed)) {
-			hardware_disable_all_nolock();
-			r = -EBUSY;
-		}
-	}
-
-	mutex_unlock(&kvm_lock);
-	cpus_read_unlock();
-
-	return r;
-}
-
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		      void *v)
 {
@@ -5109,7 +5025,6 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 	/* This hook is called without cpuhotplug disabled.  */
 	cpus_read_lock();
 	mutex_lock(&kvm_lock);
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	r = kvm_arch_reboot(val);
 	mutex_unlock(&kvm_lock);
 	cpus_read_unlock();
@@ -5708,17 +5623,13 @@ static int kvm_suspend(void)
 	 * locking.
 	 */
 	lockdep_assert_not_held(&kvm_lock);
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
 	return kvm_arch_suspend(kvm_usage_count);
 }
 
 static void kvm_resume(void)
 {
-	kvm_arch_resume(kvm_usage_count);
 	lockdep_assert_not_held(&kvm_lock);
-	if (kvm_usage_count)
-		hardware_enable_nolock(NULL);
+	kvm_arch_resume(kvm_usage_count);
 }
 
 static struct syscore_ops kvm_syscore_ops = {
@@ -5864,11 +5775,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r)
 		goto out_irqfd;
 
-	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
-		r = -ENOMEM;
-		goto out_free_0;
-	}
-
 	r = kvm_arch_hardware_setup(opaque);
 	if (r < 0)
 		goto out_free_1;
@@ -5947,8 +5853,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 out_free_2:
 	kvm_arch_hardware_unsetup();
 out_free_1:
-	free_cpumask_var(cpus_hardware_enabled);
-out_free_0:
 	kvm_irqfd_exit();
 out_irqfd:
 	kvm_arch_exit();
@@ -5970,11 +5874,12 @@ void kvm_exit(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	cpus_read_lock();
+	kvm_arch_pre_hardware_unsetup();
 	kvm_arch_hardware_unsetup();
+	cpus_read_unlock();
 	kvm_arch_exit();
 	kvm_irqfd_exit();
-	free_cpumask_var(cpus_hardware_enabled);
 	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
-- 
2.25.1

