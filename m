Return-Path: <kvm+bounces-31586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D479C4FCF
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:47:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06DB41F2363A
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF27B21501C;
	Tue, 12 Nov 2024 07:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j1F3GSHD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA620B7EB;
	Tue, 12 Nov 2024 07:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397292; cv=none; b=nPyMc1wWZ2IyeD8VUiYJmG8tHLfpMuqZo2G8nzF+URYsiGtNuqCPqGKPGLMmeoq0PAGr6ItpCvp2/a0YDIo27sSQRGx/zOysMn70xrcM8+O8605f/isuu6wd8fmjP3yZgWzQ2SOOidP3LdxWM4/DYWXVdFcRxpeG2WplKNYcAxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397292; c=relaxed/simple;
	bh=8maquX7rIqjbR3syOA0q3Nw/T2JMdSZH0sD7Nw18LSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EegioWD3MpnwBLOTl/CG312OU/xEs5+MMBjnDTJ0iGeFV3CjbTLzak44yMBsMcQk3vxJMx6E2y3J6AL71H8Im/Oqx+Mew8FIvEZ7oDG2mGDM+CA7/aG1/b4FIZHPRz+xf59GSvCbbZ2XiwnGqJ/9PuPY1teANXnFigtJpCydLFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j1F3GSHD; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397290; x=1762933290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8maquX7rIqjbR3syOA0q3Nw/T2JMdSZH0sD7Nw18LSQ=;
  b=j1F3GSHDlK+ODsHvXQcmZBkGOrm8i6r6dmZkMg/92ZlDQL5aYjnuAi7y
   c3ryO+mIa9bb5ixr8UKLW6X72wJuvVFvryMGq0q56ziheTBtquoSrkOet
   BBXBZcMfd7CvkC4LhGFVYuu1cK43O8lZOAYaF/iht29gwfyfAHaa84vKq
   B0t/CC72v9dhzaFOOuhbFw/mxn4ZLO6w9t8/f8u2jMp9dWKOvVTJA+J3w
   mQnWC952lrRxmYwwd/aFvHG8yZVl04Fcowv5oLuqe4FfGLG/XzdiAGkIE
   rRPkwvI3vlFYmZJqD2lpDKIDsCNFWnVRp8jFrzyypW/CM6NdZfVCUWllr
   w==;
X-CSE-ConnectionGUID: Z5KL+r+kSeuWhGAKm20HsA==
X-CSE-MsgGUID: +73cIhYsTw+z7FTtUqjQug==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31311600"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31311600"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:41:29 -0800
X-CSE-ConnectionGUID: OrDPkGjCS0GehITXlhVenA==
X-CSE-MsgGUID: IHJs6NldQc2vc09pS73TbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="124830667"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:41:25 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 23/24] KVM: TDX: Handle vCPU dissociation
Date: Tue, 12 Nov 2024 15:38:58 +0800
Message-ID: <20241112073858.22312-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle vCPUs dissociations by invoking SEAMCALL TDH.VP.FLUSH which flushes
the address translation caches and cached TD VMCS of a TD vCPU in its
associated pCPU.

In TDX, a vCPUs can only be associated with one pCPU at a time, which is
done by invoking SEAMCALL TDH.VP.ENTER. For a successful association, the
vCPU must be dissociated from its previous associated pCPU.

To facilitate vCPU dissociation, introduce a per-pCPU list
associated_tdvcpus. Add a vCPU into this list when it's loaded into a new
pCPU (i.e. when a vCPU is loaded for the first time or migrated to a new
pCPU).

vCPU dissociations can happen under below conditions:
- On the op hardware_disable is called.
  This op is called when virtualization is disabled on a given pCPU, e.g.
  when hot-unplug a pCPU or machine shutdown/suspend.
  In this case, dissociate all vCPUs from the pCPU by iterating its
  per-pCPU list associated_tdvcpus.

- On vCPU migration to a new pCPU.
  Before adding a vCPU into associated_tdvcpus list of the new pCPU,
  dissociation from its old pCPU is required, which is performed by issuing
  an IPI and executing SEAMCALL TDH.VP.FLUSH on the old pCPU.
  On a successful dissociation, the vCPU will be removed from the
  associated_tdvcpus list of its previously associated pCPU.

- On tdx_mmu_release_hkid() is called.
  TDX mandates that all vCPUs must be disassociated prior to the release of
  an hkid. Therefore, dissociation of all vCPUs is a must before executing
  the SEAMCALL TDH.MNG.VPFLUSHDONE and subsequently freeing the hkid.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
TDX MMU part 2 v2:
 - No need for is_td_vcpu_created() (Rick)
 - Fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
   wrappers (Kai)
 - Rename vt_hardware_disable() and tdx_hardware_disable() to track
   upstream changes
 - Updated the comment of per-cpu list (Yan)
 - Added an assertion
   KVM_BUG_ON(cpu != raw_smp_processor_id(), vcpu->kvm) in tdx_vcpu_load().
   (Yan)

