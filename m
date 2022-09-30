Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B647F5F0874
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiI3KUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiI3KTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:00 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310D1163B60;
        Fri, 30 Sep 2022 03:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533139; x=1696069139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1stPIgHyis1he2c07VfBLAZMiMFnIIlywivg7Mw8CwM=;
  b=NBhPdbqtUv8ygKlYYDGIBaL35nsaTDJnD7K7NbRuJezb8pW9uI4O6DCY
   OT1xxfI0YtYSnH438v+xEvo9dAq3/KY3XMc42OjPHBEtiqb9UTRqfifM9
   m/a7bbWS8wC7V0w+9HDEmATTZx5p6Cf8gphFigmJ44Vh4OItV7gtWOR1L
   wTpUSERDrGp/T5011QbFQMvLvCqChKVO+tFqo4dgmqs+zOQuCncyLPCn3
   mL7BGm4W4lQboAr0KGXsawnWnUdxDIjF7wLrCiRCZt1x60p2VXXuyohGL
   X/a+oFSLSM0ql2hWX0wCDnKvMxCX07yAuAO4CMnMZmOVxq+yczTsovtU0
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870077"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870077"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:55 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807577"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807577"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 023/105] KVM: TDX: allocate/free TDX vcpu structure
Date:   Fri, 30 Sep 2022 03:17:17 -0700
Message-Id: <cfe721a18424100eba8c72ec4fd78aacedf705c9.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c    |  40 +++++++++--
 arch/x86/kvm/vmx/tdx.c     | 138 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |   8 +++
 3 files changed, 182 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 42b1243a89e5..b49d3f58dc4f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -63,6 +63,38 @@ static void vt_vm_free(struct kvm *kvm)
 		return tdx_vm_free(kvm);
 }
 
+static int vt_vcpu_precreate(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return 0;
+
+	return vmx_vcpu_precreate(kvm);
+}
+
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
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -89,10 +121,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vm_destroy = vt_vm_destroy,
 	.vm_free = vt_vm_free,
 
-	.vcpu_precreate = vmx_vcpu_precreate,
-	.vcpu_create = vmx_vcpu_create,
-	.vcpu_free = vmx_vcpu_free,
-	.vcpu_reset = vmx_vcpu_reset,
+	.vcpu_precreate = vt_vcpu_precreate,
+	.vcpu_create = vt_vcpu_create,
+	.vcpu_free = vt_vcpu_free,
+	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
 	.vcpu_load = vmx_vcpu_load,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3c16f2d535b1..0fa4746f0450 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -49,6 +49,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
 }
 
+static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
+{
+	return tdx->tdvpr.added;
+}
+
 static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
 {
 	return kvm_tdx->tdr.added;
@@ -286,6 +291,139 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int ret, i;
+
+	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
+	if (!vcpu->arch.apic)
+		return -EINVAL;
+
+	fpstate_set_confidential(&vcpu->arch.guest_fpu);
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
+	tdx->tdvpx = NULL;
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
+	if (tdx->tdvpx) {
+		for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++)
+			tdx_reclaim_td_page(&tdx->tdvpx[i]);
+		kfree(tdx->tdvpx);
+		tdx->tdvpx = NULL;
+	}
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
+	if (WARN_ON_ONCE(init_event))
+		goto td_bugged;
+	if (WARN_ON_ONCE(is_td_vcpu_created(tdx)))
+		goto td_bugged;
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
+	if (WARN_ON_ONCE(kvm_set_apic_base(vcpu, &apic_base_msr)))
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
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 3576b5c7238d..1febdc8dfe9f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -141,6 +141,10 @@ int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_free(struct kvm_vcpu *vcpu);
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
@@ -154,6 +158,10 @@ static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
 static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
 
+static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
-- 
2.25.1

