Return-Path: <kvm+bounces-7903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E05EA8484A9
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A19EB270C9
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6A65EE88;
	Sat,  3 Feb 2024 09:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B50w1Qso"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AA45D730;
	Sat,  3 Feb 2024 09:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950831; cv=none; b=T2Fk/Fo34q2VZkQqxNbeFd8AaJAeHYsAqm+gx76ZASgf/Nt4Rgjh+doRrwkEOa4oRkC/P1CjY47V3hWr8hki1jN+SAfhDWHMAD2VVKadf3vjhx1MWa4vO+y2hlgGi0tGV1xWm+c3WF6Ogrw2P2k47Pc/VaMasLzAU8ENxZK+hJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950831; c=relaxed/simple;
	bh=wo39QfY6kJNr9HVF4FRT1N8YzxbVUTeLkZgS6iaMtTI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NL1hfjnUNyi71BPSD/tEALOXC63J7NW7MB5PdpghcYM3DG+GpHMLlrkeqTqX+a2hz9wRy1s6zXuXmGdX6oXb5H25f2VSvr+nPhlHgPJDsicAQb0y//ejeeR6++mDPqZQOz7/zuipZtZCkX5FcrhgbJu0h8ASpjJmJLuQ7NzFq0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B50w1Qso; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950830; x=1738486830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wo39QfY6kJNr9HVF4FRT1N8YzxbVUTeLkZgS6iaMtTI=;
  b=B50w1QsoL4+WGOaihzrreLFYGwNTpQ25GQCnNz/z9mB9fUcXhLXEEwge
   Uxtqscw+eP40mtNQsfRc7Eh0Ai7GUqBGXqn6rZAJUEO9do2LE6s9VQ4sI
   aivMXE9tazjyfXG8uAPCn24m4EGiMDEa7+B+ialY3ouho9KiOH4vRsF08
   U4n6vpMM3DjCGNHVARSj7BlFddEZzTrWxTzIUO4QOek7uj/09aqLjPB1i
   VbzXuX1sOnmcavJ8virE3ANZmpETHEGoh1cgI6dmhq/wvCCofCMChzwRL
   EV4DqvL7478j7AUlDE2Nzye1sbJEkJ02ka1B9wLiv214SXg2IC1OCSnOw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131932"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131932"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:00:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291255"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:00:20 -0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [RFC 07/26] KVM: VMX: Emulate ACPI (CPUID.0x01.edx[bit 22]) feature
Date: Sat,  3 Feb 2024 17:11:55 +0800
Message-Id: <20240203091214.411862-8-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhuocheng Ding <zhuocheng.ding@intel.com>

The ACPI (Thermal Monitor and Software Controlled Clock Facilities)
feature is a dependency of thermal interrupt processing so that
it is required for the HFI notification (a thermal interrupt)
handling.

To support VM to handle thermal interrupt, we need to emulate ACPI
feature in KVM:

1. Emulate MSR_IA32_THERM_CONTROL (alias, IA32_CLOCK_MODULATION),
MSR_IA32_THERM_INTERRUPT and MSR_IA32_THERM_STATUS with dummy values.

According to SDM [1], the ACPI feature means:

"The ACPI flag (bit 22) of the CPUID feature flags indicates the
presence of the IA32_THERM_STATUS, IA32_THERM_INTERRUPT,
IA32_CLOCK_MODULATION MSRs, and the xAPIC thermal LVT entry."

It is enough to use dummy values in KVM to emulate the RDMSR/WRMSR on
them.

2. Add the thermal interrupt injection interfaces.

This interface reflects the integrity of the ACPI emulation. Although
thermal interrupts are not actually injected into the Guest now, in the
following HFI/ITD emulations, thermal interrupt will be injected into
Guest once the conditions are met.

3. Additionally, expose the CPUID bit of the ACPI feature to the VM,
which can help enable thermal interrupt handling in the VM.

