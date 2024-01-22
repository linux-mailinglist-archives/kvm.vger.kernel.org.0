Return-Path: <kvm+bounces-6600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33489837924
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54D1C1C2739B
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596095C601;
	Mon, 22 Jan 2024 23:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DvfiY4NN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2D95B5CA;
	Mon, 22 Jan 2024 23:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967718; cv=none; b=Vkv8ofYVIz18nBT/DktfI6fOwxAwI/oqFNzZj/fkQIw4DD8yCjgokJwJ/g6/5+0cLtqHRdRjVOkk3pNN8gOL+KPv3Ra5yykV9LEceiNoWTjbPVjYi2zhQCtcTg3dKa9EWLsQdUcn+1COjQr7hDENn1iiYa1kPBBsn1M+0eZgg9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967718; c=relaxed/simple;
	bh=YMvBpwA2nyOoJ0XsQl6wNhEs9HqLUlc70SaiUDGb018=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dWElPF3Y9tuZnB3CFwb+Y7DabNz0n+w+1563dYPdE3j12hp/Kqar89zc7H67b6NJ0wkGKayHCOly2emHqccXjMC2/fGbCn2daTk6+FNUB2YSsVor6zZEbtFJ1OroY26dIMS0W7SXa+uC+3ZDd9PgEVDzcZCwgI9n9CbU/gLuM9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DvfiY4NN; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967715; x=1737503715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YMvBpwA2nyOoJ0XsQl6wNhEs9HqLUlc70SaiUDGb018=;
  b=DvfiY4NNdH5fhVgMSGVn8fc4dSDimKHw6D3b44GKtX6Pgc2AlKhlzSxj
   tFw+9zc+QnStvnG2HWmK5B0a6/cfRG1o0yqAaTMMJyqJ7VgAWYXIMhSCK
   IK/8gQ+6AMxspJlNLwyw7P2izkIXhmuoGiyT9Fx6sEh2IlbYh8X3aexnd
   LL10yHh8TgbGA94Oklh3yPZdq1j+ZqAF/lFc1mYaUE17B0Fvp7zPwTvHL
   sH04ih8Sj5aSy/Fw/SF95F1wTUM3LGF7Hc+8TB4JyimPf+B076qORlg1o
   Ke1zVvvR339yUJHcx/DeNVJvPoCRpo8LoeesPSuiEAYdCIXhsW4pxbnJ/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243826"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243826"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888564"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888564"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:13 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v18 027/121] KVM: TDX: Refuse to unplug the last cpu on the package
Date: Mon, 22 Jan 2024 15:53:03 -0800
Message-Id: <d50aef7f5e591c4668c3c07f26dc5b18365b88cd.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
v18:
- Added reviewed-by BinBin
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
index 6146104fb04b..1b8fe1502bde 100644
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
index 6093147f672b..ba68f63958db 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1598,6 +1598,7 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
+	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 461cee12c1fa..50a1f50c0fc5 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -125,6 +125,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_processor_compatibility = vmx_check_processor_compat,
 
 	.hardware_unsetup = vt_hardware_unsetup,
+	.offline_cpu = tdx_offline_cpu,
 
 	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 83b962b4bd42..1c6541789c39 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -141,6 +141,7 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
  */
 static DEFINE_MUTEX(tdx_lock);
 static struct mutex *tdx_mng_key_config_lock;
+static atomic_t nr_configured_hkid;
 
 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
@@ -156,6 +157,7 @@ static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
 {
 	tdx_guest_keyid_free(kvm_tdx->hkid);
 	kvm_tdx->hkid = -1;
+	atomic_dec(&nr_configured_hkid);
 }
 
 static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
@@ -628,6 +630,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	if (ret < 0)
 		return ret;
 	kvm_tdx->hkid = ret;
+	atomic_inc(&nr_configured_hkid);
 
 	va = __get_free_page(GFP_KERNEL_ACCOUNT);
 	if (!va)
@@ -1058,3 +1061,41 @@ void tdx_hardware_unsetup(void)
 	kfree(tdx_info);
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
index 5befcc2d58e1..645688081561 100644
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
index 3ab243d9fe9d..c5b66b493f1d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12479,6 +12479,11 @@ void kvm_arch_hardware_disable(void)
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
index 0520cd8d03cc..53dfc5946454 100644
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
index 0349e1f241d1..48f2086a627f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5586,13 +5586,21 @@ static void hardware_disable_nolock(void *junk)
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


