Return-Path: <kvm+bounces-918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D67A27E4269
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B2DE2812B2
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7537436B0A;
	Tue,  7 Nov 2023 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZcOeeJc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE53358A8
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:58:01 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF651AD;
	Tue,  7 Nov 2023 06:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369079; x=1730905079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q6Mc+e9ectDAdPe5KEIGxVh1Q7GxtzQWx/pmt+k0Bb4=;
  b=dZcOeeJc4mKsQZLt9nIAQr1wdMXvx0PIrHOomClxm0HBSROyL7PkWND6
   4FMyQUEft5paymoe/kJkKLjcttlMih6tmmPc2LLTQPFlSKeMXKDRIO9KY
   9XdvwAGHAQJpdSV2UqAI4iIPMqOktMz5OfFqq0u50I/0+QFyhfnQwf1Fj
   Rv03LZOMRZyuwBWYNu3I6rPbqdj3nxVa/ph1YNz/6wnB4/WEIxf+qw77b
   UUOXVAE+6mezHA2T6ZVsD0NvfcnurelZBNjxA3Z/T3Pf5PL3b8Gn9QFTw
   8QFwb5rRF4zKWAAZJhCvMVJ+WZLvOzhqGfImxP84azK/GcszXweKq8nKZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="374555837"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="374555837"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10444119"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:56 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 023/116] KVM: TDX: Refuse to unplug the last cpu on the package
Date: Tue,  7 Nov 2023 06:55:49 -0800
Message-Id: <e40ecd771a513fc0fa6fa207e2c1e408ded7734d.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

In order to reclaim TDX HKID, (i.e. when deleting guest TD), needs to call
TDH.PHYMEM.PAGE.WBINVD on all packages.  If we have active TDX HKID, refuse
to offline the last online cpu to guarantee at least one CPU online per
package. Add arch callback for cpu offline.
Because TDX doesn't support suspend, this also refuses suspend if TDs are
running.  If no TD is running, suspend is allowed.

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
index d05a829254ea..0fbafb287839 100644
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
index 742ac63e1992..56d0ba5793cf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1570,6 +1570,7 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
+	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7082e9ea8492..c8213d6ea301 100644
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
index feee8c1e737f..ffba64008682 100644
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
index 9ef81d235406..191ac1e0d96d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12421,6 +12421,11 @@ void kvm_arch_hardware_disable(void)
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
index 687589ce9f63..96ff951bdd29 100644
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
index ba2f993c9655..29fdb39976e0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5578,13 +5578,21 @@ static void hardware_disable_nolock(void *junk)
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


