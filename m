Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE4C4CDE90
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiCDUGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiCDUGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:06:06 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F562D14ED;
        Fri,  4 Mar 2022 12:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424114; x=1677960114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NykIWDWP79+50HxmKS6gaSA86CTH+g69IvXu+29N03w=;
  b=XVzP2JpagltsSEyGHJXGZ9nwgseoGo4fHJz7ryx+g2vdfll5spEGZEDw
   bU/a9uK610AaCUXSl66A35Dcj3ooP447BEMpOOk2uNqGG1KJzdlkm5oFE
   1SKZ3Lg26IqW87cP/meFgsR/+gG6akow6yf4I7kUwzbEC6VTNhHbM3ZqX
   IvSkGVRDknTkw02x0Jo1VykUtTsLynAxhPgeSx+KRy+Bw4jikyMOqTR6w
   8eB57qxaBMDayjN7h7+4dwGG1LOFXiqo5Tp7pfXuxzREwMRqSQruLZIV9
   oUFujON2GDjaeyuuv39tkbRccUtz/bajUMxgebyalHfb+4olNKxoNc5bB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983426"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983426"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:16 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344276"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:16 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 029/104] KVM: TDX: allocate/free TDX vcpu structure
Date:   Fri,  4 Mar 2022 11:48:45 -0800
Message-Id: <e50caba2a40beaaee7fc1ade60d55d414d979d34.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The next step of TDX guest creation is to create vcpu.  Allocate TDX vcpu
structures, initialize it.  Allocate pages of TDX vcpu for the TDX module.

In the case of the conventional case, cpuid is empty at the initialization.
and cpuid is configured after the vcpu initialization.  Because TDX
supports only X2APIC mode, cpuid is forcibly initialized to support X2APIC
on the vcpu initialization.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    |  30 +++++++-
 arch/x86/kvm/vmx/tdx.c     | 142 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_ops.h |   2 +
 arch/x86/kvm/vmx/x86_ops.h |   8 +++
 arch/x86/kvm/x86.c         |   3 +-
 arch/x86/kvm/x86.h         |   1 +
 6 files changed, 182 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index fc497f50e0e1..a11d3e870a98 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -65,6 +65,30 @@ static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
 	return tdx_vm_ioctl(kvm, argp);
 }
 
+static int vt_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_create(vcpu);
+
+	return vmx_vcpu_create(vcpu);
+}
+
+static void vt_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_free(vcpu);
+
+	return vmx_vcpu_free(vcpu);
+}
+
+static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_reset(vcpu, init_event);
+
+	return vmx_vcpu_reset(vcpu, init_event);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -81,9 +105,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.mmu_prezap = vt_mmu_prezap,
 	.vm_free = vt_vm_free,
 
-	.vcpu_create = vmx_vcpu_create,
-	.vcpu_free = vmx_vcpu_free,
-	.vcpu_reset = vmx_vcpu_reset,
+	.vcpu_create = vt_vcpu_create,
+	.vcpu_free = vt_vcpu_free,
+	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_guest_switch = vmx_prepare_switch_to_guest,
 	.vcpu_load = vmx_vcpu_load,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 236faaca68a0..e43ca93ff95b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include "capabilities.h"
 #include "x86_ops.h"
 #include "tdx.h"
+#include "x86.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt
@@ -51,6 +52,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa;
 }
 
