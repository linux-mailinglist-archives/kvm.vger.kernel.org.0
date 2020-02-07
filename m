Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC24155D91
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgBGSRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:03 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40748 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727747AbgBGSQ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:58 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D34B6305D365;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C59B3305207D;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 71/78] KVM: introspection: add KVMI_VM_SET_PAGE_ACCESS
Date:   Fri,  7 Feb 2020 20:16:29 +0200
Message-Id: <20200207181636.1065-72-alazar@bitdefender.com>
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

This command sets the spte access bits (rwx) for an array of guest
physical addresses (through the page track subsystem).

These pages, with the requested access bits, are also kept in a radix
tree in order to filter out the #PF events which are of no interest to
the introspection tool.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  58 ++++++++
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/include/asm/kvmi_host.h              |   8 ++
 arch/x86/kvm/kvmi.c                           |  78 ++++++++++
 include/linux/kvmi_host.h                     |   3 +
 include/uapi/linux/kvmi.h                     |  23 +++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  73 ++++++++++
 virt/kvm/introspection/kvmi.c                 | 133 +++++++++++++++++-
 virt/kvm/introspection/kvmi_int.h             |  15 ++
 virt/kvm/introspection/kvmi_msg.c             |  31 ++--
 10 files changed, 414 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 4930a84200fc..14790171a170 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -860,6 +860,64 @@ to control events for any other register will fail with -KVM_EINVAL::
 * -KVM_EINVAL - padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+20. KVMI_VM_SET_PAGE_ACCESS
+---------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vm_set_page_access {
+		__u16 count;
+		__u16 padding1;
+		__u32 padding2;
+		struct kvmi_page_access_entry entries[0];
+	};
+
+where::
+
+	struct kvmi_page_access_entry {
+		__u64 gpa;
+		__u8 access;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 padding3;
+	};
+
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Sets the spte access bits (rwx) for an array of ``count`` guest physical
+addresses.
+
+The valid access bits are::
+
+	KVMI_PAGE_ACCESS_R
+	KVMI_PAGE_ACCESS_W
+	KVMI_PAGE_ACCESS_X
+
+
+The command will fail with -KVM_EINVAL if any of the specified combination
+of access bits is not supported.
+
+The command will try to apply all changes and return the first error if
+some failed. The introspection tool should handle the rollback.
+
+In order to 'forget' an address, all the access bits ('rwx') must be set.
+
+:Errors:
+
+* -KVM_EINVAL - the specified access bits combination is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EINVAL - the message size is invalid
+* -KVM_ENOMEM - not enough memory to add the page tracking structures
+
 Events
 ======
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fbd9ecc41177..685157cc36ad 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -45,6 +45,8 @@
 #define KVM_PRIVATE_MEM_SLOTS 3
 #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 
+#include <asm/kvmi_host.h>
+
 #define KVM_HALT_POLL_NS_DEFAULT 200000
 
 #define KVM_IRQCHIP_NUM_PINS  KVM_IOAPIC_NUM_PINS
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 875778d80176..5f2614ac3b4c 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_KVMI_HOST_H
 #define _ASM_X86_KVMI_HOST_H
 
+#include <asm/kvm_page_track.h>
+
 struct msr_data;
 
 #define KVMI_NUM_CR 5
@@ -39,6 +41,12 @@ struct kvm_vcpu_arch_introspection {
 struct kvm_arch_introspection {
 };
 
+#define SLOTS_SIZE BITS_TO_LONGS(KVM_MEM_SLOTS_NUM)
+
+struct kvmi_arch_mem_access {
+	unsigned long active[KVM_PAGE_TRACK_MAX][SLOTS_SIZE];
+};
+
 #ifdef CONFIG_KVM_INTROSPECTION
 
 bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg);
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index bed6e02697ca..ae6fef5a9b95 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1000,3 +1000,81 @@ bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 	return ret;
 }
