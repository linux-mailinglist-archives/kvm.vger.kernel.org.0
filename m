Return-Path: <kvm+bounces-33356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A90EB9EA3CF
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:50:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAB08284630
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617721CB9F0;
	Tue, 10 Dec 2024 00:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AwNc39OY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA14A1C6F55;
	Tue, 10 Dec 2024 00:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791696; cv=none; b=B/XnDYieZhdjA7vLkiXhvQjSQovJT75jMUulAU1BCAKiNNy1XzDYNnfAessabTILt7SNS3lOEnSSu7KFFV8fwxRBqzW55bRhY9gjEDaffXW7RUyEkOHlcQGWo7fZUEP4Tcps6cyu7OOEkAaKeEM32cd09BtuojBHtJfoeBiLiFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791696; c=relaxed/simple;
	bh=TLv9MNhfqNUbqTDbMVPcnS18Mpe8c6Qa8beuTcU+HtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFbZzTnAA6WkwG1ATxXp9r4b4hBj9BMCUUlPoBrWf5ERtJthe78iRzJJvf9qLZKS7gzjjqT5t9gnZbRk6oNpAnxhD1uSWGEmxWveSMigvTVGNrJJUqQackuuriXooLkLfApQ1PExj/lZ9Qm+2CJHQ/4zArAWtRXoNcyI9nf72Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AwNc39OY; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791694; x=1765327694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TLv9MNhfqNUbqTDbMVPcnS18Mpe8c6Qa8beuTcU+HtM=;
  b=AwNc39OYPMWSGJI77HD/M3QAj3UCfiFzL4tOUv7p7hCN6gyc/fUW6C9G
   buADWmkZ2sFRqTQ+4GD5g3lclAi1jU4jmD0YDLChhhokIDzMZc2j0eUJg
   510AyNSlQ35N1US2WY9CfEh8ADyD7zXLFJiQ7rYfY9t0MSVifCAPSAg3e
   L0xNuTgJ0s77qKhhH9KN+F+wIDJ38UEKWoLGVhXFqOOV+hJnJYmufSP70
   c07tR+uu+AQc28ophgeKeBawcyaI8yTvo98TnEt/JtPjy6wY/weWADrU8
   L80b/dxOacOOwnPSCHKsbsn22Ep+rGXjyH+cCkc0K2Rm7DMs9QmQbqmxe
   g==;
X-CSE-ConnectionGUID: MTek+1kIQEOwZVNkU4Nv2w==
X-CSE-MsgGUID: GuzvO0KqTd+8E/4LCPLNCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793711"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793711"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:14 -0800
X-CSE-ConnectionGUID: dA49xAljT7qJ0/izZPr+Rw==
X-CSE-MsgGUID: 2bhwuea6QLeh676yhYt3uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033039"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:10 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 07/18] KVM: TDX: Implement callbacks for MSR operations
Date: Tue, 10 Dec 2024 08:49:33 +0800
Message-ID: <20241210004946.3718496-8-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add functions to implement MSR related callbacks, .set_msr(), .get_msr(),
and .has_emulated_msr(), for preparation of handling hypercalls from TDX
guest for para-virtualized RDMSR and WRMSR.  Ignore KVM_REQ_MSR_FILTER_CHANGED
for TDX.

There are three classes of MSRs virtualization for TDX.
- Non-configurable: TDX module directly virtualizes it. VMM can't configure
  it, the value set by KVM_SET_MSRS is ignored.
- Configurable: TDX module directly virtualizes it. VMM can configure at the
  VM creation time.  The value set by KVM_SET_MSRS is used.
- #VE case: TDX guest would issue TDG.VP.VMCALL<INSTRUCTION.{WRMSR,RDMSR}>
  and VMM handles the MSR hypercall. The value set by KVM_SET_MSRS is used.

For the MSRs belonging to the #VE case, the TDX module injects #VE to the
TDX guest upon RDMSR or WRMSR.  The exact list of such MSRs are defined in
TDX Module ABI Spec.

Upon #VE, the TDX guest may call TDG.VP.VMCALL<INSTRUCTION.{WRMSR,RDMSR}>,
which are defined in GHCI (Guest-Host Communication Interface) so that the
host VMM (e.g. KVM) can virtualize the MSRs.

TDX doesn't allow VMM to configure interception of MSR accesses.  Ignore
KVM_REQ_MSR_FILTER_CHANGED for TDX guest.  If the userspace has set any
MSR filters, it will be applied when handling
TDG.VP.VMCALL<INSTRUCTION.{WRMSR,RDMSR}> in a later patch.

Suggested-by: Sean Christopherson<seanjc@google.com>
Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu<binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu<binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini<pbonzini@redhat.com>
---
TDX "the rest" breakout:
- Renamed from "KVM: TDX: Implement callbacks for MSR operations for TDX"
  to "KVM: TDX: Implement callbacks for MSR operations"
