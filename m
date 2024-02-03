Return-Path: <kvm+bounces-7906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E38438484B3
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 975A328ECF9
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECDD5D75A;
	Sat,  3 Feb 2024 09:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ISWNHVpz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F875F857;
	Sat,  3 Feb 2024 09:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950845; cv=none; b=llF8S1OMNbkN96tbN0Tny/lfFZt2euz0eob+i9gqJK5OPOuzKtQ674Lw//lYlYYZZfvD6U48e3GINqe/mozOw2FBW3ViO7IMNnuXZPrCCLQagdZ7nd3+MvCt7h3CvTZe4K4yxExt8tXYkzEYhX/QWrZ7lRjOb8BjqUYAwvpnIE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950845; c=relaxed/simple;
	bh=m40AHoQ2UOqtleX+0akDeAncXxKxVKmuDUaNWhRJTc8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cAH0mbhZuW4xypltjXUm0CXLlvwyun3P290W9jsVMQkFyN+ElH11bv4TwXR5RV6AYrd4Vt0txfGl7wjvIom+YNXWY6Fot9fhfAO14WgphreLfclcSGObJu6A1kH4fnVXCdRhrzSCrFh58KRfn4tR1TIuSButQ0A4GVessfCkFnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ISWNHVpz; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950844; x=1738486844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m40AHoQ2UOqtleX+0akDeAncXxKxVKmuDUaNWhRJTc8=;
  b=ISWNHVpzGFkmI5RK+i7DBalvx8y+pKvDxtXutoVUZJSK0CnFMiKRcR4s
   On3bZM0AwWg3xlzKI+Uy1q1IzwElpALsfTyRJLQ3W5koUPkkorEletX4B
   IfLSUCcpMfFY+/7y1h50EXwgbzJCRgQNur5p7EgFGl5jjRFLrl5YUpMjw
   uUCx2a3iRzImbsyqP2SzhLuxZ9qWKA7bUS/pQbvhaQv/gmkLIbpwgl5zS
   yolyTEVW4lkKF+qVR0qaHYimKsY5iHEDiukDFIj8JU8MYq34ZAAHu8Ikb
   WlJ0SwUVFLEVuE6MntJBwNpl7WfuhDxSrrJiWHxyZl66AOkQ0cOFFWol1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4131982"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4131982"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:00:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291335"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:00:37 -0800
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
Subject: [RFC 10/26] KVM: VMX: Emulate PTM/PTS (CPUID.0x06.eax[bit 6]) feature
Date: Sat,  3 Feb 2024 17:11:58 +0800
Message-Id: <20240203091214.411862-11-zhao1.liu@linux.intel.com>
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

The PTM feature (Package Thermal Management, alias, PTS) is the
dependency of the Hardware Feedback Interface (HFI) feature.

To support HFI virtualization, PTM feature is also required to be
emulated in KVM.

The PTM feature provides 2 package-level thermal related MSRs:
MSR_IA32_PACKAGE_THERM_INTERRUPT and MSR_IA32_PACKAGE_THERM_STATUS.

Currently KVM doesn't support MSR topology (except for thread scope MSR,
no more other different topological scopes), but since PTM's package
thermal MSRs are only used on client platform with only 1 package, it's
enough to handle these 2 MSRs at VM level. Additionally, a mutex is used
to avoid competing different vCPUs' access to emulated MSR values stored
in kvm_vmx.

PTM also indicates the presence of package level thermal interrupts,
which is meaningful for VM to handle package level thermal interrupt.

The ACPI emulation patch has already added the support for thermal
interrupt injection, and this also reflects the integrity of the PTM
emulation. Although thermal interrupts are not actually injected into
the Guest now, in the following HFI/ITD emulations, thermal interrupts
will be injected into the Guest once the conditions are met.

In addition, expose the CPUID bit of the PTM feature to the VM, which
can help enable package thermal interrupt handling in VM.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/cpuid.c   | 11 ++++++
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/vmx/vmx.c | 76 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h |  9 +++++
 arch/x86/kvm/x86.c     |  2 ++
 5 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d8cfae17cc92..eaac2c8d98b9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -632,6 +632,17 @@ void kvm_set_cpu_caps(void)
 		F(ARAT)
 	);
 
