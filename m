Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B3B5A62CA
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiH3MC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiH3MCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:02:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D672EA8A5;
        Tue, 30 Aug 2022 05:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860923; x=1693396923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KB0aXNh0+CQxndncWszmaVeXEIeP3GeVpY9ut6U46AE=;
  b=L4+thYa7bSEqYpNMAzB9wv7swEdCQW5m37xa+8wqFvx+KdKn/G5wUhbI
   NYp0tUH0coapCEYqJTAutu/jkdBFhrB8YOj6mRum2xXBKL0Sgw2NPAFGV
   q9C/T0sFpczYPNOGTEKGtFfHKOsXh4yFHQwe3U99o9Ez98AdQvyZ8JBBG
   GFUFJm5lEnkvAkTM84yF0wz/wZTlQ2EsQwLmGCWA1D/KaewqP3hUi+9ls
   oyChMrA5tjv8qfetCOU/XrtqdV6D4FLfmNkaiE2WnyN4kmvv2L72NtdNk
   8A2duSI+k0l9YDctOp1dUV1YlU1n4F78TnINr1ThuniGMU6+9z73uz7u8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870992"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870992"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469654"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:59 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 14/19] KVM: x86: Duplicate arch callbacks related to pm events
Date:   Tue, 30 Aug 2022 05:01:29 -0700
Message-Id: <214d73856dbb76237abf7a267a577ab3c312ad28.1661860550.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661860550.git.isaku.yamahata@intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
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

KVM/X86 can change those callbacks without worrying about breaking other
archs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 131 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 126 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac185e199f69..2485f3d792b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11841,6 +11841,130 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
+static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
+
+int kvm_arch_post_init_vm(struct kvm *kvm)
+{
+	return kvm_mmu_post_init_vm(kvm);
+}
+
+static int __hardware_enable(void)
+{
+	int cpu = raw_smp_processor_id();
+	int r;
+
+	WARN_ON_ONCE(preemptible());
+
+	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
+		return 0;
+	r = kvm_arch_hardware_enable();
+	if (r)
+		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
+	else
+		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+	return r;
+}
+
+static void hardware_enable(void *arg)
+{
+	atomic_t *failed = arg;
+
+	if (__hardware_enable())
+		atomic_inc(failed);
+}
+
+static void hardware_disable(void *junk)
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
+void kvm_arch_pre_hardware_unsetup(void)
+{
+	on_each_cpu(hardware_disable, NULL, 1);
+}
+
+/*
+ * Called after the VM is otherwise initialized, but just before adding it to
+ * the vm_list.
+ */
+int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
+{
+	atomic_t failed;
+	int r = 0;
+
+	if (usage_count != 1)
+		return 0;
+
+	atomic_set(&failed, 0);
+	on_each_cpu(hardware_enable, &failed, 1);
+
+	if (atomic_read(&failed)) {
+		r = -EBUSY;
+		goto err;
+	}
+
+	r = kvm_arch_post_init_vm(kvm);
+err:
+	if (r)
+		on_each_cpu(hardware_disable, NULL, 1);
+	return r;
+}
+
+int kvm_arch_del_vm(int usage_count)
+{
+	if (usage_count)
+		return 0;
+
+	on_each_cpu(hardware_disable, NULL, 1);
+	return 0;
+}
+
+int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
+{
+	int r;
+
+	r = kvm_arch_check_processor_compat();
+	if (r)
+		return r;
+
+	if (usage_count) {
+		/*
+		 * Abort the CPU online process if hardware virtualization cannot
+		 * be enabled. Otherwise running VMs would encounter unrecoverable
+		 * errors when scheduled to this CPU.
+		 */
+		return __hardware_enable();
+	}
+	return 0;
+}
+
+int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
+{
+	if (usage_count)
+		hardware_disable(NULL);
+	return 0;
+}
+
+int kvm_arch_reboot(int val)
+{
+	on_each_cpu(hardware_disable, NULL, 1);
+	return NOTIFY_OK;
+}
+
+int kvm_arch_suspend(int usage_count)
+{
+	if (usage_count)
+		hardware_disable(NULL);
+	return 0;
+}
+
 void kvm_arch_resume(int usage_count)
 {
 	struct kvm *kvm;
@@ -11853,6 +11977,8 @@ void kvm_arch_resume(int usage_count)
 	if (!usage_count)
 		return;
 
+	if (kvm_arch_check_processor_compat())
+		return;
 	if (kvm_arch_hardware_enable())
 		return;
 
@@ -12102,11 +12228,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-int kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return kvm_mmu_post_init_vm(kvm);
-}
-
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
-- 
2.25.1

