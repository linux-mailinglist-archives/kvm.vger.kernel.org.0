Return-Path: <kvm+bounces-7098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D71DD83D668
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:33:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DE5E1F2AE19
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4276C13D4E9;
	Fri, 26 Jan 2024 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djQPfYGy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B67813BEB9;
	Fri, 26 Jan 2024 08:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259393; cv=none; b=X5B+b+H++lJYLbVeRjyjdg026tKxEB8m4x1or3MC9f3nTrsDWDU4zycFL+SIlwju8cXpVW7EN+J9wcHx6KJAMXYbB5Hq3LibmK5ma+BO7Nv7uZpX9TTpbsuKv8Xi9j4XOKIvp3IrcfMsEBh61odT/HkGcsb3F192HcUj+a0avO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259393; c=relaxed/simple;
	bh=nUkh1QjgR3qOr8GyFIRw1EGTod80FI2b8MTrj3AVrPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sphi1YwDdhRS70x2WWoivRZs2mQd6TMSHl0GAuSNPQ6/gpIr26zSIpXgYQbDEZEkeqXPjgnNrkdiVdRq8YYHNtNBCU0S9/VBPVhdkU3A8hEUy4TJ8NcGAiiHxr3LxDZkPnOKTdDXUBKFTj5oGYAZfUg7SbDuThJmDaNxke2VTGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=djQPfYGy; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259392; x=1737795392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nUkh1QjgR3qOr8GyFIRw1EGTod80FI2b8MTrj3AVrPA=;
  b=djQPfYGywnraJNuH20TJGeb0KiYs6zDsWZxqXggn9lzB06wndEZPcOUg
   kAdPUKb8pSL3ubj7Zw4ykjEbW69q2zwvIY6C/YjRf0b5V5xBRcuBe1Aie
   YfohMgNvTrHZmGo+zr/fH/Xbw/6WBitDkerUiUFUU9aJJ+PNOHR0P9jme
   m+jfi3zYU8sTBgtsRjW2FIIqMrhnJVMA+B/YGF4PlutnjXCH1ukXipCN0
   GtBhhZj/41nUmMVRx0t+9hYHYtd9q9dnY5PTUEHx7XiDS/DCGV3oXbrin
   vCJt0gMHlq4o21GQPhxbCQkEb0wwWMNlsYXfiZ6uyRDCeg0qEI+jnMI3t
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792208"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792208"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310004"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310004"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:56:26 -0800
From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	peterz@infradead.org,
	mizhang@google.com,
	kan.liang@intel.com,
	zhenyuw@linux.intel.com,
	dapeng1.mi@linux.intel.com,
	jmattson@google.com
Cc: kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com,
	eranian@google.com,
	irogers@google.com,
	samantha.alt@intel.com,
	like.xu.linux@gmail.com,
	chao.gao@intel.com,
	xiong.y.zhang@linux.intel.com,
	Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [RFC PATCH 11/41] KVM: x86/pmu: Introduce enable_passthrough_pmu module parameter and propage to KVM instance
Date: Fri, 26 Jan 2024 16:54:14 +0800
Message-Id: <20240126085444.324918-12-xiong.y.zhang@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mingwei Zhang <mizhang@google.com>

Introduce enable_passthrough_pmu as a RO KVM kernel module parameter. This
variable is true only when the following conditions satisfies:
 - set to true when module loaded.
 - enable_pmu is true.
 - is running on Intel CPU.
 - supports PerfMon v4.
 - host PMU supports passthrough mode.

The value is always read-only because passthrough PMU currently does not
support features like LBR and PEBS, while emualted PMU does. This will end
up with two different values for kvm_cap.supported_perf_cap, which is
initialized at module load time. Maintaining two different perf
capabilities will add complexity. Further, there is not enough motivation
to support running two types of PMU implementations at the same time,
although it is possible/feasible in reality.

Finally, always propagate enable_passthrough_pmu and perf_capabilities into
kvm->arch for each KVM instance.

Co-developed-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.h              | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  5 +++--
 arch/x86/kvm/x86.c              |  9 +++++++++
 arch/x86/kvm/x86.h              |  1 +
 5 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d7036982332e..f2e73e6830a3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1371,6 +1371,7 @@ struct kvm_arch {
 
 	bool bus_lock_detection_enabled;
 	bool enable_pmu;
+	bool enable_passthrough_pmu;
 
 	u32 notify_window;
 	u32 notify_vmexit_flags;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 1d64113de488..51011603c799 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -208,6 +208,20 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 			enable_pmu = false;
 	}
 
+	/* Pass-through vPMU is only supported in Intel CPUs. */
+	if (!is_intel)
+		enable_passthrough_pmu = false;
+
+	/*
+	 * Pass-through vPMU requires at least PerfMon version 4 because the
+	 * implementation requires the usage of MSR_CORE_PERF_GLOBAL_STATUS_SET
+	 * for counter emulation as well as PMU context switch.  In addition, it
+	 * requires host PMU support on passthrough mode. Disable pass-through
+	 * vPMU if any condition fails.
+	 */
+	if (!enable_pmu || kvm_pmu_cap.version < 4 || !kvm_pmu_cap.passthrough)
+		enable_passthrough_pmu = false;
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be20a60047b1..e4610b80e519 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7835,13 +7835,14 @@ static u64 vmx_get_perf_capabilities(void)
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
 
-	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
+	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
+	    !enable_passthrough_pmu) {
 		x86_perf_get_lbr(&lbr);
 		if (lbr.nr)
 			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
 	}
 
-	if (vmx_pebs_supported()) {
+	if (vmx_pebs_supported() && !enable_passthrough_pmu) {
 		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
 		if ((perf_cap & PERF_CAP_PEBS_FORMAT) < 4)
 			perf_cap &= ~PERF_CAP_PEBS_BASELINE;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4432e736129f..074452aa700d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -193,6 +193,11 @@ bool __read_mostly enable_pmu = true;
 EXPORT_SYMBOL_GPL(enable_pmu);
 module_param(enable_pmu, bool, 0444);
 
+/* Enable/disable PMU virtualization */
+bool __read_mostly enable_passthrough_pmu = true;
+EXPORT_SYMBOL_GPL(enable_passthrough_pmu);
+module_param(enable_passthrough_pmu, bool, 0444);
+
 bool __read_mostly eager_page_split = true;
 module_param(eager_page_split, bool, 0644);
 
@@ -6553,6 +6558,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_lock(&kvm->lock);
 		if (!kvm->created_vcpus) {
 			kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
+			/* Disable passthrough PMU if enable_pmu is false. */
+			if (!kvm->arch.enable_pmu)
+				kvm->arch.enable_passthrough_pmu = false;
 			r = 0;
 		}
 		mutex_unlock(&kvm->lock);
@@ -12480,6 +12488,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
 	kvm->arch.guest_can_read_msr_platform_info = true;
 	kvm->arch.enable_pmu = enable_pmu;
+	kvm->arch.enable_passthrough_pmu = enable_passthrough_pmu;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 5184fde1dc54..38b73e98eae9 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -329,6 +329,7 @@ extern u64 host_arch_capabilities;
 extern struct kvm_caps kvm_caps;
 
 extern bool enable_pmu;
+extern bool enable_passthrough_pmu;
 
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
-- 
2.34.1


