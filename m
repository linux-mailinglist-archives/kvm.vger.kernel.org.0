Return-Path: <kvm+bounces-55426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 980D0B30957
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A03F6069B7
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE56A2FC00A;
	Thu, 21 Aug 2025 22:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LwfNdNwi"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80D12EAB7B;
	Thu, 21 Aug 2025 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755815882; cv=none; b=s/BvFMxr4I+j5qniH7NzWNYZBw993SRrO8Kwma9xE6w8fT1VN1qP4KmZGXJnAnIPcanBbJgQdPxEF6vknq0G4OSKiD6s1umwGFVAjyDu6IIowORxwylC1NBsln6c52QtjqtHyRNM6YnwfE4/gFgUn2U5Y8UeKwJqWJX92bF00FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755815882; c=relaxed/simple;
	bh=N5Fxhf5o8FauR13ehO99O7qpHATo8gHj6uCp7CmHvVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6/fhXPEfk9/XLRQJ7BihHEs58pRBXFoe+1ButMvM0QelOrCijEJFTU6BpdLvY1vG1Wn7+ScfYWiBBD+l1XFDolXAdl7rnWMlNmTNM4ql9I5DszI4tGZv9/fHasCtvNaxfeBV64dyaeRSm4E4TO5el4rOR4XwXgGpeE32Ze99C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LwfNdNwi; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57LMaUOT984441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 21 Aug 2025 15:36:46 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57LMaUOT984441
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1755815806;
	bh=kGmOUfjjG2IFLy5mGX8HgAHq0LYOJ6I1LXKCS3LW8T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwfNdNwiihKKlyXt/zJ2aOX/9rJyz2fIeJpDp5Dwm/v7F+Ym0Kcao+M3/hD3ewb5U
	 In6hM5DNdOye/hetmee8W5WSNL41Bd41GLxd10YhwPe67QUUlBqKaVm2n5HtoZPfyO
	 hLr4DMUB56bmY7WLUdvs4SJ9Vr5T05j/uxoEVE8ioBfZGIE+Y8bVgJRJ7iLJ9ZRGj3
	 CRin9vuiOWRgMi2akM+t4UOFmFNFzNkxzlm538lea3vbPKpmq0Iah8aj7i7yws7j36
	 5pHbffCB2pcSoVXYMGiMZUvWkOSGnxZ35Wkn67vixwL8glckm30YJihsTGEi4kVfT3
	 0gn/RScSxol2A==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, luto@kernel.org,
        peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
        hch@infradead.org
Subject: [PATCH v6 05/20] KVM: VMX: Initialize VMCS FRED fields
Date: Thu, 21 Aug 2025 15:36:14 -0700
Message-ID: <20250821223630.984383-6-xin@zytor.com>
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

Initialize host VMCS FRED fields with host FRED MSRs' value and
guest VMCS FRED fields to 0.

FRED CPU state is managed in 9 new FRED MSRs:
        IA32_FRED_CONFIG,
        IA32_FRED_STKLVLS,
        IA32_FRED_RSP0,
        IA32_FRED_RSP1,
        IA32_FRED_RSP2,
        IA32_FRED_RSP3,
        IA32_FRED_SSP1,
        IA32_FRED_SSP2,
        IA32_FRED_SSP3,
as well as a few existing CPU registers and MSRs:
        CR4.FRED,
        IA32_STAR,
        IA32_KERNEL_GS_BASE,
        IA32_PL0_SSP (also known as IA32_FRED_SSP0).

CR4, IA32_KERNEL_GS_BASE and IA32_STAR are already well managed.
Except IA32_FRED_RSP0 and IA32_FRED_SSP0, all other FRED CPU state
MSRs have corresponding VMCS fields in both the host-state and
guest-state areas.  So KVM just needs to initialize them, and with
proper VM entry/exit FRED controls, a FRED CPU will keep tracking
host and guest FRED CPU state in VMCS automatically.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---

Change in v5:
* Add TB from Xuelian Guo.

Change in v4:
* Initialize host SSP[1-3] to 0s in vmx_set_constant_host_state()
  because Linux doesn't support kernel shadow stacks (Chao Gao).

Change in v3:
* Use structure kvm_host_values to keep host fred config & stack levels
  (Sean Christopherson).

Changes in v2:
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() to decouple
  KVM's capability to virtualize a feature and host's enabling of a
  feature (Chao Gao).
* Move guest FRED state init into __vmx_vcpu_reset() (Chao Gao).
---
 arch/x86/include/asm/vmx.h | 32 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h         |  3 +++
 3 files changed, 71 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index dd79d027ea70..6f8b8947c60c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -293,12 +293,44 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_IA32_FRED_CONFIG		= 0x0000281a,