- Update changelog.
- Remove the @write parameter of tdx_has_emulated_msr(), check whether the
  MSR is readonly or not in tdx_set_msr(). (Sean)
  https://lore.kernel.org/kvm/Zg1yPIV6cVJrwGxX@google.com/
- Change the code align with the patten "make the happy path the
  not-taken path". (Sean)
- Open code the handling for an emulated KVM MSR MSR_KVM_POLL_CONTROL,
  and let others go through the default statement. (Sean)
- Split macro KVM_MAX_MCE_BANKS move to a separate patch. (Sean)
- Add comments in vt_msr_filter_changed().
- Add Suggested-by tag.
---
 arch/x86/kvm/vmx/main.c    | 50 +++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c     | 67 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  6 ++++
 3 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index bfe848083eb9..a224e9d32701 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -191,6 +191,48 @@ static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	vmx_handle_exit_irqoff(vcpu);
 }
 
+static int vt_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_set_msr(vcpu, msr_info);
+
+	return vmx_set_msr(vcpu, msr_info);
+}
+
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool vt_has_emulated_msr(struct kvm *kvm, u32 index)
+{
+	if (kvm && is_td(kvm))
+		return tdx_has_emulated_msr(index);
+
+	return vmx_has_emulated_msr(kvm, index);
+}
+
+static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_get_msr(vcpu, msr_info);
+
+	return vmx_get_msr(vcpu, msr_info);
+}
+
+static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * TDX doesn't allow VMM to configure interception of MSR accesses.
+	 * TDX guest requests MSR accesses by calling TDVMCALL.  The MSR
+	 * filters will be applied when handling the TDVMCALL for RDMSR/WRMSR
+	 * if the userspace has set any.
+	 */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_msr_filter_changed(vcpu);
+}
+
 #ifdef CONFIG_KVM_SMM
 static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
@@ -510,7 +552,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.disable_virtualization_cpu = vt_disable_virtualization_cpu,
 	.emergency_disable_virtualization_cpu = vmx_emergency_disable_virtualization_cpu,
 
-	.has_emulated_msr = vmx_has_emulated_msr,
+	.has_emulated_msr = vt_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
 
@@ -529,8 +571,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_feature_msr = vmx_get_feature_msr,
-	.get_msr = vmx_get_msr,
-	.set_msr = vmx_set_msr,
+	.get_msr = vt_get_msr,
+	.set_msr = vt_set_msr,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
@@ -637,7 +679,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-	.msr_filter_changed = vmx_msr_filter_changed,
+	.msr_filter_changed = vt_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2b64652a0d05..770e3b847cd6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1984,6 +1984,73 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	*error_code = 0;
 }
 
+bool tdx_has_emulated_msr(u32 index)
+{
+	switch (index) {
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_ARCH_CAPABILITIES:
+	case MSR_IA32_POWER_CTL:
+	case MSR_IA32_CR_PAT:
+	case MSR_IA32_TSC_DEADLINE:
+	case MSR_IA32_MISC_ENABLE:
+	case MSR_PLATFORM_INFO:
+	case MSR_MISC_FEATURES_ENABLES:
+	case MSR_IA32_APICBASE:
+	case MSR_EFER:
+	case MSR_IA32_MCG_CAP:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MCG_CTL:
+	case MSR_IA32_MCG_EXT_CTL:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC, CTL2} */
+	case MSR_KVM_POLL_CONTROL:
+		return true;
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
+		/*
+		 * x2APIC registers that are virtualized by the CPU can't be
+		 * emulated, KVM doesn't have access to the virtual APIC page.
+		 */
+		switch (index) {
+		case X2APIC_MSR(APIC_TASKPRI):
+		case X2APIC_MSR(APIC_PROCPRI):
+		case X2APIC_MSR(APIC_EOI):
+		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
+		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
+		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
+			return false;
+		default:
+			return true;
+		}
+	default:
+		return false;
+	}
+}
+
+static bool tdx_is_read_only_msr(u32 index)
+{
+	return  index == MSR_IA32_APICBASE || index == MSR_EFER;
+}
+
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (!tdx_has_emulated_msr(msr->index))
+		return 1;
+
+	return kvm_get_msr_common(vcpu, msr);
+}
+
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (tdx_is_read_only_msr(msr->index))
+		return 1;
+
+	if (!tdx_has_emulated_msr(msr->index))
+		return 1;
+
+	return kvm_set_msr_common(vcpu, msr);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 28dbef77700c..7fb1bbf12b39 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -142,6 +142,9 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+bool tdx_has_emulated_msr(u32 index);
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -186,6 +189,9 @@ static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mo
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
+static inline bool tdx_has_emulated_msr(u32 index) { return false; }
+static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.46.0


