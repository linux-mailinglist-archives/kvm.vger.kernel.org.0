Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFA258BD4F
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbiHGWEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbiHGWCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC32C95AD;
        Sun,  7 Aug 2022 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909761; x=1691445761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IXiyYhVNUgiGj1DJ7vywiMmdmdtkVo/SgTtJ9zDOJdY=;
  b=MuSKfTEI+YQCeh57jgJEfRXU7+stk6Lcc6MpCYX4TBUOpL8U5lCeM/yP
   n/6g2rJHZayIy6JyLDCRpkV73akThR/obVWH/UVsNuvXFspjc1qYxPHEC
   x3laeDweyXLe5r0ewdTnOZUo5ppxZWG7TTaS9+B2+QeerTPxugLtkTz3d
   uWpI18SODiVJF/+k9aME/xuawmkbWIvWml0dMpOu0dO0WtqhQ5LXDPjrv
   9tF+T708PmvIvbRq5k5bsBnYtR6pfUkJYo+wEF7zCgYHsM/f03VsvQaL6
   YQLCiZQMZVkdQ/JOkNcCXKuyhxMKmOneKb4Tvk5SVInCxMiB8W0KxaF7f
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240360"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240360"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682682"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:40 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 072/103] KVM: TDX: handle vcpu migration over logical processor
Date:   Sun,  7 Aug 2022 15:01:57 -0700
Message-Id: <ffb1260223296fec566371c121dacb34f0769f75.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

For vcpu migration, in the case of VMX, VCMS is flushed on the source pcpu,
and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
call them on vcpu migration.  The logic is mostly same as VMX except the
TDX SEAMCALLs are used.

When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    |  43 +++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 121 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |   2 +
 arch/x86/kvm/vmx/x86_ops.h |   6 ++
 4 files changed, 168 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 4776c4fb547e..8f1af269c387 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -17,6 +17,25 @@ static bool vt_is_vm_type_supported(unsigned long type)
 		(enable_tdx && tdx_is_vm_type_supported(type));
 }
 
+static int vt_hardware_enable(void)
+{
+	int ret;
+
+	ret = vmx_hardware_enable();
+	if (ret)
+		return ret;
+
+	tdx_hardware_enable();
+	return 0;
+}
+
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
@@ -151,6 +170,14 @@ static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu)
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
@@ -209,6 +236,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
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
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -231,8 +266,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_unsetup = vt_hardware_unsetup,
 	.check_processor_compatibility = vmx_check_processor_compatibility,
 
-	.hardware_enable = vmx_hardware_enable,
-	.hardware_disable = vmx_hardware_disable,
+	.hardware_enable = vt_hardware_enable,
+	.hardware_disable = vt_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
@@ -248,7 +283,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
-	.vcpu_load = vmx_vcpu_load,
+	.vcpu_load = vt_vcpu_load,
 	.vcpu_put = vt_vcpu_put,
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
@@ -336,7 +371,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
-	.sched_in = vmx_sched_in,
+	.sched_in = vt_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
 	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2354889df571..7849260a252d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -51,6 +51,14 @@ static struct tdx_capabilities tdx_caps;
 static DEFINE_MUTEX(tdx_lock);
 static struct mutex *tdx_mng_key_config_lock;
 
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
@@ -82,6 +90,36 @@ static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
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
+void tdx_hardware_enable(void)
+{
+	INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, raw_smp_processor_id()));
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
 static void tdx_clear_page(unsigned long page)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
@@ -158,6 +196,41 @@ static void tdx_reclaim_td_page(struct tdx_td_page *page)
 	free_page(page->va);
 }
 
+static void tdx_flush_vp(void *arg)
+{
+	struct kvm_vcpu *vcpu = arg;
+	u64 err;
+
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
+		err = tdh_vp_flush(to_tdx(vcpu)->tdvpr.pa);
+		if (unlikely(err && err != TDX_VCPU_NOT_ASSOCIATED)) {
+			if (WARN_ON_ONCE(err))
+				pr_tdx_error(TDH_VP_FLUSH, err, NULL);
+		}
+	}
+
+	tdx_disassociate_vp(vcpu);
+}
+
+static void tdx_flush_vp_on_cpu(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(vcpu->cpu == -1))
+		return;
+
+	smp_call_function_single(vcpu->cpu, tdx_flush_vp, vcpu, 1);
+}
+
 static int tdx_do_tdh_phymem_cache_wb(void *param)
 {
 	u64 err = 0;
@@ -182,9 +255,11 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	cpumask_var_t packages;
 	bool cpumask_allocated;
+	struct kvm_vcpu *vcpu;
 	u64 err;
 	int ret;
 	int i;
+	unsigned long j;
 
 	if (!is_hkid_assigned(kvm_tdx))
 		return;
@@ -192,6 +267,19 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	if (!is_td_created(kvm_tdx))
 		goto free_hkid;
 
+	kvm_for_each_vcpu(j, vcpu, kvm)
+		tdx_flush_vp_on_cpu(vcpu);
+
+	mutex_lock(&tdx_lock);
+	err = tdh_mng_vpflushdone(kvm_tdx->tdr.pa);
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
@@ -468,6 +556,26 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	return ret;
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
@@ -514,6 +622,19 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 		tdx_reclaim_td_page(&tdx->tdvpx[i]);
 	kfree(tdx->tdvpx);
 	tdx_reclaim_td_page(&tdx->tdvpr);
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
+	WARN_ON(vcpu->cpu != -1);
 }
 
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index e8ad047514ff..c507e99bedb1 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -84,6 +84,8 @@ struct vcpu_tdx {
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page *tdvpx;
 
+	struct list_head cpu_list;
+
 	union tdx_exit_reason exit_reason;
 
 	bool vcpu_initialized;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index e29de06c73c6..fb7b5fc5f0dd 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -135,6 +135,8 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 bool tdx_is_vm_type_supported(unsigned long type);
 void tdx_hardware_unsetup(void);
+void tdx_hardware_enable(void);
+void tdx_hardware_disable(void);
 int tdx_dev_ioctl(void __user *argp);
 
 int tdx_vm_init(struct kvm *kvm);
@@ -147,6 +149,7 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
+void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -158,6 +161,8 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline void tdx_hardware_unsetup(void) {}
+static inline void tdx_hardware_enable(void) {}
+static inline void tdx_hardware_disable(void) {}
 static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
 
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
@@ -171,6 +176,7 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu) { return EXIT_FASTPATH_NONE; }
 static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