TDX MMU part 2 v1:
 - Changed title to "KVM: TDX: Handle vCPU dissociation" .
 - Updated commit log.
 - Removed calling tdx_disassociate_vp_on_cpu() in tdx_vcpu_free() since
   no new TD enter would be called for vCPU association after
   tdx_mmu_release_hkid(), which is now called in vt_vm_destroy(), i.e.
   after releasing vcpu fd and kvm_unload_vcpu_mmus(), and before
   tdx_vcpu_free().
 - TODO: include Isaku's fix
   https://eclists.intel.com/sympa/arc/kvm-qemu-review/2024-07/msg00359.html
 - Update for the wrapper functions for SEAMCALLs. (Sean)
 - Removed unnecessary pr_err() in tdx_flush_vp_on_cpu().
 - Use KVM_BUG_ON() in tdx_flush_vp_on_cpu() for consistency.
 - Capitalize the first word of tile. (Binbin)
 - Minor fixed in changelog. (Binbin, Reinette(internal))
 - Fix some comments. (Binbin, Reinette(internal))
 - Rename arg_ to _arg (Binbin)
 - Updates from seamcall overhaul (Kai)
 - Remove lockdep_assert_preemption_disabled() in tdx_hardware_setup()
   since now hardware_enable() is not called via SMP func call anymore,
   but (per-cpu) CPU hotplug thread
 - Use KVM_BUG_ON() for SEAMCALLs in tdx_mmu_release_hkid() (Kai)
 - Update based on upstream commit "KVM: x86: Fold kvm_arch_sched_in()
   into kvm_arch_vcpu_load()"
 - Eliminate TDX_FLUSHVP_NOT_DONE error check because vCPUs were all freed.
   So the error won't happen. (Sean)
---
 arch/x86/kvm/vmx/main.c    |  22 ++++-
 arch/x86/kvm/vmx/tdx.c     | 159 +++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h     |   2 +
 arch/x86/kvm/vmx/x86_ops.h |   4 +
 4 files changed, 177 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 244fb80d385a..bfed421e6fbb 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,6 +10,14 @@
 #include "tdx.h"
 #include "tdx_arch.h"
 
+static void vt_disable_virtualization_cpu(void)
+{
+	/* Note, TDX *and* VMX need to be disabled if TDX is enabled. */
+	if (enable_tdx)
+		tdx_disable_virtualization_cpu();
+	vmx_disable_virtualization_cpu();
+}
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -111,6 +119,16 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx_vcpu_reset(vcpu, init_event);
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
@@ -199,7 +217,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_unsetup = vmx_hardware_unsetup,
 
 	.enable_virtualization_cpu = vmx_enable_virtualization_cpu,
-	.disable_virtualization_cpu = vmx_disable_virtualization_cpu,
+	.disable_virtualization_cpu = vt_disable_virtualization_cpu,
 	.emergency_disable_virtualization_cpu = vmx_emergency_disable_virtualization_cpu,
 
 	.has_emulated_msr = vmx_has_emulated_msr,
@@ -216,7 +234,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
-	.vcpu_load = vmx_vcpu_load,
+	.vcpu_load = vt_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index acaa11be1031..dc6c5f40608e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -155,6 +155,21 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
 /* Maximum number of retries to attempt for SEAMCALLs. */
 #define TDX_SEAMCALL_RETRIES	10000
 
+/*
+ * A per-CPU list of TD vCPUs associated with a given CPU.
+ * Protected by interrupt mask. Only manipulated by the CPU owning this per-CPU
+ * list.
+ * - When a vCPU is loaded onto a CPU, it is removed from the per-CPU list of
+ *   the old CPU during the IPI callback running on the old CPU, and then added
+ *   to the per-CPU list of the new CPU.
+ * - When a TD is tearing down, all vCPUs are disassociated from their current
+ *   running CPUs and removed from the per-CPU list during the IPI callback
+ *   running on those CPUs.
+ * - When a CPU is brought down, traverse the per-CPU list to disassociate all
+ *   associated TD vCPUs and remove them from the per-CPU list.
+ */
+static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
+
 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
@@ -172,6 +187,22 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
 	return kvm_tdx->hkid > 0;
 }
 
+static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
+{
+	lockdep_assert_irqs_disabled();
+
+	list_del(&to_tdx(vcpu)->cpu_list);
+
+	/*
+	 * Ensure tdx->cpu_list is updated before setting vcpu->cpu to -1,
+	 * otherwise, a different CPU can see vcpu->cpu = -1 and add the vCPU
+	 * to its list before it's deleted from this CPU's list.
+	 */
+	smp_wmb();
+
+	vcpu->cpu = -1;
+}
+
 static void tdx_clear_page(unsigned long page_pa)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
