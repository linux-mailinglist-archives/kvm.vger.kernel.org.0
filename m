Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A670C2C3CA3
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgKYJmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:24 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57140 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728535AbgKYJmG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:06 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 1ED6C305D3E8;
        Wed, 25 Nov 2020 11:35:55 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E9ADA3072785;
        Wed, 25 Nov 2020 11:35:54 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 75/81] KVM: introspection: add KVMI_VCPU_EVENT_PF
Date:   Wed, 25 Nov 2020 11:35:54 +0200
Message-Id: <20201125093600.2766-76-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent when a #PF occurs due to a failed permission check
in the shadow page tables, for a page in which the introspection tool
has shown interest.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  66 ++++++++++
 arch/x86/include/asm/kvmi_host.h              |   1 +
 arch/x86/kvm/kvmi.c                           | 122 ++++++++++++++++++
 include/uapi/linux/kvmi.h                     |  10 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  76 +++++++++++
 virt/kvm/introspection/kvmi.c                 | 116 +++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |   7 +
 virt/kvm/introspection/kvmi_msg.c             |  19 +++
 8 files changed, 417 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 1540f75c4462..bdcc9066ae28 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -543,6 +543,7 @@ the following events::
 	KVMI_VCPU_EVENT_DESCRIPTOR
 	KVMI_VCPU_EVENT_HYPERCALL
 	KVMI_VCPU_EVENT_MSR
+	KVMI_VCPU_EVENT_PF
 	KVMI_VCPU_EVENT_XSETBV
 
 When an event is enabled, the introspection tool is notified and
@@ -1398,3 +1399,68 @@ register (see **KVMI_VCPU_CONTROL_EVENTS**).
 ``kvmi_vcpu_event`` (with the vCPU state), the MSR number (``msr``),
 the old value (``old_value``) and the new value (``new_value``) are sent
 to the introspection tool. The *CONTINUE* action will set the ``new_val``.
+
+10. KVMI_VCPU_EVENT_PF
+----------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH, RETRY
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_event;
+	struct kvmi_vcpu_event_pf {
+		__u64 gva;
+		__u64 gpa;
+		__u8 access;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 padding3;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_event_reply;
+
+This event is sent when a hypervisor page fault occurs due to a failed
+permission checks, the introspection has been enabled for this event
+(see *KVMI_VCPU_CONTROL_EVENTS*) and the event was generated for a
+page in which the introspection tool has shown interest (ie. has
+previously touched it by adjusting the spte permissions; see
+*KVMI_VM_SET_PAGE_ACCESS*).
+
+These permissions can be used by the introspection tool to guarantee
+the purpose of code areas inside the guest (code, rodata, stack, heap
+etc.) Each attempt at an operation unfitting for a certain memory
+range (eg. execute code in heap) triggers a page fault and gives the
+introspection tool the chance to audit the code attempting the operation.
+
+``kvmi_vcpu_event`` (with the vCPU state), guest virtual address (``gva``)
+if available or ~0 (UNMAPPED_GVA), guest physical address (``gpa``)
+and the ``access`` flags (e.g. KVMI_PAGE_ACCESS_R) are sent to the
+introspection tool.
+
+In case of a restricted read access, the guest address is the location
+of the memory being read. On write access, the guest address is the
+location of the memory being written. On execute access, the guest
+address is the location of the instruction being executed
+(``gva == kvmi_vcpu_event.arch.regs.rip``).
+
+In the current implementation, most of these events are sent during
+emulation. If the page fault has set more than one access bit
+(e.g. r-x/-rw), the introspection tool may receive more than one
+KVMI_VCPU_EVENT_PF and the order depends on the KVM emulator. Another
+cause of multiple events is when the page fault is triggered on access
+crossing the page boundary.
+
+The *CONTINUE* action will continue the page fault handling (e.g. via
+emulation).
+
+The *RETRY* action is used by the introspection tool to retry the
+execution of the current instruction, usually because it changed the
+instruction pointer or the page restrictions.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 420358c4a9ae..31500d3ff69d 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -53,6 +53,7 @@ struct kvm_vcpu_arch_introspection {
 };
 
 struct kvm_arch_introspection {
+	struct kvm_page_track_notifier_node kptn_node;
 };
 
 #define SLOTS_SIZE BITS_TO_LONGS(KVM_MEM_SLOTS_NUM)
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index acd4756e0d78..cd64762643d6 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -17,10 +17,26 @@ void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 	set_bit(KVMI_VCPU_EVENT_HYPERCALL, supported);
 	set_bit(KVMI_VCPU_EVENT_DESCRIPTOR, supported);
 	set_bit(KVMI_VCPU_EVENT_MSR, supported);
+	set_bit(KVMI_VCPU_EVENT_PF, supported);
 	set_bit(KVMI_VCPU_EVENT_TRAP, supported);
 	set_bit(KVMI_VCPU_EVENT_XSETBV, supported);
 }
 
