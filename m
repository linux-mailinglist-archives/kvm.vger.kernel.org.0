Return-Path: <kvm+bounces-9711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D69E6866D48
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE6561C22307
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831AC7A720;
	Mon, 26 Feb 2024 08:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PeFYcRJb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CF41F947;
	Mon, 26 Feb 2024 08:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936128; cv=none; b=lnoUTD9SV1/mBjUFEHsNjJNWXpaMzY2oiy49MD8IyITF34MPbS/2PftRtu6QCEPYD2MyspzvpF51TG9j+to3AkVnDgeDNFRfZZH/f06+0euCNv77AXq1MrlRlruqN1pRayJQUVA22eBw5PzIAt0yoxfyZkgNmL5tYBCtNtuXqjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936128; c=relaxed/simple;
	bh=0jXFsyFxqksmMvFjQSUBOYDFyGyaHIa0Wn3nGU2QdQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MrqbHD7QH6BpOBcoVNGMArMMlYn/EEEHG3onR5tx/+HyMXVHkECm/mRL7SckJufKVqd5Z0PzarU/Hk5h3RS+y0TqqhpJCPNwgDQLgsBeOlL/WpWdyHSHT1jM6d4ZLrnt+Fmh2MMtdK+Ky49DgZfI1ATMabQ8nA37XRzMs4lzz8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PeFYcRJb; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936126; x=1740472126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0jXFsyFxqksmMvFjQSUBOYDFyGyaHIa0Wn3nGU2QdQs=;
  b=PeFYcRJbknxadnqYs3t/tCXMYDVSigCINxTwtGc9bl9r3Wfea26bSfrf
   R0XtlF1DHo8evpbN5YQnbXF8fKD90eOhVBy0POZLgEAYkMI0nov/3QQFv
   +pHk/h5B1+agUxfjp1cf4Fky7BeoQI1tSEFQak184PNRF6q3yVDFI4FGw
   A4s9fQwDSDp5BbuXsKp8U/NDYYiHDoPgYTDOSatjxDXb/4Urhxy0uT985
   dyJqq8OAdgfQbDff2SMSeaA4s3cL+u4Glira6f0L84NgY07tTk7jcJYAF
   H0ldsklKc6FvaQ0RNHD3fsgNIOBlXAe12shEfaG0jFSXnubUfdesd69f/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069541"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069541"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272616"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:45 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical processor
Date: Mon, 26 Feb 2024 00:26:29 -0800
Message-Id: <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

For vcpu migration, in the case of VMX, VMCS is flushed on the source pcpu,
and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
call them on vcpu migration.  The logic is mostly same as VMX except the
TDX SEAMCALLs are used.

When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    |  32 ++++++-
 arch/x86/kvm/vmx/tdx.c     | 190 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h     |   2 +
 arch/x86/kvm/vmx/x86_ops.h |   4 +
 4 files changed, 221 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 8275a242ce07..9b336c1a6508 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -33,6 +33,14 @@ static int vt_max_vcpus(struct kvm *kvm)
 static int vt_flush_remote_tlbs(struct kvm *kvm);
 #endif
 
+static void vt_hardware_disable(void)
+{
+	/* Note, TDX *and* VMX need to be disabled if TDX is enabled. */
+	if (enable_tdx)
+		tdx_hardware_disable();
+	vmx_hardware_disable();
+}
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -201,6 +209,16 @@ static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
 	return vmx_vcpu_run(vcpu);
 }
 
+static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_load(vcpu, cpu);
+		return;
+	}
+
+	vmx_vcpu_load(vcpu, cpu);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu)) {
@@ -262,6 +280,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
+static void vt_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_sched_in(vcpu, cpu);
+}
+
 static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	if (is_td_vcpu(vcpu))
@@ -335,7 +361,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	/* TDX cpu enablement is done by tdx_hardware_setup(). */
 	.hardware_enable = vmx_hardware_enable,
-	.hardware_disable = vmx_hardware_disable,
+	.hardware_disable = vt_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
@@ -353,7 +379,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
-	.vcpu_load = vmx_vcpu_load,
+	.vcpu_load = vt_vcpu_load,
 	.vcpu_put = vt_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
@@ -440,7 +466,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
-	.sched_in = vmx_sched_in,
+	.sched_in = vt_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ad4d3d4eaf6c..7aa9188f384d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -106,6 +106,14 @@ static DEFINE_MUTEX(tdx_lock);
 static struct mutex *tdx_mng_key_config_lock;
 static atomic_t nr_configured_hkid;
 
+/*
+ * A per-CPU list of TD vCPUs associated with a given CPU.  Used when a CPU
+ * is brought down to invoke TDH_VP_FLUSH on the approapriate TD vCPUS.
+ * Protected by interrupt mask.  This list is manipulated in process context
+ * of vcpu and IPI callback.  See tdx_flush_vp_on_cpu().
+ */
+static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
+
 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
