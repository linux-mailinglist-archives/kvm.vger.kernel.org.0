Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFFE5AA5AF
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbiIBCSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbiIBCSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B254AA4D2;
        Thu,  1 Sep 2022 19:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085096; x=1693621096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hOhh4GoFkQ/xtdVMA3+Q0KS0VbalWCjftEXGGduxifM=;
  b=BxfJjQkMsNLLh/Olj9X12G1pKondr8KDzyvv4jX+V4nn+E6Y+l/A2Xx9
   QK357aMjO7pFQ6hqsA7AD4KShosG0G2lsjyYqDW2izXKMVo171ODm8zCO
   dl6qU3fEMwDgyH246aCF6nweYyvzaIDgYAh3cvhs9OJbXgvOKYF2Ye8Bo
   KzLDJAv3w6i/qCo/nwQLgO9dFVANUsw4cdCeTJld9pLc0owN7lJf7JQp0
   HfYhq+GbTyG4yeEPK8xduw6dbyIjSNT/K0ZkwaGkmJfe/akLKU+na23BF
   ZeG6FTrpaK4brtn4SzPTKb9WbVde1yzBsWqzbpBN8ktZpKzfEi/Sw5N39
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157849"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157849"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835633"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:15 -0700
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
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v3 11/22] KVM: Add arch hooks for PM events with empty stub
Date:   Thu,  1 Sep 2022 19:17:46 -0700
Message-Id: <22e86b718ae434e52957d5af9b4c7dd26b2a74ca.1662084396.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662084396.git.isaku.yamahata@intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
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

Add arch hooks for reboot, suspend, resume, and CPU-online/offline events
with empty stub functions.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  6 +++++
 virt/kvm/Makefile.kvm    |  2 +-
 virt/kvm/kvm_arch.c      | 44 +++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 50 +++++++++++++++++++++++++---------------
 4 files changed, 82 insertions(+), 20 deletions(-)
 create mode 100644 virt/kvm/kvm_arch.c

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eab352902de7..dd2a6d98d4de 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1448,6 +1448,12 @@ int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
 
+int kvm_arch_suspend(int usage_count);
+void kvm_arch_resume(int usage_count);
+int kvm_arch_reboot(int val);
+int kvm_arch_online_cpu(unsigned int cpu, int usage_count);
+int kvm_arch_offline_cpu(unsigned int cpu, int usage_count);
+
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
  * All architectures that want to use vzalloc currently also
diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
index 2c27d5d0c367..c4210acabd35 100644
--- a/virt/kvm/Makefile.kvm
+++ b/virt/kvm/Makefile.kvm
@@ -5,7 +5,7 @@
 
 KVM ?= ../../../virt/kvm
 
-kvm-y := $(KVM)/kvm_main.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
+kvm-y := $(KVM)/kvm_main.o $(KVM)/kvm_arch.o $(KVM)/eventfd.o $(KVM)/binary_stats.o
 kvm-$(CONFIG_KVM_VFIO) += $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_MMIO) += $(KVM)/coalesced_mmio.o
 kvm-$(CONFIG_KVM_ASYNC_PF) += $(KVM)/async_pf.o
diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
new file mode 100644
index 000000000000..4748a76bcb03
--- /dev/null
+++ b/virt/kvm/kvm_arch.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kvm_arch.c: kvm default arch hooks for hardware enabling/disabling
+ * Copyright (c) 2022 Intel Corporation.
+ *
+ * Author:
+ *   Isaku Yamahata <isaku.yamahata@intel.com>
+ *                  <isaku.yamahata@gmail.com>
+ */
+
+#include <linux/kvm_host.h>
+
+/*
+ * Called after the VM is otherwise initialized, but just before adding it to
+ * the vm_list.
+ */
+__weak int kvm_arch_post_init_vm(struct kvm *kvm)
+{
+	return 0;
+}
+
+__weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
+{
+	return 0;
+}
+
+__weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
+{
+	return 0;
+}
+
+__weak int kvm_arch_reboot(int val)
+{
+	return NOTIFY_OK;
+}
+
+__weak int kvm_arch_suspend(int usage_count)
+{
+	return 0;
+}
+
+__weak void kvm_arch_resume(int usage_count)
+{
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 082d5dbc8d7f..e62240fb8474 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -144,6 +144,7 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
 #endif
 static int hardware_enable_all(void);
 static void hardware_disable_all(void);
+static void hardware_disable_nolock(void *junk);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
@@ -1097,15 +1098,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
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
 /*
  * Called just after removing the VM from the vm_list, but before doing any
  * other destruction.
@@ -5033,6 +5025,10 @@ static int kvm_online_cpu(unsigned int cpu)
 		if (atomic_read(&hardware_enable_failed)) {
 			atomic_set(&hardware_enable_failed, 0);
 			ret = -EIO;
+		} else {
+			ret = kvm_arch_online_cpu(cpu, kvm_usage_count);
+			if (ret)
+				hardware_disable_nolock(NULL);
 		}
 	}
 	mutex_unlock(&kvm_lock);
@@ -5053,11 +5049,19 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
+	int ret = 0;
+
 	mutex_lock(&kvm_lock);
-	if (kvm_usage_count)
+	if (kvm_usage_count) {
 		hardware_disable_nolock(NULL);
+		ret = kvm_arch_offline_cpu(cpu, kvm_usage_count);
+		if (ret) {
+			(void)hardware_enable_nolock(NULL);
+			atomic_set(&hardware_enable_failed, 0);
+		}
+	}
 	mutex_unlock(&kvm_lock);
-	return 0;
+	return ret;
 }
 
 static void hardware_disable_all_nolock(void)
@@ -5115,6 +5119,8 @@ static int hardware_enable_all(void)
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		      void *v)
 {
+	int r;
+
 	/*
 	 * Some (well, at least mine) BIOSes hang on reboot if
 	 * in vmx root mode.
@@ -5123,8 +5129,15 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 	 */
 	pr_info("kvm: exiting hardware virtualization\n");
 	kvm_rebooting = true;
+
+	/* This hook is called without cpuhotplug disabled.  */
+	cpus_read_lock();
+	mutex_lock(&kvm_lock);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
-	return NOTIFY_OK;
+	r = kvm_arch_reboot(val);
+	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
+	return r;
 }
 
 static struct notifier_block kvm_reboot_notifier = {
@@ -5718,11 +5731,10 @@ static int kvm_suspend(void)
 	 * cpu_hotplug_disable() and other CPUs are offlined.  No need for
 	 * locking.
 	 */
-	if (kvm_usage_count) {
-		lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_not_held(&kvm_lock);
+	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
-	}
-	return 0;
+	return kvm_arch_suspend(kvm_usage_count);
 }
 
 static void kvm_resume(void)
@@ -5734,10 +5746,10 @@ static void kvm_resume(void)
 		 */
 		return; /* FIXME: disable KVM */
 
-	if (kvm_usage_count) {
-		lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_not_held(&kvm_lock);
+	kvm_arch_resume(kvm_usage_count);
+	if (kvm_usage_count)
 		hardware_enable_nolock((void *)__func__);
-	}
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.25.1

