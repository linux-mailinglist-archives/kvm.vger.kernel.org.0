Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F65667AFA
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjALQho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbjALQhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:11 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4A7B1F9;
        Thu, 12 Jan 2023 08:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541216; x=1705077216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+D02GFRwzyPPzHRZ3ML+NUyBlJUGTn/xk6VLzziNYYQ=;
  b=kAM1ySz3A4T49I/IN7oMxjHiHRpZWrNiEMD8mWiWyBUvYo5y5yJo3fOg
   KSolc0f5TSiRM7N8+P7VtzIj+ng9IM9rLl8DpWUP2B83ceLsGFXojY1lE
   vNgVDvFv0DeOvl0z5/xPS+BQGHHUfMahpSDghAvsPUUeboNp859k6N/G9
   1xilTR4nrtM9ZiDEtt1nr25ZhHEw75fmxpCRuuWKK2yta9ImA+efb29o1
   mQ8efOgSJArP4FcDzEmOKZj9itTOzEahC46xAFAKcknSYV+sHnuDpFHiN
   D4bvumauVeNuPDeuzt06+t3aFjpVIZTSJxKd/w/Rdndwt+CJKVSCelUq/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089623"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089623"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372477"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372477"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:32 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 073/113] KVM: TDX: handle vcpu migration over logical processor
Date:   Thu, 12 Jan 2023 08:32:21 -0800
Message-Id: <4420e8c07114c990b67bc8237994a2432887c635.1673539699.git.isaku.yamahata@intel.com>
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

For vcpu migration, in the case of VMX, VMCS is flushed on the source pcpu,
and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
call them on vcpu migration.  The logic is mostly same as VMX except the
TDX SEAMCALLs are used.

When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    |  35 ++++++++-
 arch/x86/kvm/vmx/tdx.c     | 152 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |   2 +
 arch/x86/kvm/vmx/x86_ops.h |   7 ++
 4 files changed, 193 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index f4b20974199f..7be68c3b345b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -17,6 +17,13 @@ static bool vt_is_vm_type_supported(unsigned long type)
 		(enable_tdx && tdx_is_vm_type_supported(type));
 }
 
+static void vt_hardware_disable(void)
+{
+	/* Note, TDX *and* VMX need to be disabled if TDX is enabled. */
+	tdx_hardware_disable();
+	vmx_hardware_disable();
+}
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -141,6 +148,14 @@ static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
 	return vmx_vcpu_run(vcpu);
 }
 
+static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_load(vcpu, cpu);
+
+	return vmx_vcpu_load(vcpu, cpu);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -199,6 +214,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
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
@@ -232,7 +255,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.offline_cpu = tdx_offline_cpu,
 
 	.hardware_enable = vmx_hardware_enable,
-	.hardware_disable = vmx_hardware_disable,
+	.hardware_disable = vt_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
@@ -248,7 +271,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
-	.vcpu_load = vmx_vcpu_load,
+	.vcpu_load = vt_vcpu_load,
 	.vcpu_put = vt_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
@@ -336,7 +359,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
-	.sched_in = vmx_sched_in,
+	.sched_in = vt_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
@@ -404,6 +427,10 @@ static int __init vt_init(void)
 	if (r)
 		goto err_vmx_init;
 
+	r = tdx_init();
+	if (r)
+		goto err_tdx_init;
+
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
@@ -426,6 +453,8 @@ static int __init vt_init(void)
 	return 0;
 
 err_kvm_init:
+	/* tdx_exit() is not defined. */
+err_tdx_init:
 	vmx_exit();
 err_vmx_init:
 	kvm_x86_vendor_exit();
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f2b92c8bc081..0eed2481641b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -51,6 +51,14 @@ static DEFINE_MUTEX(tdx_lock);
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
@@ -82,6 +90,31 @@ static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
 	return kvm_tdx->finalized;
 }
 
