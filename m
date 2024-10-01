Return-Path: <kvm+bounces-27735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B53CA98B36B
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:05:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64208284216
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46C191BFDF5;
	Tue,  1 Oct 2024 05:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="birV8BbQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27D01BBBF8;
	Tue,  1 Oct 2024 05:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758940; cv=none; b=jFVRxOICcerJXKZQfHFYnrvTcvTaM98fXHp+pG0LdHueNj3dQINq0Vpl5NNgKLIS/yHQS7mZrioVUM6cdlRwa4YKEF/eVA2VrbQt8i2gh/vcWO5c5wn2c0K+MEK+AlgIsG+oi5HPNyT6nGIknjXonqZDOynVeGI3YbhR3FLv8XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758940; c=relaxed/simple;
	bh=zeMVBh2t6rcmcSMPFekgQDkjP5ip/YKm00vUimMWlqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alvT+hBcxHfUeCtHEYqnO4vfcMQvdIVubUewWibjX7Dyd+gWnLSaOk41wRGjhMT/jgIndqJZsb3Lkq/OP3KFTtsMpZ0dOpqtBbpTIz7wRz1VjlZrPfBf9Slo2tKbuSHTJgdqfxIAJupB8alJJ7TmeSaiOdpeX6fuXnictqlw4TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=birV8BbQ; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7W3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:22 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7W3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758883;
	bh=a8ZJAxBUc5v7ZGwYUvEF4rZopLKK9vaa9w31JixcidI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=birV8BbQrRrLGG2v557/z70/N9yieIBNgYIuXn9c4ue1o6HQ3aJ7/Aw44yPe+Z3uJ
	 4T44cSG6OvqjeAV9maaYafXNPXKygLJhgdHbQdhTjrdJPtPq9zZ1xpYRQghGNq+w17
	 J70y19woPpLrpZCuA6PTfAW84VsM4rlpZeqYkj11vDCzMK6OXbgC5JA6ib3kLsbJVR
	 QOjJB8QCnOvtg1dy4VjSlKNS8gXeiRsrbOZnosiBhEH/BbXKmIG7L81mHzCk0efadM
	 TXYAcnDn5UxHOxGNSkm5YJZ4cfdmm9pzFRzokhWNjaiGrwqIECRyK2jRujujG3fxML
	 DCifVuoCDMhsQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 07/27] KVM: VMX: Initialize VMCS FRED fields
Date: Mon, 30 Sep 2024 22:00:50 -0700
Message-ID: <20241001050110.3643764-8-xin@zytor.com>
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

Initialize host VMCS FRED fields with host FRED MSRs' value and
guest VMCS FRED fields to 0.

FRED CPU states are managed in 9 new FRED MSRs, as well as a few
existing CPU registers and MSRs, e.g., CR4.FRED.  To support FRED
context management, new VMCS fields corresponding to most of FRED
CPU state MSRs are added to both the host-state and guest-state
areas of VMCS.

Specifically no VMCS fields are added for FRED RSP0 and SSP0 MSRs,
because the 2 FRED MSRs are used during ring 3 event delivery only,
thus KVM can run safely even with guest FRED RSP0 and SSP0.  Thus
save and restore of FRED RSP0 and SSP0 are deferred.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---

Change since v2:
* Use structure kvm_host_values to keep host fred config & stack levels
  (Sean Christopherson).

Changes since v1:
* Use kvm_cpu_cap_has() instead of cpu_feature_enabled() to decouple
  KVM's capability to virtualize a feature and host's enabling of a
  feature (Chao Gao).
* Move guest FRED states init into __vmx_vcpu_reset() (Chao Gao).
---
 arch/x86/include/asm/vmx.h | 16 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h         |  3 +++
 3 files changed, 53 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 551f62892e1a..5184e03945dd 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -289,12 +289,28 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_IA32_FRED_CONFIG		= 0x0000281a,
+	GUEST_IA32_FRED_RSP1		= 0x0000281c,
+	GUEST_IA32_FRED_RSP2		= 0x0000281e,
+	GUEST_IA32_FRED_RSP3		= 0x00002820,
+	GUEST_IA32_FRED_STKLVLS		= 0x00002822,
+	GUEST_IA32_FRED_SSP1		= 0x00002824,
+	GUEST_IA32_FRED_SSP2		= 0x00002826,
+	GUEST_IA32_FRED_SSP3		= 0x00002828,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
 	HOST_IA32_EFER_HIGH		= 0x00002c03,
 	HOST_IA32_PERF_GLOBAL_CTRL	= 0x00002c04,
 	HOST_IA32_PERF_GLOBAL_CTRL_HIGH	= 0x00002c05,
+	HOST_IA32_FRED_CONFIG		= 0x00002c08,
+	HOST_IA32_FRED_RSP1		= 0x00002c0a,
+	HOST_IA32_FRED_RSP2		= 0x00002c0c,
+	HOST_IA32_FRED_RSP3		= 0x00002c0e,
+	HOST_IA32_FRED_STKLVLS		= 0x00002c10,
+	HOST_IA32_FRED_SSP1		= 0x00002c12,
+	HOST_IA32_FRED_SSP2		= 0x00002c14,
+	HOST_IA32_FRED_SSP3		= 0x00002c16,
 	PIN_BASED_VM_EXEC_CONTROL       = 0x00004000,
 	CPU_BASED_VM_EXEC_CONTROL       = 0x00004002,
 	EXCEPTION_BITMAP                = 0x00004004,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9b4c30db911f..fee0df93e07c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1503,6 +1503,18 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 				    (unsigned long)(cpu_entry_stack(cpu) + 1));
 		}
 
+		/* Per-CPU FRED MSRs */
+		if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+#ifdef CONFIG_X86_64
+			vmcs_write64(HOST_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
+			vmcs_write64(HOST_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
+			vmcs_write64(HOST_IA32_FRED_RSP3, __this_cpu_ist_top_va(DF));
+#endif
+			vmcs_write64(HOST_IA32_FRED_SSP1, 0);
+			vmcs_write64(HOST_IA32_FRED_SSP2, 0);
+			vmcs_write64(HOST_IA32_FRED_SSP3, 0);
+		}
+
 		vmx->loaded_vmcs->cpu = cpu;
 	}
 }
@@ -4366,6 +4378,12 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	 */
 	vmcs_write16(HOST_DS_SELECTOR, 0);
 	vmcs_write16(HOST_ES_SELECTOR, 0);
+
+	/* FRED CONFIG and STKLVLS are the same on all CPUs. */
+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+		vmcs_write64(HOST_IA32_FRED_CONFIG, kvm_host.fred_config);
+		vmcs_write64(HOST_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);
+	}
 #else
 	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_ES_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
@@ -4876,6 +4894,17 @@ static void init_vmcs(struct vcpu_vmx *vmx)
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
@@ -8614,6 +8643,11 @@ __init int vmx_hardware_setup(void)
 
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
 
+	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
+		rdmsrl(MSR_IA32_FRED_CONFIG, kvm_host.fred_config);
+		rdmsrl(MSR_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);
+	}
+
 	return r;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a84c48ef5278..578fea05ff18 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -45,6 +45,9 @@ struct kvm_host_values {
 	u64 xcr0;
 	u64 xss;
 	u64 arch_capabilities;
+
+	u64 fred_config;
+	u64 fred_stklvls;
 };
 
 void kvm_spurious_fault(void);
-- 
2.46.2


