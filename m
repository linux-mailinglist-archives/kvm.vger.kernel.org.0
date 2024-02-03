Return-Path: <kvm+bounces-7918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 540D48484D9
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:08:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60B5EB2C1A1
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A484C657CA;
	Sat,  3 Feb 2024 09:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b4SN3Uwf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6276F64A8A;
	Sat,  3 Feb 2024 09:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706950914; cv=none; b=sqjqUygj4lTMP+PUMRBttjCLQu7AiJ94vCbtFL4mvniMmQrvhC2834emT5qUxPGbI5EBN3JQPu2bjoPmZQWAc61SfcSrYmrpgDDOI3Ho3DiFxD9xJ7VTURaMyg/E2LPSWM+CQRN+Ur4PqiF/7fRNNNQJgba5++9CucaJzFYs5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706950914; c=relaxed/simple;
	bh=mfaQaAeHONDag9Knpv31L0HoH9EOtHuJiJGnjNwXfx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n9eJVKYgwksXLUdKqUjbasO/nA8lzuC201BdNMnHMqoV6LyDfH6HSjx7/u9RxFeqFLLoVygY0Ig0EkMZWL0OOxZpfWI/LVxpqp7WrGkUPDzq5EJJJbw8AzLwrG4/aCx3+ZLLP+h5Z7icVEMYD3okJRdoOTmrFrkG387vlIH3RCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b4SN3Uwf; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706950914; x=1738486914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mfaQaAeHONDag9Knpv31L0HoH9EOtHuJiJGnjNwXfx8=;
  b=b4SN3Uwfa9pyvX5CZskGA5dxNc9TUZ3xrckWhgZOrJNfasgsl3QSEmcJ
   TFPK1IJRlrdxeQCgMcNY2fGq80/1mt19lO/484fsSmviQW4eoGdxTIqPz
   6Zc+/OlRkHB/MdXg3mV2Z2UNwyT8Nyym5ziBXKEyE6Qr76J6FDvwQbCka
   WKhcxpAXrxQ4ld0ZECHvL7Aqnsx7xhjERWab9heIQElDAYfe7N/VjFzg7
   5ArBxvw3G/JtccnfYgcHyaEh4zuEJ+myJ97+a8DyHr+TeSOf99HlrAIp6
   WgbEwohCFSYcg5NozVfWhFE/5ybAMJqinbDzvTX5D7g8Jq/pwhOTjiMSP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="4132157"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4132157"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:01:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="291560"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa009.fm.intel.com with ESMTP; 03 Feb 2024 01:01:46 -0800
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
Subject: [RFC 22/26] KVM: VMX: Pass through ITD classification related MSRs to Guest
Date: Sat,  3 Feb 2024 17:12:10 +0800
Message-Id: <20240203091214.411862-23-zhao1.liu@linux.intel.com>
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

ITD adds 2 new MSRs, MSR_IA32_HW_FEEDBACK_CHAR and
MSR_IA32_HW_FEEDBACK_THREAD_CONFIG, to allow OS to classify the running
task into one of four classes [1].

Pass through these 2 MSRs to Guest:

* MSR_IA32_HW_FEEDBACK_CHAR.

MSR_IA32_HW_FEEDBACK_CHAR is a thread scope MSR. It is used to specify
the class for the currently running workload,

* MSR_IA32_HW_FEEDBACK_THREAD_CONFIG.

MSR_IA32_HW_FEEDBACK_THREAD_CONFIG is also a thread scope MSR and is
used to control the enablement of the classification function.

[1]: SDM, vol. 3B, section 15.6.8 Logical Processor Scope Intel Thread
     Director Configuration

Suggested-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Co-developed-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhuocheng Ding <zhuocheng.ding@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 37 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  8 +++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bdff1d424b2f..11d42e0a208b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -225,6 +225,8 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_CORE_C3_RESIDENCY,
 	MSR_CORE_C6_RESIDENCY,
 	MSR_CORE_C7_RESIDENCY,
