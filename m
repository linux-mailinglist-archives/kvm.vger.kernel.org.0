Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8FF1978CF
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgC3KUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:06 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43834 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729607AbgC3KUF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:05 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 71C10305D3D1;
        Mon, 30 Mar 2020 13:13:01 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4CE67305B7A5;
        Mon, 30 Mar 2020 13:13:01 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 75/81] KVM: introspection: add KVMI_EVENT_PF
Date:   Mon, 30 Mar 2020 13:13:02 +0300
Message-Id: <20200330101308.21702-76-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
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
 Documentation/virt/kvm/kvmi.rst               |  50 +++++
 arch/x86/include/asm/kvmi_host.h              |   1 +
 arch/x86/kvm/kvmi.c                           |  27 +++
 include/uapi/linux/kvmi.h                     |  10 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  74 +++++++
 virt/kvm/introspection/kvmi.c                 | 205 ++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |   4 +
 virt/kvm/introspection/kvmi_msg.c             |  18 ++
 8 files changed, 389 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index fe6c71f84dd7..3952aef9af9c 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -551,6 +551,7 @@ the following events::
 	KVMI_EVENT_DESCRIPTOR
 	KVMI_EVENT_HYPERCALL
 	KVMI_EVENT_MSR
+	KVMI_EVENT_PF
 	KVMI_EVENT_XSETBV
 
 When an event is enabled, the introspection tool is notified and
@@ -1282,3 +1283,52 @@ register (see **KVMI_VCPU_CONTROL_EVENTS**).
 
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
+enabled for this event (see *KVMI_VPUC_CONTROL_EVENTS*) and the event was
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
+The *CONTINUE* action will continue the page fault handling via emulation.
+
+The *RETRY* action is used by the introspection tool to retry the
+execution of the current instruction, usually because it changed the
+instruction pointer or the page restrictions.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 446f6c3ddf4e..8d0c3ed3021b 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -39,6 +39,7 @@ struct kvm_vcpu_arch_introspection {
 };
 
 struct kvm_arch_introspection {
+	struct kvm_page_track_notifier_node kptn_node;
 };
 
 #define SLOTS_SIZE BITS_TO_LONGS(KVM_MEM_SLOTS_NUM)
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 328783d9e341..06829e1c5737 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1178,3 +1178,30 @@ int kvmi_arch_cmd_set_page_access(struct kvm_introspection *kvmi,
 	return ec;
 }
 
+bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			u8 access)
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
+		kvmi_handle_common_event_actions(vcpu->kvm, action, "PF");
+	}
+
+	return ret;
+}
+
+bool kvmi_arch_pf_of_interest(struct kvm_vcpu *vcpu)
+{
+	return kvm_x86_ops->spt_fault(vcpu) &&
+	      !kvm_x86_ops->gpt_translation_fault(vcpu);
+}
+
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index da0ce3e41cdd..df192936b017 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -55,6 +55,7 @@ enum {
 	KVMI_EVENT_XSETBV     = 6,
 	KVMI_EVENT_DESCRIPTOR = 7,
 	KVMI_EVENT_MSR        = 8,
+	KVMI_EVENT_PF         = 9,
 
 	KVMI_NUM_EVENTS
 };
