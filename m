Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE1F75BE65
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 08:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjGUGJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 02:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjGUGI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 02:08:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AA9171D;
        Thu, 20 Jul 2023 23:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689919736; x=1721455736;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Vcu3lfidbXVWuWh0tAa22jzUlvj8smQsLz77KEzUs0=;
  b=PdSmu6ahSDJKCcHd6pkyMngHUfSclIPa5OqbWleMizVcQlGyzvshD60H
   GL+W5cWD08ciJc0v+KQdrDYRBO1rnGuV3rWTxoQ///bdp/M4KqBEXJMBH
   A8aw/94eWnT/+u+Aonu/K+LXuUYsXtj2vplJMQpbgbaAEDm9i4KAFhEOa
   kjaArlGE0IvOhwkpnso0qu6OBMFN7D5oksNhuiKyF7zxT+kyvZwaX3gVF
   wSdMCoax0CsDRTmsuPM2i/Hp+8EHYDJljJUtVCT1ZkX4uv1qfBehfaSIc
   xvNlV6FE3dDBTCjax43uNQUh+mYyawqDcPxXcCmBC71C9ytzmfE3PACIR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370547567"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370547567"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="848721968"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="848721968"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 23:08:41 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v4 09/20] KVM:x86: Add common code of CET MSR access
Date:   Thu, 20 Jul 2023 23:03:41 -0400
Message-Id: <20230721030352.72414-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230721030352.72414-1-weijiang.yang@intel.com>
References: <20230721030352.72414-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add unified handling for AMD/Intel's SHSTK MSRs, and leave IBT
related handling in VMX specific code.

Guest supervisor SSPs are handled specially because they are
loaded into HW registers only when the SSPs are used by guest.

Currently, AMD doesn't support IBT, so move related handling in
VMX specific code.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/cpuid.h            |  10 ++++
 arch/x86/kvm/x86.c              | 103 +++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.h              |  18 ++++++
 4 files changed, 124 insertions(+), 8 deletions(-)

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
index b1658c0de847..7791a19b88ba 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -232,4 +232,14 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
 	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
 }
 
+/*
+ * FIXME: When the "KVM-governed" enabling patchset is merge, rebase this
+ * series on top of that and replace this one with the helper merged.
+ */
+static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
+					  unsigned int feature)
+{
+	return kvm_cpu_cap_has(feature) && guest_cpuid_has(vcpu, feature);
+}
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59e961a88b75..7a3753c05c09 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3628,6 +3628,47 @@ static bool kvm_is_msr_to_save(u32 msr_index)
 	return false;
 }
 
+static inline bool is_shadow_stack_msr(struct kvm_vcpu *vcpu,
+				       struct msr_data *msr)
+{
+	return msr->index == MSR_IA32_PL0_SSP ||
+		msr->index == MSR_IA32_PL1_SSP ||
+		msr->index == MSR_IA32_PL2_SSP ||
+		msr->index == MSR_IA32_PL3_SSP ||
+		msr->index == MSR_IA32_INT_SSP_TAB ||
+		msr->index == MSR_KVM_GUEST_SSP;
+}
+
+static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr)
+{
+
+	/*
+	 * This function cannot work without later CET MSR read/write
+	 * emulation patch.
+	 */
+	WARN_ON_ONCE(1);
+
+	if (is_shadow_stack_msr(vcpu, msr)) {
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+			return false;
+
+		if (msr->index == MSR_KVM_GUEST_SSP)
+			return msr->host_initiated;
+
+		return msr->host_initiated ||
+			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+	}
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		return false;
+
+	return msr->host_initiated ||
+		guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+}
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	u32 msr = msr_info->index;
@@ -3982,6 +4023,35 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.guest_fpu.xfd_err = data;
 		break;
 #endif
