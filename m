Return-Path: <kvm+bounces-7115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98AB283D6B2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25F1A1F2E901
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:43:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD2514AD2E;
	Fri, 26 Jan 2024 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hzDtdLuM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C381814AD17;
	Fri, 26 Jan 2024 08:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706259480; cv=none; b=gpYbhXY8W/niohkQ8M5/xeHDGCBTWVe+gevEk1w/k3OjrmBn4f8DflGyHC75bctCFwhDQtqD7ln+s7oDgstF68VH7eDhG3Cuidfxl8J3sfeJLq7z7ztXOZLoGLgfgpjPeuQMI0PsQFZ6noK4dpyHfGnN0EMFHAE0TX8jcroQpYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706259480; c=relaxed/simple;
	bh=Pl83DMZ20U/aWXgf0PpwHCQnMJZPTtvWBj5drnp1+m8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tPK5FkkTHzjFgyMU2yPZWQ1mdJth3hEzWvp5rMIkBewE+RZAFyBzQtfDKHVPJgyLmf+KzH4+ZwFGw5oJK6cLVSzxkFtNDsIC3Yt1hhutokfPHnYDNaMefyARN1Ljuc7kSbKyPF4jQC2McLSabxCnu2pxBwxK/uvDU85IM6GX2xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hzDtdLuM; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706259479; x=1737795479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pl83DMZ20U/aWXgf0PpwHCQnMJZPTtvWBj5drnp1+m8=;
  b=hzDtdLuMFYG/b2DWLZbkcouV6c12uzZusBe3TzIUZXebtmjG+pdMoXl3
   NeCPRXYNQREhs0tBh3OR0Epc0XIvcl4AbQ5UhpDIsgysVdF3qqUBUMxLX
   PXl82S4n4WlVtvFsogNocfrkJ/tyaBjyjKLa4IVH6wUdxVKdUgHPzwSF0
   ANTvqnPSfAi9yPrA+f1VHx3lprCFeG7fGWIuf588g1vS3Mn+BmJVQqxVk
   pQ6qDRRvJKDNklAq6DCb0KKLAyEY3pnhN7RknEeDfNDhuExBOLooye7Y2
   4o+w3LK2RJaE2JsIpRpbEVpT/v1pfspMKED6Kot7xMU4bjWc3zQwWhRw+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9792783"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9792783"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930310306"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930310306"
Received: from yanli3-mobl.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.254.213.178])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 00:57:52 -0800
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
Subject: [RFC PATCH 28/41] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL at VM boundary
Date: Fri, 26 Jan 2024 16:54:31 +0800
Message-Id: <20240126085444.324918-29-xiong.y.zhang@linux.intel.com>
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

From: Xiong Zhang <xiong.y.zhang@intel.com>

In PMU passthrough mode, use global_ctrl field in struct kvm_pmu as the
cached value. This is convenient for KVM to set and get the value from the
host side. In addition, load and save the value across VM enter/exit
boundary in the following way:

 - At VM exit, if processor supports
   GUEST_VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL, read guest
   IA32_PERF_GLOBAL_CTRL GUEST_IA32_PERF_GLOBAL_CTRL VMCS field, else read
   it from VM-exit MSR-stroe array in VMCS. The value is then assigned to
   global_ctrl.

 - At VM Entry, if processor supports
   GUEST_VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL, read guest
   IA32_PERF_GLOBAL_CTRL from GUEST_IA32_PERF_GLOBAL_CTRL VMCS field, else
   read it from VM-entry MSR-load array in VMCS. The value is then
   assigned to global ctrl.

Implement the above logic into two helper functions and invoke them around
VM Enter/exit boundary.

Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 51 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 50100954cd92..a9623351eafe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7193,7 +7193,7 @@ static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
 }
 
-static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
+static void __atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 {
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
@@ -7216,6 +7216,52 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
+static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
+	int i;
+
+	if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL) {
+		pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
+	} else {
+		i = vmx_find_loadstore_msr_slot(&vmx->msr_autostore.guest,
+						MSR_CORE_PERF_GLOBAL_CTRL);
+		if (i < 0)
+			return;
+		pmu->global_ctrl = vmx->msr_autostore.guest.val[i].value;
+	}
+}
+
+static void load_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
+{
+	u64 global_ctrl = vcpu_to_pmu(&vmx->vcpu)->global_ctrl;
+	int i;
+
+	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
+		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
+	} else {
+		i = vmx_find_loadstore_msr_slot(&vmx->msr_autoload.guest,
+						MSR_CORE_PERF_GLOBAL_CTRL);
+		if (i < 0)
+			return;
+
+		vmx->msr_autoload.guest.val[i].value = global_ctrl;
+	}
+}
+
+static void __atomic_switch_perf_msrs_in_passthrough_pmu(struct vcpu_vmx *vmx)
+{
+	load_perf_global_ctrl_in_passthrough_pmu(vmx);
+}
+
+static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
+{
+	if (is_passthrough_pmu_enabled(&vmx->vcpu))
+		__atomic_switch_perf_msrs_in_passthrough_pmu(vmx);
+	else
+		__atomic_switch_perf_msrs(vmx);
+}
+
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7314,6 +7360,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	vcpu->arch.cr2 = native_read_cr2();
 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
 
+	if (is_passthrough_pmu_enabled(vcpu))
+		save_perf_global_ctrl_in_passthrough_pmu(vmx);
+
 	vmx->idt_vectoring_info = 0;
 
 	vmx_enable_fb_clear(vmx);
-- 
2.34.1


