Return-Path: <kvm+bounces-9033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A625F859D9B
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 08:56:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A6CD1F215FF
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 07:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79223F9D1;
	Mon, 19 Feb 2024 07:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l9dmXkCC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC85374F2;
	Mon, 19 Feb 2024 07:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708328877; cv=none; b=r3g9Hw1FxkA7xc3OaiouWk49x1YiNXa7469zh6Knzt85UJ9IxsT1fHNEAEoJrcAMoDejNUtwvp92Dh70GegzqZzMFwl1xJfViqmASxMXgo/TQEzGPXawxgI5q7KahhDCq3QQ4bEDw9bouKGc/FIVuEU0yGxcC4GCwD0ra9dHnBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708328877; c=relaxed/simple;
	bh=BTAmCrJM+TMcHQ8B+9ubqY9NJwhtodRsnqEaKj9jxbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbklRxyrOaOsbSL9dNUj+yOgsWShfebGy4M9x6aOru2iLYSeSYcnGorj51FS0XhrpvLygJoNKUTPbLfXXG71lCUR6/CE29BZBekauqwtiYCuMJ/DcJTBFw96Hgc/I8SkDvPbHxgElYd8S9kEKKX6Bo1zHoZOVOjFFA7OFImopDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l9dmXkCC; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708328875; x=1739864875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BTAmCrJM+TMcHQ8B+9ubqY9NJwhtodRsnqEaKj9jxbQ=;
  b=l9dmXkCC1AkFPVYNybVIzkDHkNBlWE8buOUZKbLoKBgFvYUohz7mAGJF
   SdfK+5vOWwru2GtsYUAGhzodYzDbWq+gMv8gi1ZHtETzforkpwNkrYQds
   Zsnb+wxKbj2oeAIognWTF+pqf9vGuQUQ+4KApKn9fsYu6SbE36uyjezAX
   qHAEwynqB7mStFZAsUfA04SO3Wg2gNitBSI/DPmGOX3OGM6aN69lJ1KQc
   DM7CWlM90sWV7xxgS5twW+On4p8vu9C8McuzDQtG2FODe4yIjhbrOdTl7
   SllVNNwoIJDRfTjaM1z3PIIT30CkJDdUuTA2YjG/+fxplP5NhDsXPdNJC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="2535142"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="2535142"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10988"; a="826966118"
X-IronPort-AV: E=Sophos;i="6.06,170,1705392000"; 
   d="scan'208";a="826966118"
Received: from jf.jf.intel.com (HELO jf.intel.com) ([10.165.9.183])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2024 23:47:44 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v10 20/27] KVM: VMX: Emulate read and write to CET MSRs
Date: Sun, 18 Feb 2024 23:47:26 -0800
Message-ID: <20240219074733.122080-21-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add emulation interface for CET MSR access. The emulation code is split
into common part and vendor specific part. The former does common checks
for MSRs, e.g., accessibility, data validity etc., then passes operation
to either XSAVE-managed MSRs via the helpers or CET VMCS fields.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 +++++++++
 arch/x86/kvm/x86.c     | 88 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6cb94754c2a9..ff2296fa7d39 100644
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
index c0ed69353674..281c3fe728c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1849,6 +1849,36 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
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
@@ -1908,6 +1938,42 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 
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
+		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
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
@@ -1951,6 +2017,20 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_can_use(vcpu, X86_FEATURE_IBT))
+			return 1;
+		break;
+	case MSR_KVM_SSP:
+		if (!host_initiated)
+			return 1;
+		fallthrough;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
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
2.43.0


