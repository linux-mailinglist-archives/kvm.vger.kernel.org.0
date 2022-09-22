Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16C105E6ACA
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbiIVSXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiIVSWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:22:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D2610AB20;
        Thu, 22 Sep 2022 11:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870909; x=1695406909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fanfknRHqXqNCiNeSiwe63GR4M0QgQwb/iuuXUqHmiw=;
  b=d6kBaUFeyAW4iSTcSUUwUJ9JCh3kXvyKzQQKn9GW2oJYxUjCm/0gzmw0
   j//VdLCnPuQZg1VPQ0ThaVv4U7KRVJJDlXEbONjgLlUCkmobWP6d2l0Xx
   hnGOSPKNHCpa2ZsNhca01JFPOurLx8tiJ6EpWWMuoBmTyzsiCt7TZVq5B
   kLqdASF/NYqrCV8c8as1lLvkub4KycurYFua6x66El+YKZea8y6KuBIUA
   zACtvXjpaOJZ9VUVLZnXoEHMi+rvBd+IY1Q+sjtm78sKag9r1t28O7vSB
   wbbNqXpchKdBQaf8F7PN1Zj2+gFzQGPlUPXHIxzp5nV1lJnxwZjT7vlLB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712896"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712896"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:22 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086765"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:22 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 17/30] KVM: Move out KVM arch PM hooks and hardware enable/disable logic
Date:   Thu, 22 Sep 2022 11:20:46 -0700
Message-Id: <245445b7326fb86cdae11ad2709d5f3dac3c9e53.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

To make clear that those files are default implementation and that KVM/x86
(and other KVM arch in future) will override them, split out those into a
dedicated file.  Once conversions for all kvm archs are done, the file will
be deleted.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/Makefile.kvm |   2 +-
 virt/kvm/kvm_arch.c   | 164 ++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c   | 160 -----------------------------------------
 3 files changed, 165 insertions(+), 161 deletions(-)
 create mode 100644 virt/kvm/kvm_arch.c

diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 2c27d5d0c367..428b09b3f80a 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -5,7 +5,7 @@
 
 KVM ?= ../../../virt/kvm
 
-kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
+kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o $(KVM)/kvm_arch.o
 kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
 kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