+
+static const struct {
+	unsigned int allow_bit;
+	enum kvm_page_track_mode track_mode;
+} track_modes[] = {
+	{ KVMI_PAGE_ACCESS_R, KVM_PAGE_TRACK_PREREAD },
+	{ KVMI_PAGE_ACCESS_W, KVM_PAGE_TRACK_PREWRITE },
+	{ KVMI_PAGE_ACCESS_X, KVM_PAGE_TRACK_PREEXEC },
+};
+
+void kvmi_arch_update_page_tracking(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    struct kvmi_mem_access *m)
+{
+	struct kvmi_arch_mem_access *arch = &m->arch;
+	int i;
+
+	if (!slot) {
+		slot = gfn_to_memslot(kvm, m->gfn);
+		if (!slot)
+			return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(track_modes); i++) {
+		unsigned int allow_bit = track_modes[i].allow_bit;
+		enum kvm_page_track_mode mode = track_modes[i].track_mode;
+		bool slot_tracked = test_bit(slot->id, arch->active[mode]);
+
+		if (m->access & allow_bit) {
+			if (slot_tracked) {
+				kvm_slot_page_track_remove_page(kvm, slot,
+								m->gfn, mode);
+				clear_bit(slot->id, arch->active[mode]);
+			}
+		} else if (!slot_tracked) {
+			kvm_slot_page_track_add_page(kvm, slot, m->gfn, mode);
+			set_bit(slot->id, arch->active[mode]);
+		}
+	}
+}
+
+int kvmi_arch_cmd_set_page_access(struct kvm_introspection *kvmi,
+				  const struct kvmi_msg_hdr *msg,
+				  const struct kvmi_vm_set_page_access *req)
+{
+	const struct kvmi_page_access_entry *entry = req->entries;
+	const struct kvmi_page_access_entry *end = req->entries + req->count;
+	u8 unknown_bits = ~(KVMI_PAGE_ACCESS_R | KVMI_PAGE_ACCESS_W
+			    | KVMI_PAGE_ACCESS_X);
+	int ec = 0;
+
+	if (req->padding1 || req->padding2)
+		return -KVM_EINVAL;
+
+	if (msg->size < struct_size(req, entries, req->count))
+		return -KVM_EINVAL;
+
+	for (; entry < end; entry++) {
+		int r;
+
+		if ((entry->access & unknown_bits) || entry->padding1
+				|| entry->padding2 || entry->padding3)
+			r = -KVM_EINVAL;
+		else
+			r = kvmi_cmd_set_page_access(kvmi, entry->gpa,
+						      entry->access);
+		if (r) {
+			kvmi_warn(kvmi, "%s: %llx %x padding %x,%x,%x",
+				  __func__, entry->gpa, entry->access,
+				  entry->padding1, entry->padding2,
+				  entry->padding3);
+			if (!ec)
+				ec = r;
+		}
+	}
+
+	return ec;
+}
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index b738f15cd826..a9f572df1809 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -67,6 +67,9 @@ struct kvm_introspection {
 	DECLARE_BITMAP(vm_event_enable_mask, KVMI_NUM_EVENTS);
 
 	atomic_t ev_seq;
+
+	struct radix_tree_root access_tree;
+	rwlock_t access_tree_lock;
 };
 
 #ifdef CONFIG_KVM_INTROSPECTION
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 2d37d407f65d..4b8462b80553 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -41,6 +41,8 @@ enum {
 	KVMI_VCPU_GET_MTRR_TYPE = 19,
 	KVMI_VCPU_CONTROL_MSR   = 20,
 
+	KVMI_VM_SET_PAGE_ACCESS = 21,
+
 	KVMI_NUM_MESSAGES
 };
 
@@ -64,6 +66,12 @@ enum {
 	KVMI_EVENT_ACTION_CRASH    = 2,
 };
 
+enum {
+	KVMI_PAGE_ACCESS_R = 1 << 0,
+	KVMI_PAGE_ACCESS_W = 1 << 1,
+	KVMI_PAGE_ACCESS_X = 1 << 2,
+};
+
 struct kvmi_msg_hdr {
 	__u16 id;
 	__u16 size;
@@ -143,6 +151,21 @@ struct kvmi_vm_get_max_gfn_reply {
 	__u64 gfn;
 };
 
+struct kvmi_page_access_entry {
+	__u64 gpa;
+	__u8 access;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 padding3;
+};
+
+struct kvmi_vm_set_page_access {
+	__u16 count;
+	__u16 padding1;
+	__u32 padding2;
+	struct kvmi_page_access_entry entries[0];
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 7bf2b64b62a3..a0bd573ab264 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1520,6 +1520,78 @@ static void test_cmd_vcpu_control_msr(struct kvm_vm *vm)
 		msr, msr_data, ev.msr.old_value);
 }
 
