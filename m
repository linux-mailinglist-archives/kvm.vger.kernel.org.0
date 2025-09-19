Return-Path: <kvm+bounces-58242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C43B8B7E7
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECE3B161807
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1522EA72B;
	Fri, 19 Sep 2025 22:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sFRGttzd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588F32EA154
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321214; cv=none; b=Spxci+x2jcuxifnNCBxxAafc6Yl624L1n4+T+Xgy+jeuzVyWSlA6T8yEb1o+94tuqz1wgbGx1jF66Zaa2dyq7huEBLH7lRNKTFe2obSlldG7c+ZfZmwHKblqKvfM/PMeQb+FSShvphh3eyi808eDQqRIs5Fr4pbC2YPF0TFMk+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321214; c=relaxed/simple;
	bh=1H4JKoxS3V8wps7O900Yb2ln5StPCFFY4VKmmk1NeVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lfuprEZMO47MqNgTwCleVuNkd+USYCc5d/OoYhLeG+OGxmgk28SYNrITQIITSh0xTn7pYK/bjRzFF+qTLNDc93sUo3+w0v+FVGgvOdtkF7pn+ZkN8lsPjInnH7ZDWQNZEDEI+A3d+JwppltbPR5357k5UStZ5iScVLpIKu5TJns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sFRGttzd; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77241858ec1so2531539b3a.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321212; x=1758926012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EHSMB3YudiESW4kjmExRtv85WymVJpL9tXhY6ETxnPM=;
        b=sFRGttzdxLr1l3MDy/+GCZZ6VEwxGfjB/TwUT0N/bmpTwFx0zLYQEGHHTb0pAXA6ig
         aldbouNDxfVhYFvsbp31Y0oQ1BNwhptLVm7e/X2XDyG9XStlxOwbO6UvoTzf9IeWjHHm
         1SveBWxuJWjOMIY52mScuTMuXF7N8j5IDspyCsWsjI+FahVD91Jr2IvtQMunftBL+IL0
         efz4SOUQMtQoZQPwHKx4Xvxu0jiXQ/LKL5ZyyieChoC0e9Bd0FwcxG/R39nBF0qrHZc/
         VEbWnGSWYXcd/O+OEHt0irVdh6FDQ/QGYcoicVYSm3XG4LU49SDiUpVerJWG1bYhrUZC
         XrEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321212; x=1758926012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EHSMB3YudiESW4kjmExRtv85WymVJpL9tXhY6ETxnPM=;
        b=A+VCyxqgeLtUqgPPZIWlRNOS3UaToVNByNXR12WFmndSjqBmvp42bAILF4TEqaazw7
         hk7yQKY4bx6uLvzIbJ7PFDKzRPiHH2CGPq+zbwZu3BPT3VomDTlWAi+vpFBD250sN7s1
         LTkaxT1V4kxyIxoO9RRBiZdM2KvuL570zwivFttJTO67uuWRYekbGRcNIjP/QPuX0Edz
         lpAMXBVL0sRTVAQyE5+z+upbmooTpz3IvIuZKbhnep3HbL17Ji8k9xw1Ma3MXEIa/JqG
         FMBG8mJ8Hv5MCBZ9AC6WDqa35qlP0CmpG0RuU9u/fWw0H7Ycyi5QR0QfKtARKD3ei8OK
         z27Q==
X-Gm-Message-State: AOJu0Yx26llSEErcwmog+pdLpoB8qNNLDAOq2ZRXgWFtununSQgrc0lZ
	s9jxYYYIEIFloKiWS1QHtB2cQflCAsrdi4r1s3cCF1DxlzRcbaiTSy57ZwnLztmtFxJ7ghlmsH+
	5a+TDEg==
X-Google-Smtp-Source: AGHT+IHQqwZx/+upFtcTEoGCJl+OSJOyg9gTYspoU2hAtFEPWklOA4VCzj28Hht77v8pXm74VpXb8kXxnTw=
X-Received: from pfjc16.prod.google.com ([2002:a05:6a00:90:b0:771:ec64:cef2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a8f:b0:772:3b9d:70fb
 with SMTP id d2e1a72fcca58-77e4f9b4dcdmr6360968b3a.31.1758321208316; Fri, 19
 Sep 2025 15:33:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:21 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-15-seanjc@google.com>
Subject: [PATCH v16 14/51] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

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
[sean: drop call to kvm_set_xstate_msr() for S_CET, consolidate code]
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++++
 arch/x86/kvm/x86.c     | 64 ++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.h     | 23 +++++++++++++++
 3 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 35037fc326e5..e271e3785561 100644
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
@@ -2424,6 +2433,15 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
 		if (data & PERF_CAP_LBR_FMT) {
 			if ((data & PERF_CAP_LBR_FMT) !=
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 720540f102e1..fee90388a861 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1890,6 +1890,44 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 
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
@@ -1934,6 +1972,20 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
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
@@ -3865,12 +3917,12 @@ static __always_inline void kvm_access_xstate_msr(struct kvm_vcpu *vcpu,
 	kvm_fpu_put();
 }
 
-static __maybe_unused void kvm_set_xstate_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+static void kvm_set_xstate_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	kvm_access_xstate_msr(vcpu, msr_info, MSR_TYPE_W);
 }
 
-static __maybe_unused void kvm_get_xstate_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+static void kvm_get_xstate_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	kvm_access_xstate_msr(vcpu, msr_info, MSR_TYPE_R);
 }
@@ -4256,6 +4308,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4605,6 +4661,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index a7c9c72fca93..076eccba0f7e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -710,4 +710,27 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
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
2.51.0.470.ga7dc726c21-goog


