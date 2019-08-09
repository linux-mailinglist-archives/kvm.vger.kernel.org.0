Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BD287F67
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437105AbfHIQQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:16:26 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52910 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436973AbfHIQPA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5E318305D355;
        Fri,  9 Aug 2019 19:01:28 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 40116305B7A5;
        Fri,  9 Aug 2019 19:01:27 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [RFC PATCH v6 64/92] kvm: introspection: add single-stepping
Date:   Fri,  9 Aug 2019 19:00:19 +0300
Message-Id: <20190809160047.8319-65-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This would be used either if the introspection tool request it as a
reply to a KVMI_EVENT_PF event or to cope with instructions that cannot
be handled by the x86 emulator during the handling of a VMEXIT. In
these situations, all other vCPU-s are kicked and held, the EPT-based
protection is removed and the guest is single stepped by the vCPU that
triggered the initial VMEXIT. Upon completion the EPT-base protection
is reinstalled and all vCPU-s all allowed to return to the guest.

This is a rather slow workaround that kicks in occasionally. In the
future, the most frequently single-stepped instructions should be added
to the emulator (usually, stores to and from memory - SSE/AVX).

For the moment it works only on Intel.

CC: Jim Mattson <jmattson@google.com>
CC: Sean Christopherson <sean.j.christopherson@intel.com>
CC: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/kvmi.c             |  47 ++++++++++-
 arch/x86/kvm/svm.c              |   5 ++
 arch/x86/kvm/vmx/vmx.c          |  17 ++++
 arch/x86/kvm/x86.c              |  19 +++++
 include/linux/kvmi.h            |   4 +
 virt/kvm/kvmi.c                 | 145 +++++++++++++++++++++++++++++++-
 virt/kvm/kvmi_int.h             |  16 ++++
 8 files changed, 253 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad36a5fc2048..60e2c298d469 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1016,6 +1016,7 @@ struct kvm_x86_ops {
 	void (*msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
 				bool enable);
 	bool (*desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
+	void (*set_mtf)(struct kvm_vcpu *vcpu, bool enable);
 	void (*cr3_write_exiting)(struct kvm_vcpu *vcpu, bool enable);
 	bool (*nested_pagefault)(struct kvm_vcpu *vcpu);
 	bool (*spt_fault)(struct kvm_vcpu *vcpu);
@@ -1628,6 +1629,8 @@ void kvm_arch_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
 				bool enable);
 bool kvm_mmu_nested_pagefault(struct kvm_vcpu *vcpu);
 bool kvm_spt_fault(struct kvm_vcpu *vcpu);
+void kvm_set_mtf(struct kvm_vcpu *vcpu, bool enable);
+void kvm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask);
 void kvm_control_cr3_write_exiting(struct kvm_vcpu *vcpu, bool enable);
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 04cac5b8a4d0..f0ab4bd9eb37 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -520,7 +520,6 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 	u32 ctx_size;
 	u64 ctx_addr;
 	u32 action;
-	bool singlestep_ignored;
 	bool ret = false;
 
 	if (!kvm_spt_fault(vcpu))
@@ -533,7 +532,7 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 	if (ivcpu->effective_rep_complete)
 		return true;
 