[1]: SDM, vol. 3B, section 15.8.4.1, Detection of Software Controlled
Clock Modulation Extension.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/cpuid.c   |  2 +-
 arch/x86/kvm/irq.h     |  1 +
 arch/x86/kvm/lapic.c   |  9 ++++
 arch/x86/kvm/svm/svm.c |  3 ++
 arch/x86/kvm/vmx/vmx.c | 94 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  3 ++
 arch/x86/kvm/x86.c     |  3 ++
 7 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..1ad547651022 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -623,7 +623,7 @@ void kvm_set_cpu_caps(void)
 		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
 		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
 		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
-		0 /* Reserved, DS, ACPI */ | F(MMX) |
+		0 /* Reserved, DS */ | F(ACPI) | F(MMX) |
 		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
 		0 /* HTT, TM, Reserved, PBE */
 	);
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index c2d7cfe82d00..e11c1fb6e1e6 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -99,6 +99,7 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu);
+void kvm_apic_therm_deliver(struct kvm_vcpu *vcpu);
 void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu);
 void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu);
 void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2457..af8572798976 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2783,6 +2783,15 @@ void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu)
 		kvm_apic_local_deliver(apic, APIC_LVT0);
 }
 
+void kvm_apic_therm_deliver(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic = vcpu->arch.apic;
+
+	if (apic)
+		kvm_apic_local_deliver(apic, APIC_LVTTHMR);
+}
+EXPORT_SYMBOL_GPL(kvm_apic_therm_deliver);
+
 static const struct kvm_io_device_ops apic_mmio_ops = {
 	.read     = apic_mmio_read,
 	.write    = apic_mmio_write,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..2e22d5e86768 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4288,6 +4288,9 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	switch (index) {
 	case MSR_IA32_MCG_EXT_CTL:
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
+	case MSR_IA32_THERM_CONTROL:
+	case MSR_IA32_THERM_INTERRUPT:
+	case MSR_IA32_THERM_STATUS:
 		return false;
 	case MSR_IA32_SMBASE:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8f5981635fe5..aa37b55cf045 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -157,6 +157,32 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 	RTIT_STATUS_ERROR | RTIT_STATUS_STOPPED | \
 	RTIT_STATUS_BYTECNT))
 
+/*
+ * TM2 (CPUID.01H:ECX[8]), DTHERM (CPUID.06H:EAX[0]), PLN (CPUID.06H:EAX[4]),
+ * and HWP (CPUID.06H:EAX[7]) are not emulated in kvm.
+ */
+#define MSR_IA32_THERM_STATUS_RO_MASK (THERM_STATUS_PROCHOT | \
+	THERM_STATUS_PROCHOT_FORCEPR_EVENT | THERM_STATUS_CRITICAL_TEMP)
+#define MSR_IA32_THERM_STATUS_RWC0_MASK (THERM_STATUS_PROCHOT_LOG | \
+	THERM_STATUS_PROCHOT_FORCEPR_LOG | THERM_STATUS_CRITICAL_TEMP_LOG)
+/* MSR_IA32_THERM_STATUS unavailable bits mask: unsupported and reserved bits. */
+#define MSR_IA32_THERM_STATUS_UNAVAIL_MASK (~(MSR_IA32_THERM_STATUS_RO_MASK | \
+	MSR_IA32_THERM_STATUS_RWC0_MASK))
+
+/* ECMD (CPUID.06H:EAX[5]) is not emulated in kvm. */
+#define MSR_IA32_THERM_CONTROL_AVAIL_MASK (THERM_ON_DEM_CLO_MOD_ENABLE | \
+	THERM_ON_DEM_CLO_MOD_DUTY_CYC_MASK)
+
+/*
+ * MSR_IA32_THERM_INTERRUPT available bits mask.
+ * PLN (CPUID.06H:EAX[4]) and HFN (CPUID.06H:EAX[24]) are not emulated in kvm.
+ */
+#define MSR_IA32_THERM_INTERRUPT_AVAIL_MASK (THERM_INT_HIGH_ENABLE | \
+	THERM_INT_LOW_ENABLE | THERM_INT_PROCHOT_ENABLE | \
+	THERM_INT_FORCEPR_ENABLE | THERM_INT_CRITICAL_TEM_ENABLE | \
+	THERM_MASK_THRESHOLD0 | THERM_INT_THRESHOLD0_ENABLE | \
+	THERM_MASK_THRESHOLD1 | THERM_INT_THRESHOLD1_ENABLE)
+
 /*
  * List of MSRs that can be directly passed to the guest.
  * In addition to these x2apic and PT MSRs are handled specially.
@@ -1470,6 +1496,19 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 	}
 }
 
+static void vmx_inject_therm_interrupt(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * From SDM, the ACPI flag also indicates the presence of the
+	 * xAPIC thermal LVT entry.
+	 */
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_ACPI))
+		return;
+
+	if (irqchip_in_kernel(vcpu->kvm))
+		kvm_apic_therm_deliver(vcpu);
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put(), but assumes
  * vcpu mutex is already taken.
