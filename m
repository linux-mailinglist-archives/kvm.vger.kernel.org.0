Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8791F5B2A3F
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiIHX0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiIHX0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F5BFF0A0;
        Thu,  8 Sep 2022 16:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679573; x=1694215573;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CB6pdMtWrveFUnO2jvTSztQL9r1rUdSNl46pxYfNIgQ=;
  b=MEE+M0ynZt+iqNyqnPFdAbNf0qTmTXJD0JFQj5cm9uzWwsbcy8iQ4McW
   v1ABDdmz1hDPakES/MHre4c+bGDNdXBV9pJbV2H41ZMhHMngFzxqE39EU
   o2/plgtHci9g6vmcD6H6A+uboaHORyU15K62l9GfBliEQqyRLcN/NSmex
   y0z7cGs/zIj6n1VDyN21jYYGkKpZFoc+RIyAzX7WqioYPioOYArOWxEYh
   kleyDIkCFLnB0S1k1SNMDleikzqUzuiMVP+0ZtNTPaWORJgXgXvz0TTmo
   zj+4D8IAP+DuCmuga8MAaW054rOHzezBdMu+nl3YXzWNPCWjFTDooVqR8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687012"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687012"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863229"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:10 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v4 14/26] KVM: Move out KVM arch PM hooks and hardware enable/disable logic
Date:   Thu,  8 Sep 2022 16:25:30 -0700
Message-Id: <7face8cdec33c84f3aed7e8d400b5adf24fc5c75.1662679124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662679124.git.isaku.yamahata@intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
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
kvm_arch_hardware_unsetup() in each arch code. x86 kvm_arch_resume() needs
to be adjusted to do CPU compatibility check and virtualization hardware
enabling.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c       |  10 ++
 include/linux/kvm_host.h |   1 +
 virt/kvm/kvm_arch.c      | 124 +++++++++++++++++++++++-
 virt/kvm/kvm_main.c      | 198 +++++----------------------------------
 4 files changed, 156 insertions(+), 177 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c733f65aaf3c..23623b6a789b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11854,9 +11854,19 @@ void kvm_arch_resume(int usage_count)
 	u64 max_tsc = 0;
 	bool stable, backwards_tsc = false;
 
+	if (kvm_arch_check_processor_compat())
+		return; /* FIXME: disable KVM. */
+
 	if (!usage_count)
 		return;
 
+	preempt_disable();
+	if (kvm_arch_hardware_enable()) {
+		preempt_enable();
+		return;
+	}
+	preempt_enable();
+
 	local_tsc = rdtsc();
 	stable = !kvm_check_tsc_unstable();
 	list_for_each_entry(kvm, &vm_list, vm_list) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f78364e01ca9..60f4ae9d6f48 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1437,6 +1437,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
+void kvm_arch_pre_hardware_unsetup(void);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 0eac996f4981..32befdbf7d6e 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -6,49 +6,169 @@
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
 