+static int __cmd_set_page_access(struct kvm_vm *vm, __u16 count, __u64 *gpa,
+				 __u8 *access)
+{
+	struct kvmi_page_access_entry *entry, *end;
+	struct kvmi_vm_set_page_access *cmd;
+	struct kvmi_msg_hdr *req;
+	size_t req_size;
+	int r;
+
+	req_size = sizeof(*req) + sizeof(*cmd) + count * sizeof(*entry);
+
+	TEST_ASSERT(req_size < KVMI_MSG_SIZE + sizeof(req),
+		"Message too big\n");
+
+	req = calloc(1, req_size);
+
+	TEST_ASSERT(req, "Insufficient Memory\n");
+
+	cmd = (struct kvmi_vm_set_page_access *)(req + 1);
+	cmd->count = count;
+
+	entry = cmd->entries;
+	end = cmd->entries + count;
+	for (; entry < end; entry++) {
+		entry->gpa = *gpa++;
+		entry->access = *access++;
+	}
+
+	r = do_command(KVMI_VM_SET_PAGE_ACCESS, req, req_size, NULL, 0);
+
+	free(req);
+	return r;
+}
+
+static int cmd_set_page_access(struct kvm_vm *vm, __u16 count, __u64 *gpa,
+			       __u8 *access)
+{
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID};
+	pthread_t vcpu_thread;
+	int r;
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	r = __cmd_set_page_access(vm, count, gpa, access);
+
+	stop_vcpu_worker(vcpu_thread, &data);
+
+	return r;
+}
+
+static void set_page_access(struct kvm_vm *vm, __u64 gpa, __u8 access)
+{
+	int r;
+
+	r = cmd_set_page_access(vm, 1, &gpa, &access);
+	TEST_ASSERT(r == 0,
+		"KVMI_VM_SET_PAGE_ACCESS failed, gpa 0x%llx, access 0x%x, error %d (%s)\n",
+		gpa, access, -r, kvm_strerror(-r));
+}
+
+static void test_cmd_vm_set_page_access(struct kvm_vm *vm)
+{
+	__u8 full_access = KVMI_PAGE_ACCESS_R | KVMI_PAGE_ACCESS_W
+			| KVMI_PAGE_ACCESS_X;
+	__u8 no_access = 0;
+	__u64 gpa = 0;
+
+	set_page_access(vm, gpa, no_access);
+
+	set_page_access(vm, gpa, full_access);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -1549,6 +1621,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_mtrr_type(vm);
 	test_event_descriptor(vm);
 	test_cmd_vcpu_control_msr(vm);
+	test_cmd_vm_set_page_access(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 92d1719f4941..6e88735978ae 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -15,6 +15,11 @@ enum {
 
 static struct kmem_cache *msg_cache;
 static struct kmem_cache *job_cache;
+static struct kmem_cache *radix_cache;
+
+static const u8 full_access  =	KVMI_PAGE_ACCESS_R |
+				KVMI_PAGE_ACCESS_W |
+				KVMI_PAGE_ACCESS_X;
 
 void *kvmi_msg_alloc(void)
 {
@@ -40,6 +45,8 @@ static void kvmi_cache_destroy(void)
 	msg_cache = NULL;
 	kmem_cache_destroy(job_cache);
 	job_cache = NULL;
+	kmem_cache_destroy(radix_cache);
+	radix_cache = NULL;
 }
 
 static int kvmi_cache_create(void)
@@ -49,8 +56,11 @@ static int kvmi_cache_create(void)
 	job_cache = kmem_cache_create("kvmi_job",
 				      sizeof(struct kvmi_job),
 				      0, SLAB_ACCOUNT, NULL);
+	radix_cache = kmem_cache_create("kvmi_radix_tree",
+					sizeof(struct kvmi_mem_access),
+					0, SLAB_ACCOUNT, NULL);
 
-	if (!msg_cache || !job_cache) {
+	if (!msg_cache || !job_cache || !radix_cache) {
 		kvmi_cache_destroy();
 
 		return -1;
@@ -170,11 +180,37 @@ static void free_vcpui(struct kvm_vcpu *vcpu)
 	kvmi_make_request(vcpu, false);
 }
 
+static void kvmi_clear_mem_access(struct kvm *kvm)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+	struct radix_tree_iter iter;
+	void **slot;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+
+	radix_tree_for_each_slot(slot, &kvmi->access_tree, &iter, 0) {
+		struct kvmi_mem_access *m = *slot;
+
+		m->access = full_access;
+		kvmi_arch_update_page_tracking(kvm, NULL, m);
+
+		radix_tree_iter_delete(&kvmi->access_tree, &iter, slot);
+		kmem_cache_free(radix_cache, m);
+	}
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
 static void free_kvmi(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
 	int i;
 
+	kvmi_clear_mem_access(kvm);
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		free_vcpui(vcpu);
 
@@ -208,6 +244,10 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
 	atomic_set(&kvmi->ev_seq, 0);
 
+	INIT_RADIX_TREE(&kvmi->access_tree,
+			GFP_KERNEL & ~__GFP_DIRECT_RECLAIM);
+	rwlock_init(&kvmi->access_tree_lock);
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		int err = create_vcpui(vcpu);
 
@@ -944,3 +984,94 @@ bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
 	kvmi_put(vcpu->kvm);
 	return r;
 }
+
+static struct kvmi_mem_access *
+__kvmi_get_gfn_access(struct kvm_introspection *kvmi, const gfn_t gfn)
+{
+	return radix_tree_lookup(&kvmi->access_tree, gfn);
+}
+
+static void kvmi_update_mem_access(struct kvm *kvm, struct kvmi_mem_access *old,
+				   struct kvmi_mem_access *m)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+	u32 new_access = old->access = m->access;
+
+	kvmi_arch_update_page_tracking(kvm, NULL, old);
+
+	if (new_access == full_access) {
+		radix_tree_delete(&kvmi->access_tree, old->gfn);
+		kmem_cache_free(radix_cache, old);
+	}
+}
+
+static bool kvmi_insert_mem_access(struct kvm *kvm, struct kvmi_mem_access *m)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+
+	if (!kvm_is_visible_gfn(kvm, m->gfn))
+		return false;
+
+	if (m->access == full_access)
+		return false;
+
+	kvmi_arch_update_page_tracking(kvm, NULL, m);
+	radix_tree_insert(&kvmi->access_tree, m->gfn, m);
+
+	return true;
+}
+
+static void kvmi_set_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
+				bool *done)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+	struct kvmi_mem_access *found;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvmi->access_tree_lock);
+
+	found = __kvmi_get_gfn_access(kvmi, m->gfn);
+	if (found)
+		kvmi_update_mem_access(kvm, found, m);
+	else if (kvmi_insert_mem_access(kvm, m))
+		*done = true;
+
+	write_unlock(&kvmi->access_tree_lock);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
+static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
+{
+	struct kvmi_mem_access *m;
+	bool done = false;
+	int err = 0;
+
+	m = kmem_cache_zalloc(radix_cache, GFP_KERNEL);
+	if (!m)
+		return -KVM_ENOMEM;
+
+	m->gfn = gfn;
+	m->access = access;
+
+	if (radix_tree_preload(GFP_KERNEL))
+		err = -KVM_ENOMEM;
+	else
+		kvmi_set_mem_access(kvm, m, &done);
+
+	radix_tree_preload_end();
+
+	if (!done)
+		kmem_cache_free(radix_cache, m);
+
+	return err;
+}
+
+int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi, u64 gpa, u8 access)
+{
+	gfn_t gfn = gpa_to_gfn(gpa);
+
+	return kvmi_set_gfn_access(kvmi->kvm, gfn, access);
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 33544dd9dce5..a81e400eab17 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -42,6 +42,7 @@
 			| BIT(KVMI_VM_GET_INFO) \
 			| BIT(KVMI_VM_GET_MAX_GFN) \
 			| BIT(KVMI_VM_READ_PHYSICAL) \
+			| BIT(KVMI_VM_SET_PAGE_ACCESS) \
 			| BIT(KVMI_VM_WRITE_PHYSICAL) \
 			| BIT(KVMI_VCPU_GET_INFO) \
 			| BIT(KVMI_VCPU_PAUSE) \
@@ -59,6 +60,12 @@
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
 #define VCPUI(vcpu) ((struct kvm_vcpu_introspection *)((vcpu)->kvmi))
 
+struct kvmi_mem_access {
+	gfn_t gfn;
+	u8 access;
+	struct kvmi_arch_mem_access arch;
+};
+
 static inline bool is_vm_event_enabled(struct kvm_introspection *kvmi,
 					int event)
 {
@@ -112,6 +119,8 @@ int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, u64 size,
 int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
 				const struct kvm_regs *regs);
+int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi, u64 gpa,
+			     u8 access);
 
 /* arch */
 bool kvmi_arch_vcpu_alloc(struct kvm_vcpu *vcpu);