@@ -252,6 +283,83 @@ static void tdx_reclaim_control_page(unsigned long ctrl_page_pa)
 	free_page((unsigned long)__va(ctrl_page_pa));
 }
 
+struct tdx_flush_vp_arg {
+	struct kvm_vcpu *vcpu;
+	u64 err;
+};
+
+static void tdx_flush_vp(void *_arg)
+{
+	struct tdx_flush_vp_arg *arg = _arg;
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
+	if (to_tdx(vcpu)->state != VCPU_TD_STATE_UNINITIALIZED) {
+		/*
+		 * No need to retry.  TDX Resources needed for TDH.VP.FLUSH are:
+		 * TDVPR as exclusive, TDR as shared, and TDCS as shared.  This
+		 * vp flush function is called when destructing vCPU/TD or vCPU
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
+	if (KVM_BUG_ON(arg.err, vcpu->kvm))
+		pr_tdx_error(TDH_VP_FLUSH, arg.err);
+}
+
+void tdx_disable_virtualization_cpu(void)
+{
+	int cpu = raw_smp_processor_id();
+	struct list_head *tdvcpus = &per_cpu(associated_tdvcpus, cpu);
+	struct tdx_flush_vp_arg arg;
+	struct vcpu_tdx *tdx, *tmp;
+	unsigned long flags;
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
 static void smp_func_do_phymem_cache_wb(void *unused)
 {
 	u64 err = 0;
@@ -288,22 +396,21 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	bool packages_allocated, targets_allocated;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	cpumask_var_t packages, targets;
-	u64 err;
+	struct kvm_vcpu *vcpu;
+	unsigned long j;
 	int i;
+	u64 err;
 
 	if (!is_hkid_assigned(kvm_tdx))
 		return;
 
-	/* KeyID has been allocated but guest is not yet configured */
-	if (!kvm_tdx->tdr_pa) {
-		tdx_hkid_free(kvm_tdx);
-		return;
-	}
-
 	packages_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
 	targets_allocated = zalloc_cpumask_var(&targets, GFP_KERNEL);
 	cpus_read_lock();
 
+	kvm_for_each_vcpu(j, vcpu, kvm)
+		tdx_flush_vp_on_cpu(vcpu);
+
 	/*
 	 * TDH.PHYMEM.CACHE.WB tries to acquire the TDX module global lock
 	 * and can fail with TDX_OPERAND_BUSY when it fails to get the lock.
@@ -317,6 +424,16 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 * After the above flushing vps, there should be no more vCPU
 	 * associations, as all vCPU fds have been released at this stage.
 	 */
+	err = tdh_mng_vpflushdone(kvm_tdx->tdr_pa);
+	if (err == TDX_FLUSHVP_NOT_DONE)
+		goto out;
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err);
+		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
+		       kvm_tdx->hkid);
+		goto out;
+	}
+
 	for_each_online_cpu(i) {
 		if (packages_allocated &&
 		    cpumask_test_and_set_cpu(topology_physical_package_id(i),
@@ -342,6 +459,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		tdx_hkid_free(kvm_tdx);
 	}
 
+out:
 	mutex_unlock(&tdx_lock);
 	cpus_read_unlock();
 	free_cpumask_var(targets);
@@ -489,6 +607,27 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
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
+	KVM_BUG_ON(cpu != raw_smp_processor_id(), vcpu->kvm);
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
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
@@ -1937,7 +2076,7 @@ static int __init __do_tdx_bringup(void)
 static int __init __tdx_bringup(void)
 {
 	const struct tdx_sys_info_td_conf *td_conf;
-	int r;
+	int r, i;
 
 	if (!tdp_mmu_enabled || !enable_mmio_caching)
 		return -EOPNOTSUPP;
@@ -1947,6 +2086,10 @@ static int __init __tdx_bringup(void)
 		return -EOPNOTSUPP;
 	}
 
+	/* tdx_disable_virtualization_cpu() uses associated_tdvcpus. */
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, i));
+
 	/*
 	 * Enabling TDX requires enabling hardware virtualization first,
 	 * as making SEAMCALLs requires CPU being in post-VMXON state.
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index aeddf2bb0a94..899654519df6 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -49,6 +49,8 @@ struct vcpu_tdx {
 	unsigned long tdvpr_pa;
 	unsigned long *tdcx_pa;
 
+	struct list_head cpu_list;
+
 	enum vcpu_tdx_state state;
 };
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f61daac5f2f0..06583b1afa4f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -119,6 +119,7 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
+void tdx_disable_virtualization_cpu(void);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
@@ -127,6 +128,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
+void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -144,6 +146,7 @@ void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #else
+static inline void tdx_disable_virtualization_cpu(void) {}
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
@@ -152,6 +155,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.43.2


