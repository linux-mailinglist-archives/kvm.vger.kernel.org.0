Return-Path: <kvm+bounces-57457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27067B55A16
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5D6CAE0FA8
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C182D7DCE;
	Fri, 12 Sep 2025 23:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NjE7J40C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4263D2D5959
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719431; cv=none; b=aoMv52IC8TMSbn3GlK3BbbuUdBTSIl26m82PQM7A+ytJH9DKRfABYkBmxa8l58qA1GQr7aiMHZohm2DdnUE1qvJgl1jHAtAOKqJxXCz8i4G+O9+zX/oiKvOTQr/mrq2TiOMStRPE27dz5gpZQjdR34/i15CLlSrw15py3BipozI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719431; c=relaxed/simple;
	bh=vQDdu1zHF4bPFrrDNQxsUDgUl3nDRRZ82FO95++Z81I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ThWHIildMaAXgMHaHiw2dnAoyeErkfOZDRWWRQr6ROBoQqT/Irt+/+fnMzDD6XxaltCGfajk/n13pqDv3Tr1fnV89veC+ZTKDLSUaTP//Lw4SACdgjX8KPj/YVM5mGiDSoTlLZehkW6EpVbaEBQHCmpVYVeosDUfrv8vNMxv1KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NjE7J40C; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32b57b0aa25so2525341a91.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719430; x=1758324230; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tsK8S7ainZOuiq7DM/VWeS+FQWWRgudnHijGojTqtSE=;
        b=NjE7J40CbkboexwUpkOVNsySS7jfEvBIcJ9SLkjIMvRAyC1C/QNC93TzI9QxHjMA4u
         3r9GAMr7W+8SKm37PxZo+XfzmkekQn4+LlN5MfELwrS56UGuaJBmyuaViIENEziLtIup
         L+YdMJN2vDfJFHugcxNqr+I5rhwYnvp2M8anMknkJPsAbTLF2UJ1l1cNec1v8tVs/I2+
         ed26fka81WYQQlRWSDWxThbZIWIAmwSQjtystieDgNdnzYnu5pcXaAdxd1oGg0PwyjeP
         DQRBvTTKVINWcRPhf4X+la3NV4hzlkMC0N3Z8HhWqw59syAY2dktdN1pQ+P4ZaH5w4J4
         3bdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719430; x=1758324230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tsK8S7ainZOuiq7DM/VWeS+FQWWRgudnHijGojTqtSE=;
        b=qt3Nmp+7an5GeDDstjjWFmzUSFaAzpEXWoJxy2G/uDqsGlSH0gGXAGvym+40gnWMId
         z7X7REiWZZFb2Pu0jrcbVURi1DhrA8UMz1tKTqt7OQddJeV/EaLnQw9LOeR59v9lYbIU
         UDX8nv2IeEBfTmUpQv9vG+LFzXg9fwRz+QlIphOYWF4oVDp/ZjCOFeJ9psn1VPwUZvIC
         S2PHG/PdgEezhWXv7FlVmKRgD0jpSinQtDGeYBOWcye25pzgCTXy0LsaOJyq0zHKuZi3
         l8gojGqHHlC1O8KkpodIrEIkp3qtQKdm7/E3XvYB1DIumG5C1HKQTXazomxrc1ylE1vr
         vnEw==
X-Gm-Message-State: AOJu0YwZsCY9wNyvwMxZfGd+7S0Wyp9xYnPFXqz6rH/LhELv1xMoNavi
	WhZXvzfpzGxOSfFX7eWv/hw4uH0mCTRZS1exhU633cHMt+k4xHqfuFOGdKGq1k0NApRgRdJ89qG
	OB5hY6A==
X-Google-Smtp-Source: AGHT+IFvmwPke7/pDRYXxhNym9lrKDGTafHhCXPfQmEL//L2GNevsjrfbq484QdlEwKFAEmqSAGwTvkqMxo=
X-Received: from pjj16.prod.google.com ([2002:a17:90b:5550:b0:328:887d:69f0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd1:b0:32d:dadf:b6ac
 with SMTP id 98e67ed59e1d1-32de4fb1099mr5747605a91.33.1757719429747; Fri, 12
 Sep 2025 16:23:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:52 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-15-seanjc@google.com>
Subject: [PATCH v15 14/41] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++++
 arch/x86/kvm/x86.c     | 64 ++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/x86.h     | 23 +++++++++++++++
 3 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 227b45430ad8..4fc1dbba2eb0 100644
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
 		if (data & PMU_CAP_LBR_FMT) {
 			if ((data & PMU_CAP_LBR_FMT) !=
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 460ceae11495..0b67b1b0e361 100644
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
@@ -3864,12 +3916,12 @@ static __always_inline void kvm_access_xstate_msr(struct kvm_vcpu *vcpu,
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
@@ -4255,6 +4307,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4604,6 +4660,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.51.0.384.g4c02a37b29-goog