-	action = kvmi_msg_send_pf(vcpu, gpa, gva, access, &singlestep_ignored,
+	action = kvmi_msg_send_pf(vcpu, gpa, gva, access, &ivcpu->ss_requested,
 				  &ivcpu->rep_complete, &ctx_addr,
 				  ivcpu->ctx_data, &ctx_size);
 
@@ -547,6 +546,8 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 		ret = true;
 		break;
 	case KVMI_EVENT_ACTION_RETRY:
+		if (ivcpu->ss_requested && !kvmi_start_ss(vcpu, gpa, access))
+			ret = true;
 		break;
 	default:
 		kvmi_handle_common_event_actions(vcpu, action, "PF");
@@ -758,6 +759,48 @@ int kvmi_arch_cmd_control_cr(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+void kvmi_arch_start_single_step(struct kvm_vcpu *vcpu)
+{
+	kvm_set_mtf(vcpu, true);
+
+	/*
+	 * Set block by STI only if the RFLAGS.IF = 1.
+	 * Blocking by both STI and MOV/POP SS is not possible.
+	 */
+	if (kvm_arch_interrupt_allowed(vcpu))
+		kvm_set_interrupt_shadow(vcpu, KVM_X86_SHADOW_INT_STI);
+
+}
+
+void kvmi_arch_stop_single_step(struct kvm_vcpu *vcpu)
+{
+	kvm_set_mtf(vcpu, false);
+	/*
+	 * The blocking by STI is cleared after the guest
+	 * executes one instruction or incurs an exception.
+	 * However we migh stop the SS before entering to guest,
+	 * so be sure we are clearing the STI blocking.
+	 */
+	kvm_set_interrupt_shadow(vcpu, 0);
+}
+
+u8 kvmi_arch_relax_page_access(u8 old, u8 new)
+{
+	u8 ret = old | new;
+
+	/*
+	 * An SPTE entry with just the -wx bits set can trigger a
+	 * misconfiguration error from the hardware, as it's the case
+	 * for x86 where this access mode is used to mark I/O memory.
+	 * Thus, we make sure that -wx accesses are translated to rwx.
+	 */
+	if ((ret & (KVMI_PAGE_ACCESS_W | KVMI_PAGE_ACCESS_X)) ==
+	    (KVMI_PAGE_ACCESS_W | KVMI_PAGE_ACCESS_X))
+		ret |= KVMI_PAGE_ACCESS_R;
+
+	return ret;
+}
+
 static const struct {
 	unsigned int allow_bit;
 	enum kvm_page_track_mode track_mode;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b178b8900660..3481c0247680 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7183,6 +7183,10 @@ static bool svm_spt_fault(struct kvm_vcpu *vcpu)
 	return (svm->vmcb->control.exit_code == SVM_EXIT_NPF);
 }
 
+static void svm_set_mtf(struct kvm_vcpu *vcpu, bool enable)
+{
+}
+
 static void svm_cr3_write_exiting(struct kvm_vcpu *vcpu, bool enable)
 {
 }
@@ -7225,6 +7229,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 	.has_emulated_msr = svm_has_emulated_msr,
 
+	.set_mtf = svm_set_mtf,
 	.cr3_write_exiting = svm_cr3_write_exiting,
 	.msr_intercept = svm_msr_intercept,
 	.desc_intercept = svm_desc_intercept,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7d1e341b51ad..f0369d0574dc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5384,6 +5384,7 @@ static int handle_invalid_op(struct kvm_vcpu *vcpu)
 
 static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 {
+	kvmi_stop_ss(vcpu);
 	return 1;
 }
 
@@ -5992,6 +5993,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (kvmi_vcpu_enabled_ss(vcpu)
+			&& exit_reason != EXIT_REASON_EPT_VIOLATION
+			&& exit_reason != EXIT_REASON_MONITOR_TRAP_FLAG)
+		kvmi_stop_ss(vcpu);
+
 	if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu);
@@ -7842,6 +7848,16 @@ static __exit void hardware_unsetup(void)
 	free_kvm_area();
 }
 
+static void vmx_set_mtf(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (enable)
+		vmcs_set_bits(CPU_BASED_VM_EXEC_CONTROL,
+			      CPU_BASED_MONITOR_TRAP_FLAG);
+	else
+		vmcs_clear_bits(CPU_BASED_VM_EXEC_CONTROL,
+				CPU_BASED_MONITOR_TRAP_FLAG);
+}
+
 static void vmx_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
 			      bool enable)
 {
@@ -7927,6 +7943,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.set_mtf = vmx_set_mtf,
 	.msr_intercept = vmx_msr_intercept,
 	.cr3_write_exiting = vmx_cr3_write_exiting,
 	.desc_intercept = vmx_desc_intercept,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38aaddadb93a..65855340249a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7358,6 +7358,13 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 {
 	int r;
 
+	if (kvmi_vcpu_enabled_ss(vcpu))
+		/*
+		 * We cannot inject events during single-stepping.
+		 * Try again later.
+		 */
+		return -1;
+
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected)
@@ -10134,6 +10141,18 @@ void kvm_control_cr3_write_exiting(struct kvm_vcpu *vcpu, bool enable)
 }
 EXPORT_SYMBOL(kvm_control_cr3_write_exiting);
 
