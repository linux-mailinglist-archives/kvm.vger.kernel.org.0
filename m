Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83433228ADC
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbgGUVRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:42 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38092 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731259AbgGUVQG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:06 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 8C12A305D506;
        Wed, 22 Jul 2020 00:09:31 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 62D70304FA14;
        Wed, 22 Jul 2020 00:09:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 78/84] KVM: introspection: add KVMI_EVENT_PF
Date:   Wed, 22 Jul 2020 00:09:16 +0300
Message-Id: <20200721210922.7646-79-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
 Documentation/virt/kvm/kvmi.rst               |  51 +++++++
 arch/x86/include/asm/kvmi_host.h              |   1 +
 arch/x86/kvm/kvmi.c                           | 141 ++++++++++++++++++
 include/uapi/linux/kvmi.h                     |  10 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  76 ++++++++++
 virt/kvm/introspection/kvmi.c                 | 115 ++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |   9 ++
 virt/kvm/introspection/kvmi_msg.c             |  18 +++
 8 files changed, 421 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 123b2360d2e0..b2e2a9edda77 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -554,6 +554,7 @@ the following events::
 	KVMI_EVENT_DESCRIPTOR
 	KVMI_EVENT_HYPERCALL
 	KVMI_EVENT_MSR
+	KVMI_EVENT_PF
 	KVMI_EVENT_XSETBV
 
 When an event is enabled, the introspection tool is notified and
@@ -1387,3 +1388,53 @@ register (see **KVMI_VCPU_CONTROL_EVENTS**).
 
 ``kvmi_event``, the MSR number, the old value and the new value are
 sent to the introspection tool. The *CONTINUE* action will set the ``new_val``.
+
+10. KVMI_EVENT_PF
+-----------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH, RETRY
+:Parameters:
+
+::
+
+	struct kvmi_event;
+	struct kvmi_event_pf {
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
+	struct kvmi_event_reply;
+
+This event is sent when a hypervisor page fault occurs due to a failed
+permission check in the shadow page tables, the introspection has been
+enabled for this event (see *KVMI_VCPU_CONTROL_EVENTS*) and the event was
+generated for a page in which the introspection tool has shown interest
+(ie. has previously touched it by adjusting the spte permissions).
+
+The shadow page tables can be used by the introspection tool to guarantee
+the purpose of code areas inside the guest (code, rodata, stack, heap
+etc.) Each attempt at an operation unfitting for a certain memory
+range (eg. execute code in heap) triggers a page fault and gives the
+introspection tool the chance to audit the code attempting the operation.
+
+``kvmi_event``, guest virtual address (or 0xffffffff/UNMAPPED_GVA),
+guest physical address and the access flags (eg. KVMI_PAGE_ACCESS_R)
+are sent to the introspection tool.
+
+The *CONTINUE* action will continue the page fault handling (e.g. via
+emulation).
+
+The *RETRY* action is used by the introspection tool to retry the
+execution of the current instruction, usually because it changed the
+instruction pointer or the page restrictions.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 98ea548c0b15..25c7bb8a9082 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -41,6 +41,7 @@ struct kvm_vcpu_arch_introspection {
 };
 
 struct kvm_arch_introspection {
+	struct kvm_page_track_notifier_node kptn_node;
 };
 
 #define SLOTS_SIZE BITS_TO_LONGS(KVM_MEM_SLOTS_NUM)
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index b233a3c5becb..8fbf1720749b 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -10,6 +10,21 @@
 #include "cpuid.h"
 #include "../../../virt/kvm/introspection/kvmi_int.h"
 
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
@@ -1209,3 +1224,129 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
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
+static bool is_pf_of_interest(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access)
+{
+	if (!kvm_x86_ops.spt_fault(vcpu))
+		return false;
+
+	if (kvm_x86_ops.gpt_translation_fault(vcpu))
+		return false;
+
+	return kvmi_restricted_page_access(KVMI(vcpu->kvm), gpa, access);
+}
+
+static bool handle_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			    int access)
+{
+	if (!is_pf_of_interest(vcpu, gpa, access))
+		return true;
+
+	return kvmi_pf_event(vcpu, gpa, gva, access);
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
+	if (is_event_enabled(vcpu, KVMI_EVENT_PF))
+		ret = handle_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_R);
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
+	if (is_event_enabled(vcpu, KVMI_EVENT_PF))
+		ret = handle_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_W);
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
+	if (is_event_enabled(vcpu, KVMI_EVENT_PF))
+		ret = handle_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_X);
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
index dc82f192534c..dc7ba12498b7 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -60,6 +60,7 @@ enum {
 	KVMI_EVENT_XSETBV     = 6,
 	KVMI_EVENT_DESCRIPTOR = 7,
 	KVMI_EVENT_MSR        = 8,
+	KVMI_EVENT_PF         = 9,
 
 	KVMI_NUM_EVENTS
 };
@@ -218,4 +219,13 @@ struct kvmi_vcpu_inject_exception {
 	__u64 address;
 };
 