+static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
+{
+	return tdx->tdvpr.added;
+}
+
 static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
 {
 	return kvm_tdx->tdr.added;
@@ -349,6 +355,142 @@ int tdx_vm_init(struct kvm *kvm)
 	return ret;
 }
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int ret, i;
+
+	ret = tdx_alloc_td_page(&tdx->tdvpr);
+	if (ret)
+		return ret;
+
+	tdx->tdvpx = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx),
+			GFP_KERNEL_ACCOUNT);
+	if (!tdx->tdvpx) {
+		ret = -ENOMEM;
+		goto free_tdvpr;
+	}
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		ret = tdx_alloc_td_page(&tdx->tdvpx[i]);
+		if (ret)
+			goto free_tdvpx;
+	}
+
+	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
+
+	vcpu->arch.cr0_guest_owned_bits = -1ul;
+	vcpu->arch.cr4_guest_owned_bits = -1ul;
+
+	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;
+	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
+	vcpu->arch.guest_state_protected =
+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
+
+	return 0;
+
+free_tdvpx:
+	/* @i points at the TDVPX page that failed allocation. */
+	for (--i; i >= 0; i--)
+		free_page(tdx->tdvpx[i].va);
+	kfree(tdx->tdvpx);
+free_tdvpr:
+	free_page(tdx->tdvpr.va);
+
+	return ret;
+}
+
+void tdx_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int i;
+
+	/* Can't reclaim or free pages if teardown failed. */
+	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm)))
+		return;
+
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
+		tdx_reclaim_td_page(&tdx->tdvpx[i]);
+	kfree(tdx->tdvpx);
+	tdx_reclaim_td_page(&tdx->tdvpr);
+}
+
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct msr_data apic_base_msr;
+	u64 err;
+	int i;
+
+	/* TDX doesn't support INIT event. */
+	if (WARN_ON(init_event))
+		goto td_bugged;
+	/* TDX supports only X2APIC enabled. */
+	if (WARN_ON(!vcpu->arch.apic))
+		goto td_bugged;
+	if (WARN_ON(is_td_vcpu_created(tdx)))
+		goto td_bugged;
+
+	/*
+	 * In TDX case, tsc frequency is per-VM and determined by the parameter
+	 * tdh_mng_init().  Forcibly set it instead of max_tsc_khz set by
+	 * kvm_arch_vcpu_create().
+	 *
+	 * This function is called after kvm_arch_vcpu_create() calling
+	 * kvm_set_tsc_khz().
+	 */
+	kvm_set_tsc_khz(vcpu, kvm_tdx->tsc_khz);
+
+	err = tdh_vp_create(kvm_tdx->tdr.pa, tdx->tdvpr.pa);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_VP_CREATE, err, NULL);
+		goto td_bugged;
+	}
+	tdx_mark_td_page_added(&tdx->tdvpr);
+
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		err = tdh_vp_addcx(tdx->tdvpr.pa, tdx->tdvpx[i].pa);
+		if (WARN_ON_ONCE(err)) {
+			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
+			goto td_bugged;
+		}
+		tdx_mark_td_page_added(&tdx->tdvpx[i]);
+	}
+
+	if (!vcpu->arch.cpuid_entries) {
+		/*
+		 * On cpu creation, cpuid entry is blank.  Forcibly enable
+		 * X2APIC feature to allow X2APIC.
+		 */
+		struct kvm_cpuid_entry2 *e;
+
+		e = kvmalloc_array(1, sizeof(*e), GFP_KERNEL_ACCOUNT);
+		*e  = (struct kvm_cpuid_entry2) {
+			.function = 1,	/* Features for X2APIC */
+			.index = 0,
+			.eax = 0,
+			.ebx = 0,
+			.ecx = 1ULL << 21,	/* X2APIC */
+			.edx = 0,
+		};
+		vcpu->arch.cpuid_entries = e;
+		vcpu->arch.cpuid_nent = 1;
+	}
+	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
+	if (kvm_vcpu_is_reset_bsp(vcpu))
+		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
+	apic_base_msr.host_initiated = true;
+	if (WARN_ON(kvm_set_apic_base(vcpu, &apic_base_msr)))
+		goto td_bugged;
+
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+	return;
+
+td_bugged:
+	vcpu->kvm->vm_bugged = true;
+}
+
 static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 3dd5b4c3f04c..dc76b3a5cf96 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -41,6 +41,7 @@ static inline u64 tdh_mem_sept_add(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
 
 static inline u64 tdh_vp_addcx(hpa_t tdvpr, hpa_t addr)
 {
+	tdx_clflush_page(addr);
 	return kvm_seamcall(TDH_VP_ADDCX, addr, tdvpr, 0, 0, 0, NULL);
 }
 
@@ -69,6 +70,7 @@ static inline u64 tdh_mng_create(hpa_t tdr, int hkid)
 
 static inline u64 tdh_vp_create(hpa_t tdr, hpa_t tdvpr)
 {
+	tdx_clflush_page(tdvpr);
 	return kvm_seamcall(TDH_VP_CREATE, tdvpr, tdr, 0, 0, 0, NULL);
 }
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 9d88ba9b093b..f1640f201a19 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -137,6 +137,10 @@ int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_prezap(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_free(struct kvm_vcpu *vcpu);
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
 static inline void tdx_pre_kvm_init(
@@ -149,6 +153,10 @@ static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_prezap(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
 
+static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 734699bd940f..158e1891ac14 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2322,7 +2322,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 	return 0;
 }
 
-static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
+int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 {
 	u32 thresh_lo, thresh_hi;
 	int use_scaling = 0;
@@ -2354,6 +2354,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 	}
 	return set_tsc_khz(vcpu, user_tsc_khz, use_scaling);
 }
+EXPORT_SYMBOL_GPL(kvm_set_tsc_khz);
 
 static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 5ff3badc3f2b..f15bf1c0aeb1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -303,6 +303,7 @@ extern int pi_inject_timer;
 extern bool report_ignored_msrs;
 
 extern unsigned long max_tsc_khz;
+int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz);
 
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
-- 
2.25.1

