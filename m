Return-Path: <kvm+bounces-2414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C35647F6D7B
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:00:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F9F9281D0F
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2830D1862D;
	Fri, 24 Nov 2023 07:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uyime4Gt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889D110F2;
	Thu, 23 Nov 2023 23:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812728; x=1732348728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EIDBnN3Fa/jfofaQS+71ohT8d44MUV2gyhWnvNd70ww=;
  b=Uyime4Gt35a6C0Ng7oXrRq9ns+mW8guoWHyPvCvS8FaY4cWZhv7pIB8i
   NgMRfiY1TImvcx/0aZAiheZnR49oSL7AKBvGQztzklf6XZ7JiyU3McI6Z
   xxY7snhjDcipDCR3XM4NiTtLQvBvm7U4CIS1Nqa+AC+EfPtmwpwaCVyDb
   WyZf28Fhx9vcARmzl8kQSgBpiemUF1035uh16awnoMkEgJEgq2WdvU8a8
   8grRNjbkDgQ16MTbWEuJnzGcBvqJx2wpoth58kAT2V0pYKeEP8yvcpyFE
   gLKrBJ7uHRCTV3XHCJZaWvXdOEllcWRWts+09wQ9EwsT+3dGTHajHeb8o
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872387"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872387"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629853"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629853"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:42 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v7 20/26] KVM: VMX: Emulate read and write to CET MSRs
Date: Fri, 24 Nov 2023 00:53:24 -0500
Message-Id: <20231124055330.138870-21-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add emulation interface for CET MSR access. The emulation code is split
into common part and vendor specific part. The former does common checks
for MSRs, e.g., accessibility, data validity etc., then pass the operation
to either XSAVE-managed MSRs via the helpers or CET VMCS fields.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 +++++++++
 arch/x86/kvm/x86.c     | 88 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f6ad5ba5d518..554f665e59c3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2111,6 +2111,15 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = vmcs_readl(GUEST_S_CET);
+		break;
+	case MSR_KVM_SSP:
+		msr_info->data = vmcs_readl(GUEST_SSP);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
@@ -2420,6 +2429,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_S_CET:
+		vmcs_writel(GUEST_S_CET, data);
+		break;
+	case MSR_KVM_SSP:
+		vmcs_writel(GUEST_SSP, data);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 74d2d00a1681..5792ed16e61b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1847,6 +1847,36 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 }
 EXPORT_SYMBOL_GPL(kvm_msr_allowed);
 
+#define CET_US_RESERVED_BITS		GENMASK(9, 6)
+#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
+#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
+#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
+
+static bool is_set_cet_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u64 data,
+				   bool host_initiated)
+{
+	bool msr_ctrl = index == MSR_IA32_S_CET || index == MSR_IA32_U_CET;
+
+	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
+		return true;
+
+	if (msr_ctrl && guest_can_use(vcpu, X86_FEATURE_IBT))
+		return true;
+
+	/*
+	 * If KVM supports the MSR, i.e. has enumerated the MSR existence to
+	 * userspace, then userspace is allowed to write '0' irrespective of
+	 * whether or not the MSR is exposed to the guest.
+	 */
+	if (!host_initiated || data)
+		return false;
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+		return true;
+
+	return msr_ctrl && kvm_cpu_cap_has(X86_FEATURE_IBT);
+}
+
 /*
  * Write @data into the MSR specified by @index.  Select MSR specific fault
  * checks are bypassed if @host_initiated is %true.
@@ -1906,6 +1936,43 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 
 		data = (u32)data;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
+			return 1;
+		if (data & CET_US_RESERVED_BITS)
+			return 1;
+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+		    (data & CET_US_SHSTK_MASK_BITS))
+			return 1;
+		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
+		    (data & CET_US_IBT_MASK_BITS))
+			return 1;
+		if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
+			return 1;
+		/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDBR. */
+		if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
+			return 1;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated) ||
+		    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
+			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		break;
+	case MSR_KVM_SSP:
+		if (!host_initiated)
+			return 1;
+		fallthrough;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
+			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		if (!IS_ALIGNED(data, 4))
+			return 1;
+		break;
 	}
 
 	msr.data = data;
@@ -1949,6 +2016,19 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) ||
+		    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
+			return 1;
+		break;
+	case MSR_KVM_SSP:
+		if (!host_initiated)
+			return 1;
+		fallthrough;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
+			return 1;
+		break;
 	}
 
 	msr.index = index;
@@ -4118,6 +4198,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.guest_fpu.xfd_err = data;
 		break;
 #endif
+	case MSR_IA32_U_CET:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		kvm_set_xstate_msr(vcpu, msr_info);
+		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
 			return kvm_pmu_set_msr(vcpu, msr_info);
@@ -4475,6 +4559,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
 		break;
 #endif
+	case MSR_IA32_U_CET:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		kvm_get_xstate_msr(vcpu, msr_info);
+		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
 			return kvm_pmu_get_msr(vcpu, msr_info);
-- 
2.27.0


