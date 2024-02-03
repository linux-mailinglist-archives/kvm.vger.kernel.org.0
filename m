Return-Path: <kvm+bounces-7920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 503678484DF
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:09:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE52B1F2D07A
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C086A02E;
	Sat,  3 Feb 2024 09:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DzVSoMfb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4A369D13;
	Sat,  3 Feb 2024 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950925; cv=none; b=AwLNhj72iAIhsqSRXhsaN90kclGOSNqOqUzS7oMxgbozBlLcurp71rzGV3WLlcxzG23n9MPSevZtx8ibhIfhY2BjBsFonMS0zTYJRG2p11s7JzJQc6cfjJU7pd/WIcLQuHXXv2Nz8V0qkroD7GGLtwSjr805RFbHvBfKyfhdpuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950925; c=relaxed/simple;
	bh=21uhPX23ysNrQvndgnEhnvqGKaQ2s2imIgrPnztL+CI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tbisdWhYpo/Oevm3QXvhOVqrGTazJ9NM7/t7WcQVe+inAOm4Tu/y/hAsXuafwYHXvmjZJO30AdWg+/b0IZh3lKBOGiUZdyTjXOS3OHKnunb2oylz+26WSyaxYOMNLHDYYCQ/WH+IowupwGw/ciX79QvDwYGqdq1RokIpFGI+8Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DzVSoMfb; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950924; x=1738486924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=21uhPX23ysNrQvndgnEhnvqGKaQ2s2imIgrPnztL+CI=;
  b=DzVSoMfb791AXpZhnYNAhjGCRc3ErPY20TO5s1c0N71LCz9r1SLMTpfU
   VyztG9zb/RMyNOOoBZNboEtOqgCcZ80VFvyxn9IJNjuCyiW8RQ1sO+4qE
   iDEp1qYZfwfh2sy8mXv2WgHqKpIkuBbdieWRhIdv16Oh5fxpRcpn0oGOA
   bQ6mLiJgKqXGrYsoUjhzYqwVrniQh/XpfG8I+FhJmbWNNrCsnwqNNmuF8
   +4bI2zCzUAoRzbxTfWKerIMX+IRXFW9/MBrw7xmWsvSC+auR45ZXZ0D0i
   B9zmyvCOtaH4xO4FoL68osS4TUjXmQL/edcK4xar8ZvnNaDqdZQDVxcIZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132225"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132225"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:02:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291593"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:57 -0800
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
Subject: [RFC 24/26] KVM: VMX: Emulate the MSR of HRESET feature
Date: Sat,  3 Feb 2024 17:12:12 +0800
Message-Id: <20240203091214.411862-25-zhao1.liu@linux.intel.com>
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

HRESET is a feature associated with ITD, which provides an HRESET
instruction to reset the ITD related history accumulated on the current
logical processor it is executing on [1]. The HRESET instruction does
not cause the VMExit and is therefore available to the Guest by default
when the HRESET feature bit is set for the Guest.

The HRESET feature also provides a thread scope MSR to control the
enabling of the ITD history reset via the HRESET instruction [2]:
MSR_IA32_HW_HRESET_ENABLE.

This MSR can control the hardware, so we use the emulation way to
support it for Guest, and this makes the Guest's changes to the hardware
under the control of the Host.

Considering that there may be the difference between Guest and Host
about HRESET enabling status, we store the MSR_IA32_HW_HRESET_ENABLE
values of Host and Guest in vcpu_vmx and save/load their respective
configurations when Guest/Host switch.

[1]: SDM, vol. 3B, section 15.6.11 Logical Processor Scope History
[2]: SDM, vol. 2A, chap. CPUID--CPU Identification, CPUID.07H.01H.EAX
     [Bit 22], HRESET.

Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/vmx/vmx.c | 54 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  2 ++
 arch/x86/kvm/x86.c     |  1 +
 4 files changed, 58 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 980d93c70eb6..d847dd8eb193 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4295,6 +4295,7 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 	case MSR_IA32_PACKAGE_THERM_STATUS:
 	case MSR_IA32_HW_FEEDBACK_CONFIG:
 	case MSR_IA32_HW_FEEDBACK_PTR:
+	case MSR_IA32_HW_HRESET_ENABLE:
 		return false;
 	case MSR_IA32_SMBASE:
 		if (!IS_ENABLED(CONFIG_KVM_SMM))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 11d42e0a208b..2d733c959f32 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1314,6 +1314,35 @@ static void itd_guest_exit(struct vcpu_vmx *vmx)
 	wrmsrl(MSR_IA32_HW_FEEDBACK_THREAD_CONFIG, vcpu_hfi->host_thread_cfg);
 }
 
