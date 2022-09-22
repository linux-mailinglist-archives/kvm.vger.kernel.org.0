Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0515E6A9B
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiIVSVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbiIVSVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:21:32 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9529FFA41;
        Thu, 22 Sep 2022 11:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870888; x=1695406888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zO1wIEhxQ5q5ko0adH4xh6bT/ltNKHCmmVgWcfEpVrI=;
  b=bkqY5mYGxflNeOmeZfvI4Hc1Rh9Snqov0damjqqtGcstDzo+8gmwkj5L
   6Dfbtn7IU/keD9U1hdaeKx0s/G2903tzVwPQGfAKmKWh6UfOt7xTawcmS
   rj3gMTI7vxqDhyGxlSlmDKAsNZNd/nJDT6UpsL4RkbRSK5WTXyj3fjcBv
   l3zkLMZC3Aa2I9h1uqE6AGEUP8y+2SyHEfBB1BsAH9mNHTzuJtiSukOGv
   ceGRp7vjJp0BvVJ/qH6AYI8vTPf3t+iYMbJVicmMi7IPoW/Kd9x7J+h1j
   J09SDl03B0xWCIpwKyS/qJiS61nmxWRAwp5Xiev47zAaTZZnCe6JnWw5i
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="386675979"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="386675979"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086707"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:18 -0700
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
Subject: [PATCH v5 10/30] KVM: Add arch hooks when VM is added/deleted
Date:   Thu, 22 Sep 2022 11:20:39 -0700
Message-Id: <aab342d576fe22b8f5b27e61d4fc635d45a4f866.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

and pass kvm_usage_count with kvm_lock.  Move kvm_arch_post_init_vm() under
kvm_arch_add_vm().  Replace enable/disable_hardware_all() with the default
implementation of kvm_arch_add/del_vm().  Later kvm_arch_post_init_vm() is
deleted once x86 overrides kvm_arch_add_vm().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |   2 +
 virt/kvm/kvm_main.c      | 121 ++++++++++++++++++++-------------------
 2 files changed, 65 insertions(+), 58 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eab352902de7..3fbb01bbac98 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1445,6 +1445,8 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
+int kvm_arch_add_vm(struct kvm *kvm, int usage_count);
+int kvm_arch_del_vm(int usage_count);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c4b908553726..e2c8823786ff 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -142,8 +142,9 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
 			.open		= kvm_no_compat_open
 #endif
-static int hardware_enable_all(void);
-static void hardware_disable_all(void);
+static void hardware_enable_nolock(void *junk);
+static void hardware_disable_nolock(void *junk);
+static void kvm_del_vm(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1106,6 +1107,41 @@ int __weak kvm_arch_post_init_vm(struct kvm *kvm)
 	return 0;
 }
 
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
 /*
  * Called just after removing the VM from the vm_list, but before doing any
  * other destruction.
@@ -1203,10 +1239,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_arch_destroy_vm;
 
-	r = hardware_enable_all();
-	if (r)
-		goto out_err_no_disable;
-
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
@@ -1223,13 +1255,28 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err_no_debugfs;
 
-	r = kvm_arch_post_init_vm(kvm);
-	if (r)
-		goto out_err;
-
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
+	r = kvm_arch_add_vm(kvm, kvm_usage_count);
+	if (r) {
+		/* the following kvm_del_vm() decrements kvm_usage_count. */
+		mutex_unlock(&kvm_lock);
+		goto out_err;
+	}
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
 
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
@@ -1246,8 +1293,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
 #endif
 out_err_no_mmu_notifier:
-	hardware_disable_all();
-out_err_no_disable:
+	kvm_del_vm();
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
 	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
@@ -1326,7 +1372,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	cleanup_srcu_struct(&kvm->srcu);
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
-	hardware_disable_all();
+	kvm_del_vm();
 	mmdrop(mm);
 	module_put(kvm_chardev_ops.owner);
 }
@@ -5075,56 +5121,15 @@ static int kvm_offline_cpu(unsigned int cpu)
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
+static void kvm_del_vm(void)
 {
 	cpus_read_lock();
 	mutex_lock(&kvm_lock);
-	hardware_disable_all_nolock();
-	mutex_unlock(&kvm_lock);
-	cpus_read_unlock();
-}
-
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
-		on_each_cpu(hardware_enable_nolock, NULL, 1);
-
-		if (atomic_read(&hardware_enable_failed)) {
-			hardware_disable_all_nolock();
-			r = -EBUSY;
-		}
-	}
-
+	WARN_ON_ONCE(!kvm_usage_count);
+	kvm_usage_count--;
+	kvm_arch_del_vm(kvm_usage_count);
 	mutex_unlock(&kvm_lock);
 	cpus_read_unlock();
-
-	return r;
 }
 
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
-- 
2.25.1

