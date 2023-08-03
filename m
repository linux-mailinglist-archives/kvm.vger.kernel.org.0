Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E36976E1B9
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbjHCHhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjHCHgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:08 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304AE35B5;
        Thu,  3 Aug 2023 00:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047939; x=1722583939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MtGa0CIT6TMKrMJCbtFW+RrI6aWHvtFB1pwFF6IjLuc=;
  b=hD+szM+yT8EoXcB+T4cyYV68AVRuOHBSZ/+4RcJRTw0Eos1tkN+L2LaQ
   UXmO/FQzdy3ttp86SyXt4kNftJWx+kWQiKTDNwOKM21VrrbpTH7JOOij8
   ClkgBr3BjOdU2zUIigeAIXFPZk/MOjXzOEx1ofujKAmXse8Mn8tjMLyVX
   SPY2KlocQR4a4Aso5yDdWfK/z31uFymU5hJ7ZmDGigT8+rz5Mw8DpHFtR
   JeprOO51G84qgEXcRt9MunV/LgD/0cYG3lSdRU++nBCG/nXfvBc8aNM4x
   yMi9McEST4df+O1byy3S0E5o/s4E2u6WKibP5kPEAN64J7PcYfB7gFStB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708123"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708123"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888492"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888492"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:16 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as non-XSAVE managed
Date:   Thu,  3 Aug 2023 00:27:22 -0400
Message-Id: <20230803042732.88515-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Save guest CET supervisor states, i.e.,PL{0,1,2}_SSP, when vCPU
is exiting to userspace or being preempted. Reload the MSRs
before vm-entry.

Embeded the helpers in {vmx,svm}_prepare_switch_to_guest() and
vmx_prepare_switch_to_host()/svm_prepare_host_switch() to employ
existing guest state management and optimize the invocation of
the helpers.

Enabling CET supervisor state management in KVM due to:
 -Introducing unnecessary XSAVE operation when switch to non-vCPU
userspace within current FPU framework.
 -Forcing allocating additional space for CET supervisor states in
each thread context regardless whether it's vCPU thread or not.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.h            | 11 +++++++++++
 arch/x86/kvm/svm/svm.c          |  2 ++
 arch/x86/kvm/vmx/vmx.c          |  2 ++
 arch/x86/kvm/x86.c              | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |  3 +++
 6 files changed, 46 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 20bbcd95511f..69cbc9d9b277 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -805,6 +805,7 @@ struct kvm_vcpu_arch {
 	u64 xcr0;
 	u64 guest_supported_xcr0;
 	u64 guest_supported_xss;
+	u64 cet_s_ssp[3];
 
 	struct kvm_pio_request pio;
 	void *pio_data;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b1658c0de847..b221a663de4c 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -232,4 +232,15 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
 	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
 }
 
+/*
+ * FIXME: When the "KVM-governed" enabling patchset is merge, rebase this
+ * series on top of that and add a new patch for CET to replace this helper
+ * with the qualified one.
+ */
+static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
+					  unsigned int feature)
+{
+	return kvm_cpu_cap_has(feature) && guest_cpuid_has(vcpu, feature);
+}
+
 #endif
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1bc0936bbd51..8652e86fbfb2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1515,11 +1515,13 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (likely(tsc_aux_uret_slot >= 0))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
+	reload_cet_supervisor_ssp(vcpu);
 	svm->guest_state_loaded = true;
 }
 
 static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 {
+	save_cet_supervisor_ssp(vcpu);
 	to_svm(vcpu)->guest_state_loaded = false;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c8d9870cfecb..6aa76124e81e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1323,6 +1323,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	gs_base = segment_base(gs_sel);
 #endif
 
+	reload_cet_supervisor_ssp(vcpu);
 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
 	vmx->guest_state_loaded = true;
 }
@@ -1362,6 +1363,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
+	save_cet_supervisor_ssp(&vmx->vcpu);
 	vmx->guest_state_loaded = false;
 	vmx->guest_uret_msrs_loaded = false;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d68ef87fe007..5b63441fd2d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11128,6 +11128,31 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	trace_kvm_fpu(0);
 }
 
+void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
+		rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
+		rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
+		rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
+		/*
+		 * Omit reset to host PL{1,2}_SSP because Linux will never use
+		 * these MSRs.
+		 */
+		wrmsrl(MSR_IA32_PL0_SSP, 0);
+	}
+}
+EXPORT_SYMBOL_GPL(save_cet_supervisor_ssp);
+
+void reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
+		wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
+		wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
+		wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
+	}
+}
+EXPORT_SYMBOL_GPL(reload_cet_supervisor_ssp);
+
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
@@ -12133,6 +12158,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.cr3 = 0;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+	memset(vcpu->arch.cet_s_ssp, 0, sizeof(vcpu->arch.cet_s_ssp));
 
 	/*
 	 * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
@@ -12313,6 +12339,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		pmu->need_cleanup = true;
 		kvm_make_request(KVM_REQ_PMU, vcpu);
 	}
+
 	static_call(kvm_x86_sched_in)(vcpu, cpu);
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6e6292915f8c..c69fc027f5ec 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -501,6 +501,9 @@ static inline void kvm_machine_check(void)
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
+void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu);
+void reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu);
+
 int kvm_spec_ctrl_test_value(u64 value);
 bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
-- 
2.27.0

