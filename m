Return-Path: <kvm+bounces-40436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB717A57376
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:21:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6131A3B676B
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EED258CD0;
	Fri,  7 Mar 2025 21:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TU+V6QX3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E42D256C92
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382467; cv=none; b=NHgYyuOZkG/CuAWJjlFCa2KU4sm8IhIpPC81IO39fSTzwI33lOHwarrTGhYTt1vkgtqz47eM8eZMqngAWk+WL97kk66undS/eeYdlxAHa5fciYkTSSdoTQQVOVAHfvyre97Qyb2jCmV7IqjGsLjaegPo46ME/gt+KQuWw6xo54k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382467; c=relaxed/simple;
	bh=uTyqx1sxtazmKt2p4mDk0GeDssCeAYZpMer2Qj4+rUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meozNh3VUhMepNzR5j2Tl8nFl8Vz/RTJ8GCBUxAh8Fg+HS4Ut/izatyi0ihrqe2UtoNkPm+/FGOohEXAhsG0BQ26YjMuFxKDL2alrP56OeIEPOtfQeuRi3yyHKLXaBMALzfQhk2JY9lItwPAufAsRm/BPBHwPdojU8XdgttoyGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TU+V6QX3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741382462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rHZOxdXgBidTgQK0o4CsircXD7H55ORCf+ekiVmiD8I=;
	b=TU+V6QX3w8LCVm0Meqho+G1mgYtnxqTw/zaTDzAYuBufjmqGqMgTwD3e/lph94XuOjq/q7
	oNHZgSyFc7QgO4g7qHUHWU+pg0SX7CX9b/J4RIOhkaHs1TZZF9zGxyskATRLi6U5dMKGsc
	toAJEee56W2pnJCm51XjIHuPd9uuXPA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-4BZBBau8NaSCKBlr2BlrSQ-1; Fri,
 07 Mar 2025 16:21:00 -0500
X-MC-Unique: 4BZBBau8NaSCKBlr2BlrSQ-1
X-Mimecast-MFC-AGG-ID: 4BZBBau8NaSCKBlr2BlrSQ_1741382459
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03EEB19560AB;
	Fri,  7 Mar 2025 21:20:59 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 85B531955DDE;
	Fri,  7 Mar 2025 21:20:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	adrian.hunter@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v3 02/10] KVM: VMX: Move common fields of struct vcpu_{vmx,tdx} to a struct
Date: Fri,  7 Mar 2025 16:20:44 -0500
Message-ID: <20250307212053.2948340-3-pbonzini@redhat.com>
In-Reply-To: <20250307212053.2948340-1-pbonzini@redhat.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Binbin Wu <binbin.wu@linux.intel.com>

Move common fields of struct vcpu_vmx and struct vcpu_tdx to struct
vcpu_vt, to share the code between VMX/TDX as much as possible and to make
TDX exit handling more VMX like.

No functional change intended.

[Adrian: move code that depends on struct vcpu_vmx back to vmx.h]

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/Z1suNzg2Or743a7e@google.com
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Message-ID: <20250129095902.16391-5-adrian.hunter@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/common.h      |  68 +++++++++++++++++++++
 arch/x86/kvm/vmx/main.c        |   4 ++
 arch/x86/kvm/vmx/nested.c      |  10 ++--
 arch/x86/kvm/vmx/posted_intr.c |  18 +++---
 arch/x86/kvm/vmx/tdx.h         |  16 +----
 arch/x86/kvm/vmx/vmx.c         |  99 +++++++++++++++----------------
 arch/x86/kvm/vmx/vmx.h         | 104 +++++++++++++--------------------
 7 files changed, 178 insertions(+), 141 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 7a592467a044..a0b229d5ebb1 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -6,6 +6,74 @@
 
 #include "mmu.h"
 
