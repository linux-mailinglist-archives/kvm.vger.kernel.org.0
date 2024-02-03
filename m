Return-Path: <kvm+bounces-7914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 815618484CD
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:06:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7E75B2B27B
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060A261663;
	Sat,  3 Feb 2024 09:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XNxX8FLq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8422E612F5;
	Sat,  3 Feb 2024 09:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950891; cv=none; b=YaEBwA9S5F+ESzB/8SFZiyDVtX6dCbpzn+4Rc/XftNoTKuFY1Jm5sQsjp2f19rAYm0OJ6rSfw/dIVooVi8Jwx3Ntl+GReFvu9UUBIOQUQ3AjO8x7zcPFvfUXBc2xFrOgi5xFhxwTd1Cba/BY6zgFRyMNAipv6tQVbYM1WotmMEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950891; c=relaxed/simple;
	bh=xPsoiGvQ/WepqnMDgjkmeX0HGRQmeVD7pNcmGBM6KEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FX0hp02W2hzeXLl9BJ8PRCRjW0fNN9AOup/SZB5mzVD7e1dHBv+T37E61kx8/SPyD2uY9dixF9ny8hKwFWI2UcXD2RPEtIRALZwACthrtZRrCCgkPrcB1c2nKTMxmOr07V8CEwQeOc/r/r7Fozkk9OYnAAxP5ZjZkWkoKgMhyzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XNxX8FLq; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950890; x=1738486890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xPsoiGvQ/WepqnMDgjkmeX0HGRQmeVD7pNcmGBM6KEo=;
  b=XNxX8FLqfNEcl+ZjdB9QXcRB+D8nbyOonzMzp0jSwBw+TgRmZvbiKLMe
   sXehU72p9x095U2bxoBuzLEzHGmi5VtS5ydQKYTnmtrmvAP8Jzd6dvv6B
   xERrScTWeZ4xR5FXaUfchVY6aLJcEBJEA0W9KYupS6zoirgYmR/Pcy+8y
   TUK+wy8VwGF2MIEyTzsVnxuPUwg0exuKXd+sH/a3sgntX/ilMzv4ZbzBq
   ULPmgKL0lV/TY5FPpTgIuOKulOXqtuU/eUzPWLzPkt35BnxogbXc5pNFC
   H5DMPOvFimt90cXsiYKdQUECK/5mIdaysaP9OesjknFQ9LehYqpgDBB9V
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132081"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132081"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291496"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:23 -0800
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
Subject: [RFC 18/26] KVM: VMX: Emulate HFI related bits in package thermal MSRs
Date: Sat,  3 Feb 2024 17:12:06 +0800
Message-Id: <20240203091214.411862-19-zhao1.liu@linux.intel.com>
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

The HFI feature adds the new bits in MSR_IA32_PACKAGE_THERM_STATUS and
MSR_IA32_PACKAGE_THERM_INTERRUPT to control HFI status and notification:

* MSR_IA32_PACKAGE_THERM_STATUS: PACKAGE_THERM_STATUS_HFI_UPDATED bit.

  This bit indicates if there's the new HFI update. Whenever the HFI
  table is updated, the hardware sends an HFI notification and sets this
  bit to 1. Only when the OS clears this bit to 0 will the HFI table
  continue to be updated.

  Emulate the logic of this bit to coordinate with the update of the
  Guest HFI table and also to support Guest's clear 0 write.

* MSR_IA32_PACKAGE_THERM_INTERRUPT: PACKAGE_THERM_INT_HFI_ENABLE bit.

  This bit controls the HFI notification enabling. If it's set to 1,
  every time when HFI table has update, hardware will send a thermal
  interrupt to notify OS.

  Therefore, also emulate this bit to support thermal interrupt when
  Guest HFI table is updated.

These status/control bits correspond to the flags in struct hfi_desc,
(this is hfi_update_status and hfi_int_enabled).

Note that for the thermal interrupt-related features, we only fully
emulate HFI, so MSR_IA32_PACKAGE_THERM_STATUS and
MSR_IA32_PACKAGE_THERM_INTERRUPT do not (and should not, even though
we do not disable the initial exception MSR value via KVM_SET_MSRS)
take effect by setting other bits.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 129 +++++++++++++++++++++++++++++++++++------
 1 file changed, 111 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 97bb7b304213..92dded89ae3c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -183,7 +183,6 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 	THERM_MASK_THRESHOLD0 | THERM_INT_THRESHOLD0_ENABLE | \
 	THERM_MASK_THRESHOLD1 | THERM_INT_THRESHOLD1_ENABLE)
 
