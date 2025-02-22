Return-Path: <kvm+bounces-38939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99796A404E0
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E49016D72D
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB391F239B;
	Sat, 22 Feb 2025 01:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NaPjx6r4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0870F1D88B4;
	Sat, 22 Feb 2025 01:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188788; cv=none; b=TWh9RXjdukmUooooLGsYtw63387ms1VabgHDgLgpBaVUsYyQigWEFr+z86j7JXsKuNXLZR/OYg5LJfsmiPyRz+raRF2Q5YBlRpOHd31/M4wuCfDa0qX9jHy+eTVJoaLa7/IsaXzNfJ40qajRMoiJkE9ynMEMqsto6nIPYekNybA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188788; c=relaxed/simple;
	bh=5QUr1xCUtphfHspsHxDBWS5ZXChq2CrqSbUbLlVQwUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRsxUmsLMmqfNjg9tIQNu9ll7Wb+eZjfs0J9h+zbXmi7Hs6vY6bUkD2UgxPXUjrZZjwEJ38q6PmT91DNQuWRd+zFfR5c3M0Tks48Tg2/YCnk7byRjCz67Xu4gZmmjAVTR6GmKGPVdqjZZCele5gw0sxueqnVnDyypWnOEIjy5Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NaPjx6r4; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188787; x=1771724787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5QUr1xCUtphfHspsHxDBWS5ZXChq2CrqSbUbLlVQwUo=;
  b=NaPjx6r4OolbWgb/VFHNKAImZt11up+vD2qzwEK56/Ja6jm0XawtyNDg
   SqW9De061HKQLkusN3Ah+XpQzW6+trF7K3lcR6wfcF3W3ZBKqYEFV015p
   msrPK0JTF8L4NHU4x8nMNnZhWyr4+FtPu4mRfz1fsdlbbCo4kR1jvTgT3
   VKrkJKz9HRzfkBWIvbILMLTArHPu71WWp3jxeiaEHc5v5TMza63l09GJv
   4Pl4zvEZ/cTRUA01VyVva+MFoj2P5/esJB5ltgA0zFPnyctnLc8lNK9pi
   Jo2SCWeVo+xsS6YsdUc2LBexUyZf9DmSMiQqmjwNcaQrpWKo52W0iTVnC
   Q==;
X-CSE-ConnectionGUID: AvPTkK0HQzSchRL7pqE+OA==
X-CSE-MsgGUID: 0OociRKVRW+n5BM19TK8TQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449008"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449008"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:27 -0800
X-CSE-ConnectionGUID: YtPcMkAdRM2U8fgveW2mWQ==
X-CSE-MsgGUID: azxOl+eUQveIdzIPSjJtoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621598"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:46:24 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v3 01/16] KVM: TDX: Add support for find pending IRQ in a protected local APIC
Date: Sat, 22 Feb 2025 09:47:42 +0800
Message-ID: <20250222014757.897978-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Add flag and hook to KVM's local APIC management to support determining
whether or not a TDX guest has a pending IRQ.  For TDX vCPUs, the virtual
APIC page is owned by the TDX module and cannot be accessed by KVM.  As a
result, registers that are virtualized by the CPU, e.g. PPR, cannot be
read or written by KVM.  To deliver interrupts for TDX guests, KVM must
send an IRQ to the CPU on the posted interrupt notification vector.  And
to determine if TDX vCPU has a pending interrupt, KVM must check if there
is an outstanding notification.

Return "no interrupt" in kvm_apic_has_interrupt() if the guest APIC is
protected to short-circuit the various other flows that try to pull an
IRQ out of the vAPIC, the only valid operation is querying _if_ an IRQ is
pending, KVM can't do anything based on _which_ IRQ is pending.

Intentionally omit sanity checks from other flows, e.g. PPR update, so as
not to degrade non-TDX guests with unnecessary checks.  A well-behaved KVM
and userspace will never reach those flows for TDX guests, but reaching
them is not fatal if something does go awry.