new file mode 100644
index 000000000000..bcf8b74144e3
--- /dev/null
+++ b/virt/kvm/kvm_arch.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kvm_arch.c: kvm default arch hooks for hardware enabling/disabling
+ * Copyright (c) 2022 Intel Corporation.
+ *
+ * Author:
+ *   Isaku Yamahata <isaku.yamahata@intel.com>
+ *                  <isaku.yamahata@gmail.com>
+ *
+ * TODO: Delete this file once the conversion of all KVM arch is done.
+ */
+
+#include <linux/kvm_host.h>
+
+static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
+static atomic_t hardware_enable_failed;
+
+/*
+ * Called after the VM is otherwise initialized, but just before adding it to
+ * the vm_list.
+ */
+int __weak kvm_arch_post_init_vm(struct kvm *kvm)
+{
+	return 0;
+}
+
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
+		pr_warn("kvm: enabling virtualization on CPU%d failed during %pSb\n",
+			cpu, __builtin_return_address(0));
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
+/*
+ * Called after the VM is otherwise initialized, but just before adding it to
+ * the vm_list.
+ */
+int __weak kvm_arch_add_vm(struct kvm *kvm, int usage_count)
+{
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
+}
+
+int __weak kvm_arch_del_vm(int usage_count)
+{
+	if (usage_count)
+		return 0;
+
+	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	return 0;
+}
+
+int __weak kvm_arch_online_cpu(unsigned int cpu, int usage_count)
+{
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
+		hardware_enable_nolock(NULL);
+		preempt_enable();
+		if (atomic_read(&hardware_enable_failed)) {
+			atomic_set(&hardware_enable_failed, 0);
+			ret = -EIO;
+		}
+	}
+	return ret;
+}
+
+int __weak kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
+{
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
+	return 0;
+}
+
+int __weak kvm_arch_reboot(int val)
+{
+	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	return NOTIFY_OK;
+}
+
+int __weak kvm_arch_suspend(int usage_count)
+{
+	if (usage_count)
+		/*
+		 * Because kvm_suspend() is called with interrupt disabled,  no
+		 * need to disable preemption.
+		 */
+		hardware_disable_nolock(NULL);
+	return 0;
+}
+
+void __weak kvm_arch_resume(int usage_count)
+{
+	if (usage_count)
+		hardware_enable_nolock(NULL);
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d7c3bc14691f..b1a09d2d5982 100644
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
-static void hardware_enable_nolock(void *junk);
-static void hardware_disable_nolock(void *junk);
 static void kvm_del_vm(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
@@ -1098,120 +1094,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	return ret;
 }
 
-/*
- * Called after the VM is otherwise initialized, but just before adding it to
- * the vm_list.
- */
-int __weak kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return 0;
-}
-
-/*
- * Called after the VM is otherwise initialized, but just before adding it to
- * the vm_list.
- */
-int __weak kvm_arch_add_vm(struct kvm *kvm, int usage_count)
-{
-	int r = 0;
-
-	if (usage_count != 1)
-		return 0;
-
-	atomic_set(&hardware_enable_failed, 0);
-	on_each_cpu(hardware_enable_nolock, NULL, 1);
-
-	if (atomic_read(&hardware_enable_failed)) {
-		r = -EBUSY;
-		goto err;
-	}
-
-	r = kvm_arch_post_init_vm(kvm);
-err:
-	if (r)
-		on_each_cpu(hardware_disable_nolock, NULL, 1);
-	return r;
-}
-
-int __weak kvm_arch_del_vm(int usage_count)
-{
-	if (usage_count)
-		return 0;
-
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
-	return 0;
-}
-
-int __weak kvm_arch_online_cpu(unsigned int cpu, int usage_count)
-{
-	int ret = 0;
-
-	ret = kvm_arch_check_processor_compat();
-	if (ret)
-		return ret;
-
-	/*
-	 * Abort the CPU online process if hardware virtualization cannot
-	 * be enabled. Otherwise running VMs would encounter unrecoverable
-	 * errors when scheduled to this CPU.
-	 */
-	if (usage_count) {
-		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
-
-		/*
-		 * arch callback kvm_arch_hardware_eanble() assumes that
-		 * preemption is disabled for historical reason.  Disable
-		 * preemption until all arch callbacks are fixed.
-		 */
-		preempt_disable();
-		hardware_enable_nolock(NULL);
-		preempt_enable();
-		if (atomic_read(&hardware_enable_failed)) {
-			atomic_set(&hardware_enable_failed, 0);
-			ret = -EIO;
-		}
-	}
-	return ret;
-}
-
-int __weak kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
-{
-	if (usage_count) {
-		/*
-		 * arch callback kvm_arch_hardware_disable() assumes that
-		 * preemption is disabled for historical reason.  Disable
-		 * preemption until all arch callbacks are fixed.
-		 */
-		preempt_disable();
-		hardware_disable_nolock(NULL);
-		preempt_enable();
-	}
-	return 0;
-}
-
-int __weak kvm_arch_reboot(int val)
-{
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
-	return NOTIFY_OK;
-}
-
-int __weak kvm_arch_suspend(int usage_count)
-{
-	if (usage_count)
-		/*
-		 * Because kvm_suspend() is called with interrupt disabled,  no
-		 * need to disable preemption.
-		 */
-		hardware_disable_nolock(NULL);
-	return 0;
-}
-
-void __weak kvm_arch_resume(int usage_count)
-{
-	if (usage_count)
-		hardware_enable_nolock(NULL);
-}
-
 /*
  * Called just after removing the VM from the vm_list, but before doing any
  * other destruction.
@@ -5106,28 +4988,6 @@ static struct miscdevice kvm_dev = {
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
-		pr_warn("kvm: enabling virtualization on CPU%d failed during %pSb\n",
-			cpu, __builtin_return_address(0));
-	}
-}
-
 static int kvm_online_cpu(unsigned int cpu)
 {
 	int ret;
@@ -5138,18 +4998,6 @@ static int kvm_online_cpu(unsigned int cpu)
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
 	int ret;
@@ -5930,11 +5778,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
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
@@ -6011,8 +5854,6 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 out_free_2:
 	kvm_arch_hardware_unsetup();
 out_free_1:
-	free_cpumask_var(cpus_hardware_enabled);
-out_free_0:
 	kvm_irqfd_exit();
 out_irqfd:
 	kvm_arch_exit();
@@ -6037,7 +5878,6 @@ void kvm_exit(void)
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
 	kvm_irqfd_exit();
-	free_cpumask_var(cpus_hardware_enabled);
 	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
-- 
2.25.1