+	GUEST_IA32_FRED_CONFIG_HIGH	= 0x0000281b,
+	GUEST_IA32_FRED_RSP1		= 0x0000281c,
+	GUEST_IA32_FRED_RSP1_HIGH	= 0x0000281d,
+	GUEST_IA32_FRED_RSP2		= 0x0000281e,
+	GUEST_IA32_FRED_RSP2_HIGH	= 0x0000281f,
+	GUEST_IA32_FRED_RSP3		= 0x00002820,
+	GUEST_IA32_FRED_RSP3_HIGH	= 0x00002821,
+	GUEST_IA32_FRED_STKLVLS		= 0x00002822,
+	GUEST_IA32_FRED_STKLVLS_HIGH	= 0x00002823,
+	GUEST_IA32_FRED_SSP1		= 0x00002824,
+	GUEST_IA32_FRED_SSP1_HIGH	= 0x00002825,
+	GUEST_IA32_FRED_SSP2		= 0x00002826,
+	GUEST_IA32_FRED_SSP2_HIGH	= 0x00002827,
+	GUEST_IA32_FRED_SSP3		= 0x00002828,
+	GUEST_IA32_FRED_SSP3_HIGH	= 0x00002829,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
 	HOST_IA32_EFER_HIGH		= 0x00002c03,
 	HOST_IA32_PERF_GLOBAL_CTRL	= 0x00002c04,
 	HOST_IA32_PERF_GLOBAL_CTRL_HIGH	= 0x00002c05,
+	HOST_IA32_FRED_CONFIG		= 0x00002c08,
+	HOST_IA32_FRED_CONFIG_HIGH	= 0x00002c09,
+	HOST_IA32_FRED_RSP1		= 0x00002c0a,
+	HOST_IA32_FRED_RSP1_HIGH	= 0x00002c0b,
+	HOST_IA32_FRED_RSP2		= 0x00002c0c,
+	HOST_IA32_FRED_RSP2_HIGH	= 0x00002c0d,
+	HOST_IA32_FRED_RSP3		= 0x00002c0e,
+	HOST_IA32_FRED_RSP3_HIGH	= 0x00002c0f,
+	HOST_IA32_FRED_STKLVLS		= 0x00002c10,
+	HOST_IA32_FRED_STKLVLS_HIGH	= 0x00002c11,
+	HOST_IA32_FRED_SSP1		= 0x00002c12,
+	HOST_IA32_FRED_SSP1_HIGH	= 0x00002c13,
+	HOST_IA32_FRED_SSP2		= 0x00002c14,
+	HOST_IA32_FRED_SSP2_HIGH	= 0x00002c15,
+	HOST_IA32_FRED_SSP3		= 0x00002c16,
+	HOST_IA32_FRED_SSP3_HIGH	= 0x00002c17,
 	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
 	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
 	EXCEPTION_BITMAP                = 0x00004004,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c8b95c215869..42e179f19c23 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1460,6 +1460,15 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
 				    (unsigned long)(cpu_entry_stack(cpu) + 1));
 		}
 
+		/* Per-CPU FRED MSRs */
+		if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+#ifdef CONFIG_X86_64
+			vmcs_write64(HOST_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB));
+			vmcs_write64(HOST_IA32_FRED_RSP2, __this_cpu_ist_top_va(ESTACK_NMI));
+			vmcs_write64(HOST_IA32_FRED_RSP3, __this_cpu_ist_top_va(ESTACK_DF));
+#endif
+		}
+
 		vmx->loaded_vmcs->cpu = cpu;
 	}
 }
@@ -4307,6 +4316,17 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	 */
 	vmcs_write16(HOST_DS_SELECTOR, 0);
 	vmcs_write16(HOST_ES_SELECTOR, 0);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+		/* FRED CONFIG and STKLVLS are the same on all CPUs */
+		vmcs_write64(HOST_IA32_FRED_CONFIG, kvm_host.fred_config);
+		vmcs_write64(HOST_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);
+
+		/* Linux doesn't support kernel shadow stacks, thus SSPs are 0s */
+		vmcs_write64(HOST_IA32_FRED_SSP1, 0);
+		vmcs_write64(HOST_IA32_FRED_SSP2, 0);
+		vmcs_write64(HOST_IA32_FRED_SSP3, 0);
+	}
 #else
 	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_ES_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
@@ -4824,6 +4844,17 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	}
 
 	vmx_setup_uret_msrs(vmx);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+		vmcs_write64(GUEST_IA32_FRED_CONFIG, 0);
+		vmcs_write64(GUEST_IA32_FRED_RSP1, 0);
+		vmcs_write64(GUEST_IA32_FRED_RSP2, 0);
+		vmcs_write64(GUEST_IA32_FRED_RSP3, 0);
+		vmcs_write64(GUEST_IA32_FRED_STKLVLS, 0);
+		vmcs_write64(GUEST_IA32_FRED_SSP1, 0);
+		vmcs_write64(GUEST_IA32_FRED_SSP2, 0);
+		vmcs_write64(GUEST_IA32_FRED_SSP3, 0);
+	}
 }
 
 static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -8679,6 +8710,11 @@ __init int vmx_hardware_setup(void)
 
 	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+		rdmsrl(MSR_IA32_FRED_CONFIG, kvm_host.fred_config);
+		rdmsrl(MSR_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);
+	}
+
 	return r;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d6b21ba41416..b6dc23c478ff 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -52,6 +52,9 @@ struct kvm_host_values {
 	u64 xss;
 	u64 s_cet;
 	u64 arch_capabilities;
+
+	u64 fred_config;
+	u64 fred_stklvls;
 };
 
 void kvm_spurious_fault(void);
-- 
2.50.1