+	/*
+	 * PTS is the dependency of ITD, currently we only use PTS for
+	 * enabling ITD in KVM. Since KVM does not support msr topology at
+	 * present, the emulation of PTS has restrictions on the topology of
+	 * Guest, so we only expose PTS when Host enables ITD.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_ITD)) {
+		if (boot_cpu_has(X86_FEATURE_PTS))
+			kvm_cpu_cap_set(X86_FEATURE_PTS);
+	}
+
 	kvm_cpu_cap_mask(CPUID_7_0_EBX,
 		F(FSGSBASE) | F(SGX) | F(BMI1) | F(HLE) | F(AVX2) |
 		F(FDP_EXCPTN_ONLY) | F(SMEP) | F(BMI2) | F(ERMS) | F(INVPCID) |
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2e22d5e86768..7039ae48d8d0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4291,6 +4291,8 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	case MSR_IA32_THERM_CONTROL:
 	case MSR_IA32_THERM_INTERRUPT:
 	case MSR_IA32_THERM_STATUS:
+	case MSR_IA32_PACKAGE_THERM_INTERRUPT:
+	case MSR_IA32_PACKAGE_THERM_STATUS:
 		return false;
 	case MSR_IA32_SMBASE:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa37b55cf045..45b40a47b448 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -183,6 +183,29 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 	THERM_MASK_THRESHOLD0 | THERM_INT_THRESHOLD0_ENABLE | \
 	THERM_MASK_THRESHOLD1 | THERM_INT_THRESHOLD1_ENABLE)
 
+/* HFI (CPUID.06H:EAX[19]) is not emulated in kvm yet. */
+#define MSR_IA32_PACKAGE_THERM_STATUS_RO_MASK (PACKAGE_THERM_STATUS_PROCHOT | \
+	PACKAGE_THERM_STATUS_PROCHOT_EVENT | PACKAGE_THERM_STATUS_CRITICAL_TEMP | \
+	THERM_STATUS_THRESHOLD0 | THERM_STATUS_THRESHOLD1 | \
+	PACKAGE_THERM_STATUS_POWER_LIMIT | PACKAGE_THERM_STATUS_DIG_READOUT_MASK)
+#define MSR_IA32_PACKAGE_THERM_STATUS_RWC0_MASK (PACKAGE_THERM_STATUS_PROCHOT_LOG | \
+	PACKAGE_THERM_STATUS_PROCHOT_EVENT_LOG | PACKAGE_THERM_STATUS_CRITICAL_TEMP_LOG | \
+	THERM_LOG_THRESHOLD0 | THERM_LOG_THRESHOLD1 | \
+	PACKAGE_THERM_STATUS_POWER_LIMIT_LOG)
+/* MSR_IA32_PACKAGE_THERM_STATUS unavailable bits mask: unsupported and reserved bits. */
+#define MSR_IA32_PACKAGE_THERM_STATUS_UNAVAIL_MASK (~(MSR_IA32_PACKAGE_THERM_STATUS_RO_MASK | \
+	MSR_IA32_PACKAGE_THERM_STATUS_RWC0_MASK))
+
+/*
+ * MSR_IA32_PACKAGE_THERM_INTERRUPT available bits mask.
+ * HFI (CPUID.06H:EAX[19]) is not emulated in kvm yet.
+ */
+#define MSR_IA32_PACKAGE_THERM_INTERRUPT_AVAIL_MASK (PACKAGE_THERM_INT_HIGH_ENABLE | \
+	PACKAGE_THERM_INT_LOW_ENABLE | PACKAGE_THERM_INT_PROCHOT_ENABLE | \
+	PACKAGE_THERM_INT_OVERHEAT_ENABLE | THERM_MASK_THRESHOLD0 | \
+	THERM_INT_THRESHOLD0_ENABLE | THERM_MASK_THRESHOLD1 | \
+	THERM_INT_THRESHOLD1_ENABLE | PACKAGE_THERM_INT_PLN_ENABLE)
+
 /*
  * List of MSRs that can be directly passed to the guest.
  * In addition to these x2apic and PT MSRs are handled specially.
@@ -2013,6 +2036,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
 	struct vmx_uret_msr *msr;
 	u32 index;
 
@@ -2166,6 +2190,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vmx->msr_ia32_therm_status;
 		break;
+	case MSR_IA32_PACKAGE_THERM_INTERRUPT:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PTS))
+			return 1;
+		msr_info->data = kvm_vmx->pkg_therm.msr_pkg_therm_int;
+		break;
+	case MSR_IA32_PACKAGE_THERM_STATUS:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PTS))
+			return 1;
+		msr_info->data = kvm_vmx->pkg_therm.msr_pkg_therm_status;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2226,6 +2262,7 @@ static inline u64 vmx_set_msr_rwc0_bits(u64 new_val, u64 old_val, u64 rwc0_mask)
 static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
 	struct vmx_uret_msr *msr;
 	int ret = 0;
 	u32 msr_index = msr_info->index;
@@ -2543,7 +2580,35 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		vmx->msr_ia32_therm_status = data;
 		break;
+	case MSR_IA32_PACKAGE_THERM_INTERRUPT:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PTS))
+			return 1;
+		/* Unsupported and reserved bits: generate the exception. */
+		if (!msr_info->host_initiated &&
+		    data & ~MSR_IA32_PACKAGE_THERM_INTERRUPT_AVAIL_MASK)
+			return 1;
+		kvm_vmx->pkg_therm.msr_pkg_therm_int = data;
+		break;
+	case MSR_IA32_PACKAGE_THERM_STATUS:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_PTS))
+			return 1;
+		/* Unsupported and reserved bits: generate the exception. */
+		if (!msr_info->host_initiated &&
+		    data & MSR_IA32_PACKAGE_THERM_STATUS_UNAVAIL_MASK)
+			return 1;
 
