Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 326B95B2A41
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiIHX05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiIHX0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928211098E1;
        Thu,  8 Sep 2022 16:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679576; x=1694215576;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BCW0b+RqTHG/HSgdegqcNoUHAj5WKFiSkIrcMdx/w4M=;
  b=AqVvACoAXGyMS6XxsSjLWnIVwdrcBw/iKxj7K92fxGhSEJHI8a6/kAFt
   qmXCkQSGkX+k0c20Zam8aqTG/mqThtxgDAafXuZIQqBKmknTtgSQ+LNKQ
   ELQ3Ku9hQCeAp4LpGu8ZSe9pGezWm7gnvRsl+KT8A79iBCNPnYkhiWiUQ
   UYYLin+R9eqTQkZuDiYMc1Ns9BkWJkm/tpi9T7n9DozS1lpW/oDV+TKIf
   YP2r/jO266ZJtCqTqCDIyVw0Y9oPnP9NsCAqdDAlEJgU68lYLFhBlw5gW
   UxEJAr66VWoK0Jb9MqfkBOIAbHXz35Qm+f2a8lx9BkkUEiPZI+EYab1D5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687023"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687023"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863256"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:12 -0700
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
Subject: [PATCH v4 18/26] KVM: x86: Duplicate arch callbacks related to pm events and compat check
Date:   Thu,  8 Sep 2022 16:25:34 -0700
Message-Id: <f4fae4835ead86dd9ff1d75b12bbd098c85dc7a3.1662679124.git.isaku.yamahata@intel.com>
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

KVM/X86 can change those callbacks without worrying about breaking other
archs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 168 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 163 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23623b6a789b..feee7739219e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11845,6 +11845,169 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
+static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
+
+int kvm_arch_post_init_vm(struct kvm *kvm)
+{
+	return kvm_mmu_post_init_vm(kvm);
+}
+
+static int __hardware_enable(void *caller_name)
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
+		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
+			cpu, (const char *)caller_name);
+	else
+		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+	return r;
+}
+
+static void hardware_enable(void *arg)
+{
+	atomic_t *failed = arg;
+
+	if (__hardware_enable((void *)__func__))
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
+	ret = __hardware_enable((void *)__func__);
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
+	if (usage_count) {
+		preempt_disable();
+		hardware_disable(NULL);
+		preempt_enable();
+	}
+	return 0;
+}
+
 void kvm_arch_resume(int usage_count)
 {
 	struct kvm *kvm;
@@ -12122,11 +12285,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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