+static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
+{
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
+void tdx_hardware_disable(void)
+{
+	int cpu = raw_smp_processor_id();
+	struct list_head *tdvcpus = &per_cpu(associated_tdvcpus, cpu);
+	struct vcpu_tdx *tdx, *tmp;
+
+	/* Safe variant needed as tdx_disassociate_vp() deletes the entry. */
+	list_for_each_entry_safe(tdx, tmp, tdvcpus, cpu_list)
+		tdx_disassociate_vp(&tdx->vcpu);
+}
+
 static void tdx_clear_page(unsigned long page_pa)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
@@ -163,6 +196,68 @@ static void tdx_reclaim_td_page(unsigned long td_page_pa)
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
+	if (vcpu->cpu != raw_smp_processor_id())
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
 static int tdx_do_tdh_phymem_cache_wb(void *param)
 {
 	u64 err = 0;
@@ -187,6 +282,8 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	cpumask_var_t packages;
 	bool cpumask_allocated;
+	struct kvm_vcpu *vcpu;
+	unsigned long j;
 	u64 err;
 	int ret;
 	int i;
@@ -197,6 +294,19 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	if (!is_td_created(kvm_tdx))
 		goto free_hkid;
 
+	kvm_for_each_vcpu(j, vcpu, kvm)
+		tdx_flush_vp_on_cpu(vcpu);
+
+	mutex_lock(&tdx_lock);
+	err = tdh_mng_vpflushdone(kvm_tdx->tdr_pa);
+	mutex_unlock(&tdx_lock);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err, NULL);
+		pr_err("tdh_mng_vpflushdone failed. HKID %d is leaked.\n",
+			kvm_tdx->hkid);
+		return;
+	}
+
 	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
 	cpus_read_lock();
 	for_each_online_cpu(i) {
@@ -381,6 +491,26 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
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
@@ -431,6 +561,19 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 	}
 	tdx_reclaim_td_page(tdx->tdvpr_pa);
 	tdx->tdvpr_pa = 0;
+
+	/*
+	 * kvm_free_vcpus()
+	 *   -> kvm_unload_vcpu_mmu()
+	 *
+	 * does vcpu_load() for every vcpu after they already disassociated
+	 * from the per cpu list when tdx_vm_teardown(). So we need to
+	 * disassociate them again, otherwise the freed vcpu data will be
+	 * accessed when do list_{del,add}() on associated_tdvcpus list
+	 * later.
+	 */
+	tdx_flush_vp_on_cpu(vcpu);
+	WARN_ON_ONCE(vcpu->cpu != -1);
 }
 
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -1699,3 +1842,12 @@ int tdx_offline_cpu(void)
 			"Delete all TDs in order to offline all CPUs of a package.\n");
 	return ret;
 }
+
+int __init tdx_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, cpu));
+	return 0;
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index e97cb19a7a50..6e021ef6a943 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -62,6 +62,8 @@ struct vcpu_tdx {
 	unsigned long tdvpr_pa;
 	unsigned long *tdvpx_pa;
 
+	struct list_head cpu_list;
+
 	union tdx_exit_reason exit_reason;
 
 	bool vcpu_initialized;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f5ee5efd7cf6..dbbc27519637 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -141,8 +141,11 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
+int __init tdx_init(void);
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 void tdx_hardware_unsetup(void);
+void tdx_hardware_enable(void);
+void tdx_hardware_disable(void);
 bool tdx_is_vm_type_supported(unsigned long type);
 int tdx_dev_ioctl(void __user *argp);
 int tdx_offline_cpu(void);
@@ -157,6 +160,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
+void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
@@ -166,8 +170,10 @@ void tdx_flush_tlb(struct kvm_vcpu *vcpu);
 int tdx_sept_tlb_remote_flush(struct kvm *kvm);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
+static inline int tdx_init(void) { return 0; };
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline void tdx_hardware_unsetup(void) {}
+static inline void tdx_hardware_disable(void) {}
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
 static inline int tdx_offline_cpu(void) { return 0; }
@@ -183,6 +189,7 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
 static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