@@ -138,6 +146,37 @@ static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
 	return kvm_tdx->finalized;
 }
 
+static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_irqs_disabled();
+
+	list_del(&to_tdx(vcpu)->cpu_list);
+
+	/*
+	 * Ensure tdx->cpu_list is updated is before setting vcpu->cpu to -1,
+	 * otherwise, a different CPU can see vcpu->cpu = -1 and add the vCPU
+	 * to its list before its deleted from this CPUs list.
+	 */
+	smp_wmb();
+
+	vcpu->cpu = -1;
+}
+
+static void tdx_disassociate_vp_arg(void *vcpu)
+{
+	tdx_disassociate_vp(vcpu);
+}
+
+static void tdx_disassociate_vp_on_cpu(struct kvm_vcpu *vcpu)
+{
+	int cpu = vcpu->cpu;
+
+	if (unlikely(cpu == -1))
+		return;
+
+	smp_call_function_single(cpu, tdx_disassociate_vp_arg, vcpu, 1);
+}
+
 static void tdx_clear_page(unsigned long page_pa)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
@@ -218,6 +257,87 @@ static void tdx_reclaim_control_page(unsigned long td_page_pa)
 	free_page((unsigned long)__va(td_page_pa));
 }
 
+struct tdx_flush_vp_arg {
+	struct kvm_vcpu *vcpu;
+	u64 err;
+};
+
+static void tdx_flush_vp(void *arg_)
+{
+	struct tdx_flush_vp_arg *arg = arg_;
+	struct kvm_vcpu *vcpu = arg->vcpu;
+	u64 err;
+
+	arg->err = 0;
+	lockdep_assert_irqs_disabled();
+
+	/* Task migration can race with CPU offlining. */
+	if (unlikely(vcpu->cpu != raw_smp_processor_id()))
+		return;
+
+	/*
+	 * No need to do TDH_VP_FLUSH if the vCPU hasn't been initialized.  The
+	 * list tracking still needs to be updated so that it's correct if/when
+	 * the vCPU does get initialized.
+	 */
+	if (is_td_vcpu_created(to_tdx(vcpu))) {
+		/*
+		 * No need to retry.  TDX Resources needed for TDH.VP.FLUSH are,
+		 * TDVPR as exclusive, TDR as shared, and TDCS as shared.  This
+		 * vp flush function is called when destructing vcpu/TD or vcpu
+		 * migration.  No other thread uses TDVPR in those cases.
+		 */
+		err = tdh_vp_flush(to_tdx(vcpu)->tdvpr_pa);
+		if (unlikely(err && err != TDX_VCPU_NOT_ASSOCIATED)) {
+			/*
+			 * This function is called in IPI context. Do not use
+			 * printk to avoid console semaphore.
+			 * The caller prints out the error message, instead.
+			 */
+			if (err)
+				arg->err = err;
+		}
+	}
+
+	tdx_disassociate_vp(vcpu);
+}
+
+static void tdx_flush_vp_on_cpu(struct kvm_vcpu *vcpu)
+{
+	struct tdx_flush_vp_arg arg = {
+		.vcpu = vcpu,
+	};
+	int cpu = vcpu->cpu;
+
+	if (unlikely(cpu == -1))
+		return;
+
+	smp_call_function_single(cpu, tdx_flush_vp, &arg, 1);
+	if (WARN_ON_ONCE(arg.err)) {
+		pr_err("cpu: %d ", cpu);
+		pr_tdx_error(TDH_VP_FLUSH, arg.err, NULL);
+	}
+}
+
+void tdx_hardware_disable(void)
+{
+	int cpu = raw_smp_processor_id();
+	struct list_head *tdvcpus = &per_cpu(associated_tdvcpus, cpu);
+	struct tdx_flush_vp_arg arg;
+	struct vcpu_tdx *tdx, *tmp;
+	unsigned long flags;
+
+	lockdep_assert_preemption_disabled();
+
+	local_irq_save(flags);
+	/* Safe variant needed as tdx_disassociate_vp() deletes the entry. */
+	list_for_each_entry_safe(tdx, tmp, tdvcpus, cpu_list) {
+		arg.vcpu = &tdx->vcpu;
+		tdx_flush_vp(&arg);
+	}
+	local_irq_restore(flags);
+}
+
 static void tdx_do_tdh_phymem_cache_wb(void *unused)
 {
 	u64 err = 0;
@@ -233,26 +353,31 @@ static void tdx_do_tdh_phymem_cache_wb(void *unused)
 		pr_tdx_error(TDH_PHYMEM_CACHE_WB, err, NULL);
 }
 
