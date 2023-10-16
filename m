Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373457CAF5C
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbjJPQcP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbjJPQbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:31:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1879D6FAD;
        Mon, 16 Oct 2023 09:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473351; x=1729009351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=siO4e3CdYBjh4eJNf1n1mKu/3KHyeoYKT2+Gkcn8VH8=;
  b=HOk3JYvW5w1XXlQJmpHDrkl0yq674NMsRoP6csRPqcz7wZoEtQziTWTW
   QUtrOaOVPA0QvVlPBJ/U42z8FpZ/LvDYGUdCLj0nrsIpyZ3hUTaIhBsso
   KzYvzyXlBe2/Ho/FgS0Y+bESFYXFIfuRTkvJIqvQ8FSTm0ieyEYTnrlRJ
   HWTYhmIs58XLLu4sUfYF3p3IChpvGqvuIZwZCrvg+c9eENKFYNUjKjugP
   eizXyrLiwA32WKCPQi6Vg2AgmRG1wNg1j2w/MLOmigWrAsORP5y/QzsmL
   7dlgsJIkrFe94VElo90IbJeKjP9pYbHKC7xlJpE4SmWySIJpmAVSxh/xB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825981"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825981"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126065"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126065"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:31 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v16 023/116] KVM: TDX: Refuse to unplug the last cpu on the package
Date:   Mon, 16 Oct 2023 09:13:35 -0700
Message-Id: <546fa64fa634e2745c68f0cac04878a1f2cac05d.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.c             | 41 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  2 ++
 arch/x86/kvm/x86.c                 |  5 ++++
 include/linux/kvm_host.h           |  1 +
 virt/kvm/kvm_main.c                | 12 +++++++--
 8 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index d5a900842535..e1adeb7d4e26 100644
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
index f23557850c27..24d9a9ab338d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1562,6 +1562,7 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
+	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 463ba7214392..0bb087e3bbdf 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -121,6 +121,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_processor_compatibility = vmx_check_processor_compat,
 
 	.hardware_unsetup = vt_hardware_unsetup,
+	.offline_cpu = tdx_offline_cpu,
 
 	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6017e0feac1e..51aa114feb86 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -64,6 +64,7 @@ static struct tdx_info tdx_info __ro_after_init;
  */
 static DEFINE_MUTEX(tdx_lock);
 static struct mutex *tdx_mng_key_config_lock;
+static atomic_t nr_configured_hkid;
 
 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
@@ -79,6 +80,7 @@ static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
 	kvm_tdx->hkid = -1;
+	atomic_dec(&nr_configured_hkid);
 }
 
 static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
@@ -562,6 +564,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	if (ret < 0)
 		return ret;
 	kvm_tdx->hkid = ret;
+	atomic_inc(&nr_configured_hkid);
 
 	va = __get_free_page(GFP_KERNEL_ACCOUNT);
 	if (!va)
@@ -932,3 +935,41 @@ void tdx_hardware_unsetup(void)
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
+#define MSG_ALLPKG_ONLINE \
+	"TDX requires all packages to have an online CPU. Delete all TDs in order to offline all CPUs of a package.\n"
+		pr_warn_ratelimited(MSG_ALLPKG_ONLINE);
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 01f3b02a5b46..ef14c3873fe0 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -138,6 +138,7 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 void tdx_hardware_unsetup(void);
 bool tdx_is_vm_type_supported(unsigned long type);
+int tdx_offline_cpu(void);
 
 int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int tdx_vm_init(struct kvm *kvm);
@@ -148,6 +149,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
+static inline int tdx_offline_cpu(void) { return 0; }
 
 static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbd80f2e403e..714685a31baf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12301,6 +12301,11 @@ void kvm_arch_hardware_disable(void)
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
index 8c5c017ab4e9..9f90cda7149f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1502,6 +1502,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 #endif
+int kvm_arch_offline_cpu(unsigned int cpu);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu);
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e0563477830f..aa9426472bb4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5581,13 +5581,21 @@ static void hardware_disable_nolock(void *junk)
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