+void kvm_set_mtf(struct kvm_vcpu *vcpu, bool enable)
+{
+	kvm_x86_ops->set_mtf(vcpu, enable);
+}
+EXPORT_SYMBOL(kvm_set_mtf);
+
+void kvm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
+{
+	kvm_x86_ops->set_interrupt_shadow(vcpu, mask);
+}
+EXPORT_SYMBOL(kvm_set_interrupt_shadow);
+
 bool kvm_spt_fault(struct kvm_vcpu *vcpu)
 {
 	return kvm_x86_ops->spt_fault(vcpu);
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index 5d162b9e67f2..1dc90284dc3a 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -22,6 +22,8 @@ bool kvmi_queue_exception(struct kvm_vcpu *vcpu);
 void kvmi_trap_event(struct kvm_vcpu *vcpu);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
+void kvmi_stop_ss(struct kvm_vcpu *vcpu);
+bool kvmi_vcpu_enabled_ss(struct kvm_vcpu *vcpu);
 void kvmi_init_emulate(struct kvm_vcpu *vcpu);
 void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu);
 bool kvmi_bp_intercepted(struct kvm_vcpu *vcpu, u32 dbg);
@@ -44,6 +46,8 @@ static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
 static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_queue_exception(struct kvm_vcpu *vcpu) { return true; }
 static inline void kvmi_trap_event(struct kvm_vcpu *vcpu) { }
+static inline void kvmi_stop_ss(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_vcpu_enabled_ss(struct kvm_vcpu *vcpu) { return false; }
 static inline void kvmi_init_emulate(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu) { }
 static inline bool kvmi_bp_intercepted(struct kvm_vcpu *vcpu, u32 dbg)
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index d47a725a4045..a3a5af9080a9 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -1260,11 +1260,19 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool need_to_wait_for_ss(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	struct kvmi *ikvm = IKVM(vcpu->kvm);
+
+	return atomic_read(&ikvm->ss_active) && !ivcpu->ss_owner;
+}
+
 static bool need_to_wait(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
 
-	return ivcpu->reply_waiting;
+	return ivcpu->reply_waiting || need_to_wait_for_ss(vcpu);
 }
 
 static bool done_waiting(struct kvm_vcpu *vcpu)
@@ -1572,6 +1580,141 @@ int kvmi_cmd_pause_vcpu(struct kvm_vcpu *vcpu, bool wait)
 	return 0;
 }
 
