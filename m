Return-Path: <kvm+bounces-27720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5382198B34B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03422282E76
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C485E1BD4E2;
	Tue,  1 Oct 2024 05:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ppYG5tdY"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA6192D74;
	Tue,  1 Oct 2024 05:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758938; cv=none; b=LrB3W8eoo+/Zz/kf+Hm9eDOIejNXTzBU/CIwavZ+vimlT2Tt/UuMIgIbaiIJkLEiBs+j+YrT7jv7+AOEEw1fCbyMi1j+S9PyY6xleGd68X7DOxXLEZhEM5yXq2oOjQc37fQSGrpFPMwRsdf5qVghw8/acru2Svt/4BB+tC7K9Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758938; c=relaxed/simple;
	bh=CWtx/mRP+r/mpwJiXi9nnsoAzgAb0wK805v+GpUvK9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3wWWnuFGFBHep4UmSDIWJ5dPPvRuH4ToFInj6q+l9HGhe6FoSlxDomtg5couHg/9Uxes3PJdrR1dhln3I5TPlS/zf/CIDOp171zmYT6dyyA0djm4hKOVgFwo7fooSHFJ3G8ttvFcM+5HBAouUryHwGAg0ubEEIf+7/OC/1KVHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ppYG5tdY; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7b3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7b3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758888;
	bh=u/W8FqIpYceGvlBt/jZhU4dFvclVcZ1Loz/v27Qn560=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppYG5tdYC6LWKuXaep3CoURrWaYQ2AxPSYW638XW2OBMIBxWvdsyYHzzPQ/h0fR+2
	 gTaXD0r8ohyx/UBvMGGyT8UnW+OuLN3WRqu2anExDeHphOSADdbKOXlnCYDGSX0J9q
	 Nm3/XHGrHDQGpWdKxeUEBOKThMW00rkdGE9nrryNjbWPvAjDqNpZtbKBpqg7FjX1IP
	 738h6WZPqfYLy3okX5Fem2RyRuthyDuXvmoM7A+j9HlwRf4XkRKfXPCbTnDZx+4VCF
	 /zZE6/lDModSx266Y3fB8tJ57tOz3die1Zz5hNLbFDLA/maaZWpl1q+WCBZZ8Hik1q
	 ZTjKhhkz9YhmA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 12/27] KVM: VMX: Add support for FRED context save/restore
Date: Mon, 30 Sep 2024 22:00:55 -0700
Message-ID: <20241001050110.3643764-13-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
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

Note, handling of MSR_IA32_FRED_SSP0, i.e., MSR_IA32_PL0_SSP, is not
added yet, which is done in the KVM CET patch set.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---

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
 arch/x86/kvm/vmx/vmx.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c     | 25 ++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c638492ebd59..65ab26b13d24 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1424,6 +1424,24 @@ static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
 	preempt_enable();
 	vmx->msr_guest_kernel_gs_base = data;
 }
+
+static u64 vmx_read_guest_fred_rsp0(struct vcpu_vmx *vmx)
+{
+	preempt_disable();
+	if (vmx->guest_state_loaded)
+		vmx->msr_guest_fred_rsp0 = read_msr(MSR_IA32_FRED_RSP0);
+	preempt_enable();
+	return vmx->msr_guest_fred_rsp0;
+}
+
+static void vmx_write_guest_fred_rsp0(struct vcpu_vmx *vmx, u64 data)
+{
+	preempt_disable();
+	if (vmx->guest_state_loaded)
+		wrmsrns(MSR_IA32_FRED_RSP0, data);
+	preempt_enable();
+	vmx->msr_guest_fred_rsp0 = data;
+}
 #endif
 
 static void grow_ple_window(struct kvm_vcpu *vcpu)
@@ -2036,6 +2054,24 @@ int vmx_get_feature_msr(u32 msr, u64 *data)
 	}
 }
 
+#ifdef CONFIG_X86_64
+static u32 fred_msr_vmcs_fields[] = {
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
+static u32 fred_msr_to_vmcs(u32 msr)
+{
+	return fred_msr_vmcs_fields[msr - MSR_IA32_FRED_RSP1];
+}
+#endif
+
 /*
  * Reads an msr value (of 'msr_info->index') into 'msr_info->data'.
  * Returns 0 on success, non-0 otherwise.
@@ -2058,6 +2094,12 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -2265,6 +2307,12 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index e8de9f4734a6..b31ebafbe0bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -320,6 +320,9 @@ static const u32 msrs_to_save_base[] = {
 	MSR_STAR,
 #ifdef CONFIG_X86_64
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
+	MSR_IA32_FRED_RSP0, MSR_IA32_FRED_RSP1, MSR_IA32_FRED_RSP2,
+	MSR_IA32_FRED_RSP3, MSR_IA32_FRED_STKLVLS, MSR_IA32_FRED_SSP1,
+	MSR_IA32_FRED_SSP2, MSR_IA32_FRED_SSP3, MSR_IA32_FRED_CONFIG,
 #endif
 	MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
 	MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
@@ -1891,6 +1894,20 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 
 		data = (u32)data;
 		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		if (!guest_can_use(vcpu, X86_FEATURE_FRED))
+			return 1;
+
+		if (index != MSR_IA32_FRED_STKLVLS && is_noncanonical_address(data, vcpu))
+			return 1;
+		if ((index >= MSR_IA32_FRED_RSP0 && index <= MSR_IA32_FRED_RSP3) &&
+		    (data & GENMASK_ULL(5, 0)))
+			return 1;
+		if ((index >= MSR_IA32_FRED_SSP1 && index <= MSR_IA32_FRED_SSP3) &&
+		    (data & GENMASK_ULL(2, 0)))
+			return 1;
+
+		break;
 	}
 
 	msr.data = data;
@@ -1935,6 +1952,10 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		if (!guest_can_use(vcpu, X86_FEATURE_FRED))
+			return 1;
+		break;
 	}
 
 	msr.index = index;
@@ -7460,6 +7481,10 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		if (!(kvm_get_arch_capabilities() & ARCH_CAP_TSX_CTRL_MSR))
 			return;
 		break;
+	case MSR_IA32_FRED_RSP0 ... MSR_IA32_FRED_CONFIG:
+		if (!kvm_cpu_cap_has(X86_FEATURE_FRED))
+			return;
+		break;
 	default:
 		break;
 	}
-- 
2.46.2


