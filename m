Return-Path: <kvm+bounces-7915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 404468484CF
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:07:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B051B2B5B1
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157C262A16;
	Sat,  3 Feb 2024 09:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FJLd0h6V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30EB63101;
	Sat,  3 Feb 2024 09:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950897; cv=none; b=OmIWpHLNNC9RI8yvmyynEUyY2oHNz+nn4s+p1OBk+zRwDqDijXSiLPYK1YZnfDaKKK834llbzqLuPkvRbVgZOVznUVKw/bhfjPXB7HO0XDOHG0YNwM0QxrOp1fzH1t9nDw9j5qLgOT/1CfujtESSfd8ypJaUMBz7+WmwEqj+3XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950897; c=relaxed/simple;
	bh=SGebCb4uhyf1FjJh6l9SreVJIhhK/w3FLryXtt84pw8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C7m7pPFqgl6+g0q9OESrmk+1xDzZQuZEQ2h4S5Vw1u+lomzrjb7q6lRTaWDiCxNI2MLuyQJD+j6qwPO0JwmSU9f3WaRsEbyQZiJmXqLML6rXX4HF4WZYaebJ1aN+hAEddJV5hMepP8YdrtRNh1KV7ZgBEpRILC14oSo5Nj4aKFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FJLd0h6V; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950896; x=1738486896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SGebCb4uhyf1FjJh6l9SreVJIhhK/w3FLryXtt84pw8=;
  b=FJLd0h6VaqwYXyjXvE9CR+VFXPvMY7FGpcBjbRhO9Ch4qmaNFflPNWrR
   pBmKh19vRegZLi/2BEIG1bOMGhZeLqBPQQEtR+bCgQBGt4+p6sue99iZ9
   Han8wPbN30Ohqh91PLfOCRfnIHvmXWYr2SMWeqaoA6ZVnPK5grJlflxRx
   wCeoOLVqjY1UAstPekJN53636sCdQejutS4gPCt0N73/9T0c3JtCfROvT
   /SEc3pU7iw4IbRJeVFK0QA4xNQgo//et94UmexLHJaI97TtIsTHKJXHaW
   ZWgbb14gijy9WwJ7E+wDjqG6o/Jq9J0YmTBpoVBJZmSYRQR9Xxlw8cyEL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132093"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132093"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291510"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:29 -0800
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
Subject: [RFC 19/26] KVM: VMX: Emulate the MSRs of HFI feature
Date: Sat,  3 Feb 2024 17:12:07 +0800
Message-Id: <20240203091214.411862-20-zhao1.liu@linux.intel.com>
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

From: Zhao Liu <zhao1.liu@intel.com>

In addition to adding new bits to the package thermal MSRs, HFI has also
introduced two new MSRs:

* MSR_IA32_HW_FEEDBACK_CONFIG: used to enable/disable HFI feature at
  runtime.

  Emulate this MSR by parsing the HFI enabling bit.

* MSR_IA32_HW_FEEDBACK_PTR: used to configure the HFI table's memory
  address.

  Emulate this MSR by storing the Guest HFI table's GPA, and writing
  local virtual HFI table into this GPA when Guest's HFI table needs to
  be updated.

Only when HFI is enabled (set by Guest in MSR_IA32_HW_FEEDBACK_CONFIG)
and Guest HFI table is valid (set the valid address by Guest in
MSR_IA32_HW_FEEDBACK_PTR), Guest can have the valid HFI table and its
HFI table can be updated.

Because the current virtual HFI table is maintained for each VM, not for
each virtual package, these 2 MSRs are also emulated at the VM level.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/svm/svm.c |   2 +
 arch/x86/kvm/vmx/vmx.c | 112 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |   2 +
 arch/x86/kvm/x86.c     |   2 +
 4 files changed, 118 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7039ae48d8d0..980d93c70eb6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4293,6 +4293,8 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	case MSR_IA32_THERM_STATUS:
 	case MSR_IA32_PACKAGE_THERM_INTERRUPT:
 	case MSR_IA32_PACKAGE_THERM_STATUS:
+	case MSR_IA32_HW_FEEDBACK_CONFIG:
+	case MSR_IA32_HW_FEEDBACK_PTR:
 		return false;
 	case MSR_IA32_SMBASE:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 92dded89ae3c..9c28d4ea0b2d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2424,6 +2424,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = kvm_vmx->pkg_therm.msr_pkg_therm_status;
 		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
 		break;
