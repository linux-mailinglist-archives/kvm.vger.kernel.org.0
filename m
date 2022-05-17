Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5168E52A72D
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350355AbiEQPmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350486AbiEQPlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8913240E7C;
        Tue, 17 May 2022 08:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802096; x=1684338096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lPvj3AuKPLOBCyfjiHi73B4oqME7322FSr1EsA5Gyy8=;
  b=DSuY6ZQyvCRnB71qfe0TuZS/2Zalm4Hm2HcwRlRk8vfWSXSGaRj4iaJt
   QiH9JHHNBe00AtU0PLATRxVnZKqkBNGYC3kZL3+ChxEvPeYKmqizvXdel
   qD5MDWnVIycDlRcaXXPyXQr+asM22KzcoLti0H4zSW0oF2mEAOtCzYlAv
   4DnPxByO43/n0ruaSGDIjEtUqAPwqDbTzpae18o8jNy0o8TsAX+UHCFFW
   KeaBE/QUMJTiJ3sMPqahg+zcYZjn/pwqBvIC7Q2NiISwxiDOGtKGtEJrg
   SDXRv24JT9kVC+mtdGyAyRM3b2CVFfjVvVZVz6+w+VgJ3ih1eLOy3L9JJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632101"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632101"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533571"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:33 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Like Xu <like.xu@linux.intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 06/16] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for guest Arch LBR
Date:   Tue, 17 May 2022 11:40:50 -0400
Message-Id: <20220517154100.29983-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220517154100.29983-1-weijiang.yang@intel.com>
References: <20220517154100.29983-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The number of Arch LBR entries available is determined by the value
in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
supported. In the first generation of Arch LBR, max entry size is 32,
host configures the max size and guest always honors the setting.

Write to MSR_ARCH_LBR_DEPTH has side-effect, all LBR entries are reset
to 0. Kernel PMU driver can leverage this effect to do fask reset to
LBR record MSRs. KVM allows guest to achieve it when Arch LBR records
MSRs are passed through to the guest.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/vmx/pmu_intel.c    | 48 +++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9cdc5bbd721f..b6735dcf5a6a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -547,6 +547,9 @@ struct kvm_pmu {
 	 * redundant check before cleanup if guest don't use vPMU at all.
 	 */
 	u8 event_count;
+
+	/* Guest arch lbr depth supported by KVM. */
+	u64 kvm_arch_lbr_depth;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 84b326c4dce9..22d6a869ea4d 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -182,6 +182,12 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
 	if (!intel_pmu_lbr_is_enabled(vcpu))
 		return ret;
 
+	if (index == MSR_ARCH_LBR_DEPTH) {
+		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+			ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
+		return ret;
+	}
+
 	ret = (index == MSR_LBR_SELECT) || (index == MSR_LBR_TOS) ||
 		(index >= records->from && index < records->from + records->nr) ||
 		(index >= records->to && index < records->to + records->nr);
@@ -343,10 +349,26 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * Check if the requested depth value the same as that of host.
+ * When guest/host depth are different, the handling would be tricky,
+ * so now only max depth is supported for both host and guest.
+ */
+static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return false;
+
+	return (depth == pmu->kvm_arch_lbr_depth);
+}
+
 static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 
 	switch (msr) {
@@ -371,6 +393,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_PEBS_DATA_CFG:
 		msr_info->data = pmu->pebs_data_cfg;
 		return 0;
+	case MSR_ARCH_LBR_DEPTH:
+		msr_info->data = lbr_desc->records.nr;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -397,6 +422,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 	u64 reserved_bits;
@@ -452,6 +478,16 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_ARCH_LBR_DEPTH:
+		if (!arch_lbr_depth_is_valid(vcpu, data))
+			return 1;
+		lbr_desc->records.nr = data;
+		/*
+		 * Writing depth MSR from guest could either setting the
+		 * MSR or resetting the LBR records with the side-effect.
+		 */
+		wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -615,6 +651,18 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL;
 		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
 	}
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+		return;
+
+	entry = kvm_find_cpuid_entry(vcpu, 28, 0);
+	if (entry) {
+		/*
+		 * The depth mask in CPUID is fixed to host supported
+		 * value when userspace sets guest CPUID.
+		 */
+		pmu->kvm_arch_lbr_depth = fls(entry->eax & 0xff) * 8;
+	}
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.27.0