+static void hardware_enable_nolock(void *caller_name)
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
+		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
+			cpu, (const char *)caller_name);
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
+	on_each_cpu(hardware_enable_nolock, (void *)__func__, 1);
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
-	return 0;
+	int ret = 0;
+
+	ret = kvm_arch_check_processor_compat();
+	if (ret)
+		return ret;
+
+	/*
+	 * Abort the CPU online process if hardware virtualization cannot
+	 * be enabled. Otherwise running VMs would encounter unrecoverable
+	 * errors when scheduled to this CPU.
+	 */
+	if (usage_count) {
+		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
+
+		/*
+		 * arch callback kvm_arch_hardware_eanble() assumes that
+		 * preemption is disabled for historical reason.  Disable
+		 * preemption until all arch callbacks are fixed.
+		 */
+		preempt_disable();
+		hardware_enable_nolock((void *)__func__);
+		preempt_enable();
+		if (atomic_read(&hardware_enable_failed)) {
+			atomic_set(&hardware_enable_failed, 0);
+			ret = -EIO;
+		}
+	}
+	return ret;
 }
 
 __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
 {
+	if (usage_count) {
+		/*
+		 * arch callback kvm_arch_hardware_disable() assumes that
+		 * preemption is disabled for historical reason.  Disable
+		 * preemption until all arch callbacks are fixed.
+		 */
+		preempt_disable();
+		hardware_disable_nolock(NULL);
+		preempt_enable();
+	}
 	return 0;
 }
 
 __weak int kvm_arch_reboot(int val)
 {
+	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	return NOTIFY_OK;
 }
 
 __weak int kvm_arch_suspend(int usage_count)
 {
+	if (usage_count) {
+		preempt_disable();
+		hardware_disable_nolock(NULL);
+		preempt_enable();
+	}
 	return 0;
 }
 
 __weak void kvm_arch_resume(int usage_count)
 {
+	if (kvm_arch_check_processor_compat())
+		/*
+		 * No warning here because kvm_arch_check_processor_compat()
+		 * would have warned with more information.
+		 */
+		return; /* FIXME: disable KVM */
+
+	if (usage_count) {
+		preempt_disable();
+		hardware_enable_nolock((void *)__func__);
+		preempt_enable();
+	}
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7acc35e279ec..5373127dcdb6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -102,9 +102,7 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
 DEFINE_MUTEX(kvm_lock);
 LIST_HEAD(vm_list);
 
-static cpumask_var_t cpus_hardware_enabled;
 static int kvm_usage_count;
-static atomic_t hardware_enable_failed;
 
 static struct kmem_cache *kvm_vcpu_cache;
 
@@ -142,9 +140,6 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
-static void hardware_disable_nolock(void *junk);
 static void kvm_del_vm(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
@@ -1196,10 +1191,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
-	r = hardware_enable_all();
-	if (r)
-		goto out_err_no_disable;
-
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
@@ -1216,14 +1207,28 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_debugfs;
 
+	/*
+	 * During onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
+	 * is called. on_each_cpu() between them includes the CPU. As a result,
+	 * hardware_enable_nolock() may get invoked before kvm_online_cpu().
+	 * This would enable hardware virtualization on that cpu without
+	 * compatibility checks, which can potentially crash system or break
+	 * running VMs.
+	 *
+	 * Disable CPU hotplug to prevent this case from happening.
+	 */
+	cpus_read_lock();
 	mutex_lock(&kvm_lock);
+	kvm_usage_count++;
 	r = kvm_arch_add_vm(kvm, kvm_usage_count);
 	if (r) {
+		/* the following kvm_del_vm() decrements kvm_usage_count. */
 		mutex_unlock(&kvm_lock);
 		goto out_err;
 	}
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
 
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
@@ -1240,9 +1245,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	hardware_disable_all();
 	kvm_del_vm();
-out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
 	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
@@ -1321,7 +1324,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	cleanup_srcu_struct(&kvm->srcu);
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
-	hardware_disable_all();
 	kvm_del_vm();
 	mmdrop(mm);
 	module_put(kvm_chardev_ops.owner);
@@ -4986,163 +4988,37 @@ static struct miscdevice kvm_dev = {
 	&kvm_chardev_ops,
 };
 
-static void hardware_enable_nolock(void *caller_name)
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
-		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
-			cpu, (const char *)caller_name);
-	}
-}
-
 static int kvm_online_cpu(unsigned int cpu)
 {
 	int ret;
 
-	ret = kvm_arch_check_processor_compat();
-	if (ret)
-		return ret;
-
 	mutex_lock(&kvm_lock);
-	/*
-	 * Abort the CPU online process if hardware virtualization cannot
-	 * be enabled. Otherwise running VMs would encounter unrecoverable
-	 * errors when scheduled to this CPU.
-	 */
-	if (kvm_usage_count) {
-		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
-
-		/*
-		 * arch callback kvm_arch_hardware_eanble() assumes that
-		 * preemption is disabled for historical reason.  Disable
-		 * preemption until all arch callbacks are fixed.
-		 */
-		preempt_disable();
-		hardware_enable_nolock((void *)__func__);
-		preempt_enable();
-		if (atomic_read(&hardware_enable_failed)) {
-			atomic_set(&hardware_enable_failed, 0);
-			ret = -EIO;
-		} else {
-			ret = kvm_arch_online_cpu(cpu, kvm_usage_count);
-			if (ret)
-				hardware_disable_nolock(NULL);
-		}
-	}
+	ret = kvm_arch_online_cpu(cpu, kvm_usage_count);
 	mutex_unlock(&kvm_lock);
 	return ret;
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
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&kvm_lock);
-	if (kvm_usage_count) {
-		/*
-		 * arch callback kvm_arch_hardware_disable() assumes that
-		 * preemption is disabled for historical reason.  Disable
-		 * preemption until all arch callbacks are fixed.
-		 */
-		preempt_disable();
-		hardware_disable_nolock(NULL);
-		ret = kvm_arch_offline_cpu(cpu, kvm_usage_count);
-		if (ret) {
-			(void)hardware_enable_nolock(NULL);
-			atomic_set(&hardware_enable_failed, 0);
-		}
-		preempt_enable();
-	}
+	ret = kvm_arch_offline_cpu(cpu, kvm_usage_count);
 	mutex_unlock(&kvm_lock);
 	return ret;
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
-	/*
-	 * During onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
-	 * is called. on_each_cpu() between them includes the CPU. As a result,
-	 * hardware_enable_nolock() may get invoked before kvm_online_cpu().
-	 * This would enable hardware virtualization on that cpu without
-	 * compatibility checks, which can potentially crash system or break
-	 * running VMs.
-	 *
-	 * Disable CPU hotplug to prevent this case from happening.
-	 */
-	cpus_read_lock();
-	mutex_lock(&kvm_lock);
-
-	kvm_usage_count++;
-	if (kvm_usage_count == 1) {
-		atomic_set(&hardware_enable_failed, 0);
-		on_each_cpu(hardware_enable_nolock, (void *)__func__, 1);
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
@@ -5160,7 +5036,6 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 	/* This hook is called without cpuhotplug disabled.  */
 	cpus_read_lock();
 	mutex_lock(&kvm_lock);
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	r = kvm_arch_reboot(val);
 	mutex_unlock(&kvm_lock);
 	cpus_read_unlock();
@@ -5753,40 +5628,19 @@ static void kvm_init_debug(void)
 
 static int kvm_suspend(void)
 {
-	int ret;
-
 	/*
 	 * The caller ensures that CPU hotlug is disabled by
 	 * cpu_hotplug_disable() and other CPUs are offlined.  No need for
 	 * locking.
 	 */
 	lockdep_assert_not_held(&kvm_lock);
-
-	preempt_disable();
-	if (kvm_usage_count)
-		hardware_disable_nolock(NULL);
-	ret = kvm_arch_suspend(kvm_usage_count);
-	preempt_enable();
-
-	return ret;
+	return kvm_arch_suspend(kvm_usage_count);
 }
 
 static void kvm_resume(void)
 {
 	lockdep_assert_not_held(&kvm_lock);
-
-	if (kvm_arch_check_processor_compat())
-		/*
-		 * No warning here because kvm_arch_check_processor_compat()
-		 * would have warned with more information.
-		 */
-		return; /* FIXME: disable KVM */
-
-	preempt_disable();
-	if (kvm_usage_count)
-		hardware_enable_nolock((void *)__func__);
 	kvm_arch_resume(kvm_usage_count);
-	preempt_enable();
 }
 
 static struct syscore_ops kvm_syscore_ops = {
@@ -5924,11 +5778,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
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
@@ -6005,8 +5854,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 out_free_2:
 	kvm_arch_hardware_unsetup();
 out_free_1:
-	free_cpumask_var(cpus_hardware_enabled);
-out_free_0:
 	kvm_irqfd_exit();
 out_irqfd:
 	kvm_arch_exit();
@@ -6028,11 +5875,12 @@ void kvm_exit(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
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