+struct kvmi_event_pf {
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
index 4fb109cec1b4..21b3f7a459c8 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -42,6 +42,11 @@ struct vcpu_reply {
 	struct kvmi_event_reply reply;
 };
 
+struct pf_ev {
+	struct kvmi_event common;
+	struct kvmi_event_pf pf;
+};
+
 struct vcpu_worker_data {
 	struct kvm_vm *vm;
 	int vcpu_id;
@@ -51,6 +56,10 @@ struct vcpu_worker_data {
 	bool restart_on_shutdown;
 };
 
+typedef void (*fct_pf_event)(struct kvm_vm *vm, struct kvmi_msg_hdr *hdr,
+				struct pf_ev *ev,
+				struct vcpu_reply *rpl);
+
 enum {
 	GUEST_TEST_NOOP = 0,
 	GUEST_TEST_BP,
@@ -58,6 +67,7 @@ enum {
 	GUEST_TEST_DESCRIPTOR,
 	GUEST_TEST_HYPERCALL,
 	GUEST_TEST_MSR,
+	GUEST_TEST_PF,
 	GUEST_TEST_XSETBV,
 };
 
@@ -111,6 +121,11 @@ static void guest_msr_test(void)
 	wrmsr(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
+static void guest_pf_test(void)
+{
+	*((uint8_t *)test_gva) = READ_ONCE(test_write_pattern);
+}
+
 /* from fpu/internal.h */
 static u64 xgetbv(u32 index)
 {
@@ -171,6 +186,9 @@ static void guest_code(void)
 		case GUEST_TEST_MSR:
 			guest_msr_test();
 			break;
+		case GUEST_TEST_PF:
+			guest_pf_test();
+			break;
 		case GUEST_TEST_XSETBV:
 			guest_xsetbv_test();
 			break;
@@ -1860,6 +1878,63 @@ static void test_cmd_vm_set_page_access(struct kvm_vm *vm)
 	set_page_access(gpa, full_access);
 }
 
+static void test_pf(struct kvm_vm *vm, fct_pf_event cbk)
+{
+	__u16 event_id = KVMI_EVENT_PF;
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
+	new_test_write_pattern(vm);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	pr_info("PF event, gpa 0x%llx, gva 0x%llx, access 0x%x\n",
+		ev.pf.gpa, ev.pf.gva, ev.pf.access);
+
+	TEST_ASSERT(ev.pf.gpa == test_gpa && ev.pf.gva == test_gva,
+		"Unexpected #PF event, gpa 0x%llx (expended 0x%lx), gva 0x%llx (expected 0x%lx)\n",
+		ev.pf.gpa, test_gpa, ev.pf.gva, test_gva);
+
+	cbk(vm, &hdr, &ev, &rpl);
+
+	stop_vcpu_worker(vcpu_thread, &data);
+
+	TEST_ASSERT(*((uint8_t *)test_hva) == test_write_pattern,
+		"Write failed, expected 0x%x, result 0x%x\n",
+		test_write_pattern, *((uint8_t *)test_hva));
+
+	disable_vcpu_event(vm, event_id);
+	set_page_access(test_gpa, KVMI_PAGE_ACCESS_R
+				| KVMI_PAGE_ACCESS_W
+				| KVMI_PAGE_ACCESS_X);
+}
+
+static void cbk_test_event_pf(struct kvm_vm *vm, struct kvmi_msg_hdr *hdr,
+				struct pf_ev *ev, struct vcpu_reply *rpl)
+{
+	set_page_access(test_gpa, KVMI_PAGE_ACCESS_R | KVMI_PAGE_ACCESS_W);
+
+	reply_to_event(hdr, &ev->common, KVMI_EVENT_ACTION_RETRY,
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
@@ -1893,6 +1968,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_descriptor(vm);
 	test_cmd_vcpu_control_msr(vm);
 	test_cmd_vm_set_page_access(vm);
+	test_event_pf(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index b57ad490dd06..99c88e182587 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -113,6 +113,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_HYPERCALL, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_MSR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_PF, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_TRAP, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_XSETBV, Kvmi_known_vcpu_events);
 
@@ -368,6 +369,8 @@ static void __kvmi_unhook(struct kvm *kvm)
 	struct kvm_introspection *kvmi = KVMI(kvm);
 
 	wait_for_completion_killable(&kvm->kvmi_complete);
+
+	kvmi_arch_unhook(kvm);
 	kvmi_sock_put(kvmi);
 }
 
@@ -415,6 +418,8 @@ static int __kvmi_hook(struct kvm *kvm,
 	if (!kvmi_sock_get(kvmi, hook->fd))
 		return -EINVAL;
 
+	kvmi_arch_hook(kvm);
+
 	return 0;
 }
 
@@ -1182,3 +1187,113 @@ int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi,
 
 	return ec;
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
+	action = kvmi_msg_send_pf(vcpu, gpa, gva, access);
+
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		ret = true;
+		break;
+	case KVMI_EVENT_ACTION_RETRY:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action);
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
index 024e7acf0dce..9f2341fe21d5 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -47,6 +47,7 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
+u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -82,6 +83,12 @@ int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
 int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi,
 			     const struct kvmi_msg_hdr *msg,
 			     const struct kvmi_vm_set_page_access *req);
+bool kvmi_restricted_page_access(struct kvm_introspection *kvmi, gpa_t gpa,
+				 u8 access);
+bool kvmi_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva, u8 access);
+void kvmi_add_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
+		      unsigned long npages);
+void kvmi_remove_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 
 /* arch */
 bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu);
@@ -129,5 +136,7 @@ int kvmi_arch_cmd_vcpu_control_msr(struct kvm_vcpu *vcpu,
 void kvmi_arch_update_page_tracking(struct kvm *kvm,
 				    struct kvm_memory_slot *slot,
 				    struct kvmi_mem_access *m);
+void kvmi_arch_hook(struct kvm *kvm);
+void kvmi_arch_unhook(struct kvm *kvm);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index f7ffb971f1dc..0a0d10b43f2d 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -983,3 +983,21 @@ u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len)
 
 	return action;
 }
+
+u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access)
+{
+	struct kvmi_event_pf e;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.gpa = gpa;
+	e.gva = gva;
+	e.access = access;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_PF, &e, sizeof(e),
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
