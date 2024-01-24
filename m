Return-Path: <kvm+bounces-6769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEAF839F7E
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:50:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FC42282F25
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92BD227701;
	Wed, 24 Jan 2024 02:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c/xpOLmZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D5B18C1A;
	Wed, 24 Jan 2024 02:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064168; cv=none; b=Unb8MFYz9W7ojyNVNYxNDPfLz88rQU7jZ84hyNNNagh7js7Tl4H9GPRlGd25cTxlse3QCco1s0ygBEAPZnVpweDSYoSagrGYSMlHb+0xUFzEnEPTRBDsZQSdoKwePKl+TRbfPQS8LgAxtcMpd8lYHXEeCfd9JJqBitgwjCfUUAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064168; c=relaxed/simple;
	bh=KjDe60Yb7E8XbbbfTdTf5HJMHBxDk3I1fydRBBz9T98=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tBW2TS9/fgLByaKwOBn3crNBN8KcRjObd7zhFtEezxa5aE4C0GFgpXL8I3JfZZ7D0yxqKTT4hJPO19AlCz8eUIkSHXqFMXrH6aeu96uzmv/9BXp0cE5q+hgJ3XnNLZ7aMoFFx6Xk8+vYozAY+93zdbXbNS4PvPgdDXNDqzwC9kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c/xpOLmZ; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064166; x=1737600166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KjDe60Yb7E8XbbbfTdTf5HJMHBxDk3I1fydRBBz9T98=;
  b=c/xpOLmZXPajLknn+aYPAzTYW1yGBD0mhw6M2YNGMks0WDivgAGQYjJv
   yDLgF8NGVJtRJsgE8RC2UuILpqka3hSCjvdkOIYNhfswJ/nN20jZR1WPL
   E1Ng6B2mc5U2k+iW85SkB5yc+C17RMT1JSJuzepaBqsBqs+W5l7B9BkiK
   f+cD4UX7WOCb+Zf6solvUJ/ZlDhN/PCB+tcj8dgZFZSIRC+mIQ6qnoFT3
   /WT+IeoTaFx0eW2qPV5TZWH/i6/Mje2m8hLJCNIx7CUxHbE7o7OSVCa/o
   /LvaYUB8TvGydwEO/bxr81TurUOLMR1/S1UQOWD1v+2+aH4yprGmjljCq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586550"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586550"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825904"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:41 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 20/27] KVM: VMX: Emulate read and write to CET MSRs
Date: Tue, 23 Jan 2024 18:41:53 -0800
Message-Id: <20240124024200.102792-21-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
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


