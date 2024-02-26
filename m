Return-Path: <kvm+bounces-9732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77ABB866D7C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:04:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31E25285474
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCA012B144;
	Mon, 26 Feb 2024 08:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U1Cz3jTU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5602D1292DA;
	Mon, 26 Feb 2024 08:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936148; cv=none; b=a/YsmOn8nEzs+eSNflavLkI+eSSY9Tr8VUXGntD72ejrJc3eDI2cl1v+mg0QuiFY/Pdeh7OFPUvMxDmFuAAmpOOlaX1snbLYiXBr1mv9MaWizXjQwEGo5o/W6Vyx9WFQYxtMVrMDSzRtdDnW6PBIX8rLC/WTXAfhE4ATwUwO6Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936148; c=relaxed/simple;
	bh=iLKBzkaZ2x4CHI/IAJCoPiQoXu/6vbCP7L7Yic/bYOw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n82SATvrcv0RvVPDScS/m0ZRxVswKKmNMATSiBHiajF7ryMdKM7n1AR2L7hR7AGX6izPK6p6aQdv4dbjvAFcfumpIHbgjHtJ6if+97ngaR9POCfCQahpMBKq5amMlZAE2W/HN4eISi0S5NFz0Ryj/1HV6dv6P//rrroB3U52T7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U1Cz3jTU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936146; x=1740472146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iLKBzkaZ2x4CHI/IAJCoPiQoXu/6vbCP7L7Yic/bYOw=;
  b=U1Cz3jTUjgnNuhg1yJYijnV4hUVmUyhhU3r88mvz10roSxnMQ3TD9lMk
   Q1vR96ZJ79Yg6U7OUnOxzisCxp3cyToggRDufOlZcD8PSVgabXcr6kU9p
   E6Y1XUEpuVmu/ExXwbLEyU/UlfNbsXEO63WVYe1brBYZ122ZwfbtVkYkI
   zrZh2KeI7DuF+goB59WEoGIFh1X8JqDN/g4KrfhJ/wTno2Gyr9EHBYB4V
   TvQ6Jk8ys3ulFKosAUMyCyphQzjNiWbbrj0jJ4Hg9J37HZMdIn/2/kcJ4
   rsFZMVbaqU7KT11bjImXCFIvuL+FH0RWsARL3NOcnpik7UtW79D1fjI7i
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751330"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751330"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735065"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:04 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 108/130] KVM: TDX: Handle TDX PV HLT hypercall
Date: Mon, 26 Feb 2024 00:26:50 -0800
Message-Id: <c083430632ba9e80abd09bccd5609fb3cd9d9c63.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up TDX PV HLT hypercall to the KVM backend function.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- move tdvps_state_non_arch_check() to this patch

v18:
- drop buggy_hlt_workaround and use TDH.VP.RD(TD_VCPU_STATE_DETAILS)

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 26 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h |  4 ++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index eb68d6c148b6..a2caf2ae838c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -688,7 +688,18 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_has_pending_interrupt(vcpu);
+	bool ret = pi_has_pending_interrupt(vcpu);
+	union tdx_vcpu_state_details details;
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (ret || vcpu->arch.mp_state != KVM_MP_STATE_HALTED)
+		return true;
+
+	if (tdx->interrupt_disabled_hlt)
+		return false;
+
+	details.full = td_state_non_arch_read64(tdx, TD_VCPU_STATE_DETAILS_NON_ARCH);
+	return !!details.vmxip;
 }
 
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -1130,6 +1141,17 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	/* See tdx_protected_apic_has_interrupt() to avoid heavy seamcall */
+	tdx->interrupt_disabled_hlt = tdvmcall_a0_read(vcpu);
+
+	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
+	return kvm_emulate_halt_noskip(vcpu);
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1138,6 +1160,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 	switch (tdvmcall_leaf(vcpu)) {
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
+	case EXIT_REASON_HLT:
+		return tdx_emulate_hlt(vcpu);
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 4399d474764f..11c74c34555f 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -104,6 +104,8 @@ struct vcpu_tdx {
 	bool host_state_need_restore;
 	u64 msr_host_kernel_gs_base;
 
+	bool interrupt_disabled_hlt;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
@@ -166,6 +168,7 @@ static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
 }
 
 static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
+static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
 
 #define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
 static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
@@ -226,6 +229,7 @@ TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
 
 TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
+TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
 
 static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
 {
-- 
2.25.1


