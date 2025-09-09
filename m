Return-Path: <kvm+bounces-57075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E63B4A870
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:43:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D78C1608A7
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05543093A7;
	Tue,  9 Sep 2025 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aY8PGE4v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFDAA2C21D5;
	Tue,  9 Sep 2025 09:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410804; cv=none; b=e+JAlQjsiGDfj3d5ANzBTSPnc/Ny26sl0P80AJZ5gk+KIuyjFBW0YpTM5jw/YAHP0awxRXzOQq+4DTuBebwX350XrT4L842pANAe625/it7IX9v9k6fU3qWRCtFNJEjVp7C07KObfQhkBmWNPdj5ihGmPuKWOj6gD2X7GxNhEQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410804; c=relaxed/simple;
	bh=+HbYP4q471SAqwfdc0ak8mqKLtcYzSvenaKEK8HA3fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uV3/VgufbLWi0Whpd03EGho7y9DelXUQQecNjGBz4eL4o/6yzSfdgmeJTCsYCMCqW+W8iijYUBVeuzDjSwIzS6yzbnL0UEXf7+udlf5442BJsEukig3g2jcY/9yzmQ7Re3Oj9k0D8p4kY2ByOEfQgF2QUCPwJaOfDByX1JN9cS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aY8PGE4v; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410803; x=1788946803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+HbYP4q471SAqwfdc0ak8mqKLtcYzSvenaKEK8HA3fo=;
  b=aY8PGE4v52abgKqB852V4oyMGP/gM2bb6NlzmZPvzAsOO7RscZ0AJBET
   QqPtTpPIp9ohb3gh7Vppf857IacTf22ozIhfnBE2vCRFstMvzi3ExFUDv
   Ik8aXRE0CgpFgpDXFlAXhzR3lIvEi1YL2ry2ox8wq8R/Yg9G+5jYAt6Rb
   1/oQuqnC2LSiHDfBeqNZ9EoFVdrxy8raowXIxkCYcRQn7T9o1oz5yAcs3
   3WerWPLB6++mu6MaARFDoNE+T6bzcALHoc7x7zwXmyuMwwAYP35ijIpc2
   MO3Svtjxul80tOyFq1/WIHQ7TxsHZSzjvRJS8d/3HW1MGHbWjiLnxIvEi
   Q==;
X-CSE-ConnectionGUID: gW48EN3gT/KXEjGxJGEDkg==
X-CSE-MsgGUID: F1TNbCh1TQGp+3u3Qd28jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307264"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307264"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:56 -0700
X-CSE-ConnectionGUID: Caez4MCQQxqKhU0gm0gjyQ==
X-CSE-MsgGUID: VgHes3RATqW72aEe2EybXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207418"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:56 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 11/22] KVM: VMX: Emulate read and write to CET MSRs
Date: Tue,  9 Sep 2025 02:39:42 -0700
Message-ID: <20250909093953.202028-12-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Add emulation interface for CET MSR access. The emulation code is split
into common part and vendor specific part. The former does common checks
for MSRs, e.g., accessibility, data validity etc., then passes operation
to either XSAVE-managed MSRs via the helpers or CET VMCS fields.

SSP can only be read via RDSSP. Writing even requires destructive and
potentially faulting operations such as SAVEPREVSSP/RSTORSSP or
SETSSBSY/CLRSSBSY. Let the host use a pseudo-MSR that is just a wrapper
for the GUEST_SSP field of the VMCS.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v14:
- Update both hardware MSR value and VMCS field when userspace writes to
  MSR_IA32_S_CET. This keeps guest FPU and VMCS always inconsistent
  regarding MSR_IA32_S_CET.
---
 arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++
 arch/x86/kvm/x86.c     | 60 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     | 23 ++++++++++++++++
 3 files changed, 102 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 227b45430ad8..22bd71bebfad 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2106,6 +2106,15 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_S_CET:
+		msr_info->data = vmcs_readl(GUEST_S_CET);
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		msr_info->data = vmcs_readl(GUEST_SSP);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmx_guest_debugctl_read();
 		break;
@@ -2424,6 +2433,16 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_S_CET:
+		vmcs_writel(GUEST_S_CET, data);
+		kvm_set_xstate_msr(vcpu, msr_info);
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		vmcs_writel(GUEST_SSP, data);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data & PMU_CAP_LBR_FMT) {
 			if ((data & PMU_CAP_LBR_FMT) !=
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6036eab3852..79861b7ad44d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1886,6 +1886,44 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 
 		data = (u32)data;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT))
+			return KVM_MSR_RET_UNSUPPORTED;
+		if (!kvm_is_valid_u_s_cet(vcpu, data))
+			return 1;
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		if (!host_initiated)
+			return 1;
+		fallthrough;
+		/*
+		 * Note that the MSR emulation here is flawed when a vCPU
+		 * doesn't support the Intel 64 architecture. The expected
+		 * architectural behavior in this case is that the upper 32
+		 * bits do not exist and should always read '0'. However,
+		 * because the actual hardware on which the virtual CPU is
+		 * running does support Intel 64, XRSTORS/XSAVES in the
+		 * guest could observe behavior that violates the
+		 * architecture. Intercepting XRSTORS/XSAVES for this
+		 * special case isn't deemed worthwhile.
+		 */
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+			return KVM_MSR_RET_UNSUPPORTED;
+		/*
+		 * MSR_IA32_INT_SSP_TAB is not present on processors that do
+		 * not support Intel 64 architecture.
+		 */
+		if (index == MSR_IA32_INT_SSP_TAB && !guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
+			return KVM_MSR_RET_UNSUPPORTED;
+		if (is_noncanonical_msr_address(data, vcpu))
+			return 1;
+		/* All SSP MSRs except MSR_IA32_INT_SSP_TAB must be 4-byte aligned */
+		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
+			return 1;
+		break;
 	}
 
 	msr.data = data;
@@ -1930,6 +1968,20 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		if (!host_initiated)
+			return 1;
+		fallthrough;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
 	}
 
 	msr.index = index;
@@ -4220,6 +4272,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4569,6 +4625,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index cf4f73a95825..95d2a82a4674 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -735,4 +735,27 @@ static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
 	kvm_fpu_put();
 }
 
+#define CET_US_RESERVED_BITS		GENMASK(9, 6)
+#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
+#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
+#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
+
+static inline bool kvm_is_valid_u_s_cet(struct kvm_vcpu *vcpu, u64 data)
+{
+	if (data & CET_US_RESERVED_BITS)
+		return false;
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    (data & CET_US_SHSTK_MASK_BITS))
+		return false;
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
+	    (data & CET_US_IBT_MASK_BITS))
+		return false;
+	if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
+		return false;
+	/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDBR. */
+	if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
+		return false;
+
+	return true;
+}
 #endif
-- 
2.47.3