@@ -2109,6 +2148,24 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
 		break;
+	case MSR_IA32_THERM_CONTROL:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_ACPI))
+			return 1;
+		msr_info->data = vmx->msr_ia32_therm_control;
+		break;
+	case MSR_IA32_THERM_INTERRUPT:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_ACPI))
+			return 1;
+		msr_info->data = vmx->msr_ia32_therm_interrupt;
+		break;
+	case MSR_IA32_THERM_STATUS:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_ACPI))
+			return 1;
+		msr_info->data = vmx->msr_ia32_therm_status;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2452,6 +2509,40 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
+	case MSR_IA32_THERM_CONTROL:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_ACPI))
+			return 1;
+		if (!msr_info->host_initiated &&
+		    data & ~MSR_IA32_THERM_CONTROL_AVAIL_MASK)
+			return 1;
+		vmx->msr_ia32_therm_control = data;
+		break;
+	case MSR_IA32_THERM_INTERRUPT:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_ACPI))
+			return 1;
+		if (!msr_info->host_initiated &&
+		    data & ~MSR_IA32_THERM_INTERRUPT_AVAIL_MASK)
+			return 1;
+		vmx->msr_ia32_therm_interrupt = data;
+		break;
+	case MSR_IA32_THERM_STATUS:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_ACPI))
+			return 1;
+		/* Unsupported and reserved bits: generate the exception. */
+		if (!msr_info->host_initiated &&
+		    data & MSR_IA32_THERM_STATUS_UNAVAIL_MASK)
+			return 1;
+		if (!msr_info->host_initiated) {
+			data = vmx_set_msr_rwc0_bits(data, vmx->msr_ia32_therm_status,
+						     MSR_IA32_THERM_STATUS_RWC0_MASK);
+			data = vmx_set_msr_ro_bits(data, vmx->msr_ia32_therm_status,
+						   MSR_IA32_THERM_STATUS_RO_MASK);
+		}
+		vmx->msr_ia32_therm_status = data;
+		break;
 
 	default:
 	find_uret_msr:
@@ -4870,6 +4961,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->spec_ctrl = 0;
 
 	vmx->msr_ia32_umwait_control = 0;
+	vmx->msr_ia32_therm_control = 0;
+	vmx->msr_ia32_therm_interrupt = 0;
+	vmx->msr_ia32_therm_status = 0;
 
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e3b0985bb74a..e159dd5b7a66 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -282,6 +282,9 @@ struct vcpu_vmx {
 
 	u64		      spec_ctrl;
 	u32		      msr_ia32_umwait_control;
+	u64		      msr_ia32_therm_control;
+	u64		      msr_ia32_therm_interrupt;
+	u64		      msr_ia32_therm_status;
 
 	/*
 	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd9a7251c768..50aceb0ce4ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1545,6 +1545,9 @@ static const u32 emulated_msrs_all[] = {
 	MSR_AMD64_TSC_RATIO,
 	MSR_IA32_POWER_CTL,
 	MSR_IA32_UCODE_REV,
+	MSR_IA32_THERM_CONTROL,
+	MSR_IA32_THERM_INTERRUPT,
+	MSR_IA32_THERM_STATUS,
 
 	/*
 	 * KVM always supports the "true" VMX control MSRs, even if the host
-- 
2.34.1