+union vmx_exit_reason {
+	struct {
+		u32	basic			: 16;
+		u32	reserved16		: 1;
+		u32	reserved17		: 1;
+		u32	reserved18		: 1;
+		u32	reserved19		: 1;
+		u32	reserved20		: 1;
+		u32	reserved21		: 1;
+		u32	reserved22		: 1;
+		u32	reserved23		: 1;
+		u32	reserved24		: 1;
+		u32	reserved25		: 1;
+		u32	bus_lock_detected	: 1;
+		u32	enclave_mode		: 1;
+		u32	smi_pending_mtf		: 1;
+		u32	smi_from_vmx_root	: 1;
+		u32	reserved30		: 1;
+		u32	failed_vmentry		: 1;
+	};
+	u32 full;
+};
+
+struct vcpu_vt {
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+
+	union vmx_exit_reason exit_reason;
+
+	unsigned long	exit_qualification;
+	u32		exit_intr_info;
+
+	/*
+	 * If true, guest state has been loaded into hardware, and host state
+	 * saved into vcpu_{vt,vmx,tdx}.  If false, host state is loaded into
+	 * hardware.
+	 */
+	bool		guest_state_loaded;
+
+#ifdef CONFIG_X86_64
+	u64		msr_host_kernel_gs_base;
+#endif
+
+	unsigned long	host_debugctlmsr;
+};
+
+#ifdef CONFIG_KVM_INTEL_TDX
+
+static __always_inline bool is_td(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
+static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
+{
+	return is_td(vcpu->kvm);
+}
+
+#else
+
+static inline bool is_td(struct kvm *kvm) { return false; }
+static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
+
+#endif
+
 static inline bool vt_is_tdx_private_gpa(struct kvm *kvm, gpa_t gpa)
 {
 	/* For TDX the direct mask is the shared mask. */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ec8223ee9d28..36b6343a011e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,6 +10,10 @@
 #include "tdx.h"
 #include "tdx_arch.h"
 
+#ifdef CONFIG_KVM_INTEL_TDX
+static_assert(offsetof(struct vcpu_vmx, vt) == offsetof(struct vcpu_tdx, vt));
+#endif
+
 static void vt_disable_virtualization_cpu(void)
 {
 	/* Note, TDX *and* VMX need to be disabled if TDX is enabled. */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ed8a3cb53961..99f02972cd74 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -275,7 +275,7 @@ static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 {
 	struct vmcs_host_state *dest, *src;
 
-	if (unlikely(!vmx->guest_state_loaded))
+	if (unlikely(!vmx->vt.guest_state_loaded))
 		return;
 
 	src = &prev->host_state;
@@ -425,7 +425,7 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 		 * tables also changed, but KVM should not treat EPT Misconfig
 		 * VM-Exits as writes.
 		 */
-		WARN_ON_ONCE(vmx->exit_reason.basic != EXIT_REASON_EPT_VIOLATION);
+		WARN_ON_ONCE(vmx->vt.exit_reason.basic != EXIT_REASON_EPT_VIOLATION);
 
 		/*
 		 * PML Full and EPT Violation VM-Exits both use bit 12 to report
@@ -4622,7 +4622,7 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 {
 	/* update exit information fields: */
 	vmcs12->vm_exit_reason = vm_exit_reason;
-	if (to_vmx(vcpu)->exit_reason.enclave_mode)
+	if (vmx_get_exit_reason(vcpu).enclave_mode)
 		vmcs12->vm_exit_reason |= VMX_EXIT_REASONS_SGX_ENCLAVE_MODE;
 	vmcs12->exit_qualification = exit_qualification;
 
@@ -6126,7 +6126,7 @@ static int handle_vmfunc(struct kvm_vcpu *vcpu)
 	 * nested VM-Exit.  Pass the original exit reason, i.e. don't hardcode
 	 * EXIT_REASON_VMFUNC as the exit reason.
 	 */
-	nested_vmx_vmexit(vcpu, vmx->exit_reason.full,
+	nested_vmx_vmexit(vcpu, vmx->vt.exit_reason.full,
 			  vmx_get_intr_info(vcpu),
 			  vmx_get_exit_qual(vcpu));
 	return 1;
@@ -6571,7 +6571,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	union vmx_exit_reason exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx->vt.exit_reason;
 	unsigned long exit_qual;
 	u32 exit_intr_info;
 
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index ec08fa3caf43..5696e0f9f924 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -33,7 +33,7 @@ static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
-	return &(to_vmx(vcpu)->pi_desc);
+	return &(to_vt(vcpu)->pi_desc);
 }
 
 static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
@@ -53,7 +53,7 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 	struct pi_desc old, new;
 	unsigned long flags;
 	unsigned int dest;
@@ -90,7 +90,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
 		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
-		list_del(&vmx->pi_wakeup_list);
+		list_del(&vt->pi_wakeup_list);
 		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 	}
 
@@ -146,14 +146,14 @@ static bool vmx_can_use_vtd_pi(struct kvm *kvm)
 static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 	struct pi_desc old, new;
 	unsigned long flags;
 
 	local_irq_save(flags);
 
 	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
-	list_add_tail(&vmx->pi_wakeup_list,
+	list_add_tail(&vt->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
 	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
@@ -220,13 +220,13 @@ void pi_wakeup_handler(void)
 	int cpu = smp_processor_id();
 	struct list_head *wakeup_list = &per_cpu(wakeup_vcpus_on_cpu, cpu);
 	raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, cpu);
-	struct vcpu_vmx *vmx;
+	struct vcpu_vt *vt;
 
 	raw_spin_lock(spinlock);
-	list_for_each_entry(vmx, wakeup_list, pi_wakeup_list) {
+	list_for_each_entry(vt, wakeup_list, pi_wakeup_list) {
 
-		if (pi_test_on(&vmx->pi_desc))
-			kvm_vcpu_wake_up(&vmx->vcpu);
+		if (pi_test_on(&vt->pi_desc))
+			kvm_vcpu_wake_up(vt_to_vcpu(vt));
 	}
 	raw_spin_unlock(spinlock);
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index bba49ca74b17..11b3cc96c529 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -6,6 +6,8 @@
 #include "tdx_errno.h"
 
 #ifdef CONFIG_KVM_INTEL_TDX
+#include "common.h"
+
 int tdx_bringup(void);
 void tdx_cleanup(void);
 
@@ -44,6 +46,7 @@ enum vcpu_tdx_state {
 
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
+	struct vcpu_vt vt;
 
 	struct tdx_vp vp;
 
@@ -56,16 +59,6 @@ void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
 void tdh_vp_wr_failed(struct vcpu_tdx *tdx, char *uclass, char *op, u32 field,
 		      u64 val, u64 err);
 
-static inline bool is_td(struct kvm *kvm)
-{
-	return kvm->arch.vm_type == KVM_X86_TDX_VM;
-}
-
-static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
-{
-	return is_td(vcpu->kvm);
-}
-
 static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
 {
 	u64 err, data;
@@ -175,9 +168,6 @@ struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 };
 
-static inline bool is_td(struct kvm *kvm) { return false; }
-static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
-
 #endif
 
 #endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b71125a1b5cf..41479ca83ae7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1282,6 +1282,7 @@ void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 	struct vmcs_host_state *host_state;
 #ifdef CONFIG_X86_64
 	int cpu = raw_smp_processor_id();
@@ -1310,7 +1311,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (vmx->nested.need_vmcs12_to_shadow_sync)
 		nested_sync_vmcs12_to_shadow(vcpu);
 
-	if (vmx->guest_state_loaded)
+	if (vt->guest_state_loaded)
 		return;
 
 	host_state = &vmx->loaded_vmcs->host_state;
@@ -1331,12 +1332,12 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		fs_sel = current->thread.fsindex;
 		gs_sel = current->thread.gsindex;
 		fs_base = current->thread.fsbase;
-		vmx->msr_host_kernel_gs_base = current->thread.gsbase;
+		vt->msr_host_kernel_gs_base = current->thread.gsbase;
 	} else {
 		savesegment(fs, fs_sel);
 		savesegment(gs, gs_sel);
 		fs_base = read_msr(MSR_FS_BASE);
-		vmx->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
+		vt->msr_host_kernel_gs_base = read_msr(MSR_KERNEL_GS_BASE);
 	}
 
 	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
@@ -1348,14 +1349,14 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 #endif
 
 	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
-	vmx->guest_state_loaded = true;
+	vt->guest_state_loaded = true;
 }
 
 static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 {
 	struct vmcs_host_state *host_state;
 
-	if (!vmx->guest_state_loaded)
+	if (!vmx->vt.guest_state_loaded)
 		return;
 
 	host_state = &vmx->loaded_vmcs->host_state;
@@ -1383,10 +1384,10 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 #endif
 	invalidate_tss_limit();
 #ifdef CONFIG_X86_64
-	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
+	wrmsrl(MSR_KERNEL_GS_BASE, vmx->vt.msr_host_kernel_gs_base);
 #endif
 	load_fixmap_gdt(raw_smp_processor_id());
-	vmx->guest_state_loaded = false;
+	vmx->vt.guest_state_loaded = false;
 	vmx->guest_uret_msrs_loaded = false;
 }
 
@@ -1394,7 +1395,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
 {
 	preempt_disable();
-	if (vmx->guest_state_loaded)
+	if (vmx->vt.guest_state_loaded)
 		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
 	preempt_enable();
 	return vmx->msr_guest_kernel_gs_base;
@@ -1403,7 +1404,7 @@ static u64 vmx_read_guest_kernel_gs_base(struct vcpu_vmx *vmx)
 static void vmx_write_guest_kernel_gs_base(struct vcpu_vmx *vmx, u64 data)
 {
 	preempt_disable();
-	if (vmx->guest_state_loaded)
+	if (vmx->vt.guest_state_loaded)
 		wrmsrl(MSR_KERNEL_GS_BASE, data);
 	preempt_enable();
 	vmx->msr_guest_kernel_gs_base = data;
@@ -1524,7 +1525,7 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
-	vmx->host_debugctlmsr = get_debugctlmsr();
+	vmx->vt.host_debugctlmsr = get_debugctlmsr();
 }
 
 void vmx_vcpu_put(struct kvm_vcpu *vcpu)
@@ -1703,7 +1704,7 @@ int vmx_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 * so that guest userspace can't DoS the guest simply by triggering
 	 * emulation (enclaves are CPL3 only).
 	 */
-	if (to_vmx(vcpu)->exit_reason.enclave_mode) {
+	if (vmx_get_exit_reason(vcpu).enclave_mode) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return X86EMUL_PROPAGATE_FAULT;
 	}
@@ -1718,7 +1719,7 @@ int vmx_check_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 
 static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	union vmx_exit_reason exit_reason = to_vmx(vcpu)->exit_reason;
+	union vmx_exit_reason exit_reason = vmx_get_exit_reason(vcpu);
 	unsigned long rip, orig_rip;
 	u32 instr_len;
 
@@ -4277,7 +4278,7 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
  */
 static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 	int r;
 
 	r = vmx_deliver_nested_posted_interrupt(vcpu, vector);
@@ -4288,11 +4289,11 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	if (!vcpu->arch.apic->apicv_active)
 		return -1;
 
-	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
+	if (pi_test_and_set_pir(vector, &vt->pi_desc))
 		return 0;
 
 	/* If a previous notification has sent the IPI, nothing to do.  */
-	if (pi_test_and_set_on(&vmx->pi_desc))
+	if (pi_test_and_set_on(&vt->pi_desc))
 		return 0;
 
 	/*
@@ -4768,7 +4769,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write16(GUEST_INTR_STATUS, 0);
 
 		vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
-		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
+		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->vt.pi_desc)));
 	}
 
 	if (vmx_can_use_ipiv(&vmx->vcpu)) {
@@ -4881,8 +4882,8 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * Enforce invariant: pi_desc.nv is always either POSTED_INTR_VECTOR
 	 * or POSTED_INTR_WAKEUP_VECTOR.
 	 */
-	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
-	__pi_set_sn(&vmx->pi_desc);
+	vmx->vt.pi_desc.nv = POSTED_INTR_VECTOR;
+	__pi_set_sn(&vmx->vt.pi_desc);
 }
 
 void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -6068,7 +6069,7 @@ static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 	 * VM-Exits. Unconditionally set the flag here and leave the handling to
 	 * vmx_handle_exit().
 	 */
-	to_vmx(vcpu)->exit_reason.bus_lock_detected = true;
+	to_vt(vcpu)->exit_reason.bus_lock_detected = true;
 	return 1;
 }
 
@@ -6166,9 +6167,9 @@ void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	*reason = vmx->exit_reason.full;
+	*reason = vmx->vt.exit_reason.full;
 	*info1 = vmx_get_exit_qual(vcpu);
-	if (!(vmx->exit_reason.failed_vmentry)) {
+	if (!(vmx->vt.exit_reason.failed_vmentry)) {
 		*info2 = vmx->idt_vectoring_info;
 		*intr_info = vmx_get_intr_info(vcpu);
 		if (is_exception_with_error_code(*intr_info))
@@ -6464,7 +6465,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	union vmx_exit_reason exit_reason = vmx->exit_reason;
+	union vmx_exit_reason exit_reason = vmx_get_exit_reason(vcpu);
 	u32 vectoring_info = vmx->idt_vectoring_info;
 	u16 exit_handler_index;
 
@@ -6630,7 +6631,7 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * Exit to user space when bus lock detected to inform that there is
 	 * a bus lock in guest.
 	 */
-	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
+	if (vmx_get_exit_reason(vcpu).bus_lock_detected) {
 		if (ret > 0)
 			vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
 
@@ -6909,22 +6910,22 @@ static void vmx_set_rvi(int vector)
 
 int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 	int max_irr;
 	bool got_posted_interrupt;
 
 	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
 		return -EIO;
 
-	if (pi_test_on(&vmx->pi_desc)) {
-		pi_clear_on(&vmx->pi_desc);
+	if (pi_test_on(&vt->pi_desc)) {
+		pi_clear_on(&vt->pi_desc);
 		/*
 		 * IOMMU can write to PID.ON, so the barrier matters even on UP.
 		 * But on x86 this is just a compiler barrier anyway.
 		 */
 		smp_mb__after_atomic();
 		got_posted_interrupt =
-			kvm_apic_update_irr(vcpu, vmx->pi_desc.pir, &max_irr);
+			kvm_apic_update_irr(vcpu, vt->pi_desc.pir, &max_irr);
 	} else {
 		max_irr = kvm_lapic_find_highest_irr(vcpu);
 		got_posted_interrupt = false;
@@ -6966,10 +6967,10 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 
 void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_vt *vt = to_vt(vcpu);
 
-	pi_clear_on(&vmx->pi_desc);
-	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
+	pi_clear_on(&vt->pi_desc);
+	memset(vt->pi_desc.pir, 0, sizeof(vt->pi_desc.pir));
 }
 
 void vmx_do_interrupt_irqoff(unsigned long entry);
@@ -7034,9 +7035,9 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	if (vmx->emulation_required)
 		return;
 
-	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
+	if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXTERNAL_INTERRUPT)
 		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
-	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
+	else if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
 }
 
@@ -7267,10 +7268,10 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
 	 * the fastpath even, all other exits must use the slow path.
 	 */
 	if (is_guest_mode(vcpu) &&
-	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_PREEMPTION_TIMER)
+	    vmx_get_exit_reason(vcpu).basic != EXIT_REASON_PREEMPTION_TIMER)
 		return EXIT_FASTPATH_NONE;
 
-	switch (to_vmx(vcpu)->exit_reason.basic) {
+	switch (vmx_get_exit_reason(vcpu).basic) {
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_set_msr_irqoff(vcpu);
 	case EXIT_REASON_PREEMPTION_TIMER:
@@ -7317,15 +7318,15 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	vmx_enable_fb_clear(vmx);
 
 	if (unlikely(vmx->fail)) {
-		vmx->exit_reason.full = 0xdead;
+		vmx->vt.exit_reason.full = 0xdead;
 		goto out;
 	}
 
-	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
-	if (likely(!vmx->exit_reason.failed_vmentry))
+	vmx->vt.exit_reason.full = vmcs_read32(VM_EXIT_REASON);
+	if (likely(!vmx_get_exit_reason(vcpu).failed_vmentry))
 		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
-	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
+	if ((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXCEPTION_NMI &&
 	    is_nmi(vmx_get_intr_info(vcpu))) {
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 		if (cpu_feature_enabled(X86_FEATURE_FRED))
@@ -7357,12 +7358,12 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	if (unlikely(vmx->emulation_required)) {
 		vmx->fail = 0;
 
-		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
-		vmx->exit_reason.failed_vmentry = 1;
+		vmx->vt.exit_reason.full = EXIT_REASON_INVALID_STATE;
+		vmx->vt.exit_reason.failed_vmentry = 1;
 		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
-		vmx->exit_qualification = ENTRY_FAIL_DEFAULT;
+		vmx->vt.exit_qualification = ENTRY_FAIL_DEFAULT;
 		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2);
-		vmx->exit_intr_info = 0;
+		vmx->vt.exit_intr_info = 0;
 		return EXIT_FASTPATH_NONE;
 	}
 
@@ -7439,8 +7440,8 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	}
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
-	if (vmx->host_debugctlmsr)
-		update_debugctlmsr(vmx->host_debugctlmsr);
+	if (vmx->vt.host_debugctlmsr)
+		update_debugctlmsr(vmx->vt.host_debugctlmsr);
 
 #ifndef CONFIG_X86_64
 	/*
@@ -7465,7 +7466,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		 * checking.
 		 */
 		if (vmx->nested.nested_run_pending &&
-		    !vmx->exit_reason.failed_vmentry)
+		    !vmx_get_exit_reason(vcpu).failed_vmentry)
 			++vcpu->stat.nested_run;
 
 		vmx->nested.nested_run_pending = 0;
@@ -7474,12 +7475,12 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	if (unlikely(vmx->fail))
 		return EXIT_FASTPATH_NONE;
 
-	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
+	if (unlikely((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
 
-	if (unlikely(vmx->exit_reason.failed_vmentry))
+	if (unlikely(vmx_get_exit_reason(vcpu).failed_vmentry))
 		return EXIT_FASTPATH_NONE;
 
 	vmx->loaded_vmcs->launched = 1;
@@ -7511,7 +7512,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
 	vmx = to_vmx(vcpu);
 
-	INIT_LIST_HEAD(&vmx->pi_wakeup_list);
+	INIT_LIST_HEAD(&vmx->vt.pi_wakeup_list);
 
 	err = -ENOMEM;
 
@@ -7609,7 +7610,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	if (vmx_can_use_ipiv(vcpu))
 		WRITE_ONCE(to_kvm_vmx(vcpu->kvm)->pid_table[vcpu->vcpu_id],
-			   __pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
+			   __pa(&vmx->vt.pi_desc) | PID_TABLE_ENTRY_VALID);
 
 	return 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a58b940f0634..e635199901e2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -17,6 +17,7 @@
 #include "../cpuid.h"
 #include "run_flags.h"
 #include "../mmu.h"
+#include "common.h"
 
 #define X2APIC_MSR(r) (APIC_BASE_MSR + ((r) >> 4))
 
@@ -68,29 +69,6 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
-union vmx_exit_reason {
-	struct {
-		u32	basic			: 16;
-		u32	reserved16		: 1;
-		u32	reserved17		: 1;
-		u32	reserved18		: 1;
-		u32	reserved19		: 1;
-		u32	reserved20		: 1;
-		u32	reserved21		: 1;
-		u32	reserved22		: 1;
-		u32	reserved23		: 1;
-		u32	reserved24		: 1;
-		u32	reserved25		: 1;
-		u32	bus_lock_detected	: 1;
-		u32	enclave_mode		: 1;
-		u32	smi_pending_mtf		: 1;
-		u32	smi_from_vmx_root	: 1;
-		u32	reserved30		: 1;
-		u32	failed_vmentry		: 1;
-	};
-	u32 full;
-};
-
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -231,20 +209,10 @@ struct nested_vmx {
 
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
+	struct vcpu_vt	      vt;
 	u8                    fail;
 	u8		      x2apic_msr_bitmap_mode;
 
-	/*
-	 * If true, host state has been stored in vmx->loaded_vmcs for
-	 * the CPU registers that only need to be switched when transitioning
-	 * to/from the kernel, and the registers have been loaded with guest
-	 * values.  If false, host state is loaded in the CPU registers
-	 * and vmx->loaded_vmcs->host_state is invalid.
-	 */
-	bool		      guest_state_loaded;
-
-	unsigned long         exit_qualification;
-	u32                   exit_intr_info;
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 
@@ -257,7 +225,6 @@ struct vcpu_vmx {
 	struct vmx_uret_msr   guest_uret_msrs[MAX_NR_USER_RETURN_MSRS];
 	bool                  guest_uret_msrs_loaded;
 #ifdef CONFIG_X86_64
-	u64		      msr_host_kernel_gs_base;
 	u64		      msr_guest_kernel_gs_base;
 #endif
 
@@ -298,14 +265,6 @@ struct vcpu_vmx {
 	int vpid;
 	bool emulation_required;
 
-	union vmx_exit_reason exit_reason;
-
-	/* Posted interrupt descriptor */
-	struct pi_desc pi_desc;
-
-	/* Used if this vCPU is waiting for PI notification wakeup. */
-	struct list_head pi_wakeup_list;
-
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
 
@@ -323,8 +282,6 @@ struct vcpu_vmx {
 	/* apic deadline value in host tsc */
 	u64 hv_deadline_tsc;
 
-	unsigned long host_debugctlmsr;
-
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
 	 * msr_ia32_feature_control. FEAT_CTL_LOCKED is always included
@@ -361,6 +318,43 @@ struct kvm_vmx {
 	u64 *pid_table;
 };
 
+static __always_inline struct vcpu_vt *to_vt(struct kvm_vcpu *vcpu)
+{
+	return &(container_of(vcpu, struct vcpu_vmx, vcpu)->vt);
+}
+
+static __always_inline struct kvm_vcpu *vt_to_vcpu(struct vcpu_vt *vt)
+{
+	return &(container_of(vt, struct vcpu_vmx, vt)->vcpu);
+}
+
+static __always_inline union vmx_exit_reason vmx_get_exit_reason(struct kvm_vcpu *vcpu)
+{
+	return to_vt(vcpu)->exit_reason;
+}
+
+static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vt *vt = to_vt(vcpu);
+
+	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1) &&
+	    !WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		vt->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+
+	return vt->exit_qualification;
+}
+
+static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vt *vt = to_vt(vcpu);
+
+	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2) &&
+	    !WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		vt->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+
+	return vt->exit_intr_info;
+}
+
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 			struct loaded_vmcs *buddy);
 int allocate_vpid(void);
@@ -651,26 +645,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 
-static __always_inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1))
-		vmx->exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
-
-	return vmx->exit_qualification;
-}
-
-static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (!kvm_register_test_and_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2))
-		vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-
-	return vmx->exit_intr_info;
-}
-
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
-- 
2.43.5