+	MSR_IA32_HW_FEEDBACK_THREAD_CONFIG,
+	MSR_IA32_HW_FEEDBACK_CHAR,
 };
 
 /*
@@ -1288,6 +1290,30 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 		wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 }
 
+static void itd_guest_enter(struct vcpu_vmx *vmx)
+{
+	struct vcpu_hfi_desc *vcpu_hfi = &vmx->vcpu_hfi_desc;
+
+	if (!guest_cpuid_has(&vmx->vcpu, X86_FEATURE_ITD) ||
+	    !kvm_cpu_cap_has(X86_FEATURE_ITD))
+		return;
+
+	rdmsrl(MSR_IA32_HW_FEEDBACK_THREAD_CONFIG, vcpu_hfi->host_thread_cfg);
+	wrmsrl(MSR_IA32_HW_FEEDBACK_THREAD_CONFIG, vcpu_hfi->guest_thread_cfg);
+}
+
+static void itd_guest_exit(struct vcpu_vmx *vmx)
+{
+	struct vcpu_hfi_desc *vcpu_hfi = &vmx->vcpu_hfi_desc;
+
+	if (!guest_cpuid_has(&vmx->vcpu, X86_FEATURE_ITD) ||
+	    !kvm_cpu_cap_has(X86_FEATURE_ITD))
+		return;
+
+	rdmsrl(MSR_IA32_HW_FEEDBACK_THREAD_CONFIG, vcpu_hfi->guest_thread_cfg);
+	wrmsrl(MSR_IA32_HW_FEEDBACK_THREAD_CONFIG, vcpu_hfi->host_thread_cfg);
+}
+
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 			unsigned long fs_base, unsigned long gs_base)
 {
@@ -5485,6 +5511,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmx->msr_ia32_therm_control = 0;
 	vmx->msr_ia32_therm_interrupt = 0;
 	vmx->msr_ia32_therm_status = 0;
+	vmx->vcpu_hfi_desc.host_thread_cfg = 0;
+	vmx->vcpu_hfi_desc.guest_thread_cfg = 0;
 
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
@@ -7977,6 +8005,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	kvm_load_guest_xsave_state(vcpu);
 
 	pt_guest_enter(vmx);
+	itd_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
 	if (intel_pmu_lbr_is_enabled(vcpu))
@@ -8015,6 +8044,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	loadsegment(es, __USER_DS);
 #endif
 
+	itd_guest_exit(vmx);
 	pt_guest_exit(vmx);
 
 	kvm_load_host_xsave_state(vcpu);
@@ -8475,6 +8505,13 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			vmx->hfi_table_idx = ((union cpuid6_edx)best->edx).split.index;
 	}
 
+	if (guest_cpuid_has(vcpu, X86_FEATURE_ITD) && kvm_cpu_cap_has(X86_FEATURE_ITD)) {
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_HW_FEEDBACK_THREAD_CONFIG,
+					  MSR_TYPE_RW, !guest_cpuid_has(vcpu, X86_FEATURE_ITD));
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_HW_FEEDBACK_CHAR,
+					  MSR_TYPE_RW, !guest_cpuid_has(vcpu, X86_FEATURE_ITD));
+	}
+
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 }
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0ef767d63def..3d3238dd8fc3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -71,6 +71,11 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+struct vcpu_hfi_desc {
+	u64 host_thread_cfg;
+	u64 guest_thread_cfg;
+};
+
 union vmx_exit_reason {
 	struct {
 		u32	basic			: 16;
@@ -286,6 +291,7 @@ struct vcpu_vmx {
 	u64		      msr_ia32_therm_control;
 	u64		      msr_ia32_therm_interrupt;
 	u64		      msr_ia32_therm_status;
+	struct vcpu_hfi_desc  vcpu_hfi_desc;
 
 	/*
 	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
@@ -366,7 +372,7 @@ struct vcpu_vmx {
 	int hfi_table_idx;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	18
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-- 
2.34.1