-void tdx_mmu_release_hkid(struct kvm *kvm)
+static int __tdx_mmu_release_hkid(struct kvm *kvm)
 {
 	bool packages_allocated, targets_allocated;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	cpumask_var_t packages, targets;
+	struct kvm_vcpu *vcpu;
+	unsigned long j;
+	int i, ret = 0;
 	u64 err;
-	int i;
 
 	if (!is_hkid_assigned(kvm_tdx))
-		return;
+		return 0;
 
 	if (!is_td_created(kvm_tdx)) {
 		tdx_hkid_free(kvm_tdx);
-		return;
+		return 0;
 	}
 
 	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
 	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
 	cpus_read_lock();
 
+	kvm_for_each_vcpu(j, vcpu, kvm)
+		tdx_flush_vp_on_cpu(vcpu);
+
 	/*
 	 * We can destroy multiple guest TDs simultaneously.  Prevent
 	 * tdh_phymem_cache_wb from returning TDX_BUSY by serialization.
@@ -270,6 +395,19 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 */
 	write_lock(&kvm->mmu_lock);
 
+	err = tdh_mng_vpflushdone(kvm_tdx->tdr_pa);
+	if (err == TDX_FLUSHVP_NOT_DONE) {
+		ret = -EBUSY;
+		goto out;
+	}
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err, NULL);
+		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
+		       kvm_tdx->hkid);
+		ret = -EIO;
+		goto out;
+	}
+
 	for_each_online_cpu(i) {
 		if (packages_allocated &&
 		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
@@ -291,14 +429,24 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		pr_tdx_error(TDH_MNG_KEY_FREEID, err, NULL);
 		pr_err("tdh_mng_key_freeid() failed. HKID %d is leaked.\n",
 		       kvm_tdx->hkid);
+		ret = -EIO;
 	} else
 		tdx_hkid_free(kvm_tdx);
 
+out:
 	write_unlock(&kvm->mmu_lock);
 	mutex_unlock(&tdx_lock);
 	cpus_read_unlock();
 	free_cpumask_var(targets);
 	free_cpumask_var(packages);
+
+	return ret;
+}
+
+void tdx_mmu_release_hkid(struct kvm *kvm)
+{
+	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
+		;
 }
 
 void tdx_vm_free(struct kvm *kvm)
@@ -455,6 +603,26 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (vcpu->cpu == cpu)
+		return;
+
+	tdx_flush_vp_on_cpu(vcpu);
+
+	local_irq_disable();
+	/*
+	 * Pairs with the smp_wmb() in tdx_disassociate_vp() to ensure
+	 * vcpu->cpu is read before tdx->cpu_list.
+	 */
+	smp_rmb();
+
+	list_add(&tdx->cpu_list, &per_cpu(associated_tdvcpus, cpu));
+	local_irq_enable();
+}
+
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -495,6 +663,16 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int i;
 
+	/*
+	 * When destroying VM, kvm_unload_vcpu_mmu() calls vcpu_load() for every
+	 * vcpu after they already disassociated from the per cpu list by
+	 * tdx_mmu_release_hkid().  So we need to disassociate them again,
+	 * otherwise the freed vcpu data will be accessed when do
+	 * list_{del,add}() on associated_tdvcpus list later.
+	 */
+	tdx_disassociate_vp_on_cpu(vcpu);
+	WARN_ON_ONCE(vcpu->cpu != -1);
+
 	/*
 	 * This methods can be called when vcpu allocation/initialization
 	 * failed. So it's possible that hkid, tdvpx and tdvpr are not assigned
@@ -2030,6 +2208,10 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 		return -EINVAL;
 	}
 
+	/* tdx_hardware_disable() uses associated_tdvcpus. */
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, i));
+
 	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
 		/*
 		 * Here it checks if MSRs (tdx_uret_msrs) can be saved/restored
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 0d8a98feb58e..7f8c78f06508 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -73,6 +73,8 @@ struct vcpu_tdx {
 	unsigned long *tdvpx_pa;
 	bool td_vcpu_created;
 
+	struct list_head cpu_list;
+
 	union tdx_exit_reason exit_reason;
 
 	bool initialized;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9fd997c79c33..5853f29f0af3 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -137,6 +137,7 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_INTEL_TDX_HOST
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 void tdx_hardware_unsetup(void);
+void tdx_hardware_disable(void);
 bool tdx_is_vm_type_supported(unsigned long type);
 int tdx_offline_cpu(void);
 
@@ -153,6 +154,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
+void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -171,6 +173,7 @@ void tdx_post_memory_mapping(struct kvm_vcpu *vcpu,
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
+static inline void tdx_hardware_disable(void) {}
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline int tdx_offline_cpu(void) { return 0; }
 
@@ -190,6 +193,7 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
 static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1


