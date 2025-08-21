Return-Path: <kvm+bounces-55432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 268B7B3096E
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:42:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D46ACB02122
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3AB3126CA;
	Thu, 21 Aug 2025 22:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="RuCPN1OP"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28522EB870;
	Thu, 21 Aug 2025 22:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815883; cv=none; b=aC5BJguo9AGXlnx6FYPgrcZeHzjZ1ELcy3njMjPUrZt5q5NzhkCr8NmI964w7KpkKu87+Hj8l55sKBt98KjQHSUmW35EVT4EFpK8/7P67gXfyU3Pbkgna+0iIs7D3DzOm6mMXLoDuAVfIM/b0bGsqfvCNJhuotMOaSQ6I4gj8Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815883; c=relaxed/simple;
	bh=c0lImDF/iUabNXFFbf2aWrdmGzB7EevFDiw5j493mlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHmXeueb1z7qXQfLJVVjqsv1l1q+EXLTPmXvMTNuyqMpB8MU2xOJjhKdwA2leRs1S7hLrNQPkXkCZORS+61KuXInbGABdALS6+HlQxuS+9dOum1vMKURH27fkJwC8ke8v7wrh5/0AbLfUhmGaB9Ujx/SUhzYLht98acJ+7pzWXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=RuCPN1OP; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOW984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:48 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOW984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815809;
	bh=UHQPNvJ8JeSQvww6GCPhBoSVks1LhBQeDcZfoQRGaLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuCPN1OPxmzJdQ9EHzUKnBlOuP1ORGiVaWq8XGW71ktSwpWK3uIq2mde+dTytRVQf
	 JZsiJB3fFhCiDdbzKmmBhsnrtQemVtGU1ms1MDfIh0txX/ArXpdQeApnXbiSw7obSI
	 J3OY1tvreFAskMtTzaIwmLfaY9nSIT22KqFFSxRdcqki/XVdV6LZ74HEDuXga83TEl
	 IzsIDt72W/oazVf6BXQT5kqYn0or9a09TEzYtAhjRu+c6VljXIdUy1WBBwebQqc09B
	 PgoAjPaHy5mBSaMNk03iu/uPK4VCxZDSDWgvlNByLmKbuaHw/2Co1t5h95FuSL6vM7
	 uU1NugXsn+0kQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 08/20] KVM: VMX: Add support for FRED context save/restore
Date: Thu, 21 Aug 2025 15:36:17 -0700
Message-ID: <20250821223630.984383-9-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821223630.984383-1-xin@zytor.com>
References: <20250821223630.984383-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Handle FRED MSR access requests, allowing FRED context to be set/get
from both host and guest.

During VM save/restore and live migration, FRED context needs to be
saved/restored, which requires FRED MSRs to be accessed from userspace,
e.g., Qemu.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v6:
* Return KVM_MSR_RET_UNSUPPORTED instead of 1 when FRED is not available
  (Chao Gao)
* Handle MSR_IA32_PL0_SSP when FRED is enumerated but CET not.

Change in v5:
* Use the newly added guest MSR read/write helpers (Sean).
* Check the size of fred_msr_vmcs_fields[] using static_assert() (Sean).
* Rewrite setting FRED MSRs to make it much easier to read (Sean).
* Add TB from Xuelian Guo.

Changes since v2:
* Add a helper to convert FRED MSR index to VMCS field encoding to
  make the code more compact (Chao Gao).
* Get rid of the "host_initiated" check because userspace has to set
  CPUID before MSRs (Chao Gao & Sean Christopherson).
* Address a few cleanup comments (Sean Christopherson).

Changes since v1:
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() (Chao Gao).
* Fail host requested FRED MSRs access if KVM cannot virtualize FRED
  (Chao Gao).
* Handle the case FRED MSRs are valid but KVM cannot virtualize FRED
  (Chao Gao).
* Add sanity checks when writing to FRED MSRs.
---
 arch/x86/kvm/vmx/vmx.c | 45 +++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     | 69 ++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 714de55f4e8b..225c4638ffd7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1388,6 +1388,18 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
 	vmx_write_guest_host_msr(vmx, MSR_KERNEL_GS_BASE, data,
 				 &vmx->msr_guest_kernel_gs_base);
 }
+
+static u64 vmx_read_guest_fred_rsp0(struct vcpu_vmx *vmx)
+{
+	return vmx_read_guest_host_msr(vmx, MSR_IA32_FRED_RSP0,
+				       &vmx->msr_guest_fred_rsp0);
+}
+
+static void vmx_write_guest_fred_rsp0(struct vcpu_vmx *vmx, u64 data)
+{
+	vmx_write_guest_host_msr(vmx, MSR_IA32_FRED_RSP0, data,
+				 &vmx->msr_guest_fred_rsp0);
+}
 #endif
 
 static void grow_ple_window(struct kvm_vcpu *vcpu)
@@ -1989,6 +2001,27 @@ int vmx_get_feature_msr(u32 msr, u64 *data)
 	}
 }
 