+		mutex_lock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+		if (!msr_info->host_initiated) {
+			data = vmx_set_msr_rwc0_bits(data, kvm_vmx->pkg_therm.msr_pkg_therm_status,
+						     MSR_IA32_PACKAGE_THERM_STATUS_RWC0_MASK);
+			data = vmx_set_msr_ro_bits(data, kvm_vmx->pkg_therm.msr_pkg_therm_status,
+						   MSR_IA32_PACKAGE_THERM_STATUS_RO_MASK);
+		}
+		kvm_vmx->pkg_therm.msr_pkg_therm_status = data;
+		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
@@ -7649,6 +7714,14 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
+static int vmx_vm_init_pkg_therm(struct kvm *kvm)
+{
+	struct pkg_therm_desc *pkg_therm = &to_kvm_vmx(kvm)->pkg_therm;
+
+	mutex_init(&pkg_therm->pkg_therm_lock);
+	return 0;
+}
+
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
@@ -7680,7 +7753,8 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
-	return 0;
+
+	return vmx_vm_init_pkg_therm(kvm);
 }
 
 static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e159dd5b7a66..5723780da180 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -369,6 +369,13 @@ struct vcpu_vmx {
 	} shadow_msr_intercept;
 };
 
+struct pkg_therm_desc {
+	u64			msr_pkg_therm_int;
+	u64			msr_pkg_therm_status;
+	/* All members before "struct mutex pkg_therm_lock" are protected by the lock. */
+	struct mutex		pkg_therm_lock;
+};
+
 struct kvm_vmx {
 	struct kvm kvm;
 
@@ -377,6 +384,8 @@ struct kvm_vmx {
 	gpa_t ept_identity_map_addr;
 	/* Posted Interrupt Descriptor (PID) table for IPI virtualization */
 	u64 *pid_table;
+
+	struct pkg_therm_desc pkg_therm;
 };
 
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 50aceb0ce4ee..7d787ced513f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1548,6 +1548,8 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_THERM_CONTROL,
 	MSR_IA32_THERM_INTERRUPT,
 	MSR_IA32_THERM_STATUS,
+	MSR_IA32_PACKAGE_THERM_INTERRUPT,
+	MSR_IA32_PACKAGE_THERM_STATUS,
 
 	/*
 	 * KVM always supports the "true" VMX control MSRs, even if the host
-- 
2.34.1