+static void hreset_guest_enter(struct vcpu_vmx *vmx)
+{
+	struct vcpu_hfi_desc *vcpu_hfi = &vmx->vcpu_hfi_desc;
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_HRESET) ||
+	    !guest_cpuid_has(&vmx->vcpu, X86_FEATURE_HRESET))
+		return;
+
+	rdmsrl(MSR_IA32_HW_HRESET_ENABLE, vcpu_hfi->host_hreset_enable);
+	if (unlikely(vcpu_hfi->host_hreset_enable != vcpu_hfi->guest_hreset_enable))
+		wrmsrl(MSR_IA32_HW_HRESET_ENABLE, vcpu_hfi->guest_hreset_enable);
+}
+
+static void hreset_guest_exit(struct vcpu_vmx *vmx)
+{
+	struct vcpu_hfi_desc *vcpu_hfi = &vmx->vcpu_hfi_desc;
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_HRESET) ||
+	    !guest_cpuid_has(&vmx->vcpu, X86_FEATURE_HRESET))
+		return;
+
+	/*
+	 * MSR_IA32_HW_HRESET_ENABLE is not passed through to Guest, so there
+	 * is no need to read the MSR to save the Guest's value.
+	 */
+	if (unlikely(vcpu_hfi->host_hreset_enable != vcpu_hfi->guest_hreset_enable))
+		wrmsrl(MSR_IA32_HW_HRESET_ENABLE, vcpu_hfi->host_hreset_enable);
+}
+
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 			unsigned long fs_base, unsigned long gs_base)
 {
@@ -2462,6 +2491,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = kvm_vmx->pkg_therm.msr_ia32_hfi_ptr;
 		break;
+	case MSR_IA32_HW_HRESET_ENABLE:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(&vmx->vcpu, X86_FEATURE_HRESET))
+			return 1;
+		msr_info->data = vmx->vcpu_hfi_desc.guest_hreset_enable;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -3091,6 +3126,21 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		ret = vmx_set_hfi_ptr_msr(vcpu, msr_info);
 		mutex_unlock(&kvm_vmx->pkg_therm.pkg_therm_lock);
 		break;
+	case MSR_IA32_HW_HRESET_ENABLE: {
+		struct kvm_cpuid_entry2 *entry;
+
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(&vmx->vcpu, X86_FEATURE_HRESET))
+			return 1;
+
+		entry = kvm_find_cpuid_entry_index(&vmx->vcpu, 0x20, 0);
+		/* Reserved bits: generate the exception. */
+		if (!msr_info->host_initiated && data & ~entry->ebx)
+			return 1;
+		/* hreset_guest_enter() will update MSR for Guest. */
+		vmx->vcpu_hfi_desc.guest_hreset_enable = data;
+		break;
+	}
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
@@ -5513,6 +5563,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->msr_ia32_therm_status = 0;
 	vmx->vcpu_hfi_desc.host_thread_cfg = 0;
 	vmx->vcpu_hfi_desc.guest_thread_cfg = 0;
+	vmx->vcpu_hfi_desc.host_hreset_enable = 0;
+	vmx->vcpu_hfi_desc.guest_hreset_enable = 0;
 
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
@@ -8006,6 +8058,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_enter(vmx);
 	itd_guest_enter(vmx);
+	hreset_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
 	if (intel_pmu_lbr_is_enabled(vcpu))
@@ -8044,6 +8097,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	loadsegment(es, __USER_DS);
 #endif
 
+	hreset_guest_exit(vmx);
 	itd_guest_exit(vmx);
 	pt_guest_exit(vmx);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 3d3238dd8fc3..c5b4684a5b51 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -74,6 +74,8 @@ struct pt_desc {
 struct vcpu_hfi_desc {
 	u64 host_thread_cfg;
 	u64 guest_thread_cfg;
+	u64 host_hreset_enable;
+	u64 guest_hreset_enable;
 };
 
 union vmx_exit_reason {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27bec359907c..04489efc2fb4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1552,6 +1552,7 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_PACKAGE_THERM_STATUS,
 	MSR_IA32_HW_FEEDBACK_CONFIG,
 	MSR_IA32_HW_FEEDBACK_PTR,
+	MSR_IA32_HW_HRESET_ENABLE,
 
 	/*
 	 * KVM always supports the "true" VMX control MSRs, even if the host
-- 
2.34.1