+static bool kvmi_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			       int bytes,
+			       struct kvm_page_track_notifier_node *node);
+static bool kvmi_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+				const u8 *new, int bytes,
+				struct kvm_page_track_notifier_node *node);
+static bool kvmi_track_preexec(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			       struct kvm_page_track_notifier_node *node);
+static void kvmi_track_create_slot(struct kvm *kvm,
+				   struct kvm_memory_slot *slot,
+				   unsigned long npages,
+				   struct kvm_page_track_notifier_node *node);
+static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+				  struct kvm_page_track_notifier_node *node);
+
 static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
 				   const struct kvm_sregs *sregs)
 {
@@ -959,3 +975,109 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 		}
 	}
 }
+
+void kvmi_arch_hook(struct kvm *kvm)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+
+	kvmi->arch.kptn_node.track_preread = kvmi_track_preread;
+	kvmi->arch.kptn_node.track_prewrite = kvmi_track_prewrite;
+	kvmi->arch.kptn_node.track_preexec = kvmi_track_preexec;
+	kvmi->arch.kptn_node.track_create_slot = kvmi_track_create_slot;
+	kvmi->arch.kptn_node.track_flush_slot = kvmi_track_flush_slot;
+
+	kvm_page_track_register_notifier(kvm, &kvmi->arch.kptn_node);
+}
+
+void kvmi_arch_unhook(struct kvm *kvm)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+
+	kvm_page_track_unregister_notifier(kvm, &kvmi->arch.kptn_node);
+}
+
+static bool kvmi_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			       int bytes,
+			       struct kvm_page_track_notifier_node *node)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	if (is_vcpu_event_enabled(vcpu, KVMI_VCPU_EVENT_PF))
+		ret = kvmi_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_R);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+static bool kvmi_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+				const u8 *new, int bytes,
+				struct kvm_page_track_notifier_node *node)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	if (is_vcpu_event_enabled(vcpu, KVMI_VCPU_EVENT_PF))
+		ret = kvmi_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_W);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+static bool kvmi_track_preexec(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			       struct kvm_page_track_notifier_node *node)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	if (is_vcpu_event_enabled(vcpu, KVMI_VCPU_EVENT_PF))
+		ret = kvmi_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_X);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+static void kvmi_track_create_slot(struct kvm *kvm,
+				   struct kvm_memory_slot *slot,
+				   unsigned long npages,
+				   struct kvm_page_track_notifier_node *node)
+{
+	struct kvm_introspection *kvmi;
+
+	kvmi = kvmi_get(kvm);
+	if (!kvmi)
+		return;
+
+	kvmi_add_memslot(kvm, slot, npages);
+
+	kvmi_put(kvm);
+}
+
+static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+				  struct kvm_page_track_notifier_node *node)
+{
+	struct kvm_introspection *kvmi;
+
+	kvmi = kvmi_get(kvm);
+	if (!kvmi)
+		return;
+
+	kvmi_remove_memslot(kvm, slot);
+
+	kvmi_put(kvm);
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 42c8e6342fcf..3b432b37b17c 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -72,6 +72,7 @@ enum {
 	KVMI_VCPU_EVENT_XSETBV     = KVMI_VCPU_EVENT_ID(5),
 	KVMI_VCPU_EVENT_DESCRIPTOR = KVMI_VCPU_EVENT_ID(6),
 	KVMI_VCPU_EVENT_MSR        = KVMI_VCPU_EVENT_ID(7),
+	KVMI_VCPU_EVENT_PF         = KVMI_VCPU_EVENT_ID(8),
 
 	KVMI_NEXT_VCPU_EVENT
 };
@@ -210,4 +211,13 @@ struct kvmi_vm_set_page_access {
 	struct kvmi_page_access_entry entries[0];
 };
 
+struct kvmi_vcpu_event_pf {
+	__u64 gva;
+	__u64 gpa;
+	__u8 access;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 padding3;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index c9d6ee57d506..e36b574c264e 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -47,6 +47,11 @@ struct vcpu_reply {
 	struct kvmi_vcpu_event_reply reply;
 };
 
+struct pf_ev {
+	struct vcpu_event vcpu_ev;
+	struct kvmi_vcpu_event_pf pf;
+};
+
 struct vcpu_worker_data {
 	struct kvm_vm *vm;
 	int vcpu_id;
@@ -54,6 +59,10 @@ struct vcpu_worker_data {
 	bool restart_on_shutdown;
 };
 
+typedef void (*fct_pf_event)(struct kvm_vm *vm, struct kvmi_msg_hdr *hdr,
+				struct pf_ev *ev,
+				struct vcpu_reply *rpl);
+
 enum {
 	GUEST_TEST_NOOP = 0,
 	GUEST_TEST_BP,
@@ -61,6 +70,7 @@ enum {
 	GUEST_TEST_DESCRIPTOR,
 	GUEST_TEST_HYPERCALL,
 	GUEST_TEST_MSR,
+	GUEST_TEST_PF,
 	GUEST_TEST_XSETBV,
 };
 
@@ -114,6 +124,11 @@ static void guest_msr_test(void)
 	wrmsr(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
+static void guest_pf_test(void)
+{
+	*((uint8_t *)test_gva) = GUEST_TEST_PF;
+}
+
 /* from fpu/internal.h */
 static u64 xgetbv(u32 index)
 {
@@ -174,6 +189,9 @@ static void guest_code(void)
 		case GUEST_TEST_MSR:
 			guest_msr_test();
 			break;
+		case GUEST_TEST_PF:
+			guest_pf_test();
+			break;
 		case GUEST_TEST_XSETBV:
 			guest_xsetbv_test();
 			break;
@@ -1738,6 +1756,63 @@ static void test_cmd_vm_set_page_access(struct kvm_vm *vm)
 	set_page_access(gpa, full_access);
 }
 
+static void test_pf(struct kvm_vm *vm, fct_pf_event cbk)
+{
+	__u16 event_id = KVMI_VCPU_EVENT_PF;
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_PF,
+	};
+	struct kvmi_msg_hdr hdr;
+	struct vcpu_reply rpl = {};
+	pthread_t vcpu_thread;
+	struct pf_ev ev;
+
+	set_page_access(test_gpa, KVMI_PAGE_ACCESS_R);
+	enable_vcpu_event(vm, event_id);
+
+	*((uint8_t *)test_hva) = ~GUEST_TEST_PF;
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev), event_id);
+
+	pr_debug("PF event, gpa 0x%llx, gva 0x%llx, access 0x%x\n",
+		 ev.pf.gpa, ev.pf.gva, ev.pf.access);
+
+	TEST_ASSERT(ev.pf.gpa == test_gpa && ev.pf.gva == test_gva,
+		"Unexpected #PF event, gpa 0x%llx (expended 0x%lx), gva 0x%llx (expected 0x%lx)\n",
+		ev.pf.gpa, test_gpa, ev.pf.gva, test_gva);
+
+	cbk(vm, &hdr, &ev, &rpl);
+
+	wait_vcpu_worker(vcpu_thread);
+
+	TEST_ASSERT(*((uint8_t *)test_hva) == GUEST_TEST_PF,
+		"Write failed, expected 0x%x, result 0x%x\n",
+		GUEST_TEST_PF, *((uint8_t *)test_hva));
+
+	disable_vcpu_event(vm, event_id);
+	set_page_access(test_gpa, KVMI_PAGE_ACCESS_R |
+				  KVMI_PAGE_ACCESS_W |
+				  KVMI_PAGE_ACCESS_X);
+}
+
+static void cbk_test_event_pf(struct kvm_vm *vm, struct kvmi_msg_hdr *hdr,
+				struct pf_ev *ev, struct vcpu_reply *rpl)
+{
+	set_page_access(test_gpa, KVMI_PAGE_ACCESS_R | KVMI_PAGE_ACCESS_W);
+
+	reply_to_event(hdr, &ev->vcpu_ev, KVMI_EVENT_ACTION_RETRY,
+			rpl, sizeof(*rpl));
+}
+
+static void test_event_pf(struct kvm_vm *vm)
+{
+	test_pf(vm, cbk_test_event_pf);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1771,6 +1846,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_descriptor(vm);
 	test_cmd_vcpu_control_msr(vm);
 	test_cmd_vm_set_page_access(vm);
+	test_event_pf(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 079b355540b4..a228178ddba2 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -376,6 +376,8 @@ static void __kvmi_unhook(struct kvm *kvm)
 	struct kvm_introspection *kvmi = KVMI(kvm);
 
 	wait_for_completion_killable(&kvm->kvmi_complete);
+
+	kvmi_arch_unhook(kvm);
 	kvmi_sock_put(kvmi);
 }
 
@@ -423,6 +425,8 @@ static int __kvmi_hook(struct kvm *kvm,
 	if (!kvmi_sock_get(kvmi, hook->fd))
 		return -EINVAL;
 
+	kvmi_arch_hook(kvm);
+
 	return 0;
 }
 
@@ -1054,3 +1058,115 @@ int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
 
 	return err;
 }
+
+static int kvmi_get_gfn_access(struct kvm_introspection *kvmi, const gfn_t gfn,
+			       u8 *access)
+{
+	struct kvmi_mem_access *m;
+
+	read_lock(&kvmi->access_tree_lock);
+	m = __kvmi_get_gfn_access(kvmi, gfn);
+	if (m)
+		*access = m->access;
+	read_unlock(&kvmi->access_tree_lock);
+
+	return m ? 0 : -1;
+}
+
+bool kvmi_restricted_page_access(struct kvm_introspection *kvmi, gpa_t gpa,
+				 u8 access)
+{
+	u8 allowed_access;
+	int err;
+
+	err = kvmi_get_gfn_access(kvmi, gpa_to_gfn(gpa), &allowed_access);
+	if (err)
+		return false;
+
+	/*
+	 * We want to be notified only for violations involving access
+	 * bits that we've specifically cleared
+	 */
+	if (access & (~allowed_access))
+		return true;
+
+	return false;
+}
+
+bool kvmi_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva, u8 access)
+{
+	bool ret = false;
+	u32 action;
+
+	if (!kvmi_restricted_page_access(KVMI(vcpu->kvm), gpa, access))
+		return true;
+
+	action = kvmi_msg_send_vcpu_pf(vcpu, gpa, gva, access);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		ret = true;
+		break;
+	case KVMI_EVENT_ACTION_RETRY:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action);
+	}
+
+	return ret;
+}
+
+void kvmi_add_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
+		      unsigned long npages)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+	gfn_t start = slot->base_gfn;
+	gfn_t end = start + npages;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	read_lock(&kvmi->access_tree_lock);
+
+	while (start < end) {
+		struct kvmi_mem_access *m;
+
+		m = __kvmi_get_gfn_access(kvmi, start);
+		if (m)
+			kvmi_arch_update_page_tracking(kvm, slot, m);
+		start++;
+	}
+
+	read_unlock(&kvmi->access_tree_lock);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
+void kvmi_remove_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+	gfn_t start = slot->base_gfn;
+	gfn_t end = start + slot->npages;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvmi->access_tree_lock);
+
+	while (start < end) {
+		struct kvmi_mem_access *m;
+
+		m = __kvmi_get_gfn_access(kvmi, start);
+		if (m) {
+			u8 prev_access = m->access;
+
+			m->access = full_access;
+			kvmi_arch_update_page_tracking(kvm, slot, m);
+			m->access = prev_access;
+		}
+		start++;
+	}
+
+	write_unlock(&kvmi->access_tree_lock);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 41720b194458..bf6545e66425 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -63,6 +63,7 @@ int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_msg_job *job,
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_vcpu_hypercall(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_vcpu_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
+u32 kvmi_msg_send_vcpu_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -93,6 +94,10 @@ int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 			    const void *buf);
 int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access);
+bool kvmi_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva, u8 access);
+void kvmi_add_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
+		      unsigned long npages);
+void kvmi_remove_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 
 /* arch */
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
@@ -114,5 +119,7 @@ void kvmi_arch_send_pending_event(struct kvm_vcpu *vcpu);
 void kvmi_arch_update_page_tracking(struct kvm *kvm,
 				    struct kvm_memory_slot *slot,
 				    struct kvmi_mem_access *m);
+void kvmi_arch_hook(struct kvm *kvm);
+void kvmi_arch_unhook(struct kvm *kvm);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index a3d6d3df3078..276b898912fd 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -870,3 +870,22 @@ u32 kvmi_msg_send_vcpu_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len)
 
 	return action;
 }
+
+u32 kvmi_msg_send_vcpu_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access)
+{
+	struct kvmi_vcpu_event_pf e;
+	u32 action;
+	int err;
+
+	memset(&e, 0, sizeof(e));
+	e.gpa = gpa;
+	e.gva = gva;
+	e.access = access;
+
+	err = kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_PF, &e, sizeof(e),
+				   NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
