Return-Path: <kvm+bounces-54487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA0BB21B23
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 05:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1EE568437C
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 03:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7CA2E8DFA;
	Tue, 12 Aug 2025 02:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="maE7j/fy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43862E764B;
	Tue, 12 Aug 2025 02:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967398; cv=none; b=YiPd0BBQMYM6Bg071rW5TLibZnZnct8cXB16np6Q8uE7FSrOFcIarKkppRgqYdwCEwMUsB50YqFtNT2rF/7Y8jj/pPCw3rrlhZaZh1Wv3U+uWx0239CM5+dIb0jYZzAj+U4FqY0UwHM3h2saj46iqvXL9BvxbUbUCICd2PfMwes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967398; c=relaxed/simple;
	bh=pclJ9Rtt4zR94pPpscgVs4cYRU+wMG+LAMS6GmGnH9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAwIsGYJIpnpsWUmWlH+B1gDZLrxnv5v69rPDbFxmfEbzEev23LcaWDyyzlHEpbxIq2C5m4hR36RFeCPr7CROKugq5yNvPdHBjUrx1Fs2uRhX8/JcHl0mU5agtzhxRrwg9eq2jttDztMH2yGOmq0scXPA8NDoKNnIohkDHn/NnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=maE7j/fy; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967396; x=1786503396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pclJ9Rtt4zR94pPpscgVs4cYRU+wMG+LAMS6GmGnH9I=;
  b=maE7j/fyjmJ/2uPhVLNYsA1C7wbrxI3l+bKTIv8ToXv8X4OoMvcGkiWT
   32y18Ql3EnsuOhTr+LHP31Ypv6d13n0qxgbBGYoIrs/Xgcf4KBdwHo54c
   JE1shrmVqLX1sDnog31LY+E8j0TdENZgP6881c/qohxmZMM4oG59j+TiW
   Dbhj8O8yYdxex0V+bf7ZlkoNZ9CJ/B48KAG/tgDsMK0YSu3QvRR3vYBMf
   iHAuiHtdz11v8tUbIFNusY4UtI2QVWiClbMdcPzWrHwUGQps80YRsS232
   kJDIb/VDk0mNEL+RwWWLH3D6Lknol4/tXow5tOc1JfxfHI59smXoxr/wX
   Q==;
X-CSE-ConnectionGUID: B8/FFYlKSfiRQzgQRThfkw==
X-CSE-MsgGUID: wrLTWqGsQJ2rnSgJBM1ptQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100575"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100575"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:34 -0700
X-CSE-ConnectionGUID: X0Rxla+dTqy2YMIQxwBEzQ==
X-CSE-MsgGUID: BbbaVR8eTamPsR51vX4QUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321324"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:34 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Sean Christopherson <seanjc@google.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 15/24] KVM: VMX: Emulate read and write to CET MSRs
Date: Mon, 11 Aug 2025 19:55:23 -0700
Message-ID: <20250812025606.74625-16-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
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
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++++++++++
 arch/x86/kvm/x86.c     | 43 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     | 23 ++++++++++++++++++++++
 3 files changed, 84 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa157fe5b7b3..bd572c8c7bc3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2093,6 +2093,15 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2411,6 +2420,15 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_S_CET:
+		vmcs_writel(GUEST_S_CET, data);
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
index b5c4db4b7e04..cc39ace47262 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1885,6 +1885,27 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 
 		data = (u32)data;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT))
+			return KVM_MSR_RET_UNSUPPORTED;
+		if (!is_cet_msr_valid(vcpu, data))
+			return 1;
+		break;
+	case MSR_KVM_INTERNAL_GUEST_SSP:
+		if (!host_initiated)
+			return 1;
+		fallthrough;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
+			return KVM_MSR_RET_UNSUPPORTED;
+		if (is_noncanonical_msr_address(data, vcpu))
+			return 1;
+		/* All SSP MSRs except MSR_IA32_INT_SSP_TAB must be 4-byte aligned */
+		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
+			return 1;
+		break;
 	}
 
 	msr.data = data;
@@ -1929,6 +1950,20 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
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
@@ -4207,6 +4242,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4556,6 +4595,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index f8fbd33db067..d5b039addd11 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -733,4 +733,27 @@ static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
 	kvm_fpu_put();
 }
 
+#define CET_US_RESERVED_BITS		GENMASK(9, 6)
+#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
+#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
+#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
+
+static inline bool is_cet_msr_valid(struct kvm_vcpu *vcpu, u64 data)
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
2.47.1


