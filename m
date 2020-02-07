Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713DC155D92
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgBGSRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:07 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40778 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727752AbgBGSQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:57 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DB261305D366;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id CF440305207E;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 72/78] KVM: introspection: add KVMI_EVENT_PF
Date:   Fri,  7 Feb 2020 20:16:30 +0200
Message-Id: <20200207181636.1065-73-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
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
 Documentation/virt/kvm/kvmi.rst               |  50 ++++
 arch/x86/include/asm/kvmi_host.h              |   1 +
 arch/x86/kvm/kvmi.c                           |  28 +++
 include/uapi/linux/kvmi.h                     |  10 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  85 +++++++
 virt/kvm/introspection/kvmi.c                 | 221 ++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |   5 +
 virt/kvm/introspection/kvmi_msg.c             |  27 +++
 8 files changed, 427 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 14790171a170..7994d6e8cacf 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -535,6 +535,7 @@ the following events::
 	KVMI_EVENT_DESCRIPTOR
 	KVMI_EVENT_HYPERCALL
 	KVMI_EVENT_MSR
+	KVMI_EVENT_PF
 	KVMI_EVENT_TRAP
 	KVMI_EVENT_XSETBV
 
@@ -1260,3 +1261,52 @@ register (see **KVMI_VCPU_CONTROL_EVENTS**).
 
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
index 5f2614ac3b4c..2e4eff501c0a 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -39,6 +39,7 @@ struct kvm_vcpu_arch_introspection {
 };
 
 struct kvm_arch_introspection {
+	struct kvm_page_track_notifier_node kptn_node;
 };
 
 #define SLOTS_SIZE BITS_TO_LONGS(KVM_MEM_SLOTS_NUM)
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index ae6fef5a9b95..4e8b8e0a2961 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1078,3 +1078,31 @@ int kvmi_arch_cmd_set_page_access(struct kvm_introspection *kvmi,
 
 	return ec;
 }
+
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
index 4b8462b80553..c74ded097efa 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -56,6 +56,7 @@ enum {
 	KVMI_EVENT_XSETBV     = 6,
 	KVMI_EVENT_DESCRIPTOR = 7,
 	KVMI_EVENT_MSR        = 8,
+	KVMI_EVENT_PF         = 9,
 
 	KVMI_NUM_EVENTS
 };