-/* HFI (CPUID.06H:EAX[19]) is not emulated in kvm yet. */
 #define MSR_IA32_PACKAGE_THERM_STATUS_RO_MASK (PACKAGE_THERM_STATUS_PROCHOT | \
 	PACKAGE_THERM_STATUS_PROCHOT_EVENT | PACKAGE_THERM_STATUS_CRITICAL_TEMP | \
 	THERM_STATUS_THRESHOLD0 | THERM_STATUS_THRESHOLD1 | \
@@ -191,20 +190,17 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 #define MSR_IA32_PACKAGE_THERM_STATUS_RWC0_MASK (PACKAGE_THERM_STATUS_PROCHOT_LOG | \
 	PACKAGE_THERM_STATUS_PROCHOT_EVENT_LOG | PACKAGE_THERM_STATUS_CRITICAL_TEMP_LOG | \
 	THERM_LOG_THRESHOLD0 | THERM_LOG_THRESHOLD1 | \
-	PACKAGE_THERM_STATUS_POWER_LIMIT_LOG)
+	PACKAGE_THERM_STATUS_POWER_LIMIT_LOG | PACKAGE_THERM_STATUS_HFI_UPDATED)
 /* MSR_IA32_PACKAGE_THERM_STATUS unavailable bits mask: unsupported and reserved bits. */
 #define MSR_IA32_PACKAGE_THERM_STATUS_UNAVAIL_MASK (~(MSR_IA32_PACKAGE_THERM_STATUS_RO_MASK | \
 	MSR_IA32_PACKAGE_THERM_STATUS_RWC0_MASK))
 
-/*
- * MSR_IA32_PACKAGE_THERM_INTERRUPT available bits mask.
- * HFI (CPUID.06H:EAX[19]) is not emulated in kvm yet.
- */
-#define MSR_IA32_PACKAGE_THERM_INTERRUPT_AVAIL_MASK (PACKAGE_THERM_INT_HIGH_ENABLE | \
+#define MSR_IA32_PACKAGE_THERM_INTERRUPT_MASK (PACKAGE_THERM_INT_HIGH_ENABLE | \
 	PACKAGE_THERM_INT_LOW_ENABLE | PACKAGE_THERM_INT_PROCHOT_ENABLE | \
 	PACKAGE_THERM_INT_OVERHEAT_ENABLE | THERM_MASK_THRESHOLD0 | \
 	THERM_INT_THRESHOLD0_ENABLE | THERM_MASK_THRESHOLD1 | \
