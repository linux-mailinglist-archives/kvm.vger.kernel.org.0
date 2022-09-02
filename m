Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316935AA593
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbiIBCSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiIBCS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF55EAA4EC;
        Thu,  1 Sep 2022 19:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085099; x=1693621099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RfvsExVeSj6EDjppWB40+zJyPhyv5PSdd1H744HOBmo=;
  b=HF8gxVP62WrENQEqVsM1aMg/0U8MdxWEwD8pmPWRtPJmrSC638Q/LlcF
   ViPesI/0JLAE4QSGY/uifzSxxV2MD0SEbrT5ECJBqQgC4YtHgIwivqTKS
   hVKthpELquD0HzY5X1EWdLdc6HeqRyg6TqMZOULSvaAp9cyokS4h/GWmn
   Cz9TG9JK6R9SO6e2P7a5YTRgwGxhs5t58blk8Eeyd2swhPxruOf4gkLL6
   5f4cqxSto2ekL7f7Vukv0yuWF9P7ByKu1jjJa1fsDEvCBabdNPdOKfngp
   vbjXa7swX0DYdzomscMMAdU2kazRUeOl9MN/QbPn1l8QcspMRGFrLxqVo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157861"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157861"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:19 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835661"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:19 -0700
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
Subject: [PATCH v3 17/22] KVM: x86: Duplicate arch callbacks related to pm events
Date:   Thu,  1 Sep 2022 19:17:52 -0700
Message-Id: <903be9503d38e1bfbc4023ef24753f4eba76bc87.1662084396.git.isaku.yamahata@intel.com>
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

KVM/X86 can change those callbacks without worrying about breaking other
archs.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 131 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 126 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5f4d8eed588..9a28eb5fbb76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11845,6 +11845,130 @@ void kvm_arch_hardware_disable(void)
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
+int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
+{
+	int r;
+
+	r = kvm_arch_check_processor_compat();
+	if (r)
+		return r;
+
+	if (!usage_count)
+		return 0;
+	/*
+	 * Abort the CPU online process if hardware virtualization cannot
+	 * be enabled. Otherwise running VMs would encounter unrecoverable
+	 * errors when scheduled to this CPU.
+	 */
+	return __hardware_enable((void *)__func__);
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
@@ -11857,6 +11981,8 @@ void kvm_arch_resume(int usage_count)
 	if (!usage_count)
 		return;
 
+	if (kvm_arch_check_processor_compat())
+		return;
 	if (kvm_arch_hardware_enable())
 		return;
 
@@ -12115,11 +12241,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
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

