Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE9859ABA6
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245321AbiHTGBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244498AbiHTGAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3915A260A;
        Fri, 19 Aug 2022 23:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975252; x=1692511252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tz2myrWkcxiLhdua2HaqakBscUxnMz1ROup5PGWdHyk=;
  b=jTS7XwU6MPL3DL0cjYIIm2jSpmI2cUaMipFWtSHdj8X4u50IpshE64gP
   d/vxNzu+EoBfBUzQkkqkemmJtt7FxlipAh0Xcw2aMpbvnTLQVZg2OQ8LI
   yQY1YqvThEME123pF9bikpFG3kFyCFZjuiYlQ4gwbX+/Y9v5Wf2bWmQes
   xDOfqErX1zArVT74qsx02Ilxh8CcleAIua5rj7N8PcYWPRb/jK9vo0Svu
   nEhZh4aQ9zmz1qAILCzaWRRIh+iHNbwnX5S3eoHa9O9Nq/8c6AAFoG+AV
   MyaJqp5QMhZwvJRoa2bLCqX7M13BVibg4dzxIryZe6FDS87obTu0mJwDj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448980"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448980"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857551"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 13/18] KVM: x86: Duplicate arch callbacks related to pm events
Date:   Fri, 19 Aug 2022 23:00:19 -0700
Message-Id: <c1d64ba97ad4144e37a44b9d981e9bf8d8b8d755.1660974106.git.isaku.yamahata@intel.com>
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

KVM/X86 can change those callbacks without worrying about breaking other
archs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 125 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 120 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b112cd7de58..71e90d0f0da9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11841,6 +11841,124 @@ void kvm_arch_hardware_disable(void)
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
+	if (r && usage_count == 1)
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
+	if (!usage_count)
+		return 0;
+
+	r = kvm_arch_check_processor_compat();
+	if (r)
+		return r;
+	return __hardware_enable();
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
@@ -11853,6 +11971,8 @@ void kvm_arch_resume(int usage_count)
 	if (!usage_count)
 		return;
 
+	if (kvm_arch_check_processor_compat())
+		return;
 	if (kvm_arch_hardware_enable())
 		return;
 
@@ -12104,11 +12224,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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