@@ -181,4 +182,13 @@ struct kvmi_event_reply {
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
index a0bd573ab264..e8d3ccac1caa 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -41,6 +41,11 @@ struct vcpu_reply {
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
@@ -50,6 +55,10 @@ struct vcpu_worker_data {
 	bool restart_on_shutdown;
 };
 
+typedef void (*fct_pf_event)(struct kvm_vm *vm, struct kvmi_msg_hdr *hdr,
+				struct pf_ev *ev,
+				struct vcpu_reply *rpl);
+
 enum {
 	GUEST_TEST_NOOP = 0,
 	GUEST_TEST_BP,
@@ -57,6 +66,7 @@ enum {
 	GUEST_TEST_DESCRIPTOR,
 	GUEST_TEST_HYPERCALL,
 	GUEST_TEST_MSR,
+	GUEST_TEST_PF,
 	GUEST_TEST_XSETBV,
 };
 
@@ -106,6 +116,11 @@ static void guest_msr_test(void)
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
@@ -166,6 +181,9 @@ static void guest_code(void)
 		case GUEST_TEST_MSR:
 			guest_msr_test();
 			break;
+		case GUEST_TEST_PF:
+			guest_pf_test();
+			break;
 		case GUEST_TEST_XSETBV:
 			guest_xsetbv_test();
 			break;
@@ -1580,6 +1598,16 @@ static void set_page_access(struct kvm_vm *vm, __u64 gpa, __u8 access)
 		gpa, access, -r, kvm_strerror(-r));
 }
 
+static void __set_page_access(struct kvm_vm *vm, __u64 gpa, __u8 access)
+{
+	int r;
+
+	r = __cmd_set_page_access(vm, 1, &gpa, &access);
+	TEST_ASSERT(r == 0,
+		"KVMI_VM_SET_PAGE_ACCESS failed, gpa 0x%llx, access 0x%x, error %d (%s)\n",
+		gpa, access, -r, kvm_strerror(-r));
+}
+
 static void test_cmd_vm_set_page_access(struct kvm_vm *vm)
 {
 	__u8 full_access = KVMI_PAGE_ACCESS_R | KVMI_PAGE_ACCESS_W
@@ -1592,6 +1620,62 @@ static void test_cmd_vm_set_page_access(struct kvm_vm *vm)
 	set_page_access(vm, gpa, full_access);
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
+	set_page_access(vm, test_gpa, KVMI_PAGE_ACCESS_R);
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
+	__set_page_access(vm, test_gpa, KVMI_PAGE_ACCESS_R
+					| KVMI_PAGE_ACCESS_W);
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
 	setup_socket();
@@ -1622,6 +1706,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_descriptor(vm);
 	test_cmd_vcpu_control_msr(vm);
 	test_cmd_vm_set_page_access(vm);
+	test_event_pf(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 6e88735978ae..10d59061fa82 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -13,6 +13,21 @@ enum {
 	MAX_PAUSE_REQUESTS = 1001
 };
 
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
@@ -248,6 +263,12 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
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
 
@@ -279,6 +300,8 @@ static void __kvmi_unhook(struct kvm *kvm)
 	struct kvm_introspection *kvmi = KVMI(kvm);
 
 	wait_for_completion_killable(&kvm->kvmi_complete);
+
+	kvm_page_track_unregister_notifier(kvm, &kvmi->arch.kptn_node);
 	kvmi_sock_put(kvmi);
 }
 
@@ -327,6 +350,8 @@ static int __kvmi_hook(struct kvm *kvm,
 	if (!kvmi_sock_get(kvmi, hook->fd))
 		return -EINVAL;
 
+	kvm_page_track_register_notifier(kvm, &kvmi->arch.kptn_node);
+
 	return 0;
 }
 
@@ -1075,3 +1100,199 @@ int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi, u64 gpa, u8 access)
 
 	return kvmi_set_gfn_access(kvmi->kvm, gfn, access);
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
+static bool kvmi_restricted_access(struct kvm_introspection *kvmi, gpa_t gpa,
+				   u8 access)
+{
+	u8 allowed_access;
+	int err;
+
+	err = kvmi_get_gfn_access(kvmi, gpa_to_gfn(gpa), &allowed_access);
+
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
+static bool __kvmi_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva)
+{
+	if (!is_pf_of_interest(vcpu, gpa, KVMI_PAGE_ACCESS_R))
+		return true;
+
+	return kvmi_arch_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_R);
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
+		ret = __kvmi_track_preread(vcpu, gpa, gva);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+static bool __kvmi_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva)
+{
+	if (!is_pf_of_interest(vcpu, gpa, KVMI_PAGE_ACCESS_W))
+		return true;
+
+	return kvmi_arch_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_W);
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
+		ret = __kvmi_track_prewrite(vcpu, gpa, gva);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+static bool __kvmi_track_preexec(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva)
+{
+	if (!is_pf_of_interest(vcpu, gpa, KVMI_PAGE_ACCESS_X))
+		return true;
+
+	return kvmi_arch_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_X);
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
+		ret = __kvmi_track_preexec(vcpu, gpa, gva);
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
index a81e400eab17..23a088afe072 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -29,6 +29,7 @@
 			  | BIT(KVMI_EVENT_MSR) \
 			  | BIT(KVMI_EVENT_TRAP) \
 			  | BIT(KVMI_EVENT_PAUSE_VCPU) \
+			  | BIT(KVMI_EVENT_PF) \
 			  | BIT(KVMI_EVENT_XSETBV) \
 		)
 
@@ -90,6 +91,7 @@ u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
 u32 kvmi_msg_send_descriptor(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
+u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -162,5 +164,8 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 int kvmi_arch_cmd_set_page_access(struct kvm_introspection *kvmi,
 				  const struct kvmi_msg_hdr *msg,
 				  const struct kvmi_vm_set_page_access *req);
+bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			u8 access);
+bool kvmi_arch_pf_of_interest(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index fd7c9993296f..49f49f2401bc 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -1072,3 +1072,30 @@ u32 kvmi_msg_send_descriptor(struct kvm_vcpu *vcpu, u8 descriptor, u8 write)
 
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
+	if (e.padding1 || e.padding2 || e.padding3) {
+		struct kvm_introspection *kvmi = KVMI(vcpu->kvm);
+
+		kvmi_err(kvmi, "%s: non zero padding %u,%u\n",
+			__func__, e.padding1, e.padding2);
+		kvmi_sock_shutdown(kvmi);
+		return KVMI_EVENT_ACTION_CONTINUE;
+	}
+
+	return action;
+}