For the TD exits not due to HLT TDCALL, skip checking RVI pending in
tdx_protected_apic_has_interrupt().  Except for the guest being stupid
(e.g., non-HLT TDCALL in an interrupt shadow), it's not even possible to
have an interrupt in RVI that is fully unmasked.  There is no any CPU flows
that modify RVI in the middle of instruction execution.  I.e. if RVI is
non-zero, then either the interrupt has been pending since before the TD
exit, or the instruction caused the TD exit is in an STI/SS shadow.  KVM
doesn't care about STI/SS shadows outside of the HALTED case.  And if the
interrupt was pending before TD exit, then it _must_ be blocked, otherwise
the interrupt would have been serviced at the instruction boundary.

For the HLT TDCALL case, it will be handled in a future patch when HLT
TDCALL is supported.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v3:
 - Updated the changelog about skipping checking pending RVI for non
   halted cases.
 - Replace static_call(kvm_x86_protected_apic_has_interrupt)(v) with
   kvm_x86_call(protected_apic_has_interrupt)(v).

TDX interrupts v2:
 - Fix a typo in changelog.

TDX interrupts v1:
 - Dropped vt_protected_apic_has_interrupt() with KVM_BUG_ON(), wire in
   tdx_protected_apic_has_interrupt() directly. (Rick)
 - Add {} on else in vt_hardware_setup()
---
 arch/x86/include/asm/kvm-x86-ops.h | 1 +
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/irq.c                 | 3 +++
 arch/x86/kvm/lapic.c               | 3 +++
 arch/x86/kvm/lapic.h               | 2 ++
 arch/x86/kvm/vmx/main.c            | 1 +
 arch/x86/kvm/vmx/tdx.c             | 6 ++++++
 arch/x86/kvm/vmx/x86_ops.h         | 2 ++
 8 files changed, 19 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e9e4cecd6897..50cf27473ffb 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -116,6 +116,7 @@ KVM_X86_OP_OPTIONAL(pi_start_assignment)
 KVM_X86_OP_OPTIONAL(apicv_pre_state_restore)
 KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
 KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
+KVM_X86_OP_OPTIONAL(protected_apic_has_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
 KVM_X86_OP_OPTIONAL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a08ff1c7a806..089cf2c82414 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1840,6 +1840,7 @@ struct kvm_x86_ops {
 	void (*apicv_pre_state_restore)(struct kvm_vcpu *vcpu);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
+	bool (*protected_apic_has_interrupt)(struct kvm_vcpu *vcpu);
 
 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			    bool *expired);
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 63f66c51975a..97d68d837929 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -100,6 +100,9 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 	if (kvm_cpu_has_extint(v))
 		return 1;
 
+	if (lapic_in_kernel(v) && v->arch.apic->guest_apic_protected)
+		return kvm_x86_call(protected_apic_has_interrupt)(v);
+
 	return kvm_apic_has_interrupt(v) != -1;	/* LAPIC */
 }
 EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a1cbca31ec30..bbdede07d063 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2967,6 +2967,9 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_present(vcpu))
 		return -1;
 
+	if (apic->guest_apic_protected)
+		return -1;
+
 	__apic_update_ppr(apic, &ppr);
 	return apic_has_interrupt_for_ppr(apic, ppr);
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1a8553ebdb42..e33c969439f7 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -65,6 +65,8 @@ struct kvm_lapic {
 	bool sw_enabled;
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
+	/* Select registers in the vAPIC cannot be read/written. */
+	bool guest_apic_protected;
 	/* Number of bits set in ISR. */
 	s16 isr_count;
 	/* The highest vector set in ISR; if -1 - invalid, must scan ISR. */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 75fd11ae6481..42a62be9a035 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -62,6 +62,7 @@ static __init int vt_hardware_setup(void)
 		vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
 		vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 		vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
+		vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c023e99de294..fdc8732ba7a3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -663,6 +663,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
+	vcpu->arch.apic->guest_apic_protected = true;
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
@@ -704,6 +705,11 @@ void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	local_irq_enable();
 }
 
+bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	return pi_has_pending_interrupt(vcpu);
+}
+
 /*
  * Compared to vmx_prepare_switch_to_guest(), there is not much to do
  * as SEAMCALL/SEAMRET calls take care of most of save and restore.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index bc76f5b60b0e..9d2e76c5a5a7 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -136,6 +136,7 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
 fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
 void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
+bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
 int tdx_handle_exit(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion fastpath);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
@@ -174,6 +175,7 @@ static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediat
 }
 static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
+static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
 static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion fastpath) { return 0; }
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
-- 
2.46.0


