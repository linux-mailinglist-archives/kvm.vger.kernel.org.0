Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F524CDF67
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiCDUcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiCDUcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:32:21 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F51F1E745D;
        Fri,  4 Mar 2022 12:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646425892; x=1677961892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XReXNqpwpeyey4iDt5Hc4w6I7ya/Tm4BYwR6+cJm6/A=;
  b=jScdxAMChw9gisXtyDR80F1mcu4Wa15Q49xxsuS3pSa8wJI0xQA5638y
   P+W4h/nJjWNUv60dLlqBgUmYHdZrHjOX8XTollSrc1cOPLtG26MuLHLKa
   wH4Uk8jUh+y0z3hMOxNzMKj3K+xRrRv0OhqCdXJROZpl5hAqCmH4YXGYz
   hr/+UH++ORFTcMSu8fTZdAAwk18MpqlIhuouk14syxOJ5vEKONFXsFuBw
   gfoXNPhRrQXB6cmgdy5/WQn3GflLhV87+HSdJZg9Lo9tnZDwhPxQ99elP
   HZqRVDQG5+KJ2ERxmtMipP+9mpoXx7kABCAgT9OsBRmO03QeIxR/EMEsS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251624275"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251624275"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:36 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344484"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:35 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 073/104] KVM: TDX: track LP tdx vcpu run and teardown vcpus on descroing the guest TD
Date:   Fri,  4 Mar 2022 11:49:29 -0800
Message-Id: <6e096d8509ef40ce3e25c1e132643e772641241b.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 23 +++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 70 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h     |  2 ++
 arch/x86/kvm/vmx/x86_ops.h |  4 +++
 4 files changed, 95 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 2cd5ba0e8788..882358ac270b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -13,6 +13,25 @@ static bool vt_is_vm_type_supported(unsigned long type)
 	return type == KVM_X86_DEFAULT_VM || tdx_is_vm_type_supported(type);
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
@@ -199,8 +218,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_unsetup = vt_hardware_unsetup,
 
-	.hardware_enable = vmx_hardware_enable,
-	.hardware_disable = vmx_hardware_disable,
+	.hardware_enable = vt_hardware_enable,
+	.hardware_disable = vt_hardware_disable,
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a6b1a8ce888d..690298fb99c7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -48,6 +48,14 @@ struct tdx_capabilities tdx_caps;
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
 static u64 hkid_mask __ro_after_init;
 static u8 hkid_start_pos __ro_after_init;
 
@@ -87,6 +95,8 @@ static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
 
 static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 {
+	list_del(&to_tdx(vcpu)->cpu_list);
+
 	/*
 	 * Ensure tdx->cpu_list is updated is before setting vcpu->cpu to -1,
 	 * otherwise, a different CPU can see vcpu->cpu = -1 and add the vCPU
@@ -97,6 +107,22 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
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
@@ -230,9 +256,11 @@ void tdx_mmu_prezap(struct kvm *kvm)
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
@@ -248,6 +276,17 @@ void tdx_mmu_prezap(struct kvm *kvm)
 		return;
 	}
 
+	kvm_for_each_vcpu(j, vcpu, kvm)
+		tdx_flush_vp_on_cpu(vcpu);
+
+	mutex_lock(&tdx_lock);
+	err = tdh_mng_vpflushdone(kvm_tdx->tdr.pa);
+	mutex_unlock(&tdx_lock);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_VPFLUSHDONE, err, NULL);
+		return;
+	}
+
 	cpumask_allocated = zalloc_cpumask_var(&packages, GFP_KERNEL);
 	for_each_online_cpu(i) {
 		if (cpumask_allocated &&
@@ -472,8 +511,22 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (vcpu->cpu != cpu)
-		tdx_flush_vp_on_cpu(vcpu);
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
 }
 
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -522,6 +575,19 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
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
index 8b1cf9c158e3..180360a65545 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -81,6 +81,8 @@ struct vcpu_tdx {
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page *tdvpx;
 
+	struct list_head cpu_list;
+
 	union tdx_exit_reason exit_reason;
 
 	bool initialized;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ceafd6e18f4e..aae0f4449ec5 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -132,6 +132,8 @@ void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
 bool tdx_is_vm_type_supported(unsigned long type);
 void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 void tdx_hardware_unsetup(void);
+void tdx_hardware_enable(void);
+void tdx_hardware_disable(void);
 
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_prezap(struct kvm *kvm);
@@ -156,6 +158,8 @@ static inline void tdx_pre_kvm_init(
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
 static inline void tdx_hardware_unsetup(void) {}
+static inline void tdx_hardware_enable(void) {}
+static inline void tdx_hardware_disable(void) {}
 
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_prezap(struct kvm *kvm) {}
-- 
2.25.1

