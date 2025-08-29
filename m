Return-Path: <kvm+bounces-56336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E860B3BF5E
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 17:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67F3A200D42
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 15:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD857335BA3;
	Fri, 29 Aug 2025 15:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="iCEMVUl1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8C62222B6;
	Fri, 29 Aug 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481591; cv=none; b=us9k2y2Ma9aGCeWTn4FObgKs6Z8sbBG56q1quIOtsTTqsXvvo2RfhZivresfuFZufA3O8cd3O+4GEH+qr0IRCyvMjH6JeVUTzGTkWWck5OLbSfpoNgUMHa5n+KLQGCudAG5J8zeY3mG03SpQYvYf6EL9kmnXQU+XGF2KobG73qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481591; c=relaxed/simple;
	bh=IZAcf1aegp8pBPTiC7aXNvJ/BlAxYHGr/n/69Rd7MOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V04rsKy+JYUl/Fi5wVFKSOtyy32/D/WPbhROE8MM2MTx5xA1quAJ8i3YwjKBWK/JLURrJu8LTZDHiUPd0x6kyhpnYuGyqKNmUEEzbief6urZ6GE3cFvoBWcjzyopLnPyMt+m3htOOw4gd6dc2mr6UC6cs4XBRkDhHXasHlowymk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=iCEMVUl1; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57TFVo4F2871953
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 08:32:20 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57TFVo4F2871953
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756481541;
	bh=kMHxdPrkyi+mof/Hq/9CeRaL5H712EGkw71jXlrR6gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCEMVUl1TOAq+0goTRaxXw2JO73B/zQGROzwnk0h+Pa/I0f1v0vz89g3PXu16T+lt
	 6dIC50NCZzpVZtDlK+JMaA9RYMaPGXABNicmvdzobpDTE2zyy1eBZRPQK/gGCN1N/X
	 /qo6Y1bFhxUs++9UntgxlGf3zOdPw4HYq3IL63wDpnyAS7vMIxpRlI06r9zVa2b1jm
	 ZhqIB5SsTXEaDSboZkMewO0NAqBMk6F6RyK17JJx1UegdT+2y/tdWDfNu+wWSmeqjM
	 Gjtes7yaYc/1Z9gmsZvnkLjlni2ylFmb5FWgH4RSMiEMieXHcTurXgbftk6VM+hQNh
	 BBLX/zpNzRPAA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v7 09/21] KVM: VMX: Add support for saving and restoring FRED MSRs
Date: Fri, 29 Aug 2025 08:31:37 -0700
Message-ID: <20250829153149.2871901-10-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829153149.2871901-1-xin@zytor.com>
References: <20250829153149.2871901-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Introduce support for handling FRED MSR access requests, enabling both
host and guest to read and write FRED MSRs, which is essential for VM
save/restore and live migration, and allows userspace tools such as QEMU
to access the relevant MSRs.

Specially, intercept accesses to the FRED SSP0 MSR (IA32_PL0_SSP), which
remains accessible when FRED is enumerated even if CET is not.  This
ensures the guest value is fully virtual and does not alter the hardware
FRED SSP0 MSR.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v7:
* Intercept accesses to FRED SSP0, i.e., IA32_PL0_SSP, which remains
  accessible when FRED but !CET (Sean).

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
 arch/x86/include/asm/kvm_host.h |   5 ++
 arch/x86/kvm/vmx/vmx.c          |  45 ++++++++++++++
 arch/x86/kvm/x86.c              | 102 ++++++++++++++++++++++++++++++--
 3 files changed, 148 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 061c0cd73d39..bec644eec92f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1091,6 +1091,11 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+	/*
+	 * Stores the FRED SSP0 MSR when CET is not supported, prompting KVM
+	 * to intercept its accesses.
+	 */
+	u64 fred_ssp0_fallback;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5f639fb3b44d..358410220cc2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1387,6 +1387,18 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
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
@@ -1988,6 +2000,27 @@ int vmx_get_feature_msr(u32 msr, u64 *data)
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
@@ -2010,6 +2043,12 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2242,6 +2281,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index 9930678f5a3b..c53fc235b8bd 100644
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
@@ -1925,6 +1928,52 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
 			return 1;
 		break;
+	case MSR_IA32_FRED_STKLVLS:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+			return KVM_MSR_RET_UNSUPPORTED;
+		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_RSP3:
+	case MSR_IA32_FRED_SSP1 ... MSR_IA32_FRED_CONFIG: {
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
+
+		if (data & reserved_bits)
+			return 1;
+
+		break;
+	}
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
+
+		break;
 	}
 
 	msr.data = data;
@@ -1979,10 +2028,19 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
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
@@ -4275,6 +4333,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #endif
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+			WARN_ON_ONCE(msr != MSR_IA32_FRED_SSP0);
+			vcpu->arch.fred_ssp0_fallback = data;
+			break;
+		}
+
 		kvm_set_xstate_msr(vcpu, msr_info);
 		break;
 	default:
@@ -4628,6 +4692,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #endif
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
+			WARN_ON_ONCE(msr_info->index != MSR_IA32_FRED_SSP0);
+			msr_info->data = vcpu->arch.fred_ssp0_fallback;
+			break;
+		}
+
 		kvm_get_xstate_msr(vcpu, msr_info);
 		break;
 	default:
@@ -4648,8 +4718,23 @@ static bool is_xstate_managed_msr(u32 index)
 {
 	switch (index) {
 	case MSR_IA32_U_CET:
-	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+	case MSR_IA32_PL1_SSP ... MSR_IA32_PL3_SSP:
 		return true;
+	case MSR_IA32_PL0_SSP:
+		/*
+		 * When CET is not supported, XRSTORS/XSAVES do not cover
+		 * MSR_IA32_PL0_SSP.  However, this MSR remains accessible
+		 * to a FRED guest.
+		 *
+		 * Return false to skip loading the guest FPU in __msr_io()
+		 * whenever CET is unsupported, regardless of FRED support.
+		 *
+		 * Note: if !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) but
+		 * kvm_cpu_cap_has(X86_FEATURE_SHSTK), this function returns
+		 * true and XSAVES/XRSTORS save and restore MSR_IA32_PL0_SSP,
+		 * even such a guest doesn't affect the hardware PL0 SSP MSR.
+		 */
+		return kvm_caps.supported_xss & XFEATURE_MASK_CET_KERNEL;
 	default:
 		return false;
 	}
@@ -7603,10 +7688,19 @@ static void kvm_probe_msr_to_save(u32 msr_index)
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
2.51.0