+void kvmi_stop_ss(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	struct kvm *kvm = vcpu->kvm;
+	struct kvmi *ikvm;
+	int i;
+
+	ikvm = kvmi_get(kvm);
+	if (!ikvm)
+		return;
+
+	if (unlikely(!ivcpu->ss_owner)) {
+		kvmi_warn(ikvm, "%s\n", __func__);
+		goto out;
+	}
+
+	for (i = ikvm->ss_level; i--;)
+		kvmi_set_gfn_access(kvm,
+				    ikvm->ss_context[i].gfn,
+				    ikvm->ss_context[i].old_access,
+				    ikvm->ss_context[i].old_write_bitmap);
+
+	ikvm->ss_level = 0;
+
+	kvmi_arch_stop_single_step(vcpu);
+
+	atomic_set(&ikvm->ss_active, false);
+	/*
+	 * Make ss_active update visible
+	 * before resuming all the other vCPUs.
+	 */
+	smp_mb__after_atomic();
+	kvm_make_all_cpus_request(kvm, 0);
+
+	ivcpu->ss_owner = false;
+
+out:
+	kvmi_put(kvm);
+}
+EXPORT_SYMBOL(kvmi_stop_ss);
+
+static bool kvmi_acquire_ss(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	struct kvmi *ikvm = IKVM(vcpu->kvm);
+
+	if (ivcpu->ss_owner)
+		return true;
+
+	if (atomic_cmpxchg(&ikvm->ss_active, false, true) != false)
+		return false;
+
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_INTROSPECTION |
+						KVM_REQUEST_WAIT);
+
+	ivcpu->ss_owner = true;
+
+	return true;
+}
+
+static bool kvmi_run_ss(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access)
+{
+	struct kvmi *ikvm = IKVM(vcpu->kvm);
+	u8 old_access, new_access;
+	u32 old_write_bitmap;
+	gfn_t gfn = gpa_to_gfn(gpa);
+	int err;
+
+	kvmi_arch_start_single_step(vcpu);
+
+	err = kvmi_get_gfn_access(ikvm, gfn, &old_access, &old_write_bitmap);
+	/* likely was removed from radix tree due to rwx */
+	if (err) {
+		kvmi_warn(ikvm, "%s: gfn 0x%llx not found in the radix tree\n",
+			  __func__, gfn);
+		return true;
+	}
+
+	if (ikvm->ss_level == SINGLE_STEP_MAX_DEPTH - 1) {
+		kvmi_err(ikvm, "single step limit reached\n");
+		return false;
+	}
+
+	ikvm->ss_context[ikvm->ss_level].gfn = gfn;
+	ikvm->ss_context[ikvm->ss_level].old_access = old_access;
+	ikvm->ss_context[ikvm->ss_level].old_write_bitmap = old_write_bitmap;
+	ikvm->ss_level++;
+
+	new_access = kvmi_arch_relax_page_access(old_access, access);
+
+	kvmi_set_gfn_access(vcpu->kvm, gfn, new_access, old_write_bitmap);
+
+	return true;
+}
+
+bool kvmi_start_ss(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access)
+{
+	bool ret = false;
+
+	while (!kvmi_acquire_ss(vcpu)) {
+		int err = kvmi_run_jobs_and_wait(vcpu);
+
+		if (err) {
+			kvmi_err(IKVM(vcpu->kvm), "kvmi_acquire_ss() has failed\n");
+			goto out;
+		}
+	}
+
+	if (kvmi_run_ss(vcpu, gpa, access))
+		ret = true;
+	else
+		kvmi_stop_ss(vcpu);
+
+out:
+	return ret;
+}
+
+bool kvmi_vcpu_enabled_ss(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	struct kvmi *ikvm;
+	bool ret;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return false;
+
+	ret = ivcpu->ss_owner;
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvmi_vcpu_enabled_ss);
+
 static void kvmi_job_abort(struct kvm_vcpu *vcpu, void *ctx)
 {
 	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index d7f9858d3e97..1550fe33ed48 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -126,6 +126,9 @@ struct kvmi_vcpu {
 		DECLARE_BITMAP(high, KVMI_NUM_MSR);
 	} msr_mask;
 
+	bool ss_owner;
+	bool ss_requested;
+
 	struct list_head job_list;
 	spinlock_t job_lock;
 
@@ -151,6 +154,15 @@ struct kvmi {
 	DECLARE_BITMAP(event_allow_mask, KVMI_NUM_EVENTS);
 	DECLARE_BITMAP(vm_ev_mask, KVMI_NUM_EVENTS);
 
+#define SINGLE_STEP_MAX_DEPTH 8
+	struct {
+		gfn_t gfn;
+		u8 old_access;
+		u32 old_write_bitmap;
+	} ss_context[SINGLE_STEP_MAX_DEPTH];
+	u8 ss_level;
+	atomic_t ss_active;
+
 	struct {
 		bool initialized;
 		atomic_t enabled;
@@ -224,6 +236,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void *ctx, void (*free_fct)(void *ctx));
 void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action,
 				      const char *str);
+bool kvmi_start_ss(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access);
 
 /* arch */
 void kvmi_arch_update_page_tracking(struct kvm *kvm,
@@ -274,6 +287,9 @@ int kvmi_arch_cmd_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
 				   u64 address);
 int kvmi_arch_cmd_control_cr(struct kvm_vcpu *vcpu,
 			     const struct kvmi_control_cr *req);
+void kvmi_arch_start_single_step(struct kvm_vcpu *vcpu);
+void kvmi_arch_stop_single_step(struct kvm_vcpu *vcpu);
+u8 kvmi_arch_relax_page_access(u8 old, u8 new);
 int kvmi_arch_cmd_control_msr(struct kvm_vcpu *vcpu,
 			      const struct kvmi_control_msr *req);
 int kvmi_arch_cmd_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type);