+#ifdef CONFIG_X86_64
+static const u32 fred_msr_vmcs_fields[] = {
+	GUEST_IA32_FRED_RSP1,
+	GUEST_IA32_FRED_RSP2,
+	GUEST_IA32_FRED_RSP3,
+	GUEST_IA32_FRED_STKLVLS,
+	GUEST_IA32_FRED_SSP1,
+	GUEST_IA32_FRED_SSP2,
+	GUEST_IA32_FRED_SSP3,
+	GUEST_IA32_FRED_CONFIG,
+};
+
+static_assert(MSR_IA32_FRED_CONFIG - MSR_IA32_FRED_RSP1 ==
+	      ARRAY_SIZE(fred_msr_vmcs_fields) - 1);
+
+static u32 fred_msr_to_vmcs(u32 msr)
+{
+	return fred_msr_vmcs_fields[msr - MSR_IA32_FRED_RSP1];
+}
+#endif
+
 /*
  * Reads an msr value (of 'msr_info->index') into 'msr_info->data'.
  * Returns 0 on success, non-0 otherwise.
@@ -2011,6 +2044,12 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KERNEL_GS_BASE:
 		msr_info->data = vmx_read_guest_kernel_gs_base(vmx);
 		break;
+	case MSR_IA32_FRED_RSP0:
+		msr_info->data = vmx_read_guest_fred_rsp0(vmx);
+		break;
+	case MSR_IA32_FRED_RSP1 ... MSR_IA32_FRED_CONFIG:
+		msr_info->data = vmcs_read64(fred_msr_to_vmcs(msr_info->index));
+		break;
 #endif
 	case MSR_EFER:
 		return kvm_get_msr_common(vcpu, msr_info);
@@ -2243,6 +2282,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmx_update_exception_bitmap(vcpu);
 		}
 		break;
+	case MSR_IA32_FRED_RSP0:
+		vmx_write_guest_fred_rsp0(vmx, data);
+		break;
+	case MSR_IA32_FRED_RSP1 ... MSR_IA32_FRED_CONFIG:
+		vmcs_write64(fred_msr_to_vmcs(msr_index), data);
+		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
 		if (is_guest_mode(vcpu))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9930678f5a3b..1f9a09b34742 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -329,6 +329,9 @@ static const u32 msrs_to_save_base[] = {
 	MSR_STAR,
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
+	MSR_IA32_FRED_RSP0, MSR_IA32_FRED_RSP1, MSR_IA32_FRED_RSP2,
+	MSR_IA32_FRED_RSP3, MSR_IA32_FRED_STKLVLS, MSR_IA32_FRED_SSP1,
+	MSR_IA32_FRED_SSP2, MSR_IA32_FRED_SSP3, MSR_IA32_FRED_CONFIG,
 #endif
 	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
 	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
@@ -1910,7 +1913,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		 * architecture. Intercepting XRSTORS/XSAVES for this
 		 * special case isn't deemed worthwhile.
 		 */
-	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+	case MSR_IA32_PL1_SSP ... MSR_IA32_INT_SSP_TAB:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
 			return KVM_MSR_RET_UNSUPPORTED;
 		/*
@@ -1925,6 +1928,48 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
 			return 1;
 		break;
+	case MSR_IA32_FRED_STKLVLS:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
+	case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_CONFIG:
+		u64 reserved_bits = 0;
+
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+
+		if (is_noncanonical_msr_address(data, vcpu))
+			return 1;
+
+		switch (index) {
+		case MSR_IA32_FRED_CONFIG:
+			reserved_bits = BIT_ULL(11) | GENMASK_ULL(5, 4) | BIT_ULL(2);
+			break;
+		case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
+			reserved_bits = GENMASK_ULL(5, 0);
+			break;
+		case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_SSP3:
+			reserved_bits = GENMASK_ULL(2, 0);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			return 1;
+		}
+		if (data & reserved_bits)
+			return 1;
+		break;
+	case MSR_IA32_PL0_SSP: /* I.e., MSR_IA32_FRED_SSP0 */
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+
+		if (is_noncanonical_msr_address(data, vcpu))
+			return 1;
+
+		if (!IS_ALIGNED(data, 4))
+			return 1;
+		break;
 	}
 
 	msr.data = data;
@@ -1979,10 +2024,19 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 		if (!host_initiated)
 			return 1;
 		fallthrough;
-	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+	case MSR_IA32_PL1_SSP ... MSR_IA32_INT_SSP_TAB:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
 			return KVM_MSR_RET_UNSUPPORTED;
 		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
+	case MSR_IA32_PL0_SSP: /* I.e., MSR_IA32_FRED_SSP0 */
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
 	}
 
 	msr.index = index;
@@ -7603,10 +7657,19 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!kvm_cpu_cap_has(X86_FEATURE_LM))
 			return;
 		fallthrough;
-	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+	case MSR_IA32_PL1_SSP ... MSR_IA32_PL3_SSP:
 		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
 			return;
 		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
+			return;
+		break;
+	case MSR_IA32_PL0_SSP: /* I.e., MSR_IA32_FRED_SSP0 */
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+		    !kvm_cpu_cap_has(X86_FEATURE_FRED))
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.50.1