+	case MSR_IA32_HW_FEEDBACK_CONFIG:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_HFI))
+			return 1;
+		msr_info->data = kvm_vmx->pkg_therm.msr_ia32_hfi_cfg;
+		break;
+	case MSR_IA32_HW_FEEDBACK_PTR:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_HFI))
+			return 1;
+		msr_info->data = kvm_vmx->pkg_therm.msr_ia32_hfi_ptr;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2557,6 +2569,77 @@ static int vmx_set_pkg_therm_status_msr(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int vmx_set_hfi_cfg_msr(struct kvm_vcpu *vcpu,
+			       struct msr_data *msr_info)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+	u64 data = msr_info->data;
+	bool hfi_enabled, hfi_changed;
+
+	/*
+	 * When the HFI enable bit changes (either from 0 to 1 or 1 to
+	 * 0), HFI status bit is set and an interrupt is generated if
+	 * enabled.
+	 */
+	hfi_enabled = data & HW_FEEDBACK_CONFIG_HFI_ENABLE;
+	hfi_changed = kvm_vmx_hfi->hfi_enabled != hfi_enabled;
+
+	kvm_vmx->pkg_therm.msr_ia32_hfi_cfg = data;
+	kvm_vmx_hfi->hfi_enabled = hfi_enabled;
+
+	if (!hfi_changed)
+		return 0;
+
+	if (!hfi_enabled) {
+		/*
+		 * SDM: hardware sets the IA32_PACKAGE_THERM_STATUS[bit 26]
+		 * to 1 to acknowledge disabling of the interface.
+		 */
+		kvm_vmx_hfi->hfi_update_status = true;
+		if (vmx_hfi_int_enabled(kvm_vmx))
+			vmx_inject_therm_interrupt(vcpu);
+	} else {
+		/*
+		 * Here we don't care pending updates, because the enabed
+		 * feature change may cause the HFI table update range to
+		 * change.
+		 */
+		vmx_update_hfi_table(vcpu->kvm, true);
+		vmx_hfi_notifier_register(vcpu->kvm);
+	}
+
+	return 0;
+}
+
+static int vmx_set_hfi_ptr_msr(struct kvm_vcpu *vcpu,
+			       struct msr_data *msr_info)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+	u64 data = msr_info->data;
+
+	if (kvm_vmx->pkg_therm.msr_ia32_hfi_ptr == data)
+		return 0;
+
+	kvm_vmx->pkg_therm.msr_ia32_hfi_ptr = data;
+	kvm_vmx_hfi->table_ptr_valid = data & HW_FEEDBACK_PTR_VALID;
+	/*
+	 * Currently we don't really support MSR handling for package
+	 * scope, so when Guest writes, it is not possible to distinguish
+	 * between writes from different packages or repeated writes from
+	 * the same package. To simplify the process, we just assume that
+	 * multiple writes are duplicate writes of the same package and
+	 * overwrite the old.
+	 */
+	kvm_vmx_hfi->table_base = data & ~HW_FEEDBACK_PTR_VALID;
+
+	vmx_update_hfi_table(vcpu->kvm, true);
+	vmx_hfi_notifier_register(vcpu->kvm);
+
+	return 0;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2919,6 +3002,35 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		ret = vmx_set_pkg_therm_status_msr(vcpu, msr_info);
 		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
 		break;
+	case MSR_IA32_HW_FEEDBACK_CONFIG:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_HFI))
+			return 1;
+		/*
+		 * Unsupported and reserved bits. ITD is not supported
+		 * (CPUID.06H:EAX[19]) yet.
+		 */
+		if (!msr_info->host_initiated &&
+		    data & ~(HW_FEEDBACK_CONFIG_HFI_ENABLE))
+			return 1;
+
+		mutex_lock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+		ret = vmx_set_hfi_cfg_msr(vcpu, msr_info);
+		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+		break;
+	case MSR_IA32_HW_FEEDBACK_PTR:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_HFI))
+			return 1;
+		/* Reserved bits: generate the exception. */
+		if (!msr_info->host_initiated &&
+		    data & HW_FEEDBACK_PTR_RESERVED_MASK)
+			return 1;
+
+		mutex_lock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+		ret = vmx_set_hfi_ptr_msr(vcpu, msr_info);
+		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ff205bc0e99a..d9db8bf3726f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -422,6 +422,8 @@ struct hfi_desc {
 struct pkg_therm_desc {
 	u64			msr_pkg_therm_int;
 	u64			msr_pkg_therm_status;
+	u64			msr_ia32_hfi_cfg;
+	u64			msr_ia32_hfi_ptr;
 	/* Currently HFI is only supported at package level. */
 	struct hfi_desc		hfi_desc;
 	/* All members before "struct mutex pkg_therm_lock" are protected by the lock. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bea3def6a4b1..27bec359907c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1550,6 +1550,8 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_THERM_STATUS,
 	MSR_IA32_PACKAGE_THERM_INTERRUPT,
 	MSR_IA32_PACKAGE_THERM_STATUS,
+	MSR_IA32_HW_FEEDBACK_CONFIG,
+	MSR_IA32_HW_FEEDBACK_PTR,
 
 	/*
 	 * KVM always supports the "true" VMX control MSRs, even if the host
-- 
2.34.1


