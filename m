Return-Path: <kvm+bounces-5005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F3381B1EC
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B5AF1F21C49
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC3AD58AB6;
	Thu, 21 Dec 2023 09:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HEUjBg/d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F49057308;
	Thu, 21 Dec 2023 09:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149435; x=1734685435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KjDe60Yb7E8XbbbfTdTf5HJMHBxDk3I1fydRBBz9T98=;
  b=HEUjBg/diXbRy0yIOLMjfBat8EVZ3R8tIY/mjO7gnc1y/vHBDovqlAid
   WnjTeodNXpUZ1GCr+q+XjzKjsbAc3LS2dw2tI9PyaQgBNJ8l/Hmr1O/TT
   RFvY2jBH2MaRXwAYqTMsKR6WRBp/J/5WffctgmVdHx0HtOvy2AE3gm/3C
   OxwzZYQ/ywndAB9ToaObote5fvjBouV5WQJUYZrST3TvTGXxfKBsiiBuw
   3PEasWNAz9ftM+7See9PCt1Ki/H53FI9BekhGPOCcfOe0yEaOIEpS3cio
   7+Px4e5oj5vs8zAeqzD+c0wY4qs6iufAwWG3j0MHJLvpmYA+SHY3g4DWK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729709"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729709"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028627"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028627"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:11 -0800
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
Subject: [PATCH v8 20/26] KVM: VMX: Emulate read and write to CET MSRs
Date: Thu, 21 Dec 2023 09:02:33 -0500
Message-Id: <20231221140239.4349-21-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
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
index 29a0fd3e83c5..064a5fe87948 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2106,6 +2106,15 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2415,6 +2424,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index a7368adad6b8..cf0f9e4474a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1850,6 +1850,36 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
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
@@ -1909,6 +1939,43 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 
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
@@ -1952,6 +2019,19 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
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
@@ -4143,6 +4223,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4502,6 +4586,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.39.3