+#define CET_IBT_MASK_BITS	GENMASK_ULL(63, 2)
+#define CET_SHSTK_MASK_BITS	GENMASK(1, 0)
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		if ((!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+		     (data & CET_SHSTK_MASK_BITS)) ||
+		    (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
+		     (data & CET_IBT_MASK_BITS)))
+			return 1;
+		if (msr == MSR_IA32_U_CET)
+			kvm_set_xsave_msr(msr_info);
+		break;
+	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		if (!IS_ALIGNED(data, 4))
+			return 1;
+		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
+		    msr == MSR_IA32_PL2_SSP) {
+			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
+		} else if (msr == MSR_IA32_PL3_SSP) {
+			kvm_set_xsave_msr(msr_info);
+		}
+		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -4052,7 +4122,9 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
-	switch (msr_info->index) {
+	u32 msr = msr_info->index;
+
+	switch (msr) {
 	case MSR_IA32_PLATFORM_ID:
 	case MSR_IA32_EBL_CR_POWERON:
 	case MSR_IA32_LASTBRANCHFROMIP:
@@ -4087,7 +4159,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
 	case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 		msr_info->data = 0;
 		break;
@@ -4138,7 +4210,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_MTRRcap:
 	case MTRRphysBase_MSR(0) ... MSR_MTRRfix4K_F8000:
 	case MSR_MTRRdefType:
-		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
+		return kvm_mtrr_get_msr(vcpu, msr, &msr_info->data);
 	case 0xcd: /* fsb frequency */
 		msr_info->data = 3;
 		break;
@@ -4160,7 +4232,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = kvm_get_apic_base(vcpu);
 		break;
 	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
-		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
+		return kvm_x2apic_msr_read(vcpu, msr, &msr_info->data);
 	case MSR_IA32_TSC_DEADLINE:
 		msr_info->data = kvm_get_lapic_tscdeadline_msr(vcpu);
 		break;
@@ -4254,7 +4326,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
 	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
-		return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
+		return get_msr_mce(vcpu, msr, &msr_info->data,
 				   msr_info->host_initiated);
 	case MSR_IA32_XSS:
 		if (!msr_info->host_initiated &&
@@ -4285,7 +4357,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case HV_X64_MSR_TSC_EMULATION_STATUS:
 	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
 		return kvm_hv_get_msr_common(vcpu,
-					     msr_info->index, &msr_info->data,
+					     msr, &msr_info->data,
 					     msr_info->host_initiated);
 	case MSR_IA32_BBL_CR_CTL3:
 		/* This legacy MSR exists but isn't fully documented in current
@@ -4338,8 +4410,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
 		break;
 #endif
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
+			return 1;
+		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
+		    msr == MSR_IA32_PL2_SSP) {
+			msr_info->data =
+				vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
+		} else if (msr == MSR_IA32_U_CET || msr == MSR_IA32_PL3_SSP) {
+			kvm_get_xsave_msr(msr_info);
+		}
+		break;
 	default:
-		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
+		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_get_msr(vcpu, msr_info);
 
 		/*
@@ -4347,7 +4433,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * to-be-saved, even if an MSR isn't fully supported.
 		 */
 		if (msr_info->host_initiated &&
-		    kvm_is_msr_to_save(msr_info->index)) {
+		    kvm_is_msr_to_save(msr)) {
 			msr_info->data = 0;
 			break;
 		}
@@ -12131,6 +12217,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.cr3 = 0;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+	memset(vcpu->arch.cet_s_ssp, 0, sizeof(vcpu->arch.cet_s_ssp));
 
 	/*
 	 * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6e6292915f8c..09dd35a79ff3 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -549,4 +549,22 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+/*
+ * Guest xstate MSRs have been loaded in __msr_io(), disable preemption before
+ * access the MSRs to avoid MSR content corruption.
+ */
+static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
+{
+	kvm_fpu_get();
+	rdmsrl(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_set_xsave_msr(struct msr_data *msr_info)
+{
+	kvm_fpu_get();
+	wrmsrl(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
 #endif
-- 
2.27.0

