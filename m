Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29385B2A35
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiIHX0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiIHX0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A738BE3D78;
        Thu,  8 Sep 2022 16:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679569; x=1694215569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rcsBig+l8i4wXZPyFgjZw0NvXS2qsmb7B5pWOnc3Pk8=;
  b=kWcqNzGCp8t6c/S/hDoehPKCVplpemKEIhNwKoBNQl2hF/mKSYAg/qjy
   pMZjku66DcjFHyzc7RsJPl5+40WU8lkg9v0ijbKZN3joEV9Q9rNJ06+K7
   10+10fWAJm3OI1eu7c9HWxYBFXjr6PxnAxT7F2HPlJ+LgRNoahTFEgmy0
   O7kG58XV3BjQLKkewb1scbCqfuzAHUgDIBdcDHTAw/kJnf8Ux7mxJmRxu
   kh9PKoR7ARhWyovKdVId7uW3EPfITTEJ8qLLwBlQesfrntX80VZvvi34F
   QtE/NgHhSxjSQatBl+YMvs7mc5d3EKGI+7HwaGuQJvP804tktKI8qR8mc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298686994"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298686994"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:07 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863186"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:07 -0700
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
        Huacai Chen <chenhuacai@kernel.org>,
        Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v4 08/26] KVM: Do compatibility checks on hotplugged CPUs
Date:   Thu,  8 Sep 2022 16:25:24 -0700
Message-Id: <e99a21f8a9ba6a6cb4c201c2d80fd3bdc43a6422.1662679124.git.isaku.yamahata@intel.com>
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

From: Chao Gao <chao.gao@intel.com>

At init time, KVM does compatibility checks to ensure that all online
CPUs support hardware virtualization and a common set of features. But
KVM uses hotplugged CPUs without such compatibility checks. On Intel
CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX or
vmentry failure if the hotplugged CPU doesn't meet minimal feature
requirements.

Do compatibility checks when onlining a CPU and abort the online process
if the hotplugged CPU is incompatible with online CPUs.

CPU hotplug is disabled during hardware_enable_all() to prevent the corner
case as shown below. A hotplugged CPU marks itself online in
cpu_online_mask (1) and enables interrupt (2) before invoking callbacks
registered in ONLINE section (3). So, if hardware_enable_all() is invoked
on another CPU right after (2), then on_each_cpu() in hardware_enable_all()
invokes hardware_enable_nolock() on the hotplugged CPU before
kvm_online_cpu() is called. This makes the CPU escape from compatibility
checks, which is risky.

	start_secondary { ...
		set_cpu_online(smp_processor_id(), true); <- 1
		...
		local_irq_enable();  <- 2
		...
		cpu_startup_entry(CPUHP_AP_ONLINE_IDLE); <- 3
	}

Keep compatibility checks at KVM init time. It can help to find
incompatibility issues earlier and refuse to load arch KVM module
(e.g., kvm-intel).

Loosen the WARN_ON in kvm_arch_check_processor_compat so that it
can be invoked from KVM's CPU hotplug callback (i.e., kvm_online_cpu).
Other arch doesn't depends on prohibiting of preemption because powerpc
has "strcmp(cur_cpu_spec->cpu_name, "model name")" and other arch has
"return 0".  Only x86 kvm_arch_check_processor_compat() has issue.

Opportunistically, add a pr_err() for setup_vmcs_config() path in
vmx_check_processor_compatibility() so that each possible error path has
its own error message. Convert printk(KERN_ERR ... to pr_err to please
checkpatch.pl

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20220216031528.92558-7-chao.gao@intel.com
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++----
 arch/x86/kvm/x86.c     | 11 +++++++++--
 virt/kvm/kvm_main.c    | 18 +++++++++++++++++-
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3cf7f18a4115..2a1ab6495299 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7421,20 +7421,22 @@ static int vmx_check_processor_compatibility(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
+	int cpu = smp_processor_id();
 
 	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
 	    !this_cpu_has(X86_FEATURE_VMX)) {
-		pr_err("kvm: VMX is disabled on CPU %d\n", smp_processor_id());
+		pr_err("kvm: VMX is disabled on CPU %d\n", cpu);
 		return -EIO;
 	}
 
-	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
+	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
+		pr_err("kvm: failed to setup vmcs config on CPU %d\n", cpu);
 		return -EIO;
+	}
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
 	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
-		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
-				smp_processor_id());
+		pr_err("kvm: CPU %d feature inconsistency!\n", cpu);
 		return -EIO;
 	}
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f6f014e78ab9..0ab8db07fa0e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12000,9 +12000,16 @@ void kvm_arch_hardware_unsetup(void)
 
 int kvm_arch_check_processor_compat(void)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	int cpu = smp_processor_id();
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	WARN_ON(!irqs_disabled());
+	/*
+	 * Compatibility checks are done when loading KVM or in KVM's CPU
+	 * hotplug callback. It ensures all online CPUs are compatible to run
+	 * vCPUs. For other cases, compatibility checks are unnecessary or
+	 * even problematic. Try to detect improper usages here.
+	 */
+	WARN_ON(!irqs_disabled() && cpu_active(cpu));
 
 	if (__cr4_reserved_bits(cpu_has, c) !=
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index db1303e2abc9..0ac00c711384 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5013,7 +5013,11 @@ static void hardware_enable_nolock(void *caller_name)
 
 static int kvm_online_cpu(unsigned int cpu)
 {
-	int ret = 0;
+	int ret;
+
+	ret = kvm_arch_check_processor_compat();
+	if (ret)
+		return ret;
 
 	raw_spin_lock(&kvm_count_lock);
 	/*
@@ -5073,6 +5077,17 @@ static int hardware_enable_all(void)
 {
 	int r = 0;
 
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
 	raw_spin_lock(&kvm_count_lock);
 
 	kvm_usage_count++;
@@ -5087,6 +5102,7 @@ static int hardware_enable_all(void)
 	}
 
 	raw_spin_unlock(&kvm_count_lock);
+	cpus_read_unlock();
 
 	return r;
 }
-- 
2.25.1

