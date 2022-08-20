Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD4159ABA9
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244848AbiHTGA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244283AbiHTGAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:51 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9DAA2237;
        Fri, 19 Aug 2022 23:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975250; x=1692511250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0VoHVBGgGCiqNYxpIdpSYtKotvAu6f6dsiGvmJLhrGw=;
  b=OJsqD0mfjj3datvCkTy/yTzdDc4Z+iEsxaxxFn6xK250u0X3U0BSmoNJ
   xnduV6HZTcxgvqxCuMnrfTVloTpDrIkBsGhbMtx8yr4nloeOR2JRSyf9v
   +jaPZtei1SpkttXsKr0tx5cfTvE4mS/Bcn1cR8G16kDUPxakgc8xS4ybg
   La6Ez0/C1CwYGMi1llQ10kmAPLJqeP5y4KqP6XYzukKotBzp5W6LrzlGl
   4nEI+s9kGQPSF2fzwnYSxlHKvSkTbDKxaqinRzm3rw7bqp9G6pKRORhGJ
   TUtXKyqZVd66CjtZn2oHD2OrIVKY0x5SnUzTiBQNeKEJ390EF5WLBrR2z
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448970"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448970"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857520"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 04/18] KVM: Add arch hooks for PM events with empty stub
Date:   Fri, 19 Aug 2022 23:00:10 -0700
Message-Id: <7f603a52229f8a31faf14a299daea114ec17b0e2.1660974106.git.isaku.yamahata@intel.com>
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

Add arch hooks for reboot, suspend, resume, and CPU-online/offline events
with empty stub functions.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  6 ++++++
 virt/kvm/Makefile.kvm    |  2 +-
 virt/kvm/kvm_arch.c      | 44 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 35 ++++++++++++++++----------------
 4 files changed, 69 insertions(+), 18 deletions(-)
 create mode 100644 virt/kvm/kvm_arch.c

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1c480b1821e1..c38f382f3808 100644
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
index c6781fa30461..8d08126e6c74 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1095,15 +1095,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
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
@@ -5019,6 +5010,7 @@ static int kvm_starting_cpu(unsigned int cpu)
 	mutex_lock(&kvm_lock);
 	if (kvm_usage_count)
 		hardware_enable_nolock(NULL);
+	(void)kvm_arch_online_cpu(cpu, kvm_usage_count);
 	mutex_unlock(&kvm_lock);
 	return 0;
 }
@@ -5040,6 +5032,7 @@ static int kvm_dying_cpu(unsigned int cpu)
 	mutex_lock(&kvm_lock);
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
+	(void)kvm_arch_offline_cpu(cpu, kvm_usage_count);
 	mutex_unlock(&kvm_lock);
 	return 0;
 }
@@ -5089,6 +5082,8 @@ static int hardware_enable_all(void)
 static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 		      void *v)
 {
+	int r;
+
 	/*
 	 * Some (well, at least mine) BIOSes hang on reboot if
 	 * in vmx root mode.
@@ -5097,8 +5092,15 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
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
@@ -5692,19 +5694,18 @@ static int kvm_suspend(void)
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
 {
-	if (kvm_usage_count) {
-		lockdep_assert_not_held(&kvm_lock);
+	kvm_arch_resume(kvm_usage_count);
+	lockdep_assert_not_held(&kvm_lock);
+	if (kvm_usage_count)
 		hardware_enable_nolock(NULL);
-	}
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.25.1

