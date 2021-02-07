Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AB6312210
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 07:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBGG4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 01:56:38 -0500
Received: from mga07.intel.com ([134.134.136.100]:48437 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBGG4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 01:56:36 -0500
IronPort-SDR: BLtMSqoh8LQk+Z40nWUratjZuOzeKHBMjYat43YX22WNoC0wOwlIeI+hl+xpZaiUuvh0xwGgYy
 5VKo7XSS45uA==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="245660847"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="245660847"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 22:54:47 -0800
IronPort-SDR: QNpGHsFcbjbIys09fIlYtX6PuQI0VtLr4NvtouvrZloWounfBTZW3i880PR2At0TBYcnhkTPJr
 M75Ff+ZMDCjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="410376580"
Received: from vmmteam.bj.intel.com ([10.240.193.86])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2021 22:54:45 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: [PATCH RFC 2/7] kvm: x86: Introduce XFD MSRs as passthrough to guest
Date:   Sun,  7 Feb 2021 10:42:51 -0500
Message-Id: <20210207154256.52850-3-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210207154256.52850-1-jing2.liu@linux.intel.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

XFD feature introduces two new MSRs: IA32_XFD and IA32_XFD_ERR.
Each of the MSRs contains a state-component bitmap. XFD is enabled
for state component i if XCR0[i] = IA32_XFD[i] = 1. When XFD is
enabled for a state component, any instruction that would access
that state component does not execute and instead generates an
device-not-available exception (#NM). IA32_XFD_ERR is for
indicating which state causes the #NM event.

The MSRs are per task and need be context switched between host
and guest, and also between tasks inside guest just as native.
Passthrough both MSRs to let guest access and write without
vmexit. Add two slots for XFD MSRs as desired passthrough MSRs.

Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  6 +++++-
 arch/x86/kvm/x86.c     |  6 ++++++
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 47b8357b9751..7fa54e78c45c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -162,6 +162,8 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_IA32_SYSENTER_CS,
 	MSR_IA32_SYSENTER_ESP,
 	MSR_IA32_SYSENTER_EIP,
+	MSR_IA32_XFD,
+	MSR_IA32_XFD_ERR,
 	MSR_CORE_C1_RES,
 	MSR_CORE_C3_RESIDENCY,
 	MSR_CORE_C6_RESIDENCY,
@@ -1824,6 +1826,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vmx->msr_ia32_umwait_control;
 		break;
+	case MSR_IA32_XFD:
+		if (!msr_info->host_initiated)
+			return 1;
+
+		msr_info->data = vmx->msr_ia32_xfd;
+		break;
+	case MSR_IA32_XFD_ERR:
+		if (!msr_info->host_initiated)
+			return 1;
+
+		msr_info->data = vmx->msr_ia32_xfd_err;
+		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -2026,6 +2040,20 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vmx->msr_ia32_umwait_control = data;
 		break;
+	case MSR_IA32_XFD:
+		if (!msr_info->host_initiated)
+			return 1;
+
+		vmx->msr_ia32_xfd = data;
+		break;
+	case MSR_IA32_XFD_ERR:
+		if (!msr_info->host_initiated)
+			return 1;
+		if (data)
+			break;
+
+		vmx->msr_ia32_xfd_err = data;
+		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
@@ -7219,6 +7247,12 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_update_intercept_xfd(struct kvm_vcpu *vcpu)
+{
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD, MSR_TYPE_RW, false);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_RW, false);
+}
+
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7249,6 +7283,10 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
 		update_intel_pt_cfg(vcpu);
 
+	if (boot_cpu_has(X86_FEATURE_XFD) &&
+			guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		vmx_update_intercept_xfd(vcpu);
+
 	if (boot_cpu_has(X86_FEATURE_RTM)) {
 		struct vmx_uret_msr *msr;
 		msr = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f6f66e5c6510..d487f5a53a08 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -281,11 +281,15 @@ struct vcpu_vmx {
 	struct pt_desc pt_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	13
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	15
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 	} shadow_msr_intercept;
+
+	/* eXtended Feature Disabling (XFD) MSRs */
+	u64 msr_ia32_xfd;
+	u64 msr_ia32_xfd_err;
 };
 
 enum ept_pointers_status {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 93b5bacad67a..9ca8b1e58afa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1213,6 +1213,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_RTIT_ADDR2_A, MSR_IA32_RTIT_ADDR2_B,
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
 	MSR_IA32_UMWAIT_CONTROL,
+	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
@@ -5744,6 +5745,11 @@ static void kvm_init_msr_list(void)
 			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
 				continue;
 			break;
+		case MSR_IA32_XFD:
+		case MSR_IA32_XFD_ERR:
+			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
+				continue;
+			break;
 		case MSR_IA32_RTIT_CTL:
 		case MSR_IA32_RTIT_STATUS:
 			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT))
-- 
2.18.4

