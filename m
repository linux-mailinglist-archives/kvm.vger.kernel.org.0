Return-Path: <kvm+bounces-7917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD358484D6
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32BC21F2CA70
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECDA363506;
	Sat,  3 Feb 2024 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YKfFuU/Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5B6634F9;
	Sat,  3 Feb 2024 09:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950909; cv=none; b=pX1r2pyfdeG28eFYOEuJpLPD+lFfEqrUZfHd96RFqy0+Zud2M0Jp/3+szyo5y0M/Iz+ghLxGnzD6Rb33pht1jxF99eL/8uhtYOma7ESilaGuzE+awt5iMrV93+avUisBUWd17jfuwdGUKwskHV1FZGJEj1XpzFAmJrJI/20wKC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950909; c=relaxed/simple;
	bh=lSCiO+p9r/GjQUjj3pkuJGjUOV3DAnIfLLhwnD/+1iI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FngUg57vi5NDHpjD/iGFPTxBKzfeLTuWGgAT1EmrT62n2DU26yxVmri93E0LVu7FJj7LjafVruvIfsqx2CJxUIIABHbHgbXWnKVPhQaATY7ri95HlHVKAoJNKfR9oemd/fTOn+ahutUciggZLnbCUj6PvWwfcDN2O/vcMARhMjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YKfFuU/Y; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950907; x=1738486907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lSCiO+p9r/GjQUjj3pkuJGjUOV3DAnIfLLhwnD/+1iI=;
  b=YKfFuU/Y0cuYxO2Kynb5wtEjNQ1Q+xXcv4+rnrk4lPgwKCQNrDd111Fr
   Jx275Ga900i/5mI4HbWfSD+zy9b86Jl0Em9x4nv7vIyoQIcIsYkOaXReS
   yGty4VwwMEvIRargPa+GDAaJiK/ixA8wFmXN2HPn2kaUFEIQi9TCjc5WD
   iP6KhNPC3rbP6kmEwK++plqlBOWY5tSSLfrbF1djIIwG6bETRf9X22Wp5
   6lyaBdsrTONFmB9Fw7S7WQRbYhqqO9jgu/KbFHJ+Js/a5cZWe1AYKNBEN
   whS7nZ/gB7maItztlk/P6qfVd2jDBHTNN55aBLtt9ZnqeKjtMnCYSb29b
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132136"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132136"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291543"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:40 -0800
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
Subject: [RFC 21/26] KVM: VMX: Extend HFI table and MSR emulation to support ITD
Date: Sat,  3 Feb 2024 17:12:09 +0800
Message-Id: <20240203091214.411862-22-zhao1.liu@linux.intel.com>
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

ITD (Intel Thread Director) is the extension of HFI feature. Based on
HFI, it adds 4 classes in HFI table and it provides the MSR interface to
support the OS to classify the currently running task into one of 4
classes.

As the first step of ITD support, extend the HFI table and related HFI
MSRs' emulation to support the ITD:

* More classes in HFI table

If ITD is configured in Guest's CPUID, the virtual HFI table will be
built with 4 classes.

But only when ITD is enabled in MSR_IA32_HW_FEEDBACK_CONFIG, the
virtual HFI table will update all these 4 classes, otherwise it will
only update class 0's data if HFI is enabled.

* MSR_IA32_HW_FEEDBACK_CONFIG (HW_FEEDBACK_CONFIG_ITD_ENABLE bit)

With ITD support, MSR_IA32_HW_FEEDBACK_CONFIG has 2 feature enabling
bits: HW_FEEDBACK_CONFIG_HFI_ENABLE and HW_FEEDBACK_CONFIG_ITD_ENABLE
bit. These 2 bits control whether the HFI and ITD features are enabled
or not, and also affect which class data should actually be updated in
the virtual HFI table [1].

For the MSR_IA32_HW_FEEDBACK_CONFIG's emulation, add support for
dynamically changing these two bits and the corresponding HFI update
adjustments.

[1]: SDM, vol. 3B, section 15.6.5 Hardware Feedback Interface
     Configuration, Table 15-10. IA32_HW_FEEDBACK_CONFIG Control Option

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 68 +++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.h |  3 ++
 2 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 636f2bd68546..bdff1d424b2f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1547,11 +1547,11 @@ static int vmx_init_hfi_table(struct kvm *kvm)
 	struct hfi_table *hfi_table = &kvm_vmx_hfi->hfi_table;
 	int nr_classes, ret = 0;
 
-	/*
-	 * Currently we haven't supported ITD. HFI is the default feature
-	 * with 1 class.
-	 */
-	nr_classes = 1;
+	if (guest_cpuid_has(kvm_get_vcpu(kvm, 0), X86_FEATURE_ITD))
+		nr_classes = 4;
+	else
+		nr_classes = 1;
+
 	ret = intel_hfi_build_virt_features(hfi_features,
 					    nr_classes,
 					    kvm->created_vcpus);
@@ -1579,11 +1579,11 @@ static int vmx_build_hfi_table(struct kvm *kvm)
 	struct kvm_vcpu *v;
 	unsigned long i;
 
