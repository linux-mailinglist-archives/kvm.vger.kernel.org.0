Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87C55E6ABB
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiIVSXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiIVSXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:23:10 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A61109634;
        Thu, 22 Sep 2022 11:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870927; x=1695406927;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7L6JQ3duEiYpDJSnY7rr6Cjj65pecUDGDkupr2JKZ5Q=;
  b=bnroP5O3VWYDjUHYEaiKENsT0/qHbIKrkrwK9uvmWrzE4OlnK8SMxkbd
   33DdxTqPUhCjzWVSfjOVDspqHDPLPUDz+NYl/AcsvJ6DGR5rMAjfYszeA
   A+FOeIaQOLaxq0FVHReXKh6VeUUSWvMbFI1XeAUqsW6gC8AxAvd0k2Yfb
   wngaCOPRcb6ylpGRQcrPuaAhlL8JpRSLySB1stb2oKbcN34fUNerf5XOs
   ULROU8Ms1OEJjjG/UAj8ryvf6gqxfrnLtdCCpoP0oJ8fHQeufB9G52tMx
   fI/JLABO8tWrhEAItF8v1K43mtoLDkh2A+jgOMOroOJrSs6sJEUTWuwpZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712913"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712913"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:25 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086807"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:24 -0700
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
Subject: [PATCH v5 21/30] KVM: x86: Duplicate arch callbacks related to pm events and compat check
Date:   Thu, 22 Sep 2022 11:20:50 -0700
Message-Id: <242f31fa4382d28d5f3893d9148c79e976d94136.1663869838.git.isaku.yamahata@intel.com>
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

KVM/X86 can change those callbacks without worrying about breaking other
archs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 166 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 161 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5ebb69996d5..b15eb59096b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11960,6 +11960,167 @@ void kvm_arch_hardware_disable(void)
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
+		pr_warn("kvm: enabling virtualization on CPU%d failed during %pSb\n",
+			cpu, __builtin_return_address(0));
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
+static void check_processor_compat(void *rtn)
+{
+	*(int *)rtn = kvm_arch_check_processor_compat();
+}
+
+int kvm_arch_check_processor_compat_all(void)
+{
+	int cpu;
+	int r;
+
+	for_each_online_cpu(cpu) {
+		smp_call_function_single(cpu, check_processor_compat, &r, 1);
+		if (r < 0)
+			return r;
+	}
+	return 0;
+}
+
+int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
+{
+	int ret;
+
+	ret = kvm_arch_check_processor_compat();
+	if (ret)
+		return ret;
+
+	if (!usage_count)
+		return 0;
+
+	/*
+	 * arch callback kvm_arch_hardware_eanble() assumes that
+	 * preemption is disabled for historical reason.  Disable
+	 * preemption until all arch callbacks are fixed.
+	 */
+	preempt_disable();
+	/*
+	 * Abort the CPU online process if hardware virtualization cannot
+	 * be enabled. Otherwise running VMs would encounter unrecoverable
+	 * errors when scheduled to this CPU.
+	 */
+	ret = __hardware_enable();
+	preempt_enable();
+
+	return ret;
+}
+
+int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
+{
+	if (usage_count) {
+		/*
+		 * arch callback kvm_arch_hardware_disable() assumes that
+		 * preemption is disabled for historical reason.  Disable
+		 * preemption until all arch callbacks are fixed.
+		 */
+		preempt_disable();
+		hardware_disable(NULL);
+		preempt_enable();
+	}
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
+void kvm_arch_resume(int usage_count)
+{
+	if (usage_count)
+		(void)__hardware_enable();
+}
+
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
@@ -12140,11 +12301,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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