@@ -147,5 +156,11 @@ int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
 int kvmi_arch_cmd_vcpu_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type);
 int kvmi_arch_cmd_vcpu_control_msr(struct kvm_vcpu *vcpu,
 				   const struct kvmi_vcpu_control_msr *req);
+void kvmi_arch_update_page_tracking(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    struct kvmi_mem_access *m);
+int kvmi_arch_cmd_set_page_access(struct kvm_introspection *kvmi,
+				  const struct kvmi_msg_hdr *msg,
+				  const struct kvmi_vm_set_page_access *req);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index a5250d9b9b3d..fd7c9993296f 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -25,6 +25,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_GET_INFO]           = "KVMI_VM_GET_INFO",
 	[KVMI_VM_GET_MAX_GFN]        = "KVMI_VM_GET_MAX_GFN",
 	[KVMI_VM_READ_PHYSICAL]      = "KVMI_VM_READ_PHYSICAL",
+	[KVMI_VM_SET_PAGE_ACCESS]    = "KVMI_VM_SET_PAGE_ACCESS",
 	[KVMI_VM_WRITE_PHYSICAL]     = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_CONTROL_CR]       = "KVMI_VCPU_CONTROL_CR",
 	[KVMI_VCPU_CONTROL_EVENTS]   = "KVMI_VCPU_CONTROL_EVENTS",