@@ -191,4 +192,13 @@ struct kvmi_event_reply {
 	__u32 padding2;
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
index c2ab28f6427f..48cb546234c0 100644
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
 
@@ -107,6 +117,11 @@ static void guest_msr_test(void)
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
@@ -167,6 +182,9 @@ static void guest_code(void)
 		case GUEST_TEST_MSR:
 			guest_msr_test();
 			break;
+		case GUEST_TEST_PF:
+			guest_pf_test();
+			break;
 		case GUEST_TEST_XSETBV:
 			guest_xsetbv_test();
 			break;
@@ -1590,6 +1608,61 @@ static void test_cmd_vm_set_page_access(struct kvm_vm *vm)
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
+
+	enable_vcpu_event(vm, event_id);
+
+	new_test_write_pattern(vm);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	DEBUG("PF event, gpa 0x%llx, gva 0x%llx, access 0x%x\n",
+		ev.pf.gpa, ev.pf.gva, ev.pf.access);
+
+	TEST_ASSERT(ev.pf.gpa == test_gpa && ev.pf.gva == test_gva,
+		"Unexpected #PF event, gpa 0x%llx (expended 0x%llx), gva 0x%llx (expected 0x%llx)\n",
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
@@ -1621,6 +1694,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_descriptor(vm);
 	test_cmd_vcpu_control_msr(vm);
 	test_cmd_vm_set_page_access(vm);
+	test_event_pf(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 2629d3d1f68c..e13b55856e9c 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -18,6 +18,21 @@ DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
 DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
 DECLARE_BITMAP(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 
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
 static struct kmem_cache *msg_cache;
 static struct kmem_cache *job_cache;
 static struct kmem_cache *radix_cache;
@@ -94,6 +109,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_HYPERCALL, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_MSR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_PF, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_TRAP, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_XSETBV, Kvmi_known_vcpu_events);
 
@@ -288,6 +304,12 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 			GFP_KERNEL & ~__GFP_DIRECT_RECLAIM);
 	rwlock_init(&kvmi->access_tree_lock);
 
+	kvmi->arch.kptn_node.track_preread = kvmi_track_preread;
+	kvmi->arch.kptn_node.track_prewrite = kvmi_track_prewrite;
+	kvmi->arch.kptn_node.track_preexec = kvmi_track_preexec;
+	kvmi->arch.kptn_node.track_create_slot = kvmi_track_create_slot;
+	kvmi->arch.kptn_node.track_flush_slot = kvmi_track_flush_slot;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		int err = create_vcpui(vcpu);
 
@@ -319,6 +341,8 @@ static void __kvmi_unhook(struct kvm *kvm)
 	struct kvm_introspection *kvmi = KVMI(kvm);
 
 	wait_for_completion_killable(&kvm->kvmi_complete);
+
+	kvm_page_track_unregister_notifier(kvm, &kvmi->arch.kptn_node);
 	kvmi_sock_put(kvmi);
 }
 
@@ -366,6 +390,8 @@ static int __kvmi_hook(struct kvm *kvm,
 	if (!kvmi_sock_get(kvmi, hook->fd))
 		return -EINVAL;
 
+	kvm_page_track_register_notifier(kvm, &kvmi->arch.kptn_node);
+
 	return 0;
 }
 
@@ -1092,3 +1118,182 @@ int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi, u64 gpa, u8 access)
 	return kvmi_set_gfn_access(kvmi->kvm, gfn, access);
 }
 
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
+static bool kvmi_restricted_access(struct kvm_introspection *kvmi, gpa_t gpa,
+				   u8 access)
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
+static bool is_pf_of_interest(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!kvmi_arch_pf_of_interest(vcpu))
+		return false;
+
+	return kvmi_restricted_access(KVMI(kvm), gpa, access);
+}
+
+static bool kvmi_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			  int access)
+{
+	if (!is_pf_of_interest(vcpu, gpa, access))
+		return true;
+
+	return kvmi_arch_pf_event(vcpu, gpa, gva, access);
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
+	if (is_event_enabled(vcpu, KVMI_EVENT_PF))
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
+	if (is_event_enabled(vcpu, KVMI_EVENT_PF))
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
+	gfn_t start = slot->base_gfn;
+	const gfn_t end = start + npages;
+	int idx;
+
+	kvmi = kvmi_get(kvm);
+	if (!kvmi)
+		return;
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
+
+	kvmi_put(kvm);
+}
+
+static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+				  struct kvm_page_track_notifier_node *node)
+{
+	struct kvm_introspection *kvmi;
+	gfn_t start = slot->base_gfn;
+	const gfn_t end = start + slot->npages;
+	int idx;
+
+	kvmi = kvmi_get(kvm);
+	if (!kvmi)
+		return;
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
+
+	kvmi_put(kvm);
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 237bb083cf01..639d14811933 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -49,6 +49,7 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
+u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -123,5 +124,8 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 int kvmi_arch_cmd_set_page_access(struct kvm_introspection *kvmi,
 				  const struct kvmi_msg_hdr *msg,
 				  const struct kvmi_vm_set_page_access *req);
+bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			u8 access);
+bool kvmi_arch_pf_of_interest(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 973ed9d92bfb..10d4e40387ef 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -984,3 +984,21 @@ u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len)
 
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
