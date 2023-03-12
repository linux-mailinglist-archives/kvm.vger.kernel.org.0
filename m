Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC33F6B6939
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjCLSAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjCLR7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:59:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CEE241F7;
        Sun, 12 Mar 2023 10:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643898; x=1710179898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IaP+R6OmOVVt9rwp++3UB/7MOA/QKgmXm6dR69UiHVc=;
  b=MVUd2hZuDXUVJXWCYcwKtmtEqN7Bufn3doB6DgPt0BymIhumUolvINrd
   0C6AARwiiWPc96benA6C4ox51hZm2+qpZXRT9sD461nXlNKw48KqIhhEi
   APjoofhU/wKqVhZsLrlgD4y8tC8f95+QLjTSWUWUP392BRzB40mZHJm70
   U/fv7W3v/NchUsZcvH1ETlLr7GkEFhbe0yMoJRSM7v0AXzNgFQccTKiFS
   kVkdby+ayx+FIQecOe0Rsv5wYyAyYJqCOeTbRXKWo9zeGJQDjcWfaPD7P
   vmDKgKFQGat5uqQg8fL3AcsTKSnBIFxdUEx8Xh4FdCHUu/C0NMfLW09EP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320863629"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="320863629"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="628396983"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="628396983"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 022/113] KVM: TDX: Refuse to unplug the last cpu on the package
Date:   Sun, 12 Mar 2023 10:55:46 -0700
Message-Id: <da0ea103d4824dd127fcf01e614baf3c5cf05b03.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

In order to reclaim TDX HKID, (i.e. when deleting guest TD), needs to call
TDH.PHYMEM.PAGE.WBINVD on all packages.  If we have active TDX HKID, refuse
to offline the last online cpu to guarantee at least one CPU online per
package. Add arch callback for cpu offline.
Because TDX doesn't support suspend by the TDX 1.0 spec, this also refuses
suspend if TDs are running.  If no TD is running, suspend is allowed.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/tdx.c             | 43 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/x86_ops.h         |  2 ++
 arch/x86/kvm/x86.c                 |  5 ++++
 include/linux/kvm_host.h           |  1 +
 virt/kvm/kvm_main.c                | 12 +++++++--
 8 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c30d2d2ad686..f763981b7dbc 100644
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
index 15f7c0d45082..f30543caddbf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1558,6 +1558,7 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
+	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 08ed6fc8cc3d..e57b36902313 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -122,6 +122,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_processor_compatibility = vmx_check_processor_compat,
 
 	.hardware_unsetup = vt_hardware_unsetup,
+	.offline_cpu = tdx_offline_cpu,
 
 	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 496410ec6334..aeec8bcf8921 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -63,6 +63,7 @@ static struct tdx_info tdx_info;
  */
 static DEFINE_MUTEX(tdx_lock);
 static struct mutex *tdx_mng_key_config_lock;
+static atomic_t nr_configured_hkid;
 
 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
@@ -243,7 +244,8 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
 			kvm_tdx->hkid);
 		return;
-	}
+	} else
+		atomic_dec(&nr_configured_hkid);
 
 free_hkid:
 	tdx_hkid_free(kvm_tdx);
@@ -620,6 +622,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params)
 		if (ret)
 			break;
 	}
+	if (!ret)
+		atomic_inc(&nr_configured_hkid);
 	cpus_read_unlock();
 	free_cpumask_var(packages);
 	if (ret)
@@ -858,3 +862,40 @@ void tdx_hardware_unsetup(void)
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
+	/* No TD is running.  Allow any cpu to be offline. */
+	if (!atomic_read(&nr_configured_hkid))
+		return 0;
+
+	/*
+	 * In order to reclaim TDX HKID, (i.e. when deleting guest TD), need to
+	 * call TDH.PHYMEM.PAGE.WBINVD on all packages to program all memory
+	 * controller with pconfig.  If we have active TDX HKID, refuse to
+	 * offline the last online cpu.
+	 */
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
+		return -ENOMEM;
+	for_each_online_cpu(i) {
+		if (i != curr_cpu)
+			cpumask_set_cpu(topology_physical_package_id(i), packages);
+	}
+	/* Check if this cpu is the last online cpu of this package. */
+	if (!cpumask_test_cpu(topology_physical_package_id(curr_cpu), packages))
+		ret = -EBUSY;
+	free_cpumask_var(packages);
+	if (ret)
+		/*
+		 * Because it's hard for human operator to understand the
+		 * reason, warn it.
+		 */
+		pr_warn_ratelimited("TDX requires all packages to have an online CPU. "
+				    "Delete all TDs in order to offline all CPUs of a package.\n");
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 8f87eeeab97c..544f99141f8f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -143,6 +143,7 @@ void tdx_hardware_unsetup(void);
 int tdx_hardware_enable(void);
 bool tdx_is_vm_type_supported(unsigned long type);
 int tdx_dev_ioctl(void __user *argp);
+int tdx_offline_cpu(void);
 
 int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int tdx_vm_init(struct kvm *kvm);
@@ -155,6 +156,7 @@ static inline void tdx_hardware_unsetup(void) {}
 static inline int tdx_hardware_enable(void) { return -EOPNOTSUPP; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
+static inline int tdx_offline_cpu(void) { return 0; }
 
 static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap) { return -EINVAL; };
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 89fd8074c20c..a1d5d920302b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12161,6 +12161,11 @@ void kvm_arch_hardware_disable(void)
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
index 4ae46e6f93af..115cdca6384f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1478,6 +1478,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 #endif
+int kvm_arch_offline_cpu(unsigned int cpu);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f1a55834440..f8495e27d210 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5509,13 +5509,21 @@ static void hardware_disable_nolock(void *junk)
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