@@ -352,20 +353,32 @@ static int handle_vm_get_max_gfn(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_set_page_access(struct kvm_introspection *kvmi,
+				  const struct kvmi_msg_hdr *msg,
+				  const void *req)
+{
+	int ec;
+
+	ec = kvmi_arch_cmd_set_page_access(kvmi, msg, req);
+
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread/worker.
  */
 static int(*const msg_vm[])(struct kvm_introspection *,
 			    const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_GET_VERSION]       = handle_get_version,
-	[KVMI_VM_CHECK_COMMAND]  = handle_check_command,
-	[KVMI_VM_CHECK_EVENT]    = handle_check_event,
-	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
-	[KVMI_VM_GET_INFO]       = handle_get_info,
-	[KVMI_VM_GET_MAX_GFN]    = handle_vm_get_max_gfn,
-	[KVMI_VM_READ_PHYSICAL]  = handle_read_physical,
-	[KVMI_VM_WRITE_PHYSICAL] = handle_write_physical,
-	[KVMI_VCPU_PAUSE]        = handle_pause_vcpu,
+	[KVMI_GET_VERSION]        = handle_get_version,
+	[KVMI_VM_CHECK_COMMAND]   = handle_check_command,
+	[KVMI_VM_CHECK_EVENT]     = handle_check_event,
+	[KVMI_VM_CONTROL_EVENTS]  = handle_vm_control_events,
+	[KVMI_VM_GET_INFO]        = handle_get_info,
+	[KVMI_VM_GET_MAX_GFN]     = handle_vm_get_max_gfn,
+	[KVMI_VM_READ_PHYSICAL]   = handle_read_physical,
+	[KVMI_VM_SET_PAGE_ACCESS] = handle_set_page_access,
+	[KVMI_VM_WRITE_PHYSICAL]  = handle_write_physical,
+	[KVMI_VCPU_PAUSE]         = handle_pause_vcpu,
 };
 
 static int handle_get_vcpu_info(const struct kvmi_vcpu_cmd_job *job,