-	/*
-	 * Currently we haven't supported ITD. HFI is the default feature
-	 * with 1 class.
-	 */
-	nr_classes = 1;
+	if (kvm_vmx_hfi->itd_enabled)
+		nr_classes = kvm_vmx_hfi->hfi_features.nr_classes;
+	else
+		nr_classes = 1;
+
 	for (int j = 0; j < nr_classes; j++) {
 		hfi_hdr->perf_updated = 0;
 		hfi_hdr->ee_updated = 0;
@@ -2575,7 +2575,7 @@ static int vmx_set_hfi_cfg_msr(struct kvm_vcpu *vcpu,
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
 	struct hfi_desc *kvm_vmx_hfi = &kvm_vmx->pkg_therm.hfi_desc;
 	u64 data = msr_info->data;
-	bool hfi_enabled, hfi_changed;
+	bool hfi_enabled, hfi_changed, itd_enabled, itd_changed;
 
 	/*
 	 * When the HFI enable bit changes (either from 0 to 1 or 1 to
@@ -2584,12 +2584,44 @@ static int vmx_set_hfi_cfg_msr(struct kvm_vcpu *vcpu,
 	 */
 	hfi_enabled = data & HW_FEEDBACK_CONFIG_HFI_ENABLE;
 	hfi_changed = kvm_vmx_hfi->hfi_enabled != hfi_enabled;
+	itd_enabled = data & HW_FEEDBACK_CONFIG_ITD_ENABLE;
+	itd_changed = kvm_vmx_hfi->itd_enabled != itd_enabled;
 
 	kvm_vmx->pkg_therm.msr_ia32_hfi_cfg = data;
 	kvm_vmx_hfi->hfi_enabled = hfi_enabled;
+	kvm_vmx_hfi->itd_enabled = itd_enabled;
+
+	if (!hfi_changed && !itd_changed)
+		return 0;
+
+	/*
+	 * Refer to SDM, vol. 3B, Table 15-10. IA32_HW_FEEDBACK_CONFIG
+	 * Control Option.
+	 */
+
+	/* Invalid option; quietly ignored by the hardware. */
+	if (!hfi_changed && itd_changed && !hfi_enabled && itd_enabled) {
+		/* No action (no update in the table). */
+		return 0;
+	}
 
-	if (!hfi_changed)
+	/* No action; keep HFI and Intel Thread Director disabled. */
+	if (!hfi_changed && itd_changed && !hfi_enabled && !itd_enabled) {
+		/* No action (no update in the table). */
 		return 0;
+	}
+
+	/* No action; keep HFI enabled. */
+	if (!hfi_changed && itd_changed && hfi_enabled && !itd_enabled) {
+		/* No action (no update in the table). */
+		return 0;
+	}
+
+	/* Disable HFI and Intel Thread Director whether ITD changed. */
+	if (hfi_changed && !hfi_enabled && itd_enabled) {
+		kvm_vmx_hfi->hfi_enabled = false;
+		kvm_vmx_hfi->itd_enabled = false;
+	}
 
 	if (!hfi_enabled) {
 		/*
@@ -3006,12 +3038,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_HFI))
 			return 1;
-		/*
-		 * Unsupported and reserved bits. ITD is not supported
-		 * (CPUID.06H:EAX[19]) yet.
-		 */
+		/* Unsupported bit: generate the exception. */
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_ITD) &&
+		    (data & HW_FEEDBACK_CONFIG_ITD_ENABLE))
+			return 1;
+		/* Reserved bits: generate the exception. */
 		if (!msr_info->host_initiated &&
-		    data & ~(HW_FEEDBACK_CONFIG_HFI_ENABLE))
+		    data & ~(HW_FEEDBACK_CONFIG_HFI_ENABLE | HW_FEEDBACK_CONFIG_ITD_ENABLE))
 			return 1;
 
 		mutex_lock(&kvm_vmx->pkg_therm.pkg_therm_lock);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d9db8bf3726f..0ef767d63def 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -377,6 +377,8 @@ struct vcpu_vmx {
  * struct hfi_desc - Representation of an HFI instance (i.e., a table)
  * @hfi_enabled:	Flag to indicate whether HFI is enabled at runtime.
  *			Parsed from the Guest's MSR_IA32_HW_FEEDBACK_CONFIG.
+ * @itd_enabled:	Flag to indicate whether ITD is enabled at runtime.
+ *			Parsed from the Guest's MSR_IA32_HW_FEEDBACK_CONFIG.
  * @hfi_int_enabled:	Flag to indicate whether HFI is enabled at runtime.
  *			Parsed from Guest's MSR_IA32_PACKAGE_THERM_INTERRUPT[bit 25].
  * @table_ptr_valid:	Flag to indicate whether the memory of Guest HFI table is ready.
@@ -407,6 +409,7 @@ struct vcpu_vmx {
 
 struct hfi_desc {
 	bool			hfi_enabled;
+	bool			itd_enabled;
 	bool			hfi_int_enabled;
 	bool			table_ptr_valid;
 	bool			hfi_update_status;
-- 
2.34.1


