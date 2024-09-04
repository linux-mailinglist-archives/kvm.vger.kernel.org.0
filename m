Return-Path: <kvm+bounces-25829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD40596AF21
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F20361C240BF
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D1A146A60;
	Wed,  4 Sep 2024 03:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YdvENOHt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B580313F458;
	Wed,  4 Sep 2024 03:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419689; cv=none; b=TRFtKYBE1hgC/Ex0j2fWybz+w+LU8VuwphDjzQ5j84fgYNqpHE289ktheEN3ZOUiISNOL3c8hUY+4QXF9XEt0KKdZPllWJSx0p4JXdqL0y/DkNCSvdtBVKU6rB6omjmbXEeHy/xXUZt8e7nc+bX+4VGkyWLQePAC5sCwYh+VSds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419689; c=relaxed/simple;
	bh=WX27fnXsZPVUcpAjBEAPE+bdFp1W2FwYupWRB5xei9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XCvlD1TjYlfCtOLgb0ecW81qJV953I9EBqMju1fpPJQihtk3f4k1szu+z4ZskBaYtsQZM1SqIYDYorYSTxyFohYjewicG1LiB4QY4rIqzy/F0ZS5URXcne7c2cpoHlc9Mzkq7AeIWqEeJax7nnhCJLqw0o1HlWt6ZXL9QTKELRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YdvENOHt; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419686; x=1756955686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WX27fnXsZPVUcpAjBEAPE+bdFp1W2FwYupWRB5xei9Q=;
  b=YdvENOHtnMjzfxyYMmTV2tfD+/55LeHfeYHSVcNZ/Vf/ulZsOqfP4liB
   JBHuxuOPvTsVN5qxuoBnEjQ4bTQ702SZVMCbHPcFliGPNex7Qkt25onDN
   /C7Vn/Ak1v9U8GzIIIQ9j4zSDMu4vs3v1j2/JzgQWOLd7hKNHkxZJuvs2
   GOkkFd/TANDNn6bQupvMcS2zvg6YodWzQwcyE8fDBOwqfsNqIiZl8EMX7
   WsyGRE8ntzS1cl+/UecMRR1+H3TilxSMA7bKqI5waLrgr+wbaFRlR8x7V
   a69ui1lAxpiqEojDbA1oLbdqvySD7VAD/PXhVAHvmZBMaBXzcGEwkd5FA
   w==;
X-CSE-ConnectionGUID: ZVfGFlVEQOqW1QReaeIqpQ==
X-CSE-MsgGUID: q72WS+HnQfW313xdaAqvow==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564737"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564737"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:14 -0700
X-CSE-ConnectionGUID: RtPFJEKvRuOfYMLIf1xdwQ==
X-CSE-MsgGUID: zu8SYLqvRBqM9NEDRtn4iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106401"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:13 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 21/21] KVM: TDX: Handle vCPU dissociation
Date: Tue,  3 Sep 2024 20:07:51 -0700
Message-Id: <20240904030751.117579-22-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
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
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
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
 arch/x86/kvm/vmx/main.c    |  22 +++++-
 arch/x86/kvm/vmx/tdx.c     | 151 +++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h     |   2 +
 arch/x86/kvm/vmx/x86_ops.h |   4 +
 4 files changed, 169 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 8f5dbab9099f..8171c1412c3b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,6 +10,14 @@
 #include "tdx.h"
 #include "tdx_arch.h"
 
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
@@ -113,6 +121,16 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
 	/*
@@ -217,7 +235,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_unsetup = vmx_hardware_unsetup,
 
 	.hardware_enable = vmx_hardware_enable,
-	.hardware_disable = vmx_hardware_disable,
+	.hardware_disable = vt_hardware_disable,
 	.emergency_disable = vmx_emergency_disable,
 
 	.has_emulated_msr = vmx_has_emulated_msr,
@@ -234,7 +252,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
-	.vcpu_load = vmx_vcpu_load,
+	.vcpu_load = vt_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3083a66bb895..554154d3dd58 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -57,6 +57,14 @@ static DEFINE_MUTEX(tdx_lock);
 /* Maximum number of retries to attempt for SEAMCALLs. */
 #define TDX_SEAMCALL_RETRIES	10000
 
+/*
+ * A per-CPU list of TD vCPUs associated with a given CPU.  Used when a CPU
+ * is brought down to invoke TDH_VP_FLUSH on the appropriate TD vCPUS.
+ * Protected by interrupt mask.  This list is manipulated in process context
+ * of vCPU and IPI callback.  See tdx_flush_vp_on_cpu().
+ */
+static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);
+
 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
@@ -88,6 +96,22 @@ static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
 	return kvm_tdx->finalized;
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
@@ -168,6 +192,83 @@ static void tdx_reclaim_control_page(unsigned long ctrl_page_pa)
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
+	if (is_td_vcpu_created(to_tdx(vcpu))) {
+		/*
+		 * No need to retry.  TDX Resources needed for TDH.VP.FLUSH are:
+		 * TDVPR as exclusive, TDR as shared, and TDCS as shared.  This
+		 * vp flush function is called when destructing vCPU/TD or vCPU
+		 * migration.  No other thread uses TDVPR in those cases.
+		 */
+		err = tdh_vp_flush(to_tdx(vcpu));
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
+void tdx_hardware_disable(void)
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
@@ -204,22 +305,21 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
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
-	if (!is_td_created(kvm_tdx)) {
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
@@ -233,6 +333,16 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 * After the above flushing vps, there should be no more vCPU
 	 * associations, as all vCPU fds have been released at this stage.
 	 */
+	err = tdh_mng_vpflushdone(kvm_tdx);
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
@@ -258,6 +368,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		tdx_hkid_free(kvm_tdx);
 	}
 
+out:
 	mutex_unlock(&tdx_lock);
 	cpus_read_unlock();
 	free_cpumask_var(targets);
@@ -409,6 +520,26 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
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
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -1977,7 +2108,7 @@ static int __init __do_tdx_bringup(void)
 static int __init __tdx_bringup(void)
 {
 	const struct tdx_sys_info_td_conf *td_conf;
-	int r;
+	int r, i;
 
 	if (!tdp_mmu_enabled || !enable_mmio_caching)
 		return -EOPNOTSUPP;
@@ -1987,6 +2118,10 @@ static int __init __tdx_bringup(void)
 		return -EOPNOTSUPP;
 	}
 
+	/* tdx_hardware_disable() uses associated_tdvcpus. */
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, i));
+
 	/*
 	 * Enabling TDX requires enabling hardware virtualization first,
 	 * as making SEAMCALLs requires CPU being in post-VMXON state.
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 25a4aaede2ba..4b6fc25feeb6 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -39,6 +39,8 @@ struct vcpu_tdx {
 	unsigned long *tdcx_pa;
 	bool td_vcpu_created;
 
+	struct list_head cpu_list;
+
 	bool initialized;
 
 	/*
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index d8a00ab4651c..f4aa0ec16980 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -119,6 +119,7 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
+void tdx_hardware_disable(void);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
@@ -128,6 +129,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -145,6 +147,7 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
 #else
+static inline void tdx_hardware_disable(void) {}
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
@@ -154,6 +157,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.34.1


