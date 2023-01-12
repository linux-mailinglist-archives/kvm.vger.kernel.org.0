Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF95667B5C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240686AbjALQlv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239928AbjALQhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B51E17E2A;
        Thu, 12 Jan 2023 08:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541238; x=1705077238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RvqX+71M0wuoZu+998fl/Hj4LfEmmytgmlYxnmQCuV0=;
  b=eQ4gVh0CwgIY321JlLg/hG6M0C5ecZROiwHtjb6Dh2mE8KEEO7AYG3Qe
   jnE4FSTRRUnpcEM5eUADFRowsXqyrAQjfwBmUlDxxm+d57mOt4c2fzxgH
   O4A0h07EVzXFM6ajEQppJxXVUvpryyTkxCtosLbT3bmgmR8LwrLuxCw+q
   y0CNc8AD5b2iLyU6TVqz2xpu1WxyfTbD4jlnjqLdM0pUulZ5AwWYWswtr
   PGhriuRinjlAxB0Q0HG6NWcaqsk3fiISTccfdVQUQS9BPPWkRqsGAuA7g
   ibSELd/cDgbruMF0Q4GBWqBn2Q1e7WzaJY1hSOz6gEkL3Yqen+MwpMgXh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811751"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811751"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:23 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151694"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151694"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:23 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 021/113] KVM: TDX: Refuse to unplug the last cpu on the package
Date:   Thu, 12 Jan 2023 08:31:29 -0800
Message-Id: <ecf02459d319789aca1b9399ed8fda47c03812df.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
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

In order to reclaim TDX HKID, (i.e. when deleting guest TD), needs to call
TDH.PHYMEM.PAGE.WBINVD on all packages.  If we have used TDX HKID, refuse
to offline the last online cpu. Add arch callback for cpu offline.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/tdx.c             | 40 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/x86_ops.h         |  2 ++
 arch/x86/kvm/x86.c                 |  5 ++++
 include/linux/kvm_host.h           |  1 +
 virt/kvm/kvm_main.c                | 12 +++++++--
 8 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 552de893af75..1a27f3aee982 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -18,6 +18,7 @@ KVM_X86_OP(check_processor_compatibility)
 KVM_X86_OP(hardware_enable)
 KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
+KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e199ddf0bb00..30f4ddb18548 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1534,6 +1534,7 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
+	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c5f2515026e9..ddf0742f1f67 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -77,6 +77,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_processor_compatibility = vmx_check_processor_compat,
 
 	.hardware_unsetup = vt_hardware_unsetup,
+	.offline_cpu = tdx_offline_cpu,
 
 	.hardware_enable = vmx_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0b309bbfe4e5..557a609c5147 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -42,6 +42,7 @@ static struct tdx_capabilities tdx_caps;
  */
 static DEFINE_MUTEX(tdx_lock);
 static struct mutex *tdx_mng_key_config_lock;
+static atomic_t nr_configured_hkid;
 
 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
@@ -209,7 +210,8 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
 			kvm_tdx->hkid);
 		return;
-	}
+	} else
+		atomic_dec(&nr_configured_hkid);
 
 free_hkid:
 	tdx_hkid_free(kvm_tdx);
@@ -560,6 +562,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params)
 		if (ret)
 			break;
 	}
+	if (!ret)
+		atomic_inc(&nr_configured_hkid);
 	cpus_read_unlock();
 	free_cpumask_var(packages);
 	if (ret)
@@ -791,3 +795,37 @@ void tdx_hardware_unsetup(void)
 	/* kfree accepts NULL. */
 	kfree(tdx_mng_key_config_lock);
 }
+
+int tdx_offline_cpu(void)
+{
+	int curr_cpu = smp_processor_id();
+	cpumask_var_t packages;
+	int ret = 0;
+	int i;
+
+	if (!atomic_read(&nr_configured_hkid))
+		return 0;
+
+	/*
+	 * To reclaim hkid, need to call TDH.PHYMEM.PAGE.WBINVD on all packages.
+	 * If this is the last online cpu on the package, refuse offline.
+	 */
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
+		return -ENOMEM;
+
+	for_each_online_cpu(i) {
+		if (i != curr_cpu)
+			cpumask_set_cpu(topology_physical_package_id(i), packages);
+	}
+	if (!cpumask_test_cpu(topology_physical_package_id(curr_cpu), packages))
+		ret = -EBUSY;
+	free_cpumask_var(packages);
+	if (ret)
+		/*
+		 * Because it's hard for human operator to understand the
+		 * reason, warn it.
+		 */
+		pr_warn("TDX requires all packages to have an online CPU.  "
+			"Delete all TDs in order to offline all CPUs of a package.\n");
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 3d0f519727c6..6c40dda1cc2f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -142,6 +142,7 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 void tdx_hardware_unsetup(void);
 bool tdx_is_vm_type_supported(unsigned long type);
 int tdx_dev_ioctl(void __user *argp);
+int tdx_offline_cpu(void);
 
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
@@ -152,6 +153,7 @@ static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline void tdx_hardware_unsetup(void) {}
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
+static inline int tdx_offline_cpu(void) { return 0; }
 
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0fa91a9708aa..1fb135e0c98f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12100,6 +12100,11 @@ void kvm_arch_hardware_disable(void)
 	drop_user_return_notifiers();
 }
 
+int kvm_arch_offline_cpu(unsigned int cpu)
+{
+	return static_call(kvm_x86_offline_cpu)();
+}
+
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6fada852c064..cd1f3634dd6a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1459,6 +1459,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 #endif
+int kvm_arch_offline_cpu(unsigned int cpu);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1cfa7da92ad0..6c61b71b56d2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5516,13 +5516,21 @@ static void hardware_disable_nolock(void *junk)
 	__this_cpu_write(hardware_enabled, false);
 }
 
+__weak int kvm_arch_offline_cpu(unsigned int cpu)
+{
+	return 0;
+}
+
 static int kvm_offline_cpu(unsigned int cpu)
 {
+	int r = 0;
+
 	mutex_lock(&kvm_lock);
-	if (kvm_usage_count)
+	r = kvm_arch_offline_cpu(cpu);
+	if (!r && kvm_usage_count)
 		hardware_disable_nolock(NULL);
 	mutex_unlock(&kvm_lock);
-	return 0;
+	return r;
 }
 
 static void hardware_disable_all_nolock(void)
-- 
2.25.1