-	THERM_INT_THRESHOLD1_ENABLE | PACKAGE_THERM_INT_PLN_ENABLE)
+	THERM_INT_THRESHOLD1_ENABLE | PACKAGE_THERM_INT_PLN_ENABLE | \
+	PACKAGE_THERM_INT_HFI_ENABLE)
 
 /*
  * List of MSRs that can be directly passed to the guest.
@@ -2417,7 +2413,16 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_PTS))
 			return 1;
+
+		mutex_lock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+		if (kvm_vmx->pkg_therm.hfi_desc.hfi_update_status)
+			kvm_vmx->pkg_therm.msr_pkg_therm_status |=
+				PACKAGE_THERM_STATUS_HFI_UPDATED;
+		else
+			kvm_vmx->pkg_therm.msr_pkg_therm_status &=
+				~PACKAGE_THERM_STATUS_HFI_UPDATED;
 		msr_info->data = kvm_vmx->pkg_therm.msr_pkg_therm_status;
+		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
 		break;
 	default:
 	find_uret_msr:
@@ -2471,6 +2476,87 @@ static inline u64 vmx_set_msr_rwc0_bits(u64 new_val, u64 old_val, u64 rwc0_mask)
 	return ((new_rwc0 | ~old_rwc0) & old_rwc0) | (new_val & ~rwc0_mask);
 }
 
+static int vmx_set_pkg_therm_int_msr(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr_info)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+	u64 data = msr_info->data;
+	bool hfi_int_enabled, hfi_int_changed;
+
+	hfi_int_enabled = data & PACKAGE_THERM_INT_HFI_ENABLE;
+	hfi_int_changed = vmx_hfi_int_enabled(kvm_vmx) != hfi_int_enabled;
+
+	kvm_vmx->pkg_therm.msr_pkg_therm_int = data;
+	kvm_vmx_hfi->hfi_int_enabled = hfi_int_enabled;
+
+	/*
+	 * Only HFI notification is supported, otherwise behave as a
+	 * dummy MSR.
+	 */
+	if (!intel_hfi_enabled() ||
+	    !guest_cpuid_has(vcpu, X86_FEATURE_HFI) ||
+	    !hfi_int_changed)
+		return 0;
+
+	if (!hfi_int_enabled)
+		return 0;
+
+	/*
+	 * SDM: (For IA32_HW_FEEDBACK_CONFIG) no (HFI) status bit
+	 * set, no interrupt is generated.
+	 */
+	if (!kvm_vmx_hfi->hfi_enabled)
+		return 0;
+
+	/*
+	 * When HFI interrupt enable bit transitions from 0 to 1,
+	 * try to inject initial interrupt. No need to force
+	 * injection of the interrupt if there's no HFI table update.
+	 */
+	vmx_update_hfi_table(vcpu->kvm, false);
+
+	return 0;
+}
+
+static int vmx_set_pkg_therm_status_msr(struct kvm_vcpu *vcpu,
+					struct msr_data *msr_info)
+{
+	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
+	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
+	u64 data = msr_info->data;
+	bool hfi_status_updated, hfi_status_changed;
+
+	if (!msr_info->host_initiated) {
+		data = vmx_set_msr_rwc0_bits(data, kvm_vmx->pkg_therm.msr_pkg_therm_status,
+					     MSR_IA32_PACKAGE_THERM_STATUS_RWC0_MASK);
+		data = vmx_set_msr_ro_bits(data, kvm_vmx->pkg_therm.msr_pkg_therm_status,
+					   MSR_IA32_PACKAGE_THERM_STATUS_RO_MASK);
+	}
+
+	hfi_status_updated = data & PACKAGE_THERM_STATUS_HFI_UPDATED;
+	hfi_status_changed = kvm_vmx_hfi->hfi_update_status != hfi_status_updated;
+
+	kvm_vmx->pkg_therm.msr_pkg_therm_status = data;
+	kvm_vmx_hfi->hfi_update_status = hfi_status_updated;
+
+	if (!intel_hfi_enabled() ||
+	    !guest_cpuid_has(vcpu, X86_FEATURE_HFI) ||
+	    !hfi_status_changed)
+		return 0;
+
+	/*
+	 * From SDM, once the HFI (thermal) status bit is set, the hardware
+	 * will not generate any further updates to HFI table until the OS
+	 * clears this bit by writing 0. When this bit is cleared, apply any
+	 * pending updates to guest HFI table.
+	 */
+	if (!kvm_vmx_hfi->hfi_update_status && kvm_vmx_hfi->hfi_update_pending)
+		vmx_update_hfi_table(vcpu->kvm, false);
+
+	return 0;
+}
+
 /*
  * Writes msr value into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
@@ -2801,11 +2887,19 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_PTS))
 			return 1;
-		/* Unsupported and reserved bits: generate the exception. */
+		/* Unsupported bit: generate the exception. */
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_HFI) &&
+		    data & PACKAGE_THERM_INT_HFI_ENABLE)
+			return 1;
+		/* Reserved bits: generate the exception. */
 		if (!msr_info->host_initiated &&
-		    data & ~MSR_IA32_PACKAGE_THERM_INTERRUPT_AVAIL_MASK)
+		    data & ~MSR_IA32_PACKAGE_THERM_INTERRUPT_MASK)
 			return 1;
-		kvm_vmx->pkg_therm.msr_pkg_therm_int = data;
+
+		mutex_lock(&kvm_vmx->pkg_therm.pkg_therm_lock);
+		ret = vmx_set_pkg_therm_int_msr(vcpu, msr_info);
+		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
 		break;
 	case MSR_IA32_PACKAGE_THERM_STATUS:
 		if (!msr_info->host_initiated &&
@@ -2815,15 +2909,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    data & MSR_IA32_PACKAGE_THERM_STATUS_UNAVAIL_MASK)
 			return 1;
+		/* Unsupported bit: generate the exception. */
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_HFI) &&
+		    data & PACKAGE_THERM_STATUS_HFI_UPDATED)
+			return 1;
 
 		mutex_lock(&kvm_vmx->pkg_therm.pkg_therm_lock);
-		if (!msr_info->host_initiated) {
-			data = vmx_set_msr_rwc0_bits(data, kvm_vmx->pkg_therm.msr_pkg_therm_status,
-						     MSR_IA32_PACKAGE_THERM_STATUS_RWC0_MASK);
-			data = vmx_set_msr_ro_bits(data, kvm_vmx->pkg_therm.msr_pkg_therm_status,
-						   MSR_IA32_PACKAGE_THERM_STATUS_RO_MASK);
-		}
-		kvm_vmx->pkg_therm.msr_pkg_therm_status = data;
+		ret = vmx_set_pkg_therm_status_msr(vcpu, msr_info);
 		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
 		break;
 	default:
-- 
2.34.1


